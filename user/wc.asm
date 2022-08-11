
user/_wc：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	9dbd8d93          	addi	s11,s11,-1573 # a09 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	908a0a13          	addi	s4,s4,-1784 # 940 <malloc+0xe6>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1e4080e7          	jalr	484(ra) # 22a <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	99258593          	addi	a1,a1,-1646 # a08 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	3ae080e7          	jalr	942(ra) # 430 <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	97a48493          	addi	s1,s1,-1670 # a08 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	8a250513          	addi	a0,a0,-1886 # 958 <malloc+0xfe>
  be:	00000097          	auipc	ra,0x0
  c2:	6e4080e7          	jalr	1764(ra) # 7a2 <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	86450513          	addi	a0,a0,-1948 # 948 <malloc+0xee>
  ec:	00000097          	auipc	ra,0x0
  f0:	6b6080e7          	jalr	1718(ra) # 7a2 <printf>
    exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	322080e7          	jalr	802(ra) # 418 <exit>

00000000000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10e:	4785                	li	a5,1
 110:	04a7d763          	bge	a5,a0,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	02099793          	slli	a5,s3,0x20
 120:	01d7d993          	srli	s3,a5,0x1d
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	32c080e7          	jalr	812(ra) # 458 <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
    close(fd);
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	2fa080e7          	jalr	762(ra) # 440 <close>
  for(i = 1; i < argc; i++){
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
  }
  exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	2c2080e7          	jalr	706(ra) # 418 <exit>
    wc(0, "");
 15e:	00001597          	auipc	a1,0x1
 162:	80a58593          	addi	a1,a1,-2038 # 968 <malloc+0x10e>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
    exit(0);
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	2a6080e7          	jalr	678(ra) # 418 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 17a:	608c                	ld	a1,0(s1)
 17c:	00000517          	auipc	a0,0x0
 180:	7f450513          	addi	a0,a0,2036 # 970 <malloc+0x116>
 184:	00000097          	auipc	ra,0x0
 188:	61e080e7          	jalr	1566(ra) # 7a2 <printf>
      exit(1);
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	28a080e7          	jalr	650(ra) # 418 <exit>

0000000000000196 <strcpy>:



char*
strcpy(char *s, const char *t)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 19c:	87aa                	mv	a5,a0
 19e:	0585                	addi	a1,a1,1
 1a0:	0785                	addi	a5,a5,1
 1a2:	fff5c703          	lbu	a4,-1(a1)
 1a6:	fee78fa3          	sb	a4,-1(a5)
 1aa:	fb75                	bnez	a4,19e <strcpy+0x8>
    ;
  return os;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb91                	beqz	a5,1d0 <strcmp+0x1e>
 1be:	0005c703          	lbu	a4,0(a1)
 1c2:	00f71763          	bne	a4,a5,1d0 <strcmp+0x1e>
    p++, q++;
 1c6:	0505                	addi	a0,a0,1
 1c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbe5                	bnez	a5,1be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d0:	0005c503          	lbu	a0,0(a1)
}
 1d4:	40a7853b          	subw	a0,a5,a0
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret

00000000000001de <strlen>:

uint
strlen(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cf91                	beqz	a5,204 <strlen+0x26>
 1ea:	0505                	addi	a0,a0,1
 1ec:	87aa                	mv	a5,a0
 1ee:	4685                	li	a3,1
 1f0:	9e89                	subw	a3,a3,a0
 1f2:	00f6853b          	addw	a0,a3,a5
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	fb7d                	bnez	a4,1f2 <strlen+0x14>
    ;
  return n;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
  for(n = 0; s[n]; n++)
 204:	4501                	li	a0,0
 206:	bfe5                	j	1fe <strlen+0x20>

0000000000000208 <memset>:

void*
memset(void *dst, int c, uint n)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 20e:	ca19                	beqz	a2,224 <memset+0x1c>
 210:	87aa                	mv	a5,a0
 212:	1602                	slli	a2,a2,0x20
 214:	9201                	srli	a2,a2,0x20
 216:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 21a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 21e:	0785                	addi	a5,a5,1
 220:	fee79de3          	bne	a5,a4,21a <memset+0x12>
  }
  return dst;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret

000000000000022a <strchr>:

