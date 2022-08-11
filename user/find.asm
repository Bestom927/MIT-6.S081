
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "user/user.h"
#include "kernel/fs.h"

char* des = 0;
void find(const char* path)
{
   0:	d9010113          	addi	sp,sp,-624
   4:	26113423          	sd	ra,616(sp)
   8:	26813023          	sd	s0,608(sp)
   c:	24913c23          	sd	s1,600(sp)
  10:	25213823          	sd	s2,592(sp)
  14:	25313423          	sd	s3,584(sp)
  18:	25413023          	sd	s4,576(sp)
  1c:	23513c23          	sd	s5,568(sp)
  20:	23613823          	sd	s6,560(sp)
  24:	1c80                	addi	s0,sp,624
  26:	892a                	mv	s2,a0
    //buf中存绝对路径
	char buf[512],*p;
	strcpy(buf,path);
  28:	85aa                	mv	a1,a0
  2a:	dc040513          	addi	a0,s0,-576
  2e:	00000097          	auipc	ra,0x0
  32:	1c6080e7          	jalr	454(ra) # 1f4 <strcpy>
	p = buf + strlen(path);
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	204080e7          	jalr	516(ra) # 23c <strlen>
  40:	1502                	slli	a0,a0,0x20
  42:	9101                	srli	a0,a0,0x20
  44:	dc040793          	addi	a5,s0,-576
  48:	00a789b3          	add	s3,a5,a0
	*p++ = '/';
  4c:	02f00793          	li	a5,47
  50:	00f98023          	sb	a5,0(s3)
	int fd;
	
	//文件状态
	struct stat st;
	if (0 > (fd = open(path,O_RDONLY)))
  54:	4581                	li	a1,0
  56:	854a                	mv	a0,s2
  58:	00000097          	auipc	ra,0x0
  5c:	448080e7          	jalr	1096(ra) # 4a0 <open>
  60:	0a054663          	bltz	a0,10c <find+0x10c>
  64:	84aa                	mv	s1,a0
	{
		fprintf(2,"cannot open %s\n",path);
		return;
	}
	if (0 > fstat(fd,&st))
  66:	da840593          	addi	a1,s0,-600
  6a:	00000097          	auipc	ra,0x0
  6e:	44e080e7          	jalr	1102(ra) # 4b8 <fstat>
  72:	0a054863          	bltz	a0,122 <find+0x122>
	*p++ = '/';
  76:	0985                	addi	s3,s3,1
		if (stat(buf,&st) < 0)
		{
			fprintf(2,"cannot stat %s\n",buf);
			continue;
		}
		switch(st.type)
  78:	4905                	li	s2,1
					printf("%s\n",buf);
				break;
			
			//是目录
			case T_DIR:
				if (strcmp(".",dir.name) && strcmp("..",dir.name))
  7a:	00001a97          	auipc	s5,0x1
  7e:	93ea8a93          	addi	s5,s5,-1730 # 9b8 <malloc+0x126>
  82:	00001b17          	auipc	s6,0x1
  86:	93eb0b13          	addi	s6,s6,-1730 # 9c0 <malloc+0x12e>
				if (!strcmp(dir.name,des))//如果文件名相同
  8a:	00001a17          	auipc	s4,0x1
  8e:	9d6a0a13          	addi	s4,s4,-1578 # a60 <des>
	while (read(fd,&dir,len) == len)
  92:	4641                	li	a2,16
  94:	d9840593          	addi	a1,s0,-616
  98:	8526                	mv	a0,s1
  9a:	00000097          	auipc	ra,0x0
  9e:	3de080e7          	jalr	990(ra) # 478 <read>
  a2:	47c1                	li	a5,16
  a4:	0cf51d63          	bne	a0,a5,17e <find+0x17e>
		if (0 == dir.inum)
  a8:	d9845783          	lhu	a5,-616(s0)
  ac:	d3fd                	beqz	a5,92 <find+0x92>
		strcpy(p,dir.name);
  ae:	d9a40593          	addi	a1,s0,-614
  b2:	854e                	mv	a0,s3
  b4:	00000097          	auipc	ra,0x0
  b8:	140080e7          	jalr	320(ra) # 1f4 <strcpy>
		if (stat(buf,&st) < 0)
  bc:	da840593          	addi	a1,s0,-600
  c0:	dc040513          	addi	a0,s0,-576
  c4:	00000097          	auipc	ra,0x0
  c8:	25c080e7          	jalr	604(ra) # 320 <stat>
  cc:	06054663          	bltz	a0,138 <find+0x138>
		switch(st.type)
  d0:	db041783          	lh	a5,-592(s0)
  d4:	0007871b          	sext.w	a4,a5
  d8:	07270c63          	beq	a4,s2,150 <find+0x150>
  dc:	87ba                	mv	a5,a4
  de:	4709                	li	a4,2
  e0:	fae799e3          	bne	a5,a4,92 <find+0x92>
				if (!strcmp(dir.name,des))//如果文件名相同
  e4:	000a3583          	ld	a1,0(s4)
  e8:	d9a40513          	addi	a0,s0,-614
  ec:	00000097          	auipc	ra,0x0
  f0:	124080e7          	jalr	292(ra) # 210 <strcmp>
  f4:	fd59                	bnez	a0,92 <find+0x92>
					printf("%s\n",buf);
  f6:	dc040593          	addi	a1,s0,-576
  fa:	00001517          	auipc	a0,0x1
  fe:	8b650513          	addi	a0,a0,-1866 # 9b0 <malloc+0x11e>
 102:	00000097          	auipc	ra,0x0
 106:	6d8080e7          	jalr	1752(ra) # 7da <printf>
 10a:	b761                	j	92 <find+0x92>
		fprintf(2,"cannot open %s\n",path);
 10c:	864a                	mv	a2,s2
 10e:	00001597          	auipc	a1,0x1
 112:	86a58593          	addi	a1,a1,-1942 # 978 <malloc+0xe6>
 116:	4509                	li	a0,2
 118:	00000097          	auipc	ra,0x0
 11c:	694080e7          	jalr	1684(ra) # 7ac <fprintf>
		return;
 120:	a0a5                	j	188 <find+0x188>
		fprintf(2,"cannot fstat %s\n",path);
 122:	864a                	mv	a2,s2
 124:	00001597          	auipc	a1,0x1
 128:	86458593          	addi	a1,a1,-1948 # 988 <malloc+0xf6>
 12c:	4509                	li	a0,2
 12e:	00000097          	auipc	ra,0x0
 132:	67e080e7          	jalr	1662(ra) # 7ac <fprintf>
		return;
 136:	a889                	j	188 <find+0x188>
			fprintf(2,"cannot stat %s\n",buf);
 138:	dc040613          	addi	a2,s0,-576
 13c:	00001597          	auipc	a1,0x1
 140:	86458593          	addi	a1,a1,-1948 # 9a0 <malloc+0x10e>
 144:	4509                	li	a0,2
 146:	00000097          	auipc	ra,0x0
 14a:	666080e7          	jalr	1638(ra) # 7ac <fprintf>
			continue;
 14e:	b791                	j	92 <find+0x92>
				if (strcmp(".",dir.name) && strcmp("..",dir.name))
 150:	d9a40593          	addi	a1,s0,-614
 154:	8556                	mv	a0,s5
 156:	00000097          	auipc	ra,0x0
 15a:	0ba080e7          	jalr	186(ra) # 210 <strcmp>
 15e:	d915                	beqz	a0,92 <find+0x92>
 160:	d9a40593          	addi	a1,s0,-614
 164:	855a                	mv	a0,s6
 166:	00000097          	auipc	ra,0x0
 16a:	0aa080e7          	jalr	170(ra) # 210 <strcmp>
 16e:	d115                	beqz	a0,92 <find+0x92>
					find(buf);//递归
 170:	dc040513          	addi	a0,s0,-576
 174:	00000097          	auipc	ra,0x0
 178:	e8c080e7          	jalr	-372(ra) # 0 <find>
 17c:	bf19                	j	92 <find+0x92>

			default:
				break;
		}
	}
	close(fd);
 17e:	8526                	mv	a0,s1
 180:	00000097          	auipc	ra,0x0
 184:	308080e7          	jalr	776(ra) # 488 <close>
}
 188:	26813083          	ld	ra,616(sp)
 18c:	26013403          	ld	s0,608(sp)
 190:	25813483          	ld	s1,600(sp)
 194:	25013903          	ld	s2,592(sp)
 198:	24813983          	ld	s3,584(sp)
 19c:	24013a03          	ld	s4,576(sp)
 1a0:	23813a83          	ld	s5,568(sp)
 1a4:	23013b03          	ld	s6,560(sp)
 1a8:	27010113          	addi	sp,sp,624
 1ac:	8082                	ret

