
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	92013103          	ld	sp,-1760(sp) # 80008920 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0dd050ef          	jal	ra,800058f2 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kalloc>:
    kmem.freelist = r;
    release(&kmem.lock);
}

void *kalloc(void)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	1000                	addi	s0,sp,32
    struct run *r;

    acquire(&kmem.lock);
    80000026:	00009497          	auipc	s1,0x9
    8000002a:	00a48493          	addi	s1,s1,10 # 80009030 <kmem>
    8000002e:	8526                	mv	a0,s1
    80000030:	00006097          	auipc	ra,0x6
    80000034:	2a8080e7          	jalr	680(ra) # 800062d8 <acquire>
    r = kmem.freelist;
    80000038:	6c84                	ld	s1,24(s1)
    if (r)
    8000003a:	c0b9                	beqz	s1,80000080 <kalloc+0x64>
        kmem.freelist = r->next;
    8000003c:	609c                	ld	a5,0(s1)
    8000003e:	00009517          	auipc	a0,0x9
    80000042:	ff250513          	addi	a0,a0,-14 # 80009030 <kmem>
    80000046:	ed1c                	sd	a5,24(a0)
    release(&kmem.lock);
    80000048:	00006097          	auipc	ra,0x6
    8000004c:	344080e7          	jalr	836(ra) # 8000638c <release>

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    80000050:	6605                	lui	a2,0x1
    80000052:	4595                	li	a1,5
    80000054:	8526                	mv	a0,s1
    80000056:	00000097          	auipc	ra,0x0
    8000005a:	248080e7          	jalr	584(ra) # 8000029e <memset>
    release(&rc.lock);
}

void set_ref_cnt(uint64 pa, int cnt) // 设置物理页引用计数
{
    uint64 pfn = pa / PGSIZE;
    8000005e:	00c4d793          	srli	a5,s1,0xc
    rc.cnt[pfn] = cnt;
    80000062:	0791                	addi	a5,a5,4
    80000064:	078a                	slli	a5,a5,0x2
    80000066:	00009717          	auipc	a4,0x9
    8000006a:	fea70713          	addi	a4,a4,-22 # 80009050 <rc>
    8000006e:	97ba                	add	a5,a5,a4
    80000070:	4705                	li	a4,1
    80000072:	c798                	sw	a4,8(a5)
}
    80000074:	8526                	mv	a0,s1
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6105                	addi	sp,sp,32
    8000007e:	8082                	ret
    release(&kmem.lock);
    80000080:	00009517          	auipc	a0,0x9
    80000084:	fb050513          	addi	a0,a0,-80 # 80009030 <kmem>
    80000088:	00006097          	auipc	ra,0x6
    8000008c:	304080e7          	jalr	772(ra) # 8000638c <release>
    if (r)
    80000090:	b7d5                	j	80000074 <kalloc+0x58>

0000000080000092 <acquire_rc_lock>:
{
    80000092:	1141                	addi	sp,sp,-16
    80000094:	e406                	sd	ra,8(sp)
    80000096:	e022                	sd	s0,0(sp)
    80000098:	0800                	addi	s0,sp,16
    acquire(&rc.lock);
    8000009a:	00009517          	auipc	a0,0x9
    8000009e:	fb650513          	addi	a0,a0,-74 # 80009050 <rc>
    800000a2:	00006097          	auipc	ra,0x6
    800000a6:	236080e7          	jalr	566(ra) # 800062d8 <acquire>
}
    800000aa:	60a2                	ld	ra,8(sp)
    800000ac:	6402                	ld	s0,0(sp)
    800000ae:	0141                	addi	sp,sp,16
    800000b0:	8082                	ret

00000000800000b2 <release_rc_lock>:
{
    800000b2:	1141                	addi	sp,sp,-16
    800000b4:	e406                	sd	ra,8(sp)
    800000b6:	e022                	sd	s0,0(sp)
    800000b8:	0800                	addi	s0,sp,16
    release(&rc.lock);
    800000ba:	00009517          	auipc	a0,0x9
    800000be:	f9650513          	addi	a0,a0,-106 # 80009050 <rc>
    800000c2:	00006097          	auipc	ra,0x6
    800000c6:	2ca080e7          	jalr	714(ra) # 8000638c <release>
}
    800000ca:	60a2                	ld	ra,8(sp)
    800000cc:	6402                	ld	s0,0(sp)
    800000ce:	0141                	addi	sp,sp,16
    800000d0:	8082                	ret

00000000800000d2 <set_ref_cnt>:
{
    800000d2:	1141                	addi	sp,sp,-16
    800000d4:	e422                	sd	s0,8(sp)
    800000d6:	0800                	addi	s0,sp,16
    uint64 pfn = pa / PGSIZE;
    800000d8:	8131                	srli	a0,a0,0xc
    rc.cnt[pfn] = cnt;
    800000da:	0511                	addi	a0,a0,4
    800000dc:	050a                	slli	a0,a0,0x2
    800000de:	00009797          	auipc	a5,0x9
    800000e2:	f7278793          	addi	a5,a5,-142 # 80009050 <rc>
    800000e6:	97aa                	add	a5,a5,a0
    800000e8:	c78c                	sw	a1,8(a5)
}
    800000ea:	6422                	ld	s0,8(sp)
    800000ec:	0141                	addi	sp,sp,16
    800000ee:	8082                	ret

00000000800000f0 <get_ref_cnt>:

int get_ref_cnt(uint64 pa) // 获取物理页引用计数
{
    800000f0:	1141                	addi	sp,sp,-16
    800000f2:	e422                	sd	s0,8(sp)
    800000f4:	0800                	addi	s0,sp,16
    uint64 pfn = pa / PGSIZE;
    800000f6:	8131                	srli	a0,a0,0xc
    return rc.cnt[pfn];
    800000f8:	0511                	addi	a0,a0,4
    800000fa:	050a                	slli	a0,a0,0x2
    800000fc:	00009797          	auipc	a5,0x9
    80000100:	f5478793          	addi	a5,a5,-172 # 80009050 <rc>
    80000104:	97aa                	add	a5,a5,a0
}
    80000106:	4788                	lw	a0,8(a5)
    80000108:	6422                	ld	s0,8(sp)
    8000010a:	0141                	addi	sp,sp,16
    8000010c:	8082                	ret

000000008000010e <inc_ref_cnt>:

int inc_ref_cnt(uint64 pa) // 增加物理页引用计数
{
    8000010e:	1141                	addi	sp,sp,-16
    80000110:	e422                	sd	s0,8(sp)
    80000112:	0800                	addi	s0,sp,16
    uint64 pfn = pa / PGSIZE;
    80000114:	8131                	srli	a0,a0,0xc
    rc.cnt[pfn]++;
    80000116:	0511                	addi	a0,a0,4
    80000118:	050a                	slli	a0,a0,0x2
    8000011a:	00009797          	auipc	a5,0x9
    8000011e:	f3678793          	addi	a5,a5,-202 # 80009050 <rc>
    80000122:	97aa                	add	a5,a5,a0
    80000124:	4788                	lw	a0,8(a5)
    80000126:	2505                	addiw	a0,a0,1
    80000128:	c788                	sw	a0,8(a5)
    return rc.cnt[pfn];
}
    8000012a:	2501                	sext.w	a0,a0
    8000012c:	6422                	ld	s0,8(sp)
    8000012e:	0141                	addi	sp,sp,16
    80000130:	8082                	ret

0000000080000132 <dec_ref_cnt>:

int dec_ref_cnt(uint64 pa) // 减小物理页引用计数
{
    80000132:	1141                	addi	sp,sp,-16
    80000134:	e422                	sd	s0,8(sp)
    80000136:	0800                	addi	s0,sp,16
    uint64 pfn = pa / PGSIZE;
    80000138:	8131                	srli	a0,a0,0xc
    rc.cnt[pfn]--;
    8000013a:	0511                	addi	a0,a0,4
    8000013c:	050a                	slli	a0,a0,0x2
    8000013e:	00009797          	auipc	a5,0x9
    80000142:	f1278793          	addi	a5,a5,-238 # 80009050 <rc>
    80000146:	97aa                	add	a5,a5,a0
    80000148:	4788                	lw	a0,8(a5)
    8000014a:	357d                	addiw	a0,a0,-1
    8000014c:	c788                	sw	a0,8(a5)
    return rc.cnt[pfn];
}
    8000014e:	2501                	sext.w	a0,a0
    80000150:	6422                	ld	s0,8(sp)
    80000152:	0141                	addi	sp,sp,16
    80000154:	8082                	ret

0000000080000156 <kfree>:
{
    80000156:	1101                	addi	sp,sp,-32
    80000158:	ec06                	sd	ra,24(sp)
    8000015a:	e822                	sd	s0,16(sp)
    8000015c:	e426                	sd	s1,8(sp)
    8000015e:	e04a                	sd	s2,0(sp)
    80000160:	1000                	addi	s0,sp,32
    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000162:	03451793          	slli	a5,a0,0x34
    80000166:	eb85                	bnez	a5,80000196 <kfree+0x40>
    80000168:	84aa                	mv	s1,a0
    8000016a:	00246797          	auipc	a5,0x246
    8000016e:	0d678793          	addi	a5,a5,214 # 80246240 <end>
    80000172:	02f56263          	bltu	a0,a5,80000196 <kfree+0x40>
    80000176:	47c5                	li	a5,17
    80000178:	07ee                	slli	a5,a5,0x1b
    8000017a:	00f57e63          	bgeu	a0,a5,80000196 <kfree+0x40>
    int cnt = dec_ref_cnt((uint64)pa); // 减小物理页引用计数
    8000017e:	00000097          	auipc	ra,0x0
    80000182:	fb4080e7          	jalr	-76(ra) # 80000132 <dec_ref_cnt>
    if (cnt > 0)                       // 仍有进程引用该页，直接返回
    80000186:	02a05063          	blez	a0,800001a6 <kfree+0x50>
}
    8000018a:	60e2                	ld	ra,24(sp)
    8000018c:	6442                	ld	s0,16(sp)
    8000018e:	64a2                	ld	s1,8(sp)
    80000190:	6902                	ld	s2,0(sp)
    80000192:	6105                	addi	sp,sp,32
    80000194:	8082                	ret
        panic("kfree");
    80000196:	00008517          	auipc	a0,0x8
    8000019a:	e7a50513          	addi	a0,a0,-390 # 80008010 <etext+0x10>
    8000019e:	00006097          	auipc	ra,0x6
    800001a2:	c02080e7          	jalr	-1022(ra) # 80005da0 <panic>
    memset(pa, 1, PGSIZE);
    800001a6:	6605                	lui	a2,0x1
    800001a8:	4585                	li	a1,1
    800001aa:	8526                	mv	a0,s1
    800001ac:	00000097          	auipc	ra,0x0
    800001b0:	0f2080e7          	jalr	242(ra) # 8000029e <memset>
    acquire(&kmem.lock);
    800001b4:	00009917          	auipc	s2,0x9
    800001b8:	e7c90913          	addi	s2,s2,-388 # 80009030 <kmem>
    800001bc:	854a                	mv	a0,s2
    800001be:	00006097          	auipc	ra,0x6
    800001c2:	11a080e7          	jalr	282(ra) # 800062d8 <acquire>
    r->next = kmem.freelist;
    800001c6:	01893783          	ld	a5,24(s2)
    800001ca:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    800001cc:	00993c23          	sd	s1,24(s2)
    release(&kmem.lock);
    800001d0:	854a                	mv	a0,s2
    800001d2:	00006097          	auipc	ra,0x6
    800001d6:	1ba080e7          	jalr	442(ra) # 8000638c <release>
    800001da:	bf45                	j	8000018a <kfree+0x34>

00000000800001dc <freerange>:
{
    800001dc:	7139                	addi	sp,sp,-64
    800001de:	fc06                	sd	ra,56(sp)
    800001e0:	f822                	sd	s0,48(sp)
    800001e2:	f426                	sd	s1,40(sp)
    800001e4:	f04a                	sd	s2,32(sp)
    800001e6:	ec4e                	sd	s3,24(sp)
    800001e8:	e852                	sd	s4,16(sp)
    800001ea:	e456                	sd	s5,8(sp)
    800001ec:	e05a                	sd	s6,0(sp)
    800001ee:	0080                	addi	s0,sp,64
    p = (char *)PGROUNDUP((uint64)pa_start);
    800001f0:	6785                	lui	a5,0x1
    800001f2:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800001f6:	953a                	add	a0,a0,a4
    800001f8:	777d                	lui	a4,0xfffff
    800001fa:	00e574b3          	and	s1,a0,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800001fe:	97a6                	add	a5,a5,s1
    80000200:	02f5eb63          	bltu	a1,a5,80000236 <freerange+0x5a>
    80000204:	892e                	mv	s2,a1
    rc.cnt[pfn] = cnt;
    80000206:	00009b17          	auipc	s6,0x9
    8000020a:	e4ab0b13          	addi	s6,s6,-438 # 80009050 <rc>
    8000020e:	4a85                	li	s5,1
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000210:	6a05                	lui	s4,0x1
    80000212:	6989                	lui	s3,0x2
    uint64 pfn = pa / PGSIZE;
    80000214:	00c4d793          	srli	a5,s1,0xc
    rc.cnt[pfn] = cnt;
    80000218:	0791                	addi	a5,a5,4
    8000021a:	078a                	slli	a5,a5,0x2
    8000021c:	97da                	add	a5,a5,s6
    8000021e:	0157a423          	sw	s5,8(a5)
        kfree(p);
    80000222:	8526                	mv	a0,s1
    80000224:	00000097          	auipc	ra,0x0
    80000228:	f32080e7          	jalr	-206(ra) # 80000156 <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    8000022c:	87a6                	mv	a5,s1
    8000022e:	94d2                	add	s1,s1,s4
    80000230:	97ce                	add	a5,a5,s3
    80000232:	fef971e3          	bgeu	s2,a5,80000214 <freerange+0x38>
}
    80000236:	70e2                	ld	ra,56(sp)
    80000238:	7442                	ld	s0,48(sp)
    8000023a:	74a2                	ld	s1,40(sp)
    8000023c:	7902                	ld	s2,32(sp)
    8000023e:	69e2                	ld	s3,24(sp)
    80000240:	6a42                	ld	s4,16(sp)
    80000242:	6aa2                	ld	s5,8(sp)
    80000244:	6b02                	ld	s6,0(sp)
    80000246:	6121                	addi	sp,sp,64
    80000248:	8082                	ret

000000008000024a <kinit>:
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e406                	sd	ra,8(sp)
    8000024e:	e022                	sd	s0,0(sp)
    80000250:	0800                	addi	s0,sp,16
    initlock(&kmem.lock, "kmem");
    80000252:	00008597          	auipc	a1,0x8
    80000256:	dc658593          	addi	a1,a1,-570 # 80008018 <etext+0x18>
    8000025a:	00009517          	auipc	a0,0x9
    8000025e:	dd650513          	addi	a0,a0,-554 # 80009030 <kmem>
    80000262:	00006097          	auipc	ra,0x6
    80000266:	fe6080e7          	jalr	-26(ra) # 80006248 <initlock>
    initlock(&rc.lock, "rc"); // 初始化引用计数锁
    8000026a:	00008597          	auipc	a1,0x8
    8000026e:	db658593          	addi	a1,a1,-586 # 80008020 <etext+0x20>
    80000272:	00009517          	auipc	a0,0x9
    80000276:	dde50513          	addi	a0,a0,-546 # 80009050 <rc>
    8000027a:	00006097          	auipc	ra,0x6
    8000027e:	fce080e7          	jalr	-50(ra) # 80006248 <initlock>
    freerange(end, (void *)PHYSTOP);
    80000282:	45c5                	li	a1,17
    80000284:	05ee                	slli	a1,a1,0x1b
    80000286:	00246517          	auipc	a0,0x246
    8000028a:	fba50513          	addi	a0,a0,-70 # 80246240 <end>
    8000028e:	00000097          	auipc	ra,0x0
    80000292:	f4e080e7          	jalr	-178(ra) # 800001dc <freerange>
}
    80000296:	60a2                	ld	ra,8(sp)
    80000298:	6402                	ld	s0,0(sp)
    8000029a:	0141                	addi	sp,sp,16
    8000029c:	8082                	ret

000000008000029e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000029e:	1141                	addi	sp,sp,-16
    800002a0:	e422                	sd	s0,8(sp)
    800002a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002a4:	ca19                	beqz	a2,800002ba <memset+0x1c>
    800002a6:	87aa                	mv	a5,a0
    800002a8:	1602                	slli	a2,a2,0x20
    800002aa:	9201                	srli	a2,a2,0x20
    800002ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800002b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002b4:	0785                	addi	a5,a5,1
    800002b6:	fee79de3          	bne	a5,a4,800002b0 <memset+0x12>
  }
  return dst;
}
    800002ba:	6422                	ld	s0,8(sp)
    800002bc:	0141                	addi	sp,sp,16
    800002be:	8082                	ret

00000000800002c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002c0:	1141                	addi	sp,sp,-16
    800002c2:	e422                	sd	s0,8(sp)
    800002c4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002c6:	ca05                	beqz	a2,800002f6 <memcmp+0x36>
    800002c8:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002cc:	1682                	slli	a3,a3,0x20
    800002ce:	9281                	srli	a3,a3,0x20
    800002d0:	0685                	addi	a3,a3,1
    800002d2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002d4:	00054783          	lbu	a5,0(a0)
    800002d8:	0005c703          	lbu	a4,0(a1)
    800002dc:	00e79863          	bne	a5,a4,800002ec <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002e0:	0505                	addi	a0,a0,1
    800002e2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002e4:	fed518e3          	bne	a0,a3,800002d4 <memcmp+0x14>
  }

  return 0;
    800002e8:	4501                	li	a0,0
    800002ea:	a019                	j	800002f0 <memcmp+0x30>
      return *s1 - *s2;
    800002ec:	40e7853b          	subw	a0,a5,a4
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret
  return 0;
    800002f6:	4501                	li	a0,0
    800002f8:	bfe5                	j	800002f0 <memcmp+0x30>

00000000800002fa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002fa:	1141                	addi	sp,sp,-16
    800002fc:	e422                	sd	s0,8(sp)
    800002fe:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000300:	c205                	beqz	a2,80000320 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000302:	02a5e263          	bltu	a1,a0,80000326 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000306:	1602                	slli	a2,a2,0x20
    80000308:	9201                	srli	a2,a2,0x20
    8000030a:	00c587b3          	add	a5,a1,a2
{
    8000030e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000310:	0585                	addi	a1,a1,1
    80000312:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdb8dc1>
    80000314:	fff5c683          	lbu	a3,-1(a1)
    80000318:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000031c:	fef59ae3          	bne	a1,a5,80000310 <memmove+0x16>

  return dst;
}
    80000320:	6422                	ld	s0,8(sp)
    80000322:	0141                	addi	sp,sp,16
    80000324:	8082                	ret
  if(s < d && s + n > d){
    80000326:	02061693          	slli	a3,a2,0x20
    8000032a:	9281                	srli	a3,a3,0x20
    8000032c:	00d58733          	add	a4,a1,a3
    80000330:	fce57be3          	bgeu	a0,a4,80000306 <memmove+0xc>
    d += n;
    80000334:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000336:	fff6079b          	addiw	a5,a2,-1
    8000033a:	1782                	slli	a5,a5,0x20
    8000033c:	9381                	srli	a5,a5,0x20
    8000033e:	fff7c793          	not	a5,a5
    80000342:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000344:	177d                	addi	a4,a4,-1
    80000346:	16fd                	addi	a3,a3,-1
    80000348:	00074603          	lbu	a2,0(a4)
    8000034c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000350:	fee79ae3          	bne	a5,a4,80000344 <memmove+0x4a>
    80000354:	b7f1                	j	80000320 <memmove+0x26>

0000000080000356 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000356:	1141                	addi	sp,sp,-16
    80000358:	e406                	sd	ra,8(sp)
    8000035a:	e022                	sd	s0,0(sp)
    8000035c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	f9c080e7          	jalr	-100(ra) # 800002fa <memmove>
}
    80000366:	60a2                	ld	ra,8(sp)
    80000368:	6402                	ld	s0,0(sp)
    8000036a:	0141                	addi	sp,sp,16
    8000036c:	8082                	ret

000000008000036e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000036e:	1141                	addi	sp,sp,-16
    80000370:	e422                	sd	s0,8(sp)
    80000372:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000374:	ce11                	beqz	a2,80000390 <strncmp+0x22>
    80000376:	00054783          	lbu	a5,0(a0)
    8000037a:	cf89                	beqz	a5,80000394 <strncmp+0x26>
    8000037c:	0005c703          	lbu	a4,0(a1)
    80000380:	00f71a63          	bne	a4,a5,80000394 <strncmp+0x26>
    n--, p++, q++;
    80000384:	367d                	addiw	a2,a2,-1
    80000386:	0505                	addi	a0,a0,1
    80000388:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000038a:	f675                	bnez	a2,80000376 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000038c:	4501                	li	a0,0
    8000038e:	a809                	j	800003a0 <strncmp+0x32>
    80000390:	4501                	li	a0,0
    80000392:	a039                	j	800003a0 <strncmp+0x32>
  if(n == 0)
    80000394:	ca09                	beqz	a2,800003a6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000396:	00054503          	lbu	a0,0(a0)
    8000039a:	0005c783          	lbu	a5,0(a1)
    8000039e:	9d1d                	subw	a0,a0,a5
}
    800003a0:	6422                	ld	s0,8(sp)
    800003a2:	0141                	addi	sp,sp,16
    800003a4:	8082                	ret
    return 0;
    800003a6:	4501                	li	a0,0
    800003a8:	bfe5                	j	800003a0 <strncmp+0x32>

00000000800003aa <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003aa:	1141                	addi	sp,sp,-16
    800003ac:	e422                	sd	s0,8(sp)
    800003ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003b0:	872a                	mv	a4,a0
    800003b2:	8832                	mv	a6,a2
    800003b4:	367d                	addiw	a2,a2,-1
    800003b6:	01005963          	blez	a6,800003c8 <strncpy+0x1e>
    800003ba:	0705                	addi	a4,a4,1
    800003bc:	0005c783          	lbu	a5,0(a1)
    800003c0:	fef70fa3          	sb	a5,-1(a4)
    800003c4:	0585                	addi	a1,a1,1
    800003c6:	f7f5                	bnez	a5,800003b2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800003c8:	86ba                	mv	a3,a4
    800003ca:	00c05c63          	blez	a2,800003e2 <strncpy+0x38>
    *s++ = 0;
    800003ce:	0685                	addi	a3,a3,1
    800003d0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003d4:	40d707bb          	subw	a5,a4,a3
    800003d8:	37fd                	addiw	a5,a5,-1
    800003da:	010787bb          	addw	a5,a5,a6
    800003de:	fef048e3          	bgtz	a5,800003ce <strncpy+0x24>
  return os;
}
    800003e2:	6422                	ld	s0,8(sp)
    800003e4:	0141                	addi	sp,sp,16
    800003e6:	8082                	ret

00000000800003e8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003e8:	1141                	addi	sp,sp,-16
    800003ea:	e422                	sd	s0,8(sp)
    800003ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003ee:	02c05363          	blez	a2,80000414 <safestrcpy+0x2c>
    800003f2:	fff6069b          	addiw	a3,a2,-1
    800003f6:	1682                	slli	a3,a3,0x20
    800003f8:	9281                	srli	a3,a3,0x20
    800003fa:	96ae                	add	a3,a3,a1
    800003fc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003fe:	00d58963          	beq	a1,a3,80000410 <safestrcpy+0x28>
    80000402:	0585                	addi	a1,a1,1
    80000404:	0785                	addi	a5,a5,1
    80000406:	fff5c703          	lbu	a4,-1(a1)
    8000040a:	fee78fa3          	sb	a4,-1(a5)
    8000040e:	fb65                	bnez	a4,800003fe <safestrcpy+0x16>
    ;
  *s = 0;
    80000410:	00078023          	sb	zero,0(a5)
  return os;
}
    80000414:	6422                	ld	s0,8(sp)
    80000416:	0141                	addi	sp,sp,16
    80000418:	8082                	ret

000000008000041a <strlen>:

int
strlen(const char *s)
{
    8000041a:	1141                	addi	sp,sp,-16
    8000041c:	e422                	sd	s0,8(sp)
    8000041e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000420:	00054783          	lbu	a5,0(a0)
    80000424:	cf91                	beqz	a5,80000440 <strlen+0x26>
    80000426:	0505                	addi	a0,a0,1
    80000428:	87aa                	mv	a5,a0
    8000042a:	4685                	li	a3,1
    8000042c:	9e89                	subw	a3,a3,a0
    8000042e:	00f6853b          	addw	a0,a3,a5
    80000432:	0785                	addi	a5,a5,1
    80000434:	fff7c703          	lbu	a4,-1(a5)
    80000438:	fb7d                	bnez	a4,8000042e <strlen+0x14>
    ;
  return n;
}
    8000043a:	6422                	ld	s0,8(sp)
    8000043c:	0141                	addi	sp,sp,16
    8000043e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000440:	4501                	li	a0,0
    80000442:	bfe5                	j	8000043a <strlen+0x20>

0000000080000444 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000444:	1141                	addi	sp,sp,-16
    80000446:	e406                	sd	ra,8(sp)
    80000448:	e022                	sd	s0,0(sp)
    8000044a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000044c:	00001097          	auipc	ra,0x1
    80000450:	c6c080e7          	jalr	-916(ra) # 800010b8 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000454:	00009717          	auipc	a4,0x9
    80000458:	bac70713          	addi	a4,a4,-1108 # 80009000 <started>
  if(cpuid() == 0){
    8000045c:	c139                	beqz	a0,800004a2 <main+0x5e>
    while(started == 0)
    8000045e:	431c                	lw	a5,0(a4)
    80000460:	2781                	sext.w	a5,a5
    80000462:	dff5                	beqz	a5,8000045e <main+0x1a>
      ;
    __sync_synchronize();
    80000464:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000468:	00001097          	auipc	ra,0x1
    8000046c:	c50080e7          	jalr	-944(ra) # 800010b8 <cpuid>
    80000470:	85aa                	mv	a1,a0
    80000472:	00008517          	auipc	a0,0x8
    80000476:	bce50513          	addi	a0,a0,-1074 # 80008040 <etext+0x40>
    8000047a:	00006097          	auipc	ra,0x6
    8000047e:	970080e7          	jalr	-1680(ra) # 80005dea <printf>
    kvminithart();    // turn on paging
    80000482:	00000097          	auipc	ra,0x0
    80000486:	0d8080e7          	jalr	216(ra) # 8000055a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000048a:	00002097          	auipc	ra,0x2
    8000048e:	8b0080e7          	jalr	-1872(ra) # 80001d3a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000492:	00005097          	auipc	ra,0x5
    80000496:	e3e080e7          	jalr	-450(ra) # 800052d0 <plicinithart>
  }

  scheduler();        
    8000049a:	00001097          	auipc	ra,0x1
    8000049e:	15c080e7          	jalr	348(ra) # 800015f6 <scheduler>
    consoleinit();
    800004a2:	00006097          	auipc	ra,0x6
    800004a6:	80e080e7          	jalr	-2034(ra) # 80005cb0 <consoleinit>
    printfinit();
    800004aa:	00006097          	auipc	ra,0x6
    800004ae:	b20080e7          	jalr	-1248(ra) # 80005fca <printfinit>
    printf("\n");
    800004b2:	00008517          	auipc	a0,0x8
    800004b6:	b9e50513          	addi	a0,a0,-1122 # 80008050 <etext+0x50>
    800004ba:	00006097          	auipc	ra,0x6
    800004be:	930080e7          	jalr	-1744(ra) # 80005dea <printf>
    printf("xv6 kernel is booting\n");
    800004c2:	00008517          	auipc	a0,0x8
    800004c6:	b6650513          	addi	a0,a0,-1178 # 80008028 <etext+0x28>
    800004ca:	00006097          	auipc	ra,0x6
    800004ce:	920080e7          	jalr	-1760(ra) # 80005dea <printf>
    printf("\n");
    800004d2:	00008517          	auipc	a0,0x8
    800004d6:	b7e50513          	addi	a0,a0,-1154 # 80008050 <etext+0x50>
    800004da:	00006097          	auipc	ra,0x6
    800004de:	910080e7          	jalr	-1776(ra) # 80005dea <printf>
    kinit();         // physical page allocator
    800004e2:	00000097          	auipc	ra,0x0
    800004e6:	d68080e7          	jalr	-664(ra) # 8000024a <kinit>
    kvminit();       // create kernel page table
    800004ea:	00000097          	auipc	ra,0x0
    800004ee:	322080e7          	jalr	802(ra) # 8000080c <kvminit>
    kvminithart();   // turn on paging
    800004f2:	00000097          	auipc	ra,0x0
    800004f6:	068080e7          	jalr	104(ra) # 8000055a <kvminithart>
    procinit();      // process table
    800004fa:	00001097          	auipc	ra,0x1
    800004fe:	b0e080e7          	jalr	-1266(ra) # 80001008 <procinit>
    trapinit();      // trap vectors
    80000502:	00002097          	auipc	ra,0x2
    80000506:	810080e7          	jalr	-2032(ra) # 80001d12 <trapinit>
    trapinithart();  // install kernel trap vector
    8000050a:	00002097          	auipc	ra,0x2
    8000050e:	830080e7          	jalr	-2000(ra) # 80001d3a <trapinithart>
    plicinit();      // set up interrupt controller
    80000512:	00005097          	auipc	ra,0x5
    80000516:	da8080e7          	jalr	-600(ra) # 800052ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000051a:	00005097          	auipc	ra,0x5
    8000051e:	db6080e7          	jalr	-586(ra) # 800052d0 <plicinithart>
    binit();         // buffer cache
    80000522:	00002097          	auipc	ra,0x2
    80000526:	f7a080e7          	jalr	-134(ra) # 8000249c <binit>
    iinit();         // inode table
    8000052a:	00002097          	auipc	ra,0x2
    8000052e:	608080e7          	jalr	1544(ra) # 80002b32 <iinit>
    fileinit();      // file table
    80000532:	00003097          	auipc	ra,0x3
    80000536:	5ba080e7          	jalr	1466(ra) # 80003aec <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000053a:	00005097          	auipc	ra,0x5
    8000053e:	eb6080e7          	jalr	-330(ra) # 800053f0 <virtio_disk_init>
    userinit();      // first user process
    80000542:	00001097          	auipc	ra,0x1
    80000546:	e7a080e7          	jalr	-390(ra) # 800013bc <userinit>
    __sync_synchronize();
    8000054a:	0ff0000f          	fence
    started = 1;
    8000054e:	4785                	li	a5,1
    80000550:	00009717          	auipc	a4,0x9
    80000554:	aaf72823          	sw	a5,-1360(a4) # 80009000 <started>
    80000558:	b789                	j	8000049a <main+0x56>

000000008000055a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000055a:	1141                	addi	sp,sp,-16
    8000055c:	e422                	sd	s0,8(sp)
    8000055e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000560:	00009797          	auipc	a5,0x9
    80000564:	aa87b783          	ld	a5,-1368(a5) # 80009008 <kernel_pagetable>
    80000568:	83b1                	srli	a5,a5,0xc
    8000056a:	577d                	li	a4,-1
    8000056c:	177e                	slli	a4,a4,0x3f
    8000056e:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000570:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000574:	12000073          	sfence.vma
  sfence_vma();
}
    80000578:	6422                	ld	s0,8(sp)
    8000057a:	0141                	addi	sp,sp,16
    8000057c:	8082                	ret

000000008000057e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000057e:	7139                	addi	sp,sp,-64
    80000580:	fc06                	sd	ra,56(sp)
    80000582:	f822                	sd	s0,48(sp)
    80000584:	f426                	sd	s1,40(sp)
    80000586:	f04a                	sd	s2,32(sp)
    80000588:	ec4e                	sd	s3,24(sp)
    8000058a:	e852                	sd	s4,16(sp)
    8000058c:	e456                	sd	s5,8(sp)
    8000058e:	e05a                	sd	s6,0(sp)
    80000590:	0080                	addi	s0,sp,64
    80000592:	84aa                	mv	s1,a0
    80000594:	89ae                	mv	s3,a1
    80000596:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000598:	57fd                	li	a5,-1
    8000059a:	83e9                	srli	a5,a5,0x1a
    8000059c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000059e:	4b31                	li	s6,12
  if(va >= MAXVA)
    800005a0:	04b7f263          	bgeu	a5,a1,800005e4 <walk+0x66>
    panic("walk");
    800005a4:	00008517          	auipc	a0,0x8
    800005a8:	ab450513          	addi	a0,a0,-1356 # 80008058 <etext+0x58>
    800005ac:	00005097          	auipc	ra,0x5
    800005b0:	7f4080e7          	jalr	2036(ra) # 80005da0 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005b4:	060a8663          	beqz	s5,80000620 <walk+0xa2>
    800005b8:	00000097          	auipc	ra,0x0
    800005bc:	a64080e7          	jalr	-1436(ra) # 8000001c <kalloc>
    800005c0:	84aa                	mv	s1,a0
    800005c2:	c529                	beqz	a0,8000060c <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005c4:	6605                	lui	a2,0x1
    800005c6:	4581                	li	a1,0
    800005c8:	00000097          	auipc	ra,0x0
    800005cc:	cd6080e7          	jalr	-810(ra) # 8000029e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005d0:	00c4d793          	srli	a5,s1,0xc
    800005d4:	07aa                	slli	a5,a5,0xa
    800005d6:	0017e793          	ori	a5,a5,1
    800005da:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005de:	3a5d                	addiw	s4,s4,-9 # ff7 <_entry-0x7ffff009>
    800005e0:	036a0063          	beq	s4,s6,80000600 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005e4:	0149d933          	srl	s2,s3,s4
    800005e8:	1ff97913          	andi	s2,s2,511
    800005ec:	090e                	slli	s2,s2,0x3
    800005ee:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005f0:	00093483          	ld	s1,0(s2)
    800005f4:	0014f793          	andi	a5,s1,1
    800005f8:	dfd5                	beqz	a5,800005b4 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005fa:	80a9                	srli	s1,s1,0xa
    800005fc:	04b2                	slli	s1,s1,0xc
    800005fe:	b7c5                	j	800005de <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000600:	00c9d513          	srli	a0,s3,0xc
    80000604:	1ff57513          	andi	a0,a0,511
    80000608:	050e                	slli	a0,a0,0x3
    8000060a:	9526                	add	a0,a0,s1
}
    8000060c:	70e2                	ld	ra,56(sp)
    8000060e:	7442                	ld	s0,48(sp)
    80000610:	74a2                	ld	s1,40(sp)
    80000612:	7902                	ld	s2,32(sp)
    80000614:	69e2                	ld	s3,24(sp)
    80000616:	6a42                	ld	s4,16(sp)
    80000618:	6aa2                	ld	s5,8(sp)
    8000061a:	6b02                	ld	s6,0(sp)
    8000061c:	6121                	addi	sp,sp,64
    8000061e:	8082                	ret
        return 0;
    80000620:	4501                	li	a0,0
    80000622:	b7ed                	j	8000060c <walk+0x8e>

0000000080000624 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000624:	57fd                	li	a5,-1
    80000626:	83e9                	srli	a5,a5,0x1a
    80000628:	00b7f463          	bgeu	a5,a1,80000630 <walkaddr+0xc>
    return 0;
    8000062c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000062e:	8082                	ret
{
    80000630:	1141                	addi	sp,sp,-16
    80000632:	e406                	sd	ra,8(sp)
    80000634:	e022                	sd	s0,0(sp)
    80000636:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000638:	4601                	li	a2,0
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	f44080e7          	jalr	-188(ra) # 8000057e <walk>
  if(pte == 0)
    80000642:	c105                	beqz	a0,80000662 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000644:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000646:	0117f693          	andi	a3,a5,17
    8000064a:	4745                	li	a4,17
    return 0;
    8000064c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000064e:	00e68663          	beq	a3,a4,8000065a <walkaddr+0x36>
}
    80000652:	60a2                	ld	ra,8(sp)
    80000654:	6402                	ld	s0,0(sp)
    80000656:	0141                	addi	sp,sp,16
    80000658:	8082                	ret
  pa = PTE2PA(*pte);
    8000065a:	83a9                	srli	a5,a5,0xa
    8000065c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000660:	bfcd                	j	80000652 <walkaddr+0x2e>
    return 0;
    80000662:	4501                	li	a0,0
    80000664:	b7fd                	j	80000652 <walkaddr+0x2e>

0000000080000666 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000666:	715d                	addi	sp,sp,-80
    80000668:	e486                	sd	ra,72(sp)
    8000066a:	e0a2                	sd	s0,64(sp)
    8000066c:	fc26                	sd	s1,56(sp)
    8000066e:	f84a                	sd	s2,48(sp)
    80000670:	f44e                	sd	s3,40(sp)
    80000672:	f052                	sd	s4,32(sp)
    80000674:	ec56                	sd	s5,24(sp)
    80000676:	e85a                	sd	s6,16(sp)
    80000678:	e45e                	sd	s7,8(sp)
    8000067a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000067c:	c639                	beqz	a2,800006ca <mappages+0x64>
    8000067e:	8aaa                	mv	s5,a0
    80000680:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000682:	777d                	lui	a4,0xfffff
    80000684:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000688:	fff58993          	addi	s3,a1,-1
    8000068c:	99b2                	add	s3,s3,a2
    8000068e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000692:	893e                	mv	s2,a5
    80000694:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000698:	6b85                	lui	s7,0x1
    8000069a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000069e:	4605                	li	a2,1
    800006a0:	85ca                	mv	a1,s2
    800006a2:	8556                	mv	a0,s5
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	eda080e7          	jalr	-294(ra) # 8000057e <walk>
    800006ac:	cd1d                	beqz	a0,800006ea <mappages+0x84>
    if(*pte & PTE_V)
    800006ae:	611c                	ld	a5,0(a0)
    800006b0:	8b85                	andi	a5,a5,1
    800006b2:	e785                	bnez	a5,800006da <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006b4:	80b1                	srli	s1,s1,0xc
    800006b6:	04aa                	slli	s1,s1,0xa
    800006b8:	0164e4b3          	or	s1,s1,s6
    800006bc:	0014e493          	ori	s1,s1,1
    800006c0:	e104                	sd	s1,0(a0)
    if(a == last)
    800006c2:	05390063          	beq	s2,s3,80000702 <mappages+0x9c>
    a += PGSIZE;
    800006c6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800006c8:	bfc9                	j	8000069a <mappages+0x34>
    panic("mappages: size");
    800006ca:	00008517          	auipc	a0,0x8
    800006ce:	99650513          	addi	a0,a0,-1642 # 80008060 <etext+0x60>
    800006d2:	00005097          	auipc	ra,0x5
    800006d6:	6ce080e7          	jalr	1742(ra) # 80005da0 <panic>
      panic("mappages: remap");
    800006da:	00008517          	auipc	a0,0x8
    800006de:	99650513          	addi	a0,a0,-1642 # 80008070 <etext+0x70>
    800006e2:	00005097          	auipc	ra,0x5
    800006e6:	6be080e7          	jalr	1726(ra) # 80005da0 <panic>
      return -1;
    800006ea:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006ec:	60a6                	ld	ra,72(sp)
    800006ee:	6406                	ld	s0,64(sp)
    800006f0:	74e2                	ld	s1,56(sp)
    800006f2:	7942                	ld	s2,48(sp)
    800006f4:	79a2                	ld	s3,40(sp)
    800006f6:	7a02                	ld	s4,32(sp)
    800006f8:	6ae2                	ld	s5,24(sp)
    800006fa:	6b42                	ld	s6,16(sp)
    800006fc:	6ba2                	ld	s7,8(sp)
    800006fe:	6161                	addi	sp,sp,80
    80000700:	8082                	ret
  return 0;
    80000702:	4501                	li	a0,0
    80000704:	b7e5                	j	800006ec <mappages+0x86>

0000000080000706 <kvmmap>:
{
    80000706:	1141                	addi	sp,sp,-16
    80000708:	e406                	sd	ra,8(sp)
    8000070a:	e022                	sd	s0,0(sp)
    8000070c:	0800                	addi	s0,sp,16
    8000070e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000710:	86b2                	mv	a3,a2
    80000712:	863e                	mv	a2,a5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	f52080e7          	jalr	-174(ra) # 80000666 <mappages>
    8000071c:	e509                	bnez	a0,80000726 <kvmmap+0x20>
}
    8000071e:	60a2                	ld	ra,8(sp)
    80000720:	6402                	ld	s0,0(sp)
    80000722:	0141                	addi	sp,sp,16
    80000724:	8082                	ret
    panic("kvmmap");
    80000726:	00008517          	auipc	a0,0x8
    8000072a:	95a50513          	addi	a0,a0,-1702 # 80008080 <etext+0x80>
    8000072e:	00005097          	auipc	ra,0x5
    80000732:	672080e7          	jalr	1650(ra) # 80005da0 <panic>

0000000080000736 <kvmmake>:
{
    80000736:	1101                	addi	sp,sp,-32
    80000738:	ec06                	sd	ra,24(sp)
    8000073a:	e822                	sd	s0,16(sp)
    8000073c:	e426                	sd	s1,8(sp)
    8000073e:	e04a                	sd	s2,0(sp)
    80000740:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000742:	00000097          	auipc	ra,0x0
    80000746:	8da080e7          	jalr	-1830(ra) # 8000001c <kalloc>
    8000074a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000074c:	6605                	lui	a2,0x1
    8000074e:	4581                	li	a1,0
    80000750:	00000097          	auipc	ra,0x0
    80000754:	b4e080e7          	jalr	-1202(ra) # 8000029e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000758:	4719                	li	a4,6
    8000075a:	6685                	lui	a3,0x1
    8000075c:	10000637          	lui	a2,0x10000
    80000760:	100005b7          	lui	a1,0x10000
    80000764:	8526                	mv	a0,s1
    80000766:	00000097          	auipc	ra,0x0
    8000076a:	fa0080e7          	jalr	-96(ra) # 80000706 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000076e:	4719                	li	a4,6
    80000770:	6685                	lui	a3,0x1
    80000772:	10001637          	lui	a2,0x10001
    80000776:	100015b7          	lui	a1,0x10001
    8000077a:	8526                	mv	a0,s1
    8000077c:	00000097          	auipc	ra,0x0
    80000780:	f8a080e7          	jalr	-118(ra) # 80000706 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000784:	4719                	li	a4,6
    80000786:	004006b7          	lui	a3,0x400
    8000078a:	0c000637          	lui	a2,0xc000
    8000078e:	0c0005b7          	lui	a1,0xc000
    80000792:	8526                	mv	a0,s1
    80000794:	00000097          	auipc	ra,0x0
    80000798:	f72080e7          	jalr	-142(ra) # 80000706 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000079c:	00008917          	auipc	s2,0x8
    800007a0:	86490913          	addi	s2,s2,-1948 # 80008000 <etext>
    800007a4:	4729                	li	a4,10
    800007a6:	80008697          	auipc	a3,0x80008
    800007aa:	85a68693          	addi	a3,a3,-1958 # 8000 <_entry-0x7fff8000>
    800007ae:	4605                	li	a2,1
    800007b0:	067e                	slli	a2,a2,0x1f
    800007b2:	85b2                	mv	a1,a2
    800007b4:	8526                	mv	a0,s1
    800007b6:	00000097          	auipc	ra,0x0
    800007ba:	f50080e7          	jalr	-176(ra) # 80000706 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007be:	4719                	li	a4,6
    800007c0:	46c5                	li	a3,17
    800007c2:	06ee                	slli	a3,a3,0x1b
    800007c4:	412686b3          	sub	a3,a3,s2
    800007c8:	864a                	mv	a2,s2
    800007ca:	85ca                	mv	a1,s2
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	f38080e7          	jalr	-200(ra) # 80000706 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007d6:	4729                	li	a4,10
    800007d8:	6685                	lui	a3,0x1
    800007da:	00007617          	auipc	a2,0x7
    800007de:	82660613          	addi	a2,a2,-2010 # 80007000 <_trampoline>
    800007e2:	040005b7          	lui	a1,0x4000
    800007e6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007e8:	05b2                	slli	a1,a1,0xc
    800007ea:	8526                	mv	a0,s1
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	f1a080e7          	jalr	-230(ra) # 80000706 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007f4:	8526                	mv	a0,s1
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	77c080e7          	jalr	1916(ra) # 80000f72 <proc_mapstacks>
}
    800007fe:	8526                	mv	a0,s1
    80000800:	60e2                	ld	ra,24(sp)
    80000802:	6442                	ld	s0,16(sp)
    80000804:	64a2                	ld	s1,8(sp)
    80000806:	6902                	ld	s2,0(sp)
    80000808:	6105                	addi	sp,sp,32
    8000080a:	8082                	ret

000000008000080c <kvminit>:
{
    8000080c:	1141                	addi	sp,sp,-16
    8000080e:	e406                	sd	ra,8(sp)
    80000810:	e022                	sd	s0,0(sp)
    80000812:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000814:	00000097          	auipc	ra,0x0
    80000818:	f22080e7          	jalr	-222(ra) # 80000736 <kvmmake>
    8000081c:	00008797          	auipc	a5,0x8
    80000820:	7ea7b623          	sd	a0,2028(a5) # 80009008 <kernel_pagetable>
}
    80000824:	60a2                	ld	ra,8(sp)
    80000826:	6402                	ld	s0,0(sp)
    80000828:	0141                	addi	sp,sp,16
    8000082a:	8082                	ret

000000008000082c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000082c:	715d                	addi	sp,sp,-80
    8000082e:	e486                	sd	ra,72(sp)
    80000830:	e0a2                	sd	s0,64(sp)
    80000832:	fc26                	sd	s1,56(sp)
    80000834:	f84a                	sd	s2,48(sp)
    80000836:	f44e                	sd	s3,40(sp)
    80000838:	f052                	sd	s4,32(sp)
    8000083a:	ec56                	sd	s5,24(sp)
    8000083c:	e85a                	sd	s6,16(sp)
    8000083e:	e45e                	sd	s7,8(sp)
    80000840:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000842:	03459793          	slli	a5,a1,0x34
    80000846:	e795                	bnez	a5,80000872 <uvmunmap+0x46>
    80000848:	8a2a                	mv	s4,a0
    8000084a:	892e                	mv	s2,a1
    8000084c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000084e:	0632                	slli	a2,a2,0xc
    80000850:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000854:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000856:	6b05                	lui	s6,0x1
    80000858:	0735e263          	bltu	a1,s3,800008bc <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000085c:	60a6                	ld	ra,72(sp)
    8000085e:	6406                	ld	s0,64(sp)
    80000860:	74e2                	ld	s1,56(sp)
    80000862:	7942                	ld	s2,48(sp)
    80000864:	79a2                	ld	s3,40(sp)
    80000866:	7a02                	ld	s4,32(sp)
    80000868:	6ae2                	ld	s5,24(sp)
    8000086a:	6b42                	ld	s6,16(sp)
    8000086c:	6ba2                	ld	s7,8(sp)
    8000086e:	6161                	addi	sp,sp,80
    80000870:	8082                	ret
    panic("uvmunmap: not aligned");
    80000872:	00008517          	auipc	a0,0x8
    80000876:	81650513          	addi	a0,a0,-2026 # 80008088 <etext+0x88>
    8000087a:	00005097          	auipc	ra,0x5
    8000087e:	526080e7          	jalr	1318(ra) # 80005da0 <panic>
      panic("uvmunmap: walk");
    80000882:	00008517          	auipc	a0,0x8
    80000886:	81e50513          	addi	a0,a0,-2018 # 800080a0 <etext+0xa0>
    8000088a:	00005097          	auipc	ra,0x5
    8000088e:	516080e7          	jalr	1302(ra) # 80005da0 <panic>
      panic("uvmunmap: not mapped");
    80000892:	00008517          	auipc	a0,0x8
    80000896:	81e50513          	addi	a0,a0,-2018 # 800080b0 <etext+0xb0>
    8000089a:	00005097          	auipc	ra,0x5
    8000089e:	506080e7          	jalr	1286(ra) # 80005da0 <panic>
      panic("uvmunmap: not a leaf");
    800008a2:	00008517          	auipc	a0,0x8
    800008a6:	82650513          	addi	a0,a0,-2010 # 800080c8 <etext+0xc8>
    800008aa:	00005097          	auipc	ra,0x5
    800008ae:	4f6080e7          	jalr	1270(ra) # 80005da0 <panic>
    *pte = 0;
    800008b2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008b6:	995a                	add	s2,s2,s6
    800008b8:	fb3972e3          	bgeu	s2,s3,8000085c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008bc:	4601                	li	a2,0
    800008be:	85ca                	mv	a1,s2
    800008c0:	8552                	mv	a0,s4
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	cbc080e7          	jalr	-836(ra) # 8000057e <walk>
    800008ca:	84aa                	mv	s1,a0
    800008cc:	d95d                	beqz	a0,80000882 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008ce:	6108                	ld	a0,0(a0)
    800008d0:	00157793          	andi	a5,a0,1
    800008d4:	dfdd                	beqz	a5,80000892 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008d6:	3ff57793          	andi	a5,a0,1023
    800008da:	fd7784e3          	beq	a5,s7,800008a2 <uvmunmap+0x76>
    if(do_free){
    800008de:	fc0a8ae3          	beqz	s5,800008b2 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800008e2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008e4:	0532                	slli	a0,a0,0xc
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	870080e7          	jalr	-1936(ra) # 80000156 <kfree>
    800008ee:	b7d1                	j	800008b2 <uvmunmap+0x86>

00000000800008f0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008f0:	1101                	addi	sp,sp,-32
    800008f2:	ec06                	sd	ra,24(sp)
    800008f4:	e822                	sd	s0,16(sp)
    800008f6:	e426                	sd	s1,8(sp)
    800008f8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008fa:	fffff097          	auipc	ra,0xfffff
    800008fe:	722080e7          	jalr	1826(ra) # 8000001c <kalloc>
    80000902:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000904:	c519                	beqz	a0,80000912 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000906:	6605                	lui	a2,0x1
    80000908:	4581                	li	a1,0
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	994080e7          	jalr	-1644(ra) # 8000029e <memset>
  return pagetable;
}
    80000912:	8526                	mv	a0,s1
    80000914:	60e2                	ld	ra,24(sp)
    80000916:	6442                	ld	s0,16(sp)
    80000918:	64a2                	ld	s1,8(sp)
    8000091a:	6105                	addi	sp,sp,32
    8000091c:	8082                	ret

000000008000091e <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000091e:	7179                	addi	sp,sp,-48
    80000920:	f406                	sd	ra,40(sp)
    80000922:	f022                	sd	s0,32(sp)
    80000924:	ec26                	sd	s1,24(sp)
    80000926:	e84a                	sd	s2,16(sp)
    80000928:	e44e                	sd	s3,8(sp)
    8000092a:	e052                	sd	s4,0(sp)
    8000092c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000092e:	6785                	lui	a5,0x1
    80000930:	04f67863          	bgeu	a2,a5,80000980 <uvminit+0x62>
    80000934:	8a2a                	mv	s4,a0
    80000936:	89ae                	mv	s3,a1
    80000938:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	6e2080e7          	jalr	1762(ra) # 8000001c <kalloc>
    80000942:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000944:	6605                	lui	a2,0x1
    80000946:	4581                	li	a1,0
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	956080e7          	jalr	-1706(ra) # 8000029e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000950:	4779                	li	a4,30
    80000952:	86ca                	mv	a3,s2
    80000954:	6605                	lui	a2,0x1
    80000956:	4581                	li	a1,0
    80000958:	8552                	mv	a0,s4
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	d0c080e7          	jalr	-756(ra) # 80000666 <mappages>
  memmove(mem, src, sz);
    80000962:	8626                	mv	a2,s1
    80000964:	85ce                	mv	a1,s3
    80000966:	854a                	mv	a0,s2
    80000968:	00000097          	auipc	ra,0x0
    8000096c:	992080e7          	jalr	-1646(ra) # 800002fa <memmove>
}
    80000970:	70a2                	ld	ra,40(sp)
    80000972:	7402                	ld	s0,32(sp)
    80000974:	64e2                	ld	s1,24(sp)
    80000976:	6942                	ld	s2,16(sp)
    80000978:	69a2                	ld	s3,8(sp)
    8000097a:	6a02                	ld	s4,0(sp)
    8000097c:	6145                	addi	sp,sp,48
    8000097e:	8082                	ret
    panic("inituvm: more than a page");
    80000980:	00007517          	auipc	a0,0x7
    80000984:	76050513          	addi	a0,a0,1888 # 800080e0 <etext+0xe0>
    80000988:	00005097          	auipc	ra,0x5
    8000098c:	418080e7          	jalr	1048(ra) # 80005da0 <panic>

0000000080000990 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000990:	1101                	addi	sp,sp,-32
    80000992:	ec06                	sd	ra,24(sp)
    80000994:	e822                	sd	s0,16(sp)
    80000996:	e426                	sd	s1,8(sp)
    80000998:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000099a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000099c:	00b67d63          	bgeu	a2,a1,800009b6 <uvmdealloc+0x26>
    800009a0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009a2:	6785                	lui	a5,0x1
    800009a4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009a6:	00f60733          	add	a4,a2,a5
    800009aa:	76fd                	lui	a3,0xfffff
    800009ac:	8f75                	and	a4,a4,a3
    800009ae:	97ae                	add	a5,a5,a1
    800009b0:	8ff5                	and	a5,a5,a3
    800009b2:	00f76863          	bltu	a4,a5,800009c2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009b6:	8526                	mv	a0,s1
    800009b8:	60e2                	ld	ra,24(sp)
    800009ba:	6442                	ld	s0,16(sp)
    800009bc:	64a2                	ld	s1,8(sp)
    800009be:	6105                	addi	sp,sp,32
    800009c0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009c2:	8f99                	sub	a5,a5,a4
    800009c4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009c6:	4685                	li	a3,1
    800009c8:	0007861b          	sext.w	a2,a5
    800009cc:	85ba                	mv	a1,a4
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	e5e080e7          	jalr	-418(ra) # 8000082c <uvmunmap>
    800009d6:	b7c5                	j	800009b6 <uvmdealloc+0x26>

00000000800009d8 <uvmalloc>:
  if(newsz < oldsz)
    800009d8:	0ab66163          	bltu	a2,a1,80000a7a <uvmalloc+0xa2>
{
    800009dc:	7139                	addi	sp,sp,-64
    800009de:	fc06                	sd	ra,56(sp)
    800009e0:	f822                	sd	s0,48(sp)
    800009e2:	f426                	sd	s1,40(sp)
    800009e4:	f04a                	sd	s2,32(sp)
    800009e6:	ec4e                	sd	s3,24(sp)
    800009e8:	e852                	sd	s4,16(sp)
    800009ea:	e456                	sd	s5,8(sp)
    800009ec:	0080                	addi	s0,sp,64
    800009ee:	8aaa                	mv	s5,a0
    800009f0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009f2:	6785                	lui	a5,0x1
    800009f4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f6:	95be                	add	a1,a1,a5
    800009f8:	77fd                	lui	a5,0xfffff
    800009fa:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009fe:	08c9f063          	bgeu	s3,a2,80000a7e <uvmalloc+0xa6>
    80000a02:	894e                	mv	s2,s3
    mem = kalloc();
    80000a04:	fffff097          	auipc	ra,0xfffff
    80000a08:	618080e7          	jalr	1560(ra) # 8000001c <kalloc>
    80000a0c:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a0e:	c51d                	beqz	a0,80000a3c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a10:	6605                	lui	a2,0x1
    80000a12:	4581                	li	a1,0
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	88a080e7          	jalr	-1910(ra) # 8000029e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a1c:	4779                	li	a4,30
    80000a1e:	86a6                	mv	a3,s1
    80000a20:	6605                	lui	a2,0x1
    80000a22:	85ca                	mv	a1,s2
    80000a24:	8556                	mv	a0,s5
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	c40080e7          	jalr	-960(ra) # 80000666 <mappages>
    80000a2e:	e905                	bnez	a0,80000a5e <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a30:	6785                	lui	a5,0x1
    80000a32:	993e                	add	s2,s2,a5
    80000a34:	fd4968e3          	bltu	s2,s4,80000a04 <uvmalloc+0x2c>
  return newsz;
    80000a38:	8552                	mv	a0,s4
    80000a3a:	a809                	j	80000a4c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a3c:	864e                	mv	a2,s3
    80000a3e:	85ca                	mv	a1,s2
    80000a40:	8556                	mv	a0,s5
    80000a42:	00000097          	auipc	ra,0x0
    80000a46:	f4e080e7          	jalr	-178(ra) # 80000990 <uvmdealloc>
      return 0;
    80000a4a:	4501                	li	a0,0
}
    80000a4c:	70e2                	ld	ra,56(sp)
    80000a4e:	7442                	ld	s0,48(sp)
    80000a50:	74a2                	ld	s1,40(sp)
    80000a52:	7902                	ld	s2,32(sp)
    80000a54:	69e2                	ld	s3,24(sp)
    80000a56:	6a42                	ld	s4,16(sp)
    80000a58:	6aa2                	ld	s5,8(sp)
    80000a5a:	6121                	addi	sp,sp,64
    80000a5c:	8082                	ret
      kfree(mem);
    80000a5e:	8526                	mv	a0,s1
    80000a60:	fffff097          	auipc	ra,0xfffff
    80000a64:	6f6080e7          	jalr	1782(ra) # 80000156 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a68:	864e                	mv	a2,s3
    80000a6a:	85ca                	mv	a1,s2
    80000a6c:	8556                	mv	a0,s5
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	f22080e7          	jalr	-222(ra) # 80000990 <uvmdealloc>
      return 0;
    80000a76:	4501                	li	a0,0
    80000a78:	bfd1                	j	80000a4c <uvmalloc+0x74>
    return oldsz;
    80000a7a:	852e                	mv	a0,a1
}
    80000a7c:	8082                	ret
  return newsz;
    80000a7e:	8532                	mv	a0,a2
    80000a80:	b7f1                	j	80000a4c <uvmalloc+0x74>

0000000080000a82 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a82:	7179                	addi	sp,sp,-48
    80000a84:	f406                	sd	ra,40(sp)
    80000a86:	f022                	sd	s0,32(sp)
    80000a88:	ec26                	sd	s1,24(sp)
    80000a8a:	e84a                	sd	s2,16(sp)
    80000a8c:	e44e                	sd	s3,8(sp)
    80000a8e:	e052                	sd	s4,0(sp)
    80000a90:	1800                	addi	s0,sp,48
    80000a92:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a94:	84aa                	mv	s1,a0
    80000a96:	6905                	lui	s2,0x1
    80000a98:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a9a:	4985                	li	s3,1
    80000a9c:	a829                	j	80000ab6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a9e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000aa0:	00c79513          	slli	a0,a5,0xc
    80000aa4:	00000097          	auipc	ra,0x0
    80000aa8:	fde080e7          	jalr	-34(ra) # 80000a82 <freewalk>
      pagetable[i] = 0;
    80000aac:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000ab0:	04a1                	addi	s1,s1,8
    80000ab2:	03248163          	beq	s1,s2,80000ad4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000ab6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000ab8:	00f7f713          	andi	a4,a5,15
    80000abc:	ff3701e3          	beq	a4,s3,80000a9e <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000ac0:	8b85                	andi	a5,a5,1
    80000ac2:	d7fd                	beqz	a5,80000ab0 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000ac4:	00007517          	auipc	a0,0x7
    80000ac8:	63c50513          	addi	a0,a0,1596 # 80008100 <etext+0x100>
    80000acc:	00005097          	auipc	ra,0x5
    80000ad0:	2d4080e7          	jalr	724(ra) # 80005da0 <panic>
    }
  }
  kfree((void*)pagetable);
    80000ad4:	8552                	mv	a0,s4
    80000ad6:	fffff097          	auipc	ra,0xfffff
    80000ada:	680080e7          	jalr	1664(ra) # 80000156 <kfree>
}
    80000ade:	70a2                	ld	ra,40(sp)
    80000ae0:	7402                	ld	s0,32(sp)
    80000ae2:	64e2                	ld	s1,24(sp)
    80000ae4:	6942                	ld	s2,16(sp)
    80000ae6:	69a2                	ld	s3,8(sp)
    80000ae8:	6a02                	ld	s4,0(sp)
    80000aea:	6145                	addi	sp,sp,48
    80000aec:	8082                	ret

0000000080000aee <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000aee:	1101                	addi	sp,sp,-32
    80000af0:	ec06                	sd	ra,24(sp)
    80000af2:	e822                	sd	s0,16(sp)
    80000af4:	e426                	sd	s1,8(sp)
    80000af6:	1000                	addi	s0,sp,32
    80000af8:	84aa                	mv	s1,a0
  if(sz > 0)
    80000afa:	e999                	bnez	a1,80000b10 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000afc:	8526                	mv	a0,s1
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	f84080e7          	jalr	-124(ra) # 80000a82 <freewalk>
}
    80000b06:	60e2                	ld	ra,24(sp)
    80000b08:	6442                	ld	s0,16(sp)
    80000b0a:	64a2                	ld	s1,8(sp)
    80000b0c:	6105                	addi	sp,sp,32
    80000b0e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b10:	6785                	lui	a5,0x1
    80000b12:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b14:	95be                	add	a1,a1,a5
    80000b16:	4685                	li	a3,1
    80000b18:	00c5d613          	srli	a2,a1,0xc
    80000b1c:	4581                	li	a1,0
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	d0e080e7          	jalr	-754(ra) # 8000082c <uvmunmap>
    80000b26:	bfd9                	j	80000afc <uvmfree+0xe>

0000000080000b28 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b28:	1141                	addi	sp,sp,-16
    80000b2a:	e406                	sd	ra,8(sp)
    80000b2c:	e022                	sd	s0,0(sp)
    80000b2e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b30:	4601                	li	a2,0
    80000b32:	00000097          	auipc	ra,0x0
    80000b36:	a4c080e7          	jalr	-1460(ra) # 8000057e <walk>
  if(pte == 0)
    80000b3a:	c901                	beqz	a0,80000b4a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b3c:	611c                	ld	a5,0(a0)
    80000b3e:	9bbd                	andi	a5,a5,-17
    80000b40:	e11c                	sd	a5,0(a0)
}
    80000b42:	60a2                	ld	ra,8(sp)
    80000b44:	6402                	ld	s0,0(sp)
    80000b46:	0141                	addi	sp,sp,16
    80000b48:	8082                	ret
    panic("uvmclear");
    80000b4a:	00007517          	auipc	a0,0x7
    80000b4e:	5c650513          	addi	a0,a0,1478 # 80008110 <etext+0x110>
    80000b52:	00005097          	auipc	ra,0x5
    80000b56:	24e080e7          	jalr	590(ra) # 80005da0 <panic>

0000000080000b5a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b5a:	caa5                	beqz	a3,80000bca <copyin+0x70>
{
    80000b5c:	715d                	addi	sp,sp,-80
    80000b5e:	e486                	sd	ra,72(sp)
    80000b60:	e0a2                	sd	s0,64(sp)
    80000b62:	fc26                	sd	s1,56(sp)
    80000b64:	f84a                	sd	s2,48(sp)
    80000b66:	f44e                	sd	s3,40(sp)
    80000b68:	f052                	sd	s4,32(sp)
    80000b6a:	ec56                	sd	s5,24(sp)
    80000b6c:	e85a                	sd	s6,16(sp)
    80000b6e:	e45e                	sd	s7,8(sp)
    80000b70:	e062                	sd	s8,0(sp)
    80000b72:	0880                	addi	s0,sp,80
    80000b74:	8b2a                	mv	s6,a0
    80000b76:	8a2e                	mv	s4,a1
    80000b78:	8c32                	mv	s8,a2
    80000b7a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b7c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b7e:	6a85                	lui	s5,0x1
    80000b80:	a01d                	j	80000ba6 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b82:	018505b3          	add	a1,a0,s8
    80000b86:	0004861b          	sext.w	a2,s1
    80000b8a:	412585b3          	sub	a1,a1,s2
    80000b8e:	8552                	mv	a0,s4
    80000b90:	fffff097          	auipc	ra,0xfffff
    80000b94:	76a080e7          	jalr	1898(ra) # 800002fa <memmove>

    len -= n;
    80000b98:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b9c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b9e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ba2:	02098263          	beqz	s3,80000bc6 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000ba6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000baa:	85ca                	mv	a1,s2
    80000bac:	855a                	mv	a0,s6
    80000bae:	00000097          	auipc	ra,0x0
    80000bb2:	a76080e7          	jalr	-1418(ra) # 80000624 <walkaddr>
    if(pa0 == 0)
    80000bb6:	cd01                	beqz	a0,80000bce <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bb8:	418904b3          	sub	s1,s2,s8
    80000bbc:	94d6                	add	s1,s1,s5
    80000bbe:	fc99f2e3          	bgeu	s3,s1,80000b82 <copyin+0x28>
    80000bc2:	84ce                	mv	s1,s3
    80000bc4:	bf7d                	j	80000b82 <copyin+0x28>
  }
  return 0;
    80000bc6:	4501                	li	a0,0
    80000bc8:	a021                	j	80000bd0 <copyin+0x76>
    80000bca:	4501                	li	a0,0
}
    80000bcc:	8082                	ret
      return -1;
    80000bce:	557d                	li	a0,-1
}
    80000bd0:	60a6                	ld	ra,72(sp)
    80000bd2:	6406                	ld	s0,64(sp)
    80000bd4:	74e2                	ld	s1,56(sp)
    80000bd6:	7942                	ld	s2,48(sp)
    80000bd8:	79a2                	ld	s3,40(sp)
    80000bda:	7a02                	ld	s4,32(sp)
    80000bdc:	6ae2                	ld	s5,24(sp)
    80000bde:	6b42                	ld	s6,16(sp)
    80000be0:	6ba2                	ld	s7,8(sp)
    80000be2:	6c02                	ld	s8,0(sp)
    80000be4:	6161                	addi	sp,sp,80
    80000be6:	8082                	ret

0000000080000be8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000be8:	c2dd                	beqz	a3,80000c8e <copyinstr+0xa6>
{
    80000bea:	715d                	addi	sp,sp,-80
    80000bec:	e486                	sd	ra,72(sp)
    80000bee:	e0a2                	sd	s0,64(sp)
    80000bf0:	fc26                	sd	s1,56(sp)
    80000bf2:	f84a                	sd	s2,48(sp)
    80000bf4:	f44e                	sd	s3,40(sp)
    80000bf6:	f052                	sd	s4,32(sp)
    80000bf8:	ec56                	sd	s5,24(sp)
    80000bfa:	e85a                	sd	s6,16(sp)
    80000bfc:	e45e                	sd	s7,8(sp)
    80000bfe:	0880                	addi	s0,sp,80
    80000c00:	8a2a                	mv	s4,a0
    80000c02:	8b2e                	mv	s6,a1
    80000c04:	8bb2                	mv	s7,a2
    80000c06:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c08:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c0a:	6985                	lui	s3,0x1
    80000c0c:	a02d                	j	80000c36 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c0e:	00078023          	sb	zero,0(a5)
    80000c12:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c14:	37fd                	addiw	a5,a5,-1
    80000c16:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c1a:	60a6                	ld	ra,72(sp)
    80000c1c:	6406                	ld	s0,64(sp)
    80000c1e:	74e2                	ld	s1,56(sp)
    80000c20:	7942                	ld	s2,48(sp)
    80000c22:	79a2                	ld	s3,40(sp)
    80000c24:	7a02                	ld	s4,32(sp)
    80000c26:	6ae2                	ld	s5,24(sp)
    80000c28:	6b42                	ld	s6,16(sp)
    80000c2a:	6ba2                	ld	s7,8(sp)
    80000c2c:	6161                	addi	sp,sp,80
    80000c2e:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c30:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c34:	c8a9                	beqz	s1,80000c86 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c36:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c3a:	85ca                	mv	a1,s2
    80000c3c:	8552                	mv	a0,s4
    80000c3e:	00000097          	auipc	ra,0x0
    80000c42:	9e6080e7          	jalr	-1562(ra) # 80000624 <walkaddr>
    if(pa0 == 0)
    80000c46:	c131                	beqz	a0,80000c8a <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c48:	417906b3          	sub	a3,s2,s7
    80000c4c:	96ce                	add	a3,a3,s3
    80000c4e:	00d4f363          	bgeu	s1,a3,80000c54 <copyinstr+0x6c>
    80000c52:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c54:	955e                	add	a0,a0,s7
    80000c56:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c5a:	daf9                	beqz	a3,80000c30 <copyinstr+0x48>
    80000c5c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c5e:	41650633          	sub	a2,a0,s6
    80000c62:	fff48593          	addi	a1,s1,-1
    80000c66:	95da                	add	a1,a1,s6
    while(n > 0){
    80000c68:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000c6a:	00f60733          	add	a4,a2,a5
    80000c6e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fdb8dc0>
    80000c72:	df51                	beqz	a4,80000c0e <copyinstr+0x26>
        *dst = *p;
    80000c74:	00e78023          	sb	a4,0(a5)
      --max;
    80000c78:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000c7c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c7e:	fed796e3          	bne	a5,a3,80000c6a <copyinstr+0x82>
      dst++;
    80000c82:	8b3e                	mv	s6,a5
    80000c84:	b775                	j	80000c30 <copyinstr+0x48>
    80000c86:	4781                	li	a5,0
    80000c88:	b771                	j	80000c14 <copyinstr+0x2c>
      return -1;
    80000c8a:	557d                	li	a0,-1
    80000c8c:	b779                	j	80000c1a <copyinstr+0x32>
  int got_null = 0;
    80000c8e:	4781                	li	a5,0
  if(got_null){
    80000c90:	37fd                	addiw	a5,a5,-1
    80000c92:	0007851b          	sext.w	a0,a5
}
    80000c96:	8082                	ret

0000000080000c98 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.

int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000c98:	7139                	addi	sp,sp,-64
    80000c9a:	fc06                	sd	ra,56(sp)
    80000c9c:	f822                	sd	s0,48(sp)
    80000c9e:	f426                	sd	s1,40(sp)
    80000ca0:	f04a                	sd	s2,32(sp)
    80000ca2:	ec4e                	sd	s3,24(sp)
    80000ca4:	e852                	sd	s4,16(sp)
    80000ca6:	e456                	sd	s5,8(sp)
    80000ca8:	0080                	addi	s0,sp,64
    80000caa:	8aaa                	mv	s5,a0
    80000cac:	8a2e                	mv	s4,a1
    80000cae:	89b2                	mv	s3,a2
    pte_t *pte;
    uint64 pa, i;
    uint flags;

    acquire_rc_lock(); // 请求引用计数锁
    80000cb0:	fffff097          	auipc	ra,0xfffff
    80000cb4:	3e2080e7          	jalr	994(ra) # 80000092 <acquire_rc_lock>
    for (i = 0; i < sz; i += PGSIZE)
    80000cb8:	08098f63          	beqz	s3,80000d56 <uvmcopy+0xbe>
    80000cbc:	4481                	li	s1,0
    80000cbe:	a0b1                	j	80000d0a <uvmcopy+0x72>
    {
        if ((pte = walk(old, i, 0)) == 0)
            panic("uvmcopy: pte should exist");
    80000cc0:	00007517          	auipc	a0,0x7
    80000cc4:	46050513          	addi	a0,a0,1120 # 80008120 <etext+0x120>
    80000cc8:	00005097          	auipc	ra,0x5
    80000ccc:	0d8080e7          	jalr	216(ra) # 80005da0 <panic>
        if ((*pte & PTE_V) == 0)
            panic("uvmcopy: page not present");
    80000cd0:	00007517          	auipc	a0,0x7
    80000cd4:	47050513          	addi	a0,a0,1136 # 80008140 <etext+0x140>
    80000cd8:	00005097          	auipc	ra,0x5
    80000cdc:	0c8080e7          	jalr	200(ra) # 80005da0 <panic>
        if (*pte & PTE_W) // 若该页可写，将cow位置位并将w位清零
        {
            *pte |= PTE_COW;
            *pte &= ~PTE_W;
        }
        flags = PTE_FLAGS(*pte);
    80000ce0:	6118                	ld	a4,0(a0)
        if (mappages(new, i, PGSIZE, pa, flags) != 0) // 子进程映射到相同的物理页上
    80000ce2:	3ff77713          	andi	a4,a4,1023
    80000ce6:	86ca                	mv	a3,s2
    80000ce8:	6605                	lui	a2,0x1
    80000cea:	85a6                	mv	a1,s1
    80000cec:	8552                	mv	a0,s4
    80000cee:	00000097          	auipc	ra,0x0
    80000cf2:	978080e7          	jalr	-1672(ra) # 80000666 <mappages>
    80000cf6:	e129                	bnez	a0,80000d38 <uvmcopy+0xa0>
        {
            goto err;
        }
        inc_ref_cnt(pa); // 增加物理页引用计数
    80000cf8:	854a                	mv	a0,s2
    80000cfa:	fffff097          	auipc	ra,0xfffff
    80000cfe:	414080e7          	jalr	1044(ra) # 8000010e <inc_ref_cnt>
    for (i = 0; i < sz; i += PGSIZE)
    80000d02:	6785                	lui	a5,0x1
    80000d04:	94be                	add	s1,s1,a5
    80000d06:	0534f863          	bgeu	s1,s3,80000d56 <uvmcopy+0xbe>
        if ((pte = walk(old, i, 0)) == 0)
    80000d0a:	4601                	li	a2,0
    80000d0c:	85a6                	mv	a1,s1
    80000d0e:	8556                	mv	a0,s5
    80000d10:	00000097          	auipc	ra,0x0
    80000d14:	86e080e7          	jalr	-1938(ra) # 8000057e <walk>
    80000d18:	d545                	beqz	a0,80000cc0 <uvmcopy+0x28>
        if ((*pte & PTE_V) == 0)
    80000d1a:	611c                	ld	a5,0(a0)
    80000d1c:	0017f713          	andi	a4,a5,1
    80000d20:	db45                	beqz	a4,80000cd0 <uvmcopy+0x38>
        pa = PTE2PA(*pte);
    80000d22:	00a7d913          	srli	s2,a5,0xa
    80000d26:	0932                	slli	s2,s2,0xc
        if (*pte & PTE_W) // 若该页可写，将cow位置位并将w位清零
    80000d28:	0047f713          	andi	a4,a5,4
    80000d2c:	db55                	beqz	a4,80000ce0 <uvmcopy+0x48>
            *pte &= ~PTE_W;
    80000d2e:	9bed                	andi	a5,a5,-5
    80000d30:	1007e793          	ori	a5,a5,256
    80000d34:	e11c                	sd	a5,0(a0)
    80000d36:	b76d                	j	80000ce0 <uvmcopy+0x48>
    }
    release_rc_lock(); // 释放引用计数锁
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1); // 取消映射并调用kree函数
    80000d38:	4685                	li	a3,1
    80000d3a:	00c4d613          	srli	a2,s1,0xc
    80000d3e:	4581                	li	a1,0
    80000d40:	8552                	mv	a0,s4
    80000d42:	00000097          	auipc	ra,0x0
    80000d46:	aea080e7          	jalr	-1302(ra) # 8000082c <uvmunmap>
    release_rc_lock();               // 释放引用计数锁
    80000d4a:	fffff097          	auipc	ra,0xfffff
    80000d4e:	368080e7          	jalr	872(ra) # 800000b2 <release_rc_lock>
    return -1;
    80000d52:	557d                	li	a0,-1
    80000d54:	a031                	j	80000d60 <uvmcopy+0xc8>
    release_rc_lock(); // 释放引用计数锁
    80000d56:	fffff097          	auipc	ra,0xfffff
    80000d5a:	35c080e7          	jalr	860(ra) # 800000b2 <release_rc_lock>
    return 0;
    80000d5e:	4501                	li	a0,0
}
    80000d60:	70e2                	ld	ra,56(sp)
    80000d62:	7442                	ld	s0,48(sp)
    80000d64:	74a2                	ld	s1,40(sp)
    80000d66:	7902                	ld	s2,32(sp)
    80000d68:	69e2                	ld	s3,24(sp)
    80000d6a:	6a42                	ld	s4,16(sp)
    80000d6c:	6aa2                	ld	s5,8(sp)
    80000d6e:	6121                	addi	sp,sp,64
    80000d70:	8082                	ret

0000000080000d72 <address_translation_wiht_cow_page>:
    pte_t *pte;
    uint64 pa;
    uint flags;
    void *mem;

    if (va >= MAXVA) // 非法访问高位地址
    80000d72:	57fd                	li	a5,-1
    80000d74:	83e9                	srli	a5,a5,0x1a
    80000d76:	14a7ec63          	bltu	a5,a0,80000ece <address_translation_wiht_cow_page+0x15c>
{
    80000d7a:	7139                	addi	sp,sp,-64
    80000d7c:	fc06                	sd	ra,56(sp)
    80000d7e:	f822                	sd	s0,48(sp)
    80000d80:	f426                	sd	s1,40(sp)
    80000d82:	f04a                	sd	s2,32(sp)
    80000d84:	ec4e                	sd	s3,24(sp)
    80000d86:	e852                	sd	s4,16(sp)
    80000d88:	e456                	sd	s5,8(sp)
    80000d8a:	0080                	addi	s0,sp,64
    80000d8c:	8a2e                	mv	s4,a1
    {
        return -1;
    }
    va = PGROUNDDOWN(va); // 将页偏移地址设为0
    80000d8e:	77fd                	lui	a5,0xfffff
    80000d90:	00f579b3          	and	s3,a0,a5
    if ((pte = walk(pagetable, va, 0)) == 0)
    80000d94:	4601                	li	a2,0
    80000d96:	85ce                	mv	a1,s3
    80000d98:	8552                	mv	a0,s4
    80000d9a:	fffff097          	auipc	ra,0xfffff
    80000d9e:	7e4080e7          	jalr	2020(ra) # 8000057e <walk>
    80000da2:	892a                	mv	s2,a0
    80000da4:	c52d                	beqz	a0,80000e0e <address_translation_wiht_cow_page+0x9c>
        // panic("uvmcopy: pte should exist");
        printf("address_translation_wiht_cow_page: pte should exist\n");
        return -1;
    }

    if ((*pte & PTE_V) == 0)
    80000da6:	611c                	ld	a5,0(a0)
    80000da8:	0017f713          	andi	a4,a5,1
    80000dac:	cb3d                	beqz	a4,80000e22 <address_translation_wiht_cow_page+0xb0>
        //   panic("uvmcopy: page not present");
        printf("address_translation_wiht_cow_page: page not present\n");
        return -1;
    }

    if (*pte & PTE_W) // 不是cow页
    80000dae:	0047f713          	andi	a4,a5,4
    {
        return 0;
    80000db2:	4501                	li	a0,0
    if (*pte & PTE_W) // 不是cow页
    80000db4:	e721                	bnez	a4,80000dfc <address_translation_wiht_cow_page+0x8a>
    }

    if (!(*pte & PTE_COW))
    80000db6:	1007f713          	andi	a4,a5,256
    80000dba:	cf35                	beqz	a4,80000e36 <address_translation_wiht_cow_page+0xc4>
    {
        printf("cow bit isn't set\n");
        return -1;
    }
    pa = PTE2PA(*pte);
    80000dbc:	83a9                	srli	a5,a5,0xa
    80000dbe:	00c79493          	slli	s1,a5,0xc
    if (pa > PHYSTOP)
    80000dc2:	47c5                	li	a5,17
    80000dc4:	07ee                	slli	a5,a5,0x1b
    80000dc6:	0897e263          	bltu	a5,s1,80000e4a <address_translation_wiht_cow_page+0xd8>
    {
        printf("phy addr error\n");
        return -1;
    }
    
    acquire_rc_lock();             // 请求引用计数锁
    80000dca:	fffff097          	auipc	ra,0xfffff
    80000dce:	2c8080e7          	jalr	712(ra) # 80000092 <acquire_rc_lock>
    int ref_cnt = get_ref_cnt(pa); // 获取当前物理页引用计数
    80000dd2:	8526                	mv	a0,s1
    80000dd4:	fffff097          	auipc	ra,0xfffff
    80000dd8:	31c080e7          	jalr	796(ra) # 800000f0 <get_ref_cnt>
    if (ref_cnt == 1)              // 只有一个进程引用，直接修改权限
    80000ddc:	4785                	li	a5,1
    80000dde:	08f51063          	bne	a0,a5,80000e5e <address_translation_wiht_cow_page+0xec>
    {
        *pte |= PTE_W;
        *pte &= ~PTE_COW;
    80000de2:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    80000de6:	eff7f793          	andi	a5,a5,-257
    80000dea:	0047e793          	ori	a5,a5,4
    80000dee:	00f93023          	sd	a5,0(s2)
        {
            release_rc_lock();
            return -1;
        }
    }
    release_rc_lock();
    80000df2:	fffff097          	auipc	ra,0xfffff
    80000df6:	2c0080e7          	jalr	704(ra) # 800000b2 <release_rc_lock>
    return 0;
    80000dfa:	4501                	li	a0,0
}
    80000dfc:	70e2                	ld	ra,56(sp)
    80000dfe:	7442                	ld	s0,48(sp)
    80000e00:	74a2                	ld	s1,40(sp)
    80000e02:	7902                	ld	s2,32(sp)
    80000e04:	69e2                	ld	s3,24(sp)
    80000e06:	6a42                	ld	s4,16(sp)
    80000e08:	6aa2                	ld	s5,8(sp)
    80000e0a:	6121                	addi	sp,sp,64
    80000e0c:	8082                	ret
        printf("address_translation_wiht_cow_page: pte should exist\n");
    80000e0e:	00007517          	auipc	a0,0x7
    80000e12:	35250513          	addi	a0,a0,850 # 80008160 <etext+0x160>
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	fd4080e7          	jalr	-44(ra) # 80005dea <printf>
        return -1;
    80000e1e:	557d                	li	a0,-1
    80000e20:	bff1                	j	80000dfc <address_translation_wiht_cow_page+0x8a>
        printf("address_translation_wiht_cow_page: page not present\n");
    80000e22:	00007517          	auipc	a0,0x7
    80000e26:	37650513          	addi	a0,a0,886 # 80008198 <etext+0x198>
    80000e2a:	00005097          	auipc	ra,0x5
    80000e2e:	fc0080e7          	jalr	-64(ra) # 80005dea <printf>
        return -1;
    80000e32:	557d                	li	a0,-1
    80000e34:	b7e1                	j	80000dfc <address_translation_wiht_cow_page+0x8a>
        printf("cow bit isn't set\n");
    80000e36:	00007517          	auipc	a0,0x7
    80000e3a:	39a50513          	addi	a0,a0,922 # 800081d0 <etext+0x1d0>
    80000e3e:	00005097          	auipc	ra,0x5
    80000e42:	fac080e7          	jalr	-84(ra) # 80005dea <printf>
        return -1;
    80000e46:	557d                	li	a0,-1
    80000e48:	bf55                	j	80000dfc <address_translation_wiht_cow_page+0x8a>
        printf("phy addr error\n");
    80000e4a:	00007517          	auipc	a0,0x7
    80000e4e:	39e50513          	addi	a0,a0,926 # 800081e8 <etext+0x1e8>
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	f98080e7          	jalr	-104(ra) # 80005dea <printf>
        return -1;
    80000e5a:	557d                	li	a0,-1
    80000e5c:	b745                	j	80000dfc <address_translation_wiht_cow_page+0x8a>
        mem = kalloc(); // 申请新的物理页
    80000e5e:	fffff097          	auipc	ra,0xfffff
    80000e62:	1be080e7          	jalr	446(ra) # 8000001c <kalloc>
    80000e66:	8aaa                	mv	s5,a0
        if (mem == 0)
    80000e68:	c529                	beqz	a0,80000eb2 <address_translation_wiht_cow_page+0x140>
        memmove(mem, (void *)pa, PGSIZE); // 复制旧物理页内容
    80000e6a:	6605                	lui	a2,0x1
    80000e6c:	85a6                	mv	a1,s1
    80000e6e:	fffff097          	auipc	ra,0xfffff
    80000e72:	48c080e7          	jalr	1164(ra) # 800002fa <memmove>
        flags = (PTE_FLAGS(*pte) | PTE_W) & ~PTE_COW;                 // 获取旧物理页标志位信息并置换cow与w位
    80000e76:	00093483          	ld	s1,0(s2)
    80000e7a:	2fb4f493          	andi	s1,s1,763
    80000e7e:	0044e493          	ori	s1,s1,4
        uvmunmap(pagetable, va, 1, 1);                                // 取消对旧物理页的映射并调用kree函数
    80000e82:	4685                	li	a3,1
    80000e84:	4605                	li	a2,1
    80000e86:	85ce                	mv	a1,s3
    80000e88:	8552                	mv	a0,s4
    80000e8a:	00000097          	auipc	ra,0x0
    80000e8e:	9a2080e7          	jalr	-1630(ra) # 8000082c <uvmunmap>
        if (mappages(pagetable, va, PGSIZE, (uint64)mem, flags) != 0) // 将虚拟地址映射到新物理页
    80000e92:	8726                	mv	a4,s1
    80000e94:	86d6                	mv	a3,s5
    80000e96:	6605                	lui	a2,0x1
    80000e98:	85ce                	mv	a1,s3
    80000e9a:	8552                	mv	a0,s4
    80000e9c:	fffff097          	auipc	ra,0xfffff
    80000ea0:	7ca080e7          	jalr	1994(ra) # 80000666 <mappages>
    80000ea4:	d539                	beqz	a0,80000df2 <address_translation_wiht_cow_page+0x80>
            release_rc_lock();
    80000ea6:	fffff097          	auipc	ra,0xfffff
    80000eaa:	20c080e7          	jalr	524(ra) # 800000b2 <release_rc_lock>
            return -1;
    80000eae:	557d                	li	a0,-1
    80000eb0:	b7b1                	j	80000dfc <address_translation_wiht_cow_page+0x8a>
            printf("alloc memory failed\n");
    80000eb2:	00007517          	auipc	a0,0x7
    80000eb6:	34650513          	addi	a0,a0,838 # 800081f8 <etext+0x1f8>
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	f30080e7          	jalr	-208(ra) # 80005dea <printf>
            release_rc_lock();
    80000ec2:	fffff097          	auipc	ra,0xfffff
    80000ec6:	1f0080e7          	jalr	496(ra) # 800000b2 <release_rc_lock>
            return -1;
    80000eca:	557d                	li	a0,-1
    80000ecc:	bf05                	j	80000dfc <address_translation_wiht_cow_page+0x8a>
        return -1;
    80000ece:	557d                	li	a0,-1
}
    80000ed0:	8082                	ret

0000000080000ed2 <copyout>:
    while (len > 0)
    80000ed2:	cebd                	beqz	a3,80000f50 <copyout+0x7e>
{
    80000ed4:	715d                	addi	sp,sp,-80
    80000ed6:	e486                	sd	ra,72(sp)
    80000ed8:	e0a2                	sd	s0,64(sp)
    80000eda:	fc26                	sd	s1,56(sp)
    80000edc:	f84a                	sd	s2,48(sp)
    80000ede:	f44e                	sd	s3,40(sp)
    80000ee0:	f052                	sd	s4,32(sp)
    80000ee2:	ec56                	sd	s5,24(sp)
    80000ee4:	e85a                	sd	s6,16(sp)
    80000ee6:	e45e                	sd	s7,8(sp)
    80000ee8:	e062                	sd	s8,0(sp)
    80000eea:	0880                	addi	s0,sp,80
    80000eec:	8b2a                	mv	s6,a0
    80000eee:	892e                	mv	s2,a1
    80000ef0:	8ab2                	mv	s5,a2
    80000ef2:	8a36                	mv	s4,a3
        va0 = PGROUNDDOWN(dstva);
    80000ef4:	7c7d                	lui	s8,0xfffff
        n = PGSIZE - (dstva - va0);
    80000ef6:	6b85                	lui	s7,0x1
    80000ef8:	a015                	j	80000f1c <copyout+0x4a>
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000efa:	41390933          	sub	s2,s2,s3
    80000efe:	0004861b          	sext.w	a2,s1
    80000f02:	85d6                	mv	a1,s5
    80000f04:	954a                	add	a0,a0,s2
    80000f06:	fffff097          	auipc	ra,0xfffff
    80000f0a:	3f4080e7          	jalr	1012(ra) # 800002fa <memmove>
        len -= n;
    80000f0e:	409a0a33          	sub	s4,s4,s1
        src += n;
    80000f12:	9aa6                	add	s5,s5,s1
        dstva = va0 + PGSIZE;
    80000f14:	01798933          	add	s2,s3,s7
    while (len > 0)
    80000f18:	020a0a63          	beqz	s4,80000f4c <copyout+0x7a>
        va0 = PGROUNDDOWN(dstva);
    80000f1c:	018979b3          	and	s3,s2,s8
        res = address_translation_wiht_cow_page(va0, pagetable); // cow页处理
    80000f20:	85da                	mv	a1,s6
    80000f22:	854e                	mv	a0,s3
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	e4e080e7          	jalr	-434(ra) # 80000d72 <address_translation_wiht_cow_page>
        if (res < 0)
    80000f2c:	02054463          	bltz	a0,80000f54 <copyout+0x82>
        pa0 = walkaddr(pagetable, va0);
    80000f30:	85ce                	mv	a1,s3
    80000f32:	855a                	mv	a0,s6
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	6f0080e7          	jalr	1776(ra) # 80000624 <walkaddr>
        if (pa0 == 0)
    80000f3c:	c90d                	beqz	a0,80000f6e <copyout+0x9c>
        n = PGSIZE - (dstva - va0);
    80000f3e:	412984b3          	sub	s1,s3,s2
    80000f42:	94de                	add	s1,s1,s7
    80000f44:	fa9a7be3          	bgeu	s4,s1,80000efa <copyout+0x28>
    80000f48:	84d2                	mv	s1,s4
    80000f4a:	bf45                	j	80000efa <copyout+0x28>
    return 0;
    80000f4c:	4501                	li	a0,0
    80000f4e:	a021                	j	80000f56 <copyout+0x84>
    80000f50:	4501                	li	a0,0
}
    80000f52:	8082                	ret
            return -1;
    80000f54:	557d                	li	a0,-1
}
    80000f56:	60a6                	ld	ra,72(sp)
    80000f58:	6406                	ld	s0,64(sp)
    80000f5a:	74e2                	ld	s1,56(sp)
    80000f5c:	7942                	ld	s2,48(sp)
    80000f5e:	79a2                	ld	s3,40(sp)
    80000f60:	7a02                	ld	s4,32(sp)
    80000f62:	6ae2                	ld	s5,24(sp)
    80000f64:	6b42                	ld	s6,16(sp)
    80000f66:	6ba2                	ld	s7,8(sp)
    80000f68:	6c02                	ld	s8,0(sp)
    80000f6a:	6161                	addi	sp,sp,80
    80000f6c:	8082                	ret
            return -1;
    80000f6e:	557d                	li	a0,-1
    80000f70:	b7dd                	j	80000f56 <copyout+0x84>

0000000080000f72 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000f72:	7139                	addi	sp,sp,-64
    80000f74:	fc06                	sd	ra,56(sp)
    80000f76:	f822                	sd	s0,48(sp)
    80000f78:	f426                	sd	s1,40(sp)
    80000f7a:	f04a                	sd	s2,32(sp)
    80000f7c:	ec4e                	sd	s3,24(sp)
    80000f7e:	e852                	sd	s4,16(sp)
    80000f80:	e456                	sd	s5,8(sp)
    80000f82:	e05a                	sd	s6,0(sp)
    80000f84:	0080                	addi	s0,sp,64
    80000f86:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f88:	00228497          	auipc	s1,0x228
    80000f8c:	51848493          	addi	s1,s1,1304 # 802294a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f90:	8b26                	mv	s6,s1
    80000f92:	00007a97          	auipc	s5,0x7
    80000f96:	06ea8a93          	addi	s5,s5,110 # 80008000 <etext>
    80000f9a:	04000937          	lui	s2,0x4000
    80000f9e:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000fa0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fa2:	0022ea17          	auipc	s4,0x22e
    80000fa6:	efea0a13          	addi	s4,s4,-258 # 8022eea0 <tickslock>
    char *pa = kalloc();
    80000faa:	fffff097          	auipc	ra,0xfffff
    80000fae:	072080e7          	jalr	114(ra) # 8000001c <kalloc>
    80000fb2:	862a                	mv	a2,a0
    if(pa == 0)
    80000fb4:	c131                	beqz	a0,80000ff8 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000fb6:	416485b3          	sub	a1,s1,s6
    80000fba:	858d                	srai	a1,a1,0x3
    80000fbc:	000ab783          	ld	a5,0(s5)
    80000fc0:	02f585b3          	mul	a1,a1,a5
    80000fc4:	2585                	addiw	a1,a1,1
    80000fc6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000fca:	4719                	li	a4,6
    80000fcc:	6685                	lui	a3,0x1
    80000fce:	40b905b3          	sub	a1,s2,a1
    80000fd2:	854e                	mv	a0,s3
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	732080e7          	jalr	1842(ra) # 80000706 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fdc:	16848493          	addi	s1,s1,360
    80000fe0:	fd4495e3          	bne	s1,s4,80000faa <proc_mapstacks+0x38>
  }
}
    80000fe4:	70e2                	ld	ra,56(sp)
    80000fe6:	7442                	ld	s0,48(sp)
    80000fe8:	74a2                	ld	s1,40(sp)
    80000fea:	7902                	ld	s2,32(sp)
    80000fec:	69e2                	ld	s3,24(sp)
    80000fee:	6a42                	ld	s4,16(sp)
    80000ff0:	6aa2                	ld	s5,8(sp)
    80000ff2:	6b02                	ld	s6,0(sp)
    80000ff4:	6121                	addi	sp,sp,64
    80000ff6:	8082                	ret
      panic("kalloc");
    80000ff8:	00007517          	auipc	a0,0x7
    80000ffc:	21850513          	addi	a0,a0,536 # 80008210 <etext+0x210>
    80001000:	00005097          	auipc	ra,0x5
    80001004:	da0080e7          	jalr	-608(ra) # 80005da0 <panic>

0000000080001008 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80001008:	7139                	addi	sp,sp,-64
    8000100a:	fc06                	sd	ra,56(sp)
    8000100c:	f822                	sd	s0,48(sp)
    8000100e:	f426                	sd	s1,40(sp)
    80001010:	f04a                	sd	s2,32(sp)
    80001012:	ec4e                	sd	s3,24(sp)
    80001014:	e852                	sd	s4,16(sp)
    80001016:	e456                	sd	s5,8(sp)
    80001018:	e05a                	sd	s6,0(sp)
    8000101a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000101c:	00007597          	auipc	a1,0x7
    80001020:	1fc58593          	addi	a1,a1,508 # 80008218 <etext+0x218>
    80001024:	00228517          	auipc	a0,0x228
    80001028:	04c50513          	addi	a0,a0,76 # 80229070 <pid_lock>
    8000102c:	00005097          	auipc	ra,0x5
    80001030:	21c080e7          	jalr	540(ra) # 80006248 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001034:	00007597          	auipc	a1,0x7
    80001038:	1ec58593          	addi	a1,a1,492 # 80008220 <etext+0x220>
    8000103c:	00228517          	auipc	a0,0x228
    80001040:	04c50513          	addi	a0,a0,76 # 80229088 <wait_lock>
    80001044:	00005097          	auipc	ra,0x5
    80001048:	204080e7          	jalr	516(ra) # 80006248 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000104c:	00228497          	auipc	s1,0x228
    80001050:	45448493          	addi	s1,s1,1108 # 802294a0 <proc>
      initlock(&p->lock, "proc");
    80001054:	00007b17          	auipc	s6,0x7
    80001058:	1dcb0b13          	addi	s6,s6,476 # 80008230 <etext+0x230>
      p->kstack = KSTACK((int) (p - proc));
    8000105c:	8aa6                	mv	s5,s1
    8000105e:	00007a17          	auipc	s4,0x7
    80001062:	fa2a0a13          	addi	s4,s4,-94 # 80008000 <etext>
    80001066:	04000937          	lui	s2,0x4000
    8000106a:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000106c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000106e:	0022e997          	auipc	s3,0x22e
    80001072:	e3298993          	addi	s3,s3,-462 # 8022eea0 <tickslock>
      initlock(&p->lock, "proc");
    80001076:	85da                	mv	a1,s6
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	1ce080e7          	jalr	462(ra) # 80006248 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001082:	415487b3          	sub	a5,s1,s5
    80001086:	878d                	srai	a5,a5,0x3
    80001088:	000a3703          	ld	a4,0(s4)
    8000108c:	02e787b3          	mul	a5,a5,a4
    80001090:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7fdb8dc1>
    80001092:	00d7979b          	slliw	a5,a5,0xd
    80001096:	40f907b3          	sub	a5,s2,a5
    8000109a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000109c:	16848493          	addi	s1,s1,360
    800010a0:	fd349be3          	bne	s1,s3,80001076 <procinit+0x6e>
  }
}
    800010a4:	70e2                	ld	ra,56(sp)
    800010a6:	7442                	ld	s0,48(sp)
    800010a8:	74a2                	ld	s1,40(sp)
    800010aa:	7902                	ld	s2,32(sp)
    800010ac:	69e2                	ld	s3,24(sp)
    800010ae:	6a42                	ld	s4,16(sp)
    800010b0:	6aa2                	ld	s5,8(sp)
    800010b2:	6b02                	ld	s6,0(sp)
    800010b4:	6121                	addi	sp,sp,64
    800010b6:	8082                	ret

00000000800010b8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800010b8:	1141                	addi	sp,sp,-16
    800010ba:	e422                	sd	s0,8(sp)
    800010bc:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800010be:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800010c0:	2501                	sext.w	a0,a0
    800010c2:	6422                	ld	s0,8(sp)
    800010c4:	0141                	addi	sp,sp,16
    800010c6:	8082                	ret

00000000800010c8 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    800010c8:	1141                	addi	sp,sp,-16
    800010ca:	e422                	sd	s0,8(sp)
    800010cc:	0800                	addi	s0,sp,16
    800010ce:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800010d0:	2781                	sext.w	a5,a5
    800010d2:	079e                	slli	a5,a5,0x7
  return c;
}
    800010d4:	00228517          	auipc	a0,0x228
    800010d8:	fcc50513          	addi	a0,a0,-52 # 802290a0 <cpus>
    800010dc:	953e                	add	a0,a0,a5
    800010de:	6422                	ld	s0,8(sp)
    800010e0:	0141                	addi	sp,sp,16
    800010e2:	8082                	ret

00000000800010e4 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    800010e4:	1101                	addi	sp,sp,-32
    800010e6:	ec06                	sd	ra,24(sp)
    800010e8:	e822                	sd	s0,16(sp)
    800010ea:	e426                	sd	s1,8(sp)
    800010ec:	1000                	addi	s0,sp,32
  push_off();
    800010ee:	00005097          	auipc	ra,0x5
    800010f2:	19e080e7          	jalr	414(ra) # 8000628c <push_off>
    800010f6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800010f8:	2781                	sext.w	a5,a5
    800010fa:	079e                	slli	a5,a5,0x7
    800010fc:	00228717          	auipc	a4,0x228
    80001100:	f7470713          	addi	a4,a4,-140 # 80229070 <pid_lock>
    80001104:	97ba                	add	a5,a5,a4
    80001106:	7b84                	ld	s1,48(a5)
  pop_off();
    80001108:	00005097          	auipc	ra,0x5
    8000110c:	224080e7          	jalr	548(ra) # 8000632c <pop_off>
  return p;
}
    80001110:	8526                	mv	a0,s1
    80001112:	60e2                	ld	ra,24(sp)
    80001114:	6442                	ld	s0,16(sp)
    80001116:	64a2                	ld	s1,8(sp)
    80001118:	6105                	addi	sp,sp,32
    8000111a:	8082                	ret

000000008000111c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000111c:	1141                	addi	sp,sp,-16
    8000111e:	e406                	sd	ra,8(sp)
    80001120:	e022                	sd	s0,0(sp)
    80001122:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001124:	00000097          	auipc	ra,0x0
    80001128:	fc0080e7          	jalr	-64(ra) # 800010e4 <myproc>
    8000112c:	00005097          	auipc	ra,0x5
    80001130:	260080e7          	jalr	608(ra) # 8000638c <release>

  if (first) {
    80001134:	00007797          	auipc	a5,0x7
    80001138:	79c7a783          	lw	a5,1948(a5) # 800088d0 <first.1>
    8000113c:	eb89                	bnez	a5,8000114e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    8000113e:	00001097          	auipc	ra,0x1
    80001142:	c14080e7          	jalr	-1004(ra) # 80001d52 <usertrapret>
}
    80001146:	60a2                	ld	ra,8(sp)
    80001148:	6402                	ld	s0,0(sp)
    8000114a:	0141                	addi	sp,sp,16
    8000114c:	8082                	ret
    first = 0;
    8000114e:	00007797          	auipc	a5,0x7
    80001152:	7807a123          	sw	zero,1922(a5) # 800088d0 <first.1>
    fsinit(ROOTDEV);
    80001156:	4505                	li	a0,1
    80001158:	00002097          	auipc	ra,0x2
    8000115c:	95a080e7          	jalr	-1702(ra) # 80002ab2 <fsinit>
    80001160:	bff9                	j	8000113e <forkret+0x22>

0000000080001162 <allocpid>:
allocpid() {
    80001162:	1101                	addi	sp,sp,-32
    80001164:	ec06                	sd	ra,24(sp)
    80001166:	e822                	sd	s0,16(sp)
    80001168:	e426                	sd	s1,8(sp)
    8000116a:	e04a                	sd	s2,0(sp)
    8000116c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000116e:	00228917          	auipc	s2,0x228
    80001172:	f0290913          	addi	s2,s2,-254 # 80229070 <pid_lock>
    80001176:	854a                	mv	a0,s2
    80001178:	00005097          	auipc	ra,0x5
    8000117c:	160080e7          	jalr	352(ra) # 800062d8 <acquire>
  pid = nextpid;
    80001180:	00007797          	auipc	a5,0x7
    80001184:	75478793          	addi	a5,a5,1876 # 800088d4 <nextpid>
    80001188:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000118a:	0014871b          	addiw	a4,s1,1
    8000118e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001190:	854a                	mv	a0,s2
    80001192:	00005097          	auipc	ra,0x5
    80001196:	1fa080e7          	jalr	506(ra) # 8000638c <release>
}
    8000119a:	8526                	mv	a0,s1
    8000119c:	60e2                	ld	ra,24(sp)
    8000119e:	6442                	ld	s0,16(sp)
    800011a0:	64a2                	ld	s1,8(sp)
    800011a2:	6902                	ld	s2,0(sp)
    800011a4:	6105                	addi	sp,sp,32
    800011a6:	8082                	ret

00000000800011a8 <proc_pagetable>:
{
    800011a8:	1101                	addi	sp,sp,-32
    800011aa:	ec06                	sd	ra,24(sp)
    800011ac:	e822                	sd	s0,16(sp)
    800011ae:	e426                	sd	s1,8(sp)
    800011b0:	e04a                	sd	s2,0(sp)
    800011b2:	1000                	addi	s0,sp,32
    800011b4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800011b6:	fffff097          	auipc	ra,0xfffff
    800011ba:	73a080e7          	jalr	1850(ra) # 800008f0 <uvmcreate>
    800011be:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800011c0:	c121                	beqz	a0,80001200 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800011c2:	4729                	li	a4,10
    800011c4:	00006697          	auipc	a3,0x6
    800011c8:	e3c68693          	addi	a3,a3,-452 # 80007000 <_trampoline>
    800011cc:	6605                	lui	a2,0x1
    800011ce:	040005b7          	lui	a1,0x4000
    800011d2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011d4:	05b2                	slli	a1,a1,0xc
    800011d6:	fffff097          	auipc	ra,0xfffff
    800011da:	490080e7          	jalr	1168(ra) # 80000666 <mappages>
    800011de:	02054863          	bltz	a0,8000120e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800011e2:	4719                	li	a4,6
    800011e4:	05893683          	ld	a3,88(s2)
    800011e8:	6605                	lui	a2,0x1
    800011ea:	020005b7          	lui	a1,0x2000
    800011ee:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011f0:	05b6                	slli	a1,a1,0xd
    800011f2:	8526                	mv	a0,s1
    800011f4:	fffff097          	auipc	ra,0xfffff
    800011f8:	472080e7          	jalr	1138(ra) # 80000666 <mappages>
    800011fc:	02054163          	bltz	a0,8000121e <proc_pagetable+0x76>
}
    80001200:	8526                	mv	a0,s1
    80001202:	60e2                	ld	ra,24(sp)
    80001204:	6442                	ld	s0,16(sp)
    80001206:	64a2                	ld	s1,8(sp)
    80001208:	6902                	ld	s2,0(sp)
    8000120a:	6105                	addi	sp,sp,32
    8000120c:	8082                	ret
    uvmfree(pagetable, 0);
    8000120e:	4581                	li	a1,0
    80001210:	8526                	mv	a0,s1
    80001212:	00000097          	auipc	ra,0x0
    80001216:	8dc080e7          	jalr	-1828(ra) # 80000aee <uvmfree>
    return 0;
    8000121a:	4481                	li	s1,0
    8000121c:	b7d5                	j	80001200 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000121e:	4681                	li	a3,0
    80001220:	4605                	li	a2,1
    80001222:	040005b7          	lui	a1,0x4000
    80001226:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001228:	05b2                	slli	a1,a1,0xc
    8000122a:	8526                	mv	a0,s1
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	600080e7          	jalr	1536(ra) # 8000082c <uvmunmap>
    uvmfree(pagetable, 0);
    80001234:	4581                	li	a1,0
    80001236:	8526                	mv	a0,s1
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	8b6080e7          	jalr	-1866(ra) # 80000aee <uvmfree>
    return 0;
    80001240:	4481                	li	s1,0
    80001242:	bf7d                	j	80001200 <proc_pagetable+0x58>

0000000080001244 <proc_freepagetable>:
{
    80001244:	1101                	addi	sp,sp,-32
    80001246:	ec06                	sd	ra,24(sp)
    80001248:	e822                	sd	s0,16(sp)
    8000124a:	e426                	sd	s1,8(sp)
    8000124c:	e04a                	sd	s2,0(sp)
    8000124e:	1000                	addi	s0,sp,32
    80001250:	84aa                	mv	s1,a0
    80001252:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001254:	4681                	li	a3,0
    80001256:	4605                	li	a2,1
    80001258:	040005b7          	lui	a1,0x4000
    8000125c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000125e:	05b2                	slli	a1,a1,0xc
    80001260:	fffff097          	auipc	ra,0xfffff
    80001264:	5cc080e7          	jalr	1484(ra) # 8000082c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001268:	4681                	li	a3,0
    8000126a:	4605                	li	a2,1
    8000126c:	020005b7          	lui	a1,0x2000
    80001270:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001272:	05b6                	slli	a1,a1,0xd
    80001274:	8526                	mv	a0,s1
    80001276:	fffff097          	auipc	ra,0xfffff
    8000127a:	5b6080e7          	jalr	1462(ra) # 8000082c <uvmunmap>
  uvmfree(pagetable, sz);
    8000127e:	85ca                	mv	a1,s2
    80001280:	8526                	mv	a0,s1
    80001282:	00000097          	auipc	ra,0x0
    80001286:	86c080e7          	jalr	-1940(ra) # 80000aee <uvmfree>
}
    8000128a:	60e2                	ld	ra,24(sp)
    8000128c:	6442                	ld	s0,16(sp)
    8000128e:	64a2                	ld	s1,8(sp)
    80001290:	6902                	ld	s2,0(sp)
    80001292:	6105                	addi	sp,sp,32
    80001294:	8082                	ret

0000000080001296 <freeproc>:
{
    80001296:	1101                	addi	sp,sp,-32
    80001298:	ec06                	sd	ra,24(sp)
    8000129a:	e822                	sd	s0,16(sp)
    8000129c:	e426                	sd	s1,8(sp)
    8000129e:	1000                	addi	s0,sp,32
    800012a0:	84aa                	mv	s1,a0
  if(p->trapframe)
    800012a2:	6d28                	ld	a0,88(a0)
    800012a4:	c509                	beqz	a0,800012ae <freeproc+0x18>
    kfree((void*)p->trapframe);
    800012a6:	fffff097          	auipc	ra,0xfffff
    800012aa:	eb0080e7          	jalr	-336(ra) # 80000156 <kfree>
  p->trapframe = 0;
    800012ae:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800012b2:	68a8                	ld	a0,80(s1)
    800012b4:	c511                	beqz	a0,800012c0 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800012b6:	64ac                	ld	a1,72(s1)
    800012b8:	00000097          	auipc	ra,0x0
    800012bc:	f8c080e7          	jalr	-116(ra) # 80001244 <proc_freepagetable>
  p->pagetable = 0;
    800012c0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800012c4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800012c8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800012cc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800012d0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800012d4:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800012d8:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800012dc:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800012e0:	0004ac23          	sw	zero,24(s1)
}
    800012e4:	60e2                	ld	ra,24(sp)
    800012e6:	6442                	ld	s0,16(sp)
    800012e8:	64a2                	ld	s1,8(sp)
    800012ea:	6105                	addi	sp,sp,32
    800012ec:	8082                	ret

00000000800012ee <allocproc>:
{
    800012ee:	1101                	addi	sp,sp,-32
    800012f0:	ec06                	sd	ra,24(sp)
    800012f2:	e822                	sd	s0,16(sp)
    800012f4:	e426                	sd	s1,8(sp)
    800012f6:	e04a                	sd	s2,0(sp)
    800012f8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800012fa:	00228497          	auipc	s1,0x228
    800012fe:	1a648493          	addi	s1,s1,422 # 802294a0 <proc>
    80001302:	0022e917          	auipc	s2,0x22e
    80001306:	b9e90913          	addi	s2,s2,-1122 # 8022eea0 <tickslock>
    acquire(&p->lock);
    8000130a:	8526                	mv	a0,s1
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	fcc080e7          	jalr	-52(ra) # 800062d8 <acquire>
    if(p->state == UNUSED) {
    80001314:	4c9c                	lw	a5,24(s1)
    80001316:	cf81                	beqz	a5,8000132e <allocproc+0x40>
      release(&p->lock);
    80001318:	8526                	mv	a0,s1
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	072080e7          	jalr	114(ra) # 8000638c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001322:	16848493          	addi	s1,s1,360
    80001326:	ff2492e3          	bne	s1,s2,8000130a <allocproc+0x1c>
  return 0;
    8000132a:	4481                	li	s1,0
    8000132c:	a889                	j	8000137e <allocproc+0x90>
  p->pid = allocpid();
    8000132e:	00000097          	auipc	ra,0x0
    80001332:	e34080e7          	jalr	-460(ra) # 80001162 <allocpid>
    80001336:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001338:	4785                	li	a5,1
    8000133a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000133c:	fffff097          	auipc	ra,0xfffff
    80001340:	ce0080e7          	jalr	-800(ra) # 8000001c <kalloc>
    80001344:	892a                	mv	s2,a0
    80001346:	eca8                	sd	a0,88(s1)
    80001348:	c131                	beqz	a0,8000138c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000134a:	8526                	mv	a0,s1
    8000134c:	00000097          	auipc	ra,0x0
    80001350:	e5c080e7          	jalr	-420(ra) # 800011a8 <proc_pagetable>
    80001354:	892a                	mv	s2,a0
    80001356:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001358:	c531                	beqz	a0,800013a4 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000135a:	07000613          	li	a2,112
    8000135e:	4581                	li	a1,0
    80001360:	06048513          	addi	a0,s1,96
    80001364:	fffff097          	auipc	ra,0xfffff
    80001368:	f3a080e7          	jalr	-198(ra) # 8000029e <memset>
  p->context.ra = (uint64)forkret;
    8000136c:	00000797          	auipc	a5,0x0
    80001370:	db078793          	addi	a5,a5,-592 # 8000111c <forkret>
    80001374:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001376:	60bc                	ld	a5,64(s1)
    80001378:	6705                	lui	a4,0x1
    8000137a:	97ba                	add	a5,a5,a4
    8000137c:	f4bc                	sd	a5,104(s1)
}
    8000137e:	8526                	mv	a0,s1
    80001380:	60e2                	ld	ra,24(sp)
    80001382:	6442                	ld	s0,16(sp)
    80001384:	64a2                	ld	s1,8(sp)
    80001386:	6902                	ld	s2,0(sp)
    80001388:	6105                	addi	sp,sp,32
    8000138a:	8082                	ret
    freeproc(p);
    8000138c:	8526                	mv	a0,s1
    8000138e:	00000097          	auipc	ra,0x0
    80001392:	f08080e7          	jalr	-248(ra) # 80001296 <freeproc>
    release(&p->lock);
    80001396:	8526                	mv	a0,s1
    80001398:	00005097          	auipc	ra,0x5
    8000139c:	ff4080e7          	jalr	-12(ra) # 8000638c <release>
    return 0;
    800013a0:	84ca                	mv	s1,s2
    800013a2:	bff1                	j	8000137e <allocproc+0x90>
    freeproc(p);
    800013a4:	8526                	mv	a0,s1
    800013a6:	00000097          	auipc	ra,0x0
    800013aa:	ef0080e7          	jalr	-272(ra) # 80001296 <freeproc>
    release(&p->lock);
    800013ae:	8526                	mv	a0,s1
    800013b0:	00005097          	auipc	ra,0x5
    800013b4:	fdc080e7          	jalr	-36(ra) # 8000638c <release>
    return 0;
    800013b8:	84ca                	mv	s1,s2
    800013ba:	b7d1                	j	8000137e <allocproc+0x90>

00000000800013bc <userinit>:
{
    800013bc:	1101                	addi	sp,sp,-32
    800013be:	ec06                	sd	ra,24(sp)
    800013c0:	e822                	sd	s0,16(sp)
    800013c2:	e426                	sd	s1,8(sp)
    800013c4:	1000                	addi	s0,sp,32
  p = allocproc();
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	f28080e7          	jalr	-216(ra) # 800012ee <allocproc>
    800013ce:	84aa                	mv	s1,a0
  initproc = p;
    800013d0:	00008797          	auipc	a5,0x8
    800013d4:	c4a7b023          	sd	a0,-960(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800013d8:	03400613          	li	a2,52
    800013dc:	00007597          	auipc	a1,0x7
    800013e0:	50458593          	addi	a1,a1,1284 # 800088e0 <initcode>
    800013e4:	6928                	ld	a0,80(a0)
    800013e6:	fffff097          	auipc	ra,0xfffff
    800013ea:	538080e7          	jalr	1336(ra) # 8000091e <uvminit>
  p->sz = PGSIZE;
    800013ee:	6785                	lui	a5,0x1
    800013f0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800013f2:	6cb8                	ld	a4,88(s1)
    800013f4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800013f8:	6cb8                	ld	a4,88(s1)
    800013fa:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800013fc:	4641                	li	a2,16
    800013fe:	00007597          	auipc	a1,0x7
    80001402:	e3a58593          	addi	a1,a1,-454 # 80008238 <etext+0x238>
    80001406:	15848513          	addi	a0,s1,344
    8000140a:	fffff097          	auipc	ra,0xfffff
    8000140e:	fde080e7          	jalr	-34(ra) # 800003e8 <safestrcpy>
  p->cwd = namei("/");
    80001412:	00007517          	auipc	a0,0x7
    80001416:	e3650513          	addi	a0,a0,-458 # 80008248 <etext+0x248>
    8000141a:	00002097          	auipc	ra,0x2
    8000141e:	0ce080e7          	jalr	206(ra) # 800034e8 <namei>
    80001422:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001426:	478d                	li	a5,3
    80001428:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000142a:	8526                	mv	a0,s1
    8000142c:	00005097          	auipc	ra,0x5
    80001430:	f60080e7          	jalr	-160(ra) # 8000638c <release>
}
    80001434:	60e2                	ld	ra,24(sp)
    80001436:	6442                	ld	s0,16(sp)
    80001438:	64a2                	ld	s1,8(sp)
    8000143a:	6105                	addi	sp,sp,32
    8000143c:	8082                	ret

000000008000143e <growproc>:
{
    8000143e:	1101                	addi	sp,sp,-32
    80001440:	ec06                	sd	ra,24(sp)
    80001442:	e822                	sd	s0,16(sp)
    80001444:	e426                	sd	s1,8(sp)
    80001446:	e04a                	sd	s2,0(sp)
    80001448:	1000                	addi	s0,sp,32
    8000144a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000144c:	00000097          	auipc	ra,0x0
    80001450:	c98080e7          	jalr	-872(ra) # 800010e4 <myproc>
    80001454:	892a                	mv	s2,a0
  sz = p->sz;
    80001456:	652c                	ld	a1,72(a0)
    80001458:	0005879b          	sext.w	a5,a1
  if(n > 0){
    8000145c:	00904f63          	bgtz	s1,8000147a <growproc+0x3c>
  } else if(n < 0){
    80001460:	0204cd63          	bltz	s1,8000149a <growproc+0x5c>
  p->sz = sz;
    80001464:	1782                	slli	a5,a5,0x20
    80001466:	9381                	srli	a5,a5,0x20
    80001468:	04f93423          	sd	a5,72(s2)
  return 0;
    8000146c:	4501                	li	a0,0
}
    8000146e:	60e2                	ld	ra,24(sp)
    80001470:	6442                	ld	s0,16(sp)
    80001472:	64a2                	ld	s1,8(sp)
    80001474:	6902                	ld	s2,0(sp)
    80001476:	6105                	addi	sp,sp,32
    80001478:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000147a:	00f4863b          	addw	a2,s1,a5
    8000147e:	1602                	slli	a2,a2,0x20
    80001480:	9201                	srli	a2,a2,0x20
    80001482:	1582                	slli	a1,a1,0x20
    80001484:	9181                	srli	a1,a1,0x20
    80001486:	6928                	ld	a0,80(a0)
    80001488:	fffff097          	auipc	ra,0xfffff
    8000148c:	550080e7          	jalr	1360(ra) # 800009d8 <uvmalloc>
    80001490:	0005079b          	sext.w	a5,a0
    80001494:	fbe1                	bnez	a5,80001464 <growproc+0x26>
      return -1;
    80001496:	557d                	li	a0,-1
    80001498:	bfd9                	j	8000146e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000149a:	00f4863b          	addw	a2,s1,a5
    8000149e:	1602                	slli	a2,a2,0x20
    800014a0:	9201                	srli	a2,a2,0x20
    800014a2:	1582                	slli	a1,a1,0x20
    800014a4:	9181                	srli	a1,a1,0x20
    800014a6:	6928                	ld	a0,80(a0)
    800014a8:	fffff097          	auipc	ra,0xfffff
    800014ac:	4e8080e7          	jalr	1256(ra) # 80000990 <uvmdealloc>
    800014b0:	0005079b          	sext.w	a5,a0
    800014b4:	bf45                	j	80001464 <growproc+0x26>

00000000800014b6 <fork>:
{
    800014b6:	7139                	addi	sp,sp,-64
    800014b8:	fc06                	sd	ra,56(sp)
    800014ba:	f822                	sd	s0,48(sp)
    800014bc:	f426                	sd	s1,40(sp)
    800014be:	f04a                	sd	s2,32(sp)
    800014c0:	ec4e                	sd	s3,24(sp)
    800014c2:	e852                	sd	s4,16(sp)
    800014c4:	e456                	sd	s5,8(sp)
    800014c6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800014c8:	00000097          	auipc	ra,0x0
    800014cc:	c1c080e7          	jalr	-996(ra) # 800010e4 <myproc>
    800014d0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	e1c080e7          	jalr	-484(ra) # 800012ee <allocproc>
    800014da:	10050c63          	beqz	a0,800015f2 <fork+0x13c>
    800014de:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800014e0:	048ab603          	ld	a2,72(s5)
    800014e4:	692c                	ld	a1,80(a0)
    800014e6:	050ab503          	ld	a0,80(s5)
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	7ae080e7          	jalr	1966(ra) # 80000c98 <uvmcopy>
    800014f2:	04054863          	bltz	a0,80001542 <fork+0x8c>
  np->sz = p->sz;
    800014f6:	048ab783          	ld	a5,72(s5)
    800014fa:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800014fe:	058ab683          	ld	a3,88(s5)
    80001502:	87b6                	mv	a5,a3
    80001504:	058a3703          	ld	a4,88(s4)
    80001508:	12068693          	addi	a3,a3,288
    8000150c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001510:	6788                	ld	a0,8(a5)
    80001512:	6b8c                	ld	a1,16(a5)
    80001514:	6f90                	ld	a2,24(a5)
    80001516:	01073023          	sd	a6,0(a4)
    8000151a:	e708                	sd	a0,8(a4)
    8000151c:	eb0c                	sd	a1,16(a4)
    8000151e:	ef10                	sd	a2,24(a4)
    80001520:	02078793          	addi	a5,a5,32
    80001524:	02070713          	addi	a4,a4,32
    80001528:	fed792e3          	bne	a5,a3,8000150c <fork+0x56>
  np->trapframe->a0 = 0;
    8000152c:	058a3783          	ld	a5,88(s4)
    80001530:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001534:	0d0a8493          	addi	s1,s5,208
    80001538:	0d0a0913          	addi	s2,s4,208
    8000153c:	150a8993          	addi	s3,s5,336
    80001540:	a00d                	j	80001562 <fork+0xac>
    freeproc(np);
    80001542:	8552                	mv	a0,s4
    80001544:	00000097          	auipc	ra,0x0
    80001548:	d52080e7          	jalr	-686(ra) # 80001296 <freeproc>
    release(&np->lock);
    8000154c:	8552                	mv	a0,s4
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	e3e080e7          	jalr	-450(ra) # 8000638c <release>
    return -1;
    80001556:	597d                	li	s2,-1
    80001558:	a059                	j	800015de <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    8000155a:	04a1                	addi	s1,s1,8
    8000155c:	0921                	addi	s2,s2,8
    8000155e:	01348b63          	beq	s1,s3,80001574 <fork+0xbe>
    if(p->ofile[i])
    80001562:	6088                	ld	a0,0(s1)
    80001564:	d97d                	beqz	a0,8000155a <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001566:	00002097          	auipc	ra,0x2
    8000156a:	618080e7          	jalr	1560(ra) # 80003b7e <filedup>
    8000156e:	00a93023          	sd	a0,0(s2)
    80001572:	b7e5                	j	8000155a <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001574:	150ab503          	ld	a0,336(s5)
    80001578:	00001097          	auipc	ra,0x1
    8000157c:	776080e7          	jalr	1910(ra) # 80002cee <idup>
    80001580:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001584:	4641                	li	a2,16
    80001586:	158a8593          	addi	a1,s5,344
    8000158a:	158a0513          	addi	a0,s4,344
    8000158e:	fffff097          	auipc	ra,0xfffff
    80001592:	e5a080e7          	jalr	-422(ra) # 800003e8 <safestrcpy>
  pid = np->pid;
    80001596:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000159a:	8552                	mv	a0,s4
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	df0080e7          	jalr	-528(ra) # 8000638c <release>
  acquire(&wait_lock);
    800015a4:	00228497          	auipc	s1,0x228
    800015a8:	ae448493          	addi	s1,s1,-1308 # 80229088 <wait_lock>
    800015ac:	8526                	mv	a0,s1
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	d2a080e7          	jalr	-726(ra) # 800062d8 <acquire>
  np->parent = p;
    800015b6:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800015ba:	8526                	mv	a0,s1
    800015bc:	00005097          	auipc	ra,0x5
    800015c0:	dd0080e7          	jalr	-560(ra) # 8000638c <release>
  acquire(&np->lock);
    800015c4:	8552                	mv	a0,s4
    800015c6:	00005097          	auipc	ra,0x5
    800015ca:	d12080e7          	jalr	-750(ra) # 800062d8 <acquire>
  np->state = RUNNABLE;
    800015ce:	478d                	li	a5,3
    800015d0:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800015d4:	8552                	mv	a0,s4
    800015d6:	00005097          	auipc	ra,0x5
    800015da:	db6080e7          	jalr	-586(ra) # 8000638c <release>
}
    800015de:	854a                	mv	a0,s2
    800015e0:	70e2                	ld	ra,56(sp)
    800015e2:	7442                	ld	s0,48(sp)
    800015e4:	74a2                	ld	s1,40(sp)
    800015e6:	7902                	ld	s2,32(sp)
    800015e8:	69e2                	ld	s3,24(sp)
    800015ea:	6a42                	ld	s4,16(sp)
    800015ec:	6aa2                	ld	s5,8(sp)
    800015ee:	6121                	addi	sp,sp,64
    800015f0:	8082                	ret
    return -1;
    800015f2:	597d                	li	s2,-1
    800015f4:	b7ed                	j	800015de <fork+0x128>

00000000800015f6 <scheduler>:
{
    800015f6:	7139                	addi	sp,sp,-64
    800015f8:	fc06                	sd	ra,56(sp)
    800015fa:	f822                	sd	s0,48(sp)
    800015fc:	f426                	sd	s1,40(sp)
    800015fe:	f04a                	sd	s2,32(sp)
    80001600:	ec4e                	sd	s3,24(sp)
    80001602:	e852                	sd	s4,16(sp)
    80001604:	e456                	sd	s5,8(sp)
    80001606:	e05a                	sd	s6,0(sp)
    80001608:	0080                	addi	s0,sp,64
    8000160a:	8792                	mv	a5,tp
  int id = r_tp();
    8000160c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000160e:	00779a93          	slli	s5,a5,0x7
    80001612:	00228717          	auipc	a4,0x228
    80001616:	a5e70713          	addi	a4,a4,-1442 # 80229070 <pid_lock>
    8000161a:	9756                	add	a4,a4,s5
    8000161c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001620:	00228717          	auipc	a4,0x228
    80001624:	a8870713          	addi	a4,a4,-1400 # 802290a8 <cpus+0x8>
    80001628:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000162a:	498d                	li	s3,3
        p->state = RUNNING;
    8000162c:	4b11                	li	s6,4
        c->proc = p;
    8000162e:	079e                	slli	a5,a5,0x7
    80001630:	00228a17          	auipc	s4,0x228
    80001634:	a40a0a13          	addi	s4,s4,-1472 # 80229070 <pid_lock>
    80001638:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000163a:	0022e917          	auipc	s2,0x22e
    8000163e:	86690913          	addi	s2,s2,-1946 # 8022eea0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001642:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001646:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000164a:	10079073          	csrw	sstatus,a5
    8000164e:	00228497          	auipc	s1,0x228
    80001652:	e5248493          	addi	s1,s1,-430 # 802294a0 <proc>
    80001656:	a811                	j	8000166a <scheduler+0x74>
      release(&p->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	00005097          	auipc	ra,0x5
    8000165e:	d32080e7          	jalr	-718(ra) # 8000638c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001662:	16848493          	addi	s1,s1,360
    80001666:	fd248ee3          	beq	s1,s2,80001642 <scheduler+0x4c>
      acquire(&p->lock);
    8000166a:	8526                	mv	a0,s1
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	c6c080e7          	jalr	-916(ra) # 800062d8 <acquire>
      if(p->state == RUNNABLE) {
    80001674:	4c9c                	lw	a5,24(s1)
    80001676:	ff3791e3          	bne	a5,s3,80001658 <scheduler+0x62>
        p->state = RUNNING;
    8000167a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000167e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001682:	06048593          	addi	a1,s1,96
    80001686:	8556                	mv	a0,s5
    80001688:	00000097          	auipc	ra,0x0
    8000168c:	620080e7          	jalr	1568(ra) # 80001ca8 <swtch>
        c->proc = 0;
    80001690:	020a3823          	sd	zero,48(s4)
    80001694:	b7d1                	j	80001658 <scheduler+0x62>

0000000080001696 <sched>:
{
    80001696:	7179                	addi	sp,sp,-48
    80001698:	f406                	sd	ra,40(sp)
    8000169a:	f022                	sd	s0,32(sp)
    8000169c:	ec26                	sd	s1,24(sp)
    8000169e:	e84a                	sd	s2,16(sp)
    800016a0:	e44e                	sd	s3,8(sp)
    800016a2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	a40080e7          	jalr	-1472(ra) # 800010e4 <myproc>
    800016ac:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	bb0080e7          	jalr	-1104(ra) # 8000625e <holding>
    800016b6:	c93d                	beqz	a0,8000172c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800016b8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800016ba:	2781                	sext.w	a5,a5
    800016bc:	079e                	slli	a5,a5,0x7
    800016be:	00228717          	auipc	a4,0x228
    800016c2:	9b270713          	addi	a4,a4,-1614 # 80229070 <pid_lock>
    800016c6:	97ba                	add	a5,a5,a4
    800016c8:	0a87a703          	lw	a4,168(a5)
    800016cc:	4785                	li	a5,1
    800016ce:	06f71763          	bne	a4,a5,8000173c <sched+0xa6>
  if(p->state == RUNNING)
    800016d2:	4c98                	lw	a4,24(s1)
    800016d4:	4791                	li	a5,4
    800016d6:	06f70b63          	beq	a4,a5,8000174c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800016da:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800016de:	8b89                	andi	a5,a5,2
  if(intr_get())
    800016e0:	efb5                	bnez	a5,8000175c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800016e2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800016e4:	00228917          	auipc	s2,0x228
    800016e8:	98c90913          	addi	s2,s2,-1652 # 80229070 <pid_lock>
    800016ec:	2781                	sext.w	a5,a5
    800016ee:	079e                	slli	a5,a5,0x7
    800016f0:	97ca                	add	a5,a5,s2
    800016f2:	0ac7a983          	lw	s3,172(a5)
    800016f6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800016f8:	2781                	sext.w	a5,a5
    800016fa:	079e                	slli	a5,a5,0x7
    800016fc:	00228597          	auipc	a1,0x228
    80001700:	9ac58593          	addi	a1,a1,-1620 # 802290a8 <cpus+0x8>
    80001704:	95be                	add	a1,a1,a5
    80001706:	06048513          	addi	a0,s1,96
    8000170a:	00000097          	auipc	ra,0x0
    8000170e:	59e080e7          	jalr	1438(ra) # 80001ca8 <swtch>
    80001712:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001714:	2781                	sext.w	a5,a5
    80001716:	079e                	slli	a5,a5,0x7
    80001718:	993e                	add	s2,s2,a5
    8000171a:	0b392623          	sw	s3,172(s2)
}
    8000171e:	70a2                	ld	ra,40(sp)
    80001720:	7402                	ld	s0,32(sp)
    80001722:	64e2                	ld	s1,24(sp)
    80001724:	6942                	ld	s2,16(sp)
    80001726:	69a2                	ld	s3,8(sp)
    80001728:	6145                	addi	sp,sp,48
    8000172a:	8082                	ret
    panic("sched p->lock");
    8000172c:	00007517          	auipc	a0,0x7
    80001730:	b2450513          	addi	a0,a0,-1244 # 80008250 <etext+0x250>
    80001734:	00004097          	auipc	ra,0x4
    80001738:	66c080e7          	jalr	1644(ra) # 80005da0 <panic>
    panic("sched locks");
    8000173c:	00007517          	auipc	a0,0x7
    80001740:	b2450513          	addi	a0,a0,-1244 # 80008260 <etext+0x260>
    80001744:	00004097          	auipc	ra,0x4
    80001748:	65c080e7          	jalr	1628(ra) # 80005da0 <panic>
    panic("sched running");
    8000174c:	00007517          	auipc	a0,0x7
    80001750:	b2450513          	addi	a0,a0,-1244 # 80008270 <etext+0x270>
    80001754:	00004097          	auipc	ra,0x4
    80001758:	64c080e7          	jalr	1612(ra) # 80005da0 <panic>
    panic("sched interruptible");
    8000175c:	00007517          	auipc	a0,0x7
    80001760:	b2450513          	addi	a0,a0,-1244 # 80008280 <etext+0x280>
    80001764:	00004097          	auipc	ra,0x4
    80001768:	63c080e7          	jalr	1596(ra) # 80005da0 <panic>

000000008000176c <yield>:
{
    8000176c:	1101                	addi	sp,sp,-32
    8000176e:	ec06                	sd	ra,24(sp)
    80001770:	e822                	sd	s0,16(sp)
    80001772:	e426                	sd	s1,8(sp)
    80001774:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	96e080e7          	jalr	-1682(ra) # 800010e4 <myproc>
    8000177e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001780:	00005097          	auipc	ra,0x5
    80001784:	b58080e7          	jalr	-1192(ra) # 800062d8 <acquire>
  p->state = RUNNABLE;
    80001788:	478d                	li	a5,3
    8000178a:	cc9c                	sw	a5,24(s1)
  sched();
    8000178c:	00000097          	auipc	ra,0x0
    80001790:	f0a080e7          	jalr	-246(ra) # 80001696 <sched>
  release(&p->lock);
    80001794:	8526                	mv	a0,s1
    80001796:	00005097          	auipc	ra,0x5
    8000179a:	bf6080e7          	jalr	-1034(ra) # 8000638c <release>
}
    8000179e:	60e2                	ld	ra,24(sp)
    800017a0:	6442                	ld	s0,16(sp)
    800017a2:	64a2                	ld	s1,8(sp)
    800017a4:	6105                	addi	sp,sp,32
    800017a6:	8082                	ret

00000000800017a8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800017a8:	7179                	addi	sp,sp,-48
    800017aa:	f406                	sd	ra,40(sp)
    800017ac:	f022                	sd	s0,32(sp)
    800017ae:	ec26                	sd	s1,24(sp)
    800017b0:	e84a                	sd	s2,16(sp)
    800017b2:	e44e                	sd	s3,8(sp)
    800017b4:	1800                	addi	s0,sp,48
    800017b6:	89aa                	mv	s3,a0
    800017b8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800017ba:	00000097          	auipc	ra,0x0
    800017be:	92a080e7          	jalr	-1750(ra) # 800010e4 <myproc>
    800017c2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800017c4:	00005097          	auipc	ra,0x5
    800017c8:	b14080e7          	jalr	-1260(ra) # 800062d8 <acquire>
  release(lk);
    800017cc:	854a                	mv	a0,s2
    800017ce:	00005097          	auipc	ra,0x5
    800017d2:	bbe080e7          	jalr	-1090(ra) # 8000638c <release>

  // Go to sleep.
  p->chan = chan;
    800017d6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800017da:	4789                	li	a5,2
    800017dc:	cc9c                	sw	a5,24(s1)

  sched();
    800017de:	00000097          	auipc	ra,0x0
    800017e2:	eb8080e7          	jalr	-328(ra) # 80001696 <sched>

  // Tidy up.
  p->chan = 0;
    800017e6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800017ea:	8526                	mv	a0,s1
    800017ec:	00005097          	auipc	ra,0x5
    800017f0:	ba0080e7          	jalr	-1120(ra) # 8000638c <release>
  acquire(lk);
    800017f4:	854a                	mv	a0,s2
    800017f6:	00005097          	auipc	ra,0x5
    800017fa:	ae2080e7          	jalr	-1310(ra) # 800062d8 <acquire>
}
    800017fe:	70a2                	ld	ra,40(sp)
    80001800:	7402                	ld	s0,32(sp)
    80001802:	64e2                	ld	s1,24(sp)
    80001804:	6942                	ld	s2,16(sp)
    80001806:	69a2                	ld	s3,8(sp)
    80001808:	6145                	addi	sp,sp,48
    8000180a:	8082                	ret

000000008000180c <wait>:
{
    8000180c:	715d                	addi	sp,sp,-80
    8000180e:	e486                	sd	ra,72(sp)
    80001810:	e0a2                	sd	s0,64(sp)
    80001812:	fc26                	sd	s1,56(sp)
    80001814:	f84a                	sd	s2,48(sp)
    80001816:	f44e                	sd	s3,40(sp)
    80001818:	f052                	sd	s4,32(sp)
    8000181a:	ec56                	sd	s5,24(sp)
    8000181c:	e85a                	sd	s6,16(sp)
    8000181e:	e45e                	sd	s7,8(sp)
    80001820:	e062                	sd	s8,0(sp)
    80001822:	0880                	addi	s0,sp,80
    80001824:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001826:	00000097          	auipc	ra,0x0
    8000182a:	8be080e7          	jalr	-1858(ra) # 800010e4 <myproc>
    8000182e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001830:	00228517          	auipc	a0,0x228
    80001834:	85850513          	addi	a0,a0,-1960 # 80229088 <wait_lock>
    80001838:	00005097          	auipc	ra,0x5
    8000183c:	aa0080e7          	jalr	-1376(ra) # 800062d8 <acquire>
    havekids = 0;
    80001840:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001842:	4a15                	li	s4,5
        havekids = 1;
    80001844:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001846:	0022d997          	auipc	s3,0x22d
    8000184a:	65a98993          	addi	s3,s3,1626 # 8022eea0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000184e:	00228c17          	auipc	s8,0x228
    80001852:	83ac0c13          	addi	s8,s8,-1990 # 80229088 <wait_lock>
    havekids = 0;
    80001856:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001858:	00228497          	auipc	s1,0x228
    8000185c:	c4848493          	addi	s1,s1,-952 # 802294a0 <proc>
    80001860:	a0bd                	j	800018ce <wait+0xc2>
          pid = np->pid;
    80001862:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001866:	000b0e63          	beqz	s6,80001882 <wait+0x76>
    8000186a:	4691                	li	a3,4
    8000186c:	02c48613          	addi	a2,s1,44
    80001870:	85da                	mv	a1,s6
    80001872:	05093503          	ld	a0,80(s2)
    80001876:	fffff097          	auipc	ra,0xfffff
    8000187a:	65c080e7          	jalr	1628(ra) # 80000ed2 <copyout>
    8000187e:	02054563          	bltz	a0,800018a8 <wait+0x9c>
          freeproc(np);
    80001882:	8526                	mv	a0,s1
    80001884:	00000097          	auipc	ra,0x0
    80001888:	a12080e7          	jalr	-1518(ra) # 80001296 <freeproc>
          release(&np->lock);
    8000188c:	8526                	mv	a0,s1
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	afe080e7          	jalr	-1282(ra) # 8000638c <release>
          release(&wait_lock);
    80001896:	00227517          	auipc	a0,0x227
    8000189a:	7f250513          	addi	a0,a0,2034 # 80229088 <wait_lock>
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	aee080e7          	jalr	-1298(ra) # 8000638c <release>
          return pid;
    800018a6:	a09d                	j	8000190c <wait+0x100>
            release(&np->lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	ae2080e7          	jalr	-1310(ra) # 8000638c <release>
            release(&wait_lock);
    800018b2:	00227517          	auipc	a0,0x227
    800018b6:	7d650513          	addi	a0,a0,2006 # 80229088 <wait_lock>
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	ad2080e7          	jalr	-1326(ra) # 8000638c <release>
            return -1;
    800018c2:	59fd                	li	s3,-1
    800018c4:	a0a1                	j	8000190c <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800018c6:	16848493          	addi	s1,s1,360
    800018ca:	03348463          	beq	s1,s3,800018f2 <wait+0xe6>
      if(np->parent == p){
    800018ce:	7c9c                	ld	a5,56(s1)
    800018d0:	ff279be3          	bne	a5,s2,800018c6 <wait+0xba>
        acquire(&np->lock);
    800018d4:	8526                	mv	a0,s1
    800018d6:	00005097          	auipc	ra,0x5
    800018da:	a02080e7          	jalr	-1534(ra) # 800062d8 <acquire>
        if(np->state == ZOMBIE){
    800018de:	4c9c                	lw	a5,24(s1)
    800018e0:	f94781e3          	beq	a5,s4,80001862 <wait+0x56>
        release(&np->lock);
    800018e4:	8526                	mv	a0,s1
    800018e6:	00005097          	auipc	ra,0x5
    800018ea:	aa6080e7          	jalr	-1370(ra) # 8000638c <release>
        havekids = 1;
    800018ee:	8756                	mv	a4,s5
    800018f0:	bfd9                	j	800018c6 <wait+0xba>
    if(!havekids || p->killed){
    800018f2:	c701                	beqz	a4,800018fa <wait+0xee>
    800018f4:	02892783          	lw	a5,40(s2)
    800018f8:	c79d                	beqz	a5,80001926 <wait+0x11a>
      release(&wait_lock);
    800018fa:	00227517          	auipc	a0,0x227
    800018fe:	78e50513          	addi	a0,a0,1934 # 80229088 <wait_lock>
    80001902:	00005097          	auipc	ra,0x5
    80001906:	a8a080e7          	jalr	-1398(ra) # 8000638c <release>
      return -1;
    8000190a:	59fd                	li	s3,-1
}
    8000190c:	854e                	mv	a0,s3
    8000190e:	60a6                	ld	ra,72(sp)
    80001910:	6406                	ld	s0,64(sp)
    80001912:	74e2                	ld	s1,56(sp)
    80001914:	7942                	ld	s2,48(sp)
    80001916:	79a2                	ld	s3,40(sp)
    80001918:	7a02                	ld	s4,32(sp)
    8000191a:	6ae2                	ld	s5,24(sp)
    8000191c:	6b42                	ld	s6,16(sp)
    8000191e:	6ba2                	ld	s7,8(sp)
    80001920:	6c02                	ld	s8,0(sp)
    80001922:	6161                	addi	sp,sp,80
    80001924:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001926:	85e2                	mv	a1,s8
    80001928:	854a                	mv	a0,s2
    8000192a:	00000097          	auipc	ra,0x0
    8000192e:	e7e080e7          	jalr	-386(ra) # 800017a8 <sleep>
    havekids = 0;
    80001932:	b715                	j	80001856 <wait+0x4a>

0000000080001934 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001934:	7139                	addi	sp,sp,-64
    80001936:	fc06                	sd	ra,56(sp)
    80001938:	f822                	sd	s0,48(sp)
    8000193a:	f426                	sd	s1,40(sp)
    8000193c:	f04a                	sd	s2,32(sp)
    8000193e:	ec4e                	sd	s3,24(sp)
    80001940:	e852                	sd	s4,16(sp)
    80001942:	e456                	sd	s5,8(sp)
    80001944:	0080                	addi	s0,sp,64
    80001946:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001948:	00228497          	auipc	s1,0x228
    8000194c:	b5848493          	addi	s1,s1,-1192 # 802294a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001950:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001952:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001954:	0022d917          	auipc	s2,0x22d
    80001958:	54c90913          	addi	s2,s2,1356 # 8022eea0 <tickslock>
    8000195c:	a811                	j	80001970 <wakeup+0x3c>
      }
      release(&p->lock);
    8000195e:	8526                	mv	a0,s1
    80001960:	00005097          	auipc	ra,0x5
    80001964:	a2c080e7          	jalr	-1492(ra) # 8000638c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001968:	16848493          	addi	s1,s1,360
    8000196c:	03248663          	beq	s1,s2,80001998 <wakeup+0x64>
    if(p != myproc()){
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	774080e7          	jalr	1908(ra) # 800010e4 <myproc>
    80001978:	fea488e3          	beq	s1,a0,80001968 <wakeup+0x34>
      acquire(&p->lock);
    8000197c:	8526                	mv	a0,s1
    8000197e:	00005097          	auipc	ra,0x5
    80001982:	95a080e7          	jalr	-1702(ra) # 800062d8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001986:	4c9c                	lw	a5,24(s1)
    80001988:	fd379be3          	bne	a5,s3,8000195e <wakeup+0x2a>
    8000198c:	709c                	ld	a5,32(s1)
    8000198e:	fd4798e3          	bne	a5,s4,8000195e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001992:	0154ac23          	sw	s5,24(s1)
    80001996:	b7e1                	j	8000195e <wakeup+0x2a>
    }
  }
}
    80001998:	70e2                	ld	ra,56(sp)
    8000199a:	7442                	ld	s0,48(sp)
    8000199c:	74a2                	ld	s1,40(sp)
    8000199e:	7902                	ld	s2,32(sp)
    800019a0:	69e2                	ld	s3,24(sp)
    800019a2:	6a42                	ld	s4,16(sp)
    800019a4:	6aa2                	ld	s5,8(sp)
    800019a6:	6121                	addi	sp,sp,64
    800019a8:	8082                	ret

00000000800019aa <reparent>:
{
    800019aa:	7179                	addi	sp,sp,-48
    800019ac:	f406                	sd	ra,40(sp)
    800019ae:	f022                	sd	s0,32(sp)
    800019b0:	ec26                	sd	s1,24(sp)
    800019b2:	e84a                	sd	s2,16(sp)
    800019b4:	e44e                	sd	s3,8(sp)
    800019b6:	e052                	sd	s4,0(sp)
    800019b8:	1800                	addi	s0,sp,48
    800019ba:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800019bc:	00228497          	auipc	s1,0x228
    800019c0:	ae448493          	addi	s1,s1,-1308 # 802294a0 <proc>
      pp->parent = initproc;
    800019c4:	00007a17          	auipc	s4,0x7
    800019c8:	64ca0a13          	addi	s4,s4,1612 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800019cc:	0022d997          	auipc	s3,0x22d
    800019d0:	4d498993          	addi	s3,s3,1236 # 8022eea0 <tickslock>
    800019d4:	a029                	j	800019de <reparent+0x34>
    800019d6:	16848493          	addi	s1,s1,360
    800019da:	01348d63          	beq	s1,s3,800019f4 <reparent+0x4a>
    if(pp->parent == p){
    800019de:	7c9c                	ld	a5,56(s1)
    800019e0:	ff279be3          	bne	a5,s2,800019d6 <reparent+0x2c>
      pp->parent = initproc;
    800019e4:	000a3503          	ld	a0,0(s4)
    800019e8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800019ea:	00000097          	auipc	ra,0x0
    800019ee:	f4a080e7          	jalr	-182(ra) # 80001934 <wakeup>
    800019f2:	b7d5                	j	800019d6 <reparent+0x2c>
}
    800019f4:	70a2                	ld	ra,40(sp)
    800019f6:	7402                	ld	s0,32(sp)
    800019f8:	64e2                	ld	s1,24(sp)
    800019fa:	6942                	ld	s2,16(sp)
    800019fc:	69a2                	ld	s3,8(sp)
    800019fe:	6a02                	ld	s4,0(sp)
    80001a00:	6145                	addi	sp,sp,48
    80001a02:	8082                	ret

0000000080001a04 <exit>:
{
    80001a04:	7179                	addi	sp,sp,-48
    80001a06:	f406                	sd	ra,40(sp)
    80001a08:	f022                	sd	s0,32(sp)
    80001a0a:	ec26                	sd	s1,24(sp)
    80001a0c:	e84a                	sd	s2,16(sp)
    80001a0e:	e44e                	sd	s3,8(sp)
    80001a10:	e052                	sd	s4,0(sp)
    80001a12:	1800                	addi	s0,sp,48
    80001a14:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001a16:	fffff097          	auipc	ra,0xfffff
    80001a1a:	6ce080e7          	jalr	1742(ra) # 800010e4 <myproc>
    80001a1e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001a20:	00007797          	auipc	a5,0x7
    80001a24:	5f07b783          	ld	a5,1520(a5) # 80009010 <initproc>
    80001a28:	0d050493          	addi	s1,a0,208
    80001a2c:	15050913          	addi	s2,a0,336
    80001a30:	02a79363          	bne	a5,a0,80001a56 <exit+0x52>
    panic("init exiting");
    80001a34:	00007517          	auipc	a0,0x7
    80001a38:	86450513          	addi	a0,a0,-1948 # 80008298 <etext+0x298>
    80001a3c:	00004097          	auipc	ra,0x4
    80001a40:	364080e7          	jalr	868(ra) # 80005da0 <panic>
      fileclose(f);
    80001a44:	00002097          	auipc	ra,0x2
    80001a48:	18c080e7          	jalr	396(ra) # 80003bd0 <fileclose>
      p->ofile[fd] = 0;
    80001a4c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001a50:	04a1                	addi	s1,s1,8
    80001a52:	01248563          	beq	s1,s2,80001a5c <exit+0x58>
    if(p->ofile[fd]){
    80001a56:	6088                	ld	a0,0(s1)
    80001a58:	f575                	bnez	a0,80001a44 <exit+0x40>
    80001a5a:	bfdd                	j	80001a50 <exit+0x4c>
  begin_op();
    80001a5c:	00002097          	auipc	ra,0x2
    80001a60:	cac080e7          	jalr	-852(ra) # 80003708 <begin_op>
  iput(p->cwd);
    80001a64:	1509b503          	ld	a0,336(s3)
    80001a68:	00001097          	auipc	ra,0x1
    80001a6c:	47e080e7          	jalr	1150(ra) # 80002ee6 <iput>
  end_op();
    80001a70:	00002097          	auipc	ra,0x2
    80001a74:	d16080e7          	jalr	-746(ra) # 80003786 <end_op>
  p->cwd = 0;
    80001a78:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001a7c:	00227497          	auipc	s1,0x227
    80001a80:	60c48493          	addi	s1,s1,1548 # 80229088 <wait_lock>
    80001a84:	8526                	mv	a0,s1
    80001a86:	00005097          	auipc	ra,0x5
    80001a8a:	852080e7          	jalr	-1966(ra) # 800062d8 <acquire>
  reparent(p);
    80001a8e:	854e                	mv	a0,s3
    80001a90:	00000097          	auipc	ra,0x0
    80001a94:	f1a080e7          	jalr	-230(ra) # 800019aa <reparent>
  wakeup(p->parent);
    80001a98:	0389b503          	ld	a0,56(s3)
    80001a9c:	00000097          	auipc	ra,0x0
    80001aa0:	e98080e7          	jalr	-360(ra) # 80001934 <wakeup>
  acquire(&p->lock);
    80001aa4:	854e                	mv	a0,s3
    80001aa6:	00005097          	auipc	ra,0x5
    80001aaa:	832080e7          	jalr	-1998(ra) # 800062d8 <acquire>
  p->xstate = status;
    80001aae:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001ab2:	4795                	li	a5,5
    80001ab4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001ab8:	8526                	mv	a0,s1
    80001aba:	00005097          	auipc	ra,0x5
    80001abe:	8d2080e7          	jalr	-1838(ra) # 8000638c <release>
  sched();
    80001ac2:	00000097          	auipc	ra,0x0
    80001ac6:	bd4080e7          	jalr	-1068(ra) # 80001696 <sched>
  panic("zombie exit");
    80001aca:	00006517          	auipc	a0,0x6
    80001ace:	7de50513          	addi	a0,a0,2014 # 800082a8 <etext+0x2a8>
    80001ad2:	00004097          	auipc	ra,0x4
    80001ad6:	2ce080e7          	jalr	718(ra) # 80005da0 <panic>

0000000080001ada <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001ada:	7179                	addi	sp,sp,-48
    80001adc:	f406                	sd	ra,40(sp)
    80001ade:	f022                	sd	s0,32(sp)
    80001ae0:	ec26                	sd	s1,24(sp)
    80001ae2:	e84a                	sd	s2,16(sp)
    80001ae4:	e44e                	sd	s3,8(sp)
    80001ae6:	1800                	addi	s0,sp,48
    80001ae8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001aea:	00228497          	auipc	s1,0x228
    80001aee:	9b648493          	addi	s1,s1,-1610 # 802294a0 <proc>
    80001af2:	0022d997          	auipc	s3,0x22d
    80001af6:	3ae98993          	addi	s3,s3,942 # 8022eea0 <tickslock>
    acquire(&p->lock);
    80001afa:	8526                	mv	a0,s1
    80001afc:	00004097          	auipc	ra,0x4
    80001b00:	7dc080e7          	jalr	2012(ra) # 800062d8 <acquire>
    if(p->pid == pid){
    80001b04:	589c                	lw	a5,48(s1)
    80001b06:	01278d63          	beq	a5,s2,80001b20 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001b0a:	8526                	mv	a0,s1
    80001b0c:	00005097          	auipc	ra,0x5
    80001b10:	880080e7          	jalr	-1920(ra) # 8000638c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b14:	16848493          	addi	s1,s1,360
    80001b18:	ff3491e3          	bne	s1,s3,80001afa <kill+0x20>
  }
  return -1;
    80001b1c:	557d                	li	a0,-1
    80001b1e:	a829                	j	80001b38 <kill+0x5e>
      p->killed = 1;
    80001b20:	4785                	li	a5,1
    80001b22:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001b24:	4c98                	lw	a4,24(s1)
    80001b26:	4789                	li	a5,2
    80001b28:	00f70f63          	beq	a4,a5,80001b46 <kill+0x6c>
      release(&p->lock);
    80001b2c:	8526                	mv	a0,s1
    80001b2e:	00005097          	auipc	ra,0x5
    80001b32:	85e080e7          	jalr	-1954(ra) # 8000638c <release>
      return 0;
    80001b36:	4501                	li	a0,0
}
    80001b38:	70a2                	ld	ra,40(sp)
    80001b3a:	7402                	ld	s0,32(sp)
    80001b3c:	64e2                	ld	s1,24(sp)
    80001b3e:	6942                	ld	s2,16(sp)
    80001b40:	69a2                	ld	s3,8(sp)
    80001b42:	6145                	addi	sp,sp,48
    80001b44:	8082                	ret
        p->state = RUNNABLE;
    80001b46:	478d                	li	a5,3
    80001b48:	cc9c                	sw	a5,24(s1)
    80001b4a:	b7cd                	j	80001b2c <kill+0x52>

0000000080001b4c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b4c:	7179                	addi	sp,sp,-48
    80001b4e:	f406                	sd	ra,40(sp)
    80001b50:	f022                	sd	s0,32(sp)
    80001b52:	ec26                	sd	s1,24(sp)
    80001b54:	e84a                	sd	s2,16(sp)
    80001b56:	e44e                	sd	s3,8(sp)
    80001b58:	e052                	sd	s4,0(sp)
    80001b5a:	1800                	addi	s0,sp,48
    80001b5c:	84aa                	mv	s1,a0
    80001b5e:	892e                	mv	s2,a1
    80001b60:	89b2                	mv	s3,a2
    80001b62:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b64:	fffff097          	auipc	ra,0xfffff
    80001b68:	580080e7          	jalr	1408(ra) # 800010e4 <myproc>
  if(user_dst){
    80001b6c:	c08d                	beqz	s1,80001b8e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b6e:	86d2                	mv	a3,s4
    80001b70:	864e                	mv	a2,s3
    80001b72:	85ca                	mv	a1,s2
    80001b74:	6928                	ld	a0,80(a0)
    80001b76:	fffff097          	auipc	ra,0xfffff
    80001b7a:	35c080e7          	jalr	860(ra) # 80000ed2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b7e:	70a2                	ld	ra,40(sp)
    80001b80:	7402                	ld	s0,32(sp)
    80001b82:	64e2                	ld	s1,24(sp)
    80001b84:	6942                	ld	s2,16(sp)
    80001b86:	69a2                	ld	s3,8(sp)
    80001b88:	6a02                	ld	s4,0(sp)
    80001b8a:	6145                	addi	sp,sp,48
    80001b8c:	8082                	ret
    memmove((char *)dst, src, len);
    80001b8e:	000a061b          	sext.w	a2,s4
    80001b92:	85ce                	mv	a1,s3
    80001b94:	854a                	mv	a0,s2
    80001b96:	ffffe097          	auipc	ra,0xffffe
    80001b9a:	764080e7          	jalr	1892(ra) # 800002fa <memmove>
    return 0;
    80001b9e:	8526                	mv	a0,s1
    80001ba0:	bff9                	j	80001b7e <either_copyout+0x32>

0000000080001ba2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ba2:	7179                	addi	sp,sp,-48
    80001ba4:	f406                	sd	ra,40(sp)
    80001ba6:	f022                	sd	s0,32(sp)
    80001ba8:	ec26                	sd	s1,24(sp)
    80001baa:	e84a                	sd	s2,16(sp)
    80001bac:	e44e                	sd	s3,8(sp)
    80001bae:	e052                	sd	s4,0(sp)
    80001bb0:	1800                	addi	s0,sp,48
    80001bb2:	892a                	mv	s2,a0
    80001bb4:	84ae                	mv	s1,a1
    80001bb6:	89b2                	mv	s3,a2
    80001bb8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001bba:	fffff097          	auipc	ra,0xfffff
    80001bbe:	52a080e7          	jalr	1322(ra) # 800010e4 <myproc>
  if(user_src){
    80001bc2:	c08d                	beqz	s1,80001be4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001bc4:	86d2                	mv	a3,s4
    80001bc6:	864e                	mv	a2,s3
    80001bc8:	85ca                	mv	a1,s2
    80001bca:	6928                	ld	a0,80(a0)
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	f8e080e7          	jalr	-114(ra) # 80000b5a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001bd4:	70a2                	ld	ra,40(sp)
    80001bd6:	7402                	ld	s0,32(sp)
    80001bd8:	64e2                	ld	s1,24(sp)
    80001bda:	6942                	ld	s2,16(sp)
    80001bdc:	69a2                	ld	s3,8(sp)
    80001bde:	6a02                	ld	s4,0(sp)
    80001be0:	6145                	addi	sp,sp,48
    80001be2:	8082                	ret
    memmove(dst, (char*)src, len);
    80001be4:	000a061b          	sext.w	a2,s4
    80001be8:	85ce                	mv	a1,s3
    80001bea:	854a                	mv	a0,s2
    80001bec:	ffffe097          	auipc	ra,0xffffe
    80001bf0:	70e080e7          	jalr	1806(ra) # 800002fa <memmove>
    return 0;
    80001bf4:	8526                	mv	a0,s1
    80001bf6:	bff9                	j	80001bd4 <either_copyin+0x32>

0000000080001bf8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001bf8:	715d                	addi	sp,sp,-80
    80001bfa:	e486                	sd	ra,72(sp)
    80001bfc:	e0a2                	sd	s0,64(sp)
    80001bfe:	fc26                	sd	s1,56(sp)
    80001c00:	f84a                	sd	s2,48(sp)
    80001c02:	f44e                	sd	s3,40(sp)
    80001c04:	f052                	sd	s4,32(sp)
    80001c06:	ec56                	sd	s5,24(sp)
    80001c08:	e85a                	sd	s6,16(sp)
    80001c0a:	e45e                	sd	s7,8(sp)
    80001c0c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001c0e:	00006517          	auipc	a0,0x6
    80001c12:	44250513          	addi	a0,a0,1090 # 80008050 <etext+0x50>
    80001c16:	00004097          	auipc	ra,0x4
    80001c1a:	1d4080e7          	jalr	468(ra) # 80005dea <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c1e:	00228497          	auipc	s1,0x228
    80001c22:	9da48493          	addi	s1,s1,-1574 # 802295f8 <proc+0x158>
    80001c26:	0022d917          	auipc	s2,0x22d
    80001c2a:	3d290913          	addi	s2,s2,978 # 8022eff8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c2e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c30:	00006997          	auipc	s3,0x6
    80001c34:	68898993          	addi	s3,s3,1672 # 800082b8 <etext+0x2b8>
    printf("%d %s %s", p->pid, state, p->name);
    80001c38:	00006a97          	auipc	s5,0x6
    80001c3c:	688a8a93          	addi	s5,s5,1672 # 800082c0 <etext+0x2c0>
    printf("\n");
    80001c40:	00006a17          	auipc	s4,0x6
    80001c44:	410a0a13          	addi	s4,s4,1040 # 80008050 <etext+0x50>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c48:	00006b97          	auipc	s7,0x6
    80001c4c:	6b0b8b93          	addi	s7,s7,1712 # 800082f8 <states.0>
    80001c50:	a00d                	j	80001c72 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c52:	ed86a583          	lw	a1,-296(a3)
    80001c56:	8556                	mv	a0,s5
    80001c58:	00004097          	auipc	ra,0x4
    80001c5c:	192080e7          	jalr	402(ra) # 80005dea <printf>
    printf("\n");
    80001c60:	8552                	mv	a0,s4
    80001c62:	00004097          	auipc	ra,0x4
    80001c66:	188080e7          	jalr	392(ra) # 80005dea <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c6a:	16848493          	addi	s1,s1,360
    80001c6e:	03248263          	beq	s1,s2,80001c92 <procdump+0x9a>
    if(p->state == UNUSED)
    80001c72:	86a6                	mv	a3,s1
    80001c74:	ec04a783          	lw	a5,-320(s1)
    80001c78:	dbed                	beqz	a5,80001c6a <procdump+0x72>
      state = "???";
    80001c7a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c7c:	fcfb6be3          	bltu	s6,a5,80001c52 <procdump+0x5a>
    80001c80:	02079713          	slli	a4,a5,0x20
    80001c84:	01d75793          	srli	a5,a4,0x1d
    80001c88:	97de                	add	a5,a5,s7
    80001c8a:	6390                	ld	a2,0(a5)
    80001c8c:	f279                	bnez	a2,80001c52 <procdump+0x5a>
      state = "???";
    80001c8e:	864e                	mv	a2,s3
    80001c90:	b7c9                	j	80001c52 <procdump+0x5a>
  }
}
    80001c92:	60a6                	ld	ra,72(sp)
    80001c94:	6406                	ld	s0,64(sp)
    80001c96:	74e2                	ld	s1,56(sp)
    80001c98:	7942                	ld	s2,48(sp)
    80001c9a:	79a2                	ld	s3,40(sp)
    80001c9c:	7a02                	ld	s4,32(sp)
    80001c9e:	6ae2                	ld	s5,24(sp)
    80001ca0:	6b42                	ld	s6,16(sp)
    80001ca2:	6ba2                	ld	s7,8(sp)
    80001ca4:	6161                	addi	sp,sp,80
    80001ca6:	8082                	ret

0000000080001ca8 <swtch>:
    80001ca8:	00153023          	sd	ra,0(a0)
    80001cac:	00253423          	sd	sp,8(a0)
    80001cb0:	e900                	sd	s0,16(a0)
    80001cb2:	ed04                	sd	s1,24(a0)
    80001cb4:	03253023          	sd	s2,32(a0)
    80001cb8:	03353423          	sd	s3,40(a0)
    80001cbc:	03453823          	sd	s4,48(a0)
    80001cc0:	03553c23          	sd	s5,56(a0)
    80001cc4:	05653023          	sd	s6,64(a0)
    80001cc8:	05753423          	sd	s7,72(a0)
    80001ccc:	05853823          	sd	s8,80(a0)
    80001cd0:	05953c23          	sd	s9,88(a0)
    80001cd4:	07a53023          	sd	s10,96(a0)
    80001cd8:	07b53423          	sd	s11,104(a0)
    80001cdc:	0005b083          	ld	ra,0(a1)
    80001ce0:	0085b103          	ld	sp,8(a1)
    80001ce4:	6980                	ld	s0,16(a1)
    80001ce6:	6d84                	ld	s1,24(a1)
    80001ce8:	0205b903          	ld	s2,32(a1)
    80001cec:	0285b983          	ld	s3,40(a1)
    80001cf0:	0305ba03          	ld	s4,48(a1)
    80001cf4:	0385ba83          	ld	s5,56(a1)
    80001cf8:	0405bb03          	ld	s6,64(a1)
    80001cfc:	0485bb83          	ld	s7,72(a1)
    80001d00:	0505bc03          	ld	s8,80(a1)
    80001d04:	0585bc83          	ld	s9,88(a1)
    80001d08:	0605bd03          	ld	s10,96(a1)
    80001d0c:	0685bd83          	ld	s11,104(a1)
    80001d10:	8082                	ret

0000000080001d12 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001d12:	1141                	addi	sp,sp,-16
    80001d14:	e406                	sd	ra,8(sp)
    80001d16:	e022                	sd	s0,0(sp)
    80001d18:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001d1a:	00006597          	auipc	a1,0x6
    80001d1e:	60e58593          	addi	a1,a1,1550 # 80008328 <states.0+0x30>
    80001d22:	0022d517          	auipc	a0,0x22d
    80001d26:	17e50513          	addi	a0,a0,382 # 8022eea0 <tickslock>
    80001d2a:	00004097          	auipc	ra,0x4
    80001d2e:	51e080e7          	jalr	1310(ra) # 80006248 <initlock>
}
    80001d32:	60a2                	ld	ra,8(sp)
    80001d34:	6402                	ld	s0,0(sp)
    80001d36:	0141                	addi	sp,sp,16
    80001d38:	8082                	ret

0000000080001d3a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d3a:	1141                	addi	sp,sp,-16
    80001d3c:	e422                	sd	s0,8(sp)
    80001d3e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d40:	00003797          	auipc	a5,0x3
    80001d44:	4c078793          	addi	a5,a5,1216 # 80005200 <kernelvec>
    80001d48:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d4c:	6422                	ld	s0,8(sp)
    80001d4e:	0141                	addi	sp,sp,16
    80001d50:	8082                	ret

0000000080001d52 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d52:	1141                	addi	sp,sp,-16
    80001d54:	e406                	sd	ra,8(sp)
    80001d56:	e022                	sd	s0,0(sp)
    80001d58:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d5a:	fffff097          	auipc	ra,0xfffff
    80001d5e:	38a080e7          	jalr	906(ra) # 800010e4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d66:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d68:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001d6c:	00005697          	auipc	a3,0x5
    80001d70:	29468693          	addi	a3,a3,660 # 80007000 <_trampoline>
    80001d74:	00005717          	auipc	a4,0x5
    80001d78:	28c70713          	addi	a4,a4,652 # 80007000 <_trampoline>
    80001d7c:	8f15                	sub	a4,a4,a3
    80001d7e:	040007b7          	lui	a5,0x4000
    80001d82:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d84:	07b2                	slli	a5,a5,0xc
    80001d86:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d88:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d8c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d8e:	18002673          	csrr	a2,satp
    80001d92:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d94:	6d30                	ld	a2,88(a0)
    80001d96:	6138                	ld	a4,64(a0)
    80001d98:	6585                	lui	a1,0x1
    80001d9a:	972e                	add	a4,a4,a1
    80001d9c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d9e:	6d38                	ld	a4,88(a0)
    80001da0:	00000617          	auipc	a2,0x0
    80001da4:	13860613          	addi	a2,a2,312 # 80001ed8 <usertrap>
    80001da8:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001daa:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dac:	8612                	mv	a2,tp
    80001dae:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db0:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001db4:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001db8:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dbc:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001dc0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dc2:	6f18                	ld	a4,24(a4)
    80001dc4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001dc8:	692c                	ld	a1,80(a0)
    80001dca:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001dcc:	00005717          	auipc	a4,0x5
    80001dd0:	2c470713          	addi	a4,a4,708 # 80007090 <userret>
    80001dd4:	8f15                	sub	a4,a4,a3
    80001dd6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001dd8:	577d                	li	a4,-1
    80001dda:	177e                	slli	a4,a4,0x3f
    80001ddc:	8dd9                	or	a1,a1,a4
    80001dde:	02000537          	lui	a0,0x2000
    80001de2:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001de4:	0536                	slli	a0,a0,0xd
    80001de6:	9782                	jalr	a5
}
    80001de8:	60a2                	ld	ra,8(sp)
    80001dea:	6402                	ld	s0,0(sp)
    80001dec:	0141                	addi	sp,sp,16
    80001dee:	8082                	ret

0000000080001df0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001df0:	1101                	addi	sp,sp,-32
    80001df2:	ec06                	sd	ra,24(sp)
    80001df4:	e822                	sd	s0,16(sp)
    80001df6:	e426                	sd	s1,8(sp)
    80001df8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001dfa:	0022d497          	auipc	s1,0x22d
    80001dfe:	0a648493          	addi	s1,s1,166 # 8022eea0 <tickslock>
    80001e02:	8526                	mv	a0,s1
    80001e04:	00004097          	auipc	ra,0x4
    80001e08:	4d4080e7          	jalr	1236(ra) # 800062d8 <acquire>
  ticks++;
    80001e0c:	00007517          	auipc	a0,0x7
    80001e10:	20c50513          	addi	a0,a0,524 # 80009018 <ticks>
    80001e14:	411c                	lw	a5,0(a0)
    80001e16:	2785                	addiw	a5,a5,1
    80001e18:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e1a:	00000097          	auipc	ra,0x0
    80001e1e:	b1a080e7          	jalr	-1254(ra) # 80001934 <wakeup>
  release(&tickslock);
    80001e22:	8526                	mv	a0,s1
    80001e24:	00004097          	auipc	ra,0x4
    80001e28:	568080e7          	jalr	1384(ra) # 8000638c <release>
}
    80001e2c:	60e2                	ld	ra,24(sp)
    80001e2e:	6442                	ld	s0,16(sp)
    80001e30:	64a2                	ld	s1,8(sp)
    80001e32:	6105                	addi	sp,sp,32
    80001e34:	8082                	ret

0000000080001e36 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001e36:	1101                	addi	sp,sp,-32
    80001e38:	ec06                	sd	ra,24(sp)
    80001e3a:	e822                	sd	s0,16(sp)
    80001e3c:	e426                	sd	s1,8(sp)
    80001e3e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e40:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001e44:	00074d63          	bltz	a4,80001e5e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001e48:	57fd                	li	a5,-1
    80001e4a:	17fe                	slli	a5,a5,0x3f
    80001e4c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e4e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e50:	06f70363          	beq	a4,a5,80001eb6 <devintr+0x80>
  }
}
    80001e54:	60e2                	ld	ra,24(sp)
    80001e56:	6442                	ld	s0,16(sp)
    80001e58:	64a2                	ld	s1,8(sp)
    80001e5a:	6105                	addi	sp,sp,32
    80001e5c:	8082                	ret
     (scause & 0xff) == 9){
    80001e5e:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001e62:	46a5                	li	a3,9
    80001e64:	fed792e3          	bne	a5,a3,80001e48 <devintr+0x12>
    int irq = plic_claim();
    80001e68:	00003097          	auipc	ra,0x3
    80001e6c:	4a0080e7          	jalr	1184(ra) # 80005308 <plic_claim>
    80001e70:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e72:	47a9                	li	a5,10
    80001e74:	02f50763          	beq	a0,a5,80001ea2 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001e78:	4785                	li	a5,1
    80001e7a:	02f50963          	beq	a0,a5,80001eac <devintr+0x76>
    return 1;
    80001e7e:	4505                	li	a0,1
    } else if(irq){
    80001e80:	d8f1                	beqz	s1,80001e54 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e82:	85a6                	mv	a1,s1
    80001e84:	00006517          	auipc	a0,0x6
    80001e88:	4ac50513          	addi	a0,a0,1196 # 80008330 <states.0+0x38>
    80001e8c:	00004097          	auipc	ra,0x4
    80001e90:	f5e080e7          	jalr	-162(ra) # 80005dea <printf>
      plic_complete(irq);
    80001e94:	8526                	mv	a0,s1
    80001e96:	00003097          	auipc	ra,0x3
    80001e9a:	496080e7          	jalr	1174(ra) # 8000532c <plic_complete>
    return 1;
    80001e9e:	4505                	li	a0,1
    80001ea0:	bf55                	j	80001e54 <devintr+0x1e>
      uartintr();
    80001ea2:	00004097          	auipc	ra,0x4
    80001ea6:	356080e7          	jalr	854(ra) # 800061f8 <uartintr>
    80001eaa:	b7ed                	j	80001e94 <devintr+0x5e>
      virtio_disk_intr();
    80001eac:	00004097          	auipc	ra,0x4
    80001eb0:	90c080e7          	jalr	-1780(ra) # 800057b8 <virtio_disk_intr>
    80001eb4:	b7c5                	j	80001e94 <devintr+0x5e>
    if(cpuid() == 0){
    80001eb6:	fffff097          	auipc	ra,0xfffff
    80001eba:	202080e7          	jalr	514(ra) # 800010b8 <cpuid>
    80001ebe:	c901                	beqz	a0,80001ece <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ec0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ec4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ec6:	14479073          	csrw	sip,a5
    return 2;
    80001eca:	4509                	li	a0,2
    80001ecc:	b761                	j	80001e54 <devintr+0x1e>
      clockintr();
    80001ece:	00000097          	auipc	ra,0x0
    80001ed2:	f22080e7          	jalr	-222(ra) # 80001df0 <clockintr>
    80001ed6:	b7ed                	j	80001ec0 <devintr+0x8a>

0000000080001ed8 <usertrap>:
{
    80001ed8:	1101                	addi	sp,sp,-32
    80001eda:	ec06                	sd	ra,24(sp)
    80001edc:	e822                	sd	s0,16(sp)
    80001ede:	e426                	sd	s1,8(sp)
    80001ee0:	e04a                	sd	s2,0(sp)
    80001ee2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ee8:	1007f793          	andi	a5,a5,256
    80001eec:	e3b9                	bnez	a5,80001f32 <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001eee:	00003797          	auipc	a5,0x3
    80001ef2:	31278793          	addi	a5,a5,786 # 80005200 <kernelvec>
    80001ef6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001efa:	fffff097          	auipc	ra,0xfffff
    80001efe:	1ea080e7          	jalr	490(ra) # 800010e4 <myproc>
    80001f02:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f04:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f06:	14102773          	csrr	a4,sepc
    80001f0a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f0c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001f10:	47a1                	li	a5,8
    80001f12:	02f70863          	beq	a4,a5,80001f42 <usertrap+0x6a>
    80001f16:	14202773          	csrr	a4,scause
     else if (r_scause() == 15)
    80001f1a:	47bd                	li	a5,15
    80001f1c:	06f70563          	beq	a4,a5,80001f86 <usertrap+0xae>
  else if((which_dev = devintr()) != 0){
    80001f20:	00000097          	auipc	ra,0x0
    80001f24:	f16080e7          	jalr	-234(ra) # 80001e36 <devintr>
    80001f28:	892a                	mv	s2,a0
    80001f2a:	c925                	beqz	a0,80001f9a <usertrap+0xc2>
  if(p->killed)
    80001f2c:	549c                	lw	a5,40(s1)
    80001f2e:	c7cd                	beqz	a5,80001fd8 <usertrap+0x100>
    80001f30:	a879                	j	80001fce <usertrap+0xf6>
    panic("usertrap: not from user mode");
    80001f32:	00006517          	auipc	a0,0x6
    80001f36:	41e50513          	addi	a0,a0,1054 # 80008350 <states.0+0x58>
    80001f3a:	00004097          	auipc	ra,0x4
    80001f3e:	e66080e7          	jalr	-410(ra) # 80005da0 <panic>
    if(p->killed)
    80001f42:	551c                	lw	a5,40(a0)
    80001f44:	eb9d                	bnez	a5,80001f7a <usertrap+0xa2>
    p->trapframe->epc += 4;
    80001f46:	6cb8                	ld	a4,88(s1)
    80001f48:	6f1c                	ld	a5,24(a4)
    80001f4a:	0791                	addi	a5,a5,4
    80001f4c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f4e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f52:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f56:	10079073          	csrw	sstatus,a5
    syscall();
    80001f5a:	00000097          	auipc	ra,0x0
    80001f5e:	2d4080e7          	jalr	724(ra) # 8000222e <syscall>
  if(p->killed)
    80001f62:	549c                	lw	a5,40(s1)
    80001f64:	e3d1                	bnez	a5,80001fe8 <usertrap+0x110>
  usertrapret();
    80001f66:	00000097          	auipc	ra,0x0
    80001f6a:	dec080e7          	jalr	-532(ra) # 80001d52 <usertrapret>
}
    80001f6e:	60e2                	ld	ra,24(sp)
    80001f70:	6442                	ld	s0,16(sp)
    80001f72:	64a2                	ld	s1,8(sp)
    80001f74:	6902                	ld	s2,0(sp)
    80001f76:	6105                	addi	sp,sp,32
    80001f78:	8082                	ret
      exit(-1);
    80001f7a:	557d                	li	a0,-1
    80001f7c:	00000097          	auipc	ra,0x0
    80001f80:	a88080e7          	jalr	-1400(ra) # 80001a04 <exit>
    80001f84:	b7c9                	j	80001f46 <usertrap+0x6e>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f86:	14302573          	csrr	a0,stval
        int res = address_translation_wiht_cow_page(va, p->pagetable); // 进行地址转换
    80001f8a:	68ac                	ld	a1,80(s1)
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	de6080e7          	jalr	-538(ra) # 80000d72 <address_translation_wiht_cow_page>
        if (res < 0)
    80001f94:	fc0557e3          	bgez	a0,80001f62 <usertrap+0x8a>
    80001f98:	a805                	j	80001fc8 <usertrap+0xf0>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f9a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f9e:	5890                	lw	a2,48(s1)
    80001fa0:	00006517          	auipc	a0,0x6
    80001fa4:	3d050513          	addi	a0,a0,976 # 80008370 <states.0+0x78>
    80001fa8:	00004097          	auipc	ra,0x4
    80001fac:	e42080e7          	jalr	-446(ra) # 80005dea <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fb0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fb4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fb8:	00006517          	auipc	a0,0x6
    80001fbc:	3e850513          	addi	a0,a0,1000 # 800083a0 <states.0+0xa8>
    80001fc0:	00004097          	auipc	ra,0x4
    80001fc4:	e2a080e7          	jalr	-470(ra) # 80005dea <printf>
    p->killed = 1;
    80001fc8:	4785                	li	a5,1
    80001fca:	d49c                	sw	a5,40(s1)
    80001fcc:	4901                	li	s2,0
    exit(-1);
    80001fce:	557d                	li	a0,-1
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	a34080e7          	jalr	-1484(ra) # 80001a04 <exit>
  if(which_dev == 2)
    80001fd8:	4789                	li	a5,2
    80001fda:	f8f916e3          	bne	s2,a5,80001f66 <usertrap+0x8e>
    yield();
    80001fde:	fffff097          	auipc	ra,0xfffff
    80001fe2:	78e080e7          	jalr	1934(ra) # 8000176c <yield>
    80001fe6:	b741                	j	80001f66 <usertrap+0x8e>
  if(p->killed)
    80001fe8:	4901                	li	s2,0
    80001fea:	b7d5                	j	80001fce <usertrap+0xf6>

0000000080001fec <kerneltrap>:
{
    80001fec:	7179                	addi	sp,sp,-48
    80001fee:	f406                	sd	ra,40(sp)
    80001ff0:	f022                	sd	s0,32(sp)
    80001ff2:	ec26                	sd	s1,24(sp)
    80001ff4:	e84a                	sd	s2,16(sp)
    80001ff6:	e44e                	sd	s3,8(sp)
    80001ff8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ffa:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ffe:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002002:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002006:	1004f793          	andi	a5,s1,256
    8000200a:	cb85                	beqz	a5,8000203a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000200c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002010:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002012:	ef85                	bnez	a5,8000204a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002014:	00000097          	auipc	ra,0x0
    80002018:	e22080e7          	jalr	-478(ra) # 80001e36 <devintr>
    8000201c:	cd1d                	beqz	a0,8000205a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000201e:	4789                	li	a5,2
    80002020:	06f50a63          	beq	a0,a5,80002094 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002024:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002028:	10049073          	csrw	sstatus,s1
}
    8000202c:	70a2                	ld	ra,40(sp)
    8000202e:	7402                	ld	s0,32(sp)
    80002030:	64e2                	ld	s1,24(sp)
    80002032:	6942                	ld	s2,16(sp)
    80002034:	69a2                	ld	s3,8(sp)
    80002036:	6145                	addi	sp,sp,48
    80002038:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000203a:	00006517          	auipc	a0,0x6
    8000203e:	38650513          	addi	a0,a0,902 # 800083c0 <states.0+0xc8>
    80002042:	00004097          	auipc	ra,0x4
    80002046:	d5e080e7          	jalr	-674(ra) # 80005da0 <panic>
    panic("kerneltrap: interrupts enabled");
    8000204a:	00006517          	auipc	a0,0x6
    8000204e:	39e50513          	addi	a0,a0,926 # 800083e8 <states.0+0xf0>
    80002052:	00004097          	auipc	ra,0x4
    80002056:	d4e080e7          	jalr	-690(ra) # 80005da0 <panic>
    printf("scause %p\n", scause);
    8000205a:	85ce                	mv	a1,s3
    8000205c:	00006517          	auipc	a0,0x6
    80002060:	3ac50513          	addi	a0,a0,940 # 80008408 <states.0+0x110>
    80002064:	00004097          	auipc	ra,0x4
    80002068:	d86080e7          	jalr	-634(ra) # 80005dea <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000206c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002070:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002074:	00006517          	auipc	a0,0x6
    80002078:	3a450513          	addi	a0,a0,932 # 80008418 <states.0+0x120>
    8000207c:	00004097          	auipc	ra,0x4
    80002080:	d6e080e7          	jalr	-658(ra) # 80005dea <printf>
    panic("kerneltrap");
    80002084:	00006517          	auipc	a0,0x6
    80002088:	3ac50513          	addi	a0,a0,940 # 80008430 <states.0+0x138>
    8000208c:	00004097          	auipc	ra,0x4
    80002090:	d14080e7          	jalr	-748(ra) # 80005da0 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002094:	fffff097          	auipc	ra,0xfffff
    80002098:	050080e7          	jalr	80(ra) # 800010e4 <myproc>
    8000209c:	d541                	beqz	a0,80002024 <kerneltrap+0x38>
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	046080e7          	jalr	70(ra) # 800010e4 <myproc>
    800020a6:	4d18                	lw	a4,24(a0)
    800020a8:	4791                	li	a5,4
    800020aa:	f6f71de3          	bne	a4,a5,80002024 <kerneltrap+0x38>
    yield();
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	6be080e7          	jalr	1726(ra) # 8000176c <yield>
    800020b6:	b7bd                	j	80002024 <kerneltrap+0x38>

00000000800020b8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800020b8:	1101                	addi	sp,sp,-32
    800020ba:	ec06                	sd	ra,24(sp)
    800020bc:	e822                	sd	s0,16(sp)
    800020be:	e426                	sd	s1,8(sp)
    800020c0:	1000                	addi	s0,sp,32
    800020c2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020c4:	fffff097          	auipc	ra,0xfffff
    800020c8:	020080e7          	jalr	32(ra) # 800010e4 <myproc>
  switch (n) {
    800020cc:	4795                	li	a5,5
    800020ce:	0497e163          	bltu	a5,s1,80002110 <argraw+0x58>
    800020d2:	048a                	slli	s1,s1,0x2
    800020d4:	00006717          	auipc	a4,0x6
    800020d8:	39470713          	addi	a4,a4,916 # 80008468 <states.0+0x170>
    800020dc:	94ba                	add	s1,s1,a4
    800020de:	409c                	lw	a5,0(s1)
    800020e0:	97ba                	add	a5,a5,a4
    800020e2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020e4:	6d3c                	ld	a5,88(a0)
    800020e6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020e8:	60e2                	ld	ra,24(sp)
    800020ea:	6442                	ld	s0,16(sp)
    800020ec:	64a2                	ld	s1,8(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret
    return p->trapframe->a1;
    800020f2:	6d3c                	ld	a5,88(a0)
    800020f4:	7fa8                	ld	a0,120(a5)
    800020f6:	bfcd                	j	800020e8 <argraw+0x30>
    return p->trapframe->a2;
    800020f8:	6d3c                	ld	a5,88(a0)
    800020fa:	63c8                	ld	a0,128(a5)
    800020fc:	b7f5                	j	800020e8 <argraw+0x30>
    return p->trapframe->a3;
    800020fe:	6d3c                	ld	a5,88(a0)
    80002100:	67c8                	ld	a0,136(a5)
    80002102:	b7dd                	j	800020e8 <argraw+0x30>
    return p->trapframe->a4;
    80002104:	6d3c                	ld	a5,88(a0)
    80002106:	6bc8                	ld	a0,144(a5)
    80002108:	b7c5                	j	800020e8 <argraw+0x30>
    return p->trapframe->a5;
    8000210a:	6d3c                	ld	a5,88(a0)
    8000210c:	6fc8                	ld	a0,152(a5)
    8000210e:	bfe9                	j	800020e8 <argraw+0x30>
  panic("argraw");
    80002110:	00006517          	auipc	a0,0x6
    80002114:	33050513          	addi	a0,a0,816 # 80008440 <states.0+0x148>
    80002118:	00004097          	auipc	ra,0x4
    8000211c:	c88080e7          	jalr	-888(ra) # 80005da0 <panic>

0000000080002120 <fetchaddr>:
{
    80002120:	1101                	addi	sp,sp,-32
    80002122:	ec06                	sd	ra,24(sp)
    80002124:	e822                	sd	s0,16(sp)
    80002126:	e426                	sd	s1,8(sp)
    80002128:	e04a                	sd	s2,0(sp)
    8000212a:	1000                	addi	s0,sp,32
    8000212c:	84aa                	mv	s1,a0
    8000212e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	fb4080e7          	jalr	-76(ra) # 800010e4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002138:	653c                	ld	a5,72(a0)
    8000213a:	02f4f863          	bgeu	s1,a5,8000216a <fetchaddr+0x4a>
    8000213e:	00848713          	addi	a4,s1,8
    80002142:	02e7e663          	bltu	a5,a4,8000216e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002146:	46a1                	li	a3,8
    80002148:	8626                	mv	a2,s1
    8000214a:	85ca                	mv	a1,s2
    8000214c:	6928                	ld	a0,80(a0)
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	a0c080e7          	jalr	-1524(ra) # 80000b5a <copyin>
    80002156:	00a03533          	snez	a0,a0
    8000215a:	40a00533          	neg	a0,a0
}
    8000215e:	60e2                	ld	ra,24(sp)
    80002160:	6442                	ld	s0,16(sp)
    80002162:	64a2                	ld	s1,8(sp)
    80002164:	6902                	ld	s2,0(sp)
    80002166:	6105                	addi	sp,sp,32
    80002168:	8082                	ret
    return -1;
    8000216a:	557d                	li	a0,-1
    8000216c:	bfcd                	j	8000215e <fetchaddr+0x3e>
    8000216e:	557d                	li	a0,-1
    80002170:	b7fd                	j	8000215e <fetchaddr+0x3e>

0000000080002172 <fetchstr>:
{
    80002172:	7179                	addi	sp,sp,-48
    80002174:	f406                	sd	ra,40(sp)
    80002176:	f022                	sd	s0,32(sp)
    80002178:	ec26                	sd	s1,24(sp)
    8000217a:	e84a                	sd	s2,16(sp)
    8000217c:	e44e                	sd	s3,8(sp)
    8000217e:	1800                	addi	s0,sp,48
    80002180:	892a                	mv	s2,a0
    80002182:	84ae                	mv	s1,a1
    80002184:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002186:	fffff097          	auipc	ra,0xfffff
    8000218a:	f5e080e7          	jalr	-162(ra) # 800010e4 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000218e:	86ce                	mv	a3,s3
    80002190:	864a                	mv	a2,s2
    80002192:	85a6                	mv	a1,s1
    80002194:	6928                	ld	a0,80(a0)
    80002196:	fffff097          	auipc	ra,0xfffff
    8000219a:	a52080e7          	jalr	-1454(ra) # 80000be8 <copyinstr>
  if(err < 0)
    8000219e:	00054763          	bltz	a0,800021ac <fetchstr+0x3a>
  return strlen(buf);
    800021a2:	8526                	mv	a0,s1
    800021a4:	ffffe097          	auipc	ra,0xffffe
    800021a8:	276080e7          	jalr	630(ra) # 8000041a <strlen>
}
    800021ac:	70a2                	ld	ra,40(sp)
    800021ae:	7402                	ld	s0,32(sp)
    800021b0:	64e2                	ld	s1,24(sp)
    800021b2:	6942                	ld	s2,16(sp)
    800021b4:	69a2                	ld	s3,8(sp)
    800021b6:	6145                	addi	sp,sp,48
    800021b8:	8082                	ret

00000000800021ba <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800021ba:	1101                	addi	sp,sp,-32
    800021bc:	ec06                	sd	ra,24(sp)
    800021be:	e822                	sd	s0,16(sp)
    800021c0:	e426                	sd	s1,8(sp)
    800021c2:	1000                	addi	s0,sp,32
    800021c4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021c6:	00000097          	auipc	ra,0x0
    800021ca:	ef2080e7          	jalr	-270(ra) # 800020b8 <argraw>
    800021ce:	c088                	sw	a0,0(s1)
  return 0;
}
    800021d0:	4501                	li	a0,0
    800021d2:	60e2                	ld	ra,24(sp)
    800021d4:	6442                	ld	s0,16(sp)
    800021d6:	64a2                	ld	s1,8(sp)
    800021d8:	6105                	addi	sp,sp,32
    800021da:	8082                	ret

00000000800021dc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800021dc:	1101                	addi	sp,sp,-32
    800021de:	ec06                	sd	ra,24(sp)
    800021e0:	e822                	sd	s0,16(sp)
    800021e2:	e426                	sd	s1,8(sp)
    800021e4:	1000                	addi	s0,sp,32
    800021e6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	ed0080e7          	jalr	-304(ra) # 800020b8 <argraw>
    800021f0:	e088                	sd	a0,0(s1)
  return 0;
}
    800021f2:	4501                	li	a0,0
    800021f4:	60e2                	ld	ra,24(sp)
    800021f6:	6442                	ld	s0,16(sp)
    800021f8:	64a2                	ld	s1,8(sp)
    800021fa:	6105                	addi	sp,sp,32
    800021fc:	8082                	ret

00000000800021fe <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021fe:	1101                	addi	sp,sp,-32
    80002200:	ec06                	sd	ra,24(sp)
    80002202:	e822                	sd	s0,16(sp)
    80002204:	e426                	sd	s1,8(sp)
    80002206:	e04a                	sd	s2,0(sp)
    80002208:	1000                	addi	s0,sp,32
    8000220a:	84ae                	mv	s1,a1
    8000220c:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000220e:	00000097          	auipc	ra,0x0
    80002212:	eaa080e7          	jalr	-342(ra) # 800020b8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002216:	864a                	mv	a2,s2
    80002218:	85a6                	mv	a1,s1
    8000221a:	00000097          	auipc	ra,0x0
    8000221e:	f58080e7          	jalr	-168(ra) # 80002172 <fetchstr>
}
    80002222:	60e2                	ld	ra,24(sp)
    80002224:	6442                	ld	s0,16(sp)
    80002226:	64a2                	ld	s1,8(sp)
    80002228:	6902                	ld	s2,0(sp)
    8000222a:	6105                	addi	sp,sp,32
    8000222c:	8082                	ret

000000008000222e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000222e:	1101                	addi	sp,sp,-32
    80002230:	ec06                	sd	ra,24(sp)
    80002232:	e822                	sd	s0,16(sp)
    80002234:	e426                	sd	s1,8(sp)
    80002236:	e04a                	sd	s2,0(sp)
    80002238:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	eaa080e7          	jalr	-342(ra) # 800010e4 <myproc>
    80002242:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002244:	05853903          	ld	s2,88(a0)
    80002248:	0a893783          	ld	a5,168(s2)
    8000224c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002250:	37fd                	addiw	a5,a5,-1
    80002252:	4751                	li	a4,20
    80002254:	00f76f63          	bltu	a4,a5,80002272 <syscall+0x44>
    80002258:	00369713          	slli	a4,a3,0x3
    8000225c:	00006797          	auipc	a5,0x6
    80002260:	22478793          	addi	a5,a5,548 # 80008480 <syscalls>
    80002264:	97ba                	add	a5,a5,a4
    80002266:	639c                	ld	a5,0(a5)
    80002268:	c789                	beqz	a5,80002272 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000226a:	9782                	jalr	a5
    8000226c:	06a93823          	sd	a0,112(s2)
    80002270:	a839                	j	8000228e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002272:	15848613          	addi	a2,s1,344
    80002276:	588c                	lw	a1,48(s1)
    80002278:	00006517          	auipc	a0,0x6
    8000227c:	1d050513          	addi	a0,a0,464 # 80008448 <states.0+0x150>
    80002280:	00004097          	auipc	ra,0x4
    80002284:	b6a080e7          	jalr	-1174(ra) # 80005dea <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002288:	6cbc                	ld	a5,88(s1)
    8000228a:	577d                	li	a4,-1
    8000228c:	fbb8                	sd	a4,112(a5)
  }
}
    8000228e:	60e2                	ld	ra,24(sp)
    80002290:	6442                	ld	s0,16(sp)
    80002292:	64a2                	ld	s1,8(sp)
    80002294:	6902                	ld	s2,0(sp)
    80002296:	6105                	addi	sp,sp,32
    80002298:	8082                	ret

000000008000229a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000229a:	1101                	addi	sp,sp,-32
    8000229c:	ec06                	sd	ra,24(sp)
    8000229e:	e822                	sd	s0,16(sp)
    800022a0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800022a2:	fec40593          	addi	a1,s0,-20
    800022a6:	4501                	li	a0,0
    800022a8:	00000097          	auipc	ra,0x0
    800022ac:	f12080e7          	jalr	-238(ra) # 800021ba <argint>
    return -1;
    800022b0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022b2:	00054963          	bltz	a0,800022c4 <sys_exit+0x2a>
  exit(n);
    800022b6:	fec42503          	lw	a0,-20(s0)
    800022ba:	fffff097          	auipc	ra,0xfffff
    800022be:	74a080e7          	jalr	1866(ra) # 80001a04 <exit>
  return 0;  // not reached
    800022c2:	4781                	li	a5,0
}
    800022c4:	853e                	mv	a0,a5
    800022c6:	60e2                	ld	ra,24(sp)
    800022c8:	6442                	ld	s0,16(sp)
    800022ca:	6105                	addi	sp,sp,32
    800022cc:	8082                	ret

00000000800022ce <sys_getpid>:

uint64
sys_getpid(void)
{
    800022ce:	1141                	addi	sp,sp,-16
    800022d0:	e406                	sd	ra,8(sp)
    800022d2:	e022                	sd	s0,0(sp)
    800022d4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	e0e080e7          	jalr	-498(ra) # 800010e4 <myproc>
}
    800022de:	5908                	lw	a0,48(a0)
    800022e0:	60a2                	ld	ra,8(sp)
    800022e2:	6402                	ld	s0,0(sp)
    800022e4:	0141                	addi	sp,sp,16
    800022e6:	8082                	ret

00000000800022e8 <sys_fork>:

uint64
sys_fork(void)
{
    800022e8:	1141                	addi	sp,sp,-16
    800022ea:	e406                	sd	ra,8(sp)
    800022ec:	e022                	sd	s0,0(sp)
    800022ee:	0800                	addi	s0,sp,16
  return fork();
    800022f0:	fffff097          	auipc	ra,0xfffff
    800022f4:	1c6080e7          	jalr	454(ra) # 800014b6 <fork>
}
    800022f8:	60a2                	ld	ra,8(sp)
    800022fa:	6402                	ld	s0,0(sp)
    800022fc:	0141                	addi	sp,sp,16
    800022fe:	8082                	ret

0000000080002300 <sys_wait>:

uint64
sys_wait(void)
{
    80002300:	1101                	addi	sp,sp,-32
    80002302:	ec06                	sd	ra,24(sp)
    80002304:	e822                	sd	s0,16(sp)
    80002306:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002308:	fe840593          	addi	a1,s0,-24
    8000230c:	4501                	li	a0,0
    8000230e:	00000097          	auipc	ra,0x0
    80002312:	ece080e7          	jalr	-306(ra) # 800021dc <argaddr>
    80002316:	87aa                	mv	a5,a0
    return -1;
    80002318:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000231a:	0007c863          	bltz	a5,8000232a <sys_wait+0x2a>
  return wait(p);
    8000231e:	fe843503          	ld	a0,-24(s0)
    80002322:	fffff097          	auipc	ra,0xfffff
    80002326:	4ea080e7          	jalr	1258(ra) # 8000180c <wait>
}
    8000232a:	60e2                	ld	ra,24(sp)
    8000232c:	6442                	ld	s0,16(sp)
    8000232e:	6105                	addi	sp,sp,32
    80002330:	8082                	ret

0000000080002332 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002332:	7179                	addi	sp,sp,-48
    80002334:	f406                	sd	ra,40(sp)
    80002336:	f022                	sd	s0,32(sp)
    80002338:	ec26                	sd	s1,24(sp)
    8000233a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000233c:	fdc40593          	addi	a1,s0,-36
    80002340:	4501                	li	a0,0
    80002342:	00000097          	auipc	ra,0x0
    80002346:	e78080e7          	jalr	-392(ra) # 800021ba <argint>
    8000234a:	87aa                	mv	a5,a0
    return -1;
    8000234c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000234e:	0207c063          	bltz	a5,8000236e <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002352:	fffff097          	auipc	ra,0xfffff
    80002356:	d92080e7          	jalr	-622(ra) # 800010e4 <myproc>
    8000235a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000235c:	fdc42503          	lw	a0,-36(s0)
    80002360:	fffff097          	auipc	ra,0xfffff
    80002364:	0de080e7          	jalr	222(ra) # 8000143e <growproc>
    80002368:	00054863          	bltz	a0,80002378 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000236c:	8526                	mv	a0,s1
}
    8000236e:	70a2                	ld	ra,40(sp)
    80002370:	7402                	ld	s0,32(sp)
    80002372:	64e2                	ld	s1,24(sp)
    80002374:	6145                	addi	sp,sp,48
    80002376:	8082                	ret
    return -1;
    80002378:	557d                	li	a0,-1
    8000237a:	bfd5                	j	8000236e <sys_sbrk+0x3c>

000000008000237c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000237c:	7139                	addi	sp,sp,-64
    8000237e:	fc06                	sd	ra,56(sp)
    80002380:	f822                	sd	s0,48(sp)
    80002382:	f426                	sd	s1,40(sp)
    80002384:	f04a                	sd	s2,32(sp)
    80002386:	ec4e                	sd	s3,24(sp)
    80002388:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000238a:	fcc40593          	addi	a1,s0,-52
    8000238e:	4501                	li	a0,0
    80002390:	00000097          	auipc	ra,0x0
    80002394:	e2a080e7          	jalr	-470(ra) # 800021ba <argint>
    return -1;
    80002398:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000239a:	06054563          	bltz	a0,80002404 <sys_sleep+0x88>
  acquire(&tickslock);
    8000239e:	0022d517          	auipc	a0,0x22d
    800023a2:	b0250513          	addi	a0,a0,-1278 # 8022eea0 <tickslock>
    800023a6:	00004097          	auipc	ra,0x4
    800023aa:	f32080e7          	jalr	-206(ra) # 800062d8 <acquire>
  ticks0 = ticks;
    800023ae:	00007917          	auipc	s2,0x7
    800023b2:	c6a92903          	lw	s2,-918(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800023b6:	fcc42783          	lw	a5,-52(s0)
    800023ba:	cf85                	beqz	a5,800023f2 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800023bc:	0022d997          	auipc	s3,0x22d
    800023c0:	ae498993          	addi	s3,s3,-1308 # 8022eea0 <tickslock>
    800023c4:	00007497          	auipc	s1,0x7
    800023c8:	c5448493          	addi	s1,s1,-940 # 80009018 <ticks>
    if(myproc()->killed){
    800023cc:	fffff097          	auipc	ra,0xfffff
    800023d0:	d18080e7          	jalr	-744(ra) # 800010e4 <myproc>
    800023d4:	551c                	lw	a5,40(a0)
    800023d6:	ef9d                	bnez	a5,80002414 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800023d8:	85ce                	mv	a1,s3
    800023da:	8526                	mv	a0,s1
    800023dc:	fffff097          	auipc	ra,0xfffff
    800023e0:	3cc080e7          	jalr	972(ra) # 800017a8 <sleep>
  while(ticks - ticks0 < n){
    800023e4:	409c                	lw	a5,0(s1)
    800023e6:	412787bb          	subw	a5,a5,s2
    800023ea:	fcc42703          	lw	a4,-52(s0)
    800023ee:	fce7efe3          	bltu	a5,a4,800023cc <sys_sleep+0x50>
  }
  release(&tickslock);
    800023f2:	0022d517          	auipc	a0,0x22d
    800023f6:	aae50513          	addi	a0,a0,-1362 # 8022eea0 <tickslock>
    800023fa:	00004097          	auipc	ra,0x4
    800023fe:	f92080e7          	jalr	-110(ra) # 8000638c <release>
  return 0;
    80002402:	4781                	li	a5,0
}
    80002404:	853e                	mv	a0,a5
    80002406:	70e2                	ld	ra,56(sp)
    80002408:	7442                	ld	s0,48(sp)
    8000240a:	74a2                	ld	s1,40(sp)
    8000240c:	7902                	ld	s2,32(sp)
    8000240e:	69e2                	ld	s3,24(sp)
    80002410:	6121                	addi	sp,sp,64
    80002412:	8082                	ret
      release(&tickslock);
    80002414:	0022d517          	auipc	a0,0x22d
    80002418:	a8c50513          	addi	a0,a0,-1396 # 8022eea0 <tickslock>
    8000241c:	00004097          	auipc	ra,0x4
    80002420:	f70080e7          	jalr	-144(ra) # 8000638c <release>
      return -1;
    80002424:	57fd                	li	a5,-1
    80002426:	bff9                	j	80002404 <sys_sleep+0x88>

0000000080002428 <sys_kill>:

uint64
sys_kill(void)
{
    80002428:	1101                	addi	sp,sp,-32
    8000242a:	ec06                	sd	ra,24(sp)
    8000242c:	e822                	sd	s0,16(sp)
    8000242e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002430:	fec40593          	addi	a1,s0,-20
    80002434:	4501                	li	a0,0
    80002436:	00000097          	auipc	ra,0x0
    8000243a:	d84080e7          	jalr	-636(ra) # 800021ba <argint>
    8000243e:	87aa                	mv	a5,a0
    return -1;
    80002440:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002442:	0007c863          	bltz	a5,80002452 <sys_kill+0x2a>
  return kill(pid);
    80002446:	fec42503          	lw	a0,-20(s0)
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	690080e7          	jalr	1680(ra) # 80001ada <kill>
}
    80002452:	60e2                	ld	ra,24(sp)
    80002454:	6442                	ld	s0,16(sp)
    80002456:	6105                	addi	sp,sp,32
    80002458:	8082                	ret

000000008000245a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000245a:	1101                	addi	sp,sp,-32
    8000245c:	ec06                	sd	ra,24(sp)
    8000245e:	e822                	sd	s0,16(sp)
    80002460:	e426                	sd	s1,8(sp)
    80002462:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002464:	0022d517          	auipc	a0,0x22d
    80002468:	a3c50513          	addi	a0,a0,-1476 # 8022eea0 <tickslock>
    8000246c:	00004097          	auipc	ra,0x4
    80002470:	e6c080e7          	jalr	-404(ra) # 800062d8 <acquire>
  xticks = ticks;
    80002474:	00007497          	auipc	s1,0x7
    80002478:	ba44a483          	lw	s1,-1116(s1) # 80009018 <ticks>
  release(&tickslock);
    8000247c:	0022d517          	auipc	a0,0x22d
    80002480:	a2450513          	addi	a0,a0,-1500 # 8022eea0 <tickslock>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	f08080e7          	jalr	-248(ra) # 8000638c <release>
  return xticks;
}
    8000248c:	02049513          	slli	a0,s1,0x20
    80002490:	9101                	srli	a0,a0,0x20
    80002492:	60e2                	ld	ra,24(sp)
    80002494:	6442                	ld	s0,16(sp)
    80002496:	64a2                	ld	s1,8(sp)
    80002498:	6105                	addi	sp,sp,32
    8000249a:	8082                	ret

000000008000249c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000249c:	7179                	addi	sp,sp,-48
    8000249e:	f406                	sd	ra,40(sp)
    800024a0:	f022                	sd	s0,32(sp)
    800024a2:	ec26                	sd	s1,24(sp)
    800024a4:	e84a                	sd	s2,16(sp)
    800024a6:	e44e                	sd	s3,8(sp)
    800024a8:	e052                	sd	s4,0(sp)
    800024aa:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024ac:	00006597          	auipc	a1,0x6
    800024b0:	08458593          	addi	a1,a1,132 # 80008530 <syscalls+0xb0>
    800024b4:	0022d517          	auipc	a0,0x22d
    800024b8:	a0450513          	addi	a0,a0,-1532 # 8022eeb8 <bcache>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	d8c080e7          	jalr	-628(ra) # 80006248 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024c4:	00235797          	auipc	a5,0x235
    800024c8:	9f478793          	addi	a5,a5,-1548 # 80236eb8 <bcache+0x8000>
    800024cc:	00235717          	auipc	a4,0x235
    800024d0:	c5470713          	addi	a4,a4,-940 # 80237120 <bcache+0x8268>
    800024d4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024d8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024dc:	0022d497          	auipc	s1,0x22d
    800024e0:	9f448493          	addi	s1,s1,-1548 # 8022eed0 <bcache+0x18>
    b->next = bcache.head.next;
    800024e4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024e6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024e8:	00006a17          	auipc	s4,0x6
    800024ec:	050a0a13          	addi	s4,s4,80 # 80008538 <syscalls+0xb8>
    b->next = bcache.head.next;
    800024f0:	2b893783          	ld	a5,696(s2)
    800024f4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024f6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024fa:	85d2                	mv	a1,s4
    800024fc:	01048513          	addi	a0,s1,16
    80002500:	00001097          	auipc	ra,0x1
    80002504:	4c2080e7          	jalr	1218(ra) # 800039c2 <initsleeplock>
    bcache.head.next->prev = b;
    80002508:	2b893783          	ld	a5,696(s2)
    8000250c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000250e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002512:	45848493          	addi	s1,s1,1112
    80002516:	fd349de3          	bne	s1,s3,800024f0 <binit+0x54>
  }
}
    8000251a:	70a2                	ld	ra,40(sp)
    8000251c:	7402                	ld	s0,32(sp)
    8000251e:	64e2                	ld	s1,24(sp)
    80002520:	6942                	ld	s2,16(sp)
    80002522:	69a2                	ld	s3,8(sp)
    80002524:	6a02                	ld	s4,0(sp)
    80002526:	6145                	addi	sp,sp,48
    80002528:	8082                	ret

000000008000252a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000252a:	7179                	addi	sp,sp,-48
    8000252c:	f406                	sd	ra,40(sp)
    8000252e:	f022                	sd	s0,32(sp)
    80002530:	ec26                	sd	s1,24(sp)
    80002532:	e84a                	sd	s2,16(sp)
    80002534:	e44e                	sd	s3,8(sp)
    80002536:	1800                	addi	s0,sp,48
    80002538:	892a                	mv	s2,a0
    8000253a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000253c:	0022d517          	auipc	a0,0x22d
    80002540:	97c50513          	addi	a0,a0,-1668 # 8022eeb8 <bcache>
    80002544:	00004097          	auipc	ra,0x4
    80002548:	d94080e7          	jalr	-620(ra) # 800062d8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000254c:	00235497          	auipc	s1,0x235
    80002550:	c244b483          	ld	s1,-988(s1) # 80237170 <bcache+0x82b8>
    80002554:	00235797          	auipc	a5,0x235
    80002558:	bcc78793          	addi	a5,a5,-1076 # 80237120 <bcache+0x8268>
    8000255c:	02f48f63          	beq	s1,a5,8000259a <bread+0x70>
    80002560:	873e                	mv	a4,a5
    80002562:	a021                	j	8000256a <bread+0x40>
    80002564:	68a4                	ld	s1,80(s1)
    80002566:	02e48a63          	beq	s1,a4,8000259a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000256a:	449c                	lw	a5,8(s1)
    8000256c:	ff279ce3          	bne	a5,s2,80002564 <bread+0x3a>
    80002570:	44dc                	lw	a5,12(s1)
    80002572:	ff3799e3          	bne	a5,s3,80002564 <bread+0x3a>
      b->refcnt++;
    80002576:	40bc                	lw	a5,64(s1)
    80002578:	2785                	addiw	a5,a5,1
    8000257a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000257c:	0022d517          	auipc	a0,0x22d
    80002580:	93c50513          	addi	a0,a0,-1732 # 8022eeb8 <bcache>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	e08080e7          	jalr	-504(ra) # 8000638c <release>
      acquiresleep(&b->lock);
    8000258c:	01048513          	addi	a0,s1,16
    80002590:	00001097          	auipc	ra,0x1
    80002594:	46c080e7          	jalr	1132(ra) # 800039fc <acquiresleep>
      return b;
    80002598:	a8b9                	j	800025f6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000259a:	00235497          	auipc	s1,0x235
    8000259e:	bce4b483          	ld	s1,-1074(s1) # 80237168 <bcache+0x82b0>
    800025a2:	00235797          	auipc	a5,0x235
    800025a6:	b7e78793          	addi	a5,a5,-1154 # 80237120 <bcache+0x8268>
    800025aa:	00f48863          	beq	s1,a5,800025ba <bread+0x90>
    800025ae:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025b0:	40bc                	lw	a5,64(s1)
    800025b2:	cf81                	beqz	a5,800025ca <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025b4:	64a4                	ld	s1,72(s1)
    800025b6:	fee49de3          	bne	s1,a4,800025b0 <bread+0x86>
  panic("bget: no buffers");
    800025ba:	00006517          	auipc	a0,0x6
    800025be:	f8650513          	addi	a0,a0,-122 # 80008540 <syscalls+0xc0>
    800025c2:	00003097          	auipc	ra,0x3
    800025c6:	7de080e7          	jalr	2014(ra) # 80005da0 <panic>
      b->dev = dev;
    800025ca:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025ce:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025d2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025d6:	4785                	li	a5,1
    800025d8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025da:	0022d517          	auipc	a0,0x22d
    800025de:	8de50513          	addi	a0,a0,-1826 # 8022eeb8 <bcache>
    800025e2:	00004097          	auipc	ra,0x4
    800025e6:	daa080e7          	jalr	-598(ra) # 8000638c <release>
      acquiresleep(&b->lock);
    800025ea:	01048513          	addi	a0,s1,16
    800025ee:	00001097          	auipc	ra,0x1
    800025f2:	40e080e7          	jalr	1038(ra) # 800039fc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025f6:	409c                	lw	a5,0(s1)
    800025f8:	cb89                	beqz	a5,8000260a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025fa:	8526                	mv	a0,s1
    800025fc:	70a2                	ld	ra,40(sp)
    800025fe:	7402                	ld	s0,32(sp)
    80002600:	64e2                	ld	s1,24(sp)
    80002602:	6942                	ld	s2,16(sp)
    80002604:	69a2                	ld	s3,8(sp)
    80002606:	6145                	addi	sp,sp,48
    80002608:	8082                	ret
    virtio_disk_rw(b, 0);
    8000260a:	4581                	li	a1,0
    8000260c:	8526                	mv	a0,s1
    8000260e:	00003097          	auipc	ra,0x3
    80002612:	f24080e7          	jalr	-220(ra) # 80005532 <virtio_disk_rw>
    b->valid = 1;
    80002616:	4785                	li	a5,1
    80002618:	c09c                	sw	a5,0(s1)
  return b;
    8000261a:	b7c5                	j	800025fa <bread+0xd0>

000000008000261c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000261c:	1101                	addi	sp,sp,-32
    8000261e:	ec06                	sd	ra,24(sp)
    80002620:	e822                	sd	s0,16(sp)
    80002622:	e426                	sd	s1,8(sp)
    80002624:	1000                	addi	s0,sp,32
    80002626:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002628:	0541                	addi	a0,a0,16
    8000262a:	00001097          	auipc	ra,0x1
    8000262e:	46c080e7          	jalr	1132(ra) # 80003a96 <holdingsleep>
    80002632:	cd01                	beqz	a0,8000264a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002634:	4585                	li	a1,1
    80002636:	8526                	mv	a0,s1
    80002638:	00003097          	auipc	ra,0x3
    8000263c:	efa080e7          	jalr	-262(ra) # 80005532 <virtio_disk_rw>
}
    80002640:	60e2                	ld	ra,24(sp)
    80002642:	6442                	ld	s0,16(sp)
    80002644:	64a2                	ld	s1,8(sp)
    80002646:	6105                	addi	sp,sp,32
    80002648:	8082                	ret
    panic("bwrite");
    8000264a:	00006517          	auipc	a0,0x6
    8000264e:	f0e50513          	addi	a0,a0,-242 # 80008558 <syscalls+0xd8>
    80002652:	00003097          	auipc	ra,0x3
    80002656:	74e080e7          	jalr	1870(ra) # 80005da0 <panic>

000000008000265a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000265a:	1101                	addi	sp,sp,-32
    8000265c:	ec06                	sd	ra,24(sp)
    8000265e:	e822                	sd	s0,16(sp)
    80002660:	e426                	sd	s1,8(sp)
    80002662:	e04a                	sd	s2,0(sp)
    80002664:	1000                	addi	s0,sp,32
    80002666:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002668:	01050913          	addi	s2,a0,16
    8000266c:	854a                	mv	a0,s2
    8000266e:	00001097          	auipc	ra,0x1
    80002672:	428080e7          	jalr	1064(ra) # 80003a96 <holdingsleep>
    80002676:	c92d                	beqz	a0,800026e8 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002678:	854a                	mv	a0,s2
    8000267a:	00001097          	auipc	ra,0x1
    8000267e:	3d8080e7          	jalr	984(ra) # 80003a52 <releasesleep>

  acquire(&bcache.lock);
    80002682:	0022d517          	auipc	a0,0x22d
    80002686:	83650513          	addi	a0,a0,-1994 # 8022eeb8 <bcache>
    8000268a:	00004097          	auipc	ra,0x4
    8000268e:	c4e080e7          	jalr	-946(ra) # 800062d8 <acquire>
  b->refcnt--;
    80002692:	40bc                	lw	a5,64(s1)
    80002694:	37fd                	addiw	a5,a5,-1
    80002696:	0007871b          	sext.w	a4,a5
    8000269a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000269c:	eb05                	bnez	a4,800026cc <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000269e:	68bc                	ld	a5,80(s1)
    800026a0:	64b8                	ld	a4,72(s1)
    800026a2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026a4:	64bc                	ld	a5,72(s1)
    800026a6:	68b8                	ld	a4,80(s1)
    800026a8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026aa:	00235797          	auipc	a5,0x235
    800026ae:	80e78793          	addi	a5,a5,-2034 # 80236eb8 <bcache+0x8000>
    800026b2:	2b87b703          	ld	a4,696(a5)
    800026b6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026b8:	00235717          	auipc	a4,0x235
    800026bc:	a6870713          	addi	a4,a4,-1432 # 80237120 <bcache+0x8268>
    800026c0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026c2:	2b87b703          	ld	a4,696(a5)
    800026c6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026c8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026cc:	0022c517          	auipc	a0,0x22c
    800026d0:	7ec50513          	addi	a0,a0,2028 # 8022eeb8 <bcache>
    800026d4:	00004097          	auipc	ra,0x4
    800026d8:	cb8080e7          	jalr	-840(ra) # 8000638c <release>
}
    800026dc:	60e2                	ld	ra,24(sp)
    800026de:	6442                	ld	s0,16(sp)
    800026e0:	64a2                	ld	s1,8(sp)
    800026e2:	6902                	ld	s2,0(sp)
    800026e4:	6105                	addi	sp,sp,32
    800026e6:	8082                	ret
    panic("brelse");
    800026e8:	00006517          	auipc	a0,0x6
    800026ec:	e7850513          	addi	a0,a0,-392 # 80008560 <syscalls+0xe0>
    800026f0:	00003097          	auipc	ra,0x3
    800026f4:	6b0080e7          	jalr	1712(ra) # 80005da0 <panic>

00000000800026f8 <bpin>:

void
bpin(struct buf *b) {
    800026f8:	1101                	addi	sp,sp,-32
    800026fa:	ec06                	sd	ra,24(sp)
    800026fc:	e822                	sd	s0,16(sp)
    800026fe:	e426                	sd	s1,8(sp)
    80002700:	1000                	addi	s0,sp,32
    80002702:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002704:	0022c517          	auipc	a0,0x22c
    80002708:	7b450513          	addi	a0,a0,1972 # 8022eeb8 <bcache>
    8000270c:	00004097          	auipc	ra,0x4
    80002710:	bcc080e7          	jalr	-1076(ra) # 800062d8 <acquire>
  b->refcnt++;
    80002714:	40bc                	lw	a5,64(s1)
    80002716:	2785                	addiw	a5,a5,1
    80002718:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000271a:	0022c517          	auipc	a0,0x22c
    8000271e:	79e50513          	addi	a0,a0,1950 # 8022eeb8 <bcache>
    80002722:	00004097          	auipc	ra,0x4
    80002726:	c6a080e7          	jalr	-918(ra) # 8000638c <release>
}
    8000272a:	60e2                	ld	ra,24(sp)
    8000272c:	6442                	ld	s0,16(sp)
    8000272e:	64a2                	ld	s1,8(sp)
    80002730:	6105                	addi	sp,sp,32
    80002732:	8082                	ret

0000000080002734 <bunpin>:

void
bunpin(struct buf *b) {
    80002734:	1101                	addi	sp,sp,-32
    80002736:	ec06                	sd	ra,24(sp)
    80002738:	e822                	sd	s0,16(sp)
    8000273a:	e426                	sd	s1,8(sp)
    8000273c:	1000                	addi	s0,sp,32
    8000273e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002740:	0022c517          	auipc	a0,0x22c
    80002744:	77850513          	addi	a0,a0,1912 # 8022eeb8 <bcache>
    80002748:	00004097          	auipc	ra,0x4
    8000274c:	b90080e7          	jalr	-1136(ra) # 800062d8 <acquire>
  b->refcnt--;
    80002750:	40bc                	lw	a5,64(s1)
    80002752:	37fd                	addiw	a5,a5,-1
    80002754:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002756:	0022c517          	auipc	a0,0x22c
    8000275a:	76250513          	addi	a0,a0,1890 # 8022eeb8 <bcache>
    8000275e:	00004097          	auipc	ra,0x4
    80002762:	c2e080e7          	jalr	-978(ra) # 8000638c <release>
}
    80002766:	60e2                	ld	ra,24(sp)
    80002768:	6442                	ld	s0,16(sp)
    8000276a:	64a2                	ld	s1,8(sp)
    8000276c:	6105                	addi	sp,sp,32
    8000276e:	8082                	ret

0000000080002770 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002770:	1101                	addi	sp,sp,-32
    80002772:	ec06                	sd	ra,24(sp)
    80002774:	e822                	sd	s0,16(sp)
    80002776:	e426                	sd	s1,8(sp)
    80002778:	e04a                	sd	s2,0(sp)
    8000277a:	1000                	addi	s0,sp,32
    8000277c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000277e:	00d5d59b          	srliw	a1,a1,0xd
    80002782:	00235797          	auipc	a5,0x235
    80002786:	e127a783          	lw	a5,-494(a5) # 80237594 <sb+0x1c>
    8000278a:	9dbd                	addw	a1,a1,a5
    8000278c:	00000097          	auipc	ra,0x0
    80002790:	d9e080e7          	jalr	-610(ra) # 8000252a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002794:	0074f713          	andi	a4,s1,7
    80002798:	4785                	li	a5,1
    8000279a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000279e:	14ce                	slli	s1,s1,0x33
    800027a0:	90d9                	srli	s1,s1,0x36
    800027a2:	00950733          	add	a4,a0,s1
    800027a6:	05874703          	lbu	a4,88(a4)
    800027aa:	00e7f6b3          	and	a3,a5,a4
    800027ae:	c69d                	beqz	a3,800027dc <bfree+0x6c>
    800027b0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027b2:	94aa                	add	s1,s1,a0
    800027b4:	fff7c793          	not	a5,a5
    800027b8:	8f7d                	and	a4,a4,a5
    800027ba:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800027be:	00001097          	auipc	ra,0x1
    800027c2:	120080e7          	jalr	288(ra) # 800038de <log_write>
  brelse(bp);
    800027c6:	854a                	mv	a0,s2
    800027c8:	00000097          	auipc	ra,0x0
    800027cc:	e92080e7          	jalr	-366(ra) # 8000265a <brelse>
}
    800027d0:	60e2                	ld	ra,24(sp)
    800027d2:	6442                	ld	s0,16(sp)
    800027d4:	64a2                	ld	s1,8(sp)
    800027d6:	6902                	ld	s2,0(sp)
    800027d8:	6105                	addi	sp,sp,32
    800027da:	8082                	ret
    panic("freeing free block");
    800027dc:	00006517          	auipc	a0,0x6
    800027e0:	d8c50513          	addi	a0,a0,-628 # 80008568 <syscalls+0xe8>
    800027e4:	00003097          	auipc	ra,0x3
    800027e8:	5bc080e7          	jalr	1468(ra) # 80005da0 <panic>

00000000800027ec <balloc>:
{
    800027ec:	711d                	addi	sp,sp,-96
    800027ee:	ec86                	sd	ra,88(sp)
    800027f0:	e8a2                	sd	s0,80(sp)
    800027f2:	e4a6                	sd	s1,72(sp)
    800027f4:	e0ca                	sd	s2,64(sp)
    800027f6:	fc4e                	sd	s3,56(sp)
    800027f8:	f852                	sd	s4,48(sp)
    800027fa:	f456                	sd	s5,40(sp)
    800027fc:	f05a                	sd	s6,32(sp)
    800027fe:	ec5e                	sd	s7,24(sp)
    80002800:	e862                	sd	s8,16(sp)
    80002802:	e466                	sd	s9,8(sp)
    80002804:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002806:	00235797          	auipc	a5,0x235
    8000280a:	d767a783          	lw	a5,-650(a5) # 8023757c <sb+0x4>
    8000280e:	cbc1                	beqz	a5,8000289e <balloc+0xb2>
    80002810:	8baa                	mv	s7,a0
    80002812:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002814:	00235b17          	auipc	s6,0x235
    80002818:	d64b0b13          	addi	s6,s6,-668 # 80237578 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000281c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000281e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002820:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002822:	6c89                	lui	s9,0x2
    80002824:	a831                	j	80002840 <balloc+0x54>
    brelse(bp);
    80002826:	854a                	mv	a0,s2
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	e32080e7          	jalr	-462(ra) # 8000265a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002830:	015c87bb          	addw	a5,s9,s5
    80002834:	00078a9b          	sext.w	s5,a5
    80002838:	004b2703          	lw	a4,4(s6)
    8000283c:	06eaf163          	bgeu	s5,a4,8000289e <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002840:	41fad79b          	sraiw	a5,s5,0x1f
    80002844:	0137d79b          	srliw	a5,a5,0x13
    80002848:	015787bb          	addw	a5,a5,s5
    8000284c:	40d7d79b          	sraiw	a5,a5,0xd
    80002850:	01cb2583          	lw	a1,28(s6)
    80002854:	9dbd                	addw	a1,a1,a5
    80002856:	855e                	mv	a0,s7
    80002858:	00000097          	auipc	ra,0x0
    8000285c:	cd2080e7          	jalr	-814(ra) # 8000252a <bread>
    80002860:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002862:	004b2503          	lw	a0,4(s6)
    80002866:	000a849b          	sext.w	s1,s5
    8000286a:	8762                	mv	a4,s8
    8000286c:	faa4fde3          	bgeu	s1,a0,80002826 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002870:	00777693          	andi	a3,a4,7
    80002874:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002878:	41f7579b          	sraiw	a5,a4,0x1f
    8000287c:	01d7d79b          	srliw	a5,a5,0x1d
    80002880:	9fb9                	addw	a5,a5,a4
    80002882:	4037d79b          	sraiw	a5,a5,0x3
    80002886:	00f90633          	add	a2,s2,a5
    8000288a:	05864603          	lbu	a2,88(a2)
    8000288e:	00c6f5b3          	and	a1,a3,a2
    80002892:	cd91                	beqz	a1,800028ae <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002894:	2705                	addiw	a4,a4,1
    80002896:	2485                	addiw	s1,s1,1
    80002898:	fd471ae3          	bne	a4,s4,8000286c <balloc+0x80>
    8000289c:	b769                	j	80002826 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000289e:	00006517          	auipc	a0,0x6
    800028a2:	ce250513          	addi	a0,a0,-798 # 80008580 <syscalls+0x100>
    800028a6:	00003097          	auipc	ra,0x3
    800028aa:	4fa080e7          	jalr	1274(ra) # 80005da0 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028ae:	97ca                	add	a5,a5,s2
    800028b0:	8e55                	or	a2,a2,a3
    800028b2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800028b6:	854a                	mv	a0,s2
    800028b8:	00001097          	auipc	ra,0x1
    800028bc:	026080e7          	jalr	38(ra) # 800038de <log_write>
        brelse(bp);
    800028c0:	854a                	mv	a0,s2
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	d98080e7          	jalr	-616(ra) # 8000265a <brelse>
  bp = bread(dev, bno);
    800028ca:	85a6                	mv	a1,s1
    800028cc:	855e                	mv	a0,s7
    800028ce:	00000097          	auipc	ra,0x0
    800028d2:	c5c080e7          	jalr	-932(ra) # 8000252a <bread>
    800028d6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028d8:	40000613          	li	a2,1024
    800028dc:	4581                	li	a1,0
    800028de:	05850513          	addi	a0,a0,88
    800028e2:	ffffe097          	auipc	ra,0xffffe
    800028e6:	9bc080e7          	jalr	-1604(ra) # 8000029e <memset>
  log_write(bp);
    800028ea:	854a                	mv	a0,s2
    800028ec:	00001097          	auipc	ra,0x1
    800028f0:	ff2080e7          	jalr	-14(ra) # 800038de <log_write>
  brelse(bp);
    800028f4:	854a                	mv	a0,s2
    800028f6:	00000097          	auipc	ra,0x0
    800028fa:	d64080e7          	jalr	-668(ra) # 8000265a <brelse>
}
    800028fe:	8526                	mv	a0,s1
    80002900:	60e6                	ld	ra,88(sp)
    80002902:	6446                	ld	s0,80(sp)
    80002904:	64a6                	ld	s1,72(sp)
    80002906:	6906                	ld	s2,64(sp)
    80002908:	79e2                	ld	s3,56(sp)
    8000290a:	7a42                	ld	s4,48(sp)
    8000290c:	7aa2                	ld	s5,40(sp)
    8000290e:	7b02                	ld	s6,32(sp)
    80002910:	6be2                	ld	s7,24(sp)
    80002912:	6c42                	ld	s8,16(sp)
    80002914:	6ca2                	ld	s9,8(sp)
    80002916:	6125                	addi	sp,sp,96
    80002918:	8082                	ret

000000008000291a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000291a:	7179                	addi	sp,sp,-48
    8000291c:	f406                	sd	ra,40(sp)
    8000291e:	f022                	sd	s0,32(sp)
    80002920:	ec26                	sd	s1,24(sp)
    80002922:	e84a                	sd	s2,16(sp)
    80002924:	e44e                	sd	s3,8(sp)
    80002926:	e052                	sd	s4,0(sp)
    80002928:	1800                	addi	s0,sp,48
    8000292a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000292c:	47ad                	li	a5,11
    8000292e:	04b7fe63          	bgeu	a5,a1,8000298a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002932:	ff45849b          	addiw	s1,a1,-12
    80002936:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000293a:	0ff00793          	li	a5,255
    8000293e:	0ae7e463          	bltu	a5,a4,800029e6 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002942:	08052583          	lw	a1,128(a0)
    80002946:	c5b5                	beqz	a1,800029b2 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002948:	00092503          	lw	a0,0(s2)
    8000294c:	00000097          	auipc	ra,0x0
    80002950:	bde080e7          	jalr	-1058(ra) # 8000252a <bread>
    80002954:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002956:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000295a:	02049713          	slli	a4,s1,0x20
    8000295e:	01e75593          	srli	a1,a4,0x1e
    80002962:	00b784b3          	add	s1,a5,a1
    80002966:	0004a983          	lw	s3,0(s1)
    8000296a:	04098e63          	beqz	s3,800029c6 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000296e:	8552                	mv	a0,s4
    80002970:	00000097          	auipc	ra,0x0
    80002974:	cea080e7          	jalr	-790(ra) # 8000265a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002978:	854e                	mv	a0,s3
    8000297a:	70a2                	ld	ra,40(sp)
    8000297c:	7402                	ld	s0,32(sp)
    8000297e:	64e2                	ld	s1,24(sp)
    80002980:	6942                	ld	s2,16(sp)
    80002982:	69a2                	ld	s3,8(sp)
    80002984:	6a02                	ld	s4,0(sp)
    80002986:	6145                	addi	sp,sp,48
    80002988:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000298a:	02059793          	slli	a5,a1,0x20
    8000298e:	01e7d593          	srli	a1,a5,0x1e
    80002992:	00b504b3          	add	s1,a0,a1
    80002996:	0504a983          	lw	s3,80(s1)
    8000299a:	fc099fe3          	bnez	s3,80002978 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000299e:	4108                	lw	a0,0(a0)
    800029a0:	00000097          	auipc	ra,0x0
    800029a4:	e4c080e7          	jalr	-436(ra) # 800027ec <balloc>
    800029a8:	0005099b          	sext.w	s3,a0
    800029ac:	0534a823          	sw	s3,80(s1)
    800029b0:	b7e1                	j	80002978 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029b2:	4108                	lw	a0,0(a0)
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	e38080e7          	jalr	-456(ra) # 800027ec <balloc>
    800029bc:	0005059b          	sext.w	a1,a0
    800029c0:	08b92023          	sw	a1,128(s2)
    800029c4:	b751                	j	80002948 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029c6:	00092503          	lw	a0,0(s2)
    800029ca:	00000097          	auipc	ra,0x0
    800029ce:	e22080e7          	jalr	-478(ra) # 800027ec <balloc>
    800029d2:	0005099b          	sext.w	s3,a0
    800029d6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029da:	8552                	mv	a0,s4
    800029dc:	00001097          	auipc	ra,0x1
    800029e0:	f02080e7          	jalr	-254(ra) # 800038de <log_write>
    800029e4:	b769                	j	8000296e <bmap+0x54>
  panic("bmap: out of range");
    800029e6:	00006517          	auipc	a0,0x6
    800029ea:	bb250513          	addi	a0,a0,-1102 # 80008598 <syscalls+0x118>
    800029ee:	00003097          	auipc	ra,0x3
    800029f2:	3b2080e7          	jalr	946(ra) # 80005da0 <panic>

00000000800029f6 <iget>:
{
    800029f6:	7179                	addi	sp,sp,-48
    800029f8:	f406                	sd	ra,40(sp)
    800029fa:	f022                	sd	s0,32(sp)
    800029fc:	ec26                	sd	s1,24(sp)
    800029fe:	e84a                	sd	s2,16(sp)
    80002a00:	e44e                	sd	s3,8(sp)
    80002a02:	e052                	sd	s4,0(sp)
    80002a04:	1800                	addi	s0,sp,48
    80002a06:	89aa                	mv	s3,a0
    80002a08:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a0a:	00235517          	auipc	a0,0x235
    80002a0e:	b8e50513          	addi	a0,a0,-1138 # 80237598 <itable>
    80002a12:	00004097          	auipc	ra,0x4
    80002a16:	8c6080e7          	jalr	-1850(ra) # 800062d8 <acquire>
  empty = 0;
    80002a1a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a1c:	00235497          	auipc	s1,0x235
    80002a20:	b9448493          	addi	s1,s1,-1132 # 802375b0 <itable+0x18>
    80002a24:	00236697          	auipc	a3,0x236
    80002a28:	61c68693          	addi	a3,a3,1564 # 80239040 <log>
    80002a2c:	a039                	j	80002a3a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a2e:	02090b63          	beqz	s2,80002a64 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a32:	08848493          	addi	s1,s1,136
    80002a36:	02d48a63          	beq	s1,a3,80002a6a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a3a:	449c                	lw	a5,8(s1)
    80002a3c:	fef059e3          	blez	a5,80002a2e <iget+0x38>
    80002a40:	4098                	lw	a4,0(s1)
    80002a42:	ff3716e3          	bne	a4,s3,80002a2e <iget+0x38>
    80002a46:	40d8                	lw	a4,4(s1)
    80002a48:	ff4713e3          	bne	a4,s4,80002a2e <iget+0x38>
      ip->ref++;
    80002a4c:	2785                	addiw	a5,a5,1
    80002a4e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a50:	00235517          	auipc	a0,0x235
    80002a54:	b4850513          	addi	a0,a0,-1208 # 80237598 <itable>
    80002a58:	00004097          	auipc	ra,0x4
    80002a5c:	934080e7          	jalr	-1740(ra) # 8000638c <release>
      return ip;
    80002a60:	8926                	mv	s2,s1
    80002a62:	a03d                	j	80002a90 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a64:	f7f9                	bnez	a5,80002a32 <iget+0x3c>
    80002a66:	8926                	mv	s2,s1
    80002a68:	b7e9                	j	80002a32 <iget+0x3c>
  if(empty == 0)
    80002a6a:	02090c63          	beqz	s2,80002aa2 <iget+0xac>
  ip->dev = dev;
    80002a6e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a72:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a76:	4785                	li	a5,1
    80002a78:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a7c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a80:	00235517          	auipc	a0,0x235
    80002a84:	b1850513          	addi	a0,a0,-1256 # 80237598 <itable>
    80002a88:	00004097          	auipc	ra,0x4
    80002a8c:	904080e7          	jalr	-1788(ra) # 8000638c <release>
}
    80002a90:	854a                	mv	a0,s2
    80002a92:	70a2                	ld	ra,40(sp)
    80002a94:	7402                	ld	s0,32(sp)
    80002a96:	64e2                	ld	s1,24(sp)
    80002a98:	6942                	ld	s2,16(sp)
    80002a9a:	69a2                	ld	s3,8(sp)
    80002a9c:	6a02                	ld	s4,0(sp)
    80002a9e:	6145                	addi	sp,sp,48
    80002aa0:	8082                	ret
    panic("iget: no inodes");
    80002aa2:	00006517          	auipc	a0,0x6
    80002aa6:	b0e50513          	addi	a0,a0,-1266 # 800085b0 <syscalls+0x130>
    80002aaa:	00003097          	auipc	ra,0x3
    80002aae:	2f6080e7          	jalr	758(ra) # 80005da0 <panic>

0000000080002ab2 <fsinit>:
fsinit(int dev) {
    80002ab2:	7179                	addi	sp,sp,-48
    80002ab4:	f406                	sd	ra,40(sp)
    80002ab6:	f022                	sd	s0,32(sp)
    80002ab8:	ec26                	sd	s1,24(sp)
    80002aba:	e84a                	sd	s2,16(sp)
    80002abc:	e44e                	sd	s3,8(sp)
    80002abe:	1800                	addi	s0,sp,48
    80002ac0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ac2:	4585                	li	a1,1
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	a66080e7          	jalr	-1434(ra) # 8000252a <bread>
    80002acc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ace:	00235997          	auipc	s3,0x235
    80002ad2:	aaa98993          	addi	s3,s3,-1366 # 80237578 <sb>
    80002ad6:	02000613          	li	a2,32
    80002ada:	05850593          	addi	a1,a0,88
    80002ade:	854e                	mv	a0,s3
    80002ae0:	ffffe097          	auipc	ra,0xffffe
    80002ae4:	81a080e7          	jalr	-2022(ra) # 800002fa <memmove>
  brelse(bp);
    80002ae8:	8526                	mv	a0,s1
    80002aea:	00000097          	auipc	ra,0x0
    80002aee:	b70080e7          	jalr	-1168(ra) # 8000265a <brelse>
  if(sb.magic != FSMAGIC)
    80002af2:	0009a703          	lw	a4,0(s3)
    80002af6:	102037b7          	lui	a5,0x10203
    80002afa:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002afe:	02f71263          	bne	a4,a5,80002b22 <fsinit+0x70>
  initlog(dev, &sb);
    80002b02:	00235597          	auipc	a1,0x235
    80002b06:	a7658593          	addi	a1,a1,-1418 # 80237578 <sb>
    80002b0a:	854a                	mv	a0,s2
    80002b0c:	00001097          	auipc	ra,0x1
    80002b10:	b56080e7          	jalr	-1194(ra) # 80003662 <initlog>
}
    80002b14:	70a2                	ld	ra,40(sp)
    80002b16:	7402                	ld	s0,32(sp)
    80002b18:	64e2                	ld	s1,24(sp)
    80002b1a:	6942                	ld	s2,16(sp)
    80002b1c:	69a2                	ld	s3,8(sp)
    80002b1e:	6145                	addi	sp,sp,48
    80002b20:	8082                	ret
    panic("invalid file system");
    80002b22:	00006517          	auipc	a0,0x6
    80002b26:	a9e50513          	addi	a0,a0,-1378 # 800085c0 <syscalls+0x140>
    80002b2a:	00003097          	auipc	ra,0x3
    80002b2e:	276080e7          	jalr	630(ra) # 80005da0 <panic>

0000000080002b32 <iinit>:
{
    80002b32:	7179                	addi	sp,sp,-48
    80002b34:	f406                	sd	ra,40(sp)
    80002b36:	f022                	sd	s0,32(sp)
    80002b38:	ec26                	sd	s1,24(sp)
    80002b3a:	e84a                	sd	s2,16(sp)
    80002b3c:	e44e                	sd	s3,8(sp)
    80002b3e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b40:	00006597          	auipc	a1,0x6
    80002b44:	a9858593          	addi	a1,a1,-1384 # 800085d8 <syscalls+0x158>
    80002b48:	00235517          	auipc	a0,0x235
    80002b4c:	a5050513          	addi	a0,a0,-1456 # 80237598 <itable>
    80002b50:	00003097          	auipc	ra,0x3
    80002b54:	6f8080e7          	jalr	1784(ra) # 80006248 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b58:	00235497          	auipc	s1,0x235
    80002b5c:	a6848493          	addi	s1,s1,-1432 # 802375c0 <itable+0x28>
    80002b60:	00236997          	auipc	s3,0x236
    80002b64:	4f098993          	addi	s3,s3,1264 # 80239050 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b68:	00006917          	auipc	s2,0x6
    80002b6c:	a7890913          	addi	s2,s2,-1416 # 800085e0 <syscalls+0x160>
    80002b70:	85ca                	mv	a1,s2
    80002b72:	8526                	mv	a0,s1
    80002b74:	00001097          	auipc	ra,0x1
    80002b78:	e4e080e7          	jalr	-434(ra) # 800039c2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b7c:	08848493          	addi	s1,s1,136
    80002b80:	ff3498e3          	bne	s1,s3,80002b70 <iinit+0x3e>
}
    80002b84:	70a2                	ld	ra,40(sp)
    80002b86:	7402                	ld	s0,32(sp)
    80002b88:	64e2                	ld	s1,24(sp)
    80002b8a:	6942                	ld	s2,16(sp)
    80002b8c:	69a2                	ld	s3,8(sp)
    80002b8e:	6145                	addi	sp,sp,48
    80002b90:	8082                	ret

0000000080002b92 <ialloc>:
{
    80002b92:	715d                	addi	sp,sp,-80
    80002b94:	e486                	sd	ra,72(sp)
    80002b96:	e0a2                	sd	s0,64(sp)
    80002b98:	fc26                	sd	s1,56(sp)
    80002b9a:	f84a                	sd	s2,48(sp)
    80002b9c:	f44e                	sd	s3,40(sp)
    80002b9e:	f052                	sd	s4,32(sp)
    80002ba0:	ec56                	sd	s5,24(sp)
    80002ba2:	e85a                	sd	s6,16(sp)
    80002ba4:	e45e                	sd	s7,8(sp)
    80002ba6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ba8:	00235717          	auipc	a4,0x235
    80002bac:	9dc72703          	lw	a4,-1572(a4) # 80237584 <sb+0xc>
    80002bb0:	4785                	li	a5,1
    80002bb2:	04e7fa63          	bgeu	a5,a4,80002c06 <ialloc+0x74>
    80002bb6:	8aaa                	mv	s5,a0
    80002bb8:	8bae                	mv	s7,a1
    80002bba:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bbc:	00235a17          	auipc	s4,0x235
    80002bc0:	9bca0a13          	addi	s4,s4,-1604 # 80237578 <sb>
    80002bc4:	00048b1b          	sext.w	s6,s1
    80002bc8:	0044d593          	srli	a1,s1,0x4
    80002bcc:	018a2783          	lw	a5,24(s4)
    80002bd0:	9dbd                	addw	a1,a1,a5
    80002bd2:	8556                	mv	a0,s5
    80002bd4:	00000097          	auipc	ra,0x0
    80002bd8:	956080e7          	jalr	-1706(ra) # 8000252a <bread>
    80002bdc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bde:	05850993          	addi	s3,a0,88
    80002be2:	00f4f793          	andi	a5,s1,15
    80002be6:	079a                	slli	a5,a5,0x6
    80002be8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bea:	00099783          	lh	a5,0(s3)
    80002bee:	c785                	beqz	a5,80002c16 <ialloc+0x84>
    brelse(bp);
    80002bf0:	00000097          	auipc	ra,0x0
    80002bf4:	a6a080e7          	jalr	-1430(ra) # 8000265a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bf8:	0485                	addi	s1,s1,1
    80002bfa:	00ca2703          	lw	a4,12(s4)
    80002bfe:	0004879b          	sext.w	a5,s1
    80002c02:	fce7e1e3          	bltu	a5,a4,80002bc4 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c06:	00006517          	auipc	a0,0x6
    80002c0a:	9e250513          	addi	a0,a0,-1566 # 800085e8 <syscalls+0x168>
    80002c0e:	00003097          	auipc	ra,0x3
    80002c12:	192080e7          	jalr	402(ra) # 80005da0 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c16:	04000613          	li	a2,64
    80002c1a:	4581                	li	a1,0
    80002c1c:	854e                	mv	a0,s3
    80002c1e:	ffffd097          	auipc	ra,0xffffd
    80002c22:	680080e7          	jalr	1664(ra) # 8000029e <memset>
      dip->type = type;
    80002c26:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c2a:	854a                	mv	a0,s2
    80002c2c:	00001097          	auipc	ra,0x1
    80002c30:	cb2080e7          	jalr	-846(ra) # 800038de <log_write>
      brelse(bp);
    80002c34:	854a                	mv	a0,s2
    80002c36:	00000097          	auipc	ra,0x0
    80002c3a:	a24080e7          	jalr	-1500(ra) # 8000265a <brelse>
      return iget(dev, inum);
    80002c3e:	85da                	mv	a1,s6
    80002c40:	8556                	mv	a0,s5
    80002c42:	00000097          	auipc	ra,0x0
    80002c46:	db4080e7          	jalr	-588(ra) # 800029f6 <iget>
}
    80002c4a:	60a6                	ld	ra,72(sp)
    80002c4c:	6406                	ld	s0,64(sp)
    80002c4e:	74e2                	ld	s1,56(sp)
    80002c50:	7942                	ld	s2,48(sp)
    80002c52:	79a2                	ld	s3,40(sp)
    80002c54:	7a02                	ld	s4,32(sp)
    80002c56:	6ae2                	ld	s5,24(sp)
    80002c58:	6b42                	ld	s6,16(sp)
    80002c5a:	6ba2                	ld	s7,8(sp)
    80002c5c:	6161                	addi	sp,sp,80
    80002c5e:	8082                	ret

0000000080002c60 <iupdate>:
{
    80002c60:	1101                	addi	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	e426                	sd	s1,8(sp)
    80002c68:	e04a                	sd	s2,0(sp)
    80002c6a:	1000                	addi	s0,sp,32
    80002c6c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c6e:	415c                	lw	a5,4(a0)
    80002c70:	0047d79b          	srliw	a5,a5,0x4
    80002c74:	00235597          	auipc	a1,0x235
    80002c78:	91c5a583          	lw	a1,-1764(a1) # 80237590 <sb+0x18>
    80002c7c:	9dbd                	addw	a1,a1,a5
    80002c7e:	4108                	lw	a0,0(a0)
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	8aa080e7          	jalr	-1878(ra) # 8000252a <bread>
    80002c88:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c8a:	05850793          	addi	a5,a0,88
    80002c8e:	40d8                	lw	a4,4(s1)
    80002c90:	8b3d                	andi	a4,a4,15
    80002c92:	071a                	slli	a4,a4,0x6
    80002c94:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c96:	04449703          	lh	a4,68(s1)
    80002c9a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c9e:	04649703          	lh	a4,70(s1)
    80002ca2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ca6:	04849703          	lh	a4,72(s1)
    80002caa:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cae:	04a49703          	lh	a4,74(s1)
    80002cb2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002cb6:	44f8                	lw	a4,76(s1)
    80002cb8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cba:	03400613          	li	a2,52
    80002cbe:	05048593          	addi	a1,s1,80
    80002cc2:	00c78513          	addi	a0,a5,12
    80002cc6:	ffffd097          	auipc	ra,0xffffd
    80002cca:	634080e7          	jalr	1588(ra) # 800002fa <memmove>
  log_write(bp);
    80002cce:	854a                	mv	a0,s2
    80002cd0:	00001097          	auipc	ra,0x1
    80002cd4:	c0e080e7          	jalr	-1010(ra) # 800038de <log_write>
  brelse(bp);
    80002cd8:	854a                	mv	a0,s2
    80002cda:	00000097          	auipc	ra,0x0
    80002cde:	980080e7          	jalr	-1664(ra) # 8000265a <brelse>
}
    80002ce2:	60e2                	ld	ra,24(sp)
    80002ce4:	6442                	ld	s0,16(sp)
    80002ce6:	64a2                	ld	s1,8(sp)
    80002ce8:	6902                	ld	s2,0(sp)
    80002cea:	6105                	addi	sp,sp,32
    80002cec:	8082                	ret

0000000080002cee <idup>:
{
    80002cee:	1101                	addi	sp,sp,-32
    80002cf0:	ec06                	sd	ra,24(sp)
    80002cf2:	e822                	sd	s0,16(sp)
    80002cf4:	e426                	sd	s1,8(sp)
    80002cf6:	1000                	addi	s0,sp,32
    80002cf8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cfa:	00235517          	auipc	a0,0x235
    80002cfe:	89e50513          	addi	a0,a0,-1890 # 80237598 <itable>
    80002d02:	00003097          	auipc	ra,0x3
    80002d06:	5d6080e7          	jalr	1494(ra) # 800062d8 <acquire>
  ip->ref++;
    80002d0a:	449c                	lw	a5,8(s1)
    80002d0c:	2785                	addiw	a5,a5,1
    80002d0e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d10:	00235517          	auipc	a0,0x235
    80002d14:	88850513          	addi	a0,a0,-1912 # 80237598 <itable>
    80002d18:	00003097          	auipc	ra,0x3
    80002d1c:	674080e7          	jalr	1652(ra) # 8000638c <release>
}
    80002d20:	8526                	mv	a0,s1
    80002d22:	60e2                	ld	ra,24(sp)
    80002d24:	6442                	ld	s0,16(sp)
    80002d26:	64a2                	ld	s1,8(sp)
    80002d28:	6105                	addi	sp,sp,32
    80002d2a:	8082                	ret

0000000080002d2c <ilock>:
{
    80002d2c:	1101                	addi	sp,sp,-32
    80002d2e:	ec06                	sd	ra,24(sp)
    80002d30:	e822                	sd	s0,16(sp)
    80002d32:	e426                	sd	s1,8(sp)
    80002d34:	e04a                	sd	s2,0(sp)
    80002d36:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d38:	c115                	beqz	a0,80002d5c <ilock+0x30>
    80002d3a:	84aa                	mv	s1,a0
    80002d3c:	451c                	lw	a5,8(a0)
    80002d3e:	00f05f63          	blez	a5,80002d5c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d42:	0541                	addi	a0,a0,16
    80002d44:	00001097          	auipc	ra,0x1
    80002d48:	cb8080e7          	jalr	-840(ra) # 800039fc <acquiresleep>
  if(ip->valid == 0){
    80002d4c:	40bc                	lw	a5,64(s1)
    80002d4e:	cf99                	beqz	a5,80002d6c <ilock+0x40>
}
    80002d50:	60e2                	ld	ra,24(sp)
    80002d52:	6442                	ld	s0,16(sp)
    80002d54:	64a2                	ld	s1,8(sp)
    80002d56:	6902                	ld	s2,0(sp)
    80002d58:	6105                	addi	sp,sp,32
    80002d5a:	8082                	ret
    panic("ilock");
    80002d5c:	00006517          	auipc	a0,0x6
    80002d60:	8a450513          	addi	a0,a0,-1884 # 80008600 <syscalls+0x180>
    80002d64:	00003097          	auipc	ra,0x3
    80002d68:	03c080e7          	jalr	60(ra) # 80005da0 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d6c:	40dc                	lw	a5,4(s1)
    80002d6e:	0047d79b          	srliw	a5,a5,0x4
    80002d72:	00235597          	auipc	a1,0x235
    80002d76:	81e5a583          	lw	a1,-2018(a1) # 80237590 <sb+0x18>
    80002d7a:	9dbd                	addw	a1,a1,a5
    80002d7c:	4088                	lw	a0,0(s1)
    80002d7e:	fffff097          	auipc	ra,0xfffff
    80002d82:	7ac080e7          	jalr	1964(ra) # 8000252a <bread>
    80002d86:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d88:	05850593          	addi	a1,a0,88
    80002d8c:	40dc                	lw	a5,4(s1)
    80002d8e:	8bbd                	andi	a5,a5,15
    80002d90:	079a                	slli	a5,a5,0x6
    80002d92:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d94:	00059783          	lh	a5,0(a1)
    80002d98:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d9c:	00259783          	lh	a5,2(a1)
    80002da0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002da4:	00459783          	lh	a5,4(a1)
    80002da8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dac:	00659783          	lh	a5,6(a1)
    80002db0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002db4:	459c                	lw	a5,8(a1)
    80002db6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002db8:	03400613          	li	a2,52
    80002dbc:	05b1                	addi	a1,a1,12
    80002dbe:	05048513          	addi	a0,s1,80
    80002dc2:	ffffd097          	auipc	ra,0xffffd
    80002dc6:	538080e7          	jalr	1336(ra) # 800002fa <memmove>
    brelse(bp);
    80002dca:	854a                	mv	a0,s2
    80002dcc:	00000097          	auipc	ra,0x0
    80002dd0:	88e080e7          	jalr	-1906(ra) # 8000265a <brelse>
    ip->valid = 1;
    80002dd4:	4785                	li	a5,1
    80002dd6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002dd8:	04449783          	lh	a5,68(s1)
    80002ddc:	fbb5                	bnez	a5,80002d50 <ilock+0x24>
      panic("ilock: no type");
    80002dde:	00006517          	auipc	a0,0x6
    80002de2:	82a50513          	addi	a0,a0,-2006 # 80008608 <syscalls+0x188>
    80002de6:	00003097          	auipc	ra,0x3
    80002dea:	fba080e7          	jalr	-70(ra) # 80005da0 <panic>

0000000080002dee <iunlock>:
{
    80002dee:	1101                	addi	sp,sp,-32
    80002df0:	ec06                	sd	ra,24(sp)
    80002df2:	e822                	sd	s0,16(sp)
    80002df4:	e426                	sd	s1,8(sp)
    80002df6:	e04a                	sd	s2,0(sp)
    80002df8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dfa:	c905                	beqz	a0,80002e2a <iunlock+0x3c>
    80002dfc:	84aa                	mv	s1,a0
    80002dfe:	01050913          	addi	s2,a0,16
    80002e02:	854a                	mv	a0,s2
    80002e04:	00001097          	auipc	ra,0x1
    80002e08:	c92080e7          	jalr	-878(ra) # 80003a96 <holdingsleep>
    80002e0c:	cd19                	beqz	a0,80002e2a <iunlock+0x3c>
    80002e0e:	449c                	lw	a5,8(s1)
    80002e10:	00f05d63          	blez	a5,80002e2a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e14:	854a                	mv	a0,s2
    80002e16:	00001097          	auipc	ra,0x1
    80002e1a:	c3c080e7          	jalr	-964(ra) # 80003a52 <releasesleep>
}
    80002e1e:	60e2                	ld	ra,24(sp)
    80002e20:	6442                	ld	s0,16(sp)
    80002e22:	64a2                	ld	s1,8(sp)
    80002e24:	6902                	ld	s2,0(sp)
    80002e26:	6105                	addi	sp,sp,32
    80002e28:	8082                	ret
    panic("iunlock");
    80002e2a:	00005517          	auipc	a0,0x5
    80002e2e:	7ee50513          	addi	a0,a0,2030 # 80008618 <syscalls+0x198>
    80002e32:	00003097          	auipc	ra,0x3
    80002e36:	f6e080e7          	jalr	-146(ra) # 80005da0 <panic>

0000000080002e3a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e3a:	7179                	addi	sp,sp,-48
    80002e3c:	f406                	sd	ra,40(sp)
    80002e3e:	f022                	sd	s0,32(sp)
    80002e40:	ec26                	sd	s1,24(sp)
    80002e42:	e84a                	sd	s2,16(sp)
    80002e44:	e44e                	sd	s3,8(sp)
    80002e46:	e052                	sd	s4,0(sp)
    80002e48:	1800                	addi	s0,sp,48
    80002e4a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e4c:	05050493          	addi	s1,a0,80
    80002e50:	08050913          	addi	s2,a0,128
    80002e54:	a021                	j	80002e5c <itrunc+0x22>
    80002e56:	0491                	addi	s1,s1,4
    80002e58:	01248d63          	beq	s1,s2,80002e72 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e5c:	408c                	lw	a1,0(s1)
    80002e5e:	dde5                	beqz	a1,80002e56 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e60:	0009a503          	lw	a0,0(s3)
    80002e64:	00000097          	auipc	ra,0x0
    80002e68:	90c080e7          	jalr	-1780(ra) # 80002770 <bfree>
      ip->addrs[i] = 0;
    80002e6c:	0004a023          	sw	zero,0(s1)
    80002e70:	b7dd                	j	80002e56 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e72:	0809a583          	lw	a1,128(s3)
    80002e76:	e185                	bnez	a1,80002e96 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e78:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e7c:	854e                	mv	a0,s3
    80002e7e:	00000097          	auipc	ra,0x0
    80002e82:	de2080e7          	jalr	-542(ra) # 80002c60 <iupdate>
}
    80002e86:	70a2                	ld	ra,40(sp)
    80002e88:	7402                	ld	s0,32(sp)
    80002e8a:	64e2                	ld	s1,24(sp)
    80002e8c:	6942                	ld	s2,16(sp)
    80002e8e:	69a2                	ld	s3,8(sp)
    80002e90:	6a02                	ld	s4,0(sp)
    80002e92:	6145                	addi	sp,sp,48
    80002e94:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e96:	0009a503          	lw	a0,0(s3)
    80002e9a:	fffff097          	auipc	ra,0xfffff
    80002e9e:	690080e7          	jalr	1680(ra) # 8000252a <bread>
    80002ea2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ea4:	05850493          	addi	s1,a0,88
    80002ea8:	45850913          	addi	s2,a0,1112
    80002eac:	a021                	j	80002eb4 <itrunc+0x7a>
    80002eae:	0491                	addi	s1,s1,4
    80002eb0:	01248b63          	beq	s1,s2,80002ec6 <itrunc+0x8c>
      if(a[j])
    80002eb4:	408c                	lw	a1,0(s1)
    80002eb6:	dde5                	beqz	a1,80002eae <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002eb8:	0009a503          	lw	a0,0(s3)
    80002ebc:	00000097          	auipc	ra,0x0
    80002ec0:	8b4080e7          	jalr	-1868(ra) # 80002770 <bfree>
    80002ec4:	b7ed                	j	80002eae <itrunc+0x74>
    brelse(bp);
    80002ec6:	8552                	mv	a0,s4
    80002ec8:	fffff097          	auipc	ra,0xfffff
    80002ecc:	792080e7          	jalr	1938(ra) # 8000265a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ed0:	0809a583          	lw	a1,128(s3)
    80002ed4:	0009a503          	lw	a0,0(s3)
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	898080e7          	jalr	-1896(ra) # 80002770 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ee0:	0809a023          	sw	zero,128(s3)
    80002ee4:	bf51                	j	80002e78 <itrunc+0x3e>

0000000080002ee6 <iput>:
{
    80002ee6:	1101                	addi	sp,sp,-32
    80002ee8:	ec06                	sd	ra,24(sp)
    80002eea:	e822                	sd	s0,16(sp)
    80002eec:	e426                	sd	s1,8(sp)
    80002eee:	e04a                	sd	s2,0(sp)
    80002ef0:	1000                	addi	s0,sp,32
    80002ef2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ef4:	00234517          	auipc	a0,0x234
    80002ef8:	6a450513          	addi	a0,a0,1700 # 80237598 <itable>
    80002efc:	00003097          	auipc	ra,0x3
    80002f00:	3dc080e7          	jalr	988(ra) # 800062d8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f04:	4498                	lw	a4,8(s1)
    80002f06:	4785                	li	a5,1
    80002f08:	02f70363          	beq	a4,a5,80002f2e <iput+0x48>
  ip->ref--;
    80002f0c:	449c                	lw	a5,8(s1)
    80002f0e:	37fd                	addiw	a5,a5,-1
    80002f10:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f12:	00234517          	auipc	a0,0x234
    80002f16:	68650513          	addi	a0,a0,1670 # 80237598 <itable>
    80002f1a:	00003097          	auipc	ra,0x3
    80002f1e:	472080e7          	jalr	1138(ra) # 8000638c <release>
}
    80002f22:	60e2                	ld	ra,24(sp)
    80002f24:	6442                	ld	s0,16(sp)
    80002f26:	64a2                	ld	s1,8(sp)
    80002f28:	6902                	ld	s2,0(sp)
    80002f2a:	6105                	addi	sp,sp,32
    80002f2c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f2e:	40bc                	lw	a5,64(s1)
    80002f30:	dff1                	beqz	a5,80002f0c <iput+0x26>
    80002f32:	04a49783          	lh	a5,74(s1)
    80002f36:	fbf9                	bnez	a5,80002f0c <iput+0x26>
    acquiresleep(&ip->lock);
    80002f38:	01048913          	addi	s2,s1,16
    80002f3c:	854a                	mv	a0,s2
    80002f3e:	00001097          	auipc	ra,0x1
    80002f42:	abe080e7          	jalr	-1346(ra) # 800039fc <acquiresleep>
    release(&itable.lock);
    80002f46:	00234517          	auipc	a0,0x234
    80002f4a:	65250513          	addi	a0,a0,1618 # 80237598 <itable>
    80002f4e:	00003097          	auipc	ra,0x3
    80002f52:	43e080e7          	jalr	1086(ra) # 8000638c <release>
    itrunc(ip);
    80002f56:	8526                	mv	a0,s1
    80002f58:	00000097          	auipc	ra,0x0
    80002f5c:	ee2080e7          	jalr	-286(ra) # 80002e3a <itrunc>
    ip->type = 0;
    80002f60:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f64:	8526                	mv	a0,s1
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	cfa080e7          	jalr	-774(ra) # 80002c60 <iupdate>
    ip->valid = 0;
    80002f6e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f72:	854a                	mv	a0,s2
    80002f74:	00001097          	auipc	ra,0x1
    80002f78:	ade080e7          	jalr	-1314(ra) # 80003a52 <releasesleep>
    acquire(&itable.lock);
    80002f7c:	00234517          	auipc	a0,0x234
    80002f80:	61c50513          	addi	a0,a0,1564 # 80237598 <itable>
    80002f84:	00003097          	auipc	ra,0x3
    80002f88:	354080e7          	jalr	852(ra) # 800062d8 <acquire>
    80002f8c:	b741                	j	80002f0c <iput+0x26>

0000000080002f8e <iunlockput>:
{
    80002f8e:	1101                	addi	sp,sp,-32
    80002f90:	ec06                	sd	ra,24(sp)
    80002f92:	e822                	sd	s0,16(sp)
    80002f94:	e426                	sd	s1,8(sp)
    80002f96:	1000                	addi	s0,sp,32
    80002f98:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f9a:	00000097          	auipc	ra,0x0
    80002f9e:	e54080e7          	jalr	-428(ra) # 80002dee <iunlock>
  iput(ip);
    80002fa2:	8526                	mv	a0,s1
    80002fa4:	00000097          	auipc	ra,0x0
    80002fa8:	f42080e7          	jalr	-190(ra) # 80002ee6 <iput>
}
    80002fac:	60e2                	ld	ra,24(sp)
    80002fae:	6442                	ld	s0,16(sp)
    80002fb0:	64a2                	ld	s1,8(sp)
    80002fb2:	6105                	addi	sp,sp,32
    80002fb4:	8082                	ret

0000000080002fb6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fb6:	1141                	addi	sp,sp,-16
    80002fb8:	e422                	sd	s0,8(sp)
    80002fba:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fbc:	411c                	lw	a5,0(a0)
    80002fbe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fc0:	415c                	lw	a5,4(a0)
    80002fc2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fc4:	04451783          	lh	a5,68(a0)
    80002fc8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fcc:	04a51783          	lh	a5,74(a0)
    80002fd0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fd4:	04c56783          	lwu	a5,76(a0)
    80002fd8:	e99c                	sd	a5,16(a1)
}
    80002fda:	6422                	ld	s0,8(sp)
    80002fdc:	0141                	addi	sp,sp,16
    80002fde:	8082                	ret

0000000080002fe0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fe0:	457c                	lw	a5,76(a0)
    80002fe2:	0ed7e963          	bltu	a5,a3,800030d4 <readi+0xf4>
{
    80002fe6:	7159                	addi	sp,sp,-112
    80002fe8:	f486                	sd	ra,104(sp)
    80002fea:	f0a2                	sd	s0,96(sp)
    80002fec:	eca6                	sd	s1,88(sp)
    80002fee:	e8ca                	sd	s2,80(sp)
    80002ff0:	e4ce                	sd	s3,72(sp)
    80002ff2:	e0d2                	sd	s4,64(sp)
    80002ff4:	fc56                	sd	s5,56(sp)
    80002ff6:	f85a                	sd	s6,48(sp)
    80002ff8:	f45e                	sd	s7,40(sp)
    80002ffa:	f062                	sd	s8,32(sp)
    80002ffc:	ec66                	sd	s9,24(sp)
    80002ffe:	e86a                	sd	s10,16(sp)
    80003000:	e46e                	sd	s11,8(sp)
    80003002:	1880                	addi	s0,sp,112
    80003004:	8baa                	mv	s7,a0
    80003006:	8c2e                	mv	s8,a1
    80003008:	8ab2                	mv	s5,a2
    8000300a:	84b6                	mv	s1,a3
    8000300c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000300e:	9f35                	addw	a4,a4,a3
    return 0;
    80003010:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003012:	0ad76063          	bltu	a4,a3,800030b2 <readi+0xd2>
  if(off + n > ip->size)
    80003016:	00e7f463          	bgeu	a5,a4,8000301e <readi+0x3e>
    n = ip->size - off;
    8000301a:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000301e:	0a0b0963          	beqz	s6,800030d0 <readi+0xf0>
    80003022:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003024:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003028:	5cfd                	li	s9,-1
    8000302a:	a82d                	j	80003064 <readi+0x84>
    8000302c:	020a1d93          	slli	s11,s4,0x20
    80003030:	020ddd93          	srli	s11,s11,0x20
    80003034:	05890613          	addi	a2,s2,88
    80003038:	86ee                	mv	a3,s11
    8000303a:	963a                	add	a2,a2,a4
    8000303c:	85d6                	mv	a1,s5
    8000303e:	8562                	mv	a0,s8
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	b0c080e7          	jalr	-1268(ra) # 80001b4c <either_copyout>
    80003048:	05950d63          	beq	a0,s9,800030a2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000304c:	854a                	mv	a0,s2
    8000304e:	fffff097          	auipc	ra,0xfffff
    80003052:	60c080e7          	jalr	1548(ra) # 8000265a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003056:	013a09bb          	addw	s3,s4,s3
    8000305a:	009a04bb          	addw	s1,s4,s1
    8000305e:	9aee                	add	s5,s5,s11
    80003060:	0569f763          	bgeu	s3,s6,800030ae <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003064:	000ba903          	lw	s2,0(s7)
    80003068:	00a4d59b          	srliw	a1,s1,0xa
    8000306c:	855e                	mv	a0,s7
    8000306e:	00000097          	auipc	ra,0x0
    80003072:	8ac080e7          	jalr	-1876(ra) # 8000291a <bmap>
    80003076:	0005059b          	sext.w	a1,a0
    8000307a:	854a                	mv	a0,s2
    8000307c:	fffff097          	auipc	ra,0xfffff
    80003080:	4ae080e7          	jalr	1198(ra) # 8000252a <bread>
    80003084:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003086:	3ff4f713          	andi	a4,s1,1023
    8000308a:	40ed07bb          	subw	a5,s10,a4
    8000308e:	413b06bb          	subw	a3,s6,s3
    80003092:	8a3e                	mv	s4,a5
    80003094:	2781                	sext.w	a5,a5
    80003096:	0006861b          	sext.w	a2,a3
    8000309a:	f8f679e3          	bgeu	a2,a5,8000302c <readi+0x4c>
    8000309e:	8a36                	mv	s4,a3
    800030a0:	b771                	j	8000302c <readi+0x4c>
      brelse(bp);
    800030a2:	854a                	mv	a0,s2
    800030a4:	fffff097          	auipc	ra,0xfffff
    800030a8:	5b6080e7          	jalr	1462(ra) # 8000265a <brelse>
      tot = -1;
    800030ac:	59fd                	li	s3,-1
  }
  return tot;
    800030ae:	0009851b          	sext.w	a0,s3
}
    800030b2:	70a6                	ld	ra,104(sp)
    800030b4:	7406                	ld	s0,96(sp)
    800030b6:	64e6                	ld	s1,88(sp)
    800030b8:	6946                	ld	s2,80(sp)
    800030ba:	69a6                	ld	s3,72(sp)
    800030bc:	6a06                	ld	s4,64(sp)
    800030be:	7ae2                	ld	s5,56(sp)
    800030c0:	7b42                	ld	s6,48(sp)
    800030c2:	7ba2                	ld	s7,40(sp)
    800030c4:	7c02                	ld	s8,32(sp)
    800030c6:	6ce2                	ld	s9,24(sp)
    800030c8:	6d42                	ld	s10,16(sp)
    800030ca:	6da2                	ld	s11,8(sp)
    800030cc:	6165                	addi	sp,sp,112
    800030ce:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030d0:	89da                	mv	s3,s6
    800030d2:	bff1                	j	800030ae <readi+0xce>
    return 0;
    800030d4:	4501                	li	a0,0
}
    800030d6:	8082                	ret

00000000800030d8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030d8:	457c                	lw	a5,76(a0)
    800030da:	10d7e863          	bltu	a5,a3,800031ea <writei+0x112>
{
    800030de:	7159                	addi	sp,sp,-112
    800030e0:	f486                	sd	ra,104(sp)
    800030e2:	f0a2                	sd	s0,96(sp)
    800030e4:	eca6                	sd	s1,88(sp)
    800030e6:	e8ca                	sd	s2,80(sp)
    800030e8:	e4ce                	sd	s3,72(sp)
    800030ea:	e0d2                	sd	s4,64(sp)
    800030ec:	fc56                	sd	s5,56(sp)
    800030ee:	f85a                	sd	s6,48(sp)
    800030f0:	f45e                	sd	s7,40(sp)
    800030f2:	f062                	sd	s8,32(sp)
    800030f4:	ec66                	sd	s9,24(sp)
    800030f6:	e86a                	sd	s10,16(sp)
    800030f8:	e46e                	sd	s11,8(sp)
    800030fa:	1880                	addi	s0,sp,112
    800030fc:	8b2a                	mv	s6,a0
    800030fe:	8c2e                	mv	s8,a1
    80003100:	8ab2                	mv	s5,a2
    80003102:	8936                	mv	s2,a3
    80003104:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003106:	00e687bb          	addw	a5,a3,a4
    8000310a:	0ed7e263          	bltu	a5,a3,800031ee <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000310e:	00043737          	lui	a4,0x43
    80003112:	0ef76063          	bltu	a4,a5,800031f2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003116:	0c0b8863          	beqz	s7,800031e6 <writei+0x10e>
    8000311a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000311c:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003120:	5cfd                	li	s9,-1
    80003122:	a091                	j	80003166 <writei+0x8e>
    80003124:	02099d93          	slli	s11,s3,0x20
    80003128:	020ddd93          	srli	s11,s11,0x20
    8000312c:	05848513          	addi	a0,s1,88
    80003130:	86ee                	mv	a3,s11
    80003132:	8656                	mv	a2,s5
    80003134:	85e2                	mv	a1,s8
    80003136:	953a                	add	a0,a0,a4
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	a6a080e7          	jalr	-1430(ra) # 80001ba2 <either_copyin>
    80003140:	07950263          	beq	a0,s9,800031a4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003144:	8526                	mv	a0,s1
    80003146:	00000097          	auipc	ra,0x0
    8000314a:	798080e7          	jalr	1944(ra) # 800038de <log_write>
    brelse(bp);
    8000314e:	8526                	mv	a0,s1
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	50a080e7          	jalr	1290(ra) # 8000265a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003158:	01498a3b          	addw	s4,s3,s4
    8000315c:	0129893b          	addw	s2,s3,s2
    80003160:	9aee                	add	s5,s5,s11
    80003162:	057a7663          	bgeu	s4,s7,800031ae <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003166:	000b2483          	lw	s1,0(s6)
    8000316a:	00a9559b          	srliw	a1,s2,0xa
    8000316e:	855a                	mv	a0,s6
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	7aa080e7          	jalr	1962(ra) # 8000291a <bmap>
    80003178:	0005059b          	sext.w	a1,a0
    8000317c:	8526                	mv	a0,s1
    8000317e:	fffff097          	auipc	ra,0xfffff
    80003182:	3ac080e7          	jalr	940(ra) # 8000252a <bread>
    80003186:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003188:	3ff97713          	andi	a4,s2,1023
    8000318c:	40ed07bb          	subw	a5,s10,a4
    80003190:	414b86bb          	subw	a3,s7,s4
    80003194:	89be                	mv	s3,a5
    80003196:	2781                	sext.w	a5,a5
    80003198:	0006861b          	sext.w	a2,a3
    8000319c:	f8f674e3          	bgeu	a2,a5,80003124 <writei+0x4c>
    800031a0:	89b6                	mv	s3,a3
    800031a2:	b749                	j	80003124 <writei+0x4c>
      brelse(bp);
    800031a4:	8526                	mv	a0,s1
    800031a6:	fffff097          	auipc	ra,0xfffff
    800031aa:	4b4080e7          	jalr	1204(ra) # 8000265a <brelse>
  }

  if(off > ip->size)
    800031ae:	04cb2783          	lw	a5,76(s6)
    800031b2:	0127f463          	bgeu	a5,s2,800031ba <writei+0xe2>
    ip->size = off;
    800031b6:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031ba:	855a                	mv	a0,s6
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	aa4080e7          	jalr	-1372(ra) # 80002c60 <iupdate>

  return tot;
    800031c4:	000a051b          	sext.w	a0,s4
}
    800031c8:	70a6                	ld	ra,104(sp)
    800031ca:	7406                	ld	s0,96(sp)
    800031cc:	64e6                	ld	s1,88(sp)
    800031ce:	6946                	ld	s2,80(sp)
    800031d0:	69a6                	ld	s3,72(sp)
    800031d2:	6a06                	ld	s4,64(sp)
    800031d4:	7ae2                	ld	s5,56(sp)
    800031d6:	7b42                	ld	s6,48(sp)
    800031d8:	7ba2                	ld	s7,40(sp)
    800031da:	7c02                	ld	s8,32(sp)
    800031dc:	6ce2                	ld	s9,24(sp)
    800031de:	6d42                	ld	s10,16(sp)
    800031e0:	6da2                	ld	s11,8(sp)
    800031e2:	6165                	addi	sp,sp,112
    800031e4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031e6:	8a5e                	mv	s4,s7
    800031e8:	bfc9                	j	800031ba <writei+0xe2>
    return -1;
    800031ea:	557d                	li	a0,-1
}
    800031ec:	8082                	ret
    return -1;
    800031ee:	557d                	li	a0,-1
    800031f0:	bfe1                	j	800031c8 <writei+0xf0>
    return -1;
    800031f2:	557d                	li	a0,-1
    800031f4:	bfd1                	j	800031c8 <writei+0xf0>

00000000800031f6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031f6:	1141                	addi	sp,sp,-16
    800031f8:	e406                	sd	ra,8(sp)
    800031fa:	e022                	sd	s0,0(sp)
    800031fc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031fe:	4639                	li	a2,14
    80003200:	ffffd097          	auipc	ra,0xffffd
    80003204:	16e080e7          	jalr	366(ra) # 8000036e <strncmp>
}
    80003208:	60a2                	ld	ra,8(sp)
    8000320a:	6402                	ld	s0,0(sp)
    8000320c:	0141                	addi	sp,sp,16
    8000320e:	8082                	ret

0000000080003210 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003210:	7139                	addi	sp,sp,-64
    80003212:	fc06                	sd	ra,56(sp)
    80003214:	f822                	sd	s0,48(sp)
    80003216:	f426                	sd	s1,40(sp)
    80003218:	f04a                	sd	s2,32(sp)
    8000321a:	ec4e                	sd	s3,24(sp)
    8000321c:	e852                	sd	s4,16(sp)
    8000321e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003220:	04451703          	lh	a4,68(a0)
    80003224:	4785                	li	a5,1
    80003226:	00f71a63          	bne	a4,a5,8000323a <dirlookup+0x2a>
    8000322a:	892a                	mv	s2,a0
    8000322c:	89ae                	mv	s3,a1
    8000322e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003230:	457c                	lw	a5,76(a0)
    80003232:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003234:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003236:	e79d                	bnez	a5,80003264 <dirlookup+0x54>
    80003238:	a8a5                	j	800032b0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000323a:	00005517          	auipc	a0,0x5
    8000323e:	3e650513          	addi	a0,a0,998 # 80008620 <syscalls+0x1a0>
    80003242:	00003097          	auipc	ra,0x3
    80003246:	b5e080e7          	jalr	-1186(ra) # 80005da0 <panic>
      panic("dirlookup read");
    8000324a:	00005517          	auipc	a0,0x5
    8000324e:	3ee50513          	addi	a0,a0,1006 # 80008638 <syscalls+0x1b8>
    80003252:	00003097          	auipc	ra,0x3
    80003256:	b4e080e7          	jalr	-1202(ra) # 80005da0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325a:	24c1                	addiw	s1,s1,16
    8000325c:	04c92783          	lw	a5,76(s2)
    80003260:	04f4f763          	bgeu	s1,a5,800032ae <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003264:	4741                	li	a4,16
    80003266:	86a6                	mv	a3,s1
    80003268:	fc040613          	addi	a2,s0,-64
    8000326c:	4581                	li	a1,0
    8000326e:	854a                	mv	a0,s2
    80003270:	00000097          	auipc	ra,0x0
    80003274:	d70080e7          	jalr	-656(ra) # 80002fe0 <readi>
    80003278:	47c1                	li	a5,16
    8000327a:	fcf518e3          	bne	a0,a5,8000324a <dirlookup+0x3a>
    if(de.inum == 0)
    8000327e:	fc045783          	lhu	a5,-64(s0)
    80003282:	dfe1                	beqz	a5,8000325a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003284:	fc240593          	addi	a1,s0,-62
    80003288:	854e                	mv	a0,s3
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	f6c080e7          	jalr	-148(ra) # 800031f6 <namecmp>
    80003292:	f561                	bnez	a0,8000325a <dirlookup+0x4a>
      if(poff)
    80003294:	000a0463          	beqz	s4,8000329c <dirlookup+0x8c>
        *poff = off;
    80003298:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000329c:	fc045583          	lhu	a1,-64(s0)
    800032a0:	00092503          	lw	a0,0(s2)
    800032a4:	fffff097          	auipc	ra,0xfffff
    800032a8:	752080e7          	jalr	1874(ra) # 800029f6 <iget>
    800032ac:	a011                	j	800032b0 <dirlookup+0xa0>
  return 0;
    800032ae:	4501                	li	a0,0
}
    800032b0:	70e2                	ld	ra,56(sp)
    800032b2:	7442                	ld	s0,48(sp)
    800032b4:	74a2                	ld	s1,40(sp)
    800032b6:	7902                	ld	s2,32(sp)
    800032b8:	69e2                	ld	s3,24(sp)
    800032ba:	6a42                	ld	s4,16(sp)
    800032bc:	6121                	addi	sp,sp,64
    800032be:	8082                	ret

00000000800032c0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032c0:	711d                	addi	sp,sp,-96
    800032c2:	ec86                	sd	ra,88(sp)
    800032c4:	e8a2                	sd	s0,80(sp)
    800032c6:	e4a6                	sd	s1,72(sp)
    800032c8:	e0ca                	sd	s2,64(sp)
    800032ca:	fc4e                	sd	s3,56(sp)
    800032cc:	f852                	sd	s4,48(sp)
    800032ce:	f456                	sd	s5,40(sp)
    800032d0:	f05a                	sd	s6,32(sp)
    800032d2:	ec5e                	sd	s7,24(sp)
    800032d4:	e862                	sd	s8,16(sp)
    800032d6:	e466                	sd	s9,8(sp)
    800032d8:	e06a                	sd	s10,0(sp)
    800032da:	1080                	addi	s0,sp,96
    800032dc:	84aa                	mv	s1,a0
    800032de:	8b2e                	mv	s6,a1
    800032e0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032e2:	00054703          	lbu	a4,0(a0)
    800032e6:	02f00793          	li	a5,47
    800032ea:	02f70363          	beq	a4,a5,80003310 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032ee:	ffffe097          	auipc	ra,0xffffe
    800032f2:	df6080e7          	jalr	-522(ra) # 800010e4 <myproc>
    800032f6:	15053503          	ld	a0,336(a0)
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	9f4080e7          	jalr	-1548(ra) # 80002cee <idup>
    80003302:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003304:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003308:	4cb5                	li	s9,13
  len = path - s;
    8000330a:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000330c:	4c05                	li	s8,1
    8000330e:	a87d                	j	800033cc <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003310:	4585                	li	a1,1
    80003312:	4505                	li	a0,1
    80003314:	fffff097          	auipc	ra,0xfffff
    80003318:	6e2080e7          	jalr	1762(ra) # 800029f6 <iget>
    8000331c:	8a2a                	mv	s4,a0
    8000331e:	b7dd                	j	80003304 <namex+0x44>
      iunlockput(ip);
    80003320:	8552                	mv	a0,s4
    80003322:	00000097          	auipc	ra,0x0
    80003326:	c6c080e7          	jalr	-916(ra) # 80002f8e <iunlockput>
      return 0;
    8000332a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000332c:	8552                	mv	a0,s4
    8000332e:	60e6                	ld	ra,88(sp)
    80003330:	6446                	ld	s0,80(sp)
    80003332:	64a6                	ld	s1,72(sp)
    80003334:	6906                	ld	s2,64(sp)
    80003336:	79e2                	ld	s3,56(sp)
    80003338:	7a42                	ld	s4,48(sp)
    8000333a:	7aa2                	ld	s5,40(sp)
    8000333c:	7b02                	ld	s6,32(sp)
    8000333e:	6be2                	ld	s7,24(sp)
    80003340:	6c42                	ld	s8,16(sp)
    80003342:	6ca2                	ld	s9,8(sp)
    80003344:	6d02                	ld	s10,0(sp)
    80003346:	6125                	addi	sp,sp,96
    80003348:	8082                	ret
      iunlock(ip);
    8000334a:	8552                	mv	a0,s4
    8000334c:	00000097          	auipc	ra,0x0
    80003350:	aa2080e7          	jalr	-1374(ra) # 80002dee <iunlock>
      return ip;
    80003354:	bfe1                	j	8000332c <namex+0x6c>
      iunlockput(ip);
    80003356:	8552                	mv	a0,s4
    80003358:	00000097          	auipc	ra,0x0
    8000335c:	c36080e7          	jalr	-970(ra) # 80002f8e <iunlockput>
      return 0;
    80003360:	8a4e                	mv	s4,s3
    80003362:	b7e9                	j	8000332c <namex+0x6c>
  len = path - s;
    80003364:	40998633          	sub	a2,s3,s1
    80003368:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000336c:	09acd863          	bge	s9,s10,800033fc <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003370:	4639                	li	a2,14
    80003372:	85a6                	mv	a1,s1
    80003374:	8556                	mv	a0,s5
    80003376:	ffffd097          	auipc	ra,0xffffd
    8000337a:	f84080e7          	jalr	-124(ra) # 800002fa <memmove>
    8000337e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003380:	0004c783          	lbu	a5,0(s1)
    80003384:	01279763          	bne	a5,s2,80003392 <namex+0xd2>
    path++;
    80003388:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000338a:	0004c783          	lbu	a5,0(s1)
    8000338e:	ff278de3          	beq	a5,s2,80003388 <namex+0xc8>
    ilock(ip);
    80003392:	8552                	mv	a0,s4
    80003394:	00000097          	auipc	ra,0x0
    80003398:	998080e7          	jalr	-1640(ra) # 80002d2c <ilock>
    if(ip->type != T_DIR){
    8000339c:	044a1783          	lh	a5,68(s4)
    800033a0:	f98790e3          	bne	a5,s8,80003320 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800033a4:	000b0563          	beqz	s6,800033ae <namex+0xee>
    800033a8:	0004c783          	lbu	a5,0(s1)
    800033ac:	dfd9                	beqz	a5,8000334a <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033ae:	865e                	mv	a2,s7
    800033b0:	85d6                	mv	a1,s5
    800033b2:	8552                	mv	a0,s4
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	e5c080e7          	jalr	-420(ra) # 80003210 <dirlookup>
    800033bc:	89aa                	mv	s3,a0
    800033be:	dd41                	beqz	a0,80003356 <namex+0x96>
    iunlockput(ip);
    800033c0:	8552                	mv	a0,s4
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	bcc080e7          	jalr	-1076(ra) # 80002f8e <iunlockput>
    ip = next;
    800033ca:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033cc:	0004c783          	lbu	a5,0(s1)
    800033d0:	01279763          	bne	a5,s2,800033de <namex+0x11e>
    path++;
    800033d4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033d6:	0004c783          	lbu	a5,0(s1)
    800033da:	ff278de3          	beq	a5,s2,800033d4 <namex+0x114>
  if(*path == 0)
    800033de:	cb9d                	beqz	a5,80003414 <namex+0x154>
  while(*path != '/' && *path != 0)
    800033e0:	0004c783          	lbu	a5,0(s1)
    800033e4:	89a6                	mv	s3,s1
  len = path - s;
    800033e6:	8d5e                	mv	s10,s7
    800033e8:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033ea:	01278963          	beq	a5,s2,800033fc <namex+0x13c>
    800033ee:	dbbd                	beqz	a5,80003364 <namex+0xa4>
    path++;
    800033f0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033f2:	0009c783          	lbu	a5,0(s3)
    800033f6:	ff279ce3          	bne	a5,s2,800033ee <namex+0x12e>
    800033fa:	b7ad                	j	80003364 <namex+0xa4>
    memmove(name, s, len);
    800033fc:	2601                	sext.w	a2,a2
    800033fe:	85a6                	mv	a1,s1
    80003400:	8556                	mv	a0,s5
    80003402:	ffffd097          	auipc	ra,0xffffd
    80003406:	ef8080e7          	jalr	-264(ra) # 800002fa <memmove>
    name[len] = 0;
    8000340a:	9d56                	add	s10,s10,s5
    8000340c:	000d0023          	sb	zero,0(s10)
    80003410:	84ce                	mv	s1,s3
    80003412:	b7bd                	j	80003380 <namex+0xc0>
  if(nameiparent){
    80003414:	f00b0ce3          	beqz	s6,8000332c <namex+0x6c>
    iput(ip);
    80003418:	8552                	mv	a0,s4
    8000341a:	00000097          	auipc	ra,0x0
    8000341e:	acc080e7          	jalr	-1332(ra) # 80002ee6 <iput>
    return 0;
    80003422:	4a01                	li	s4,0
    80003424:	b721                	j	8000332c <namex+0x6c>

0000000080003426 <dirlink>:
{
    80003426:	7139                	addi	sp,sp,-64
    80003428:	fc06                	sd	ra,56(sp)
    8000342a:	f822                	sd	s0,48(sp)
    8000342c:	f426                	sd	s1,40(sp)
    8000342e:	f04a                	sd	s2,32(sp)
    80003430:	ec4e                	sd	s3,24(sp)
    80003432:	e852                	sd	s4,16(sp)
    80003434:	0080                	addi	s0,sp,64
    80003436:	892a                	mv	s2,a0
    80003438:	8a2e                	mv	s4,a1
    8000343a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000343c:	4601                	li	a2,0
    8000343e:	00000097          	auipc	ra,0x0
    80003442:	dd2080e7          	jalr	-558(ra) # 80003210 <dirlookup>
    80003446:	e93d                	bnez	a0,800034bc <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003448:	04c92483          	lw	s1,76(s2)
    8000344c:	c49d                	beqz	s1,8000347a <dirlink+0x54>
    8000344e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003450:	4741                	li	a4,16
    80003452:	86a6                	mv	a3,s1
    80003454:	fc040613          	addi	a2,s0,-64
    80003458:	4581                	li	a1,0
    8000345a:	854a                	mv	a0,s2
    8000345c:	00000097          	auipc	ra,0x0
    80003460:	b84080e7          	jalr	-1148(ra) # 80002fe0 <readi>
    80003464:	47c1                	li	a5,16
    80003466:	06f51163          	bne	a0,a5,800034c8 <dirlink+0xa2>
    if(de.inum == 0)
    8000346a:	fc045783          	lhu	a5,-64(s0)
    8000346e:	c791                	beqz	a5,8000347a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003470:	24c1                	addiw	s1,s1,16
    80003472:	04c92783          	lw	a5,76(s2)
    80003476:	fcf4ede3          	bltu	s1,a5,80003450 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000347a:	4639                	li	a2,14
    8000347c:	85d2                	mv	a1,s4
    8000347e:	fc240513          	addi	a0,s0,-62
    80003482:	ffffd097          	auipc	ra,0xffffd
    80003486:	f28080e7          	jalr	-216(ra) # 800003aa <strncpy>
  de.inum = inum;
    8000348a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000348e:	4741                	li	a4,16
    80003490:	86a6                	mv	a3,s1
    80003492:	fc040613          	addi	a2,s0,-64
    80003496:	4581                	li	a1,0
    80003498:	854a                	mv	a0,s2
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	c3e080e7          	jalr	-962(ra) # 800030d8 <writei>
    800034a2:	872a                	mv	a4,a0
    800034a4:	47c1                	li	a5,16
  return 0;
    800034a6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034a8:	02f71863          	bne	a4,a5,800034d8 <dirlink+0xb2>
}
    800034ac:	70e2                	ld	ra,56(sp)
    800034ae:	7442                	ld	s0,48(sp)
    800034b0:	74a2                	ld	s1,40(sp)
    800034b2:	7902                	ld	s2,32(sp)
    800034b4:	69e2                	ld	s3,24(sp)
    800034b6:	6a42                	ld	s4,16(sp)
    800034b8:	6121                	addi	sp,sp,64
    800034ba:	8082                	ret
    iput(ip);
    800034bc:	00000097          	auipc	ra,0x0
    800034c0:	a2a080e7          	jalr	-1494(ra) # 80002ee6 <iput>
    return -1;
    800034c4:	557d                	li	a0,-1
    800034c6:	b7dd                	j	800034ac <dirlink+0x86>
      panic("dirlink read");
    800034c8:	00005517          	auipc	a0,0x5
    800034cc:	18050513          	addi	a0,a0,384 # 80008648 <syscalls+0x1c8>
    800034d0:	00003097          	auipc	ra,0x3
    800034d4:	8d0080e7          	jalr	-1840(ra) # 80005da0 <panic>
    panic("dirlink");
    800034d8:	00005517          	auipc	a0,0x5
    800034dc:	28050513          	addi	a0,a0,640 # 80008758 <syscalls+0x2d8>
    800034e0:	00003097          	auipc	ra,0x3
    800034e4:	8c0080e7          	jalr	-1856(ra) # 80005da0 <panic>

00000000800034e8 <namei>:

struct inode*
namei(char *path)
{
    800034e8:	1101                	addi	sp,sp,-32
    800034ea:	ec06                	sd	ra,24(sp)
    800034ec:	e822                	sd	s0,16(sp)
    800034ee:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034f0:	fe040613          	addi	a2,s0,-32
    800034f4:	4581                	li	a1,0
    800034f6:	00000097          	auipc	ra,0x0
    800034fa:	dca080e7          	jalr	-566(ra) # 800032c0 <namex>
}
    800034fe:	60e2                	ld	ra,24(sp)
    80003500:	6442                	ld	s0,16(sp)
    80003502:	6105                	addi	sp,sp,32
    80003504:	8082                	ret

0000000080003506 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003506:	1141                	addi	sp,sp,-16
    80003508:	e406                	sd	ra,8(sp)
    8000350a:	e022                	sd	s0,0(sp)
    8000350c:	0800                	addi	s0,sp,16
    8000350e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003510:	4585                	li	a1,1
    80003512:	00000097          	auipc	ra,0x0
    80003516:	dae080e7          	jalr	-594(ra) # 800032c0 <namex>
}
    8000351a:	60a2                	ld	ra,8(sp)
    8000351c:	6402                	ld	s0,0(sp)
    8000351e:	0141                	addi	sp,sp,16
    80003520:	8082                	ret

0000000080003522 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003522:	1101                	addi	sp,sp,-32
    80003524:	ec06                	sd	ra,24(sp)
    80003526:	e822                	sd	s0,16(sp)
    80003528:	e426                	sd	s1,8(sp)
    8000352a:	e04a                	sd	s2,0(sp)
    8000352c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000352e:	00236917          	auipc	s2,0x236
    80003532:	b1290913          	addi	s2,s2,-1262 # 80239040 <log>
    80003536:	01892583          	lw	a1,24(s2)
    8000353a:	02892503          	lw	a0,40(s2)
    8000353e:	fffff097          	auipc	ra,0xfffff
    80003542:	fec080e7          	jalr	-20(ra) # 8000252a <bread>
    80003546:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003548:	02c92683          	lw	a3,44(s2)
    8000354c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000354e:	02d05863          	blez	a3,8000357e <write_head+0x5c>
    80003552:	00236797          	auipc	a5,0x236
    80003556:	b1e78793          	addi	a5,a5,-1250 # 80239070 <log+0x30>
    8000355a:	05c50713          	addi	a4,a0,92
    8000355e:	36fd                	addiw	a3,a3,-1
    80003560:	02069613          	slli	a2,a3,0x20
    80003564:	01e65693          	srli	a3,a2,0x1e
    80003568:	00236617          	auipc	a2,0x236
    8000356c:	b0c60613          	addi	a2,a2,-1268 # 80239074 <log+0x34>
    80003570:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003572:	4390                	lw	a2,0(a5)
    80003574:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003576:	0791                	addi	a5,a5,4
    80003578:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000357a:	fed79ce3          	bne	a5,a3,80003572 <write_head+0x50>
  }
  bwrite(buf);
    8000357e:	8526                	mv	a0,s1
    80003580:	fffff097          	auipc	ra,0xfffff
    80003584:	09c080e7          	jalr	156(ra) # 8000261c <bwrite>
  brelse(buf);
    80003588:	8526                	mv	a0,s1
    8000358a:	fffff097          	auipc	ra,0xfffff
    8000358e:	0d0080e7          	jalr	208(ra) # 8000265a <brelse>
}
    80003592:	60e2                	ld	ra,24(sp)
    80003594:	6442                	ld	s0,16(sp)
    80003596:	64a2                	ld	s1,8(sp)
    80003598:	6902                	ld	s2,0(sp)
    8000359a:	6105                	addi	sp,sp,32
    8000359c:	8082                	ret

000000008000359e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000359e:	00236797          	auipc	a5,0x236
    800035a2:	ace7a783          	lw	a5,-1330(a5) # 8023906c <log+0x2c>
    800035a6:	0af05d63          	blez	a5,80003660 <install_trans+0xc2>
{
    800035aa:	7139                	addi	sp,sp,-64
    800035ac:	fc06                	sd	ra,56(sp)
    800035ae:	f822                	sd	s0,48(sp)
    800035b0:	f426                	sd	s1,40(sp)
    800035b2:	f04a                	sd	s2,32(sp)
    800035b4:	ec4e                	sd	s3,24(sp)
    800035b6:	e852                	sd	s4,16(sp)
    800035b8:	e456                	sd	s5,8(sp)
    800035ba:	e05a                	sd	s6,0(sp)
    800035bc:	0080                	addi	s0,sp,64
    800035be:	8b2a                	mv	s6,a0
    800035c0:	00236a97          	auipc	s5,0x236
    800035c4:	ab0a8a93          	addi	s5,s5,-1360 # 80239070 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035c8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035ca:	00236997          	auipc	s3,0x236
    800035ce:	a7698993          	addi	s3,s3,-1418 # 80239040 <log>
    800035d2:	a00d                	j	800035f4 <install_trans+0x56>
    brelse(lbuf);
    800035d4:	854a                	mv	a0,s2
    800035d6:	fffff097          	auipc	ra,0xfffff
    800035da:	084080e7          	jalr	132(ra) # 8000265a <brelse>
    brelse(dbuf);
    800035de:	8526                	mv	a0,s1
    800035e0:	fffff097          	auipc	ra,0xfffff
    800035e4:	07a080e7          	jalr	122(ra) # 8000265a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e8:	2a05                	addiw	s4,s4,1
    800035ea:	0a91                	addi	s5,s5,4
    800035ec:	02c9a783          	lw	a5,44(s3)
    800035f0:	04fa5e63          	bge	s4,a5,8000364c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035f4:	0189a583          	lw	a1,24(s3)
    800035f8:	014585bb          	addw	a1,a1,s4
    800035fc:	2585                	addiw	a1,a1,1
    800035fe:	0289a503          	lw	a0,40(s3)
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	f28080e7          	jalr	-216(ra) # 8000252a <bread>
    8000360a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000360c:	000aa583          	lw	a1,0(s5)
    80003610:	0289a503          	lw	a0,40(s3)
    80003614:	fffff097          	auipc	ra,0xfffff
    80003618:	f16080e7          	jalr	-234(ra) # 8000252a <bread>
    8000361c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000361e:	40000613          	li	a2,1024
    80003622:	05890593          	addi	a1,s2,88
    80003626:	05850513          	addi	a0,a0,88
    8000362a:	ffffd097          	auipc	ra,0xffffd
    8000362e:	cd0080e7          	jalr	-816(ra) # 800002fa <memmove>
    bwrite(dbuf);  // write dst to disk
    80003632:	8526                	mv	a0,s1
    80003634:	fffff097          	auipc	ra,0xfffff
    80003638:	fe8080e7          	jalr	-24(ra) # 8000261c <bwrite>
    if(recovering == 0)
    8000363c:	f80b1ce3          	bnez	s6,800035d4 <install_trans+0x36>
      bunpin(dbuf);
    80003640:	8526                	mv	a0,s1
    80003642:	fffff097          	auipc	ra,0xfffff
    80003646:	0f2080e7          	jalr	242(ra) # 80002734 <bunpin>
    8000364a:	b769                	j	800035d4 <install_trans+0x36>
}
    8000364c:	70e2                	ld	ra,56(sp)
    8000364e:	7442                	ld	s0,48(sp)
    80003650:	74a2                	ld	s1,40(sp)
    80003652:	7902                	ld	s2,32(sp)
    80003654:	69e2                	ld	s3,24(sp)
    80003656:	6a42                	ld	s4,16(sp)
    80003658:	6aa2                	ld	s5,8(sp)
    8000365a:	6b02                	ld	s6,0(sp)
    8000365c:	6121                	addi	sp,sp,64
    8000365e:	8082                	ret
    80003660:	8082                	ret

0000000080003662 <initlog>:
{
    80003662:	7179                	addi	sp,sp,-48
    80003664:	f406                	sd	ra,40(sp)
    80003666:	f022                	sd	s0,32(sp)
    80003668:	ec26                	sd	s1,24(sp)
    8000366a:	e84a                	sd	s2,16(sp)
    8000366c:	e44e                	sd	s3,8(sp)
    8000366e:	1800                	addi	s0,sp,48
    80003670:	892a                	mv	s2,a0
    80003672:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003674:	00236497          	auipc	s1,0x236
    80003678:	9cc48493          	addi	s1,s1,-1588 # 80239040 <log>
    8000367c:	00005597          	auipc	a1,0x5
    80003680:	fdc58593          	addi	a1,a1,-36 # 80008658 <syscalls+0x1d8>
    80003684:	8526                	mv	a0,s1
    80003686:	00003097          	auipc	ra,0x3
    8000368a:	bc2080e7          	jalr	-1086(ra) # 80006248 <initlock>
  log.start = sb->logstart;
    8000368e:	0149a583          	lw	a1,20(s3)
    80003692:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003694:	0109a783          	lw	a5,16(s3)
    80003698:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000369a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000369e:	854a                	mv	a0,s2
    800036a0:	fffff097          	auipc	ra,0xfffff
    800036a4:	e8a080e7          	jalr	-374(ra) # 8000252a <bread>
  log.lh.n = lh->n;
    800036a8:	4d34                	lw	a3,88(a0)
    800036aa:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036ac:	02d05663          	blez	a3,800036d8 <initlog+0x76>
    800036b0:	05c50793          	addi	a5,a0,92
    800036b4:	00236717          	auipc	a4,0x236
    800036b8:	9bc70713          	addi	a4,a4,-1604 # 80239070 <log+0x30>
    800036bc:	36fd                	addiw	a3,a3,-1
    800036be:	02069613          	slli	a2,a3,0x20
    800036c2:	01e65693          	srli	a3,a2,0x1e
    800036c6:	06050613          	addi	a2,a0,96
    800036ca:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800036cc:	4390                	lw	a2,0(a5)
    800036ce:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036d0:	0791                	addi	a5,a5,4
    800036d2:	0711                	addi	a4,a4,4
    800036d4:	fed79ce3          	bne	a5,a3,800036cc <initlog+0x6a>
  brelse(buf);
    800036d8:	fffff097          	auipc	ra,0xfffff
    800036dc:	f82080e7          	jalr	-126(ra) # 8000265a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036e0:	4505                	li	a0,1
    800036e2:	00000097          	auipc	ra,0x0
    800036e6:	ebc080e7          	jalr	-324(ra) # 8000359e <install_trans>
  log.lh.n = 0;
    800036ea:	00236797          	auipc	a5,0x236
    800036ee:	9807a123          	sw	zero,-1662(a5) # 8023906c <log+0x2c>
  write_head(); // clear the log
    800036f2:	00000097          	auipc	ra,0x0
    800036f6:	e30080e7          	jalr	-464(ra) # 80003522 <write_head>
}
    800036fa:	70a2                	ld	ra,40(sp)
    800036fc:	7402                	ld	s0,32(sp)
    800036fe:	64e2                	ld	s1,24(sp)
    80003700:	6942                	ld	s2,16(sp)
    80003702:	69a2                	ld	s3,8(sp)
    80003704:	6145                	addi	sp,sp,48
    80003706:	8082                	ret

0000000080003708 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003708:	1101                	addi	sp,sp,-32
    8000370a:	ec06                	sd	ra,24(sp)
    8000370c:	e822                	sd	s0,16(sp)
    8000370e:	e426                	sd	s1,8(sp)
    80003710:	e04a                	sd	s2,0(sp)
    80003712:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003714:	00236517          	auipc	a0,0x236
    80003718:	92c50513          	addi	a0,a0,-1748 # 80239040 <log>
    8000371c:	00003097          	auipc	ra,0x3
    80003720:	bbc080e7          	jalr	-1092(ra) # 800062d8 <acquire>
  while(1){
    if(log.committing){
    80003724:	00236497          	auipc	s1,0x236
    80003728:	91c48493          	addi	s1,s1,-1764 # 80239040 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000372c:	4979                	li	s2,30
    8000372e:	a039                	j	8000373c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003730:	85a6                	mv	a1,s1
    80003732:	8526                	mv	a0,s1
    80003734:	ffffe097          	auipc	ra,0xffffe
    80003738:	074080e7          	jalr	116(ra) # 800017a8 <sleep>
    if(log.committing){
    8000373c:	50dc                	lw	a5,36(s1)
    8000373e:	fbed                	bnez	a5,80003730 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003740:	5098                	lw	a4,32(s1)
    80003742:	2705                	addiw	a4,a4,1
    80003744:	0007069b          	sext.w	a3,a4
    80003748:	0027179b          	slliw	a5,a4,0x2
    8000374c:	9fb9                	addw	a5,a5,a4
    8000374e:	0017979b          	slliw	a5,a5,0x1
    80003752:	54d8                	lw	a4,44(s1)
    80003754:	9fb9                	addw	a5,a5,a4
    80003756:	00f95963          	bge	s2,a5,80003768 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000375a:	85a6                	mv	a1,s1
    8000375c:	8526                	mv	a0,s1
    8000375e:	ffffe097          	auipc	ra,0xffffe
    80003762:	04a080e7          	jalr	74(ra) # 800017a8 <sleep>
    80003766:	bfd9                	j	8000373c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003768:	00236517          	auipc	a0,0x236
    8000376c:	8d850513          	addi	a0,a0,-1832 # 80239040 <log>
    80003770:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003772:	00003097          	auipc	ra,0x3
    80003776:	c1a080e7          	jalr	-998(ra) # 8000638c <release>
      break;
    }
  }
}
    8000377a:	60e2                	ld	ra,24(sp)
    8000377c:	6442                	ld	s0,16(sp)
    8000377e:	64a2                	ld	s1,8(sp)
    80003780:	6902                	ld	s2,0(sp)
    80003782:	6105                	addi	sp,sp,32
    80003784:	8082                	ret

0000000080003786 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003786:	7139                	addi	sp,sp,-64
    80003788:	fc06                	sd	ra,56(sp)
    8000378a:	f822                	sd	s0,48(sp)
    8000378c:	f426                	sd	s1,40(sp)
    8000378e:	f04a                	sd	s2,32(sp)
    80003790:	ec4e                	sd	s3,24(sp)
    80003792:	e852                	sd	s4,16(sp)
    80003794:	e456                	sd	s5,8(sp)
    80003796:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003798:	00236497          	auipc	s1,0x236
    8000379c:	8a848493          	addi	s1,s1,-1880 # 80239040 <log>
    800037a0:	8526                	mv	a0,s1
    800037a2:	00003097          	auipc	ra,0x3
    800037a6:	b36080e7          	jalr	-1226(ra) # 800062d8 <acquire>
  log.outstanding -= 1;
    800037aa:	509c                	lw	a5,32(s1)
    800037ac:	37fd                	addiw	a5,a5,-1
    800037ae:	0007891b          	sext.w	s2,a5
    800037b2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037b4:	50dc                	lw	a5,36(s1)
    800037b6:	e7b9                	bnez	a5,80003804 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037b8:	04091e63          	bnez	s2,80003814 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037bc:	00236497          	auipc	s1,0x236
    800037c0:	88448493          	addi	s1,s1,-1916 # 80239040 <log>
    800037c4:	4785                	li	a5,1
    800037c6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037c8:	8526                	mv	a0,s1
    800037ca:	00003097          	auipc	ra,0x3
    800037ce:	bc2080e7          	jalr	-1086(ra) # 8000638c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037d2:	54dc                	lw	a5,44(s1)
    800037d4:	06f04763          	bgtz	a5,80003842 <end_op+0xbc>
    acquire(&log.lock);
    800037d8:	00236497          	auipc	s1,0x236
    800037dc:	86848493          	addi	s1,s1,-1944 # 80239040 <log>
    800037e0:	8526                	mv	a0,s1
    800037e2:	00003097          	auipc	ra,0x3
    800037e6:	af6080e7          	jalr	-1290(ra) # 800062d8 <acquire>
    log.committing = 0;
    800037ea:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037ee:	8526                	mv	a0,s1
    800037f0:	ffffe097          	auipc	ra,0xffffe
    800037f4:	144080e7          	jalr	324(ra) # 80001934 <wakeup>
    release(&log.lock);
    800037f8:	8526                	mv	a0,s1
    800037fa:	00003097          	auipc	ra,0x3
    800037fe:	b92080e7          	jalr	-1134(ra) # 8000638c <release>
}
    80003802:	a03d                	j	80003830 <end_op+0xaa>
    panic("log.committing");
    80003804:	00005517          	auipc	a0,0x5
    80003808:	e5c50513          	addi	a0,a0,-420 # 80008660 <syscalls+0x1e0>
    8000380c:	00002097          	auipc	ra,0x2
    80003810:	594080e7          	jalr	1428(ra) # 80005da0 <panic>
    wakeup(&log);
    80003814:	00236497          	auipc	s1,0x236
    80003818:	82c48493          	addi	s1,s1,-2004 # 80239040 <log>
    8000381c:	8526                	mv	a0,s1
    8000381e:	ffffe097          	auipc	ra,0xffffe
    80003822:	116080e7          	jalr	278(ra) # 80001934 <wakeup>
  release(&log.lock);
    80003826:	8526                	mv	a0,s1
    80003828:	00003097          	auipc	ra,0x3
    8000382c:	b64080e7          	jalr	-1180(ra) # 8000638c <release>
}
    80003830:	70e2                	ld	ra,56(sp)
    80003832:	7442                	ld	s0,48(sp)
    80003834:	74a2                	ld	s1,40(sp)
    80003836:	7902                	ld	s2,32(sp)
    80003838:	69e2                	ld	s3,24(sp)
    8000383a:	6a42                	ld	s4,16(sp)
    8000383c:	6aa2                	ld	s5,8(sp)
    8000383e:	6121                	addi	sp,sp,64
    80003840:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003842:	00236a97          	auipc	s5,0x236
    80003846:	82ea8a93          	addi	s5,s5,-2002 # 80239070 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000384a:	00235a17          	auipc	s4,0x235
    8000384e:	7f6a0a13          	addi	s4,s4,2038 # 80239040 <log>
    80003852:	018a2583          	lw	a1,24(s4)
    80003856:	012585bb          	addw	a1,a1,s2
    8000385a:	2585                	addiw	a1,a1,1
    8000385c:	028a2503          	lw	a0,40(s4)
    80003860:	fffff097          	auipc	ra,0xfffff
    80003864:	cca080e7          	jalr	-822(ra) # 8000252a <bread>
    80003868:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000386a:	000aa583          	lw	a1,0(s5)
    8000386e:	028a2503          	lw	a0,40(s4)
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	cb8080e7          	jalr	-840(ra) # 8000252a <bread>
    8000387a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000387c:	40000613          	li	a2,1024
    80003880:	05850593          	addi	a1,a0,88
    80003884:	05848513          	addi	a0,s1,88
    80003888:	ffffd097          	auipc	ra,0xffffd
    8000388c:	a72080e7          	jalr	-1422(ra) # 800002fa <memmove>
    bwrite(to);  // write the log
    80003890:	8526                	mv	a0,s1
    80003892:	fffff097          	auipc	ra,0xfffff
    80003896:	d8a080e7          	jalr	-630(ra) # 8000261c <bwrite>
    brelse(from);
    8000389a:	854e                	mv	a0,s3
    8000389c:	fffff097          	auipc	ra,0xfffff
    800038a0:	dbe080e7          	jalr	-578(ra) # 8000265a <brelse>
    brelse(to);
    800038a4:	8526                	mv	a0,s1
    800038a6:	fffff097          	auipc	ra,0xfffff
    800038aa:	db4080e7          	jalr	-588(ra) # 8000265a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038ae:	2905                	addiw	s2,s2,1
    800038b0:	0a91                	addi	s5,s5,4
    800038b2:	02ca2783          	lw	a5,44(s4)
    800038b6:	f8f94ee3          	blt	s2,a5,80003852 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038ba:	00000097          	auipc	ra,0x0
    800038be:	c68080e7          	jalr	-920(ra) # 80003522 <write_head>
    install_trans(0); // Now install writes to home locations
    800038c2:	4501                	li	a0,0
    800038c4:	00000097          	auipc	ra,0x0
    800038c8:	cda080e7          	jalr	-806(ra) # 8000359e <install_trans>
    log.lh.n = 0;
    800038cc:	00235797          	auipc	a5,0x235
    800038d0:	7a07a023          	sw	zero,1952(a5) # 8023906c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038d4:	00000097          	auipc	ra,0x0
    800038d8:	c4e080e7          	jalr	-946(ra) # 80003522 <write_head>
    800038dc:	bdf5                	j	800037d8 <end_op+0x52>

00000000800038de <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038de:	1101                	addi	sp,sp,-32
    800038e0:	ec06                	sd	ra,24(sp)
    800038e2:	e822                	sd	s0,16(sp)
    800038e4:	e426                	sd	s1,8(sp)
    800038e6:	e04a                	sd	s2,0(sp)
    800038e8:	1000                	addi	s0,sp,32
    800038ea:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038ec:	00235917          	auipc	s2,0x235
    800038f0:	75490913          	addi	s2,s2,1876 # 80239040 <log>
    800038f4:	854a                	mv	a0,s2
    800038f6:	00003097          	auipc	ra,0x3
    800038fa:	9e2080e7          	jalr	-1566(ra) # 800062d8 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038fe:	02c92603          	lw	a2,44(s2)
    80003902:	47f5                	li	a5,29
    80003904:	06c7c563          	blt	a5,a2,8000396e <log_write+0x90>
    80003908:	00235797          	auipc	a5,0x235
    8000390c:	7547a783          	lw	a5,1876(a5) # 8023905c <log+0x1c>
    80003910:	37fd                	addiw	a5,a5,-1
    80003912:	04f65e63          	bge	a2,a5,8000396e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003916:	00235797          	auipc	a5,0x235
    8000391a:	74a7a783          	lw	a5,1866(a5) # 80239060 <log+0x20>
    8000391e:	06f05063          	blez	a5,8000397e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003922:	4781                	li	a5,0
    80003924:	06c05563          	blez	a2,8000398e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003928:	44cc                	lw	a1,12(s1)
    8000392a:	00235717          	auipc	a4,0x235
    8000392e:	74670713          	addi	a4,a4,1862 # 80239070 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003932:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003934:	4314                	lw	a3,0(a4)
    80003936:	04b68c63          	beq	a3,a1,8000398e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000393a:	2785                	addiw	a5,a5,1
    8000393c:	0711                	addi	a4,a4,4
    8000393e:	fef61be3          	bne	a2,a5,80003934 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003942:	0621                	addi	a2,a2,8
    80003944:	060a                	slli	a2,a2,0x2
    80003946:	00235797          	auipc	a5,0x235
    8000394a:	6fa78793          	addi	a5,a5,1786 # 80239040 <log>
    8000394e:	97b2                	add	a5,a5,a2
    80003950:	44d8                	lw	a4,12(s1)
    80003952:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003954:	8526                	mv	a0,s1
    80003956:	fffff097          	auipc	ra,0xfffff
    8000395a:	da2080e7          	jalr	-606(ra) # 800026f8 <bpin>
    log.lh.n++;
    8000395e:	00235717          	auipc	a4,0x235
    80003962:	6e270713          	addi	a4,a4,1762 # 80239040 <log>
    80003966:	575c                	lw	a5,44(a4)
    80003968:	2785                	addiw	a5,a5,1
    8000396a:	d75c                	sw	a5,44(a4)
    8000396c:	a82d                	j	800039a6 <log_write+0xc8>
    panic("too big a transaction");
    8000396e:	00005517          	auipc	a0,0x5
    80003972:	d0250513          	addi	a0,a0,-766 # 80008670 <syscalls+0x1f0>
    80003976:	00002097          	auipc	ra,0x2
    8000397a:	42a080e7          	jalr	1066(ra) # 80005da0 <panic>
    panic("log_write outside of trans");
    8000397e:	00005517          	auipc	a0,0x5
    80003982:	d0a50513          	addi	a0,a0,-758 # 80008688 <syscalls+0x208>
    80003986:	00002097          	auipc	ra,0x2
    8000398a:	41a080e7          	jalr	1050(ra) # 80005da0 <panic>
  log.lh.block[i] = b->blockno;
    8000398e:	00878693          	addi	a3,a5,8
    80003992:	068a                	slli	a3,a3,0x2
    80003994:	00235717          	auipc	a4,0x235
    80003998:	6ac70713          	addi	a4,a4,1708 # 80239040 <log>
    8000399c:	9736                	add	a4,a4,a3
    8000399e:	44d4                	lw	a3,12(s1)
    800039a0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039a2:	faf609e3          	beq	a2,a5,80003954 <log_write+0x76>
  }
  release(&log.lock);
    800039a6:	00235517          	auipc	a0,0x235
    800039aa:	69a50513          	addi	a0,a0,1690 # 80239040 <log>
    800039ae:	00003097          	auipc	ra,0x3
    800039b2:	9de080e7          	jalr	-1570(ra) # 8000638c <release>
}
    800039b6:	60e2                	ld	ra,24(sp)
    800039b8:	6442                	ld	s0,16(sp)
    800039ba:	64a2                	ld	s1,8(sp)
    800039bc:	6902                	ld	s2,0(sp)
    800039be:	6105                	addi	sp,sp,32
    800039c0:	8082                	ret

00000000800039c2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039c2:	1101                	addi	sp,sp,-32
    800039c4:	ec06                	sd	ra,24(sp)
    800039c6:	e822                	sd	s0,16(sp)
    800039c8:	e426                	sd	s1,8(sp)
    800039ca:	e04a                	sd	s2,0(sp)
    800039cc:	1000                	addi	s0,sp,32
    800039ce:	84aa                	mv	s1,a0
    800039d0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039d2:	00005597          	auipc	a1,0x5
    800039d6:	cd658593          	addi	a1,a1,-810 # 800086a8 <syscalls+0x228>
    800039da:	0521                	addi	a0,a0,8
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	86c080e7          	jalr	-1940(ra) # 80006248 <initlock>
  lk->name = name;
    800039e4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039e8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039ec:	0204a423          	sw	zero,40(s1)
}
    800039f0:	60e2                	ld	ra,24(sp)
    800039f2:	6442                	ld	s0,16(sp)
    800039f4:	64a2                	ld	s1,8(sp)
    800039f6:	6902                	ld	s2,0(sp)
    800039f8:	6105                	addi	sp,sp,32
    800039fa:	8082                	ret

00000000800039fc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039fc:	1101                	addi	sp,sp,-32
    800039fe:	ec06                	sd	ra,24(sp)
    80003a00:	e822                	sd	s0,16(sp)
    80003a02:	e426                	sd	s1,8(sp)
    80003a04:	e04a                	sd	s2,0(sp)
    80003a06:	1000                	addi	s0,sp,32
    80003a08:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a0a:	00850913          	addi	s2,a0,8
    80003a0e:	854a                	mv	a0,s2
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	8c8080e7          	jalr	-1848(ra) # 800062d8 <acquire>
  while (lk->locked) {
    80003a18:	409c                	lw	a5,0(s1)
    80003a1a:	cb89                	beqz	a5,80003a2c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a1c:	85ca                	mv	a1,s2
    80003a1e:	8526                	mv	a0,s1
    80003a20:	ffffe097          	auipc	ra,0xffffe
    80003a24:	d88080e7          	jalr	-632(ra) # 800017a8 <sleep>
  while (lk->locked) {
    80003a28:	409c                	lw	a5,0(s1)
    80003a2a:	fbed                	bnez	a5,80003a1c <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a2c:	4785                	li	a5,1
    80003a2e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a30:	ffffd097          	auipc	ra,0xffffd
    80003a34:	6b4080e7          	jalr	1716(ra) # 800010e4 <myproc>
    80003a38:	591c                	lw	a5,48(a0)
    80003a3a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	94e080e7          	jalr	-1714(ra) # 8000638c <release>
}
    80003a46:	60e2                	ld	ra,24(sp)
    80003a48:	6442                	ld	s0,16(sp)
    80003a4a:	64a2                	ld	s1,8(sp)
    80003a4c:	6902                	ld	s2,0(sp)
    80003a4e:	6105                	addi	sp,sp,32
    80003a50:	8082                	ret

0000000080003a52 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a52:	1101                	addi	sp,sp,-32
    80003a54:	ec06                	sd	ra,24(sp)
    80003a56:	e822                	sd	s0,16(sp)
    80003a58:	e426                	sd	s1,8(sp)
    80003a5a:	e04a                	sd	s2,0(sp)
    80003a5c:	1000                	addi	s0,sp,32
    80003a5e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a60:	00850913          	addi	s2,a0,8
    80003a64:	854a                	mv	a0,s2
    80003a66:	00003097          	auipc	ra,0x3
    80003a6a:	872080e7          	jalr	-1934(ra) # 800062d8 <acquire>
  lk->locked = 0;
    80003a6e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a72:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a76:	8526                	mv	a0,s1
    80003a78:	ffffe097          	auipc	ra,0xffffe
    80003a7c:	ebc080e7          	jalr	-324(ra) # 80001934 <wakeup>
  release(&lk->lk);
    80003a80:	854a                	mv	a0,s2
    80003a82:	00003097          	auipc	ra,0x3
    80003a86:	90a080e7          	jalr	-1782(ra) # 8000638c <release>
}
    80003a8a:	60e2                	ld	ra,24(sp)
    80003a8c:	6442                	ld	s0,16(sp)
    80003a8e:	64a2                	ld	s1,8(sp)
    80003a90:	6902                	ld	s2,0(sp)
    80003a92:	6105                	addi	sp,sp,32
    80003a94:	8082                	ret

0000000080003a96 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a96:	7179                	addi	sp,sp,-48
    80003a98:	f406                	sd	ra,40(sp)
    80003a9a:	f022                	sd	s0,32(sp)
    80003a9c:	ec26                	sd	s1,24(sp)
    80003a9e:	e84a                	sd	s2,16(sp)
    80003aa0:	e44e                	sd	s3,8(sp)
    80003aa2:	1800                	addi	s0,sp,48
    80003aa4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003aa6:	00850913          	addi	s2,a0,8
    80003aaa:	854a                	mv	a0,s2
    80003aac:	00003097          	auipc	ra,0x3
    80003ab0:	82c080e7          	jalr	-2004(ra) # 800062d8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ab4:	409c                	lw	a5,0(s1)
    80003ab6:	ef99                	bnez	a5,80003ad4 <holdingsleep+0x3e>
    80003ab8:	4481                	li	s1,0
  release(&lk->lk);
    80003aba:	854a                	mv	a0,s2
    80003abc:	00003097          	auipc	ra,0x3
    80003ac0:	8d0080e7          	jalr	-1840(ra) # 8000638c <release>
  return r;
}
    80003ac4:	8526                	mv	a0,s1
    80003ac6:	70a2                	ld	ra,40(sp)
    80003ac8:	7402                	ld	s0,32(sp)
    80003aca:	64e2                	ld	s1,24(sp)
    80003acc:	6942                	ld	s2,16(sp)
    80003ace:	69a2                	ld	s3,8(sp)
    80003ad0:	6145                	addi	sp,sp,48
    80003ad2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ad4:	0284a983          	lw	s3,40(s1)
    80003ad8:	ffffd097          	auipc	ra,0xffffd
    80003adc:	60c080e7          	jalr	1548(ra) # 800010e4 <myproc>
    80003ae0:	5904                	lw	s1,48(a0)
    80003ae2:	413484b3          	sub	s1,s1,s3
    80003ae6:	0014b493          	seqz	s1,s1
    80003aea:	bfc1                	j	80003aba <holdingsleep+0x24>

0000000080003aec <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003aec:	1141                	addi	sp,sp,-16
    80003aee:	e406                	sd	ra,8(sp)
    80003af0:	e022                	sd	s0,0(sp)
    80003af2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003af4:	00005597          	auipc	a1,0x5
    80003af8:	bc458593          	addi	a1,a1,-1084 # 800086b8 <syscalls+0x238>
    80003afc:	00235517          	auipc	a0,0x235
    80003b00:	68c50513          	addi	a0,a0,1676 # 80239188 <ftable>
    80003b04:	00002097          	auipc	ra,0x2
    80003b08:	744080e7          	jalr	1860(ra) # 80006248 <initlock>
}
    80003b0c:	60a2                	ld	ra,8(sp)
    80003b0e:	6402                	ld	s0,0(sp)
    80003b10:	0141                	addi	sp,sp,16
    80003b12:	8082                	ret

0000000080003b14 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b14:	1101                	addi	sp,sp,-32
    80003b16:	ec06                	sd	ra,24(sp)
    80003b18:	e822                	sd	s0,16(sp)
    80003b1a:	e426                	sd	s1,8(sp)
    80003b1c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b1e:	00235517          	auipc	a0,0x235
    80003b22:	66a50513          	addi	a0,a0,1642 # 80239188 <ftable>
    80003b26:	00002097          	auipc	ra,0x2
    80003b2a:	7b2080e7          	jalr	1970(ra) # 800062d8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b2e:	00235497          	auipc	s1,0x235
    80003b32:	67248493          	addi	s1,s1,1650 # 802391a0 <ftable+0x18>
    80003b36:	00236717          	auipc	a4,0x236
    80003b3a:	60a70713          	addi	a4,a4,1546 # 8023a140 <ftable+0xfb8>
    if(f->ref == 0){
    80003b3e:	40dc                	lw	a5,4(s1)
    80003b40:	cf99                	beqz	a5,80003b5e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b42:	02848493          	addi	s1,s1,40
    80003b46:	fee49ce3          	bne	s1,a4,80003b3e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b4a:	00235517          	auipc	a0,0x235
    80003b4e:	63e50513          	addi	a0,a0,1598 # 80239188 <ftable>
    80003b52:	00003097          	auipc	ra,0x3
    80003b56:	83a080e7          	jalr	-1990(ra) # 8000638c <release>
  return 0;
    80003b5a:	4481                	li	s1,0
    80003b5c:	a819                	j	80003b72 <filealloc+0x5e>
      f->ref = 1;
    80003b5e:	4785                	li	a5,1
    80003b60:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b62:	00235517          	auipc	a0,0x235
    80003b66:	62650513          	addi	a0,a0,1574 # 80239188 <ftable>
    80003b6a:	00003097          	auipc	ra,0x3
    80003b6e:	822080e7          	jalr	-2014(ra) # 8000638c <release>
}
    80003b72:	8526                	mv	a0,s1
    80003b74:	60e2                	ld	ra,24(sp)
    80003b76:	6442                	ld	s0,16(sp)
    80003b78:	64a2                	ld	s1,8(sp)
    80003b7a:	6105                	addi	sp,sp,32
    80003b7c:	8082                	ret

0000000080003b7e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b7e:	1101                	addi	sp,sp,-32
    80003b80:	ec06                	sd	ra,24(sp)
    80003b82:	e822                	sd	s0,16(sp)
    80003b84:	e426                	sd	s1,8(sp)
    80003b86:	1000                	addi	s0,sp,32
    80003b88:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b8a:	00235517          	auipc	a0,0x235
    80003b8e:	5fe50513          	addi	a0,a0,1534 # 80239188 <ftable>
    80003b92:	00002097          	auipc	ra,0x2
    80003b96:	746080e7          	jalr	1862(ra) # 800062d8 <acquire>
  if(f->ref < 1)
    80003b9a:	40dc                	lw	a5,4(s1)
    80003b9c:	02f05263          	blez	a5,80003bc0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ba0:	2785                	addiw	a5,a5,1
    80003ba2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ba4:	00235517          	auipc	a0,0x235
    80003ba8:	5e450513          	addi	a0,a0,1508 # 80239188 <ftable>
    80003bac:	00002097          	auipc	ra,0x2
    80003bb0:	7e0080e7          	jalr	2016(ra) # 8000638c <release>
  return f;
}
    80003bb4:	8526                	mv	a0,s1
    80003bb6:	60e2                	ld	ra,24(sp)
    80003bb8:	6442                	ld	s0,16(sp)
    80003bba:	64a2                	ld	s1,8(sp)
    80003bbc:	6105                	addi	sp,sp,32
    80003bbe:	8082                	ret
    panic("filedup");
    80003bc0:	00005517          	auipc	a0,0x5
    80003bc4:	b0050513          	addi	a0,a0,-1280 # 800086c0 <syscalls+0x240>
    80003bc8:	00002097          	auipc	ra,0x2
    80003bcc:	1d8080e7          	jalr	472(ra) # 80005da0 <panic>

0000000080003bd0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bd0:	7139                	addi	sp,sp,-64
    80003bd2:	fc06                	sd	ra,56(sp)
    80003bd4:	f822                	sd	s0,48(sp)
    80003bd6:	f426                	sd	s1,40(sp)
    80003bd8:	f04a                	sd	s2,32(sp)
    80003bda:	ec4e                	sd	s3,24(sp)
    80003bdc:	e852                	sd	s4,16(sp)
    80003bde:	e456                	sd	s5,8(sp)
    80003be0:	0080                	addi	s0,sp,64
    80003be2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003be4:	00235517          	auipc	a0,0x235
    80003be8:	5a450513          	addi	a0,a0,1444 # 80239188 <ftable>
    80003bec:	00002097          	auipc	ra,0x2
    80003bf0:	6ec080e7          	jalr	1772(ra) # 800062d8 <acquire>
  if(f->ref < 1)
    80003bf4:	40dc                	lw	a5,4(s1)
    80003bf6:	06f05163          	blez	a5,80003c58 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bfa:	37fd                	addiw	a5,a5,-1
    80003bfc:	0007871b          	sext.w	a4,a5
    80003c00:	c0dc                	sw	a5,4(s1)
    80003c02:	06e04363          	bgtz	a4,80003c68 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c06:	0004a903          	lw	s2,0(s1)
    80003c0a:	0094ca83          	lbu	s5,9(s1)
    80003c0e:	0104ba03          	ld	s4,16(s1)
    80003c12:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c16:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c1a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c1e:	00235517          	auipc	a0,0x235
    80003c22:	56a50513          	addi	a0,a0,1386 # 80239188 <ftable>
    80003c26:	00002097          	auipc	ra,0x2
    80003c2a:	766080e7          	jalr	1894(ra) # 8000638c <release>

  if(ff.type == FD_PIPE){
    80003c2e:	4785                	li	a5,1
    80003c30:	04f90d63          	beq	s2,a5,80003c8a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c34:	3979                	addiw	s2,s2,-2
    80003c36:	4785                	li	a5,1
    80003c38:	0527e063          	bltu	a5,s2,80003c78 <fileclose+0xa8>
    begin_op();
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	acc080e7          	jalr	-1332(ra) # 80003708 <begin_op>
    iput(ff.ip);
    80003c44:	854e                	mv	a0,s3
    80003c46:	fffff097          	auipc	ra,0xfffff
    80003c4a:	2a0080e7          	jalr	672(ra) # 80002ee6 <iput>
    end_op();
    80003c4e:	00000097          	auipc	ra,0x0
    80003c52:	b38080e7          	jalr	-1224(ra) # 80003786 <end_op>
    80003c56:	a00d                	j	80003c78 <fileclose+0xa8>
    panic("fileclose");
    80003c58:	00005517          	auipc	a0,0x5
    80003c5c:	a7050513          	addi	a0,a0,-1424 # 800086c8 <syscalls+0x248>
    80003c60:	00002097          	auipc	ra,0x2
    80003c64:	140080e7          	jalr	320(ra) # 80005da0 <panic>
    release(&ftable.lock);
    80003c68:	00235517          	auipc	a0,0x235
    80003c6c:	52050513          	addi	a0,a0,1312 # 80239188 <ftable>
    80003c70:	00002097          	auipc	ra,0x2
    80003c74:	71c080e7          	jalr	1820(ra) # 8000638c <release>
  }
}
    80003c78:	70e2                	ld	ra,56(sp)
    80003c7a:	7442                	ld	s0,48(sp)
    80003c7c:	74a2                	ld	s1,40(sp)
    80003c7e:	7902                	ld	s2,32(sp)
    80003c80:	69e2                	ld	s3,24(sp)
    80003c82:	6a42                	ld	s4,16(sp)
    80003c84:	6aa2                	ld	s5,8(sp)
    80003c86:	6121                	addi	sp,sp,64
    80003c88:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c8a:	85d6                	mv	a1,s5
    80003c8c:	8552                	mv	a0,s4
    80003c8e:	00000097          	auipc	ra,0x0
    80003c92:	34c080e7          	jalr	844(ra) # 80003fda <pipeclose>
    80003c96:	b7cd                	j	80003c78 <fileclose+0xa8>

0000000080003c98 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c98:	715d                	addi	sp,sp,-80
    80003c9a:	e486                	sd	ra,72(sp)
    80003c9c:	e0a2                	sd	s0,64(sp)
    80003c9e:	fc26                	sd	s1,56(sp)
    80003ca0:	f84a                	sd	s2,48(sp)
    80003ca2:	f44e                	sd	s3,40(sp)
    80003ca4:	0880                	addi	s0,sp,80
    80003ca6:	84aa                	mv	s1,a0
    80003ca8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003caa:	ffffd097          	auipc	ra,0xffffd
    80003cae:	43a080e7          	jalr	1082(ra) # 800010e4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cb2:	409c                	lw	a5,0(s1)
    80003cb4:	37f9                	addiw	a5,a5,-2
    80003cb6:	4705                	li	a4,1
    80003cb8:	04f76763          	bltu	a4,a5,80003d06 <filestat+0x6e>
    80003cbc:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cbe:	6c88                	ld	a0,24(s1)
    80003cc0:	fffff097          	auipc	ra,0xfffff
    80003cc4:	06c080e7          	jalr	108(ra) # 80002d2c <ilock>
    stati(f->ip, &st);
    80003cc8:	fb840593          	addi	a1,s0,-72
    80003ccc:	6c88                	ld	a0,24(s1)
    80003cce:	fffff097          	auipc	ra,0xfffff
    80003cd2:	2e8080e7          	jalr	744(ra) # 80002fb6 <stati>
    iunlock(f->ip);
    80003cd6:	6c88                	ld	a0,24(s1)
    80003cd8:	fffff097          	auipc	ra,0xfffff
    80003cdc:	116080e7          	jalr	278(ra) # 80002dee <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ce0:	46e1                	li	a3,24
    80003ce2:	fb840613          	addi	a2,s0,-72
    80003ce6:	85ce                	mv	a1,s3
    80003ce8:	05093503          	ld	a0,80(s2)
    80003cec:	ffffd097          	auipc	ra,0xffffd
    80003cf0:	1e6080e7          	jalr	486(ra) # 80000ed2 <copyout>
    80003cf4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cf8:	60a6                	ld	ra,72(sp)
    80003cfa:	6406                	ld	s0,64(sp)
    80003cfc:	74e2                	ld	s1,56(sp)
    80003cfe:	7942                	ld	s2,48(sp)
    80003d00:	79a2                	ld	s3,40(sp)
    80003d02:	6161                	addi	sp,sp,80
    80003d04:	8082                	ret
  return -1;
    80003d06:	557d                	li	a0,-1
    80003d08:	bfc5                	j	80003cf8 <filestat+0x60>

0000000080003d0a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d0a:	7179                	addi	sp,sp,-48
    80003d0c:	f406                	sd	ra,40(sp)
    80003d0e:	f022                	sd	s0,32(sp)
    80003d10:	ec26                	sd	s1,24(sp)
    80003d12:	e84a                	sd	s2,16(sp)
    80003d14:	e44e                	sd	s3,8(sp)
    80003d16:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d18:	00854783          	lbu	a5,8(a0)
    80003d1c:	c3d5                	beqz	a5,80003dc0 <fileread+0xb6>
    80003d1e:	84aa                	mv	s1,a0
    80003d20:	89ae                	mv	s3,a1
    80003d22:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d24:	411c                	lw	a5,0(a0)
    80003d26:	4705                	li	a4,1
    80003d28:	04e78963          	beq	a5,a4,80003d7a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d2c:	470d                	li	a4,3
    80003d2e:	04e78d63          	beq	a5,a4,80003d88 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d32:	4709                	li	a4,2
    80003d34:	06e79e63          	bne	a5,a4,80003db0 <fileread+0xa6>
    ilock(f->ip);
    80003d38:	6d08                	ld	a0,24(a0)
    80003d3a:	fffff097          	auipc	ra,0xfffff
    80003d3e:	ff2080e7          	jalr	-14(ra) # 80002d2c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d42:	874a                	mv	a4,s2
    80003d44:	5094                	lw	a3,32(s1)
    80003d46:	864e                	mv	a2,s3
    80003d48:	4585                	li	a1,1
    80003d4a:	6c88                	ld	a0,24(s1)
    80003d4c:	fffff097          	auipc	ra,0xfffff
    80003d50:	294080e7          	jalr	660(ra) # 80002fe0 <readi>
    80003d54:	892a                	mv	s2,a0
    80003d56:	00a05563          	blez	a0,80003d60 <fileread+0x56>
      f->off += r;
    80003d5a:	509c                	lw	a5,32(s1)
    80003d5c:	9fa9                	addw	a5,a5,a0
    80003d5e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d60:	6c88                	ld	a0,24(s1)
    80003d62:	fffff097          	auipc	ra,0xfffff
    80003d66:	08c080e7          	jalr	140(ra) # 80002dee <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d6a:	854a                	mv	a0,s2
    80003d6c:	70a2                	ld	ra,40(sp)
    80003d6e:	7402                	ld	s0,32(sp)
    80003d70:	64e2                	ld	s1,24(sp)
    80003d72:	6942                	ld	s2,16(sp)
    80003d74:	69a2                	ld	s3,8(sp)
    80003d76:	6145                	addi	sp,sp,48
    80003d78:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d7a:	6908                	ld	a0,16(a0)
    80003d7c:	00000097          	auipc	ra,0x0
    80003d80:	3c0080e7          	jalr	960(ra) # 8000413c <piperead>
    80003d84:	892a                	mv	s2,a0
    80003d86:	b7d5                	j	80003d6a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d88:	02451783          	lh	a5,36(a0)
    80003d8c:	03079693          	slli	a3,a5,0x30
    80003d90:	92c1                	srli	a3,a3,0x30
    80003d92:	4725                	li	a4,9
    80003d94:	02d76863          	bltu	a4,a3,80003dc4 <fileread+0xba>
    80003d98:	0792                	slli	a5,a5,0x4
    80003d9a:	00235717          	auipc	a4,0x235
    80003d9e:	34e70713          	addi	a4,a4,846 # 802390e8 <devsw>
    80003da2:	97ba                	add	a5,a5,a4
    80003da4:	639c                	ld	a5,0(a5)
    80003da6:	c38d                	beqz	a5,80003dc8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003da8:	4505                	li	a0,1
    80003daa:	9782                	jalr	a5
    80003dac:	892a                	mv	s2,a0
    80003dae:	bf75                	j	80003d6a <fileread+0x60>
    panic("fileread");
    80003db0:	00005517          	auipc	a0,0x5
    80003db4:	92850513          	addi	a0,a0,-1752 # 800086d8 <syscalls+0x258>
    80003db8:	00002097          	auipc	ra,0x2
    80003dbc:	fe8080e7          	jalr	-24(ra) # 80005da0 <panic>
    return -1;
    80003dc0:	597d                	li	s2,-1
    80003dc2:	b765                	j	80003d6a <fileread+0x60>
      return -1;
    80003dc4:	597d                	li	s2,-1
    80003dc6:	b755                	j	80003d6a <fileread+0x60>
    80003dc8:	597d                	li	s2,-1
    80003dca:	b745                	j	80003d6a <fileread+0x60>

0000000080003dcc <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dcc:	715d                	addi	sp,sp,-80
    80003dce:	e486                	sd	ra,72(sp)
    80003dd0:	e0a2                	sd	s0,64(sp)
    80003dd2:	fc26                	sd	s1,56(sp)
    80003dd4:	f84a                	sd	s2,48(sp)
    80003dd6:	f44e                	sd	s3,40(sp)
    80003dd8:	f052                	sd	s4,32(sp)
    80003dda:	ec56                	sd	s5,24(sp)
    80003ddc:	e85a                	sd	s6,16(sp)
    80003dde:	e45e                	sd	s7,8(sp)
    80003de0:	e062                	sd	s8,0(sp)
    80003de2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003de4:	00954783          	lbu	a5,9(a0)
    80003de8:	10078663          	beqz	a5,80003ef4 <filewrite+0x128>
    80003dec:	892a                	mv	s2,a0
    80003dee:	8b2e                	mv	s6,a1
    80003df0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003df2:	411c                	lw	a5,0(a0)
    80003df4:	4705                	li	a4,1
    80003df6:	02e78263          	beq	a5,a4,80003e1a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dfa:	470d                	li	a4,3
    80003dfc:	02e78663          	beq	a5,a4,80003e28 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e00:	4709                	li	a4,2
    80003e02:	0ee79163          	bne	a5,a4,80003ee4 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e06:	0ac05d63          	blez	a2,80003ec0 <filewrite+0xf4>
    int i = 0;
    80003e0a:	4981                	li	s3,0
    80003e0c:	6b85                	lui	s7,0x1
    80003e0e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e12:	6c05                	lui	s8,0x1
    80003e14:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e18:	a861                	j	80003eb0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e1a:	6908                	ld	a0,16(a0)
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	22e080e7          	jalr	558(ra) # 8000404a <pipewrite>
    80003e24:	8a2a                	mv	s4,a0
    80003e26:	a045                	j	80003ec6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e28:	02451783          	lh	a5,36(a0)
    80003e2c:	03079693          	slli	a3,a5,0x30
    80003e30:	92c1                	srli	a3,a3,0x30
    80003e32:	4725                	li	a4,9
    80003e34:	0cd76263          	bltu	a4,a3,80003ef8 <filewrite+0x12c>
    80003e38:	0792                	slli	a5,a5,0x4
    80003e3a:	00235717          	auipc	a4,0x235
    80003e3e:	2ae70713          	addi	a4,a4,686 # 802390e8 <devsw>
    80003e42:	97ba                	add	a5,a5,a4
    80003e44:	679c                	ld	a5,8(a5)
    80003e46:	cbdd                	beqz	a5,80003efc <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e48:	4505                	li	a0,1
    80003e4a:	9782                	jalr	a5
    80003e4c:	8a2a                	mv	s4,a0
    80003e4e:	a8a5                	j	80003ec6 <filewrite+0xfa>
    80003e50:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e54:	00000097          	auipc	ra,0x0
    80003e58:	8b4080e7          	jalr	-1868(ra) # 80003708 <begin_op>
      ilock(f->ip);
    80003e5c:	01893503          	ld	a0,24(s2)
    80003e60:	fffff097          	auipc	ra,0xfffff
    80003e64:	ecc080e7          	jalr	-308(ra) # 80002d2c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e68:	8756                	mv	a4,s5
    80003e6a:	02092683          	lw	a3,32(s2)
    80003e6e:	01698633          	add	a2,s3,s6
    80003e72:	4585                	li	a1,1
    80003e74:	01893503          	ld	a0,24(s2)
    80003e78:	fffff097          	auipc	ra,0xfffff
    80003e7c:	260080e7          	jalr	608(ra) # 800030d8 <writei>
    80003e80:	84aa                	mv	s1,a0
    80003e82:	00a05763          	blez	a0,80003e90 <filewrite+0xc4>
        f->off += r;
    80003e86:	02092783          	lw	a5,32(s2)
    80003e8a:	9fa9                	addw	a5,a5,a0
    80003e8c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e90:	01893503          	ld	a0,24(s2)
    80003e94:	fffff097          	auipc	ra,0xfffff
    80003e98:	f5a080e7          	jalr	-166(ra) # 80002dee <iunlock>
      end_op();
    80003e9c:	00000097          	auipc	ra,0x0
    80003ea0:	8ea080e7          	jalr	-1814(ra) # 80003786 <end_op>

      if(r != n1){
    80003ea4:	009a9f63          	bne	s5,s1,80003ec2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ea8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003eac:	0149db63          	bge	s3,s4,80003ec2 <filewrite+0xf6>
      int n1 = n - i;
    80003eb0:	413a04bb          	subw	s1,s4,s3
    80003eb4:	0004879b          	sext.w	a5,s1
    80003eb8:	f8fbdce3          	bge	s7,a5,80003e50 <filewrite+0x84>
    80003ebc:	84e2                	mv	s1,s8
    80003ebe:	bf49                	j	80003e50 <filewrite+0x84>
    int i = 0;
    80003ec0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ec2:	013a1f63          	bne	s4,s3,80003ee0 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ec6:	8552                	mv	a0,s4
    80003ec8:	60a6                	ld	ra,72(sp)
    80003eca:	6406                	ld	s0,64(sp)
    80003ecc:	74e2                	ld	s1,56(sp)
    80003ece:	7942                	ld	s2,48(sp)
    80003ed0:	79a2                	ld	s3,40(sp)
    80003ed2:	7a02                	ld	s4,32(sp)
    80003ed4:	6ae2                	ld	s5,24(sp)
    80003ed6:	6b42                	ld	s6,16(sp)
    80003ed8:	6ba2                	ld	s7,8(sp)
    80003eda:	6c02                	ld	s8,0(sp)
    80003edc:	6161                	addi	sp,sp,80
    80003ede:	8082                	ret
    ret = (i == n ? n : -1);
    80003ee0:	5a7d                	li	s4,-1
    80003ee2:	b7d5                	j	80003ec6 <filewrite+0xfa>
    panic("filewrite");
    80003ee4:	00005517          	auipc	a0,0x5
    80003ee8:	80450513          	addi	a0,a0,-2044 # 800086e8 <syscalls+0x268>
    80003eec:	00002097          	auipc	ra,0x2
    80003ef0:	eb4080e7          	jalr	-332(ra) # 80005da0 <panic>
    return -1;
    80003ef4:	5a7d                	li	s4,-1
    80003ef6:	bfc1                	j	80003ec6 <filewrite+0xfa>
      return -1;
    80003ef8:	5a7d                	li	s4,-1
    80003efa:	b7f1                	j	80003ec6 <filewrite+0xfa>
    80003efc:	5a7d                	li	s4,-1
    80003efe:	b7e1                	j	80003ec6 <filewrite+0xfa>

0000000080003f00 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f00:	7179                	addi	sp,sp,-48
    80003f02:	f406                	sd	ra,40(sp)
    80003f04:	f022                	sd	s0,32(sp)
    80003f06:	ec26                	sd	s1,24(sp)
    80003f08:	e84a                	sd	s2,16(sp)
    80003f0a:	e44e                	sd	s3,8(sp)
    80003f0c:	e052                	sd	s4,0(sp)
    80003f0e:	1800                	addi	s0,sp,48
    80003f10:	84aa                	mv	s1,a0
    80003f12:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f14:	0005b023          	sd	zero,0(a1)
    80003f18:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f1c:	00000097          	auipc	ra,0x0
    80003f20:	bf8080e7          	jalr	-1032(ra) # 80003b14 <filealloc>
    80003f24:	e088                	sd	a0,0(s1)
    80003f26:	c551                	beqz	a0,80003fb2 <pipealloc+0xb2>
    80003f28:	00000097          	auipc	ra,0x0
    80003f2c:	bec080e7          	jalr	-1044(ra) # 80003b14 <filealloc>
    80003f30:	00aa3023          	sd	a0,0(s4)
    80003f34:	c92d                	beqz	a0,80003fa6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f36:	ffffc097          	auipc	ra,0xffffc
    80003f3a:	0e6080e7          	jalr	230(ra) # 8000001c <kalloc>
    80003f3e:	892a                	mv	s2,a0
    80003f40:	c125                	beqz	a0,80003fa0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f42:	4985                	li	s3,1
    80003f44:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f48:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f4c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f50:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f54:	00004597          	auipc	a1,0x4
    80003f58:	7a458593          	addi	a1,a1,1956 # 800086f8 <syscalls+0x278>
    80003f5c:	00002097          	auipc	ra,0x2
    80003f60:	2ec080e7          	jalr	748(ra) # 80006248 <initlock>
  (*f0)->type = FD_PIPE;
    80003f64:	609c                	ld	a5,0(s1)
    80003f66:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f6a:	609c                	ld	a5,0(s1)
    80003f6c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f70:	609c                	ld	a5,0(s1)
    80003f72:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f76:	609c                	ld	a5,0(s1)
    80003f78:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f7c:	000a3783          	ld	a5,0(s4)
    80003f80:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f84:	000a3783          	ld	a5,0(s4)
    80003f88:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f8c:	000a3783          	ld	a5,0(s4)
    80003f90:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f94:	000a3783          	ld	a5,0(s4)
    80003f98:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f9c:	4501                	li	a0,0
    80003f9e:	a025                	j	80003fc6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fa0:	6088                	ld	a0,0(s1)
    80003fa2:	e501                	bnez	a0,80003faa <pipealloc+0xaa>
    80003fa4:	a039                	j	80003fb2 <pipealloc+0xb2>
    80003fa6:	6088                	ld	a0,0(s1)
    80003fa8:	c51d                	beqz	a0,80003fd6 <pipealloc+0xd6>
    fileclose(*f0);
    80003faa:	00000097          	auipc	ra,0x0
    80003fae:	c26080e7          	jalr	-986(ra) # 80003bd0 <fileclose>
  if(*f1)
    80003fb2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fb6:	557d                	li	a0,-1
  if(*f1)
    80003fb8:	c799                	beqz	a5,80003fc6 <pipealloc+0xc6>
    fileclose(*f1);
    80003fba:	853e                	mv	a0,a5
    80003fbc:	00000097          	auipc	ra,0x0
    80003fc0:	c14080e7          	jalr	-1004(ra) # 80003bd0 <fileclose>
  return -1;
    80003fc4:	557d                	li	a0,-1
}
    80003fc6:	70a2                	ld	ra,40(sp)
    80003fc8:	7402                	ld	s0,32(sp)
    80003fca:	64e2                	ld	s1,24(sp)
    80003fcc:	6942                	ld	s2,16(sp)
    80003fce:	69a2                	ld	s3,8(sp)
    80003fd0:	6a02                	ld	s4,0(sp)
    80003fd2:	6145                	addi	sp,sp,48
    80003fd4:	8082                	ret
  return -1;
    80003fd6:	557d                	li	a0,-1
    80003fd8:	b7fd                	j	80003fc6 <pipealloc+0xc6>

0000000080003fda <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fda:	1101                	addi	sp,sp,-32
    80003fdc:	ec06                	sd	ra,24(sp)
    80003fde:	e822                	sd	s0,16(sp)
    80003fe0:	e426                	sd	s1,8(sp)
    80003fe2:	e04a                	sd	s2,0(sp)
    80003fe4:	1000                	addi	s0,sp,32
    80003fe6:	84aa                	mv	s1,a0
    80003fe8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fea:	00002097          	auipc	ra,0x2
    80003fee:	2ee080e7          	jalr	750(ra) # 800062d8 <acquire>
  if(writable){
    80003ff2:	02090d63          	beqz	s2,8000402c <pipeclose+0x52>
    pi->writeopen = 0;
    80003ff6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ffa:	21848513          	addi	a0,s1,536
    80003ffe:	ffffe097          	auipc	ra,0xffffe
    80004002:	936080e7          	jalr	-1738(ra) # 80001934 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004006:	2204b783          	ld	a5,544(s1)
    8000400a:	eb95                	bnez	a5,8000403e <pipeclose+0x64>
    release(&pi->lock);
    8000400c:	8526                	mv	a0,s1
    8000400e:	00002097          	auipc	ra,0x2
    80004012:	37e080e7          	jalr	894(ra) # 8000638c <release>
    kfree((char*)pi);
    80004016:	8526                	mv	a0,s1
    80004018:	ffffc097          	auipc	ra,0xffffc
    8000401c:	13e080e7          	jalr	318(ra) # 80000156 <kfree>
  } else
    release(&pi->lock);
}
    80004020:	60e2                	ld	ra,24(sp)
    80004022:	6442                	ld	s0,16(sp)
    80004024:	64a2                	ld	s1,8(sp)
    80004026:	6902                	ld	s2,0(sp)
    80004028:	6105                	addi	sp,sp,32
    8000402a:	8082                	ret
    pi->readopen = 0;
    8000402c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004030:	21c48513          	addi	a0,s1,540
    80004034:	ffffe097          	auipc	ra,0xffffe
    80004038:	900080e7          	jalr	-1792(ra) # 80001934 <wakeup>
    8000403c:	b7e9                	j	80004006 <pipeclose+0x2c>
    release(&pi->lock);
    8000403e:	8526                	mv	a0,s1
    80004040:	00002097          	auipc	ra,0x2
    80004044:	34c080e7          	jalr	844(ra) # 8000638c <release>
}
    80004048:	bfe1                	j	80004020 <pipeclose+0x46>

000000008000404a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000404a:	711d                	addi	sp,sp,-96
    8000404c:	ec86                	sd	ra,88(sp)
    8000404e:	e8a2                	sd	s0,80(sp)
    80004050:	e4a6                	sd	s1,72(sp)
    80004052:	e0ca                	sd	s2,64(sp)
    80004054:	fc4e                	sd	s3,56(sp)
    80004056:	f852                	sd	s4,48(sp)
    80004058:	f456                	sd	s5,40(sp)
    8000405a:	f05a                	sd	s6,32(sp)
    8000405c:	ec5e                	sd	s7,24(sp)
    8000405e:	e862                	sd	s8,16(sp)
    80004060:	1080                	addi	s0,sp,96
    80004062:	84aa                	mv	s1,a0
    80004064:	8aae                	mv	s5,a1
    80004066:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004068:	ffffd097          	auipc	ra,0xffffd
    8000406c:	07c080e7          	jalr	124(ra) # 800010e4 <myproc>
    80004070:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004072:	8526                	mv	a0,s1
    80004074:	00002097          	auipc	ra,0x2
    80004078:	264080e7          	jalr	612(ra) # 800062d8 <acquire>
  while(i < n){
    8000407c:	0b405363          	blez	s4,80004122 <pipewrite+0xd8>
  int i = 0;
    80004080:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004082:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004084:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004088:	21c48b93          	addi	s7,s1,540
    8000408c:	a089                	j	800040ce <pipewrite+0x84>
      release(&pi->lock);
    8000408e:	8526                	mv	a0,s1
    80004090:	00002097          	auipc	ra,0x2
    80004094:	2fc080e7          	jalr	764(ra) # 8000638c <release>
      return -1;
    80004098:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000409a:	854a                	mv	a0,s2
    8000409c:	60e6                	ld	ra,88(sp)
    8000409e:	6446                	ld	s0,80(sp)
    800040a0:	64a6                	ld	s1,72(sp)
    800040a2:	6906                	ld	s2,64(sp)
    800040a4:	79e2                	ld	s3,56(sp)
    800040a6:	7a42                	ld	s4,48(sp)
    800040a8:	7aa2                	ld	s5,40(sp)
    800040aa:	7b02                	ld	s6,32(sp)
    800040ac:	6be2                	ld	s7,24(sp)
    800040ae:	6c42                	ld	s8,16(sp)
    800040b0:	6125                	addi	sp,sp,96
    800040b2:	8082                	ret
      wakeup(&pi->nread);
    800040b4:	8562                	mv	a0,s8
    800040b6:	ffffe097          	auipc	ra,0xffffe
    800040ba:	87e080e7          	jalr	-1922(ra) # 80001934 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040be:	85a6                	mv	a1,s1
    800040c0:	855e                	mv	a0,s7
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	6e6080e7          	jalr	1766(ra) # 800017a8 <sleep>
  while(i < n){
    800040ca:	05495d63          	bge	s2,s4,80004124 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    800040ce:	2204a783          	lw	a5,544(s1)
    800040d2:	dfd5                	beqz	a5,8000408e <pipewrite+0x44>
    800040d4:	0289a783          	lw	a5,40(s3)
    800040d8:	fbdd                	bnez	a5,8000408e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040da:	2184a783          	lw	a5,536(s1)
    800040de:	21c4a703          	lw	a4,540(s1)
    800040e2:	2007879b          	addiw	a5,a5,512
    800040e6:	fcf707e3          	beq	a4,a5,800040b4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ea:	4685                	li	a3,1
    800040ec:	01590633          	add	a2,s2,s5
    800040f0:	faf40593          	addi	a1,s0,-81
    800040f4:	0509b503          	ld	a0,80(s3)
    800040f8:	ffffd097          	auipc	ra,0xffffd
    800040fc:	a62080e7          	jalr	-1438(ra) # 80000b5a <copyin>
    80004100:	03650263          	beq	a0,s6,80004124 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004104:	21c4a783          	lw	a5,540(s1)
    80004108:	0017871b          	addiw	a4,a5,1
    8000410c:	20e4ae23          	sw	a4,540(s1)
    80004110:	1ff7f793          	andi	a5,a5,511
    80004114:	97a6                	add	a5,a5,s1
    80004116:	faf44703          	lbu	a4,-81(s0)
    8000411a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000411e:	2905                	addiw	s2,s2,1
    80004120:	b76d                	j	800040ca <pipewrite+0x80>
  int i = 0;
    80004122:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004124:	21848513          	addi	a0,s1,536
    80004128:	ffffe097          	auipc	ra,0xffffe
    8000412c:	80c080e7          	jalr	-2036(ra) # 80001934 <wakeup>
  release(&pi->lock);
    80004130:	8526                	mv	a0,s1
    80004132:	00002097          	auipc	ra,0x2
    80004136:	25a080e7          	jalr	602(ra) # 8000638c <release>
  return i;
    8000413a:	b785                	j	8000409a <pipewrite+0x50>

000000008000413c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000413c:	715d                	addi	sp,sp,-80
    8000413e:	e486                	sd	ra,72(sp)
    80004140:	e0a2                	sd	s0,64(sp)
    80004142:	fc26                	sd	s1,56(sp)
    80004144:	f84a                	sd	s2,48(sp)
    80004146:	f44e                	sd	s3,40(sp)
    80004148:	f052                	sd	s4,32(sp)
    8000414a:	ec56                	sd	s5,24(sp)
    8000414c:	e85a                	sd	s6,16(sp)
    8000414e:	0880                	addi	s0,sp,80
    80004150:	84aa                	mv	s1,a0
    80004152:	892e                	mv	s2,a1
    80004154:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	f8e080e7          	jalr	-114(ra) # 800010e4 <myproc>
    8000415e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004160:	8526                	mv	a0,s1
    80004162:	00002097          	auipc	ra,0x2
    80004166:	176080e7          	jalr	374(ra) # 800062d8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000416a:	2184a703          	lw	a4,536(s1)
    8000416e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004172:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004176:	02f71463          	bne	a4,a5,8000419e <piperead+0x62>
    8000417a:	2244a783          	lw	a5,548(s1)
    8000417e:	c385                	beqz	a5,8000419e <piperead+0x62>
    if(pr->killed){
    80004180:	028a2783          	lw	a5,40(s4)
    80004184:	ebc9                	bnez	a5,80004216 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004186:	85a6                	mv	a1,s1
    80004188:	854e                	mv	a0,s3
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	61e080e7          	jalr	1566(ra) # 800017a8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004192:	2184a703          	lw	a4,536(s1)
    80004196:	21c4a783          	lw	a5,540(s1)
    8000419a:	fef700e3          	beq	a4,a5,8000417a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000419e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041a0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041a2:	05505463          	blez	s5,800041ea <piperead+0xae>
    if(pi->nread == pi->nwrite)
    800041a6:	2184a783          	lw	a5,536(s1)
    800041aa:	21c4a703          	lw	a4,540(s1)
    800041ae:	02f70e63          	beq	a4,a5,800041ea <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041b2:	0017871b          	addiw	a4,a5,1
    800041b6:	20e4ac23          	sw	a4,536(s1)
    800041ba:	1ff7f793          	andi	a5,a5,511
    800041be:	97a6                	add	a5,a5,s1
    800041c0:	0187c783          	lbu	a5,24(a5)
    800041c4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041c8:	4685                	li	a3,1
    800041ca:	fbf40613          	addi	a2,s0,-65
    800041ce:	85ca                	mv	a1,s2
    800041d0:	050a3503          	ld	a0,80(s4)
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	cfe080e7          	jalr	-770(ra) # 80000ed2 <copyout>
    800041dc:	01650763          	beq	a0,s6,800041ea <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e0:	2985                	addiw	s3,s3,1
    800041e2:	0905                	addi	s2,s2,1
    800041e4:	fd3a91e3          	bne	s5,s3,800041a6 <piperead+0x6a>
    800041e8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041ea:	21c48513          	addi	a0,s1,540
    800041ee:	ffffd097          	auipc	ra,0xffffd
    800041f2:	746080e7          	jalr	1862(ra) # 80001934 <wakeup>
  release(&pi->lock);
    800041f6:	8526                	mv	a0,s1
    800041f8:	00002097          	auipc	ra,0x2
    800041fc:	194080e7          	jalr	404(ra) # 8000638c <release>
  return i;
}
    80004200:	854e                	mv	a0,s3
    80004202:	60a6                	ld	ra,72(sp)
    80004204:	6406                	ld	s0,64(sp)
    80004206:	74e2                	ld	s1,56(sp)
    80004208:	7942                	ld	s2,48(sp)
    8000420a:	79a2                	ld	s3,40(sp)
    8000420c:	7a02                	ld	s4,32(sp)
    8000420e:	6ae2                	ld	s5,24(sp)
    80004210:	6b42                	ld	s6,16(sp)
    80004212:	6161                	addi	sp,sp,80
    80004214:	8082                	ret
      release(&pi->lock);
    80004216:	8526                	mv	a0,s1
    80004218:	00002097          	auipc	ra,0x2
    8000421c:	174080e7          	jalr	372(ra) # 8000638c <release>
      return -1;
    80004220:	59fd                	li	s3,-1
    80004222:	bff9                	j	80004200 <piperead+0xc4>

0000000080004224 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004224:	de010113          	addi	sp,sp,-544
    80004228:	20113c23          	sd	ra,536(sp)
    8000422c:	20813823          	sd	s0,528(sp)
    80004230:	20913423          	sd	s1,520(sp)
    80004234:	21213023          	sd	s2,512(sp)
    80004238:	ffce                	sd	s3,504(sp)
    8000423a:	fbd2                	sd	s4,496(sp)
    8000423c:	f7d6                	sd	s5,488(sp)
    8000423e:	f3da                	sd	s6,480(sp)
    80004240:	efde                	sd	s7,472(sp)
    80004242:	ebe2                	sd	s8,464(sp)
    80004244:	e7e6                	sd	s9,456(sp)
    80004246:	e3ea                	sd	s10,448(sp)
    80004248:	ff6e                	sd	s11,440(sp)
    8000424a:	1400                	addi	s0,sp,544
    8000424c:	892a                	mv	s2,a0
    8000424e:	dea43423          	sd	a0,-536(s0)
    80004252:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004256:	ffffd097          	auipc	ra,0xffffd
    8000425a:	e8e080e7          	jalr	-370(ra) # 800010e4 <myproc>
    8000425e:	84aa                	mv	s1,a0

  begin_op();
    80004260:	fffff097          	auipc	ra,0xfffff
    80004264:	4a8080e7          	jalr	1192(ra) # 80003708 <begin_op>

  if((ip = namei(path)) == 0){
    80004268:	854a                	mv	a0,s2
    8000426a:	fffff097          	auipc	ra,0xfffff
    8000426e:	27e080e7          	jalr	638(ra) # 800034e8 <namei>
    80004272:	c93d                	beqz	a0,800042e8 <exec+0xc4>
    80004274:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004276:	fffff097          	auipc	ra,0xfffff
    8000427a:	ab6080e7          	jalr	-1354(ra) # 80002d2c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000427e:	04000713          	li	a4,64
    80004282:	4681                	li	a3,0
    80004284:	e5040613          	addi	a2,s0,-432
    80004288:	4581                	li	a1,0
    8000428a:	8556                	mv	a0,s5
    8000428c:	fffff097          	auipc	ra,0xfffff
    80004290:	d54080e7          	jalr	-684(ra) # 80002fe0 <readi>
    80004294:	04000793          	li	a5,64
    80004298:	00f51a63          	bne	a0,a5,800042ac <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000429c:	e5042703          	lw	a4,-432(s0)
    800042a0:	464c47b7          	lui	a5,0x464c4
    800042a4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042a8:	04f70663          	beq	a4,a5,800042f4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042ac:	8556                	mv	a0,s5
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	ce0080e7          	jalr	-800(ra) # 80002f8e <iunlockput>
    end_op();
    800042b6:	fffff097          	auipc	ra,0xfffff
    800042ba:	4d0080e7          	jalr	1232(ra) # 80003786 <end_op>
  }
  return -1;
    800042be:	557d                	li	a0,-1
}
    800042c0:	21813083          	ld	ra,536(sp)
    800042c4:	21013403          	ld	s0,528(sp)
    800042c8:	20813483          	ld	s1,520(sp)
    800042cc:	20013903          	ld	s2,512(sp)
    800042d0:	79fe                	ld	s3,504(sp)
    800042d2:	7a5e                	ld	s4,496(sp)
    800042d4:	7abe                	ld	s5,488(sp)
    800042d6:	7b1e                	ld	s6,480(sp)
    800042d8:	6bfe                	ld	s7,472(sp)
    800042da:	6c5e                	ld	s8,464(sp)
    800042dc:	6cbe                	ld	s9,456(sp)
    800042de:	6d1e                	ld	s10,448(sp)
    800042e0:	7dfa                	ld	s11,440(sp)
    800042e2:	22010113          	addi	sp,sp,544
    800042e6:	8082                	ret
    end_op();
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	49e080e7          	jalr	1182(ra) # 80003786 <end_op>
    return -1;
    800042f0:	557d                	li	a0,-1
    800042f2:	b7f9                	j	800042c0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800042f4:	8526                	mv	a0,s1
    800042f6:	ffffd097          	auipc	ra,0xffffd
    800042fa:	eb2080e7          	jalr	-334(ra) # 800011a8 <proc_pagetable>
    800042fe:	8b2a                	mv	s6,a0
    80004300:	d555                	beqz	a0,800042ac <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004302:	e7042783          	lw	a5,-400(s0)
    80004306:	e8845703          	lhu	a4,-376(s0)
    8000430a:	c735                	beqz	a4,80004376 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000430c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000430e:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80004312:	6a05                	lui	s4,0x1
    80004314:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004318:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000431c:	6d85                	lui	s11,0x1
    8000431e:	7d7d                	lui	s10,0xfffff
    80004320:	ac1d                	j	80004556 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004322:	00004517          	auipc	a0,0x4
    80004326:	3de50513          	addi	a0,a0,990 # 80008700 <syscalls+0x280>
    8000432a:	00002097          	auipc	ra,0x2
    8000432e:	a76080e7          	jalr	-1418(ra) # 80005da0 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004332:	874a                	mv	a4,s2
    80004334:	009c86bb          	addw	a3,s9,s1
    80004338:	4581                	li	a1,0
    8000433a:	8556                	mv	a0,s5
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	ca4080e7          	jalr	-860(ra) # 80002fe0 <readi>
    80004344:	2501                	sext.w	a0,a0
    80004346:	1aa91863          	bne	s2,a0,800044f6 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    8000434a:	009d84bb          	addw	s1,s11,s1
    8000434e:	013d09bb          	addw	s3,s10,s3
    80004352:	1f74f263          	bgeu	s1,s7,80004536 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004356:	02049593          	slli	a1,s1,0x20
    8000435a:	9181                	srli	a1,a1,0x20
    8000435c:	95e2                	add	a1,a1,s8
    8000435e:	855a                	mv	a0,s6
    80004360:	ffffc097          	auipc	ra,0xffffc
    80004364:	2c4080e7          	jalr	708(ra) # 80000624 <walkaddr>
    80004368:	862a                	mv	a2,a0
    if(pa == 0)
    8000436a:	dd45                	beqz	a0,80004322 <exec+0xfe>
      n = PGSIZE;
    8000436c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000436e:	fd49f2e3          	bgeu	s3,s4,80004332 <exec+0x10e>
      n = sz - i;
    80004372:	894e                	mv	s2,s3
    80004374:	bf7d                	j	80004332 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004376:	4481                	li	s1,0
  iunlockput(ip);
    80004378:	8556                	mv	a0,s5
    8000437a:	fffff097          	auipc	ra,0xfffff
    8000437e:	c14080e7          	jalr	-1004(ra) # 80002f8e <iunlockput>
  end_op();
    80004382:	fffff097          	auipc	ra,0xfffff
    80004386:	404080e7          	jalr	1028(ra) # 80003786 <end_op>
  p = myproc();
    8000438a:	ffffd097          	auipc	ra,0xffffd
    8000438e:	d5a080e7          	jalr	-678(ra) # 800010e4 <myproc>
    80004392:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004394:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004398:	6785                	lui	a5,0x1
    8000439a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000439c:	97a6                	add	a5,a5,s1
    8000439e:	777d                	lui	a4,0xfffff
    800043a0:	8ff9                	and	a5,a5,a4
    800043a2:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043a6:	6609                	lui	a2,0x2
    800043a8:	963e                	add	a2,a2,a5
    800043aa:	85be                	mv	a1,a5
    800043ac:	855a                	mv	a0,s6
    800043ae:	ffffc097          	auipc	ra,0xffffc
    800043b2:	62a080e7          	jalr	1578(ra) # 800009d8 <uvmalloc>
    800043b6:	8c2a                	mv	s8,a0
  ip = 0;
    800043b8:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043ba:	12050e63          	beqz	a0,800044f6 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043be:	75f9                	lui	a1,0xffffe
    800043c0:	95aa                	add	a1,a1,a0
    800043c2:	855a                	mv	a0,s6
    800043c4:	ffffc097          	auipc	ra,0xffffc
    800043c8:	764080e7          	jalr	1892(ra) # 80000b28 <uvmclear>
  stackbase = sp - PGSIZE;
    800043cc:	7afd                	lui	s5,0xfffff
    800043ce:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800043d0:	df043783          	ld	a5,-528(s0)
    800043d4:	6388                	ld	a0,0(a5)
    800043d6:	c925                	beqz	a0,80004446 <exec+0x222>
    800043d8:	e9040993          	addi	s3,s0,-368
    800043dc:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043e0:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043e2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043e4:	ffffc097          	auipc	ra,0xffffc
    800043e8:	036080e7          	jalr	54(ra) # 8000041a <strlen>
    800043ec:	0015079b          	addiw	a5,a0,1
    800043f0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043f4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043f8:	13596363          	bltu	s2,s5,8000451e <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043fc:	df043d83          	ld	s11,-528(s0)
    80004400:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004404:	8552                	mv	a0,s4
    80004406:	ffffc097          	auipc	ra,0xffffc
    8000440a:	014080e7          	jalr	20(ra) # 8000041a <strlen>
    8000440e:	0015069b          	addiw	a3,a0,1
    80004412:	8652                	mv	a2,s4
    80004414:	85ca                	mv	a1,s2
    80004416:	855a                	mv	a0,s6
    80004418:	ffffd097          	auipc	ra,0xffffd
    8000441c:	aba080e7          	jalr	-1350(ra) # 80000ed2 <copyout>
    80004420:	10054363          	bltz	a0,80004526 <exec+0x302>
    ustack[argc] = sp;
    80004424:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004428:	0485                	addi	s1,s1,1
    8000442a:	008d8793          	addi	a5,s11,8
    8000442e:	def43823          	sd	a5,-528(s0)
    80004432:	008db503          	ld	a0,8(s11)
    80004436:	c911                	beqz	a0,8000444a <exec+0x226>
    if(argc >= MAXARG)
    80004438:	09a1                	addi	s3,s3,8
    8000443a:	fb3c95e3          	bne	s9,s3,800043e4 <exec+0x1c0>
  sz = sz1;
    8000443e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004442:	4a81                	li	s5,0
    80004444:	a84d                	j	800044f6 <exec+0x2d2>
  sp = sz;
    80004446:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004448:	4481                	li	s1,0
  ustack[argc] = 0;
    8000444a:	00349793          	slli	a5,s1,0x3
    8000444e:	f9078793          	addi	a5,a5,-112
    80004452:	97a2                	add	a5,a5,s0
    80004454:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004458:	00148693          	addi	a3,s1,1
    8000445c:	068e                	slli	a3,a3,0x3
    8000445e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004462:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004466:	01597663          	bgeu	s2,s5,80004472 <exec+0x24e>
  sz = sz1;
    8000446a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000446e:	4a81                	li	s5,0
    80004470:	a059                	j	800044f6 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004472:	e9040613          	addi	a2,s0,-368
    80004476:	85ca                	mv	a1,s2
    80004478:	855a                	mv	a0,s6
    8000447a:	ffffd097          	auipc	ra,0xffffd
    8000447e:	a58080e7          	jalr	-1448(ra) # 80000ed2 <copyout>
    80004482:	0a054663          	bltz	a0,8000452e <exec+0x30a>
  p->trapframe->a1 = sp;
    80004486:	058bb783          	ld	a5,88(s7)
    8000448a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000448e:	de843783          	ld	a5,-536(s0)
    80004492:	0007c703          	lbu	a4,0(a5)
    80004496:	cf11                	beqz	a4,800044b2 <exec+0x28e>
    80004498:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000449a:	02f00693          	li	a3,47
    8000449e:	a039                	j	800044ac <exec+0x288>
      last = s+1;
    800044a0:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800044a4:	0785                	addi	a5,a5,1
    800044a6:	fff7c703          	lbu	a4,-1(a5)
    800044aa:	c701                	beqz	a4,800044b2 <exec+0x28e>
    if(*s == '/')
    800044ac:	fed71ce3          	bne	a4,a3,800044a4 <exec+0x280>
    800044b0:	bfc5                	j	800044a0 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800044b2:	4641                	li	a2,16
    800044b4:	de843583          	ld	a1,-536(s0)
    800044b8:	158b8513          	addi	a0,s7,344
    800044bc:	ffffc097          	auipc	ra,0xffffc
    800044c0:	f2c080e7          	jalr	-212(ra) # 800003e8 <safestrcpy>
  oldpagetable = p->pagetable;
    800044c4:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800044c8:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800044cc:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044d0:	058bb783          	ld	a5,88(s7)
    800044d4:	e6843703          	ld	a4,-408(s0)
    800044d8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044da:	058bb783          	ld	a5,88(s7)
    800044de:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044e2:	85ea                	mv	a1,s10
    800044e4:	ffffd097          	auipc	ra,0xffffd
    800044e8:	d60080e7          	jalr	-672(ra) # 80001244 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044ec:	0004851b          	sext.w	a0,s1
    800044f0:	bbc1                	j	800042c0 <exec+0x9c>
    800044f2:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800044f6:	df843583          	ld	a1,-520(s0)
    800044fa:	855a                	mv	a0,s6
    800044fc:	ffffd097          	auipc	ra,0xffffd
    80004500:	d48080e7          	jalr	-696(ra) # 80001244 <proc_freepagetable>
  if(ip){
    80004504:	da0a94e3          	bnez	s5,800042ac <exec+0x88>
  return -1;
    80004508:	557d                	li	a0,-1
    8000450a:	bb5d                	j	800042c0 <exec+0x9c>
    8000450c:	de943c23          	sd	s1,-520(s0)
    80004510:	b7dd                	j	800044f6 <exec+0x2d2>
    80004512:	de943c23          	sd	s1,-520(s0)
    80004516:	b7c5                	j	800044f6 <exec+0x2d2>
    80004518:	de943c23          	sd	s1,-520(s0)
    8000451c:	bfe9                	j	800044f6 <exec+0x2d2>
  sz = sz1;
    8000451e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004522:	4a81                	li	s5,0
    80004524:	bfc9                	j	800044f6 <exec+0x2d2>
  sz = sz1;
    80004526:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000452a:	4a81                	li	s5,0
    8000452c:	b7e9                	j	800044f6 <exec+0x2d2>
  sz = sz1;
    8000452e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004532:	4a81                	li	s5,0
    80004534:	b7c9                	j	800044f6 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004536:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000453a:	e0843783          	ld	a5,-504(s0)
    8000453e:	0017869b          	addiw	a3,a5,1
    80004542:	e0d43423          	sd	a3,-504(s0)
    80004546:	e0043783          	ld	a5,-512(s0)
    8000454a:	0387879b          	addiw	a5,a5,56
    8000454e:	e8845703          	lhu	a4,-376(s0)
    80004552:	e2e6d3e3          	bge	a3,a4,80004378 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004556:	2781                	sext.w	a5,a5
    80004558:	e0f43023          	sd	a5,-512(s0)
    8000455c:	03800713          	li	a4,56
    80004560:	86be                	mv	a3,a5
    80004562:	e1840613          	addi	a2,s0,-488
    80004566:	4581                	li	a1,0
    80004568:	8556                	mv	a0,s5
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	a76080e7          	jalr	-1418(ra) # 80002fe0 <readi>
    80004572:	03800793          	li	a5,56
    80004576:	f6f51ee3          	bne	a0,a5,800044f2 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000457a:	e1842783          	lw	a5,-488(s0)
    8000457e:	4705                	li	a4,1
    80004580:	fae79de3          	bne	a5,a4,8000453a <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004584:	e4043603          	ld	a2,-448(s0)
    80004588:	e3843783          	ld	a5,-456(s0)
    8000458c:	f8f660e3          	bltu	a2,a5,8000450c <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004590:	e2843783          	ld	a5,-472(s0)
    80004594:	963e                	add	a2,a2,a5
    80004596:	f6f66ee3          	bltu	a2,a5,80004512 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000459a:	85a6                	mv	a1,s1
    8000459c:	855a                	mv	a0,s6
    8000459e:	ffffc097          	auipc	ra,0xffffc
    800045a2:	43a080e7          	jalr	1082(ra) # 800009d8 <uvmalloc>
    800045a6:	dea43c23          	sd	a0,-520(s0)
    800045aa:	d53d                	beqz	a0,80004518 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    800045ac:	e2843c03          	ld	s8,-472(s0)
    800045b0:	de043783          	ld	a5,-544(s0)
    800045b4:	00fc77b3          	and	a5,s8,a5
    800045b8:	ff9d                	bnez	a5,800044f6 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045ba:	e2042c83          	lw	s9,-480(s0)
    800045be:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045c2:	f60b8ae3          	beqz	s7,80004536 <exec+0x312>
    800045c6:	89de                	mv	s3,s7
    800045c8:	4481                	li	s1,0
    800045ca:	b371                	j	80004356 <exec+0x132>

00000000800045cc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045cc:	7179                	addi	sp,sp,-48
    800045ce:	f406                	sd	ra,40(sp)
    800045d0:	f022                	sd	s0,32(sp)
    800045d2:	ec26                	sd	s1,24(sp)
    800045d4:	e84a                	sd	s2,16(sp)
    800045d6:	1800                	addi	s0,sp,48
    800045d8:	892e                	mv	s2,a1
    800045da:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045dc:	fdc40593          	addi	a1,s0,-36
    800045e0:	ffffe097          	auipc	ra,0xffffe
    800045e4:	bda080e7          	jalr	-1062(ra) # 800021ba <argint>
    800045e8:	04054063          	bltz	a0,80004628 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045ec:	fdc42703          	lw	a4,-36(s0)
    800045f0:	47bd                	li	a5,15
    800045f2:	02e7ed63          	bltu	a5,a4,8000462c <argfd+0x60>
    800045f6:	ffffd097          	auipc	ra,0xffffd
    800045fa:	aee080e7          	jalr	-1298(ra) # 800010e4 <myproc>
    800045fe:	fdc42703          	lw	a4,-36(s0)
    80004602:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7fdb8dda>
    80004606:	078e                	slli	a5,a5,0x3
    80004608:	953e                	add	a0,a0,a5
    8000460a:	611c                	ld	a5,0(a0)
    8000460c:	c395                	beqz	a5,80004630 <argfd+0x64>
    return -1;
  if(pfd)
    8000460e:	00090463          	beqz	s2,80004616 <argfd+0x4a>
    *pfd = fd;
    80004612:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004616:	4501                	li	a0,0
  if(pf)
    80004618:	c091                	beqz	s1,8000461c <argfd+0x50>
    *pf = f;
    8000461a:	e09c                	sd	a5,0(s1)
}
    8000461c:	70a2                	ld	ra,40(sp)
    8000461e:	7402                	ld	s0,32(sp)
    80004620:	64e2                	ld	s1,24(sp)
    80004622:	6942                	ld	s2,16(sp)
    80004624:	6145                	addi	sp,sp,48
    80004626:	8082                	ret
    return -1;
    80004628:	557d                	li	a0,-1
    8000462a:	bfcd                	j	8000461c <argfd+0x50>
    return -1;
    8000462c:	557d                	li	a0,-1
    8000462e:	b7fd                	j	8000461c <argfd+0x50>
    80004630:	557d                	li	a0,-1
    80004632:	b7ed                	j	8000461c <argfd+0x50>

0000000080004634 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004634:	1101                	addi	sp,sp,-32
    80004636:	ec06                	sd	ra,24(sp)
    80004638:	e822                	sd	s0,16(sp)
    8000463a:	e426                	sd	s1,8(sp)
    8000463c:	1000                	addi	s0,sp,32
    8000463e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004640:	ffffd097          	auipc	ra,0xffffd
    80004644:	aa4080e7          	jalr	-1372(ra) # 800010e4 <myproc>
    80004648:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000464a:	0d050793          	addi	a5,a0,208
    8000464e:	4501                	li	a0,0
    80004650:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004652:	6398                	ld	a4,0(a5)
    80004654:	cb19                	beqz	a4,8000466a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004656:	2505                	addiw	a0,a0,1
    80004658:	07a1                	addi	a5,a5,8
    8000465a:	fed51ce3          	bne	a0,a3,80004652 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000465e:	557d                	li	a0,-1
}
    80004660:	60e2                	ld	ra,24(sp)
    80004662:	6442                	ld	s0,16(sp)
    80004664:	64a2                	ld	s1,8(sp)
    80004666:	6105                	addi	sp,sp,32
    80004668:	8082                	ret
      p->ofile[fd] = f;
    8000466a:	01a50793          	addi	a5,a0,26
    8000466e:	078e                	slli	a5,a5,0x3
    80004670:	963e                	add	a2,a2,a5
    80004672:	e204                	sd	s1,0(a2)
      return fd;
    80004674:	b7f5                	j	80004660 <fdalloc+0x2c>

0000000080004676 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004676:	715d                	addi	sp,sp,-80
    80004678:	e486                	sd	ra,72(sp)
    8000467a:	e0a2                	sd	s0,64(sp)
    8000467c:	fc26                	sd	s1,56(sp)
    8000467e:	f84a                	sd	s2,48(sp)
    80004680:	f44e                	sd	s3,40(sp)
    80004682:	f052                	sd	s4,32(sp)
    80004684:	ec56                	sd	s5,24(sp)
    80004686:	0880                	addi	s0,sp,80
    80004688:	89ae                	mv	s3,a1
    8000468a:	8ab2                	mv	s5,a2
    8000468c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000468e:	fb040593          	addi	a1,s0,-80
    80004692:	fffff097          	auipc	ra,0xfffff
    80004696:	e74080e7          	jalr	-396(ra) # 80003506 <nameiparent>
    8000469a:	892a                	mv	s2,a0
    8000469c:	12050e63          	beqz	a0,800047d8 <create+0x162>
    return 0;

  ilock(dp);
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	68c080e7          	jalr	1676(ra) # 80002d2c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046a8:	4601                	li	a2,0
    800046aa:	fb040593          	addi	a1,s0,-80
    800046ae:	854a                	mv	a0,s2
    800046b0:	fffff097          	auipc	ra,0xfffff
    800046b4:	b60080e7          	jalr	-1184(ra) # 80003210 <dirlookup>
    800046b8:	84aa                	mv	s1,a0
    800046ba:	c921                	beqz	a0,8000470a <create+0x94>
    iunlockput(dp);
    800046bc:	854a                	mv	a0,s2
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	8d0080e7          	jalr	-1840(ra) # 80002f8e <iunlockput>
    ilock(ip);
    800046c6:	8526                	mv	a0,s1
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	664080e7          	jalr	1636(ra) # 80002d2c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046d0:	2981                	sext.w	s3,s3
    800046d2:	4789                	li	a5,2
    800046d4:	02f99463          	bne	s3,a5,800046fc <create+0x86>
    800046d8:	0444d783          	lhu	a5,68(s1)
    800046dc:	37f9                	addiw	a5,a5,-2
    800046de:	17c2                	slli	a5,a5,0x30
    800046e0:	93c1                	srli	a5,a5,0x30
    800046e2:	4705                	li	a4,1
    800046e4:	00f76c63          	bltu	a4,a5,800046fc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046e8:	8526                	mv	a0,s1
    800046ea:	60a6                	ld	ra,72(sp)
    800046ec:	6406                	ld	s0,64(sp)
    800046ee:	74e2                	ld	s1,56(sp)
    800046f0:	7942                	ld	s2,48(sp)
    800046f2:	79a2                	ld	s3,40(sp)
    800046f4:	7a02                	ld	s4,32(sp)
    800046f6:	6ae2                	ld	s5,24(sp)
    800046f8:	6161                	addi	sp,sp,80
    800046fa:	8082                	ret
    iunlockput(ip);
    800046fc:	8526                	mv	a0,s1
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	890080e7          	jalr	-1904(ra) # 80002f8e <iunlockput>
    return 0;
    80004706:	4481                	li	s1,0
    80004708:	b7c5                	j	800046e8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000470a:	85ce                	mv	a1,s3
    8000470c:	00092503          	lw	a0,0(s2)
    80004710:	ffffe097          	auipc	ra,0xffffe
    80004714:	482080e7          	jalr	1154(ra) # 80002b92 <ialloc>
    80004718:	84aa                	mv	s1,a0
    8000471a:	c521                	beqz	a0,80004762 <create+0xec>
  ilock(ip);
    8000471c:	ffffe097          	auipc	ra,0xffffe
    80004720:	610080e7          	jalr	1552(ra) # 80002d2c <ilock>
  ip->major = major;
    80004724:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004728:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000472c:	4a05                	li	s4,1
    8000472e:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004732:	8526                	mv	a0,s1
    80004734:	ffffe097          	auipc	ra,0xffffe
    80004738:	52c080e7          	jalr	1324(ra) # 80002c60 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000473c:	2981                	sext.w	s3,s3
    8000473e:	03498a63          	beq	s3,s4,80004772 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004742:	40d0                	lw	a2,4(s1)
    80004744:	fb040593          	addi	a1,s0,-80
    80004748:	854a                	mv	a0,s2
    8000474a:	fffff097          	auipc	ra,0xfffff
    8000474e:	cdc080e7          	jalr	-804(ra) # 80003426 <dirlink>
    80004752:	06054b63          	bltz	a0,800047c8 <create+0x152>
  iunlockput(dp);
    80004756:	854a                	mv	a0,s2
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	836080e7          	jalr	-1994(ra) # 80002f8e <iunlockput>
  return ip;
    80004760:	b761                	j	800046e8 <create+0x72>
    panic("create: ialloc");
    80004762:	00004517          	auipc	a0,0x4
    80004766:	fbe50513          	addi	a0,a0,-66 # 80008720 <syscalls+0x2a0>
    8000476a:	00001097          	auipc	ra,0x1
    8000476e:	636080e7          	jalr	1590(ra) # 80005da0 <panic>
    dp->nlink++;  // for ".."
    80004772:	04a95783          	lhu	a5,74(s2)
    80004776:	2785                	addiw	a5,a5,1
    80004778:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000477c:	854a                	mv	a0,s2
    8000477e:	ffffe097          	auipc	ra,0xffffe
    80004782:	4e2080e7          	jalr	1250(ra) # 80002c60 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004786:	40d0                	lw	a2,4(s1)
    80004788:	00004597          	auipc	a1,0x4
    8000478c:	fa858593          	addi	a1,a1,-88 # 80008730 <syscalls+0x2b0>
    80004790:	8526                	mv	a0,s1
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	c94080e7          	jalr	-876(ra) # 80003426 <dirlink>
    8000479a:	00054f63          	bltz	a0,800047b8 <create+0x142>
    8000479e:	00492603          	lw	a2,4(s2)
    800047a2:	00004597          	auipc	a1,0x4
    800047a6:	f9658593          	addi	a1,a1,-106 # 80008738 <syscalls+0x2b8>
    800047aa:	8526                	mv	a0,s1
    800047ac:	fffff097          	auipc	ra,0xfffff
    800047b0:	c7a080e7          	jalr	-902(ra) # 80003426 <dirlink>
    800047b4:	f80557e3          	bgez	a0,80004742 <create+0xcc>
      panic("create dots");
    800047b8:	00004517          	auipc	a0,0x4
    800047bc:	f8850513          	addi	a0,a0,-120 # 80008740 <syscalls+0x2c0>
    800047c0:	00001097          	auipc	ra,0x1
    800047c4:	5e0080e7          	jalr	1504(ra) # 80005da0 <panic>
    panic("create: dirlink");
    800047c8:	00004517          	auipc	a0,0x4
    800047cc:	f8850513          	addi	a0,a0,-120 # 80008750 <syscalls+0x2d0>
    800047d0:	00001097          	auipc	ra,0x1
    800047d4:	5d0080e7          	jalr	1488(ra) # 80005da0 <panic>
    return 0;
    800047d8:	84aa                	mv	s1,a0
    800047da:	b739                	j	800046e8 <create+0x72>

00000000800047dc <sys_dup>:
{
    800047dc:	7179                	addi	sp,sp,-48
    800047de:	f406                	sd	ra,40(sp)
    800047e0:	f022                	sd	s0,32(sp)
    800047e2:	ec26                	sd	s1,24(sp)
    800047e4:	e84a                	sd	s2,16(sp)
    800047e6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047e8:	fd840613          	addi	a2,s0,-40
    800047ec:	4581                	li	a1,0
    800047ee:	4501                	li	a0,0
    800047f0:	00000097          	auipc	ra,0x0
    800047f4:	ddc080e7          	jalr	-548(ra) # 800045cc <argfd>
    return -1;
    800047f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047fa:	02054363          	bltz	a0,80004820 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800047fe:	fd843903          	ld	s2,-40(s0)
    80004802:	854a                	mv	a0,s2
    80004804:	00000097          	auipc	ra,0x0
    80004808:	e30080e7          	jalr	-464(ra) # 80004634 <fdalloc>
    8000480c:	84aa                	mv	s1,a0
    return -1;
    8000480e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004810:	00054863          	bltz	a0,80004820 <sys_dup+0x44>
  filedup(f);
    80004814:	854a                	mv	a0,s2
    80004816:	fffff097          	auipc	ra,0xfffff
    8000481a:	368080e7          	jalr	872(ra) # 80003b7e <filedup>
  return fd;
    8000481e:	87a6                	mv	a5,s1
}
    80004820:	853e                	mv	a0,a5
    80004822:	70a2                	ld	ra,40(sp)
    80004824:	7402                	ld	s0,32(sp)
    80004826:	64e2                	ld	s1,24(sp)
    80004828:	6942                	ld	s2,16(sp)
    8000482a:	6145                	addi	sp,sp,48
    8000482c:	8082                	ret

000000008000482e <sys_read>:
{
    8000482e:	7179                	addi	sp,sp,-48
    80004830:	f406                	sd	ra,40(sp)
    80004832:	f022                	sd	s0,32(sp)
    80004834:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004836:	fe840613          	addi	a2,s0,-24
    8000483a:	4581                	li	a1,0
    8000483c:	4501                	li	a0,0
    8000483e:	00000097          	auipc	ra,0x0
    80004842:	d8e080e7          	jalr	-626(ra) # 800045cc <argfd>
    return -1;
    80004846:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004848:	04054163          	bltz	a0,8000488a <sys_read+0x5c>
    8000484c:	fe440593          	addi	a1,s0,-28
    80004850:	4509                	li	a0,2
    80004852:	ffffe097          	auipc	ra,0xffffe
    80004856:	968080e7          	jalr	-1688(ra) # 800021ba <argint>
    return -1;
    8000485a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000485c:	02054763          	bltz	a0,8000488a <sys_read+0x5c>
    80004860:	fd840593          	addi	a1,s0,-40
    80004864:	4505                	li	a0,1
    80004866:	ffffe097          	auipc	ra,0xffffe
    8000486a:	976080e7          	jalr	-1674(ra) # 800021dc <argaddr>
    return -1;
    8000486e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004870:	00054d63          	bltz	a0,8000488a <sys_read+0x5c>
  return fileread(f, p, n);
    80004874:	fe442603          	lw	a2,-28(s0)
    80004878:	fd843583          	ld	a1,-40(s0)
    8000487c:	fe843503          	ld	a0,-24(s0)
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	48a080e7          	jalr	1162(ra) # 80003d0a <fileread>
    80004888:	87aa                	mv	a5,a0
}
    8000488a:	853e                	mv	a0,a5
    8000488c:	70a2                	ld	ra,40(sp)
    8000488e:	7402                	ld	s0,32(sp)
    80004890:	6145                	addi	sp,sp,48
    80004892:	8082                	ret

0000000080004894 <sys_write>:
{
    80004894:	7179                	addi	sp,sp,-48
    80004896:	f406                	sd	ra,40(sp)
    80004898:	f022                	sd	s0,32(sp)
    8000489a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000489c:	fe840613          	addi	a2,s0,-24
    800048a0:	4581                	li	a1,0
    800048a2:	4501                	li	a0,0
    800048a4:	00000097          	auipc	ra,0x0
    800048a8:	d28080e7          	jalr	-728(ra) # 800045cc <argfd>
    return -1;
    800048ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ae:	04054163          	bltz	a0,800048f0 <sys_write+0x5c>
    800048b2:	fe440593          	addi	a1,s0,-28
    800048b6:	4509                	li	a0,2
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	902080e7          	jalr	-1790(ra) # 800021ba <argint>
    return -1;
    800048c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048c2:	02054763          	bltz	a0,800048f0 <sys_write+0x5c>
    800048c6:	fd840593          	addi	a1,s0,-40
    800048ca:	4505                	li	a0,1
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	910080e7          	jalr	-1776(ra) # 800021dc <argaddr>
    return -1;
    800048d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d6:	00054d63          	bltz	a0,800048f0 <sys_write+0x5c>
  return filewrite(f, p, n);
    800048da:	fe442603          	lw	a2,-28(s0)
    800048de:	fd843583          	ld	a1,-40(s0)
    800048e2:	fe843503          	ld	a0,-24(s0)
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	4e6080e7          	jalr	1254(ra) # 80003dcc <filewrite>
    800048ee:	87aa                	mv	a5,a0
}
    800048f0:	853e                	mv	a0,a5
    800048f2:	70a2                	ld	ra,40(sp)
    800048f4:	7402                	ld	s0,32(sp)
    800048f6:	6145                	addi	sp,sp,48
    800048f8:	8082                	ret

00000000800048fa <sys_close>:
{
    800048fa:	1101                	addi	sp,sp,-32
    800048fc:	ec06                	sd	ra,24(sp)
    800048fe:	e822                	sd	s0,16(sp)
    80004900:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004902:	fe040613          	addi	a2,s0,-32
    80004906:	fec40593          	addi	a1,s0,-20
    8000490a:	4501                	li	a0,0
    8000490c:	00000097          	auipc	ra,0x0
    80004910:	cc0080e7          	jalr	-832(ra) # 800045cc <argfd>
    return -1;
    80004914:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004916:	02054463          	bltz	a0,8000493e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000491a:	ffffc097          	auipc	ra,0xffffc
    8000491e:	7ca080e7          	jalr	1994(ra) # 800010e4 <myproc>
    80004922:	fec42783          	lw	a5,-20(s0)
    80004926:	07e9                	addi	a5,a5,26
    80004928:	078e                	slli	a5,a5,0x3
    8000492a:	953e                	add	a0,a0,a5
    8000492c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004930:	fe043503          	ld	a0,-32(s0)
    80004934:	fffff097          	auipc	ra,0xfffff
    80004938:	29c080e7          	jalr	668(ra) # 80003bd0 <fileclose>
  return 0;
    8000493c:	4781                	li	a5,0
}
    8000493e:	853e                	mv	a0,a5
    80004940:	60e2                	ld	ra,24(sp)
    80004942:	6442                	ld	s0,16(sp)
    80004944:	6105                	addi	sp,sp,32
    80004946:	8082                	ret

0000000080004948 <sys_fstat>:
{
    80004948:	1101                	addi	sp,sp,-32
    8000494a:	ec06                	sd	ra,24(sp)
    8000494c:	e822                	sd	s0,16(sp)
    8000494e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004950:	fe840613          	addi	a2,s0,-24
    80004954:	4581                	li	a1,0
    80004956:	4501                	li	a0,0
    80004958:	00000097          	auipc	ra,0x0
    8000495c:	c74080e7          	jalr	-908(ra) # 800045cc <argfd>
    return -1;
    80004960:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004962:	02054563          	bltz	a0,8000498c <sys_fstat+0x44>
    80004966:	fe040593          	addi	a1,s0,-32
    8000496a:	4505                	li	a0,1
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	870080e7          	jalr	-1936(ra) # 800021dc <argaddr>
    return -1;
    80004974:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004976:	00054b63          	bltz	a0,8000498c <sys_fstat+0x44>
  return filestat(f, st);
    8000497a:	fe043583          	ld	a1,-32(s0)
    8000497e:	fe843503          	ld	a0,-24(s0)
    80004982:	fffff097          	auipc	ra,0xfffff
    80004986:	316080e7          	jalr	790(ra) # 80003c98 <filestat>
    8000498a:	87aa                	mv	a5,a0
}
    8000498c:	853e                	mv	a0,a5
    8000498e:	60e2                	ld	ra,24(sp)
    80004990:	6442                	ld	s0,16(sp)
    80004992:	6105                	addi	sp,sp,32
    80004994:	8082                	ret

0000000080004996 <sys_link>:
{
    80004996:	7169                	addi	sp,sp,-304
    80004998:	f606                	sd	ra,296(sp)
    8000499a:	f222                	sd	s0,288(sp)
    8000499c:	ee26                	sd	s1,280(sp)
    8000499e:	ea4a                	sd	s2,272(sp)
    800049a0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049a2:	08000613          	li	a2,128
    800049a6:	ed040593          	addi	a1,s0,-304
    800049aa:	4501                	li	a0,0
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	852080e7          	jalr	-1966(ra) # 800021fe <argstr>
    return -1;
    800049b4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049b6:	10054e63          	bltz	a0,80004ad2 <sys_link+0x13c>
    800049ba:	08000613          	li	a2,128
    800049be:	f5040593          	addi	a1,s0,-176
    800049c2:	4505                	li	a0,1
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	83a080e7          	jalr	-1990(ra) # 800021fe <argstr>
    return -1;
    800049cc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ce:	10054263          	bltz	a0,80004ad2 <sys_link+0x13c>
  begin_op();
    800049d2:	fffff097          	auipc	ra,0xfffff
    800049d6:	d36080e7          	jalr	-714(ra) # 80003708 <begin_op>
  if((ip = namei(old)) == 0){
    800049da:	ed040513          	addi	a0,s0,-304
    800049de:	fffff097          	auipc	ra,0xfffff
    800049e2:	b0a080e7          	jalr	-1270(ra) # 800034e8 <namei>
    800049e6:	84aa                	mv	s1,a0
    800049e8:	c551                	beqz	a0,80004a74 <sys_link+0xde>
  ilock(ip);
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	342080e7          	jalr	834(ra) # 80002d2c <ilock>
  if(ip->type == T_DIR){
    800049f2:	04449703          	lh	a4,68(s1)
    800049f6:	4785                	li	a5,1
    800049f8:	08f70463          	beq	a4,a5,80004a80 <sys_link+0xea>
  ip->nlink++;
    800049fc:	04a4d783          	lhu	a5,74(s1)
    80004a00:	2785                	addiw	a5,a5,1
    80004a02:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a06:	8526                	mv	a0,s1
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	258080e7          	jalr	600(ra) # 80002c60 <iupdate>
  iunlock(ip);
    80004a10:	8526                	mv	a0,s1
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	3dc080e7          	jalr	988(ra) # 80002dee <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a1a:	fd040593          	addi	a1,s0,-48
    80004a1e:	f5040513          	addi	a0,s0,-176
    80004a22:	fffff097          	auipc	ra,0xfffff
    80004a26:	ae4080e7          	jalr	-1308(ra) # 80003506 <nameiparent>
    80004a2a:	892a                	mv	s2,a0
    80004a2c:	c935                	beqz	a0,80004aa0 <sys_link+0x10a>
  ilock(dp);
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	2fe080e7          	jalr	766(ra) # 80002d2c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a36:	00092703          	lw	a4,0(s2)
    80004a3a:	409c                	lw	a5,0(s1)
    80004a3c:	04f71d63          	bne	a4,a5,80004a96 <sys_link+0x100>
    80004a40:	40d0                	lw	a2,4(s1)
    80004a42:	fd040593          	addi	a1,s0,-48
    80004a46:	854a                	mv	a0,s2
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	9de080e7          	jalr	-1570(ra) # 80003426 <dirlink>
    80004a50:	04054363          	bltz	a0,80004a96 <sys_link+0x100>
  iunlockput(dp);
    80004a54:	854a                	mv	a0,s2
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	538080e7          	jalr	1336(ra) # 80002f8e <iunlockput>
  iput(ip);
    80004a5e:	8526                	mv	a0,s1
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	486080e7          	jalr	1158(ra) # 80002ee6 <iput>
  end_op();
    80004a68:	fffff097          	auipc	ra,0xfffff
    80004a6c:	d1e080e7          	jalr	-738(ra) # 80003786 <end_op>
  return 0;
    80004a70:	4781                	li	a5,0
    80004a72:	a085                	j	80004ad2 <sys_link+0x13c>
    end_op();
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	d12080e7          	jalr	-750(ra) # 80003786 <end_op>
    return -1;
    80004a7c:	57fd                	li	a5,-1
    80004a7e:	a891                	j	80004ad2 <sys_link+0x13c>
    iunlockput(ip);
    80004a80:	8526                	mv	a0,s1
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	50c080e7          	jalr	1292(ra) # 80002f8e <iunlockput>
    end_op();
    80004a8a:	fffff097          	auipc	ra,0xfffff
    80004a8e:	cfc080e7          	jalr	-772(ra) # 80003786 <end_op>
    return -1;
    80004a92:	57fd                	li	a5,-1
    80004a94:	a83d                	j	80004ad2 <sys_link+0x13c>
    iunlockput(dp);
    80004a96:	854a                	mv	a0,s2
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	4f6080e7          	jalr	1270(ra) # 80002f8e <iunlockput>
  ilock(ip);
    80004aa0:	8526                	mv	a0,s1
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	28a080e7          	jalr	650(ra) # 80002d2c <ilock>
  ip->nlink--;
    80004aaa:	04a4d783          	lhu	a5,74(s1)
    80004aae:	37fd                	addiw	a5,a5,-1
    80004ab0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ab4:	8526                	mv	a0,s1
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	1aa080e7          	jalr	426(ra) # 80002c60 <iupdate>
  iunlockput(ip);
    80004abe:	8526                	mv	a0,s1
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	4ce080e7          	jalr	1230(ra) # 80002f8e <iunlockput>
  end_op();
    80004ac8:	fffff097          	auipc	ra,0xfffff
    80004acc:	cbe080e7          	jalr	-834(ra) # 80003786 <end_op>
  return -1;
    80004ad0:	57fd                	li	a5,-1
}
    80004ad2:	853e                	mv	a0,a5
    80004ad4:	70b2                	ld	ra,296(sp)
    80004ad6:	7412                	ld	s0,288(sp)
    80004ad8:	64f2                	ld	s1,280(sp)
    80004ada:	6952                	ld	s2,272(sp)
    80004adc:	6155                	addi	sp,sp,304
    80004ade:	8082                	ret

0000000080004ae0 <sys_unlink>:
{
    80004ae0:	7151                	addi	sp,sp,-240
    80004ae2:	f586                	sd	ra,232(sp)
    80004ae4:	f1a2                	sd	s0,224(sp)
    80004ae6:	eda6                	sd	s1,216(sp)
    80004ae8:	e9ca                	sd	s2,208(sp)
    80004aea:	e5ce                	sd	s3,200(sp)
    80004aec:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004aee:	08000613          	li	a2,128
    80004af2:	f3040593          	addi	a1,s0,-208
    80004af6:	4501                	li	a0,0
    80004af8:	ffffd097          	auipc	ra,0xffffd
    80004afc:	706080e7          	jalr	1798(ra) # 800021fe <argstr>
    80004b00:	18054163          	bltz	a0,80004c82 <sys_unlink+0x1a2>
  begin_op();
    80004b04:	fffff097          	auipc	ra,0xfffff
    80004b08:	c04080e7          	jalr	-1020(ra) # 80003708 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b0c:	fb040593          	addi	a1,s0,-80
    80004b10:	f3040513          	addi	a0,s0,-208
    80004b14:	fffff097          	auipc	ra,0xfffff
    80004b18:	9f2080e7          	jalr	-1550(ra) # 80003506 <nameiparent>
    80004b1c:	84aa                	mv	s1,a0
    80004b1e:	c979                	beqz	a0,80004bf4 <sys_unlink+0x114>
  ilock(dp);
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	20c080e7          	jalr	524(ra) # 80002d2c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b28:	00004597          	auipc	a1,0x4
    80004b2c:	c0858593          	addi	a1,a1,-1016 # 80008730 <syscalls+0x2b0>
    80004b30:	fb040513          	addi	a0,s0,-80
    80004b34:	ffffe097          	auipc	ra,0xffffe
    80004b38:	6c2080e7          	jalr	1730(ra) # 800031f6 <namecmp>
    80004b3c:	14050a63          	beqz	a0,80004c90 <sys_unlink+0x1b0>
    80004b40:	00004597          	auipc	a1,0x4
    80004b44:	bf858593          	addi	a1,a1,-1032 # 80008738 <syscalls+0x2b8>
    80004b48:	fb040513          	addi	a0,s0,-80
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	6aa080e7          	jalr	1706(ra) # 800031f6 <namecmp>
    80004b54:	12050e63          	beqz	a0,80004c90 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b58:	f2c40613          	addi	a2,s0,-212
    80004b5c:	fb040593          	addi	a1,s0,-80
    80004b60:	8526                	mv	a0,s1
    80004b62:	ffffe097          	auipc	ra,0xffffe
    80004b66:	6ae080e7          	jalr	1710(ra) # 80003210 <dirlookup>
    80004b6a:	892a                	mv	s2,a0
    80004b6c:	12050263          	beqz	a0,80004c90 <sys_unlink+0x1b0>
  ilock(ip);
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	1bc080e7          	jalr	444(ra) # 80002d2c <ilock>
  if(ip->nlink < 1)
    80004b78:	04a91783          	lh	a5,74(s2)
    80004b7c:	08f05263          	blez	a5,80004c00 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b80:	04491703          	lh	a4,68(s2)
    80004b84:	4785                	li	a5,1
    80004b86:	08f70563          	beq	a4,a5,80004c10 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b8a:	4641                	li	a2,16
    80004b8c:	4581                	li	a1,0
    80004b8e:	fc040513          	addi	a0,s0,-64
    80004b92:	ffffb097          	auipc	ra,0xffffb
    80004b96:	70c080e7          	jalr	1804(ra) # 8000029e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b9a:	4741                	li	a4,16
    80004b9c:	f2c42683          	lw	a3,-212(s0)
    80004ba0:	fc040613          	addi	a2,s0,-64
    80004ba4:	4581                	li	a1,0
    80004ba6:	8526                	mv	a0,s1
    80004ba8:	ffffe097          	auipc	ra,0xffffe
    80004bac:	530080e7          	jalr	1328(ra) # 800030d8 <writei>
    80004bb0:	47c1                	li	a5,16
    80004bb2:	0af51563          	bne	a0,a5,80004c5c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bb6:	04491703          	lh	a4,68(s2)
    80004bba:	4785                	li	a5,1
    80004bbc:	0af70863          	beq	a4,a5,80004c6c <sys_unlink+0x18c>
  iunlockput(dp);
    80004bc0:	8526                	mv	a0,s1
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	3cc080e7          	jalr	972(ra) # 80002f8e <iunlockput>
  ip->nlink--;
    80004bca:	04a95783          	lhu	a5,74(s2)
    80004bce:	37fd                	addiw	a5,a5,-1
    80004bd0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bd4:	854a                	mv	a0,s2
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	08a080e7          	jalr	138(ra) # 80002c60 <iupdate>
  iunlockput(ip);
    80004bde:	854a                	mv	a0,s2
    80004be0:	ffffe097          	auipc	ra,0xffffe
    80004be4:	3ae080e7          	jalr	942(ra) # 80002f8e <iunlockput>
  end_op();
    80004be8:	fffff097          	auipc	ra,0xfffff
    80004bec:	b9e080e7          	jalr	-1122(ra) # 80003786 <end_op>
  return 0;
    80004bf0:	4501                	li	a0,0
    80004bf2:	a84d                	j	80004ca4 <sys_unlink+0x1c4>
    end_op();
    80004bf4:	fffff097          	auipc	ra,0xfffff
    80004bf8:	b92080e7          	jalr	-1134(ra) # 80003786 <end_op>
    return -1;
    80004bfc:	557d                	li	a0,-1
    80004bfe:	a05d                	j	80004ca4 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c00:	00004517          	auipc	a0,0x4
    80004c04:	b6050513          	addi	a0,a0,-1184 # 80008760 <syscalls+0x2e0>
    80004c08:	00001097          	auipc	ra,0x1
    80004c0c:	198080e7          	jalr	408(ra) # 80005da0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c10:	04c92703          	lw	a4,76(s2)
    80004c14:	02000793          	li	a5,32
    80004c18:	f6e7f9e3          	bgeu	a5,a4,80004b8a <sys_unlink+0xaa>
    80004c1c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c20:	4741                	li	a4,16
    80004c22:	86ce                	mv	a3,s3
    80004c24:	f1840613          	addi	a2,s0,-232
    80004c28:	4581                	li	a1,0
    80004c2a:	854a                	mv	a0,s2
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	3b4080e7          	jalr	948(ra) # 80002fe0 <readi>
    80004c34:	47c1                	li	a5,16
    80004c36:	00f51b63          	bne	a0,a5,80004c4c <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c3a:	f1845783          	lhu	a5,-232(s0)
    80004c3e:	e7a1                	bnez	a5,80004c86 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c40:	29c1                	addiw	s3,s3,16
    80004c42:	04c92783          	lw	a5,76(s2)
    80004c46:	fcf9ede3          	bltu	s3,a5,80004c20 <sys_unlink+0x140>
    80004c4a:	b781                	j	80004b8a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c4c:	00004517          	auipc	a0,0x4
    80004c50:	b2c50513          	addi	a0,a0,-1236 # 80008778 <syscalls+0x2f8>
    80004c54:	00001097          	auipc	ra,0x1
    80004c58:	14c080e7          	jalr	332(ra) # 80005da0 <panic>
    panic("unlink: writei");
    80004c5c:	00004517          	auipc	a0,0x4
    80004c60:	b3450513          	addi	a0,a0,-1228 # 80008790 <syscalls+0x310>
    80004c64:	00001097          	auipc	ra,0x1
    80004c68:	13c080e7          	jalr	316(ra) # 80005da0 <panic>
    dp->nlink--;
    80004c6c:	04a4d783          	lhu	a5,74(s1)
    80004c70:	37fd                	addiw	a5,a5,-1
    80004c72:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c76:	8526                	mv	a0,s1
    80004c78:	ffffe097          	auipc	ra,0xffffe
    80004c7c:	fe8080e7          	jalr	-24(ra) # 80002c60 <iupdate>
    80004c80:	b781                	j	80004bc0 <sys_unlink+0xe0>
    return -1;
    80004c82:	557d                	li	a0,-1
    80004c84:	a005                	j	80004ca4 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c86:	854a                	mv	a0,s2
    80004c88:	ffffe097          	auipc	ra,0xffffe
    80004c8c:	306080e7          	jalr	774(ra) # 80002f8e <iunlockput>
  iunlockput(dp);
    80004c90:	8526                	mv	a0,s1
    80004c92:	ffffe097          	auipc	ra,0xffffe
    80004c96:	2fc080e7          	jalr	764(ra) # 80002f8e <iunlockput>
  end_op();
    80004c9a:	fffff097          	auipc	ra,0xfffff
    80004c9e:	aec080e7          	jalr	-1300(ra) # 80003786 <end_op>
  return -1;
    80004ca2:	557d                	li	a0,-1
}
    80004ca4:	70ae                	ld	ra,232(sp)
    80004ca6:	740e                	ld	s0,224(sp)
    80004ca8:	64ee                	ld	s1,216(sp)
    80004caa:	694e                	ld	s2,208(sp)
    80004cac:	69ae                	ld	s3,200(sp)
    80004cae:	616d                	addi	sp,sp,240
    80004cb0:	8082                	ret

0000000080004cb2 <sys_open>:

uint64
sys_open(void)
{
    80004cb2:	7131                	addi	sp,sp,-192
    80004cb4:	fd06                	sd	ra,184(sp)
    80004cb6:	f922                	sd	s0,176(sp)
    80004cb8:	f526                	sd	s1,168(sp)
    80004cba:	f14a                	sd	s2,160(sp)
    80004cbc:	ed4e                	sd	s3,152(sp)
    80004cbe:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cc0:	08000613          	li	a2,128
    80004cc4:	f5040593          	addi	a1,s0,-176
    80004cc8:	4501                	li	a0,0
    80004cca:	ffffd097          	auipc	ra,0xffffd
    80004cce:	534080e7          	jalr	1332(ra) # 800021fe <argstr>
    return -1;
    80004cd2:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cd4:	0c054163          	bltz	a0,80004d96 <sys_open+0xe4>
    80004cd8:	f4c40593          	addi	a1,s0,-180
    80004cdc:	4505                	li	a0,1
    80004cde:	ffffd097          	auipc	ra,0xffffd
    80004ce2:	4dc080e7          	jalr	1244(ra) # 800021ba <argint>
    80004ce6:	0a054863          	bltz	a0,80004d96 <sys_open+0xe4>

  begin_op();
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	a1e080e7          	jalr	-1506(ra) # 80003708 <begin_op>

  if(omode & O_CREATE){
    80004cf2:	f4c42783          	lw	a5,-180(s0)
    80004cf6:	2007f793          	andi	a5,a5,512
    80004cfa:	cbdd                	beqz	a5,80004db0 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cfc:	4681                	li	a3,0
    80004cfe:	4601                	li	a2,0
    80004d00:	4589                	li	a1,2
    80004d02:	f5040513          	addi	a0,s0,-176
    80004d06:	00000097          	auipc	ra,0x0
    80004d0a:	970080e7          	jalr	-1680(ra) # 80004676 <create>
    80004d0e:	892a                	mv	s2,a0
    if(ip == 0){
    80004d10:	c959                	beqz	a0,80004da6 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d12:	04491703          	lh	a4,68(s2)
    80004d16:	478d                	li	a5,3
    80004d18:	00f71763          	bne	a4,a5,80004d26 <sys_open+0x74>
    80004d1c:	04695703          	lhu	a4,70(s2)
    80004d20:	47a5                	li	a5,9
    80004d22:	0ce7ec63          	bltu	a5,a4,80004dfa <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	dee080e7          	jalr	-530(ra) # 80003b14 <filealloc>
    80004d2e:	89aa                	mv	s3,a0
    80004d30:	10050263          	beqz	a0,80004e34 <sys_open+0x182>
    80004d34:	00000097          	auipc	ra,0x0
    80004d38:	900080e7          	jalr	-1792(ra) # 80004634 <fdalloc>
    80004d3c:	84aa                	mv	s1,a0
    80004d3e:	0e054663          	bltz	a0,80004e2a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d42:	04491703          	lh	a4,68(s2)
    80004d46:	478d                	li	a5,3
    80004d48:	0cf70463          	beq	a4,a5,80004e10 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d4c:	4789                	li	a5,2
    80004d4e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d52:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d56:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d5a:	f4c42783          	lw	a5,-180(s0)
    80004d5e:	0017c713          	xori	a4,a5,1
    80004d62:	8b05                	andi	a4,a4,1
    80004d64:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d68:	0037f713          	andi	a4,a5,3
    80004d6c:	00e03733          	snez	a4,a4
    80004d70:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d74:	4007f793          	andi	a5,a5,1024
    80004d78:	c791                	beqz	a5,80004d84 <sys_open+0xd2>
    80004d7a:	04491703          	lh	a4,68(s2)
    80004d7e:	4789                	li	a5,2
    80004d80:	08f70f63          	beq	a4,a5,80004e1e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d84:	854a                	mv	a0,s2
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	068080e7          	jalr	104(ra) # 80002dee <iunlock>
  end_op();
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	9f8080e7          	jalr	-1544(ra) # 80003786 <end_op>

  return fd;
}
    80004d96:	8526                	mv	a0,s1
    80004d98:	70ea                	ld	ra,184(sp)
    80004d9a:	744a                	ld	s0,176(sp)
    80004d9c:	74aa                	ld	s1,168(sp)
    80004d9e:	790a                	ld	s2,160(sp)
    80004da0:	69ea                	ld	s3,152(sp)
    80004da2:	6129                	addi	sp,sp,192
    80004da4:	8082                	ret
      end_op();
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	9e0080e7          	jalr	-1568(ra) # 80003786 <end_op>
      return -1;
    80004dae:	b7e5                	j	80004d96 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004db0:	f5040513          	addi	a0,s0,-176
    80004db4:	ffffe097          	auipc	ra,0xffffe
    80004db8:	734080e7          	jalr	1844(ra) # 800034e8 <namei>
    80004dbc:	892a                	mv	s2,a0
    80004dbe:	c905                	beqz	a0,80004dee <sys_open+0x13c>
    ilock(ip);
    80004dc0:	ffffe097          	auipc	ra,0xffffe
    80004dc4:	f6c080e7          	jalr	-148(ra) # 80002d2c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dc8:	04491703          	lh	a4,68(s2)
    80004dcc:	4785                	li	a5,1
    80004dce:	f4f712e3          	bne	a4,a5,80004d12 <sys_open+0x60>
    80004dd2:	f4c42783          	lw	a5,-180(s0)
    80004dd6:	dba1                	beqz	a5,80004d26 <sys_open+0x74>
      iunlockput(ip);
    80004dd8:	854a                	mv	a0,s2
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	1b4080e7          	jalr	436(ra) # 80002f8e <iunlockput>
      end_op();
    80004de2:	fffff097          	auipc	ra,0xfffff
    80004de6:	9a4080e7          	jalr	-1628(ra) # 80003786 <end_op>
      return -1;
    80004dea:	54fd                	li	s1,-1
    80004dec:	b76d                	j	80004d96 <sys_open+0xe4>
      end_op();
    80004dee:	fffff097          	auipc	ra,0xfffff
    80004df2:	998080e7          	jalr	-1640(ra) # 80003786 <end_op>
      return -1;
    80004df6:	54fd                	li	s1,-1
    80004df8:	bf79                	j	80004d96 <sys_open+0xe4>
    iunlockput(ip);
    80004dfa:	854a                	mv	a0,s2
    80004dfc:	ffffe097          	auipc	ra,0xffffe
    80004e00:	192080e7          	jalr	402(ra) # 80002f8e <iunlockput>
    end_op();
    80004e04:	fffff097          	auipc	ra,0xfffff
    80004e08:	982080e7          	jalr	-1662(ra) # 80003786 <end_op>
    return -1;
    80004e0c:	54fd                	li	s1,-1
    80004e0e:	b761                	j	80004d96 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e10:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e14:	04691783          	lh	a5,70(s2)
    80004e18:	02f99223          	sh	a5,36(s3)
    80004e1c:	bf2d                	j	80004d56 <sys_open+0xa4>
    itrunc(ip);
    80004e1e:	854a                	mv	a0,s2
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	01a080e7          	jalr	26(ra) # 80002e3a <itrunc>
    80004e28:	bfb1                	j	80004d84 <sys_open+0xd2>
      fileclose(f);
    80004e2a:	854e                	mv	a0,s3
    80004e2c:	fffff097          	auipc	ra,0xfffff
    80004e30:	da4080e7          	jalr	-604(ra) # 80003bd0 <fileclose>
    iunlockput(ip);
    80004e34:	854a                	mv	a0,s2
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	158080e7          	jalr	344(ra) # 80002f8e <iunlockput>
    end_op();
    80004e3e:	fffff097          	auipc	ra,0xfffff
    80004e42:	948080e7          	jalr	-1720(ra) # 80003786 <end_op>
    return -1;
    80004e46:	54fd                	li	s1,-1
    80004e48:	b7b9                	j	80004d96 <sys_open+0xe4>

0000000080004e4a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e4a:	7175                	addi	sp,sp,-144
    80004e4c:	e506                	sd	ra,136(sp)
    80004e4e:	e122                	sd	s0,128(sp)
    80004e50:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e52:	fffff097          	auipc	ra,0xfffff
    80004e56:	8b6080e7          	jalr	-1866(ra) # 80003708 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e5a:	08000613          	li	a2,128
    80004e5e:	f7040593          	addi	a1,s0,-144
    80004e62:	4501                	li	a0,0
    80004e64:	ffffd097          	auipc	ra,0xffffd
    80004e68:	39a080e7          	jalr	922(ra) # 800021fe <argstr>
    80004e6c:	02054963          	bltz	a0,80004e9e <sys_mkdir+0x54>
    80004e70:	4681                	li	a3,0
    80004e72:	4601                	li	a2,0
    80004e74:	4585                	li	a1,1
    80004e76:	f7040513          	addi	a0,s0,-144
    80004e7a:	fffff097          	auipc	ra,0xfffff
    80004e7e:	7fc080e7          	jalr	2044(ra) # 80004676 <create>
    80004e82:	cd11                	beqz	a0,80004e9e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	10a080e7          	jalr	266(ra) # 80002f8e <iunlockput>
  end_op();
    80004e8c:	fffff097          	auipc	ra,0xfffff
    80004e90:	8fa080e7          	jalr	-1798(ra) # 80003786 <end_op>
  return 0;
    80004e94:	4501                	li	a0,0
}
    80004e96:	60aa                	ld	ra,136(sp)
    80004e98:	640a                	ld	s0,128(sp)
    80004e9a:	6149                	addi	sp,sp,144
    80004e9c:	8082                	ret
    end_op();
    80004e9e:	fffff097          	auipc	ra,0xfffff
    80004ea2:	8e8080e7          	jalr	-1816(ra) # 80003786 <end_op>
    return -1;
    80004ea6:	557d                	li	a0,-1
    80004ea8:	b7fd                	j	80004e96 <sys_mkdir+0x4c>

0000000080004eaa <sys_mknod>:

uint64
sys_mknod(void)
{
    80004eaa:	7135                	addi	sp,sp,-160
    80004eac:	ed06                	sd	ra,152(sp)
    80004eae:	e922                	sd	s0,144(sp)
    80004eb0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004eb2:	fffff097          	auipc	ra,0xfffff
    80004eb6:	856080e7          	jalr	-1962(ra) # 80003708 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eba:	08000613          	li	a2,128
    80004ebe:	f7040593          	addi	a1,s0,-144
    80004ec2:	4501                	li	a0,0
    80004ec4:	ffffd097          	auipc	ra,0xffffd
    80004ec8:	33a080e7          	jalr	826(ra) # 800021fe <argstr>
    80004ecc:	04054a63          	bltz	a0,80004f20 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004ed0:	f6c40593          	addi	a1,s0,-148
    80004ed4:	4505                	li	a0,1
    80004ed6:	ffffd097          	auipc	ra,0xffffd
    80004eda:	2e4080e7          	jalr	740(ra) # 800021ba <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ede:	04054163          	bltz	a0,80004f20 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004ee2:	f6840593          	addi	a1,s0,-152
    80004ee6:	4509                	li	a0,2
    80004ee8:	ffffd097          	auipc	ra,0xffffd
    80004eec:	2d2080e7          	jalr	722(ra) # 800021ba <argint>
     argint(1, &major) < 0 ||
    80004ef0:	02054863          	bltz	a0,80004f20 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ef4:	f6841683          	lh	a3,-152(s0)
    80004ef8:	f6c41603          	lh	a2,-148(s0)
    80004efc:	458d                	li	a1,3
    80004efe:	f7040513          	addi	a0,s0,-144
    80004f02:	fffff097          	auipc	ra,0xfffff
    80004f06:	774080e7          	jalr	1908(ra) # 80004676 <create>
     argint(2, &minor) < 0 ||
    80004f0a:	c919                	beqz	a0,80004f20 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f0c:	ffffe097          	auipc	ra,0xffffe
    80004f10:	082080e7          	jalr	130(ra) # 80002f8e <iunlockput>
  end_op();
    80004f14:	fffff097          	auipc	ra,0xfffff
    80004f18:	872080e7          	jalr	-1934(ra) # 80003786 <end_op>
  return 0;
    80004f1c:	4501                	li	a0,0
    80004f1e:	a031                	j	80004f2a <sys_mknod+0x80>
    end_op();
    80004f20:	fffff097          	auipc	ra,0xfffff
    80004f24:	866080e7          	jalr	-1946(ra) # 80003786 <end_op>
    return -1;
    80004f28:	557d                	li	a0,-1
}
    80004f2a:	60ea                	ld	ra,152(sp)
    80004f2c:	644a                	ld	s0,144(sp)
    80004f2e:	610d                	addi	sp,sp,160
    80004f30:	8082                	ret

0000000080004f32 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f32:	7135                	addi	sp,sp,-160
    80004f34:	ed06                	sd	ra,152(sp)
    80004f36:	e922                	sd	s0,144(sp)
    80004f38:	e526                	sd	s1,136(sp)
    80004f3a:	e14a                	sd	s2,128(sp)
    80004f3c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f3e:	ffffc097          	auipc	ra,0xffffc
    80004f42:	1a6080e7          	jalr	422(ra) # 800010e4 <myproc>
    80004f46:	892a                	mv	s2,a0
  
  begin_op();
    80004f48:	ffffe097          	auipc	ra,0xffffe
    80004f4c:	7c0080e7          	jalr	1984(ra) # 80003708 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f50:	08000613          	li	a2,128
    80004f54:	f6040593          	addi	a1,s0,-160
    80004f58:	4501                	li	a0,0
    80004f5a:	ffffd097          	auipc	ra,0xffffd
    80004f5e:	2a4080e7          	jalr	676(ra) # 800021fe <argstr>
    80004f62:	04054b63          	bltz	a0,80004fb8 <sys_chdir+0x86>
    80004f66:	f6040513          	addi	a0,s0,-160
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	57e080e7          	jalr	1406(ra) # 800034e8 <namei>
    80004f72:	84aa                	mv	s1,a0
    80004f74:	c131                	beqz	a0,80004fb8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	db6080e7          	jalr	-586(ra) # 80002d2c <ilock>
  if(ip->type != T_DIR){
    80004f7e:	04449703          	lh	a4,68(s1)
    80004f82:	4785                	li	a5,1
    80004f84:	04f71063          	bne	a4,a5,80004fc4 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f88:	8526                	mv	a0,s1
    80004f8a:	ffffe097          	auipc	ra,0xffffe
    80004f8e:	e64080e7          	jalr	-412(ra) # 80002dee <iunlock>
  iput(p->cwd);
    80004f92:	15093503          	ld	a0,336(s2)
    80004f96:	ffffe097          	auipc	ra,0xffffe
    80004f9a:	f50080e7          	jalr	-176(ra) # 80002ee6 <iput>
  end_op();
    80004f9e:	ffffe097          	auipc	ra,0xffffe
    80004fa2:	7e8080e7          	jalr	2024(ra) # 80003786 <end_op>
  p->cwd = ip;
    80004fa6:	14993823          	sd	s1,336(s2)
  return 0;
    80004faa:	4501                	li	a0,0
}
    80004fac:	60ea                	ld	ra,152(sp)
    80004fae:	644a                	ld	s0,144(sp)
    80004fb0:	64aa                	ld	s1,136(sp)
    80004fb2:	690a                	ld	s2,128(sp)
    80004fb4:	610d                	addi	sp,sp,160
    80004fb6:	8082                	ret
    end_op();
    80004fb8:	ffffe097          	auipc	ra,0xffffe
    80004fbc:	7ce080e7          	jalr	1998(ra) # 80003786 <end_op>
    return -1;
    80004fc0:	557d                	li	a0,-1
    80004fc2:	b7ed                	j	80004fac <sys_chdir+0x7a>
    iunlockput(ip);
    80004fc4:	8526                	mv	a0,s1
    80004fc6:	ffffe097          	auipc	ra,0xffffe
    80004fca:	fc8080e7          	jalr	-56(ra) # 80002f8e <iunlockput>
    end_op();
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	7b8080e7          	jalr	1976(ra) # 80003786 <end_op>
    return -1;
    80004fd6:	557d                	li	a0,-1
    80004fd8:	bfd1                	j	80004fac <sys_chdir+0x7a>

0000000080004fda <sys_exec>:

uint64
sys_exec(void)
{
    80004fda:	7145                	addi	sp,sp,-464
    80004fdc:	e786                	sd	ra,456(sp)
    80004fde:	e3a2                	sd	s0,448(sp)
    80004fe0:	ff26                	sd	s1,440(sp)
    80004fe2:	fb4a                	sd	s2,432(sp)
    80004fe4:	f74e                	sd	s3,424(sp)
    80004fe6:	f352                	sd	s4,416(sp)
    80004fe8:	ef56                	sd	s5,408(sp)
    80004fea:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fec:	08000613          	li	a2,128
    80004ff0:	f4040593          	addi	a1,s0,-192
    80004ff4:	4501                	li	a0,0
    80004ff6:	ffffd097          	auipc	ra,0xffffd
    80004ffa:	208080e7          	jalr	520(ra) # 800021fe <argstr>
    return -1;
    80004ffe:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005000:	0c054b63          	bltz	a0,800050d6 <sys_exec+0xfc>
    80005004:	e3840593          	addi	a1,s0,-456
    80005008:	4505                	li	a0,1
    8000500a:	ffffd097          	auipc	ra,0xffffd
    8000500e:	1d2080e7          	jalr	466(ra) # 800021dc <argaddr>
    80005012:	0c054263          	bltz	a0,800050d6 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005016:	10000613          	li	a2,256
    8000501a:	4581                	li	a1,0
    8000501c:	e4040513          	addi	a0,s0,-448
    80005020:	ffffb097          	auipc	ra,0xffffb
    80005024:	27e080e7          	jalr	638(ra) # 8000029e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005028:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000502c:	89a6                	mv	s3,s1
    8000502e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005030:	02000a13          	li	s4,32
    80005034:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005038:	00391513          	slli	a0,s2,0x3
    8000503c:	e3040593          	addi	a1,s0,-464
    80005040:	e3843783          	ld	a5,-456(s0)
    80005044:	953e                	add	a0,a0,a5
    80005046:	ffffd097          	auipc	ra,0xffffd
    8000504a:	0da080e7          	jalr	218(ra) # 80002120 <fetchaddr>
    8000504e:	02054a63          	bltz	a0,80005082 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005052:	e3043783          	ld	a5,-464(s0)
    80005056:	c3b9                	beqz	a5,8000509c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005058:	ffffb097          	auipc	ra,0xffffb
    8000505c:	fc4080e7          	jalr	-60(ra) # 8000001c <kalloc>
    80005060:	85aa                	mv	a1,a0
    80005062:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005066:	cd11                	beqz	a0,80005082 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005068:	6605                	lui	a2,0x1
    8000506a:	e3043503          	ld	a0,-464(s0)
    8000506e:	ffffd097          	auipc	ra,0xffffd
    80005072:	104080e7          	jalr	260(ra) # 80002172 <fetchstr>
    80005076:	00054663          	bltz	a0,80005082 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000507a:	0905                	addi	s2,s2,1
    8000507c:	09a1                	addi	s3,s3,8
    8000507e:	fb491be3          	bne	s2,s4,80005034 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005082:	f4040913          	addi	s2,s0,-192
    80005086:	6088                	ld	a0,0(s1)
    80005088:	c531                	beqz	a0,800050d4 <sys_exec+0xfa>
    kfree(argv[i]);
    8000508a:	ffffb097          	auipc	ra,0xffffb
    8000508e:	0cc080e7          	jalr	204(ra) # 80000156 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005092:	04a1                	addi	s1,s1,8
    80005094:	ff2499e3          	bne	s1,s2,80005086 <sys_exec+0xac>
  return -1;
    80005098:	597d                	li	s2,-1
    8000509a:	a835                	j	800050d6 <sys_exec+0xfc>
      argv[i] = 0;
    8000509c:	0a8e                	slli	s5,s5,0x3
    8000509e:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7fdb8d80>
    800050a2:	00878ab3          	add	s5,a5,s0
    800050a6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050aa:	e4040593          	addi	a1,s0,-448
    800050ae:	f4040513          	addi	a0,s0,-192
    800050b2:	fffff097          	auipc	ra,0xfffff
    800050b6:	172080e7          	jalr	370(ra) # 80004224 <exec>
    800050ba:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050bc:	f4040993          	addi	s3,s0,-192
    800050c0:	6088                	ld	a0,0(s1)
    800050c2:	c911                	beqz	a0,800050d6 <sys_exec+0xfc>
    kfree(argv[i]);
    800050c4:	ffffb097          	auipc	ra,0xffffb
    800050c8:	092080e7          	jalr	146(ra) # 80000156 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050cc:	04a1                	addi	s1,s1,8
    800050ce:	ff3499e3          	bne	s1,s3,800050c0 <sys_exec+0xe6>
    800050d2:	a011                	j	800050d6 <sys_exec+0xfc>
  return -1;
    800050d4:	597d                	li	s2,-1
}
    800050d6:	854a                	mv	a0,s2
    800050d8:	60be                	ld	ra,456(sp)
    800050da:	641e                	ld	s0,448(sp)
    800050dc:	74fa                	ld	s1,440(sp)
    800050de:	795a                	ld	s2,432(sp)
    800050e0:	79ba                	ld	s3,424(sp)
    800050e2:	7a1a                	ld	s4,416(sp)
    800050e4:	6afa                	ld	s5,408(sp)
    800050e6:	6179                	addi	sp,sp,464
    800050e8:	8082                	ret

00000000800050ea <sys_pipe>:

uint64
sys_pipe(void)
{
    800050ea:	7139                	addi	sp,sp,-64
    800050ec:	fc06                	sd	ra,56(sp)
    800050ee:	f822                	sd	s0,48(sp)
    800050f0:	f426                	sd	s1,40(sp)
    800050f2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050f4:	ffffc097          	auipc	ra,0xffffc
    800050f8:	ff0080e7          	jalr	-16(ra) # 800010e4 <myproc>
    800050fc:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050fe:	fd840593          	addi	a1,s0,-40
    80005102:	4501                	li	a0,0
    80005104:	ffffd097          	auipc	ra,0xffffd
    80005108:	0d8080e7          	jalr	216(ra) # 800021dc <argaddr>
    return -1;
    8000510c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000510e:	0e054063          	bltz	a0,800051ee <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005112:	fc840593          	addi	a1,s0,-56
    80005116:	fd040513          	addi	a0,s0,-48
    8000511a:	fffff097          	auipc	ra,0xfffff
    8000511e:	de6080e7          	jalr	-538(ra) # 80003f00 <pipealloc>
    return -1;
    80005122:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005124:	0c054563          	bltz	a0,800051ee <sys_pipe+0x104>
  fd0 = -1;
    80005128:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000512c:	fd043503          	ld	a0,-48(s0)
    80005130:	fffff097          	auipc	ra,0xfffff
    80005134:	504080e7          	jalr	1284(ra) # 80004634 <fdalloc>
    80005138:	fca42223          	sw	a0,-60(s0)
    8000513c:	08054c63          	bltz	a0,800051d4 <sys_pipe+0xea>
    80005140:	fc843503          	ld	a0,-56(s0)
    80005144:	fffff097          	auipc	ra,0xfffff
    80005148:	4f0080e7          	jalr	1264(ra) # 80004634 <fdalloc>
    8000514c:	fca42023          	sw	a0,-64(s0)
    80005150:	06054963          	bltz	a0,800051c2 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005154:	4691                	li	a3,4
    80005156:	fc440613          	addi	a2,s0,-60
    8000515a:	fd843583          	ld	a1,-40(s0)
    8000515e:	68a8                	ld	a0,80(s1)
    80005160:	ffffc097          	auipc	ra,0xffffc
    80005164:	d72080e7          	jalr	-654(ra) # 80000ed2 <copyout>
    80005168:	02054063          	bltz	a0,80005188 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000516c:	4691                	li	a3,4
    8000516e:	fc040613          	addi	a2,s0,-64
    80005172:	fd843583          	ld	a1,-40(s0)
    80005176:	0591                	addi	a1,a1,4
    80005178:	68a8                	ld	a0,80(s1)
    8000517a:	ffffc097          	auipc	ra,0xffffc
    8000517e:	d58080e7          	jalr	-680(ra) # 80000ed2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005182:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005184:	06055563          	bgez	a0,800051ee <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005188:	fc442783          	lw	a5,-60(s0)
    8000518c:	07e9                	addi	a5,a5,26
    8000518e:	078e                	slli	a5,a5,0x3
    80005190:	97a6                	add	a5,a5,s1
    80005192:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005196:	fc042783          	lw	a5,-64(s0)
    8000519a:	07e9                	addi	a5,a5,26
    8000519c:	078e                	slli	a5,a5,0x3
    8000519e:	00f48533          	add	a0,s1,a5
    800051a2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051a6:	fd043503          	ld	a0,-48(s0)
    800051aa:	fffff097          	auipc	ra,0xfffff
    800051ae:	a26080e7          	jalr	-1498(ra) # 80003bd0 <fileclose>
    fileclose(wf);
    800051b2:	fc843503          	ld	a0,-56(s0)
    800051b6:	fffff097          	auipc	ra,0xfffff
    800051ba:	a1a080e7          	jalr	-1510(ra) # 80003bd0 <fileclose>
    return -1;
    800051be:	57fd                	li	a5,-1
    800051c0:	a03d                	j	800051ee <sys_pipe+0x104>
    if(fd0 >= 0)
    800051c2:	fc442783          	lw	a5,-60(s0)
    800051c6:	0007c763          	bltz	a5,800051d4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051ca:	07e9                	addi	a5,a5,26
    800051cc:	078e                	slli	a5,a5,0x3
    800051ce:	97a6                	add	a5,a5,s1
    800051d0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800051d4:	fd043503          	ld	a0,-48(s0)
    800051d8:	fffff097          	auipc	ra,0xfffff
    800051dc:	9f8080e7          	jalr	-1544(ra) # 80003bd0 <fileclose>
    fileclose(wf);
    800051e0:	fc843503          	ld	a0,-56(s0)
    800051e4:	fffff097          	auipc	ra,0xfffff
    800051e8:	9ec080e7          	jalr	-1556(ra) # 80003bd0 <fileclose>
    return -1;
    800051ec:	57fd                	li	a5,-1
}
    800051ee:	853e                	mv	a0,a5
    800051f0:	70e2                	ld	ra,56(sp)
    800051f2:	7442                	ld	s0,48(sp)
    800051f4:	74a2                	ld	s1,40(sp)
    800051f6:	6121                	addi	sp,sp,64
    800051f8:	8082                	ret
    800051fa:	0000                	unimp
    800051fc:	0000                	unimp
	...

0000000080005200 <kernelvec>:
    80005200:	7111                	addi	sp,sp,-256
    80005202:	e006                	sd	ra,0(sp)
    80005204:	e40a                	sd	sp,8(sp)
    80005206:	e80e                	sd	gp,16(sp)
    80005208:	ec12                	sd	tp,24(sp)
    8000520a:	f016                	sd	t0,32(sp)
    8000520c:	f41a                	sd	t1,40(sp)
    8000520e:	f81e                	sd	t2,48(sp)
    80005210:	fc22                	sd	s0,56(sp)
    80005212:	e0a6                	sd	s1,64(sp)
    80005214:	e4aa                	sd	a0,72(sp)
    80005216:	e8ae                	sd	a1,80(sp)
    80005218:	ecb2                	sd	a2,88(sp)
    8000521a:	f0b6                	sd	a3,96(sp)
    8000521c:	f4ba                	sd	a4,104(sp)
    8000521e:	f8be                	sd	a5,112(sp)
    80005220:	fcc2                	sd	a6,120(sp)
    80005222:	e146                	sd	a7,128(sp)
    80005224:	e54a                	sd	s2,136(sp)
    80005226:	e94e                	sd	s3,144(sp)
    80005228:	ed52                	sd	s4,152(sp)
    8000522a:	f156                	sd	s5,160(sp)
    8000522c:	f55a                	sd	s6,168(sp)
    8000522e:	f95e                	sd	s7,176(sp)
    80005230:	fd62                	sd	s8,184(sp)
    80005232:	e1e6                	sd	s9,192(sp)
    80005234:	e5ea                	sd	s10,200(sp)
    80005236:	e9ee                	sd	s11,208(sp)
    80005238:	edf2                	sd	t3,216(sp)
    8000523a:	f1f6                	sd	t4,224(sp)
    8000523c:	f5fa                	sd	t5,232(sp)
    8000523e:	f9fe                	sd	t6,240(sp)
    80005240:	dadfc0ef          	jal	ra,80001fec <kerneltrap>
    80005244:	6082                	ld	ra,0(sp)
    80005246:	6122                	ld	sp,8(sp)
    80005248:	61c2                	ld	gp,16(sp)
    8000524a:	7282                	ld	t0,32(sp)
    8000524c:	7322                	ld	t1,40(sp)
    8000524e:	73c2                	ld	t2,48(sp)
    80005250:	7462                	ld	s0,56(sp)
    80005252:	6486                	ld	s1,64(sp)
    80005254:	6526                	ld	a0,72(sp)
    80005256:	65c6                	ld	a1,80(sp)
    80005258:	6666                	ld	a2,88(sp)
    8000525a:	7686                	ld	a3,96(sp)
    8000525c:	7726                	ld	a4,104(sp)
    8000525e:	77c6                	ld	a5,112(sp)
    80005260:	7866                	ld	a6,120(sp)
    80005262:	688a                	ld	a7,128(sp)
    80005264:	692a                	ld	s2,136(sp)
    80005266:	69ca                	ld	s3,144(sp)
    80005268:	6a6a                	ld	s4,152(sp)
    8000526a:	7a8a                	ld	s5,160(sp)
    8000526c:	7b2a                	ld	s6,168(sp)
    8000526e:	7bca                	ld	s7,176(sp)
    80005270:	7c6a                	ld	s8,184(sp)
    80005272:	6c8e                	ld	s9,192(sp)
    80005274:	6d2e                	ld	s10,200(sp)
    80005276:	6dce                	ld	s11,208(sp)
    80005278:	6e6e                	ld	t3,216(sp)
    8000527a:	7e8e                	ld	t4,224(sp)
    8000527c:	7f2e                	ld	t5,232(sp)
    8000527e:	7fce                	ld	t6,240(sp)
    80005280:	6111                	addi	sp,sp,256
    80005282:	10200073          	sret
    80005286:	00000013          	nop
    8000528a:	00000013          	nop
    8000528e:	0001                	nop

0000000080005290 <timervec>:
    80005290:	34051573          	csrrw	a0,mscratch,a0
    80005294:	e10c                	sd	a1,0(a0)
    80005296:	e510                	sd	a2,8(a0)
    80005298:	e914                	sd	a3,16(a0)
    8000529a:	6d0c                	ld	a1,24(a0)
    8000529c:	7110                	ld	a2,32(a0)
    8000529e:	6194                	ld	a3,0(a1)
    800052a0:	96b2                	add	a3,a3,a2
    800052a2:	e194                	sd	a3,0(a1)
    800052a4:	4589                	li	a1,2
    800052a6:	14459073          	csrw	sip,a1
    800052aa:	6914                	ld	a3,16(a0)
    800052ac:	6510                	ld	a2,8(a0)
    800052ae:	610c                	ld	a1,0(a0)
    800052b0:	34051573          	csrrw	a0,mscratch,a0
    800052b4:	30200073          	mret
	...

00000000800052ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ba:	1141                	addi	sp,sp,-16
    800052bc:	e422                	sd	s0,8(sp)
    800052be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052c0:	0c0007b7          	lui	a5,0xc000
    800052c4:	4705                	li	a4,1
    800052c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052c8:	c3d8                	sw	a4,4(a5)
}
    800052ca:	6422                	ld	s0,8(sp)
    800052cc:	0141                	addi	sp,sp,16
    800052ce:	8082                	ret

00000000800052d0 <plicinithart>:

void
plicinithart(void)
{
    800052d0:	1141                	addi	sp,sp,-16
    800052d2:	e406                	sd	ra,8(sp)
    800052d4:	e022                	sd	s0,0(sp)
    800052d6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	de0080e7          	jalr	-544(ra) # 800010b8 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052e0:	0085171b          	slliw	a4,a0,0x8
    800052e4:	0c0027b7          	lui	a5,0xc002
    800052e8:	97ba                	add	a5,a5,a4
    800052ea:	40200713          	li	a4,1026
    800052ee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052f2:	00d5151b          	slliw	a0,a0,0xd
    800052f6:	0c2017b7          	lui	a5,0xc201
    800052fa:	97aa                	add	a5,a5,a0
    800052fc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005300:	60a2                	ld	ra,8(sp)
    80005302:	6402                	ld	s0,0(sp)
    80005304:	0141                	addi	sp,sp,16
    80005306:	8082                	ret

0000000080005308 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005308:	1141                	addi	sp,sp,-16
    8000530a:	e406                	sd	ra,8(sp)
    8000530c:	e022                	sd	s0,0(sp)
    8000530e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005310:	ffffc097          	auipc	ra,0xffffc
    80005314:	da8080e7          	jalr	-600(ra) # 800010b8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005318:	00d5151b          	slliw	a0,a0,0xd
    8000531c:	0c2017b7          	lui	a5,0xc201
    80005320:	97aa                	add	a5,a5,a0
  return irq;
}
    80005322:	43c8                	lw	a0,4(a5)
    80005324:	60a2                	ld	ra,8(sp)
    80005326:	6402                	ld	s0,0(sp)
    80005328:	0141                	addi	sp,sp,16
    8000532a:	8082                	ret

000000008000532c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000532c:	1101                	addi	sp,sp,-32
    8000532e:	ec06                	sd	ra,24(sp)
    80005330:	e822                	sd	s0,16(sp)
    80005332:	e426                	sd	s1,8(sp)
    80005334:	1000                	addi	s0,sp,32
    80005336:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005338:	ffffc097          	auipc	ra,0xffffc
    8000533c:	d80080e7          	jalr	-640(ra) # 800010b8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005340:	00d5151b          	slliw	a0,a0,0xd
    80005344:	0c2017b7          	lui	a5,0xc201
    80005348:	97aa                	add	a5,a5,a0
    8000534a:	c3c4                	sw	s1,4(a5)
}
    8000534c:	60e2                	ld	ra,24(sp)
    8000534e:	6442                	ld	s0,16(sp)
    80005350:	64a2                	ld	s1,8(sp)
    80005352:	6105                	addi	sp,sp,32
    80005354:	8082                	ret

0000000080005356 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005356:	1141                	addi	sp,sp,-16
    80005358:	e406                	sd	ra,8(sp)
    8000535a:	e022                	sd	s0,0(sp)
    8000535c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000535e:	479d                	li	a5,7
    80005360:	06a7c863          	blt	a5,a0,800053d0 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005364:	00236717          	auipc	a4,0x236
    80005368:	c9c70713          	addi	a4,a4,-868 # 8023b000 <disk>
    8000536c:	972a                	add	a4,a4,a0
    8000536e:	6789                	lui	a5,0x2
    80005370:	97ba                	add	a5,a5,a4
    80005372:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005376:	e7ad                	bnez	a5,800053e0 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005378:	00451793          	slli	a5,a0,0x4
    8000537c:	00238717          	auipc	a4,0x238
    80005380:	c8470713          	addi	a4,a4,-892 # 8023d000 <disk+0x2000>
    80005384:	6314                	ld	a3,0(a4)
    80005386:	96be                	add	a3,a3,a5
    80005388:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000538c:	6314                	ld	a3,0(a4)
    8000538e:	96be                	add	a3,a3,a5
    80005390:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005394:	6314                	ld	a3,0(a4)
    80005396:	96be                	add	a3,a3,a5
    80005398:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000539c:	6318                	ld	a4,0(a4)
    8000539e:	97ba                	add	a5,a5,a4
    800053a0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053a4:	00236717          	auipc	a4,0x236
    800053a8:	c5c70713          	addi	a4,a4,-932 # 8023b000 <disk>
    800053ac:	972a                	add	a4,a4,a0
    800053ae:	6789                	lui	a5,0x2
    800053b0:	97ba                	add	a5,a5,a4
    800053b2:	4705                	li	a4,1
    800053b4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053b8:	00238517          	auipc	a0,0x238
    800053bc:	c6050513          	addi	a0,a0,-928 # 8023d018 <disk+0x2018>
    800053c0:	ffffc097          	auipc	ra,0xffffc
    800053c4:	574080e7          	jalr	1396(ra) # 80001934 <wakeup>
}
    800053c8:	60a2                	ld	ra,8(sp)
    800053ca:	6402                	ld	s0,0(sp)
    800053cc:	0141                	addi	sp,sp,16
    800053ce:	8082                	ret
    panic("free_desc 1");
    800053d0:	00003517          	auipc	a0,0x3
    800053d4:	3d050513          	addi	a0,a0,976 # 800087a0 <syscalls+0x320>
    800053d8:	00001097          	auipc	ra,0x1
    800053dc:	9c8080e7          	jalr	-1592(ra) # 80005da0 <panic>
    panic("free_desc 2");
    800053e0:	00003517          	auipc	a0,0x3
    800053e4:	3d050513          	addi	a0,a0,976 # 800087b0 <syscalls+0x330>
    800053e8:	00001097          	auipc	ra,0x1
    800053ec:	9b8080e7          	jalr	-1608(ra) # 80005da0 <panic>

00000000800053f0 <virtio_disk_init>:
{
    800053f0:	1101                	addi	sp,sp,-32
    800053f2:	ec06                	sd	ra,24(sp)
    800053f4:	e822                	sd	s0,16(sp)
    800053f6:	e426                	sd	s1,8(sp)
    800053f8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053fa:	00003597          	auipc	a1,0x3
    800053fe:	3c658593          	addi	a1,a1,966 # 800087c0 <syscalls+0x340>
    80005402:	00238517          	auipc	a0,0x238
    80005406:	d2650513          	addi	a0,a0,-730 # 8023d128 <disk+0x2128>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	e3e080e7          	jalr	-450(ra) # 80006248 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005412:	100017b7          	lui	a5,0x10001
    80005416:	4398                	lw	a4,0(a5)
    80005418:	2701                	sext.w	a4,a4
    8000541a:	747277b7          	lui	a5,0x74727
    8000541e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005422:	0ef71063          	bne	a4,a5,80005502 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005426:	100017b7          	lui	a5,0x10001
    8000542a:	43dc                	lw	a5,4(a5)
    8000542c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000542e:	4705                	li	a4,1
    80005430:	0ce79963          	bne	a5,a4,80005502 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005434:	100017b7          	lui	a5,0x10001
    80005438:	479c                	lw	a5,8(a5)
    8000543a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000543c:	4709                	li	a4,2
    8000543e:	0ce79263          	bne	a5,a4,80005502 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005442:	100017b7          	lui	a5,0x10001
    80005446:	47d8                	lw	a4,12(a5)
    80005448:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000544a:	554d47b7          	lui	a5,0x554d4
    8000544e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005452:	0af71863          	bne	a4,a5,80005502 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005456:	100017b7          	lui	a5,0x10001
    8000545a:	4705                	li	a4,1
    8000545c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000545e:	470d                	li	a4,3
    80005460:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005462:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005464:	c7ffe6b7          	lui	a3,0xc7ffe
    80005468:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47db851f>
    8000546c:	8f75                	and	a4,a4,a3
    8000546e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005470:	472d                	li	a4,11
    80005472:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005474:	473d                	li	a4,15
    80005476:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005478:	6705                	lui	a4,0x1
    8000547a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000547c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005480:	5bdc                	lw	a5,52(a5)
    80005482:	2781                	sext.w	a5,a5
  if(max == 0)
    80005484:	c7d9                	beqz	a5,80005512 <virtio_disk_init+0x122>
  if(max < NUM)
    80005486:	471d                	li	a4,7
    80005488:	08f77d63          	bgeu	a4,a5,80005522 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000548c:	100014b7          	lui	s1,0x10001
    80005490:	47a1                	li	a5,8
    80005492:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005494:	6609                	lui	a2,0x2
    80005496:	4581                	li	a1,0
    80005498:	00236517          	auipc	a0,0x236
    8000549c:	b6850513          	addi	a0,a0,-1176 # 8023b000 <disk>
    800054a0:	ffffb097          	auipc	ra,0xffffb
    800054a4:	dfe080e7          	jalr	-514(ra) # 8000029e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054a8:	00236717          	auipc	a4,0x236
    800054ac:	b5870713          	addi	a4,a4,-1192 # 8023b000 <disk>
    800054b0:	00c75793          	srli	a5,a4,0xc
    800054b4:	2781                	sext.w	a5,a5
    800054b6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054b8:	00238797          	auipc	a5,0x238
    800054bc:	b4878793          	addi	a5,a5,-1208 # 8023d000 <disk+0x2000>
    800054c0:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054c2:	00236717          	auipc	a4,0x236
    800054c6:	bbe70713          	addi	a4,a4,-1090 # 8023b080 <disk+0x80>
    800054ca:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054cc:	00237717          	auipc	a4,0x237
    800054d0:	b3470713          	addi	a4,a4,-1228 # 8023c000 <disk+0x1000>
    800054d4:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054d6:	4705                	li	a4,1
    800054d8:	00e78c23          	sb	a4,24(a5)
    800054dc:	00e78ca3          	sb	a4,25(a5)
    800054e0:	00e78d23          	sb	a4,26(a5)
    800054e4:	00e78da3          	sb	a4,27(a5)
    800054e8:	00e78e23          	sb	a4,28(a5)
    800054ec:	00e78ea3          	sb	a4,29(a5)
    800054f0:	00e78f23          	sb	a4,30(a5)
    800054f4:	00e78fa3          	sb	a4,31(a5)
}
    800054f8:	60e2                	ld	ra,24(sp)
    800054fa:	6442                	ld	s0,16(sp)
    800054fc:	64a2                	ld	s1,8(sp)
    800054fe:	6105                	addi	sp,sp,32
    80005500:	8082                	ret
    panic("could not find virtio disk");
    80005502:	00003517          	auipc	a0,0x3
    80005506:	2ce50513          	addi	a0,a0,718 # 800087d0 <syscalls+0x350>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	896080e7          	jalr	-1898(ra) # 80005da0 <panic>
    panic("virtio disk has no queue 0");
    80005512:	00003517          	auipc	a0,0x3
    80005516:	2de50513          	addi	a0,a0,734 # 800087f0 <syscalls+0x370>
    8000551a:	00001097          	auipc	ra,0x1
    8000551e:	886080e7          	jalr	-1914(ra) # 80005da0 <panic>
    panic("virtio disk max queue too short");
    80005522:	00003517          	auipc	a0,0x3
    80005526:	2ee50513          	addi	a0,a0,750 # 80008810 <syscalls+0x390>
    8000552a:	00001097          	auipc	ra,0x1
    8000552e:	876080e7          	jalr	-1930(ra) # 80005da0 <panic>

0000000080005532 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005532:	7119                	addi	sp,sp,-128
    80005534:	fc86                	sd	ra,120(sp)
    80005536:	f8a2                	sd	s0,112(sp)
    80005538:	f4a6                	sd	s1,104(sp)
    8000553a:	f0ca                	sd	s2,96(sp)
    8000553c:	ecce                	sd	s3,88(sp)
    8000553e:	e8d2                	sd	s4,80(sp)
    80005540:	e4d6                	sd	s5,72(sp)
    80005542:	e0da                	sd	s6,64(sp)
    80005544:	fc5e                	sd	s7,56(sp)
    80005546:	f862                	sd	s8,48(sp)
    80005548:	f466                	sd	s9,40(sp)
    8000554a:	f06a                	sd	s10,32(sp)
    8000554c:	ec6e                	sd	s11,24(sp)
    8000554e:	0100                	addi	s0,sp,128
    80005550:	8aaa                	mv	s5,a0
    80005552:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005554:	00c52c83          	lw	s9,12(a0)
    80005558:	001c9c9b          	slliw	s9,s9,0x1
    8000555c:	1c82                	slli	s9,s9,0x20
    8000555e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005562:	00238517          	auipc	a0,0x238
    80005566:	bc650513          	addi	a0,a0,-1082 # 8023d128 <disk+0x2128>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	d6e080e7          	jalr	-658(ra) # 800062d8 <acquire>
  for(int i = 0; i < 3; i++){
    80005572:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005574:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005576:	00236c17          	auipc	s8,0x236
    8000557a:	a8ac0c13          	addi	s8,s8,-1398 # 8023b000 <disk>
    8000557e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005580:	4b0d                	li	s6,3
    80005582:	a0ad                	j	800055ec <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005584:	00fc0733          	add	a4,s8,a5
    80005588:	975e                	add	a4,a4,s7
    8000558a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000558e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005590:	0207c563          	bltz	a5,800055ba <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005594:	2905                	addiw	s2,s2,1
    80005596:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005598:	19690c63          	beq	s2,s6,80005730 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000559c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000559e:	00238717          	auipc	a4,0x238
    800055a2:	a7a70713          	addi	a4,a4,-1414 # 8023d018 <disk+0x2018>
    800055a6:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055a8:	00074683          	lbu	a3,0(a4)
    800055ac:	fee1                	bnez	a3,80005584 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055ae:	2785                	addiw	a5,a5,1
    800055b0:	0705                	addi	a4,a4,1
    800055b2:	fe979be3          	bne	a5,s1,800055a8 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055b6:	57fd                	li	a5,-1
    800055b8:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055ba:	01205d63          	blez	s2,800055d4 <virtio_disk_rw+0xa2>
    800055be:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055c0:	000a2503          	lw	a0,0(s4)
    800055c4:	00000097          	auipc	ra,0x0
    800055c8:	d92080e7          	jalr	-622(ra) # 80005356 <free_desc>
      for(int j = 0; j < i; j++)
    800055cc:	2d85                	addiw	s11,s11,1
    800055ce:	0a11                	addi	s4,s4,4
    800055d0:	ff2d98e3          	bne	s11,s2,800055c0 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055d4:	00238597          	auipc	a1,0x238
    800055d8:	b5458593          	addi	a1,a1,-1196 # 8023d128 <disk+0x2128>
    800055dc:	00238517          	auipc	a0,0x238
    800055e0:	a3c50513          	addi	a0,a0,-1476 # 8023d018 <disk+0x2018>
    800055e4:	ffffc097          	auipc	ra,0xffffc
    800055e8:	1c4080e7          	jalr	452(ra) # 800017a8 <sleep>
  for(int i = 0; i < 3; i++){
    800055ec:	f8040a13          	addi	s4,s0,-128
{
    800055f0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800055f2:	894e                	mv	s2,s3
    800055f4:	b765                	j	8000559c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055f6:	00238697          	auipc	a3,0x238
    800055fa:	a0a6b683          	ld	a3,-1526(a3) # 8023d000 <disk+0x2000>
    800055fe:	96ba                	add	a3,a3,a4
    80005600:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005604:	00236817          	auipc	a6,0x236
    80005608:	9fc80813          	addi	a6,a6,-1540 # 8023b000 <disk>
    8000560c:	00238697          	auipc	a3,0x238
    80005610:	9f468693          	addi	a3,a3,-1548 # 8023d000 <disk+0x2000>
    80005614:	6290                	ld	a2,0(a3)
    80005616:	963a                	add	a2,a2,a4
    80005618:	00c65583          	lhu	a1,12(a2)
    8000561c:	0015e593          	ori	a1,a1,1
    80005620:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005624:	f8842603          	lw	a2,-120(s0)
    80005628:	628c                	ld	a1,0(a3)
    8000562a:	972e                	add	a4,a4,a1
    8000562c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005630:	20050593          	addi	a1,a0,512
    80005634:	0592                	slli	a1,a1,0x4
    80005636:	95c2                	add	a1,a1,a6
    80005638:	577d                	li	a4,-1
    8000563a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000563e:	00461713          	slli	a4,a2,0x4
    80005642:	6290                	ld	a2,0(a3)
    80005644:	963a                	add	a2,a2,a4
    80005646:	03078793          	addi	a5,a5,48
    8000564a:	97c2                	add	a5,a5,a6
    8000564c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000564e:	629c                	ld	a5,0(a3)
    80005650:	97ba                	add	a5,a5,a4
    80005652:	4605                	li	a2,1
    80005654:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005656:	629c                	ld	a5,0(a3)
    80005658:	97ba                	add	a5,a5,a4
    8000565a:	4809                	li	a6,2
    8000565c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005660:	629c                	ld	a5,0(a3)
    80005662:	97ba                	add	a5,a5,a4
    80005664:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005668:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000566c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005670:	6698                	ld	a4,8(a3)
    80005672:	00275783          	lhu	a5,2(a4)
    80005676:	8b9d                	andi	a5,a5,7
    80005678:	0786                	slli	a5,a5,0x1
    8000567a:	973e                	add	a4,a4,a5
    8000567c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005680:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005684:	6698                	ld	a4,8(a3)
    80005686:	00275783          	lhu	a5,2(a4)
    8000568a:	2785                	addiw	a5,a5,1
    8000568c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005690:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005694:	100017b7          	lui	a5,0x10001
    80005698:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000569c:	004aa783          	lw	a5,4(s5)
    800056a0:	02c79163          	bne	a5,a2,800056c2 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800056a4:	00238917          	auipc	s2,0x238
    800056a8:	a8490913          	addi	s2,s2,-1404 # 8023d128 <disk+0x2128>
  while(b->disk == 1) {
    800056ac:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056ae:	85ca                	mv	a1,s2
    800056b0:	8556                	mv	a0,s5
    800056b2:	ffffc097          	auipc	ra,0xffffc
    800056b6:	0f6080e7          	jalr	246(ra) # 800017a8 <sleep>
  while(b->disk == 1) {
    800056ba:	004aa783          	lw	a5,4(s5)
    800056be:	fe9788e3          	beq	a5,s1,800056ae <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800056c2:	f8042903          	lw	s2,-128(s0)
    800056c6:	20090713          	addi	a4,s2,512
    800056ca:	0712                	slli	a4,a4,0x4
    800056cc:	00236797          	auipc	a5,0x236
    800056d0:	93478793          	addi	a5,a5,-1740 # 8023b000 <disk>
    800056d4:	97ba                	add	a5,a5,a4
    800056d6:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056da:	00238997          	auipc	s3,0x238
    800056de:	92698993          	addi	s3,s3,-1754 # 8023d000 <disk+0x2000>
    800056e2:	00491713          	slli	a4,s2,0x4
    800056e6:	0009b783          	ld	a5,0(s3)
    800056ea:	97ba                	add	a5,a5,a4
    800056ec:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056f0:	854a                	mv	a0,s2
    800056f2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056f6:	00000097          	auipc	ra,0x0
    800056fa:	c60080e7          	jalr	-928(ra) # 80005356 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056fe:	8885                	andi	s1,s1,1
    80005700:	f0ed                	bnez	s1,800056e2 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005702:	00238517          	auipc	a0,0x238
    80005706:	a2650513          	addi	a0,a0,-1498 # 8023d128 <disk+0x2128>
    8000570a:	00001097          	auipc	ra,0x1
    8000570e:	c82080e7          	jalr	-894(ra) # 8000638c <release>
}
    80005712:	70e6                	ld	ra,120(sp)
    80005714:	7446                	ld	s0,112(sp)
    80005716:	74a6                	ld	s1,104(sp)
    80005718:	7906                	ld	s2,96(sp)
    8000571a:	69e6                	ld	s3,88(sp)
    8000571c:	6a46                	ld	s4,80(sp)
    8000571e:	6aa6                	ld	s5,72(sp)
    80005720:	6b06                	ld	s6,64(sp)
    80005722:	7be2                	ld	s7,56(sp)
    80005724:	7c42                	ld	s8,48(sp)
    80005726:	7ca2                	ld	s9,40(sp)
    80005728:	7d02                	ld	s10,32(sp)
    8000572a:	6de2                	ld	s11,24(sp)
    8000572c:	6109                	addi	sp,sp,128
    8000572e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005730:	f8042503          	lw	a0,-128(s0)
    80005734:	20050793          	addi	a5,a0,512
    80005738:	0792                	slli	a5,a5,0x4
  if(write)
    8000573a:	00236817          	auipc	a6,0x236
    8000573e:	8c680813          	addi	a6,a6,-1850 # 8023b000 <disk>
    80005742:	00f80733          	add	a4,a6,a5
    80005746:	01a036b3          	snez	a3,s10
    8000574a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000574e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005752:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005756:	7679                	lui	a2,0xffffe
    80005758:	963e                	add	a2,a2,a5
    8000575a:	00238697          	auipc	a3,0x238
    8000575e:	8a668693          	addi	a3,a3,-1882 # 8023d000 <disk+0x2000>
    80005762:	6298                	ld	a4,0(a3)
    80005764:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005766:	0a878593          	addi	a1,a5,168
    8000576a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000576c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000576e:	6298                	ld	a4,0(a3)
    80005770:	9732                	add	a4,a4,a2
    80005772:	45c1                	li	a1,16
    80005774:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005776:	6298                	ld	a4,0(a3)
    80005778:	9732                	add	a4,a4,a2
    8000577a:	4585                	li	a1,1
    8000577c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005780:	f8442703          	lw	a4,-124(s0)
    80005784:	628c                	ld	a1,0(a3)
    80005786:	962e                	add	a2,a2,a1
    80005788:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7fdb7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000578c:	0712                	slli	a4,a4,0x4
    8000578e:	6290                	ld	a2,0(a3)
    80005790:	963a                	add	a2,a2,a4
    80005792:	058a8593          	addi	a1,s5,88
    80005796:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005798:	6294                	ld	a3,0(a3)
    8000579a:	96ba                	add	a3,a3,a4
    8000579c:	40000613          	li	a2,1024
    800057a0:	c690                	sw	a2,8(a3)
  if(write)
    800057a2:	e40d1ae3          	bnez	s10,800055f6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057a6:	00238697          	auipc	a3,0x238
    800057aa:	85a6b683          	ld	a3,-1958(a3) # 8023d000 <disk+0x2000>
    800057ae:	96ba                	add	a3,a3,a4
    800057b0:	4609                	li	a2,2
    800057b2:	00c69623          	sh	a2,12(a3)
    800057b6:	b5b9                	j	80005604 <virtio_disk_rw+0xd2>

00000000800057b8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057b8:	1101                	addi	sp,sp,-32
    800057ba:	ec06                	sd	ra,24(sp)
    800057bc:	e822                	sd	s0,16(sp)
    800057be:	e426                	sd	s1,8(sp)
    800057c0:	e04a                	sd	s2,0(sp)
    800057c2:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057c4:	00238517          	auipc	a0,0x238
    800057c8:	96450513          	addi	a0,a0,-1692 # 8023d128 <disk+0x2128>
    800057cc:	00001097          	auipc	ra,0x1
    800057d0:	b0c080e7          	jalr	-1268(ra) # 800062d8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057d4:	10001737          	lui	a4,0x10001
    800057d8:	533c                	lw	a5,96(a4)
    800057da:	8b8d                	andi	a5,a5,3
    800057dc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057de:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057e2:	00238797          	auipc	a5,0x238
    800057e6:	81e78793          	addi	a5,a5,-2018 # 8023d000 <disk+0x2000>
    800057ea:	6b94                	ld	a3,16(a5)
    800057ec:	0207d703          	lhu	a4,32(a5)
    800057f0:	0026d783          	lhu	a5,2(a3)
    800057f4:	06f70163          	beq	a4,a5,80005856 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057f8:	00236917          	auipc	s2,0x236
    800057fc:	80890913          	addi	s2,s2,-2040 # 8023b000 <disk>
    80005800:	00238497          	auipc	s1,0x238
    80005804:	80048493          	addi	s1,s1,-2048 # 8023d000 <disk+0x2000>
    __sync_synchronize();
    80005808:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000580c:	6898                	ld	a4,16(s1)
    8000580e:	0204d783          	lhu	a5,32(s1)
    80005812:	8b9d                	andi	a5,a5,7
    80005814:	078e                	slli	a5,a5,0x3
    80005816:	97ba                	add	a5,a5,a4
    80005818:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000581a:	20078713          	addi	a4,a5,512
    8000581e:	0712                	slli	a4,a4,0x4
    80005820:	974a                	add	a4,a4,s2
    80005822:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005826:	e731                	bnez	a4,80005872 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005828:	20078793          	addi	a5,a5,512
    8000582c:	0792                	slli	a5,a5,0x4
    8000582e:	97ca                	add	a5,a5,s2
    80005830:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005832:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005836:	ffffc097          	auipc	ra,0xffffc
    8000583a:	0fe080e7          	jalr	254(ra) # 80001934 <wakeup>

    disk.used_idx += 1;
    8000583e:	0204d783          	lhu	a5,32(s1)
    80005842:	2785                	addiw	a5,a5,1
    80005844:	17c2                	slli	a5,a5,0x30
    80005846:	93c1                	srli	a5,a5,0x30
    80005848:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000584c:	6898                	ld	a4,16(s1)
    8000584e:	00275703          	lhu	a4,2(a4)
    80005852:	faf71be3          	bne	a4,a5,80005808 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005856:	00238517          	auipc	a0,0x238
    8000585a:	8d250513          	addi	a0,a0,-1838 # 8023d128 <disk+0x2128>
    8000585e:	00001097          	auipc	ra,0x1
    80005862:	b2e080e7          	jalr	-1234(ra) # 8000638c <release>
}
    80005866:	60e2                	ld	ra,24(sp)
    80005868:	6442                	ld	s0,16(sp)
    8000586a:	64a2                	ld	s1,8(sp)
    8000586c:	6902                	ld	s2,0(sp)
    8000586e:	6105                	addi	sp,sp,32
    80005870:	8082                	ret
      panic("virtio_disk_intr status");
    80005872:	00003517          	auipc	a0,0x3
    80005876:	fbe50513          	addi	a0,a0,-66 # 80008830 <syscalls+0x3b0>
    8000587a:	00000097          	auipc	ra,0x0
    8000587e:	526080e7          	jalr	1318(ra) # 80005da0 <panic>

0000000080005882 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005882:	1141                	addi	sp,sp,-16
    80005884:	e422                	sd	s0,8(sp)
    80005886:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005888:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000588c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005890:	0037979b          	slliw	a5,a5,0x3
    80005894:	02004737          	lui	a4,0x2004
    80005898:	97ba                	add	a5,a5,a4
    8000589a:	0200c737          	lui	a4,0x200c
    8000589e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058a2:	000f4637          	lui	a2,0xf4
    800058a6:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058aa:	9732                	add	a4,a4,a2
    800058ac:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058ae:	00259693          	slli	a3,a1,0x2
    800058b2:	96ae                	add	a3,a3,a1
    800058b4:	068e                	slli	a3,a3,0x3
    800058b6:	00238717          	auipc	a4,0x238
    800058ba:	74a70713          	addi	a4,a4,1866 # 8023e000 <timer_scratch>
    800058be:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058c0:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058c2:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058c4:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058c8:	00000797          	auipc	a5,0x0
    800058cc:	9c878793          	addi	a5,a5,-1592 # 80005290 <timervec>
    800058d0:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058d4:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058d8:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058dc:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058e0:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058e4:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058e8:	30479073          	csrw	mie,a5
}
    800058ec:	6422                	ld	s0,8(sp)
    800058ee:	0141                	addi	sp,sp,16
    800058f0:	8082                	ret

00000000800058f2 <start>:
{
    800058f2:	1141                	addi	sp,sp,-16
    800058f4:	e406                	sd	ra,8(sp)
    800058f6:	e022                	sd	s0,0(sp)
    800058f8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058fa:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058fe:	7779                	lui	a4,0xffffe
    80005900:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb85bf>
    80005904:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005906:	6705                	lui	a4,0x1
    80005908:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000590c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000590e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005912:	ffffb797          	auipc	a5,0xffffb
    80005916:	b3278793          	addi	a5,a5,-1230 # 80000444 <main>
    8000591a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000591e:	4781                	li	a5,0
    80005920:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005924:	67c1                	lui	a5,0x10
    80005926:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005928:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000592c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005930:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005934:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005938:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000593c:	57fd                	li	a5,-1
    8000593e:	83a9                	srli	a5,a5,0xa
    80005940:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005944:	47bd                	li	a5,15
    80005946:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000594a:	00000097          	auipc	ra,0x0
    8000594e:	f38080e7          	jalr	-200(ra) # 80005882 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005952:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005956:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005958:	823e                	mv	tp,a5
  asm volatile("mret");
    8000595a:	30200073          	mret
}
    8000595e:	60a2                	ld	ra,8(sp)
    80005960:	6402                	ld	s0,0(sp)
    80005962:	0141                	addi	sp,sp,16
    80005964:	8082                	ret

0000000080005966 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005966:	715d                	addi	sp,sp,-80
    80005968:	e486                	sd	ra,72(sp)
    8000596a:	e0a2                	sd	s0,64(sp)
    8000596c:	fc26                	sd	s1,56(sp)
    8000596e:	f84a                	sd	s2,48(sp)
    80005970:	f44e                	sd	s3,40(sp)
    80005972:	f052                	sd	s4,32(sp)
    80005974:	ec56                	sd	s5,24(sp)
    80005976:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005978:	04c05763          	blez	a2,800059c6 <consolewrite+0x60>
    8000597c:	8a2a                	mv	s4,a0
    8000597e:	84ae                	mv	s1,a1
    80005980:	89b2                	mv	s3,a2
    80005982:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005984:	5afd                	li	s5,-1
    80005986:	4685                	li	a3,1
    80005988:	8626                	mv	a2,s1
    8000598a:	85d2                	mv	a1,s4
    8000598c:	fbf40513          	addi	a0,s0,-65
    80005990:	ffffc097          	auipc	ra,0xffffc
    80005994:	212080e7          	jalr	530(ra) # 80001ba2 <either_copyin>
    80005998:	01550d63          	beq	a0,s5,800059b2 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000599c:	fbf44503          	lbu	a0,-65(s0)
    800059a0:	00000097          	auipc	ra,0x0
    800059a4:	77e080e7          	jalr	1918(ra) # 8000611e <uartputc>
  for(i = 0; i < n; i++){
    800059a8:	2905                	addiw	s2,s2,1
    800059aa:	0485                	addi	s1,s1,1
    800059ac:	fd299de3          	bne	s3,s2,80005986 <consolewrite+0x20>
    800059b0:	894e                	mv	s2,s3
  }

  return i;
}
    800059b2:	854a                	mv	a0,s2
    800059b4:	60a6                	ld	ra,72(sp)
    800059b6:	6406                	ld	s0,64(sp)
    800059b8:	74e2                	ld	s1,56(sp)
    800059ba:	7942                	ld	s2,48(sp)
    800059bc:	79a2                	ld	s3,40(sp)
    800059be:	7a02                	ld	s4,32(sp)
    800059c0:	6ae2                	ld	s5,24(sp)
    800059c2:	6161                	addi	sp,sp,80
    800059c4:	8082                	ret
  for(i = 0; i < n; i++){
    800059c6:	4901                	li	s2,0
    800059c8:	b7ed                	j	800059b2 <consolewrite+0x4c>

00000000800059ca <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ca:	7159                	addi	sp,sp,-112
    800059cc:	f486                	sd	ra,104(sp)
    800059ce:	f0a2                	sd	s0,96(sp)
    800059d0:	eca6                	sd	s1,88(sp)
    800059d2:	e8ca                	sd	s2,80(sp)
    800059d4:	e4ce                	sd	s3,72(sp)
    800059d6:	e0d2                	sd	s4,64(sp)
    800059d8:	fc56                	sd	s5,56(sp)
    800059da:	f85a                	sd	s6,48(sp)
    800059dc:	f45e                	sd	s7,40(sp)
    800059de:	f062                	sd	s8,32(sp)
    800059e0:	ec66                	sd	s9,24(sp)
    800059e2:	e86a                	sd	s10,16(sp)
    800059e4:	1880                	addi	s0,sp,112
    800059e6:	8aaa                	mv	s5,a0
    800059e8:	8a2e                	mv	s4,a1
    800059ea:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059ec:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059f0:	00240517          	auipc	a0,0x240
    800059f4:	75050513          	addi	a0,a0,1872 # 80246140 <cons>
    800059f8:	00001097          	auipc	ra,0x1
    800059fc:	8e0080e7          	jalr	-1824(ra) # 800062d8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a00:	00240497          	auipc	s1,0x240
    80005a04:	74048493          	addi	s1,s1,1856 # 80246140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a08:	00240917          	auipc	s2,0x240
    80005a0c:	7d090913          	addi	s2,s2,2000 # 802461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a10:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a12:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a14:	4ca9                	li	s9,10
  while(n > 0){
    80005a16:	07305863          	blez	s3,80005a86 <consoleread+0xbc>
    while(cons.r == cons.w){
    80005a1a:	0984a783          	lw	a5,152(s1)
    80005a1e:	09c4a703          	lw	a4,156(s1)
    80005a22:	02f71463          	bne	a4,a5,80005a4a <consoleread+0x80>
      if(myproc()->killed){
    80005a26:	ffffb097          	auipc	ra,0xffffb
    80005a2a:	6be080e7          	jalr	1726(ra) # 800010e4 <myproc>
    80005a2e:	551c                	lw	a5,40(a0)
    80005a30:	e7b5                	bnez	a5,80005a9c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005a32:	85a6                	mv	a1,s1
    80005a34:	854a                	mv	a0,s2
    80005a36:	ffffc097          	auipc	ra,0xffffc
    80005a3a:	d72080e7          	jalr	-654(ra) # 800017a8 <sleep>
    while(cons.r == cons.w){
    80005a3e:	0984a783          	lw	a5,152(s1)
    80005a42:	09c4a703          	lw	a4,156(s1)
    80005a46:	fef700e3          	beq	a4,a5,80005a26 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a4a:	0017871b          	addiw	a4,a5,1
    80005a4e:	08e4ac23          	sw	a4,152(s1)
    80005a52:	07f7f713          	andi	a4,a5,127
    80005a56:	9726                	add	a4,a4,s1
    80005a58:	01874703          	lbu	a4,24(a4)
    80005a5c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a60:	077d0563          	beq	s10,s7,80005aca <consoleread+0x100>
    cbuf = c;
    80005a64:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a68:	4685                	li	a3,1
    80005a6a:	f9f40613          	addi	a2,s0,-97
    80005a6e:	85d2                	mv	a1,s4
    80005a70:	8556                	mv	a0,s5
    80005a72:	ffffc097          	auipc	ra,0xffffc
    80005a76:	0da080e7          	jalr	218(ra) # 80001b4c <either_copyout>
    80005a7a:	01850663          	beq	a0,s8,80005a86 <consoleread+0xbc>
    dst++;
    80005a7e:	0a05                	addi	s4,s4,1
    --n;
    80005a80:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005a82:	f99d1ae3          	bne	s10,s9,80005a16 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a86:	00240517          	auipc	a0,0x240
    80005a8a:	6ba50513          	addi	a0,a0,1722 # 80246140 <cons>
    80005a8e:	00001097          	auipc	ra,0x1
    80005a92:	8fe080e7          	jalr	-1794(ra) # 8000638c <release>

  return target - n;
    80005a96:	413b053b          	subw	a0,s6,s3
    80005a9a:	a811                	j	80005aae <consoleread+0xe4>
        release(&cons.lock);
    80005a9c:	00240517          	auipc	a0,0x240
    80005aa0:	6a450513          	addi	a0,a0,1700 # 80246140 <cons>
    80005aa4:	00001097          	auipc	ra,0x1
    80005aa8:	8e8080e7          	jalr	-1816(ra) # 8000638c <release>
        return -1;
    80005aac:	557d                	li	a0,-1
}
    80005aae:	70a6                	ld	ra,104(sp)
    80005ab0:	7406                	ld	s0,96(sp)
    80005ab2:	64e6                	ld	s1,88(sp)
    80005ab4:	6946                	ld	s2,80(sp)
    80005ab6:	69a6                	ld	s3,72(sp)
    80005ab8:	6a06                	ld	s4,64(sp)
    80005aba:	7ae2                	ld	s5,56(sp)
    80005abc:	7b42                	ld	s6,48(sp)
    80005abe:	7ba2                	ld	s7,40(sp)
    80005ac0:	7c02                	ld	s8,32(sp)
    80005ac2:	6ce2                	ld	s9,24(sp)
    80005ac4:	6d42                	ld	s10,16(sp)
    80005ac6:	6165                	addi	sp,sp,112
    80005ac8:	8082                	ret
      if(n < target){
    80005aca:	0009871b          	sext.w	a4,s3
    80005ace:	fb677ce3          	bgeu	a4,s6,80005a86 <consoleread+0xbc>
        cons.r--;
    80005ad2:	00240717          	auipc	a4,0x240
    80005ad6:	70f72323          	sw	a5,1798(a4) # 802461d8 <cons+0x98>
    80005ada:	b775                	j	80005a86 <consoleread+0xbc>

0000000080005adc <consputc>:
{
    80005adc:	1141                	addi	sp,sp,-16
    80005ade:	e406                	sd	ra,8(sp)
    80005ae0:	e022                	sd	s0,0(sp)
    80005ae2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ae4:	10000793          	li	a5,256
    80005ae8:	00f50a63          	beq	a0,a5,80005afc <consputc+0x20>
    uartputc_sync(c);
    80005aec:	00000097          	auipc	ra,0x0
    80005af0:	560080e7          	jalr	1376(ra) # 8000604c <uartputc_sync>
}
    80005af4:	60a2                	ld	ra,8(sp)
    80005af6:	6402                	ld	s0,0(sp)
    80005af8:	0141                	addi	sp,sp,16
    80005afa:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005afc:	4521                	li	a0,8
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	54e080e7          	jalr	1358(ra) # 8000604c <uartputc_sync>
    80005b06:	02000513          	li	a0,32
    80005b0a:	00000097          	auipc	ra,0x0
    80005b0e:	542080e7          	jalr	1346(ra) # 8000604c <uartputc_sync>
    80005b12:	4521                	li	a0,8
    80005b14:	00000097          	auipc	ra,0x0
    80005b18:	538080e7          	jalr	1336(ra) # 8000604c <uartputc_sync>
    80005b1c:	bfe1                	j	80005af4 <consputc+0x18>

0000000080005b1e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b1e:	1101                	addi	sp,sp,-32
    80005b20:	ec06                	sd	ra,24(sp)
    80005b22:	e822                	sd	s0,16(sp)
    80005b24:	e426                	sd	s1,8(sp)
    80005b26:	e04a                	sd	s2,0(sp)
    80005b28:	1000                	addi	s0,sp,32
    80005b2a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b2c:	00240517          	auipc	a0,0x240
    80005b30:	61450513          	addi	a0,a0,1556 # 80246140 <cons>
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	7a4080e7          	jalr	1956(ra) # 800062d8 <acquire>

  switch(c){
    80005b3c:	47d5                	li	a5,21
    80005b3e:	0af48663          	beq	s1,a5,80005bea <consoleintr+0xcc>
    80005b42:	0297ca63          	blt	a5,s1,80005b76 <consoleintr+0x58>
    80005b46:	47a1                	li	a5,8
    80005b48:	0ef48763          	beq	s1,a5,80005c36 <consoleintr+0x118>
    80005b4c:	47c1                	li	a5,16
    80005b4e:	10f49a63          	bne	s1,a5,80005c62 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b52:	ffffc097          	auipc	ra,0xffffc
    80005b56:	0a6080e7          	jalr	166(ra) # 80001bf8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b5a:	00240517          	auipc	a0,0x240
    80005b5e:	5e650513          	addi	a0,a0,1510 # 80246140 <cons>
    80005b62:	00001097          	auipc	ra,0x1
    80005b66:	82a080e7          	jalr	-2006(ra) # 8000638c <release>
}
    80005b6a:	60e2                	ld	ra,24(sp)
    80005b6c:	6442                	ld	s0,16(sp)
    80005b6e:	64a2                	ld	s1,8(sp)
    80005b70:	6902                	ld	s2,0(sp)
    80005b72:	6105                	addi	sp,sp,32
    80005b74:	8082                	ret
  switch(c){
    80005b76:	07f00793          	li	a5,127
    80005b7a:	0af48e63          	beq	s1,a5,80005c36 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b7e:	00240717          	auipc	a4,0x240
    80005b82:	5c270713          	addi	a4,a4,1474 # 80246140 <cons>
    80005b86:	0a072783          	lw	a5,160(a4)
    80005b8a:	09872703          	lw	a4,152(a4)
    80005b8e:	9f99                	subw	a5,a5,a4
    80005b90:	07f00713          	li	a4,127
    80005b94:	fcf763e3          	bltu	a4,a5,80005b5a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b98:	47b5                	li	a5,13
    80005b9a:	0cf48763          	beq	s1,a5,80005c68 <consoleintr+0x14a>
      consputc(c);
    80005b9e:	8526                	mv	a0,s1
    80005ba0:	00000097          	auipc	ra,0x0
    80005ba4:	f3c080e7          	jalr	-196(ra) # 80005adc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ba8:	00240797          	auipc	a5,0x240
    80005bac:	59878793          	addi	a5,a5,1432 # 80246140 <cons>
    80005bb0:	0a07a703          	lw	a4,160(a5)
    80005bb4:	0017069b          	addiw	a3,a4,1
    80005bb8:	0006861b          	sext.w	a2,a3
    80005bbc:	0ad7a023          	sw	a3,160(a5)
    80005bc0:	07f77713          	andi	a4,a4,127
    80005bc4:	97ba                	add	a5,a5,a4
    80005bc6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bca:	47a9                	li	a5,10
    80005bcc:	0cf48563          	beq	s1,a5,80005c96 <consoleintr+0x178>
    80005bd0:	4791                	li	a5,4
    80005bd2:	0cf48263          	beq	s1,a5,80005c96 <consoleintr+0x178>
    80005bd6:	00240797          	auipc	a5,0x240
    80005bda:	6027a783          	lw	a5,1538(a5) # 802461d8 <cons+0x98>
    80005bde:	0807879b          	addiw	a5,a5,128
    80005be2:	f6f61ce3          	bne	a2,a5,80005b5a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005be6:	863e                	mv	a2,a5
    80005be8:	a07d                	j	80005c96 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bea:	00240717          	auipc	a4,0x240
    80005bee:	55670713          	addi	a4,a4,1366 # 80246140 <cons>
    80005bf2:	0a072783          	lw	a5,160(a4)
    80005bf6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bfa:	00240497          	auipc	s1,0x240
    80005bfe:	54648493          	addi	s1,s1,1350 # 80246140 <cons>
    while(cons.e != cons.w &&
    80005c02:	4929                	li	s2,10
    80005c04:	f4f70be3          	beq	a4,a5,80005b5a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c08:	37fd                	addiw	a5,a5,-1
    80005c0a:	07f7f713          	andi	a4,a5,127
    80005c0e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c10:	01874703          	lbu	a4,24(a4)
    80005c14:	f52703e3          	beq	a4,s2,80005b5a <consoleintr+0x3c>
      cons.e--;
    80005c18:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c1c:	10000513          	li	a0,256
    80005c20:	00000097          	auipc	ra,0x0
    80005c24:	ebc080e7          	jalr	-324(ra) # 80005adc <consputc>
    while(cons.e != cons.w &&
    80005c28:	0a04a783          	lw	a5,160(s1)
    80005c2c:	09c4a703          	lw	a4,156(s1)
    80005c30:	fcf71ce3          	bne	a4,a5,80005c08 <consoleintr+0xea>
    80005c34:	b71d                	j	80005b5a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c36:	00240717          	auipc	a4,0x240
    80005c3a:	50a70713          	addi	a4,a4,1290 # 80246140 <cons>
    80005c3e:	0a072783          	lw	a5,160(a4)
    80005c42:	09c72703          	lw	a4,156(a4)
    80005c46:	f0f70ae3          	beq	a4,a5,80005b5a <consoleintr+0x3c>
      cons.e--;
    80005c4a:	37fd                	addiw	a5,a5,-1
    80005c4c:	00240717          	auipc	a4,0x240
    80005c50:	58f72a23          	sw	a5,1428(a4) # 802461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c54:	10000513          	li	a0,256
    80005c58:	00000097          	auipc	ra,0x0
    80005c5c:	e84080e7          	jalr	-380(ra) # 80005adc <consputc>
    80005c60:	bded                	j	80005b5a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c62:	ee048ce3          	beqz	s1,80005b5a <consoleintr+0x3c>
    80005c66:	bf21                	j	80005b7e <consoleintr+0x60>
      consputc(c);
    80005c68:	4529                	li	a0,10
    80005c6a:	00000097          	auipc	ra,0x0
    80005c6e:	e72080e7          	jalr	-398(ra) # 80005adc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c72:	00240797          	auipc	a5,0x240
    80005c76:	4ce78793          	addi	a5,a5,1230 # 80246140 <cons>
    80005c7a:	0a07a703          	lw	a4,160(a5)
    80005c7e:	0017069b          	addiw	a3,a4,1
    80005c82:	0006861b          	sext.w	a2,a3
    80005c86:	0ad7a023          	sw	a3,160(a5)
    80005c8a:	07f77713          	andi	a4,a4,127
    80005c8e:	97ba                	add	a5,a5,a4
    80005c90:	4729                	li	a4,10
    80005c92:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c96:	00240797          	auipc	a5,0x240
    80005c9a:	54c7a323          	sw	a2,1350(a5) # 802461dc <cons+0x9c>
        wakeup(&cons.r);
    80005c9e:	00240517          	auipc	a0,0x240
    80005ca2:	53a50513          	addi	a0,a0,1338 # 802461d8 <cons+0x98>
    80005ca6:	ffffc097          	auipc	ra,0xffffc
    80005caa:	c8e080e7          	jalr	-882(ra) # 80001934 <wakeup>
    80005cae:	b575                	j	80005b5a <consoleintr+0x3c>

0000000080005cb0 <consoleinit>:

void
consoleinit(void)
{
    80005cb0:	1141                	addi	sp,sp,-16
    80005cb2:	e406                	sd	ra,8(sp)
    80005cb4:	e022                	sd	s0,0(sp)
    80005cb6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cb8:	00003597          	auipc	a1,0x3
    80005cbc:	b9058593          	addi	a1,a1,-1136 # 80008848 <syscalls+0x3c8>
    80005cc0:	00240517          	auipc	a0,0x240
    80005cc4:	48050513          	addi	a0,a0,1152 # 80246140 <cons>
    80005cc8:	00000097          	auipc	ra,0x0
    80005ccc:	580080e7          	jalr	1408(ra) # 80006248 <initlock>

  uartinit();
    80005cd0:	00000097          	auipc	ra,0x0
    80005cd4:	32c080e7          	jalr	812(ra) # 80005ffc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cd8:	00233797          	auipc	a5,0x233
    80005cdc:	41078793          	addi	a5,a5,1040 # 802390e8 <devsw>
    80005ce0:	00000717          	auipc	a4,0x0
    80005ce4:	cea70713          	addi	a4,a4,-790 # 800059ca <consoleread>
    80005ce8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cea:	00000717          	auipc	a4,0x0
    80005cee:	c7c70713          	addi	a4,a4,-900 # 80005966 <consolewrite>
    80005cf2:	ef98                	sd	a4,24(a5)
}
    80005cf4:	60a2                	ld	ra,8(sp)
    80005cf6:	6402                	ld	s0,0(sp)
    80005cf8:	0141                	addi	sp,sp,16
    80005cfa:	8082                	ret

0000000080005cfc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cfc:	7179                	addi	sp,sp,-48
    80005cfe:	f406                	sd	ra,40(sp)
    80005d00:	f022                	sd	s0,32(sp)
    80005d02:	ec26                	sd	s1,24(sp)
    80005d04:	e84a                	sd	s2,16(sp)
    80005d06:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d08:	c219                	beqz	a2,80005d0e <printint+0x12>
    80005d0a:	08054763          	bltz	a0,80005d98 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d0e:	2501                	sext.w	a0,a0
    80005d10:	4881                	li	a7,0
    80005d12:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d16:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d18:	2581                	sext.w	a1,a1
    80005d1a:	00003617          	auipc	a2,0x3
    80005d1e:	b5e60613          	addi	a2,a2,-1186 # 80008878 <digits>
    80005d22:	883a                	mv	a6,a4
    80005d24:	2705                	addiw	a4,a4,1
    80005d26:	02b577bb          	remuw	a5,a0,a1
    80005d2a:	1782                	slli	a5,a5,0x20
    80005d2c:	9381                	srli	a5,a5,0x20
    80005d2e:	97b2                	add	a5,a5,a2
    80005d30:	0007c783          	lbu	a5,0(a5)
    80005d34:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d38:	0005079b          	sext.w	a5,a0
    80005d3c:	02b5553b          	divuw	a0,a0,a1
    80005d40:	0685                	addi	a3,a3,1
    80005d42:	feb7f0e3          	bgeu	a5,a1,80005d22 <printint+0x26>

  if(sign)
    80005d46:	00088c63          	beqz	a7,80005d5e <printint+0x62>
    buf[i++] = '-';
    80005d4a:	fe070793          	addi	a5,a4,-32
    80005d4e:	00878733          	add	a4,a5,s0
    80005d52:	02d00793          	li	a5,45
    80005d56:	fef70823          	sb	a5,-16(a4)
    80005d5a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d5e:	02e05763          	blez	a4,80005d8c <printint+0x90>
    80005d62:	fd040793          	addi	a5,s0,-48
    80005d66:	00e784b3          	add	s1,a5,a4
    80005d6a:	fff78913          	addi	s2,a5,-1
    80005d6e:	993a                	add	s2,s2,a4
    80005d70:	377d                	addiw	a4,a4,-1
    80005d72:	1702                	slli	a4,a4,0x20
    80005d74:	9301                	srli	a4,a4,0x20
    80005d76:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d7a:	fff4c503          	lbu	a0,-1(s1)
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	d5e080e7          	jalr	-674(ra) # 80005adc <consputc>
  while(--i >= 0)
    80005d86:	14fd                	addi	s1,s1,-1
    80005d88:	ff2499e3          	bne	s1,s2,80005d7a <printint+0x7e>
}
    80005d8c:	70a2                	ld	ra,40(sp)
    80005d8e:	7402                	ld	s0,32(sp)
    80005d90:	64e2                	ld	s1,24(sp)
    80005d92:	6942                	ld	s2,16(sp)
    80005d94:	6145                	addi	sp,sp,48
    80005d96:	8082                	ret
    x = -xx;
    80005d98:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d9c:	4885                	li	a7,1
    x = -xx;
    80005d9e:	bf95                	j	80005d12 <printint+0x16>

0000000080005da0 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005da0:	1101                	addi	sp,sp,-32
    80005da2:	ec06                	sd	ra,24(sp)
    80005da4:	e822                	sd	s0,16(sp)
    80005da6:	e426                	sd	s1,8(sp)
    80005da8:	1000                	addi	s0,sp,32
    80005daa:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dac:	00240797          	auipc	a5,0x240
    80005db0:	4407aa23          	sw	zero,1108(a5) # 80246200 <pr+0x18>
  printf("panic: ");
    80005db4:	00003517          	auipc	a0,0x3
    80005db8:	a9c50513          	addi	a0,a0,-1380 # 80008850 <syscalls+0x3d0>
    80005dbc:	00000097          	auipc	ra,0x0
    80005dc0:	02e080e7          	jalr	46(ra) # 80005dea <printf>
  printf(s);
    80005dc4:	8526                	mv	a0,s1
    80005dc6:	00000097          	auipc	ra,0x0
    80005dca:	024080e7          	jalr	36(ra) # 80005dea <printf>
  printf("\n");
    80005dce:	00002517          	auipc	a0,0x2
    80005dd2:	28250513          	addi	a0,a0,642 # 80008050 <etext+0x50>
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	014080e7          	jalr	20(ra) # 80005dea <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dde:	4785                	li	a5,1
    80005de0:	00003717          	auipc	a4,0x3
    80005de4:	22f72e23          	sw	a5,572(a4) # 8000901c <panicked>
  for(;;)
    80005de8:	a001                	j	80005de8 <panic+0x48>

0000000080005dea <printf>:
{
    80005dea:	7131                	addi	sp,sp,-192
    80005dec:	fc86                	sd	ra,120(sp)
    80005dee:	f8a2                	sd	s0,112(sp)
    80005df0:	f4a6                	sd	s1,104(sp)
    80005df2:	f0ca                	sd	s2,96(sp)
    80005df4:	ecce                	sd	s3,88(sp)
    80005df6:	e8d2                	sd	s4,80(sp)
    80005df8:	e4d6                	sd	s5,72(sp)
    80005dfa:	e0da                	sd	s6,64(sp)
    80005dfc:	fc5e                	sd	s7,56(sp)
    80005dfe:	f862                	sd	s8,48(sp)
    80005e00:	f466                	sd	s9,40(sp)
    80005e02:	f06a                	sd	s10,32(sp)
    80005e04:	ec6e                	sd	s11,24(sp)
    80005e06:	0100                	addi	s0,sp,128
    80005e08:	8a2a                	mv	s4,a0
    80005e0a:	e40c                	sd	a1,8(s0)
    80005e0c:	e810                	sd	a2,16(s0)
    80005e0e:	ec14                	sd	a3,24(s0)
    80005e10:	f018                	sd	a4,32(s0)
    80005e12:	f41c                	sd	a5,40(s0)
    80005e14:	03043823          	sd	a6,48(s0)
    80005e18:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e1c:	00240d97          	auipc	s11,0x240
    80005e20:	3e4dad83          	lw	s11,996(s11) # 80246200 <pr+0x18>
  if(locking)
    80005e24:	020d9b63          	bnez	s11,80005e5a <printf+0x70>
  if (fmt == 0)
    80005e28:	040a0263          	beqz	s4,80005e6c <printf+0x82>
  va_start(ap, fmt);
    80005e2c:	00840793          	addi	a5,s0,8
    80005e30:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e34:	000a4503          	lbu	a0,0(s4)
    80005e38:	14050f63          	beqz	a0,80005f96 <printf+0x1ac>
    80005e3c:	4981                	li	s3,0
    if(c != '%'){
    80005e3e:	02500a93          	li	s5,37
    switch(c){
    80005e42:	07000b93          	li	s7,112
  consputc('x');
    80005e46:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e48:	00003b17          	auipc	s6,0x3
    80005e4c:	a30b0b13          	addi	s6,s6,-1488 # 80008878 <digits>
    switch(c){
    80005e50:	07300c93          	li	s9,115
    80005e54:	06400c13          	li	s8,100
    80005e58:	a82d                	j	80005e92 <printf+0xa8>
    acquire(&pr.lock);
    80005e5a:	00240517          	auipc	a0,0x240
    80005e5e:	38e50513          	addi	a0,a0,910 # 802461e8 <pr>
    80005e62:	00000097          	auipc	ra,0x0
    80005e66:	476080e7          	jalr	1142(ra) # 800062d8 <acquire>
    80005e6a:	bf7d                	j	80005e28 <printf+0x3e>
    panic("null fmt");
    80005e6c:	00003517          	auipc	a0,0x3
    80005e70:	9f450513          	addi	a0,a0,-1548 # 80008860 <syscalls+0x3e0>
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	f2c080e7          	jalr	-212(ra) # 80005da0 <panic>
      consputc(c);
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	c60080e7          	jalr	-928(ra) # 80005adc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e84:	2985                	addiw	s3,s3,1
    80005e86:	013a07b3          	add	a5,s4,s3
    80005e8a:	0007c503          	lbu	a0,0(a5)
    80005e8e:	10050463          	beqz	a0,80005f96 <printf+0x1ac>
    if(c != '%'){
    80005e92:	ff5515e3          	bne	a0,s5,80005e7c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e96:	2985                	addiw	s3,s3,1
    80005e98:	013a07b3          	add	a5,s4,s3
    80005e9c:	0007c783          	lbu	a5,0(a5)
    80005ea0:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ea4:	cbed                	beqz	a5,80005f96 <printf+0x1ac>
    switch(c){
    80005ea6:	05778a63          	beq	a5,s7,80005efa <printf+0x110>
    80005eaa:	02fbf663          	bgeu	s7,a5,80005ed6 <printf+0xec>
    80005eae:	09978863          	beq	a5,s9,80005f3e <printf+0x154>
    80005eb2:	07800713          	li	a4,120
    80005eb6:	0ce79563          	bne	a5,a4,80005f80 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005eba:	f8843783          	ld	a5,-120(s0)
    80005ebe:	00878713          	addi	a4,a5,8
    80005ec2:	f8e43423          	sd	a4,-120(s0)
    80005ec6:	4605                	li	a2,1
    80005ec8:	85ea                	mv	a1,s10
    80005eca:	4388                	lw	a0,0(a5)
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	e30080e7          	jalr	-464(ra) # 80005cfc <printint>
      break;
    80005ed4:	bf45                	j	80005e84 <printf+0x9a>
    switch(c){
    80005ed6:	09578f63          	beq	a5,s5,80005f74 <printf+0x18a>
    80005eda:	0b879363          	bne	a5,s8,80005f80 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005ede:	f8843783          	ld	a5,-120(s0)
    80005ee2:	00878713          	addi	a4,a5,8
    80005ee6:	f8e43423          	sd	a4,-120(s0)
    80005eea:	4605                	li	a2,1
    80005eec:	45a9                	li	a1,10
    80005eee:	4388                	lw	a0,0(a5)
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	e0c080e7          	jalr	-500(ra) # 80005cfc <printint>
      break;
    80005ef8:	b771                	j	80005e84 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005efa:	f8843783          	ld	a5,-120(s0)
    80005efe:	00878713          	addi	a4,a5,8
    80005f02:	f8e43423          	sd	a4,-120(s0)
    80005f06:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f0a:	03000513          	li	a0,48
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	bce080e7          	jalr	-1074(ra) # 80005adc <consputc>
  consputc('x');
    80005f16:	07800513          	li	a0,120
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	bc2080e7          	jalr	-1086(ra) # 80005adc <consputc>
    80005f22:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f24:	03c95793          	srli	a5,s2,0x3c
    80005f28:	97da                	add	a5,a5,s6
    80005f2a:	0007c503          	lbu	a0,0(a5)
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	bae080e7          	jalr	-1106(ra) # 80005adc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f36:	0912                	slli	s2,s2,0x4
    80005f38:	34fd                	addiw	s1,s1,-1
    80005f3a:	f4ed                	bnez	s1,80005f24 <printf+0x13a>
    80005f3c:	b7a1                	j	80005e84 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f3e:	f8843783          	ld	a5,-120(s0)
    80005f42:	00878713          	addi	a4,a5,8
    80005f46:	f8e43423          	sd	a4,-120(s0)
    80005f4a:	6384                	ld	s1,0(a5)
    80005f4c:	cc89                	beqz	s1,80005f66 <printf+0x17c>
      for(; *s; s++)
    80005f4e:	0004c503          	lbu	a0,0(s1)
    80005f52:	d90d                	beqz	a0,80005e84 <printf+0x9a>
        consputc(*s);
    80005f54:	00000097          	auipc	ra,0x0
    80005f58:	b88080e7          	jalr	-1144(ra) # 80005adc <consputc>
      for(; *s; s++)
    80005f5c:	0485                	addi	s1,s1,1
    80005f5e:	0004c503          	lbu	a0,0(s1)
    80005f62:	f96d                	bnez	a0,80005f54 <printf+0x16a>
    80005f64:	b705                	j	80005e84 <printf+0x9a>
        s = "(null)";
    80005f66:	00003497          	auipc	s1,0x3
    80005f6a:	8f248493          	addi	s1,s1,-1806 # 80008858 <syscalls+0x3d8>
      for(; *s; s++)
    80005f6e:	02800513          	li	a0,40
    80005f72:	b7cd                	j	80005f54 <printf+0x16a>
      consputc('%');
    80005f74:	8556                	mv	a0,s5
    80005f76:	00000097          	auipc	ra,0x0
    80005f7a:	b66080e7          	jalr	-1178(ra) # 80005adc <consputc>
      break;
    80005f7e:	b719                	j	80005e84 <printf+0x9a>
      consputc('%');
    80005f80:	8556                	mv	a0,s5
    80005f82:	00000097          	auipc	ra,0x0
    80005f86:	b5a080e7          	jalr	-1190(ra) # 80005adc <consputc>
      consputc(c);
    80005f8a:	8526                	mv	a0,s1
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	b50080e7          	jalr	-1200(ra) # 80005adc <consputc>
      break;
    80005f94:	bdc5                	j	80005e84 <printf+0x9a>
  if(locking)
    80005f96:	020d9163          	bnez	s11,80005fb8 <printf+0x1ce>
}
    80005f9a:	70e6                	ld	ra,120(sp)
    80005f9c:	7446                	ld	s0,112(sp)
    80005f9e:	74a6                	ld	s1,104(sp)
    80005fa0:	7906                	ld	s2,96(sp)
    80005fa2:	69e6                	ld	s3,88(sp)
    80005fa4:	6a46                	ld	s4,80(sp)
    80005fa6:	6aa6                	ld	s5,72(sp)
    80005fa8:	6b06                	ld	s6,64(sp)
    80005faa:	7be2                	ld	s7,56(sp)
    80005fac:	7c42                	ld	s8,48(sp)
    80005fae:	7ca2                	ld	s9,40(sp)
    80005fb0:	7d02                	ld	s10,32(sp)
    80005fb2:	6de2                	ld	s11,24(sp)
    80005fb4:	6129                	addi	sp,sp,192
    80005fb6:	8082                	ret
    release(&pr.lock);
    80005fb8:	00240517          	auipc	a0,0x240
    80005fbc:	23050513          	addi	a0,a0,560 # 802461e8 <pr>
    80005fc0:	00000097          	auipc	ra,0x0
    80005fc4:	3cc080e7          	jalr	972(ra) # 8000638c <release>
}
    80005fc8:	bfc9                	j	80005f9a <printf+0x1b0>

0000000080005fca <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fca:	1101                	addi	sp,sp,-32
    80005fcc:	ec06                	sd	ra,24(sp)
    80005fce:	e822                	sd	s0,16(sp)
    80005fd0:	e426                	sd	s1,8(sp)
    80005fd2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fd4:	00240497          	auipc	s1,0x240
    80005fd8:	21448493          	addi	s1,s1,532 # 802461e8 <pr>
    80005fdc:	00003597          	auipc	a1,0x3
    80005fe0:	89458593          	addi	a1,a1,-1900 # 80008870 <syscalls+0x3f0>
    80005fe4:	8526                	mv	a0,s1
    80005fe6:	00000097          	auipc	ra,0x0
    80005fea:	262080e7          	jalr	610(ra) # 80006248 <initlock>
  pr.locking = 1;
    80005fee:	4785                	li	a5,1
    80005ff0:	cc9c                	sw	a5,24(s1)
}
    80005ff2:	60e2                	ld	ra,24(sp)
    80005ff4:	6442                	ld	s0,16(sp)
    80005ff6:	64a2                	ld	s1,8(sp)
    80005ff8:	6105                	addi	sp,sp,32
    80005ffa:	8082                	ret

0000000080005ffc <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ffc:	1141                	addi	sp,sp,-16
    80005ffe:	e406                	sd	ra,8(sp)
    80006000:	e022                	sd	s0,0(sp)
    80006002:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006004:	100007b7          	lui	a5,0x10000
    80006008:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000600c:	f8000713          	li	a4,-128
    80006010:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006014:	470d                	li	a4,3
    80006016:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000601a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000601e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006022:	469d                	li	a3,7
    80006024:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006028:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000602c:	00003597          	auipc	a1,0x3
    80006030:	86458593          	addi	a1,a1,-1948 # 80008890 <digits+0x18>
    80006034:	00240517          	auipc	a0,0x240
    80006038:	1d450513          	addi	a0,a0,468 # 80246208 <uart_tx_lock>
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	20c080e7          	jalr	524(ra) # 80006248 <initlock>
}
    80006044:	60a2                	ld	ra,8(sp)
    80006046:	6402                	ld	s0,0(sp)
    80006048:	0141                	addi	sp,sp,16
    8000604a:	8082                	ret

000000008000604c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000604c:	1101                	addi	sp,sp,-32
    8000604e:	ec06                	sd	ra,24(sp)
    80006050:	e822                	sd	s0,16(sp)
    80006052:	e426                	sd	s1,8(sp)
    80006054:	1000                	addi	s0,sp,32
    80006056:	84aa                	mv	s1,a0
  push_off();
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	234080e7          	jalr	564(ra) # 8000628c <push_off>

  if(panicked){
    80006060:	00003797          	auipc	a5,0x3
    80006064:	fbc7a783          	lw	a5,-68(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006068:	10000737          	lui	a4,0x10000
  if(panicked){
    8000606c:	c391                	beqz	a5,80006070 <uartputc_sync+0x24>
    for(;;)
    8000606e:	a001                	j	8000606e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006070:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006074:	0207f793          	andi	a5,a5,32
    80006078:	dfe5                	beqz	a5,80006070 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000607a:	0ff4f513          	zext.b	a0,s1
    8000607e:	100007b7          	lui	a5,0x10000
    80006082:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	2a6080e7          	jalr	678(ra) # 8000632c <pop_off>
}
    8000608e:	60e2                	ld	ra,24(sp)
    80006090:	6442                	ld	s0,16(sp)
    80006092:	64a2                	ld	s1,8(sp)
    80006094:	6105                	addi	sp,sp,32
    80006096:	8082                	ret

0000000080006098 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006098:	00003797          	auipc	a5,0x3
    8000609c:	f887b783          	ld	a5,-120(a5) # 80009020 <uart_tx_r>
    800060a0:	00003717          	auipc	a4,0x3
    800060a4:	f8873703          	ld	a4,-120(a4) # 80009028 <uart_tx_w>
    800060a8:	06f70a63          	beq	a4,a5,8000611c <uartstart+0x84>
{
    800060ac:	7139                	addi	sp,sp,-64
    800060ae:	fc06                	sd	ra,56(sp)
    800060b0:	f822                	sd	s0,48(sp)
    800060b2:	f426                	sd	s1,40(sp)
    800060b4:	f04a                	sd	s2,32(sp)
    800060b6:	ec4e                	sd	s3,24(sp)
    800060b8:	e852                	sd	s4,16(sp)
    800060ba:	e456                	sd	s5,8(sp)
    800060bc:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060be:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060c2:	00240a17          	auipc	s4,0x240
    800060c6:	146a0a13          	addi	s4,s4,326 # 80246208 <uart_tx_lock>
    uart_tx_r += 1;
    800060ca:	00003497          	auipc	s1,0x3
    800060ce:	f5648493          	addi	s1,s1,-170 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060d2:	00003997          	auipc	s3,0x3
    800060d6:	f5698993          	addi	s3,s3,-170 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060da:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060de:	02077713          	andi	a4,a4,32
    800060e2:	c705                	beqz	a4,8000610a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060e4:	01f7f713          	andi	a4,a5,31
    800060e8:	9752                	add	a4,a4,s4
    800060ea:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800060ee:	0785                	addi	a5,a5,1
    800060f0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060f2:	8526                	mv	a0,s1
    800060f4:	ffffc097          	auipc	ra,0xffffc
    800060f8:	840080e7          	jalr	-1984(ra) # 80001934 <wakeup>
    
    WriteReg(THR, c);
    800060fc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006100:	609c                	ld	a5,0(s1)
    80006102:	0009b703          	ld	a4,0(s3)
    80006106:	fcf71ae3          	bne	a4,a5,800060da <uartstart+0x42>
  }
}
    8000610a:	70e2                	ld	ra,56(sp)
    8000610c:	7442                	ld	s0,48(sp)
    8000610e:	74a2                	ld	s1,40(sp)
    80006110:	7902                	ld	s2,32(sp)
    80006112:	69e2                	ld	s3,24(sp)
    80006114:	6a42                	ld	s4,16(sp)
    80006116:	6aa2                	ld	s5,8(sp)
    80006118:	6121                	addi	sp,sp,64
    8000611a:	8082                	ret
    8000611c:	8082                	ret

000000008000611e <uartputc>:
{
    8000611e:	7179                	addi	sp,sp,-48
    80006120:	f406                	sd	ra,40(sp)
    80006122:	f022                	sd	s0,32(sp)
    80006124:	ec26                	sd	s1,24(sp)
    80006126:	e84a                	sd	s2,16(sp)
    80006128:	e44e                	sd	s3,8(sp)
    8000612a:	e052                	sd	s4,0(sp)
    8000612c:	1800                	addi	s0,sp,48
    8000612e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006130:	00240517          	auipc	a0,0x240
    80006134:	0d850513          	addi	a0,a0,216 # 80246208 <uart_tx_lock>
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	1a0080e7          	jalr	416(ra) # 800062d8 <acquire>
  if(panicked){
    80006140:	00003797          	auipc	a5,0x3
    80006144:	edc7a783          	lw	a5,-292(a5) # 8000901c <panicked>
    80006148:	c391                	beqz	a5,8000614c <uartputc+0x2e>
    for(;;)
    8000614a:	a001                	j	8000614a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000614c:	00003717          	auipc	a4,0x3
    80006150:	edc73703          	ld	a4,-292(a4) # 80009028 <uart_tx_w>
    80006154:	00003797          	auipc	a5,0x3
    80006158:	ecc7b783          	ld	a5,-308(a5) # 80009020 <uart_tx_r>
    8000615c:	02078793          	addi	a5,a5,32
    80006160:	02e79b63          	bne	a5,a4,80006196 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006164:	00240997          	auipc	s3,0x240
    80006168:	0a498993          	addi	s3,s3,164 # 80246208 <uart_tx_lock>
    8000616c:	00003497          	auipc	s1,0x3
    80006170:	eb448493          	addi	s1,s1,-332 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006174:	00003917          	auipc	s2,0x3
    80006178:	eb490913          	addi	s2,s2,-332 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000617c:	85ce                	mv	a1,s3
    8000617e:	8526                	mv	a0,s1
    80006180:	ffffb097          	auipc	ra,0xffffb
    80006184:	628080e7          	jalr	1576(ra) # 800017a8 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006188:	00093703          	ld	a4,0(s2)
    8000618c:	609c                	ld	a5,0(s1)
    8000618e:	02078793          	addi	a5,a5,32
    80006192:	fee785e3          	beq	a5,a4,8000617c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006196:	00240497          	auipc	s1,0x240
    8000619a:	07248493          	addi	s1,s1,114 # 80246208 <uart_tx_lock>
    8000619e:	01f77793          	andi	a5,a4,31
    800061a2:	97a6                	add	a5,a5,s1
    800061a4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800061a8:	0705                	addi	a4,a4,1
    800061aa:	00003797          	auipc	a5,0x3
    800061ae:	e6e7bf23          	sd	a4,-386(a5) # 80009028 <uart_tx_w>
      uartstart();
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	ee6080e7          	jalr	-282(ra) # 80006098 <uartstart>
      release(&uart_tx_lock);
    800061ba:	8526                	mv	a0,s1
    800061bc:	00000097          	auipc	ra,0x0
    800061c0:	1d0080e7          	jalr	464(ra) # 8000638c <release>
}
    800061c4:	70a2                	ld	ra,40(sp)
    800061c6:	7402                	ld	s0,32(sp)
    800061c8:	64e2                	ld	s1,24(sp)
    800061ca:	6942                	ld	s2,16(sp)
    800061cc:	69a2                	ld	s3,8(sp)
    800061ce:	6a02                	ld	s4,0(sp)
    800061d0:	6145                	addi	sp,sp,48
    800061d2:	8082                	ret

00000000800061d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061d4:	1141                	addi	sp,sp,-16
    800061d6:	e422                	sd	s0,8(sp)
    800061d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061da:	100007b7          	lui	a5,0x10000
    800061de:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061e2:	8b85                	andi	a5,a5,1
    800061e4:	cb81                	beqz	a5,800061f4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800061e6:	100007b7          	lui	a5,0x10000
    800061ea:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800061ee:	6422                	ld	s0,8(sp)
    800061f0:	0141                	addi	sp,sp,16
    800061f2:	8082                	ret
    return -1;
    800061f4:	557d                	li	a0,-1
    800061f6:	bfe5                	j	800061ee <uartgetc+0x1a>

00000000800061f8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061f8:	1101                	addi	sp,sp,-32
    800061fa:	ec06                	sd	ra,24(sp)
    800061fc:	e822                	sd	s0,16(sp)
    800061fe:	e426                	sd	s1,8(sp)
    80006200:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006202:	54fd                	li	s1,-1
    80006204:	a029                	j	8000620e <uartintr+0x16>
      break;
    consoleintr(c);
    80006206:	00000097          	auipc	ra,0x0
    8000620a:	918080e7          	jalr	-1768(ra) # 80005b1e <consoleintr>
    int c = uartgetc();
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	fc6080e7          	jalr	-58(ra) # 800061d4 <uartgetc>
    if(c == -1)
    80006216:	fe9518e3          	bne	a0,s1,80006206 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000621a:	00240497          	auipc	s1,0x240
    8000621e:	fee48493          	addi	s1,s1,-18 # 80246208 <uart_tx_lock>
    80006222:	8526                	mv	a0,s1
    80006224:	00000097          	auipc	ra,0x0
    80006228:	0b4080e7          	jalr	180(ra) # 800062d8 <acquire>
  uartstart();
    8000622c:	00000097          	auipc	ra,0x0
    80006230:	e6c080e7          	jalr	-404(ra) # 80006098 <uartstart>
  release(&uart_tx_lock);
    80006234:	8526                	mv	a0,s1
    80006236:	00000097          	auipc	ra,0x0
    8000623a:	156080e7          	jalr	342(ra) # 8000638c <release>
}
    8000623e:	60e2                	ld	ra,24(sp)
    80006240:	6442                	ld	s0,16(sp)
    80006242:	64a2                	ld	s1,8(sp)
    80006244:	6105                	addi	sp,sp,32
    80006246:	8082                	ret

0000000080006248 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006248:	1141                	addi	sp,sp,-16
    8000624a:	e422                	sd	s0,8(sp)
    8000624c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000624e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006250:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006254:	00053823          	sd	zero,16(a0)
}
    80006258:	6422                	ld	s0,8(sp)
    8000625a:	0141                	addi	sp,sp,16
    8000625c:	8082                	ret

000000008000625e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000625e:	411c                	lw	a5,0(a0)
    80006260:	e399                	bnez	a5,80006266 <holding+0x8>
    80006262:	4501                	li	a0,0
  return r;
}
    80006264:	8082                	ret
{
    80006266:	1101                	addi	sp,sp,-32
    80006268:	ec06                	sd	ra,24(sp)
    8000626a:	e822                	sd	s0,16(sp)
    8000626c:	e426                	sd	s1,8(sp)
    8000626e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006270:	6904                	ld	s1,16(a0)
    80006272:	ffffb097          	auipc	ra,0xffffb
    80006276:	e56080e7          	jalr	-426(ra) # 800010c8 <mycpu>
    8000627a:	40a48533          	sub	a0,s1,a0
    8000627e:	00153513          	seqz	a0,a0
}
    80006282:	60e2                	ld	ra,24(sp)
    80006284:	6442                	ld	s0,16(sp)
    80006286:	64a2                	ld	s1,8(sp)
    80006288:	6105                	addi	sp,sp,32
    8000628a:	8082                	ret

000000008000628c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000628c:	1101                	addi	sp,sp,-32
    8000628e:	ec06                	sd	ra,24(sp)
    80006290:	e822                	sd	s0,16(sp)
    80006292:	e426                	sd	s1,8(sp)
    80006294:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006296:	100024f3          	csrr	s1,sstatus
    8000629a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000629e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062a0:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062a4:	ffffb097          	auipc	ra,0xffffb
    800062a8:	e24080e7          	jalr	-476(ra) # 800010c8 <mycpu>
    800062ac:	5d3c                	lw	a5,120(a0)
    800062ae:	cf89                	beqz	a5,800062c8 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062b0:	ffffb097          	auipc	ra,0xffffb
    800062b4:	e18080e7          	jalr	-488(ra) # 800010c8 <mycpu>
    800062b8:	5d3c                	lw	a5,120(a0)
    800062ba:	2785                	addiw	a5,a5,1
    800062bc:	dd3c                	sw	a5,120(a0)
}
    800062be:	60e2                	ld	ra,24(sp)
    800062c0:	6442                	ld	s0,16(sp)
    800062c2:	64a2                	ld	s1,8(sp)
    800062c4:	6105                	addi	sp,sp,32
    800062c6:	8082                	ret
    mycpu()->intena = old;
    800062c8:	ffffb097          	auipc	ra,0xffffb
    800062cc:	e00080e7          	jalr	-512(ra) # 800010c8 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062d0:	8085                	srli	s1,s1,0x1
    800062d2:	8885                	andi	s1,s1,1
    800062d4:	dd64                	sw	s1,124(a0)
    800062d6:	bfe9                	j	800062b0 <push_off+0x24>

00000000800062d8 <acquire>:
{
    800062d8:	1101                	addi	sp,sp,-32
    800062da:	ec06                	sd	ra,24(sp)
    800062dc:	e822                	sd	s0,16(sp)
    800062de:	e426                	sd	s1,8(sp)
    800062e0:	1000                	addi	s0,sp,32
    800062e2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062e4:	00000097          	auipc	ra,0x0
    800062e8:	fa8080e7          	jalr	-88(ra) # 8000628c <push_off>
  if(holding(lk))
    800062ec:	8526                	mv	a0,s1
    800062ee:	00000097          	auipc	ra,0x0
    800062f2:	f70080e7          	jalr	-144(ra) # 8000625e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062f6:	4705                	li	a4,1
  if(holding(lk))
    800062f8:	e115                	bnez	a0,8000631c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062fa:	87ba                	mv	a5,a4
    800062fc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006300:	2781                	sext.w	a5,a5
    80006302:	ffe5                	bnez	a5,800062fa <acquire+0x22>
  __sync_synchronize();
    80006304:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006308:	ffffb097          	auipc	ra,0xffffb
    8000630c:	dc0080e7          	jalr	-576(ra) # 800010c8 <mycpu>
    80006310:	e888                	sd	a0,16(s1)
}
    80006312:	60e2                	ld	ra,24(sp)
    80006314:	6442                	ld	s0,16(sp)
    80006316:	64a2                	ld	s1,8(sp)
    80006318:	6105                	addi	sp,sp,32
    8000631a:	8082                	ret
    panic("acquire");
    8000631c:	00002517          	auipc	a0,0x2
    80006320:	57c50513          	addi	a0,a0,1404 # 80008898 <digits+0x20>
    80006324:	00000097          	auipc	ra,0x0
    80006328:	a7c080e7          	jalr	-1412(ra) # 80005da0 <panic>

000000008000632c <pop_off>:

void
pop_off(void)
{
    8000632c:	1141                	addi	sp,sp,-16
    8000632e:	e406                	sd	ra,8(sp)
    80006330:	e022                	sd	s0,0(sp)
    80006332:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006334:	ffffb097          	auipc	ra,0xffffb
    80006338:	d94080e7          	jalr	-620(ra) # 800010c8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000633c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006340:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006342:	e78d                	bnez	a5,8000636c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006344:	5d3c                	lw	a5,120(a0)
    80006346:	02f05b63          	blez	a5,8000637c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000634a:	37fd                	addiw	a5,a5,-1
    8000634c:	0007871b          	sext.w	a4,a5
    80006350:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006352:	eb09                	bnez	a4,80006364 <pop_off+0x38>
    80006354:	5d7c                	lw	a5,124(a0)
    80006356:	c799                	beqz	a5,80006364 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006358:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000635c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006360:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006364:	60a2                	ld	ra,8(sp)
    80006366:	6402                	ld	s0,0(sp)
    80006368:	0141                	addi	sp,sp,16
    8000636a:	8082                	ret
    panic("pop_off - interruptible");
    8000636c:	00002517          	auipc	a0,0x2
    80006370:	53450513          	addi	a0,a0,1332 # 800088a0 <digits+0x28>
    80006374:	00000097          	auipc	ra,0x0
    80006378:	a2c080e7          	jalr	-1492(ra) # 80005da0 <panic>
    panic("pop_off");
    8000637c:	00002517          	auipc	a0,0x2
    80006380:	53c50513          	addi	a0,a0,1340 # 800088b8 <digits+0x40>
    80006384:	00000097          	auipc	ra,0x0
    80006388:	a1c080e7          	jalr	-1508(ra) # 80005da0 <panic>

000000008000638c <release>:
{
    8000638c:	1101                	addi	sp,sp,-32
    8000638e:	ec06                	sd	ra,24(sp)
    80006390:	e822                	sd	s0,16(sp)
    80006392:	e426                	sd	s1,8(sp)
    80006394:	1000                	addi	s0,sp,32
    80006396:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006398:	00000097          	auipc	ra,0x0
    8000639c:	ec6080e7          	jalr	-314(ra) # 8000625e <holding>
    800063a0:	c115                	beqz	a0,800063c4 <release+0x38>
  lk->cpu = 0;
    800063a2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063a6:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063aa:	0f50000f          	fence	iorw,ow
    800063ae:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063b2:	00000097          	auipc	ra,0x0
    800063b6:	f7a080e7          	jalr	-134(ra) # 8000632c <pop_off>
}
    800063ba:	60e2                	ld	ra,24(sp)
    800063bc:	6442                	ld	s0,16(sp)
    800063be:	64a2                	ld	s1,8(sp)
    800063c0:	6105                	addi	sp,sp,32
    800063c2:	8082                	ret
    panic("release");
    800063c4:	00002517          	auipc	a0,0x2
    800063c8:	4fc50513          	addi	a0,a0,1276 # 800088c0 <digits+0x48>
    800063cc:	00000097          	auipc	ra,0x0
    800063d0:	9d4080e7          	jalr	-1580(ra) # 80005da0 <panic>
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