char*
strchr(const char *s, char c)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 230:	00054783          	lbu	a5,0(a0)
 234:	cb99                	beqz	a5,24a <strchr+0x20>
    if(*s == c)
 236:	00f58763          	beq	a1,a5,244 <strchr+0x1a>
  for(; *s; s++)
 23a:	0505                	addi	a0,a0,1
 23c:	00054783          	lbu	a5,0(a0)
 240:	fbfd                	bnez	a5,236 <strchr+0xc>
      return (char*)s;
  return 0;
 242:	4501                	li	a0,0
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  return 0;
 24a:	4501                	li	a0,0
 24c:	bfe5                	j	244 <strchr+0x1a>

000000000000024e <gets>:

char*
gets(char *buf, int max)
{
 24e:	711d                	addi	sp,sp,-96
 250:	ec86                	sd	ra,88(sp)
 252:	e8a2                	sd	s0,80(sp)
 254:	e4a6                	sd	s1,72(sp)
 256:	e0ca                	sd	s2,64(sp)
 258:	fc4e                	sd	s3,56(sp)
 25a:	f852                	sd	s4,48(sp)
 25c:	f456                	sd	s5,40(sp)
 25e:	f05a                	sd	s6,32(sp)
 260:	ec5e                	sd	s7,24(sp)
 262:	1080                	addi	s0,sp,96
 264:	8baa                	mv	s7,a0
 266:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 268:	892a                	mv	s2,a0
 26a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 26c:	4aa9                	li	s5,10
 26e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 270:	89a6                	mv	s3,s1
 272:	2485                	addiw	s1,s1,1
 274:	0344d863          	bge	s1,s4,2a4 <gets+0x56>
    cc = read(0, &c, 1);
 278:	4605                	li	a2,1
 27a:	faf40593          	addi	a1,s0,-81
 27e:	4501                	li	a0,0
 280:	00000097          	auipc	ra,0x0
 284:	1b0080e7          	jalr	432(ra) # 430 <read>
    if(cc < 1)
 288:	00a05e63          	blez	a0,2a4 <gets+0x56>
    buf[i++] = c;
 28c:	faf44783          	lbu	a5,-81(s0)
 290:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 294:	01578763          	beq	a5,s5,2a2 <gets+0x54>
 298:	0905                	addi	s2,s2,1
 29a:	fd679be3          	bne	a5,s6,270 <gets+0x22>
  for(i=0; i+1 < max; ){
 29e:	89a6                	mv	s3,s1
 2a0:	a011                	j	2a4 <gets+0x56>
 2a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2a4:	99de                	add	s3,s3,s7
 2a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 2aa:	855e                	mv	a0,s7
 2ac:	60e6                	ld	ra,88(sp)
 2ae:	6446                	ld	s0,80(sp)
 2b0:	64a6                	ld	s1,72(sp)
 2b2:	6906                	ld	s2,64(sp)
 2b4:	79e2                	ld	s3,56(sp)
 2b6:	7a42                	ld	s4,48(sp)
 2b8:	7aa2                	ld	s5,40(sp)
 2ba:	7b02                	ld	s6,32(sp)
 2bc:	6be2                	ld	s7,24(sp)
 2be:	6125                	addi	sp,sp,96
 2c0:	8082                	ret

00000000000002c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c2:	1101                	addi	sp,sp,-32
 2c4:	ec06                	sd	ra,24(sp)
 2c6:	e822                	sd	s0,16(sp)
 2c8:	e426                	sd	s1,8(sp)
 2ca:	e04a                	sd	s2,0(sp)
 2cc:	1000                	addi	s0,sp,32
 2ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	4581                	li	a1,0
 2d2:	00000097          	auipc	ra,0x0
 2d6:	186080e7          	jalr	390(ra) # 458 <open>
  if(fd < 0)
 2da:	02054563          	bltz	a0,304 <stat+0x42>
 2de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e0:	85ca                	mv	a1,s2
 2e2:	00000097          	auipc	ra,0x0
 2e6:	18e080e7          	jalr	398(ra) # 470 <fstat>
 2ea:	892a                	mv	s2,a0
  close(fd);
 2ec:	8526                	mv	a0,s1
 2ee:	00000097          	auipc	ra,0x0
 2f2:	152080e7          	jalr	338(ra) # 440 <close>
  return r;
}
 2f6:	854a                	mv	a0,s2
 2f8:	60e2                	ld	ra,24(sp)
 2fa:	6442                	ld	s0,16(sp)
 2fc:	64a2                	ld	s1,8(sp)
 2fe:	6902                	ld	s2,0(sp)
 300:	6105                	addi	sp,sp,32
 302:	8082                	ret
    return -1;
 304:	597d                	li	s2,-1
 306:	bfc5                	j	2f6 <stat+0x34>

0000000000000308 <atoi>:

int
atoi(const char *s)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30e:	00054683          	lbu	a3,0(a0)
 312:	fd06879b          	addiw	a5,a3,-48
 316:	0ff7f793          	zext.b	a5,a5
 31a:	4625                	li	a2,9
 31c:	02f66863          	bltu	a2,a5,34c <atoi+0x44>
 320:	872a                	mv	a4,a0
  n = 0;
 322:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 324:	0705                	addi	a4,a4,1
 326:	0025179b          	slliw	a5,a0,0x2
 32a:	9fa9                	addw	a5,a5,a0
 32c:	0017979b          	slliw	a5,a5,0x1
 330:	9fb5                	addw	a5,a5,a3
 332:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 336:	00074683          	lbu	a3,0(a4)
 33a:	fd06879b          	addiw	a5,a3,-48
 33e:	0ff7f793          	zext.b	a5,a5
 342:	fef671e3          	bgeu	a2,a5,324 <atoi+0x1c>
  return n;
}
 346:	6422                	ld	s0,8(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret
  n = 0;
 34c:	4501                	li	a0,0
 34e:	bfe5                	j	346 <atoi+0x3e>

0000000000000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	1141                	addi	sp,sp,-16
 352:	e422                	sd	s0,8(sp)
 354:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 356:	02b57463          	bgeu	a0,a1,37e <memmove+0x2e>
    while(n-- > 0)
 35a:	00c05f63          	blez	a2,378 <memmove+0x28>
 35e:	1602                	slli	a2,a2,0x20
 360:	9201                	srli	a2,a2,0x20
 362:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 366:	872a                	mv	a4,a0
      *dst++ = *src++;
 368:	0585                	addi	a1,a1,1
 36a:	0705                	addi	a4,a4,1
 36c:	fff5c683          	lbu	a3,-1(a1)
 370:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 374:	fee79ae3          	bne	a5,a4,368 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
    dst += n;
 37e:	00c50733          	add	a4,a0,a2
    src += n;
 382:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 384:	fec05ae3          	blez	a2,378 <memmove+0x28>
 388:	fff6079b          	addiw	a5,a2,-1
 38c:	1782                	slli	a5,a5,0x20
 38e:	9381                	srli	a5,a5,0x20
 390:	fff7c793          	not	a5,a5
 394:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 396:	15fd                	addi	a1,a1,-1
 398:	177d                	addi	a4,a4,-1
 39a:	0005c683          	lbu	a3,0(a1)
 39e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3a2:	fee79ae3          	bne	a5,a4,396 <memmove+0x46>
 3a6:	bfc9                	j	378 <memmove+0x28>

00000000000003a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e422                	sd	s0,8(sp)
 3ac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3ae:	ca05                	beqz	a2,3de <memcmp+0x36>
 3b0:	fff6069b          	addiw	a3,a2,-1
 3b4:	1682                	slli	a3,a3,0x20
 3b6:	9281                	srli	a3,a3,0x20
 3b8:	0685                	addi	a3,a3,1
 3ba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3bc:	00054783          	lbu	a5,0(a0)
 3c0:	0005c703          	lbu	a4,0(a1)
 3c4:	00e79863          	bne	a5,a4,3d4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3c8:	0505                	addi	a0,a0,1
    p2++;
 3ca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3cc:	fed518e3          	bne	a0,a3,3bc <memcmp+0x14>
  }
  return 0;
 3d0:	4501                	li	a0,0
 3d2:	a019                	j	3d8 <memcmp+0x30>
      return *p1 - *p2;
 3d4:	40e7853b          	subw	a0,a5,a4
}
 3d8:	6422                	ld	s0,8(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret
  return 0;
 3de:	4501                	li	a0,0
 3e0:	bfe5                	j	3d8 <memcmp+0x30>

00000000000003e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3e2:	1141                	addi	sp,sp,-16
 3e4:	e406                	sd	ra,8(sp)
 3e6:	e022                	sd	s0,0(sp)
 3e8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ea:	00000097          	auipc	ra,0x0
 3ee:	f66080e7          	jalr	-154(ra) # 350 <memmove>
}
 3f2:	60a2                	ld	ra,8(sp)
 3f4:	6402                	ld	s0,0(sp)
 3f6:	0141                	addi	sp,sp,16
 3f8:	8082                	ret