00000000000001ae <main>:

int main(int argc,const char* argv[])
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e406                	sd	ra,8(sp)
 1b2:	e022                	sd	s0,0(sp)
 1b4:	0800                	addi	s0,sp,16
	if (argc <= 2)
 1b6:	4789                	li	a5,2
 1b8:	00a7cf63          	blt	a5,a0,1d6 <main+0x28>
	{
		printf("Usage: find <dir> <file> ...\n");
 1bc:	00001517          	auipc	a0,0x1
 1c0:	80c50513          	addi	a0,a0,-2036 # 9c8 <malloc+0x136>
 1c4:	00000097          	auipc	ra,0x0
 1c8:	616080e7          	jalr	1558(ra) # 7da <printf>
		exit(1);
 1cc:	4505                	li	a0,1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	292080e7          	jalr	658(ra) # 460 <exit>
	}
	des = (char*)argv[2];
 1d6:	699c                	ld	a5,16(a1)
 1d8:	00001717          	auipc	a4,0x1
 1dc:	88f73423          	sd	a5,-1912(a4) # a60 <des>
	find(argv[1]);
 1e0:	6588                	ld	a0,8(a1)
 1e2:	00000097          	auipc	ra,0x0
 1e6:	e1e080e7          	jalr	-482(ra) # 0 <find>
	exit(0);
 1ea:	4501                	li	a0,0
 1ec:	00000097          	auipc	ra,0x0
 1f0:	274080e7          	jalr	628(ra) # 460 <exit>

00000000000001f4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1fa:	87aa                	mv	a5,a0
 1fc:	0585                	addi	a1,a1,1
 1fe:	0785                	addi	a5,a5,1
 200:	fff5c703          	lbu	a4,-1(a1)
 204:	fee78fa3          	sb	a4,-1(a5)
 208:	fb75                	bnez	a4,1fc <strcpy+0x8>
    ;
  return os;
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret

0000000000000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 216:	00054783          	lbu	a5,0(a0)
 21a:	cb91                	beqz	a5,22e <strcmp+0x1e>
 21c:	0005c703          	lbu	a4,0(a1)
 220:	00f71763          	bne	a4,a5,22e <strcmp+0x1e>
    p++, q++;
 224:	0505                	addi	a0,a0,1
 226:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 228:	00054783          	lbu	a5,0(a0)
 22c:	fbe5                	bnez	a5,21c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 22e:	0005c503          	lbu	a0,0(a1)
}
 232:	40a7853b          	subw	a0,a5,a0
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret

