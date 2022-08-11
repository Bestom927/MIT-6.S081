
user/_sh：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  fprintf(2, "$ ");
      10:	00001597          	auipc	a1,0x1
      14:	2f858593          	addi	a1,a1,760 # 1308 <malloc+0xe8>
      18:	4509                	li	a0,2
      1a:	00001097          	auipc	ra,0x1
      1e:	120080e7          	jalr	288(ra) # 113a <fprintf>
  memset(buf, 0, nbuf);
      22:	864a                	mv	a2,s2
      24:	4581                	li	a1,0
      26:	8526                	mv	a0,s1
      28:	00001097          	auipc	ra,0x1
      2c:	ba6080e7          	jalr	-1114(ra) # bce <memset>
  gets(buf, nbuf);
      30:	85ca                	mv	a1,s2
      32:	8526                	mv	a0,s1
      34:	00001097          	auipc	ra,0x1
      38:	be0080e7          	jalr	-1056(ra) # c14 <gets>
  if(buf[0] == 0) // EOF
      3c:	0004c503          	lbu	a0,0(s1)
      40:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      44:	40a00533          	neg	a0,a0
      48:	60e2                	ld	ra,24(sp)
      4a:	6442                	ld	s0,16(sp)
      4c:	64a2                	ld	s1,8(sp)
      4e:	6902                	ld	s2,0(sp)
      50:	6105                	addi	sp,sp,32
      52:	8082                	ret

0000000000000054 <panic>:
  exit(0);
}

void
panic(char *s)
{
      54:	1141                	addi	sp,sp,-16
      56:	e406                	sd	ra,8(sp)
      58:	e022                	sd	s0,0(sp)
      5a:	0800                	addi	s0,sp,16
      5c:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      5e:	00001597          	auipc	a1,0x1
      62:	2b258593          	addi	a1,a1,690 # 1310 <malloc+0xf0>
      66:	4509                	li	a0,2
      68:	00001097          	auipc	ra,0x1
      6c:	0d2080e7          	jalr	210(ra) # 113a <fprintf>
  exit(1);
      70:	4505                	li	a0,1
      72:	00001097          	auipc	ra,0x1
      76:	d6c080e7          	jalr	-660(ra) # dde <exit>

000000000000007a <fork1>:
}

int
fork1(void)
{
      7a:	1141                	addi	sp,sp,-16
      7c:	e406                	sd	ra,8(sp)
      7e:	e022                	sd	s0,0(sp)
      80:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      82:	00001097          	auipc	ra,0x1
      86:	d54080e7          	jalr	-684(ra) # dd6 <fork>
  if(pid == -1)
      8a:	57fd                	li	a5,-1
      8c:	00f50663          	beq	a0,a5,98 <fork1+0x1e>
    panic("fork");
  return pid;
}
      90:	60a2                	ld	ra,8(sp)
      92:	6402                	ld	s0,0(sp)
      94:	0141                	addi	sp,sp,16
      96:	8082                	ret
    panic("fork");
      98:	00001517          	auipc	a0,0x1
      9c:	28050513          	addi	a0,a0,640 # 1318 <malloc+0xf8>
      a0:	00000097          	auipc	ra,0x0
      a4:	fb4080e7          	jalr	-76(ra) # 54 <panic>