00000000000003fa <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 3fa:	1141                	addi	sp,sp,-16
 3fc:	e422                	sd	s0,8(sp)
 3fe:	0800                	addi	s0,sp,16
  struct usyscall* u = (struct usyscall *)USYSCALL;
  return u->pid;
 400:	040007b7          	lui	a5,0x4000
}
 404:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffee04>
 406:	07b2                	slli	a5,a5,0xc
 408:	4388                	lw	a0,0(a5)
 40a:	6422                	ld	s0,8(sp)
 40c:	0141                	addi	sp,sp,16
 40e:	8082                	ret

0000000000000410 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 410:	4885                	li	a7,1
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <exit>:
.global exit
exit:
 li a7, SYS_exit
 418:	4889                	li	a7,2
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <wait>:
.global wait
wait:
 li a7, SYS_wait
 420:	488d                	li	a7,3
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 428:	4891                	li	a7,4
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <read>:
.global read
read:
 li a7, SYS_read
 430:	4895                	li	a7,5
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <write>:
.global write
write:
 li a7, SYS_write
 438:	48c1                	li	a7,16
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <close>:
.global close
close:
 li a7, SYS_close
 440:	48d5                	li	a7,21
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <kill>:
.global kill
kill:
 li a7, SYS_kill
 448:	4899                	li	a7,6
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <exec>:
.global exec
exec:
 li a7, SYS_exec
 450:	489d                	li	a7,7
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <open>:
.global open
open:
 li a7, SYS_open
 458:	48bd                	li	a7,15
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 460:	48c5                	li	a7,17
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 468:	48c9                	li	a7,18
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 470:	48a1                	li	a7,8
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <link>:
.global link
link:
 li a7, SYS_link
 478:	48cd                	li	a7,19
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 480:	48d1                	li	a7,20
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 488:	48a5                	li	a7,9
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <dup>:
.global dup
dup:
 li a7, SYS_dup
 490:	48a9                	li	a7,10
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 498:	48ad                	li	a7,11
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4a0:	48b1                	li	a7,12
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a8:	48b5                	li	a7,13
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4b0:	48b9                	li	a7,14
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4b8:	48f5                	li	a7,29
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4c0:	48f9                	li	a7,30
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4c8:	1101                	addi	sp,sp,-32
 4ca:	ec06                	sd	ra,24(sp)
 4cc:	e822                	sd	s0,16(sp)
 4ce:	1000                	addi	s0,sp,32
 4d0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4d4:	4605                	li	a2,1
 4d6:	fef40593          	addi	a1,s0,-17
 4da:	00000097          	auipc	ra,0x0
 4de:	f5e080e7          	jalr	-162(ra) # 438 <write>
}
 4e2:	60e2                	ld	ra,24(sp)
 4e4:	6442                	ld	s0,16(sp)
 4e6:	6105                	addi	sp,sp,32
 4e8:	8082                	ret