000000000000023c <strlen>:

uint
strlen(const char *s)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 242:	00054783          	lbu	a5,0(a0)
 246:	cf91                	beqz	a5,262 <strlen+0x26>
 248:	0505                	addi	a0,a0,1
 24a:	87aa                	mv	a5,a0
 24c:	4685                	li	a3,1
 24e:	9e89                	subw	a3,a3,a0
 250:	00f6853b          	addw	a0,a3,a5
 254:	0785                	addi	a5,a5,1
 256:	fff7c703          	lbu	a4,-1(a5)
 25a:	fb7d                	bnez	a4,250 <strlen+0x14>
    ;
  return n;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
  for(n = 0; s[n]; n++)
 262:	4501                	li	a0,0
 264:	bfe5                	j	25c <strlen+0x20>

0000000000000266 <memset>:

void*
memset(void *dst, int c, uint n)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 26c:	ca19                	beqz	a2,282 <memset+0x1c>
 26e:	87aa                	mv	a5,a0
 270:	1602                	slli	a2,a2,0x20
 272:	9201                	srli	a2,a2,0x20
 274:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 278:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 27c:	0785                	addi	a5,a5,1
 27e:	fee79de3          	bne	a5,a4,278 <memset+0x12>
  }
  return dst;
}
 282:	6422                	ld	s0,8(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strchr>:

char*
strchr(const char *s, char c)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cb99                	beqz	a5,2a8 <strchr+0x20>
    if(*s == c)
 294:	00f58763          	beq	a1,a5,2a2 <strchr+0x1a>
  for(; *s; s++)
 298:	0505                	addi	a0,a0,1
 29a:	00054783          	lbu	a5,0(a0)
 29e:	fbfd                	bnez	a5,294 <strchr+0xc>
      return (char*)s;
  return 0;
 2a0:	4501                	li	a0,0
}
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret
  return 0;
 2a8:	4501                	li	a0,0
 2aa:	bfe5                	j	2a2 <strchr+0x1a>

00000000000002ac <gets>:

