
user/_mmaptest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
  printf("mmaptest: %s failed: %s, pid=%d\n", testname, why, getpid());
       e:	00001917          	auipc	s2,0x1
      12:	5e293903          	ld	s2,1506(s2) # 15f0 <testname>
      16:	00001097          	auipc	ra,0x1
      1a:	c04080e7          	jalr	-1020(ra) # c1a <getpid>
      1e:	86aa                	mv	a3,a0
      20:	8626                	mv	a2,s1
      22:	85ca                	mv	a1,s2
      24:	00001517          	auipc	a0,0x1
      28:	0a450513          	addi	a0,a0,164 # 10c8 <malloc+0xec>
      2c:	00001097          	auipc	ra,0x1
      30:	ef8080e7          	jalr	-264(ra) # f24 <printf>
  exit(1);
      34:	4505                	li	a0,1
      36:	00001097          	auipc	ra,0x1
      3a:	b64080e7          	jalr	-1180(ra) # b9a <exit>

000000000000003e <_v1>:
//
// check the content of the two mapped pages.
//
void
_v1(char *p)
{
      3e:	1141                	addi	sp,sp,-16
      40:	e406                	sd	ra,8(sp)
      42:	e022                	sd	s0,0(sp)
      44:	0800                	addi	s0,sp,16
      46:	4705                	li	a4,1
      48:	4781                	li	a5,0
  int i;
  for (i = 0; i < PGSIZE*2; i++) {
    if (i < PGSIZE + (PGSIZE/2)) {
      4a:	6685                	lui	a3,0x1
      4c:	7ff68693          	addi	a3,a3,2047 # 17ff <buf+0x1ff>
  for (i = 0; i < PGSIZE*2; i++) {
      50:	6889                	lui	a7,0x2
      if (p[i] != 'A') {
      52:	04100813          	li	a6,65
      56:	a819                	j	6c <_v1+0x2e>
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
        err("v1 mismatch (1)");
      }
    } else {
      if (p[i] != 0) {
      58:	00054603          	lbu	a2,0(a0)
      5c:	e221                	bnez	a2,9c <_v1+0x5e>
  for (i = 0; i < PGSIZE*2; i++) {
      5e:	0007061b          	sext.w	a2,a4
      62:	05165d63          	bge	a2,a7,bc <_v1+0x7e>
      66:	2785                	addiw	a5,a5,1
      68:	2705                	addiw	a4,a4,1
      6a:	0505                	addi	a0,a0,1
      6c:	0007859b          	sext.w	a1,a5
    if (i < PGSIZE + (PGSIZE/2)) {
      70:	feb6c4e3          	blt	a3,a1,58 <_v1+0x1a>
      if (p[i] != 'A') {
      74:	00054603          	lbu	a2,0(a0)
      78:	ff0607e3          	beq	a2,a6,66 <_v1+0x28>
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
      7c:	00001517          	auipc	a0,0x1
      80:	07450513          	addi	a0,a0,116 # 10f0 <malloc+0x114>
      84:	00001097          	auipc	ra,0x1
      88:	ea0080e7          	jalr	-352(ra) # f24 <printf>
        err("v1 mismatch (1)");
      8c:	00001517          	auipc	a0,0x1
      90:	08c50513          	addi	a0,a0,140 # 1118 <malloc+0x13c>
      94:	00000097          	auipc	ra,0x0
      98:	f6c080e7          	jalr	-148(ra) # 0 <err>
        printf("mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
      9c:	00001517          	auipc	a0,0x1
      a0:	08c50513          	addi	a0,a0,140 # 1128 <malloc+0x14c>
      a4:	00001097          	auipc	ra,0x1
      a8:	e80080e7          	jalr	-384(ra) # f24 <printf>
        err("v1 mismatch (2)");
      ac:	00001517          	auipc	a0,0x1
      b0:	0a450513          	addi	a0,a0,164 # 1150 <malloc+0x174>
      b4:	00000097          	auipc	ra,0x0
      b8:	f4c080e7          	jalr	-180(ra) # 0 <err>
      }
    }
  }
}
      bc:	60a2                	ld	ra,8(sp)
      be:	6402                	ld	s0,0(sp)
      c0:	0141                	addi	sp,sp,16
      c2:	8082                	ret

00000000000000c4 <makefile>:
// create a file to be mapped, containing
// 1.5 pages of 'A' and half a page of zeros.
//
void
makefile(const char *f)
{
      c4:	7179                	addi	sp,sp,-48
      c6:	f406                	sd	ra,40(sp)
      c8:	f022                	sd	s0,32(sp)
      ca:	ec26                	sd	s1,24(sp)
      cc:	e84a                	sd	s2,16(sp)
      ce:	e44e                	sd	s3,8(sp)
      d0:	1800                	addi	s0,sp,48
      d2:	84aa                	mv	s1,a0
  int i;
  int n = PGSIZE/BSIZE;

  unlink(f);
      d4:	00001097          	auipc	ra,0x1
      d8:	b16080e7          	jalr	-1258(ra) # bea <unlink>
  int fd = open(f, O_WRONLY | O_CREATE);
      dc:	20100593          	li	a1,513
      e0:	8526                	mv	a0,s1
      e2:	00001097          	auipc	ra,0x1
      e6:	af8080e7          	jalr	-1288(ra) # bda <open>
  if (fd == -1)
      ea:	57fd                	li	a5,-1
      ec:	06f50163          	beq	a0,a5,14e <makefile+0x8a>
      f0:	892a                	mv	s2,a0
    err("open");
  memset(buf, 'A', BSIZE);
      f2:	40000613          	li	a2,1024
      f6:	04100593          	li	a1,65
      fa:	00001517          	auipc	a0,0x1
      fe:	50650513          	addi	a0,a0,1286 # 1600 <buf>
     102:	00001097          	auipc	ra,0x1
     106:	89e080e7          	jalr	-1890(ra) # 9a0 <memset>
     10a:	4499                	li	s1,6
  // write 1.5 page
  for (i = 0; i < n + n/2; i++) {
    if (write(fd, buf, BSIZE) != BSIZE)
     10c:	00001997          	auipc	s3,0x1
     110:	4f498993          	addi	s3,s3,1268 # 1600 <buf>
     114:	40000613          	li	a2,1024
     118:	85ce                	mv	a1,s3
     11a:	854a                	mv	a0,s2
     11c:	00001097          	auipc	ra,0x1
     120:	a9e080e7          	jalr	-1378(ra) # bba <write>
     124:	40000793          	li	a5,1024
     128:	02f51b63          	bne	a0,a5,15e <makefile+0x9a>
  for (i = 0; i < n + n/2; i++) {
     12c:	34fd                	addiw	s1,s1,-1
     12e:	f0fd                	bnez	s1,114 <makefile+0x50>
      err("write 0 makefile");
  }
  if (close(fd) == -1)
     130:	854a                	mv	a0,s2
     132:	00001097          	auipc	ra,0x1
     136:	a90080e7          	jalr	-1392(ra) # bc2 <close>
     13a:	57fd                	li	a5,-1
     13c:	02f50963          	beq	a0,a5,16e <makefile+0xaa>
    err("close");
}
     140:	70a2                	ld	ra,40(sp)
     142:	7402                	ld	s0,32(sp)
     144:	64e2                	ld	s1,24(sp)
     146:	6942                	ld	s2,16(sp)
     148:	69a2                	ld	s3,8(sp)
     14a:	6145                	addi	sp,sp,48
     14c:	8082                	ret
    err("open");
     14e:	00001517          	auipc	a0,0x1
     152:	01250513          	addi	a0,a0,18 # 1160 <malloc+0x184>
     156:	00000097          	auipc	ra,0x0
     15a:	eaa080e7          	jalr	-342(ra) # 0 <err>
      err("write 0 makefile");
     15e:	00001517          	auipc	a0,0x1
     162:	00a50513          	addi	a0,a0,10 # 1168 <malloc+0x18c>
     166:	00000097          	auipc	ra,0x0
     16a:	e9a080e7          	jalr	-358(ra) # 0 <err>
    err("close");
     16e:	00001517          	auipc	a0,0x1
     172:	01250513          	addi	a0,a0,18 # 1180 <malloc+0x1a4>
     176:	00000097          	auipc	ra,0x0
     17a:	e8a080e7          	jalr	-374(ra) # 0 <err>

000000000000017e <mmap_test>:

void
mmap_test(void)
{
     17e:	7139                	addi	sp,sp,-64
     180:	fc06                	sd	ra,56(sp)
     182:	f822                	sd	s0,48(sp)
     184:	f426                	sd	s1,40(sp)
     186:	f04a                	sd	s2,32(sp)
     188:	ec4e                	sd	s3,24(sp)
     18a:	e852                	sd	s4,16(sp)
     18c:	0080                	addi	s0,sp,64
  int fd;
  int i;
  const char * const f = "mmap.dur";
  printf("mmap_test starting\n");
     18e:	00001517          	auipc	a0,0x1
     192:	ffa50513          	addi	a0,a0,-6 # 1188 <malloc+0x1ac>
     196:	00001097          	auipc	ra,0x1
     19a:	d8e080e7          	jalr	-626(ra) # f24 <printf>
  testname = "mmap_test";
     19e:	00001797          	auipc	a5,0x1
     1a2:	00278793          	addi	a5,a5,2 # 11a0 <malloc+0x1c4>
     1a6:	00001717          	auipc	a4,0x1
     1aa:	44f73523          	sd	a5,1098(a4) # 15f0 <testname>
  //
  // create a file with known content, map it into memory, check that
  // the mapped memory has the same bytes as originally written to the
  // file.
  //
  makefile(f);
     1ae:	00001517          	auipc	a0,0x1
     1b2:	00250513          	addi	a0,a0,2 # 11b0 <malloc+0x1d4>
     1b6:	00000097          	auipc	ra,0x0
     1ba:	f0e080e7          	jalr	-242(ra) # c4 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     1be:	4581                	li	a1,0
     1c0:	00001517          	auipc	a0,0x1
     1c4:	ff050513          	addi	a0,a0,-16 # 11b0 <malloc+0x1d4>
     1c8:	00001097          	auipc	ra,0x1
     1cc:	a12080e7          	jalr	-1518(ra) # bda <open>
     1d0:	57fd                	li	a5,-1
     1d2:	3ef50663          	beq	a0,a5,5be <mmap_test+0x440>
     1d6:	892a                	mv	s2,a0
    err("open");

  printf("test mmap f\n");
     1d8:	00001517          	auipc	a0,0x1
     1dc:	fe850513          	addi	a0,a0,-24 # 11c0 <malloc+0x1e4>
     1e0:	00001097          	auipc	ra,0x1
     1e4:	d44080e7          	jalr	-700(ra) # f24 <printf>
  // same file (of course in this case updates are prohibited
  // due to PROT_READ). the fifth argument is the file descriptor
  // of the file to be mapped. the last argument is the starting
  // offset in the file.
  //
  char *p = mmap(0, PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
     1e8:	4781                	li	a5,0
     1ea:	874a                	mv	a4,s2
     1ec:	4689                	li	a3,2
     1ee:	4605                	li	a2,1
     1f0:	6589                	lui	a1,0x2
     1f2:	4501                	li	a0,0
     1f4:	00001097          	auipc	ra,0x1
     1f8:	a46080e7          	jalr	-1466(ra) # c3a <mmap>
     1fc:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     1fe:	57fd                	li	a5,-1
     200:	3cf50763          	beq	a0,a5,5ce <mmap_test+0x450>
    err("mmap (1)");
  _v1(p);
     204:	00000097          	auipc	ra,0x0
     208:	e3a080e7          	jalr	-454(ra) # 3e <_v1>
  if (munmap(p, PGSIZE*2) == -1)
     20c:	6589                	lui	a1,0x2
     20e:	8526                	mv	a0,s1
     210:	00001097          	auipc	ra,0x1
     214:	a32080e7          	jalr	-1486(ra) # c42 <munmap>
     218:	57fd                	li	a5,-1
     21a:	3cf50263          	beq	a0,a5,5de <mmap_test+0x460>
    err("munmap (1)");

  printf("test mmap f: OK\n");
     21e:	00001517          	auipc	a0,0x1
     222:	fd250513          	addi	a0,a0,-46 # 11f0 <malloc+0x214>
     226:	00001097          	auipc	ra,0x1
     22a:	cfe080e7          	jalr	-770(ra) # f24 <printf>
    
  printf("test mmap private\n");
     22e:	00001517          	auipc	a0,0x1
     232:	fda50513          	addi	a0,a0,-38 # 1208 <malloc+0x22c>
     236:	00001097          	auipc	ra,0x1
     23a:	cee080e7          	jalr	-786(ra) # f24 <printf>
  // should be able to map file opened read-only with private writable
  // mapping
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
     23e:	4781                	li	a5,0
     240:	874a                	mv	a4,s2
     242:	4689                	li	a3,2
     244:	460d                	li	a2,3
     246:	6589                	lui	a1,0x2
     248:	4501                	li	a0,0
     24a:	00001097          	auipc	ra,0x1
     24e:	9f0080e7          	jalr	-1552(ra) # c3a <mmap>
     252:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     254:	57fd                	li	a5,-1
     256:	38f50c63          	beq	a0,a5,5ee <mmap_test+0x470>
    err("mmap (2)");
  if (close(fd) == -1)
     25a:	854a                	mv	a0,s2
     25c:	00001097          	auipc	ra,0x1
     260:	966080e7          	jalr	-1690(ra) # bc2 <close>
     264:	57fd                	li	a5,-1
     266:	38f50c63          	beq	a0,a5,5fe <mmap_test+0x480>
    err("close");
  _v1(p);
     26a:	8526                	mv	a0,s1
     26c:	00000097          	auipc	ra,0x0
     270:	dd2080e7          	jalr	-558(ra) # 3e <_v1>
  for (i = 0; i < PGSIZE*2; i++)
     274:	87a6                	mv	a5,s1
     276:	6709                	lui	a4,0x2
     278:	9726                	add	a4,a4,s1
    p[i] = 'Z';
     27a:	05a00693          	li	a3,90
     27e:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     282:	0785                	addi	a5,a5,1
     284:	fef71de3          	bne	a4,a5,27e <mmap_test+0x100>
  if (munmap(p, PGSIZE*2) == -1)
     288:	6589                	lui	a1,0x2
     28a:	8526                	mv	a0,s1
     28c:	00001097          	auipc	ra,0x1
     290:	9b6080e7          	jalr	-1610(ra) # c42 <munmap>
     294:	57fd                	li	a5,-1
     296:	36f50c63          	beq	a0,a5,60e <mmap_test+0x490>
    err("munmap (2)");

  printf("test mmap private: OK\n");
     29a:	00001517          	auipc	a0,0x1
     29e:	fa650513          	addi	a0,a0,-90 # 1240 <malloc+0x264>
     2a2:	00001097          	auipc	ra,0x1
     2a6:	c82080e7          	jalr	-894(ra) # f24 <printf>
    
  printf("test mmap read-only\n");
     2aa:	00001517          	auipc	a0,0x1
     2ae:	fae50513          	addi	a0,a0,-82 # 1258 <malloc+0x27c>
     2b2:	00001097          	auipc	ra,0x1
     2b6:	c72080e7          	jalr	-910(ra) # f24 <printf>
    
  // check that mmap doesn't allow read/write mapping of a
  // file opened read-only.
  if ((fd = open(f, O_RDONLY)) == -1)
     2ba:	4581                	li	a1,0
     2bc:	00001517          	auipc	a0,0x1
     2c0:	ef450513          	addi	a0,a0,-268 # 11b0 <malloc+0x1d4>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	916080e7          	jalr	-1770(ra) # bda <open>
     2cc:	84aa                	mv	s1,a0
     2ce:	57fd                	li	a5,-1
     2d0:	34f50763          	beq	a0,a5,61e <mmap_test+0x4a0>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     2d4:	4781                	li	a5,0
     2d6:	872a                	mv	a4,a0
     2d8:	4685                	li	a3,1
     2da:	460d                	li	a2,3
     2dc:	658d                	lui	a1,0x3
     2de:	4501                	li	a0,0
     2e0:	00001097          	auipc	ra,0x1
     2e4:	95a080e7          	jalr	-1702(ra) # c3a <mmap>
  if (p != MAP_FAILED)
     2e8:	57fd                	li	a5,-1
     2ea:	34f51263          	bne	a0,a5,62e <mmap_test+0x4b0>
    err("mmap call should have failed");
  if (close(fd) == -1)
     2ee:	8526                	mv	a0,s1
     2f0:	00001097          	auipc	ra,0x1
     2f4:	8d2080e7          	jalr	-1838(ra) # bc2 <close>
     2f8:	57fd                	li	a5,-1
     2fa:	34f50263          	beq	a0,a5,63e <mmap_test+0x4c0>
    err("close");

  printf("test mmap read-only: OK\n");
     2fe:	00001517          	auipc	a0,0x1
     302:	f9250513          	addi	a0,a0,-110 # 1290 <malloc+0x2b4>
     306:	00001097          	auipc	ra,0x1
     30a:	c1e080e7          	jalr	-994(ra) # f24 <printf>
    
  printf("test mmap read/write\n");
     30e:	00001517          	auipc	a0,0x1
     312:	fa250513          	addi	a0,a0,-94 # 12b0 <malloc+0x2d4>
     316:	00001097          	auipc	ra,0x1
     31a:	c0e080e7          	jalr	-1010(ra) # f24 <printf>
  
  // check that mmap does allow read/write mapping of a
  // file opened read/write.
  if ((fd = open(f, O_RDWR)) == -1)
     31e:	4589                	li	a1,2
     320:	00001517          	auipc	a0,0x1
     324:	e9050513          	addi	a0,a0,-368 # 11b0 <malloc+0x1d4>
     328:	00001097          	auipc	ra,0x1
     32c:	8b2080e7          	jalr	-1870(ra) # bda <open>
     330:	84aa                	mv	s1,a0
     332:	57fd                	li	a5,-1
     334:	30f50d63          	beq	a0,a5,64e <mmap_test+0x4d0>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     338:	4781                	li	a5,0
     33a:	872a                	mv	a4,a0
     33c:	4685                	li	a3,1
     33e:	460d                	li	a2,3
     340:	658d                	lui	a1,0x3
     342:	4501                	li	a0,0
     344:	00001097          	auipc	ra,0x1
     348:	8f6080e7          	jalr	-1802(ra) # c3a <mmap>
     34c:	89aa                	mv	s3,a0
  if (p == MAP_FAILED)
     34e:	57fd                	li	a5,-1
     350:	30f50763          	beq	a0,a5,65e <mmap_test+0x4e0>
    err("mmap (3)");
  if (close(fd) == -1)
     354:	8526                	mv	a0,s1
     356:	00001097          	auipc	ra,0x1
     35a:	86c080e7          	jalr	-1940(ra) # bc2 <close>
     35e:	57fd                	li	a5,-1
     360:	30f50763          	beq	a0,a5,66e <mmap_test+0x4f0>
    err("close");

  // check that the mapping still works after close(fd).
  _v1(p);
     364:	854e                	mv	a0,s3
     366:	00000097          	auipc	ra,0x0
     36a:	cd8080e7          	jalr	-808(ra) # 3e <_v1>

  // write the mapped memory.
  for (i = 0; i < PGSIZE*2; i++)
     36e:	87ce                	mv	a5,s3
     370:	6709                	lui	a4,0x2
     372:	974e                	add	a4,a4,s3
    p[i] = 'Z';
     374:	05a00693          	li	a3,90
     378:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     37c:	0785                	addi	a5,a5,1
     37e:	fee79de3          	bne	a5,a4,378 <mmap_test+0x1fa>

  // unmap just the first two of three pages of mapped memory.
  if (munmap(p, PGSIZE*2) == -1)
     382:	6589                	lui	a1,0x2
     384:	854e                	mv	a0,s3
     386:	00001097          	auipc	ra,0x1
     38a:	8bc080e7          	jalr	-1860(ra) # c42 <munmap>
     38e:	57fd                	li	a5,-1
     390:	2ef50763          	beq	a0,a5,67e <mmap_test+0x500>
    err("munmap (3)");
  
  printf("test mmap read/write: OK\n");
     394:	00001517          	auipc	a0,0x1
     398:	f5450513          	addi	a0,a0,-172 # 12e8 <malloc+0x30c>
     39c:	00001097          	auipc	ra,0x1
     3a0:	b88080e7          	jalr	-1144(ra) # f24 <printf>
  
  printf("test mmap dirty\n");
     3a4:	00001517          	auipc	a0,0x1
     3a8:	f6450513          	addi	a0,a0,-156 # 1308 <malloc+0x32c>
     3ac:	00001097          	auipc	ra,0x1
     3b0:	b78080e7          	jalr	-1160(ra) # f24 <printf>
  
  // check that the writes to the mapped memory were
  // written to the file.
  if ((fd = open(f, O_RDWR)) == -1)
     3b4:	4589                	li	a1,2
     3b6:	00001517          	auipc	a0,0x1
     3ba:	dfa50513          	addi	a0,a0,-518 # 11b0 <malloc+0x1d4>
     3be:	00001097          	auipc	ra,0x1
     3c2:	81c080e7          	jalr	-2020(ra) # bda <open>
     3c6:	892a                	mv	s2,a0
     3c8:	57fd                	li	a5,-1
     3ca:	6489                	lui	s1,0x2
     3cc:	80048493          	addi	s1,s1,-2048 # 1800 <buf+0x200>
    err("open");
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
    char b;
    if (read(fd, &b, 1) != 1)
      err("read (1)");
    if (b != 'Z')
     3d0:	05a00a13          	li	s4,90
  if ((fd = open(f, O_RDWR)) == -1)
     3d4:	2af50d63          	beq	a0,a5,68e <mmap_test+0x510>
    if (read(fd, &b, 1) != 1)
     3d8:	4605                	li	a2,1
     3da:	fcf40593          	addi	a1,s0,-49
     3de:	854a                	mv	a0,s2
     3e0:	00000097          	auipc	ra,0x0
     3e4:	7d2080e7          	jalr	2002(ra) # bb2 <read>
     3e8:	4785                	li	a5,1
     3ea:	2af51a63          	bne	a0,a5,69e <mmap_test+0x520>
    if (b != 'Z')
     3ee:	fcf44783          	lbu	a5,-49(s0)
     3f2:	2b479e63          	bne	a5,s4,6ae <mmap_test+0x530>
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
     3f6:	34fd                	addiw	s1,s1,-1
     3f8:	f0e5                	bnez	s1,3d8 <mmap_test+0x25a>
      err("file does not contain modifications");
  }
  if (close(fd) == -1)
     3fa:	854a                	mv	a0,s2
     3fc:	00000097          	auipc	ra,0x0
     400:	7c6080e7          	jalr	1990(ra) # bc2 <close>
     404:	57fd                	li	a5,-1
     406:	2af50c63          	beq	a0,a5,6be <mmap_test+0x540>
    err("close");

  printf("test mmap dirty: OK\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	f4e50513          	addi	a0,a0,-178 # 1358 <malloc+0x37c>
     412:	00001097          	auipc	ra,0x1
     416:	b12080e7          	jalr	-1262(ra) # f24 <printf>

  printf("test not-mapped unmap\n");
     41a:	00001517          	auipc	a0,0x1
     41e:	f5650513          	addi	a0,a0,-170 # 1370 <malloc+0x394>
     422:	00001097          	auipc	ra,0x1
     426:	b02080e7          	jalr	-1278(ra) # f24 <printf>
  
  // unmap the rest of the mapped memory.
  if (munmap(p+PGSIZE*2, PGSIZE) == -1)
     42a:	6585                	lui	a1,0x1
     42c:	6509                	lui	a0,0x2
     42e:	954e                	add	a0,a0,s3
     430:	00001097          	auipc	ra,0x1
     434:	812080e7          	jalr	-2030(ra) # c42 <munmap>
     438:	57fd                	li	a5,-1
     43a:	28f50a63          	beq	a0,a5,6ce <mmap_test+0x550>
    err("munmap (4)");

  printf("test not-mapped unmap: OK\n");
     43e:	00001517          	auipc	a0,0x1
     442:	f5a50513          	addi	a0,a0,-166 # 1398 <malloc+0x3bc>
     446:	00001097          	auipc	ra,0x1
     44a:	ade080e7          	jalr	-1314(ra) # f24 <printf>
    
  printf("test mmap two files\n");
     44e:	00001517          	auipc	a0,0x1
     452:	f6a50513          	addi	a0,a0,-150 # 13b8 <malloc+0x3dc>
     456:	00001097          	auipc	ra,0x1
     45a:	ace080e7          	jalr	-1330(ra) # f24 <printf>
  
  //
  // mmap two files at the same time.
  //
  int fd1;
  if((fd1 = open("mmap1", O_RDWR|O_CREATE)) < 0)
     45e:	20200593          	li	a1,514
     462:	00001517          	auipc	a0,0x1
     466:	f6e50513          	addi	a0,a0,-146 # 13d0 <malloc+0x3f4>
     46a:	00000097          	auipc	ra,0x0
     46e:	770080e7          	jalr	1904(ra) # bda <open>
     472:	84aa                	mv	s1,a0
     474:	26054563          	bltz	a0,6de <mmap_test+0x560>
    err("open mmap1");
  if(write(fd1, "12345", 5) != 5)
     478:	4615                	li	a2,5
     47a:	00001597          	auipc	a1,0x1
     47e:	f6e58593          	addi	a1,a1,-146 # 13e8 <malloc+0x40c>
     482:	00000097          	auipc	ra,0x0
     486:	738080e7          	jalr	1848(ra) # bba <write>
     48a:	4795                	li	a5,5
     48c:	26f51163          	bne	a0,a5,6ee <mmap_test+0x570>
    err("write mmap1");
  char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
     490:	4781                	li	a5,0
     492:	8726                	mv	a4,s1
     494:	4689                	li	a3,2
     496:	4605                	li	a2,1
     498:	6585                	lui	a1,0x1
     49a:	4501                	li	a0,0
     49c:	00000097          	auipc	ra,0x0
     4a0:	79e080e7          	jalr	1950(ra) # c3a <mmap>
     4a4:	89aa                	mv	s3,a0
  if(p1 == MAP_FAILED)
     4a6:	57fd                	li	a5,-1
     4a8:	24f50b63          	beq	a0,a5,6fe <mmap_test+0x580>
    err("mmap mmap1");
  close(fd1);
     4ac:	8526                	mv	a0,s1
     4ae:	00000097          	auipc	ra,0x0
     4b2:	714080e7          	jalr	1812(ra) # bc2 <close>
  unlink("mmap1");
     4b6:	00001517          	auipc	a0,0x1
     4ba:	f1a50513          	addi	a0,a0,-230 # 13d0 <malloc+0x3f4>
     4be:	00000097          	auipc	ra,0x0
     4c2:	72c080e7          	jalr	1836(ra) # bea <unlink>

  int fd2;
  if((fd2 = open("mmap2", O_RDWR|O_CREATE)) < 0)
     4c6:	20200593          	li	a1,514
     4ca:	00001517          	auipc	a0,0x1
     4ce:	f4650513          	addi	a0,a0,-186 # 1410 <malloc+0x434>
     4d2:	00000097          	auipc	ra,0x0
     4d6:	708080e7          	jalr	1800(ra) # bda <open>
     4da:	892a                	mv	s2,a0
     4dc:	22054963          	bltz	a0,70e <mmap_test+0x590>
    err("open mmap2");
  if(write(fd2, "67890", 5) != 5)
     4e0:	4615                	li	a2,5
     4e2:	00001597          	auipc	a1,0x1
     4e6:	f4658593          	addi	a1,a1,-186 # 1428 <malloc+0x44c>
     4ea:	00000097          	auipc	ra,0x0
     4ee:	6d0080e7          	jalr	1744(ra) # bba <write>
     4f2:	4795                	li	a5,5
     4f4:	22f51563          	bne	a0,a5,71e <mmap_test+0x5a0>
    err("write mmap2");
  char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
     4f8:	4781                	li	a5,0
     4fa:	874a                	mv	a4,s2
     4fc:	4689                	li	a3,2
     4fe:	4605                	li	a2,1
     500:	6585                	lui	a1,0x1
     502:	4501                	li	a0,0
     504:	00000097          	auipc	ra,0x0
     508:	736080e7          	jalr	1846(ra) # c3a <mmap>
     50c:	84aa                	mv	s1,a0
  if(p2 == MAP_FAILED)
     50e:	57fd                	li	a5,-1
     510:	20f50f63          	beq	a0,a5,72e <mmap_test+0x5b0>
    err("mmap mmap2");
  close(fd2);
     514:	854a                	mv	a0,s2
     516:	00000097          	auipc	ra,0x0
     51a:	6ac080e7          	jalr	1708(ra) # bc2 <close>
  unlink("mmap2");
     51e:	00001517          	auipc	a0,0x1
     522:	ef250513          	addi	a0,a0,-270 # 1410 <malloc+0x434>
     526:	00000097          	auipc	ra,0x0
     52a:	6c4080e7          	jalr	1732(ra) # bea <unlink>

  if(memcmp(p1, "12345", 5) != 0)
     52e:	4615                	li	a2,5
     530:	00001597          	auipc	a1,0x1
     534:	eb858593          	addi	a1,a1,-328 # 13e8 <malloc+0x40c>
     538:	854e                	mv	a0,s3
     53a:	00000097          	auipc	ra,0x0
     53e:	606080e7          	jalr	1542(ra) # b40 <memcmp>
     542:	1e051e63          	bnez	a0,73e <mmap_test+0x5c0>
    err("mmap1 mismatch");
  if(memcmp(p2, "67890", 5) != 0)
     546:	4615                	li	a2,5
     548:	00001597          	auipc	a1,0x1
     54c:	ee058593          	addi	a1,a1,-288 # 1428 <malloc+0x44c>
     550:	8526                	mv	a0,s1
     552:	00000097          	auipc	ra,0x0
     556:	5ee080e7          	jalr	1518(ra) # b40 <memcmp>
     55a:	1e051a63          	bnez	a0,74e <mmap_test+0x5d0>
    err("mmap2 mismatch");

  munmap(p1, PGSIZE);
     55e:	6585                	lui	a1,0x1
     560:	854e                	mv	a0,s3
     562:	00000097          	auipc	ra,0x0
     566:	6e0080e7          	jalr	1760(ra) # c42 <munmap>
  if(memcmp(p2, "67890", 5) != 0)
     56a:	4615                	li	a2,5
     56c:	00001597          	auipc	a1,0x1
     570:	ebc58593          	addi	a1,a1,-324 # 1428 <malloc+0x44c>
     574:	8526                	mv	a0,s1
     576:	00000097          	auipc	ra,0x0
     57a:	5ca080e7          	jalr	1482(ra) # b40 <memcmp>
     57e:	1e051063          	bnez	a0,75e <mmap_test+0x5e0>
    err("mmap2 mismatch (2)");
  munmap(p2, PGSIZE);
     582:	6585                	lui	a1,0x1
     584:	8526                	mv	a0,s1
     586:	00000097          	auipc	ra,0x0
     58a:	6bc080e7          	jalr	1724(ra) # c42 <munmap>
  
  printf("test mmap two files: OK\n");
     58e:	00001517          	auipc	a0,0x1
     592:	efa50513          	addi	a0,a0,-262 # 1488 <malloc+0x4ac>
     596:	00001097          	auipc	ra,0x1
     59a:	98e080e7          	jalr	-1650(ra) # f24 <printf>
  
  printf("mmap_test: ALL OK\n");
     59e:	00001517          	auipc	a0,0x1
     5a2:	f0a50513          	addi	a0,a0,-246 # 14a8 <malloc+0x4cc>
     5a6:	00001097          	auipc	ra,0x1
     5aa:	97e080e7          	jalr	-1666(ra) # f24 <printf>
}
     5ae:	70e2                	ld	ra,56(sp)
     5b0:	7442                	ld	s0,48(sp)
     5b2:	74a2                	ld	s1,40(sp)
     5b4:	7902                	ld	s2,32(sp)
     5b6:	69e2                	ld	s3,24(sp)
     5b8:	6a42                	ld	s4,16(sp)
     5ba:	6121                	addi	sp,sp,64
     5bc:	8082                	ret
    err("open");
     5be:	00001517          	auipc	a0,0x1
     5c2:	ba250513          	addi	a0,a0,-1118 # 1160 <malloc+0x184>
     5c6:	00000097          	auipc	ra,0x0
     5ca:	a3a080e7          	jalr	-1478(ra) # 0 <err>
    err("mmap (1)");
     5ce:	00001517          	auipc	a0,0x1
     5d2:	c0250513          	addi	a0,a0,-1022 # 11d0 <malloc+0x1f4>
     5d6:	00000097          	auipc	ra,0x0
     5da:	a2a080e7          	jalr	-1494(ra) # 0 <err>
    err("munmap (1)");
     5de:	00001517          	auipc	a0,0x1
     5e2:	c0250513          	addi	a0,a0,-1022 # 11e0 <malloc+0x204>
     5e6:	00000097          	auipc	ra,0x0
     5ea:	a1a080e7          	jalr	-1510(ra) # 0 <err>
    err("mmap (2)");
     5ee:	00001517          	auipc	a0,0x1
     5f2:	c3250513          	addi	a0,a0,-974 # 1220 <malloc+0x244>
     5f6:	00000097          	auipc	ra,0x0
     5fa:	a0a080e7          	jalr	-1526(ra) # 0 <err>
    err("close");
     5fe:	00001517          	auipc	a0,0x1
     602:	b8250513          	addi	a0,a0,-1150 # 1180 <malloc+0x1a4>
     606:	00000097          	auipc	ra,0x0
     60a:	9fa080e7          	jalr	-1542(ra) # 0 <err>
    err("munmap (2)");
     60e:	00001517          	auipc	a0,0x1
     612:	c2250513          	addi	a0,a0,-990 # 1230 <malloc+0x254>
     616:	00000097          	auipc	ra,0x0
     61a:	9ea080e7          	jalr	-1558(ra) # 0 <err>
    err("open");
     61e:	00001517          	auipc	a0,0x1
     622:	b4250513          	addi	a0,a0,-1214 # 1160 <malloc+0x184>
     626:	00000097          	auipc	ra,0x0
     62a:	9da080e7          	jalr	-1574(ra) # 0 <err>
    err("mmap call should have failed");
     62e:	00001517          	auipc	a0,0x1
     632:	c4250513          	addi	a0,a0,-958 # 1270 <malloc+0x294>
     636:	00000097          	auipc	ra,0x0
     63a:	9ca080e7          	jalr	-1590(ra) # 0 <err>
    err("close");
     63e:	00001517          	auipc	a0,0x1
     642:	b4250513          	addi	a0,a0,-1214 # 1180 <malloc+0x1a4>
     646:	00000097          	auipc	ra,0x0
     64a:	9ba080e7          	jalr	-1606(ra) # 0 <err>
    err("open");
     64e:	00001517          	auipc	a0,0x1
     652:	b1250513          	addi	a0,a0,-1262 # 1160 <malloc+0x184>
     656:	00000097          	auipc	ra,0x0
     65a:	9aa080e7          	jalr	-1622(ra) # 0 <err>
    err("mmap (3)");
     65e:	00001517          	auipc	a0,0x1
     662:	c6a50513          	addi	a0,a0,-918 # 12c8 <malloc+0x2ec>
     666:	00000097          	auipc	ra,0x0
     66a:	99a080e7          	jalr	-1638(ra) # 0 <err>
    err("close");
     66e:	00001517          	auipc	a0,0x1
     672:	b1250513          	addi	a0,a0,-1262 # 1180 <malloc+0x1a4>
     676:	00000097          	auipc	ra,0x0
     67a:	98a080e7          	jalr	-1654(ra) # 0 <err>
    err("munmap (3)");
     67e:	00001517          	auipc	a0,0x1
     682:	c5a50513          	addi	a0,a0,-934 # 12d8 <malloc+0x2fc>
     686:	00000097          	auipc	ra,0x0
     68a:	97a080e7          	jalr	-1670(ra) # 0 <err>
    err("open");
     68e:	00001517          	auipc	a0,0x1
     692:	ad250513          	addi	a0,a0,-1326 # 1160 <malloc+0x184>
     696:	00000097          	auipc	ra,0x0
     69a:	96a080e7          	jalr	-1686(ra) # 0 <err>
      err("read (1)");
     69e:	00001517          	auipc	a0,0x1
     6a2:	c8250513          	addi	a0,a0,-894 # 1320 <malloc+0x344>
     6a6:	00000097          	auipc	ra,0x0
     6aa:	95a080e7          	jalr	-1702(ra) # 0 <err>
      err("file does not contain modifications");
     6ae:	00001517          	auipc	a0,0x1
     6b2:	c8250513          	addi	a0,a0,-894 # 1330 <malloc+0x354>
     6b6:	00000097          	auipc	ra,0x0
     6ba:	94a080e7          	jalr	-1718(ra) # 0 <err>
    err("close");
     6be:	00001517          	auipc	a0,0x1
     6c2:	ac250513          	addi	a0,a0,-1342 # 1180 <malloc+0x1a4>
     6c6:	00000097          	auipc	ra,0x0
     6ca:	93a080e7          	jalr	-1734(ra) # 0 <err>
    err("munmap (4)");
     6ce:	00001517          	auipc	a0,0x1
     6d2:	cba50513          	addi	a0,a0,-838 # 1388 <malloc+0x3ac>
     6d6:	00000097          	auipc	ra,0x0
     6da:	92a080e7          	jalr	-1750(ra) # 0 <err>
    err("open mmap1");
     6de:	00001517          	auipc	a0,0x1
     6e2:	cfa50513          	addi	a0,a0,-774 # 13d8 <malloc+0x3fc>
     6e6:	00000097          	auipc	ra,0x0
     6ea:	91a080e7          	jalr	-1766(ra) # 0 <err>
    err("write mmap1");
     6ee:	00001517          	auipc	a0,0x1
     6f2:	d0250513          	addi	a0,a0,-766 # 13f0 <malloc+0x414>
     6f6:	00000097          	auipc	ra,0x0
     6fa:	90a080e7          	jalr	-1782(ra) # 0 <err>
    err("mmap mmap1");
     6fe:	00001517          	auipc	a0,0x1
     702:	d0250513          	addi	a0,a0,-766 # 1400 <malloc+0x424>
     706:	00000097          	auipc	ra,0x0
     70a:	8fa080e7          	jalr	-1798(ra) # 0 <err>
    err("open mmap2");
     70e:	00001517          	auipc	a0,0x1
     712:	d0a50513          	addi	a0,a0,-758 # 1418 <malloc+0x43c>
     716:	00000097          	auipc	ra,0x0
     71a:	8ea080e7          	jalr	-1814(ra) # 0 <err>
    err("write mmap2");
     71e:	00001517          	auipc	a0,0x1
     722:	d1250513          	addi	a0,a0,-750 # 1430 <malloc+0x454>
     726:	00000097          	auipc	ra,0x0
     72a:	8da080e7          	jalr	-1830(ra) # 0 <err>
    err("mmap mmap2");
     72e:	00001517          	auipc	a0,0x1
     732:	d1250513          	addi	a0,a0,-750 # 1440 <malloc+0x464>
     736:	00000097          	auipc	ra,0x0
     73a:	8ca080e7          	jalr	-1846(ra) # 0 <err>
    err("mmap1 mismatch");
     73e:	00001517          	auipc	a0,0x1
     742:	d1250513          	addi	a0,a0,-750 # 1450 <malloc+0x474>
     746:	00000097          	auipc	ra,0x0
     74a:	8ba080e7          	jalr	-1862(ra) # 0 <err>
    err("mmap2 mismatch");
     74e:	00001517          	auipc	a0,0x1
     752:	d1250513          	addi	a0,a0,-750 # 1460 <malloc+0x484>
     756:	00000097          	auipc	ra,0x0
     75a:	8aa080e7          	jalr	-1878(ra) # 0 <err>
    err("mmap2 mismatch (2)");
     75e:	00001517          	auipc	a0,0x1
     762:	d1250513          	addi	a0,a0,-750 # 1470 <malloc+0x494>
     766:	00000097          	auipc	ra,0x0
     76a:	89a080e7          	jalr	-1894(ra) # 0 <err>

000000000000076e <fork_test>:
// mmap a file, then fork.
// check that the child sees the mapped file.
//
void
fork_test(void)
{
     76e:	7179                	addi	sp,sp,-48
     770:	f406                	sd	ra,40(sp)
     772:	f022                	sd	s0,32(sp)
     774:	ec26                	sd	s1,24(sp)
     776:	e84a                	sd	s2,16(sp)
     778:	1800                	addi	s0,sp,48
  int fd;
  int pid;
  const char * const f = "mmap.dur";
  
  printf("fork_test starting\n");
     77a:	00001517          	auipc	a0,0x1
     77e:	d4650513          	addi	a0,a0,-698 # 14c0 <malloc+0x4e4>
     782:	00000097          	auipc	ra,0x0
     786:	7a2080e7          	jalr	1954(ra) # f24 <printf>
  testname = "fork_test";
     78a:	00001797          	auipc	a5,0x1
     78e:	d4e78793          	addi	a5,a5,-690 # 14d8 <malloc+0x4fc>
     792:	00001717          	auipc	a4,0x1
     796:	e4f73f23          	sd	a5,-418(a4) # 15f0 <testname>
  
  // mmap the file twice.
  makefile(f);
     79a:	00001517          	auipc	a0,0x1
     79e:	a1650513          	addi	a0,a0,-1514 # 11b0 <malloc+0x1d4>
     7a2:	00000097          	auipc	ra,0x0
     7a6:	922080e7          	jalr	-1758(ra) # c4 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     7aa:	4581                	li	a1,0
     7ac:	00001517          	auipc	a0,0x1
     7b0:	a0450513          	addi	a0,a0,-1532 # 11b0 <malloc+0x1d4>
     7b4:	00000097          	auipc	ra,0x0
     7b8:	426080e7          	jalr	1062(ra) # bda <open>
     7bc:	57fd                	li	a5,-1
     7be:	0af50a63          	beq	a0,a5,872 <fork_test+0x104>
     7c2:	84aa                	mv	s1,a0
    err("open");
  unlink(f);
     7c4:	00001517          	auipc	a0,0x1
     7c8:	9ec50513          	addi	a0,a0,-1556 # 11b0 <malloc+0x1d4>
     7cc:	00000097          	auipc	ra,0x0
     7d0:	41e080e7          	jalr	1054(ra) # bea <unlink>
  char *p1 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     7d4:	4781                	li	a5,0
     7d6:	8726                	mv	a4,s1
     7d8:	4685                	li	a3,1
     7da:	4605                	li	a2,1
     7dc:	6589                	lui	a1,0x2
     7de:	4501                	li	a0,0
     7e0:	00000097          	auipc	ra,0x0
     7e4:	45a080e7          	jalr	1114(ra) # c3a <mmap>
     7e8:	892a                	mv	s2,a0
  if (p1 == MAP_FAILED)
     7ea:	57fd                	li	a5,-1
     7ec:	08f50b63          	beq	a0,a5,882 <fork_test+0x114>
    err("mmap (4)");
  char *p2 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     7f0:	4781                	li	a5,0
     7f2:	8726                	mv	a4,s1
     7f4:	4685                	li	a3,1
     7f6:	4605                	li	a2,1
     7f8:	6589                	lui	a1,0x2
     7fa:	4501                	li	a0,0
     7fc:	00000097          	auipc	ra,0x0
     800:	43e080e7          	jalr	1086(ra) # c3a <mmap>
     804:	84aa                	mv	s1,a0
  if (p2 == MAP_FAILED)
     806:	57fd                	li	a5,-1
     808:	08f50563          	beq	a0,a5,892 <fork_test+0x124>
    err("mmap (5)");

  // read just 2nd page.
  if(*(p1+PGSIZE) != 'A')
     80c:	6785                	lui	a5,0x1
     80e:	97ca                	add	a5,a5,s2
     810:	0007c703          	lbu	a4,0(a5) # 1000 <malloc+0x24>
     814:	04100793          	li	a5,65
     818:	08f71563          	bne	a4,a5,8a2 <fork_test+0x134>
    err("fork mismatch (1)");

  if((pid = fork()) < 0)
     81c:	00000097          	auipc	ra,0x0
     820:	376080e7          	jalr	886(ra) # b92 <fork>
     824:	08054763          	bltz	a0,8b2 <fork_test+0x144>
    err("fork");
  if (pid == 0) {
     828:	cd49                	beqz	a0,8c2 <fork_test+0x154>
    _v1(p1);
    munmap(p1, PGSIZE); // just the first page
    exit(0); // tell the parent that the mapping looks OK.
  }

  int status = -1;
     82a:	57fd                	li	a5,-1
     82c:	fcf42e23          	sw	a5,-36(s0)
  wait(&status);
     830:	fdc40513          	addi	a0,s0,-36
     834:	00000097          	auipc	ra,0x0
     838:	36e080e7          	jalr	878(ra) # ba2 <wait>

  if(status != 0){
     83c:	fdc42783          	lw	a5,-36(s0)
     840:	e3cd                	bnez	a5,8e2 <fork_test+0x174>
    printf("fork_test failed\n");
    exit(1);
  }

  // check that the parent's mappings are still there.
  _v1(p1);
     842:	854a                	mv	a0,s2
     844:	fffff097          	auipc	ra,0xfffff
     848:	7fa080e7          	jalr	2042(ra) # 3e <_v1>
  _v1(p2);
     84c:	8526                	mv	a0,s1
     84e:	fffff097          	auipc	ra,0xfffff
     852:	7f0080e7          	jalr	2032(ra) # 3e <_v1>

  printf("fork_test OK\n");
     856:	00001517          	auipc	a0,0x1
     85a:	cea50513          	addi	a0,a0,-790 # 1540 <malloc+0x564>
     85e:	00000097          	auipc	ra,0x0
     862:	6c6080e7          	jalr	1734(ra) # f24 <printf>
}
     866:	70a2                	ld	ra,40(sp)
     868:	7402                	ld	s0,32(sp)
     86a:	64e2                	ld	s1,24(sp)
     86c:	6942                	ld	s2,16(sp)
     86e:	6145                	addi	sp,sp,48
     870:	8082                	ret
    err("open");
     872:	00001517          	auipc	a0,0x1
     876:	8ee50513          	addi	a0,a0,-1810 # 1160 <malloc+0x184>
     87a:	fffff097          	auipc	ra,0xfffff
     87e:	786080e7          	jalr	1926(ra) # 0 <err>
    err("mmap (4)");
     882:	00001517          	auipc	a0,0x1
     886:	c6650513          	addi	a0,a0,-922 # 14e8 <malloc+0x50c>
     88a:	fffff097          	auipc	ra,0xfffff
     88e:	776080e7          	jalr	1910(ra) # 0 <err>
    err("mmap (5)");
     892:	00001517          	auipc	a0,0x1
     896:	c6650513          	addi	a0,a0,-922 # 14f8 <malloc+0x51c>
     89a:	fffff097          	auipc	ra,0xfffff
     89e:	766080e7          	jalr	1894(ra) # 0 <err>
    err("fork mismatch (1)");
     8a2:	00001517          	auipc	a0,0x1
     8a6:	c6650513          	addi	a0,a0,-922 # 1508 <malloc+0x52c>
     8aa:	fffff097          	auipc	ra,0xfffff
     8ae:	756080e7          	jalr	1878(ra) # 0 <err>
    err("fork");
     8b2:	00001517          	auipc	a0,0x1
     8b6:	c6e50513          	addi	a0,a0,-914 # 1520 <malloc+0x544>
     8ba:	fffff097          	auipc	ra,0xfffff
     8be:	746080e7          	jalr	1862(ra) # 0 <err>
    _v1(p1);
     8c2:	854a                	mv	a0,s2
     8c4:	fffff097          	auipc	ra,0xfffff
     8c8:	77a080e7          	jalr	1914(ra) # 3e <_v1>
    munmap(p1, PGSIZE); // just the first page
     8cc:	6585                	lui	a1,0x1
     8ce:	854a                	mv	a0,s2
     8d0:	00000097          	auipc	ra,0x0
     8d4:	372080e7          	jalr	882(ra) # c42 <munmap>
    exit(0); // tell the parent that the mapping looks OK.
     8d8:	4501                	li	a0,0
     8da:	00000097          	auipc	ra,0x0
     8de:	2c0080e7          	jalr	704(ra) # b9a <exit>
    printf("fork_test failed\n");
     8e2:	00001517          	auipc	a0,0x1
     8e6:	c4650513          	addi	a0,a0,-954 # 1528 <malloc+0x54c>
     8ea:	00000097          	auipc	ra,0x0
     8ee:	63a080e7          	jalr	1594(ra) # f24 <printf>
    exit(1);
     8f2:	4505                	li	a0,1
     8f4:	00000097          	auipc	ra,0x0
     8f8:	2a6080e7          	jalr	678(ra) # b9a <exit>

00000000000008fc <main>:
{
     8fc:	1141                	addi	sp,sp,-16
     8fe:	e406                	sd	ra,8(sp)
     900:	e022                	sd	s0,0(sp)
     902:	0800                	addi	s0,sp,16
  mmap_test();
     904:	00000097          	auipc	ra,0x0
     908:	87a080e7          	jalr	-1926(ra) # 17e <mmap_test>
  fork_test();
     90c:	00000097          	auipc	ra,0x0
     910:	e62080e7          	jalr	-414(ra) # 76e <fork_test>
  printf("mmaptest: all tests succeeded\n");
     914:	00001517          	auipc	a0,0x1
     918:	c3c50513          	addi	a0,a0,-964 # 1550 <malloc+0x574>
     91c:	00000097          	auipc	ra,0x0
     920:	608080e7          	jalr	1544(ra) # f24 <printf>
  exit(0);
     924:	4501                	li	a0,0
     926:	00000097          	auipc	ra,0x0
     92a:	274080e7          	jalr	628(ra) # b9a <exit>

000000000000092e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     92e:	1141                	addi	sp,sp,-16
     930:	e422                	sd	s0,8(sp)
     932:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     934:	87aa                	mv	a5,a0
     936:	0585                	addi	a1,a1,1 # 1001 <malloc+0x25>
     938:	0785                	addi	a5,a5,1
     93a:	fff5c703          	lbu	a4,-1(a1)
     93e:	fee78fa3          	sb	a4,-1(a5)
     942:	fb75                	bnez	a4,936 <strcpy+0x8>
    ;
  return os;
}
     944:	6422                	ld	s0,8(sp)
     946:	0141                	addi	sp,sp,16
     948:	8082                	ret

000000000000094a <strcmp>:

int
strcmp(const char *p, const char *q)
{
     94a:	1141                	addi	sp,sp,-16
     94c:	e422                	sd	s0,8(sp)
     94e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     950:	00054783          	lbu	a5,0(a0)
     954:	cb91                	beqz	a5,968 <strcmp+0x1e>
     956:	0005c703          	lbu	a4,0(a1)
     95a:	00f71763          	bne	a4,a5,968 <strcmp+0x1e>
    p++, q++;
     95e:	0505                	addi	a0,a0,1
     960:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     962:	00054783          	lbu	a5,0(a0)
     966:	fbe5                	bnez	a5,956 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     968:	0005c503          	lbu	a0,0(a1)
}
     96c:	40a7853b          	subw	a0,a5,a0
     970:	6422                	ld	s0,8(sp)
     972:	0141                	addi	sp,sp,16
     974:	8082                	ret

0000000000000976 <strlen>:

uint
strlen(const char *s)
{
     976:	1141                	addi	sp,sp,-16
     978:	e422                	sd	s0,8(sp)
     97a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     97c:	00054783          	lbu	a5,0(a0)
     980:	cf91                	beqz	a5,99c <strlen+0x26>
     982:	0505                	addi	a0,a0,1
     984:	87aa                	mv	a5,a0
     986:	4685                	li	a3,1
     988:	9e89                	subw	a3,a3,a0
     98a:	00f6853b          	addw	a0,a3,a5
     98e:	0785                	addi	a5,a5,1
     990:	fff7c703          	lbu	a4,-1(a5)
     994:	fb7d                	bnez	a4,98a <strlen+0x14>
    ;
  return n;
}
     996:	6422                	ld	s0,8(sp)
     998:	0141                	addi	sp,sp,16
     99a:	8082                	ret
  for(n = 0; s[n]; n++)
     99c:	4501                	li	a0,0
     99e:	bfe5                	j	996 <strlen+0x20>

00000000000009a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     9a0:	1141                	addi	sp,sp,-16
     9a2:	e422                	sd	s0,8(sp)
     9a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     9a6:	ca19                	beqz	a2,9bc <memset+0x1c>
     9a8:	87aa                	mv	a5,a0
     9aa:	1602                	slli	a2,a2,0x20
     9ac:	9201                	srli	a2,a2,0x20
     9ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     9b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     9b6:	0785                	addi	a5,a5,1
     9b8:	fee79de3          	bne	a5,a4,9b2 <memset+0x12>
  }
  return dst;
}
     9bc:	6422                	ld	s0,8(sp)
     9be:	0141                	addi	sp,sp,16
     9c0:	8082                	ret

00000000000009c2 <strchr>:

char*
strchr(const char *s, char c)
{
     9c2:	1141                	addi	sp,sp,-16
     9c4:	e422                	sd	s0,8(sp)
     9c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9c8:	00054783          	lbu	a5,0(a0)
     9cc:	cb99                	beqz	a5,9e2 <strchr+0x20>
    if(*s == c)
     9ce:	00f58763          	beq	a1,a5,9dc <strchr+0x1a>
  for(; *s; s++)
     9d2:	0505                	addi	a0,a0,1
     9d4:	00054783          	lbu	a5,0(a0)
     9d8:	fbfd                	bnez	a5,9ce <strchr+0xc>
      return (char*)s;
  return 0;
     9da:	4501                	li	a0,0
}
     9dc:	6422                	ld	s0,8(sp)
     9de:	0141                	addi	sp,sp,16
     9e0:	8082                	ret
  return 0;
     9e2:	4501                	li	a0,0
     9e4:	bfe5                	j	9dc <strchr+0x1a>

00000000000009e6 <gets>:

char*
gets(char *buf, int max)
{
     9e6:	711d                	addi	sp,sp,-96
     9e8:	ec86                	sd	ra,88(sp)
     9ea:	e8a2                	sd	s0,80(sp)
     9ec:	e4a6                	sd	s1,72(sp)
     9ee:	e0ca                	sd	s2,64(sp)
     9f0:	fc4e                	sd	s3,56(sp)
     9f2:	f852                	sd	s4,48(sp)
     9f4:	f456                	sd	s5,40(sp)
     9f6:	f05a                	sd	s6,32(sp)
     9f8:	ec5e                	sd	s7,24(sp)
     9fa:	1080                	addi	s0,sp,96
     9fc:	8baa                	mv	s7,a0
     9fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a00:	892a                	mv	s2,a0
     a02:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a04:	4aa9                	li	s5,10
     a06:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a08:	89a6                	mv	s3,s1
     a0a:	2485                	addiw	s1,s1,1
     a0c:	0344d863          	bge	s1,s4,a3c <gets+0x56>
    cc = read(0, &c, 1);
     a10:	4605                	li	a2,1
     a12:	faf40593          	addi	a1,s0,-81
     a16:	4501                	li	a0,0
     a18:	00000097          	auipc	ra,0x0
     a1c:	19a080e7          	jalr	410(ra) # bb2 <read>
    if(cc < 1)
     a20:	00a05e63          	blez	a0,a3c <gets+0x56>
    buf[i++] = c;
     a24:	faf44783          	lbu	a5,-81(s0)
     a28:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a2c:	01578763          	beq	a5,s5,a3a <gets+0x54>
     a30:	0905                	addi	s2,s2,1
     a32:	fd679be3          	bne	a5,s6,a08 <gets+0x22>
  for(i=0; i+1 < max; ){
     a36:	89a6                	mv	s3,s1
     a38:	a011                	j	a3c <gets+0x56>
     a3a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a3c:	99de                	add	s3,s3,s7
     a3e:	00098023          	sb	zero,0(s3)
  return buf;
}
     a42:	855e                	mv	a0,s7
     a44:	60e6                	ld	ra,88(sp)
     a46:	6446                	ld	s0,80(sp)
     a48:	64a6                	ld	s1,72(sp)
     a4a:	6906                	ld	s2,64(sp)
     a4c:	79e2                	ld	s3,56(sp)
     a4e:	7a42                	ld	s4,48(sp)
     a50:	7aa2                	ld	s5,40(sp)
     a52:	7b02                	ld	s6,32(sp)
     a54:	6be2                	ld	s7,24(sp)
     a56:	6125                	addi	sp,sp,96
     a58:	8082                	ret

0000000000000a5a <stat>:

int
stat(const char *n, struct stat *st)
{
     a5a:	1101                	addi	sp,sp,-32
     a5c:	ec06                	sd	ra,24(sp)
     a5e:	e822                	sd	s0,16(sp)
     a60:	e426                	sd	s1,8(sp)
     a62:	e04a                	sd	s2,0(sp)
     a64:	1000                	addi	s0,sp,32
     a66:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a68:	4581                	li	a1,0
     a6a:	00000097          	auipc	ra,0x0
     a6e:	170080e7          	jalr	368(ra) # bda <open>
  if(fd < 0)
     a72:	02054563          	bltz	a0,a9c <stat+0x42>
     a76:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a78:	85ca                	mv	a1,s2
     a7a:	00000097          	auipc	ra,0x0
     a7e:	178080e7          	jalr	376(ra) # bf2 <fstat>
     a82:	892a                	mv	s2,a0
  close(fd);
     a84:	8526                	mv	a0,s1
     a86:	00000097          	auipc	ra,0x0
     a8a:	13c080e7          	jalr	316(ra) # bc2 <close>
  return r;
}
     a8e:	854a                	mv	a0,s2
     a90:	60e2                	ld	ra,24(sp)
     a92:	6442                	ld	s0,16(sp)
     a94:	64a2                	ld	s1,8(sp)
     a96:	6902                	ld	s2,0(sp)
     a98:	6105                	addi	sp,sp,32
     a9a:	8082                	ret
    return -1;
     a9c:	597d                	li	s2,-1
     a9e:	bfc5                	j	a8e <stat+0x34>

0000000000000aa0 <atoi>:

int
atoi(const char *s)
{
     aa0:	1141                	addi	sp,sp,-16
     aa2:	e422                	sd	s0,8(sp)
     aa4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     aa6:	00054683          	lbu	a3,0(a0)
     aaa:	fd06879b          	addiw	a5,a3,-48
     aae:	0ff7f793          	zext.b	a5,a5
     ab2:	4625                	li	a2,9
     ab4:	02f66863          	bltu	a2,a5,ae4 <atoi+0x44>
     ab8:	872a                	mv	a4,a0
  n = 0;
     aba:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     abc:	0705                	addi	a4,a4,1
     abe:	0025179b          	slliw	a5,a0,0x2
     ac2:	9fa9                	addw	a5,a5,a0
     ac4:	0017979b          	slliw	a5,a5,0x1
     ac8:	9fb5                	addw	a5,a5,a3
     aca:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ace:	00074683          	lbu	a3,0(a4)
     ad2:	fd06879b          	addiw	a5,a3,-48
     ad6:	0ff7f793          	zext.b	a5,a5
     ada:	fef671e3          	bgeu	a2,a5,abc <atoi+0x1c>
  return n;
}
     ade:	6422                	ld	s0,8(sp)
     ae0:	0141                	addi	sp,sp,16
     ae2:	8082                	ret
  n = 0;
     ae4:	4501                	li	a0,0
     ae6:	bfe5                	j	ade <atoi+0x3e>

0000000000000ae8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     ae8:	1141                	addi	sp,sp,-16
     aea:	e422                	sd	s0,8(sp)
     aec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     aee:	02b57463          	bgeu	a0,a1,b16 <memmove+0x2e>
    while(n-- > 0)
     af2:	00c05f63          	blez	a2,b10 <memmove+0x28>
     af6:	1602                	slli	a2,a2,0x20
     af8:	9201                	srli	a2,a2,0x20
     afa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     afe:	872a                	mv	a4,a0
      *dst++ = *src++;
     b00:	0585                	addi	a1,a1,1
     b02:	0705                	addi	a4,a4,1
     b04:	fff5c683          	lbu	a3,-1(a1)
     b08:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b0c:	fee79ae3          	bne	a5,a4,b00 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b10:	6422                	ld	s0,8(sp)
     b12:	0141                	addi	sp,sp,16
     b14:	8082                	ret
    dst += n;
     b16:	00c50733          	add	a4,a0,a2
    src += n;
     b1a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b1c:	fec05ae3          	blez	a2,b10 <memmove+0x28>
     b20:	fff6079b          	addiw	a5,a2,-1
     b24:	1782                	slli	a5,a5,0x20
     b26:	9381                	srli	a5,a5,0x20
     b28:	fff7c793          	not	a5,a5
     b2c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b2e:	15fd                	addi	a1,a1,-1
     b30:	177d                	addi	a4,a4,-1
     b32:	0005c683          	lbu	a3,0(a1)
     b36:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b3a:	fee79ae3          	bne	a5,a4,b2e <memmove+0x46>
     b3e:	bfc9                	j	b10 <memmove+0x28>

0000000000000b40 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b40:	1141                	addi	sp,sp,-16
     b42:	e422                	sd	s0,8(sp)
     b44:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b46:	ca05                	beqz	a2,b76 <memcmp+0x36>
     b48:	fff6069b          	addiw	a3,a2,-1
     b4c:	1682                	slli	a3,a3,0x20
     b4e:	9281                	srli	a3,a3,0x20
     b50:	0685                	addi	a3,a3,1
     b52:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b54:	00054783          	lbu	a5,0(a0)
     b58:	0005c703          	lbu	a4,0(a1)
     b5c:	00e79863          	bne	a5,a4,b6c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b60:	0505                	addi	a0,a0,1
    p2++;
     b62:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b64:	fed518e3          	bne	a0,a3,b54 <memcmp+0x14>
  }
  return 0;
     b68:	4501                	li	a0,0
     b6a:	a019                	j	b70 <memcmp+0x30>
      return *p1 - *p2;
     b6c:	40e7853b          	subw	a0,a5,a4
}
     b70:	6422                	ld	s0,8(sp)
     b72:	0141                	addi	sp,sp,16
     b74:	8082                	ret
  return 0;
     b76:	4501                	li	a0,0
     b78:	bfe5                	j	b70 <memcmp+0x30>

0000000000000b7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b7a:	1141                	addi	sp,sp,-16
     b7c:	e406                	sd	ra,8(sp)
     b7e:	e022                	sd	s0,0(sp)
     b80:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b82:	00000097          	auipc	ra,0x0
     b86:	f66080e7          	jalr	-154(ra) # ae8 <memmove>
}
     b8a:	60a2                	ld	ra,8(sp)
     b8c:	6402                	ld	s0,0(sp)
     b8e:	0141                	addi	sp,sp,16
     b90:	8082                	ret

0000000000000b92 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b92:	4885                	li	a7,1
 ecall
     b94:	00000073          	ecall
 ret
     b98:	8082                	ret

0000000000000b9a <exit>:
.global exit
exit:
 li a7, SYS_exit
     b9a:	4889                	li	a7,2
 ecall
     b9c:	00000073          	ecall
 ret
     ba0:	8082                	ret

0000000000000ba2 <wait>:
.global wait
wait:
 li a7, SYS_wait
     ba2:	488d                	li	a7,3
 ecall
     ba4:	00000073          	ecall
 ret
     ba8:	8082                	ret

0000000000000baa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     baa:	4891                	li	a7,4
 ecall
     bac:	00000073          	ecall
 ret
     bb0:	8082                	ret

0000000000000bb2 <read>:
.global read
read:
 li a7, SYS_read
     bb2:	4895                	li	a7,5
 ecall
     bb4:	00000073          	ecall
 ret
     bb8:	8082                	ret

0000000000000bba <write>:
.global write
write:
 li a7, SYS_write
     bba:	48c1                	li	a7,16
 ecall
     bbc:	00000073          	ecall
 ret
     bc0:	8082                	ret

0000000000000bc2 <close>:
.global close
close:
 li a7, SYS_close
     bc2:	48d5                	li	a7,21
 ecall
     bc4:	00000073          	ecall
 ret
     bc8:	8082                	ret

0000000000000bca <kill>:
.global kill
kill:
 li a7, SYS_kill
     bca:	4899                	li	a7,6
 ecall
     bcc:	00000073          	ecall
 ret
     bd0:	8082                	ret

0000000000000bd2 <exec>:
.global exec
exec:
 li a7, SYS_exec
     bd2:	489d                	li	a7,7
 ecall
     bd4:	00000073          	ecall
 ret
     bd8:	8082                	ret

0000000000000bda <open>:
.global open
open:
 li a7, SYS_open
     bda:	48bd                	li	a7,15
 ecall
     bdc:	00000073          	ecall
 ret
     be0:	8082                	ret

0000000000000be2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     be2:	48c5                	li	a7,17
 ecall
     be4:	00000073          	ecall
 ret
     be8:	8082                	ret

0000000000000bea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bea:	48c9                	li	a7,18
 ecall
     bec:	00000073          	ecall
 ret
     bf0:	8082                	ret

0000000000000bf2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bf2:	48a1                	li	a7,8
 ecall
     bf4:	00000073          	ecall
 ret
     bf8:	8082                	ret

0000000000000bfa <link>:
.global link
link:
 li a7, SYS_link
     bfa:	48cd                	li	a7,19
 ecall
     bfc:	00000073          	ecall
 ret
     c00:	8082                	ret

0000000000000c02 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c02:	48d1                	li	a7,20
 ecall
     c04:	00000073          	ecall
 ret
     c08:	8082                	ret

0000000000000c0a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c0a:	48a5                	li	a7,9
 ecall
     c0c:	00000073          	ecall
 ret
     c10:	8082                	ret

0000000000000c12 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c12:	48a9                	li	a7,10
 ecall
     c14:	00000073          	ecall
 ret
     c18:	8082                	ret

0000000000000c1a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c1a:	48ad                	li	a7,11
 ecall
     c1c:	00000073          	ecall
 ret
     c20:	8082                	ret

0000000000000c22 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c22:	48b1                	li	a7,12
 ecall
     c24:	00000073          	ecall
 ret
     c28:	8082                	ret

0000000000000c2a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c2a:	48b5                	li	a7,13
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c32:	48b9                	li	a7,14
 ecall
     c34:	00000073          	ecall
 ret
     c38:	8082                	ret

0000000000000c3a <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     c3a:	48d9                	li	a7,22
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     c42:	48dd                	li	a7,23
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c4a:	1101                	addi	sp,sp,-32
     c4c:	ec06                	sd	ra,24(sp)
     c4e:	e822                	sd	s0,16(sp)
     c50:	1000                	addi	s0,sp,32
     c52:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c56:	4605                	li	a2,1
     c58:	fef40593          	addi	a1,s0,-17
     c5c:	00000097          	auipc	ra,0x0
     c60:	f5e080e7          	jalr	-162(ra) # bba <write>
}
     c64:	60e2                	ld	ra,24(sp)
     c66:	6442                	ld	s0,16(sp)
     c68:	6105                	addi	sp,sp,32
     c6a:	8082                	ret

0000000000000c6c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c6c:	7139                	addi	sp,sp,-64
     c6e:	fc06                	sd	ra,56(sp)
     c70:	f822                	sd	s0,48(sp)
     c72:	f426                	sd	s1,40(sp)
     c74:	f04a                	sd	s2,32(sp)
     c76:	ec4e                	sd	s3,24(sp)
     c78:	0080                	addi	s0,sp,64
     c7a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c7c:	c299                	beqz	a3,c82 <printint+0x16>
     c7e:	0805c963          	bltz	a1,d10 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c82:	2581                	sext.w	a1,a1
  neg = 0;
     c84:	4881                	li	a7,0
     c86:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c8a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c8c:	2601                	sext.w	a2,a2
     c8e:	00001517          	auipc	a0,0x1
     c92:	94a50513          	addi	a0,a0,-1718 # 15d8 <digits>
     c96:	883a                	mv	a6,a4
     c98:	2705                	addiw	a4,a4,1
     c9a:	02c5f7bb          	remuw	a5,a1,a2
     c9e:	1782                	slli	a5,a5,0x20
     ca0:	9381                	srli	a5,a5,0x20
     ca2:	97aa                	add	a5,a5,a0
     ca4:	0007c783          	lbu	a5,0(a5)
     ca8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cac:	0005879b          	sext.w	a5,a1
     cb0:	02c5d5bb          	divuw	a1,a1,a2
     cb4:	0685                	addi	a3,a3,1
     cb6:	fec7f0e3          	bgeu	a5,a2,c96 <printint+0x2a>
  if(neg)
     cba:	00088c63          	beqz	a7,cd2 <printint+0x66>
    buf[i++] = '-';
     cbe:	fd070793          	addi	a5,a4,-48
     cc2:	00878733          	add	a4,a5,s0
     cc6:	02d00793          	li	a5,45
     cca:	fef70823          	sb	a5,-16(a4)
     cce:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     cd2:	02e05863          	blez	a4,d02 <printint+0x96>
     cd6:	fc040793          	addi	a5,s0,-64
     cda:	00e78933          	add	s2,a5,a4
     cde:	fff78993          	addi	s3,a5,-1
     ce2:	99ba                	add	s3,s3,a4
     ce4:	377d                	addiw	a4,a4,-1
     ce6:	1702                	slli	a4,a4,0x20
     ce8:	9301                	srli	a4,a4,0x20
     cea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cee:	fff94583          	lbu	a1,-1(s2)
     cf2:	8526                	mv	a0,s1
     cf4:	00000097          	auipc	ra,0x0
     cf8:	f56080e7          	jalr	-170(ra) # c4a <putc>
  while(--i >= 0)
     cfc:	197d                	addi	s2,s2,-1
     cfe:	ff3918e3          	bne	s2,s3,cee <printint+0x82>
}
     d02:	70e2                	ld	ra,56(sp)
     d04:	7442                	ld	s0,48(sp)
     d06:	74a2                	ld	s1,40(sp)
     d08:	7902                	ld	s2,32(sp)
     d0a:	69e2                	ld	s3,24(sp)
     d0c:	6121                	addi	sp,sp,64
     d0e:	8082                	ret
    x = -xx;
     d10:	40b005bb          	negw	a1,a1
    neg = 1;
     d14:	4885                	li	a7,1
    x = -xx;
     d16:	bf85                	j	c86 <printint+0x1a>

0000000000000d18 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d18:	7119                	addi	sp,sp,-128
     d1a:	fc86                	sd	ra,120(sp)
     d1c:	f8a2                	sd	s0,112(sp)
     d1e:	f4a6                	sd	s1,104(sp)
     d20:	f0ca                	sd	s2,96(sp)
     d22:	ecce                	sd	s3,88(sp)
     d24:	e8d2                	sd	s4,80(sp)
     d26:	e4d6                	sd	s5,72(sp)
     d28:	e0da                	sd	s6,64(sp)
     d2a:	fc5e                	sd	s7,56(sp)
     d2c:	f862                	sd	s8,48(sp)
     d2e:	f466                	sd	s9,40(sp)
     d30:	f06a                	sd	s10,32(sp)
     d32:	ec6e                	sd	s11,24(sp)
     d34:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d36:	0005c903          	lbu	s2,0(a1)
     d3a:	18090f63          	beqz	s2,ed8 <vprintf+0x1c0>
     d3e:	8aaa                	mv	s5,a0
     d40:	8b32                	mv	s6,a2
     d42:	00158493          	addi	s1,a1,1
  state = 0;
     d46:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d48:	02500a13          	li	s4,37
     d4c:	4c55                	li	s8,21
     d4e:	00001c97          	auipc	s9,0x1
     d52:	832c8c93          	addi	s9,s9,-1998 # 1580 <malloc+0x5a4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     d56:	02800d93          	li	s11,40
  putc(fd, 'x');
     d5a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d5c:	00001b97          	auipc	s7,0x1
     d60:	87cb8b93          	addi	s7,s7,-1924 # 15d8 <digits>
     d64:	a839                	j	d82 <vprintf+0x6a>
        putc(fd, c);
     d66:	85ca                	mv	a1,s2
     d68:	8556                	mv	a0,s5
     d6a:	00000097          	auipc	ra,0x0
     d6e:	ee0080e7          	jalr	-288(ra) # c4a <putc>
     d72:	a019                	j	d78 <vprintf+0x60>
    } else if(state == '%'){
     d74:	01498d63          	beq	s3,s4,d8e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     d78:	0485                	addi	s1,s1,1
     d7a:	fff4c903          	lbu	s2,-1(s1)
     d7e:	14090d63          	beqz	s2,ed8 <vprintf+0x1c0>
    if(state == 0){
     d82:	fe0999e3          	bnez	s3,d74 <vprintf+0x5c>
      if(c == '%'){
     d86:	ff4910e3          	bne	s2,s4,d66 <vprintf+0x4e>
        state = '%';
     d8a:	89d2                	mv	s3,s4
     d8c:	b7f5                	j	d78 <vprintf+0x60>
      if(c == 'd'){
     d8e:	11490c63          	beq	s2,s4,ea6 <vprintf+0x18e>
     d92:	f9d9079b          	addiw	a5,s2,-99
     d96:	0ff7f793          	zext.b	a5,a5
     d9a:	10fc6e63          	bltu	s8,a5,eb6 <vprintf+0x19e>
     d9e:	f9d9079b          	addiw	a5,s2,-99
     da2:	0ff7f713          	zext.b	a4,a5
     da6:	10ec6863          	bltu	s8,a4,eb6 <vprintf+0x19e>
     daa:	00271793          	slli	a5,a4,0x2
     dae:	97e6                	add	a5,a5,s9
     db0:	439c                	lw	a5,0(a5)
     db2:	97e6                	add	a5,a5,s9
     db4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     db6:	008b0913          	addi	s2,s6,8
     dba:	4685                	li	a3,1
     dbc:	4629                	li	a2,10
     dbe:	000b2583          	lw	a1,0(s6)
     dc2:	8556                	mv	a0,s5
     dc4:	00000097          	auipc	ra,0x0
     dc8:	ea8080e7          	jalr	-344(ra) # c6c <printint>
     dcc:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     dce:	4981                	li	s3,0
     dd0:	b765                	j	d78 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     dd2:	008b0913          	addi	s2,s6,8
     dd6:	4681                	li	a3,0
     dd8:	4629                	li	a2,10
     dda:	000b2583          	lw	a1,0(s6)
     dde:	8556                	mv	a0,s5
     de0:	00000097          	auipc	ra,0x0
     de4:	e8c080e7          	jalr	-372(ra) # c6c <printint>
     de8:	8b4a                	mv	s6,s2
      state = 0;
     dea:	4981                	li	s3,0
     dec:	b771                	j	d78 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     dee:	008b0913          	addi	s2,s6,8
     df2:	4681                	li	a3,0
     df4:	866a                	mv	a2,s10
     df6:	000b2583          	lw	a1,0(s6)
     dfa:	8556                	mv	a0,s5
     dfc:	00000097          	auipc	ra,0x0
     e00:	e70080e7          	jalr	-400(ra) # c6c <printint>
     e04:	8b4a                	mv	s6,s2
      state = 0;
     e06:	4981                	li	s3,0
     e08:	bf85                	j	d78 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     e0a:	008b0793          	addi	a5,s6,8
     e0e:	f8f43423          	sd	a5,-120(s0)
     e12:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     e16:	03000593          	li	a1,48
     e1a:	8556                	mv	a0,s5
     e1c:	00000097          	auipc	ra,0x0
     e20:	e2e080e7          	jalr	-466(ra) # c4a <putc>
  putc(fd, 'x');
     e24:	07800593          	li	a1,120
     e28:	8556                	mv	a0,s5
     e2a:	00000097          	auipc	ra,0x0
     e2e:	e20080e7          	jalr	-480(ra) # c4a <putc>
     e32:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e34:	03c9d793          	srli	a5,s3,0x3c
     e38:	97de                	add	a5,a5,s7
     e3a:	0007c583          	lbu	a1,0(a5)
     e3e:	8556                	mv	a0,s5
     e40:	00000097          	auipc	ra,0x0
     e44:	e0a080e7          	jalr	-502(ra) # c4a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e48:	0992                	slli	s3,s3,0x4
     e4a:	397d                	addiw	s2,s2,-1
     e4c:	fe0914e3          	bnez	s2,e34 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
     e50:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     e54:	4981                	li	s3,0
     e56:	b70d                	j	d78 <vprintf+0x60>
        s = va_arg(ap, char*);
     e58:	008b0913          	addi	s2,s6,8
     e5c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
     e60:	02098163          	beqz	s3,e82 <vprintf+0x16a>
        while(*s != 0){
     e64:	0009c583          	lbu	a1,0(s3)
     e68:	c5ad                	beqz	a1,ed2 <vprintf+0x1ba>
          putc(fd, *s);
     e6a:	8556                	mv	a0,s5
     e6c:	00000097          	auipc	ra,0x0
     e70:	dde080e7          	jalr	-546(ra) # c4a <putc>
          s++;
     e74:	0985                	addi	s3,s3,1
        while(*s != 0){
     e76:	0009c583          	lbu	a1,0(s3)
     e7a:	f9e5                	bnez	a1,e6a <vprintf+0x152>
        s = va_arg(ap, char*);
     e7c:	8b4a                	mv	s6,s2
      state = 0;
     e7e:	4981                	li	s3,0
     e80:	bde5                	j	d78 <vprintf+0x60>
          s = "(null)";
     e82:	00000997          	auipc	s3,0x0
     e86:	6f698993          	addi	s3,s3,1782 # 1578 <malloc+0x59c>
        while(*s != 0){
     e8a:	85ee                	mv	a1,s11
     e8c:	bff9                	j	e6a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
     e8e:	008b0913          	addi	s2,s6,8
     e92:	000b4583          	lbu	a1,0(s6)
     e96:	8556                	mv	a0,s5
     e98:	00000097          	auipc	ra,0x0
     e9c:	db2080e7          	jalr	-590(ra) # c4a <putc>
     ea0:	8b4a                	mv	s6,s2
      state = 0;
     ea2:	4981                	li	s3,0
     ea4:	bdd1                	j	d78 <vprintf+0x60>
        putc(fd, c);
     ea6:	85d2                	mv	a1,s4
     ea8:	8556                	mv	a0,s5
     eaa:	00000097          	auipc	ra,0x0
     eae:	da0080e7          	jalr	-608(ra) # c4a <putc>
      state = 0;
     eb2:	4981                	li	s3,0
     eb4:	b5d1                	j	d78 <vprintf+0x60>
        putc(fd, '%');
     eb6:	85d2                	mv	a1,s4
     eb8:	8556                	mv	a0,s5
     eba:	00000097          	auipc	ra,0x0
     ebe:	d90080e7          	jalr	-624(ra) # c4a <putc>
        putc(fd, c);
     ec2:	85ca                	mv	a1,s2
     ec4:	8556                	mv	a0,s5
     ec6:	00000097          	auipc	ra,0x0
     eca:	d84080e7          	jalr	-636(ra) # c4a <putc>
      state = 0;
     ece:	4981                	li	s3,0
     ed0:	b565                	j	d78 <vprintf+0x60>
        s = va_arg(ap, char*);
     ed2:	8b4a                	mv	s6,s2
      state = 0;
     ed4:	4981                	li	s3,0
     ed6:	b54d                	j	d78 <vprintf+0x60>
    }
  }
}
     ed8:	70e6                	ld	ra,120(sp)
     eda:	7446                	ld	s0,112(sp)
     edc:	74a6                	ld	s1,104(sp)
     ede:	7906                	ld	s2,96(sp)
     ee0:	69e6                	ld	s3,88(sp)
     ee2:	6a46                	ld	s4,80(sp)
     ee4:	6aa6                	ld	s5,72(sp)
     ee6:	6b06                	ld	s6,64(sp)
     ee8:	7be2                	ld	s7,56(sp)
     eea:	7c42                	ld	s8,48(sp)
     eec:	7ca2                	ld	s9,40(sp)
     eee:	7d02                	ld	s10,32(sp)
     ef0:	6de2                	ld	s11,24(sp)
     ef2:	6109                	addi	sp,sp,128
     ef4:	8082                	ret

0000000000000ef6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     ef6:	715d                	addi	sp,sp,-80
     ef8:	ec06                	sd	ra,24(sp)
     efa:	e822                	sd	s0,16(sp)
     efc:	1000                	addi	s0,sp,32
     efe:	e010                	sd	a2,0(s0)
     f00:	e414                	sd	a3,8(s0)
     f02:	e818                	sd	a4,16(s0)
     f04:	ec1c                	sd	a5,24(s0)
     f06:	03043023          	sd	a6,32(s0)
     f0a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f0e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f12:	8622                	mv	a2,s0
     f14:	00000097          	auipc	ra,0x0
     f18:	e04080e7          	jalr	-508(ra) # d18 <vprintf>
}
     f1c:	60e2                	ld	ra,24(sp)
     f1e:	6442                	ld	s0,16(sp)
     f20:	6161                	addi	sp,sp,80
     f22:	8082                	ret

0000000000000f24 <printf>:

void
printf(const char *fmt, ...)
{
     f24:	711d                	addi	sp,sp,-96
     f26:	ec06                	sd	ra,24(sp)
     f28:	e822                	sd	s0,16(sp)
     f2a:	1000                	addi	s0,sp,32
     f2c:	e40c                	sd	a1,8(s0)
     f2e:	e810                	sd	a2,16(s0)
     f30:	ec14                	sd	a3,24(s0)
     f32:	f018                	sd	a4,32(s0)
     f34:	f41c                	sd	a5,40(s0)
     f36:	03043823          	sd	a6,48(s0)
     f3a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f3e:	00840613          	addi	a2,s0,8
     f42:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f46:	85aa                	mv	a1,a0
     f48:	4505                	li	a0,1
     f4a:	00000097          	auipc	ra,0x0
     f4e:	dce080e7          	jalr	-562(ra) # d18 <vprintf>
}
     f52:	60e2                	ld	ra,24(sp)
     f54:	6442                	ld	s0,16(sp)
     f56:	6125                	addi	sp,sp,96
     f58:	8082                	ret

0000000000000f5a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f5a:	1141                	addi	sp,sp,-16
     f5c:	e422                	sd	s0,8(sp)
     f5e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f60:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f64:	00000797          	auipc	a5,0x0
     f68:	6947b783          	ld	a5,1684(a5) # 15f8 <freep>
     f6c:	a02d                	j	f96 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f6e:	4618                	lw	a4,8(a2)
     f70:	9f2d                	addw	a4,a4,a1
     f72:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f76:	6398                	ld	a4,0(a5)
     f78:	6310                	ld	a2,0(a4)
     f7a:	a83d                	j	fb8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f7c:	ff852703          	lw	a4,-8(a0)
     f80:	9f31                	addw	a4,a4,a2
     f82:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f84:	ff053683          	ld	a3,-16(a0)
     f88:	a091                	j	fcc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f8a:	6398                	ld	a4,0(a5)
     f8c:	00e7e463          	bltu	a5,a4,f94 <free+0x3a>
     f90:	00e6ea63          	bltu	a3,a4,fa4 <free+0x4a>
{
     f94:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f96:	fed7fae3          	bgeu	a5,a3,f8a <free+0x30>
     f9a:	6398                	ld	a4,0(a5)
     f9c:	00e6e463          	bltu	a3,a4,fa4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fa0:	fee7eae3          	bltu	a5,a4,f94 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     fa4:	ff852583          	lw	a1,-8(a0)
     fa8:	6390                	ld	a2,0(a5)
     faa:	02059813          	slli	a6,a1,0x20
     fae:	01c85713          	srli	a4,a6,0x1c
     fb2:	9736                	add	a4,a4,a3
     fb4:	fae60de3          	beq	a2,a4,f6e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     fb8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     fbc:	4790                	lw	a2,8(a5)
     fbe:	02061593          	slli	a1,a2,0x20
     fc2:	01c5d713          	srli	a4,a1,0x1c
     fc6:	973e                	add	a4,a4,a5
     fc8:	fae68ae3          	beq	a3,a4,f7c <free+0x22>
    p->s.ptr = bp->s.ptr;
     fcc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     fce:	00000717          	auipc	a4,0x0
     fd2:	62f73523          	sd	a5,1578(a4) # 15f8 <freep>
}
     fd6:	6422                	ld	s0,8(sp)
     fd8:	0141                	addi	sp,sp,16
     fda:	8082                	ret

0000000000000fdc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     fdc:	7139                	addi	sp,sp,-64
     fde:	fc06                	sd	ra,56(sp)
     fe0:	f822                	sd	s0,48(sp)
     fe2:	f426                	sd	s1,40(sp)
     fe4:	f04a                	sd	s2,32(sp)
     fe6:	ec4e                	sd	s3,24(sp)
     fe8:	e852                	sd	s4,16(sp)
     fea:	e456                	sd	s5,8(sp)
     fec:	e05a                	sd	s6,0(sp)
     fee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     ff0:	02051493          	slli	s1,a0,0x20
     ff4:	9081                	srli	s1,s1,0x20
     ff6:	04bd                	addi	s1,s1,15
     ff8:	8091                	srli	s1,s1,0x4
     ffa:	0014899b          	addiw	s3,s1,1
     ffe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1000:	00000517          	auipc	a0,0x0
    1004:	5f853503          	ld	a0,1528(a0) # 15f8 <freep>
    1008:	c515                	beqz	a0,1034 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    100a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    100c:	4798                	lw	a4,8(a5)
    100e:	02977f63          	bgeu	a4,s1,104c <malloc+0x70>
    1012:	8a4e                	mv	s4,s3
    1014:	0009871b          	sext.w	a4,s3
    1018:	6685                	lui	a3,0x1
    101a:	00d77363          	bgeu	a4,a3,1020 <malloc+0x44>
    101e:	6a05                	lui	s4,0x1
    1020:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1024:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1028:	00000917          	auipc	s2,0x0
    102c:	5d090913          	addi	s2,s2,1488 # 15f8 <freep>
  if(p == (char*)-1)
    1030:	5afd                	li	s5,-1
    1032:	a895                	j	10a6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    1034:	00001797          	auipc	a5,0x1
    1038:	9cc78793          	addi	a5,a5,-1588 # 1a00 <base>
    103c:	00000717          	auipc	a4,0x0
    1040:	5af73e23          	sd	a5,1468(a4) # 15f8 <freep>
    1044:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1046:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    104a:	b7e1                	j	1012 <malloc+0x36>
      if(p->s.size == nunits)
    104c:	02e48c63          	beq	s1,a4,1084 <malloc+0xa8>
        p->s.size -= nunits;
    1050:	4137073b          	subw	a4,a4,s3
    1054:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1056:	02071693          	slli	a3,a4,0x20
    105a:	01c6d713          	srli	a4,a3,0x1c
    105e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1060:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1064:	00000717          	auipc	a4,0x0
    1068:	58a73a23          	sd	a0,1428(a4) # 15f8 <freep>
      return (void*)(p + 1);
    106c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1070:	70e2                	ld	ra,56(sp)
    1072:	7442                	ld	s0,48(sp)
    1074:	74a2                	ld	s1,40(sp)
    1076:	7902                	ld	s2,32(sp)
    1078:	69e2                	ld	s3,24(sp)
    107a:	6a42                	ld	s4,16(sp)
    107c:	6aa2                	ld	s5,8(sp)
    107e:	6b02                	ld	s6,0(sp)
    1080:	6121                	addi	sp,sp,64
    1082:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1084:	6398                	ld	a4,0(a5)
    1086:	e118                	sd	a4,0(a0)
    1088:	bff1                	j	1064 <malloc+0x88>
  hp->s.size = nu;
    108a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    108e:	0541                	addi	a0,a0,16
    1090:	00000097          	auipc	ra,0x0
    1094:	eca080e7          	jalr	-310(ra) # f5a <free>
  return freep;
    1098:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    109c:	d971                	beqz	a0,1070 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    109e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10a0:	4798                	lw	a4,8(a5)
    10a2:	fa9775e3          	bgeu	a4,s1,104c <malloc+0x70>
    if(p == freep)
    10a6:	00093703          	ld	a4,0(s2)
    10aa:	853e                	mv	a0,a5
    10ac:	fef719e3          	bne	a4,a5,109e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    10b0:	8552                	mv	a0,s4
    10b2:	00000097          	auipc	ra,0x0
    10b6:	b70080e7          	jalr	-1168(ra) # c22 <sbrk>
  if(p == (char*)-1)
    10ba:	fd5518e3          	bne	a0,s5,108a <malloc+0xae>
        return 0;
    10be:	4501                	li	a0,0
    10c0:	bf45                	j	1070 <malloc+0x94>