00000000000004ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ea:	7139                	addi	sp,sp,-64
 4ec:	fc06                	sd	ra,56(sp)
 4ee:	f822                	sd	s0,48(sp)
 4f0:	f426                	sd	s1,40(sp)
 4f2:	f04a                	sd	s2,32(sp)
 4f4:	ec4e                	sd	s3,24(sp)
 4f6:	0080                	addi	s0,sp,64
 4f8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4fa:	c299                	beqz	a3,500 <printint+0x16>
 4fc:	0805c963          	bltz	a1,58e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 500:	2581                	sext.w	a1,a1
  neg = 0;
 502:	4881                	li	a7,0
 504:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 508:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 50a:	2601                	sext.w	a2,a2
 50c:	00000517          	auipc	a0,0x0
 510:	4dc50513          	addi	a0,a0,1244 # 9e8 <digits>
 514:	883a                	mv	a6,a4
 516:	2705                	addiw	a4,a4,1
 518:	02c5f7bb          	remuw	a5,a1,a2
 51c:	1782                	slli	a5,a5,0x20
 51e:	9381                	srli	a5,a5,0x20
 520:	97aa                	add	a5,a5,a0
 522:	0007c783          	lbu	a5,0(a5)
 526:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 52a:	0005879b          	sext.w	a5,a1
 52e:	02c5d5bb          	divuw	a1,a1,a2
 532:	0685                	addi	a3,a3,1
 534:	fec7f0e3          	bgeu	a5,a2,514 <printint+0x2a>
  if(neg)
 538:	00088c63          	beqz	a7,550 <printint+0x66>
    buf[i++] = '-';
 53c:	fd070793          	addi	a5,a4,-48
 540:	00878733          	add	a4,a5,s0
 544:	02d00793          	li	a5,45
 548:	fef70823          	sb	a5,-16(a4)
 54c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 550:	02e05863          	blez	a4,580 <printint+0x96>
 554:	fc040793          	addi	a5,s0,-64
 558:	00e78933          	add	s2,a5,a4
 55c:	fff78993          	addi	s3,a5,-1
 560:	99ba                	add	s3,s3,a4
 562:	377d                	addiw	a4,a4,-1
 564:	1702                	slli	a4,a4,0x20
 566:	9301                	srli	a4,a4,0x20
 568:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 56c:	fff94583          	lbu	a1,-1(s2)
 570:	8526                	mv	a0,s1
 572:	00000097          	auipc	ra,0x0
 576:	f56080e7          	jalr	-170(ra) # 4c8 <putc>
  while(--i >= 0)
 57a:	197d                	addi	s2,s2,-1
 57c:	ff3918e3          	bne	s2,s3,56c <printint+0x82>
}
 580:	70e2                	ld	ra,56(sp)
 582:	7442                	ld	s0,48(sp)
 584:	74a2                	ld	s1,40(sp)
 586:	7902                	ld	s2,32(sp)
 588:	69e2                	ld	s3,24(sp)
 58a:	6121                	addi	sp,sp,64
 58c:	8082                	ret
    x = -xx;
 58e:	40b005bb          	negw	a1,a1
    neg = 1;
 592:	4885                	li	a7,1
    x = -xx;
 594:	bf85                	j	504 <printint+0x1a>