char*
gets(char *buf, int max)
{
 2ac:	711d                	addi	sp,sp,-96
 2ae:	ec86                	sd	ra,88(sp)
 2b0:	e8a2                	sd	s0,80(sp)
 2b2:	e4a6                	sd	s1,72(sp)
 2b4:	e0ca                	sd	s2,64(sp)
 2b6:	fc4e                	sd	s3,56(sp)
 2b8:	f852                	sd	s4,48(sp)
 2ba:	f456                	sd	s5,40(sp)
 2bc:	f05a                	sd	s6,32(sp)
 2be:	ec5e                	sd	s7,24(sp)
 2c0:	1080                	addi	s0,sp,96
 2c2:	8baa                	mv	s7,a0
 2c4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c6:	892a                	mv	s2,a0
 2c8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ca:	4aa9                	li	s5,10
 2cc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2ce:	89a6                	mv	s3,s1
 2d0:	2485                	addiw	s1,s1,1
 2d2:	0344d863          	bge	s1,s4,302 <gets+0x56>
    cc = read(0, &c, 1);
 2d6:	4605                	li	a2,1
 2d8:	faf40593          	addi	a1,s0,-81
 2dc:	4501                	li	a0,0
 2de:	00000097          	auipc	ra,0x0
 2e2:	19a080e7          	jalr	410(ra) # 478 <read>
    if(cc < 1)
 2e6:	00a05e63          	blez	a0,302 <gets+0x56>
    buf[i++] = c;
 2ea:	faf44783          	lbu	a5,-81(s0)
 2ee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2f2:	01578763          	beq	a5,s5,300 <gets+0x54>
 2f6:	0905                	addi	s2,s2,1
 2f8:	fd679be3          	bne	a5,s6,2ce <gets+0x22>
  for(i=0; i+1 < max; ){
 2fc:	89a6                	mv	s3,s1
 2fe:	a011                	j	302 <gets+0x56>
 300:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 302:	99de                	add	s3,s3,s7
 304:	00098023          	sb	zero,0(s3)
  return buf;
}
 308:	855e                	mv	a0,s7
 30a:	60e6                	ld	ra,88(sp)
 30c:	6446                	ld	s0,80(sp)
 30e:	64a6                	ld	s1,72(sp)
 310:	6906                	ld	s2,64(sp)
 312:	79e2                	ld	s3,56(sp)
 314:	7a42                	ld	s4,48(sp)
 316:	7aa2                	ld	s5,40(sp)
 318:	7b02                	ld	s6,32(sp)
 31a:	6be2                	ld	s7,24(sp)
 31c:	6125                	addi	sp,sp,96
 31e:	8082                	ret

0000000000000320 <stat>:

int
stat(const char *n, struct stat *st)
{
 320:	1101                	addi	sp,sp,-32
 322:	ec06                	sd	ra,24(sp)
 324:	e822                	sd	s0,16(sp)
 326:	e426                	sd	s1,8(sp)
 328:	e04a                	sd	s2,0(sp)
 32a:	1000                	addi	s0,sp,32
 32c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 32e:	4581                	li	a1,0
 330:	00000097          	auipc	ra,0x0
 334:	170080e7          	jalr	368(ra) # 4a0 <open>
  if(fd < 0)
 338:	02054563          	bltz	a0,362 <stat+0x42>
 33c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 33e:	85ca                	mv	a1,s2
 340:	00000097          	auipc	ra,0x0
 344:	178080e7          	jalr	376(ra) # 4b8 <fstat>
 348:	892a                	mv	s2,a0
  close(fd);
 34a:	8526                	mv	a0,s1
 34c:	00000097          	auipc	ra,0x0
 350:	13c080e7          	jalr	316(ra) # 488 <close>
  return r;
}
 354:	854a                	mv	a0,s2
 356:	60e2                	ld	ra,24(sp)
 358:	6442                	ld	s0,16(sp)
 35a:	64a2                	ld	s1,8(sp)
 35c:	6902                	ld	s2,0(sp)
 35e:	6105                	addi	sp,sp,32
 360:	8082                	ret
    return -1;
 362:	597d                	li	s2,-1
 364:	bfc5                	j	354 <stat+0x34>

0000000000000366 <atoi>:

int
atoi(const char *s)
{
 366:	1141                	addi	sp,sp,-16
 368:	e422                	sd	s0,8(sp)
 36a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 36c:	00054683          	lbu	a3,0(a0)
 370:	fd06879b          	addiw	a5,a3,-48
 374:	0ff7f793          	zext.b	a5,a5
 378:	4625                	li	a2,9
 37a:	02f66863          	bltu	a2,a5,3aa <atoi+0x44>
 37e:	872a                	mv	a4,a0
  n = 0;
 380:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 382:	0705                	addi	a4,a4,1
 384:	0025179b          	slliw	a5,a0,0x2
 388:	9fa9                	addw	a5,a5,a0
 38a:	0017979b          	slliw	a5,a5,0x1
 38e:	9fb5                	addw	a5,a5,a3
 390:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 394:	00074683          	lbu	a3,0(a4)
 398:	fd06879b          	addiw	a5,a3,-48
 39c:	0ff7f793          	zext.b	a5,a5
 3a0:	fef671e3          	bgeu	a2,a5,382 <atoi+0x1c>
  return n;
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret
  n = 0;
 3aa:	4501                	li	a0,0
 3ac:	bfe5                	j	3a4 <atoi+0x3e>

00000000000003ae <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3ae:	1141                	addi	sp,sp,-16
 3b0:	e422                	sd	s0,8(sp)
 3b2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3b4:	02b57463          	bgeu	a0,a1,3dc <memmove+0x2e>
    while(n-- > 0)
 3b8:	00c05f63          	blez	a2,3d6 <memmove+0x28>
 3bc:	1602                	slli	a2,a2,0x20
 3be:	9201                	srli	a2,a2,0x20
 3c0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3c4:	872a                	mv	a4,a0
      *dst++ = *src++;
 3c6:	0585                	addi	a1,a1,1
 3c8:	0705                	addi	a4,a4,1
 3ca:	fff5c683          	lbu	a3,-1(a1)
 3ce:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3d2:	fee79ae3          	bne	a5,a4,3c6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3d6:	6422                	ld	s0,8(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret
    dst += n;
 3dc:	00c50733          	add	a4,a0,a2
    src += n;
 3e0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3e2:	fec05ae3          	blez	a2,3d6 <memmove+0x28>
 3e6:	fff6079b          	addiw	a5,a2,-1
 3ea:	1782                	slli	a5,a5,0x20
 3ec:	9381                	srli	a5,a5,0x20
 3ee:	fff7c793          	not	a5,a5
 3f2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3f4:	15fd                	addi	a1,a1,-1
 3f6:	177d                	addi	a4,a4,-1
 3f8:	0005c683          	lbu	a3,0(a1)
 3fc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 400:	fee79ae3          	bne	a5,a4,3f4 <memmove+0x46>
 404:	bfc9                	j	3d6 <memmove+0x28>

0000000000000406 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 406:	1141                	addi	sp,sp,-16
 408:	e422                	sd	s0,8(sp)
 40a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 40c:	ca05                	beqz	a2,43c <memcmp+0x36>
 40e:	fff6069b          	addiw	a3,a2,-1
 412:	1682                	slli	a3,a3,0x20
 414:	9281                	srli	a3,a3,0x20
 416:	0685                	addi	a3,a3,1
 418:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 41a:	00054783          	lbu	a5,0(a0)
 41e:	0005c703          	lbu	a4,0(a1)
 422:	00e79863          	bne	a5,a4,432 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 426:	0505                	addi	a0,a0,1
    p2++;
 428:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 42a:	fed518e3          	bne	a0,a3,41a <memcmp+0x14>
  }
  return 0;
 42e:	4501                	li	a0,0
 430:	a019                	j	436 <memcmp+0x30>
      return *p1 - *p2;
 432:	40e7853b          	subw	a0,a5,a4
}
 436:	6422                	ld	s0,8(sp)
 438:	0141                	addi	sp,sp,16
 43a:	8082                	ret
  return 0;
 43c:	4501                	li	a0,0
 43e:	bfe5                	j	436 <memcmp+0x30>

0000000000000440 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 440:	1141                	addi	sp,sp,-16
 442:	e406                	sd	ra,8(sp)
 444:	e022                	sd	s0,0(sp)
 446:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 448:	00000097          	auipc	ra,0x0
 44c:	f66080e7          	jalr	-154(ra) # 3ae <memmove>
}
 450:	60a2                	ld	ra,8(sp)
 452:	6402                	ld	s0,0(sp)
 454:	0141                	addi	sp,sp,16
 456:	8082                	ret