00000000000000a8 <runcmd>:
{
      a8:	7179                	addi	sp,sp,-48
      aa:	f406                	sd	ra,40(sp)
      ac:	f022                	sd	s0,32(sp)
      ae:	ec26                	sd	s1,24(sp)
      b0:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b2:	c10d                	beqz	a0,d4 <runcmd+0x2c>
      b4:	84aa                	mv	s1,a0
  switch(cmd->type){
      b6:	4118                	lw	a4,0(a0)
      b8:	4795                	li	a5,5
      ba:	02e7e263          	bltu	a5,a4,de <runcmd+0x36>
      be:	00056783          	lwu	a5,0(a0)
      c2:	078a                	slli	a5,a5,0x2
      c4:	00001717          	auipc	a4,0x1
      c8:	35470713          	addi	a4,a4,852 # 1418 <malloc+0x1f8>
      cc:	97ba                	add	a5,a5,a4
      ce:	439c                	lw	a5,0(a5)
      d0:	97ba                	add	a5,a5,a4
      d2:	8782                	jr	a5
    exit(1);
      d4:	4505                	li	a0,1
      d6:	00001097          	auipc	ra,0x1
      da:	d08080e7          	jalr	-760(ra) # dde <exit>
    panic("runcmd");
      de:	00001517          	auipc	a0,0x1
      e2:	24250513          	addi	a0,a0,578 # 1320 <malloc+0x100>
      e6:	00000097          	auipc	ra,0x0
      ea:	f6e080e7          	jalr	-146(ra) # 54 <panic>
    if(ecmd->argv[0] == 0)
      ee:	6508                	ld	a0,8(a0)
      f0:	c515                	beqz	a0,11c <runcmd+0x74>
    exec(ecmd->argv[0], ecmd->argv);
      f2:	00848593          	addi	a1,s1,8
      f6:	00001097          	auipc	ra,0x1
      fa:	d20080e7          	jalr	-736(ra) # e16 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      fe:	6490                	ld	a2,8(s1)
     100:	00001597          	auipc	a1,0x1
     104:	22858593          	addi	a1,a1,552 # 1328 <malloc+0x108>
     108:	4509                	li	a0,2
     10a:	00001097          	auipc	ra,0x1
     10e:	030080e7          	jalr	48(ra) # 113a <fprintf>
  exit(0);
     112:	4501                	li	a0,0
     114:	00001097          	auipc	ra,0x1
     118:	cca080e7          	jalr	-822(ra) # dde <exit>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	00001097          	auipc	ra,0x1
     122:	cc0080e7          	jalr	-832(ra) # dde <exit>
    close(rcmd->fd);
     126:	5148                	lw	a0,36(a0)
     128:	00001097          	auipc	ra,0x1
     12c:	cde080e7          	jalr	-802(ra) # e06 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     130:	508c                	lw	a1,32(s1)
     132:	6888                	ld	a0,16(s1)
     134:	00001097          	auipc	ra,0x1
     138:	cea080e7          	jalr	-790(ra) # e1e <open>
     13c:	00054763          	bltz	a0,14a <runcmd+0xa2>
    runcmd(rcmd->cmd);
     140:	6488                	ld	a0,8(s1)
     142:	00000097          	auipc	ra,0x0
     146:	f66080e7          	jalr	-154(ra) # a8 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14a:	6890                	ld	a2,16(s1)
     14c:	00001597          	auipc	a1,0x1
     150:	1ec58593          	addi	a1,a1,492 # 1338 <malloc+0x118>
     154:	4509                	li	a0,2
     156:	00001097          	auipc	ra,0x1
     15a:	fe4080e7          	jalr	-28(ra) # 113a <fprintf>
      exit(1);
     15e:	4505                	li	a0,1
     160:	00001097          	auipc	ra,0x1
     164:	c7e080e7          	jalr	-898(ra) # dde <exit>
    if(fork1() == 0)
     168:	00000097          	auipc	ra,0x0
     16c:	f12080e7          	jalr	-238(ra) # 7a <fork1>
     170:	c919                	beqz	a0,186 <runcmd+0xde>
    wait(0);
     172:	4501                	li	a0,0
     174:	00001097          	auipc	ra,0x1
     178:	c72080e7          	jalr	-910(ra) # de6 <wait>
    runcmd(lcmd->right);
     17c:	6888                	ld	a0,16(s1)
     17e:	00000097          	auipc	ra,0x0
     182:	f2a080e7          	jalr	-214(ra) # a8 <runcmd>
      runcmd(lcmd->left);
     186:	6488                	ld	a0,8(s1)
     188:	00000097          	auipc	ra,0x0
     18c:	f20080e7          	jalr	-224(ra) # a8 <runcmd>
    if(pipe(p) < 0)
     190:	fd840513          	addi	a0,s0,-40
     194:	00001097          	auipc	ra,0x1
     198:	c5a080e7          	jalr	-934(ra) # dee <pipe>
     19c:	04054363          	bltz	a0,1e2 <runcmd+0x13a>
    if(fork1() == 0){
     1a0:	00000097          	auipc	ra,0x0
     1a4:	eda080e7          	jalr	-294(ra) # 7a <fork1>
     1a8:	c529                	beqz	a0,1f2 <runcmd+0x14a>
    if(fork1() == 0){
     1aa:	00000097          	auipc	ra,0x0
     1ae:	ed0080e7          	jalr	-304(ra) # 7a <fork1>
     1b2:	cd25                	beqz	a0,22a <runcmd+0x182>
    close(p[0]);
     1b4:	fd842503          	lw	a0,-40(s0)
     1b8:	00001097          	auipc	ra,0x1
     1bc:	c4e080e7          	jalr	-946(ra) # e06 <close>
    close(p[1]);
     1c0:	fdc42503          	lw	a0,-36(s0)
     1c4:	00001097          	auipc	ra,0x1
     1c8:	c42080e7          	jalr	-958(ra) # e06 <close>
    wait(0);
     1cc:	4501                	li	a0,0
     1ce:	00001097          	auipc	ra,0x1
     1d2:	c18080e7          	jalr	-1000(ra) # de6 <wait>
    wait(0);
     1d6:	4501                	li	a0,0
     1d8:	00001097          	auipc	ra,0x1
     1dc:	c0e080e7          	jalr	-1010(ra) # de6 <wait>
    break;
     1e0:	bf0d                	j	112 <runcmd+0x6a>
      panic("pipe");
     1e2:	00001517          	auipc	a0,0x1
     1e6:	16650513          	addi	a0,a0,358 # 1348 <malloc+0x128>
     1ea:	00000097          	auipc	ra,0x0
     1ee:	e6a080e7          	jalr	-406(ra) # 54 <panic>
      close(1);
     1f2:	4505                	li	a0,1
     1f4:	00001097          	auipc	ra,0x1
     1f8:	c12080e7          	jalr	-1006(ra) # e06 <close>
      dup(p[1]);
     1fc:	fdc42503          	lw	a0,-36(s0)
     200:	00001097          	auipc	ra,0x1
     204:	c56080e7          	jalr	-938(ra) # e56 <dup>
      close(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	bfa080e7          	jalr	-1030(ra) # e06 <close>
      close(p[1]);
     214:	fdc42503          	lw	a0,-36(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	bee080e7          	jalr	-1042(ra) # e06 <close>
      runcmd(pcmd->left);
     220:	6488                	ld	a0,8(s1)
     222:	00000097          	auipc	ra,0x0
     226:	e86080e7          	jalr	-378(ra) # a8 <runcmd>
      close(0);
     22a:	00001097          	auipc	ra,0x1
     22e:	bdc080e7          	jalr	-1060(ra) # e06 <close>
      dup(p[0]);
     232:	fd842503          	lw	a0,-40(s0)
     236:	00001097          	auipc	ra,0x1
     23a:	c20080e7          	jalr	-992(ra) # e56 <dup>
      close(p[0]);
     23e:	fd842503          	lw	a0,-40(s0)
     242:	00001097          	auipc	ra,0x1
     246:	bc4080e7          	jalr	-1084(ra) # e06 <close>
      close(p[1]);
     24a:	fdc42503          	lw	a0,-36(s0)
     24e:	00001097          	auipc	ra,0x1
     252:	bb8080e7          	jalr	-1096(ra) # e06 <close>
      runcmd(pcmd->right);
     256:	6888                	ld	a0,16(s1)
     258:	00000097          	auipc	ra,0x0
     25c:	e50080e7          	jalr	-432(ra) # a8 <runcmd>
    if(fork1() == 0)
     260:	00000097          	auipc	ra,0x0
     264:	e1a080e7          	jalr	-486(ra) # 7a <fork1>
     268:	ea0515e3          	bnez	a0,112 <runcmd+0x6a>
      runcmd(bcmd->cmd);
     26c:	6488                	ld	a0,8(s1)
     26e:	00000097          	auipc	ra,0x0
     272:	e3a080e7          	jalr	-454(ra) # a8 <runcmd>

0000000000000276 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     276:	1101                	addi	sp,sp,-32
     278:	ec06                	sd	ra,24(sp)
     27a:	e822                	sd	s0,16(sp)
     27c:	e426                	sd	s1,8(sp)
     27e:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     280:	0a800513          	li	a0,168
     284:	00001097          	auipc	ra,0x1
     288:	f9c080e7          	jalr	-100(ra) # 1220 <malloc>
     28c:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     28e:	0a800613          	li	a2,168
     292:	4581                	li	a1,0
     294:	00001097          	auipc	ra,0x1
     298:	93a080e7          	jalr	-1734(ra) # bce <memset>
  cmd->type = EXEC;
     29c:	4785                	li	a5,1
     29e:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a0:	8526                	mv	a0,s1
     2a2:	60e2                	ld	ra,24(sp)
     2a4:	6442                	ld	s0,16(sp)
     2a6:	64a2                	ld	s1,8(sp)
     2a8:	6105                	addi	sp,sp,32
     2aa:	8082                	ret

00000000000002ac <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2ac:	7139                	addi	sp,sp,-64
     2ae:	fc06                	sd	ra,56(sp)
     2b0:	f822                	sd	s0,48(sp)
     2b2:	f426                	sd	s1,40(sp)
     2b4:	f04a                	sd	s2,32(sp)
     2b6:	ec4e                	sd	s3,24(sp)
     2b8:	e852                	sd	s4,16(sp)
     2ba:	e456                	sd	s5,8(sp)
     2bc:	e05a                	sd	s6,0(sp)
     2be:	0080                	addi	s0,sp,64
     2c0:	8b2a                	mv	s6,a0
     2c2:	8aae                	mv	s5,a1
     2c4:	8a32                	mv	s4,a2
     2c6:	89b6                	mv	s3,a3
     2c8:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ca:	02800513          	li	a0,40
     2ce:	00001097          	auipc	ra,0x1
     2d2:	f52080e7          	jalr	-174(ra) # 1220 <malloc>
     2d6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2d8:	02800613          	li	a2,40
     2dc:	4581                	li	a1,0
     2de:	00001097          	auipc	ra,0x1
     2e2:	8f0080e7          	jalr	-1808(ra) # bce <memset>
  cmd->type = REDIR;
     2e6:	4789                	li	a5,2
     2e8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ea:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2ee:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f2:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2f6:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fa:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     2fe:	8526                	mv	a0,s1
     300:	70e2                	ld	ra,56(sp)
     302:	7442                	ld	s0,48(sp)
     304:	74a2                	ld	s1,40(sp)
     306:	7902                	ld	s2,32(sp)
     308:	69e2                	ld	s3,24(sp)
     30a:	6a42                	ld	s4,16(sp)
     30c:	6aa2                	ld	s5,8(sp)
     30e:	6b02                	ld	s6,0(sp)
     310:	6121                	addi	sp,sp,64
     312:	8082                	ret

0000000000000314 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     314:	7179                	addi	sp,sp,-48
     316:	f406                	sd	ra,40(sp)
     318:	f022                	sd	s0,32(sp)
     31a:	ec26                	sd	s1,24(sp)
     31c:	e84a                	sd	s2,16(sp)
     31e:	e44e                	sd	s3,8(sp)
     320:	1800                	addi	s0,sp,48
     322:	89aa                	mv	s3,a0
     324:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     326:	4561                	li	a0,24
     328:	00001097          	auipc	ra,0x1
     32c:	ef8080e7          	jalr	-264(ra) # 1220 <malloc>
     330:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     332:	4661                	li	a2,24
     334:	4581                	li	a1,0
     336:	00001097          	auipc	ra,0x1
     33a:	898080e7          	jalr	-1896(ra) # bce <memset>
  cmd->type = PIPE;
     33e:	478d                	li	a5,3
     340:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     342:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     346:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34a:	8526                	mv	a0,s1
     34c:	70a2                	ld	ra,40(sp)
     34e:	7402                	ld	s0,32(sp)
     350:	64e2                	ld	s1,24(sp)
     352:	6942                	ld	s2,16(sp)
     354:	69a2                	ld	s3,8(sp)
     356:	6145                	addi	sp,sp,48
     358:	8082                	ret

000000000000035a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35a:	7179                	addi	sp,sp,-48
     35c:	f406                	sd	ra,40(sp)
     35e:	f022                	sd	s0,32(sp)
     360:	ec26                	sd	s1,24(sp)
     362:	e84a                	sd	s2,16(sp)
     364:	e44e                	sd	s3,8(sp)
     366:	1800                	addi	s0,sp,48
     368:	89aa                	mv	s3,a0
     36a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     36c:	4561                	li	a0,24
     36e:	00001097          	auipc	ra,0x1
     372:	eb2080e7          	jalr	-334(ra) # 1220 <malloc>
     376:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     378:	4661                	li	a2,24
     37a:	4581                	li	a1,0
     37c:	00001097          	auipc	ra,0x1
     380:	852080e7          	jalr	-1966(ra) # bce <memset>
  cmd->type = LIST;
     384:	4791                	li	a5,4
     386:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     388:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     38c:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     390:	8526                	mv	a0,s1
     392:	70a2                	ld	ra,40(sp)
     394:	7402                	ld	s0,32(sp)
     396:	64e2                	ld	s1,24(sp)
     398:	6942                	ld	s2,16(sp)
     39a:	69a2                	ld	s3,8(sp)
     39c:	6145                	addi	sp,sp,48
     39e:	8082                	ret

00000000000003a0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a0:	1101                	addi	sp,sp,-32
     3a2:	ec06                	sd	ra,24(sp)
     3a4:	e822                	sd	s0,16(sp)
     3a6:	e426                	sd	s1,8(sp)
     3a8:	e04a                	sd	s2,0(sp)
     3aa:	1000                	addi	s0,sp,32
     3ac:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3ae:	4541                	li	a0,16
     3b0:	00001097          	auipc	ra,0x1
     3b4:	e70080e7          	jalr	-400(ra) # 1220 <malloc>
     3b8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3ba:	4641                	li	a2,16
     3bc:	4581                	li	a1,0
     3be:	00001097          	auipc	ra,0x1
     3c2:	810080e7          	jalr	-2032(ra) # bce <memset>
  cmd->type = BACK;
     3c6:	4795                	li	a5,5
     3c8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3ca:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3ce:	8526                	mv	a0,s1
     3d0:	60e2                	ld	ra,24(sp)
     3d2:	6442                	ld	s0,16(sp)
     3d4:	64a2                	ld	s1,8(sp)
     3d6:	6902                	ld	s2,0(sp)
     3d8:	6105                	addi	sp,sp,32
     3da:	8082                	ret

00000000000003dc <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3dc:	7139                	addi	sp,sp,-64
     3de:	fc06                	sd	ra,56(sp)
     3e0:	f822                	sd	s0,48(sp)
     3e2:	f426                	sd	s1,40(sp)
     3e4:	f04a                	sd	s2,32(sp)
     3e6:	ec4e                	sd	s3,24(sp)
     3e8:	e852                	sd	s4,16(sp)
     3ea:	e456                	sd	s5,8(sp)
     3ec:	e05a                	sd	s6,0(sp)
     3ee:	0080                	addi	s0,sp,64
     3f0:	8a2a                	mv	s4,a0
     3f2:	892e                	mv	s2,a1
     3f4:	8ab2                	mv	s5,a2
     3f6:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3f8:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fa:	00001997          	auipc	s3,0x1
     3fe:	0ce98993          	addi	s3,s3,206 # 14c8 <whitespace>
     402:	00b4fe63          	bgeu	s1,a1,41e <gettoken+0x42>
     406:	0004c583          	lbu	a1,0(s1)
     40a:	854e                	mv	a0,s3
     40c:	00000097          	auipc	ra,0x0
     410:	7e4080e7          	jalr	2020(ra) # bf0 <strchr>
     414:	c509                	beqz	a0,41e <gettoken+0x42>
    s++;
     416:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     418:	fe9917e3          	bne	s2,s1,406 <gettoken+0x2a>
    s++;
     41c:	84ca                	mv	s1,s2
  if(q)
     41e:	000a8463          	beqz	s5,426 <gettoken+0x4a>
    *q = s;
     422:	009ab023          	sd	s1,0(s5)
  ret = *s;
     426:	0004c783          	lbu	a5,0(s1)
     42a:	00078a9b          	sext.w	s5,a5
  switch(*s){
     42e:	03c00713          	li	a4,60
     432:	06f76663          	bltu	a4,a5,49e <gettoken+0xc2>
     436:	03a00713          	li	a4,58
     43a:	00f76e63          	bltu	a4,a5,456 <gettoken+0x7a>
     43e:	cf89                	beqz	a5,458 <gettoken+0x7c>
     440:	02600713          	li	a4,38
     444:	00e78963          	beq	a5,a4,456 <gettoken+0x7a>
     448:	fd87879b          	addiw	a5,a5,-40
     44c:	0ff7f793          	zext.b	a5,a5
     450:	4705                	li	a4,1
     452:	06f76d63          	bltu	a4,a5,4cc <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     456:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     458:	000b0463          	beqz	s6,460 <gettoken+0x84>
    *eq = s;
     45c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     460:	00001997          	auipc	s3,0x1
     464:	06898993          	addi	s3,s3,104 # 14c8 <whitespace>
     468:	0124fe63          	bgeu	s1,s2,484 <gettoken+0xa8>
     46c:	0004c583          	lbu	a1,0(s1)
     470:	854e                	mv	a0,s3
     472:	00000097          	auipc	ra,0x0
     476:	77e080e7          	jalr	1918(ra) # bf0 <strchr>
     47a:	c509                	beqz	a0,484 <gettoken+0xa8>
    s++;
     47c:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     47e:	fe9917e3          	bne	s2,s1,46c <gettoken+0x90>
    s++;
     482:	84ca                	mv	s1,s2
  *ps = s;
     484:	009a3023          	sd	s1,0(s4)
  return ret;
}
     488:	8556                	mv	a0,s5
     48a:	70e2                	ld	ra,56(sp)
     48c:	7442                	ld	s0,48(sp)
     48e:	74a2                	ld	s1,40(sp)
     490:	7902                	ld	s2,32(sp)
     492:	69e2                	ld	s3,24(sp)
     494:	6a42                	ld	s4,16(sp)
     496:	6aa2                	ld	s5,8(sp)
     498:	6b02                	ld	s6,0(sp)
     49a:	6121                	addi	sp,sp,64
     49c:	8082                	ret
  switch(*s){
     49e:	03e00713          	li	a4,62
     4a2:	02e79163          	bne	a5,a4,4c4 <gettoken+0xe8>
    s++;
     4a6:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4aa:	0014c703          	lbu	a4,1(s1)
     4ae:	03e00793          	li	a5,62
      s++;
     4b2:	0489                	addi	s1,s1,2
      ret = '+';
     4b4:	02b00a93          	li	s5,43
    if(*s == '>'){
     4b8:	faf700e3          	beq	a4,a5,458 <gettoken+0x7c>
    s++;
     4bc:	84b6                	mv	s1,a3
  ret = *s;
     4be:	03e00a93          	li	s5,62
     4c2:	bf59                	j	458 <gettoken+0x7c>
  switch(*s){
     4c4:	07c00713          	li	a4,124
     4c8:	f8e787e3          	beq	a5,a4,456 <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4cc:	00001997          	auipc	s3,0x1
     4d0:	ffc98993          	addi	s3,s3,-4 # 14c8 <whitespace>
     4d4:	00001a97          	auipc	s5,0x1
     4d8:	feca8a93          	addi	s5,s5,-20 # 14c0 <symbols>
     4dc:	0324f663          	bgeu	s1,s2,508 <gettoken+0x12c>
     4e0:	0004c583          	lbu	a1,0(s1)
     4e4:	854e                	mv	a0,s3
     4e6:	00000097          	auipc	ra,0x0
     4ea:	70a080e7          	jalr	1802(ra) # bf0 <strchr>
     4ee:	e50d                	bnez	a0,518 <gettoken+0x13c>
     4f0:	0004c583          	lbu	a1,0(s1)
     4f4:	8556                	mv	a0,s5
     4f6:	00000097          	auipc	ra,0x0
     4fa:	6fa080e7          	jalr	1786(ra) # bf0 <strchr>
     4fe:	e911                	bnez	a0,512 <gettoken+0x136>
      s++;
     500:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     502:	fc991fe3          	bne	s2,s1,4e0 <gettoken+0x104>
      s++;
     506:	84ca                	mv	s1,s2
  if(eq)
     508:	06100a93          	li	s5,97
     50c:	f40b18e3          	bnez	s6,45c <gettoken+0x80>
     510:	bf95                	j	484 <gettoken+0xa8>
    ret = 'a';
     512:	06100a93          	li	s5,97
     516:	b789                	j	458 <gettoken+0x7c>
     518:	06100a93          	li	s5,97
     51c:	bf35                	j	458 <gettoken+0x7c>

000000000000051e <peek>:

int
peek(char **ps, char *es, char *toks)
{
     51e:	7139                	addi	sp,sp,-64
     520:	fc06                	sd	ra,56(sp)
     522:	f822                	sd	s0,48(sp)
     524:	f426                	sd	s1,40(sp)
     526:	f04a                	sd	s2,32(sp)
     528:	ec4e                	sd	s3,24(sp)
     52a:	e852                	sd	s4,16(sp)
     52c:	e456                	sd	s5,8(sp)
     52e:	0080                	addi	s0,sp,64
     530:	8a2a                	mv	s4,a0
     532:	892e                	mv	s2,a1
     534:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     536:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     538:	00001997          	auipc	s3,0x1
     53c:	f9098993          	addi	s3,s3,-112 # 14c8 <whitespace>
     540:	00b4fe63          	bgeu	s1,a1,55c <peek+0x3e>
     544:	0004c583          	lbu	a1,0(s1)
     548:	854e                	mv	a0,s3
     54a:	00000097          	auipc	ra,0x0
     54e:	6a6080e7          	jalr	1702(ra) # bf0 <strchr>
     552:	c509                	beqz	a0,55c <peek+0x3e>
    s++;
     554:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     556:	fe9917e3          	bne	s2,s1,544 <peek+0x26>
    s++;
     55a:	84ca                	mv	s1,s2
  *ps = s;
     55c:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     560:	0004c583          	lbu	a1,0(s1)
     564:	4501                	li	a0,0
     566:	e991                	bnez	a1,57a <peek+0x5c>
}
     568:	70e2                	ld	ra,56(sp)
     56a:	7442                	ld	s0,48(sp)
     56c:	74a2                	ld	s1,40(sp)
     56e:	7902                	ld	s2,32(sp)
     570:	69e2                	ld	s3,24(sp)
     572:	6a42                	ld	s4,16(sp)
     574:	6aa2                	ld	s5,8(sp)
     576:	6121                	addi	sp,sp,64
     578:	8082                	ret
  return *s && strchr(toks, *s);
     57a:	8556                	mv	a0,s5
     57c:	00000097          	auipc	ra,0x0
     580:	674080e7          	jalr	1652(ra) # bf0 <strchr>
     584:	00a03533          	snez	a0,a0
     588:	b7c5                	j	568 <peek+0x4a>

000000000000058a <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     58a:	7159                	addi	sp,sp,-112
     58c:	f486                	sd	ra,104(sp)
     58e:	f0a2                	sd	s0,96(sp)
     590:	eca6                	sd	s1,88(sp)
     592:	e8ca                	sd	s2,80(sp)
     594:	e4ce                	sd	s3,72(sp)
     596:	e0d2                	sd	s4,64(sp)
     598:	fc56                	sd	s5,56(sp)
     59a:	f85a                	sd	s6,48(sp)
     59c:	f45e                	sd	s7,40(sp)
     59e:	f062                	sd	s8,32(sp)
     5a0:	ec66                	sd	s9,24(sp)
     5a2:	1880                	addi	s0,sp,112
     5a4:	8a2a                	mv	s4,a0
     5a6:	89ae                	mv	s3,a1
     5a8:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5aa:	00001b97          	auipc	s7,0x1
     5ae:	dc6b8b93          	addi	s7,s7,-570 # 1370 <malloc+0x150>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5b2:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     5b6:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     5ba:	a02d                	j	5e4 <parseredirs+0x5a>
      panic("missing file for redirection");
     5bc:	00001517          	auipc	a0,0x1
     5c0:	d9450513          	addi	a0,a0,-620 # 1350 <malloc+0x130>
     5c4:	00000097          	auipc	ra,0x0
     5c8:	a90080e7          	jalr	-1392(ra) # 54 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5cc:	4701                	li	a4,0
     5ce:	4681                	li	a3,0
     5d0:	f9043603          	ld	a2,-112(s0)
     5d4:	f9843583          	ld	a1,-104(s0)
     5d8:	8552                	mv	a0,s4
     5da:	00000097          	auipc	ra,0x0
     5de:	cd2080e7          	jalr	-814(ra) # 2ac <redircmd>
     5e2:	8a2a                	mv	s4,a0
    switch(tok){
     5e4:	03e00b13          	li	s6,62
     5e8:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     5ec:	865e                	mv	a2,s7
     5ee:	85ca                	mv	a1,s2
     5f0:	854e                	mv	a0,s3
     5f2:	00000097          	auipc	ra,0x0
     5f6:	f2c080e7          	jalr	-212(ra) # 51e <peek>
     5fa:	c925                	beqz	a0,66a <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     5fc:	4681                	li	a3,0
     5fe:	4601                	li	a2,0
     600:	85ca                	mv	a1,s2
     602:	854e                	mv	a0,s3
     604:	00000097          	auipc	ra,0x0
     608:	dd8080e7          	jalr	-552(ra) # 3dc <gettoken>
     60c:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     60e:	f9040693          	addi	a3,s0,-112
     612:	f9840613          	addi	a2,s0,-104
     616:	85ca                	mv	a1,s2
     618:	854e                	mv	a0,s3
     61a:	00000097          	auipc	ra,0x0
     61e:	dc2080e7          	jalr	-574(ra) # 3dc <gettoken>
     622:	f9851de3          	bne	a0,s8,5bc <parseredirs+0x32>
    switch(tok){
     626:	fb9483e3          	beq	s1,s9,5cc <parseredirs+0x42>
     62a:	03648263          	beq	s1,s6,64e <parseredirs+0xc4>
     62e:	fb549fe3          	bne	s1,s5,5ec <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     632:	4705                	li	a4,1
     634:	20100693          	li	a3,513
     638:	f9043603          	ld	a2,-112(s0)
     63c:	f9843583          	ld	a1,-104(s0)
     640:	8552                	mv	a0,s4
     642:	00000097          	auipc	ra,0x0
     646:	c6a080e7          	jalr	-918(ra) # 2ac <redircmd>
     64a:	8a2a                	mv	s4,a0
      break;
     64c:	bf61                	j	5e4 <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     64e:	4705                	li	a4,1
     650:	60100693          	li	a3,1537
     654:	f9043603          	ld	a2,-112(s0)
     658:	f9843583          	ld	a1,-104(s0)
     65c:	8552                	mv	a0,s4
     65e:	00000097          	auipc	ra,0x0
     662:	c4e080e7          	jalr	-946(ra) # 2ac <redircmd>
     666:	8a2a                	mv	s4,a0
      break;
     668:	bfb5                	j	5e4 <parseredirs+0x5a>
    }
  }
  return cmd;
}
     66a:	8552                	mv	a0,s4
     66c:	70a6                	ld	ra,104(sp)
     66e:	7406                	ld	s0,96(sp)
     670:	64e6                	ld	s1,88(sp)
     672:	6946                	ld	s2,80(sp)
     674:	69a6                	ld	s3,72(sp)
     676:	6a06                	ld	s4,64(sp)
     678:	7ae2                	ld	s5,56(sp)
     67a:	7b42                	ld	s6,48(sp)
     67c:	7ba2                	ld	s7,40(sp)
     67e:	7c02                	ld	s8,32(sp)
     680:	6ce2                	ld	s9,24(sp)
     682:	6165                	addi	sp,sp,112
     684:	8082                	ret

0000000000000686 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     686:	7159                	addi	sp,sp,-112
     688:	f486                	sd	ra,104(sp)
     68a:	f0a2                	sd	s0,96(sp)
     68c:	eca6                	sd	s1,88(sp)
     68e:	e8ca                	sd	s2,80(sp)
     690:	e4ce                	sd	s3,72(sp)
     692:	e0d2                	sd	s4,64(sp)
     694:	fc56                	sd	s5,56(sp)
     696:	f85a                	sd	s6,48(sp)
     698:	f45e                	sd	s7,40(sp)
     69a:	f062                	sd	s8,32(sp)
     69c:	ec66                	sd	s9,24(sp)
     69e:	1880                	addi	s0,sp,112
     6a0:	8a2a                	mv	s4,a0
     6a2:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     6a4:	00001617          	auipc	a2,0x1
     6a8:	cd460613          	addi	a2,a2,-812 # 1378 <malloc+0x158>
     6ac:	00000097          	auipc	ra,0x0
     6b0:	e72080e7          	jalr	-398(ra) # 51e <peek>
     6b4:	e905                	bnez	a0,6e4 <parseexec+0x5e>
     6b6:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6b8:	00000097          	auipc	ra,0x0
     6bc:	bbe080e7          	jalr	-1090(ra) # 276 <execcmd>
     6c0:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6c2:	8656                	mv	a2,s5
     6c4:	85d2                	mv	a1,s4
     6c6:	00000097          	auipc	ra,0x0
     6ca:	ec4080e7          	jalr	-316(ra) # 58a <parseredirs>
     6ce:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6d0:	008c0913          	addi	s2,s8,8
     6d4:	00001b17          	auipc	s6,0x1
     6d8:	cc4b0b13          	addi	s6,s6,-828 # 1398 <malloc+0x178>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6dc:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6e0:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6e2:	a0b1                	j	72e <parseexec+0xa8>
    return parseblock(ps, es);
     6e4:	85d6                	mv	a1,s5
     6e6:	8552                	mv	a0,s4
     6e8:	00000097          	auipc	ra,0x0
     6ec:	1bc080e7          	jalr	444(ra) # 8a4 <parseblock>
     6f0:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6f2:	8526                	mv	a0,s1
     6f4:	70a6                	ld	ra,104(sp)
     6f6:	7406                	ld	s0,96(sp)
     6f8:	64e6                	ld	s1,88(sp)
     6fa:	6946                	ld	s2,80(sp)
     6fc:	69a6                	ld	s3,72(sp)
     6fe:	6a06                	ld	s4,64(sp)
     700:	7ae2                	ld	s5,56(sp)
     702:	7b42                	ld	s6,48(sp)
     704:	7ba2                	ld	s7,40(sp)
     706:	7c02                	ld	s8,32(sp)
     708:	6ce2                	ld	s9,24(sp)
     70a:	6165                	addi	sp,sp,112
     70c:	8082                	ret
      panic("syntax");
     70e:	00001517          	auipc	a0,0x1
     712:	c7250513          	addi	a0,a0,-910 # 1380 <malloc+0x160>
     716:	00000097          	auipc	ra,0x0
     71a:	93e080e7          	jalr	-1730(ra) # 54 <panic>
    ret = parseredirs(ret, ps, es);
     71e:	8656                	mv	a2,s5
     720:	85d2                	mv	a1,s4
     722:	8526                	mv	a0,s1
     724:	00000097          	auipc	ra,0x0
     728:	e66080e7          	jalr	-410(ra) # 58a <parseredirs>
     72c:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     72e:	865a                	mv	a2,s6
     730:	85d6                	mv	a1,s5
     732:	8552                	mv	a0,s4
     734:	00000097          	auipc	ra,0x0
     738:	dea080e7          	jalr	-534(ra) # 51e <peek>
     73c:	e131                	bnez	a0,780 <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     73e:	f9040693          	addi	a3,s0,-112
     742:	f9840613          	addi	a2,s0,-104
     746:	85d6                	mv	a1,s5
     748:	8552                	mv	a0,s4
     74a:	00000097          	auipc	ra,0x0
     74e:	c92080e7          	jalr	-878(ra) # 3dc <gettoken>
     752:	c51d                	beqz	a0,780 <parseexec+0xfa>
    if(tok != 'a')
     754:	fb951de3          	bne	a0,s9,70e <parseexec+0x88>
    cmd->argv[argc] = q;
     758:	f9843783          	ld	a5,-104(s0)
     75c:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     760:	f9043783          	ld	a5,-112(s0)
     764:	04f93823          	sd	a5,80(s2)
    argc++;
     768:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     76a:	0921                	addi	s2,s2,8
     76c:	fb7999e3          	bne	s3,s7,71e <parseexec+0x98>
      panic("too many args");
     770:	00001517          	auipc	a0,0x1
     774:	c1850513          	addi	a0,a0,-1000 # 1388 <malloc+0x168>
     778:	00000097          	auipc	ra,0x0
     77c:	8dc080e7          	jalr	-1828(ra) # 54 <panic>
  cmd->argv[argc] = 0;
     780:	098e                	slli	s3,s3,0x3
     782:	9c4e                	add	s8,s8,s3
     784:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     788:	040c3c23          	sd	zero,88(s8)
  return ret;
     78c:	b79d                	j	6f2 <parseexec+0x6c>

000000000000078e <parsepipe>:
{
     78e:	7179                	addi	sp,sp,-48
     790:	f406                	sd	ra,40(sp)
     792:	f022                	sd	s0,32(sp)
     794:	ec26                	sd	s1,24(sp)
     796:	e84a                	sd	s2,16(sp)
     798:	e44e                	sd	s3,8(sp)
     79a:	1800                	addi	s0,sp,48
     79c:	892a                	mv	s2,a0
     79e:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7a0:	00000097          	auipc	ra,0x0
     7a4:	ee6080e7          	jalr	-282(ra) # 686 <parseexec>
     7a8:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7aa:	00001617          	auipc	a2,0x1
     7ae:	bf660613          	addi	a2,a2,-1034 # 13a0 <malloc+0x180>
     7b2:	85ce                	mv	a1,s3
     7b4:	854a                	mv	a0,s2
     7b6:	00000097          	auipc	ra,0x0
     7ba:	d68080e7          	jalr	-664(ra) # 51e <peek>
     7be:	e909                	bnez	a0,7d0 <parsepipe+0x42>
}
     7c0:	8526                	mv	a0,s1
     7c2:	70a2                	ld	ra,40(sp)
     7c4:	7402                	ld	s0,32(sp)
     7c6:	64e2                	ld	s1,24(sp)
     7c8:	6942                	ld	s2,16(sp)
     7ca:	69a2                	ld	s3,8(sp)
     7cc:	6145                	addi	sp,sp,48
     7ce:	8082                	ret
    gettoken(ps, es, 0, 0);
     7d0:	4681                	li	a3,0
     7d2:	4601                	li	a2,0
     7d4:	85ce                	mv	a1,s3
     7d6:	854a                	mv	a0,s2
     7d8:	00000097          	auipc	ra,0x0
     7dc:	c04080e7          	jalr	-1020(ra) # 3dc <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7e0:	85ce                	mv	a1,s3
     7e2:	854a                	mv	a0,s2
     7e4:	00000097          	auipc	ra,0x0
     7e8:	faa080e7          	jalr	-86(ra) # 78e <parsepipe>
     7ec:	85aa                	mv	a1,a0
     7ee:	8526                	mv	a0,s1
     7f0:	00000097          	auipc	ra,0x0
     7f4:	b24080e7          	jalr	-1244(ra) # 314 <pipecmd>
     7f8:	84aa                	mv	s1,a0
  return cmd;
     7fa:	b7d9                	j	7c0 <parsepipe+0x32>

00000000000007fc <parseline>:
{
     7fc:	7179                	addi	sp,sp,-48
     7fe:	f406                	sd	ra,40(sp)
     800:	f022                	sd	s0,32(sp)
     802:	ec26                	sd	s1,24(sp)
     804:	e84a                	sd	s2,16(sp)
     806:	e44e                	sd	s3,8(sp)
     808:	e052                	sd	s4,0(sp)
     80a:	1800                	addi	s0,sp,48
     80c:	892a                	mv	s2,a0
     80e:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     810:	00000097          	auipc	ra,0x0
     814:	f7e080e7          	jalr	-130(ra) # 78e <parsepipe>
     818:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     81a:	00001a17          	auipc	s4,0x1
     81e:	b8ea0a13          	addi	s4,s4,-1138 # 13a8 <malloc+0x188>
     822:	a839                	j	840 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     824:	4681                	li	a3,0
     826:	4601                	li	a2,0
     828:	85ce                	mv	a1,s3
     82a:	854a                	mv	a0,s2
     82c:	00000097          	auipc	ra,0x0
     830:	bb0080e7          	jalr	-1104(ra) # 3dc <gettoken>
    cmd = backcmd(cmd);
     834:	8526                	mv	a0,s1
     836:	00000097          	auipc	ra,0x0
     83a:	b6a080e7          	jalr	-1174(ra) # 3a0 <backcmd>
     83e:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     840:	8652                	mv	a2,s4
     842:	85ce                	mv	a1,s3
     844:	854a                	mv	a0,s2
     846:	00000097          	auipc	ra,0x0
     84a:	cd8080e7          	jalr	-808(ra) # 51e <peek>
     84e:	f979                	bnez	a0,824 <parseline+0x28>
  if(peek(ps, es, ";")){
     850:	00001617          	auipc	a2,0x1
     854:	b6060613          	addi	a2,a2,-1184 # 13b0 <malloc+0x190>
     858:	85ce                	mv	a1,s3
     85a:	854a                	mv	a0,s2
     85c:	00000097          	auipc	ra,0x0
     860:	cc2080e7          	jalr	-830(ra) # 51e <peek>
     864:	e911                	bnez	a0,878 <parseline+0x7c>
}
     866:	8526                	mv	a0,s1
     868:	70a2                	ld	ra,40(sp)
     86a:	7402                	ld	s0,32(sp)
     86c:	64e2                	ld	s1,24(sp)
     86e:	6942                	ld	s2,16(sp)
     870:	69a2                	ld	s3,8(sp)
     872:	6a02                	ld	s4,0(sp)
     874:	6145                	addi	sp,sp,48
     876:	8082                	ret
    gettoken(ps, es, 0, 0);
     878:	4681                	li	a3,0
     87a:	4601                	li	a2,0
     87c:	85ce                	mv	a1,s3
     87e:	854a                	mv	a0,s2
     880:	00000097          	auipc	ra,0x0
     884:	b5c080e7          	jalr	-1188(ra) # 3dc <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     888:	85ce                	mv	a1,s3
     88a:	854a                	mv	a0,s2
     88c:	00000097          	auipc	ra,0x0
     890:	f70080e7          	jalr	-144(ra) # 7fc <parseline>
     894:	85aa                	mv	a1,a0
     896:	8526                	mv	a0,s1
     898:	00000097          	auipc	ra,0x0
     89c:	ac2080e7          	jalr	-1342(ra) # 35a <listcmd>
     8a0:	84aa                	mv	s1,a0
  return cmd;
     8a2:	b7d1                	j	866 <parseline+0x6a>

00000000000008a4 <parseblock>:
{
     8a4:	7179                	addi	sp,sp,-48
     8a6:	f406                	sd	ra,40(sp)
     8a8:	f022                	sd	s0,32(sp)
     8aa:	ec26                	sd	s1,24(sp)
     8ac:	e84a                	sd	s2,16(sp)
     8ae:	e44e                	sd	s3,8(sp)
     8b0:	1800                	addi	s0,sp,48
     8b2:	84aa                	mv	s1,a0
     8b4:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8b6:	00001617          	auipc	a2,0x1
     8ba:	ac260613          	addi	a2,a2,-1342 # 1378 <malloc+0x158>
     8be:	00000097          	auipc	ra,0x0
     8c2:	c60080e7          	jalr	-928(ra) # 51e <peek>
     8c6:	c12d                	beqz	a0,928 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8c8:	4681                	li	a3,0
     8ca:	4601                	li	a2,0
     8cc:	85ca                	mv	a1,s2
     8ce:	8526                	mv	a0,s1
     8d0:	00000097          	auipc	ra,0x0
     8d4:	b0c080e7          	jalr	-1268(ra) # 3dc <gettoken>
  cmd = parseline(ps, es);
     8d8:	85ca                	mv	a1,s2
     8da:	8526                	mv	a0,s1
     8dc:	00000097          	auipc	ra,0x0
     8e0:	f20080e7          	jalr	-224(ra) # 7fc <parseline>
     8e4:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8e6:	00001617          	auipc	a2,0x1
     8ea:	ae260613          	addi	a2,a2,-1310 # 13c8 <malloc+0x1a8>
     8ee:	85ca                	mv	a1,s2
     8f0:	8526                	mv	a0,s1
     8f2:	00000097          	auipc	ra,0x0
     8f6:	c2c080e7          	jalr	-980(ra) # 51e <peek>
     8fa:	cd1d                	beqz	a0,938 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     8fc:	4681                	li	a3,0
     8fe:	4601                	li	a2,0
     900:	85ca                	mv	a1,s2
     902:	8526                	mv	a0,s1
     904:	00000097          	auipc	ra,0x0
     908:	ad8080e7          	jalr	-1320(ra) # 3dc <gettoken>
  cmd = parseredirs(cmd, ps, es);
     90c:	864a                	mv	a2,s2
     90e:	85a6                	mv	a1,s1
     910:	854e                	mv	a0,s3
     912:	00000097          	auipc	ra,0x0
     916:	c78080e7          	jalr	-904(ra) # 58a <parseredirs>
}
     91a:	70a2                	ld	ra,40(sp)
     91c:	7402                	ld	s0,32(sp)
     91e:	64e2                	ld	s1,24(sp)
     920:	6942                	ld	s2,16(sp)
     922:	69a2                	ld	s3,8(sp)
     924:	6145                	addi	sp,sp,48
     926:	8082                	ret
    panic("parseblock");
     928:	00001517          	auipc	a0,0x1
     92c:	a9050513          	addi	a0,a0,-1392 # 13b8 <malloc+0x198>
     930:	fffff097          	auipc	ra,0xfffff
     934:	724080e7          	jalr	1828(ra) # 54 <panic>
    panic("syntax - missing )");
     938:	00001517          	auipc	a0,0x1
     93c:	a9850513          	addi	a0,a0,-1384 # 13d0 <malloc+0x1b0>
     940:	fffff097          	auipc	ra,0xfffff
     944:	714080e7          	jalr	1812(ra) # 54 <panic>

0000000000000948 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     948:	1101                	addi	sp,sp,-32
     94a:	ec06                	sd	ra,24(sp)
     94c:	e822                	sd	s0,16(sp)
     94e:	e426                	sd	s1,8(sp)
     950:	1000                	addi	s0,sp,32
     952:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     954:	c521                	beqz	a0,99c <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     956:	4118                	lw	a4,0(a0)
     958:	4795                	li	a5,5
     95a:	04e7e163          	bltu	a5,a4,99c <nulterminate+0x54>
     95e:	00056783          	lwu	a5,0(a0)
     962:	078a                	slli	a5,a5,0x2
     964:	00001717          	auipc	a4,0x1
     968:	acc70713          	addi	a4,a4,-1332 # 1430 <malloc+0x210>
     96c:	97ba                	add	a5,a5,a4
     96e:	439c                	lw	a5,0(a5)
     970:	97ba                	add	a5,a5,a4
     972:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     974:	651c                	ld	a5,8(a0)
     976:	c39d                	beqz	a5,99c <nulterminate+0x54>
     978:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     97c:	67b8                	ld	a4,72(a5)
     97e:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     982:	07a1                	addi	a5,a5,8
     984:	ff87b703          	ld	a4,-8(a5)
     988:	fb75                	bnez	a4,97c <nulterminate+0x34>
     98a:	a809                	j	99c <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     98c:	6508                	ld	a0,8(a0)
     98e:	00000097          	auipc	ra,0x0
     992:	fba080e7          	jalr	-70(ra) # 948 <nulterminate>
    *rcmd->efile = 0;
     996:	6c9c                	ld	a5,24(s1)
     998:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     99c:	8526                	mv	a0,s1
     99e:	60e2                	ld	ra,24(sp)
     9a0:	6442                	ld	s0,16(sp)
     9a2:	64a2                	ld	s1,8(sp)
     9a4:	6105                	addi	sp,sp,32
     9a6:	8082                	ret
    nulterminate(pcmd->left);
     9a8:	6508                	ld	a0,8(a0)
     9aa:	00000097          	auipc	ra,0x0
     9ae:	f9e080e7          	jalr	-98(ra) # 948 <nulterminate>
    nulterminate(pcmd->right);
     9b2:	6888                	ld	a0,16(s1)
     9b4:	00000097          	auipc	ra,0x0
     9b8:	f94080e7          	jalr	-108(ra) # 948 <nulterminate>
    break;
     9bc:	b7c5                	j	99c <nulterminate+0x54>
    nulterminate(lcmd->left);
     9be:	6508                	ld	a0,8(a0)
     9c0:	00000097          	auipc	ra,0x0
     9c4:	f88080e7          	jalr	-120(ra) # 948 <nulterminate>
    nulterminate(lcmd->right);
     9c8:	6888                	ld	a0,16(s1)
     9ca:	00000097          	auipc	ra,0x0
     9ce:	f7e080e7          	jalr	-130(ra) # 948 <nulterminate>
    break;
     9d2:	b7e9                	j	99c <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9d4:	6508                	ld	a0,8(a0)
     9d6:	00000097          	auipc	ra,0x0
     9da:	f72080e7          	jalr	-142(ra) # 948 <nulterminate>
    break;
     9de:	bf7d                	j	99c <nulterminate+0x54>

00000000000009e0 <parsecmd>:
{
     9e0:	7179                	addi	sp,sp,-48
     9e2:	f406                	sd	ra,40(sp)
     9e4:	f022                	sd	s0,32(sp)
     9e6:	ec26                	sd	s1,24(sp)
     9e8:	e84a                	sd	s2,16(sp)
     9ea:	1800                	addi	s0,sp,48
     9ec:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9f0:	84aa                	mv	s1,a0
     9f2:	00000097          	auipc	ra,0x0
     9f6:	1b2080e7          	jalr	434(ra) # ba4 <strlen>
     9fa:	1502                	slli	a0,a0,0x20
     9fc:	9101                	srli	a0,a0,0x20
     9fe:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a00:	85a6                	mv	a1,s1
     a02:	fd840513          	addi	a0,s0,-40
     a06:	00000097          	auipc	ra,0x0
     a0a:	df6080e7          	jalr	-522(ra) # 7fc <parseline>
     a0e:	892a                	mv	s2,a0
  peek(&s, es, "");
     a10:	00001617          	auipc	a2,0x1
     a14:	9d860613          	addi	a2,a2,-1576 # 13e8 <malloc+0x1c8>
     a18:	85a6                	mv	a1,s1
     a1a:	fd840513          	addi	a0,s0,-40
     a1e:	00000097          	auipc	ra,0x0
     a22:	b00080e7          	jalr	-1280(ra) # 51e <peek>
  if(s != es){
     a26:	fd843603          	ld	a2,-40(s0)
     a2a:	00961e63          	bne	a2,s1,a46 <parsecmd+0x66>
  nulterminate(cmd);
     a2e:	854a                	mv	a0,s2
     a30:	00000097          	auipc	ra,0x0
     a34:	f18080e7          	jalr	-232(ra) # 948 <nulterminate>
}
     a38:	854a                	mv	a0,s2
     a3a:	70a2                	ld	ra,40(sp)
     a3c:	7402                	ld	s0,32(sp)
     a3e:	64e2                	ld	s1,24(sp)
     a40:	6942                	ld	s2,16(sp)
     a42:	6145                	addi	sp,sp,48
     a44:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a46:	00001597          	auipc	a1,0x1
     a4a:	9aa58593          	addi	a1,a1,-1622 # 13f0 <malloc+0x1d0>
     a4e:	4509                	li	a0,2
     a50:	00000097          	auipc	ra,0x0
     a54:	6ea080e7          	jalr	1770(ra) # 113a <fprintf>
    panic("syntax");
     a58:	00001517          	auipc	a0,0x1
     a5c:	92850513          	addi	a0,a0,-1752 # 1380 <malloc+0x160>
     a60:	fffff097          	auipc	ra,0xfffff
     a64:	5f4080e7          	jalr	1524(ra) # 54 <panic>

0000000000000a68 <main>:
{
     a68:	7139                	addi	sp,sp,-64
     a6a:	fc06                	sd	ra,56(sp)
     a6c:	f822                	sd	s0,48(sp)
     a6e:	f426                	sd	s1,40(sp)
     a70:	f04a                	sd	s2,32(sp)
     a72:	ec4e                	sd	s3,24(sp)
     a74:	e852                	sd	s4,16(sp)
     a76:	e456                	sd	s5,8(sp)
     a78:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     a7a:	00001497          	auipc	s1,0x1
     a7e:	98648493          	addi	s1,s1,-1658 # 1400 <malloc+0x1e0>
     a82:	4589                	li	a1,2
     a84:	8526                	mv	a0,s1
     a86:	00000097          	auipc	ra,0x0
     a8a:	398080e7          	jalr	920(ra) # e1e <open>
     a8e:	00054963          	bltz	a0,aa0 <main+0x38>
    if(fd >= 3){
     a92:	4789                	li	a5,2
     a94:	fea7d7e3          	bge	a5,a0,a82 <main+0x1a>
      close(fd);
     a98:	00000097          	auipc	ra,0x0
     a9c:	36e080e7          	jalr	878(ra) # e06 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aa0:	00001497          	auipc	s1,0x1
     aa4:	a3848493          	addi	s1,s1,-1480 # 14d8 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aa8:	06300913          	li	s2,99
     aac:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
     ab0:	00001a17          	auipc	s4,0x1
     ab4:	a2ba0a13          	addi	s4,s4,-1493 # 14db <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     ab8:	00001a97          	auipc	s5,0x1
     abc:	950a8a93          	addi	s5,s5,-1712 # 1408 <malloc+0x1e8>
     ac0:	a819                	j	ad6 <main+0x6e>
    if(fork1() == 0)
     ac2:	fffff097          	auipc	ra,0xfffff
     ac6:	5b8080e7          	jalr	1464(ra) # 7a <fork1>
     aca:	c925                	beqz	a0,b3a <main+0xd2>
    wait(0);
     acc:	4501                	li	a0,0
     ace:	00000097          	auipc	ra,0x0
     ad2:	318080e7          	jalr	792(ra) # de6 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ad6:	06400593          	li	a1,100
     ada:	8526                	mv	a0,s1
     adc:	fffff097          	auipc	ra,0xfffff
     ae0:	524080e7          	jalr	1316(ra) # 0 <getcmd>
     ae4:	06054763          	bltz	a0,b52 <main+0xea>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ae8:	0004c783          	lbu	a5,0(s1)
     aec:	fd279be3          	bne	a5,s2,ac2 <main+0x5a>
     af0:	0014c703          	lbu	a4,1(s1)
     af4:	06400793          	li	a5,100
     af8:	fcf715e3          	bne	a4,a5,ac2 <main+0x5a>
     afc:	0024c783          	lbu	a5,2(s1)
     b00:	fd3791e3          	bne	a5,s3,ac2 <main+0x5a>
      buf[strlen(buf)-1] = 0;  // chop \n
     b04:	8526                	mv	a0,s1
     b06:	00000097          	auipc	ra,0x0
     b0a:	09e080e7          	jalr	158(ra) # ba4 <strlen>
     b0e:	fff5079b          	addiw	a5,a0,-1
     b12:	1782                	slli	a5,a5,0x20
     b14:	9381                	srli	a5,a5,0x20
     b16:	97a6                	add	a5,a5,s1
     b18:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     b1c:	8552                	mv	a0,s4
     b1e:	00000097          	auipc	ra,0x0
     b22:	330080e7          	jalr	816(ra) # e4e <chdir>
     b26:	fa0558e3          	bgez	a0,ad6 <main+0x6e>
        fprintf(2, "cannot cd %s\n", buf+3);
     b2a:	8652                	mv	a2,s4
     b2c:	85d6                	mv	a1,s5
     b2e:	4509                	li	a0,2
     b30:	00000097          	auipc	ra,0x0
     b34:	60a080e7          	jalr	1546(ra) # 113a <fprintf>
     b38:	bf79                	j	ad6 <main+0x6e>
      runcmd(parsecmd(buf));
     b3a:	00001517          	auipc	a0,0x1
     b3e:	99e50513          	addi	a0,a0,-1634 # 14d8 <buf.0>
     b42:	00000097          	auipc	ra,0x0
     b46:	e9e080e7          	jalr	-354(ra) # 9e0 <parsecmd>
     b4a:	fffff097          	auipc	ra,0xfffff
     b4e:	55e080e7          	jalr	1374(ra) # a8 <runcmd>
  exit(0);
     b52:	4501                	li	a0,0
     b54:	00000097          	auipc	ra,0x0
     b58:	28a080e7          	jalr	650(ra) # dde <exit>

0000000000000b5c <strcpy>:



char*
strcpy(char *s, const char *t)
{
     b5c:	1141                	addi	sp,sp,-16
     b5e:	e422                	sd	s0,8(sp)
     b60:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b62:	87aa                	mv	a5,a0
     b64:	0585                	addi	a1,a1,1
     b66:	0785                	addi	a5,a5,1
     b68:	fff5c703          	lbu	a4,-1(a1)
     b6c:	fee78fa3          	sb	a4,-1(a5)
     b70:	fb75                	bnez	a4,b64 <strcpy+0x8>
    ;
  return os;
}
     b72:	6422                	ld	s0,8(sp)
     b74:	0141                	addi	sp,sp,16
     b76:	8082                	ret

0000000000000b78 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b78:	1141                	addi	sp,sp,-16
     b7a:	e422                	sd	s0,8(sp)
     b7c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b7e:	00054783          	lbu	a5,0(a0)
     b82:	cb91                	beqz	a5,b96 <strcmp+0x1e>
     b84:	0005c703          	lbu	a4,0(a1)
     b88:	00f71763          	bne	a4,a5,b96 <strcmp+0x1e>
    p++, q++;
     b8c:	0505                	addi	a0,a0,1
     b8e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b90:	00054783          	lbu	a5,0(a0)
     b94:	fbe5                	bnez	a5,b84 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     b96:	0005c503          	lbu	a0,0(a1)
}
     b9a:	40a7853b          	subw	a0,a5,a0
     b9e:	6422                	ld	s0,8(sp)
     ba0:	0141                	addi	sp,sp,16
     ba2:	8082                	ret

0000000000000ba4 <strlen>:

uint
strlen(const char *s)
{
     ba4:	1141                	addi	sp,sp,-16
     ba6:	e422                	sd	s0,8(sp)
     ba8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     baa:	00054783          	lbu	a5,0(a0)
     bae:	cf91                	beqz	a5,bca <strlen+0x26>
     bb0:	0505                	addi	a0,a0,1
     bb2:	87aa                	mv	a5,a0
     bb4:	4685                	li	a3,1
     bb6:	9e89                	subw	a3,a3,a0
     bb8:	00f6853b          	addw	a0,a3,a5
     bbc:	0785                	addi	a5,a5,1
     bbe:	fff7c703          	lbu	a4,-1(a5)
     bc2:	fb7d                	bnez	a4,bb8 <strlen+0x14>
    ;
  return n;
}
     bc4:	6422                	ld	s0,8(sp)
     bc6:	0141                	addi	sp,sp,16
     bc8:	8082                	ret
  for(n = 0; s[n]; n++)
     bca:	4501                	li	a0,0
     bcc:	bfe5                	j	bc4 <strlen+0x20>

0000000000000bce <memset>:

void*
memset(void *dst, int c, uint n)
{
     bce:	1141                	addi	sp,sp,-16
     bd0:	e422                	sd	s0,8(sp)
     bd2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     bd4:	ca19                	beqz	a2,bea <memset+0x1c>
     bd6:	87aa                	mv	a5,a0
     bd8:	1602                	slli	a2,a2,0x20
     bda:	9201                	srli	a2,a2,0x20
     bdc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     be0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     be4:	0785                	addi	a5,a5,1
     be6:	fee79de3          	bne	a5,a4,be0 <memset+0x12>
  }
  return dst;
}
     bea:	6422                	ld	s0,8(sp)
     bec:	0141                	addi	sp,sp,16
     bee:	8082                	ret

0000000000000bf0 <strchr>:

char*
strchr(const char *s, char c)
{
     bf0:	1141                	addi	sp,sp,-16
     bf2:	e422                	sd	s0,8(sp)
     bf4:	0800                	addi	s0,sp,16
  for(; *s; s++)
     bf6:	00054783          	lbu	a5,0(a0)
     bfa:	cb99                	beqz	a5,c10 <strchr+0x20>
    if(*s == c)
     bfc:	00f58763          	beq	a1,a5,c0a <strchr+0x1a>
  for(; *s; s++)
     c00:	0505                	addi	a0,a0,1
     c02:	00054783          	lbu	a5,0(a0)
     c06:	fbfd                	bnez	a5,bfc <strchr+0xc>
      return (char*)s;
  return 0;
     c08:	4501                	li	a0,0
}
     c0a:	6422                	ld	s0,8(sp)
     c0c:	0141                	addi	sp,sp,16
     c0e:	8082                	ret
  return 0;
     c10:	4501                	li	a0,0
     c12:	bfe5                	j	c0a <strchr+0x1a>

0000000000000c14 <gets>:

char*
gets(char *buf, int max)
{
     c14:	711d                	addi	sp,sp,-96
     c16:	ec86                	sd	ra,88(sp)
     c18:	e8a2                	sd	s0,80(sp)
     c1a:	e4a6                	sd	s1,72(sp)
     c1c:	e0ca                	sd	s2,64(sp)
     c1e:	fc4e                	sd	s3,56(sp)
     c20:	f852                	sd	s4,48(sp)
     c22:	f456                	sd	s5,40(sp)
     c24:	f05a                	sd	s6,32(sp)
     c26:	ec5e                	sd	s7,24(sp)
     c28:	1080                	addi	s0,sp,96
     c2a:	8baa                	mv	s7,a0
     c2c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c2e:	892a                	mv	s2,a0
     c30:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c32:	4aa9                	li	s5,10
     c34:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c36:	89a6                	mv	s3,s1
     c38:	2485                	addiw	s1,s1,1
     c3a:	0344d863          	bge	s1,s4,c6a <gets+0x56>
    cc = read(0, &c, 1);
     c3e:	4605                	li	a2,1
     c40:	faf40593          	addi	a1,s0,-81
     c44:	4501                	li	a0,0
     c46:	00000097          	auipc	ra,0x0
     c4a:	1b0080e7          	jalr	432(ra) # df6 <read>
    if(cc < 1)
     c4e:	00a05e63          	blez	a0,c6a <gets+0x56>
    buf[i++] = c;
     c52:	faf44783          	lbu	a5,-81(s0)
     c56:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c5a:	01578763          	beq	a5,s5,c68 <gets+0x54>
     c5e:	0905                	addi	s2,s2,1
     c60:	fd679be3          	bne	a5,s6,c36 <gets+0x22>
  for(i=0; i+1 < max; ){
     c64:	89a6                	mv	s3,s1
     c66:	a011                	j	c6a <gets+0x56>
     c68:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c6a:	99de                	add	s3,s3,s7
     c6c:	00098023          	sb	zero,0(s3)
  return buf;
}
     c70:	855e                	mv	a0,s7
     c72:	60e6                	ld	ra,88(sp)
     c74:	6446                	ld	s0,80(sp)
     c76:	64a6                	ld	s1,72(sp)
     c78:	6906                	ld	s2,64(sp)
     c7a:	79e2                	ld	s3,56(sp)
     c7c:	7a42                	ld	s4,48(sp)
     c7e:	7aa2                	ld	s5,40(sp)
     c80:	7b02                	ld	s6,32(sp)
     c82:	6be2                	ld	s7,24(sp)
     c84:	6125                	addi	sp,sp,96
     c86:	8082                	ret

0000000000000c88 <stat>:

int
stat(const char *n, struct stat *st)
{
     c88:	1101                	addi	sp,sp,-32
     c8a:	ec06                	sd	ra,24(sp)
     c8c:	e822                	sd	s0,16(sp)
     c8e:	e426                	sd	s1,8(sp)
     c90:	e04a                	sd	s2,0(sp)
     c92:	1000                	addi	s0,sp,32
     c94:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c96:	4581                	li	a1,0
     c98:	00000097          	auipc	ra,0x0
     c9c:	186080e7          	jalr	390(ra) # e1e <open>
  if(fd < 0)
     ca0:	02054563          	bltz	a0,cca <stat+0x42>
     ca4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ca6:	85ca                	mv	a1,s2
     ca8:	00000097          	auipc	ra,0x0
     cac:	18e080e7          	jalr	398(ra) # e36 <fstat>
     cb0:	892a                	mv	s2,a0
  close(fd);
     cb2:	8526                	mv	a0,s1
     cb4:	00000097          	auipc	ra,0x0
     cb8:	152080e7          	jalr	338(ra) # e06 <close>
  return r;
}
     cbc:	854a                	mv	a0,s2
     cbe:	60e2                	ld	ra,24(sp)
     cc0:	6442                	ld	s0,16(sp)
     cc2:	64a2                	ld	s1,8(sp)
     cc4:	6902                	ld	s2,0(sp)
     cc6:	6105                	addi	sp,sp,32
     cc8:	8082                	ret
    return -1;
     cca:	597d                	li	s2,-1
     ccc:	bfc5                	j	cbc <stat+0x34>

0000000000000cce <atoi>:

int
atoi(const char *s)
{
     cce:	1141                	addi	sp,sp,-16
     cd0:	e422                	sd	s0,8(sp)
     cd2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cd4:	00054683          	lbu	a3,0(a0)
     cd8:	fd06879b          	addiw	a5,a3,-48
     cdc:	0ff7f793          	zext.b	a5,a5
     ce0:	4625                	li	a2,9
     ce2:	02f66863          	bltu	a2,a5,d12 <atoi+0x44>
     ce6:	872a                	mv	a4,a0
  n = 0;
     ce8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     cea:	0705                	addi	a4,a4,1
     cec:	0025179b          	slliw	a5,a0,0x2
     cf0:	9fa9                	addw	a5,a5,a0
     cf2:	0017979b          	slliw	a5,a5,0x1
     cf6:	9fb5                	addw	a5,a5,a3
     cf8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     cfc:	00074683          	lbu	a3,0(a4)
     d00:	fd06879b          	addiw	a5,a3,-48
     d04:	0ff7f793          	zext.b	a5,a5
     d08:	fef671e3          	bgeu	a2,a5,cea <atoi+0x1c>
  return n;
}
     d0c:	6422                	ld	s0,8(sp)
     d0e:	0141                	addi	sp,sp,16
     d10:	8082                	ret
  n = 0;
     d12:	4501                	li	a0,0
     d14:	bfe5                	j	d0c <atoi+0x3e>

0000000000000d16 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d16:	1141                	addi	sp,sp,-16
     d18:	e422                	sd	s0,8(sp)
     d1a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d1c:	02b57463          	bgeu	a0,a1,d44 <memmove+0x2e>
    while(n-- > 0)
     d20:	00c05f63          	blez	a2,d3e <memmove+0x28>
     d24:	1602                	slli	a2,a2,0x20
     d26:	9201                	srli	a2,a2,0x20
     d28:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d2c:	872a                	mv	a4,a0
      *dst++ = *src++;
     d2e:	0585                	addi	a1,a1,1
     d30:	0705                	addi	a4,a4,1
     d32:	fff5c683          	lbu	a3,-1(a1)
     d36:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d3a:	fee79ae3          	bne	a5,a4,d2e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d3e:	6422                	ld	s0,8(sp)
     d40:	0141                	addi	sp,sp,16
     d42:	8082                	ret
    dst += n;
     d44:	00c50733          	add	a4,a0,a2
    src += n;
     d48:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d4a:	fec05ae3          	blez	a2,d3e <memmove+0x28>
     d4e:	fff6079b          	addiw	a5,a2,-1
     d52:	1782                	slli	a5,a5,0x20
     d54:	9381                	srli	a5,a5,0x20
     d56:	fff7c793          	not	a5,a5
     d5a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d5c:	15fd                	addi	a1,a1,-1
     d5e:	177d                	addi	a4,a4,-1
     d60:	0005c683          	lbu	a3,0(a1)
     d64:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d68:	fee79ae3          	bne	a5,a4,d5c <memmove+0x46>
     d6c:	bfc9                	j	d3e <memmove+0x28>

0000000000000d6e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d6e:	1141                	addi	sp,sp,-16
     d70:	e422                	sd	s0,8(sp)
     d72:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d74:	ca05                	beqz	a2,da4 <memcmp+0x36>
     d76:	fff6069b          	addiw	a3,a2,-1
     d7a:	1682                	slli	a3,a3,0x20
     d7c:	9281                	srli	a3,a3,0x20
     d7e:	0685                	addi	a3,a3,1
     d80:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     d82:	00054783          	lbu	a5,0(a0)
     d86:	0005c703          	lbu	a4,0(a1)
     d8a:	00e79863          	bne	a5,a4,d9a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     d8e:	0505                	addi	a0,a0,1
    p2++;
     d90:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     d92:	fed518e3          	bne	a0,a3,d82 <memcmp+0x14>
  }
  return 0;
     d96:	4501                	li	a0,0
     d98:	a019                	j	d9e <memcmp+0x30>
      return *p1 - *p2;
     d9a:	40e7853b          	subw	a0,a5,a4
}
     d9e:	6422                	ld	s0,8(sp)
     da0:	0141                	addi	sp,sp,16
     da2:	8082                	ret
  return 0;
     da4:	4501                	li	a0,0
     da6:	bfe5                	j	d9e <memcmp+0x30>

0000000000000da8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     da8:	1141                	addi	sp,sp,-16
     daa:	e406                	sd	ra,8(sp)
     dac:	e022                	sd	s0,0(sp)
     dae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     db0:	00000097          	auipc	ra,0x0
     db4:	f66080e7          	jalr	-154(ra) # d16 <memmove>
}
     db8:	60a2                	ld	ra,8(sp)
     dba:	6402                	ld	s0,0(sp)
     dbc:	0141                	addi	sp,sp,16
     dbe:	8082                	ret

0000000000000dc0 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
     dc0:	1141                	addi	sp,sp,-16
     dc2:	e422                	sd	s0,8(sp)
     dc4:	0800                	addi	s0,sp,16
  struct usyscall* u = (struct usyscall *)USYSCALL;
  return u->pid;
     dc6:	040007b7          	lui	a5,0x4000
}
     dca:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffe344>
     dcc:	07b2                	slli	a5,a5,0xc
     dce:	4388                	lw	a0,0(a5)
     dd0:	6422                	ld	s0,8(sp)
     dd2:	0141                	addi	sp,sp,16
     dd4:	8082                	ret

0000000000000dd6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     dd6:	4885                	li	a7,1
 ecall
     dd8:	00000073          	ecall
 ret
     ddc:	8082                	ret

0000000000000dde <exit>:
.global exit
exit:
 li a7, SYS_exit
     dde:	4889                	li	a7,2
 ecall
     de0:	00000073          	ecall
 ret
     de4:	8082                	ret

0000000000000de6 <wait>:
.global wait
wait:
 li a7, SYS_wait
     de6:	488d                	li	a7,3
 ecall
     de8:	00000073          	ecall
 ret
     dec:	8082                	ret

0000000000000dee <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     dee:	4891                	li	a7,4
 ecall
     df0:	00000073          	ecall
 ret
     df4:	8082                	ret

0000000000000df6 <read>:
.global read
read:
 li a7, SYS_read
     df6:	4895                	li	a7,5
 ecall
     df8:	00000073          	ecall
 ret
     dfc:	8082                	ret

0000000000000dfe <write>:
.global write
write:
 li a7, SYS_write
     dfe:	48c1                	li	a7,16
 ecall
     e00:	00000073          	ecall
 ret
     e04:	8082                	ret

0000000000000e06 <close>:
.global close
close:
 li a7, SYS_close
     e06:	48d5                	li	a7,21
 ecall
     e08:	00000073          	ecall
 ret
     e0c:	8082                	ret

0000000000000e0e <kill>:
.global kill
kill:
 li a7, SYS_kill
     e0e:	4899                	li	a7,6
 ecall
     e10:	00000073          	ecall
 ret
     e14:	8082                	ret

0000000000000e16 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e16:	489d                	li	a7,7
 ecall
     e18:	00000073          	ecall
 ret
     e1c:	8082                	ret

0000000000000e1e <open>:
.global open
open:
 li a7, SYS_open
     e1e:	48bd                	li	a7,15
 ecall
     e20:	00000073          	ecall
 ret
     e24:	8082                	ret

0000000000000e26 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e26:	48c5                	li	a7,17
 ecall
     e28:	00000073          	ecall
 ret
     e2c:	8082                	ret

0000000000000e2e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e2e:	48c9                	li	a7,18
 ecall
     e30:	00000073          	ecall
 ret
     e34:	8082                	ret

0000000000000e36 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e36:	48a1                	li	a7,8
 ecall
     e38:	00000073          	ecall
 ret
     e3c:	8082                	ret

0000000000000e3e <link>:
.global link
link:
 li a7, SYS_link
     e3e:	48cd                	li	a7,19
 ecall
     e40:	00000073          	ecall
 ret
     e44:	8082                	ret

0000000000000e46 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e46:	48d1                	li	a7,20
 ecall
     e48:	00000073          	ecall
 ret
     e4c:	8082                	ret

0000000000000e4e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e4e:	48a5                	li	a7,9
 ecall
     e50:	00000073          	ecall
 ret
     e54:	8082                	ret

0000000000000e56 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e56:	48a9                	li	a7,10
 ecall
     e58:	00000073          	ecall
 ret
     e5c:	8082                	ret

0000000000000e5e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e5e:	48ad                	li	a7,11
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e66:	48b1                	li	a7,12
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e6e:	48b5                	li	a7,13
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e76:	48b9                	li	a7,14
 ecall
     e78:	00000073          	ecall
 ret
     e7c:	8082                	ret

0000000000000e7e <connect>:
.global connect
connect:
 li a7, SYS_connect
     e7e:	48f5                	li	a7,29
 ecall
     e80:	00000073          	ecall
 ret
     e84:	8082                	ret

0000000000000e86 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     e86:	48f9                	li	a7,30
 ecall
     e88:	00000073          	ecall
 ret
     e8c:	8082                	ret

0000000000000e8e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e8e:	1101                	addi	sp,sp,-32
     e90:	ec06                	sd	ra,24(sp)
     e92:	e822                	sd	s0,16(sp)
     e94:	1000                	addi	s0,sp,32
     e96:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e9a:	4605                	li	a2,1
     e9c:	fef40593          	addi	a1,s0,-17
     ea0:	00000097          	auipc	ra,0x0
     ea4:	f5e080e7          	jalr	-162(ra) # dfe <write>
}
     ea8:	60e2                	ld	ra,24(sp)
     eaa:	6442                	ld	s0,16(sp)
     eac:	6105                	addi	sp,sp,32
     eae:	8082                	ret

0000000000000eb0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     eb0:	7139                	addi	sp,sp,-64
     eb2:	fc06                	sd	ra,56(sp)
     eb4:	f822                	sd	s0,48(sp)
     eb6:	f426                	sd	s1,40(sp)
     eb8:	f04a                	sd	s2,32(sp)
     eba:	ec4e                	sd	s3,24(sp)
     ebc:	0080                	addi	s0,sp,64
     ebe:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ec0:	c299                	beqz	a3,ec6 <printint+0x16>
     ec2:	0805c963          	bltz	a1,f54 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ec6:	2581                	sext.w	a1,a1
  neg = 0;
     ec8:	4881                	li	a7,0
     eca:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ece:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ed0:	2601                	sext.w	a2,a2
     ed2:	00000517          	auipc	a0,0x0
     ed6:	5d650513          	addi	a0,a0,1494 # 14a8 <digits>
     eda:	883a                	mv	a6,a4
     edc:	2705                	addiw	a4,a4,1
     ede:	02c5f7bb          	remuw	a5,a1,a2
     ee2:	1782                	slli	a5,a5,0x20
     ee4:	9381                	srli	a5,a5,0x20
     ee6:	97aa                	add	a5,a5,a0
     ee8:	0007c783          	lbu	a5,0(a5)
     eec:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ef0:	0005879b          	sext.w	a5,a1
     ef4:	02c5d5bb          	divuw	a1,a1,a2
     ef8:	0685                	addi	a3,a3,1
     efa:	fec7f0e3          	bgeu	a5,a2,eda <printint+0x2a>
  if(neg)
     efe:	00088c63          	beqz	a7,f16 <printint+0x66>
    buf[i++] = '-';
     f02:	fd070793          	addi	a5,a4,-48
     f06:	00878733          	add	a4,a5,s0
     f0a:	02d00793          	li	a5,45
     f0e:	fef70823          	sb	a5,-16(a4)
     f12:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f16:	02e05863          	blez	a4,f46 <printint+0x96>
     f1a:	fc040793          	addi	a5,s0,-64
     f1e:	00e78933          	add	s2,a5,a4
     f22:	fff78993          	addi	s3,a5,-1
     f26:	99ba                	add	s3,s3,a4
     f28:	377d                	addiw	a4,a4,-1
     f2a:	1702                	slli	a4,a4,0x20
     f2c:	9301                	srli	a4,a4,0x20
     f2e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f32:	fff94583          	lbu	a1,-1(s2)
     f36:	8526                	mv	a0,s1
     f38:	00000097          	auipc	ra,0x0
     f3c:	f56080e7          	jalr	-170(ra) # e8e <putc>
  while(--i >= 0)
     f40:	197d                	addi	s2,s2,-1
     f42:	ff3918e3          	bne	s2,s3,f32 <printint+0x82>
}
     f46:	70e2                	ld	ra,56(sp)
     f48:	7442                	ld	s0,48(sp)
     f4a:	74a2                	ld	s1,40(sp)
     f4c:	7902                	ld	s2,32(sp)
     f4e:	69e2                	ld	s3,24(sp)
     f50:	6121                	addi	sp,sp,64
     f52:	8082                	ret
    x = -xx;
     f54:	40b005bb          	negw	a1,a1
    neg = 1;
     f58:	4885                	li	a7,1
    x = -xx;
     f5a:	bf85                	j	eca <printint+0x1a>

0000000000000f5c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f5c:	7119                	addi	sp,sp,-128
     f5e:	fc86                	sd	ra,120(sp)
     f60:	f8a2                	sd	s0,112(sp)
     f62:	f4a6                	sd	s1,104(sp)
     f64:	f0ca                	sd	s2,96(sp)
     f66:	ecce                	sd	s3,88(sp)
     f68:	e8d2                	sd	s4,80(sp)
     f6a:	e4d6                	sd	s5,72(sp)
     f6c:	e0da                	sd	s6,64(sp)
     f6e:	fc5e                	sd	s7,56(sp)
     f70:	f862                	sd	s8,48(sp)
     f72:	f466                	sd	s9,40(sp)
     f74:	f06a                	sd	s10,32(sp)
     f76:	ec6e                	sd	s11,24(sp)
     f78:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f7a:	0005c903          	lbu	s2,0(a1)
     f7e:	18090f63          	beqz	s2,111c <vprintf+0x1c0>
     f82:	8aaa                	mv	s5,a0
     f84:	8b32                	mv	s6,a2
     f86:	00158493          	addi	s1,a1,1
  state = 0;
     f8a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f8c:	02500a13          	li	s4,37
     f90:	4c55                	li	s8,21
     f92:	00000c97          	auipc	s9,0x0
     f96:	4bec8c93          	addi	s9,s9,1214 # 1450 <malloc+0x230>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     f9a:	02800d93          	li	s11,40
  putc(fd, 'x');
     f9e:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fa0:	00000b97          	auipc	s7,0x0
     fa4:	508b8b93          	addi	s7,s7,1288 # 14a8 <digits>
     fa8:	a839                	j	fc6 <vprintf+0x6a>
        putc(fd, c);
     faa:	85ca                	mv	a1,s2
     fac:	8556                	mv	a0,s5
     fae:	00000097          	auipc	ra,0x0
     fb2:	ee0080e7          	jalr	-288(ra) # e8e <putc>
     fb6:	a019                	j	fbc <vprintf+0x60>
    } else if(state == '%'){
     fb8:	01498d63          	beq	s3,s4,fd2 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     fbc:	0485                	addi	s1,s1,1
     fbe:	fff4c903          	lbu	s2,-1(s1)
     fc2:	14090d63          	beqz	s2,111c <vprintf+0x1c0>
    if(state == 0){
     fc6:	fe0999e3          	bnez	s3,fb8 <vprintf+0x5c>
      if(c == '%'){
     fca:	ff4910e3          	bne	s2,s4,faa <vprintf+0x4e>
        state = '%';
     fce:	89d2                	mv	s3,s4
     fd0:	b7f5                	j	fbc <vprintf+0x60>
      if(c == 'd'){
     fd2:	11490c63          	beq	s2,s4,10ea <vprintf+0x18e>
     fd6:	f9d9079b          	addiw	a5,s2,-99
     fda:	0ff7f793          	zext.b	a5,a5
     fde:	10fc6e63          	bltu	s8,a5,10fa <vprintf+0x19e>
     fe2:	f9d9079b          	addiw	a5,s2,-99
     fe6:	0ff7f713          	zext.b	a4,a5
     fea:	10ec6863          	bltu	s8,a4,10fa <vprintf+0x19e>
     fee:	00271793          	slli	a5,a4,0x2
     ff2:	97e6                	add	a5,a5,s9
     ff4:	439c                	lw	a5,0(a5)
     ff6:	97e6                	add	a5,a5,s9
     ff8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     ffa:	008b0913          	addi	s2,s6,8
     ffe:	4685                	li	a3,1
    1000:	4629                	li	a2,10
    1002:	000b2583          	lw	a1,0(s6)
    1006:	8556                	mv	a0,s5
    1008:	00000097          	auipc	ra,0x0
    100c:	ea8080e7          	jalr	-344(ra) # eb0 <printint>
    1010:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1012:	4981                	li	s3,0
    1014:	b765                	j	fbc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1016:	008b0913          	addi	s2,s6,8
    101a:	4681                	li	a3,0
    101c:	4629                	li	a2,10
    101e:	000b2583          	lw	a1,0(s6)
    1022:	8556                	mv	a0,s5
    1024:	00000097          	auipc	ra,0x0
    1028:	e8c080e7          	jalr	-372(ra) # eb0 <printint>
    102c:	8b4a                	mv	s6,s2
      state = 0;
    102e:	4981                	li	s3,0
    1030:	b771                	j	fbc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1032:	008b0913          	addi	s2,s6,8
    1036:	4681                	li	a3,0
    1038:	866a                	mv	a2,s10
    103a:	000b2583          	lw	a1,0(s6)
    103e:	8556                	mv	a0,s5
    1040:	00000097          	auipc	ra,0x0
    1044:	e70080e7          	jalr	-400(ra) # eb0 <printint>
    1048:	8b4a                	mv	s6,s2
      state = 0;
    104a:	4981                	li	s3,0
    104c:	bf85                	j	fbc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    104e:	008b0793          	addi	a5,s6,8
    1052:	f8f43423          	sd	a5,-120(s0)
    1056:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    105a:	03000593          	li	a1,48
    105e:	8556                	mv	a0,s5
    1060:	00000097          	auipc	ra,0x0
    1064:	e2e080e7          	jalr	-466(ra) # e8e <putc>
  putc(fd, 'x');
    1068:	07800593          	li	a1,120
    106c:	8556                	mv	a0,s5
    106e:	00000097          	auipc	ra,0x0
    1072:	e20080e7          	jalr	-480(ra) # e8e <putc>
    1076:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1078:	03c9d793          	srli	a5,s3,0x3c
    107c:	97de                	add	a5,a5,s7
    107e:	0007c583          	lbu	a1,0(a5)
    1082:	8556                	mv	a0,s5
    1084:	00000097          	auipc	ra,0x0
    1088:	e0a080e7          	jalr	-502(ra) # e8e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    108c:	0992                	slli	s3,s3,0x4
    108e:	397d                	addiw	s2,s2,-1
    1090:	fe0914e3          	bnez	s2,1078 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    1094:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1098:	4981                	li	s3,0
    109a:	b70d                	j	fbc <vprintf+0x60>
        s = va_arg(ap, char*);
    109c:	008b0913          	addi	s2,s6,8
    10a0:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    10a4:	02098163          	beqz	s3,10c6 <vprintf+0x16a>
        while(*s != 0){
    10a8:	0009c583          	lbu	a1,0(s3)
    10ac:	c5ad                	beqz	a1,1116 <vprintf+0x1ba>
          putc(fd, *s);
    10ae:	8556                	mv	a0,s5
    10b0:	00000097          	auipc	ra,0x0
    10b4:	dde080e7          	jalr	-546(ra) # e8e <putc>
          s++;
    10b8:	0985                	addi	s3,s3,1
        while(*s != 0){
    10ba:	0009c583          	lbu	a1,0(s3)
    10be:	f9e5                	bnez	a1,10ae <vprintf+0x152>
        s = va_arg(ap, char*);
    10c0:	8b4a                	mv	s6,s2
      state = 0;
    10c2:	4981                	li	s3,0
    10c4:	bde5                	j	fbc <vprintf+0x60>
          s = "(null)";
    10c6:	00000997          	auipc	s3,0x0
    10ca:	38298993          	addi	s3,s3,898 # 1448 <malloc+0x228>
        while(*s != 0){
    10ce:	85ee                	mv	a1,s11
    10d0:	bff9                	j	10ae <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    10d2:	008b0913          	addi	s2,s6,8
    10d6:	000b4583          	lbu	a1,0(s6)
    10da:	8556                	mv	a0,s5
    10dc:	00000097          	auipc	ra,0x0
    10e0:	db2080e7          	jalr	-590(ra) # e8e <putc>
    10e4:	8b4a                	mv	s6,s2
      state = 0;
    10e6:	4981                	li	s3,0
    10e8:	bdd1                	j	fbc <vprintf+0x60>
        putc(fd, c);
    10ea:	85d2                	mv	a1,s4
    10ec:	8556                	mv	a0,s5
    10ee:	00000097          	auipc	ra,0x0
    10f2:	da0080e7          	jalr	-608(ra) # e8e <putc>
      state = 0;
    10f6:	4981                	li	s3,0
    10f8:	b5d1                	j	fbc <vprintf+0x60>
        putc(fd, '%');
    10fa:	85d2                	mv	a1,s4
    10fc:	8556                	mv	a0,s5
    10fe:	00000097          	auipc	ra,0x0
    1102:	d90080e7          	jalr	-624(ra) # e8e <putc>
        putc(fd, c);
    1106:	85ca                	mv	a1,s2
    1108:	8556                	mv	a0,s5
    110a:	00000097          	auipc	ra,0x0
    110e:	d84080e7          	jalr	-636(ra) # e8e <putc>
      state = 0;
    1112:	4981                	li	s3,0
    1114:	b565                	j	fbc <vprintf+0x60>
        s = va_arg(ap, char*);
    1116:	8b4a                	mv	s6,s2
      state = 0;
    1118:	4981                	li	s3,0
    111a:	b54d                	j	fbc <vprintf+0x60>
    }
  }
}
    111c:	70e6                	ld	ra,120(sp)
    111e:	7446                	ld	s0,112(sp)
    1120:	74a6                	ld	s1,104(sp)
    1122:	7906                	ld	s2,96(sp)
    1124:	69e6                	ld	s3,88(sp)
    1126:	6a46                	ld	s4,80(sp)
    1128:	6aa6                	ld	s5,72(sp)
    112a:	6b06                	ld	s6,64(sp)
    112c:	7be2                	ld	s7,56(sp)
    112e:	7c42                	ld	s8,48(sp)
    1130:	7ca2                	ld	s9,40(sp)
    1132:	7d02                	ld	s10,32(sp)
    1134:	6de2                	ld	s11,24(sp)
    1136:	6109                	addi	sp,sp,128
    1138:	8082                	ret

000000000000113a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    113a:	715d                	addi	sp,sp,-80
    113c:	ec06                	sd	ra,24(sp)
    113e:	e822                	sd	s0,16(sp)
    1140:	1000                	addi	s0,sp,32
    1142:	e010                	sd	a2,0(s0)
    1144:	e414                	sd	a3,8(s0)
    1146:	e818                	sd	a4,16(s0)
    1148:	ec1c                	sd	a5,24(s0)
    114a:	03043023          	sd	a6,32(s0)
    114e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1152:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1156:	8622                	mv	a2,s0
    1158:	00000097          	auipc	ra,0x0
    115c:	e04080e7          	jalr	-508(ra) # f5c <vprintf>
}
    1160:	60e2                	ld	ra,24(sp)
    1162:	6442                	ld	s0,16(sp)
    1164:	6161                	addi	sp,sp,80
    1166:	8082                	ret

0000000000001168 <printf>:

void
printf(const char *fmt, ...)
{
    1168:	711d                	addi	sp,sp,-96
    116a:	ec06                	sd	ra,24(sp)
    116c:	e822                	sd	s0,16(sp)
    116e:	1000                	addi	s0,sp,32
    1170:	e40c                	sd	a1,8(s0)
    1172:	e810                	sd	a2,16(s0)
    1174:	ec14                	sd	a3,24(s0)
    1176:	f018                	sd	a4,32(s0)
    1178:	f41c                	sd	a5,40(s0)
    117a:	03043823          	sd	a6,48(s0)
    117e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1182:	00840613          	addi	a2,s0,8
    1186:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    118a:	85aa                	mv	a1,a0
    118c:	4505                	li	a0,1
    118e:	00000097          	auipc	ra,0x0
    1192:	dce080e7          	jalr	-562(ra) # f5c <vprintf>
}
    1196:	60e2                	ld	ra,24(sp)
    1198:	6442                	ld	s0,16(sp)
    119a:	6125                	addi	sp,sp,96
    119c:	8082                	ret

000000000000119e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    119e:	1141                	addi	sp,sp,-16
    11a0:	e422                	sd	s0,8(sp)
    11a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11a4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11a8:	00000797          	auipc	a5,0x0
    11ac:	3287b783          	ld	a5,808(a5) # 14d0 <freep>
    11b0:	a02d                	j	11da <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11b2:	4618                	lw	a4,8(a2)
    11b4:	9f2d                	addw	a4,a4,a1
    11b6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11ba:	6398                	ld	a4,0(a5)
    11bc:	6310                	ld	a2,0(a4)
    11be:	a83d                	j	11fc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11c0:	ff852703          	lw	a4,-8(a0)
    11c4:	9f31                	addw	a4,a4,a2
    11c6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11c8:	ff053683          	ld	a3,-16(a0)
    11cc:	a091                	j	1210 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11ce:	6398                	ld	a4,0(a5)
    11d0:	00e7e463          	bltu	a5,a4,11d8 <free+0x3a>
    11d4:	00e6ea63          	bltu	a3,a4,11e8 <free+0x4a>
{
    11d8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11da:	fed7fae3          	bgeu	a5,a3,11ce <free+0x30>
    11de:	6398                	ld	a4,0(a5)
    11e0:	00e6e463          	bltu	a3,a4,11e8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11e4:	fee7eae3          	bltu	a5,a4,11d8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    11e8:	ff852583          	lw	a1,-8(a0)
    11ec:	6390                	ld	a2,0(a5)
    11ee:	02059813          	slli	a6,a1,0x20
    11f2:	01c85713          	srli	a4,a6,0x1c
    11f6:	9736                	add	a4,a4,a3
    11f8:	fae60de3          	beq	a2,a4,11b2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    11fc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1200:	4790                	lw	a2,8(a5)
    1202:	02061593          	slli	a1,a2,0x20
    1206:	01c5d713          	srli	a4,a1,0x1c
    120a:	973e                	add	a4,a4,a5
    120c:	fae68ae3          	beq	a3,a4,11c0 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1210:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1212:	00000717          	auipc	a4,0x0
    1216:	2af73f23          	sd	a5,702(a4) # 14d0 <freep>
}
    121a:	6422                	ld	s0,8(sp)
    121c:	0141                	addi	sp,sp,16
    121e:	8082                	ret

0000000000001220 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1220:	7139                	addi	sp,sp,-64
    1222:	fc06                	sd	ra,56(sp)
    1224:	f822                	sd	s0,48(sp)
    1226:	f426                	sd	s1,40(sp)
    1228:	f04a                	sd	s2,32(sp)
    122a:	ec4e                	sd	s3,24(sp)
    122c:	e852                	sd	s4,16(sp)
    122e:	e456                	sd	s5,8(sp)
    1230:	e05a                	sd	s6,0(sp)
    1232:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1234:	02051493          	slli	s1,a0,0x20
    1238:	9081                	srli	s1,s1,0x20
    123a:	04bd                	addi	s1,s1,15
    123c:	8091                	srli	s1,s1,0x4
    123e:	0014899b          	addiw	s3,s1,1
    1242:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1244:	00000517          	auipc	a0,0x0
    1248:	28c53503          	ld	a0,652(a0) # 14d0 <freep>
    124c:	c515                	beqz	a0,1278 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    124e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1250:	4798                	lw	a4,8(a5)
    1252:	02977f63          	bgeu	a4,s1,1290 <malloc+0x70>
    1256:	8a4e                	mv	s4,s3
    1258:	0009871b          	sext.w	a4,s3
    125c:	6685                	lui	a3,0x1
    125e:	00d77363          	bgeu	a4,a3,1264 <malloc+0x44>
    1262:	6a05                	lui	s4,0x1
    1264:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1268:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    126c:	00000917          	auipc	s2,0x0
    1270:	26490913          	addi	s2,s2,612 # 14d0 <freep>
  if(p == (char*)-1)
    1274:	5afd                	li	s5,-1
    1276:	a895                	j	12ea <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    1278:	00000797          	auipc	a5,0x0
    127c:	2c878793          	addi	a5,a5,712 # 1540 <base>
    1280:	00000717          	auipc	a4,0x0
    1284:	24f73823          	sd	a5,592(a4) # 14d0 <freep>
    1288:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    128a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    128e:	b7e1                	j	1256 <malloc+0x36>
      if(p->s.size == nunits)
    1290:	02e48c63          	beq	s1,a4,12c8 <malloc+0xa8>
        p->s.size -= nunits;
    1294:	4137073b          	subw	a4,a4,s3
    1298:	c798                	sw	a4,8(a5)
        p += p->s.size;
    129a:	02071693          	slli	a3,a4,0x20
    129e:	01c6d713          	srli	a4,a3,0x1c
    12a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12a8:	00000717          	auipc	a4,0x0
    12ac:	22a73423          	sd	a0,552(a4) # 14d0 <freep>
      return (void*)(p + 1);
    12b0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12b4:	70e2                	ld	ra,56(sp)
    12b6:	7442                	ld	s0,48(sp)
    12b8:	74a2                	ld	s1,40(sp)
    12ba:	7902                	ld	s2,32(sp)
    12bc:	69e2                	ld	s3,24(sp)
    12be:	6a42                	ld	s4,16(sp)
    12c0:	6aa2                	ld	s5,8(sp)
    12c2:	6b02                	ld	s6,0(sp)
    12c4:	6121                	addi	sp,sp,64
    12c6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12c8:	6398                	ld	a4,0(a5)
    12ca:	e118                	sd	a4,0(a0)
    12cc:	bff1                	j	12a8 <malloc+0x88>
  hp->s.size = nu;
    12ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12d2:	0541                	addi	a0,a0,16
    12d4:	00000097          	auipc	ra,0x0
    12d8:	eca080e7          	jalr	-310(ra) # 119e <free>
  return freep;
    12dc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12e0:	d971                	beqz	a0,12b4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12e4:	4798                	lw	a4,8(a5)
    12e6:	fa9775e3          	bgeu	a4,s1,1290 <malloc+0x70>
    if(p == freep)
    12ea:	00093703          	ld	a4,0(s2)
    12ee:	853e                	mv	a0,a5
    12f0:	fef719e3          	bne	a4,a5,12e2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    12f4:	8552                	mv	a0,s4
    12f6:	00000097          	auipc	ra,0x0
    12fa:	b70080e7          	jalr	-1168(ra) # e66 <sbrk>
  if(p == (char*)-1)
    12fe:	fd5518e3          	bne	a0,s5,12ce <malloc+0xae>
        return 0;
    1302:	4501                	li	a0,0
    1304:	bf45                	j	12b4 <malloc+0x94>