0000000000000596 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 596:	7119                	addi	sp,sp,-128
 598:	fc86                	sd	ra,120(sp)
 59a:	f8a2                	sd	s0,112(sp)
 59c:	f4a6                	sd	s1,104(sp)
 59e:	f0ca                	sd	s2,96(sp)
 5a0:	ecce                	sd	s3,88(sp)
 5a2:	e8d2                	sd	s4,80(sp)
 5a4:	e4d6                	sd	s5,72(sp)
 5a6:	e0da                	sd	s6,64(sp)
 5a8:	fc5e                	sd	s7,56(sp)
 5aa:	f862                	sd	s8,48(sp)
 5ac:	f466                	sd	s9,40(sp)
 5ae:	f06a                	sd	s10,32(sp)
 5b0:	ec6e                	sd	s11,24(sp)
 5b2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5b4:	0005c903          	lbu	s2,0(a1)
 5b8:	18090f63          	beqz	s2,756 <vprintf+0x1c0>
 5bc:	8aaa                	mv	s5,a0
 5be:	8b32                	mv	s6,a2
 5c0:	00158493          	addi	s1,a1,1
  state = 0;
 5c4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5c6:	02500a13          	li	s4,37
 5ca:	4c55                	li	s8,21
 5cc:	00000c97          	auipc	s9,0x0
 5d0:	3c4c8c93          	addi	s9,s9,964 # 990 <malloc+0x136>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d4:	02800d93          	li	s11,40
  putc(fd, 'x');
 5d8:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5da:	00000b97          	auipc	s7,0x0
 5de:	40eb8b93          	addi	s7,s7,1038 # 9e8 <digits>
 5e2:	a839                	j	600 <vprintf+0x6a>
        putc(fd, c);
 5e4:	85ca                	mv	a1,s2
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	ee0080e7          	jalr	-288(ra) # 4c8 <putc>
 5f0:	a019                	j	5f6 <vprintf+0x60>
    } else if(state == '%'){
 5f2:	01498d63          	beq	s3,s4,60c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 5f6:	0485                	addi	s1,s1,1
 5f8:	fff4c903          	lbu	s2,-1(s1)
 5fc:	14090d63          	beqz	s2,756 <vprintf+0x1c0>
    if(state == 0){
 600:	fe0999e3          	bnez	s3,5f2 <vprintf+0x5c>
      if(c == '%'){
 604:	ff4910e3          	bne	s2,s4,5e4 <vprintf+0x4e>
        state = '%';
 608:	89d2                	mv	s3,s4
 60a:	b7f5                	j	5f6 <vprintf+0x60>
      if(c == 'd'){
 60c:	11490c63          	beq	s2,s4,724 <vprintf+0x18e>
 610:	f9d9079b          	addiw	a5,s2,-99
 614:	0ff7f793          	zext.b	a5,a5
 618:	10fc6e63          	bltu	s8,a5,734 <vprintf+0x19e>
 61c:	f9d9079b          	addiw	a5,s2,-99
 620:	0ff7f713          	zext.b	a4,a5
 624:	10ec6863          	bltu	s8,a4,734 <vprintf+0x19e>
 628:	00271793          	slli	a5,a4,0x2
 62c:	97e6                	add	a5,a5,s9
 62e:	439c                	lw	a5,0(a5)
 630:	97e6                	add	a5,a5,s9
 632:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 634:	008b0913          	addi	s2,s6,8
 638:	4685                	li	a3,1
 63a:	4629                	li	a2,10
 63c:	000b2583          	lw	a1,0(s6)
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	ea8080e7          	jalr	-344(ra) # 4ea <printint>
 64a:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b765                	j	5f6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	008b0913          	addi	s2,s6,8
 654:	4681                	li	a3,0
 656:	4629                	li	a2,10
 658:	000b2583          	lw	a1,0(s6)
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	e8c080e7          	jalr	-372(ra) # 4ea <printint>
 666:	8b4a                	mv	s6,s2
      state = 0;
 668:	4981                	li	s3,0
 66a:	b771                	j	5f6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 66c:	008b0913          	addi	s2,s6,8
 670:	4681                	li	a3,0
 672:	866a                	mv	a2,s10
 674:	000b2583          	lw	a1,0(s6)
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	e70080e7          	jalr	-400(ra) # 4ea <printint>
 682:	8b4a                	mv	s6,s2
      state = 0;
 684:	4981                	li	s3,0
 686:	bf85                	j	5f6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 688:	008b0793          	addi	a5,s6,8
 68c:	f8f43423          	sd	a5,-120(s0)
 690:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 694:	03000593          	li	a1,48
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e2e080e7          	jalr	-466(ra) # 4c8 <putc>
  putc(fd, 'x');
 6a2:	07800593          	li	a1,120
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e20080e7          	jalr	-480(ra) # 4c8 <putc>
 6b0:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b2:	03c9d793          	srli	a5,s3,0x3c
 6b6:	97de                	add	a5,a5,s7
 6b8:	0007c583          	lbu	a1,0(a5)
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	e0a080e7          	jalr	-502(ra) # 4c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c6:	0992                	slli	s3,s3,0x4
 6c8:	397d                	addiw	s2,s2,-1
 6ca:	fe0914e3          	bnez	s2,6b2 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 6ce:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b70d                	j	5f6 <vprintf+0x60>
        s = va_arg(ap, char*);
 6d6:	008b0913          	addi	s2,s6,8
 6da:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 6de:	02098163          	beqz	s3,700 <vprintf+0x16a>
        while(*s != 0){
 6e2:	0009c583          	lbu	a1,0(s3)
 6e6:	c5ad                	beqz	a1,750 <vprintf+0x1ba>
          putc(fd, *s);
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	dde080e7          	jalr	-546(ra) # 4c8 <putc>
          s++;
 6f2:	0985                	addi	s3,s3,1
        while(*s != 0){
 6f4:	0009c583          	lbu	a1,0(s3)
 6f8:	f9e5                	bnez	a1,6e8 <vprintf+0x152>
        s = va_arg(ap, char*);
 6fa:	8b4a                	mv	s6,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bde5                	j	5f6 <vprintf+0x60>
          s = "(null)";
 700:	00000997          	auipc	s3,0x0
 704:	28898993          	addi	s3,s3,648 # 988 <malloc+0x12e>
        while(*s != 0){
 708:	85ee                	mv	a1,s11
 70a:	bff9                	j	6e8 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 70c:	008b0913          	addi	s2,s6,8
 710:	000b4583          	lbu	a1,0(s6)
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	db2080e7          	jalr	-590(ra) # 4c8 <putc>
 71e:	8b4a                	mv	s6,s2
      state = 0;
 720:	4981                	li	s3,0
 722:	bdd1                	j	5f6 <vprintf+0x60>
        putc(fd, c);
 724:	85d2                	mv	a1,s4
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	da0080e7          	jalr	-608(ra) # 4c8 <putc>
      state = 0;
 730:	4981                	li	s3,0
 732:	b5d1                	j	5f6 <vprintf+0x60>
        putc(fd, '%');
 734:	85d2                	mv	a1,s4
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	d90080e7          	jalr	-624(ra) # 4c8 <putc>
        putc(fd, c);
 740:	85ca                	mv	a1,s2
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	d84080e7          	jalr	-636(ra) # 4c8 <putc>
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b565                	j	5f6 <vprintf+0x60>
        s = va_arg(ap, char*);
 750:	8b4a                	mv	s6,s2
      state = 0;
 752:	4981                	li	s3,0
 754:	b54d                	j	5f6 <vprintf+0x60>
    }
  }
}
 756:	70e6                	ld	ra,120(sp)
 758:	7446                	ld	s0,112(sp)
 75a:	74a6                	ld	s1,104(sp)
 75c:	7906                	ld	s2,96(sp)
 75e:	69e6                	ld	s3,88(sp)
 760:	6a46                	ld	s4,80(sp)
 762:	6aa6                	ld	s5,72(sp)
 764:	6b06                	ld	s6,64(sp)
 766:	7be2                	ld	s7,56(sp)
 768:	7c42                	ld	s8,48(sp)
 76a:	7ca2                	ld	s9,40(sp)
 76c:	7d02                	ld	s10,32(sp)
 76e:	6de2                	ld	s11,24(sp)
 770:	6109                	addi	sp,sp,128
 772:	8082                	ret

0000000000000774 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 774:	715d                	addi	sp,sp,-80
 776:	ec06                	sd	ra,24(sp)
 778:	e822                	sd	s0,16(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	e010                	sd	a2,0(s0)
 77e:	e414                	sd	a3,8(s0)
 780:	e818                	sd	a4,16(s0)
 782:	ec1c                	sd	a5,24(s0)
 784:	03043023          	sd	a6,32(s0)
 788:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 78c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 790:	8622                	mv	a2,s0
 792:	00000097          	auipc	ra,0x0
 796:	e04080e7          	jalr	-508(ra) # 596 <vprintf>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6161                	addi	sp,sp,80
 7a0:	8082                	ret

00000000000007a2 <printf>:

void
printf(const char *fmt, ...)
{
 7a2:	711d                	addi	sp,sp,-96
 7a4:	ec06                	sd	ra,24(sp)
 7a6:	e822                	sd	s0,16(sp)
 7a8:	1000                	addi	s0,sp,32
 7aa:	e40c                	sd	a1,8(s0)
 7ac:	e810                	sd	a2,16(s0)
 7ae:	ec14                	sd	a3,24(s0)
 7b0:	f018                	sd	a4,32(s0)
 7b2:	f41c                	sd	a5,40(s0)
 7b4:	03043823          	sd	a6,48(s0)
 7b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7bc:	00840613          	addi	a2,s0,8
 7c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c4:	85aa                	mv	a1,a0
 7c6:	4505                	li	a0,1
 7c8:	00000097          	auipc	ra,0x0
 7cc:	dce080e7          	jalr	-562(ra) # 596 <vprintf>
}
 7d0:	60e2                	ld	ra,24(sp)
 7d2:	6442                	ld	s0,16(sp)
 7d4:	6125                	addi	sp,sp,96
 7d6:	8082                	ret

00000000000007d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d8:	1141                	addi	sp,sp,-16
 7da:	e422                	sd	s0,8(sp)
 7dc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7de:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e2:	00000797          	auipc	a5,0x0
 7e6:	21e7b783          	ld	a5,542(a5) # a00 <freep>
 7ea:	a02d                	j	814 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ec:	4618                	lw	a4,8(a2)
 7ee:	9f2d                	addw	a4,a4,a1
 7f0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	6398                	ld	a4,0(a5)
 7f6:	6310                	ld	a2,0(a4)
 7f8:	a83d                	j	836 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7fa:	ff852703          	lw	a4,-8(a0)
 7fe:	9f31                	addw	a4,a4,a2
 800:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 802:	ff053683          	ld	a3,-16(a0)
 806:	a091                	j	84a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 808:	6398                	ld	a4,0(a5)
 80a:	00e7e463          	bltu	a5,a4,812 <free+0x3a>
 80e:	00e6ea63          	bltu	a3,a4,822 <free+0x4a>
{
 812:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 814:	fed7fae3          	bgeu	a5,a3,808 <free+0x30>
 818:	6398                	ld	a4,0(a5)
 81a:	00e6e463          	bltu	a3,a4,822 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81e:	fee7eae3          	bltu	a5,a4,812 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 822:	ff852583          	lw	a1,-8(a0)
 826:	6390                	ld	a2,0(a5)
 828:	02059813          	slli	a6,a1,0x20
 82c:	01c85713          	srli	a4,a6,0x1c
 830:	9736                	add	a4,a4,a3
 832:	fae60de3          	beq	a2,a4,7ec <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 836:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 83a:	4790                	lw	a2,8(a5)
 83c:	02061593          	slli	a1,a2,0x20
 840:	01c5d713          	srli	a4,a1,0x1c
 844:	973e                	add	a4,a4,a5
 846:	fae68ae3          	beq	a3,a4,7fa <free+0x22>
    p->s.ptr = bp->s.ptr;
 84a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 84c:	00000717          	auipc	a4,0x0
 850:	1af73a23          	sd	a5,436(a4) # a00 <freep>
}
 854:	6422                	ld	s0,8(sp)
 856:	0141                	addi	sp,sp,16
 858:	8082                	ret

000000000000085a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 85a:	7139                	addi	sp,sp,-64
 85c:	fc06                	sd	ra,56(sp)
 85e:	f822                	sd	s0,48(sp)
 860:	f426                	sd	s1,40(sp)
 862:	f04a                	sd	s2,32(sp)
 864:	ec4e                	sd	s3,24(sp)
 866:	e852                	sd	s4,16(sp)
 868:	e456                	sd	s5,8(sp)
 86a:	e05a                	sd	s6,0(sp)
 86c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86e:	02051493          	slli	s1,a0,0x20
 872:	9081                	srli	s1,s1,0x20
 874:	04bd                	addi	s1,s1,15
 876:	8091                	srli	s1,s1,0x4
 878:	0014899b          	addiw	s3,s1,1
 87c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 87e:	00000517          	auipc	a0,0x0
 882:	18253503          	ld	a0,386(a0) # a00 <freep>
 886:	c515                	beqz	a0,8b2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 888:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88a:	4798                	lw	a4,8(a5)
 88c:	02977f63          	bgeu	a4,s1,8ca <malloc+0x70>
 890:	8a4e                	mv	s4,s3
 892:	0009871b          	sext.w	a4,s3
 896:	6685                	lui	a3,0x1
 898:	00d77363          	bgeu	a4,a3,89e <malloc+0x44>
 89c:	6a05                	lui	s4,0x1
 89e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a6:	00000917          	auipc	s2,0x0
 8aa:	15a90913          	addi	s2,s2,346 # a00 <freep>
  if(p == (char*)-1)
 8ae:	5afd                	li	s5,-1
 8b0:	a895                	j	924 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8b2:	00000797          	auipc	a5,0x0
 8b6:	35678793          	addi	a5,a5,854 # c08 <base>
 8ba:	00000717          	auipc	a4,0x0
 8be:	14f73323          	sd	a5,326(a4) # a00 <freep>
 8c2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8c8:	b7e1                	j	890 <malloc+0x36>
      if(p->s.size == nunits)
 8ca:	02e48c63          	beq	s1,a4,902 <malloc+0xa8>
        p->s.size -= nunits;
 8ce:	4137073b          	subw	a4,a4,s3
 8d2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d4:	02071693          	slli	a3,a4,0x20
 8d8:	01c6d713          	srli	a4,a3,0x1c
 8dc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8de:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e2:	00000717          	auipc	a4,0x0
 8e6:	10a73f23          	sd	a0,286(a4) # a00 <freep>
      return (void*)(p + 1);
 8ea:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8ee:	70e2                	ld	ra,56(sp)
 8f0:	7442                	ld	s0,48(sp)
 8f2:	74a2                	ld	s1,40(sp)
 8f4:	7902                	ld	s2,32(sp)
 8f6:	69e2                	ld	s3,24(sp)
 8f8:	6a42                	ld	s4,16(sp)
 8fa:	6aa2                	ld	s5,8(sp)
 8fc:	6b02                	ld	s6,0(sp)
 8fe:	6121                	addi	sp,sp,64
 900:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 902:	6398                	ld	a4,0(a5)
 904:	e118                	sd	a4,0(a0)
 906:	bff1                	j	8e2 <malloc+0x88>
  hp->s.size = nu;
 908:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 90c:	0541                	addi	a0,a0,16
 90e:	00000097          	auipc	ra,0x0
 912:	eca080e7          	jalr	-310(ra) # 7d8 <free>
  return freep;
 916:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 91a:	d971                	beqz	a0,8ee <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91e:	4798                	lw	a4,8(a5)
 920:	fa9775e3          	bgeu	a4,s1,8ca <malloc+0x70>
    if(p == freep)
 924:	00093703          	ld	a4,0(s2)
 928:	853e                	mv	a0,a5
 92a:	fef719e3          	bne	a4,a5,91c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 92e:	8552                	mv	a0,s4
 930:	00000097          	auipc	ra,0x0
 934:	b70080e7          	jalr	-1168(ra) # 4a0 <sbrk>
  if(p == (char*)-1)
 938:	fd5518e3          	bne	a0,s5,908 <malloc+0xae>
        return 0;
 93c:	4501                	li	a0,0
 93e:	bf45                	j	8ee <malloc+0x94>