0000000000000458 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 458:	4885                	li	a7,1
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <exit>:
.global exit
exit:
 li a7, SYS_exit
 460:	4889                	li	a7,2
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <wait>:
.global wait
wait:
 li a7, SYS_wait
 468:	488d                	li	a7,3
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 470:	4891                	li	a7,4
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <read>:
.global read
read:
 li a7, SYS_read
 478:	4895                	li	a7,5
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <write>:
.global write
write:
 li a7, SYS_write
 480:	48c1                	li	a7,16
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <close>:
.global close
close:
 li a7, SYS_close
 488:	48d5                	li	a7,21
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <kill>:
.global kill
kill:
 li a7, SYS_kill
 490:	4899                	li	a7,6
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <exec>:
.global exec
exec:
 li a7, SYS_exec
 498:	489d                	li	a7,7
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <open>:
.global open
open:
 li a7, SYS_open
 4a0:	48bd                	li	a7,15
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4a8:	48c5                	li	a7,17
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4b0:	48c9                	li	a7,18
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4b8:	48a1                	li	a7,8
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <link>:
.global link
link:
 li a7, SYS_link
 4c0:	48cd                	li	a7,19
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4c8:	48d1                	li	a7,20
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4d0:	48a5                	li	a7,9
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4d8:	48a9                	li	a7,10
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4e0:	48ad                	li	a7,11
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4e8:	48b1                	li	a7,12
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4f0:	48b5                	li	a7,13
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4f8:	48b9                	li	a7,14
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 500:	1101                	addi	sp,sp,-32
 502:	ec06                	sd	ra,24(sp)
 504:	e822                	sd	s0,16(sp)
 506:	1000                	addi	s0,sp,32
 508:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 50c:	4605                	li	a2,1
 50e:	fef40593          	addi	a1,s0,-17
 512:	00000097          	auipc	ra,0x0
 516:	f6e080e7          	jalr	-146(ra) # 480 <write>
}
 51a:	60e2                	ld	ra,24(sp)
 51c:	6442                	ld	s0,16(sp)
 51e:	6105                	addi	sp,sp,32
 520:	8082                	ret

0000000000000522 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 522:	7139                	addi	sp,sp,-64
 524:	fc06                	sd	ra,56(sp)
 526:	f822                	sd	s0,48(sp)
 528:	f426                	sd	s1,40(sp)
 52a:	f04a                	sd	s2,32(sp)
 52c:	ec4e                	sd	s3,24(sp)
 52e:	0080                	addi	s0,sp,64
 530:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 532:	c299                	beqz	a3,538 <printint+0x16>
 534:	0805c963          	bltz	a1,5c6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 538:	2581                	sext.w	a1,a1
  neg = 0;
 53a:	4881                	li	a7,0
 53c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 540:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 542:	2601                	sext.w	a2,a2
 544:	00000517          	auipc	a0,0x0
 548:	50450513          	addi	a0,a0,1284 # a48 <digits>
 54c:	883a                	mv	a6,a4
 54e:	2705                	addiw	a4,a4,1
 550:	02c5f7bb          	remuw	a5,a1,a2
 554:	1782                	slli	a5,a5,0x20
 556:	9381                	srli	a5,a5,0x20
 558:	97aa                	add	a5,a5,a0
 55a:	0007c783          	lbu	a5,0(a5)
 55e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 562:	0005879b          	sext.w	a5,a1
 566:	02c5d5bb          	divuw	a1,a1,a2
 56a:	0685                	addi	a3,a3,1
 56c:	fec7f0e3          	bgeu	a5,a2,54c <printint+0x2a>
  if(neg)
 570:	00088c63          	beqz	a7,588 <printint+0x66>
    buf[i++] = '-';
 574:	fd070793          	addi	a5,a4,-48
 578:	00878733          	add	a4,a5,s0
 57c:	02d00793          	li	a5,45
 580:	fef70823          	sb	a5,-16(a4)
 584:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 588:	02e05863          	blez	a4,5b8 <printint+0x96>
 58c:	fc040793          	addi	a5,s0,-64
 590:	00e78933          	add	s2,a5,a4
 594:	fff78993          	addi	s3,a5,-1
 598:	99ba                	add	s3,s3,a4
 59a:	377d                	addiw	a4,a4,-1
 59c:	1702                	slli	a4,a4,0x20
 59e:	9301                	srli	a4,a4,0x20
 5a0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5a4:	fff94583          	lbu	a1,-1(s2)
 5a8:	8526                	mv	a0,s1
 5aa:	00000097          	auipc	ra,0x0
 5ae:	f56080e7          	jalr	-170(ra) # 500 <putc>
  while(--i >= 0)
 5b2:	197d                	addi	s2,s2,-1
 5b4:	ff3918e3          	bne	s2,s3,5a4 <printint+0x82>
}
 5b8:	70e2                	ld	ra,56(sp)
 5ba:	7442                	ld	s0,48(sp)
 5bc:	74a2                	ld	s1,40(sp)
 5be:	7902                	ld	s2,32(sp)
 5c0:	69e2                	ld	s3,24(sp)
 5c2:	6121                	addi	sp,sp,64
 5c4:	8082                	ret
    x = -xx;
 5c6:	40b005bb          	negw	a1,a1
    neg = 1;
 5ca:	4885                	li	a7,1
    x = -xx;
 5cc:	bf85                	j	53c <printint+0x1a>

