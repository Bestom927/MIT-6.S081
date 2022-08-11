
user/_usertests：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	888080e7          	jalr	-1912(ra) # 5898 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	876080e7          	jalr	-1930(ra) # 5898 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	d4250513          	addi	a0,a0,-702 # 5d80 <malloc+0xe6>
      46:	00006097          	auipc	ra,0x6
      4a:	b9c080e7          	jalr	-1124(ra) # 5be2 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	808080e7          	jalr	-2040(ra) # 5858 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	69078793          	addi	a5,a5,1680 # 96e8 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	d9868693          	addi	a3,a3,-616 # bdf8 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	d2050513          	addi	a0,a0,-736 # 5da0 <malloc+0x106>
      88:	00006097          	auipc	ra,0x6
      8c:	b5a080e7          	jalr	-1190(ra) # 5be2 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	7c6080e7          	jalr	1990(ra) # 5858 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	d1050513          	addi	a0,a0,-752 # 5db8 <malloc+0x11e>
      b0:	00005097          	auipc	ra,0x5
      b4:	7e8080e7          	jalr	2024(ra) # 5898 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	7c4080e7          	jalr	1988(ra) # 5880 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	d1250513          	addi	a0,a0,-750 # 5dd8 <malloc+0x13e>
      ce:	00005097          	auipc	ra,0x5
      d2:	7ca080e7          	jalr	1994(ra) # 5898 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	cda50513          	addi	a0,a0,-806 # 5dc0 <malloc+0x126>
      ee:	00006097          	auipc	ra,0x6
      f2:	af4080e7          	jalr	-1292(ra) # 5be2 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	760080e7          	jalr	1888(ra) # 5858 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	ce650513          	addi	a0,a0,-794 # 5de8 <malloc+0x14e>
     10a:	00006097          	auipc	ra,0x6
     10e:	ad8080e7          	jalr	-1320(ra) # 5be2 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	744080e7          	jalr	1860(ra) # 5858 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	ce450513          	addi	a0,a0,-796 # 5e10 <malloc+0x176>
     134:	00005097          	auipc	ra,0x5
     138:	774080e7          	jalr	1908(ra) # 58a8 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	cd050513          	addi	a0,a0,-816 # 5e10 <malloc+0x176>
     148:	00005097          	auipc	ra,0x5
     14c:	750080e7          	jalr	1872(ra) # 5898 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	ccc58593          	addi	a1,a1,-820 # 5e20 <malloc+0x186>
     15c:	00005097          	auipc	ra,0x5
     160:	71c080e7          	jalr	1820(ra) # 5878 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	ca850513          	addi	a0,a0,-856 # 5e10 <malloc+0x176>
     170:	00005097          	auipc	ra,0x5
     174:	728080e7          	jalr	1832(ra) # 5898 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	cac58593          	addi	a1,a1,-852 # 5e28 <malloc+0x18e>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	6f2080e7          	jalr	1778(ra) # 5878 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	c7c50513          	addi	a0,a0,-900 # 5e10 <malloc+0x176>
     19c:	00005097          	auipc	ra,0x5
     1a0:	70c080e7          	jalr	1804(ra) # 58a8 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	6da080e7          	jalr	1754(ra) # 5880 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	6d0080e7          	jalr	1744(ra) # 5880 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	c6650513          	addi	a0,a0,-922 # 5e30 <malloc+0x196>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	a10080e7          	jalr	-1520(ra) # 5be2 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	67c080e7          	jalr	1660(ra) # 5858 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	688080e7          	jalr	1672(ra) # 5898 <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	668080e7          	jalr	1640(ra) # 5880 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	662080e7          	jalr	1634(ra) # 58a8 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	bdc50513          	addi	a0,a0,-1060 # 5e58 <malloc+0x1be>
     284:	00005097          	auipc	ra,0x5
     288:	624080e7          	jalr	1572(ra) # 58a8 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	bc8a8a93          	addi	s5,s5,-1080 # 5e58 <malloc+0x1be>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	b60a0a13          	addi	s4,s4,-1184 # bdf8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirtest+0x97>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	5ec080e7          	jalr	1516(ra) # 5898 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	5ba080e7          	jalr	1466(ra) # 5878 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	5a6080e7          	jalr	1446(ra) # 5878 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	5a0080e7          	jalr	1440(ra) # 5880 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	5be080e7          	jalr	1470(ra) # 58a8 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	b5650513          	addi	a0,a0,-1194 # 5e68 <malloc+0x1ce>
     31a:	00006097          	auipc	ra,0x6
     31e:	8c8080e7          	jalr	-1848(ra) # 5be2 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	534080e7          	jalr	1332(ra) # 5858 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	b5450513          	addi	a0,a0,-1196 # 5e88 <malloc+0x1ee>
     33c:	00006097          	auipc	ra,0x6
     340:	8a6080e7          	jalr	-1882(ra) # 5be2 <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00005097          	auipc	ra,0x5
     34a:	512080e7          	jalr	1298(ra) # 5858 <exit>

000000000000034e <copyin>:
{
     34e:	715d                	addi	sp,sp,-80
     350:	e486                	sd	ra,72(sp)
     352:	e0a2                	sd	s0,64(sp)
     354:	fc26                	sd	s1,56(sp)
     356:	f84a                	sd	s2,48(sp)
     358:	f44e                	sd	s3,40(sp)
     35a:	f052                	sd	s4,32(sp)
     35c:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     35e:	4785                	li	a5,1
     360:	07fe                	slli	a5,a5,0x1f
     362:	fcf43023          	sd	a5,-64(s0)
     366:	57fd                	li	a5,-1
     368:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     370:	00006a17          	auipc	s4,0x6
     374:	b30a0a13          	addi	s4,s4,-1232 # 5ea0 <malloc+0x206>
    uint64 addr = addrs[ai];
     378:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37c:	20100593          	li	a1,513
     380:	8552                	mv	a0,s4
     382:	00005097          	auipc	ra,0x5
     386:	516080e7          	jalr	1302(ra) # 5898 <open>
     38a:	84aa                	mv	s1,a0
    if(fd < 0){
     38c:	08054863          	bltz	a0,41c <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     390:	6609                	lui	a2,0x2
     392:	85ce                	mv	a1,s3
     394:	00005097          	auipc	ra,0x5
     398:	4e4080e7          	jalr	1252(ra) # 5878 <write>
    if(n >= 0){
     39c:	08055d63          	bgez	a0,436 <copyin+0xe8>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00005097          	auipc	ra,0x5
     3a6:	4de080e7          	jalr	1246(ra) # 5880 <close>
    unlink("copyin1");
     3aa:	8552                	mv	a0,s4
     3ac:	00005097          	auipc	ra,0x5
     3b0:	4fc080e7          	jalr	1276(ra) # 58a8 <unlink>
    n = write(1, (char*)addr, 8192);
     3b4:	6609                	lui	a2,0x2
     3b6:	85ce                	mv	a1,s3
     3b8:	4505                	li	a0,1
     3ba:	00005097          	auipc	ra,0x5
     3be:	4be080e7          	jalr	1214(ra) # 5878 <write>
    if(n > 0){
     3c2:	08a04963          	bgtz	a0,454 <copyin+0x106>
    if(pipe(fds) < 0){
     3c6:	fb840513          	addi	a0,s0,-72
     3ca:	00005097          	auipc	ra,0x5
     3ce:	49e080e7          	jalr	1182(ra) # 5868 <pipe>
     3d2:	0a054063          	bltz	a0,472 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d6:	6609                	lui	a2,0x2
     3d8:	85ce                	mv	a1,s3
     3da:	fbc42503          	lw	a0,-68(s0)
     3de:	00005097          	auipc	ra,0x5
     3e2:	49a080e7          	jalr	1178(ra) # 5878 <write>
    if(n > 0){
     3e6:	0aa04363          	bgtz	a0,48c <copyin+0x13e>
    close(fds[0]);
     3ea:	fb842503          	lw	a0,-72(s0)
     3ee:	00005097          	auipc	ra,0x5
     3f2:	492080e7          	jalr	1170(ra) # 5880 <close>
    close(fds[1]);
     3f6:	fbc42503          	lw	a0,-68(s0)
     3fa:	00005097          	auipc	ra,0x5
     3fe:	486080e7          	jalr	1158(ra) # 5880 <close>
  for(int ai = 0; ai < 2; ai++){
     402:	0921                	addi	s2,s2,8
     404:	fd040793          	addi	a5,s0,-48
     408:	f6f918e3          	bne	s2,a5,378 <copyin+0x2a>
}
     40c:	60a6                	ld	ra,72(sp)
     40e:	6406                	ld	s0,64(sp)
     410:	74e2                	ld	s1,56(sp)
     412:	7942                	ld	s2,48(sp)
     414:	79a2                	ld	s3,40(sp)
     416:	7a02                	ld	s4,32(sp)
     418:	6161                	addi	sp,sp,80
     41a:	8082                	ret
      printf("open(copyin1) failed\n");
     41c:	00006517          	auipc	a0,0x6
     420:	a8c50513          	addi	a0,a0,-1396 # 5ea8 <malloc+0x20e>
     424:	00005097          	auipc	ra,0x5
     428:	7be080e7          	jalr	1982(ra) # 5be2 <printf>
      exit(1);
     42c:	4505                	li	a0,1
     42e:	00005097          	auipc	ra,0x5
     432:	42a080e7          	jalr	1066(ra) # 5858 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     436:	862a                	mv	a2,a0
     438:	85ce                	mv	a1,s3
     43a:	00006517          	auipc	a0,0x6
     43e:	a8650513          	addi	a0,a0,-1402 # 5ec0 <malloc+0x226>
     442:	00005097          	auipc	ra,0x5
     446:	7a0080e7          	jalr	1952(ra) # 5be2 <printf>
      exit(1);
     44a:	4505                	li	a0,1
     44c:	00005097          	auipc	ra,0x5
     450:	40c080e7          	jalr	1036(ra) # 5858 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     454:	862a                	mv	a2,a0
     456:	85ce                	mv	a1,s3
     458:	00006517          	auipc	a0,0x6
     45c:	a9850513          	addi	a0,a0,-1384 # 5ef0 <malloc+0x256>
     460:	00005097          	auipc	ra,0x5
     464:	782080e7          	jalr	1922(ra) # 5be2 <printf>
      exit(1);
     468:	4505                	li	a0,1
     46a:	00005097          	auipc	ra,0x5
     46e:	3ee080e7          	jalr	1006(ra) # 5858 <exit>
      printf("pipe() failed\n");
     472:	00006517          	auipc	a0,0x6
     476:	aae50513          	addi	a0,a0,-1362 # 5f20 <malloc+0x286>
     47a:	00005097          	auipc	ra,0x5
     47e:	768080e7          	jalr	1896(ra) # 5be2 <printf>
      exit(1);
     482:	4505                	li	a0,1
     484:	00005097          	auipc	ra,0x5
     488:	3d4080e7          	jalr	980(ra) # 5858 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48c:	862a                	mv	a2,a0
     48e:	85ce                	mv	a1,s3
     490:	00006517          	auipc	a0,0x6
     494:	aa050513          	addi	a0,a0,-1376 # 5f30 <malloc+0x296>
     498:	00005097          	auipc	ra,0x5
     49c:	74a080e7          	jalr	1866(ra) # 5be2 <printf>
      exit(1);
     4a0:	4505                	li	a0,1
     4a2:	00005097          	auipc	ra,0x5
     4a6:	3b6080e7          	jalr	950(ra) # 5858 <exit>

00000000000004aa <copyout>:
{
     4aa:	711d                	addi	sp,sp,-96
     4ac:	ec86                	sd	ra,88(sp)
     4ae:	e8a2                	sd	s0,80(sp)
     4b0:	e4a6                	sd	s1,72(sp)
     4b2:	e0ca                	sd	s2,64(sp)
     4b4:	fc4e                	sd	s3,56(sp)
     4b6:	f852                	sd	s4,48(sp)
     4b8:	f456                	sd	s5,40(sp)
     4ba:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4bc:	4785                	li	a5,1
     4be:	07fe                	slli	a5,a5,0x1f
     4c0:	faf43823          	sd	a5,-80(s0)
     4c4:	57fd                	li	a5,-1
     4c6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4ca:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4ce:	00006a17          	auipc	s4,0x6
     4d2:	a92a0a13          	addi	s4,s4,-1390 # 5f60 <malloc+0x2c6>
    n = write(fds[1], "x", 1);
     4d6:	00006a97          	auipc	s5,0x6
     4da:	952a8a93          	addi	s5,s5,-1710 # 5e28 <malloc+0x18e>
    uint64 addr = addrs[ai];
     4de:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e2:	4581                	li	a1,0
     4e4:	8552                	mv	a0,s4
     4e6:	00005097          	auipc	ra,0x5
     4ea:	3b2080e7          	jalr	946(ra) # 5898 <open>
     4ee:	84aa                	mv	s1,a0
    if(fd < 0){
     4f0:	08054663          	bltz	a0,57c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f4:	6609                	lui	a2,0x2
     4f6:	85ce                	mv	a1,s3
     4f8:	00005097          	auipc	ra,0x5
     4fc:	378080e7          	jalr	888(ra) # 5870 <read>
    if(n > 0){
     500:	08a04b63          	bgtz	a0,596 <copyout+0xec>
    close(fd);
     504:	8526                	mv	a0,s1
     506:	00005097          	auipc	ra,0x5
     50a:	37a080e7          	jalr	890(ra) # 5880 <close>
    if(pipe(fds) < 0){
     50e:	fa840513          	addi	a0,s0,-88
     512:	00005097          	auipc	ra,0x5
     516:	356080e7          	jalr	854(ra) # 5868 <pipe>
     51a:	08054d63          	bltz	a0,5b4 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     51e:	4605                	li	a2,1
     520:	85d6                	mv	a1,s5
     522:	fac42503          	lw	a0,-84(s0)
     526:	00005097          	auipc	ra,0x5
     52a:	352080e7          	jalr	850(ra) # 5878 <write>
    if(n != 1){
     52e:	4785                	li	a5,1
     530:	08f51f63          	bne	a0,a5,5ce <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     534:	6609                	lui	a2,0x2
     536:	85ce                	mv	a1,s3
     538:	fa842503          	lw	a0,-88(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	334080e7          	jalr	820(ra) # 5870 <read>
    if(n > 0){
     544:	0aa04263          	bgtz	a0,5e8 <copyout+0x13e>
    close(fds[0]);
     548:	fa842503          	lw	a0,-88(s0)
     54c:	00005097          	auipc	ra,0x5
     550:	334080e7          	jalr	820(ra) # 5880 <close>
    close(fds[1]);
     554:	fac42503          	lw	a0,-84(s0)
     558:	00005097          	auipc	ra,0x5
     55c:	328080e7          	jalr	808(ra) # 5880 <close>
  for(int ai = 0; ai < 2; ai++){
     560:	0921                	addi	s2,s2,8
     562:	fc040793          	addi	a5,s0,-64
     566:	f6f91ce3          	bne	s2,a5,4de <copyout+0x34>
}
     56a:	60e6                	ld	ra,88(sp)
     56c:	6446                	ld	s0,80(sp)
     56e:	64a6                	ld	s1,72(sp)
     570:	6906                	ld	s2,64(sp)
     572:	79e2                	ld	s3,56(sp)
     574:	7a42                	ld	s4,48(sp)
     576:	7aa2                	ld	s5,40(sp)
     578:	6125                	addi	sp,sp,96
     57a:	8082                	ret
      printf("open(README) failed\n");
     57c:	00006517          	auipc	a0,0x6
     580:	9ec50513          	addi	a0,a0,-1556 # 5f68 <malloc+0x2ce>
     584:	00005097          	auipc	ra,0x5
     588:	65e080e7          	jalr	1630(ra) # 5be2 <printf>
      exit(1);
     58c:	4505                	li	a0,1
     58e:	00005097          	auipc	ra,0x5
     592:	2ca080e7          	jalr	714(ra) # 5858 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     596:	862a                	mv	a2,a0
     598:	85ce                	mv	a1,s3
     59a:	00006517          	auipc	a0,0x6
     59e:	9e650513          	addi	a0,a0,-1562 # 5f80 <malloc+0x2e6>
     5a2:	00005097          	auipc	ra,0x5
     5a6:	640080e7          	jalr	1600(ra) # 5be2 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	00005097          	auipc	ra,0x5
     5b0:	2ac080e7          	jalr	684(ra) # 5858 <exit>
      printf("pipe() failed\n");
     5b4:	00006517          	auipc	a0,0x6
     5b8:	96c50513          	addi	a0,a0,-1684 # 5f20 <malloc+0x286>
     5bc:	00005097          	auipc	ra,0x5
     5c0:	626080e7          	jalr	1574(ra) # 5be2 <printf>
      exit(1);
     5c4:	4505                	li	a0,1
     5c6:	00005097          	auipc	ra,0x5
     5ca:	292080e7          	jalr	658(ra) # 5858 <exit>
      printf("pipe write failed\n");
     5ce:	00006517          	auipc	a0,0x6
     5d2:	9e250513          	addi	a0,a0,-1566 # 5fb0 <malloc+0x316>
     5d6:	00005097          	auipc	ra,0x5
     5da:	60c080e7          	jalr	1548(ra) # 5be2 <printf>
      exit(1);
     5de:	4505                	li	a0,1
     5e0:	00005097          	auipc	ra,0x5
     5e4:	278080e7          	jalr	632(ra) # 5858 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5e8:	862a                	mv	a2,a0
     5ea:	85ce                	mv	a1,s3
     5ec:	00006517          	auipc	a0,0x6
     5f0:	9dc50513          	addi	a0,a0,-1572 # 5fc8 <malloc+0x32e>
     5f4:	00005097          	auipc	ra,0x5
     5f8:	5ee080e7          	jalr	1518(ra) # 5be2 <printf>
      exit(1);
     5fc:	4505                	li	a0,1
     5fe:	00005097          	auipc	ra,0x5
     602:	25a080e7          	jalr	602(ra) # 5858 <exit>

0000000000000606 <truncate1>:
{
     606:	711d                	addi	sp,sp,-96
     608:	ec86                	sd	ra,88(sp)
     60a:	e8a2                	sd	s0,80(sp)
     60c:	e4a6                	sd	s1,72(sp)
     60e:	e0ca                	sd	s2,64(sp)
     610:	fc4e                	sd	s3,56(sp)
     612:	f852                	sd	s4,48(sp)
     614:	f456                	sd	s5,40(sp)
     616:	1080                	addi	s0,sp,96
     618:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61a:	00005517          	auipc	a0,0x5
     61e:	7f650513          	addi	a0,a0,2038 # 5e10 <malloc+0x176>
     622:	00005097          	auipc	ra,0x5
     626:	286080e7          	jalr	646(ra) # 58a8 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62a:	60100593          	li	a1,1537
     62e:	00005517          	auipc	a0,0x5
     632:	7e250513          	addi	a0,a0,2018 # 5e10 <malloc+0x176>
     636:	00005097          	auipc	ra,0x5
     63a:	262080e7          	jalr	610(ra) # 5898 <open>
     63e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     640:	4611                	li	a2,4
     642:	00005597          	auipc	a1,0x5
     646:	7de58593          	addi	a1,a1,2014 # 5e20 <malloc+0x186>
     64a:	00005097          	auipc	ra,0x5
     64e:	22e080e7          	jalr	558(ra) # 5878 <write>
  close(fd1);
     652:	8526                	mv	a0,s1
     654:	00005097          	auipc	ra,0x5
     658:	22c080e7          	jalr	556(ra) # 5880 <close>
  int fd2 = open("truncfile", O_RDONLY);
     65c:	4581                	li	a1,0
     65e:	00005517          	auipc	a0,0x5
     662:	7b250513          	addi	a0,a0,1970 # 5e10 <malloc+0x176>
     666:	00005097          	auipc	ra,0x5
     66a:	232080e7          	jalr	562(ra) # 5898 <open>
     66e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     670:	02000613          	li	a2,32
     674:	fa040593          	addi	a1,s0,-96
     678:	00005097          	auipc	ra,0x5
     67c:	1f8080e7          	jalr	504(ra) # 5870 <read>
  if(n != 4){
     680:	4791                	li	a5,4
     682:	0cf51e63          	bne	a0,a5,75e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     686:	40100593          	li	a1,1025
     68a:	00005517          	auipc	a0,0x5
     68e:	78650513          	addi	a0,a0,1926 # 5e10 <malloc+0x176>
     692:	00005097          	auipc	ra,0x5
     696:	206080e7          	jalr	518(ra) # 5898 <open>
     69a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69c:	4581                	li	a1,0
     69e:	00005517          	auipc	a0,0x5
     6a2:	77250513          	addi	a0,a0,1906 # 5e10 <malloc+0x176>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	1f2080e7          	jalr	498(ra) # 5898 <open>
     6ae:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b0:	02000613          	li	a2,32
     6b4:	fa040593          	addi	a1,s0,-96
     6b8:	00005097          	auipc	ra,0x5
     6bc:	1b8080e7          	jalr	440(ra) # 5870 <read>
     6c0:	8a2a                	mv	s4,a0
  if(n != 0){
     6c2:	ed4d                	bnez	a0,77c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	addi	a1,s0,-96
     6cc:	8526                	mv	a0,s1
     6ce:	00005097          	auipc	ra,0x5
     6d2:	1a2080e7          	jalr	418(ra) # 5870 <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	e971                	bnez	a0,7ac <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6da:	4619                	li	a2,6
     6dc:	00006597          	auipc	a1,0x6
     6e0:	97c58593          	addi	a1,a1,-1668 # 6058 <malloc+0x3be>
     6e4:	854e                	mv	a0,s3
     6e6:	00005097          	auipc	ra,0x5
     6ea:	192080e7          	jalr	402(ra) # 5878 <write>
  n = read(fd3, buf, sizeof(buf));
     6ee:	02000613          	li	a2,32
     6f2:	fa040593          	addi	a1,s0,-96
     6f6:	854a                	mv	a0,s2
     6f8:	00005097          	auipc	ra,0x5
     6fc:	178080e7          	jalr	376(ra) # 5870 <read>
  if(n != 6){
     700:	4799                	li	a5,6
     702:	0cf51d63          	bne	a0,a5,7dc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     706:	02000613          	li	a2,32
     70a:	fa040593          	addi	a1,s0,-96
     70e:	8526                	mv	a0,s1
     710:	00005097          	auipc	ra,0x5
     714:	160080e7          	jalr	352(ra) # 5870 <read>
  if(n != 2){
     718:	4789                	li	a5,2
     71a:	0ef51063          	bne	a0,a5,7fa <truncate1+0x1f4>
  unlink("truncfile");
     71e:	00005517          	auipc	a0,0x5
     722:	6f250513          	addi	a0,a0,1778 # 5e10 <malloc+0x176>
     726:	00005097          	auipc	ra,0x5
     72a:	182080e7          	jalr	386(ra) # 58a8 <unlink>
  close(fd1);
     72e:	854e                	mv	a0,s3
     730:	00005097          	auipc	ra,0x5
     734:	150080e7          	jalr	336(ra) # 5880 <close>
  close(fd2);
     738:	8526                	mv	a0,s1
     73a:	00005097          	auipc	ra,0x5
     73e:	146080e7          	jalr	326(ra) # 5880 <close>
  close(fd3);
     742:	854a                	mv	a0,s2
     744:	00005097          	auipc	ra,0x5
     748:	13c080e7          	jalr	316(ra) # 5880 <close>
}
     74c:	60e6                	ld	ra,88(sp)
     74e:	6446                	ld	s0,80(sp)
     750:	64a6                	ld	s1,72(sp)
     752:	6906                	ld	s2,64(sp)
     754:	79e2                	ld	s3,56(sp)
     756:	7a42                	ld	s4,48(sp)
     758:	7aa2                	ld	s5,40(sp)
     75a:	6125                	addi	sp,sp,96
     75c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     75e:	862a                	mv	a2,a0
     760:	85d6                	mv	a1,s5
     762:	00006517          	auipc	a0,0x6
     766:	89650513          	addi	a0,a0,-1898 # 5ff8 <malloc+0x35e>
     76a:	00005097          	auipc	ra,0x5
     76e:	478080e7          	jalr	1144(ra) # 5be2 <printf>
    exit(1);
     772:	4505                	li	a0,1
     774:	00005097          	auipc	ra,0x5
     778:	0e4080e7          	jalr	228(ra) # 5858 <exit>
    printf("aaa fd3=%d\n", fd3);
     77c:	85ca                	mv	a1,s2
     77e:	00006517          	auipc	a0,0x6
     782:	89a50513          	addi	a0,a0,-1894 # 6018 <malloc+0x37e>
     786:	00005097          	auipc	ra,0x5
     78a:	45c080e7          	jalr	1116(ra) # 5be2 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     78e:	8652                	mv	a2,s4
     790:	85d6                	mv	a1,s5
     792:	00006517          	auipc	a0,0x6
     796:	89650513          	addi	a0,a0,-1898 # 6028 <malloc+0x38e>
     79a:	00005097          	auipc	ra,0x5
     79e:	448080e7          	jalr	1096(ra) # 5be2 <printf>
    exit(1);
     7a2:	4505                	li	a0,1
     7a4:	00005097          	auipc	ra,0x5
     7a8:	0b4080e7          	jalr	180(ra) # 5858 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ac:	85a6                	mv	a1,s1
     7ae:	00006517          	auipc	a0,0x6
     7b2:	89a50513          	addi	a0,a0,-1894 # 6048 <malloc+0x3ae>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	42c080e7          	jalr	1068(ra) # 5be2 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7be:	8652                	mv	a2,s4
     7c0:	85d6                	mv	a1,s5
     7c2:	00006517          	auipc	a0,0x6
     7c6:	86650513          	addi	a0,a0,-1946 # 6028 <malloc+0x38e>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	418080e7          	jalr	1048(ra) # 5be2 <printf>
    exit(1);
     7d2:	4505                	li	a0,1
     7d4:	00005097          	auipc	ra,0x5
     7d8:	084080e7          	jalr	132(ra) # 5858 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7dc:	862a                	mv	a2,a0
     7de:	85d6                	mv	a1,s5
     7e0:	00006517          	auipc	a0,0x6
     7e4:	88050513          	addi	a0,a0,-1920 # 6060 <malloc+0x3c6>
     7e8:	00005097          	auipc	ra,0x5
     7ec:	3fa080e7          	jalr	1018(ra) # 5be2 <printf>
    exit(1);
     7f0:	4505                	li	a0,1
     7f2:	00005097          	auipc	ra,0x5
     7f6:	066080e7          	jalr	102(ra) # 5858 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fa:	862a                	mv	a2,a0
     7fc:	85d6                	mv	a1,s5
     7fe:	00006517          	auipc	a0,0x6
     802:	88250513          	addi	a0,a0,-1918 # 6080 <malloc+0x3e6>
     806:	00005097          	auipc	ra,0x5
     80a:	3dc080e7          	jalr	988(ra) # 5be2 <printf>
    exit(1);
     80e:	4505                	li	a0,1
     810:	00005097          	auipc	ra,0x5
     814:	048080e7          	jalr	72(ra) # 5858 <exit>

0000000000000818 <writetest>:
{
     818:	7139                	addi	sp,sp,-64
     81a:	fc06                	sd	ra,56(sp)
     81c:	f822                	sd	s0,48(sp)
     81e:	f426                	sd	s1,40(sp)
     820:	f04a                	sd	s2,32(sp)
     822:	ec4e                	sd	s3,24(sp)
     824:	e852                	sd	s4,16(sp)
     826:	e456                	sd	s5,8(sp)
     828:	e05a                	sd	s6,0(sp)
     82a:	0080                	addi	s0,sp,64
     82c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     82e:	20200593          	li	a1,514
     832:	00006517          	auipc	a0,0x6
     836:	86e50513          	addi	a0,a0,-1938 # 60a0 <malloc+0x406>
     83a:	00005097          	auipc	ra,0x5
     83e:	05e080e7          	jalr	94(ra) # 5898 <open>
  if(fd < 0){
     842:	0a054d63          	bltz	a0,8fc <writetest+0xe4>
     846:	892a                	mv	s2,a0
     848:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84a:	00006997          	auipc	s3,0x6
     84e:	87e98993          	addi	s3,s3,-1922 # 60c8 <malloc+0x42e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     852:	00006a97          	auipc	s5,0x6
     856:	8aea8a93          	addi	s5,s5,-1874 # 6100 <malloc+0x466>
  for(i = 0; i < N; i++){
     85a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	4629                	li	a2,10
     860:	85ce                	mv	a1,s3
     862:	854a                	mv	a0,s2
     864:	00005097          	auipc	ra,0x5
     868:	014080e7          	jalr	20(ra) # 5878 <write>
     86c:	47a9                	li	a5,10
     86e:	0af51563          	bne	a0,a5,918 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85d6                	mv	a1,s5
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	000080e7          	jalr	ra # 5878 <write>
     880:	47a9                	li	a5,10
     882:	0af51a63          	bne	a0,a5,936 <writetest+0x11e>
  for(i = 0; i < N; i++){
     886:	2485                	addiw	s1,s1,1
     888:	fd449be3          	bne	s1,s4,85e <writetest+0x46>
  close(fd);
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	ff2080e7          	jalr	-14(ra) # 5880 <close>
  fd = open("small", O_RDONLY);
     896:	4581                	li	a1,0
     898:	00006517          	auipc	a0,0x6
     89c:	80850513          	addi	a0,a0,-2040 # 60a0 <malloc+0x406>
     8a0:	00005097          	auipc	ra,0x5
     8a4:	ff8080e7          	jalr	-8(ra) # 5898 <open>
     8a8:	84aa                	mv	s1,a0
  if(fd < 0){
     8aa:	0a054563          	bltz	a0,954 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8ae:	7d000613          	li	a2,2000
     8b2:	0000b597          	auipc	a1,0xb
     8b6:	54658593          	addi	a1,a1,1350 # bdf8 <buf>
     8ba:	00005097          	auipc	ra,0x5
     8be:	fb6080e7          	jalr	-74(ra) # 5870 <read>
  if(i != N*SZ*2){
     8c2:	7d000793          	li	a5,2000
     8c6:	0af51563          	bne	a0,a5,970 <writetest+0x158>
  close(fd);
     8ca:	8526                	mv	a0,s1
     8cc:	00005097          	auipc	ra,0x5
     8d0:	fb4080e7          	jalr	-76(ra) # 5880 <close>
  if(unlink("small") < 0){
     8d4:	00005517          	auipc	a0,0x5
     8d8:	7cc50513          	addi	a0,a0,1996 # 60a0 <malloc+0x406>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	fcc080e7          	jalr	-52(ra) # 58a8 <unlink>
     8e4:	0a054463          	bltz	a0,98c <writetest+0x174>
}
     8e8:	70e2                	ld	ra,56(sp)
     8ea:	7442                	ld	s0,48(sp)
     8ec:	74a2                	ld	s1,40(sp)
     8ee:	7902                	ld	s2,32(sp)
     8f0:	69e2                	ld	s3,24(sp)
     8f2:	6a42                	ld	s4,16(sp)
     8f4:	6aa2                	ld	s5,8(sp)
     8f6:	6b02                	ld	s6,0(sp)
     8f8:	6121                	addi	sp,sp,64
     8fa:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fc:	85da                	mv	a1,s6
     8fe:	00005517          	auipc	a0,0x5
     902:	7aa50513          	addi	a0,a0,1962 # 60a8 <malloc+0x40e>
     906:	00005097          	auipc	ra,0x5
     90a:	2dc080e7          	jalr	732(ra) # 5be2 <printf>
    exit(1);
     90e:	4505                	li	a0,1
     910:	00005097          	auipc	ra,0x5
     914:	f48080e7          	jalr	-184(ra) # 5858 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     918:	8626                	mv	a2,s1
     91a:	85da                	mv	a1,s6
     91c:	00005517          	auipc	a0,0x5
     920:	7bc50513          	addi	a0,a0,1980 # 60d8 <malloc+0x43e>
     924:	00005097          	auipc	ra,0x5
     928:	2be080e7          	jalr	702(ra) # 5be2 <printf>
      exit(1);
     92c:	4505                	li	a0,1
     92e:	00005097          	auipc	ra,0x5
     932:	f2a080e7          	jalr	-214(ra) # 5858 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     936:	8626                	mv	a2,s1
     938:	85da                	mv	a1,s6
     93a:	00005517          	auipc	a0,0x5
     93e:	7d650513          	addi	a0,a0,2006 # 6110 <malloc+0x476>
     942:	00005097          	auipc	ra,0x5
     946:	2a0080e7          	jalr	672(ra) # 5be2 <printf>
      exit(1);
     94a:	4505                	li	a0,1
     94c:	00005097          	auipc	ra,0x5
     950:	f0c080e7          	jalr	-244(ra) # 5858 <exit>
    printf("%s: error: open small failed!\n", s);
     954:	85da                	mv	a1,s6
     956:	00005517          	auipc	a0,0x5
     95a:	7e250513          	addi	a0,a0,2018 # 6138 <malloc+0x49e>
     95e:	00005097          	auipc	ra,0x5
     962:	284080e7          	jalr	644(ra) # 5be2 <printf>
    exit(1);
     966:	4505                	li	a0,1
     968:	00005097          	auipc	ra,0x5
     96c:	ef0080e7          	jalr	-272(ra) # 5858 <exit>
    printf("%s: read failed\n", s);
     970:	85da                	mv	a1,s6
     972:	00005517          	auipc	a0,0x5
     976:	7e650513          	addi	a0,a0,2022 # 6158 <malloc+0x4be>
     97a:	00005097          	auipc	ra,0x5
     97e:	268080e7          	jalr	616(ra) # 5be2 <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	ed4080e7          	jalr	-300(ra) # 5858 <exit>
    printf("%s: unlink small failed\n", s);
     98c:	85da                	mv	a1,s6
     98e:	00005517          	auipc	a0,0x5
     992:	7e250513          	addi	a0,a0,2018 # 6170 <malloc+0x4d6>
     996:	00005097          	auipc	ra,0x5
     99a:	24c080e7          	jalr	588(ra) # 5be2 <printf>
    exit(1);
     99e:	4505                	li	a0,1
     9a0:	00005097          	auipc	ra,0x5
     9a4:	eb8080e7          	jalr	-328(ra) # 5858 <exit>

00000000000009a8 <writebig>:
{
     9a8:	7139                	addi	sp,sp,-64
     9aa:	fc06                	sd	ra,56(sp)
     9ac:	f822                	sd	s0,48(sp)
     9ae:	f426                	sd	s1,40(sp)
     9b0:	f04a                	sd	s2,32(sp)
     9b2:	ec4e                	sd	s3,24(sp)
     9b4:	e852                	sd	s4,16(sp)
     9b6:	e456                	sd	s5,8(sp)
     9b8:	0080                	addi	s0,sp,64
     9ba:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9bc:	20200593          	li	a1,514
     9c0:	00005517          	auipc	a0,0x5
     9c4:	7d050513          	addi	a0,a0,2000 # 6190 <malloc+0x4f6>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	ed0080e7          	jalr	-304(ra) # 5898 <open>
     9d0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9d2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d4:	0000b917          	auipc	s2,0xb
     9d8:	42490913          	addi	s2,s2,1060 # bdf8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9dc:	10c00a13          	li	s4,268
  if(fd < 0){
     9e0:	06054c63          	bltz	a0,a58 <writebig+0xb0>
    ((int*)buf)[0] = i;
     9e4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9e8:	40000613          	li	a2,1024
     9ec:	85ca                	mv	a1,s2
     9ee:	854e                	mv	a0,s3
     9f0:	00005097          	auipc	ra,0x5
     9f4:	e88080e7          	jalr	-376(ra) # 5878 <write>
     9f8:	40000793          	li	a5,1024
     9fc:	06f51c63          	bne	a0,a5,a74 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a00:	2485                	addiw	s1,s1,1
     a02:	ff4491e3          	bne	s1,s4,9e4 <writebig+0x3c>
  close(fd);
     a06:	854e                	mv	a0,s3
     a08:	00005097          	auipc	ra,0x5
     a0c:	e78080e7          	jalr	-392(ra) # 5880 <close>
  fd = open("big", O_RDONLY);
     a10:	4581                	li	a1,0
     a12:	00005517          	auipc	a0,0x5
     a16:	77e50513          	addi	a0,a0,1918 # 6190 <malloc+0x4f6>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	e7e080e7          	jalr	-386(ra) # 5898 <open>
     a22:	89aa                	mv	s3,a0
  n = 0;
     a24:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a26:	0000b917          	auipc	s2,0xb
     a2a:	3d290913          	addi	s2,s2,978 # bdf8 <buf>
  if(fd < 0){
     a2e:	06054263          	bltz	a0,a92 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a32:	40000613          	li	a2,1024
     a36:	85ca                	mv	a1,s2
     a38:	854e                	mv	a0,s3
     a3a:	00005097          	auipc	ra,0x5
     a3e:	e36080e7          	jalr	-458(ra) # 5870 <read>
    if(i == 0){
     a42:	c535                	beqz	a0,aae <writebig+0x106>
    } else if(i != BSIZE){
     a44:	40000793          	li	a5,1024
     a48:	0af51f63          	bne	a0,a5,b06 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a4c:	00092683          	lw	a3,0(s2)
     a50:	0c969a63          	bne	a3,s1,b24 <writebig+0x17c>
    n++;
     a54:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a56:	bff1                	j	a32 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a58:	85d6                	mv	a1,s5
     a5a:	00005517          	auipc	a0,0x5
     a5e:	73e50513          	addi	a0,a0,1854 # 6198 <malloc+0x4fe>
     a62:	00005097          	auipc	ra,0x5
     a66:	180080e7          	jalr	384(ra) # 5be2 <printf>
    exit(1);
     a6a:	4505                	li	a0,1
     a6c:	00005097          	auipc	ra,0x5
     a70:	dec080e7          	jalr	-532(ra) # 5858 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a74:	8626                	mv	a2,s1
     a76:	85d6                	mv	a1,s5
     a78:	00005517          	auipc	a0,0x5
     a7c:	74050513          	addi	a0,a0,1856 # 61b8 <malloc+0x51e>
     a80:	00005097          	auipc	ra,0x5
     a84:	162080e7          	jalr	354(ra) # 5be2 <printf>
      exit(1);
     a88:	4505                	li	a0,1
     a8a:	00005097          	auipc	ra,0x5
     a8e:	dce080e7          	jalr	-562(ra) # 5858 <exit>
    printf("%s: error: open big failed!\n", s);
     a92:	85d6                	mv	a1,s5
     a94:	00005517          	auipc	a0,0x5
     a98:	74c50513          	addi	a0,a0,1868 # 61e0 <malloc+0x546>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	146080e7          	jalr	326(ra) # 5be2 <printf>
    exit(1);
     aa4:	4505                	li	a0,1
     aa6:	00005097          	auipc	ra,0x5
     aaa:	db2080e7          	jalr	-590(ra) # 5858 <exit>
      if(n == MAXFILE - 1){
     aae:	10b00793          	li	a5,267
     ab2:	02f48a63          	beq	s1,a5,ae6 <writebig+0x13e>
  close(fd);
     ab6:	854e                	mv	a0,s3
     ab8:	00005097          	auipc	ra,0x5
     abc:	dc8080e7          	jalr	-568(ra) # 5880 <close>
  if(unlink("big") < 0){
     ac0:	00005517          	auipc	a0,0x5
     ac4:	6d050513          	addi	a0,a0,1744 # 6190 <malloc+0x4f6>
     ac8:	00005097          	auipc	ra,0x5
     acc:	de0080e7          	jalr	-544(ra) # 58a8 <unlink>
     ad0:	06054963          	bltz	a0,b42 <writebig+0x19a>
}
     ad4:	70e2                	ld	ra,56(sp)
     ad6:	7442                	ld	s0,48(sp)
     ad8:	74a2                	ld	s1,40(sp)
     ada:	7902                	ld	s2,32(sp)
     adc:	69e2                	ld	s3,24(sp)
     ade:	6a42                	ld	s4,16(sp)
     ae0:	6aa2                	ld	s5,8(sp)
     ae2:	6121                	addi	sp,sp,64
     ae4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae6:	10b00613          	li	a2,267
     aea:	85d6                	mv	a1,s5
     aec:	00005517          	auipc	a0,0x5
     af0:	71450513          	addi	a0,a0,1812 # 6200 <malloc+0x566>
     af4:	00005097          	auipc	ra,0x5
     af8:	0ee080e7          	jalr	238(ra) # 5be2 <printf>
        exit(1);
     afc:	4505                	li	a0,1
     afe:	00005097          	auipc	ra,0x5
     b02:	d5a080e7          	jalr	-678(ra) # 5858 <exit>
      printf("%s: read failed %d\n", s, i);
     b06:	862a                	mv	a2,a0
     b08:	85d6                	mv	a1,s5
     b0a:	00005517          	auipc	a0,0x5
     b0e:	71e50513          	addi	a0,a0,1822 # 6228 <malloc+0x58e>
     b12:	00005097          	auipc	ra,0x5
     b16:	0d0080e7          	jalr	208(ra) # 5be2 <printf>
      exit(1);
     b1a:	4505                	li	a0,1
     b1c:	00005097          	auipc	ra,0x5
     b20:	d3c080e7          	jalr	-708(ra) # 5858 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b24:	8626                	mv	a2,s1
     b26:	85d6                	mv	a1,s5
     b28:	00005517          	auipc	a0,0x5
     b2c:	71850513          	addi	a0,a0,1816 # 6240 <malloc+0x5a6>
     b30:	00005097          	auipc	ra,0x5
     b34:	0b2080e7          	jalr	178(ra) # 5be2 <printf>
      exit(1);
     b38:	4505                	li	a0,1
     b3a:	00005097          	auipc	ra,0x5
     b3e:	d1e080e7          	jalr	-738(ra) # 5858 <exit>
    printf("%s: unlink big failed\n", s);
     b42:	85d6                	mv	a1,s5
     b44:	00005517          	auipc	a0,0x5
     b48:	72450513          	addi	a0,a0,1828 # 6268 <malloc+0x5ce>
     b4c:	00005097          	auipc	ra,0x5
     b50:	096080e7          	jalr	150(ra) # 5be2 <printf>
    exit(1);
     b54:	4505                	li	a0,1
     b56:	00005097          	auipc	ra,0x5
     b5a:	d02080e7          	jalr	-766(ra) # 5858 <exit>

0000000000000b5e <unlinkread>:
{
     b5e:	7179                	addi	sp,sp,-48
     b60:	f406                	sd	ra,40(sp)
     b62:	f022                	sd	s0,32(sp)
     b64:	ec26                	sd	s1,24(sp)
     b66:	e84a                	sd	s2,16(sp)
     b68:	e44e                	sd	s3,8(sp)
     b6a:	1800                	addi	s0,sp,48
     b6c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b6e:	20200593          	li	a1,514
     b72:	00005517          	auipc	a0,0x5
     b76:	70e50513          	addi	a0,a0,1806 # 6280 <malloc+0x5e6>
     b7a:	00005097          	auipc	ra,0x5
     b7e:	d1e080e7          	jalr	-738(ra) # 5898 <open>
  if(fd < 0){
     b82:	0e054563          	bltz	a0,c6c <unlinkread+0x10e>
     b86:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b88:	4615                	li	a2,5
     b8a:	00005597          	auipc	a1,0x5
     b8e:	72658593          	addi	a1,a1,1830 # 62b0 <malloc+0x616>
     b92:	00005097          	auipc	ra,0x5
     b96:	ce6080e7          	jalr	-794(ra) # 5878 <write>
  close(fd);
     b9a:	8526                	mv	a0,s1
     b9c:	00005097          	auipc	ra,0x5
     ba0:	ce4080e7          	jalr	-796(ra) # 5880 <close>
  fd = open("unlinkread", O_RDWR);
     ba4:	4589                	li	a1,2
     ba6:	00005517          	auipc	a0,0x5
     baa:	6da50513          	addi	a0,a0,1754 # 6280 <malloc+0x5e6>
     bae:	00005097          	auipc	ra,0x5
     bb2:	cea080e7          	jalr	-790(ra) # 5898 <open>
     bb6:	84aa                	mv	s1,a0
  if(fd < 0){
     bb8:	0c054863          	bltz	a0,c88 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbc:	00005517          	auipc	a0,0x5
     bc0:	6c450513          	addi	a0,a0,1732 # 6280 <malloc+0x5e6>
     bc4:	00005097          	auipc	ra,0x5
     bc8:	ce4080e7          	jalr	-796(ra) # 58a8 <unlink>
     bcc:	ed61                	bnez	a0,ca4 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bce:	20200593          	li	a1,514
     bd2:	00005517          	auipc	a0,0x5
     bd6:	6ae50513          	addi	a0,a0,1710 # 6280 <malloc+0x5e6>
     bda:	00005097          	auipc	ra,0x5
     bde:	cbe080e7          	jalr	-834(ra) # 5898 <open>
     be2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be4:	460d                	li	a2,3
     be6:	00005597          	auipc	a1,0x5
     bea:	71258593          	addi	a1,a1,1810 # 62f8 <malloc+0x65e>
     bee:	00005097          	auipc	ra,0x5
     bf2:	c8a080e7          	jalr	-886(ra) # 5878 <write>
  close(fd1);
     bf6:	854a                	mv	a0,s2
     bf8:	00005097          	auipc	ra,0x5
     bfc:	c88080e7          	jalr	-888(ra) # 5880 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c00:	660d                	lui	a2,0x3
     c02:	0000b597          	auipc	a1,0xb
     c06:	1f658593          	addi	a1,a1,502 # bdf8 <buf>
     c0a:	8526                	mv	a0,s1
     c0c:	00005097          	auipc	ra,0x5
     c10:	c64080e7          	jalr	-924(ra) # 5870 <read>
     c14:	4795                	li	a5,5
     c16:	0af51563          	bne	a0,a5,cc0 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1a:	0000b717          	auipc	a4,0xb
     c1e:	1de74703          	lbu	a4,478(a4) # bdf8 <buf>
     c22:	06800793          	li	a5,104
     c26:	0af71b63          	bne	a4,a5,cdc <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2a:	4629                	li	a2,10
     c2c:	0000b597          	auipc	a1,0xb
     c30:	1cc58593          	addi	a1,a1,460 # bdf8 <buf>
     c34:	8526                	mv	a0,s1
     c36:	00005097          	auipc	ra,0x5
     c3a:	c42080e7          	jalr	-958(ra) # 5878 <write>
     c3e:	47a9                	li	a5,10
     c40:	0af51c63          	bne	a0,a5,cf8 <unlinkread+0x19a>
  close(fd);
     c44:	8526                	mv	a0,s1
     c46:	00005097          	auipc	ra,0x5
     c4a:	c3a080e7          	jalr	-966(ra) # 5880 <close>
  unlink("unlinkread");
     c4e:	00005517          	auipc	a0,0x5
     c52:	63250513          	addi	a0,a0,1586 # 6280 <malloc+0x5e6>
     c56:	00005097          	auipc	ra,0x5
     c5a:	c52080e7          	jalr	-942(ra) # 58a8 <unlink>
}
     c5e:	70a2                	ld	ra,40(sp)
     c60:	7402                	ld	s0,32(sp)
     c62:	64e2                	ld	s1,24(sp)
     c64:	6942                	ld	s2,16(sp)
     c66:	69a2                	ld	s3,8(sp)
     c68:	6145                	addi	sp,sp,48
     c6a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6c:	85ce                	mv	a1,s3
     c6e:	00005517          	auipc	a0,0x5
     c72:	62250513          	addi	a0,a0,1570 # 6290 <malloc+0x5f6>
     c76:	00005097          	auipc	ra,0x5
     c7a:	f6c080e7          	jalr	-148(ra) # 5be2 <printf>
    exit(1);
     c7e:	4505                	li	a0,1
     c80:	00005097          	auipc	ra,0x5
     c84:	bd8080e7          	jalr	-1064(ra) # 5858 <exit>
    printf("%s: open unlinkread failed\n", s);
     c88:	85ce                	mv	a1,s3
     c8a:	00005517          	auipc	a0,0x5
     c8e:	62e50513          	addi	a0,a0,1582 # 62b8 <malloc+0x61e>
     c92:	00005097          	auipc	ra,0x5
     c96:	f50080e7          	jalr	-176(ra) # 5be2 <printf>
    exit(1);
     c9a:	4505                	li	a0,1
     c9c:	00005097          	auipc	ra,0x5
     ca0:	bbc080e7          	jalr	-1092(ra) # 5858 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca4:	85ce                	mv	a1,s3
     ca6:	00005517          	auipc	a0,0x5
     caa:	63250513          	addi	a0,a0,1586 # 62d8 <malloc+0x63e>
     cae:	00005097          	auipc	ra,0x5
     cb2:	f34080e7          	jalr	-204(ra) # 5be2 <printf>
    exit(1);
     cb6:	4505                	li	a0,1
     cb8:	00005097          	auipc	ra,0x5
     cbc:	ba0080e7          	jalr	-1120(ra) # 5858 <exit>
    printf("%s: unlinkread read failed", s);
     cc0:	85ce                	mv	a1,s3
     cc2:	00005517          	auipc	a0,0x5
     cc6:	63e50513          	addi	a0,a0,1598 # 6300 <malloc+0x666>
     cca:	00005097          	auipc	ra,0x5
     cce:	f18080e7          	jalr	-232(ra) # 5be2 <printf>
    exit(1);
     cd2:	4505                	li	a0,1
     cd4:	00005097          	auipc	ra,0x5
     cd8:	b84080e7          	jalr	-1148(ra) # 5858 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cdc:	85ce                	mv	a1,s3
     cde:	00005517          	auipc	a0,0x5
     ce2:	64250513          	addi	a0,a0,1602 # 6320 <malloc+0x686>
     ce6:	00005097          	auipc	ra,0x5
     cea:	efc080e7          	jalr	-260(ra) # 5be2 <printf>
    exit(1);
     cee:	4505                	li	a0,1
     cf0:	00005097          	auipc	ra,0x5
     cf4:	b68080e7          	jalr	-1176(ra) # 5858 <exit>
    printf("%s: unlinkread write failed\n", s);
     cf8:	85ce                	mv	a1,s3
     cfa:	00005517          	auipc	a0,0x5
     cfe:	64650513          	addi	a0,a0,1606 # 6340 <malloc+0x6a6>
     d02:	00005097          	auipc	ra,0x5
     d06:	ee0080e7          	jalr	-288(ra) # 5be2 <printf>
    exit(1);
     d0a:	4505                	li	a0,1
     d0c:	00005097          	auipc	ra,0x5
     d10:	b4c080e7          	jalr	-1204(ra) # 5858 <exit>

0000000000000d14 <linktest>:
{
     d14:	1101                	addi	sp,sp,-32
     d16:	ec06                	sd	ra,24(sp)
     d18:	e822                	sd	s0,16(sp)
     d1a:	e426                	sd	s1,8(sp)
     d1c:	e04a                	sd	s2,0(sp)
     d1e:	1000                	addi	s0,sp,32
     d20:	892a                	mv	s2,a0
  unlink("lf1");
     d22:	00005517          	auipc	a0,0x5
     d26:	63e50513          	addi	a0,a0,1598 # 6360 <malloc+0x6c6>
     d2a:	00005097          	auipc	ra,0x5
     d2e:	b7e080e7          	jalr	-1154(ra) # 58a8 <unlink>
  unlink("lf2");
     d32:	00005517          	auipc	a0,0x5
     d36:	63650513          	addi	a0,a0,1590 # 6368 <malloc+0x6ce>
     d3a:	00005097          	auipc	ra,0x5
     d3e:	b6e080e7          	jalr	-1170(ra) # 58a8 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d42:	20200593          	li	a1,514
     d46:	00005517          	auipc	a0,0x5
     d4a:	61a50513          	addi	a0,a0,1562 # 6360 <malloc+0x6c6>
     d4e:	00005097          	auipc	ra,0x5
     d52:	b4a080e7          	jalr	-1206(ra) # 5898 <open>
  if(fd < 0){
     d56:	10054763          	bltz	a0,e64 <linktest+0x150>
     d5a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5c:	4615                	li	a2,5
     d5e:	00005597          	auipc	a1,0x5
     d62:	55258593          	addi	a1,a1,1362 # 62b0 <malloc+0x616>
     d66:	00005097          	auipc	ra,0x5
     d6a:	b12080e7          	jalr	-1262(ra) # 5878 <write>
     d6e:	4795                	li	a5,5
     d70:	10f51863          	bne	a0,a5,e80 <linktest+0x16c>
  close(fd);
     d74:	8526                	mv	a0,s1
     d76:	00005097          	auipc	ra,0x5
     d7a:	b0a080e7          	jalr	-1270(ra) # 5880 <close>
  if(link("lf1", "lf2") < 0){
     d7e:	00005597          	auipc	a1,0x5
     d82:	5ea58593          	addi	a1,a1,1514 # 6368 <malloc+0x6ce>
     d86:	00005517          	auipc	a0,0x5
     d8a:	5da50513          	addi	a0,a0,1498 # 6360 <malloc+0x6c6>
     d8e:	00005097          	auipc	ra,0x5
     d92:	b2a080e7          	jalr	-1238(ra) # 58b8 <link>
     d96:	10054363          	bltz	a0,e9c <linktest+0x188>
  unlink("lf1");
     d9a:	00005517          	auipc	a0,0x5
     d9e:	5c650513          	addi	a0,a0,1478 # 6360 <malloc+0x6c6>
     da2:	00005097          	auipc	ra,0x5
     da6:	b06080e7          	jalr	-1274(ra) # 58a8 <unlink>
  if(open("lf1", 0) >= 0){
     daa:	4581                	li	a1,0
     dac:	00005517          	auipc	a0,0x5
     db0:	5b450513          	addi	a0,a0,1460 # 6360 <malloc+0x6c6>
     db4:	00005097          	auipc	ra,0x5
     db8:	ae4080e7          	jalr	-1308(ra) # 5898 <open>
     dbc:	0e055e63          	bgez	a0,eb8 <linktest+0x1a4>
  fd = open("lf2", 0);
     dc0:	4581                	li	a1,0
     dc2:	00005517          	auipc	a0,0x5
     dc6:	5a650513          	addi	a0,a0,1446 # 6368 <malloc+0x6ce>
     dca:	00005097          	auipc	ra,0x5
     dce:	ace080e7          	jalr	-1330(ra) # 5898 <open>
     dd2:	84aa                	mv	s1,a0
  if(fd < 0){
     dd4:	10054063          	bltz	a0,ed4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dd8:	660d                	lui	a2,0x3
     dda:	0000b597          	auipc	a1,0xb
     dde:	01e58593          	addi	a1,a1,30 # bdf8 <buf>
     de2:	00005097          	auipc	ra,0x5
     de6:	a8e080e7          	jalr	-1394(ra) # 5870 <read>
     dea:	4795                	li	a5,5
     dec:	10f51263          	bne	a0,a5,ef0 <linktest+0x1dc>
  close(fd);
     df0:	8526                	mv	a0,s1
     df2:	00005097          	auipc	ra,0x5
     df6:	a8e080e7          	jalr	-1394(ra) # 5880 <close>
  if(link("lf2", "lf2") >= 0){
     dfa:	00005597          	auipc	a1,0x5
     dfe:	56e58593          	addi	a1,a1,1390 # 6368 <malloc+0x6ce>
     e02:	852e                	mv	a0,a1
     e04:	00005097          	auipc	ra,0x5
     e08:	ab4080e7          	jalr	-1356(ra) # 58b8 <link>
     e0c:	10055063          	bgez	a0,f0c <linktest+0x1f8>
  unlink("lf2");
     e10:	00005517          	auipc	a0,0x5
     e14:	55850513          	addi	a0,a0,1368 # 6368 <malloc+0x6ce>
     e18:	00005097          	auipc	ra,0x5
     e1c:	a90080e7          	jalr	-1392(ra) # 58a8 <unlink>
  if(link("lf2", "lf1") >= 0){
     e20:	00005597          	auipc	a1,0x5
     e24:	54058593          	addi	a1,a1,1344 # 6360 <malloc+0x6c6>
     e28:	00005517          	auipc	a0,0x5
     e2c:	54050513          	addi	a0,a0,1344 # 6368 <malloc+0x6ce>
     e30:	00005097          	auipc	ra,0x5
     e34:	a88080e7          	jalr	-1400(ra) # 58b8 <link>
     e38:	0e055863          	bgez	a0,f28 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3c:	00005597          	auipc	a1,0x5
     e40:	52458593          	addi	a1,a1,1316 # 6360 <malloc+0x6c6>
     e44:	00005517          	auipc	a0,0x5
     e48:	62c50513          	addi	a0,a0,1580 # 6470 <malloc+0x7d6>
     e4c:	00005097          	auipc	ra,0x5
     e50:	a6c080e7          	jalr	-1428(ra) # 58b8 <link>
     e54:	0e055863          	bgez	a0,f44 <linktest+0x230>
}
     e58:	60e2                	ld	ra,24(sp)
     e5a:	6442                	ld	s0,16(sp)
     e5c:	64a2                	ld	s1,8(sp)
     e5e:	6902                	ld	s2,0(sp)
     e60:	6105                	addi	sp,sp,32
     e62:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e64:	85ca                	mv	a1,s2
     e66:	00005517          	auipc	a0,0x5
     e6a:	50a50513          	addi	a0,a0,1290 # 6370 <malloc+0x6d6>
     e6e:	00005097          	auipc	ra,0x5
     e72:	d74080e7          	jalr	-652(ra) # 5be2 <printf>
    exit(1);
     e76:	4505                	li	a0,1
     e78:	00005097          	auipc	ra,0x5
     e7c:	9e0080e7          	jalr	-1568(ra) # 5858 <exit>
    printf("%s: write lf1 failed\n", s);
     e80:	85ca                	mv	a1,s2
     e82:	00005517          	auipc	a0,0x5
     e86:	50650513          	addi	a0,a0,1286 # 6388 <malloc+0x6ee>
     e8a:	00005097          	auipc	ra,0x5
     e8e:	d58080e7          	jalr	-680(ra) # 5be2 <printf>
    exit(1);
     e92:	4505                	li	a0,1
     e94:	00005097          	auipc	ra,0x5
     e98:	9c4080e7          	jalr	-1596(ra) # 5858 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9c:	85ca                	mv	a1,s2
     e9e:	00005517          	auipc	a0,0x5
     ea2:	50250513          	addi	a0,a0,1282 # 63a0 <malloc+0x706>
     ea6:	00005097          	auipc	ra,0x5
     eaa:	d3c080e7          	jalr	-708(ra) # 5be2 <printf>
    exit(1);
     eae:	4505                	li	a0,1
     eb0:	00005097          	auipc	ra,0x5
     eb4:	9a8080e7          	jalr	-1624(ra) # 5858 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eb8:	85ca                	mv	a1,s2
     eba:	00005517          	auipc	a0,0x5
     ebe:	50650513          	addi	a0,a0,1286 # 63c0 <malloc+0x726>
     ec2:	00005097          	auipc	ra,0x5
     ec6:	d20080e7          	jalr	-736(ra) # 5be2 <printf>
    exit(1);
     eca:	4505                	li	a0,1
     ecc:	00005097          	auipc	ra,0x5
     ed0:	98c080e7          	jalr	-1652(ra) # 5858 <exit>
    printf("%s: open lf2 failed\n", s);
     ed4:	85ca                	mv	a1,s2
     ed6:	00005517          	auipc	a0,0x5
     eda:	51a50513          	addi	a0,a0,1306 # 63f0 <malloc+0x756>
     ede:	00005097          	auipc	ra,0x5
     ee2:	d04080e7          	jalr	-764(ra) # 5be2 <printf>
    exit(1);
     ee6:	4505                	li	a0,1
     ee8:	00005097          	auipc	ra,0x5
     eec:	970080e7          	jalr	-1680(ra) # 5858 <exit>
    printf("%s: read lf2 failed\n", s);
     ef0:	85ca                	mv	a1,s2
     ef2:	00005517          	auipc	a0,0x5
     ef6:	51650513          	addi	a0,a0,1302 # 6408 <malloc+0x76e>
     efa:	00005097          	auipc	ra,0x5
     efe:	ce8080e7          	jalr	-792(ra) # 5be2 <printf>
    exit(1);
     f02:	4505                	li	a0,1
     f04:	00005097          	auipc	ra,0x5
     f08:	954080e7          	jalr	-1708(ra) # 5858 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0c:	85ca                	mv	a1,s2
     f0e:	00005517          	auipc	a0,0x5
     f12:	51250513          	addi	a0,a0,1298 # 6420 <malloc+0x786>
     f16:	00005097          	auipc	ra,0x5
     f1a:	ccc080e7          	jalr	-820(ra) # 5be2 <printf>
    exit(1);
     f1e:	4505                	li	a0,1
     f20:	00005097          	auipc	ra,0x5
     f24:	938080e7          	jalr	-1736(ra) # 5858 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f28:	85ca                	mv	a1,s2
     f2a:	00005517          	auipc	a0,0x5
     f2e:	51e50513          	addi	a0,a0,1310 # 6448 <malloc+0x7ae>
     f32:	00005097          	auipc	ra,0x5
     f36:	cb0080e7          	jalr	-848(ra) # 5be2 <printf>
    exit(1);
     f3a:	4505                	li	a0,1
     f3c:	00005097          	auipc	ra,0x5
     f40:	91c080e7          	jalr	-1764(ra) # 5858 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f44:	85ca                	mv	a1,s2
     f46:	00005517          	auipc	a0,0x5
     f4a:	53250513          	addi	a0,a0,1330 # 6478 <malloc+0x7de>
     f4e:	00005097          	auipc	ra,0x5
     f52:	c94080e7          	jalr	-876(ra) # 5be2 <printf>
    exit(1);
     f56:	4505                	li	a0,1
     f58:	00005097          	auipc	ra,0x5
     f5c:	900080e7          	jalr	-1792(ra) # 5858 <exit>

0000000000000f60 <bigdir>:
{
     f60:	715d                	addi	sp,sp,-80
     f62:	e486                	sd	ra,72(sp)
     f64:	e0a2                	sd	s0,64(sp)
     f66:	fc26                	sd	s1,56(sp)
     f68:	f84a                	sd	s2,48(sp)
     f6a:	f44e                	sd	s3,40(sp)
     f6c:	f052                	sd	s4,32(sp)
     f6e:	ec56                	sd	s5,24(sp)
     f70:	e85a                	sd	s6,16(sp)
     f72:	0880                	addi	s0,sp,80
     f74:	89aa                	mv	s3,a0
  unlink("bd");
     f76:	00005517          	auipc	a0,0x5
     f7a:	52250513          	addi	a0,a0,1314 # 6498 <malloc+0x7fe>
     f7e:	00005097          	auipc	ra,0x5
     f82:	92a080e7          	jalr	-1750(ra) # 58a8 <unlink>
  fd = open("bd", O_CREATE);
     f86:	20000593          	li	a1,512
     f8a:	00005517          	auipc	a0,0x5
     f8e:	50e50513          	addi	a0,a0,1294 # 6498 <malloc+0x7fe>
     f92:	00005097          	auipc	ra,0x5
     f96:	906080e7          	jalr	-1786(ra) # 5898 <open>
  if(fd < 0){
     f9a:	0c054963          	bltz	a0,106c <bigdir+0x10c>
  close(fd);
     f9e:	00005097          	auipc	ra,0x5
     fa2:	8e2080e7          	jalr	-1822(ra) # 5880 <close>
  for(i = 0; i < N; i++){
     fa6:	4901                	li	s2,0
    name[0] = 'x';
     fa8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fac:	00005a17          	auipc	s4,0x5
     fb0:	4eca0a13          	addi	s4,s4,1260 # 6498 <malloc+0x7fe>
  for(i = 0; i < N; i++){
     fb4:	1f400b13          	li	s6,500
    name[0] = 'x';
     fb8:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbc:	41f9571b          	sraiw	a4,s2,0x1f
     fc0:	01a7571b          	srliw	a4,a4,0x1a
     fc4:	012707bb          	addw	a5,a4,s2
     fc8:	4067d69b          	sraiw	a3,a5,0x6
     fcc:	0306869b          	addiw	a3,a3,48
     fd0:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd4:	03f7f793          	andi	a5,a5,63
     fd8:	9f99                	subw	a5,a5,a4
     fda:	0307879b          	addiw	a5,a5,48
     fde:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe2:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe6:	fb040593          	addi	a1,s0,-80
     fea:	8552                	mv	a0,s4
     fec:	00005097          	auipc	ra,0x5
     ff0:	8cc080e7          	jalr	-1844(ra) # 58b8 <link>
     ff4:	84aa                	mv	s1,a0
     ff6:	e949                	bnez	a0,1088 <bigdir+0x128>
  for(i = 0; i < N; i++){
     ff8:	2905                	addiw	s2,s2,1
     ffa:	fb691fe3          	bne	s2,s6,fb8 <bigdir+0x58>
  unlink("bd");
     ffe:	00005517          	auipc	a0,0x5
    1002:	49a50513          	addi	a0,a0,1178 # 6498 <malloc+0x7fe>
    1006:	00005097          	auipc	ra,0x5
    100a:	8a2080e7          	jalr	-1886(ra) # 58a8 <unlink>
    name[0] = 'x';
    100e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1012:	1f400a13          	li	s4,500
    name[0] = 'x';
    1016:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101a:	41f4d71b          	sraiw	a4,s1,0x1f
    101e:	01a7571b          	srliw	a4,a4,0x1a
    1022:	009707bb          	addw	a5,a4,s1
    1026:	4067d69b          	sraiw	a3,a5,0x6
    102a:	0306869b          	addiw	a3,a3,48
    102e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1032:	03f7f793          	andi	a5,a5,63
    1036:	9f99                	subw	a5,a5,a4
    1038:	0307879b          	addiw	a5,a5,48
    103c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1040:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1044:	fb040513          	addi	a0,s0,-80
    1048:	00005097          	auipc	ra,0x5
    104c:	860080e7          	jalr	-1952(ra) # 58a8 <unlink>
    1050:	ed21                	bnez	a0,10a8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    1052:	2485                	addiw	s1,s1,1
    1054:	fd4491e3          	bne	s1,s4,1016 <bigdir+0xb6>
}
    1058:	60a6                	ld	ra,72(sp)
    105a:	6406                	ld	s0,64(sp)
    105c:	74e2                	ld	s1,56(sp)
    105e:	7942                	ld	s2,48(sp)
    1060:	79a2                	ld	s3,40(sp)
    1062:	7a02                	ld	s4,32(sp)
    1064:	6ae2                	ld	s5,24(sp)
    1066:	6b42                	ld	s6,16(sp)
    1068:	6161                	addi	sp,sp,80
    106a:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106c:	85ce                	mv	a1,s3
    106e:	00005517          	auipc	a0,0x5
    1072:	43250513          	addi	a0,a0,1074 # 64a0 <malloc+0x806>
    1076:	00005097          	auipc	ra,0x5
    107a:	b6c080e7          	jalr	-1172(ra) # 5be2 <printf>
    exit(1);
    107e:	4505                	li	a0,1
    1080:	00004097          	auipc	ra,0x4
    1084:	7d8080e7          	jalr	2008(ra) # 5858 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1088:	fb040613          	addi	a2,s0,-80
    108c:	85ce                	mv	a1,s3
    108e:	00005517          	auipc	a0,0x5
    1092:	43250513          	addi	a0,a0,1074 # 64c0 <malloc+0x826>
    1096:	00005097          	auipc	ra,0x5
    109a:	b4c080e7          	jalr	-1204(ra) # 5be2 <printf>
      exit(1);
    109e:	4505                	li	a0,1
    10a0:	00004097          	auipc	ra,0x4
    10a4:	7b8080e7          	jalr	1976(ra) # 5858 <exit>
      printf("%s: bigdir unlink failed", s);
    10a8:	85ce                	mv	a1,s3
    10aa:	00005517          	auipc	a0,0x5
    10ae:	43650513          	addi	a0,a0,1078 # 64e0 <malloc+0x846>
    10b2:	00005097          	auipc	ra,0x5
    10b6:	b30080e7          	jalr	-1232(ra) # 5be2 <printf>
      exit(1);
    10ba:	4505                	li	a0,1
    10bc:	00004097          	auipc	ra,0x4
    10c0:	79c080e7          	jalr	1948(ra) # 5858 <exit>

00000000000010c4 <validatetest>:
{
    10c4:	7139                	addi	sp,sp,-64
    10c6:	fc06                	sd	ra,56(sp)
    10c8:	f822                	sd	s0,48(sp)
    10ca:	f426                	sd	s1,40(sp)
    10cc:	f04a                	sd	s2,32(sp)
    10ce:	ec4e                	sd	s3,24(sp)
    10d0:	e852                	sd	s4,16(sp)
    10d2:	e456                	sd	s5,8(sp)
    10d4:	e05a                	sd	s6,0(sp)
    10d6:	0080                	addi	s0,sp,64
    10d8:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10da:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10dc:	00005997          	auipc	s3,0x5
    10e0:	42498993          	addi	s3,s3,1060 # 6500 <malloc+0x866>
    10e4:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e6:	6a85                	lui	s5,0x1
    10e8:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ec:	85a6                	mv	a1,s1
    10ee:	854e                	mv	a0,s3
    10f0:	00004097          	auipc	ra,0x4
    10f4:	7c8080e7          	jalr	1992(ra) # 58b8 <link>
    10f8:	01251f63          	bne	a0,s2,1116 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fc:	94d6                	add	s1,s1,s5
    10fe:	ff4497e3          	bne	s1,s4,10ec <validatetest+0x28>
}
    1102:	70e2                	ld	ra,56(sp)
    1104:	7442                	ld	s0,48(sp)
    1106:	74a2                	ld	s1,40(sp)
    1108:	7902                	ld	s2,32(sp)
    110a:	69e2                	ld	s3,24(sp)
    110c:	6a42                	ld	s4,16(sp)
    110e:	6aa2                	ld	s5,8(sp)
    1110:	6b02                	ld	s6,0(sp)
    1112:	6121                	addi	sp,sp,64
    1114:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1116:	85da                	mv	a1,s6
    1118:	00005517          	auipc	a0,0x5
    111c:	3f850513          	addi	a0,a0,1016 # 6510 <malloc+0x876>
    1120:	00005097          	auipc	ra,0x5
    1124:	ac2080e7          	jalr	-1342(ra) # 5be2 <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	00004097          	auipc	ra,0x4
    112e:	72e080e7          	jalr	1838(ra) # 5858 <exit>

0000000000001132 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1132:	7179                	addi	sp,sp,-48
    1134:	f406                	sd	ra,40(sp)
    1136:	f022                	sd	s0,32(sp)
    1138:	ec26                	sd	s1,24(sp)
    113a:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113c:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1140:	00007497          	auipc	s1,0x7
    1144:	4904b483          	ld	s1,1168(s1) # 85d0 <__SDATA_BEGIN__>
    1148:	fd840593          	addi	a1,s0,-40
    114c:	8526                	mv	a0,s1
    114e:	00004097          	auipc	ra,0x4
    1152:	742080e7          	jalr	1858(ra) # 5890 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1156:	8526                	mv	a0,s1
    1158:	00004097          	auipc	ra,0x4
    115c:	710080e7          	jalr	1808(ra) # 5868 <pipe>

  exit(0);
    1160:	4501                	li	a0,0
    1162:	00004097          	auipc	ra,0x4
    1166:	6f6080e7          	jalr	1782(ra) # 5858 <exit>

000000000000116a <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116a:	7139                	addi	sp,sp,-64
    116c:	fc06                	sd	ra,56(sp)
    116e:	f822                	sd	s0,48(sp)
    1170:	f426                	sd	s1,40(sp)
    1172:	f04a                	sd	s2,32(sp)
    1174:	ec4e                	sd	s3,24(sp)
    1176:	0080                	addi	s0,sp,64
    1178:	64b1                	lui	s1,0xc
    117a:	35048493          	addi	s1,s1,848 # c350 <buf+0x558>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    117e:	597d                	li	s2,-1
    1180:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1184:	00005997          	auipc	s3,0x5
    1188:	c3498993          	addi	s3,s3,-972 # 5db8 <malloc+0x11e>
    argv[0] = (char*)0xffffffff;
    118c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1190:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1194:	fc040593          	addi	a1,s0,-64
    1198:	854e                	mv	a0,s3
    119a:	00004097          	auipc	ra,0x4
    119e:	6f6080e7          	jalr	1782(ra) # 5890 <exec>
  for(int i = 0; i < 50000; i++){
    11a2:	34fd                	addiw	s1,s1,-1
    11a4:	f4e5                	bnez	s1,118c <badarg+0x22>
  }
  
  exit(0);
    11a6:	4501                	li	a0,0
    11a8:	00004097          	auipc	ra,0x4
    11ac:	6b0080e7          	jalr	1712(ra) # 5858 <exit>

00000000000011b0 <copyinstr2>:
{
    11b0:	7155                	addi	sp,sp,-208
    11b2:	e586                	sd	ra,200(sp)
    11b4:	e1a2                	sd	s0,192(sp)
    11b6:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11b8:	f6840793          	addi	a5,s0,-152
    11bc:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c0:	07800713          	li	a4,120
    11c4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11c8:	0785                	addi	a5,a5,1
    11ca:	fed79de3          	bne	a5,a3,11c4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11ce:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d2:	f6840513          	addi	a0,s0,-152
    11d6:	00004097          	auipc	ra,0x4
    11da:	6d2080e7          	jalr	1746(ra) # 58a8 <unlink>
  if(ret != -1){
    11de:	57fd                	li	a5,-1
    11e0:	0ef51063          	bne	a0,a5,12c0 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e4:	20100593          	li	a1,513
    11e8:	f6840513          	addi	a0,s0,-152
    11ec:	00004097          	auipc	ra,0x4
    11f0:	6ac080e7          	jalr	1708(ra) # 5898 <open>
  if(fd != -1){
    11f4:	57fd                	li	a5,-1
    11f6:	0ef51563          	bne	a0,a5,12e0 <copyinstr2+0x130>
  ret = link(b, b);
    11fa:	f6840593          	addi	a1,s0,-152
    11fe:	852e                	mv	a0,a1
    1200:	00004097          	auipc	ra,0x4
    1204:	6b8080e7          	jalr	1720(ra) # 58b8 <link>
  if(ret != -1){
    1208:	57fd                	li	a5,-1
    120a:	0ef51b63          	bne	a0,a5,1300 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    120e:	00006797          	auipc	a5,0x6
    1212:	4fa78793          	addi	a5,a5,1274 # 7708 <malloc+0x1a6e>
    1216:	f4f43c23          	sd	a5,-168(s0)
    121a:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    121e:	f5840593          	addi	a1,s0,-168
    1222:	f6840513          	addi	a0,s0,-152
    1226:	00004097          	auipc	ra,0x4
    122a:	66a080e7          	jalr	1642(ra) # 5890 <exec>
  if(ret != -1){
    122e:	57fd                	li	a5,-1
    1230:	0ef51963          	bne	a0,a5,1322 <copyinstr2+0x172>
  int pid = fork();
    1234:	00004097          	auipc	ra,0x4
    1238:	61c080e7          	jalr	1564(ra) # 5850 <fork>
  if(pid < 0){
    123c:	10054363          	bltz	a0,1342 <copyinstr2+0x192>
  if(pid == 0){
    1240:	12051463          	bnez	a0,1368 <copyinstr2+0x1b8>
    1244:	00007797          	auipc	a5,0x7
    1248:	49c78793          	addi	a5,a5,1180 # 86e0 <big.0>
    124c:	00008697          	auipc	a3,0x8
    1250:	49468693          	addi	a3,a3,1172 # 96e0 <__global_pointer$+0x910>
      big[i] = 'x';
    1254:	07800713          	li	a4,120
    1258:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    125c:	0785                	addi	a5,a5,1
    125e:	fed79de3          	bne	a5,a3,1258 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1262:	00008797          	auipc	a5,0x8
    1266:	46078f23          	sb	zero,1150(a5) # 96e0 <__global_pointer$+0x910>
    char *args2[] = { big, big, big, 0 };
    126a:	00007797          	auipc	a5,0x7
    126e:	ede78793          	addi	a5,a5,-290 # 8148 <malloc+0x24ae>
    1272:	6390                	ld	a2,0(a5)
    1274:	6794                	ld	a3,8(a5)
    1276:	6b98                	ld	a4,16(a5)
    1278:	6f9c                	ld	a5,24(a5)
    127a:	f2c43823          	sd	a2,-208(s0)
    127e:	f2d43c23          	sd	a3,-200(s0)
    1282:	f4e43023          	sd	a4,-192(s0)
    1286:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128a:	f3040593          	addi	a1,s0,-208
    128e:	00005517          	auipc	a0,0x5
    1292:	b2a50513          	addi	a0,a0,-1238 # 5db8 <malloc+0x11e>
    1296:	00004097          	auipc	ra,0x4
    129a:	5fa080e7          	jalr	1530(ra) # 5890 <exec>
    if(ret != -1){
    129e:	57fd                	li	a5,-1
    12a0:	0af50e63          	beq	a0,a5,135c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a4:	55fd                	li	a1,-1
    12a6:	00005517          	auipc	a0,0x5
    12aa:	31250513          	addi	a0,a0,786 # 65b8 <malloc+0x91e>
    12ae:	00005097          	auipc	ra,0x5
    12b2:	934080e7          	jalr	-1740(ra) # 5be2 <printf>
      exit(1);
    12b6:	4505                	li	a0,1
    12b8:	00004097          	auipc	ra,0x4
    12bc:	5a0080e7          	jalr	1440(ra) # 5858 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c0:	862a                	mv	a2,a0
    12c2:	f6840593          	addi	a1,s0,-152
    12c6:	00005517          	auipc	a0,0x5
    12ca:	26a50513          	addi	a0,a0,618 # 6530 <malloc+0x896>
    12ce:	00005097          	auipc	ra,0x5
    12d2:	914080e7          	jalr	-1772(ra) # 5be2 <printf>
    exit(1);
    12d6:	4505                	li	a0,1
    12d8:	00004097          	auipc	ra,0x4
    12dc:	580080e7          	jalr	1408(ra) # 5858 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e0:	862a                	mv	a2,a0
    12e2:	f6840593          	addi	a1,s0,-152
    12e6:	00005517          	auipc	a0,0x5
    12ea:	26a50513          	addi	a0,a0,618 # 6550 <malloc+0x8b6>
    12ee:	00005097          	auipc	ra,0x5
    12f2:	8f4080e7          	jalr	-1804(ra) # 5be2 <printf>
    exit(1);
    12f6:	4505                	li	a0,1
    12f8:	00004097          	auipc	ra,0x4
    12fc:	560080e7          	jalr	1376(ra) # 5858 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1300:	86aa                	mv	a3,a0
    1302:	f6840613          	addi	a2,s0,-152
    1306:	85b2                	mv	a1,a2
    1308:	00005517          	auipc	a0,0x5
    130c:	26850513          	addi	a0,a0,616 # 6570 <malloc+0x8d6>
    1310:	00005097          	auipc	ra,0x5
    1314:	8d2080e7          	jalr	-1838(ra) # 5be2 <printf>
    exit(1);
    1318:	4505                	li	a0,1
    131a:	00004097          	auipc	ra,0x4
    131e:	53e080e7          	jalr	1342(ra) # 5858 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1322:	567d                	li	a2,-1
    1324:	f6840593          	addi	a1,s0,-152
    1328:	00005517          	auipc	a0,0x5
    132c:	27050513          	addi	a0,a0,624 # 6598 <malloc+0x8fe>
    1330:	00005097          	auipc	ra,0x5
    1334:	8b2080e7          	jalr	-1870(ra) # 5be2 <printf>
    exit(1);
    1338:	4505                	li	a0,1
    133a:	00004097          	auipc	ra,0x4
    133e:	51e080e7          	jalr	1310(ra) # 5858 <exit>
    printf("fork failed\n");
    1342:	00005517          	auipc	a0,0x5
    1346:	6ee50513          	addi	a0,a0,1774 # 6a30 <malloc+0xd96>
    134a:	00005097          	auipc	ra,0x5
    134e:	898080e7          	jalr	-1896(ra) # 5be2 <printf>
    exit(1);
    1352:	4505                	li	a0,1
    1354:	00004097          	auipc	ra,0x4
    1358:	504080e7          	jalr	1284(ra) # 5858 <exit>
    exit(747); // OK
    135c:	2eb00513          	li	a0,747
    1360:	00004097          	auipc	ra,0x4
    1364:	4f8080e7          	jalr	1272(ra) # 5858 <exit>
  int st = 0;
    1368:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    136c:	f5440513          	addi	a0,s0,-172
    1370:	00004097          	auipc	ra,0x4
    1374:	4f0080e7          	jalr	1264(ra) # 5860 <wait>
  if(st != 747){
    1378:	f5442703          	lw	a4,-172(s0)
    137c:	2eb00793          	li	a5,747
    1380:	00f71663          	bne	a4,a5,138c <copyinstr2+0x1dc>
}
    1384:	60ae                	ld	ra,200(sp)
    1386:	640e                	ld	s0,192(sp)
    1388:	6169                	addi	sp,sp,208
    138a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    138c:	00005517          	auipc	a0,0x5
    1390:	25450513          	addi	a0,a0,596 # 65e0 <malloc+0x946>
    1394:	00005097          	auipc	ra,0x5
    1398:	84e080e7          	jalr	-1970(ra) # 5be2 <printf>
    exit(1);
    139c:	4505                	li	a0,1
    139e:	00004097          	auipc	ra,0x4
    13a2:	4ba080e7          	jalr	1210(ra) # 5858 <exit>

00000000000013a6 <truncate3>:
{
    13a6:	7159                	addi	sp,sp,-112
    13a8:	f486                	sd	ra,104(sp)
    13aa:	f0a2                	sd	s0,96(sp)
    13ac:	eca6                	sd	s1,88(sp)
    13ae:	e8ca                	sd	s2,80(sp)
    13b0:	e4ce                	sd	s3,72(sp)
    13b2:	e0d2                	sd	s4,64(sp)
    13b4:	fc56                	sd	s5,56(sp)
    13b6:	1880                	addi	s0,sp,112
    13b8:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13ba:	60100593          	li	a1,1537
    13be:	00005517          	auipc	a0,0x5
    13c2:	a5250513          	addi	a0,a0,-1454 # 5e10 <malloc+0x176>
    13c6:	00004097          	auipc	ra,0x4
    13ca:	4d2080e7          	jalr	1234(ra) # 5898 <open>
    13ce:	00004097          	auipc	ra,0x4
    13d2:	4b2080e7          	jalr	1202(ra) # 5880 <close>
  pid = fork();
    13d6:	00004097          	auipc	ra,0x4
    13da:	47a080e7          	jalr	1146(ra) # 5850 <fork>
  if(pid < 0){
    13de:	08054063          	bltz	a0,145e <truncate3+0xb8>
  if(pid == 0){
    13e2:	e969                	bnez	a0,14b4 <truncate3+0x10e>
    13e4:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13e8:	00005a17          	auipc	s4,0x5
    13ec:	a28a0a13          	addi	s4,s4,-1496 # 5e10 <malloc+0x176>
      int n = write(fd, "1234567890", 10);
    13f0:	00005a97          	auipc	s5,0x5
    13f4:	250a8a93          	addi	s5,s5,592 # 6640 <malloc+0x9a6>
      int fd = open("truncfile", O_WRONLY);
    13f8:	4585                	li	a1,1
    13fa:	8552                	mv	a0,s4
    13fc:	00004097          	auipc	ra,0x4
    1400:	49c080e7          	jalr	1180(ra) # 5898 <open>
    1404:	84aa                	mv	s1,a0
      if(fd < 0){
    1406:	06054a63          	bltz	a0,147a <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140a:	4629                	li	a2,10
    140c:	85d6                	mv	a1,s5
    140e:	00004097          	auipc	ra,0x4
    1412:	46a080e7          	jalr	1130(ra) # 5878 <write>
      if(n != 10){
    1416:	47a9                	li	a5,10
    1418:	06f51f63          	bne	a0,a5,1496 <truncate3+0xf0>
      close(fd);
    141c:	8526                	mv	a0,s1
    141e:	00004097          	auipc	ra,0x4
    1422:	462080e7          	jalr	1122(ra) # 5880 <close>
      fd = open("truncfile", O_RDONLY);
    1426:	4581                	li	a1,0
    1428:	8552                	mv	a0,s4
    142a:	00004097          	auipc	ra,0x4
    142e:	46e080e7          	jalr	1134(ra) # 5898 <open>
    1432:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1434:	02000613          	li	a2,32
    1438:	f9840593          	addi	a1,s0,-104
    143c:	00004097          	auipc	ra,0x4
    1440:	434080e7          	jalr	1076(ra) # 5870 <read>
      close(fd);
    1444:	8526                	mv	a0,s1
    1446:	00004097          	auipc	ra,0x4
    144a:	43a080e7          	jalr	1082(ra) # 5880 <close>
    for(int i = 0; i < 100; i++){
    144e:	39fd                	addiw	s3,s3,-1
    1450:	fa0994e3          	bnez	s3,13f8 <truncate3+0x52>
    exit(0);
    1454:	4501                	li	a0,0
    1456:	00004097          	auipc	ra,0x4
    145a:	402080e7          	jalr	1026(ra) # 5858 <exit>
    printf("%s: fork failed\n", s);
    145e:	85ca                	mv	a1,s2
    1460:	00005517          	auipc	a0,0x5
    1464:	1b050513          	addi	a0,a0,432 # 6610 <malloc+0x976>
    1468:	00004097          	auipc	ra,0x4
    146c:	77a080e7          	jalr	1914(ra) # 5be2 <printf>
    exit(1);
    1470:	4505                	li	a0,1
    1472:	00004097          	auipc	ra,0x4
    1476:	3e6080e7          	jalr	998(ra) # 5858 <exit>
        printf("%s: open failed\n", s);
    147a:	85ca                	mv	a1,s2
    147c:	00005517          	auipc	a0,0x5
    1480:	1ac50513          	addi	a0,a0,428 # 6628 <malloc+0x98e>
    1484:	00004097          	auipc	ra,0x4
    1488:	75e080e7          	jalr	1886(ra) # 5be2 <printf>
        exit(1);
    148c:	4505                	li	a0,1
    148e:	00004097          	auipc	ra,0x4
    1492:	3ca080e7          	jalr	970(ra) # 5858 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1496:	862a                	mv	a2,a0
    1498:	85ca                	mv	a1,s2
    149a:	00005517          	auipc	a0,0x5
    149e:	1b650513          	addi	a0,a0,438 # 6650 <malloc+0x9b6>
    14a2:	00004097          	auipc	ra,0x4
    14a6:	740080e7          	jalr	1856(ra) # 5be2 <printf>
        exit(1);
    14aa:	4505                	li	a0,1
    14ac:	00004097          	auipc	ra,0x4
    14b0:	3ac080e7          	jalr	940(ra) # 5858 <exit>
    14b4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14b8:	00005a17          	auipc	s4,0x5
    14bc:	958a0a13          	addi	s4,s4,-1704 # 5e10 <malloc+0x176>
    int n = write(fd, "xxx", 3);
    14c0:	00005a97          	auipc	s5,0x5
    14c4:	1b0a8a93          	addi	s5,s5,432 # 6670 <malloc+0x9d6>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c8:	60100593          	li	a1,1537
    14cc:	8552                	mv	a0,s4
    14ce:	00004097          	auipc	ra,0x4
    14d2:	3ca080e7          	jalr	970(ra) # 5898 <open>
    14d6:	84aa                	mv	s1,a0
    if(fd < 0){
    14d8:	04054763          	bltz	a0,1526 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14dc:	460d                	li	a2,3
    14de:	85d6                	mv	a1,s5
    14e0:	00004097          	auipc	ra,0x4
    14e4:	398080e7          	jalr	920(ra) # 5878 <write>
    if(n != 3){
    14e8:	478d                	li	a5,3
    14ea:	04f51c63          	bne	a0,a5,1542 <truncate3+0x19c>
    close(fd);
    14ee:	8526                	mv	a0,s1
    14f0:	00004097          	auipc	ra,0x4
    14f4:	390080e7          	jalr	912(ra) # 5880 <close>
  for(int i = 0; i < 150; i++){
    14f8:	39fd                	addiw	s3,s3,-1
    14fa:	fc0997e3          	bnez	s3,14c8 <truncate3+0x122>
  wait(&xstatus);
    14fe:	fbc40513          	addi	a0,s0,-68
    1502:	00004097          	auipc	ra,0x4
    1506:	35e080e7          	jalr	862(ra) # 5860 <wait>
  unlink("truncfile");
    150a:	00005517          	auipc	a0,0x5
    150e:	90650513          	addi	a0,a0,-1786 # 5e10 <malloc+0x176>
    1512:	00004097          	auipc	ra,0x4
    1516:	396080e7          	jalr	918(ra) # 58a8 <unlink>
  exit(xstatus);
    151a:	fbc42503          	lw	a0,-68(s0)
    151e:	00004097          	auipc	ra,0x4
    1522:	33a080e7          	jalr	826(ra) # 5858 <exit>
      printf("%s: open failed\n", s);
    1526:	85ca                	mv	a1,s2
    1528:	00005517          	auipc	a0,0x5
    152c:	10050513          	addi	a0,a0,256 # 6628 <malloc+0x98e>
    1530:	00004097          	auipc	ra,0x4
    1534:	6b2080e7          	jalr	1714(ra) # 5be2 <printf>
      exit(1);
    1538:	4505                	li	a0,1
    153a:	00004097          	auipc	ra,0x4
    153e:	31e080e7          	jalr	798(ra) # 5858 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1542:	862a                	mv	a2,a0
    1544:	85ca                	mv	a1,s2
    1546:	00005517          	auipc	a0,0x5
    154a:	13250513          	addi	a0,a0,306 # 6678 <malloc+0x9de>
    154e:	00004097          	auipc	ra,0x4
    1552:	694080e7          	jalr	1684(ra) # 5be2 <printf>
      exit(1);
    1556:	4505                	li	a0,1
    1558:	00004097          	auipc	ra,0x4
    155c:	300080e7          	jalr	768(ra) # 5858 <exit>

0000000000001560 <exectest>:
{
    1560:	715d                	addi	sp,sp,-80
    1562:	e486                	sd	ra,72(sp)
    1564:	e0a2                	sd	s0,64(sp)
    1566:	fc26                	sd	s1,56(sp)
    1568:	f84a                	sd	s2,48(sp)
    156a:	0880                	addi	s0,sp,80
    156c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    156e:	00005797          	auipc	a5,0x5
    1572:	84a78793          	addi	a5,a5,-1974 # 5db8 <malloc+0x11e>
    1576:	fcf43023          	sd	a5,-64(s0)
    157a:	00005797          	auipc	a5,0x5
    157e:	11e78793          	addi	a5,a5,286 # 6698 <malloc+0x9fe>
    1582:	fcf43423          	sd	a5,-56(s0)
    1586:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158a:	00005517          	auipc	a0,0x5
    158e:	11650513          	addi	a0,a0,278 # 66a0 <malloc+0xa06>
    1592:	00004097          	auipc	ra,0x4
    1596:	316080e7          	jalr	790(ra) # 58a8 <unlink>
  pid = fork();
    159a:	00004097          	auipc	ra,0x4
    159e:	2b6080e7          	jalr	694(ra) # 5850 <fork>
  if(pid < 0) {
    15a2:	04054663          	bltz	a0,15ee <exectest+0x8e>
    15a6:	84aa                	mv	s1,a0
  if(pid == 0) {
    15a8:	e959                	bnez	a0,163e <exectest+0xde>
    close(1);
    15aa:	4505                	li	a0,1
    15ac:	00004097          	auipc	ra,0x4
    15b0:	2d4080e7          	jalr	724(ra) # 5880 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b4:	20100593          	li	a1,513
    15b8:	00005517          	auipc	a0,0x5
    15bc:	0e850513          	addi	a0,a0,232 # 66a0 <malloc+0xa06>
    15c0:	00004097          	auipc	ra,0x4
    15c4:	2d8080e7          	jalr	728(ra) # 5898 <open>
    if(fd < 0) {
    15c8:	04054163          	bltz	a0,160a <exectest+0xaa>
    if(fd != 1) {
    15cc:	4785                	li	a5,1
    15ce:	04f50c63          	beq	a0,a5,1626 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d2:	85ca                	mv	a1,s2
    15d4:	00005517          	auipc	a0,0x5
    15d8:	0ec50513          	addi	a0,a0,236 # 66c0 <malloc+0xa26>
    15dc:	00004097          	auipc	ra,0x4
    15e0:	606080e7          	jalr	1542(ra) # 5be2 <printf>
      exit(1);
    15e4:	4505                	li	a0,1
    15e6:	00004097          	auipc	ra,0x4
    15ea:	272080e7          	jalr	626(ra) # 5858 <exit>
     printf("%s: fork failed\n", s);
    15ee:	85ca                	mv	a1,s2
    15f0:	00005517          	auipc	a0,0x5
    15f4:	02050513          	addi	a0,a0,32 # 6610 <malloc+0x976>
    15f8:	00004097          	auipc	ra,0x4
    15fc:	5ea080e7          	jalr	1514(ra) # 5be2 <printf>
     exit(1);
    1600:	4505                	li	a0,1
    1602:	00004097          	auipc	ra,0x4
    1606:	256080e7          	jalr	598(ra) # 5858 <exit>
      printf("%s: create failed\n", s);
    160a:	85ca                	mv	a1,s2
    160c:	00005517          	auipc	a0,0x5
    1610:	09c50513          	addi	a0,a0,156 # 66a8 <malloc+0xa0e>
    1614:	00004097          	auipc	ra,0x4
    1618:	5ce080e7          	jalr	1486(ra) # 5be2 <printf>
      exit(1);
    161c:	4505                	li	a0,1
    161e:	00004097          	auipc	ra,0x4
    1622:	23a080e7          	jalr	570(ra) # 5858 <exit>
    if(exec("echo", echoargv) < 0){
    1626:	fc040593          	addi	a1,s0,-64
    162a:	00004517          	auipc	a0,0x4
    162e:	78e50513          	addi	a0,a0,1934 # 5db8 <malloc+0x11e>
    1632:	00004097          	auipc	ra,0x4
    1636:	25e080e7          	jalr	606(ra) # 5890 <exec>
    163a:	02054163          	bltz	a0,165c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    163e:	fdc40513          	addi	a0,s0,-36
    1642:	00004097          	auipc	ra,0x4
    1646:	21e080e7          	jalr	542(ra) # 5860 <wait>
    164a:	02951763          	bne	a0,s1,1678 <exectest+0x118>
  if(xstatus != 0)
    164e:	fdc42503          	lw	a0,-36(s0)
    1652:	cd0d                	beqz	a0,168c <exectest+0x12c>
    exit(xstatus);
    1654:	00004097          	auipc	ra,0x4
    1658:	204080e7          	jalr	516(ra) # 5858 <exit>
      printf("%s: exec echo failed\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	07250513          	addi	a0,a0,114 # 66d0 <malloc+0xa36>
    1666:	00004097          	auipc	ra,0x4
    166a:	57c080e7          	jalr	1404(ra) # 5be2 <printf>
      exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	1e8080e7          	jalr	488(ra) # 5858 <exit>
    printf("%s: wait failed!\n", s);
    1678:	85ca                	mv	a1,s2
    167a:	00005517          	auipc	a0,0x5
    167e:	06e50513          	addi	a0,a0,110 # 66e8 <malloc+0xa4e>
    1682:	00004097          	auipc	ra,0x4
    1686:	560080e7          	jalr	1376(ra) # 5be2 <printf>
    168a:	b7d1                	j	164e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    168c:	4581                	li	a1,0
    168e:	00005517          	auipc	a0,0x5
    1692:	01250513          	addi	a0,a0,18 # 66a0 <malloc+0xa06>
    1696:	00004097          	auipc	ra,0x4
    169a:	202080e7          	jalr	514(ra) # 5898 <open>
  if(fd < 0) {
    169e:	02054a63          	bltz	a0,16d2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a2:	4609                	li	a2,2
    16a4:	fb840593          	addi	a1,s0,-72
    16a8:	00004097          	auipc	ra,0x4
    16ac:	1c8080e7          	jalr	456(ra) # 5870 <read>
    16b0:	4789                	li	a5,2
    16b2:	02f50e63          	beq	a0,a5,16ee <exectest+0x18e>
    printf("%s: read failed\n", s);
    16b6:	85ca                	mv	a1,s2
    16b8:	00005517          	auipc	a0,0x5
    16bc:	aa050513          	addi	a0,a0,-1376 # 6158 <malloc+0x4be>
    16c0:	00004097          	auipc	ra,0x4
    16c4:	522080e7          	jalr	1314(ra) # 5be2 <printf>
    exit(1);
    16c8:	4505                	li	a0,1
    16ca:	00004097          	auipc	ra,0x4
    16ce:	18e080e7          	jalr	398(ra) # 5858 <exit>
    printf("%s: open failed\n", s);
    16d2:	85ca                	mv	a1,s2
    16d4:	00005517          	auipc	a0,0x5
    16d8:	f5450513          	addi	a0,a0,-172 # 6628 <malloc+0x98e>
    16dc:	00004097          	auipc	ra,0x4
    16e0:	506080e7          	jalr	1286(ra) # 5be2 <printf>
    exit(1);
    16e4:	4505                	li	a0,1
    16e6:	00004097          	auipc	ra,0x4
    16ea:	172080e7          	jalr	370(ra) # 5858 <exit>
  unlink("echo-ok");
    16ee:	00005517          	auipc	a0,0x5
    16f2:	fb250513          	addi	a0,a0,-78 # 66a0 <malloc+0xa06>
    16f6:	00004097          	auipc	ra,0x4
    16fa:	1b2080e7          	jalr	434(ra) # 58a8 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    16fe:	fb844703          	lbu	a4,-72(s0)
    1702:	04f00793          	li	a5,79
    1706:	00f71863          	bne	a4,a5,1716 <exectest+0x1b6>
    170a:	fb944703          	lbu	a4,-71(s0)
    170e:	04b00793          	li	a5,75
    1712:	02f70063          	beq	a4,a5,1732 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1716:	85ca                	mv	a1,s2
    1718:	00005517          	auipc	a0,0x5
    171c:	fe850513          	addi	a0,a0,-24 # 6700 <malloc+0xa66>
    1720:	00004097          	auipc	ra,0x4
    1724:	4c2080e7          	jalr	1218(ra) # 5be2 <printf>
    exit(1);
    1728:	4505                	li	a0,1
    172a:	00004097          	auipc	ra,0x4
    172e:	12e080e7          	jalr	302(ra) # 5858 <exit>
    exit(0);
    1732:	4501                	li	a0,0
    1734:	00004097          	auipc	ra,0x4
    1738:	124080e7          	jalr	292(ra) # 5858 <exit>

000000000000173c <pipe1>:
{
    173c:	711d                	addi	sp,sp,-96
    173e:	ec86                	sd	ra,88(sp)
    1740:	e8a2                	sd	s0,80(sp)
    1742:	e4a6                	sd	s1,72(sp)
    1744:	e0ca                	sd	s2,64(sp)
    1746:	fc4e                	sd	s3,56(sp)
    1748:	f852                	sd	s4,48(sp)
    174a:	f456                	sd	s5,40(sp)
    174c:	f05a                	sd	s6,32(sp)
    174e:	ec5e                	sd	s7,24(sp)
    1750:	1080                	addi	s0,sp,96
    1752:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1754:	fa840513          	addi	a0,s0,-88
    1758:	00004097          	auipc	ra,0x4
    175c:	110080e7          	jalr	272(ra) # 5868 <pipe>
    1760:	e93d                	bnez	a0,17d6 <pipe1+0x9a>
    1762:	84aa                	mv	s1,a0
  pid = fork();
    1764:	00004097          	auipc	ra,0x4
    1768:	0ec080e7          	jalr	236(ra) # 5850 <fork>
    176c:	8a2a                	mv	s4,a0
  if(pid == 0){
    176e:	c151                	beqz	a0,17f2 <pipe1+0xb6>
  } else if(pid > 0){
    1770:	16a05d63          	blez	a0,18ea <pipe1+0x1ae>
    close(fds[1]);
    1774:	fac42503          	lw	a0,-84(s0)
    1778:	00004097          	auipc	ra,0x4
    177c:	108080e7          	jalr	264(ra) # 5880 <close>
    total = 0;
    1780:	8a26                	mv	s4,s1
    cc = 1;
    1782:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1784:	0000aa97          	auipc	s5,0xa
    1788:	674a8a93          	addi	s5,s5,1652 # bdf8 <buf>
      if(cc > sizeof(buf))
    178c:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    178e:	864e                	mv	a2,s3
    1790:	85d6                	mv	a1,s5
    1792:	fa842503          	lw	a0,-88(s0)
    1796:	00004097          	auipc	ra,0x4
    179a:	0da080e7          	jalr	218(ra) # 5870 <read>
    179e:	10a05163          	blez	a0,18a0 <pipe1+0x164>
      for(i = 0; i < n; i++){
    17a2:	0000a717          	auipc	a4,0xa
    17a6:	65670713          	addi	a4,a4,1622 # bdf8 <buf>
    17aa:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17ae:	00074683          	lbu	a3,0(a4)
    17b2:	0ff4f793          	zext.b	a5,s1
    17b6:	2485                	addiw	s1,s1,1
    17b8:	0cf69063          	bne	a3,a5,1878 <pipe1+0x13c>
      for(i = 0; i < n; i++){
    17bc:	0705                	addi	a4,a4,1
    17be:	fec498e3          	bne	s1,a2,17ae <pipe1+0x72>
      total += n;
    17c2:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17c6:	0019979b          	slliw	a5,s3,0x1
    17ca:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17ce:	fd3b70e3          	bgeu	s6,s3,178e <pipe1+0x52>
        cc = sizeof(buf);
    17d2:	89da                	mv	s3,s6
    17d4:	bf6d                	j	178e <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17d6:	85ca                	mv	a1,s2
    17d8:	00005517          	auipc	a0,0x5
    17dc:	f4050513          	addi	a0,a0,-192 # 6718 <malloc+0xa7e>
    17e0:	00004097          	auipc	ra,0x4
    17e4:	402080e7          	jalr	1026(ra) # 5be2 <printf>
    exit(1);
    17e8:	4505                	li	a0,1
    17ea:	00004097          	auipc	ra,0x4
    17ee:	06e080e7          	jalr	110(ra) # 5858 <exit>
    close(fds[0]);
    17f2:	fa842503          	lw	a0,-88(s0)
    17f6:	00004097          	auipc	ra,0x4
    17fa:	08a080e7          	jalr	138(ra) # 5880 <close>
    for(n = 0; n < N; n++){
    17fe:	0000ab17          	auipc	s6,0xa
    1802:	5fab0b13          	addi	s6,s6,1530 # bdf8 <buf>
    1806:	416004bb          	negw	s1,s6
    180a:	0ff4f493          	zext.b	s1,s1
    180e:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1812:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1814:	6a85                	lui	s5,0x1
    1816:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x87>
{
    181a:	87da                	mv	a5,s6
        buf[i] = seq++;
    181c:	0097873b          	addw	a4,a5,s1
    1820:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1824:	0785                	addi	a5,a5,1
    1826:	fef99be3          	bne	s3,a5,181c <pipe1+0xe0>
        buf[i] = seq++;
    182a:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    182e:	40900613          	li	a2,1033
    1832:	85de                	mv	a1,s7
    1834:	fac42503          	lw	a0,-84(s0)
    1838:	00004097          	auipc	ra,0x4
    183c:	040080e7          	jalr	64(ra) # 5878 <write>
    1840:	40900793          	li	a5,1033
    1844:	00f51c63          	bne	a0,a5,185c <pipe1+0x120>
    for(n = 0; n < N; n++){
    1848:	24a5                	addiw	s1,s1,9
    184a:	0ff4f493          	zext.b	s1,s1
    184e:	fd5a16e3          	bne	s4,s5,181a <pipe1+0xde>
    exit(0);
    1852:	4501                	li	a0,0
    1854:	00004097          	auipc	ra,0x4
    1858:	004080e7          	jalr	4(ra) # 5858 <exit>
        printf("%s: pipe1 oops 1\n", s);
    185c:	85ca                	mv	a1,s2
    185e:	00005517          	auipc	a0,0x5
    1862:	ed250513          	addi	a0,a0,-302 # 6730 <malloc+0xa96>
    1866:	00004097          	auipc	ra,0x4
    186a:	37c080e7          	jalr	892(ra) # 5be2 <printf>
        exit(1);
    186e:	4505                	li	a0,1
    1870:	00004097          	auipc	ra,0x4
    1874:	fe8080e7          	jalr	-24(ra) # 5858 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1878:	85ca                	mv	a1,s2
    187a:	00005517          	auipc	a0,0x5
    187e:	ece50513          	addi	a0,a0,-306 # 6748 <malloc+0xaae>
    1882:	00004097          	auipc	ra,0x4
    1886:	360080e7          	jalr	864(ra) # 5be2 <printf>
}
    188a:	60e6                	ld	ra,88(sp)
    188c:	6446                	ld	s0,80(sp)
    188e:	64a6                	ld	s1,72(sp)
    1890:	6906                	ld	s2,64(sp)
    1892:	79e2                	ld	s3,56(sp)
    1894:	7a42                	ld	s4,48(sp)
    1896:	7aa2                	ld	s5,40(sp)
    1898:	7b02                	ld	s6,32(sp)
    189a:	6be2                	ld	s7,24(sp)
    189c:	6125                	addi	sp,sp,96
    189e:	8082                	ret
    if(total != N * SZ){
    18a0:	6785                	lui	a5,0x1
    18a2:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x87>
    18a6:	02fa0063          	beq	s4,a5,18c6 <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18aa:	85d2                	mv	a1,s4
    18ac:	00005517          	auipc	a0,0x5
    18b0:	eb450513          	addi	a0,a0,-332 # 6760 <malloc+0xac6>
    18b4:	00004097          	auipc	ra,0x4
    18b8:	32e080e7          	jalr	814(ra) # 5be2 <printf>
      exit(1);
    18bc:	4505                	li	a0,1
    18be:	00004097          	auipc	ra,0x4
    18c2:	f9a080e7          	jalr	-102(ra) # 5858 <exit>
    close(fds[0]);
    18c6:	fa842503          	lw	a0,-88(s0)
    18ca:	00004097          	auipc	ra,0x4
    18ce:	fb6080e7          	jalr	-74(ra) # 5880 <close>
    wait(&xstatus);
    18d2:	fa440513          	addi	a0,s0,-92
    18d6:	00004097          	auipc	ra,0x4
    18da:	f8a080e7          	jalr	-118(ra) # 5860 <wait>
    exit(xstatus);
    18de:	fa442503          	lw	a0,-92(s0)
    18e2:	00004097          	auipc	ra,0x4
    18e6:	f76080e7          	jalr	-138(ra) # 5858 <exit>
    printf("%s: fork() failed\n", s);
    18ea:	85ca                	mv	a1,s2
    18ec:	00005517          	auipc	a0,0x5
    18f0:	e9450513          	addi	a0,a0,-364 # 6780 <malloc+0xae6>
    18f4:	00004097          	auipc	ra,0x4
    18f8:	2ee080e7          	jalr	750(ra) # 5be2 <printf>
    exit(1);
    18fc:	4505                	li	a0,1
    18fe:	00004097          	auipc	ra,0x4
    1902:	f5a080e7          	jalr	-166(ra) # 5858 <exit>

0000000000001906 <exitwait>:
{
    1906:	7139                	addi	sp,sp,-64
    1908:	fc06                	sd	ra,56(sp)
    190a:	f822                	sd	s0,48(sp)
    190c:	f426                	sd	s1,40(sp)
    190e:	f04a                	sd	s2,32(sp)
    1910:	ec4e                	sd	s3,24(sp)
    1912:	e852                	sd	s4,16(sp)
    1914:	0080                	addi	s0,sp,64
    1916:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1918:	4901                	li	s2,0
    191a:	06400993          	li	s3,100
    pid = fork();
    191e:	00004097          	auipc	ra,0x4
    1922:	f32080e7          	jalr	-206(ra) # 5850 <fork>
    1926:	84aa                	mv	s1,a0
    if(pid < 0){
    1928:	02054a63          	bltz	a0,195c <exitwait+0x56>
    if(pid){
    192c:	c151                	beqz	a0,19b0 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    192e:	fcc40513          	addi	a0,s0,-52
    1932:	00004097          	auipc	ra,0x4
    1936:	f2e080e7          	jalr	-210(ra) # 5860 <wait>
    193a:	02951f63          	bne	a0,s1,1978 <exitwait+0x72>
      if(i != xstate) {
    193e:	fcc42783          	lw	a5,-52(s0)
    1942:	05279963          	bne	a5,s2,1994 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1946:	2905                	addiw	s2,s2,1
    1948:	fd391be3          	bne	s2,s3,191e <exitwait+0x18>
}
    194c:	70e2                	ld	ra,56(sp)
    194e:	7442                	ld	s0,48(sp)
    1950:	74a2                	ld	s1,40(sp)
    1952:	7902                	ld	s2,32(sp)
    1954:	69e2                	ld	s3,24(sp)
    1956:	6a42                	ld	s4,16(sp)
    1958:	6121                	addi	sp,sp,64
    195a:	8082                	ret
      printf("%s: fork failed\n", s);
    195c:	85d2                	mv	a1,s4
    195e:	00005517          	auipc	a0,0x5
    1962:	cb250513          	addi	a0,a0,-846 # 6610 <malloc+0x976>
    1966:	00004097          	auipc	ra,0x4
    196a:	27c080e7          	jalr	636(ra) # 5be2 <printf>
      exit(1);
    196e:	4505                	li	a0,1
    1970:	00004097          	auipc	ra,0x4
    1974:	ee8080e7          	jalr	-280(ra) # 5858 <exit>
        printf("%s: wait wrong pid\n", s);
    1978:	85d2                	mv	a1,s4
    197a:	00005517          	auipc	a0,0x5
    197e:	e1e50513          	addi	a0,a0,-482 # 6798 <malloc+0xafe>
    1982:	00004097          	auipc	ra,0x4
    1986:	260080e7          	jalr	608(ra) # 5be2 <printf>
        exit(1);
    198a:	4505                	li	a0,1
    198c:	00004097          	auipc	ra,0x4
    1990:	ecc080e7          	jalr	-308(ra) # 5858 <exit>
        printf("%s: wait wrong exit status\n", s);
    1994:	85d2                	mv	a1,s4
    1996:	00005517          	auipc	a0,0x5
    199a:	e1a50513          	addi	a0,a0,-486 # 67b0 <malloc+0xb16>
    199e:	00004097          	auipc	ra,0x4
    19a2:	244080e7          	jalr	580(ra) # 5be2 <printf>
        exit(1);
    19a6:	4505                	li	a0,1
    19a8:	00004097          	auipc	ra,0x4
    19ac:	eb0080e7          	jalr	-336(ra) # 5858 <exit>
      exit(i);
    19b0:	854a                	mv	a0,s2
    19b2:	00004097          	auipc	ra,0x4
    19b6:	ea6080e7          	jalr	-346(ra) # 5858 <exit>

00000000000019ba <twochildren>:
{
    19ba:	1101                	addi	sp,sp,-32
    19bc:	ec06                	sd	ra,24(sp)
    19be:	e822                	sd	s0,16(sp)
    19c0:	e426                	sd	s1,8(sp)
    19c2:	e04a                	sd	s2,0(sp)
    19c4:	1000                	addi	s0,sp,32
    19c6:	892a                	mv	s2,a0
    19c8:	3e800493          	li	s1,1000
    int pid1 = fork();
    19cc:	00004097          	auipc	ra,0x4
    19d0:	e84080e7          	jalr	-380(ra) # 5850 <fork>
    if(pid1 < 0){
    19d4:	02054c63          	bltz	a0,1a0c <twochildren+0x52>
    if(pid1 == 0){
    19d8:	c921                	beqz	a0,1a28 <twochildren+0x6e>
      int pid2 = fork();
    19da:	00004097          	auipc	ra,0x4
    19de:	e76080e7          	jalr	-394(ra) # 5850 <fork>
      if(pid2 < 0){
    19e2:	04054763          	bltz	a0,1a30 <twochildren+0x76>
      if(pid2 == 0){
    19e6:	c13d                	beqz	a0,1a4c <twochildren+0x92>
        wait(0);
    19e8:	4501                	li	a0,0
    19ea:	00004097          	auipc	ra,0x4
    19ee:	e76080e7          	jalr	-394(ra) # 5860 <wait>
        wait(0);
    19f2:	4501                	li	a0,0
    19f4:	00004097          	auipc	ra,0x4
    19f8:	e6c080e7          	jalr	-404(ra) # 5860 <wait>
  for(int i = 0; i < 1000; i++){
    19fc:	34fd                	addiw	s1,s1,-1
    19fe:	f4f9                	bnez	s1,19cc <twochildren+0x12>
}
    1a00:	60e2                	ld	ra,24(sp)
    1a02:	6442                	ld	s0,16(sp)
    1a04:	64a2                	ld	s1,8(sp)
    1a06:	6902                	ld	s2,0(sp)
    1a08:	6105                	addi	sp,sp,32
    1a0a:	8082                	ret
      printf("%s: fork failed\n", s);
    1a0c:	85ca                	mv	a1,s2
    1a0e:	00005517          	auipc	a0,0x5
    1a12:	c0250513          	addi	a0,a0,-1022 # 6610 <malloc+0x976>
    1a16:	00004097          	auipc	ra,0x4
    1a1a:	1cc080e7          	jalr	460(ra) # 5be2 <printf>
      exit(1);
    1a1e:	4505                	li	a0,1
    1a20:	00004097          	auipc	ra,0x4
    1a24:	e38080e7          	jalr	-456(ra) # 5858 <exit>
      exit(0);
    1a28:	00004097          	auipc	ra,0x4
    1a2c:	e30080e7          	jalr	-464(ra) # 5858 <exit>
        printf("%s: fork failed\n", s);
    1a30:	85ca                	mv	a1,s2
    1a32:	00005517          	auipc	a0,0x5
    1a36:	bde50513          	addi	a0,a0,-1058 # 6610 <malloc+0x976>
    1a3a:	00004097          	auipc	ra,0x4
    1a3e:	1a8080e7          	jalr	424(ra) # 5be2 <printf>
        exit(1);
    1a42:	4505                	li	a0,1
    1a44:	00004097          	auipc	ra,0x4
    1a48:	e14080e7          	jalr	-492(ra) # 5858 <exit>
        exit(0);
    1a4c:	00004097          	auipc	ra,0x4
    1a50:	e0c080e7          	jalr	-500(ra) # 5858 <exit>

0000000000001a54 <forkfork>:
{
    1a54:	7179                	addi	sp,sp,-48
    1a56:	f406                	sd	ra,40(sp)
    1a58:	f022                	sd	s0,32(sp)
    1a5a:	ec26                	sd	s1,24(sp)
    1a5c:	1800                	addi	s0,sp,48
    1a5e:	84aa                	mv	s1,a0
    int pid = fork();
    1a60:	00004097          	auipc	ra,0x4
    1a64:	df0080e7          	jalr	-528(ra) # 5850 <fork>
    if(pid < 0){
    1a68:	04054163          	bltz	a0,1aaa <forkfork+0x56>
    if(pid == 0){
    1a6c:	cd29                	beqz	a0,1ac6 <forkfork+0x72>
    int pid = fork();
    1a6e:	00004097          	auipc	ra,0x4
    1a72:	de2080e7          	jalr	-542(ra) # 5850 <fork>
    if(pid < 0){
    1a76:	02054a63          	bltz	a0,1aaa <forkfork+0x56>
    if(pid == 0){
    1a7a:	c531                	beqz	a0,1ac6 <forkfork+0x72>
    wait(&xstatus);
    1a7c:	fdc40513          	addi	a0,s0,-36
    1a80:	00004097          	auipc	ra,0x4
    1a84:	de0080e7          	jalr	-544(ra) # 5860 <wait>
    if(xstatus != 0) {
    1a88:	fdc42783          	lw	a5,-36(s0)
    1a8c:	ebbd                	bnez	a5,1b02 <forkfork+0xae>
    wait(&xstatus);
    1a8e:	fdc40513          	addi	a0,s0,-36
    1a92:	00004097          	auipc	ra,0x4
    1a96:	dce080e7          	jalr	-562(ra) # 5860 <wait>
    if(xstatus != 0) {
    1a9a:	fdc42783          	lw	a5,-36(s0)
    1a9e:	e3b5                	bnez	a5,1b02 <forkfork+0xae>
}
    1aa0:	70a2                	ld	ra,40(sp)
    1aa2:	7402                	ld	s0,32(sp)
    1aa4:	64e2                	ld	s1,24(sp)
    1aa6:	6145                	addi	sp,sp,48
    1aa8:	8082                	ret
      printf("%s: fork failed", s);
    1aaa:	85a6                	mv	a1,s1
    1aac:	00005517          	auipc	a0,0x5
    1ab0:	d2450513          	addi	a0,a0,-732 # 67d0 <malloc+0xb36>
    1ab4:	00004097          	auipc	ra,0x4
    1ab8:	12e080e7          	jalr	302(ra) # 5be2 <printf>
      exit(1);
    1abc:	4505                	li	a0,1
    1abe:	00004097          	auipc	ra,0x4
    1ac2:	d9a080e7          	jalr	-614(ra) # 5858 <exit>
{
    1ac6:	0c800493          	li	s1,200
        int pid1 = fork();
    1aca:	00004097          	auipc	ra,0x4
    1ace:	d86080e7          	jalr	-634(ra) # 5850 <fork>
        if(pid1 < 0){
    1ad2:	00054f63          	bltz	a0,1af0 <forkfork+0x9c>
        if(pid1 == 0){
    1ad6:	c115                	beqz	a0,1afa <forkfork+0xa6>
        wait(0);
    1ad8:	4501                	li	a0,0
    1ada:	00004097          	auipc	ra,0x4
    1ade:	d86080e7          	jalr	-634(ra) # 5860 <wait>
      for(int j = 0; j < 200; j++){
    1ae2:	34fd                	addiw	s1,s1,-1
    1ae4:	f0fd                	bnez	s1,1aca <forkfork+0x76>
      exit(0);
    1ae6:	4501                	li	a0,0
    1ae8:	00004097          	auipc	ra,0x4
    1aec:	d70080e7          	jalr	-656(ra) # 5858 <exit>
          exit(1);
    1af0:	4505                	li	a0,1
    1af2:	00004097          	auipc	ra,0x4
    1af6:	d66080e7          	jalr	-666(ra) # 5858 <exit>
          exit(0);
    1afa:	00004097          	auipc	ra,0x4
    1afe:	d5e080e7          	jalr	-674(ra) # 5858 <exit>
      printf("%s: fork in child failed", s);
    1b02:	85a6                	mv	a1,s1
    1b04:	00005517          	auipc	a0,0x5
    1b08:	cdc50513          	addi	a0,a0,-804 # 67e0 <malloc+0xb46>
    1b0c:	00004097          	auipc	ra,0x4
    1b10:	0d6080e7          	jalr	214(ra) # 5be2 <printf>
      exit(1);
    1b14:	4505                	li	a0,1
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	d42080e7          	jalr	-702(ra) # 5858 <exit>

0000000000001b1e <reparent2>:
{
    1b1e:	1101                	addi	sp,sp,-32
    1b20:	ec06                	sd	ra,24(sp)
    1b22:	e822                	sd	s0,16(sp)
    1b24:	e426                	sd	s1,8(sp)
    1b26:	1000                	addi	s0,sp,32
    1b28:	32000493          	li	s1,800
    int pid1 = fork();
    1b2c:	00004097          	auipc	ra,0x4
    1b30:	d24080e7          	jalr	-732(ra) # 5850 <fork>
    if(pid1 < 0){
    1b34:	00054f63          	bltz	a0,1b52 <reparent2+0x34>
    if(pid1 == 0){
    1b38:	c915                	beqz	a0,1b6c <reparent2+0x4e>
    wait(0);
    1b3a:	4501                	li	a0,0
    1b3c:	00004097          	auipc	ra,0x4
    1b40:	d24080e7          	jalr	-732(ra) # 5860 <wait>
  for(int i = 0; i < 800; i++){
    1b44:	34fd                	addiw	s1,s1,-1
    1b46:	f0fd                	bnez	s1,1b2c <reparent2+0xe>
  exit(0);
    1b48:	4501                	li	a0,0
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	d0e080e7          	jalr	-754(ra) # 5858 <exit>
      printf("fork failed\n");
    1b52:	00005517          	auipc	a0,0x5
    1b56:	ede50513          	addi	a0,a0,-290 # 6a30 <malloc+0xd96>
    1b5a:	00004097          	auipc	ra,0x4
    1b5e:	088080e7          	jalr	136(ra) # 5be2 <printf>
      exit(1);
    1b62:	4505                	li	a0,1
    1b64:	00004097          	auipc	ra,0x4
    1b68:	cf4080e7          	jalr	-780(ra) # 5858 <exit>
      fork();
    1b6c:	00004097          	auipc	ra,0x4
    1b70:	ce4080e7          	jalr	-796(ra) # 5850 <fork>
      fork();
    1b74:	00004097          	auipc	ra,0x4
    1b78:	cdc080e7          	jalr	-804(ra) # 5850 <fork>
      exit(0);
    1b7c:	4501                	li	a0,0
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	cda080e7          	jalr	-806(ra) # 5858 <exit>

0000000000001b86 <createdelete>:
{
    1b86:	7175                	addi	sp,sp,-144
    1b88:	e506                	sd	ra,136(sp)
    1b8a:	e122                	sd	s0,128(sp)
    1b8c:	fca6                	sd	s1,120(sp)
    1b8e:	f8ca                	sd	s2,112(sp)
    1b90:	f4ce                	sd	s3,104(sp)
    1b92:	f0d2                	sd	s4,96(sp)
    1b94:	ecd6                	sd	s5,88(sp)
    1b96:	e8da                	sd	s6,80(sp)
    1b98:	e4de                	sd	s7,72(sp)
    1b9a:	e0e2                	sd	s8,64(sp)
    1b9c:	fc66                	sd	s9,56(sp)
    1b9e:	0900                	addi	s0,sp,144
    1ba0:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba2:	4901                	li	s2,0
    1ba4:	4991                	li	s3,4
    pid = fork();
    1ba6:	00004097          	auipc	ra,0x4
    1baa:	caa080e7          	jalr	-854(ra) # 5850 <fork>
    1bae:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb0:	02054f63          	bltz	a0,1bee <createdelete+0x68>
    if(pid == 0){
    1bb4:	c939                	beqz	a0,1c0a <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bb6:	2905                	addiw	s2,s2,1
    1bb8:	ff3917e3          	bne	s2,s3,1ba6 <createdelete+0x20>
    1bbc:	4491                	li	s1,4
    wait(&xstatus);
    1bbe:	f7c40513          	addi	a0,s0,-132
    1bc2:	00004097          	auipc	ra,0x4
    1bc6:	c9e080e7          	jalr	-866(ra) # 5860 <wait>
    if(xstatus != 0)
    1bca:	f7c42903          	lw	s2,-132(s0)
    1bce:	0e091263          	bnez	s2,1cb2 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd2:	34fd                	addiw	s1,s1,-1
    1bd4:	f4ed                	bnez	s1,1bbe <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bd6:	f8040123          	sb	zero,-126(s0)
    1bda:	03000993          	li	s3,48
    1bde:	5a7d                	li	s4,-1
    1be0:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1be4:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1be6:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1be8:	07400a93          	li	s5,116
    1bec:	a29d                	j	1d52 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bee:	85e6                	mv	a1,s9
    1bf0:	00005517          	auipc	a0,0x5
    1bf4:	e4050513          	addi	a0,a0,-448 # 6a30 <malloc+0xd96>
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	fea080e7          	jalr	-22(ra) # 5be2 <printf>
      exit(1);
    1c00:	4505                	li	a0,1
    1c02:	00004097          	auipc	ra,0x4
    1c06:	c56080e7          	jalr	-938(ra) # 5858 <exit>
      name[0] = 'p' + pi;
    1c0a:	0709091b          	addiw	s2,s2,112
    1c0e:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c12:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c16:	4951                	li	s2,20
    1c18:	a015                	j	1c3c <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c1a:	85e6                	mv	a1,s9
    1c1c:	00005517          	auipc	a0,0x5
    1c20:	a8c50513          	addi	a0,a0,-1396 # 66a8 <malloc+0xa0e>
    1c24:	00004097          	auipc	ra,0x4
    1c28:	fbe080e7          	jalr	-66(ra) # 5be2 <printf>
          exit(1);
    1c2c:	4505                	li	a0,1
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	c2a080e7          	jalr	-982(ra) # 5858 <exit>
      for(i = 0; i < N; i++){
    1c36:	2485                	addiw	s1,s1,1
    1c38:	07248863          	beq	s1,s2,1ca8 <createdelete+0x122>
        name[1] = '0' + i;
    1c3c:	0304879b          	addiw	a5,s1,48
    1c40:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c44:	20200593          	li	a1,514
    1c48:	f8040513          	addi	a0,s0,-128
    1c4c:	00004097          	auipc	ra,0x4
    1c50:	c4c080e7          	jalr	-948(ra) # 5898 <open>
        if(fd < 0){
    1c54:	fc0543e3          	bltz	a0,1c1a <createdelete+0x94>
        close(fd);
    1c58:	00004097          	auipc	ra,0x4
    1c5c:	c28080e7          	jalr	-984(ra) # 5880 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c60:	fc905be3          	blez	s1,1c36 <createdelete+0xb0>
    1c64:	0014f793          	andi	a5,s1,1
    1c68:	f7f9                	bnez	a5,1c36 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c6a:	01f4d79b          	srliw	a5,s1,0x1f
    1c6e:	9fa5                	addw	a5,a5,s1
    1c70:	4017d79b          	sraiw	a5,a5,0x1
    1c74:	0307879b          	addiw	a5,a5,48
    1c78:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c7c:	f8040513          	addi	a0,s0,-128
    1c80:	00004097          	auipc	ra,0x4
    1c84:	c28080e7          	jalr	-984(ra) # 58a8 <unlink>
    1c88:	fa0557e3          	bgez	a0,1c36 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c8c:	85e6                	mv	a1,s9
    1c8e:	00005517          	auipc	a0,0x5
    1c92:	b7250513          	addi	a0,a0,-1166 # 6800 <malloc+0xb66>
    1c96:	00004097          	auipc	ra,0x4
    1c9a:	f4c080e7          	jalr	-180(ra) # 5be2 <printf>
            exit(1);
    1c9e:	4505                	li	a0,1
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	bb8080e7          	jalr	-1096(ra) # 5858 <exit>
      exit(0);
    1ca8:	4501                	li	a0,0
    1caa:	00004097          	auipc	ra,0x4
    1cae:	bae080e7          	jalr	-1106(ra) # 5858 <exit>
      exit(1);
    1cb2:	4505                	li	a0,1
    1cb4:	00004097          	auipc	ra,0x4
    1cb8:	ba4080e7          	jalr	-1116(ra) # 5858 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cbc:	f8040613          	addi	a2,s0,-128
    1cc0:	85e6                	mv	a1,s9
    1cc2:	00005517          	auipc	a0,0x5
    1cc6:	b5650513          	addi	a0,a0,-1194 # 6818 <malloc+0xb7e>
    1cca:	00004097          	auipc	ra,0x4
    1cce:	f18080e7          	jalr	-232(ra) # 5be2 <printf>
        exit(1);
    1cd2:	4505                	li	a0,1
    1cd4:	00004097          	auipc	ra,0x4
    1cd8:	b84080e7          	jalr	-1148(ra) # 5858 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1cdc:	054b7163          	bgeu	s6,s4,1d1e <createdelete+0x198>
      if(fd >= 0)
    1ce0:	02055a63          	bgez	a0,1d14 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ce4:	2485                	addiw	s1,s1,1
    1ce6:	0ff4f493          	zext.b	s1,s1
    1cea:	05548c63          	beq	s1,s5,1d42 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cee:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf2:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cf6:	4581                	li	a1,0
    1cf8:	f8040513          	addi	a0,s0,-128
    1cfc:	00004097          	auipc	ra,0x4
    1d00:	b9c080e7          	jalr	-1124(ra) # 5898 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d04:	00090463          	beqz	s2,1d0c <createdelete+0x186>
    1d08:	fd2bdae3          	bge	s7,s2,1cdc <createdelete+0x156>
    1d0c:	fa0548e3          	bltz	a0,1cbc <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d10:	014b7963          	bgeu	s6,s4,1d22 <createdelete+0x19c>
        close(fd);
    1d14:	00004097          	auipc	ra,0x4
    1d18:	b6c080e7          	jalr	-1172(ra) # 5880 <close>
    1d1c:	b7e1                	j	1ce4 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d1e:	fc0543e3          	bltz	a0,1ce4 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d22:	f8040613          	addi	a2,s0,-128
    1d26:	85e6                	mv	a1,s9
    1d28:	00005517          	auipc	a0,0x5
    1d2c:	b1850513          	addi	a0,a0,-1256 # 6840 <malloc+0xba6>
    1d30:	00004097          	auipc	ra,0x4
    1d34:	eb2080e7          	jalr	-334(ra) # 5be2 <printf>
        exit(1);
    1d38:	4505                	li	a0,1
    1d3a:	00004097          	auipc	ra,0x4
    1d3e:	b1e080e7          	jalr	-1250(ra) # 5858 <exit>
  for(i = 0; i < N; i++){
    1d42:	2905                	addiw	s2,s2,1
    1d44:	2a05                	addiw	s4,s4,1
    1d46:	2985                	addiw	s3,s3,1
    1d48:	0ff9f993          	zext.b	s3,s3
    1d4c:	47d1                	li	a5,20
    1d4e:	02f90a63          	beq	s2,a5,1d82 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d52:	84e2                	mv	s1,s8
    1d54:	bf69                	j	1cee <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d56:	2905                	addiw	s2,s2,1
    1d58:	0ff97913          	zext.b	s2,s2
    1d5c:	2985                	addiw	s3,s3,1
    1d5e:	0ff9f993          	zext.b	s3,s3
    1d62:	03490863          	beq	s2,s4,1d92 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d66:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d68:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d6c:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d70:	f8040513          	addi	a0,s0,-128
    1d74:	00004097          	auipc	ra,0x4
    1d78:	b34080e7          	jalr	-1228(ra) # 58a8 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d7c:	34fd                	addiw	s1,s1,-1
    1d7e:	f4ed                	bnez	s1,1d68 <createdelete+0x1e2>
    1d80:	bfd9                	j	1d56 <createdelete+0x1d0>
    1d82:	03000993          	li	s3,48
    1d86:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d8a:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d8c:	08400a13          	li	s4,132
    1d90:	bfd9                	j	1d66 <createdelete+0x1e0>
}
    1d92:	60aa                	ld	ra,136(sp)
    1d94:	640a                	ld	s0,128(sp)
    1d96:	74e6                	ld	s1,120(sp)
    1d98:	7946                	ld	s2,112(sp)
    1d9a:	79a6                	ld	s3,104(sp)
    1d9c:	7a06                	ld	s4,96(sp)
    1d9e:	6ae6                	ld	s5,88(sp)
    1da0:	6b46                	ld	s6,80(sp)
    1da2:	6ba6                	ld	s7,72(sp)
    1da4:	6c06                	ld	s8,64(sp)
    1da6:	7ce2                	ld	s9,56(sp)
    1da8:	6149                	addi	sp,sp,144
    1daa:	8082                	ret

0000000000001dac <linkunlink>:
{
    1dac:	711d                	addi	sp,sp,-96
    1dae:	ec86                	sd	ra,88(sp)
    1db0:	e8a2                	sd	s0,80(sp)
    1db2:	e4a6                	sd	s1,72(sp)
    1db4:	e0ca                	sd	s2,64(sp)
    1db6:	fc4e                	sd	s3,56(sp)
    1db8:	f852                	sd	s4,48(sp)
    1dba:	f456                	sd	s5,40(sp)
    1dbc:	f05a                	sd	s6,32(sp)
    1dbe:	ec5e                	sd	s7,24(sp)
    1dc0:	e862                	sd	s8,16(sp)
    1dc2:	e466                	sd	s9,8(sp)
    1dc4:	1080                	addi	s0,sp,96
    1dc6:	84aa                	mv	s1,a0
  unlink("x");
    1dc8:	00004517          	auipc	a0,0x4
    1dcc:	06050513          	addi	a0,a0,96 # 5e28 <malloc+0x18e>
    1dd0:	00004097          	auipc	ra,0x4
    1dd4:	ad8080e7          	jalr	-1320(ra) # 58a8 <unlink>
  pid = fork();
    1dd8:	00004097          	auipc	ra,0x4
    1ddc:	a78080e7          	jalr	-1416(ra) # 5850 <fork>
  if(pid < 0){
    1de0:	02054b63          	bltz	a0,1e16 <linkunlink+0x6a>
    1de4:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1de6:	4c85                	li	s9,1
    1de8:	e119                	bnez	a0,1dee <linkunlink+0x42>
    1dea:	06100c93          	li	s9,97
    1dee:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df2:	41c659b7          	lui	s3,0x41c65
    1df6:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <__BSS_END__+0x41c56065>
    1dfa:	690d                	lui	s2,0x3
    1dfc:	0399091b          	addiw	s2,s2,57 # 3039 <iputtest+0xc5>
    if((x % 3) == 0){
    1e00:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e02:	4b05                	li	s6,1
      unlink("x");
    1e04:	00004a97          	auipc	s5,0x4
    1e08:	024a8a93          	addi	s5,s5,36 # 5e28 <malloc+0x18e>
      link("cat", "x");
    1e0c:	00005b97          	auipc	s7,0x5
    1e10:	a5cb8b93          	addi	s7,s7,-1444 # 6868 <malloc+0xbce>
    1e14:	a825                	j	1e4c <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e16:	85a6                	mv	a1,s1
    1e18:	00004517          	auipc	a0,0x4
    1e1c:	7f850513          	addi	a0,a0,2040 # 6610 <malloc+0x976>
    1e20:	00004097          	auipc	ra,0x4
    1e24:	dc2080e7          	jalr	-574(ra) # 5be2 <printf>
    exit(1);
    1e28:	4505                	li	a0,1
    1e2a:	00004097          	auipc	ra,0x4
    1e2e:	a2e080e7          	jalr	-1490(ra) # 5858 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e32:	20200593          	li	a1,514
    1e36:	8556                	mv	a0,s5
    1e38:	00004097          	auipc	ra,0x4
    1e3c:	a60080e7          	jalr	-1440(ra) # 5898 <open>
    1e40:	00004097          	auipc	ra,0x4
    1e44:	a40080e7          	jalr	-1472(ra) # 5880 <close>
  for(i = 0; i < 100; i++){
    1e48:	34fd                	addiw	s1,s1,-1
    1e4a:	c88d                	beqz	s1,1e7c <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e4c:	033c87bb          	mulw	a5,s9,s3
    1e50:	012787bb          	addw	a5,a5,s2
    1e54:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e58:	0347f7bb          	remuw	a5,a5,s4
    1e5c:	dbf9                	beqz	a5,1e32 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e5e:	01678863          	beq	a5,s6,1e6e <linkunlink+0xc2>
      unlink("x");
    1e62:	8556                	mv	a0,s5
    1e64:	00004097          	auipc	ra,0x4
    1e68:	a44080e7          	jalr	-1468(ra) # 58a8 <unlink>
    1e6c:	bff1                	j	1e48 <linkunlink+0x9c>
      link("cat", "x");
    1e6e:	85d6                	mv	a1,s5
    1e70:	855e                	mv	a0,s7
    1e72:	00004097          	auipc	ra,0x4
    1e76:	a46080e7          	jalr	-1466(ra) # 58b8 <link>
    1e7a:	b7f9                	j	1e48 <linkunlink+0x9c>
  if(pid)
    1e7c:	020c0463          	beqz	s8,1ea4 <linkunlink+0xf8>
    wait(0);
    1e80:	4501                	li	a0,0
    1e82:	00004097          	auipc	ra,0x4
    1e86:	9de080e7          	jalr	-1570(ra) # 5860 <wait>
}
    1e8a:	60e6                	ld	ra,88(sp)
    1e8c:	6446                	ld	s0,80(sp)
    1e8e:	64a6                	ld	s1,72(sp)
    1e90:	6906                	ld	s2,64(sp)
    1e92:	79e2                	ld	s3,56(sp)
    1e94:	7a42                	ld	s4,48(sp)
    1e96:	7aa2                	ld	s5,40(sp)
    1e98:	7b02                	ld	s6,32(sp)
    1e9a:	6be2                	ld	s7,24(sp)
    1e9c:	6c42                	ld	s8,16(sp)
    1e9e:	6ca2                	ld	s9,8(sp)
    1ea0:	6125                	addi	sp,sp,96
    1ea2:	8082                	ret
    exit(0);
    1ea4:	4501                	li	a0,0
    1ea6:	00004097          	auipc	ra,0x4
    1eaa:	9b2080e7          	jalr	-1614(ra) # 5858 <exit>

0000000000001eae <manywrites>:
{
    1eae:	711d                	addi	sp,sp,-96
    1eb0:	ec86                	sd	ra,88(sp)
    1eb2:	e8a2                	sd	s0,80(sp)
    1eb4:	e4a6                	sd	s1,72(sp)
    1eb6:	e0ca                	sd	s2,64(sp)
    1eb8:	fc4e                	sd	s3,56(sp)
    1eba:	f852                	sd	s4,48(sp)
    1ebc:	f456                	sd	s5,40(sp)
    1ebe:	f05a                	sd	s6,32(sp)
    1ec0:	ec5e                	sd	s7,24(sp)
    1ec2:	1080                	addi	s0,sp,96
    1ec4:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ec6:	4981                	li	s3,0
    1ec8:	4911                	li	s2,4
    int pid = fork();
    1eca:	00004097          	auipc	ra,0x4
    1ece:	986080e7          	jalr	-1658(ra) # 5850 <fork>
    1ed2:	84aa                	mv	s1,a0
    if(pid < 0){
    1ed4:	02054963          	bltz	a0,1f06 <manywrites+0x58>
    if(pid == 0){
    1ed8:	c521                	beqz	a0,1f20 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1eda:	2985                	addiw	s3,s3,1
    1edc:	ff2997e3          	bne	s3,s2,1eca <manywrites+0x1c>
    1ee0:	4491                	li	s1,4
    int st = 0;
    1ee2:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1ee6:	fa840513          	addi	a0,s0,-88
    1eea:	00004097          	auipc	ra,0x4
    1eee:	976080e7          	jalr	-1674(ra) # 5860 <wait>
    if(st != 0)
    1ef2:	fa842503          	lw	a0,-88(s0)
    1ef6:	ed6d                	bnez	a0,1ff0 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1ef8:	34fd                	addiw	s1,s1,-1
    1efa:	f4e5                	bnez	s1,1ee2 <manywrites+0x34>
  exit(0);
    1efc:	4501                	li	a0,0
    1efe:	00004097          	auipc	ra,0x4
    1f02:	95a080e7          	jalr	-1702(ra) # 5858 <exit>
      printf("fork failed\n");
    1f06:	00005517          	auipc	a0,0x5
    1f0a:	b2a50513          	addi	a0,a0,-1238 # 6a30 <malloc+0xd96>
    1f0e:	00004097          	auipc	ra,0x4
    1f12:	cd4080e7          	jalr	-812(ra) # 5be2 <printf>
      exit(1);
    1f16:	4505                	li	a0,1
    1f18:	00004097          	auipc	ra,0x4
    1f1c:	940080e7          	jalr	-1728(ra) # 5858 <exit>
      name[0] = 'b';
    1f20:	06200793          	li	a5,98
    1f24:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f28:	0619879b          	addiw	a5,s3,97
    1f2c:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f30:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f34:	fa840513          	addi	a0,s0,-88
    1f38:	00004097          	auipc	ra,0x4
    1f3c:	970080e7          	jalr	-1680(ra) # 58a8 <unlink>
    1f40:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f42:	0000ab17          	auipc	s6,0xa
    1f46:	eb6b0b13          	addi	s6,s6,-330 # bdf8 <buf>
        for(int i = 0; i < ci+1; i++){
    1f4a:	8a26                	mv	s4,s1
    1f4c:	0209ce63          	bltz	s3,1f88 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f50:	20200593          	li	a1,514
    1f54:	fa840513          	addi	a0,s0,-88
    1f58:	00004097          	auipc	ra,0x4
    1f5c:	940080e7          	jalr	-1728(ra) # 5898 <open>
    1f60:	892a                	mv	s2,a0
          if(fd < 0){
    1f62:	04054763          	bltz	a0,1fb0 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f66:	660d                	lui	a2,0x3
    1f68:	85da                	mv	a1,s6
    1f6a:	00004097          	auipc	ra,0x4
    1f6e:	90e080e7          	jalr	-1778(ra) # 5878 <write>
          if(cc != sz){
    1f72:	678d                	lui	a5,0x3
    1f74:	04f51e63          	bne	a0,a5,1fd0 <manywrites+0x122>
          close(fd);
    1f78:	854a                	mv	a0,s2
    1f7a:	00004097          	auipc	ra,0x4
    1f7e:	906080e7          	jalr	-1786(ra) # 5880 <close>
        for(int i = 0; i < ci+1; i++){
    1f82:	2a05                	addiw	s4,s4,1
    1f84:	fd49d6e3          	bge	s3,s4,1f50 <manywrites+0xa2>
        unlink(name);
    1f88:	fa840513          	addi	a0,s0,-88
    1f8c:	00004097          	auipc	ra,0x4
    1f90:	91c080e7          	jalr	-1764(ra) # 58a8 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f94:	3bfd                	addiw	s7,s7,-1
    1f96:	fa0b9ae3          	bnez	s7,1f4a <manywrites+0x9c>
      unlink(name);
    1f9a:	fa840513          	addi	a0,s0,-88
    1f9e:	00004097          	auipc	ra,0x4
    1fa2:	90a080e7          	jalr	-1782(ra) # 58a8 <unlink>
      exit(0);
    1fa6:	4501                	li	a0,0
    1fa8:	00004097          	auipc	ra,0x4
    1fac:	8b0080e7          	jalr	-1872(ra) # 5858 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb0:	fa840613          	addi	a2,s0,-88
    1fb4:	85d6                	mv	a1,s5
    1fb6:	00005517          	auipc	a0,0x5
    1fba:	8ba50513          	addi	a0,a0,-1862 # 6870 <malloc+0xbd6>
    1fbe:	00004097          	auipc	ra,0x4
    1fc2:	c24080e7          	jalr	-988(ra) # 5be2 <printf>
            exit(1);
    1fc6:	4505                	li	a0,1
    1fc8:	00004097          	auipc	ra,0x4
    1fcc:	890080e7          	jalr	-1904(ra) # 5858 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd0:	86aa                	mv	a3,a0
    1fd2:	660d                	lui	a2,0x3
    1fd4:	85d6                	mv	a1,s5
    1fd6:	00004517          	auipc	a0,0x4
    1fda:	eb250513          	addi	a0,a0,-334 # 5e88 <malloc+0x1ee>
    1fde:	00004097          	auipc	ra,0x4
    1fe2:	c04080e7          	jalr	-1020(ra) # 5be2 <printf>
            exit(1);
    1fe6:	4505                	li	a0,1
    1fe8:	00004097          	auipc	ra,0x4
    1fec:	870080e7          	jalr	-1936(ra) # 5858 <exit>
      exit(st);
    1ff0:	00004097          	auipc	ra,0x4
    1ff4:	868080e7          	jalr	-1944(ra) # 5858 <exit>

0000000000001ff8 <forktest>:
{
    1ff8:	7179                	addi	sp,sp,-48
    1ffa:	f406                	sd	ra,40(sp)
    1ffc:	f022                	sd	s0,32(sp)
    1ffe:	ec26                	sd	s1,24(sp)
    2000:	e84a                	sd	s2,16(sp)
    2002:	e44e                	sd	s3,8(sp)
    2004:	1800                	addi	s0,sp,48
    2006:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    2008:	4481                	li	s1,0
    200a:	3e800913          	li	s2,1000
    pid = fork();
    200e:	00004097          	auipc	ra,0x4
    2012:	842080e7          	jalr	-1982(ra) # 5850 <fork>
    if(pid < 0)
    2016:	02054863          	bltz	a0,2046 <forktest+0x4e>
    if(pid == 0)
    201a:	c115                	beqz	a0,203e <forktest+0x46>
  for(n=0; n<N; n++){
    201c:	2485                	addiw	s1,s1,1
    201e:	ff2498e3          	bne	s1,s2,200e <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2022:	85ce                	mv	a1,s3
    2024:	00005517          	auipc	a0,0x5
    2028:	87c50513          	addi	a0,a0,-1924 # 68a0 <malloc+0xc06>
    202c:	00004097          	auipc	ra,0x4
    2030:	bb6080e7          	jalr	-1098(ra) # 5be2 <printf>
    exit(1);
    2034:	4505                	li	a0,1
    2036:	00004097          	auipc	ra,0x4
    203a:	822080e7          	jalr	-2014(ra) # 5858 <exit>
      exit(0);
    203e:	00004097          	auipc	ra,0x4
    2042:	81a080e7          	jalr	-2022(ra) # 5858 <exit>
  if (n == 0) {
    2046:	cc9d                	beqz	s1,2084 <forktest+0x8c>
  if(n == N){
    2048:	3e800793          	li	a5,1000
    204c:	fcf48be3          	beq	s1,a5,2022 <forktest+0x2a>
  for(; n > 0; n--){
    2050:	00905b63          	blez	s1,2066 <forktest+0x6e>
    if(wait(0) < 0){
    2054:	4501                	li	a0,0
    2056:	00004097          	auipc	ra,0x4
    205a:	80a080e7          	jalr	-2038(ra) # 5860 <wait>
    205e:	04054163          	bltz	a0,20a0 <forktest+0xa8>
  for(; n > 0; n--){
    2062:	34fd                	addiw	s1,s1,-1
    2064:	f8e5                	bnez	s1,2054 <forktest+0x5c>
  if(wait(0) != -1){
    2066:	4501                	li	a0,0
    2068:	00003097          	auipc	ra,0x3
    206c:	7f8080e7          	jalr	2040(ra) # 5860 <wait>
    2070:	57fd                	li	a5,-1
    2072:	04f51563          	bne	a0,a5,20bc <forktest+0xc4>
}
    2076:	70a2                	ld	ra,40(sp)
    2078:	7402                	ld	s0,32(sp)
    207a:	64e2                	ld	s1,24(sp)
    207c:	6942                	ld	s2,16(sp)
    207e:	69a2                	ld	s3,8(sp)
    2080:	6145                	addi	sp,sp,48
    2082:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2084:	85ce                	mv	a1,s3
    2086:	00005517          	auipc	a0,0x5
    208a:	80250513          	addi	a0,a0,-2046 # 6888 <malloc+0xbee>
    208e:	00004097          	auipc	ra,0x4
    2092:	b54080e7          	jalr	-1196(ra) # 5be2 <printf>
    exit(1);
    2096:	4505                	li	a0,1
    2098:	00003097          	auipc	ra,0x3
    209c:	7c0080e7          	jalr	1984(ra) # 5858 <exit>
      printf("%s: wait stopped early\n", s);
    20a0:	85ce                	mv	a1,s3
    20a2:	00005517          	auipc	a0,0x5
    20a6:	82650513          	addi	a0,a0,-2010 # 68c8 <malloc+0xc2e>
    20aa:	00004097          	auipc	ra,0x4
    20ae:	b38080e7          	jalr	-1224(ra) # 5be2 <printf>
      exit(1);
    20b2:	4505                	li	a0,1
    20b4:	00003097          	auipc	ra,0x3
    20b8:	7a4080e7          	jalr	1956(ra) # 5858 <exit>
    printf("%s: wait got too many\n", s);
    20bc:	85ce                	mv	a1,s3
    20be:	00005517          	auipc	a0,0x5
    20c2:	82250513          	addi	a0,a0,-2014 # 68e0 <malloc+0xc46>
    20c6:	00004097          	auipc	ra,0x4
    20ca:	b1c080e7          	jalr	-1252(ra) # 5be2 <printf>
    exit(1);
    20ce:	4505                	li	a0,1
    20d0:	00003097          	auipc	ra,0x3
    20d4:	788080e7          	jalr	1928(ra) # 5858 <exit>

00000000000020d8 <kernmem>:
{
    20d8:	715d                	addi	sp,sp,-80
    20da:	e486                	sd	ra,72(sp)
    20dc:	e0a2                	sd	s0,64(sp)
    20de:	fc26                	sd	s1,56(sp)
    20e0:	f84a                	sd	s2,48(sp)
    20e2:	f44e                	sd	s3,40(sp)
    20e4:	f052                	sd	s4,32(sp)
    20e6:	ec56                	sd	s5,24(sp)
    20e8:	0880                	addi	s0,sp,80
    20ea:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20ec:	4485                	li	s1,1
    20ee:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f0:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f2:	69b1                	lui	s3,0xc
    20f4:	35098993          	addi	s3,s3,848 # c350 <buf+0x558>
    20f8:	1003d937          	lui	s2,0x1003d
    20fc:	090e                	slli	s2,s2,0x3
    20fe:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e678>
    pid = fork();
    2102:	00003097          	auipc	ra,0x3
    2106:	74e080e7          	jalr	1870(ra) # 5850 <fork>
    if(pid < 0){
    210a:	02054963          	bltz	a0,213c <kernmem+0x64>
    if(pid == 0){
    210e:	c529                	beqz	a0,2158 <kernmem+0x80>
    wait(&xstatus);
    2110:	fbc40513          	addi	a0,s0,-68
    2114:	00003097          	auipc	ra,0x3
    2118:	74c080e7          	jalr	1868(ra) # 5860 <wait>
    if(xstatus != -1)  // did kernel kill child?
    211c:	fbc42783          	lw	a5,-68(s0)
    2120:	05579d63          	bne	a5,s5,217a <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2124:	94ce                	add	s1,s1,s3
    2126:	fd249ee3          	bne	s1,s2,2102 <kernmem+0x2a>
}
    212a:	60a6                	ld	ra,72(sp)
    212c:	6406                	ld	s0,64(sp)
    212e:	74e2                	ld	s1,56(sp)
    2130:	7942                	ld	s2,48(sp)
    2132:	79a2                	ld	s3,40(sp)
    2134:	7a02                	ld	s4,32(sp)
    2136:	6ae2                	ld	s5,24(sp)
    2138:	6161                	addi	sp,sp,80
    213a:	8082                	ret
      printf("%s: fork failed\n", s);
    213c:	85d2                	mv	a1,s4
    213e:	00004517          	auipc	a0,0x4
    2142:	4d250513          	addi	a0,a0,1234 # 6610 <malloc+0x976>
    2146:	00004097          	auipc	ra,0x4
    214a:	a9c080e7          	jalr	-1380(ra) # 5be2 <printf>
      exit(1);
    214e:	4505                	li	a0,1
    2150:	00003097          	auipc	ra,0x3
    2154:	708080e7          	jalr	1800(ra) # 5858 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2158:	0004c683          	lbu	a3,0(s1)
    215c:	8626                	mv	a2,s1
    215e:	85d2                	mv	a1,s4
    2160:	00004517          	auipc	a0,0x4
    2164:	79850513          	addi	a0,a0,1944 # 68f8 <malloc+0xc5e>
    2168:	00004097          	auipc	ra,0x4
    216c:	a7a080e7          	jalr	-1414(ra) # 5be2 <printf>
      exit(1);
    2170:	4505                	li	a0,1
    2172:	00003097          	auipc	ra,0x3
    2176:	6e6080e7          	jalr	1766(ra) # 5858 <exit>
      exit(1);
    217a:	4505                	li	a0,1
    217c:	00003097          	auipc	ra,0x3
    2180:	6dc080e7          	jalr	1756(ra) # 5858 <exit>

0000000000002184 <MAXVAplus>:
{
    2184:	7179                	addi	sp,sp,-48
    2186:	f406                	sd	ra,40(sp)
    2188:	f022                	sd	s0,32(sp)
    218a:	ec26                	sd	s1,24(sp)
    218c:	e84a                	sd	s2,16(sp)
    218e:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2190:	4785                	li	a5,1
    2192:	179a                	slli	a5,a5,0x26
    2194:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2198:	fd843783          	ld	a5,-40(s0)
    219c:	cf85                	beqz	a5,21d4 <MAXVAplus+0x50>
    219e:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    21a0:	54fd                	li	s1,-1
    pid = fork();
    21a2:	00003097          	auipc	ra,0x3
    21a6:	6ae080e7          	jalr	1710(ra) # 5850 <fork>
    if(pid < 0){
    21aa:	02054b63          	bltz	a0,21e0 <MAXVAplus+0x5c>
    if(pid == 0){
    21ae:	c539                	beqz	a0,21fc <MAXVAplus+0x78>
    wait(&xstatus);
    21b0:	fd440513          	addi	a0,s0,-44
    21b4:	00003097          	auipc	ra,0x3
    21b8:	6ac080e7          	jalr	1708(ra) # 5860 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21bc:	fd442783          	lw	a5,-44(s0)
    21c0:	06979463          	bne	a5,s1,2228 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    21c4:	fd843783          	ld	a5,-40(s0)
    21c8:	0786                	slli	a5,a5,0x1
    21ca:	fcf43c23          	sd	a5,-40(s0)
    21ce:	fd843783          	ld	a5,-40(s0)
    21d2:	fbe1                	bnez	a5,21a2 <MAXVAplus+0x1e>
}
    21d4:	70a2                	ld	ra,40(sp)
    21d6:	7402                	ld	s0,32(sp)
    21d8:	64e2                	ld	s1,24(sp)
    21da:	6942                	ld	s2,16(sp)
    21dc:	6145                	addi	sp,sp,48
    21de:	8082                	ret
      printf("%s: fork failed\n", s);
    21e0:	85ca                	mv	a1,s2
    21e2:	00004517          	auipc	a0,0x4
    21e6:	42e50513          	addi	a0,a0,1070 # 6610 <malloc+0x976>
    21ea:	00004097          	auipc	ra,0x4
    21ee:	9f8080e7          	jalr	-1544(ra) # 5be2 <printf>
      exit(1);
    21f2:	4505                	li	a0,1
    21f4:	00003097          	auipc	ra,0x3
    21f8:	664080e7          	jalr	1636(ra) # 5858 <exit>
      *(char*)a = 99;
    21fc:	fd843783          	ld	a5,-40(s0)
    2200:	06300713          	li	a4,99
    2204:	00e78023          	sb	a4,0(a5) # 3000 <iputtest+0x8c>
      printf("%s: oops wrote %x\n", s, a);
    2208:	fd843603          	ld	a2,-40(s0)
    220c:	85ca                	mv	a1,s2
    220e:	00004517          	auipc	a0,0x4
    2212:	70a50513          	addi	a0,a0,1802 # 6918 <malloc+0xc7e>
    2216:	00004097          	auipc	ra,0x4
    221a:	9cc080e7          	jalr	-1588(ra) # 5be2 <printf>
      exit(1);
    221e:	4505                	li	a0,1
    2220:	00003097          	auipc	ra,0x3
    2224:	638080e7          	jalr	1592(ra) # 5858 <exit>
      exit(1);
    2228:	4505                	li	a0,1
    222a:	00003097          	auipc	ra,0x3
    222e:	62e080e7          	jalr	1582(ra) # 5858 <exit>

0000000000002232 <bigargtest>:
{
    2232:	7179                	addi	sp,sp,-48
    2234:	f406                	sd	ra,40(sp)
    2236:	f022                	sd	s0,32(sp)
    2238:	ec26                	sd	s1,24(sp)
    223a:	1800                	addi	s0,sp,48
    223c:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    223e:	00004517          	auipc	a0,0x4
    2242:	6f250513          	addi	a0,a0,1778 # 6930 <malloc+0xc96>
    2246:	00003097          	auipc	ra,0x3
    224a:	662080e7          	jalr	1634(ra) # 58a8 <unlink>
  pid = fork();
    224e:	00003097          	auipc	ra,0x3
    2252:	602080e7          	jalr	1538(ra) # 5850 <fork>
  if(pid == 0){
    2256:	c121                	beqz	a0,2296 <bigargtest+0x64>
  } else if(pid < 0){
    2258:	0a054063          	bltz	a0,22f8 <bigargtest+0xc6>
  wait(&xstatus);
    225c:	fdc40513          	addi	a0,s0,-36
    2260:	00003097          	auipc	ra,0x3
    2264:	600080e7          	jalr	1536(ra) # 5860 <wait>
  if(xstatus != 0)
    2268:	fdc42503          	lw	a0,-36(s0)
    226c:	e545                	bnez	a0,2314 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    226e:	4581                	li	a1,0
    2270:	00004517          	auipc	a0,0x4
    2274:	6c050513          	addi	a0,a0,1728 # 6930 <malloc+0xc96>
    2278:	00003097          	auipc	ra,0x3
    227c:	620080e7          	jalr	1568(ra) # 5898 <open>
  if(fd < 0){
    2280:	08054e63          	bltz	a0,231c <bigargtest+0xea>
  close(fd);
    2284:	00003097          	auipc	ra,0x3
    2288:	5fc080e7          	jalr	1532(ra) # 5880 <close>
}
    228c:	70a2                	ld	ra,40(sp)
    228e:	7402                	ld	s0,32(sp)
    2290:	64e2                	ld	s1,24(sp)
    2292:	6145                	addi	sp,sp,48
    2294:	8082                	ret
    2296:	00006797          	auipc	a5,0x6
    229a:	34a78793          	addi	a5,a5,842 # 85e0 <args.1>
    229e:	00006697          	auipc	a3,0x6
    22a2:	43a68693          	addi	a3,a3,1082 # 86d8 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    22a6:	00004717          	auipc	a4,0x4
    22aa:	69a70713          	addi	a4,a4,1690 # 6940 <malloc+0xca6>
    22ae:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    22b0:	07a1                	addi	a5,a5,8
    22b2:	fed79ee3          	bne	a5,a3,22ae <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    22b6:	00006597          	auipc	a1,0x6
    22ba:	32a58593          	addi	a1,a1,810 # 85e0 <args.1>
    22be:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    22c2:	00004517          	auipc	a0,0x4
    22c6:	af650513          	addi	a0,a0,-1290 # 5db8 <malloc+0x11e>
    22ca:	00003097          	auipc	ra,0x3
    22ce:	5c6080e7          	jalr	1478(ra) # 5890 <exec>
    fd = open("bigarg-ok", O_CREATE);
    22d2:	20000593          	li	a1,512
    22d6:	00004517          	auipc	a0,0x4
    22da:	65a50513          	addi	a0,a0,1626 # 6930 <malloc+0xc96>
    22de:	00003097          	auipc	ra,0x3
    22e2:	5ba080e7          	jalr	1466(ra) # 5898 <open>
    close(fd);
    22e6:	00003097          	auipc	ra,0x3
    22ea:	59a080e7          	jalr	1434(ra) # 5880 <close>
    exit(0);
    22ee:	4501                	li	a0,0
    22f0:	00003097          	auipc	ra,0x3
    22f4:	568080e7          	jalr	1384(ra) # 5858 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    22f8:	85a6                	mv	a1,s1
    22fa:	00004517          	auipc	a0,0x4
    22fe:	72650513          	addi	a0,a0,1830 # 6a20 <malloc+0xd86>
    2302:	00004097          	auipc	ra,0x4
    2306:	8e0080e7          	jalr	-1824(ra) # 5be2 <printf>
    exit(1);
    230a:	4505                	li	a0,1
    230c:	00003097          	auipc	ra,0x3
    2310:	54c080e7          	jalr	1356(ra) # 5858 <exit>
    exit(xstatus);
    2314:	00003097          	auipc	ra,0x3
    2318:	544080e7          	jalr	1348(ra) # 5858 <exit>
    printf("%s: bigarg test failed!\n", s);
    231c:	85a6                	mv	a1,s1
    231e:	00004517          	auipc	a0,0x4
    2322:	72250513          	addi	a0,a0,1826 # 6a40 <malloc+0xda6>
    2326:	00004097          	auipc	ra,0x4
    232a:	8bc080e7          	jalr	-1860(ra) # 5be2 <printf>
    exit(1);
    232e:	4505                	li	a0,1
    2330:	00003097          	auipc	ra,0x3
    2334:	528080e7          	jalr	1320(ra) # 5858 <exit>

0000000000002338 <stacktest>:
{
    2338:	7179                	addi	sp,sp,-48
    233a:	f406                	sd	ra,40(sp)
    233c:	f022                	sd	s0,32(sp)
    233e:	ec26                	sd	s1,24(sp)
    2340:	1800                	addi	s0,sp,48
    2342:	84aa                	mv	s1,a0
  pid = fork();
    2344:	00003097          	auipc	ra,0x3
    2348:	50c080e7          	jalr	1292(ra) # 5850 <fork>
  if(pid == 0) {
    234c:	c115                	beqz	a0,2370 <stacktest+0x38>
  } else if(pid < 0){
    234e:	04054463          	bltz	a0,2396 <stacktest+0x5e>
  wait(&xstatus);
    2352:	fdc40513          	addi	a0,s0,-36
    2356:	00003097          	auipc	ra,0x3
    235a:	50a080e7          	jalr	1290(ra) # 5860 <wait>
  if(xstatus == -1)  // kernel killed child?
    235e:	fdc42503          	lw	a0,-36(s0)
    2362:	57fd                	li	a5,-1
    2364:	04f50763          	beq	a0,a5,23b2 <stacktest+0x7a>
    exit(xstatus);
    2368:	00003097          	auipc	ra,0x3
    236c:	4f0080e7          	jalr	1264(ra) # 5858 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2370:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2372:	77fd                	lui	a5,0xfffff
    2374:	97ba                	add	a5,a5,a4
    2376:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff01f8>
    237a:	85a6                	mv	a1,s1
    237c:	00004517          	auipc	a0,0x4
    2380:	6e450513          	addi	a0,a0,1764 # 6a60 <malloc+0xdc6>
    2384:	00004097          	auipc	ra,0x4
    2388:	85e080e7          	jalr	-1954(ra) # 5be2 <printf>
    exit(1);
    238c:	4505                	li	a0,1
    238e:	00003097          	auipc	ra,0x3
    2392:	4ca080e7          	jalr	1226(ra) # 5858 <exit>
    printf("%s: fork failed\n", s);
    2396:	85a6                	mv	a1,s1
    2398:	00004517          	auipc	a0,0x4
    239c:	27850513          	addi	a0,a0,632 # 6610 <malloc+0x976>
    23a0:	00004097          	auipc	ra,0x4
    23a4:	842080e7          	jalr	-1982(ra) # 5be2 <printf>
    exit(1);
    23a8:	4505                	li	a0,1
    23aa:	00003097          	auipc	ra,0x3
    23ae:	4ae080e7          	jalr	1198(ra) # 5858 <exit>
    exit(0);
    23b2:	4501                	li	a0,0
    23b4:	00003097          	auipc	ra,0x3
    23b8:	4a4080e7          	jalr	1188(ra) # 5858 <exit>

00000000000023bc <copyinstr3>:
{
    23bc:	7179                	addi	sp,sp,-48
    23be:	f406                	sd	ra,40(sp)
    23c0:	f022                	sd	s0,32(sp)
    23c2:	ec26                	sd	s1,24(sp)
    23c4:	1800                	addi	s0,sp,48
  sbrk(8192);
    23c6:	6509                	lui	a0,0x2
    23c8:	00003097          	auipc	ra,0x3
    23cc:	518080e7          	jalr	1304(ra) # 58e0 <sbrk>
  uint64 top = (uint64) sbrk(0);
    23d0:	4501                	li	a0,0
    23d2:	00003097          	auipc	ra,0x3
    23d6:	50e080e7          	jalr	1294(ra) # 58e0 <sbrk>
  if((top % PGSIZE) != 0){
    23da:	03451793          	slli	a5,a0,0x34
    23de:	e3c9                	bnez	a5,2460 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    23e0:	4501                	li	a0,0
    23e2:	00003097          	auipc	ra,0x3
    23e6:	4fe080e7          	jalr	1278(ra) # 58e0 <sbrk>
  if(top % PGSIZE){
    23ea:	03451793          	slli	a5,a0,0x34
    23ee:	e3d9                	bnez	a5,2474 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    23f0:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x7>
  *b = 'x';
    23f4:	07800793          	li	a5,120
    23f8:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    23fc:	8526                	mv	a0,s1
    23fe:	00003097          	auipc	ra,0x3
    2402:	4aa080e7          	jalr	1194(ra) # 58a8 <unlink>
  if(ret != -1){
    2406:	57fd                	li	a5,-1
    2408:	08f51363          	bne	a0,a5,248e <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    240c:	20100593          	li	a1,513
    2410:	8526                	mv	a0,s1
    2412:	00003097          	auipc	ra,0x3
    2416:	486080e7          	jalr	1158(ra) # 5898 <open>
  if(fd != -1){
    241a:	57fd                	li	a5,-1
    241c:	08f51863          	bne	a0,a5,24ac <copyinstr3+0xf0>
  ret = link(b, b);
    2420:	85a6                	mv	a1,s1
    2422:	8526                	mv	a0,s1
    2424:	00003097          	auipc	ra,0x3
    2428:	494080e7          	jalr	1172(ra) # 58b8 <link>
  if(ret != -1){
    242c:	57fd                	li	a5,-1
    242e:	08f51e63          	bne	a0,a5,24ca <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2432:	00005797          	auipc	a5,0x5
    2436:	2d678793          	addi	a5,a5,726 # 7708 <malloc+0x1a6e>
    243a:	fcf43823          	sd	a5,-48(s0)
    243e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2442:	fd040593          	addi	a1,s0,-48
    2446:	8526                	mv	a0,s1
    2448:	00003097          	auipc	ra,0x3
    244c:	448080e7          	jalr	1096(ra) # 5890 <exec>
  if(ret != -1){
    2450:	57fd                	li	a5,-1
    2452:	08f51c63          	bne	a0,a5,24ea <copyinstr3+0x12e>
}
    2456:	70a2                	ld	ra,40(sp)
    2458:	7402                	ld	s0,32(sp)
    245a:	64e2                	ld	s1,24(sp)
    245c:	6145                	addi	sp,sp,48
    245e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2460:	0347d513          	srli	a0,a5,0x34
    2464:	6785                	lui	a5,0x1
    2466:	40a7853b          	subw	a0,a5,a0
    246a:	00003097          	auipc	ra,0x3
    246e:	476080e7          	jalr	1142(ra) # 58e0 <sbrk>
    2472:	b7bd                	j	23e0 <copyinstr3+0x24>
    printf("oops\n");
    2474:	00004517          	auipc	a0,0x4
    2478:	61450513          	addi	a0,a0,1556 # 6a88 <malloc+0xdee>
    247c:	00003097          	auipc	ra,0x3
    2480:	766080e7          	jalr	1894(ra) # 5be2 <printf>
    exit(1);
    2484:	4505                	li	a0,1
    2486:	00003097          	auipc	ra,0x3
    248a:	3d2080e7          	jalr	978(ra) # 5858 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    248e:	862a                	mv	a2,a0
    2490:	85a6                	mv	a1,s1
    2492:	00004517          	auipc	a0,0x4
    2496:	09e50513          	addi	a0,a0,158 # 6530 <malloc+0x896>
    249a:	00003097          	auipc	ra,0x3
    249e:	748080e7          	jalr	1864(ra) # 5be2 <printf>
    exit(1);
    24a2:	4505                	li	a0,1
    24a4:	00003097          	auipc	ra,0x3
    24a8:	3b4080e7          	jalr	948(ra) # 5858 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    24ac:	862a                	mv	a2,a0
    24ae:	85a6                	mv	a1,s1
    24b0:	00004517          	auipc	a0,0x4
    24b4:	0a050513          	addi	a0,a0,160 # 6550 <malloc+0x8b6>
    24b8:	00003097          	auipc	ra,0x3
    24bc:	72a080e7          	jalr	1834(ra) # 5be2 <printf>
    exit(1);
    24c0:	4505                	li	a0,1
    24c2:	00003097          	auipc	ra,0x3
    24c6:	396080e7          	jalr	918(ra) # 5858 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    24ca:	86aa                	mv	a3,a0
    24cc:	8626                	mv	a2,s1
    24ce:	85a6                	mv	a1,s1
    24d0:	00004517          	auipc	a0,0x4
    24d4:	0a050513          	addi	a0,a0,160 # 6570 <malloc+0x8d6>
    24d8:	00003097          	auipc	ra,0x3
    24dc:	70a080e7          	jalr	1802(ra) # 5be2 <printf>
    exit(1);
    24e0:	4505                	li	a0,1
    24e2:	00003097          	auipc	ra,0x3
    24e6:	376080e7          	jalr	886(ra) # 5858 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    24ea:	567d                	li	a2,-1
    24ec:	85a6                	mv	a1,s1
    24ee:	00004517          	auipc	a0,0x4
    24f2:	0aa50513          	addi	a0,a0,170 # 6598 <malloc+0x8fe>
    24f6:	00003097          	auipc	ra,0x3
    24fa:	6ec080e7          	jalr	1772(ra) # 5be2 <printf>
    exit(1);
    24fe:	4505                	li	a0,1
    2500:	00003097          	auipc	ra,0x3
    2504:	358080e7          	jalr	856(ra) # 5858 <exit>

0000000000002508 <rwsbrk>:
{
    2508:	1101                	addi	sp,sp,-32
    250a:	ec06                	sd	ra,24(sp)
    250c:	e822                	sd	s0,16(sp)
    250e:	e426                	sd	s1,8(sp)
    2510:	e04a                	sd	s2,0(sp)
    2512:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2514:	6509                	lui	a0,0x2
    2516:	00003097          	auipc	ra,0x3
    251a:	3ca080e7          	jalr	970(ra) # 58e0 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    251e:	57fd                	li	a5,-1
    2520:	06f50263          	beq	a0,a5,2584 <rwsbrk+0x7c>
    2524:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2526:	7579                	lui	a0,0xffffe
    2528:	00003097          	auipc	ra,0x3
    252c:	3b8080e7          	jalr	952(ra) # 58e0 <sbrk>
    2530:	57fd                	li	a5,-1
    2532:	06f50663          	beq	a0,a5,259e <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2536:	20100593          	li	a1,513
    253a:	00004517          	auipc	a0,0x4
    253e:	58e50513          	addi	a0,a0,1422 # 6ac8 <malloc+0xe2e>
    2542:	00003097          	auipc	ra,0x3
    2546:	356080e7          	jalr	854(ra) # 5898 <open>
    254a:	892a                	mv	s2,a0
  if(fd < 0){
    254c:	06054663          	bltz	a0,25b8 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    2550:	6785                	lui	a5,0x1
    2552:	94be                	add	s1,s1,a5
    2554:	40000613          	li	a2,1024
    2558:	85a6                	mv	a1,s1
    255a:	00003097          	auipc	ra,0x3
    255e:	31e080e7          	jalr	798(ra) # 5878 <write>
    2562:	862a                	mv	a2,a0
  if(n >= 0){
    2564:	06054763          	bltz	a0,25d2 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2568:	85a6                	mv	a1,s1
    256a:	00004517          	auipc	a0,0x4
    256e:	57e50513          	addi	a0,a0,1406 # 6ae8 <malloc+0xe4e>
    2572:	00003097          	auipc	ra,0x3
    2576:	670080e7          	jalr	1648(ra) # 5be2 <printf>
    exit(1);
    257a:	4505                	li	a0,1
    257c:	00003097          	auipc	ra,0x3
    2580:	2dc080e7          	jalr	732(ra) # 5858 <exit>
    printf("sbrk(rwsbrk) failed\n");
    2584:	00004517          	auipc	a0,0x4
    2588:	50c50513          	addi	a0,a0,1292 # 6a90 <malloc+0xdf6>
    258c:	00003097          	auipc	ra,0x3
    2590:	656080e7          	jalr	1622(ra) # 5be2 <printf>
    exit(1);
    2594:	4505                	li	a0,1
    2596:	00003097          	auipc	ra,0x3
    259a:	2c2080e7          	jalr	706(ra) # 5858 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    259e:	00004517          	auipc	a0,0x4
    25a2:	50a50513          	addi	a0,a0,1290 # 6aa8 <malloc+0xe0e>
    25a6:	00003097          	auipc	ra,0x3
    25aa:	63c080e7          	jalr	1596(ra) # 5be2 <printf>
    exit(1);
    25ae:	4505                	li	a0,1
    25b0:	00003097          	auipc	ra,0x3
    25b4:	2a8080e7          	jalr	680(ra) # 5858 <exit>
    printf("open(rwsbrk) failed\n");
    25b8:	00004517          	auipc	a0,0x4
    25bc:	51850513          	addi	a0,a0,1304 # 6ad0 <malloc+0xe36>
    25c0:	00003097          	auipc	ra,0x3
    25c4:	622080e7          	jalr	1570(ra) # 5be2 <printf>
    exit(1);
    25c8:	4505                	li	a0,1
    25ca:	00003097          	auipc	ra,0x3
    25ce:	28e080e7          	jalr	654(ra) # 5858 <exit>
  close(fd);
    25d2:	854a                	mv	a0,s2
    25d4:	00003097          	auipc	ra,0x3
    25d8:	2ac080e7          	jalr	684(ra) # 5880 <close>
  unlink("rwsbrk");
    25dc:	00004517          	auipc	a0,0x4
    25e0:	4ec50513          	addi	a0,a0,1260 # 6ac8 <malloc+0xe2e>
    25e4:	00003097          	auipc	ra,0x3
    25e8:	2c4080e7          	jalr	708(ra) # 58a8 <unlink>
  fd = open("README", O_RDONLY);
    25ec:	4581                	li	a1,0
    25ee:	00004517          	auipc	a0,0x4
    25f2:	97250513          	addi	a0,a0,-1678 # 5f60 <malloc+0x2c6>
    25f6:	00003097          	auipc	ra,0x3
    25fa:	2a2080e7          	jalr	674(ra) # 5898 <open>
    25fe:	892a                	mv	s2,a0
  if(fd < 0){
    2600:	02054963          	bltz	a0,2632 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2604:	4629                	li	a2,10
    2606:	85a6                	mv	a1,s1
    2608:	00003097          	auipc	ra,0x3
    260c:	268080e7          	jalr	616(ra) # 5870 <read>
    2610:	862a                	mv	a2,a0
  if(n >= 0){
    2612:	02054d63          	bltz	a0,264c <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2616:	85a6                	mv	a1,s1
    2618:	00004517          	auipc	a0,0x4
    261c:	50050513          	addi	a0,a0,1280 # 6b18 <malloc+0xe7e>
    2620:	00003097          	auipc	ra,0x3
    2624:	5c2080e7          	jalr	1474(ra) # 5be2 <printf>
    exit(1);
    2628:	4505                	li	a0,1
    262a:	00003097          	auipc	ra,0x3
    262e:	22e080e7          	jalr	558(ra) # 5858 <exit>
    printf("open(rwsbrk) failed\n");
    2632:	00004517          	auipc	a0,0x4
    2636:	49e50513          	addi	a0,a0,1182 # 6ad0 <malloc+0xe36>
    263a:	00003097          	auipc	ra,0x3
    263e:	5a8080e7          	jalr	1448(ra) # 5be2 <printf>
    exit(1);
    2642:	4505                	li	a0,1
    2644:	00003097          	auipc	ra,0x3
    2648:	214080e7          	jalr	532(ra) # 5858 <exit>
  close(fd);
    264c:	854a                	mv	a0,s2
    264e:	00003097          	auipc	ra,0x3
    2652:	232080e7          	jalr	562(ra) # 5880 <close>
  exit(0);
    2656:	4501                	li	a0,0
    2658:	00003097          	auipc	ra,0x3
    265c:	200080e7          	jalr	512(ra) # 5858 <exit>

0000000000002660 <sbrkbasic>:
{
    2660:	7139                	addi	sp,sp,-64
    2662:	fc06                	sd	ra,56(sp)
    2664:	f822                	sd	s0,48(sp)
    2666:	f426                	sd	s1,40(sp)
    2668:	f04a                	sd	s2,32(sp)
    266a:	ec4e                	sd	s3,24(sp)
    266c:	e852                	sd	s4,16(sp)
    266e:	0080                	addi	s0,sp,64
    2670:	8a2a                	mv	s4,a0
  pid = fork();
    2672:	00003097          	auipc	ra,0x3
    2676:	1de080e7          	jalr	478(ra) # 5850 <fork>
  if(pid < 0){
    267a:	02054c63          	bltz	a0,26b2 <sbrkbasic+0x52>
  if(pid == 0){
    267e:	ed21                	bnez	a0,26d6 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2680:	40000537          	lui	a0,0x40000
    2684:	00003097          	auipc	ra,0x3
    2688:	25c080e7          	jalr	604(ra) # 58e0 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    268c:	57fd                	li	a5,-1
    268e:	02f50f63          	beq	a0,a5,26cc <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2692:	400007b7          	lui	a5,0x40000
    2696:	97aa                	add	a5,a5,a0
      *b = 99;
    2698:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    269c:	6705                	lui	a4,0x1
      *b = 99;
    269e:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff11f8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    26a2:	953a                	add	a0,a0,a4
    26a4:	fef51de3          	bne	a0,a5,269e <sbrkbasic+0x3e>
    exit(1);
    26a8:	4505                	li	a0,1
    26aa:	00003097          	auipc	ra,0x3
    26ae:	1ae080e7          	jalr	430(ra) # 5858 <exit>
    printf("fork failed in sbrkbasic\n");
    26b2:	00004517          	auipc	a0,0x4
    26b6:	48e50513          	addi	a0,a0,1166 # 6b40 <malloc+0xea6>
    26ba:	00003097          	auipc	ra,0x3
    26be:	528080e7          	jalr	1320(ra) # 5be2 <printf>
    exit(1);
    26c2:	4505                	li	a0,1
    26c4:	00003097          	auipc	ra,0x3
    26c8:	194080e7          	jalr	404(ra) # 5858 <exit>
      exit(0);
    26cc:	4501                	li	a0,0
    26ce:	00003097          	auipc	ra,0x3
    26d2:	18a080e7          	jalr	394(ra) # 5858 <exit>
  wait(&xstatus);
    26d6:	fcc40513          	addi	a0,s0,-52
    26da:	00003097          	auipc	ra,0x3
    26de:	186080e7          	jalr	390(ra) # 5860 <wait>
  if(xstatus == 1){
    26e2:	fcc42703          	lw	a4,-52(s0)
    26e6:	4785                	li	a5,1
    26e8:	00f70d63          	beq	a4,a5,2702 <sbrkbasic+0xa2>
  a = sbrk(0);
    26ec:	4501                	li	a0,0
    26ee:	00003097          	auipc	ra,0x3
    26f2:	1f2080e7          	jalr	498(ra) # 58e0 <sbrk>
    26f6:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    26f8:	4901                	li	s2,0
    26fa:	6985                	lui	s3,0x1
    26fc:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d8>
    2700:	a005                	j	2720 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2702:	85d2                	mv	a1,s4
    2704:	00004517          	auipc	a0,0x4
    2708:	45c50513          	addi	a0,a0,1116 # 6b60 <malloc+0xec6>
    270c:	00003097          	auipc	ra,0x3
    2710:	4d6080e7          	jalr	1238(ra) # 5be2 <printf>
    exit(1);
    2714:	4505                	li	a0,1
    2716:	00003097          	auipc	ra,0x3
    271a:	142080e7          	jalr	322(ra) # 5858 <exit>
    a = b + 1;
    271e:	84be                	mv	s1,a5
    b = sbrk(1);
    2720:	4505                	li	a0,1
    2722:	00003097          	auipc	ra,0x3
    2726:	1be080e7          	jalr	446(ra) # 58e0 <sbrk>
    if(b != a){
    272a:	04951c63          	bne	a0,s1,2782 <sbrkbasic+0x122>
    *b = 1;
    272e:	4785                	li	a5,1
    2730:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2734:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2738:	2905                	addiw	s2,s2,1
    273a:	ff3912e3          	bne	s2,s3,271e <sbrkbasic+0xbe>
  pid = fork();
    273e:	00003097          	auipc	ra,0x3
    2742:	112080e7          	jalr	274(ra) # 5850 <fork>
    2746:	892a                	mv	s2,a0
  if(pid < 0){
    2748:	04054e63          	bltz	a0,27a4 <sbrkbasic+0x144>
  c = sbrk(1);
    274c:	4505                	li	a0,1
    274e:	00003097          	auipc	ra,0x3
    2752:	192080e7          	jalr	402(ra) # 58e0 <sbrk>
  c = sbrk(1);
    2756:	4505                	li	a0,1
    2758:	00003097          	auipc	ra,0x3
    275c:	188080e7          	jalr	392(ra) # 58e0 <sbrk>
  if(c != a + 1){
    2760:	0489                	addi	s1,s1,2
    2762:	04a48f63          	beq	s1,a0,27c0 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    2766:	85d2                	mv	a1,s4
    2768:	00004517          	auipc	a0,0x4
    276c:	45850513          	addi	a0,a0,1112 # 6bc0 <malloc+0xf26>
    2770:	00003097          	auipc	ra,0x3
    2774:	472080e7          	jalr	1138(ra) # 5be2 <printf>
    exit(1);
    2778:	4505                	li	a0,1
    277a:	00003097          	auipc	ra,0x3
    277e:	0de080e7          	jalr	222(ra) # 5858 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2782:	872a                	mv	a4,a0
    2784:	86a6                	mv	a3,s1
    2786:	864a                	mv	a2,s2
    2788:	85d2                	mv	a1,s4
    278a:	00004517          	auipc	a0,0x4
    278e:	3f650513          	addi	a0,a0,1014 # 6b80 <malloc+0xee6>
    2792:	00003097          	auipc	ra,0x3
    2796:	450080e7          	jalr	1104(ra) # 5be2 <printf>
      exit(1);
    279a:	4505                	li	a0,1
    279c:	00003097          	auipc	ra,0x3
    27a0:	0bc080e7          	jalr	188(ra) # 5858 <exit>
    printf("%s: sbrk test fork failed\n", s);
    27a4:	85d2                	mv	a1,s4
    27a6:	00004517          	auipc	a0,0x4
    27aa:	3fa50513          	addi	a0,a0,1018 # 6ba0 <malloc+0xf06>
    27ae:	00003097          	auipc	ra,0x3
    27b2:	434080e7          	jalr	1076(ra) # 5be2 <printf>
    exit(1);
    27b6:	4505                	li	a0,1
    27b8:	00003097          	auipc	ra,0x3
    27bc:	0a0080e7          	jalr	160(ra) # 5858 <exit>
  if(pid == 0)
    27c0:	00091763          	bnez	s2,27ce <sbrkbasic+0x16e>
    exit(0);
    27c4:	4501                	li	a0,0
    27c6:	00003097          	auipc	ra,0x3
    27ca:	092080e7          	jalr	146(ra) # 5858 <exit>
  wait(&xstatus);
    27ce:	fcc40513          	addi	a0,s0,-52
    27d2:	00003097          	auipc	ra,0x3
    27d6:	08e080e7          	jalr	142(ra) # 5860 <wait>
  exit(xstatus);
    27da:	fcc42503          	lw	a0,-52(s0)
    27de:	00003097          	auipc	ra,0x3
    27e2:	07a080e7          	jalr	122(ra) # 5858 <exit>

00000000000027e6 <sbrkmuch>:
{
    27e6:	7179                	addi	sp,sp,-48
    27e8:	f406                	sd	ra,40(sp)
    27ea:	f022                	sd	s0,32(sp)
    27ec:	ec26                	sd	s1,24(sp)
    27ee:	e84a                	sd	s2,16(sp)
    27f0:	e44e                	sd	s3,8(sp)
    27f2:	e052                	sd	s4,0(sp)
    27f4:	1800                	addi	s0,sp,48
    27f6:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    27f8:	4501                	li	a0,0
    27fa:	00003097          	auipc	ra,0x3
    27fe:	0e6080e7          	jalr	230(ra) # 58e0 <sbrk>
    2802:	892a                	mv	s2,a0
  a = sbrk(0);
    2804:	4501                	li	a0,0
    2806:	00003097          	auipc	ra,0x3
    280a:	0da080e7          	jalr	218(ra) # 58e0 <sbrk>
    280e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2810:	06400537          	lui	a0,0x6400
    2814:	9d05                	subw	a0,a0,s1
    2816:	00003097          	auipc	ra,0x3
    281a:	0ca080e7          	jalr	202(ra) # 58e0 <sbrk>
  if (p != a) {
    281e:	0ca49863          	bne	s1,a0,28ee <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2822:	4501                	li	a0,0
    2824:	00003097          	auipc	ra,0x3
    2828:	0bc080e7          	jalr	188(ra) # 58e0 <sbrk>
    282c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    282e:	00a4f963          	bgeu	s1,a0,2840 <sbrkmuch+0x5a>
    *pp = 1;
    2832:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2834:	6705                	lui	a4,0x1
    *pp = 1;
    2836:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    283a:	94ba                	add	s1,s1,a4
    283c:	fef4ede3          	bltu	s1,a5,2836 <sbrkmuch+0x50>
  *lastaddr = 99;
    2840:	064007b7          	lui	a5,0x6400
    2844:	06300713          	li	a4,99
    2848:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f11f7>
  a = sbrk(0);
    284c:	4501                	li	a0,0
    284e:	00003097          	auipc	ra,0x3
    2852:	092080e7          	jalr	146(ra) # 58e0 <sbrk>
    2856:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2858:	757d                	lui	a0,0xfffff
    285a:	00003097          	auipc	ra,0x3
    285e:	086080e7          	jalr	134(ra) # 58e0 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2862:	57fd                	li	a5,-1
    2864:	0af50363          	beq	a0,a5,290a <sbrkmuch+0x124>
  c = sbrk(0);
    2868:	4501                	li	a0,0
    286a:	00003097          	auipc	ra,0x3
    286e:	076080e7          	jalr	118(ra) # 58e0 <sbrk>
  if(c != a - PGSIZE){
    2872:	77fd                	lui	a5,0xfffff
    2874:	97a6                	add	a5,a5,s1
    2876:	0af51863          	bne	a0,a5,2926 <sbrkmuch+0x140>
  a = sbrk(0);
    287a:	4501                	li	a0,0
    287c:	00003097          	auipc	ra,0x3
    2880:	064080e7          	jalr	100(ra) # 58e0 <sbrk>
    2884:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2886:	6505                	lui	a0,0x1
    2888:	00003097          	auipc	ra,0x3
    288c:	058080e7          	jalr	88(ra) # 58e0 <sbrk>
    2890:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2892:	0aa49a63          	bne	s1,a0,2946 <sbrkmuch+0x160>
    2896:	4501                	li	a0,0
    2898:	00003097          	auipc	ra,0x3
    289c:	048080e7          	jalr	72(ra) # 58e0 <sbrk>
    28a0:	6785                	lui	a5,0x1
    28a2:	97a6                	add	a5,a5,s1
    28a4:	0af51163          	bne	a0,a5,2946 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    28a8:	064007b7          	lui	a5,0x6400
    28ac:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f11f7>
    28b0:	06300793          	li	a5,99
    28b4:	0af70963          	beq	a4,a5,2966 <sbrkmuch+0x180>
  a = sbrk(0);
    28b8:	4501                	li	a0,0
    28ba:	00003097          	auipc	ra,0x3
    28be:	026080e7          	jalr	38(ra) # 58e0 <sbrk>
    28c2:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    28c4:	4501                	li	a0,0
    28c6:	00003097          	auipc	ra,0x3
    28ca:	01a080e7          	jalr	26(ra) # 58e0 <sbrk>
    28ce:	40a9053b          	subw	a0,s2,a0
    28d2:	00003097          	auipc	ra,0x3
    28d6:	00e080e7          	jalr	14(ra) # 58e0 <sbrk>
  if(c != a){
    28da:	0aa49463          	bne	s1,a0,2982 <sbrkmuch+0x19c>
}
    28de:	70a2                	ld	ra,40(sp)
    28e0:	7402                	ld	s0,32(sp)
    28e2:	64e2                	ld	s1,24(sp)
    28e4:	6942                	ld	s2,16(sp)
    28e6:	69a2                	ld	s3,8(sp)
    28e8:	6a02                	ld	s4,0(sp)
    28ea:	6145                	addi	sp,sp,48
    28ec:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    28ee:	85ce                	mv	a1,s3
    28f0:	00004517          	auipc	a0,0x4
    28f4:	2f050513          	addi	a0,a0,752 # 6be0 <malloc+0xf46>
    28f8:	00003097          	auipc	ra,0x3
    28fc:	2ea080e7          	jalr	746(ra) # 5be2 <printf>
    exit(1);
    2900:	4505                	li	a0,1
    2902:	00003097          	auipc	ra,0x3
    2906:	f56080e7          	jalr	-170(ra) # 5858 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    290a:	85ce                	mv	a1,s3
    290c:	00004517          	auipc	a0,0x4
    2910:	31c50513          	addi	a0,a0,796 # 6c28 <malloc+0xf8e>
    2914:	00003097          	auipc	ra,0x3
    2918:	2ce080e7          	jalr	718(ra) # 5be2 <printf>
    exit(1);
    291c:	4505                	li	a0,1
    291e:	00003097          	auipc	ra,0x3
    2922:	f3a080e7          	jalr	-198(ra) # 5858 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2926:	86aa                	mv	a3,a0
    2928:	8626                	mv	a2,s1
    292a:	85ce                	mv	a1,s3
    292c:	00004517          	auipc	a0,0x4
    2930:	31c50513          	addi	a0,a0,796 # 6c48 <malloc+0xfae>
    2934:	00003097          	auipc	ra,0x3
    2938:	2ae080e7          	jalr	686(ra) # 5be2 <printf>
    exit(1);
    293c:	4505                	li	a0,1
    293e:	00003097          	auipc	ra,0x3
    2942:	f1a080e7          	jalr	-230(ra) # 5858 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2946:	86d2                	mv	a3,s4
    2948:	8626                	mv	a2,s1
    294a:	85ce                	mv	a1,s3
    294c:	00004517          	auipc	a0,0x4
    2950:	33c50513          	addi	a0,a0,828 # 6c88 <malloc+0xfee>
    2954:	00003097          	auipc	ra,0x3
    2958:	28e080e7          	jalr	654(ra) # 5be2 <printf>
    exit(1);
    295c:	4505                	li	a0,1
    295e:	00003097          	auipc	ra,0x3
    2962:	efa080e7          	jalr	-262(ra) # 5858 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2966:	85ce                	mv	a1,s3
    2968:	00004517          	auipc	a0,0x4
    296c:	35050513          	addi	a0,a0,848 # 6cb8 <malloc+0x101e>
    2970:	00003097          	auipc	ra,0x3
    2974:	272080e7          	jalr	626(ra) # 5be2 <printf>
    exit(1);
    2978:	4505                	li	a0,1
    297a:	00003097          	auipc	ra,0x3
    297e:	ede080e7          	jalr	-290(ra) # 5858 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2982:	86aa                	mv	a3,a0
    2984:	8626                	mv	a2,s1
    2986:	85ce                	mv	a1,s3
    2988:	00004517          	auipc	a0,0x4
    298c:	36850513          	addi	a0,a0,872 # 6cf0 <malloc+0x1056>
    2990:	00003097          	auipc	ra,0x3
    2994:	252080e7          	jalr	594(ra) # 5be2 <printf>
    exit(1);
    2998:	4505                	li	a0,1
    299a:	00003097          	auipc	ra,0x3
    299e:	ebe080e7          	jalr	-322(ra) # 5858 <exit>

00000000000029a2 <sbrkarg>:
{
    29a2:	7179                	addi	sp,sp,-48
    29a4:	f406                	sd	ra,40(sp)
    29a6:	f022                	sd	s0,32(sp)
    29a8:	ec26                	sd	s1,24(sp)
    29aa:	e84a                	sd	s2,16(sp)
    29ac:	e44e                	sd	s3,8(sp)
    29ae:	1800                	addi	s0,sp,48
    29b0:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    29b2:	6505                	lui	a0,0x1
    29b4:	00003097          	auipc	ra,0x3
    29b8:	f2c080e7          	jalr	-212(ra) # 58e0 <sbrk>
    29bc:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    29be:	20100593          	li	a1,513
    29c2:	00004517          	auipc	a0,0x4
    29c6:	35650513          	addi	a0,a0,854 # 6d18 <malloc+0x107e>
    29ca:	00003097          	auipc	ra,0x3
    29ce:	ece080e7          	jalr	-306(ra) # 5898 <open>
    29d2:	84aa                	mv	s1,a0
  unlink("sbrk");
    29d4:	00004517          	auipc	a0,0x4
    29d8:	34450513          	addi	a0,a0,836 # 6d18 <malloc+0x107e>
    29dc:	00003097          	auipc	ra,0x3
    29e0:	ecc080e7          	jalr	-308(ra) # 58a8 <unlink>
  if(fd < 0)  {
    29e4:	0404c163          	bltz	s1,2a26 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    29e8:	6605                	lui	a2,0x1
    29ea:	85ca                	mv	a1,s2
    29ec:	8526                	mv	a0,s1
    29ee:	00003097          	auipc	ra,0x3
    29f2:	e8a080e7          	jalr	-374(ra) # 5878 <write>
    29f6:	04054663          	bltz	a0,2a42 <sbrkarg+0xa0>
  close(fd);
    29fa:	8526                	mv	a0,s1
    29fc:	00003097          	auipc	ra,0x3
    2a00:	e84080e7          	jalr	-380(ra) # 5880 <close>
  a = sbrk(PGSIZE);
    2a04:	6505                	lui	a0,0x1
    2a06:	00003097          	auipc	ra,0x3
    2a0a:	eda080e7          	jalr	-294(ra) # 58e0 <sbrk>
  if(pipe((int *) a) != 0){
    2a0e:	00003097          	auipc	ra,0x3
    2a12:	e5a080e7          	jalr	-422(ra) # 5868 <pipe>
    2a16:	e521                	bnez	a0,2a5e <sbrkarg+0xbc>
}
    2a18:	70a2                	ld	ra,40(sp)
    2a1a:	7402                	ld	s0,32(sp)
    2a1c:	64e2                	ld	s1,24(sp)
    2a1e:	6942                	ld	s2,16(sp)
    2a20:	69a2                	ld	s3,8(sp)
    2a22:	6145                	addi	sp,sp,48
    2a24:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2a26:	85ce                	mv	a1,s3
    2a28:	00004517          	auipc	a0,0x4
    2a2c:	2f850513          	addi	a0,a0,760 # 6d20 <malloc+0x1086>
    2a30:	00003097          	auipc	ra,0x3
    2a34:	1b2080e7          	jalr	434(ra) # 5be2 <printf>
    exit(1);
    2a38:	4505                	li	a0,1
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	e1e080e7          	jalr	-482(ra) # 5858 <exit>
    printf("%s: write sbrk failed\n", s);
    2a42:	85ce                	mv	a1,s3
    2a44:	00004517          	auipc	a0,0x4
    2a48:	2f450513          	addi	a0,a0,756 # 6d38 <malloc+0x109e>
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	196080e7          	jalr	406(ra) # 5be2 <printf>
    exit(1);
    2a54:	4505                	li	a0,1
    2a56:	00003097          	auipc	ra,0x3
    2a5a:	e02080e7          	jalr	-510(ra) # 5858 <exit>
    printf("%s: pipe() failed\n", s);
    2a5e:	85ce                	mv	a1,s3
    2a60:	00004517          	auipc	a0,0x4
    2a64:	cb850513          	addi	a0,a0,-840 # 6718 <malloc+0xa7e>
    2a68:	00003097          	auipc	ra,0x3
    2a6c:	17a080e7          	jalr	378(ra) # 5be2 <printf>
    exit(1);
    2a70:	4505                	li	a0,1
    2a72:	00003097          	auipc	ra,0x3
    2a76:	de6080e7          	jalr	-538(ra) # 5858 <exit>

0000000000002a7a <argptest>:
{
    2a7a:	1101                	addi	sp,sp,-32
    2a7c:	ec06                	sd	ra,24(sp)
    2a7e:	e822                	sd	s0,16(sp)
    2a80:	e426                	sd	s1,8(sp)
    2a82:	e04a                	sd	s2,0(sp)
    2a84:	1000                	addi	s0,sp,32
    2a86:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2a88:	4581                	li	a1,0
    2a8a:	00004517          	auipc	a0,0x4
    2a8e:	2c650513          	addi	a0,a0,710 # 6d50 <malloc+0x10b6>
    2a92:	00003097          	auipc	ra,0x3
    2a96:	e06080e7          	jalr	-506(ra) # 5898 <open>
  if (fd < 0) {
    2a9a:	02054b63          	bltz	a0,2ad0 <argptest+0x56>
    2a9e:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2aa0:	4501                	li	a0,0
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	e3e080e7          	jalr	-450(ra) # 58e0 <sbrk>
    2aaa:	567d                	li	a2,-1
    2aac:	fff50593          	addi	a1,a0,-1
    2ab0:	8526                	mv	a0,s1
    2ab2:	00003097          	auipc	ra,0x3
    2ab6:	dbe080e7          	jalr	-578(ra) # 5870 <read>
  close(fd);
    2aba:	8526                	mv	a0,s1
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	dc4080e7          	jalr	-572(ra) # 5880 <close>
}
    2ac4:	60e2                	ld	ra,24(sp)
    2ac6:	6442                	ld	s0,16(sp)
    2ac8:	64a2                	ld	s1,8(sp)
    2aca:	6902                	ld	s2,0(sp)
    2acc:	6105                	addi	sp,sp,32
    2ace:	8082                	ret
    printf("%s: open failed\n", s);
    2ad0:	85ca                	mv	a1,s2
    2ad2:	00004517          	auipc	a0,0x4
    2ad6:	b5650513          	addi	a0,a0,-1194 # 6628 <malloc+0x98e>
    2ada:	00003097          	auipc	ra,0x3
    2ade:	108080e7          	jalr	264(ra) # 5be2 <printf>
    exit(1);
    2ae2:	4505                	li	a0,1
    2ae4:	00003097          	auipc	ra,0x3
    2ae8:	d74080e7          	jalr	-652(ra) # 5858 <exit>

0000000000002aec <sbrkbugs>:
{
    2aec:	1141                	addi	sp,sp,-16
    2aee:	e406                	sd	ra,8(sp)
    2af0:	e022                	sd	s0,0(sp)
    2af2:	0800                	addi	s0,sp,16
  int pid = fork();
    2af4:	00003097          	auipc	ra,0x3
    2af8:	d5c080e7          	jalr	-676(ra) # 5850 <fork>
  if(pid < 0){
    2afc:	02054263          	bltz	a0,2b20 <sbrkbugs+0x34>
  if(pid == 0){
    2b00:	ed0d                	bnez	a0,2b3a <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2b02:	00003097          	auipc	ra,0x3
    2b06:	dde080e7          	jalr	-546(ra) # 58e0 <sbrk>
    sbrk(-sz);
    2b0a:	40a0053b          	negw	a0,a0
    2b0e:	00003097          	auipc	ra,0x3
    2b12:	dd2080e7          	jalr	-558(ra) # 58e0 <sbrk>
    exit(0);
    2b16:	4501                	li	a0,0
    2b18:	00003097          	auipc	ra,0x3
    2b1c:	d40080e7          	jalr	-704(ra) # 5858 <exit>
    printf("fork failed\n");
    2b20:	00004517          	auipc	a0,0x4
    2b24:	f1050513          	addi	a0,a0,-240 # 6a30 <malloc+0xd96>
    2b28:	00003097          	auipc	ra,0x3
    2b2c:	0ba080e7          	jalr	186(ra) # 5be2 <printf>
    exit(1);
    2b30:	4505                	li	a0,1
    2b32:	00003097          	auipc	ra,0x3
    2b36:	d26080e7          	jalr	-730(ra) # 5858 <exit>
  wait(0);
    2b3a:	4501                	li	a0,0
    2b3c:	00003097          	auipc	ra,0x3
    2b40:	d24080e7          	jalr	-732(ra) # 5860 <wait>
  pid = fork();
    2b44:	00003097          	auipc	ra,0x3
    2b48:	d0c080e7          	jalr	-756(ra) # 5850 <fork>
  if(pid < 0){
    2b4c:	02054563          	bltz	a0,2b76 <sbrkbugs+0x8a>
  if(pid == 0){
    2b50:	e121                	bnez	a0,2b90 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2b52:	00003097          	auipc	ra,0x3
    2b56:	d8e080e7          	jalr	-626(ra) # 58e0 <sbrk>
    sbrk(-(sz - 3500));
    2b5a:	6785                	lui	a5,0x1
    2b5c:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x98>
    2b60:	40a7853b          	subw	a0,a5,a0
    2b64:	00003097          	auipc	ra,0x3
    2b68:	d7c080e7          	jalr	-644(ra) # 58e0 <sbrk>
    exit(0);
    2b6c:	4501                	li	a0,0
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	cea080e7          	jalr	-790(ra) # 5858 <exit>
    printf("fork failed\n");
    2b76:	00004517          	auipc	a0,0x4
    2b7a:	eba50513          	addi	a0,a0,-326 # 6a30 <malloc+0xd96>
    2b7e:	00003097          	auipc	ra,0x3
    2b82:	064080e7          	jalr	100(ra) # 5be2 <printf>
    exit(1);
    2b86:	4505                	li	a0,1
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	cd0080e7          	jalr	-816(ra) # 5858 <exit>
  wait(0);
    2b90:	4501                	li	a0,0
    2b92:	00003097          	auipc	ra,0x3
    2b96:	cce080e7          	jalr	-818(ra) # 5860 <wait>
  pid = fork();
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	cb6080e7          	jalr	-842(ra) # 5850 <fork>
  if(pid < 0){
    2ba2:	02054a63          	bltz	a0,2bd6 <sbrkbugs+0xea>
  if(pid == 0){
    2ba6:	e529                	bnez	a0,2bf0 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2ba8:	00003097          	auipc	ra,0x3
    2bac:	d38080e7          	jalr	-712(ra) # 58e0 <sbrk>
    2bb0:	67ad                	lui	a5,0xb
    2bb2:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1118>
    2bb6:	40a7853b          	subw	a0,a5,a0
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	d26080e7          	jalr	-730(ra) # 58e0 <sbrk>
    sbrk(-10);
    2bc2:	5559                	li	a0,-10
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	d1c080e7          	jalr	-740(ra) # 58e0 <sbrk>
    exit(0);
    2bcc:	4501                	li	a0,0
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	c8a080e7          	jalr	-886(ra) # 5858 <exit>
    printf("fork failed\n");
    2bd6:	00004517          	auipc	a0,0x4
    2bda:	e5a50513          	addi	a0,a0,-422 # 6a30 <malloc+0xd96>
    2bde:	00003097          	auipc	ra,0x3
    2be2:	004080e7          	jalr	4(ra) # 5be2 <printf>
    exit(1);
    2be6:	4505                	li	a0,1
    2be8:	00003097          	auipc	ra,0x3
    2bec:	c70080e7          	jalr	-912(ra) # 5858 <exit>
  wait(0);
    2bf0:	4501                	li	a0,0
    2bf2:	00003097          	auipc	ra,0x3
    2bf6:	c6e080e7          	jalr	-914(ra) # 5860 <wait>
  exit(0);
    2bfa:	4501                	li	a0,0
    2bfc:	00003097          	auipc	ra,0x3
    2c00:	c5c080e7          	jalr	-932(ra) # 5858 <exit>

0000000000002c04 <sbrklast>:
{
    2c04:	7179                	addi	sp,sp,-48
    2c06:	f406                	sd	ra,40(sp)
    2c08:	f022                	sd	s0,32(sp)
    2c0a:	ec26                	sd	s1,24(sp)
    2c0c:	e84a                	sd	s2,16(sp)
    2c0e:	e44e                	sd	s3,8(sp)
    2c10:	e052                	sd	s4,0(sp)
    2c12:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2c14:	4501                	li	a0,0
    2c16:	00003097          	auipc	ra,0x3
    2c1a:	cca080e7          	jalr	-822(ra) # 58e0 <sbrk>
  if((top % 4096) != 0)
    2c1e:	03451793          	slli	a5,a0,0x34
    2c22:	ebd9                	bnez	a5,2cb8 <sbrklast+0xb4>
  sbrk(4096);
    2c24:	6505                	lui	a0,0x1
    2c26:	00003097          	auipc	ra,0x3
    2c2a:	cba080e7          	jalr	-838(ra) # 58e0 <sbrk>
  sbrk(10);
    2c2e:	4529                	li	a0,10
    2c30:	00003097          	auipc	ra,0x3
    2c34:	cb0080e7          	jalr	-848(ra) # 58e0 <sbrk>
  sbrk(-20);
    2c38:	5531                	li	a0,-20
    2c3a:	00003097          	auipc	ra,0x3
    2c3e:	ca6080e7          	jalr	-858(ra) # 58e0 <sbrk>
  top = (uint64) sbrk(0);
    2c42:	4501                	li	a0,0
    2c44:	00003097          	auipc	ra,0x3
    2c48:	c9c080e7          	jalr	-868(ra) # 58e0 <sbrk>
    2c4c:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2c4e:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x60>
  p[0] = 'x';
    2c52:	07800a13          	li	s4,120
    2c56:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2c5a:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2c5e:	20200593          	li	a1,514
    2c62:	854a                	mv	a0,s2
    2c64:	00003097          	auipc	ra,0x3
    2c68:	c34080e7          	jalr	-972(ra) # 5898 <open>
    2c6c:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2c6e:	4605                	li	a2,1
    2c70:	85ca                	mv	a1,s2
    2c72:	00003097          	auipc	ra,0x3
    2c76:	c06080e7          	jalr	-1018(ra) # 5878 <write>
  close(fd);
    2c7a:	854e                	mv	a0,s3
    2c7c:	00003097          	auipc	ra,0x3
    2c80:	c04080e7          	jalr	-1020(ra) # 5880 <close>
  fd = open(p, O_RDWR);
    2c84:	4589                	li	a1,2
    2c86:	854a                	mv	a0,s2
    2c88:	00003097          	auipc	ra,0x3
    2c8c:	c10080e7          	jalr	-1008(ra) # 5898 <open>
  p[0] = '\0';
    2c90:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2c94:	4605                	li	a2,1
    2c96:	85ca                	mv	a1,s2
    2c98:	00003097          	auipc	ra,0x3
    2c9c:	bd8080e7          	jalr	-1064(ra) # 5870 <read>
  if(p[0] != 'x')
    2ca0:	fc04c783          	lbu	a5,-64(s1)
    2ca4:	03479463          	bne	a5,s4,2ccc <sbrklast+0xc8>
}
    2ca8:	70a2                	ld	ra,40(sp)
    2caa:	7402                	ld	s0,32(sp)
    2cac:	64e2                	ld	s1,24(sp)
    2cae:	6942                	ld	s2,16(sp)
    2cb0:	69a2                	ld	s3,8(sp)
    2cb2:	6a02                	ld	s4,0(sp)
    2cb4:	6145                	addi	sp,sp,48
    2cb6:	8082                	ret
    sbrk(4096 - (top % 4096));
    2cb8:	0347d513          	srli	a0,a5,0x34
    2cbc:	6785                	lui	a5,0x1
    2cbe:	40a7853b          	subw	a0,a5,a0
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	c1e080e7          	jalr	-994(ra) # 58e0 <sbrk>
    2cca:	bfa9                	j	2c24 <sbrklast+0x20>
    exit(1);
    2ccc:	4505                	li	a0,1
    2cce:	00003097          	auipc	ra,0x3
    2cd2:	b8a080e7          	jalr	-1142(ra) # 5858 <exit>

0000000000002cd6 <sbrk8000>:
{
    2cd6:	1141                	addi	sp,sp,-16
    2cd8:	e406                	sd	ra,8(sp)
    2cda:	e022                	sd	s0,0(sp)
    2cdc:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2cde:	80000537          	lui	a0,0x80000
    2ce2:	0511                	addi	a0,a0,4 # ffffffff80000004 <__BSS_END__+0xffffffff7fff11fc>
    2ce4:	00003097          	auipc	ra,0x3
    2ce8:	bfc080e7          	jalr	-1028(ra) # 58e0 <sbrk>
  volatile char *top = sbrk(0);
    2cec:	4501                	li	a0,0
    2cee:	00003097          	auipc	ra,0x3
    2cf2:	bf2080e7          	jalr	-1038(ra) # 58e0 <sbrk>
  *(top-1) = *(top-1) + 1;
    2cf6:	fff54783          	lbu	a5,-1(a0)
    2cfa:	2785                	addiw	a5,a5,1 # 1001 <bigdir+0xa1>
    2cfc:	0ff7f793          	zext.b	a5,a5
    2d00:	fef50fa3          	sb	a5,-1(a0)
}
    2d04:	60a2                	ld	ra,8(sp)
    2d06:	6402                	ld	s0,0(sp)
    2d08:	0141                	addi	sp,sp,16
    2d0a:	8082                	ret

0000000000002d0c <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2d0c:	715d                	addi	sp,sp,-80
    2d0e:	e486                	sd	ra,72(sp)
    2d10:	e0a2                	sd	s0,64(sp)
    2d12:	fc26                	sd	s1,56(sp)
    2d14:	f84a                	sd	s2,48(sp)
    2d16:	f44e                	sd	s3,40(sp)
    2d18:	f052                	sd	s4,32(sp)
    2d1a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2d1c:	4901                	li	s2,0
    2d1e:	49bd                	li	s3,15
    int pid = fork();
    2d20:	00003097          	auipc	ra,0x3
    2d24:	b30080e7          	jalr	-1232(ra) # 5850 <fork>
    2d28:	84aa                	mv	s1,a0
    if(pid < 0){
    2d2a:	02054063          	bltz	a0,2d4a <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2d2e:	c91d                	beqz	a0,2d64 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2d30:	4501                	li	a0,0
    2d32:	00003097          	auipc	ra,0x3
    2d36:	b2e080e7          	jalr	-1234(ra) # 5860 <wait>
  for(int avail = 0; avail < 15; avail++){
    2d3a:	2905                	addiw	s2,s2,1
    2d3c:	ff3912e3          	bne	s2,s3,2d20 <execout+0x14>
    }
  }

  exit(0);
    2d40:	4501                	li	a0,0
    2d42:	00003097          	auipc	ra,0x3
    2d46:	b16080e7          	jalr	-1258(ra) # 5858 <exit>
      printf("fork failed\n");
    2d4a:	00004517          	auipc	a0,0x4
    2d4e:	ce650513          	addi	a0,a0,-794 # 6a30 <malloc+0xd96>
    2d52:	00003097          	auipc	ra,0x3
    2d56:	e90080e7          	jalr	-368(ra) # 5be2 <printf>
      exit(1);
    2d5a:	4505                	li	a0,1
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	afc080e7          	jalr	-1284(ra) # 5858 <exit>
        if(a == 0xffffffffffffffffLL)
    2d64:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2d66:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2d68:	6505                	lui	a0,0x1
    2d6a:	00003097          	auipc	ra,0x3
    2d6e:	b76080e7          	jalr	-1162(ra) # 58e0 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2d72:	01350763          	beq	a0,s3,2d80 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2d76:	6785                	lui	a5,0x1
    2d78:	97aa                	add	a5,a5,a0
    2d7a:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x9f>
      while(1){
    2d7e:	b7ed                	j	2d68 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2d80:	01205a63          	blez	s2,2d94 <execout+0x88>
        sbrk(-4096);
    2d84:	757d                	lui	a0,0xfffff
    2d86:	00003097          	auipc	ra,0x3
    2d8a:	b5a080e7          	jalr	-1190(ra) # 58e0 <sbrk>
      for(int i = 0; i < avail; i++)
    2d8e:	2485                	addiw	s1,s1,1
    2d90:	ff249ae3          	bne	s1,s2,2d84 <execout+0x78>
      close(1);
    2d94:	4505                	li	a0,1
    2d96:	00003097          	auipc	ra,0x3
    2d9a:	aea080e7          	jalr	-1302(ra) # 5880 <close>
      char *args[] = { "echo", "x", 0 };
    2d9e:	00003517          	auipc	a0,0x3
    2da2:	01a50513          	addi	a0,a0,26 # 5db8 <malloc+0x11e>
    2da6:	faa43c23          	sd	a0,-72(s0)
    2daa:	00003797          	auipc	a5,0x3
    2dae:	07e78793          	addi	a5,a5,126 # 5e28 <malloc+0x18e>
    2db2:	fcf43023          	sd	a5,-64(s0)
    2db6:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2dba:	fb840593          	addi	a1,s0,-72
    2dbe:	00003097          	auipc	ra,0x3
    2dc2:	ad2080e7          	jalr	-1326(ra) # 5890 <exec>
      exit(0);
    2dc6:	4501                	li	a0,0
    2dc8:	00003097          	auipc	ra,0x3
    2dcc:	a90080e7          	jalr	-1392(ra) # 5858 <exit>

0000000000002dd0 <fourteen>:
{
    2dd0:	1101                	addi	sp,sp,-32
    2dd2:	ec06                	sd	ra,24(sp)
    2dd4:	e822                	sd	s0,16(sp)
    2dd6:	e426                	sd	s1,8(sp)
    2dd8:	1000                	addi	s0,sp,32
    2dda:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2ddc:	00004517          	auipc	a0,0x4
    2de0:	14c50513          	addi	a0,a0,332 # 6f28 <malloc+0x128e>
    2de4:	00003097          	auipc	ra,0x3
    2de8:	adc080e7          	jalr	-1316(ra) # 58c0 <mkdir>
    2dec:	e165                	bnez	a0,2ecc <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2dee:	00004517          	auipc	a0,0x4
    2df2:	f9250513          	addi	a0,a0,-110 # 6d80 <malloc+0x10e6>
    2df6:	00003097          	auipc	ra,0x3
    2dfa:	aca080e7          	jalr	-1334(ra) # 58c0 <mkdir>
    2dfe:	e56d                	bnez	a0,2ee8 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2e00:	20000593          	li	a1,512
    2e04:	00004517          	auipc	a0,0x4
    2e08:	fd450513          	addi	a0,a0,-44 # 6dd8 <malloc+0x113e>
    2e0c:	00003097          	auipc	ra,0x3
    2e10:	a8c080e7          	jalr	-1396(ra) # 5898 <open>
  if(fd < 0){
    2e14:	0e054863          	bltz	a0,2f04 <fourteen+0x134>
  close(fd);
    2e18:	00003097          	auipc	ra,0x3
    2e1c:	a68080e7          	jalr	-1432(ra) # 5880 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2e20:	4581                	li	a1,0
    2e22:	00004517          	auipc	a0,0x4
    2e26:	02e50513          	addi	a0,a0,46 # 6e50 <malloc+0x11b6>
    2e2a:	00003097          	auipc	ra,0x3
    2e2e:	a6e080e7          	jalr	-1426(ra) # 5898 <open>
  if(fd < 0){
    2e32:	0e054763          	bltz	a0,2f20 <fourteen+0x150>
  close(fd);
    2e36:	00003097          	auipc	ra,0x3
    2e3a:	a4a080e7          	jalr	-1462(ra) # 5880 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2e3e:	00004517          	auipc	a0,0x4
    2e42:	08250513          	addi	a0,a0,130 # 6ec0 <malloc+0x1226>
    2e46:	00003097          	auipc	ra,0x3
    2e4a:	a7a080e7          	jalr	-1414(ra) # 58c0 <mkdir>
    2e4e:	c57d                	beqz	a0,2f3c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2e50:	00004517          	auipc	a0,0x4
    2e54:	0c850513          	addi	a0,a0,200 # 6f18 <malloc+0x127e>
    2e58:	00003097          	auipc	ra,0x3
    2e5c:	a68080e7          	jalr	-1432(ra) # 58c0 <mkdir>
    2e60:	cd65                	beqz	a0,2f58 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2e62:	00004517          	auipc	a0,0x4
    2e66:	0b650513          	addi	a0,a0,182 # 6f18 <malloc+0x127e>
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	a3e080e7          	jalr	-1474(ra) # 58a8 <unlink>
  unlink("12345678901234/12345678901234");
    2e72:	00004517          	auipc	a0,0x4
    2e76:	04e50513          	addi	a0,a0,78 # 6ec0 <malloc+0x1226>
    2e7a:	00003097          	auipc	ra,0x3
    2e7e:	a2e080e7          	jalr	-1490(ra) # 58a8 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2e82:	00004517          	auipc	a0,0x4
    2e86:	fce50513          	addi	a0,a0,-50 # 6e50 <malloc+0x11b6>
    2e8a:	00003097          	auipc	ra,0x3
    2e8e:	a1e080e7          	jalr	-1506(ra) # 58a8 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2e92:	00004517          	auipc	a0,0x4
    2e96:	f4650513          	addi	a0,a0,-186 # 6dd8 <malloc+0x113e>
    2e9a:	00003097          	auipc	ra,0x3
    2e9e:	a0e080e7          	jalr	-1522(ra) # 58a8 <unlink>
  unlink("12345678901234/123456789012345");
    2ea2:	00004517          	auipc	a0,0x4
    2ea6:	ede50513          	addi	a0,a0,-290 # 6d80 <malloc+0x10e6>
    2eaa:	00003097          	auipc	ra,0x3
    2eae:	9fe080e7          	jalr	-1538(ra) # 58a8 <unlink>
  unlink("12345678901234");
    2eb2:	00004517          	auipc	a0,0x4
    2eb6:	07650513          	addi	a0,a0,118 # 6f28 <malloc+0x128e>
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	9ee080e7          	jalr	-1554(ra) # 58a8 <unlink>
}
    2ec2:	60e2                	ld	ra,24(sp)
    2ec4:	6442                	ld	s0,16(sp)
    2ec6:	64a2                	ld	s1,8(sp)
    2ec8:	6105                	addi	sp,sp,32
    2eca:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2ecc:	85a6                	mv	a1,s1
    2ece:	00004517          	auipc	a0,0x4
    2ed2:	e8a50513          	addi	a0,a0,-374 # 6d58 <malloc+0x10be>
    2ed6:	00003097          	auipc	ra,0x3
    2eda:	d0c080e7          	jalr	-756(ra) # 5be2 <printf>
    exit(1);
    2ede:	4505                	li	a0,1
    2ee0:	00003097          	auipc	ra,0x3
    2ee4:	978080e7          	jalr	-1672(ra) # 5858 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2ee8:	85a6                	mv	a1,s1
    2eea:	00004517          	auipc	a0,0x4
    2eee:	eb650513          	addi	a0,a0,-330 # 6da0 <malloc+0x1106>
    2ef2:	00003097          	auipc	ra,0x3
    2ef6:	cf0080e7          	jalr	-784(ra) # 5be2 <printf>
    exit(1);
    2efa:	4505                	li	a0,1
    2efc:	00003097          	auipc	ra,0x3
    2f00:	95c080e7          	jalr	-1700(ra) # 5858 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2f04:	85a6                	mv	a1,s1
    2f06:	00004517          	auipc	a0,0x4
    2f0a:	f0250513          	addi	a0,a0,-254 # 6e08 <malloc+0x116e>
    2f0e:	00003097          	auipc	ra,0x3
    2f12:	cd4080e7          	jalr	-812(ra) # 5be2 <printf>
    exit(1);
    2f16:	4505                	li	a0,1
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	940080e7          	jalr	-1728(ra) # 5858 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2f20:	85a6                	mv	a1,s1
    2f22:	00004517          	auipc	a0,0x4
    2f26:	f5e50513          	addi	a0,a0,-162 # 6e80 <malloc+0x11e6>
    2f2a:	00003097          	auipc	ra,0x3
    2f2e:	cb8080e7          	jalr	-840(ra) # 5be2 <printf>
    exit(1);
    2f32:	4505                	li	a0,1
    2f34:	00003097          	auipc	ra,0x3
    2f38:	924080e7          	jalr	-1756(ra) # 5858 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2f3c:	85a6                	mv	a1,s1
    2f3e:	00004517          	auipc	a0,0x4
    2f42:	fa250513          	addi	a0,a0,-94 # 6ee0 <malloc+0x1246>
    2f46:	00003097          	auipc	ra,0x3
    2f4a:	c9c080e7          	jalr	-868(ra) # 5be2 <printf>
    exit(1);
    2f4e:	4505                	li	a0,1
    2f50:	00003097          	auipc	ra,0x3
    2f54:	908080e7          	jalr	-1784(ra) # 5858 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2f58:	85a6                	mv	a1,s1
    2f5a:	00004517          	auipc	a0,0x4
    2f5e:	fde50513          	addi	a0,a0,-34 # 6f38 <malloc+0x129e>
    2f62:	00003097          	auipc	ra,0x3
    2f66:	c80080e7          	jalr	-896(ra) # 5be2 <printf>
    exit(1);
    2f6a:	4505                	li	a0,1
    2f6c:	00003097          	auipc	ra,0x3
    2f70:	8ec080e7          	jalr	-1812(ra) # 5858 <exit>

0000000000002f74 <iputtest>:
{
    2f74:	1101                	addi	sp,sp,-32
    2f76:	ec06                	sd	ra,24(sp)
    2f78:	e822                	sd	s0,16(sp)
    2f7a:	e426                	sd	s1,8(sp)
    2f7c:	1000                	addi	s0,sp,32
    2f7e:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2f80:	00004517          	auipc	a0,0x4
    2f84:	ff050513          	addi	a0,a0,-16 # 6f70 <malloc+0x12d6>
    2f88:	00003097          	auipc	ra,0x3
    2f8c:	938080e7          	jalr	-1736(ra) # 58c0 <mkdir>
    2f90:	04054563          	bltz	a0,2fda <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2f94:	00004517          	auipc	a0,0x4
    2f98:	fdc50513          	addi	a0,a0,-36 # 6f70 <malloc+0x12d6>
    2f9c:	00003097          	auipc	ra,0x3
    2fa0:	92c080e7          	jalr	-1748(ra) # 58c8 <chdir>
    2fa4:	04054963          	bltz	a0,2ff6 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2fa8:	00004517          	auipc	a0,0x4
    2fac:	00850513          	addi	a0,a0,8 # 6fb0 <malloc+0x1316>
    2fb0:	00003097          	auipc	ra,0x3
    2fb4:	8f8080e7          	jalr	-1800(ra) # 58a8 <unlink>
    2fb8:	04054d63          	bltz	a0,3012 <iputtest+0x9e>
  if(chdir("/") < 0){
    2fbc:	00004517          	auipc	a0,0x4
    2fc0:	02450513          	addi	a0,a0,36 # 6fe0 <malloc+0x1346>
    2fc4:	00003097          	auipc	ra,0x3
    2fc8:	904080e7          	jalr	-1788(ra) # 58c8 <chdir>
    2fcc:	06054163          	bltz	a0,302e <iputtest+0xba>
}
    2fd0:	60e2                	ld	ra,24(sp)
    2fd2:	6442                	ld	s0,16(sp)
    2fd4:	64a2                	ld	s1,8(sp)
    2fd6:	6105                	addi	sp,sp,32
    2fd8:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fda:	85a6                	mv	a1,s1
    2fdc:	00004517          	auipc	a0,0x4
    2fe0:	f9c50513          	addi	a0,a0,-100 # 6f78 <malloc+0x12de>
    2fe4:	00003097          	auipc	ra,0x3
    2fe8:	bfe080e7          	jalr	-1026(ra) # 5be2 <printf>
    exit(1);
    2fec:	4505                	li	a0,1
    2fee:	00003097          	auipc	ra,0x3
    2ff2:	86a080e7          	jalr	-1942(ra) # 5858 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2ff6:	85a6                	mv	a1,s1
    2ff8:	00004517          	auipc	a0,0x4
    2ffc:	f9850513          	addi	a0,a0,-104 # 6f90 <malloc+0x12f6>
    3000:	00003097          	auipc	ra,0x3
    3004:	be2080e7          	jalr	-1054(ra) # 5be2 <printf>
    exit(1);
    3008:	4505                	li	a0,1
    300a:	00003097          	auipc	ra,0x3
    300e:	84e080e7          	jalr	-1970(ra) # 5858 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3012:	85a6                	mv	a1,s1
    3014:	00004517          	auipc	a0,0x4
    3018:	fac50513          	addi	a0,a0,-84 # 6fc0 <malloc+0x1326>
    301c:	00003097          	auipc	ra,0x3
    3020:	bc6080e7          	jalr	-1082(ra) # 5be2 <printf>
    exit(1);
    3024:	4505                	li	a0,1
    3026:	00003097          	auipc	ra,0x3
    302a:	832080e7          	jalr	-1998(ra) # 5858 <exit>
    printf("%s: chdir / failed\n", s);
    302e:	85a6                	mv	a1,s1
    3030:	00004517          	auipc	a0,0x4
    3034:	fb850513          	addi	a0,a0,-72 # 6fe8 <malloc+0x134e>
    3038:	00003097          	auipc	ra,0x3
    303c:	baa080e7          	jalr	-1110(ra) # 5be2 <printf>
    exit(1);
    3040:	4505                	li	a0,1
    3042:	00003097          	auipc	ra,0x3
    3046:	816080e7          	jalr	-2026(ra) # 5858 <exit>

000000000000304a <exitiputtest>:
{
    304a:	7179                	addi	sp,sp,-48
    304c:	f406                	sd	ra,40(sp)
    304e:	f022                	sd	s0,32(sp)
    3050:	ec26                	sd	s1,24(sp)
    3052:	1800                	addi	s0,sp,48
    3054:	84aa                	mv	s1,a0
  pid = fork();
    3056:	00002097          	auipc	ra,0x2
    305a:	7fa080e7          	jalr	2042(ra) # 5850 <fork>
  if(pid < 0){
    305e:	04054663          	bltz	a0,30aa <exitiputtest+0x60>
  if(pid == 0){
    3062:	ed45                	bnez	a0,311a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3064:	00004517          	auipc	a0,0x4
    3068:	f0c50513          	addi	a0,a0,-244 # 6f70 <malloc+0x12d6>
    306c:	00003097          	auipc	ra,0x3
    3070:	854080e7          	jalr	-1964(ra) # 58c0 <mkdir>
    3074:	04054963          	bltz	a0,30c6 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    3078:	00004517          	auipc	a0,0x4
    307c:	ef850513          	addi	a0,a0,-264 # 6f70 <malloc+0x12d6>
    3080:	00003097          	auipc	ra,0x3
    3084:	848080e7          	jalr	-1976(ra) # 58c8 <chdir>
    3088:	04054d63          	bltz	a0,30e2 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    308c:	00004517          	auipc	a0,0x4
    3090:	f2450513          	addi	a0,a0,-220 # 6fb0 <malloc+0x1316>
    3094:	00003097          	auipc	ra,0x3
    3098:	814080e7          	jalr	-2028(ra) # 58a8 <unlink>
    309c:	06054163          	bltz	a0,30fe <exitiputtest+0xb4>
    exit(0);
    30a0:	4501                	li	a0,0
    30a2:	00002097          	auipc	ra,0x2
    30a6:	7b6080e7          	jalr	1974(ra) # 5858 <exit>
    printf("%s: fork failed\n", s);
    30aa:	85a6                	mv	a1,s1
    30ac:	00003517          	auipc	a0,0x3
    30b0:	56450513          	addi	a0,a0,1380 # 6610 <malloc+0x976>
    30b4:	00003097          	auipc	ra,0x3
    30b8:	b2e080e7          	jalr	-1234(ra) # 5be2 <printf>
    exit(1);
    30bc:	4505                	li	a0,1
    30be:	00002097          	auipc	ra,0x2
    30c2:	79a080e7          	jalr	1946(ra) # 5858 <exit>
      printf("%s: mkdir failed\n", s);
    30c6:	85a6                	mv	a1,s1
    30c8:	00004517          	auipc	a0,0x4
    30cc:	eb050513          	addi	a0,a0,-336 # 6f78 <malloc+0x12de>
    30d0:	00003097          	auipc	ra,0x3
    30d4:	b12080e7          	jalr	-1262(ra) # 5be2 <printf>
      exit(1);
    30d8:	4505                	li	a0,1
    30da:	00002097          	auipc	ra,0x2
    30de:	77e080e7          	jalr	1918(ra) # 5858 <exit>
      printf("%s: child chdir failed\n", s);
    30e2:	85a6                	mv	a1,s1
    30e4:	00004517          	auipc	a0,0x4
    30e8:	f1c50513          	addi	a0,a0,-228 # 7000 <malloc+0x1366>
    30ec:	00003097          	auipc	ra,0x3
    30f0:	af6080e7          	jalr	-1290(ra) # 5be2 <printf>
      exit(1);
    30f4:	4505                	li	a0,1
    30f6:	00002097          	auipc	ra,0x2
    30fa:	762080e7          	jalr	1890(ra) # 5858 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    30fe:	85a6                	mv	a1,s1
    3100:	00004517          	auipc	a0,0x4
    3104:	ec050513          	addi	a0,a0,-320 # 6fc0 <malloc+0x1326>
    3108:	00003097          	auipc	ra,0x3
    310c:	ada080e7          	jalr	-1318(ra) # 5be2 <printf>
      exit(1);
    3110:	4505                	li	a0,1
    3112:	00002097          	auipc	ra,0x2
    3116:	746080e7          	jalr	1862(ra) # 5858 <exit>
  wait(&xstatus);
    311a:	fdc40513          	addi	a0,s0,-36
    311e:	00002097          	auipc	ra,0x2
    3122:	742080e7          	jalr	1858(ra) # 5860 <wait>
  exit(xstatus);
    3126:	fdc42503          	lw	a0,-36(s0)
    312a:	00002097          	auipc	ra,0x2
    312e:	72e080e7          	jalr	1838(ra) # 5858 <exit>

0000000000003132 <dirtest>:
{
    3132:	1101                	addi	sp,sp,-32
    3134:	ec06                	sd	ra,24(sp)
    3136:	e822                	sd	s0,16(sp)
    3138:	e426                	sd	s1,8(sp)
    313a:	1000                	addi	s0,sp,32
    313c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    313e:	00004517          	auipc	a0,0x4
    3142:	eda50513          	addi	a0,a0,-294 # 7018 <malloc+0x137e>
    3146:	00002097          	auipc	ra,0x2
    314a:	77a080e7          	jalr	1914(ra) # 58c0 <mkdir>
    314e:	04054563          	bltz	a0,3198 <dirtest+0x66>
  if(chdir("dir0") < 0){
    3152:	00004517          	auipc	a0,0x4
    3156:	ec650513          	addi	a0,a0,-314 # 7018 <malloc+0x137e>
    315a:	00002097          	auipc	ra,0x2
    315e:	76e080e7          	jalr	1902(ra) # 58c8 <chdir>
    3162:	04054963          	bltz	a0,31b4 <dirtest+0x82>
  if(chdir("..") < 0){
    3166:	00004517          	auipc	a0,0x4
    316a:	ed250513          	addi	a0,a0,-302 # 7038 <malloc+0x139e>
    316e:	00002097          	auipc	ra,0x2
    3172:	75a080e7          	jalr	1882(ra) # 58c8 <chdir>
    3176:	04054d63          	bltz	a0,31d0 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    317a:	00004517          	auipc	a0,0x4
    317e:	e9e50513          	addi	a0,a0,-354 # 7018 <malloc+0x137e>
    3182:	00002097          	auipc	ra,0x2
    3186:	726080e7          	jalr	1830(ra) # 58a8 <unlink>
    318a:	06054163          	bltz	a0,31ec <dirtest+0xba>
}
    318e:	60e2                	ld	ra,24(sp)
    3190:	6442                	ld	s0,16(sp)
    3192:	64a2                	ld	s1,8(sp)
    3194:	6105                	addi	sp,sp,32
    3196:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3198:	85a6                	mv	a1,s1
    319a:	00004517          	auipc	a0,0x4
    319e:	dde50513          	addi	a0,a0,-546 # 6f78 <malloc+0x12de>
    31a2:	00003097          	auipc	ra,0x3
    31a6:	a40080e7          	jalr	-1472(ra) # 5be2 <printf>
    exit(1);
    31aa:	4505                	li	a0,1
    31ac:	00002097          	auipc	ra,0x2
    31b0:	6ac080e7          	jalr	1708(ra) # 5858 <exit>
    printf("%s: chdir dir0 failed\n", s);
    31b4:	85a6                	mv	a1,s1
    31b6:	00004517          	auipc	a0,0x4
    31ba:	e6a50513          	addi	a0,a0,-406 # 7020 <malloc+0x1386>
    31be:	00003097          	auipc	ra,0x3
    31c2:	a24080e7          	jalr	-1500(ra) # 5be2 <printf>
    exit(1);
    31c6:	4505                	li	a0,1
    31c8:	00002097          	auipc	ra,0x2
    31cc:	690080e7          	jalr	1680(ra) # 5858 <exit>
    printf("%s: chdir .. failed\n", s);
    31d0:	85a6                	mv	a1,s1
    31d2:	00004517          	auipc	a0,0x4
    31d6:	e6e50513          	addi	a0,a0,-402 # 7040 <malloc+0x13a6>
    31da:	00003097          	auipc	ra,0x3
    31de:	a08080e7          	jalr	-1528(ra) # 5be2 <printf>
    exit(1);
    31e2:	4505                	li	a0,1
    31e4:	00002097          	auipc	ra,0x2
    31e8:	674080e7          	jalr	1652(ra) # 5858 <exit>
    printf("%s: unlink dir0 failed\n", s);
    31ec:	85a6                	mv	a1,s1
    31ee:	00004517          	auipc	a0,0x4
    31f2:	e6a50513          	addi	a0,a0,-406 # 7058 <malloc+0x13be>
    31f6:	00003097          	auipc	ra,0x3
    31fa:	9ec080e7          	jalr	-1556(ra) # 5be2 <printf>
    exit(1);
    31fe:	4505                	li	a0,1
    3200:	00002097          	auipc	ra,0x2
    3204:	658080e7          	jalr	1624(ra) # 5858 <exit>

0000000000003208 <subdir>:
{
    3208:	1101                	addi	sp,sp,-32
    320a:	ec06                	sd	ra,24(sp)
    320c:	e822                	sd	s0,16(sp)
    320e:	e426                	sd	s1,8(sp)
    3210:	e04a                	sd	s2,0(sp)
    3212:	1000                	addi	s0,sp,32
    3214:	892a                	mv	s2,a0
  unlink("ff");
    3216:	00004517          	auipc	a0,0x4
    321a:	f8a50513          	addi	a0,a0,-118 # 71a0 <malloc+0x1506>
    321e:	00002097          	auipc	ra,0x2
    3222:	68a080e7          	jalr	1674(ra) # 58a8 <unlink>
  if(mkdir("dd") != 0){
    3226:	00004517          	auipc	a0,0x4
    322a:	e4a50513          	addi	a0,a0,-438 # 7070 <malloc+0x13d6>
    322e:	00002097          	auipc	ra,0x2
    3232:	692080e7          	jalr	1682(ra) # 58c0 <mkdir>
    3236:	38051663          	bnez	a0,35c2 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    323a:	20200593          	li	a1,514
    323e:	00004517          	auipc	a0,0x4
    3242:	e5250513          	addi	a0,a0,-430 # 7090 <malloc+0x13f6>
    3246:	00002097          	auipc	ra,0x2
    324a:	652080e7          	jalr	1618(ra) # 5898 <open>
    324e:	84aa                	mv	s1,a0
  if(fd < 0){
    3250:	38054763          	bltz	a0,35de <subdir+0x3d6>
  write(fd, "ff", 2);
    3254:	4609                	li	a2,2
    3256:	00004597          	auipc	a1,0x4
    325a:	f4a58593          	addi	a1,a1,-182 # 71a0 <malloc+0x1506>
    325e:	00002097          	auipc	ra,0x2
    3262:	61a080e7          	jalr	1562(ra) # 5878 <write>
  close(fd);
    3266:	8526                	mv	a0,s1
    3268:	00002097          	auipc	ra,0x2
    326c:	618080e7          	jalr	1560(ra) # 5880 <close>
  if(unlink("dd") >= 0){
    3270:	00004517          	auipc	a0,0x4
    3274:	e0050513          	addi	a0,a0,-512 # 7070 <malloc+0x13d6>
    3278:	00002097          	auipc	ra,0x2
    327c:	630080e7          	jalr	1584(ra) # 58a8 <unlink>
    3280:	36055d63          	bgez	a0,35fa <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3284:	00004517          	auipc	a0,0x4
    3288:	e6450513          	addi	a0,a0,-412 # 70e8 <malloc+0x144e>
    328c:	00002097          	auipc	ra,0x2
    3290:	634080e7          	jalr	1588(ra) # 58c0 <mkdir>
    3294:	38051163          	bnez	a0,3616 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3298:	20200593          	li	a1,514
    329c:	00004517          	auipc	a0,0x4
    32a0:	e7450513          	addi	a0,a0,-396 # 7110 <malloc+0x1476>
    32a4:	00002097          	auipc	ra,0x2
    32a8:	5f4080e7          	jalr	1524(ra) # 5898 <open>
    32ac:	84aa                	mv	s1,a0
  if(fd < 0){
    32ae:	38054263          	bltz	a0,3632 <subdir+0x42a>
  write(fd, "FF", 2);
    32b2:	4609                	li	a2,2
    32b4:	00004597          	auipc	a1,0x4
    32b8:	e8c58593          	addi	a1,a1,-372 # 7140 <malloc+0x14a6>
    32bc:	00002097          	auipc	ra,0x2
    32c0:	5bc080e7          	jalr	1468(ra) # 5878 <write>
  close(fd);
    32c4:	8526                	mv	a0,s1
    32c6:	00002097          	auipc	ra,0x2
    32ca:	5ba080e7          	jalr	1466(ra) # 5880 <close>
  fd = open("dd/dd/../ff", 0);
    32ce:	4581                	li	a1,0
    32d0:	00004517          	auipc	a0,0x4
    32d4:	e7850513          	addi	a0,a0,-392 # 7148 <malloc+0x14ae>
    32d8:	00002097          	auipc	ra,0x2
    32dc:	5c0080e7          	jalr	1472(ra) # 5898 <open>
    32e0:	84aa                	mv	s1,a0
  if(fd < 0){
    32e2:	36054663          	bltz	a0,364e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    32e6:	660d                	lui	a2,0x3
    32e8:	00009597          	auipc	a1,0x9
    32ec:	b1058593          	addi	a1,a1,-1264 # bdf8 <buf>
    32f0:	00002097          	auipc	ra,0x2
    32f4:	580080e7          	jalr	1408(ra) # 5870 <read>
  if(cc != 2 || buf[0] != 'f'){
    32f8:	4789                	li	a5,2
    32fa:	36f51863          	bne	a0,a5,366a <subdir+0x462>
    32fe:	00009717          	auipc	a4,0x9
    3302:	afa74703          	lbu	a4,-1286(a4) # bdf8 <buf>
    3306:	06600793          	li	a5,102
    330a:	36f71063          	bne	a4,a5,366a <subdir+0x462>
  close(fd);
    330e:	8526                	mv	a0,s1
    3310:	00002097          	auipc	ra,0x2
    3314:	570080e7          	jalr	1392(ra) # 5880 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3318:	00004597          	auipc	a1,0x4
    331c:	e8058593          	addi	a1,a1,-384 # 7198 <malloc+0x14fe>
    3320:	00004517          	auipc	a0,0x4
    3324:	df050513          	addi	a0,a0,-528 # 7110 <malloc+0x1476>
    3328:	00002097          	auipc	ra,0x2
    332c:	590080e7          	jalr	1424(ra) # 58b8 <link>
    3330:	34051b63          	bnez	a0,3686 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3334:	00004517          	auipc	a0,0x4
    3338:	ddc50513          	addi	a0,a0,-548 # 7110 <malloc+0x1476>
    333c:	00002097          	auipc	ra,0x2
    3340:	56c080e7          	jalr	1388(ra) # 58a8 <unlink>
    3344:	34051f63          	bnez	a0,36a2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3348:	4581                	li	a1,0
    334a:	00004517          	auipc	a0,0x4
    334e:	dc650513          	addi	a0,a0,-570 # 7110 <malloc+0x1476>
    3352:	00002097          	auipc	ra,0x2
    3356:	546080e7          	jalr	1350(ra) # 5898 <open>
    335a:	36055263          	bgez	a0,36be <subdir+0x4b6>
  if(chdir("dd") != 0){
    335e:	00004517          	auipc	a0,0x4
    3362:	d1250513          	addi	a0,a0,-750 # 7070 <malloc+0x13d6>
    3366:	00002097          	auipc	ra,0x2
    336a:	562080e7          	jalr	1378(ra) # 58c8 <chdir>
    336e:	36051663          	bnez	a0,36da <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3372:	00004517          	auipc	a0,0x4
    3376:	ebe50513          	addi	a0,a0,-322 # 7230 <malloc+0x1596>
    337a:	00002097          	auipc	ra,0x2
    337e:	54e080e7          	jalr	1358(ra) # 58c8 <chdir>
    3382:	36051a63          	bnez	a0,36f6 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3386:	00004517          	auipc	a0,0x4
    338a:	eda50513          	addi	a0,a0,-294 # 7260 <malloc+0x15c6>
    338e:	00002097          	auipc	ra,0x2
    3392:	53a080e7          	jalr	1338(ra) # 58c8 <chdir>
    3396:	36051e63          	bnez	a0,3712 <subdir+0x50a>
  if(chdir("./..") != 0){
    339a:	00004517          	auipc	a0,0x4
    339e:	ef650513          	addi	a0,a0,-266 # 7290 <malloc+0x15f6>
    33a2:	00002097          	auipc	ra,0x2
    33a6:	526080e7          	jalr	1318(ra) # 58c8 <chdir>
    33aa:	38051263          	bnez	a0,372e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    33ae:	4581                	li	a1,0
    33b0:	00004517          	auipc	a0,0x4
    33b4:	de850513          	addi	a0,a0,-536 # 7198 <malloc+0x14fe>
    33b8:	00002097          	auipc	ra,0x2
    33bc:	4e0080e7          	jalr	1248(ra) # 5898 <open>
    33c0:	84aa                	mv	s1,a0
  if(fd < 0){
    33c2:	38054463          	bltz	a0,374a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    33c6:	660d                	lui	a2,0x3
    33c8:	00009597          	auipc	a1,0x9
    33cc:	a3058593          	addi	a1,a1,-1488 # bdf8 <buf>
    33d0:	00002097          	auipc	ra,0x2
    33d4:	4a0080e7          	jalr	1184(ra) # 5870 <read>
    33d8:	4789                	li	a5,2
    33da:	38f51663          	bne	a0,a5,3766 <subdir+0x55e>
  close(fd);
    33de:	8526                	mv	a0,s1
    33e0:	00002097          	auipc	ra,0x2
    33e4:	4a0080e7          	jalr	1184(ra) # 5880 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    33e8:	4581                	li	a1,0
    33ea:	00004517          	auipc	a0,0x4
    33ee:	d2650513          	addi	a0,a0,-730 # 7110 <malloc+0x1476>
    33f2:	00002097          	auipc	ra,0x2
    33f6:	4a6080e7          	jalr	1190(ra) # 5898 <open>
    33fa:	38055463          	bgez	a0,3782 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    33fe:	20200593          	li	a1,514
    3402:	00004517          	auipc	a0,0x4
    3406:	f1e50513          	addi	a0,a0,-226 # 7320 <malloc+0x1686>
    340a:	00002097          	auipc	ra,0x2
    340e:	48e080e7          	jalr	1166(ra) # 5898 <open>
    3412:	38055663          	bgez	a0,379e <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3416:	20200593          	li	a1,514
    341a:	00004517          	auipc	a0,0x4
    341e:	f3650513          	addi	a0,a0,-202 # 7350 <malloc+0x16b6>
    3422:	00002097          	auipc	ra,0x2
    3426:	476080e7          	jalr	1142(ra) # 5898 <open>
    342a:	38055863          	bgez	a0,37ba <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    342e:	20000593          	li	a1,512
    3432:	00004517          	auipc	a0,0x4
    3436:	c3e50513          	addi	a0,a0,-962 # 7070 <malloc+0x13d6>
    343a:	00002097          	auipc	ra,0x2
    343e:	45e080e7          	jalr	1118(ra) # 5898 <open>
    3442:	38055a63          	bgez	a0,37d6 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3446:	4589                	li	a1,2
    3448:	00004517          	auipc	a0,0x4
    344c:	c2850513          	addi	a0,a0,-984 # 7070 <malloc+0x13d6>
    3450:	00002097          	auipc	ra,0x2
    3454:	448080e7          	jalr	1096(ra) # 5898 <open>
    3458:	38055d63          	bgez	a0,37f2 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    345c:	4585                	li	a1,1
    345e:	00004517          	auipc	a0,0x4
    3462:	c1250513          	addi	a0,a0,-1006 # 7070 <malloc+0x13d6>
    3466:	00002097          	auipc	ra,0x2
    346a:	432080e7          	jalr	1074(ra) # 5898 <open>
    346e:	3a055063          	bgez	a0,380e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3472:	00004597          	auipc	a1,0x4
    3476:	f6e58593          	addi	a1,a1,-146 # 73e0 <malloc+0x1746>
    347a:	00004517          	auipc	a0,0x4
    347e:	ea650513          	addi	a0,a0,-346 # 7320 <malloc+0x1686>
    3482:	00002097          	auipc	ra,0x2
    3486:	436080e7          	jalr	1078(ra) # 58b8 <link>
    348a:	3a050063          	beqz	a0,382a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    348e:	00004597          	auipc	a1,0x4
    3492:	f5258593          	addi	a1,a1,-174 # 73e0 <malloc+0x1746>
    3496:	00004517          	auipc	a0,0x4
    349a:	eba50513          	addi	a0,a0,-326 # 7350 <malloc+0x16b6>
    349e:	00002097          	auipc	ra,0x2
    34a2:	41a080e7          	jalr	1050(ra) # 58b8 <link>
    34a6:	3a050063          	beqz	a0,3846 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    34aa:	00004597          	auipc	a1,0x4
    34ae:	cee58593          	addi	a1,a1,-786 # 7198 <malloc+0x14fe>
    34b2:	00004517          	auipc	a0,0x4
    34b6:	bde50513          	addi	a0,a0,-1058 # 7090 <malloc+0x13f6>
    34ba:	00002097          	auipc	ra,0x2
    34be:	3fe080e7          	jalr	1022(ra) # 58b8 <link>
    34c2:	3a050063          	beqz	a0,3862 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    34c6:	00004517          	auipc	a0,0x4
    34ca:	e5a50513          	addi	a0,a0,-422 # 7320 <malloc+0x1686>
    34ce:	00002097          	auipc	ra,0x2
    34d2:	3f2080e7          	jalr	1010(ra) # 58c0 <mkdir>
    34d6:	3a050463          	beqz	a0,387e <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    34da:	00004517          	auipc	a0,0x4
    34de:	e7650513          	addi	a0,a0,-394 # 7350 <malloc+0x16b6>
    34e2:	00002097          	auipc	ra,0x2
    34e6:	3de080e7          	jalr	990(ra) # 58c0 <mkdir>
    34ea:	3a050863          	beqz	a0,389a <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    34ee:	00004517          	auipc	a0,0x4
    34f2:	caa50513          	addi	a0,a0,-854 # 7198 <malloc+0x14fe>
    34f6:	00002097          	auipc	ra,0x2
    34fa:	3ca080e7          	jalr	970(ra) # 58c0 <mkdir>
    34fe:	3a050c63          	beqz	a0,38b6 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3502:	00004517          	auipc	a0,0x4
    3506:	e4e50513          	addi	a0,a0,-434 # 7350 <malloc+0x16b6>
    350a:	00002097          	auipc	ra,0x2
    350e:	39e080e7          	jalr	926(ra) # 58a8 <unlink>
    3512:	3c050063          	beqz	a0,38d2 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3516:	00004517          	auipc	a0,0x4
    351a:	e0a50513          	addi	a0,a0,-502 # 7320 <malloc+0x1686>
    351e:	00002097          	auipc	ra,0x2
    3522:	38a080e7          	jalr	906(ra) # 58a8 <unlink>
    3526:	3c050463          	beqz	a0,38ee <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    352a:	00004517          	auipc	a0,0x4
    352e:	b6650513          	addi	a0,a0,-1178 # 7090 <malloc+0x13f6>
    3532:	00002097          	auipc	ra,0x2
    3536:	396080e7          	jalr	918(ra) # 58c8 <chdir>
    353a:	3c050863          	beqz	a0,390a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    353e:	00004517          	auipc	a0,0x4
    3542:	ff250513          	addi	a0,a0,-14 # 7530 <malloc+0x1896>
    3546:	00002097          	auipc	ra,0x2
    354a:	382080e7          	jalr	898(ra) # 58c8 <chdir>
    354e:	3c050c63          	beqz	a0,3926 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3552:	00004517          	auipc	a0,0x4
    3556:	c4650513          	addi	a0,a0,-954 # 7198 <malloc+0x14fe>
    355a:	00002097          	auipc	ra,0x2
    355e:	34e080e7          	jalr	846(ra) # 58a8 <unlink>
    3562:	3e051063          	bnez	a0,3942 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3566:	00004517          	auipc	a0,0x4
    356a:	b2a50513          	addi	a0,a0,-1238 # 7090 <malloc+0x13f6>
    356e:	00002097          	auipc	ra,0x2
    3572:	33a080e7          	jalr	826(ra) # 58a8 <unlink>
    3576:	3e051463          	bnez	a0,395e <subdir+0x756>
  if(unlink("dd") == 0){
    357a:	00004517          	auipc	a0,0x4
    357e:	af650513          	addi	a0,a0,-1290 # 7070 <malloc+0x13d6>
    3582:	00002097          	auipc	ra,0x2
    3586:	326080e7          	jalr	806(ra) # 58a8 <unlink>
    358a:	3e050863          	beqz	a0,397a <subdir+0x772>
  if(unlink("dd/dd") < 0){
    358e:	00004517          	auipc	a0,0x4
    3592:	01250513          	addi	a0,a0,18 # 75a0 <malloc+0x1906>
    3596:	00002097          	auipc	ra,0x2
    359a:	312080e7          	jalr	786(ra) # 58a8 <unlink>
    359e:	3e054c63          	bltz	a0,3996 <subdir+0x78e>
  if(unlink("dd") < 0){
    35a2:	00004517          	auipc	a0,0x4
    35a6:	ace50513          	addi	a0,a0,-1330 # 7070 <malloc+0x13d6>
    35aa:	00002097          	auipc	ra,0x2
    35ae:	2fe080e7          	jalr	766(ra) # 58a8 <unlink>
    35b2:	40054063          	bltz	a0,39b2 <subdir+0x7aa>
}
    35b6:	60e2                	ld	ra,24(sp)
    35b8:	6442                	ld	s0,16(sp)
    35ba:	64a2                	ld	s1,8(sp)
    35bc:	6902                	ld	s2,0(sp)
    35be:	6105                	addi	sp,sp,32
    35c0:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    35c2:	85ca                	mv	a1,s2
    35c4:	00004517          	auipc	a0,0x4
    35c8:	ab450513          	addi	a0,a0,-1356 # 7078 <malloc+0x13de>
    35cc:	00002097          	auipc	ra,0x2
    35d0:	616080e7          	jalr	1558(ra) # 5be2 <printf>
    exit(1);
    35d4:	4505                	li	a0,1
    35d6:	00002097          	auipc	ra,0x2
    35da:	282080e7          	jalr	642(ra) # 5858 <exit>
    printf("%s: create dd/ff failed\n", s);
    35de:	85ca                	mv	a1,s2
    35e0:	00004517          	auipc	a0,0x4
    35e4:	ab850513          	addi	a0,a0,-1352 # 7098 <malloc+0x13fe>
    35e8:	00002097          	auipc	ra,0x2
    35ec:	5fa080e7          	jalr	1530(ra) # 5be2 <printf>
    exit(1);
    35f0:	4505                	li	a0,1
    35f2:	00002097          	auipc	ra,0x2
    35f6:	266080e7          	jalr	614(ra) # 5858 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    35fa:	85ca                	mv	a1,s2
    35fc:	00004517          	auipc	a0,0x4
    3600:	abc50513          	addi	a0,a0,-1348 # 70b8 <malloc+0x141e>
    3604:	00002097          	auipc	ra,0x2
    3608:	5de080e7          	jalr	1502(ra) # 5be2 <printf>
    exit(1);
    360c:	4505                	li	a0,1
    360e:	00002097          	auipc	ra,0x2
    3612:	24a080e7          	jalr	586(ra) # 5858 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3616:	85ca                	mv	a1,s2
    3618:	00004517          	auipc	a0,0x4
    361c:	ad850513          	addi	a0,a0,-1320 # 70f0 <malloc+0x1456>
    3620:	00002097          	auipc	ra,0x2
    3624:	5c2080e7          	jalr	1474(ra) # 5be2 <printf>
    exit(1);
    3628:	4505                	li	a0,1
    362a:	00002097          	auipc	ra,0x2
    362e:	22e080e7          	jalr	558(ra) # 5858 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3632:	85ca                	mv	a1,s2
    3634:	00004517          	auipc	a0,0x4
    3638:	aec50513          	addi	a0,a0,-1300 # 7120 <malloc+0x1486>
    363c:	00002097          	auipc	ra,0x2
    3640:	5a6080e7          	jalr	1446(ra) # 5be2 <printf>
    exit(1);
    3644:	4505                	li	a0,1
    3646:	00002097          	auipc	ra,0x2
    364a:	212080e7          	jalr	530(ra) # 5858 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    364e:	85ca                	mv	a1,s2
    3650:	00004517          	auipc	a0,0x4
    3654:	b0850513          	addi	a0,a0,-1272 # 7158 <malloc+0x14be>
    3658:	00002097          	auipc	ra,0x2
    365c:	58a080e7          	jalr	1418(ra) # 5be2 <printf>
    exit(1);
    3660:	4505                	li	a0,1
    3662:	00002097          	auipc	ra,0x2
    3666:	1f6080e7          	jalr	502(ra) # 5858 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    366a:	85ca                	mv	a1,s2
    366c:	00004517          	auipc	a0,0x4
    3670:	b0c50513          	addi	a0,a0,-1268 # 7178 <malloc+0x14de>
    3674:	00002097          	auipc	ra,0x2
    3678:	56e080e7          	jalr	1390(ra) # 5be2 <printf>
    exit(1);
    367c:	4505                	li	a0,1
    367e:	00002097          	auipc	ra,0x2
    3682:	1da080e7          	jalr	474(ra) # 5858 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3686:	85ca                	mv	a1,s2
    3688:	00004517          	auipc	a0,0x4
    368c:	b2050513          	addi	a0,a0,-1248 # 71a8 <malloc+0x150e>
    3690:	00002097          	auipc	ra,0x2
    3694:	552080e7          	jalr	1362(ra) # 5be2 <printf>
    exit(1);
    3698:	4505                	li	a0,1
    369a:	00002097          	auipc	ra,0x2
    369e:	1be080e7          	jalr	446(ra) # 5858 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    36a2:	85ca                	mv	a1,s2
    36a4:	00004517          	auipc	a0,0x4
    36a8:	b2c50513          	addi	a0,a0,-1236 # 71d0 <malloc+0x1536>
    36ac:	00002097          	auipc	ra,0x2
    36b0:	536080e7          	jalr	1334(ra) # 5be2 <printf>
    exit(1);
    36b4:	4505                	li	a0,1
    36b6:	00002097          	auipc	ra,0x2
    36ba:	1a2080e7          	jalr	418(ra) # 5858 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    36be:	85ca                	mv	a1,s2
    36c0:	00004517          	auipc	a0,0x4
    36c4:	b3050513          	addi	a0,a0,-1232 # 71f0 <malloc+0x1556>
    36c8:	00002097          	auipc	ra,0x2
    36cc:	51a080e7          	jalr	1306(ra) # 5be2 <printf>
    exit(1);
    36d0:	4505                	li	a0,1
    36d2:	00002097          	auipc	ra,0x2
    36d6:	186080e7          	jalr	390(ra) # 5858 <exit>
    printf("%s: chdir dd failed\n", s);
    36da:	85ca                	mv	a1,s2
    36dc:	00004517          	auipc	a0,0x4
    36e0:	b3c50513          	addi	a0,a0,-1220 # 7218 <malloc+0x157e>
    36e4:	00002097          	auipc	ra,0x2
    36e8:	4fe080e7          	jalr	1278(ra) # 5be2 <printf>
    exit(1);
    36ec:	4505                	li	a0,1
    36ee:	00002097          	auipc	ra,0x2
    36f2:	16a080e7          	jalr	362(ra) # 5858 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    36f6:	85ca                	mv	a1,s2
    36f8:	00004517          	auipc	a0,0x4
    36fc:	b4850513          	addi	a0,a0,-1208 # 7240 <malloc+0x15a6>
    3700:	00002097          	auipc	ra,0x2
    3704:	4e2080e7          	jalr	1250(ra) # 5be2 <printf>
    exit(1);
    3708:	4505                	li	a0,1
    370a:	00002097          	auipc	ra,0x2
    370e:	14e080e7          	jalr	334(ra) # 5858 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3712:	85ca                	mv	a1,s2
    3714:	00004517          	auipc	a0,0x4
    3718:	b5c50513          	addi	a0,a0,-1188 # 7270 <malloc+0x15d6>
    371c:	00002097          	auipc	ra,0x2
    3720:	4c6080e7          	jalr	1222(ra) # 5be2 <printf>
    exit(1);
    3724:	4505                	li	a0,1
    3726:	00002097          	auipc	ra,0x2
    372a:	132080e7          	jalr	306(ra) # 5858 <exit>
    printf("%s: chdir ./.. failed\n", s);
    372e:	85ca                	mv	a1,s2
    3730:	00004517          	auipc	a0,0x4
    3734:	b6850513          	addi	a0,a0,-1176 # 7298 <malloc+0x15fe>
    3738:	00002097          	auipc	ra,0x2
    373c:	4aa080e7          	jalr	1194(ra) # 5be2 <printf>
    exit(1);
    3740:	4505                	li	a0,1
    3742:	00002097          	auipc	ra,0x2
    3746:	116080e7          	jalr	278(ra) # 5858 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    374a:	85ca                	mv	a1,s2
    374c:	00004517          	auipc	a0,0x4
    3750:	b6450513          	addi	a0,a0,-1180 # 72b0 <malloc+0x1616>
    3754:	00002097          	auipc	ra,0x2
    3758:	48e080e7          	jalr	1166(ra) # 5be2 <printf>
    exit(1);
    375c:	4505                	li	a0,1
    375e:	00002097          	auipc	ra,0x2
    3762:	0fa080e7          	jalr	250(ra) # 5858 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3766:	85ca                	mv	a1,s2
    3768:	00004517          	auipc	a0,0x4
    376c:	b6850513          	addi	a0,a0,-1176 # 72d0 <malloc+0x1636>
    3770:	00002097          	auipc	ra,0x2
    3774:	472080e7          	jalr	1138(ra) # 5be2 <printf>
    exit(1);
    3778:	4505                	li	a0,1
    377a:	00002097          	auipc	ra,0x2
    377e:	0de080e7          	jalr	222(ra) # 5858 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3782:	85ca                	mv	a1,s2
    3784:	00004517          	auipc	a0,0x4
    3788:	b6c50513          	addi	a0,a0,-1172 # 72f0 <malloc+0x1656>
    378c:	00002097          	auipc	ra,0x2
    3790:	456080e7          	jalr	1110(ra) # 5be2 <printf>
    exit(1);
    3794:	4505                	li	a0,1
    3796:	00002097          	auipc	ra,0x2
    379a:	0c2080e7          	jalr	194(ra) # 5858 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    379e:	85ca                	mv	a1,s2
    37a0:	00004517          	auipc	a0,0x4
    37a4:	b9050513          	addi	a0,a0,-1136 # 7330 <malloc+0x1696>
    37a8:	00002097          	auipc	ra,0x2
    37ac:	43a080e7          	jalr	1082(ra) # 5be2 <printf>
    exit(1);
    37b0:	4505                	li	a0,1
    37b2:	00002097          	auipc	ra,0x2
    37b6:	0a6080e7          	jalr	166(ra) # 5858 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    37ba:	85ca                	mv	a1,s2
    37bc:	00004517          	auipc	a0,0x4
    37c0:	ba450513          	addi	a0,a0,-1116 # 7360 <malloc+0x16c6>
    37c4:	00002097          	auipc	ra,0x2
    37c8:	41e080e7          	jalr	1054(ra) # 5be2 <printf>
    exit(1);
    37cc:	4505                	li	a0,1
    37ce:	00002097          	auipc	ra,0x2
    37d2:	08a080e7          	jalr	138(ra) # 5858 <exit>
    printf("%s: create dd succeeded!\n", s);
    37d6:	85ca                	mv	a1,s2
    37d8:	00004517          	auipc	a0,0x4
    37dc:	ba850513          	addi	a0,a0,-1112 # 7380 <malloc+0x16e6>
    37e0:	00002097          	auipc	ra,0x2
    37e4:	402080e7          	jalr	1026(ra) # 5be2 <printf>
    exit(1);
    37e8:	4505                	li	a0,1
    37ea:	00002097          	auipc	ra,0x2
    37ee:	06e080e7          	jalr	110(ra) # 5858 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    37f2:	85ca                	mv	a1,s2
    37f4:	00004517          	auipc	a0,0x4
    37f8:	bac50513          	addi	a0,a0,-1108 # 73a0 <malloc+0x1706>
    37fc:	00002097          	auipc	ra,0x2
    3800:	3e6080e7          	jalr	998(ra) # 5be2 <printf>
    exit(1);
    3804:	4505                	li	a0,1
    3806:	00002097          	auipc	ra,0x2
    380a:	052080e7          	jalr	82(ra) # 5858 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    380e:	85ca                	mv	a1,s2
    3810:	00004517          	auipc	a0,0x4
    3814:	bb050513          	addi	a0,a0,-1104 # 73c0 <malloc+0x1726>
    3818:	00002097          	auipc	ra,0x2
    381c:	3ca080e7          	jalr	970(ra) # 5be2 <printf>
    exit(1);
    3820:	4505                	li	a0,1
    3822:	00002097          	auipc	ra,0x2
    3826:	036080e7          	jalr	54(ra) # 5858 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    382a:	85ca                	mv	a1,s2
    382c:	00004517          	auipc	a0,0x4
    3830:	bc450513          	addi	a0,a0,-1084 # 73f0 <malloc+0x1756>
    3834:	00002097          	auipc	ra,0x2
    3838:	3ae080e7          	jalr	942(ra) # 5be2 <printf>
    exit(1);
    383c:	4505                	li	a0,1
    383e:	00002097          	auipc	ra,0x2
    3842:	01a080e7          	jalr	26(ra) # 5858 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3846:	85ca                	mv	a1,s2
    3848:	00004517          	auipc	a0,0x4
    384c:	bd050513          	addi	a0,a0,-1072 # 7418 <malloc+0x177e>
    3850:	00002097          	auipc	ra,0x2
    3854:	392080e7          	jalr	914(ra) # 5be2 <printf>
    exit(1);
    3858:	4505                	li	a0,1
    385a:	00002097          	auipc	ra,0x2
    385e:	ffe080e7          	jalr	-2(ra) # 5858 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3862:	85ca                	mv	a1,s2
    3864:	00004517          	auipc	a0,0x4
    3868:	bdc50513          	addi	a0,a0,-1060 # 7440 <malloc+0x17a6>
    386c:	00002097          	auipc	ra,0x2
    3870:	376080e7          	jalr	886(ra) # 5be2 <printf>
    exit(1);
    3874:	4505                	li	a0,1
    3876:	00002097          	auipc	ra,0x2
    387a:	fe2080e7          	jalr	-30(ra) # 5858 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    387e:	85ca                	mv	a1,s2
    3880:	00004517          	auipc	a0,0x4
    3884:	be850513          	addi	a0,a0,-1048 # 7468 <malloc+0x17ce>
    3888:	00002097          	auipc	ra,0x2
    388c:	35a080e7          	jalr	858(ra) # 5be2 <printf>
    exit(1);
    3890:	4505                	li	a0,1
    3892:	00002097          	auipc	ra,0x2
    3896:	fc6080e7          	jalr	-58(ra) # 5858 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    389a:	85ca                	mv	a1,s2
    389c:	00004517          	auipc	a0,0x4
    38a0:	bec50513          	addi	a0,a0,-1044 # 7488 <malloc+0x17ee>
    38a4:	00002097          	auipc	ra,0x2
    38a8:	33e080e7          	jalr	830(ra) # 5be2 <printf>
    exit(1);
    38ac:	4505                	li	a0,1
    38ae:	00002097          	auipc	ra,0x2
    38b2:	faa080e7          	jalr	-86(ra) # 5858 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    38b6:	85ca                	mv	a1,s2
    38b8:	00004517          	auipc	a0,0x4
    38bc:	bf050513          	addi	a0,a0,-1040 # 74a8 <malloc+0x180e>
    38c0:	00002097          	auipc	ra,0x2
    38c4:	322080e7          	jalr	802(ra) # 5be2 <printf>
    exit(1);
    38c8:	4505                	li	a0,1
    38ca:	00002097          	auipc	ra,0x2
    38ce:	f8e080e7          	jalr	-114(ra) # 5858 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    38d2:	85ca                	mv	a1,s2
    38d4:	00004517          	auipc	a0,0x4
    38d8:	bfc50513          	addi	a0,a0,-1028 # 74d0 <malloc+0x1836>
    38dc:	00002097          	auipc	ra,0x2
    38e0:	306080e7          	jalr	774(ra) # 5be2 <printf>
    exit(1);
    38e4:	4505                	li	a0,1
    38e6:	00002097          	auipc	ra,0x2
    38ea:	f72080e7          	jalr	-142(ra) # 5858 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    38ee:	85ca                	mv	a1,s2
    38f0:	00004517          	auipc	a0,0x4
    38f4:	c0050513          	addi	a0,a0,-1024 # 74f0 <malloc+0x1856>
    38f8:	00002097          	auipc	ra,0x2
    38fc:	2ea080e7          	jalr	746(ra) # 5be2 <printf>
    exit(1);
    3900:	4505                	li	a0,1
    3902:	00002097          	auipc	ra,0x2
    3906:	f56080e7          	jalr	-170(ra) # 5858 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    390a:	85ca                	mv	a1,s2
    390c:	00004517          	auipc	a0,0x4
    3910:	c0450513          	addi	a0,a0,-1020 # 7510 <malloc+0x1876>
    3914:	00002097          	auipc	ra,0x2
    3918:	2ce080e7          	jalr	718(ra) # 5be2 <printf>
    exit(1);
    391c:	4505                	li	a0,1
    391e:	00002097          	auipc	ra,0x2
    3922:	f3a080e7          	jalr	-198(ra) # 5858 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3926:	85ca                	mv	a1,s2
    3928:	00004517          	auipc	a0,0x4
    392c:	c1050513          	addi	a0,a0,-1008 # 7538 <malloc+0x189e>
    3930:	00002097          	auipc	ra,0x2
    3934:	2b2080e7          	jalr	690(ra) # 5be2 <printf>
    exit(1);
    3938:	4505                	li	a0,1
    393a:	00002097          	auipc	ra,0x2
    393e:	f1e080e7          	jalr	-226(ra) # 5858 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3942:	85ca                	mv	a1,s2
    3944:	00004517          	auipc	a0,0x4
    3948:	88c50513          	addi	a0,a0,-1908 # 71d0 <malloc+0x1536>
    394c:	00002097          	auipc	ra,0x2
    3950:	296080e7          	jalr	662(ra) # 5be2 <printf>
    exit(1);
    3954:	4505                	li	a0,1
    3956:	00002097          	auipc	ra,0x2
    395a:	f02080e7          	jalr	-254(ra) # 5858 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    395e:	85ca                	mv	a1,s2
    3960:	00004517          	auipc	a0,0x4
    3964:	bf850513          	addi	a0,a0,-1032 # 7558 <malloc+0x18be>
    3968:	00002097          	auipc	ra,0x2
    396c:	27a080e7          	jalr	634(ra) # 5be2 <printf>
    exit(1);
    3970:	4505                	li	a0,1
    3972:	00002097          	auipc	ra,0x2
    3976:	ee6080e7          	jalr	-282(ra) # 5858 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    397a:	85ca                	mv	a1,s2
    397c:	00004517          	auipc	a0,0x4
    3980:	bfc50513          	addi	a0,a0,-1028 # 7578 <malloc+0x18de>
    3984:	00002097          	auipc	ra,0x2
    3988:	25e080e7          	jalr	606(ra) # 5be2 <printf>
    exit(1);
    398c:	4505                	li	a0,1
    398e:	00002097          	auipc	ra,0x2
    3992:	eca080e7          	jalr	-310(ra) # 5858 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3996:	85ca                	mv	a1,s2
    3998:	00004517          	auipc	a0,0x4
    399c:	c1050513          	addi	a0,a0,-1008 # 75a8 <malloc+0x190e>
    39a0:	00002097          	auipc	ra,0x2
    39a4:	242080e7          	jalr	578(ra) # 5be2 <printf>
    exit(1);
    39a8:	4505                	li	a0,1
    39aa:	00002097          	auipc	ra,0x2
    39ae:	eae080e7          	jalr	-338(ra) # 5858 <exit>
    printf("%s: unlink dd failed\n", s);
    39b2:	85ca                	mv	a1,s2
    39b4:	00004517          	auipc	a0,0x4
    39b8:	c1450513          	addi	a0,a0,-1004 # 75c8 <malloc+0x192e>
    39bc:	00002097          	auipc	ra,0x2
    39c0:	226080e7          	jalr	550(ra) # 5be2 <printf>
    exit(1);
    39c4:	4505                	li	a0,1
    39c6:	00002097          	auipc	ra,0x2
    39ca:	e92080e7          	jalr	-366(ra) # 5858 <exit>

00000000000039ce <rmdot>:
{
    39ce:	1101                	addi	sp,sp,-32
    39d0:	ec06                	sd	ra,24(sp)
    39d2:	e822                	sd	s0,16(sp)
    39d4:	e426                	sd	s1,8(sp)
    39d6:	1000                	addi	s0,sp,32
    39d8:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    39da:	00004517          	auipc	a0,0x4
    39de:	c0650513          	addi	a0,a0,-1018 # 75e0 <malloc+0x1946>
    39e2:	00002097          	auipc	ra,0x2
    39e6:	ede080e7          	jalr	-290(ra) # 58c0 <mkdir>
    39ea:	e549                	bnez	a0,3a74 <rmdot+0xa6>
  if(chdir("dots") != 0){
    39ec:	00004517          	auipc	a0,0x4
    39f0:	bf450513          	addi	a0,a0,-1036 # 75e0 <malloc+0x1946>
    39f4:	00002097          	auipc	ra,0x2
    39f8:	ed4080e7          	jalr	-300(ra) # 58c8 <chdir>
    39fc:	e951                	bnez	a0,3a90 <rmdot+0xc2>
  if(unlink(".") == 0){
    39fe:	00003517          	auipc	a0,0x3
    3a02:	a7250513          	addi	a0,a0,-1422 # 6470 <malloc+0x7d6>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	ea2080e7          	jalr	-350(ra) # 58a8 <unlink>
    3a0e:	cd59                	beqz	a0,3aac <rmdot+0xde>
  if(unlink("..") == 0){
    3a10:	00003517          	auipc	a0,0x3
    3a14:	62850513          	addi	a0,a0,1576 # 7038 <malloc+0x139e>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	e90080e7          	jalr	-368(ra) # 58a8 <unlink>
    3a20:	c545                	beqz	a0,3ac8 <rmdot+0xfa>
  if(chdir("/") != 0){
    3a22:	00003517          	auipc	a0,0x3
    3a26:	5be50513          	addi	a0,a0,1470 # 6fe0 <malloc+0x1346>
    3a2a:	00002097          	auipc	ra,0x2
    3a2e:	e9e080e7          	jalr	-354(ra) # 58c8 <chdir>
    3a32:	e94d                	bnez	a0,3ae4 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3a34:	00004517          	auipc	a0,0x4
    3a38:	c1450513          	addi	a0,a0,-1004 # 7648 <malloc+0x19ae>
    3a3c:	00002097          	auipc	ra,0x2
    3a40:	e6c080e7          	jalr	-404(ra) # 58a8 <unlink>
    3a44:	cd55                	beqz	a0,3b00 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3a46:	00004517          	auipc	a0,0x4
    3a4a:	c2a50513          	addi	a0,a0,-982 # 7670 <malloc+0x19d6>
    3a4e:	00002097          	auipc	ra,0x2
    3a52:	e5a080e7          	jalr	-422(ra) # 58a8 <unlink>
    3a56:	c179                	beqz	a0,3b1c <rmdot+0x14e>
  if(unlink("dots") != 0){
    3a58:	00004517          	auipc	a0,0x4
    3a5c:	b8850513          	addi	a0,a0,-1144 # 75e0 <malloc+0x1946>
    3a60:	00002097          	auipc	ra,0x2
    3a64:	e48080e7          	jalr	-440(ra) # 58a8 <unlink>
    3a68:	e961                	bnez	a0,3b38 <rmdot+0x16a>
}
    3a6a:	60e2                	ld	ra,24(sp)
    3a6c:	6442                	ld	s0,16(sp)
    3a6e:	64a2                	ld	s1,8(sp)
    3a70:	6105                	addi	sp,sp,32
    3a72:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3a74:	85a6                	mv	a1,s1
    3a76:	00004517          	auipc	a0,0x4
    3a7a:	b7250513          	addi	a0,a0,-1166 # 75e8 <malloc+0x194e>
    3a7e:	00002097          	auipc	ra,0x2
    3a82:	164080e7          	jalr	356(ra) # 5be2 <printf>
    exit(1);
    3a86:	4505                	li	a0,1
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	dd0080e7          	jalr	-560(ra) # 5858 <exit>
    printf("%s: chdir dots failed\n", s);
    3a90:	85a6                	mv	a1,s1
    3a92:	00004517          	auipc	a0,0x4
    3a96:	b6e50513          	addi	a0,a0,-1170 # 7600 <malloc+0x1966>
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	148080e7          	jalr	328(ra) # 5be2 <printf>
    exit(1);
    3aa2:	4505                	li	a0,1
    3aa4:	00002097          	auipc	ra,0x2
    3aa8:	db4080e7          	jalr	-588(ra) # 5858 <exit>
    printf("%s: rm . worked!\n", s);
    3aac:	85a6                	mv	a1,s1
    3aae:	00004517          	auipc	a0,0x4
    3ab2:	b6a50513          	addi	a0,a0,-1174 # 7618 <malloc+0x197e>
    3ab6:	00002097          	auipc	ra,0x2
    3aba:	12c080e7          	jalr	300(ra) # 5be2 <printf>
    exit(1);
    3abe:	4505                	li	a0,1
    3ac0:	00002097          	auipc	ra,0x2
    3ac4:	d98080e7          	jalr	-616(ra) # 5858 <exit>
    printf("%s: rm .. worked!\n", s);
    3ac8:	85a6                	mv	a1,s1
    3aca:	00004517          	auipc	a0,0x4
    3ace:	b6650513          	addi	a0,a0,-1178 # 7630 <malloc+0x1996>
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	110080e7          	jalr	272(ra) # 5be2 <printf>
    exit(1);
    3ada:	4505                	li	a0,1
    3adc:	00002097          	auipc	ra,0x2
    3ae0:	d7c080e7          	jalr	-644(ra) # 5858 <exit>
    printf("%s: chdir / failed\n", s);
    3ae4:	85a6                	mv	a1,s1
    3ae6:	00003517          	auipc	a0,0x3
    3aea:	50250513          	addi	a0,a0,1282 # 6fe8 <malloc+0x134e>
    3aee:	00002097          	auipc	ra,0x2
    3af2:	0f4080e7          	jalr	244(ra) # 5be2 <printf>
    exit(1);
    3af6:	4505                	li	a0,1
    3af8:	00002097          	auipc	ra,0x2
    3afc:	d60080e7          	jalr	-672(ra) # 5858 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3b00:	85a6                	mv	a1,s1
    3b02:	00004517          	auipc	a0,0x4
    3b06:	b4e50513          	addi	a0,a0,-1202 # 7650 <malloc+0x19b6>
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	0d8080e7          	jalr	216(ra) # 5be2 <printf>
    exit(1);
    3b12:	4505                	li	a0,1
    3b14:	00002097          	auipc	ra,0x2
    3b18:	d44080e7          	jalr	-700(ra) # 5858 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3b1c:	85a6                	mv	a1,s1
    3b1e:	00004517          	auipc	a0,0x4
    3b22:	b5a50513          	addi	a0,a0,-1190 # 7678 <malloc+0x19de>
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	0bc080e7          	jalr	188(ra) # 5be2 <printf>
    exit(1);
    3b2e:	4505                	li	a0,1
    3b30:	00002097          	auipc	ra,0x2
    3b34:	d28080e7          	jalr	-728(ra) # 5858 <exit>
    printf("%s: unlink dots failed!\n", s);
    3b38:	85a6                	mv	a1,s1
    3b3a:	00004517          	auipc	a0,0x4
    3b3e:	b5e50513          	addi	a0,a0,-1186 # 7698 <malloc+0x19fe>
    3b42:	00002097          	auipc	ra,0x2
    3b46:	0a0080e7          	jalr	160(ra) # 5be2 <printf>
    exit(1);
    3b4a:	4505                	li	a0,1
    3b4c:	00002097          	auipc	ra,0x2
    3b50:	d0c080e7          	jalr	-756(ra) # 5858 <exit>

0000000000003b54 <dirfile>:
{
    3b54:	1101                	addi	sp,sp,-32
    3b56:	ec06                	sd	ra,24(sp)
    3b58:	e822                	sd	s0,16(sp)
    3b5a:	e426                	sd	s1,8(sp)
    3b5c:	e04a                	sd	s2,0(sp)
    3b5e:	1000                	addi	s0,sp,32
    3b60:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3b62:	20000593          	li	a1,512
    3b66:	00004517          	auipc	a0,0x4
    3b6a:	b5250513          	addi	a0,a0,-1198 # 76b8 <malloc+0x1a1e>
    3b6e:	00002097          	auipc	ra,0x2
    3b72:	d2a080e7          	jalr	-726(ra) # 5898 <open>
  if(fd < 0){
    3b76:	0e054d63          	bltz	a0,3c70 <dirfile+0x11c>
  close(fd);
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	d06080e7          	jalr	-762(ra) # 5880 <close>
  if(chdir("dirfile") == 0){
    3b82:	00004517          	auipc	a0,0x4
    3b86:	b3650513          	addi	a0,a0,-1226 # 76b8 <malloc+0x1a1e>
    3b8a:	00002097          	auipc	ra,0x2
    3b8e:	d3e080e7          	jalr	-706(ra) # 58c8 <chdir>
    3b92:	cd6d                	beqz	a0,3c8c <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3b94:	4581                	li	a1,0
    3b96:	00004517          	auipc	a0,0x4
    3b9a:	b6a50513          	addi	a0,a0,-1174 # 7700 <malloc+0x1a66>
    3b9e:	00002097          	auipc	ra,0x2
    3ba2:	cfa080e7          	jalr	-774(ra) # 5898 <open>
  if(fd >= 0){
    3ba6:	10055163          	bgez	a0,3ca8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3baa:	20000593          	li	a1,512
    3bae:	00004517          	auipc	a0,0x4
    3bb2:	b5250513          	addi	a0,a0,-1198 # 7700 <malloc+0x1a66>
    3bb6:	00002097          	auipc	ra,0x2
    3bba:	ce2080e7          	jalr	-798(ra) # 5898 <open>
  if(fd >= 0){
    3bbe:	10055363          	bgez	a0,3cc4 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3bc2:	00004517          	auipc	a0,0x4
    3bc6:	b3e50513          	addi	a0,a0,-1218 # 7700 <malloc+0x1a66>
    3bca:	00002097          	auipc	ra,0x2
    3bce:	cf6080e7          	jalr	-778(ra) # 58c0 <mkdir>
    3bd2:	10050763          	beqz	a0,3ce0 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3bd6:	00004517          	auipc	a0,0x4
    3bda:	b2a50513          	addi	a0,a0,-1238 # 7700 <malloc+0x1a66>
    3bde:	00002097          	auipc	ra,0x2
    3be2:	cca080e7          	jalr	-822(ra) # 58a8 <unlink>
    3be6:	10050b63          	beqz	a0,3cfc <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3bea:	00004597          	auipc	a1,0x4
    3bee:	b1658593          	addi	a1,a1,-1258 # 7700 <malloc+0x1a66>
    3bf2:	00002517          	auipc	a0,0x2
    3bf6:	36e50513          	addi	a0,a0,878 # 5f60 <malloc+0x2c6>
    3bfa:	00002097          	auipc	ra,0x2
    3bfe:	cbe080e7          	jalr	-834(ra) # 58b8 <link>
    3c02:	10050b63          	beqz	a0,3d18 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3c06:	00004517          	auipc	a0,0x4
    3c0a:	ab250513          	addi	a0,a0,-1358 # 76b8 <malloc+0x1a1e>
    3c0e:	00002097          	auipc	ra,0x2
    3c12:	c9a080e7          	jalr	-870(ra) # 58a8 <unlink>
    3c16:	10051f63          	bnez	a0,3d34 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3c1a:	4589                	li	a1,2
    3c1c:	00003517          	auipc	a0,0x3
    3c20:	85450513          	addi	a0,a0,-1964 # 6470 <malloc+0x7d6>
    3c24:	00002097          	auipc	ra,0x2
    3c28:	c74080e7          	jalr	-908(ra) # 5898 <open>
  if(fd >= 0){
    3c2c:	12055263          	bgez	a0,3d50 <dirfile+0x1fc>
  fd = open(".", 0);
    3c30:	4581                	li	a1,0
    3c32:	00003517          	auipc	a0,0x3
    3c36:	83e50513          	addi	a0,a0,-1986 # 6470 <malloc+0x7d6>
    3c3a:	00002097          	auipc	ra,0x2
    3c3e:	c5e080e7          	jalr	-930(ra) # 5898 <open>
    3c42:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3c44:	4605                	li	a2,1
    3c46:	00002597          	auipc	a1,0x2
    3c4a:	1e258593          	addi	a1,a1,482 # 5e28 <malloc+0x18e>
    3c4e:	00002097          	auipc	ra,0x2
    3c52:	c2a080e7          	jalr	-982(ra) # 5878 <write>
    3c56:	10a04b63          	bgtz	a0,3d6c <dirfile+0x218>
  close(fd);
    3c5a:	8526                	mv	a0,s1
    3c5c:	00002097          	auipc	ra,0x2
    3c60:	c24080e7          	jalr	-988(ra) # 5880 <close>
}
    3c64:	60e2                	ld	ra,24(sp)
    3c66:	6442                	ld	s0,16(sp)
    3c68:	64a2                	ld	s1,8(sp)
    3c6a:	6902                	ld	s2,0(sp)
    3c6c:	6105                	addi	sp,sp,32
    3c6e:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3c70:	85ca                	mv	a1,s2
    3c72:	00004517          	auipc	a0,0x4
    3c76:	a4e50513          	addi	a0,a0,-1458 # 76c0 <malloc+0x1a26>
    3c7a:	00002097          	auipc	ra,0x2
    3c7e:	f68080e7          	jalr	-152(ra) # 5be2 <printf>
    exit(1);
    3c82:	4505                	li	a0,1
    3c84:	00002097          	auipc	ra,0x2
    3c88:	bd4080e7          	jalr	-1068(ra) # 5858 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3c8c:	85ca                	mv	a1,s2
    3c8e:	00004517          	auipc	a0,0x4
    3c92:	a5250513          	addi	a0,a0,-1454 # 76e0 <malloc+0x1a46>
    3c96:	00002097          	auipc	ra,0x2
    3c9a:	f4c080e7          	jalr	-180(ra) # 5be2 <printf>
    exit(1);
    3c9e:	4505                	li	a0,1
    3ca0:	00002097          	auipc	ra,0x2
    3ca4:	bb8080e7          	jalr	-1096(ra) # 5858 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3ca8:	85ca                	mv	a1,s2
    3caa:	00004517          	auipc	a0,0x4
    3cae:	a6650513          	addi	a0,a0,-1434 # 7710 <malloc+0x1a76>
    3cb2:	00002097          	auipc	ra,0x2
    3cb6:	f30080e7          	jalr	-208(ra) # 5be2 <printf>
    exit(1);
    3cba:	4505                	li	a0,1
    3cbc:	00002097          	auipc	ra,0x2
    3cc0:	b9c080e7          	jalr	-1124(ra) # 5858 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3cc4:	85ca                	mv	a1,s2
    3cc6:	00004517          	auipc	a0,0x4
    3cca:	a4a50513          	addi	a0,a0,-1462 # 7710 <malloc+0x1a76>
    3cce:	00002097          	auipc	ra,0x2
    3cd2:	f14080e7          	jalr	-236(ra) # 5be2 <printf>
    exit(1);
    3cd6:	4505                	li	a0,1
    3cd8:	00002097          	auipc	ra,0x2
    3cdc:	b80080e7          	jalr	-1152(ra) # 5858 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3ce0:	85ca                	mv	a1,s2
    3ce2:	00004517          	auipc	a0,0x4
    3ce6:	a5650513          	addi	a0,a0,-1450 # 7738 <malloc+0x1a9e>
    3cea:	00002097          	auipc	ra,0x2
    3cee:	ef8080e7          	jalr	-264(ra) # 5be2 <printf>
    exit(1);
    3cf2:	4505                	li	a0,1
    3cf4:	00002097          	auipc	ra,0x2
    3cf8:	b64080e7          	jalr	-1180(ra) # 5858 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3cfc:	85ca                	mv	a1,s2
    3cfe:	00004517          	auipc	a0,0x4
    3d02:	a6250513          	addi	a0,a0,-1438 # 7760 <malloc+0x1ac6>
    3d06:	00002097          	auipc	ra,0x2
    3d0a:	edc080e7          	jalr	-292(ra) # 5be2 <printf>
    exit(1);
    3d0e:	4505                	li	a0,1
    3d10:	00002097          	auipc	ra,0x2
    3d14:	b48080e7          	jalr	-1208(ra) # 5858 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3d18:	85ca                	mv	a1,s2
    3d1a:	00004517          	auipc	a0,0x4
    3d1e:	a6e50513          	addi	a0,a0,-1426 # 7788 <malloc+0x1aee>
    3d22:	00002097          	auipc	ra,0x2
    3d26:	ec0080e7          	jalr	-320(ra) # 5be2 <printf>
    exit(1);
    3d2a:	4505                	li	a0,1
    3d2c:	00002097          	auipc	ra,0x2
    3d30:	b2c080e7          	jalr	-1236(ra) # 5858 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3d34:	85ca                	mv	a1,s2
    3d36:	00004517          	auipc	a0,0x4
    3d3a:	a7a50513          	addi	a0,a0,-1414 # 77b0 <malloc+0x1b16>
    3d3e:	00002097          	auipc	ra,0x2
    3d42:	ea4080e7          	jalr	-348(ra) # 5be2 <printf>
    exit(1);
    3d46:	4505                	li	a0,1
    3d48:	00002097          	auipc	ra,0x2
    3d4c:	b10080e7          	jalr	-1264(ra) # 5858 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3d50:	85ca                	mv	a1,s2
    3d52:	00004517          	auipc	a0,0x4
    3d56:	a7e50513          	addi	a0,a0,-1410 # 77d0 <malloc+0x1b36>
    3d5a:	00002097          	auipc	ra,0x2
    3d5e:	e88080e7          	jalr	-376(ra) # 5be2 <printf>
    exit(1);
    3d62:	4505                	li	a0,1
    3d64:	00002097          	auipc	ra,0x2
    3d68:	af4080e7          	jalr	-1292(ra) # 5858 <exit>
    printf("%s: write . succeeded!\n", s);
    3d6c:	85ca                	mv	a1,s2
    3d6e:	00004517          	auipc	a0,0x4
    3d72:	a8a50513          	addi	a0,a0,-1398 # 77f8 <malloc+0x1b5e>
    3d76:	00002097          	auipc	ra,0x2
    3d7a:	e6c080e7          	jalr	-404(ra) # 5be2 <printf>
    exit(1);
    3d7e:	4505                	li	a0,1
    3d80:	00002097          	auipc	ra,0x2
    3d84:	ad8080e7          	jalr	-1320(ra) # 5858 <exit>

0000000000003d88 <iref>:
{
    3d88:	7139                	addi	sp,sp,-64
    3d8a:	fc06                	sd	ra,56(sp)
    3d8c:	f822                	sd	s0,48(sp)
    3d8e:	f426                	sd	s1,40(sp)
    3d90:	f04a                	sd	s2,32(sp)
    3d92:	ec4e                	sd	s3,24(sp)
    3d94:	e852                	sd	s4,16(sp)
    3d96:	e456                	sd	s5,8(sp)
    3d98:	e05a                	sd	s6,0(sp)
    3d9a:	0080                	addi	s0,sp,64
    3d9c:	8b2a                	mv	s6,a0
    3d9e:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3da2:	00004a17          	auipc	s4,0x4
    3da6:	a6ea0a13          	addi	s4,s4,-1426 # 7810 <malloc+0x1b76>
    mkdir("");
    3daa:	00003497          	auipc	s1,0x3
    3dae:	56e48493          	addi	s1,s1,1390 # 7318 <malloc+0x167e>
    link("README", "");
    3db2:	00002a97          	auipc	s5,0x2
    3db6:	1aea8a93          	addi	s5,s5,430 # 5f60 <malloc+0x2c6>
    fd = open("xx", O_CREATE);
    3dba:	00004997          	auipc	s3,0x4
    3dbe:	94e98993          	addi	s3,s3,-1714 # 7708 <malloc+0x1a6e>
    3dc2:	a891                	j	3e16 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3dc4:	85da                	mv	a1,s6
    3dc6:	00004517          	auipc	a0,0x4
    3dca:	a5250513          	addi	a0,a0,-1454 # 7818 <malloc+0x1b7e>
    3dce:	00002097          	auipc	ra,0x2
    3dd2:	e14080e7          	jalr	-492(ra) # 5be2 <printf>
      exit(1);
    3dd6:	4505                	li	a0,1
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	a80080e7          	jalr	-1408(ra) # 5858 <exit>
      printf("%s: chdir irefd failed\n", s);
    3de0:	85da                	mv	a1,s6
    3de2:	00004517          	auipc	a0,0x4
    3de6:	a4e50513          	addi	a0,a0,-1458 # 7830 <malloc+0x1b96>
    3dea:	00002097          	auipc	ra,0x2
    3dee:	df8080e7          	jalr	-520(ra) # 5be2 <printf>
      exit(1);
    3df2:	4505                	li	a0,1
    3df4:	00002097          	auipc	ra,0x2
    3df8:	a64080e7          	jalr	-1436(ra) # 5858 <exit>
      close(fd);
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	a84080e7          	jalr	-1404(ra) # 5880 <close>
    3e04:	a889                	j	3e56 <iref+0xce>
    unlink("xx");
    3e06:	854e                	mv	a0,s3
    3e08:	00002097          	auipc	ra,0x2
    3e0c:	aa0080e7          	jalr	-1376(ra) # 58a8 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3e10:	397d                	addiw	s2,s2,-1
    3e12:	06090063          	beqz	s2,3e72 <iref+0xea>
    if(mkdir("irefd") != 0){
    3e16:	8552                	mv	a0,s4
    3e18:	00002097          	auipc	ra,0x2
    3e1c:	aa8080e7          	jalr	-1368(ra) # 58c0 <mkdir>
    3e20:	f155                	bnez	a0,3dc4 <iref+0x3c>
    if(chdir("irefd") != 0){
    3e22:	8552                	mv	a0,s4
    3e24:	00002097          	auipc	ra,0x2
    3e28:	aa4080e7          	jalr	-1372(ra) # 58c8 <chdir>
    3e2c:	f955                	bnez	a0,3de0 <iref+0x58>
    mkdir("");
    3e2e:	8526                	mv	a0,s1
    3e30:	00002097          	auipc	ra,0x2
    3e34:	a90080e7          	jalr	-1392(ra) # 58c0 <mkdir>
    link("README", "");
    3e38:	85a6                	mv	a1,s1
    3e3a:	8556                	mv	a0,s5
    3e3c:	00002097          	auipc	ra,0x2
    3e40:	a7c080e7          	jalr	-1412(ra) # 58b8 <link>
    fd = open("", O_CREATE);
    3e44:	20000593          	li	a1,512
    3e48:	8526                	mv	a0,s1
    3e4a:	00002097          	auipc	ra,0x2
    3e4e:	a4e080e7          	jalr	-1458(ra) # 5898 <open>
    if(fd >= 0)
    3e52:	fa0555e3          	bgez	a0,3dfc <iref+0x74>
    fd = open("xx", O_CREATE);
    3e56:	20000593          	li	a1,512
    3e5a:	854e                	mv	a0,s3
    3e5c:	00002097          	auipc	ra,0x2
    3e60:	a3c080e7          	jalr	-1476(ra) # 5898 <open>
    if(fd >= 0)
    3e64:	fa0541e3          	bltz	a0,3e06 <iref+0x7e>
      close(fd);
    3e68:	00002097          	auipc	ra,0x2
    3e6c:	a18080e7          	jalr	-1512(ra) # 5880 <close>
    3e70:	bf59                	j	3e06 <iref+0x7e>
    3e72:	03300493          	li	s1,51
    chdir("..");
    3e76:	00003997          	auipc	s3,0x3
    3e7a:	1c298993          	addi	s3,s3,450 # 7038 <malloc+0x139e>
    unlink("irefd");
    3e7e:	00004917          	auipc	s2,0x4
    3e82:	99290913          	addi	s2,s2,-1646 # 7810 <malloc+0x1b76>
    chdir("..");
    3e86:	854e                	mv	a0,s3
    3e88:	00002097          	auipc	ra,0x2
    3e8c:	a40080e7          	jalr	-1472(ra) # 58c8 <chdir>
    unlink("irefd");
    3e90:	854a                	mv	a0,s2
    3e92:	00002097          	auipc	ra,0x2
    3e96:	a16080e7          	jalr	-1514(ra) # 58a8 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3e9a:	34fd                	addiw	s1,s1,-1
    3e9c:	f4ed                	bnez	s1,3e86 <iref+0xfe>
  chdir("/");
    3e9e:	00003517          	auipc	a0,0x3
    3ea2:	14250513          	addi	a0,a0,322 # 6fe0 <malloc+0x1346>
    3ea6:	00002097          	auipc	ra,0x2
    3eaa:	a22080e7          	jalr	-1502(ra) # 58c8 <chdir>
}
    3eae:	70e2                	ld	ra,56(sp)
    3eb0:	7442                	ld	s0,48(sp)
    3eb2:	74a2                	ld	s1,40(sp)
    3eb4:	7902                	ld	s2,32(sp)
    3eb6:	69e2                	ld	s3,24(sp)
    3eb8:	6a42                	ld	s4,16(sp)
    3eba:	6aa2                	ld	s5,8(sp)
    3ebc:	6b02                	ld	s6,0(sp)
    3ebe:	6121                	addi	sp,sp,64
    3ec0:	8082                	ret

0000000000003ec2 <openiputtest>:
{
    3ec2:	7179                	addi	sp,sp,-48
    3ec4:	f406                	sd	ra,40(sp)
    3ec6:	f022                	sd	s0,32(sp)
    3ec8:	ec26                	sd	s1,24(sp)
    3eca:	1800                	addi	s0,sp,48
    3ecc:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3ece:	00004517          	auipc	a0,0x4
    3ed2:	97a50513          	addi	a0,a0,-1670 # 7848 <malloc+0x1bae>
    3ed6:	00002097          	auipc	ra,0x2
    3eda:	9ea080e7          	jalr	-1558(ra) # 58c0 <mkdir>
    3ede:	04054263          	bltz	a0,3f22 <openiputtest+0x60>
  pid = fork();
    3ee2:	00002097          	auipc	ra,0x2
    3ee6:	96e080e7          	jalr	-1682(ra) # 5850 <fork>
  if(pid < 0){
    3eea:	04054a63          	bltz	a0,3f3e <openiputtest+0x7c>
  if(pid == 0){
    3eee:	e93d                	bnez	a0,3f64 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3ef0:	4589                	li	a1,2
    3ef2:	00004517          	auipc	a0,0x4
    3ef6:	95650513          	addi	a0,a0,-1706 # 7848 <malloc+0x1bae>
    3efa:	00002097          	auipc	ra,0x2
    3efe:	99e080e7          	jalr	-1634(ra) # 5898 <open>
    if(fd >= 0){
    3f02:	04054c63          	bltz	a0,3f5a <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3f06:	85a6                	mv	a1,s1
    3f08:	00004517          	auipc	a0,0x4
    3f0c:	96050513          	addi	a0,a0,-1696 # 7868 <malloc+0x1bce>
    3f10:	00002097          	auipc	ra,0x2
    3f14:	cd2080e7          	jalr	-814(ra) # 5be2 <printf>
      exit(1);
    3f18:	4505                	li	a0,1
    3f1a:	00002097          	auipc	ra,0x2
    3f1e:	93e080e7          	jalr	-1730(ra) # 5858 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3f22:	85a6                	mv	a1,s1
    3f24:	00004517          	auipc	a0,0x4
    3f28:	92c50513          	addi	a0,a0,-1748 # 7850 <malloc+0x1bb6>
    3f2c:	00002097          	auipc	ra,0x2
    3f30:	cb6080e7          	jalr	-842(ra) # 5be2 <printf>
    exit(1);
    3f34:	4505                	li	a0,1
    3f36:	00002097          	auipc	ra,0x2
    3f3a:	922080e7          	jalr	-1758(ra) # 5858 <exit>
    printf("%s: fork failed\n", s);
    3f3e:	85a6                	mv	a1,s1
    3f40:	00002517          	auipc	a0,0x2
    3f44:	6d050513          	addi	a0,a0,1744 # 6610 <malloc+0x976>
    3f48:	00002097          	auipc	ra,0x2
    3f4c:	c9a080e7          	jalr	-870(ra) # 5be2 <printf>
    exit(1);
    3f50:	4505                	li	a0,1
    3f52:	00002097          	auipc	ra,0x2
    3f56:	906080e7          	jalr	-1786(ra) # 5858 <exit>
    exit(0);
    3f5a:	4501                	li	a0,0
    3f5c:	00002097          	auipc	ra,0x2
    3f60:	8fc080e7          	jalr	-1796(ra) # 5858 <exit>
  sleep(1);
    3f64:	4505                	li	a0,1
    3f66:	00002097          	auipc	ra,0x2
    3f6a:	982080e7          	jalr	-1662(ra) # 58e8 <sleep>
  if(unlink("oidir") != 0){
    3f6e:	00004517          	auipc	a0,0x4
    3f72:	8da50513          	addi	a0,a0,-1830 # 7848 <malloc+0x1bae>
    3f76:	00002097          	auipc	ra,0x2
    3f7a:	932080e7          	jalr	-1742(ra) # 58a8 <unlink>
    3f7e:	cd19                	beqz	a0,3f9c <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3f80:	85a6                	mv	a1,s1
    3f82:	00003517          	auipc	a0,0x3
    3f86:	87e50513          	addi	a0,a0,-1922 # 6800 <malloc+0xb66>
    3f8a:	00002097          	auipc	ra,0x2
    3f8e:	c58080e7          	jalr	-936(ra) # 5be2 <printf>
    exit(1);
    3f92:	4505                	li	a0,1
    3f94:	00002097          	auipc	ra,0x2
    3f98:	8c4080e7          	jalr	-1852(ra) # 5858 <exit>
  wait(&xstatus);
    3f9c:	fdc40513          	addi	a0,s0,-36
    3fa0:	00002097          	auipc	ra,0x2
    3fa4:	8c0080e7          	jalr	-1856(ra) # 5860 <wait>
  exit(xstatus);
    3fa8:	fdc42503          	lw	a0,-36(s0)
    3fac:	00002097          	auipc	ra,0x2
    3fb0:	8ac080e7          	jalr	-1876(ra) # 5858 <exit>

0000000000003fb4 <forkforkfork>:
{
    3fb4:	1101                	addi	sp,sp,-32
    3fb6:	ec06                	sd	ra,24(sp)
    3fb8:	e822                	sd	s0,16(sp)
    3fba:	e426                	sd	s1,8(sp)
    3fbc:	1000                	addi	s0,sp,32
    3fbe:	84aa                	mv	s1,a0
  unlink("stopforking");
    3fc0:	00004517          	auipc	a0,0x4
    3fc4:	8d050513          	addi	a0,a0,-1840 # 7890 <malloc+0x1bf6>
    3fc8:	00002097          	auipc	ra,0x2
    3fcc:	8e0080e7          	jalr	-1824(ra) # 58a8 <unlink>
  int pid = fork();
    3fd0:	00002097          	auipc	ra,0x2
    3fd4:	880080e7          	jalr	-1920(ra) # 5850 <fork>
  if(pid < 0){
    3fd8:	04054563          	bltz	a0,4022 <forkforkfork+0x6e>
  if(pid == 0){
    3fdc:	c12d                	beqz	a0,403e <forkforkfork+0x8a>
  sleep(20); // two seconds
    3fde:	4551                	li	a0,20
    3fe0:	00002097          	auipc	ra,0x2
    3fe4:	908080e7          	jalr	-1784(ra) # 58e8 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3fe8:	20200593          	li	a1,514
    3fec:	00004517          	auipc	a0,0x4
    3ff0:	8a450513          	addi	a0,a0,-1884 # 7890 <malloc+0x1bf6>
    3ff4:	00002097          	auipc	ra,0x2
    3ff8:	8a4080e7          	jalr	-1884(ra) # 5898 <open>
    3ffc:	00002097          	auipc	ra,0x2
    4000:	884080e7          	jalr	-1916(ra) # 5880 <close>
  wait(0);
    4004:	4501                	li	a0,0
    4006:	00002097          	auipc	ra,0x2
    400a:	85a080e7          	jalr	-1958(ra) # 5860 <wait>
  sleep(10); // one second
    400e:	4529                	li	a0,10
    4010:	00002097          	auipc	ra,0x2
    4014:	8d8080e7          	jalr	-1832(ra) # 58e8 <sleep>
}
    4018:	60e2                	ld	ra,24(sp)
    401a:	6442                	ld	s0,16(sp)
    401c:	64a2                	ld	s1,8(sp)
    401e:	6105                	addi	sp,sp,32
    4020:	8082                	ret
    printf("%s: fork failed", s);
    4022:	85a6                	mv	a1,s1
    4024:	00002517          	auipc	a0,0x2
    4028:	7ac50513          	addi	a0,a0,1964 # 67d0 <malloc+0xb36>
    402c:	00002097          	auipc	ra,0x2
    4030:	bb6080e7          	jalr	-1098(ra) # 5be2 <printf>
    exit(1);
    4034:	4505                	li	a0,1
    4036:	00002097          	auipc	ra,0x2
    403a:	822080e7          	jalr	-2014(ra) # 5858 <exit>
      int fd = open("stopforking", 0);
    403e:	00004497          	auipc	s1,0x4
    4042:	85248493          	addi	s1,s1,-1966 # 7890 <malloc+0x1bf6>
    4046:	4581                	li	a1,0
    4048:	8526                	mv	a0,s1
    404a:	00002097          	auipc	ra,0x2
    404e:	84e080e7          	jalr	-1970(ra) # 5898 <open>
      if(fd >= 0){
    4052:	02055463          	bgez	a0,407a <forkforkfork+0xc6>
      if(fork() < 0){
    4056:	00001097          	auipc	ra,0x1
    405a:	7fa080e7          	jalr	2042(ra) # 5850 <fork>
    405e:	fe0554e3          	bgez	a0,4046 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4062:	20200593          	li	a1,514
    4066:	8526                	mv	a0,s1
    4068:	00002097          	auipc	ra,0x2
    406c:	830080e7          	jalr	-2000(ra) # 5898 <open>
    4070:	00002097          	auipc	ra,0x2
    4074:	810080e7          	jalr	-2032(ra) # 5880 <close>
    4078:	b7f9                	j	4046 <forkforkfork+0x92>
        exit(0);
    407a:	4501                	li	a0,0
    407c:	00001097          	auipc	ra,0x1
    4080:	7dc080e7          	jalr	2012(ra) # 5858 <exit>

0000000000004084 <killstatus>:
{
    4084:	7139                	addi	sp,sp,-64
    4086:	fc06                	sd	ra,56(sp)
    4088:	f822                	sd	s0,48(sp)
    408a:	f426                	sd	s1,40(sp)
    408c:	f04a                	sd	s2,32(sp)
    408e:	ec4e                	sd	s3,24(sp)
    4090:	e852                	sd	s4,16(sp)
    4092:	0080                	addi	s0,sp,64
    4094:	8a2a                	mv	s4,a0
    4096:	06400913          	li	s2,100
    if(xst != -1) {
    409a:	59fd                	li	s3,-1
    int pid1 = fork();
    409c:	00001097          	auipc	ra,0x1
    40a0:	7b4080e7          	jalr	1972(ra) # 5850 <fork>
    40a4:	84aa                	mv	s1,a0
    if(pid1 < 0){
    40a6:	02054f63          	bltz	a0,40e4 <killstatus+0x60>
    if(pid1 == 0){
    40aa:	c939                	beqz	a0,4100 <killstatus+0x7c>
    sleep(1);
    40ac:	4505                	li	a0,1
    40ae:	00002097          	auipc	ra,0x2
    40b2:	83a080e7          	jalr	-1990(ra) # 58e8 <sleep>
    kill(pid1);
    40b6:	8526                	mv	a0,s1
    40b8:	00001097          	auipc	ra,0x1
    40bc:	7d0080e7          	jalr	2000(ra) # 5888 <kill>
    wait(&xst);
    40c0:	fcc40513          	addi	a0,s0,-52
    40c4:	00001097          	auipc	ra,0x1
    40c8:	79c080e7          	jalr	1948(ra) # 5860 <wait>
    if(xst != -1) {
    40cc:	fcc42783          	lw	a5,-52(s0)
    40d0:	03379d63          	bne	a5,s3,410a <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    40d4:	397d                	addiw	s2,s2,-1
    40d6:	fc0913e3          	bnez	s2,409c <killstatus+0x18>
  exit(0);
    40da:	4501                	li	a0,0
    40dc:	00001097          	auipc	ra,0x1
    40e0:	77c080e7          	jalr	1916(ra) # 5858 <exit>
      printf("%s: fork failed\n", s);
    40e4:	85d2                	mv	a1,s4
    40e6:	00002517          	auipc	a0,0x2
    40ea:	52a50513          	addi	a0,a0,1322 # 6610 <malloc+0x976>
    40ee:	00002097          	auipc	ra,0x2
    40f2:	af4080e7          	jalr	-1292(ra) # 5be2 <printf>
      exit(1);
    40f6:	4505                	li	a0,1
    40f8:	00001097          	auipc	ra,0x1
    40fc:	760080e7          	jalr	1888(ra) # 5858 <exit>
        getpid();
    4100:	00001097          	auipc	ra,0x1
    4104:	7d8080e7          	jalr	2008(ra) # 58d8 <getpid>
      while(1) {
    4108:	bfe5                	j	4100 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    410a:	85d2                	mv	a1,s4
    410c:	00003517          	auipc	a0,0x3
    4110:	79450513          	addi	a0,a0,1940 # 78a0 <malloc+0x1c06>
    4114:	00002097          	auipc	ra,0x2
    4118:	ace080e7          	jalr	-1330(ra) # 5be2 <printf>
       exit(1);
    411c:	4505                	li	a0,1
    411e:	00001097          	auipc	ra,0x1
    4122:	73a080e7          	jalr	1850(ra) # 5858 <exit>

0000000000004126 <preempt>:
{
    4126:	7139                	addi	sp,sp,-64
    4128:	fc06                	sd	ra,56(sp)
    412a:	f822                	sd	s0,48(sp)
    412c:	f426                	sd	s1,40(sp)
    412e:	f04a                	sd	s2,32(sp)
    4130:	ec4e                	sd	s3,24(sp)
    4132:	e852                	sd	s4,16(sp)
    4134:	0080                	addi	s0,sp,64
    4136:	892a                	mv	s2,a0
  pid1 = fork();
    4138:	00001097          	auipc	ra,0x1
    413c:	718080e7          	jalr	1816(ra) # 5850 <fork>
  if(pid1 < 0) {
    4140:	00054563          	bltz	a0,414a <preempt+0x24>
    4144:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4146:	e105                	bnez	a0,4166 <preempt+0x40>
    for(;;)
    4148:	a001                	j	4148 <preempt+0x22>
    printf("%s: fork failed", s);
    414a:	85ca                	mv	a1,s2
    414c:	00002517          	auipc	a0,0x2
    4150:	68450513          	addi	a0,a0,1668 # 67d0 <malloc+0xb36>
    4154:	00002097          	auipc	ra,0x2
    4158:	a8e080e7          	jalr	-1394(ra) # 5be2 <printf>
    exit(1);
    415c:	4505                	li	a0,1
    415e:	00001097          	auipc	ra,0x1
    4162:	6fa080e7          	jalr	1786(ra) # 5858 <exit>
  pid2 = fork();
    4166:	00001097          	auipc	ra,0x1
    416a:	6ea080e7          	jalr	1770(ra) # 5850 <fork>
    416e:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4170:	00054463          	bltz	a0,4178 <preempt+0x52>
  if(pid2 == 0)
    4174:	e105                	bnez	a0,4194 <preempt+0x6e>
    for(;;)
    4176:	a001                	j	4176 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4178:	85ca                	mv	a1,s2
    417a:	00002517          	auipc	a0,0x2
    417e:	49650513          	addi	a0,a0,1174 # 6610 <malloc+0x976>
    4182:	00002097          	auipc	ra,0x2
    4186:	a60080e7          	jalr	-1440(ra) # 5be2 <printf>
    exit(1);
    418a:	4505                	li	a0,1
    418c:	00001097          	auipc	ra,0x1
    4190:	6cc080e7          	jalr	1740(ra) # 5858 <exit>
  pipe(pfds);
    4194:	fc840513          	addi	a0,s0,-56
    4198:	00001097          	auipc	ra,0x1
    419c:	6d0080e7          	jalr	1744(ra) # 5868 <pipe>
  pid3 = fork();
    41a0:	00001097          	auipc	ra,0x1
    41a4:	6b0080e7          	jalr	1712(ra) # 5850 <fork>
    41a8:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    41aa:	02054e63          	bltz	a0,41e6 <preempt+0xc0>
  if(pid3 == 0){
    41ae:	e525                	bnez	a0,4216 <preempt+0xf0>
    close(pfds[0]);
    41b0:	fc842503          	lw	a0,-56(s0)
    41b4:	00001097          	auipc	ra,0x1
    41b8:	6cc080e7          	jalr	1740(ra) # 5880 <close>
    if(write(pfds[1], "x", 1) != 1)
    41bc:	4605                	li	a2,1
    41be:	00002597          	auipc	a1,0x2
    41c2:	c6a58593          	addi	a1,a1,-918 # 5e28 <malloc+0x18e>
    41c6:	fcc42503          	lw	a0,-52(s0)
    41ca:	00001097          	auipc	ra,0x1
    41ce:	6ae080e7          	jalr	1710(ra) # 5878 <write>
    41d2:	4785                	li	a5,1
    41d4:	02f51763          	bne	a0,a5,4202 <preempt+0xdc>
    close(pfds[1]);
    41d8:	fcc42503          	lw	a0,-52(s0)
    41dc:	00001097          	auipc	ra,0x1
    41e0:	6a4080e7          	jalr	1700(ra) # 5880 <close>
    for(;;)
    41e4:	a001                	j	41e4 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    41e6:	85ca                	mv	a1,s2
    41e8:	00002517          	auipc	a0,0x2
    41ec:	42850513          	addi	a0,a0,1064 # 6610 <malloc+0x976>
    41f0:	00002097          	auipc	ra,0x2
    41f4:	9f2080e7          	jalr	-1550(ra) # 5be2 <printf>
     exit(1);
    41f8:	4505                	li	a0,1
    41fa:	00001097          	auipc	ra,0x1
    41fe:	65e080e7          	jalr	1630(ra) # 5858 <exit>
      printf("%s: preempt write error", s);
    4202:	85ca                	mv	a1,s2
    4204:	00003517          	auipc	a0,0x3
    4208:	6bc50513          	addi	a0,a0,1724 # 78c0 <malloc+0x1c26>
    420c:	00002097          	auipc	ra,0x2
    4210:	9d6080e7          	jalr	-1578(ra) # 5be2 <printf>
    4214:	b7d1                	j	41d8 <preempt+0xb2>
  close(pfds[1]);
    4216:	fcc42503          	lw	a0,-52(s0)
    421a:	00001097          	auipc	ra,0x1
    421e:	666080e7          	jalr	1638(ra) # 5880 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4222:	660d                	lui	a2,0x3
    4224:	00008597          	auipc	a1,0x8
    4228:	bd458593          	addi	a1,a1,-1068 # bdf8 <buf>
    422c:	fc842503          	lw	a0,-56(s0)
    4230:	00001097          	auipc	ra,0x1
    4234:	640080e7          	jalr	1600(ra) # 5870 <read>
    4238:	4785                	li	a5,1
    423a:	02f50363          	beq	a0,a5,4260 <preempt+0x13a>
    printf("%s: preempt read error", s);
    423e:	85ca                	mv	a1,s2
    4240:	00003517          	auipc	a0,0x3
    4244:	69850513          	addi	a0,a0,1688 # 78d8 <malloc+0x1c3e>
    4248:	00002097          	auipc	ra,0x2
    424c:	99a080e7          	jalr	-1638(ra) # 5be2 <printf>
}
    4250:	70e2                	ld	ra,56(sp)
    4252:	7442                	ld	s0,48(sp)
    4254:	74a2                	ld	s1,40(sp)
    4256:	7902                	ld	s2,32(sp)
    4258:	69e2                	ld	s3,24(sp)
    425a:	6a42                	ld	s4,16(sp)
    425c:	6121                	addi	sp,sp,64
    425e:	8082                	ret
  close(pfds[0]);
    4260:	fc842503          	lw	a0,-56(s0)
    4264:	00001097          	auipc	ra,0x1
    4268:	61c080e7          	jalr	1564(ra) # 5880 <close>
  printf("kill... ");
    426c:	00003517          	auipc	a0,0x3
    4270:	68450513          	addi	a0,a0,1668 # 78f0 <malloc+0x1c56>
    4274:	00002097          	auipc	ra,0x2
    4278:	96e080e7          	jalr	-1682(ra) # 5be2 <printf>
  kill(pid1);
    427c:	8526                	mv	a0,s1
    427e:	00001097          	auipc	ra,0x1
    4282:	60a080e7          	jalr	1546(ra) # 5888 <kill>
  kill(pid2);
    4286:	854e                	mv	a0,s3
    4288:	00001097          	auipc	ra,0x1
    428c:	600080e7          	jalr	1536(ra) # 5888 <kill>
  kill(pid3);
    4290:	8552                	mv	a0,s4
    4292:	00001097          	auipc	ra,0x1
    4296:	5f6080e7          	jalr	1526(ra) # 5888 <kill>
  printf("wait... ");
    429a:	00003517          	auipc	a0,0x3
    429e:	66650513          	addi	a0,a0,1638 # 7900 <malloc+0x1c66>
    42a2:	00002097          	auipc	ra,0x2
    42a6:	940080e7          	jalr	-1728(ra) # 5be2 <printf>
  wait(0);
    42aa:	4501                	li	a0,0
    42ac:	00001097          	auipc	ra,0x1
    42b0:	5b4080e7          	jalr	1460(ra) # 5860 <wait>
  wait(0);
    42b4:	4501                	li	a0,0
    42b6:	00001097          	auipc	ra,0x1
    42ba:	5aa080e7          	jalr	1450(ra) # 5860 <wait>
  wait(0);
    42be:	4501                	li	a0,0
    42c0:	00001097          	auipc	ra,0x1
    42c4:	5a0080e7          	jalr	1440(ra) # 5860 <wait>
    42c8:	b761                	j	4250 <preempt+0x12a>

00000000000042ca <reparent>:
{
    42ca:	7179                	addi	sp,sp,-48
    42cc:	f406                	sd	ra,40(sp)
    42ce:	f022                	sd	s0,32(sp)
    42d0:	ec26                	sd	s1,24(sp)
    42d2:	e84a                	sd	s2,16(sp)
    42d4:	e44e                	sd	s3,8(sp)
    42d6:	e052                	sd	s4,0(sp)
    42d8:	1800                	addi	s0,sp,48
    42da:	89aa                	mv	s3,a0
  int master_pid = getpid();
    42dc:	00001097          	auipc	ra,0x1
    42e0:	5fc080e7          	jalr	1532(ra) # 58d8 <getpid>
    42e4:	8a2a                	mv	s4,a0
    42e6:	0c800913          	li	s2,200
    int pid = fork();
    42ea:	00001097          	auipc	ra,0x1
    42ee:	566080e7          	jalr	1382(ra) # 5850 <fork>
    42f2:	84aa                	mv	s1,a0
    if(pid < 0){
    42f4:	02054263          	bltz	a0,4318 <reparent+0x4e>
    if(pid){
    42f8:	cd21                	beqz	a0,4350 <reparent+0x86>
      if(wait(0) != pid){
    42fa:	4501                	li	a0,0
    42fc:	00001097          	auipc	ra,0x1
    4300:	564080e7          	jalr	1380(ra) # 5860 <wait>
    4304:	02951863          	bne	a0,s1,4334 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4308:	397d                	addiw	s2,s2,-1
    430a:	fe0910e3          	bnez	s2,42ea <reparent+0x20>
  exit(0);
    430e:	4501                	li	a0,0
    4310:	00001097          	auipc	ra,0x1
    4314:	548080e7          	jalr	1352(ra) # 5858 <exit>
      printf("%s: fork failed\n", s);
    4318:	85ce                	mv	a1,s3
    431a:	00002517          	auipc	a0,0x2
    431e:	2f650513          	addi	a0,a0,758 # 6610 <malloc+0x976>
    4322:	00002097          	auipc	ra,0x2
    4326:	8c0080e7          	jalr	-1856(ra) # 5be2 <printf>
      exit(1);
    432a:	4505                	li	a0,1
    432c:	00001097          	auipc	ra,0x1
    4330:	52c080e7          	jalr	1324(ra) # 5858 <exit>
        printf("%s: wait wrong pid\n", s);
    4334:	85ce                	mv	a1,s3
    4336:	00002517          	auipc	a0,0x2
    433a:	46250513          	addi	a0,a0,1122 # 6798 <malloc+0xafe>
    433e:	00002097          	auipc	ra,0x2
    4342:	8a4080e7          	jalr	-1884(ra) # 5be2 <printf>
        exit(1);
    4346:	4505                	li	a0,1
    4348:	00001097          	auipc	ra,0x1
    434c:	510080e7          	jalr	1296(ra) # 5858 <exit>
      int pid2 = fork();
    4350:	00001097          	auipc	ra,0x1
    4354:	500080e7          	jalr	1280(ra) # 5850 <fork>
      if(pid2 < 0){
    4358:	00054763          	bltz	a0,4366 <reparent+0x9c>
      exit(0);
    435c:	4501                	li	a0,0
    435e:	00001097          	auipc	ra,0x1
    4362:	4fa080e7          	jalr	1274(ra) # 5858 <exit>
        kill(master_pid);
    4366:	8552                	mv	a0,s4
    4368:	00001097          	auipc	ra,0x1
    436c:	520080e7          	jalr	1312(ra) # 5888 <kill>
        exit(1);
    4370:	4505                	li	a0,1
    4372:	00001097          	auipc	ra,0x1
    4376:	4e6080e7          	jalr	1254(ra) # 5858 <exit>

000000000000437a <sbrkfail>:
{
    437a:	7119                	addi	sp,sp,-128
    437c:	fc86                	sd	ra,120(sp)
    437e:	f8a2                	sd	s0,112(sp)
    4380:	f4a6                	sd	s1,104(sp)
    4382:	f0ca                	sd	s2,96(sp)
    4384:	ecce                	sd	s3,88(sp)
    4386:	e8d2                	sd	s4,80(sp)
    4388:	e4d6                	sd	s5,72(sp)
    438a:	0100                	addi	s0,sp,128
    438c:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    438e:	fb040513          	addi	a0,s0,-80
    4392:	00001097          	auipc	ra,0x1
    4396:	4d6080e7          	jalr	1238(ra) # 5868 <pipe>
    439a:	e901                	bnez	a0,43aa <sbrkfail+0x30>
    439c:	f8040493          	addi	s1,s0,-128
    43a0:	fa840993          	addi	s3,s0,-88
    43a4:	8926                	mv	s2,s1
    if(pids[i] != -1)
    43a6:	5a7d                	li	s4,-1
    43a8:	a085                	j	4408 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    43aa:	85d6                	mv	a1,s5
    43ac:	00002517          	auipc	a0,0x2
    43b0:	36c50513          	addi	a0,a0,876 # 6718 <malloc+0xa7e>
    43b4:	00002097          	auipc	ra,0x2
    43b8:	82e080e7          	jalr	-2002(ra) # 5be2 <printf>
    exit(1);
    43bc:	4505                	li	a0,1
    43be:	00001097          	auipc	ra,0x1
    43c2:	49a080e7          	jalr	1178(ra) # 5858 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    43c6:	00001097          	auipc	ra,0x1
    43ca:	51a080e7          	jalr	1306(ra) # 58e0 <sbrk>
    43ce:	064007b7          	lui	a5,0x6400
    43d2:	40a7853b          	subw	a0,a5,a0
    43d6:	00001097          	auipc	ra,0x1
    43da:	50a080e7          	jalr	1290(ra) # 58e0 <sbrk>
      write(fds[1], "x", 1);
    43de:	4605                	li	a2,1
    43e0:	00002597          	auipc	a1,0x2
    43e4:	a4858593          	addi	a1,a1,-1464 # 5e28 <malloc+0x18e>
    43e8:	fb442503          	lw	a0,-76(s0)
    43ec:	00001097          	auipc	ra,0x1
    43f0:	48c080e7          	jalr	1164(ra) # 5878 <write>
      for(;;) sleep(1000);
    43f4:	3e800513          	li	a0,1000
    43f8:	00001097          	auipc	ra,0x1
    43fc:	4f0080e7          	jalr	1264(ra) # 58e8 <sleep>
    4400:	bfd5                	j	43f4 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4402:	0911                	addi	s2,s2,4
    4404:	03390563          	beq	s2,s3,442e <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4408:	00001097          	auipc	ra,0x1
    440c:	448080e7          	jalr	1096(ra) # 5850 <fork>
    4410:	00a92023          	sw	a0,0(s2)
    4414:	d94d                	beqz	a0,43c6 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4416:	ff4506e3          	beq	a0,s4,4402 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    441a:	4605                	li	a2,1
    441c:	faf40593          	addi	a1,s0,-81
    4420:	fb042503          	lw	a0,-80(s0)
    4424:	00001097          	auipc	ra,0x1
    4428:	44c080e7          	jalr	1100(ra) # 5870 <read>
    442c:	bfd9                	j	4402 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    442e:	6505                	lui	a0,0x1
    4430:	00001097          	auipc	ra,0x1
    4434:	4b0080e7          	jalr	1200(ra) # 58e0 <sbrk>
    4438:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    443a:	597d                	li	s2,-1
    443c:	a021                	j	4444 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    443e:	0491                	addi	s1,s1,4
    4440:	01348f63          	beq	s1,s3,445e <sbrkfail+0xe4>
    if(pids[i] == -1)
    4444:	4088                	lw	a0,0(s1)
    4446:	ff250ce3          	beq	a0,s2,443e <sbrkfail+0xc4>
    kill(pids[i]);
    444a:	00001097          	auipc	ra,0x1
    444e:	43e080e7          	jalr	1086(ra) # 5888 <kill>
    wait(0);
    4452:	4501                	li	a0,0
    4454:	00001097          	auipc	ra,0x1
    4458:	40c080e7          	jalr	1036(ra) # 5860 <wait>
    445c:	b7cd                	j	443e <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    445e:	57fd                	li	a5,-1
    4460:	04fa0163          	beq	s4,a5,44a2 <sbrkfail+0x128>
  pid = fork();
    4464:	00001097          	auipc	ra,0x1
    4468:	3ec080e7          	jalr	1004(ra) # 5850 <fork>
    446c:	84aa                	mv	s1,a0
  if(pid < 0){
    446e:	04054863          	bltz	a0,44be <sbrkfail+0x144>
  if(pid == 0){
    4472:	c525                	beqz	a0,44da <sbrkfail+0x160>
  wait(&xstatus);
    4474:	fbc40513          	addi	a0,s0,-68
    4478:	00001097          	auipc	ra,0x1
    447c:	3e8080e7          	jalr	1000(ra) # 5860 <wait>
  if(xstatus != -1 && xstatus != 2)
    4480:	fbc42783          	lw	a5,-68(s0)
    4484:	577d                	li	a4,-1
    4486:	00e78563          	beq	a5,a4,4490 <sbrkfail+0x116>
    448a:	4709                	li	a4,2
    448c:	08e79d63          	bne	a5,a4,4526 <sbrkfail+0x1ac>
}
    4490:	70e6                	ld	ra,120(sp)
    4492:	7446                	ld	s0,112(sp)
    4494:	74a6                	ld	s1,104(sp)
    4496:	7906                	ld	s2,96(sp)
    4498:	69e6                	ld	s3,88(sp)
    449a:	6a46                	ld	s4,80(sp)
    449c:	6aa6                	ld	s5,72(sp)
    449e:	6109                	addi	sp,sp,128
    44a0:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    44a2:	85d6                	mv	a1,s5
    44a4:	00003517          	auipc	a0,0x3
    44a8:	46c50513          	addi	a0,a0,1132 # 7910 <malloc+0x1c76>
    44ac:	00001097          	auipc	ra,0x1
    44b0:	736080e7          	jalr	1846(ra) # 5be2 <printf>
    exit(1);
    44b4:	4505                	li	a0,1
    44b6:	00001097          	auipc	ra,0x1
    44ba:	3a2080e7          	jalr	930(ra) # 5858 <exit>
    printf("%s: fork failed\n", s);
    44be:	85d6                	mv	a1,s5
    44c0:	00002517          	auipc	a0,0x2
    44c4:	15050513          	addi	a0,a0,336 # 6610 <malloc+0x976>
    44c8:	00001097          	auipc	ra,0x1
    44cc:	71a080e7          	jalr	1818(ra) # 5be2 <printf>
    exit(1);
    44d0:	4505                	li	a0,1
    44d2:	00001097          	auipc	ra,0x1
    44d6:	386080e7          	jalr	902(ra) # 5858 <exit>
    a = sbrk(0);
    44da:	4501                	li	a0,0
    44dc:	00001097          	auipc	ra,0x1
    44e0:	404080e7          	jalr	1028(ra) # 58e0 <sbrk>
    44e4:	892a                	mv	s2,a0
    sbrk(10*BIG);
    44e6:	3e800537          	lui	a0,0x3e800
    44ea:	00001097          	auipc	ra,0x1
    44ee:	3f6080e7          	jalr	1014(ra) # 58e0 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    44f2:	87ca                	mv	a5,s2
    44f4:	3e800737          	lui	a4,0x3e800
    44f8:	993a                	add	s2,s2,a4
    44fa:	6705                	lui	a4,0x1
      n += *(a+i);
    44fc:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f11f8>
    4500:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4502:	97ba                	add	a5,a5,a4
    4504:	ff279ce3          	bne	a5,s2,44fc <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4508:	8626                	mv	a2,s1
    450a:	85d6                	mv	a1,s5
    450c:	00003517          	auipc	a0,0x3
    4510:	42450513          	addi	a0,a0,1060 # 7930 <malloc+0x1c96>
    4514:	00001097          	auipc	ra,0x1
    4518:	6ce080e7          	jalr	1742(ra) # 5be2 <printf>
    exit(1);
    451c:	4505                	li	a0,1
    451e:	00001097          	auipc	ra,0x1
    4522:	33a080e7          	jalr	826(ra) # 5858 <exit>
    exit(1);
    4526:	4505                	li	a0,1
    4528:	00001097          	auipc	ra,0x1
    452c:	330080e7          	jalr	816(ra) # 5858 <exit>

0000000000004530 <mem>:
{
    4530:	7139                	addi	sp,sp,-64
    4532:	fc06                	sd	ra,56(sp)
    4534:	f822                	sd	s0,48(sp)
    4536:	f426                	sd	s1,40(sp)
    4538:	f04a                	sd	s2,32(sp)
    453a:	ec4e                	sd	s3,24(sp)
    453c:	0080                	addi	s0,sp,64
    453e:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4540:	00001097          	auipc	ra,0x1
    4544:	310080e7          	jalr	784(ra) # 5850 <fork>
    m1 = 0;
    4548:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    454a:	6909                	lui	s2,0x2
    454c:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0xb1>
  if((pid = fork()) == 0){
    4550:	c115                	beqz	a0,4574 <mem+0x44>
    wait(&xstatus);
    4552:	fcc40513          	addi	a0,s0,-52
    4556:	00001097          	auipc	ra,0x1
    455a:	30a080e7          	jalr	778(ra) # 5860 <wait>
    if(xstatus == -1){
    455e:	fcc42503          	lw	a0,-52(s0)
    4562:	57fd                	li	a5,-1
    4564:	06f50363          	beq	a0,a5,45ca <mem+0x9a>
    exit(xstatus);
    4568:	00001097          	auipc	ra,0x1
    456c:	2f0080e7          	jalr	752(ra) # 5858 <exit>
      *(char**)m2 = m1;
    4570:	e104                	sd	s1,0(a0)
      m1 = m2;
    4572:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4574:	854a                	mv	a0,s2
    4576:	00001097          	auipc	ra,0x1
    457a:	724080e7          	jalr	1828(ra) # 5c9a <malloc>
    457e:	f96d                	bnez	a0,4570 <mem+0x40>
    while(m1){
    4580:	c881                	beqz	s1,4590 <mem+0x60>
      m2 = *(char**)m1;
    4582:	8526                	mv	a0,s1
    4584:	6084                	ld	s1,0(s1)
      free(m1);
    4586:	00001097          	auipc	ra,0x1
    458a:	692080e7          	jalr	1682(ra) # 5c18 <free>
    while(m1){
    458e:	f8f5                	bnez	s1,4582 <mem+0x52>
    m1 = malloc(1024*20);
    4590:	6515                	lui	a0,0x5
    4592:	00001097          	auipc	ra,0x1
    4596:	708080e7          	jalr	1800(ra) # 5c9a <malloc>
    if(m1 == 0){
    459a:	c911                	beqz	a0,45ae <mem+0x7e>
    free(m1);
    459c:	00001097          	auipc	ra,0x1
    45a0:	67c080e7          	jalr	1660(ra) # 5c18 <free>
    exit(0);
    45a4:	4501                	li	a0,0
    45a6:	00001097          	auipc	ra,0x1
    45aa:	2b2080e7          	jalr	690(ra) # 5858 <exit>
      printf("couldn't allocate mem?!!\n", s);
    45ae:	85ce                	mv	a1,s3
    45b0:	00003517          	auipc	a0,0x3
    45b4:	3b050513          	addi	a0,a0,944 # 7960 <malloc+0x1cc6>
    45b8:	00001097          	auipc	ra,0x1
    45bc:	62a080e7          	jalr	1578(ra) # 5be2 <printf>
      exit(1);
    45c0:	4505                	li	a0,1
    45c2:	00001097          	auipc	ra,0x1
    45c6:	296080e7          	jalr	662(ra) # 5858 <exit>
      exit(0);
    45ca:	4501                	li	a0,0
    45cc:	00001097          	auipc	ra,0x1
    45d0:	28c080e7          	jalr	652(ra) # 5858 <exit>

00000000000045d4 <sharedfd>:
{
    45d4:	7159                	addi	sp,sp,-112
    45d6:	f486                	sd	ra,104(sp)
    45d8:	f0a2                	sd	s0,96(sp)
    45da:	eca6                	sd	s1,88(sp)
    45dc:	e8ca                	sd	s2,80(sp)
    45de:	e4ce                	sd	s3,72(sp)
    45e0:	e0d2                	sd	s4,64(sp)
    45e2:	fc56                	sd	s5,56(sp)
    45e4:	f85a                	sd	s6,48(sp)
    45e6:	f45e                	sd	s7,40(sp)
    45e8:	1880                	addi	s0,sp,112
    45ea:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    45ec:	00003517          	auipc	a0,0x3
    45f0:	39450513          	addi	a0,a0,916 # 7980 <malloc+0x1ce6>
    45f4:	00001097          	auipc	ra,0x1
    45f8:	2b4080e7          	jalr	692(ra) # 58a8 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    45fc:	20200593          	li	a1,514
    4600:	00003517          	auipc	a0,0x3
    4604:	38050513          	addi	a0,a0,896 # 7980 <malloc+0x1ce6>
    4608:	00001097          	auipc	ra,0x1
    460c:	290080e7          	jalr	656(ra) # 5898 <open>
  if(fd < 0){
    4610:	04054a63          	bltz	a0,4664 <sharedfd+0x90>
    4614:	892a                	mv	s2,a0
  pid = fork();
    4616:	00001097          	auipc	ra,0x1
    461a:	23a080e7          	jalr	570(ra) # 5850 <fork>
    461e:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4620:	06300593          	li	a1,99
    4624:	c119                	beqz	a0,462a <sharedfd+0x56>
    4626:	07000593          	li	a1,112
    462a:	4629                	li	a2,10
    462c:	fa040513          	addi	a0,s0,-96
    4630:	00001097          	auipc	ra,0x1
    4634:	018080e7          	jalr	24(ra) # 5648 <memset>
    4638:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    463c:	4629                	li	a2,10
    463e:	fa040593          	addi	a1,s0,-96
    4642:	854a                	mv	a0,s2
    4644:	00001097          	auipc	ra,0x1
    4648:	234080e7          	jalr	564(ra) # 5878 <write>
    464c:	47a9                	li	a5,10
    464e:	02f51963          	bne	a0,a5,4680 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4652:	34fd                	addiw	s1,s1,-1
    4654:	f4e5                	bnez	s1,463c <sharedfd+0x68>
  if(pid == 0) {
    4656:	04099363          	bnez	s3,469c <sharedfd+0xc8>
    exit(0);
    465a:	4501                	li	a0,0
    465c:	00001097          	auipc	ra,0x1
    4660:	1fc080e7          	jalr	508(ra) # 5858 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4664:	85d2                	mv	a1,s4
    4666:	00003517          	auipc	a0,0x3
    466a:	32a50513          	addi	a0,a0,810 # 7990 <malloc+0x1cf6>
    466e:	00001097          	auipc	ra,0x1
    4672:	574080e7          	jalr	1396(ra) # 5be2 <printf>
    exit(1);
    4676:	4505                	li	a0,1
    4678:	00001097          	auipc	ra,0x1
    467c:	1e0080e7          	jalr	480(ra) # 5858 <exit>
      printf("%s: write sharedfd failed\n", s);
    4680:	85d2                	mv	a1,s4
    4682:	00003517          	auipc	a0,0x3
    4686:	33650513          	addi	a0,a0,822 # 79b8 <malloc+0x1d1e>
    468a:	00001097          	auipc	ra,0x1
    468e:	558080e7          	jalr	1368(ra) # 5be2 <printf>
      exit(1);
    4692:	4505                	li	a0,1
    4694:	00001097          	auipc	ra,0x1
    4698:	1c4080e7          	jalr	452(ra) # 5858 <exit>
    wait(&xstatus);
    469c:	f9c40513          	addi	a0,s0,-100
    46a0:	00001097          	auipc	ra,0x1
    46a4:	1c0080e7          	jalr	448(ra) # 5860 <wait>
    if(xstatus != 0)
    46a8:	f9c42983          	lw	s3,-100(s0)
    46ac:	00098763          	beqz	s3,46ba <sharedfd+0xe6>
      exit(xstatus);
    46b0:	854e                	mv	a0,s3
    46b2:	00001097          	auipc	ra,0x1
    46b6:	1a6080e7          	jalr	422(ra) # 5858 <exit>
  close(fd);
    46ba:	854a                	mv	a0,s2
    46bc:	00001097          	auipc	ra,0x1
    46c0:	1c4080e7          	jalr	452(ra) # 5880 <close>
  fd = open("sharedfd", 0);
    46c4:	4581                	li	a1,0
    46c6:	00003517          	auipc	a0,0x3
    46ca:	2ba50513          	addi	a0,a0,698 # 7980 <malloc+0x1ce6>
    46ce:	00001097          	auipc	ra,0x1
    46d2:	1ca080e7          	jalr	458(ra) # 5898 <open>
    46d6:	8baa                	mv	s7,a0
  nc = np = 0;
    46d8:	8ace                	mv	s5,s3
  if(fd < 0){
    46da:	02054563          	bltz	a0,4704 <sharedfd+0x130>
    46de:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    46e2:	06300493          	li	s1,99
      if(buf[i] == 'p')
    46e6:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    46ea:	4629                	li	a2,10
    46ec:	fa040593          	addi	a1,s0,-96
    46f0:	855e                	mv	a0,s7
    46f2:	00001097          	auipc	ra,0x1
    46f6:	17e080e7          	jalr	382(ra) # 5870 <read>
    46fa:	02a05f63          	blez	a0,4738 <sharedfd+0x164>
    46fe:	fa040793          	addi	a5,s0,-96
    4702:	a01d                	j	4728 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4704:	85d2                	mv	a1,s4
    4706:	00003517          	auipc	a0,0x3
    470a:	2d250513          	addi	a0,a0,722 # 79d8 <malloc+0x1d3e>
    470e:	00001097          	auipc	ra,0x1
    4712:	4d4080e7          	jalr	1236(ra) # 5be2 <printf>
    exit(1);
    4716:	4505                	li	a0,1
    4718:	00001097          	auipc	ra,0x1
    471c:	140080e7          	jalr	320(ra) # 5858 <exit>
        nc++;
    4720:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4722:	0785                	addi	a5,a5,1
    4724:	fd2783e3          	beq	a5,s2,46ea <sharedfd+0x116>
      if(buf[i] == 'c')
    4728:	0007c703          	lbu	a4,0(a5)
    472c:	fe970ae3          	beq	a4,s1,4720 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4730:	ff6719e3          	bne	a4,s6,4722 <sharedfd+0x14e>
        np++;
    4734:	2a85                	addiw	s5,s5,1
    4736:	b7f5                	j	4722 <sharedfd+0x14e>
  close(fd);
    4738:	855e                	mv	a0,s7
    473a:	00001097          	auipc	ra,0x1
    473e:	146080e7          	jalr	326(ra) # 5880 <close>
  unlink("sharedfd");
    4742:	00003517          	auipc	a0,0x3
    4746:	23e50513          	addi	a0,a0,574 # 7980 <malloc+0x1ce6>
    474a:	00001097          	auipc	ra,0x1
    474e:	15e080e7          	jalr	350(ra) # 58a8 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4752:	6789                	lui	a5,0x2
    4754:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0xb0>
    4758:	00f99763          	bne	s3,a5,4766 <sharedfd+0x192>
    475c:	6789                	lui	a5,0x2
    475e:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0xb0>
    4762:	02fa8063          	beq	s5,a5,4782 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4766:	85d2                	mv	a1,s4
    4768:	00003517          	auipc	a0,0x3
    476c:	29850513          	addi	a0,a0,664 # 7a00 <malloc+0x1d66>
    4770:	00001097          	auipc	ra,0x1
    4774:	472080e7          	jalr	1138(ra) # 5be2 <printf>
    exit(1);
    4778:	4505                	li	a0,1
    477a:	00001097          	auipc	ra,0x1
    477e:	0de080e7          	jalr	222(ra) # 5858 <exit>
    exit(0);
    4782:	4501                	li	a0,0
    4784:	00001097          	auipc	ra,0x1
    4788:	0d4080e7          	jalr	212(ra) # 5858 <exit>

000000000000478c <fourfiles>:
{
    478c:	7171                	addi	sp,sp,-176
    478e:	f506                	sd	ra,168(sp)
    4790:	f122                	sd	s0,160(sp)
    4792:	ed26                	sd	s1,152(sp)
    4794:	e94a                	sd	s2,144(sp)
    4796:	e54e                	sd	s3,136(sp)
    4798:	e152                	sd	s4,128(sp)
    479a:	fcd6                	sd	s5,120(sp)
    479c:	f8da                	sd	s6,112(sp)
    479e:	f4de                	sd	s7,104(sp)
    47a0:	f0e2                	sd	s8,96(sp)
    47a2:	ece6                	sd	s9,88(sp)
    47a4:	e8ea                	sd	s10,80(sp)
    47a6:	e4ee                	sd	s11,72(sp)
    47a8:	1900                	addi	s0,sp,176
    47aa:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    47ae:	00003797          	auipc	a5,0x3
    47b2:	26a78793          	addi	a5,a5,618 # 7a18 <malloc+0x1d7e>
    47b6:	f6f43823          	sd	a5,-144(s0)
    47ba:	00003797          	auipc	a5,0x3
    47be:	26678793          	addi	a5,a5,614 # 7a20 <malloc+0x1d86>
    47c2:	f6f43c23          	sd	a5,-136(s0)
    47c6:	00003797          	auipc	a5,0x3
    47ca:	26278793          	addi	a5,a5,610 # 7a28 <malloc+0x1d8e>
    47ce:	f8f43023          	sd	a5,-128(s0)
    47d2:	00003797          	auipc	a5,0x3
    47d6:	25e78793          	addi	a5,a5,606 # 7a30 <malloc+0x1d96>
    47da:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    47de:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    47e2:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    47e4:	4481                	li	s1,0
    47e6:	4a11                	li	s4,4
    fname = names[pi];
    47e8:	00093983          	ld	s3,0(s2)
    unlink(fname);
    47ec:	854e                	mv	a0,s3
    47ee:	00001097          	auipc	ra,0x1
    47f2:	0ba080e7          	jalr	186(ra) # 58a8 <unlink>
    pid = fork();
    47f6:	00001097          	auipc	ra,0x1
    47fa:	05a080e7          	jalr	90(ra) # 5850 <fork>
    if(pid < 0){
    47fe:	04054463          	bltz	a0,4846 <fourfiles+0xba>
    if(pid == 0){
    4802:	c12d                	beqz	a0,4864 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    4804:	2485                	addiw	s1,s1,1
    4806:	0921                	addi	s2,s2,8
    4808:	ff4490e3          	bne	s1,s4,47e8 <fourfiles+0x5c>
    480c:	4491                	li	s1,4
    wait(&xstatus);
    480e:	f6c40513          	addi	a0,s0,-148
    4812:	00001097          	auipc	ra,0x1
    4816:	04e080e7          	jalr	78(ra) # 5860 <wait>
    if(xstatus != 0)
    481a:	f6c42b03          	lw	s6,-148(s0)
    481e:	0c0b1e63          	bnez	s6,48fa <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    4822:	34fd                	addiw	s1,s1,-1
    4824:	f4ed                	bnez	s1,480e <fourfiles+0x82>
    4826:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    482a:	00007a17          	auipc	s4,0x7
    482e:	5cea0a13          	addi	s4,s4,1486 # bdf8 <buf>
    4832:	00007a97          	auipc	s5,0x7
    4836:	5c7a8a93          	addi	s5,s5,1479 # bdf9 <buf+0x1>
    if(total != N*SZ){
    483a:	6d85                	lui	s11,0x1
    483c:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0x34>
  for(i = 0; i < NCHILD; i++){
    4840:	03400d13          	li	s10,52
    4844:	aa1d                	j	497a <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4846:	f5843583          	ld	a1,-168(s0)
    484a:	00002517          	auipc	a0,0x2
    484e:	1e650513          	addi	a0,a0,486 # 6a30 <malloc+0xd96>
    4852:	00001097          	auipc	ra,0x1
    4856:	390080e7          	jalr	912(ra) # 5be2 <printf>
      exit(1);
    485a:	4505                	li	a0,1
    485c:	00001097          	auipc	ra,0x1
    4860:	ffc080e7          	jalr	-4(ra) # 5858 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4864:	20200593          	li	a1,514
    4868:	854e                	mv	a0,s3
    486a:	00001097          	auipc	ra,0x1
    486e:	02e080e7          	jalr	46(ra) # 5898 <open>
    4872:	892a                	mv	s2,a0
      if(fd < 0){
    4874:	04054763          	bltz	a0,48c2 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    4878:	1f400613          	li	a2,500
    487c:	0304859b          	addiw	a1,s1,48
    4880:	00007517          	auipc	a0,0x7
    4884:	57850513          	addi	a0,a0,1400 # bdf8 <buf>
    4888:	00001097          	auipc	ra,0x1
    488c:	dc0080e7          	jalr	-576(ra) # 5648 <memset>
    4890:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4892:	00007997          	auipc	s3,0x7
    4896:	56698993          	addi	s3,s3,1382 # bdf8 <buf>
    489a:	1f400613          	li	a2,500
    489e:	85ce                	mv	a1,s3
    48a0:	854a                	mv	a0,s2
    48a2:	00001097          	auipc	ra,0x1
    48a6:	fd6080e7          	jalr	-42(ra) # 5878 <write>
    48aa:	85aa                	mv	a1,a0
    48ac:	1f400793          	li	a5,500
    48b0:	02f51863          	bne	a0,a5,48e0 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    48b4:	34fd                	addiw	s1,s1,-1
    48b6:	f0f5                	bnez	s1,489a <fourfiles+0x10e>
      exit(0);
    48b8:	4501                	li	a0,0
    48ba:	00001097          	auipc	ra,0x1
    48be:	f9e080e7          	jalr	-98(ra) # 5858 <exit>
        printf("create failed\n", s);
    48c2:	f5843583          	ld	a1,-168(s0)
    48c6:	00003517          	auipc	a0,0x3
    48ca:	17250513          	addi	a0,a0,370 # 7a38 <malloc+0x1d9e>
    48ce:	00001097          	auipc	ra,0x1
    48d2:	314080e7          	jalr	788(ra) # 5be2 <printf>
        exit(1);
    48d6:	4505                	li	a0,1
    48d8:	00001097          	auipc	ra,0x1
    48dc:	f80080e7          	jalr	-128(ra) # 5858 <exit>
          printf("write failed %d\n", n);
    48e0:	00003517          	auipc	a0,0x3
    48e4:	16850513          	addi	a0,a0,360 # 7a48 <malloc+0x1dae>
    48e8:	00001097          	auipc	ra,0x1
    48ec:	2fa080e7          	jalr	762(ra) # 5be2 <printf>
          exit(1);
    48f0:	4505                	li	a0,1
    48f2:	00001097          	auipc	ra,0x1
    48f6:	f66080e7          	jalr	-154(ra) # 5858 <exit>
      exit(xstatus);
    48fa:	855a                	mv	a0,s6
    48fc:	00001097          	auipc	ra,0x1
    4900:	f5c080e7          	jalr	-164(ra) # 5858 <exit>
          printf("wrong char\n", s);
    4904:	f5843583          	ld	a1,-168(s0)
    4908:	00003517          	auipc	a0,0x3
    490c:	15850513          	addi	a0,a0,344 # 7a60 <malloc+0x1dc6>
    4910:	00001097          	auipc	ra,0x1
    4914:	2d2080e7          	jalr	722(ra) # 5be2 <printf>
          exit(1);
    4918:	4505                	li	a0,1
    491a:	00001097          	auipc	ra,0x1
    491e:	f3e080e7          	jalr	-194(ra) # 5858 <exit>
      total += n;
    4922:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4926:	660d                	lui	a2,0x3
    4928:	85d2                	mv	a1,s4
    492a:	854e                	mv	a0,s3
    492c:	00001097          	auipc	ra,0x1
    4930:	f44080e7          	jalr	-188(ra) # 5870 <read>
    4934:	02a05363          	blez	a0,495a <fourfiles+0x1ce>
    4938:	00007797          	auipc	a5,0x7
    493c:	4c078793          	addi	a5,a5,1216 # bdf8 <buf>
    4940:	fff5069b          	addiw	a3,a0,-1
    4944:	1682                	slli	a3,a3,0x20
    4946:	9281                	srli	a3,a3,0x20
    4948:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    494a:	0007c703          	lbu	a4,0(a5)
    494e:	fa971be3          	bne	a4,s1,4904 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    4952:	0785                	addi	a5,a5,1
    4954:	fed79be3          	bne	a5,a3,494a <fourfiles+0x1be>
    4958:	b7e9                	j	4922 <fourfiles+0x196>
    close(fd);
    495a:	854e                	mv	a0,s3
    495c:	00001097          	auipc	ra,0x1
    4960:	f24080e7          	jalr	-220(ra) # 5880 <close>
    if(total != N*SZ){
    4964:	03b91863          	bne	s2,s11,4994 <fourfiles+0x208>
    unlink(fname);
    4968:	8566                	mv	a0,s9
    496a:	00001097          	auipc	ra,0x1
    496e:	f3e080e7          	jalr	-194(ra) # 58a8 <unlink>
  for(i = 0; i < NCHILD; i++){
    4972:	0c21                	addi	s8,s8,8
    4974:	2b85                	addiw	s7,s7,1
    4976:	03ab8d63          	beq	s7,s10,49b0 <fourfiles+0x224>
    fname = names[i];
    497a:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    497e:	4581                	li	a1,0
    4980:	8566                	mv	a0,s9
    4982:	00001097          	auipc	ra,0x1
    4986:	f16080e7          	jalr	-234(ra) # 5898 <open>
    498a:	89aa                	mv	s3,a0
    total = 0;
    498c:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    498e:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4992:	bf51                	j	4926 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4994:	85ca                	mv	a1,s2
    4996:	00003517          	auipc	a0,0x3
    499a:	0da50513          	addi	a0,a0,218 # 7a70 <malloc+0x1dd6>
    499e:	00001097          	auipc	ra,0x1
    49a2:	244080e7          	jalr	580(ra) # 5be2 <printf>
      exit(1);
    49a6:	4505                	li	a0,1
    49a8:	00001097          	auipc	ra,0x1
    49ac:	eb0080e7          	jalr	-336(ra) # 5858 <exit>
}
    49b0:	70aa                	ld	ra,168(sp)
    49b2:	740a                	ld	s0,160(sp)
    49b4:	64ea                	ld	s1,152(sp)
    49b6:	694a                	ld	s2,144(sp)
    49b8:	69aa                	ld	s3,136(sp)
    49ba:	6a0a                	ld	s4,128(sp)
    49bc:	7ae6                	ld	s5,120(sp)
    49be:	7b46                	ld	s6,112(sp)
    49c0:	7ba6                	ld	s7,104(sp)
    49c2:	7c06                	ld	s8,96(sp)
    49c4:	6ce6                	ld	s9,88(sp)
    49c6:	6d46                	ld	s10,80(sp)
    49c8:	6da6                	ld	s11,72(sp)
    49ca:	614d                	addi	sp,sp,176
    49cc:	8082                	ret

00000000000049ce <concreate>:
{
    49ce:	7135                	addi	sp,sp,-160
    49d0:	ed06                	sd	ra,152(sp)
    49d2:	e922                	sd	s0,144(sp)
    49d4:	e526                	sd	s1,136(sp)
    49d6:	e14a                	sd	s2,128(sp)
    49d8:	fcce                	sd	s3,120(sp)
    49da:	f8d2                	sd	s4,112(sp)
    49dc:	f4d6                	sd	s5,104(sp)
    49de:	f0da                	sd	s6,96(sp)
    49e0:	ecde                	sd	s7,88(sp)
    49e2:	1100                	addi	s0,sp,160
    49e4:	89aa                	mv	s3,a0
  file[0] = 'C';
    49e6:	04300793          	li	a5,67
    49ea:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    49ee:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    49f2:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    49f4:	4b0d                	li	s6,3
    49f6:	4a85                	li	s5,1
      link("C0", file);
    49f8:	00003b97          	auipc	s7,0x3
    49fc:	090b8b93          	addi	s7,s7,144 # 7a88 <malloc+0x1dee>
  for(i = 0; i < N; i++){
    4a00:	02800a13          	li	s4,40
    4a04:	acc9                	j	4cd6 <concreate+0x308>
      link("C0", file);
    4a06:	fa840593          	addi	a1,s0,-88
    4a0a:	855e                	mv	a0,s7
    4a0c:	00001097          	auipc	ra,0x1
    4a10:	eac080e7          	jalr	-340(ra) # 58b8 <link>
    if(pid == 0) {
    4a14:	a465                	j	4cbc <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4a16:	4795                	li	a5,5
    4a18:	02f9693b          	remw	s2,s2,a5
    4a1c:	4785                	li	a5,1
    4a1e:	02f90b63          	beq	s2,a5,4a54 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4a22:	20200593          	li	a1,514
    4a26:	fa840513          	addi	a0,s0,-88
    4a2a:	00001097          	auipc	ra,0x1
    4a2e:	e6e080e7          	jalr	-402(ra) # 5898 <open>
      if(fd < 0){
    4a32:	26055c63          	bgez	a0,4caa <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4a36:	fa840593          	addi	a1,s0,-88
    4a3a:	00003517          	auipc	a0,0x3
    4a3e:	05650513          	addi	a0,a0,86 # 7a90 <malloc+0x1df6>
    4a42:	00001097          	auipc	ra,0x1
    4a46:	1a0080e7          	jalr	416(ra) # 5be2 <printf>
        exit(1);
    4a4a:	4505                	li	a0,1
    4a4c:	00001097          	auipc	ra,0x1
    4a50:	e0c080e7          	jalr	-500(ra) # 5858 <exit>
      link("C0", file);
    4a54:	fa840593          	addi	a1,s0,-88
    4a58:	00003517          	auipc	a0,0x3
    4a5c:	03050513          	addi	a0,a0,48 # 7a88 <malloc+0x1dee>
    4a60:	00001097          	auipc	ra,0x1
    4a64:	e58080e7          	jalr	-424(ra) # 58b8 <link>
      exit(0);
    4a68:	4501                	li	a0,0
    4a6a:	00001097          	auipc	ra,0x1
    4a6e:	dee080e7          	jalr	-530(ra) # 5858 <exit>
        exit(1);
    4a72:	4505                	li	a0,1
    4a74:	00001097          	auipc	ra,0x1
    4a78:	de4080e7          	jalr	-540(ra) # 5858 <exit>
  memset(fa, 0, sizeof(fa));
    4a7c:	02800613          	li	a2,40
    4a80:	4581                	li	a1,0
    4a82:	f8040513          	addi	a0,s0,-128
    4a86:	00001097          	auipc	ra,0x1
    4a8a:	bc2080e7          	jalr	-1086(ra) # 5648 <memset>
  fd = open(".", 0);
    4a8e:	4581                	li	a1,0
    4a90:	00002517          	auipc	a0,0x2
    4a94:	9e050513          	addi	a0,a0,-1568 # 6470 <malloc+0x7d6>
    4a98:	00001097          	auipc	ra,0x1
    4a9c:	e00080e7          	jalr	-512(ra) # 5898 <open>
    4aa0:	892a                	mv	s2,a0
  n = 0;
    4aa2:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4aa4:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4aa8:	02700b13          	li	s6,39
      fa[i] = 1;
    4aac:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4aae:	4641                	li	a2,16
    4ab0:	f7040593          	addi	a1,s0,-144
    4ab4:	854a                	mv	a0,s2
    4ab6:	00001097          	auipc	ra,0x1
    4aba:	dba080e7          	jalr	-582(ra) # 5870 <read>
    4abe:	08a05263          	blez	a0,4b42 <concreate+0x174>
    if(de.inum == 0)
    4ac2:	f7045783          	lhu	a5,-144(s0)
    4ac6:	d7e5                	beqz	a5,4aae <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4ac8:	f7244783          	lbu	a5,-142(s0)
    4acc:	ff4791e3          	bne	a5,s4,4aae <concreate+0xe0>
    4ad0:	f7444783          	lbu	a5,-140(s0)
    4ad4:	ffe9                	bnez	a5,4aae <concreate+0xe0>
      i = de.name[1] - '0';
    4ad6:	f7344783          	lbu	a5,-141(s0)
    4ada:	fd07879b          	addiw	a5,a5,-48
    4ade:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4ae2:	02eb6063          	bltu	s6,a4,4b02 <concreate+0x134>
      if(fa[i]){
    4ae6:	fb070793          	addi	a5,a4,-80 # fb0 <bigdir+0x50>
    4aea:	97a2                	add	a5,a5,s0
    4aec:	fd07c783          	lbu	a5,-48(a5)
    4af0:	eb8d                	bnez	a5,4b22 <concreate+0x154>
      fa[i] = 1;
    4af2:	fb070793          	addi	a5,a4,-80
    4af6:	00878733          	add	a4,a5,s0
    4afa:	fd770823          	sb	s7,-48(a4)
      n++;
    4afe:	2a85                	addiw	s5,s5,1
    4b00:	b77d                	j	4aae <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4b02:	f7240613          	addi	a2,s0,-142
    4b06:	85ce                	mv	a1,s3
    4b08:	00003517          	auipc	a0,0x3
    4b0c:	fa850513          	addi	a0,a0,-88 # 7ab0 <malloc+0x1e16>
    4b10:	00001097          	auipc	ra,0x1
    4b14:	0d2080e7          	jalr	210(ra) # 5be2 <printf>
        exit(1);
    4b18:	4505                	li	a0,1
    4b1a:	00001097          	auipc	ra,0x1
    4b1e:	d3e080e7          	jalr	-706(ra) # 5858 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4b22:	f7240613          	addi	a2,s0,-142
    4b26:	85ce                	mv	a1,s3
    4b28:	00003517          	auipc	a0,0x3
    4b2c:	fa850513          	addi	a0,a0,-88 # 7ad0 <malloc+0x1e36>
    4b30:	00001097          	auipc	ra,0x1
    4b34:	0b2080e7          	jalr	178(ra) # 5be2 <printf>
        exit(1);
    4b38:	4505                	li	a0,1
    4b3a:	00001097          	auipc	ra,0x1
    4b3e:	d1e080e7          	jalr	-738(ra) # 5858 <exit>
  close(fd);
    4b42:	854a                	mv	a0,s2
    4b44:	00001097          	auipc	ra,0x1
    4b48:	d3c080e7          	jalr	-708(ra) # 5880 <close>
  if(n != N){
    4b4c:	02800793          	li	a5,40
    4b50:	00fa9763          	bne	s5,a5,4b5e <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4b54:	4a8d                	li	s5,3
    4b56:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4b58:	02800a13          	li	s4,40
    4b5c:	a8c9                	j	4c2e <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4b5e:	85ce                	mv	a1,s3
    4b60:	00003517          	auipc	a0,0x3
    4b64:	f9850513          	addi	a0,a0,-104 # 7af8 <malloc+0x1e5e>
    4b68:	00001097          	auipc	ra,0x1
    4b6c:	07a080e7          	jalr	122(ra) # 5be2 <printf>
    exit(1);
    4b70:	4505                	li	a0,1
    4b72:	00001097          	auipc	ra,0x1
    4b76:	ce6080e7          	jalr	-794(ra) # 5858 <exit>
      printf("%s: fork failed\n", s);
    4b7a:	85ce                	mv	a1,s3
    4b7c:	00002517          	auipc	a0,0x2
    4b80:	a9450513          	addi	a0,a0,-1388 # 6610 <malloc+0x976>
    4b84:	00001097          	auipc	ra,0x1
    4b88:	05e080e7          	jalr	94(ra) # 5be2 <printf>
      exit(1);
    4b8c:	4505                	li	a0,1
    4b8e:	00001097          	auipc	ra,0x1
    4b92:	cca080e7          	jalr	-822(ra) # 5858 <exit>
      close(open(file, 0));
    4b96:	4581                	li	a1,0
    4b98:	fa840513          	addi	a0,s0,-88
    4b9c:	00001097          	auipc	ra,0x1
    4ba0:	cfc080e7          	jalr	-772(ra) # 5898 <open>
    4ba4:	00001097          	auipc	ra,0x1
    4ba8:	cdc080e7          	jalr	-804(ra) # 5880 <close>
      close(open(file, 0));
    4bac:	4581                	li	a1,0
    4bae:	fa840513          	addi	a0,s0,-88
    4bb2:	00001097          	auipc	ra,0x1
    4bb6:	ce6080e7          	jalr	-794(ra) # 5898 <open>
    4bba:	00001097          	auipc	ra,0x1
    4bbe:	cc6080e7          	jalr	-826(ra) # 5880 <close>
      close(open(file, 0));
    4bc2:	4581                	li	a1,0
    4bc4:	fa840513          	addi	a0,s0,-88
    4bc8:	00001097          	auipc	ra,0x1
    4bcc:	cd0080e7          	jalr	-816(ra) # 5898 <open>
    4bd0:	00001097          	auipc	ra,0x1
    4bd4:	cb0080e7          	jalr	-848(ra) # 5880 <close>
      close(open(file, 0));
    4bd8:	4581                	li	a1,0
    4bda:	fa840513          	addi	a0,s0,-88
    4bde:	00001097          	auipc	ra,0x1
    4be2:	cba080e7          	jalr	-838(ra) # 5898 <open>
    4be6:	00001097          	auipc	ra,0x1
    4bea:	c9a080e7          	jalr	-870(ra) # 5880 <close>
      close(open(file, 0));
    4bee:	4581                	li	a1,0
    4bf0:	fa840513          	addi	a0,s0,-88
    4bf4:	00001097          	auipc	ra,0x1
    4bf8:	ca4080e7          	jalr	-860(ra) # 5898 <open>
    4bfc:	00001097          	auipc	ra,0x1
    4c00:	c84080e7          	jalr	-892(ra) # 5880 <close>
      close(open(file, 0));
    4c04:	4581                	li	a1,0
    4c06:	fa840513          	addi	a0,s0,-88
    4c0a:	00001097          	auipc	ra,0x1
    4c0e:	c8e080e7          	jalr	-882(ra) # 5898 <open>
    4c12:	00001097          	auipc	ra,0x1
    4c16:	c6e080e7          	jalr	-914(ra) # 5880 <close>
    if(pid == 0)
    4c1a:	08090363          	beqz	s2,4ca0 <concreate+0x2d2>
      wait(0);
    4c1e:	4501                	li	a0,0
    4c20:	00001097          	auipc	ra,0x1
    4c24:	c40080e7          	jalr	-960(ra) # 5860 <wait>
  for(i = 0; i < N; i++){
    4c28:	2485                	addiw	s1,s1,1
    4c2a:	0f448563          	beq	s1,s4,4d14 <concreate+0x346>
    file[1] = '0' + i;
    4c2e:	0304879b          	addiw	a5,s1,48
    4c32:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4c36:	00001097          	auipc	ra,0x1
    4c3a:	c1a080e7          	jalr	-998(ra) # 5850 <fork>
    4c3e:	892a                	mv	s2,a0
    if(pid < 0){
    4c40:	f2054de3          	bltz	a0,4b7a <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    4c44:	0354e73b          	remw	a4,s1,s5
    4c48:	00a767b3          	or	a5,a4,a0
    4c4c:	2781                	sext.w	a5,a5
    4c4e:	d7a1                	beqz	a5,4b96 <concreate+0x1c8>
    4c50:	01671363          	bne	a4,s6,4c56 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    4c54:	f129                	bnez	a0,4b96 <concreate+0x1c8>
      unlink(file);
    4c56:	fa840513          	addi	a0,s0,-88
    4c5a:	00001097          	auipc	ra,0x1
    4c5e:	c4e080e7          	jalr	-946(ra) # 58a8 <unlink>
      unlink(file);
    4c62:	fa840513          	addi	a0,s0,-88
    4c66:	00001097          	auipc	ra,0x1
    4c6a:	c42080e7          	jalr	-958(ra) # 58a8 <unlink>
      unlink(file);
    4c6e:	fa840513          	addi	a0,s0,-88
    4c72:	00001097          	auipc	ra,0x1
    4c76:	c36080e7          	jalr	-970(ra) # 58a8 <unlink>
      unlink(file);
    4c7a:	fa840513          	addi	a0,s0,-88
    4c7e:	00001097          	auipc	ra,0x1
    4c82:	c2a080e7          	jalr	-982(ra) # 58a8 <unlink>
      unlink(file);
    4c86:	fa840513          	addi	a0,s0,-88
    4c8a:	00001097          	auipc	ra,0x1
    4c8e:	c1e080e7          	jalr	-994(ra) # 58a8 <unlink>
      unlink(file);
    4c92:	fa840513          	addi	a0,s0,-88
    4c96:	00001097          	auipc	ra,0x1
    4c9a:	c12080e7          	jalr	-1006(ra) # 58a8 <unlink>
    4c9e:	bfb5                	j	4c1a <concreate+0x24c>
      exit(0);
    4ca0:	4501                	li	a0,0
    4ca2:	00001097          	auipc	ra,0x1
    4ca6:	bb6080e7          	jalr	-1098(ra) # 5858 <exit>
      close(fd);
    4caa:	00001097          	auipc	ra,0x1
    4cae:	bd6080e7          	jalr	-1066(ra) # 5880 <close>
    if(pid == 0) {
    4cb2:	bb5d                	j	4a68 <concreate+0x9a>
      close(fd);
    4cb4:	00001097          	auipc	ra,0x1
    4cb8:	bcc080e7          	jalr	-1076(ra) # 5880 <close>
      wait(&xstatus);
    4cbc:	f6c40513          	addi	a0,s0,-148
    4cc0:	00001097          	auipc	ra,0x1
    4cc4:	ba0080e7          	jalr	-1120(ra) # 5860 <wait>
      if(xstatus != 0)
    4cc8:	f6c42483          	lw	s1,-148(s0)
    4ccc:	da0493e3          	bnez	s1,4a72 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4cd0:	2905                	addiw	s2,s2,1
    4cd2:	db4905e3          	beq	s2,s4,4a7c <concreate+0xae>
    file[1] = '0' + i;
    4cd6:	0309079b          	addiw	a5,s2,48
    4cda:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4cde:	fa840513          	addi	a0,s0,-88
    4ce2:	00001097          	auipc	ra,0x1
    4ce6:	bc6080e7          	jalr	-1082(ra) # 58a8 <unlink>
    pid = fork();
    4cea:	00001097          	auipc	ra,0x1
    4cee:	b66080e7          	jalr	-1178(ra) # 5850 <fork>
    if(pid && (i % 3) == 1){
    4cf2:	d20502e3          	beqz	a0,4a16 <concreate+0x48>
    4cf6:	036967bb          	remw	a5,s2,s6
    4cfa:	d15786e3          	beq	a5,s5,4a06 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4cfe:	20200593          	li	a1,514
    4d02:	fa840513          	addi	a0,s0,-88
    4d06:	00001097          	auipc	ra,0x1
    4d0a:	b92080e7          	jalr	-1134(ra) # 5898 <open>
      if(fd < 0){
    4d0e:	fa0553e3          	bgez	a0,4cb4 <concreate+0x2e6>
    4d12:	b315                	j	4a36 <concreate+0x68>
}
    4d14:	60ea                	ld	ra,152(sp)
    4d16:	644a                	ld	s0,144(sp)
    4d18:	64aa                	ld	s1,136(sp)
    4d1a:	690a                	ld	s2,128(sp)
    4d1c:	79e6                	ld	s3,120(sp)
    4d1e:	7a46                	ld	s4,112(sp)
    4d20:	7aa6                	ld	s5,104(sp)
    4d22:	7b06                	ld	s6,96(sp)
    4d24:	6be6                	ld	s7,88(sp)
    4d26:	610d                	addi	sp,sp,160
    4d28:	8082                	ret

0000000000004d2a <bigfile>:
{
    4d2a:	7139                	addi	sp,sp,-64
    4d2c:	fc06                	sd	ra,56(sp)
    4d2e:	f822                	sd	s0,48(sp)
    4d30:	f426                	sd	s1,40(sp)
    4d32:	f04a                	sd	s2,32(sp)
    4d34:	ec4e                	sd	s3,24(sp)
    4d36:	e852                	sd	s4,16(sp)
    4d38:	e456                	sd	s5,8(sp)
    4d3a:	0080                	addi	s0,sp,64
    4d3c:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4d3e:	00003517          	auipc	a0,0x3
    4d42:	df250513          	addi	a0,a0,-526 # 7b30 <malloc+0x1e96>
    4d46:	00001097          	auipc	ra,0x1
    4d4a:	b62080e7          	jalr	-1182(ra) # 58a8 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4d4e:	20200593          	li	a1,514
    4d52:	00003517          	auipc	a0,0x3
    4d56:	dde50513          	addi	a0,a0,-546 # 7b30 <malloc+0x1e96>
    4d5a:	00001097          	auipc	ra,0x1
    4d5e:	b3e080e7          	jalr	-1218(ra) # 5898 <open>
    4d62:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4d64:	4481                	li	s1,0
    memset(buf, i, SZ);
    4d66:	00007917          	auipc	s2,0x7
    4d6a:	09290913          	addi	s2,s2,146 # bdf8 <buf>
  for(i = 0; i < N; i++){
    4d6e:	4a51                	li	s4,20
  if(fd < 0){
    4d70:	0a054063          	bltz	a0,4e10 <bigfile+0xe6>
    memset(buf, i, SZ);
    4d74:	25800613          	li	a2,600
    4d78:	85a6                	mv	a1,s1
    4d7a:	854a                	mv	a0,s2
    4d7c:	00001097          	auipc	ra,0x1
    4d80:	8cc080e7          	jalr	-1844(ra) # 5648 <memset>
    if(write(fd, buf, SZ) != SZ){
    4d84:	25800613          	li	a2,600
    4d88:	85ca                	mv	a1,s2
    4d8a:	854e                	mv	a0,s3
    4d8c:	00001097          	auipc	ra,0x1
    4d90:	aec080e7          	jalr	-1300(ra) # 5878 <write>
    4d94:	25800793          	li	a5,600
    4d98:	08f51a63          	bne	a0,a5,4e2c <bigfile+0x102>
  for(i = 0; i < N; i++){
    4d9c:	2485                	addiw	s1,s1,1
    4d9e:	fd449be3          	bne	s1,s4,4d74 <bigfile+0x4a>
  close(fd);
    4da2:	854e                	mv	a0,s3
    4da4:	00001097          	auipc	ra,0x1
    4da8:	adc080e7          	jalr	-1316(ra) # 5880 <close>
  fd = open("bigfile.dat", 0);
    4dac:	4581                	li	a1,0
    4dae:	00003517          	auipc	a0,0x3
    4db2:	d8250513          	addi	a0,a0,-638 # 7b30 <malloc+0x1e96>
    4db6:	00001097          	auipc	ra,0x1
    4dba:	ae2080e7          	jalr	-1310(ra) # 5898 <open>
    4dbe:	8a2a                	mv	s4,a0
  total = 0;
    4dc0:	4981                	li	s3,0
  for(i = 0; ; i++){
    4dc2:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4dc4:	00007917          	auipc	s2,0x7
    4dc8:	03490913          	addi	s2,s2,52 # bdf8 <buf>
  if(fd < 0){
    4dcc:	06054e63          	bltz	a0,4e48 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4dd0:	12c00613          	li	a2,300
    4dd4:	85ca                	mv	a1,s2
    4dd6:	8552                	mv	a0,s4
    4dd8:	00001097          	auipc	ra,0x1
    4ddc:	a98080e7          	jalr	-1384(ra) # 5870 <read>
    if(cc < 0){
    4de0:	08054263          	bltz	a0,4e64 <bigfile+0x13a>
    if(cc == 0)
    4de4:	c971                	beqz	a0,4eb8 <bigfile+0x18e>
    if(cc != SZ/2){
    4de6:	12c00793          	li	a5,300
    4dea:	08f51b63          	bne	a0,a5,4e80 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4dee:	01f4d79b          	srliw	a5,s1,0x1f
    4df2:	9fa5                	addw	a5,a5,s1
    4df4:	4017d79b          	sraiw	a5,a5,0x1
    4df8:	00094703          	lbu	a4,0(s2)
    4dfc:	0af71063          	bne	a4,a5,4e9c <bigfile+0x172>
    4e00:	12b94703          	lbu	a4,299(s2)
    4e04:	08f71c63          	bne	a4,a5,4e9c <bigfile+0x172>
    total += cc;
    4e08:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4e0c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4e0e:	b7c9                	j	4dd0 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4e10:	85d6                	mv	a1,s5
    4e12:	00003517          	auipc	a0,0x3
    4e16:	d2e50513          	addi	a0,a0,-722 # 7b40 <malloc+0x1ea6>
    4e1a:	00001097          	auipc	ra,0x1
    4e1e:	dc8080e7          	jalr	-568(ra) # 5be2 <printf>
    exit(1);
    4e22:	4505                	li	a0,1
    4e24:	00001097          	auipc	ra,0x1
    4e28:	a34080e7          	jalr	-1484(ra) # 5858 <exit>
      printf("%s: write bigfile failed\n", s);
    4e2c:	85d6                	mv	a1,s5
    4e2e:	00003517          	auipc	a0,0x3
    4e32:	d3250513          	addi	a0,a0,-718 # 7b60 <malloc+0x1ec6>
    4e36:	00001097          	auipc	ra,0x1
    4e3a:	dac080e7          	jalr	-596(ra) # 5be2 <printf>
      exit(1);
    4e3e:	4505                	li	a0,1
    4e40:	00001097          	auipc	ra,0x1
    4e44:	a18080e7          	jalr	-1512(ra) # 5858 <exit>
    printf("%s: cannot open bigfile\n", s);
    4e48:	85d6                	mv	a1,s5
    4e4a:	00003517          	auipc	a0,0x3
    4e4e:	d3650513          	addi	a0,a0,-714 # 7b80 <malloc+0x1ee6>
    4e52:	00001097          	auipc	ra,0x1
    4e56:	d90080e7          	jalr	-624(ra) # 5be2 <printf>
    exit(1);
    4e5a:	4505                	li	a0,1
    4e5c:	00001097          	auipc	ra,0x1
    4e60:	9fc080e7          	jalr	-1540(ra) # 5858 <exit>
      printf("%s: read bigfile failed\n", s);
    4e64:	85d6                	mv	a1,s5
    4e66:	00003517          	auipc	a0,0x3
    4e6a:	d3a50513          	addi	a0,a0,-710 # 7ba0 <malloc+0x1f06>
    4e6e:	00001097          	auipc	ra,0x1
    4e72:	d74080e7          	jalr	-652(ra) # 5be2 <printf>
      exit(1);
    4e76:	4505                	li	a0,1
    4e78:	00001097          	auipc	ra,0x1
    4e7c:	9e0080e7          	jalr	-1568(ra) # 5858 <exit>
      printf("%s: short read bigfile\n", s);
    4e80:	85d6                	mv	a1,s5
    4e82:	00003517          	auipc	a0,0x3
    4e86:	d3e50513          	addi	a0,a0,-706 # 7bc0 <malloc+0x1f26>
    4e8a:	00001097          	auipc	ra,0x1
    4e8e:	d58080e7          	jalr	-680(ra) # 5be2 <printf>
      exit(1);
    4e92:	4505                	li	a0,1
    4e94:	00001097          	auipc	ra,0x1
    4e98:	9c4080e7          	jalr	-1596(ra) # 5858 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4e9c:	85d6                	mv	a1,s5
    4e9e:	00003517          	auipc	a0,0x3
    4ea2:	d3a50513          	addi	a0,a0,-710 # 7bd8 <malloc+0x1f3e>
    4ea6:	00001097          	auipc	ra,0x1
    4eaa:	d3c080e7          	jalr	-708(ra) # 5be2 <printf>
      exit(1);
    4eae:	4505                	li	a0,1
    4eb0:	00001097          	auipc	ra,0x1
    4eb4:	9a8080e7          	jalr	-1624(ra) # 5858 <exit>
  close(fd);
    4eb8:	8552                	mv	a0,s4
    4eba:	00001097          	auipc	ra,0x1
    4ebe:	9c6080e7          	jalr	-1594(ra) # 5880 <close>
  if(total != N*SZ){
    4ec2:	678d                	lui	a5,0x3
    4ec4:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourteen+0x110>
    4ec8:	02f99363          	bne	s3,a5,4eee <bigfile+0x1c4>
  unlink("bigfile.dat");
    4ecc:	00003517          	auipc	a0,0x3
    4ed0:	c6450513          	addi	a0,a0,-924 # 7b30 <malloc+0x1e96>
    4ed4:	00001097          	auipc	ra,0x1
    4ed8:	9d4080e7          	jalr	-1580(ra) # 58a8 <unlink>
}
    4edc:	70e2                	ld	ra,56(sp)
    4ede:	7442                	ld	s0,48(sp)
    4ee0:	74a2                	ld	s1,40(sp)
    4ee2:	7902                	ld	s2,32(sp)
    4ee4:	69e2                	ld	s3,24(sp)
    4ee6:	6a42                	ld	s4,16(sp)
    4ee8:	6aa2                	ld	s5,8(sp)
    4eea:	6121                	addi	sp,sp,64
    4eec:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4eee:	85d6                	mv	a1,s5
    4ef0:	00003517          	auipc	a0,0x3
    4ef4:	d0850513          	addi	a0,a0,-760 # 7bf8 <malloc+0x1f5e>
    4ef8:	00001097          	auipc	ra,0x1
    4efc:	cea080e7          	jalr	-790(ra) # 5be2 <printf>
    exit(1);
    4f00:	4505                	li	a0,1
    4f02:	00001097          	auipc	ra,0x1
    4f06:	956080e7          	jalr	-1706(ra) # 5858 <exit>

0000000000004f0a <fsfull>:
{
    4f0a:	7171                	addi	sp,sp,-176
    4f0c:	f506                	sd	ra,168(sp)
    4f0e:	f122                	sd	s0,160(sp)
    4f10:	ed26                	sd	s1,152(sp)
    4f12:	e94a                	sd	s2,144(sp)
    4f14:	e54e                	sd	s3,136(sp)
    4f16:	e152                	sd	s4,128(sp)
    4f18:	fcd6                	sd	s5,120(sp)
    4f1a:	f8da                	sd	s6,112(sp)
    4f1c:	f4de                	sd	s7,104(sp)
    4f1e:	f0e2                	sd	s8,96(sp)
    4f20:	ece6                	sd	s9,88(sp)
    4f22:	e8ea                	sd	s10,80(sp)
    4f24:	e4ee                	sd	s11,72(sp)
    4f26:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4f28:	00003517          	auipc	a0,0x3
    4f2c:	cf050513          	addi	a0,a0,-784 # 7c18 <malloc+0x1f7e>
    4f30:	00001097          	auipc	ra,0x1
    4f34:	cb2080e7          	jalr	-846(ra) # 5be2 <printf>
  for(nfiles = 0; ; nfiles++){
    4f38:	4481                	li	s1,0
    name[0] = 'f';
    4f3a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4f3e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4f42:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4f46:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4f48:	00003c97          	auipc	s9,0x3
    4f4c:	ce0c8c93          	addi	s9,s9,-800 # 7c28 <malloc+0x1f8e>
    int total = 0;
    4f50:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4f52:	00007a17          	auipc	s4,0x7
    4f56:	ea6a0a13          	addi	s4,s4,-346 # bdf8 <buf>
    name[0] = 'f';
    4f5a:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4f5e:	0384c7bb          	divw	a5,s1,s8
    4f62:	0307879b          	addiw	a5,a5,48
    4f66:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4f6a:	0384e7bb          	remw	a5,s1,s8
    4f6e:	0377c7bb          	divw	a5,a5,s7
    4f72:	0307879b          	addiw	a5,a5,48
    4f76:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4f7a:	0374e7bb          	remw	a5,s1,s7
    4f7e:	0367c7bb          	divw	a5,a5,s6
    4f82:	0307879b          	addiw	a5,a5,48
    4f86:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4f8a:	0364e7bb          	remw	a5,s1,s6
    4f8e:	0307879b          	addiw	a5,a5,48
    4f92:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4f96:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4f9a:	f5040593          	addi	a1,s0,-176
    4f9e:	8566                	mv	a0,s9
    4fa0:	00001097          	auipc	ra,0x1
    4fa4:	c42080e7          	jalr	-958(ra) # 5be2 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4fa8:	20200593          	li	a1,514
    4fac:	f5040513          	addi	a0,s0,-176
    4fb0:	00001097          	auipc	ra,0x1
    4fb4:	8e8080e7          	jalr	-1816(ra) # 5898 <open>
    4fb8:	892a                	mv	s2,a0
    if(fd < 0){
    4fba:	0a055663          	bgez	a0,5066 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4fbe:	f5040593          	addi	a1,s0,-176
    4fc2:	00003517          	auipc	a0,0x3
    4fc6:	c7650513          	addi	a0,a0,-906 # 7c38 <malloc+0x1f9e>
    4fca:	00001097          	auipc	ra,0x1
    4fce:	c18080e7          	jalr	-1000(ra) # 5be2 <printf>
  while(nfiles >= 0){
    4fd2:	0604c363          	bltz	s1,5038 <fsfull+0x12e>
    name[0] = 'f';
    4fd6:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4fda:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4fde:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4fe2:	4929                	li	s2,10
  while(nfiles >= 0){
    4fe4:	5afd                	li	s5,-1
    name[0] = 'f';
    4fe6:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4fea:	0344c7bb          	divw	a5,s1,s4
    4fee:	0307879b          	addiw	a5,a5,48
    4ff2:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4ff6:	0344e7bb          	remw	a5,s1,s4
    4ffa:	0337c7bb          	divw	a5,a5,s3
    4ffe:	0307879b          	addiw	a5,a5,48
    5002:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5006:	0334e7bb          	remw	a5,s1,s3
    500a:	0327c7bb          	divw	a5,a5,s2
    500e:	0307879b          	addiw	a5,a5,48
    5012:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5016:	0324e7bb          	remw	a5,s1,s2
    501a:	0307879b          	addiw	a5,a5,48
    501e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5022:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    5026:	f5040513          	addi	a0,s0,-176
    502a:	00001097          	auipc	ra,0x1
    502e:	87e080e7          	jalr	-1922(ra) # 58a8 <unlink>
    nfiles--;
    5032:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5034:	fb5499e3          	bne	s1,s5,4fe6 <fsfull+0xdc>
  printf("fsfull test finished\n");
    5038:	00003517          	auipc	a0,0x3
    503c:	c2050513          	addi	a0,a0,-992 # 7c58 <malloc+0x1fbe>
    5040:	00001097          	auipc	ra,0x1
    5044:	ba2080e7          	jalr	-1118(ra) # 5be2 <printf>
}
    5048:	70aa                	ld	ra,168(sp)
    504a:	740a                	ld	s0,160(sp)
    504c:	64ea                	ld	s1,152(sp)
    504e:	694a                	ld	s2,144(sp)
    5050:	69aa                	ld	s3,136(sp)
    5052:	6a0a                	ld	s4,128(sp)
    5054:	7ae6                	ld	s5,120(sp)
    5056:	7b46                	ld	s6,112(sp)
    5058:	7ba6                	ld	s7,104(sp)
    505a:	7c06                	ld	s8,96(sp)
    505c:	6ce6                	ld	s9,88(sp)
    505e:	6d46                	ld	s10,80(sp)
    5060:	6da6                	ld	s11,72(sp)
    5062:	614d                	addi	sp,sp,176
    5064:	8082                	ret
    int total = 0;
    5066:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    5068:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    506c:	40000613          	li	a2,1024
    5070:	85d2                	mv	a1,s4
    5072:	854a                	mv	a0,s2
    5074:	00001097          	auipc	ra,0x1
    5078:	804080e7          	jalr	-2044(ra) # 5878 <write>
      if(cc < BSIZE)
    507c:	00aad563          	bge	s5,a0,5086 <fsfull+0x17c>
      total += cc;
    5080:	00a989bb          	addw	s3,s3,a0
    while(1){
    5084:	b7e5                	j	506c <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5086:	85ce                	mv	a1,s3
    5088:	00003517          	auipc	a0,0x3
    508c:	bc050513          	addi	a0,a0,-1088 # 7c48 <malloc+0x1fae>
    5090:	00001097          	auipc	ra,0x1
    5094:	b52080e7          	jalr	-1198(ra) # 5be2 <printf>
    close(fd);
    5098:	854a                	mv	a0,s2
    509a:	00000097          	auipc	ra,0x0
    509e:	7e6080e7          	jalr	2022(ra) # 5880 <close>
    if(total == 0)
    50a2:	f20988e3          	beqz	s3,4fd2 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    50a6:	2485                	addiw	s1,s1,1
    50a8:	bd4d                	j	4f5a <fsfull+0x50>

00000000000050aa <badwrite>:
{
    50aa:	7179                	addi	sp,sp,-48
    50ac:	f406                	sd	ra,40(sp)
    50ae:	f022                	sd	s0,32(sp)
    50b0:	ec26                	sd	s1,24(sp)
    50b2:	e84a                	sd	s2,16(sp)
    50b4:	e44e                	sd	s3,8(sp)
    50b6:	e052                	sd	s4,0(sp)
    50b8:	1800                	addi	s0,sp,48
  unlink("junk");
    50ba:	00003517          	auipc	a0,0x3
    50be:	bb650513          	addi	a0,a0,-1098 # 7c70 <malloc+0x1fd6>
    50c2:	00000097          	auipc	ra,0x0
    50c6:	7e6080e7          	jalr	2022(ra) # 58a8 <unlink>
    50ca:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    50ce:	00003997          	auipc	s3,0x3
    50d2:	ba298993          	addi	s3,s3,-1118 # 7c70 <malloc+0x1fd6>
    write(fd, (char*)0xffffffffffL, 1);
    50d6:	5a7d                	li	s4,-1
    50d8:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    50dc:	20100593          	li	a1,513
    50e0:	854e                	mv	a0,s3
    50e2:	00000097          	auipc	ra,0x0
    50e6:	7b6080e7          	jalr	1974(ra) # 5898 <open>
    50ea:	84aa                	mv	s1,a0
    if(fd < 0){
    50ec:	06054b63          	bltz	a0,5162 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    50f0:	4605                	li	a2,1
    50f2:	85d2                	mv	a1,s4
    50f4:	00000097          	auipc	ra,0x0
    50f8:	784080e7          	jalr	1924(ra) # 5878 <write>
    close(fd);
    50fc:	8526                	mv	a0,s1
    50fe:	00000097          	auipc	ra,0x0
    5102:	782080e7          	jalr	1922(ra) # 5880 <close>
    unlink("junk");
    5106:	854e                	mv	a0,s3
    5108:	00000097          	auipc	ra,0x0
    510c:	7a0080e7          	jalr	1952(ra) # 58a8 <unlink>
  for(int i = 0; i < assumed_free; i++){
    5110:	397d                	addiw	s2,s2,-1
    5112:	fc0915e3          	bnez	s2,50dc <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    5116:	20100593          	li	a1,513
    511a:	00003517          	auipc	a0,0x3
    511e:	b5650513          	addi	a0,a0,-1194 # 7c70 <malloc+0x1fd6>
    5122:	00000097          	auipc	ra,0x0
    5126:	776080e7          	jalr	1910(ra) # 5898 <open>
    512a:	84aa                	mv	s1,a0
  if(fd < 0){
    512c:	04054863          	bltz	a0,517c <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    5130:	4605                	li	a2,1
    5132:	00001597          	auipc	a1,0x1
    5136:	cf658593          	addi	a1,a1,-778 # 5e28 <malloc+0x18e>
    513a:	00000097          	auipc	ra,0x0
    513e:	73e080e7          	jalr	1854(ra) # 5878 <write>
    5142:	4785                	li	a5,1
    5144:	04f50963          	beq	a0,a5,5196 <badwrite+0xec>
    printf("write failed\n");
    5148:	00003517          	auipc	a0,0x3
    514c:	b4850513          	addi	a0,a0,-1208 # 7c90 <malloc+0x1ff6>
    5150:	00001097          	auipc	ra,0x1
    5154:	a92080e7          	jalr	-1390(ra) # 5be2 <printf>
    exit(1);
    5158:	4505                	li	a0,1
    515a:	00000097          	auipc	ra,0x0
    515e:	6fe080e7          	jalr	1790(ra) # 5858 <exit>
      printf("open junk failed\n");
    5162:	00003517          	auipc	a0,0x3
    5166:	b1650513          	addi	a0,a0,-1258 # 7c78 <malloc+0x1fde>
    516a:	00001097          	auipc	ra,0x1
    516e:	a78080e7          	jalr	-1416(ra) # 5be2 <printf>
      exit(1);
    5172:	4505                	li	a0,1
    5174:	00000097          	auipc	ra,0x0
    5178:	6e4080e7          	jalr	1764(ra) # 5858 <exit>
    printf("open junk failed\n");
    517c:	00003517          	auipc	a0,0x3
    5180:	afc50513          	addi	a0,a0,-1284 # 7c78 <malloc+0x1fde>
    5184:	00001097          	auipc	ra,0x1
    5188:	a5e080e7          	jalr	-1442(ra) # 5be2 <printf>
    exit(1);
    518c:	4505                	li	a0,1
    518e:	00000097          	auipc	ra,0x0
    5192:	6ca080e7          	jalr	1738(ra) # 5858 <exit>
  close(fd);
    5196:	8526                	mv	a0,s1
    5198:	00000097          	auipc	ra,0x0
    519c:	6e8080e7          	jalr	1768(ra) # 5880 <close>
  unlink("junk");
    51a0:	00003517          	auipc	a0,0x3
    51a4:	ad050513          	addi	a0,a0,-1328 # 7c70 <malloc+0x1fd6>
    51a8:	00000097          	auipc	ra,0x0
    51ac:	700080e7          	jalr	1792(ra) # 58a8 <unlink>
  exit(0);
    51b0:	4501                	li	a0,0
    51b2:	00000097          	auipc	ra,0x0
    51b6:	6a6080e7          	jalr	1702(ra) # 5858 <exit>

00000000000051ba <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    51ba:	7139                	addi	sp,sp,-64
    51bc:	fc06                	sd	ra,56(sp)
    51be:	f822                	sd	s0,48(sp)
    51c0:	f426                	sd	s1,40(sp)
    51c2:	f04a                	sd	s2,32(sp)
    51c4:	ec4e                	sd	s3,24(sp)
    51c6:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    51c8:	fc840513          	addi	a0,s0,-56
    51cc:	00000097          	auipc	ra,0x0
    51d0:	69c080e7          	jalr	1692(ra) # 5868 <pipe>
    51d4:	06054763          	bltz	a0,5242 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    51d8:	00000097          	auipc	ra,0x0
    51dc:	678080e7          	jalr	1656(ra) # 5850 <fork>

  if(pid < 0){
    51e0:	06054e63          	bltz	a0,525c <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    51e4:	ed51                	bnez	a0,5280 <countfree+0xc6>
    close(fds[0]);
    51e6:	fc842503          	lw	a0,-56(s0)
    51ea:	00000097          	auipc	ra,0x0
    51ee:	696080e7          	jalr	1686(ra) # 5880 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    51f2:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    51f4:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    51f6:	00001997          	auipc	s3,0x1
    51fa:	c3298993          	addi	s3,s3,-974 # 5e28 <malloc+0x18e>
      uint64 a = (uint64) sbrk(4096);
    51fe:	6505                	lui	a0,0x1
    5200:	00000097          	auipc	ra,0x0
    5204:	6e0080e7          	jalr	1760(ra) # 58e0 <sbrk>
      if(a == 0xffffffffffffffff){
    5208:	07250763          	beq	a0,s2,5276 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    520c:	6785                	lui	a5,0x1
    520e:	97aa                	add	a5,a5,a0
    5210:	fe978fa3          	sb	s1,-1(a5) # fff <bigdir+0x9f>
      if(write(fds[1], "x", 1) != 1){
    5214:	8626                	mv	a2,s1
    5216:	85ce                	mv	a1,s3
    5218:	fcc42503          	lw	a0,-52(s0)
    521c:	00000097          	auipc	ra,0x0
    5220:	65c080e7          	jalr	1628(ra) # 5878 <write>
    5224:	fc950de3          	beq	a0,s1,51fe <countfree+0x44>
        printf("write() failed in countfree()\n");
    5228:	00003517          	auipc	a0,0x3
    522c:	ab850513          	addi	a0,a0,-1352 # 7ce0 <malloc+0x2046>
    5230:	00001097          	auipc	ra,0x1
    5234:	9b2080e7          	jalr	-1614(ra) # 5be2 <printf>
        exit(1);
    5238:	4505                	li	a0,1
    523a:	00000097          	auipc	ra,0x0
    523e:	61e080e7          	jalr	1566(ra) # 5858 <exit>
    printf("pipe() failed in countfree()\n");
    5242:	00003517          	auipc	a0,0x3
    5246:	a5e50513          	addi	a0,a0,-1442 # 7ca0 <malloc+0x2006>
    524a:	00001097          	auipc	ra,0x1
    524e:	998080e7          	jalr	-1640(ra) # 5be2 <printf>
    exit(1);
    5252:	4505                	li	a0,1
    5254:	00000097          	auipc	ra,0x0
    5258:	604080e7          	jalr	1540(ra) # 5858 <exit>
    printf("fork failed in countfree()\n");
    525c:	00003517          	auipc	a0,0x3
    5260:	a6450513          	addi	a0,a0,-1436 # 7cc0 <malloc+0x2026>
    5264:	00001097          	auipc	ra,0x1
    5268:	97e080e7          	jalr	-1666(ra) # 5be2 <printf>
    exit(1);
    526c:	4505                	li	a0,1
    526e:	00000097          	auipc	ra,0x0
    5272:	5ea080e7          	jalr	1514(ra) # 5858 <exit>
      }
    }

    exit(0);
    5276:	4501                	li	a0,0
    5278:	00000097          	auipc	ra,0x0
    527c:	5e0080e7          	jalr	1504(ra) # 5858 <exit>
  }

  close(fds[1]);
    5280:	fcc42503          	lw	a0,-52(s0)
    5284:	00000097          	auipc	ra,0x0
    5288:	5fc080e7          	jalr	1532(ra) # 5880 <close>

  int n = 0;
    528c:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    528e:	4605                	li	a2,1
    5290:	fc740593          	addi	a1,s0,-57
    5294:	fc842503          	lw	a0,-56(s0)
    5298:	00000097          	auipc	ra,0x0
    529c:	5d8080e7          	jalr	1496(ra) # 5870 <read>
    if(cc < 0){
    52a0:	00054563          	bltz	a0,52aa <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    52a4:	c105                	beqz	a0,52c4 <countfree+0x10a>
      break;
    n += 1;
    52a6:	2485                	addiw	s1,s1,1
  while(1){
    52a8:	b7dd                	j	528e <countfree+0xd4>
      printf("read() failed in countfree()\n");
    52aa:	00003517          	auipc	a0,0x3
    52ae:	a5650513          	addi	a0,a0,-1450 # 7d00 <malloc+0x2066>
    52b2:	00001097          	auipc	ra,0x1
    52b6:	930080e7          	jalr	-1744(ra) # 5be2 <printf>
      exit(1);
    52ba:	4505                	li	a0,1
    52bc:	00000097          	auipc	ra,0x0
    52c0:	59c080e7          	jalr	1436(ra) # 5858 <exit>
  }

  close(fds[0]);
    52c4:	fc842503          	lw	a0,-56(s0)
    52c8:	00000097          	auipc	ra,0x0
    52cc:	5b8080e7          	jalr	1464(ra) # 5880 <close>
  wait((int*)0);
    52d0:	4501                	li	a0,0
    52d2:	00000097          	auipc	ra,0x0
    52d6:	58e080e7          	jalr	1422(ra) # 5860 <wait>
  
  return n;
}
    52da:	8526                	mv	a0,s1
    52dc:	70e2                	ld	ra,56(sp)
    52de:	7442                	ld	s0,48(sp)
    52e0:	74a2                	ld	s1,40(sp)
    52e2:	7902                	ld	s2,32(sp)
    52e4:	69e2                	ld	s3,24(sp)
    52e6:	6121                	addi	sp,sp,64
    52e8:	8082                	ret

00000000000052ea <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    52ea:	7179                	addi	sp,sp,-48
    52ec:	f406                	sd	ra,40(sp)
    52ee:	f022                	sd	s0,32(sp)
    52f0:	ec26                	sd	s1,24(sp)
    52f2:	e84a                	sd	s2,16(sp)
    52f4:	1800                	addi	s0,sp,48
    52f6:	84aa                	mv	s1,a0
    52f8:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    52fa:	00003517          	auipc	a0,0x3
    52fe:	a2650513          	addi	a0,a0,-1498 # 7d20 <malloc+0x2086>
    5302:	00001097          	auipc	ra,0x1
    5306:	8e0080e7          	jalr	-1824(ra) # 5be2 <printf>
  if((pid = fork()) < 0) {
    530a:	00000097          	auipc	ra,0x0
    530e:	546080e7          	jalr	1350(ra) # 5850 <fork>
    5312:	02054e63          	bltz	a0,534e <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5316:	c929                	beqz	a0,5368 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5318:	fdc40513          	addi	a0,s0,-36
    531c:	00000097          	auipc	ra,0x0
    5320:	544080e7          	jalr	1348(ra) # 5860 <wait>
    if(xstatus != 0) 
    5324:	fdc42783          	lw	a5,-36(s0)
    5328:	c7b9                	beqz	a5,5376 <run+0x8c>
      printf("FAILED\n");
    532a:	00003517          	auipc	a0,0x3
    532e:	a1e50513          	addi	a0,a0,-1506 # 7d48 <malloc+0x20ae>
    5332:	00001097          	auipc	ra,0x1
    5336:	8b0080e7          	jalr	-1872(ra) # 5be2 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    533a:	fdc42503          	lw	a0,-36(s0)
  }
}
    533e:	00153513          	seqz	a0,a0
    5342:	70a2                	ld	ra,40(sp)
    5344:	7402                	ld	s0,32(sp)
    5346:	64e2                	ld	s1,24(sp)
    5348:	6942                	ld	s2,16(sp)
    534a:	6145                	addi	sp,sp,48
    534c:	8082                	ret
    printf("runtest: fork error\n");
    534e:	00003517          	auipc	a0,0x3
    5352:	9e250513          	addi	a0,a0,-1566 # 7d30 <malloc+0x2096>
    5356:	00001097          	auipc	ra,0x1
    535a:	88c080e7          	jalr	-1908(ra) # 5be2 <printf>
    exit(1);
    535e:	4505                	li	a0,1
    5360:	00000097          	auipc	ra,0x0
    5364:	4f8080e7          	jalr	1272(ra) # 5858 <exit>
    f(s);
    5368:	854a                	mv	a0,s2
    536a:	9482                	jalr	s1
    exit(0);
    536c:	4501                	li	a0,0
    536e:	00000097          	auipc	ra,0x0
    5372:	4ea080e7          	jalr	1258(ra) # 5858 <exit>
      printf("OK\n");
    5376:	00003517          	auipc	a0,0x3
    537a:	9da50513          	addi	a0,a0,-1574 # 7d50 <malloc+0x20b6>
    537e:	00001097          	auipc	ra,0x1
    5382:	864080e7          	jalr	-1948(ra) # 5be2 <printf>
    5386:	bf55                	j	533a <run+0x50>

0000000000005388 <main>:

int
main(int argc, char *argv[])
{
    5388:	bd010113          	addi	sp,sp,-1072
    538c:	42113423          	sd	ra,1064(sp)
    5390:	42813023          	sd	s0,1056(sp)
    5394:	40913c23          	sd	s1,1048(sp)
    5398:	41213823          	sd	s2,1040(sp)
    539c:	41313423          	sd	s3,1032(sp)
    53a0:	41413023          	sd	s4,1024(sp)
    53a4:	3f513c23          	sd	s5,1016(sp)
    53a8:	3f613823          	sd	s6,1008(sp)
    53ac:	43010413          	addi	s0,sp,1072
    53b0:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    53b2:	4789                	li	a5,2
    53b4:	08f50f63          	beq	a0,a5,5452 <main+0xca>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    53b8:	4785                	li	a5,1
  char *justone = 0;
    53ba:	4901                	li	s2,0
  } else if(argc > 1){
    53bc:	0ca7c963          	blt	a5,a0,548e <main+0x106>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    53c0:	00003797          	auipc	a5,0x3
    53c4:	da878793          	addi	a5,a5,-600 # 8168 <malloc+0x24ce>
    53c8:	bd040713          	addi	a4,s0,-1072
    53cc:	00003317          	auipc	t1,0x3
    53d0:	18c30313          	addi	t1,t1,396 # 8558 <malloc+0x28be>
    53d4:	0007b883          	ld	a7,0(a5)
    53d8:	0087b803          	ld	a6,8(a5)
    53dc:	6b88                	ld	a0,16(a5)
    53de:	6f8c                	ld	a1,24(a5)
    53e0:	7390                	ld	a2,32(a5)
    53e2:	7794                	ld	a3,40(a5)
    53e4:	01173023          	sd	a7,0(a4)
    53e8:	01073423          	sd	a6,8(a4)
    53ec:	eb08                	sd	a0,16(a4)
    53ee:	ef0c                	sd	a1,24(a4)
    53f0:	f310                	sd	a2,32(a4)
    53f2:	f714                	sd	a3,40(a4)
    53f4:	03078793          	addi	a5,a5,48
    53f8:	03070713          	addi	a4,a4,48
    53fc:	fc679ce3          	bne	a5,t1,53d4 <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5400:	00003517          	auipc	a0,0x3
    5404:	a0850513          	addi	a0,a0,-1528 # 7e08 <malloc+0x216e>
    5408:	00000097          	auipc	ra,0x0
    540c:	7da080e7          	jalr	2010(ra) # 5be2 <printf>
  int free0 = countfree();
    5410:	00000097          	auipc	ra,0x0
    5414:	daa080e7          	jalr	-598(ra) # 51ba <countfree>
    5418:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    541a:	bd843503          	ld	a0,-1064(s0)
    541e:	bd040493          	addi	s1,s0,-1072
  int fail = 0;
    5422:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5424:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    5426:	e55d                	bnez	a0,54d4 <main+0x14c>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    5428:	00000097          	auipc	ra,0x0
    542c:	d92080e7          	jalr	-622(ra) # 51ba <countfree>
    5430:	85aa                	mv	a1,a0
    5432:	0f455163          	bge	a0,s4,5514 <main+0x18c>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5436:	8652                	mv	a2,s4
    5438:	00003517          	auipc	a0,0x3
    543c:	98850513          	addi	a0,a0,-1656 # 7dc0 <malloc+0x2126>
    5440:	00000097          	auipc	ra,0x0
    5444:	7a2080e7          	jalr	1954(ra) # 5be2 <printf>
    exit(1);
    5448:	4505                	li	a0,1
    544a:	00000097          	auipc	ra,0x0
    544e:	40e080e7          	jalr	1038(ra) # 5858 <exit>
    5452:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5454:	00003597          	auipc	a1,0x3
    5458:	90458593          	addi	a1,a1,-1788 # 7d58 <malloc+0x20be>
    545c:	6488                	ld	a0,8(s1)
    545e:	00000097          	auipc	ra,0x0
    5462:	194080e7          	jalr	404(ra) # 55f2 <strcmp>
    5466:	10050563          	beqz	a0,5570 <main+0x1e8>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    546a:	00003597          	auipc	a1,0x3
    546e:	9d658593          	addi	a1,a1,-1578 # 7e40 <malloc+0x21a6>
    5472:	6488                	ld	a0,8(s1)
    5474:	00000097          	auipc	ra,0x0
    5478:	17e080e7          	jalr	382(ra) # 55f2 <strcmp>
    547c:	c97d                	beqz	a0,5572 <main+0x1ea>
  } else if(argc == 2 && argv[1][0] != '-'){
    547e:	0084b903          	ld	s2,8(s1)
    5482:	00094703          	lbu	a4,0(s2)
    5486:	02d00793          	li	a5,45
    548a:	f2f71be3          	bne	a4,a5,53c0 <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    548e:	00003517          	auipc	a0,0x3
    5492:	8d250513          	addi	a0,a0,-1838 # 7d60 <malloc+0x20c6>
    5496:	00000097          	auipc	ra,0x0
    549a:	74c080e7          	jalr	1868(ra) # 5be2 <printf>
    exit(1);
    549e:	4505                	li	a0,1
    54a0:	00000097          	auipc	ra,0x0
    54a4:	3b8080e7          	jalr	952(ra) # 5858 <exit>
          exit(1);
    54a8:	4505                	li	a0,1
    54aa:	00000097          	auipc	ra,0x0
    54ae:	3ae080e7          	jalr	942(ra) # 5858 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    54b2:	40a905bb          	subw	a1,s2,a0
    54b6:	855a                	mv	a0,s6
    54b8:	00000097          	auipc	ra,0x0
    54bc:	72a080e7          	jalr	1834(ra) # 5be2 <printf>
        if(continuous != 2)
    54c0:	09498463          	beq	s3,s4,5548 <main+0x1c0>
          exit(1);
    54c4:	4505                	li	a0,1
    54c6:	00000097          	auipc	ra,0x0
    54ca:	392080e7          	jalr	914(ra) # 5858 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    54ce:	04c1                	addi	s1,s1,16
    54d0:	6488                	ld	a0,8(s1)
    54d2:	c115                	beqz	a0,54f6 <main+0x16e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    54d4:	00090863          	beqz	s2,54e4 <main+0x15c>
    54d8:	85ca                	mv	a1,s2
    54da:	00000097          	auipc	ra,0x0
    54de:	118080e7          	jalr	280(ra) # 55f2 <strcmp>
    54e2:	f575                	bnez	a0,54ce <main+0x146>
      if(!run(t->f, t->s))
    54e4:	648c                	ld	a1,8(s1)
    54e6:	6088                	ld	a0,0(s1)
    54e8:	00000097          	auipc	ra,0x0
    54ec:	e02080e7          	jalr	-510(ra) # 52ea <run>
    54f0:	fd79                	bnez	a0,54ce <main+0x146>
        fail = 1;
    54f2:	89d6                	mv	s3,s5
    54f4:	bfe9                	j	54ce <main+0x146>
  if(fail){
    54f6:	f20989e3          	beqz	s3,5428 <main+0xa0>
    printf("SOME TESTS FAILED\n");
    54fa:	00003517          	auipc	a0,0x3
    54fe:	8ae50513          	addi	a0,a0,-1874 # 7da8 <malloc+0x210e>
    5502:	00000097          	auipc	ra,0x0
    5506:	6e0080e7          	jalr	1760(ra) # 5be2 <printf>
    exit(1);
    550a:	4505                	li	a0,1
    550c:	00000097          	auipc	ra,0x0
    5510:	34c080e7          	jalr	844(ra) # 5858 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5514:	00003517          	auipc	a0,0x3
    5518:	8dc50513          	addi	a0,a0,-1828 # 7df0 <malloc+0x2156>
    551c:	00000097          	auipc	ra,0x0
    5520:	6c6080e7          	jalr	1734(ra) # 5be2 <printf>
    exit(0);
    5524:	4501                	li	a0,0
    5526:	00000097          	auipc	ra,0x0
    552a:	332080e7          	jalr	818(ra) # 5858 <exit>
        printf("SOME TESTS FAILED\n");
    552e:	8556                	mv	a0,s5
    5530:	00000097          	auipc	ra,0x0
    5534:	6b2080e7          	jalr	1714(ra) # 5be2 <printf>
        if(continuous != 2)
    5538:	f74998e3          	bne	s3,s4,54a8 <main+0x120>
      int free1 = countfree();
    553c:	00000097          	auipc	ra,0x0
    5540:	c7e080e7          	jalr	-898(ra) # 51ba <countfree>
      if(free1 < free0){
    5544:	f72547e3          	blt	a0,s2,54b2 <main+0x12a>
      int free0 = countfree();
    5548:	00000097          	auipc	ra,0x0
    554c:	c72080e7          	jalr	-910(ra) # 51ba <countfree>
    5550:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    5552:	bd843583          	ld	a1,-1064(s0)
    5556:	d1fd                	beqz	a1,553c <main+0x1b4>
    5558:	bd040493          	addi	s1,s0,-1072
        if(!run(t->f, t->s)){
    555c:	6088                	ld	a0,0(s1)
    555e:	00000097          	auipc	ra,0x0
    5562:	d8c080e7          	jalr	-628(ra) # 52ea <run>
    5566:	d561                	beqz	a0,552e <main+0x1a6>
      for (struct test *t = tests; t->s != 0; t++) {
    5568:	04c1                	addi	s1,s1,16
    556a:	648c                	ld	a1,8(s1)
    556c:	f9e5                	bnez	a1,555c <main+0x1d4>
    556e:	b7f9                	j	553c <main+0x1b4>
    continuous = 1;
    5570:	4985                	li	s3,1
  } tests[] = {
    5572:	00003797          	auipc	a5,0x3
    5576:	bf678793          	addi	a5,a5,-1034 # 8168 <malloc+0x24ce>
    557a:	bd040713          	addi	a4,s0,-1072
    557e:	00003317          	auipc	t1,0x3
    5582:	fda30313          	addi	t1,t1,-38 # 8558 <malloc+0x28be>
    5586:	0007b883          	ld	a7,0(a5)
    558a:	0087b803          	ld	a6,8(a5)
    558e:	6b88                	ld	a0,16(a5)
    5590:	6f8c                	ld	a1,24(a5)
    5592:	7390                	ld	a2,32(a5)
    5594:	7794                	ld	a3,40(a5)
    5596:	01173023          	sd	a7,0(a4)
    559a:	01073423          	sd	a6,8(a4)
    559e:	eb08                	sd	a0,16(a4)
    55a0:	ef0c                	sd	a1,24(a4)
    55a2:	f310                	sd	a2,32(a4)
    55a4:	f714                	sd	a3,40(a4)
    55a6:	03078793          	addi	a5,a5,48
    55aa:	03070713          	addi	a4,a4,48
    55ae:	fc679ce3          	bne	a5,t1,5586 <main+0x1fe>
    printf("continuous usertests starting\n");
    55b2:	00003517          	auipc	a0,0x3
    55b6:	86e50513          	addi	a0,a0,-1938 # 7e20 <malloc+0x2186>
    55ba:	00000097          	auipc	ra,0x0
    55be:	628080e7          	jalr	1576(ra) # 5be2 <printf>
        printf("SOME TESTS FAILED\n");
    55c2:	00002a97          	auipc	s5,0x2
    55c6:	7e6a8a93          	addi	s5,s5,2022 # 7da8 <malloc+0x210e>
        if(continuous != 2)
    55ca:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    55cc:	00002b17          	auipc	s6,0x2
    55d0:	7bcb0b13          	addi	s6,s6,1980 # 7d88 <malloc+0x20ee>
    55d4:	bf95                	j	5548 <main+0x1c0>

00000000000055d6 <strcpy>:



char*
strcpy(char *s, const char *t)
{
    55d6:	1141                	addi	sp,sp,-16
    55d8:	e422                	sd	s0,8(sp)
    55da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    55dc:	87aa                	mv	a5,a0
    55de:	0585                	addi	a1,a1,1
    55e0:	0785                	addi	a5,a5,1
    55e2:	fff5c703          	lbu	a4,-1(a1)
    55e6:	fee78fa3          	sb	a4,-1(a5)
    55ea:	fb75                	bnez	a4,55de <strcpy+0x8>
    ;
  return os;
}
    55ec:	6422                	ld	s0,8(sp)
    55ee:	0141                	addi	sp,sp,16
    55f0:	8082                	ret

00000000000055f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    55f2:	1141                	addi	sp,sp,-16
    55f4:	e422                	sd	s0,8(sp)
    55f6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    55f8:	00054783          	lbu	a5,0(a0)
    55fc:	cb91                	beqz	a5,5610 <strcmp+0x1e>
    55fe:	0005c703          	lbu	a4,0(a1)
    5602:	00f71763          	bne	a4,a5,5610 <strcmp+0x1e>
    p++, q++;
    5606:	0505                	addi	a0,a0,1
    5608:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    560a:	00054783          	lbu	a5,0(a0)
    560e:	fbe5                	bnez	a5,55fe <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5610:	0005c503          	lbu	a0,0(a1)
}
    5614:	40a7853b          	subw	a0,a5,a0
    5618:	6422                	ld	s0,8(sp)
    561a:	0141                	addi	sp,sp,16
    561c:	8082                	ret

000000000000561e <strlen>:

uint
strlen(const char *s)
{
    561e:	1141                	addi	sp,sp,-16
    5620:	e422                	sd	s0,8(sp)
    5622:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5624:	00054783          	lbu	a5,0(a0)
    5628:	cf91                	beqz	a5,5644 <strlen+0x26>
    562a:	0505                	addi	a0,a0,1
    562c:	87aa                	mv	a5,a0
    562e:	4685                	li	a3,1
    5630:	9e89                	subw	a3,a3,a0
    5632:	00f6853b          	addw	a0,a3,a5
    5636:	0785                	addi	a5,a5,1
    5638:	fff7c703          	lbu	a4,-1(a5)
    563c:	fb7d                	bnez	a4,5632 <strlen+0x14>
    ;
  return n;
}
    563e:	6422                	ld	s0,8(sp)
    5640:	0141                	addi	sp,sp,16
    5642:	8082                	ret
  for(n = 0; s[n]; n++)
    5644:	4501                	li	a0,0
    5646:	bfe5                	j	563e <strlen+0x20>

0000000000005648 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5648:	1141                	addi	sp,sp,-16
    564a:	e422                	sd	s0,8(sp)
    564c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    564e:	ca19                	beqz	a2,5664 <memset+0x1c>
    5650:	87aa                	mv	a5,a0
    5652:	1602                	slli	a2,a2,0x20
    5654:	9201                	srli	a2,a2,0x20
    5656:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    565a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    565e:	0785                	addi	a5,a5,1
    5660:	fee79de3          	bne	a5,a4,565a <memset+0x12>
  }
  return dst;
}
    5664:	6422                	ld	s0,8(sp)
    5666:	0141                	addi	sp,sp,16
    5668:	8082                	ret

000000000000566a <strchr>:

char*
strchr(const char *s, char c)
{
    566a:	1141                	addi	sp,sp,-16
    566c:	e422                	sd	s0,8(sp)
    566e:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5670:	00054783          	lbu	a5,0(a0)
    5674:	cb99                	beqz	a5,568a <strchr+0x20>
    if(*s == c)
    5676:	00f58763          	beq	a1,a5,5684 <strchr+0x1a>
  for(; *s; s++)
    567a:	0505                	addi	a0,a0,1
    567c:	00054783          	lbu	a5,0(a0)
    5680:	fbfd                	bnez	a5,5676 <strchr+0xc>
      return (char*)s;
  return 0;
    5682:	4501                	li	a0,0
}
    5684:	6422                	ld	s0,8(sp)
    5686:	0141                	addi	sp,sp,16
    5688:	8082                	ret
  return 0;
    568a:	4501                	li	a0,0
    568c:	bfe5                	j	5684 <strchr+0x1a>

000000000000568e <gets>:

char*
gets(char *buf, int max)
{
    568e:	711d                	addi	sp,sp,-96
    5690:	ec86                	sd	ra,88(sp)
    5692:	e8a2                	sd	s0,80(sp)
    5694:	e4a6                	sd	s1,72(sp)
    5696:	e0ca                	sd	s2,64(sp)
    5698:	fc4e                	sd	s3,56(sp)
    569a:	f852                	sd	s4,48(sp)
    569c:	f456                	sd	s5,40(sp)
    569e:	f05a                	sd	s6,32(sp)
    56a0:	ec5e                	sd	s7,24(sp)
    56a2:	1080                	addi	s0,sp,96
    56a4:	8baa                	mv	s7,a0
    56a6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    56a8:	892a                	mv	s2,a0
    56aa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    56ac:	4aa9                	li	s5,10
    56ae:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    56b0:	89a6                	mv	s3,s1
    56b2:	2485                	addiw	s1,s1,1
    56b4:	0344d863          	bge	s1,s4,56e4 <gets+0x56>
    cc = read(0, &c, 1);
    56b8:	4605                	li	a2,1
    56ba:	faf40593          	addi	a1,s0,-81
    56be:	4501                	li	a0,0
    56c0:	00000097          	auipc	ra,0x0
    56c4:	1b0080e7          	jalr	432(ra) # 5870 <read>
    if(cc < 1)
    56c8:	00a05e63          	blez	a0,56e4 <gets+0x56>
    buf[i++] = c;
    56cc:	faf44783          	lbu	a5,-81(s0)
    56d0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    56d4:	01578763          	beq	a5,s5,56e2 <gets+0x54>
    56d8:	0905                	addi	s2,s2,1
    56da:	fd679be3          	bne	a5,s6,56b0 <gets+0x22>
  for(i=0; i+1 < max; ){
    56de:	89a6                	mv	s3,s1
    56e0:	a011                	j	56e4 <gets+0x56>
    56e2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    56e4:	99de                	add	s3,s3,s7
    56e6:	00098023          	sb	zero,0(s3)
  return buf;
}
    56ea:	855e                	mv	a0,s7
    56ec:	60e6                	ld	ra,88(sp)
    56ee:	6446                	ld	s0,80(sp)
    56f0:	64a6                	ld	s1,72(sp)
    56f2:	6906                	ld	s2,64(sp)
    56f4:	79e2                	ld	s3,56(sp)
    56f6:	7a42                	ld	s4,48(sp)
    56f8:	7aa2                	ld	s5,40(sp)
    56fa:	7b02                	ld	s6,32(sp)
    56fc:	6be2                	ld	s7,24(sp)
    56fe:	6125                	addi	sp,sp,96
    5700:	8082                	ret

0000000000005702 <stat>:

int
stat(const char *n, struct stat *st)
{
    5702:	1101                	addi	sp,sp,-32
    5704:	ec06                	sd	ra,24(sp)
    5706:	e822                	sd	s0,16(sp)
    5708:	e426                	sd	s1,8(sp)
    570a:	e04a                	sd	s2,0(sp)
    570c:	1000                	addi	s0,sp,32
    570e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5710:	4581                	li	a1,0
    5712:	00000097          	auipc	ra,0x0
    5716:	186080e7          	jalr	390(ra) # 5898 <open>
  if(fd < 0)
    571a:	02054563          	bltz	a0,5744 <stat+0x42>
    571e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5720:	85ca                	mv	a1,s2
    5722:	00000097          	auipc	ra,0x0
    5726:	18e080e7          	jalr	398(ra) # 58b0 <fstat>
    572a:	892a                	mv	s2,a0
  close(fd);
    572c:	8526                	mv	a0,s1
    572e:	00000097          	auipc	ra,0x0
    5732:	152080e7          	jalr	338(ra) # 5880 <close>
  return r;
}
    5736:	854a                	mv	a0,s2
    5738:	60e2                	ld	ra,24(sp)
    573a:	6442                	ld	s0,16(sp)
    573c:	64a2                	ld	s1,8(sp)
    573e:	6902                	ld	s2,0(sp)
    5740:	6105                	addi	sp,sp,32
    5742:	8082                	ret
    return -1;
    5744:	597d                	li	s2,-1
    5746:	bfc5                	j	5736 <stat+0x34>

0000000000005748 <atoi>:

int
atoi(const char *s)
{
    5748:	1141                	addi	sp,sp,-16
    574a:	e422                	sd	s0,8(sp)
    574c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    574e:	00054683          	lbu	a3,0(a0)
    5752:	fd06879b          	addiw	a5,a3,-48
    5756:	0ff7f793          	zext.b	a5,a5
    575a:	4625                	li	a2,9
    575c:	02f66863          	bltu	a2,a5,578c <atoi+0x44>
    5760:	872a                	mv	a4,a0
  n = 0;
    5762:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5764:	0705                	addi	a4,a4,1
    5766:	0025179b          	slliw	a5,a0,0x2
    576a:	9fa9                	addw	a5,a5,a0
    576c:	0017979b          	slliw	a5,a5,0x1
    5770:	9fb5                	addw	a5,a5,a3
    5772:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5776:	00074683          	lbu	a3,0(a4)
    577a:	fd06879b          	addiw	a5,a3,-48
    577e:	0ff7f793          	zext.b	a5,a5
    5782:	fef671e3          	bgeu	a2,a5,5764 <atoi+0x1c>
  return n;
}
    5786:	6422                	ld	s0,8(sp)
    5788:	0141                	addi	sp,sp,16
    578a:	8082                	ret
  n = 0;
    578c:	4501                	li	a0,0
    578e:	bfe5                	j	5786 <atoi+0x3e>

0000000000005790 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5790:	1141                	addi	sp,sp,-16
    5792:	e422                	sd	s0,8(sp)
    5794:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5796:	02b57463          	bgeu	a0,a1,57be <memmove+0x2e>
    while(n-- > 0)
    579a:	00c05f63          	blez	a2,57b8 <memmove+0x28>
    579e:	1602                	slli	a2,a2,0x20
    57a0:	9201                	srli	a2,a2,0x20
    57a2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    57a6:	872a                	mv	a4,a0
      *dst++ = *src++;
    57a8:	0585                	addi	a1,a1,1
    57aa:	0705                	addi	a4,a4,1
    57ac:	fff5c683          	lbu	a3,-1(a1)
    57b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    57b4:	fee79ae3          	bne	a5,a4,57a8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    57b8:	6422                	ld	s0,8(sp)
    57ba:	0141                	addi	sp,sp,16
    57bc:	8082                	ret
    dst += n;
    57be:	00c50733          	add	a4,a0,a2
    src += n;
    57c2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    57c4:	fec05ae3          	blez	a2,57b8 <memmove+0x28>
    57c8:	fff6079b          	addiw	a5,a2,-1 # 2fff <iputtest+0x8b>
    57cc:	1782                	slli	a5,a5,0x20
    57ce:	9381                	srli	a5,a5,0x20
    57d0:	fff7c793          	not	a5,a5
    57d4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    57d6:	15fd                	addi	a1,a1,-1
    57d8:	177d                	addi	a4,a4,-1
    57da:	0005c683          	lbu	a3,0(a1)
    57de:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    57e2:	fee79ae3          	bne	a5,a4,57d6 <memmove+0x46>
    57e6:	bfc9                	j	57b8 <memmove+0x28>

00000000000057e8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    57e8:	1141                	addi	sp,sp,-16
    57ea:	e422                	sd	s0,8(sp)
    57ec:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    57ee:	ca05                	beqz	a2,581e <memcmp+0x36>
    57f0:	fff6069b          	addiw	a3,a2,-1
    57f4:	1682                	slli	a3,a3,0x20
    57f6:	9281                	srli	a3,a3,0x20
    57f8:	0685                	addi	a3,a3,1
    57fa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    57fc:	00054783          	lbu	a5,0(a0)
    5800:	0005c703          	lbu	a4,0(a1)
    5804:	00e79863          	bne	a5,a4,5814 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5808:	0505                	addi	a0,a0,1
    p2++;
    580a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    580c:	fed518e3          	bne	a0,a3,57fc <memcmp+0x14>
  }
  return 0;
    5810:	4501                	li	a0,0
    5812:	a019                	j	5818 <memcmp+0x30>
      return *p1 - *p2;
    5814:	40e7853b          	subw	a0,a5,a4
}
    5818:	6422                	ld	s0,8(sp)
    581a:	0141                	addi	sp,sp,16
    581c:	8082                	ret
  return 0;
    581e:	4501                	li	a0,0
    5820:	bfe5                	j	5818 <memcmp+0x30>

0000000000005822 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5822:	1141                	addi	sp,sp,-16
    5824:	e406                	sd	ra,8(sp)
    5826:	e022                	sd	s0,0(sp)
    5828:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    582a:	00000097          	auipc	ra,0x0
    582e:	f66080e7          	jalr	-154(ra) # 5790 <memmove>
}
    5832:	60a2                	ld	ra,8(sp)
    5834:	6402                	ld	s0,0(sp)
    5836:	0141                	addi	sp,sp,16
    5838:	8082                	ret

000000000000583a <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
    583a:	1141                	addi	sp,sp,-16
    583c:	e422                	sd	s0,8(sp)
    583e:	0800                	addi	s0,sp,16
  struct usyscall* u = (struct usyscall *)USYSCALL;
  return u->pid;
    5840:	040007b7          	lui	a5,0x4000
}
    5844:	17f5                	addi	a5,a5,-3 # 3fffffd <__BSS_END__+0x3ff11f5>
    5846:	07b2                	slli	a5,a5,0xc
    5848:	4388                	lw	a0,0(a5)
    584a:	6422                	ld	s0,8(sp)
    584c:	0141                	addi	sp,sp,16
    584e:	8082                	ret

0000000000005850 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5850:	4885                	li	a7,1
 ecall
    5852:	00000073          	ecall
 ret
    5856:	8082                	ret

0000000000005858 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5858:	4889                	li	a7,2
 ecall
    585a:	00000073          	ecall
 ret
    585e:	8082                	ret

0000000000005860 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5860:	488d                	li	a7,3
 ecall
    5862:	00000073          	ecall
 ret
    5866:	8082                	ret

0000000000005868 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5868:	4891                	li	a7,4
 ecall
    586a:	00000073          	ecall
 ret
    586e:	8082                	ret

0000000000005870 <read>:
.global read
read:
 li a7, SYS_read
    5870:	4895                	li	a7,5
 ecall
    5872:	00000073          	ecall
 ret
    5876:	8082                	ret

0000000000005878 <write>:
.global write
write:
 li a7, SYS_write
    5878:	48c1                	li	a7,16
 ecall
    587a:	00000073          	ecall
 ret
    587e:	8082                	ret

0000000000005880 <close>:
.global close
close:
 li a7, SYS_close
    5880:	48d5                	li	a7,21
 ecall
    5882:	00000073          	ecall
 ret
    5886:	8082                	ret

0000000000005888 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5888:	4899                	li	a7,6
 ecall
    588a:	00000073          	ecall
 ret
    588e:	8082                	ret

0000000000005890 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5890:	489d                	li	a7,7
 ecall
    5892:	00000073          	ecall
 ret
    5896:	8082                	ret

0000000000005898 <open>:
.global open
open:
 li a7, SYS_open
    5898:	48bd                	li	a7,15
 ecall
    589a:	00000073          	ecall
 ret
    589e:	8082                	ret

00000000000058a0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    58a0:	48c5                	li	a7,17
 ecall
    58a2:	00000073          	ecall
 ret
    58a6:	8082                	ret

00000000000058a8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    58a8:	48c9                	li	a7,18
 ecall
    58aa:	00000073          	ecall
 ret
    58ae:	8082                	ret

00000000000058b0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    58b0:	48a1                	li	a7,8
 ecall
    58b2:	00000073          	ecall
 ret
    58b6:	8082                	ret

00000000000058b8 <link>:
.global link
link:
 li a7, SYS_link
    58b8:	48cd                	li	a7,19
 ecall
    58ba:	00000073          	ecall
 ret
    58be:	8082                	ret

00000000000058c0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    58c0:	48d1                	li	a7,20
 ecall
    58c2:	00000073          	ecall
 ret
    58c6:	8082                	ret

00000000000058c8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    58c8:	48a5                	li	a7,9
 ecall
    58ca:	00000073          	ecall
 ret
    58ce:	8082                	ret

00000000000058d0 <dup>:
.global dup
dup:
 li a7, SYS_dup
    58d0:	48a9                	li	a7,10
 ecall
    58d2:	00000073          	ecall
 ret
    58d6:	8082                	ret

00000000000058d8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    58d8:	48ad                	li	a7,11
 ecall
    58da:	00000073          	ecall
 ret
    58de:	8082                	ret

00000000000058e0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    58e0:	48b1                	li	a7,12
 ecall
    58e2:	00000073          	ecall
 ret
    58e6:	8082                	ret

00000000000058e8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    58e8:	48b5                	li	a7,13
 ecall
    58ea:	00000073          	ecall
 ret
    58ee:	8082                	ret

00000000000058f0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    58f0:	48b9                	li	a7,14
 ecall
    58f2:	00000073          	ecall
 ret
    58f6:	8082                	ret

00000000000058f8 <connect>:
.global connect
connect:
 li a7, SYS_connect
    58f8:	48f5                	li	a7,29
 ecall
    58fa:	00000073          	ecall
 ret
    58fe:	8082                	ret

0000000000005900 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
    5900:	48f9                	li	a7,30
 ecall
    5902:	00000073          	ecall
 ret
    5906:	8082                	ret

0000000000005908 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5908:	1101                	addi	sp,sp,-32
    590a:	ec06                	sd	ra,24(sp)
    590c:	e822                	sd	s0,16(sp)
    590e:	1000                	addi	s0,sp,32
    5910:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5914:	4605                	li	a2,1
    5916:	fef40593          	addi	a1,s0,-17
    591a:	00000097          	auipc	ra,0x0
    591e:	f5e080e7          	jalr	-162(ra) # 5878 <write>
}
    5922:	60e2                	ld	ra,24(sp)
    5924:	6442                	ld	s0,16(sp)
    5926:	6105                	addi	sp,sp,32
    5928:	8082                	ret

000000000000592a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    592a:	7139                	addi	sp,sp,-64
    592c:	fc06                	sd	ra,56(sp)
    592e:	f822                	sd	s0,48(sp)
    5930:	f426                	sd	s1,40(sp)
    5932:	f04a                	sd	s2,32(sp)
    5934:	ec4e                	sd	s3,24(sp)
    5936:	0080                	addi	s0,sp,64
    5938:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    593a:	c299                	beqz	a3,5940 <printint+0x16>
    593c:	0805c963          	bltz	a1,59ce <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5940:	2581                	sext.w	a1,a1
  neg = 0;
    5942:	4881                	li	a7,0
    5944:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5948:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    594a:	2601                	sext.w	a2,a2
    594c:	00003517          	auipc	a0,0x3
    5950:	c6c50513          	addi	a0,a0,-916 # 85b8 <digits>
    5954:	883a                	mv	a6,a4
    5956:	2705                	addiw	a4,a4,1
    5958:	02c5f7bb          	remuw	a5,a1,a2
    595c:	1782                	slli	a5,a5,0x20
    595e:	9381                	srli	a5,a5,0x20
    5960:	97aa                	add	a5,a5,a0
    5962:	0007c783          	lbu	a5,0(a5)
    5966:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    596a:	0005879b          	sext.w	a5,a1
    596e:	02c5d5bb          	divuw	a1,a1,a2
    5972:	0685                	addi	a3,a3,1
    5974:	fec7f0e3          	bgeu	a5,a2,5954 <printint+0x2a>
  if(neg)
    5978:	00088c63          	beqz	a7,5990 <printint+0x66>
    buf[i++] = '-';
    597c:	fd070793          	addi	a5,a4,-48
    5980:	00878733          	add	a4,a5,s0
    5984:	02d00793          	li	a5,45
    5988:	fef70823          	sb	a5,-16(a4)
    598c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5990:	02e05863          	blez	a4,59c0 <printint+0x96>
    5994:	fc040793          	addi	a5,s0,-64
    5998:	00e78933          	add	s2,a5,a4
    599c:	fff78993          	addi	s3,a5,-1
    59a0:	99ba                	add	s3,s3,a4
    59a2:	377d                	addiw	a4,a4,-1
    59a4:	1702                	slli	a4,a4,0x20
    59a6:	9301                	srli	a4,a4,0x20
    59a8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    59ac:	fff94583          	lbu	a1,-1(s2)
    59b0:	8526                	mv	a0,s1
    59b2:	00000097          	auipc	ra,0x0
    59b6:	f56080e7          	jalr	-170(ra) # 5908 <putc>
  while(--i >= 0)
    59ba:	197d                	addi	s2,s2,-1
    59bc:	ff3918e3          	bne	s2,s3,59ac <printint+0x82>
}
    59c0:	70e2                	ld	ra,56(sp)
    59c2:	7442                	ld	s0,48(sp)
    59c4:	74a2                	ld	s1,40(sp)
    59c6:	7902                	ld	s2,32(sp)
    59c8:	69e2                	ld	s3,24(sp)
    59ca:	6121                	addi	sp,sp,64
    59cc:	8082                	ret
    x = -xx;
    59ce:	40b005bb          	negw	a1,a1
    neg = 1;
    59d2:	4885                	li	a7,1
    x = -xx;
    59d4:	bf85                	j	5944 <printint+0x1a>

00000000000059d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    59d6:	7119                	addi	sp,sp,-128
    59d8:	fc86                	sd	ra,120(sp)
    59da:	f8a2                	sd	s0,112(sp)
    59dc:	f4a6                	sd	s1,104(sp)
    59de:	f0ca                	sd	s2,96(sp)
    59e0:	ecce                	sd	s3,88(sp)
    59e2:	e8d2                	sd	s4,80(sp)
    59e4:	e4d6                	sd	s5,72(sp)
    59e6:	e0da                	sd	s6,64(sp)
    59e8:	fc5e                	sd	s7,56(sp)
    59ea:	f862                	sd	s8,48(sp)
    59ec:	f466                	sd	s9,40(sp)
    59ee:	f06a                	sd	s10,32(sp)
    59f0:	ec6e                	sd	s11,24(sp)
    59f2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    59f4:	0005c903          	lbu	s2,0(a1)
    59f8:	18090f63          	beqz	s2,5b96 <vprintf+0x1c0>
    59fc:	8aaa                	mv	s5,a0
    59fe:	8b32                	mv	s6,a2
    5a00:	00158493          	addi	s1,a1,1
  state = 0;
    5a04:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5a06:	02500a13          	li	s4,37
    5a0a:	4c55                	li	s8,21
    5a0c:	00003c97          	auipc	s9,0x3
    5a10:	b54c8c93          	addi	s9,s9,-1196 # 8560 <malloc+0x28c6>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    5a14:	02800d93          	li	s11,40
  putc(fd, 'x');
    5a18:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5a1a:	00003b97          	auipc	s7,0x3
    5a1e:	b9eb8b93          	addi	s7,s7,-1122 # 85b8 <digits>
    5a22:	a839                	j	5a40 <vprintf+0x6a>
        putc(fd, c);
    5a24:	85ca                	mv	a1,s2
    5a26:	8556                	mv	a0,s5
    5a28:	00000097          	auipc	ra,0x0
    5a2c:	ee0080e7          	jalr	-288(ra) # 5908 <putc>
    5a30:	a019                	j	5a36 <vprintf+0x60>
    } else if(state == '%'){
    5a32:	01498d63          	beq	s3,s4,5a4c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    5a36:	0485                	addi	s1,s1,1
    5a38:	fff4c903          	lbu	s2,-1(s1)
    5a3c:	14090d63          	beqz	s2,5b96 <vprintf+0x1c0>
    if(state == 0){
    5a40:	fe0999e3          	bnez	s3,5a32 <vprintf+0x5c>
      if(c == '%'){
    5a44:	ff4910e3          	bne	s2,s4,5a24 <vprintf+0x4e>
        state = '%';
    5a48:	89d2                	mv	s3,s4
    5a4a:	b7f5                	j	5a36 <vprintf+0x60>
      if(c == 'd'){
    5a4c:	11490c63          	beq	s2,s4,5b64 <vprintf+0x18e>
    5a50:	f9d9079b          	addiw	a5,s2,-99
    5a54:	0ff7f793          	zext.b	a5,a5
    5a58:	10fc6e63          	bltu	s8,a5,5b74 <vprintf+0x19e>
    5a5c:	f9d9079b          	addiw	a5,s2,-99
    5a60:	0ff7f713          	zext.b	a4,a5
    5a64:	10ec6863          	bltu	s8,a4,5b74 <vprintf+0x19e>
    5a68:	00271793          	slli	a5,a4,0x2
    5a6c:	97e6                	add	a5,a5,s9
    5a6e:	439c                	lw	a5,0(a5)
    5a70:	97e6                	add	a5,a5,s9
    5a72:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5a74:	008b0913          	addi	s2,s6,8
    5a78:	4685                	li	a3,1
    5a7a:	4629                	li	a2,10
    5a7c:	000b2583          	lw	a1,0(s6)
    5a80:	8556                	mv	a0,s5
    5a82:	00000097          	auipc	ra,0x0
    5a86:	ea8080e7          	jalr	-344(ra) # 592a <printint>
    5a8a:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5a8c:	4981                	li	s3,0
    5a8e:	b765                	j	5a36 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a90:	008b0913          	addi	s2,s6,8
    5a94:	4681                	li	a3,0
    5a96:	4629                	li	a2,10
    5a98:	000b2583          	lw	a1,0(s6)
    5a9c:	8556                	mv	a0,s5
    5a9e:	00000097          	auipc	ra,0x0
    5aa2:	e8c080e7          	jalr	-372(ra) # 592a <printint>
    5aa6:	8b4a                	mv	s6,s2
      state = 0;
    5aa8:	4981                	li	s3,0
    5aaa:	b771                	j	5a36 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5aac:	008b0913          	addi	s2,s6,8
    5ab0:	4681                	li	a3,0
    5ab2:	866a                	mv	a2,s10
    5ab4:	000b2583          	lw	a1,0(s6)
    5ab8:	8556                	mv	a0,s5
    5aba:	00000097          	auipc	ra,0x0
    5abe:	e70080e7          	jalr	-400(ra) # 592a <printint>
    5ac2:	8b4a                	mv	s6,s2
      state = 0;
    5ac4:	4981                	li	s3,0
    5ac6:	bf85                	j	5a36 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5ac8:	008b0793          	addi	a5,s6,8
    5acc:	f8f43423          	sd	a5,-120(s0)
    5ad0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5ad4:	03000593          	li	a1,48
    5ad8:	8556                	mv	a0,s5
    5ada:	00000097          	auipc	ra,0x0
    5ade:	e2e080e7          	jalr	-466(ra) # 5908 <putc>
  putc(fd, 'x');
    5ae2:	07800593          	li	a1,120
    5ae6:	8556                	mv	a0,s5
    5ae8:	00000097          	auipc	ra,0x0
    5aec:	e20080e7          	jalr	-480(ra) # 5908 <putc>
    5af0:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5af2:	03c9d793          	srli	a5,s3,0x3c
    5af6:	97de                	add	a5,a5,s7
    5af8:	0007c583          	lbu	a1,0(a5)
    5afc:	8556                	mv	a0,s5
    5afe:	00000097          	auipc	ra,0x0
    5b02:	e0a080e7          	jalr	-502(ra) # 5908 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5b06:	0992                	slli	s3,s3,0x4
    5b08:	397d                	addiw	s2,s2,-1
    5b0a:	fe0914e3          	bnez	s2,5af2 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    5b0e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5b12:	4981                	li	s3,0
    5b14:	b70d                	j	5a36 <vprintf+0x60>
        s = va_arg(ap, char*);
    5b16:	008b0913          	addi	s2,s6,8
    5b1a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    5b1e:	02098163          	beqz	s3,5b40 <vprintf+0x16a>
        while(*s != 0){
    5b22:	0009c583          	lbu	a1,0(s3)
    5b26:	c5ad                	beqz	a1,5b90 <vprintf+0x1ba>
          putc(fd, *s);
    5b28:	8556                	mv	a0,s5
    5b2a:	00000097          	auipc	ra,0x0
    5b2e:	dde080e7          	jalr	-546(ra) # 5908 <putc>
          s++;
    5b32:	0985                	addi	s3,s3,1
        while(*s != 0){
    5b34:	0009c583          	lbu	a1,0(s3)
    5b38:	f9e5                	bnez	a1,5b28 <vprintf+0x152>
        s = va_arg(ap, char*);
    5b3a:	8b4a                	mv	s6,s2
      state = 0;
    5b3c:	4981                	li	s3,0
    5b3e:	bde5                	j	5a36 <vprintf+0x60>
          s = "(null)";
    5b40:	00003997          	auipc	s3,0x3
    5b44:	a1898993          	addi	s3,s3,-1512 # 8558 <malloc+0x28be>
        while(*s != 0){
    5b48:	85ee                	mv	a1,s11
    5b4a:	bff9                	j	5b28 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    5b4c:	008b0913          	addi	s2,s6,8
    5b50:	000b4583          	lbu	a1,0(s6)
    5b54:	8556                	mv	a0,s5
    5b56:	00000097          	auipc	ra,0x0
    5b5a:	db2080e7          	jalr	-590(ra) # 5908 <putc>
    5b5e:	8b4a                	mv	s6,s2
      state = 0;
    5b60:	4981                	li	s3,0
    5b62:	bdd1                	j	5a36 <vprintf+0x60>
        putc(fd, c);
    5b64:	85d2                	mv	a1,s4
    5b66:	8556                	mv	a0,s5
    5b68:	00000097          	auipc	ra,0x0
    5b6c:	da0080e7          	jalr	-608(ra) # 5908 <putc>
      state = 0;
    5b70:	4981                	li	s3,0
    5b72:	b5d1                	j	5a36 <vprintf+0x60>
        putc(fd, '%');
    5b74:	85d2                	mv	a1,s4
    5b76:	8556                	mv	a0,s5
    5b78:	00000097          	auipc	ra,0x0
    5b7c:	d90080e7          	jalr	-624(ra) # 5908 <putc>
        putc(fd, c);
    5b80:	85ca                	mv	a1,s2
    5b82:	8556                	mv	a0,s5
    5b84:	00000097          	auipc	ra,0x0
    5b88:	d84080e7          	jalr	-636(ra) # 5908 <putc>
      state = 0;
    5b8c:	4981                	li	s3,0
    5b8e:	b565                	j	5a36 <vprintf+0x60>
        s = va_arg(ap, char*);
    5b90:	8b4a                	mv	s6,s2
      state = 0;
    5b92:	4981                	li	s3,0
    5b94:	b54d                	j	5a36 <vprintf+0x60>
    }
  }
}
    5b96:	70e6                	ld	ra,120(sp)
    5b98:	7446                	ld	s0,112(sp)
    5b9a:	74a6                	ld	s1,104(sp)
    5b9c:	7906                	ld	s2,96(sp)
    5b9e:	69e6                	ld	s3,88(sp)
    5ba0:	6a46                	ld	s4,80(sp)
    5ba2:	6aa6                	ld	s5,72(sp)
    5ba4:	6b06                	ld	s6,64(sp)
    5ba6:	7be2                	ld	s7,56(sp)
    5ba8:	7c42                	ld	s8,48(sp)
    5baa:	7ca2                	ld	s9,40(sp)
    5bac:	7d02                	ld	s10,32(sp)
    5bae:	6de2                	ld	s11,24(sp)
    5bb0:	6109                	addi	sp,sp,128
    5bb2:	8082                	ret

0000000000005bb4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5bb4:	715d                	addi	sp,sp,-80
    5bb6:	ec06                	sd	ra,24(sp)
    5bb8:	e822                	sd	s0,16(sp)
    5bba:	1000                	addi	s0,sp,32
    5bbc:	e010                	sd	a2,0(s0)
    5bbe:	e414                	sd	a3,8(s0)
    5bc0:	e818                	sd	a4,16(s0)
    5bc2:	ec1c                	sd	a5,24(s0)
    5bc4:	03043023          	sd	a6,32(s0)
    5bc8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5bcc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5bd0:	8622                	mv	a2,s0
    5bd2:	00000097          	auipc	ra,0x0
    5bd6:	e04080e7          	jalr	-508(ra) # 59d6 <vprintf>
}
    5bda:	60e2                	ld	ra,24(sp)
    5bdc:	6442                	ld	s0,16(sp)
    5bde:	6161                	addi	sp,sp,80
    5be0:	8082                	ret

0000000000005be2 <printf>:

void
printf(const char *fmt, ...)
{
    5be2:	711d                	addi	sp,sp,-96
    5be4:	ec06                	sd	ra,24(sp)
    5be6:	e822                	sd	s0,16(sp)
    5be8:	1000                	addi	s0,sp,32
    5bea:	e40c                	sd	a1,8(s0)
    5bec:	e810                	sd	a2,16(s0)
    5bee:	ec14                	sd	a3,24(s0)
    5bf0:	f018                	sd	a4,32(s0)
    5bf2:	f41c                	sd	a5,40(s0)
    5bf4:	03043823          	sd	a6,48(s0)
    5bf8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5bfc:	00840613          	addi	a2,s0,8
    5c00:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5c04:	85aa                	mv	a1,a0
    5c06:	4505                	li	a0,1
    5c08:	00000097          	auipc	ra,0x0
    5c0c:	dce080e7          	jalr	-562(ra) # 59d6 <vprintf>
}
    5c10:	60e2                	ld	ra,24(sp)
    5c12:	6442                	ld	s0,16(sp)
    5c14:	6125                	addi	sp,sp,96
    5c16:	8082                	ret

0000000000005c18 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5c18:	1141                	addi	sp,sp,-16
    5c1a:	e422                	sd	s0,8(sp)
    5c1c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5c1e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c22:	00003797          	auipc	a5,0x3
    5c26:	9b67b783          	ld	a5,-1610(a5) # 85d8 <freep>
    5c2a:	a02d                	j	5c54 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5c2c:	4618                	lw	a4,8(a2)
    5c2e:	9f2d                	addw	a4,a4,a1
    5c30:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5c34:	6398                	ld	a4,0(a5)
    5c36:	6310                	ld	a2,0(a4)
    5c38:	a83d                	j	5c76 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5c3a:	ff852703          	lw	a4,-8(a0)
    5c3e:	9f31                	addw	a4,a4,a2
    5c40:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5c42:	ff053683          	ld	a3,-16(a0)
    5c46:	a091                	j	5c8a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c48:	6398                	ld	a4,0(a5)
    5c4a:	00e7e463          	bltu	a5,a4,5c52 <free+0x3a>
    5c4e:	00e6ea63          	bltu	a3,a4,5c62 <free+0x4a>
{
    5c52:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c54:	fed7fae3          	bgeu	a5,a3,5c48 <free+0x30>
    5c58:	6398                	ld	a4,0(a5)
    5c5a:	00e6e463          	bltu	a3,a4,5c62 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c5e:	fee7eae3          	bltu	a5,a4,5c52 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5c62:	ff852583          	lw	a1,-8(a0)
    5c66:	6390                	ld	a2,0(a5)
    5c68:	02059813          	slli	a6,a1,0x20
    5c6c:	01c85713          	srli	a4,a6,0x1c
    5c70:	9736                	add	a4,a4,a3
    5c72:	fae60de3          	beq	a2,a4,5c2c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5c76:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5c7a:	4790                	lw	a2,8(a5)
    5c7c:	02061593          	slli	a1,a2,0x20
    5c80:	01c5d713          	srli	a4,a1,0x1c
    5c84:	973e                	add	a4,a4,a5
    5c86:	fae68ae3          	beq	a3,a4,5c3a <free+0x22>
    p->s.ptr = bp->s.ptr;
    5c8a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5c8c:	00003717          	auipc	a4,0x3
    5c90:	94f73623          	sd	a5,-1716(a4) # 85d8 <freep>
}
    5c94:	6422                	ld	s0,8(sp)
    5c96:	0141                	addi	sp,sp,16
    5c98:	8082                	ret

0000000000005c9a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5c9a:	7139                	addi	sp,sp,-64
    5c9c:	fc06                	sd	ra,56(sp)
    5c9e:	f822                	sd	s0,48(sp)
    5ca0:	f426                	sd	s1,40(sp)
    5ca2:	f04a                	sd	s2,32(sp)
    5ca4:	ec4e                	sd	s3,24(sp)
    5ca6:	e852                	sd	s4,16(sp)
    5ca8:	e456                	sd	s5,8(sp)
    5caa:	e05a                	sd	s6,0(sp)
    5cac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5cae:	02051493          	slli	s1,a0,0x20
    5cb2:	9081                	srli	s1,s1,0x20
    5cb4:	04bd                	addi	s1,s1,15
    5cb6:	8091                	srli	s1,s1,0x4
    5cb8:	0014899b          	addiw	s3,s1,1
    5cbc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5cbe:	00003517          	auipc	a0,0x3
    5cc2:	91a53503          	ld	a0,-1766(a0) # 85d8 <freep>
    5cc6:	c515                	beqz	a0,5cf2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5cc8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5cca:	4798                	lw	a4,8(a5)
    5ccc:	02977f63          	bgeu	a4,s1,5d0a <malloc+0x70>
    5cd0:	8a4e                	mv	s4,s3
    5cd2:	0009871b          	sext.w	a4,s3
    5cd6:	6685                	lui	a3,0x1
    5cd8:	00d77363          	bgeu	a4,a3,5cde <malloc+0x44>
    5cdc:	6a05                	lui	s4,0x1
    5cde:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5ce2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5ce6:	00003917          	auipc	s2,0x3
    5cea:	8f290913          	addi	s2,s2,-1806 # 85d8 <freep>
  if(p == (char*)-1)
    5cee:	5afd                	li	s5,-1
    5cf0:	a895                	j	5d64 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5cf2:	00009797          	auipc	a5,0x9
    5cf6:	10678793          	addi	a5,a5,262 # edf8 <base>
    5cfa:	00003717          	auipc	a4,0x3
    5cfe:	8cf73f23          	sd	a5,-1826(a4) # 85d8 <freep>
    5d02:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5d04:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5d08:	b7e1                	j	5cd0 <malloc+0x36>
      if(p->s.size == nunits)
    5d0a:	02e48c63          	beq	s1,a4,5d42 <malloc+0xa8>
        p->s.size -= nunits;
    5d0e:	4137073b          	subw	a4,a4,s3
    5d12:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5d14:	02071693          	slli	a3,a4,0x20
    5d18:	01c6d713          	srli	a4,a3,0x1c
    5d1c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5d1e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5d22:	00003717          	auipc	a4,0x3
    5d26:	8aa73b23          	sd	a0,-1866(a4) # 85d8 <freep>
      return (void*)(p + 1);
    5d2a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5d2e:	70e2                	ld	ra,56(sp)
    5d30:	7442                	ld	s0,48(sp)
    5d32:	74a2                	ld	s1,40(sp)
    5d34:	7902                	ld	s2,32(sp)
    5d36:	69e2                	ld	s3,24(sp)
    5d38:	6a42                	ld	s4,16(sp)
    5d3a:	6aa2                	ld	s5,8(sp)
    5d3c:	6b02                	ld	s6,0(sp)
    5d3e:	6121                	addi	sp,sp,64
    5d40:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5d42:	6398                	ld	a4,0(a5)
    5d44:	e118                	sd	a4,0(a0)
    5d46:	bff1                	j	5d22 <malloc+0x88>
  hp->s.size = nu;
    5d48:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5d4c:	0541                	addi	a0,a0,16
    5d4e:	00000097          	auipc	ra,0x0
    5d52:	eca080e7          	jalr	-310(ra) # 5c18 <free>
  return freep;
    5d56:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5d5a:	d971                	beqz	a0,5d2e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5d5c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5d5e:	4798                	lw	a4,8(a5)
    5d60:	fa9775e3          	bgeu	a4,s1,5d0a <malloc+0x70>
    if(p == freep)
    5d64:	00093703          	ld	a4,0(s2)
    5d68:	853e                	mv	a0,a5
    5d6a:	fef719e3          	bne	a4,a5,5d5c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5d6e:	8552                	mv	a0,s4
    5d70:	00000097          	auipc	ra,0x0
    5d74:	b70080e7          	jalr	-1168(ra) # 58e0 <sbrk>
  if(p == (char*)-1)
    5d78:	fd5518e3          	bne	a0,s5,5d48 <malloc+0xae>
        return 0;
    5d7c:	4501                	li	a0,0
    5d7e:	bf45                	j	5d2e <malloc+0x94>