00000000000005ce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ce:	7119                	addi	sp,sp,-128
 5d0:	fc86                	sd	ra,120(sp)
 5d2:	f8a2                	sd	s0,112(sp)
 5d4:	f4a6                	sd	s1,104(sp)
 5d6:	f0ca                	sd	s2,96(sp)
 5d8:	ecce                	sd	s3,88(sp)
 5da:	e8d2                	sd	s4,80(sp)
 5dc:	e4d6                	sd	s5,72(sp)
 5de:	e0da                	sd	s6,64(sp)
 5e0:	fc5e                	sd	s7,56(sp)
 5e2:	f862                	sd	s8,48(sp)
 5e4:	f466                	sd	s9,40(sp)
 5e6:	f06a                	sd	s10,32(sp)
 5e8:	ec6e                	sd	s11,24(sp)
 5ea:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ec:	0005c903          	lbu	s2,0(a1)
 5f0:	18090f63          	beqz	s2,78e <vprintf+0x1c0>
 5f4:	8aaa                	mv	s5,a0
 5f6:	8b32                	mv	s6,a2
 5f8:	00158493          	addi	s1,a1,1
  state = 0;
 5fc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5fe:	02500a13          	li	s4,37
 602:	4c55                	li	s8,21
 604:	00000c97          	auipc	s9,0x0
 608:	3ecc8c93          	addi	s9,s9,1004 # 9f0 <malloc+0x15e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 60c:	02800d93          	li	s11,40
  putc(fd, 'x');
 610:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 612:	00000b97          	auipc	s7,0x0
 616:	436b8b93          	addi	s7,s7,1078 # a48 <digits>
 61a:	a839                	j	638 <vprintf+0x6a>
        putc(fd, c);
 61c:	85ca                	mv	a1,s2
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	ee0080e7          	jalr	-288(ra) # 500 <putc>
 628:	a019                	j	62e <vprintf+0x60>
    } else if(state == '%'){
 62a:	01498d63          	beq	s3,s4,644 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 62e:	0485                	addi	s1,s1,1
 630:	fff4c903          	lbu	s2,-1(s1)
 634:	14090d63          	beqz	s2,78e <vprintf+0x1c0>
    if(state == 0){
 638:	fe0999e3          	bnez	s3,62a <vprintf+0x5c>
      if(c == '%'){
 63c:	ff4910e3          	bne	s2,s4,61c <vprintf+0x4e>
        state = '%';
 640:	89d2                	mv	s3,s4
 642:	b7f5                	j	62e <vprintf+0x60>
      if(c == 'd'){
 644:	11490c63          	beq	s2,s4,75c <vprintf+0x18e>
 648:	f9d9079b          	addiw	a5,s2,-99
 64c:	0ff7f793          	zext.b	a5,a5
 650:	10fc6e63          	bltu	s8,a5,76c <vprintf+0x19e>
 654:	f9d9079b          	addiw	a5,s2,-99
 658:	0ff7f713          	zext.b	a4,a5
 65c:	10ec6863          	bltu	s8,a4,76c <vprintf+0x19e>
 660:	00271793          	slli	a5,a4,0x2
 664:	97e6                	add	a5,a5,s9
 666:	439c                	lw	a5,0(a5)
 668:	97e6                	add	a5,a5,s9
 66a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 66c:	008b0913          	addi	s2,s6,8
 670:	4685                	li	a3,1
 672:	4629                	li	a2,10
 674:	000b2583          	lw	a1,0(s6)
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	ea8080e7          	jalr	-344(ra) # 522 <printint>
 682:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 684:	4981                	li	s3,0
 686:	b765                	j	62e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	008b0913          	addi	s2,s6,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000b2583          	lw	a1,0(s6)
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	e8c080e7          	jalr	-372(ra) # 522 <printint>
 69e:	8b4a                	mv	s6,s2
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	b771                	j	62e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6a4:	008b0913          	addi	s2,s6,8
 6a8:	4681                	li	a3,0
 6aa:	866a                	mv	a2,s10
 6ac:	000b2583          	lw	a1,0(s6)
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	e70080e7          	jalr	-400(ra) # 522 <printint>
 6ba:	8b4a                	mv	s6,s2
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bf85                	j	62e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6c0:	008b0793          	addi	a5,s6,8
 6c4:	f8f43423          	sd	a5,-120(s0)
 6c8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6cc:	03000593          	li	a1,48
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	e2e080e7          	jalr	-466(ra) # 500 <putc>
  putc(fd, 'x');
 6da:	07800593          	li	a1,120
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e20080e7          	jalr	-480(ra) # 500 <putc>
 6e8:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ea:	03c9d793          	srli	a5,s3,0x3c
 6ee:	97de                	add	a5,a5,s7
 6f0:	0007c583          	lbu	a1,0(a5)
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e0a080e7          	jalr	-502(ra) # 500 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fe:	0992                	slli	s3,s3,0x4
 700:	397d                	addiw	s2,s2,-1
 702:	fe0914e3          	bnez	s2,6ea <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 706:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 70a:	4981                	li	s3,0
 70c:	b70d                	j	62e <vprintf+0x60>
        s = va_arg(ap, char*);
 70e:	008b0913          	addi	s2,s6,8
 712:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 716:	02098163          	beqz	s3,738 <vprintf+0x16a>
        while(*s != 0){
 71a:	0009c583          	lbu	a1,0(s3)
 71e:	c5ad                	beqz	a1,788 <vprintf+0x1ba>
          putc(fd, *s);
 720:	8556                	mv	a0,s5
 722:	00000097          	auipc	ra,0x0
 726:	dde080e7          	jalr	-546(ra) # 500 <putc>
          s++;
 72a:	0985                	addi	s3,s3,1
        while(*s != 0){
 72c:	0009c583          	lbu	a1,0(s3)
 730:	f9e5                	bnez	a1,720 <vprintf+0x152>
        s = va_arg(ap, char*);
 732:	8b4a                	mv	s6,s2
      state = 0;
 734:	4981                	li	s3,0
 736:	bde5                	j	62e <vprintf+0x60>
          s = "(null)";
 738:	00000997          	auipc	s3,0x0
 73c:	2b098993          	addi	s3,s3,688 # 9e8 <malloc+0x156>
        while(*s != 0){
 740:	85ee                	mv	a1,s11
 742:	bff9                	j	720 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 744:	008b0913          	addi	s2,s6,8
 748:	000b4583          	lbu	a1,0(s6)
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	db2080e7          	jalr	-590(ra) # 500 <putc>
 756:	8b4a                	mv	s6,s2
      state = 0;
 758:	4981                	li	s3,0
 75a:	bdd1                	j	62e <vprintf+0x60>
        putc(fd, c);
 75c:	85d2                	mv	a1,s4
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	da0080e7          	jalr	-608(ra) # 500 <putc>
      state = 0;
 768:	4981                	li	s3,0
 76a:	b5d1                	j	62e <vprintf+0x60>
        putc(fd, '%');
 76c:	85d2                	mv	a1,s4
 76e:	8556                	mv	a0,s5
 770:	00000097          	auipc	ra,0x0
 774:	d90080e7          	jalr	-624(ra) # 500 <putc>
        putc(fd, c);
 778:	85ca                	mv	a1,s2
 77a:	8556                	mv	a0,s5
 77c:	00000097          	auipc	ra,0x0
 780:	d84080e7          	jalr	-636(ra) # 500 <putc>
      state = 0;
 784:	4981                	li	s3,0
 786:	b565                	j	62e <vprintf+0x60>
        s = va_arg(ap, char*);
 788:	8b4a                	mv	s6,s2
      state = 0;
 78a:	4981                	li	s3,0
 78c:	b54d                	j	62e <vprintf+0x60>
    }
  }
}
 78e:	70e6                	ld	ra,120(sp)
 790:	7446                	ld	s0,112(sp)
 792:	74a6                	ld	s1,104(sp)
 794:	7906                	ld	s2,96(sp)
 796:	69e6                	ld	s3,88(sp)
 798:	6a46                	ld	s4,80(sp)
 79a:	6aa6                	ld	s5,72(sp)
 79c:	6b06                	ld	s6,64(sp)
 79e:	7be2                	ld	s7,56(sp)
 7a0:	7c42                	ld	s8,48(sp)
 7a2:	7ca2                	ld	s9,40(sp)
 7a4:	7d02                	ld	s10,32(sp)
 7a6:	6de2                	ld	s11,24(sp)
 7a8:	6109                	addi	sp,sp,128
 7aa:	8082                	ret

00000000000007ac <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ac:	715d                	addi	sp,sp,-80
 7ae:	ec06                	sd	ra,24(sp)
 7b0:	e822                	sd	s0,16(sp)
 7b2:	1000                	addi	s0,sp,32
 7b4:	e010                	sd	a2,0(s0)
 7b6:	e414                	sd	a3,8(s0)
 7b8:	e818                	sd	a4,16(s0)
 7ba:	ec1c                	sd	a5,24(s0)
 7bc:	03043023          	sd	a6,32(s0)
 7c0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c8:	8622                	mv	a2,s0
 7ca:	00000097          	auipc	ra,0x0
 7ce:	e04080e7          	jalr	-508(ra) # 5ce <vprintf>
}
 7d2:	60e2                	ld	ra,24(sp)
 7d4:	6442                	ld	s0,16(sp)
 7d6:	6161                	addi	sp,sp,80
 7d8:	8082                	ret

00000000000007da <printf>:

void
printf(const char *fmt, ...)
{
 7da:	711d                	addi	sp,sp,-96
 7dc:	ec06                	sd	ra,24(sp)
 7de:	e822                	sd	s0,16(sp)
 7e0:	1000                	addi	s0,sp,32
 7e2:	e40c                	sd	a1,8(s0)
 7e4:	e810                	sd	a2,16(s0)
 7e6:	ec14                	sd	a3,24(s0)
 7e8:	f018                	sd	a4,32(s0)
 7ea:	f41c                	sd	a5,40(s0)
 7ec:	03043823          	sd	a6,48(s0)
 7f0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f4:	00840613          	addi	a2,s0,8
 7f8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7fc:	85aa                	mv	a1,a0
 7fe:	4505                	li	a0,1
 800:	00000097          	auipc	ra,0x0
 804:	dce080e7          	jalr	-562(ra) # 5ce <vprintf>
}
 808:	60e2                	ld	ra,24(sp)
 80a:	6442                	ld	s0,16(sp)
 80c:	6125                	addi	sp,sp,96
 80e:	8082                	ret

0000000000000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	1141                	addi	sp,sp,-16
 812:	e422                	sd	s0,8(sp)
 814:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 816:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	00000797          	auipc	a5,0x0
 81e:	24e7b783          	ld	a5,590(a5) # a68 <freep>
 822:	a02d                	j	84c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 824:	4618                	lw	a4,8(a2)
 826:	9f2d                	addw	a4,a4,a1
 828:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 82c:	6398                	ld	a4,0(a5)
 82e:	6310                	ld	a2,0(a4)
 830:	a83d                	j	86e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 832:	ff852703          	lw	a4,-8(a0)
 836:	9f31                	addw	a4,a4,a2
 838:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83a:	ff053683          	ld	a3,-16(a0)
 83e:	a091                	j	882 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	6398                	ld	a4,0(a5)
 842:	00e7e463          	bltu	a5,a4,84a <free+0x3a>
 846:	00e6ea63          	bltu	a3,a4,85a <free+0x4a>
{
 84a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84c:	fed7fae3          	bgeu	a5,a3,840 <free+0x30>
 850:	6398                	ld	a4,0(a5)
 852:	00e6e463          	bltu	a3,a4,85a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	fee7eae3          	bltu	a5,a4,84a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 85a:	ff852583          	lw	a1,-8(a0)
 85e:	6390                	ld	a2,0(a5)
 860:	02059813          	slli	a6,a1,0x20
 864:	01c85713          	srli	a4,a6,0x1c
 868:	9736                	add	a4,a4,a3
 86a:	fae60de3          	beq	a2,a4,824 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 872:	4790                	lw	a2,8(a5)
 874:	02061593          	slli	a1,a2,0x20
 878:	01c5d713          	srli	a4,a1,0x1c
 87c:	973e                	add	a4,a4,a5
 87e:	fae68ae3          	beq	a3,a4,832 <free+0x22>
    p->s.ptr = bp->s.ptr;
 882:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 884:	00000717          	auipc	a4,0x0
 888:	1ef73223          	sd	a5,484(a4) # a68 <freep>
}
 88c:	6422                	ld	s0,8(sp)
 88e:	0141                	addi	sp,sp,16
 890:	8082                	ret

0000000000000892 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 892:	7139                	addi	sp,sp,-64
 894:	fc06                	sd	ra,56(sp)
 896:	f822                	sd	s0,48(sp)
 898:	f426                	sd	s1,40(sp)
 89a:	f04a                	sd	s2,32(sp)
 89c:	ec4e                	sd	s3,24(sp)
 89e:	e852                	sd	s4,16(sp)
 8a0:	e456                	sd	s5,8(sp)
 8a2:	e05a                	sd	s6,0(sp)
 8a4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a6:	02051493          	slli	s1,a0,0x20
 8aa:	9081                	srli	s1,s1,0x20
 8ac:	04bd                	addi	s1,s1,15
 8ae:	8091                	srli	s1,s1,0x4
 8b0:	0014899b          	addiw	s3,s1,1
 8b4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b6:	00000517          	auipc	a0,0x0
 8ba:	1b253503          	ld	a0,434(a0) # a68 <freep>
 8be:	c515                	beqz	a0,8ea <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c2:	4798                	lw	a4,8(a5)
 8c4:	02977f63          	bgeu	a4,s1,902 <malloc+0x70>
 8c8:	8a4e                	mv	s4,s3
 8ca:	0009871b          	sext.w	a4,s3
 8ce:	6685                	lui	a3,0x1
 8d0:	00d77363          	bgeu	a4,a3,8d6 <malloc+0x44>
 8d4:	6a05                	lui	s4,0x1
 8d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8de:	00000917          	auipc	s2,0x0
 8e2:	18a90913          	addi	s2,s2,394 # a68 <freep>
  if(p == (char*)-1)
 8e6:	5afd                	li	s5,-1
 8e8:	a895                	j	95c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8ea:	00000797          	auipc	a5,0x0
 8ee:	18678793          	addi	a5,a5,390 # a70 <base>
 8f2:	00000717          	auipc	a4,0x0
 8f6:	16f73b23          	sd	a5,374(a4) # a68 <freep>
 8fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 900:	b7e1                	j	8c8 <malloc+0x36>
      if(p->s.size == nunits)
 902:	02e48c63          	beq	s1,a4,93a <malloc+0xa8>
        p->s.size -= nunits;
 906:	4137073b          	subw	a4,a4,s3
 90a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90c:	02071693          	slli	a3,a4,0x20
 910:	01c6d713          	srli	a4,a3,0x1c
 914:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 916:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 91a:	00000717          	auipc	a4,0x0
 91e:	14a73723          	sd	a0,334(a4) # a68 <freep>
      return (void*)(p + 1);
 922:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 926:	70e2                	ld	ra,56(sp)
 928:	7442                	ld	s0,48(sp)
 92a:	74a2                	ld	s1,40(sp)
 92c:	7902                	ld	s2,32(sp)
 92e:	69e2                	ld	s3,24(sp)
 930:	6a42                	ld	s4,16(sp)
 932:	6aa2                	ld	s5,8(sp)
 934:	6b02                	ld	s6,0(sp)
 936:	6121                	addi	sp,sp,64
 938:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 93a:	6398                	ld	a4,0(a5)
 93c:	e118                	sd	a4,0(a0)
 93e:	bff1                	j	91a <malloc+0x88>
  hp->s.size = nu;
 940:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 944:	0541                	addi	a0,a0,16
 946:	00000097          	auipc	ra,0x0
 94a:	eca080e7          	jalr	-310(ra) # 810 <free>
  return freep;
 94e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 952:	d971                	beqz	a0,926 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 954:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 956:	4798                	lw	a4,8(a5)
 958:	fa9775e3          	bgeu	a4,s1,902 <malloc+0x70>
    if(p == freep)
 95c:	00093703          	ld	a4,0(s2)
 960:	853e                	mv	a0,a5
 962:	fef719e3          	bne	a4,a5,954 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 966:	8552                	mv	a0,s4
 968:	00000097          	auipc	ra,0x0
 96c:	b80080e7          	jalr	-1152(ra) # 4e8 <sbrk>
  if(p == (char*)-1)
 970:	fd5518e3          	bne	a0,s5,940 <malloc+0xae>
        return 0;
 974:	4501                	li	a0,0
 976:	bf45                	j	926 <malloc+0x94>
