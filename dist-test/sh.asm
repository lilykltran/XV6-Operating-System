
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	56                   	push   %esi
       4:	53                   	push   %ebx
       5:	8b 5d 08             	mov    0x8(%ebp),%ebx
       8:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 2c 13 00 00       	push   $0x132c
      13:	6a 02                	push   $0x2
      15:	e8 fb 0f 00 00       	call   1015 <printf>
  memset(buf, 0, nbuf);
      1a:	83 c4 0c             	add    $0xc,%esp
      1d:	56                   	push   %esi
      1e:	6a 00                	push   $0x0
      20:	53                   	push   %ebx
      21:	e8 9b 0c 00 00       	call   cc1 <memset>
  gets(buf, nbuf);
      26:	83 c4 08             	add    $0x8,%esp
      29:	56                   	push   %esi
      2a:	53                   	push   %ebx
      2b:	e8 de 0c 00 00       	call   d0e <gets>
  if(buf[0] == 0) // EOF
      30:	83 c4 10             	add    $0x10,%esp
      33:	80 3b 00             	cmpb   $0x0,(%ebx)
      36:	0f 94 c0             	sete   %al
      39:	0f b6 c0             	movzbl %al,%eax
      3c:	f7 d8                	neg    %eax
    return -1;
  return 0;
}
      3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
      41:	5b                   	pop    %ebx
      42:	5e                   	pop    %esi
      43:	5d                   	pop    %ebp
      44:	c3                   	ret    

00000045 <strncmp>:
#ifdef USE_BUILTINS
// ***** processing for shell builtins begins here *****

int
strncmp(const char *p, const char *q, uint n)
{
      45:	55                   	push   %ebp
      46:	89 e5                	mov    %esp,%ebp
      48:	53                   	push   %ebx
      49:	8b 45 08             	mov    0x8(%ebp),%eax
      4c:	8b 55 0c             	mov    0xc(%ebp),%edx
      4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    while(n > 0 && *p && *p == *q)
      52:	85 db                	test   %ebx,%ebx
      54:	74 2d                	je     83 <strncmp+0x3e>
      56:	0f b6 08             	movzbl (%eax),%ecx
      59:	84 c9                	test   %cl,%cl
      5b:	74 1b                	je     78 <strncmp+0x33>
      5d:	3a 0a                	cmp    (%edx),%cl
      5f:	75 17                	jne    78 <strncmp+0x33>
      61:	01 c3                	add    %eax,%ebx
      n--, p++, q++;
      63:	83 c0 01             	add    $0x1,%eax
      66:	83 c2 01             	add    $0x1,%edx
    while(n > 0 && *p && *p == *q)
      69:	39 d8                	cmp    %ebx,%eax
      6b:	74 1d                	je     8a <strncmp+0x45>
      6d:	0f b6 08             	movzbl (%eax),%ecx
      70:	84 c9                	test   %cl,%cl
      72:	74 04                	je     78 <strncmp+0x33>
      74:	3a 0a                	cmp    (%edx),%cl
      76:	74 eb                	je     63 <strncmp+0x1e>
    if(n == 0)
      return 0;
    return (uchar)*p - (uchar)*q;
      78:	0f b6 00             	movzbl (%eax),%eax
      7b:	0f b6 12             	movzbl (%edx),%edx
      7e:	29 d0                	sub    %edx,%eax
}
      80:	5b                   	pop    %ebx
      81:	5d                   	pop    %ebp
      82:	c3                   	ret    
      return 0;
      83:	b8 00 00 00 00       	mov    $0x0,%eax
      88:	eb f6                	jmp    80 <strncmp+0x3b>
      8a:	b8 00 00 00 00       	mov    $0x0,%eax
      8f:	eb ef                	jmp    80 <strncmp+0x3b>

00000091 <setbuiltin>:
int
setbuiltin(char *p)
{
      91:	55                   	push   %ebp
      92:	89 e5                	mov    %esp,%ebp
      94:	53                   	push   %ebx
      95:	83 ec 10             	sub    $0x10,%esp
  int i;
  int rc;

  p += strlen("_set");
      98:	68 2f 13 00 00       	push   $0x132f
      9d:	e8 fb 0b 00 00       	call   c9d <strlen>
      a2:	03 45 08             	add    0x8(%ebp),%eax
      a5:	89 c3                	mov    %eax,%ebx
  while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
      a7:	83 c4 10             	add    $0x10,%esp
      aa:	eb 03                	jmp    af <setbuiltin+0x1e>
      ac:	83 c3 01             	add    $0x1,%ebx
      af:	83 ec 04             	sub    $0x4,%esp
      b2:	6a 01                	push   $0x1
      b4:	68 2d 13 00 00       	push   $0x132d
      b9:	53                   	push   %ebx
      ba:	e8 86 ff ff ff       	call   45 <strncmp>
      bf:	83 c4 10             	add    $0x10,%esp
      c2:	85 c0                	test   %eax,%eax
      c4:	74 e6                	je     ac <setbuiltin+0x1b>
  if (strncmp("uid", p, 3) == 0) {
      c6:	83 ec 04             	sub    $0x4,%esp
      c9:	6a 03                	push   $0x3
      cb:	53                   	push   %ebx
      cc:	68 34 13 00 00       	push   $0x1334
      d1:	e8 6f ff ff ff       	call   45 <strncmp>
      d6:	83 c4 10             	add    $0x10,%esp
      d9:	85 c0                	test   %eax,%eax
      db:	74 2f                	je     10c <setbuiltin+0x7b>
    i = atoi(p);
    rc = (setuid(i));
    if (rc == 0)
      return 0;
  } else
  if (strncmp("gid", p, 3) == 0) {
      dd:	83 ec 04             	sub    $0x4,%esp
      e0:	6a 03                	push   $0x3
      e2:	53                   	push   %ebx
      e3:	68 38 13 00 00       	push   $0x1338
      e8:	e8 58 ff ff ff       	call   45 <strncmp>
      ed:	83 c4 10             	add    $0x10,%esp
      f0:	85 c0                	test   %eax,%eax
      f2:	0f 85 9f 00 00 00    	jne    197 <setbuiltin+0x106>
    p += strlen("gid");
      f8:	83 ec 0c             	sub    $0xc,%esp
      fb:	68 38 13 00 00       	push   $0x1338
     100:	e8 98 0b 00 00       	call   c9d <strlen>
     105:	01 c3                	add    %eax,%ebx
    while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     107:	83 c4 10             	add    $0x10,%esp
     10a:	eb 51                	jmp    15d <setbuiltin+0xcc>
    p += strlen("uid");
     10c:	83 ec 0c             	sub    $0xc,%esp
     10f:	68 34 13 00 00       	push   $0x1334
     114:	e8 84 0b 00 00       	call   c9d <strlen>
     119:	01 c3                	add    %eax,%ebx
    while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     11b:	83 c4 10             	add    $0x10,%esp
     11e:	eb 03                	jmp    123 <setbuiltin+0x92>
     120:	83 c3 01             	add    $0x1,%ebx
     123:	83 ec 04             	sub    $0x4,%esp
     126:	6a 01                	push   $0x1
     128:	68 2d 13 00 00       	push   $0x132d
     12d:	53                   	push   %ebx
     12e:	e8 12 ff ff ff       	call   45 <strncmp>
     133:	83 c4 10             	add    $0x10,%esp
     136:	85 c0                	test   %eax,%eax
     138:	74 e6                	je     120 <setbuiltin+0x8f>
    i = atoi(p);
     13a:	83 ec 0c             	sub    $0xc,%esp
     13d:	53                   	push   %ebx
     13e:	e8 62 0c 00 00       	call   da5 <atoi>
    rc = (setuid(i));
     143:	89 04 24             	mov    %eax,(%esp)
     146:	e8 28 0e 00 00       	call   f73 <setuid>
    if (rc == 0)
     14b:	83 c4 10             	add    $0x10,%esp
     14e:	85 c0                	test   %eax,%eax
     150:	0f 95 c0             	setne  %al
     153:	0f b6 c0             	movzbl %al,%eax
     156:	f7 d8                	neg    %eax
     158:	eb 38                	jmp    192 <setbuiltin+0x101>
    while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     15a:	83 c3 01             	add    $0x1,%ebx
     15d:	83 ec 04             	sub    $0x4,%esp
     160:	6a 01                	push   $0x1
     162:	68 2d 13 00 00       	push   $0x132d
     167:	53                   	push   %ebx
     168:	e8 d8 fe ff ff       	call   45 <strncmp>
     16d:	83 c4 10             	add    $0x10,%esp
     170:	85 c0                	test   %eax,%eax
     172:	74 e6                	je     15a <setbuiltin+0xc9>
    i = atoi(p);
     174:	83 ec 0c             	sub    $0xc,%esp
     177:	53                   	push   %ebx
     178:	e8 28 0c 00 00       	call   da5 <atoi>
    rc = (setgid(i));
     17d:	89 04 24             	mov    %eax,(%esp)
     180:	e8 f6 0d 00 00       	call   f7b <setgid>
    if (rc == 0)
     185:	83 c4 10             	add    $0x10,%esp
     188:	85 c0                	test   %eax,%eax
     18a:	0f 95 c0             	setne  %al
     18d:	0f b6 c0             	movzbl %al,%eax
     190:	f7 d8                	neg    %eax
      return 0;
  }
  //printf(2, "Invalid _set parameter\n");
  return -1;
}
     192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     195:	c9                   	leave  
     196:	c3                   	ret    
  return -1;
     197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     19c:	eb f4                	jmp    192 <setbuiltin+0x101>

0000019e <getbuiltin>:

int
getbuiltin(char *p)
{
     19e:	55                   	push   %ebp
     19f:	89 e5                	mov    %esp,%ebp
     1a1:	56                   	push   %esi
     1a2:	53                   	push   %ebx
  p += strlen("_get");
     1a3:	83 ec 0c             	sub    $0xc,%esp
     1a6:	68 3c 13 00 00       	push   $0x133c
     1ab:	e8 ed 0a 00 00       	call   c9d <strlen>
     1b0:	03 45 08             	add    0x8(%ebp),%eax
     1b3:	89 c3                	mov    %eax,%ebx
  while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     1b5:	83 c4 10             	add    $0x10,%esp
     1b8:	eb 03                	jmp    1bd <getbuiltin+0x1f>
     1ba:	83 c3 01             	add    $0x1,%ebx
     1bd:	83 ec 04             	sub    $0x4,%esp
     1c0:	6a 01                	push   $0x1
     1c2:	68 2d 13 00 00       	push   $0x132d
     1c7:	53                   	push   %ebx
     1c8:	e8 78 fe ff ff       	call   45 <strncmp>
     1cd:	83 c4 10             	add    $0x10,%esp
     1d0:	85 c0                	test   %eax,%eax
     1d2:	74 e6                	je     1ba <getbuiltin+0x1c>
  if (strncmp("uid", p, 3) == 0) {
     1d4:	83 ec 04             	sub    $0x4,%esp
     1d7:	6a 03                	push   $0x3
     1d9:	53                   	push   %ebx
     1da:	68 34 13 00 00       	push   $0x1334
     1df:	e8 61 fe ff ff       	call   45 <strncmp>
     1e4:	83 c4 10             	add    $0x10,%esp
     1e7:	89 c6                	mov    %eax,%esi
     1e9:	85 c0                	test   %eax,%eax
     1eb:	74 3a                	je     227 <getbuiltin+0x89>
    printf(2, "%d\n", getuid());
    return 0;
  }
  if (strncmp("gid", p, 3) == 0) {
     1ed:	83 ec 04             	sub    $0x4,%esp
     1f0:	6a 03                	push   $0x3
     1f2:	53                   	push   %ebx
     1f3:	68 38 13 00 00       	push   $0x1338
     1f8:	e8 48 fe ff ff       	call   45 <strncmp>
     1fd:	83 c4 10             	add    $0x10,%esp
     200:	89 c6                	mov    %eax,%esi
     202:	85 c0                	test   %eax,%eax
     204:	75 3b                	jne    241 <getbuiltin+0xa3>
    printf(2, "%d\n", getgid());
     206:	e8 58 0d 00 00       	call   f63 <getgid>
     20b:	83 ec 04             	sub    $0x4,%esp
     20e:	50                   	push   %eax
     20f:	68 41 13 00 00       	push   $0x1341
     214:	6a 02                	push   $0x2
     216:	e8 fa 0d 00 00       	call   1015 <printf>
    return 0;
     21b:	83 c4 10             	add    $0x10,%esp
  }
  //printf(2, "Invalid _get parameter\n");
  return -1;
}
     21e:	89 f0                	mov    %esi,%eax
     220:	8d 65 f8             	lea    -0x8(%ebp),%esp
     223:	5b                   	pop    %ebx
     224:	5e                   	pop    %esi
     225:	5d                   	pop    %ebp
     226:	c3                   	ret    
    printf(2, "%d\n", getuid());
     227:	e8 2f 0d 00 00       	call   f5b <getuid>
     22c:	83 ec 04             	sub    $0x4,%esp
     22f:	50                   	push   %eax
     230:	68 41 13 00 00       	push   $0x1341
     235:	6a 02                	push   $0x2
     237:	e8 d9 0d 00 00       	call   1015 <printf>
    return 0;
     23c:	83 c4 10             	add    $0x10,%esp
     23f:	eb dd                	jmp    21e <getbuiltin+0x80>
  return -1;
     241:	be ff ff ff ff       	mov    $0xffffffff,%esi
     246:	eb d6                	jmp    21e <getbuiltin+0x80>

00000248 <dobuiltin>:
  {"_get", getbuiltin}
};
int FDTcount = sizeof(fdt) / sizeof(fdt[0]); // # entris in FDT

void
dobuiltin(char *cmd) {
     248:	55                   	push   %ebp
     249:	89 e5                	mov    %esp,%ebp
     24b:	56                   	push   %esi
     24c:	53                   	push   %ebx
     24d:	8b 75 08             	mov    0x8(%ebp),%esi
  int i;

  for (i=0; i<FDTcount; i++)
     250:	83 3d 58 1a 00 00 00 	cmpl   $0x0,0x1a58
     257:	7e 45                	jle    29e <dobuiltin+0x56>
     259:	bb 00 00 00 00       	mov    $0x0,%ebx
    if (strncmp(cmd, fdt[i].cmd, strlen(fdt[i].cmd)) == 0)
     25e:	83 ec 0c             	sub    $0xc,%esp
     261:	ff 34 dd 5c 1a 00 00 	pushl  0x1a5c(,%ebx,8)
     268:	e8 30 0a 00 00       	call   c9d <strlen>
     26d:	83 c4 0c             	add    $0xc,%esp
     270:	50                   	push   %eax
     271:	ff 34 dd 5c 1a 00 00 	pushl  0x1a5c(,%ebx,8)
     278:	56                   	push   %esi
     279:	e8 c7 fd ff ff       	call   45 <strncmp>
     27e:	83 c4 10             	add    $0x10,%esp
     281:	85 c0                	test   %eax,%eax
     283:	75 0e                	jne    293 <dobuiltin+0x4b>
     (*fdt[i].name)(cmd);
     285:	83 ec 0c             	sub    $0xc,%esp
     288:	56                   	push   %esi
     289:	ff 14 dd 60 1a 00 00 	call   *0x1a60(,%ebx,8)
     290:	83 c4 10             	add    $0x10,%esp
  for (i=0; i<FDTcount; i++)
     293:	83 c3 01             	add    $0x1,%ebx
     296:	39 1d 58 1a 00 00    	cmp    %ebx,0x1a58
     29c:	7f c0                	jg     25e <dobuiltin+0x16>
}
     29e:	8d 65 f8             	lea    -0x8(%ebp),%esp
     2a1:	5b                   	pop    %ebx
     2a2:	5e                   	pop    %esi
     2a3:	5d                   	pop    %ebp
     2a4:	c3                   	ret    

000002a5 <panic>:
  exit();
}

void
panic(char *s)
{
     2a5:	55                   	push   %ebp
     2a6:	89 e5                	mov    %esp,%ebp
     2a8:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     2ab:	ff 75 08             	pushl  0x8(%ebp)
     2ae:	68 df 13 00 00       	push   $0x13df
     2b3:	6a 02                	push   $0x2
     2b5:	e8 5b 0d 00 00       	call   1015 <printf>
  exit();
     2ba:	e8 ec 0b 00 00       	call   eab <exit>

000002bf <fork1>:
}

int
fork1(void)
{
     2bf:	55                   	push   %ebp
     2c0:	89 e5                	mov    %esp,%ebp
     2c2:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
     2c5:	e8 d9 0b 00 00       	call   ea3 <fork>
  if(pid == -1)
     2ca:	83 f8 ff             	cmp    $0xffffffff,%eax
     2cd:	74 02                	je     2d1 <fork1+0x12>
    panic("fork");
  return pid;
}
     2cf:	c9                   	leave  
     2d0:	c3                   	ret    
    panic("fork");
     2d1:	83 ec 0c             	sub    $0xc,%esp
     2d4:	68 45 13 00 00       	push   $0x1345
     2d9:	e8 c7 ff ff ff       	call   2a5 <panic>

000002de <runcmd>:
{
     2de:	55                   	push   %ebp
     2df:	89 e5                	mov    %esp,%ebp
     2e1:	53                   	push   %ebx
     2e2:	83 ec 14             	sub    $0x14,%esp
     2e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     2e8:	85 db                	test   %ebx,%ebx
     2ea:	74 0e                	je     2fa <runcmd+0x1c>
  switch(cmd->type){
     2ec:	83 3b 05             	cmpl   $0x5,(%ebx)
     2ef:	77 0e                	ja     2ff <runcmd+0x21>
     2f1:	8b 03                	mov    (%ebx),%eax
     2f3:	ff 24 85 fc 13 00 00 	jmp    *0x13fc(,%eax,4)
    exit();
     2fa:	e8 ac 0b 00 00       	call   eab <exit>
    panic("runcmd");
     2ff:	83 ec 0c             	sub    $0xc,%esp
     302:	68 4a 13 00 00       	push   $0x134a
     307:	e8 99 ff ff ff       	call   2a5 <panic>
    if(ecmd->argv[0] == 0)
     30c:	8b 43 04             	mov    0x4(%ebx),%eax
     30f:	85 c0                	test   %eax,%eax
     311:	74 27                	je     33a <runcmd+0x5c>
    exec(ecmd->argv[0], ecmd->argv);
     313:	83 ec 08             	sub    $0x8,%esp
     316:	8d 53 04             	lea    0x4(%ebx),%edx
     319:	52                   	push   %edx
     31a:	50                   	push   %eax
     31b:	e8 c3 0b 00 00       	call   ee3 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     320:	83 c4 0c             	add    $0xc,%esp
     323:	ff 73 04             	pushl  0x4(%ebx)
     326:	68 51 13 00 00       	push   $0x1351
     32b:	6a 02                	push   $0x2
     32d:	e8 e3 0c 00 00       	call   1015 <printf>
    break;
     332:	83 c4 10             	add    $0x10,%esp
     335:	e9 3a 01 00 00       	jmp    474 <runcmd+0x196>
      exit();
     33a:	e8 6c 0b 00 00       	call   eab <exit>
    close(rcmd->fd);
     33f:	83 ec 0c             	sub    $0xc,%esp
     342:	ff 73 14             	pushl  0x14(%ebx)
     345:	e8 89 0b 00 00       	call   ed3 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     34a:	83 c4 08             	add    $0x8,%esp
     34d:	ff 73 10             	pushl  0x10(%ebx)
     350:	ff 73 08             	pushl  0x8(%ebx)
     353:	e8 93 0b 00 00       	call   eeb <open>
     358:	83 c4 10             	add    $0x10,%esp
     35b:	85 c0                	test   %eax,%eax
     35d:	79 17                	jns    376 <runcmd+0x98>
      printf(2, "open %s failed\n", rcmd->file);
     35f:	83 ec 04             	sub    $0x4,%esp
     362:	ff 73 08             	pushl  0x8(%ebx)
     365:	68 61 13 00 00       	push   $0x1361
     36a:	6a 02                	push   $0x2
     36c:	e8 a4 0c 00 00       	call   1015 <printf>
      exit();
     371:	e8 35 0b 00 00       	call   eab <exit>
    runcmd(rcmd->cmd);
     376:	83 ec 0c             	sub    $0xc,%esp
     379:	ff 73 04             	pushl  0x4(%ebx)
     37c:	e8 5d ff ff ff       	call   2de <runcmd>
    if(fork1() == 0)
     381:	e8 39 ff ff ff       	call   2bf <fork1>
     386:	85 c0                	test   %eax,%eax
     388:	74 10                	je     39a <runcmd+0xbc>
    wait();
     38a:	e8 24 0b 00 00       	call   eb3 <wait>
    runcmd(lcmd->right);
     38f:	83 ec 0c             	sub    $0xc,%esp
     392:	ff 73 08             	pushl  0x8(%ebx)
     395:	e8 44 ff ff ff       	call   2de <runcmd>
      runcmd(lcmd->left);
     39a:	83 ec 0c             	sub    $0xc,%esp
     39d:	ff 73 04             	pushl  0x4(%ebx)
     3a0:	e8 39 ff ff ff       	call   2de <runcmd>
    if(pipe(p) < 0)
     3a5:	83 ec 0c             	sub    $0xc,%esp
     3a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
     3ab:	50                   	push   %eax
     3ac:	e8 0a 0b 00 00       	call   ebb <pipe>
     3b1:	83 c4 10             	add    $0x10,%esp
     3b4:	85 c0                	test   %eax,%eax
     3b6:	78 3a                	js     3f2 <runcmd+0x114>
    if(fork1() == 0){
     3b8:	e8 02 ff ff ff       	call   2bf <fork1>
     3bd:	85 c0                	test   %eax,%eax
     3bf:	74 3e                	je     3ff <runcmd+0x121>
    if(fork1() == 0){
     3c1:	e8 f9 fe ff ff       	call   2bf <fork1>
     3c6:	85 c0                	test   %eax,%eax
     3c8:	74 6b                	je     435 <runcmd+0x157>
    close(p[0]);
     3ca:	83 ec 0c             	sub    $0xc,%esp
     3cd:	ff 75 f0             	pushl  -0x10(%ebp)
     3d0:	e8 fe 0a 00 00       	call   ed3 <close>
    close(p[1]);
     3d5:	83 c4 04             	add    $0x4,%esp
     3d8:	ff 75 f4             	pushl  -0xc(%ebp)
     3db:	e8 f3 0a 00 00       	call   ed3 <close>
    wait();
     3e0:	e8 ce 0a 00 00       	call   eb3 <wait>
    wait();
     3e5:	e8 c9 0a 00 00       	call   eb3 <wait>
    break;
     3ea:	83 c4 10             	add    $0x10,%esp
     3ed:	e9 82 00 00 00       	jmp    474 <runcmd+0x196>
      panic("pipe");
     3f2:	83 ec 0c             	sub    $0xc,%esp
     3f5:	68 71 13 00 00       	push   $0x1371
     3fa:	e8 a6 fe ff ff       	call   2a5 <panic>
      close(1);
     3ff:	83 ec 0c             	sub    $0xc,%esp
     402:	6a 01                	push   $0x1
     404:	e8 ca 0a 00 00       	call   ed3 <close>
      dup(p[1]);
     409:	83 c4 04             	add    $0x4,%esp
     40c:	ff 75 f4             	pushl  -0xc(%ebp)
     40f:	e8 0f 0b 00 00       	call   f23 <dup>
      close(p[0]);
     414:	83 c4 04             	add    $0x4,%esp
     417:	ff 75 f0             	pushl  -0x10(%ebp)
     41a:	e8 b4 0a 00 00       	call   ed3 <close>
      close(p[1]);
     41f:	83 c4 04             	add    $0x4,%esp
     422:	ff 75 f4             	pushl  -0xc(%ebp)
     425:	e8 a9 0a 00 00       	call   ed3 <close>
      runcmd(pcmd->left);
     42a:	83 c4 04             	add    $0x4,%esp
     42d:	ff 73 04             	pushl  0x4(%ebx)
     430:	e8 a9 fe ff ff       	call   2de <runcmd>
      close(0);
     435:	83 ec 0c             	sub    $0xc,%esp
     438:	6a 00                	push   $0x0
     43a:	e8 94 0a 00 00       	call   ed3 <close>
      dup(p[0]);
     43f:	83 c4 04             	add    $0x4,%esp
     442:	ff 75 f0             	pushl  -0x10(%ebp)
     445:	e8 d9 0a 00 00       	call   f23 <dup>
      close(p[0]);
     44a:	83 c4 04             	add    $0x4,%esp
     44d:	ff 75 f0             	pushl  -0x10(%ebp)
     450:	e8 7e 0a 00 00       	call   ed3 <close>
      close(p[1]);
     455:	83 c4 04             	add    $0x4,%esp
     458:	ff 75 f4             	pushl  -0xc(%ebp)
     45b:	e8 73 0a 00 00       	call   ed3 <close>
      runcmd(pcmd->right);
     460:	83 c4 04             	add    $0x4,%esp
     463:	ff 73 08             	pushl  0x8(%ebx)
     466:	e8 73 fe ff ff       	call   2de <runcmd>
    if(fork1() == 0)
     46b:	e8 4f fe ff ff       	call   2bf <fork1>
     470:	85 c0                	test   %eax,%eax
     472:	74 05                	je     479 <runcmd+0x19b>
  exit();
     474:	e8 32 0a 00 00       	call   eab <exit>
      runcmd(bcmd->cmd);
     479:	83 ec 0c             	sub    $0xc,%esp
     47c:	ff 73 04             	pushl  0x4(%ebx)
     47f:	e8 5a fe ff ff       	call   2de <runcmd>

00000484 <execcmd>:

// Constructors

struct cmd*
execcmd(void)
{
     484:	55                   	push   %ebp
     485:	89 e5                	mov    %esp,%ebp
     487:	53                   	push   %ebx
     488:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     48b:	6a 54                	push   $0x54
     48d:	e8 c1 0d 00 00       	call   1253 <malloc>
     492:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     494:	83 c4 0c             	add    $0xc,%esp
     497:	6a 54                	push   $0x54
     499:	6a 00                	push   $0x0
     49b:	50                   	push   %eax
     49c:	e8 20 08 00 00       	call   cc1 <memset>
  cmd->type = EXEC;
     4a1:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     4a7:	89 d8                	mov    %ebx,%eax
     4a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     4ac:	c9                   	leave  
     4ad:	c3                   	ret    

000004ae <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     4ae:	55                   	push   %ebp
     4af:	89 e5                	mov    %esp,%ebp
     4b1:	53                   	push   %ebx
     4b2:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4b5:	6a 18                	push   $0x18
     4b7:	e8 97 0d 00 00       	call   1253 <malloc>
     4bc:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     4be:	83 c4 0c             	add    $0xc,%esp
     4c1:	6a 18                	push   $0x18
     4c3:	6a 00                	push   $0x0
     4c5:	50                   	push   %eax
     4c6:	e8 f6 07 00 00       	call   cc1 <memset>
  cmd->type = REDIR;
     4cb:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     4d1:	8b 45 08             	mov    0x8(%ebp),%eax
     4d4:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     4d7:	8b 45 0c             	mov    0xc(%ebp),%eax
     4da:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     4dd:	8b 45 10             	mov    0x10(%ebp),%eax
     4e0:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     4e3:	8b 45 14             	mov    0x14(%ebp),%eax
     4e6:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     4e9:	8b 45 18             	mov    0x18(%ebp),%eax
     4ec:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     4ef:	89 d8                	mov    %ebx,%eax
     4f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     4f4:	c9                   	leave  
     4f5:	c3                   	ret    

000004f6 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     4f6:	55                   	push   %ebp
     4f7:	89 e5                	mov    %esp,%ebp
     4f9:	53                   	push   %ebx
     4fa:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4fd:	6a 0c                	push   $0xc
     4ff:	e8 4f 0d 00 00       	call   1253 <malloc>
     504:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     506:	83 c4 0c             	add    $0xc,%esp
     509:	6a 0c                	push   $0xc
     50b:	6a 00                	push   $0x0
     50d:	50                   	push   %eax
     50e:	e8 ae 07 00 00       	call   cc1 <memset>
  cmd->type = PIPE;
     513:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     519:	8b 45 08             	mov    0x8(%ebp),%eax
     51c:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     51f:	8b 45 0c             	mov    0xc(%ebp),%eax
     522:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     525:	89 d8                	mov    %ebx,%eax
     527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     52a:	c9                   	leave  
     52b:	c3                   	ret    

0000052c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     52c:	55                   	push   %ebp
     52d:	89 e5                	mov    %esp,%ebp
     52f:	53                   	push   %ebx
     530:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     533:	6a 0c                	push   $0xc
     535:	e8 19 0d 00 00       	call   1253 <malloc>
     53a:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     53c:	83 c4 0c             	add    $0xc,%esp
     53f:	6a 0c                	push   $0xc
     541:	6a 00                	push   $0x0
     543:	50                   	push   %eax
     544:	e8 78 07 00 00       	call   cc1 <memset>
  cmd->type = LIST;
     549:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     54f:	8b 45 08             	mov    0x8(%ebp),%eax
     552:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     555:	8b 45 0c             	mov    0xc(%ebp),%eax
     558:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     55b:	89 d8                	mov    %ebx,%eax
     55d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     560:	c9                   	leave  
     561:	c3                   	ret    

00000562 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     562:	55                   	push   %ebp
     563:	89 e5                	mov    %esp,%ebp
     565:	53                   	push   %ebx
     566:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     569:	6a 08                	push   $0x8
     56b:	e8 e3 0c 00 00       	call   1253 <malloc>
     570:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     572:	83 c4 0c             	add    $0xc,%esp
     575:	6a 08                	push   $0x8
     577:	6a 00                	push   $0x0
     579:	50                   	push   %eax
     57a:	e8 42 07 00 00       	call   cc1 <memset>
  cmd->type = BACK;
     57f:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     585:	8b 45 08             	mov    0x8(%ebp),%eax
     588:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     58b:	89 d8                	mov    %ebx,%eax
     58d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     590:	c9                   	leave  
     591:	c3                   	ret    

00000592 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     592:	55                   	push   %ebp
     593:	89 e5                	mov    %esp,%ebp
     595:	57                   	push   %edi
     596:	56                   	push   %esi
     597:	53                   	push   %ebx
     598:	83 ec 0c             	sub    $0xc,%esp
     59b:	8b 75 0c             	mov    0xc(%ebp),%esi
     59e:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
     5a1:	8b 45 08             	mov    0x8(%ebp),%eax
     5a4:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     5a6:	39 f3                	cmp    %esi,%ebx
     5a8:	73 1f                	jae    5c9 <gettoken+0x37>
     5aa:	83 ec 08             	sub    $0x8,%esp
     5ad:	0f be 03             	movsbl (%ebx),%eax
     5b0:	50                   	push   %eax
     5b1:	68 50 1a 00 00       	push   $0x1a50
     5b6:	e8 1d 07 00 00       	call   cd8 <strchr>
     5bb:	83 c4 10             	add    $0x10,%esp
     5be:	85 c0                	test   %eax,%eax
     5c0:	74 07                	je     5c9 <gettoken+0x37>
    s++;
     5c2:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     5c5:	39 de                	cmp    %ebx,%esi
     5c7:	75 e1                	jne    5aa <gettoken+0x18>
  if(q)
     5c9:	85 ff                	test   %edi,%edi
     5cb:	74 02                	je     5cf <gettoken+0x3d>
    *q = s;
     5cd:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     5cf:	0f b6 03             	movzbl (%ebx),%eax
     5d2:	0f be f8             	movsbl %al,%edi
  switch(*s){
     5d5:	3c 29                	cmp    $0x29,%al
     5d7:	0f 8f 99 00 00 00    	jg     676 <gettoken+0xe4>
     5dd:	3c 28                	cmp    $0x28,%al
     5df:	0f 8d a0 00 00 00    	jge    685 <gettoken+0xf3>
     5e5:	84 c0                	test   %al,%al
     5e7:	75 3d                	jne    626 <gettoken+0x94>
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     5e9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     5ed:	74 05                	je     5f4 <gettoken+0x62>
    *eq = s;
     5ef:	8b 45 14             	mov    0x14(%ebp),%eax
     5f2:	89 18                	mov    %ebx,(%eax)

  while(s < es && strchr(whitespace, *s))
     5f4:	39 f3                	cmp    %esi,%ebx
     5f6:	73 1f                	jae    617 <gettoken+0x85>
     5f8:	83 ec 08             	sub    $0x8,%esp
     5fb:	0f be 03             	movsbl (%ebx),%eax
     5fe:	50                   	push   %eax
     5ff:	68 50 1a 00 00       	push   $0x1a50
     604:	e8 cf 06 00 00       	call   cd8 <strchr>
     609:	83 c4 10             	add    $0x10,%esp
     60c:	85 c0                	test   %eax,%eax
     60e:	74 07                	je     617 <gettoken+0x85>
    s++;
     610:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     613:	39 de                	cmp    %ebx,%esi
     615:	75 e1                	jne    5f8 <gettoken+0x66>
  *ps = s;
     617:	8b 45 08             	mov    0x8(%ebp),%eax
     61a:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     61c:	89 f8                	mov    %edi,%eax
     61e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     621:	5b                   	pop    %ebx
     622:	5e                   	pop    %esi
     623:	5f                   	pop    %edi
     624:	5d                   	pop    %ebp
     625:	c3                   	ret    
  switch(*s){
     626:	3c 26                	cmp    $0x26,%al
     628:	74 5b                	je     685 <gettoken+0xf3>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     62a:	39 de                	cmp    %ebx,%esi
     62c:	76 37                	jbe    665 <gettoken+0xd3>
     62e:	83 ec 08             	sub    $0x8,%esp
     631:	0f be 03             	movsbl (%ebx),%eax
     634:	50                   	push   %eax
     635:	68 50 1a 00 00       	push   $0x1a50
     63a:	e8 99 06 00 00       	call   cd8 <strchr>
     63f:	83 c4 10             	add    $0x10,%esp
     642:	85 c0                	test   %eax,%eax
     644:	75 79                	jne    6bf <gettoken+0x12d>
     646:	83 ec 08             	sub    $0x8,%esp
     649:	0f be 03             	movsbl (%ebx),%eax
     64c:	50                   	push   %eax
     64d:	68 48 1a 00 00       	push   $0x1a48
     652:	e8 81 06 00 00       	call   cd8 <strchr>
     657:	83 c4 10             	add    $0x10,%esp
     65a:	85 c0                	test   %eax,%eax
     65c:	75 57                	jne    6b5 <gettoken+0x123>
      s++;
     65e:	83 c3 01             	add    $0x1,%ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     661:	39 de                	cmp    %ebx,%esi
     663:	75 c9                	jne    62e <gettoken+0x9c>
  if(eq)
     665:	bf 61 00 00 00       	mov    $0x61,%edi
     66a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     66e:	0f 85 7b ff ff ff    	jne    5ef <gettoken+0x5d>
     674:	eb a1                	jmp    617 <gettoken+0x85>
  switch(*s){
     676:	3c 3e                	cmp    $0x3e,%al
     678:	74 19                	je     693 <gettoken+0x101>
     67a:	3c 3e                	cmp    $0x3e,%al
     67c:	7f 0f                	jg     68d <gettoken+0xfb>
     67e:	83 e8 3b             	sub    $0x3b,%eax
     681:	3c 01                	cmp    $0x1,%al
     683:	77 a5                	ja     62a <gettoken+0x98>
    s++;
     685:	83 c3 01             	add    $0x1,%ebx
    break;
     688:	e9 5c ff ff ff       	jmp    5e9 <gettoken+0x57>
  switch(*s){
     68d:	3c 7c                	cmp    $0x7c,%al
     68f:	74 f4                	je     685 <gettoken+0xf3>
     691:	eb 97                	jmp    62a <gettoken+0x98>
    s++;
     693:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
     696:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
     69a:	74 0c                	je     6a8 <gettoken+0x116>
    s++;
     69c:	89 c3                	mov    %eax,%ebx
  ret = *s;
     69e:	bf 3e 00 00 00       	mov    $0x3e,%edi
     6a3:	e9 41 ff ff ff       	jmp    5e9 <gettoken+0x57>
      s++;
     6a8:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
     6ab:	bf 2b 00 00 00       	mov    $0x2b,%edi
     6b0:	e9 34 ff ff ff       	jmp    5e9 <gettoken+0x57>
    ret = 'a';
     6b5:	bf 61 00 00 00       	mov    $0x61,%edi
     6ba:	e9 2a ff ff ff       	jmp    5e9 <gettoken+0x57>
     6bf:	bf 61 00 00 00       	mov    $0x61,%edi
     6c4:	e9 20 ff ff ff       	jmp    5e9 <gettoken+0x57>

000006c9 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     6c9:	55                   	push   %ebp
     6ca:	89 e5                	mov    %esp,%ebp
     6cc:	57                   	push   %edi
     6cd:	56                   	push   %esi
     6ce:	53                   	push   %ebx
     6cf:	83 ec 0c             	sub    $0xc,%esp
     6d2:	8b 7d 08             	mov    0x8(%ebp),%edi
     6d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     6d8:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     6da:	39 f3                	cmp    %esi,%ebx
     6dc:	73 1f                	jae    6fd <peek+0x34>
     6de:	83 ec 08             	sub    $0x8,%esp
     6e1:	0f be 03             	movsbl (%ebx),%eax
     6e4:	50                   	push   %eax
     6e5:	68 50 1a 00 00       	push   $0x1a50
     6ea:	e8 e9 05 00 00       	call   cd8 <strchr>
     6ef:	83 c4 10             	add    $0x10,%esp
     6f2:	85 c0                	test   %eax,%eax
     6f4:	74 07                	je     6fd <peek+0x34>
    s++;
     6f6:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     6f9:	39 de                	cmp    %ebx,%esi
     6fb:	75 e1                	jne    6de <peek+0x15>
  *ps = s;
     6fd:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     6ff:	0f b6 13             	movzbl (%ebx),%edx
     702:	b8 00 00 00 00       	mov    $0x0,%eax
     707:	84 d2                	test   %dl,%dl
     709:	75 08                	jne    713 <peek+0x4a>
}
     70b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     70e:	5b                   	pop    %ebx
     70f:	5e                   	pop    %esi
     710:	5f                   	pop    %edi
     711:	5d                   	pop    %ebp
     712:	c3                   	ret    
  return *s && strchr(toks, *s);
     713:	83 ec 08             	sub    $0x8,%esp
     716:	0f be d2             	movsbl %dl,%edx
     719:	52                   	push   %edx
     71a:	ff 75 10             	pushl  0x10(%ebp)
     71d:	e8 b6 05 00 00       	call   cd8 <strchr>
     722:	83 c4 10             	add    $0x10,%esp
     725:	85 c0                	test   %eax,%eax
     727:	0f 95 c0             	setne  %al
     72a:	0f b6 c0             	movzbl %al,%eax
     72d:	eb dc                	jmp    70b <peek+0x42>

0000072f <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     72f:	55                   	push   %ebp
     730:	89 e5                	mov    %esp,%ebp
     732:	57                   	push   %edi
     733:	56                   	push   %esi
     734:	53                   	push   %ebx
     735:	83 ec 1c             	sub    $0x1c,%esp
     738:	8b 75 0c             	mov    0xc(%ebp),%esi
     73b:	8b 7d 10             	mov    0x10(%ebp),%edi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     73e:	eb 28                	jmp    768 <parseredirs+0x39>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
     740:	83 ec 0c             	sub    $0xc,%esp
     743:	68 76 13 00 00       	push   $0x1376
     748:	e8 58 fb ff ff       	call   2a5 <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     74d:	83 ec 0c             	sub    $0xc,%esp
     750:	6a 00                	push   $0x0
     752:	6a 00                	push   $0x0
     754:	ff 75 e0             	pushl  -0x20(%ebp)
     757:	ff 75 e4             	pushl  -0x1c(%ebp)
     75a:	ff 75 08             	pushl  0x8(%ebp)
     75d:	e8 4c fd ff ff       	call   4ae <redircmd>
     762:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     765:	83 c4 20             	add    $0x20,%esp
  while(peek(ps, es, "<>")){
     768:	83 ec 04             	sub    $0x4,%esp
     76b:	68 93 13 00 00       	push   $0x1393
     770:	57                   	push   %edi
     771:	56                   	push   %esi
     772:	e8 52 ff ff ff       	call   6c9 <peek>
     777:	83 c4 10             	add    $0x10,%esp
     77a:	85 c0                	test   %eax,%eax
     77c:	74 76                	je     7f4 <parseredirs+0xc5>
    tok = gettoken(ps, es, 0, 0);
     77e:	6a 00                	push   $0x0
     780:	6a 00                	push   $0x0
     782:	57                   	push   %edi
     783:	56                   	push   %esi
     784:	e8 09 fe ff ff       	call   592 <gettoken>
     789:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     78b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     78e:	50                   	push   %eax
     78f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     792:	50                   	push   %eax
     793:	57                   	push   %edi
     794:	56                   	push   %esi
     795:	e8 f8 fd ff ff       	call   592 <gettoken>
     79a:	83 c4 20             	add    $0x20,%esp
     79d:	83 f8 61             	cmp    $0x61,%eax
     7a0:	75 9e                	jne    740 <parseredirs+0x11>
    switch(tok){
     7a2:	83 fb 3c             	cmp    $0x3c,%ebx
     7a5:	74 a6                	je     74d <parseredirs+0x1e>
     7a7:	83 fb 3e             	cmp    $0x3e,%ebx
     7aa:	74 25                	je     7d1 <parseredirs+0xa2>
     7ac:	83 fb 2b             	cmp    $0x2b,%ebx
     7af:	75 b7                	jne    768 <parseredirs+0x39>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     7b1:	83 ec 0c             	sub    $0xc,%esp
     7b4:	6a 01                	push   $0x1
     7b6:	68 01 02 00 00       	push   $0x201
     7bb:	ff 75 e0             	pushl  -0x20(%ebp)
     7be:	ff 75 e4             	pushl  -0x1c(%ebp)
     7c1:	ff 75 08             	pushl  0x8(%ebp)
     7c4:	e8 e5 fc ff ff       	call   4ae <redircmd>
     7c9:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     7cc:	83 c4 20             	add    $0x20,%esp
     7cf:	eb 97                	jmp    768 <parseredirs+0x39>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     7d1:	83 ec 0c             	sub    $0xc,%esp
     7d4:	6a 01                	push   $0x1
     7d6:	68 01 02 00 00       	push   $0x201
     7db:	ff 75 e0             	pushl  -0x20(%ebp)
     7de:	ff 75 e4             	pushl  -0x1c(%ebp)
     7e1:	ff 75 08             	pushl  0x8(%ebp)
     7e4:	e8 c5 fc ff ff       	call   4ae <redircmd>
     7e9:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     7ec:	83 c4 20             	add    $0x20,%esp
     7ef:	e9 74 ff ff ff       	jmp    768 <parseredirs+0x39>
    }
  }
  return cmd;
}
     7f4:	8b 45 08             	mov    0x8(%ebp),%eax
     7f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7fa:	5b                   	pop    %ebx
     7fb:	5e                   	pop    %esi
     7fc:	5f                   	pop    %edi
     7fd:	5d                   	pop    %ebp
     7fe:	c3                   	ret    

000007ff <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     7ff:	55                   	push   %ebp
     800:	89 e5                	mov    %esp,%ebp
     802:	57                   	push   %edi
     803:	56                   	push   %esi
     804:	53                   	push   %ebx
     805:	83 ec 30             	sub    $0x30,%esp
     808:	8b 75 08             	mov    0x8(%ebp),%esi
     80b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     80e:	68 96 13 00 00       	push   $0x1396
     813:	57                   	push   %edi
     814:	56                   	push   %esi
     815:	e8 af fe ff ff       	call   6c9 <peek>
     81a:	83 c4 10             	add    $0x10,%esp
     81d:	85 c0                	test   %eax,%eax
     81f:	75 7a                	jne    89b <parseexec+0x9c>
     821:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     823:	e8 5c fc ff ff       	call   484 <execcmd>
     828:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     82b:	83 ec 04             	sub    $0x4,%esp
     82e:	57                   	push   %edi
     82f:	56                   	push   %esi
     830:	50                   	push   %eax
     831:	e8 f9 fe ff ff       	call   72f <parseredirs>
     836:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     839:	83 c4 10             	add    $0x10,%esp
     83c:	83 ec 04             	sub    $0x4,%esp
     83f:	68 ad 13 00 00       	push   $0x13ad
     844:	57                   	push   %edi
     845:	56                   	push   %esi
     846:	e8 7e fe ff ff       	call   6c9 <peek>
     84b:	83 c4 10             	add    $0x10,%esp
     84e:	85 c0                	test   %eax,%eax
     850:	75 7e                	jne    8d0 <parseexec+0xd1>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     852:	8d 45 e0             	lea    -0x20(%ebp),%eax
     855:	50                   	push   %eax
     856:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     859:	50                   	push   %eax
     85a:	57                   	push   %edi
     85b:	56                   	push   %esi
     85c:	e8 31 fd ff ff       	call   592 <gettoken>
     861:	83 c4 10             	add    $0x10,%esp
     864:	85 c0                	test   %eax,%eax
     866:	74 68                	je     8d0 <parseexec+0xd1>
      break;
    if(tok != 'a')
     868:	83 f8 61             	cmp    $0x61,%eax
     86b:	75 49                	jne    8b6 <parseexec+0xb7>
      panic("syntax");
    cmd->argv[argc] = q;
     86d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     870:	8b 55 d0             	mov    -0x30(%ebp),%edx
     873:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     877:	8b 45 e0             	mov    -0x20(%ebp),%eax
     87a:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     87e:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     881:	83 fb 0a             	cmp    $0xa,%ebx
     884:	74 3d                	je     8c3 <parseexec+0xc4>
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     886:	83 ec 04             	sub    $0x4,%esp
     889:	57                   	push   %edi
     88a:	56                   	push   %esi
     88b:	ff 75 d4             	pushl  -0x2c(%ebp)
     88e:	e8 9c fe ff ff       	call   72f <parseredirs>
     893:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     896:	83 c4 10             	add    $0x10,%esp
     899:	eb a1                	jmp    83c <parseexec+0x3d>
    return parseblock(ps, es);
     89b:	83 ec 08             	sub    $0x8,%esp
     89e:	57                   	push   %edi
     89f:	56                   	push   %esi
     8a0:	e8 30 01 00 00       	call   9d5 <parseblock>
     8a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     8a8:	83 c4 10             	add    $0x10,%esp
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     8ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     8ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8b1:	5b                   	pop    %ebx
     8b2:	5e                   	pop    %esi
     8b3:	5f                   	pop    %edi
     8b4:	5d                   	pop    %ebp
     8b5:	c3                   	ret    
      panic("syntax");
     8b6:	83 ec 0c             	sub    $0xc,%esp
     8b9:	68 98 13 00 00       	push   $0x1398
     8be:	e8 e2 f9 ff ff       	call   2a5 <panic>
      panic("too many args");
     8c3:	83 ec 0c             	sub    $0xc,%esp
     8c6:	68 9f 13 00 00       	push   $0x139f
     8cb:	e8 d5 f9 ff ff       	call   2a5 <panic>
     8d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
     8d3:	8d 04 98             	lea    (%eax,%ebx,4),%eax
  cmd->argv[argc] = 0;
     8d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     8dd:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
  return ret;
     8e4:	eb c5                	jmp    8ab <parseexec+0xac>

000008e6 <parsepipe>:
{
     8e6:	55                   	push   %ebp
     8e7:	89 e5                	mov    %esp,%ebp
     8e9:	57                   	push   %edi
     8ea:	56                   	push   %esi
     8eb:	53                   	push   %ebx
     8ec:	83 ec 14             	sub    $0x14,%esp
     8ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
     8f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parseexec(ps, es);
     8f5:	56                   	push   %esi
     8f6:	53                   	push   %ebx
     8f7:	e8 03 ff ff ff       	call   7ff <parseexec>
     8fc:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     8fe:	83 c4 0c             	add    $0xc,%esp
     901:	68 b2 13 00 00       	push   $0x13b2
     906:	56                   	push   %esi
     907:	53                   	push   %ebx
     908:	e8 bc fd ff ff       	call   6c9 <peek>
     90d:	83 c4 10             	add    $0x10,%esp
     910:	85 c0                	test   %eax,%eax
     912:	75 0a                	jne    91e <parsepipe+0x38>
}
     914:	89 f8                	mov    %edi,%eax
     916:	8d 65 f4             	lea    -0xc(%ebp),%esp
     919:	5b                   	pop    %ebx
     91a:	5e                   	pop    %esi
     91b:	5f                   	pop    %edi
     91c:	5d                   	pop    %ebp
     91d:	c3                   	ret    
    gettoken(ps, es, 0, 0);
     91e:	6a 00                	push   $0x0
     920:	6a 00                	push   $0x0
     922:	56                   	push   %esi
     923:	53                   	push   %ebx
     924:	e8 69 fc ff ff       	call   592 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     929:	83 c4 08             	add    $0x8,%esp
     92c:	56                   	push   %esi
     92d:	53                   	push   %ebx
     92e:	e8 b3 ff ff ff       	call   8e6 <parsepipe>
     933:	83 c4 08             	add    $0x8,%esp
     936:	50                   	push   %eax
     937:	57                   	push   %edi
     938:	e8 b9 fb ff ff       	call   4f6 <pipecmd>
     93d:	89 c7                	mov    %eax,%edi
     93f:	83 c4 10             	add    $0x10,%esp
  return cmd;
     942:	eb d0                	jmp    914 <parsepipe+0x2e>

00000944 <parseline>:
{
     944:	55                   	push   %ebp
     945:	89 e5                	mov    %esp,%ebp
     947:	57                   	push   %edi
     948:	56                   	push   %esi
     949:	53                   	push   %ebx
     94a:	83 ec 14             	sub    $0x14,%esp
     94d:	8b 5d 08             	mov    0x8(%ebp),%ebx
     950:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parsepipe(ps, es);
     953:	56                   	push   %esi
     954:	53                   	push   %ebx
     955:	e8 8c ff ff ff       	call   8e6 <parsepipe>
     95a:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     95c:	83 c4 10             	add    $0x10,%esp
     95f:	eb 18                	jmp    979 <parseline+0x35>
    gettoken(ps, es, 0, 0);
     961:	6a 00                	push   $0x0
     963:	6a 00                	push   $0x0
     965:	56                   	push   %esi
     966:	53                   	push   %ebx
     967:	e8 26 fc ff ff       	call   592 <gettoken>
    cmd = backcmd(cmd);
     96c:	89 3c 24             	mov    %edi,(%esp)
     96f:	e8 ee fb ff ff       	call   562 <backcmd>
     974:	89 c7                	mov    %eax,%edi
     976:	83 c4 10             	add    $0x10,%esp
  while(peek(ps, es, "&")){
     979:	83 ec 04             	sub    $0x4,%esp
     97c:	68 b4 13 00 00       	push   $0x13b4
     981:	56                   	push   %esi
     982:	53                   	push   %ebx
     983:	e8 41 fd ff ff       	call   6c9 <peek>
     988:	83 c4 10             	add    $0x10,%esp
     98b:	85 c0                	test   %eax,%eax
     98d:	75 d2                	jne    961 <parseline+0x1d>
  if(peek(ps, es, ";")){
     98f:	83 ec 04             	sub    $0x4,%esp
     992:	68 b0 13 00 00       	push   $0x13b0
     997:	56                   	push   %esi
     998:	53                   	push   %ebx
     999:	e8 2b fd ff ff       	call   6c9 <peek>
     99e:	83 c4 10             	add    $0x10,%esp
     9a1:	85 c0                	test   %eax,%eax
     9a3:	75 0a                	jne    9af <parseline+0x6b>
}
     9a5:	89 f8                	mov    %edi,%eax
     9a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9aa:	5b                   	pop    %ebx
     9ab:	5e                   	pop    %esi
     9ac:	5f                   	pop    %edi
     9ad:	5d                   	pop    %ebp
     9ae:	c3                   	ret    
    gettoken(ps, es, 0, 0);
     9af:	6a 00                	push   $0x0
     9b1:	6a 00                	push   $0x0
     9b3:	56                   	push   %esi
     9b4:	53                   	push   %ebx
     9b5:	e8 d8 fb ff ff       	call   592 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     9ba:	83 c4 08             	add    $0x8,%esp
     9bd:	56                   	push   %esi
     9be:	53                   	push   %ebx
     9bf:	e8 80 ff ff ff       	call   944 <parseline>
     9c4:	83 c4 08             	add    $0x8,%esp
     9c7:	50                   	push   %eax
     9c8:	57                   	push   %edi
     9c9:	e8 5e fb ff ff       	call   52c <listcmd>
     9ce:	89 c7                	mov    %eax,%edi
     9d0:	83 c4 10             	add    $0x10,%esp
  return cmd;
     9d3:	eb d0                	jmp    9a5 <parseline+0x61>

000009d5 <parseblock>:
{
     9d5:	55                   	push   %ebp
     9d6:	89 e5                	mov    %esp,%ebp
     9d8:	57                   	push   %edi
     9d9:	56                   	push   %esi
     9da:	53                   	push   %ebx
     9db:	83 ec 10             	sub    $0x10,%esp
     9de:	8b 5d 08             	mov    0x8(%ebp),%ebx
     9e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     9e4:	68 96 13 00 00       	push   $0x1396
     9e9:	56                   	push   %esi
     9ea:	53                   	push   %ebx
     9eb:	e8 d9 fc ff ff       	call   6c9 <peek>
     9f0:	83 c4 10             	add    $0x10,%esp
     9f3:	85 c0                	test   %eax,%eax
     9f5:	74 4b                	je     a42 <parseblock+0x6d>
  gettoken(ps, es, 0, 0);
     9f7:	6a 00                	push   $0x0
     9f9:	6a 00                	push   $0x0
     9fb:	56                   	push   %esi
     9fc:	53                   	push   %ebx
     9fd:	e8 90 fb ff ff       	call   592 <gettoken>
  cmd = parseline(ps, es);
     a02:	83 c4 08             	add    $0x8,%esp
     a05:	56                   	push   %esi
     a06:	53                   	push   %ebx
     a07:	e8 38 ff ff ff       	call   944 <parseline>
     a0c:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     a0e:	83 c4 0c             	add    $0xc,%esp
     a11:	68 d2 13 00 00       	push   $0x13d2
     a16:	56                   	push   %esi
     a17:	53                   	push   %ebx
     a18:	e8 ac fc ff ff       	call   6c9 <peek>
     a1d:	83 c4 10             	add    $0x10,%esp
     a20:	85 c0                	test   %eax,%eax
     a22:	74 2b                	je     a4f <parseblock+0x7a>
  gettoken(ps, es, 0, 0);
     a24:	6a 00                	push   $0x0
     a26:	6a 00                	push   $0x0
     a28:	56                   	push   %esi
     a29:	53                   	push   %ebx
     a2a:	e8 63 fb ff ff       	call   592 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     a2f:	83 c4 0c             	add    $0xc,%esp
     a32:	56                   	push   %esi
     a33:	53                   	push   %ebx
     a34:	57                   	push   %edi
     a35:	e8 f5 fc ff ff       	call   72f <parseredirs>
}
     a3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a3d:	5b                   	pop    %ebx
     a3e:	5e                   	pop    %esi
     a3f:	5f                   	pop    %edi
     a40:	5d                   	pop    %ebp
     a41:	c3                   	ret    
    panic("parseblock");
     a42:	83 ec 0c             	sub    $0xc,%esp
     a45:	68 b6 13 00 00       	push   $0x13b6
     a4a:	e8 56 f8 ff ff       	call   2a5 <panic>
    panic("syntax - missing )");
     a4f:	83 ec 0c             	sub    $0xc,%esp
     a52:	68 c1 13 00 00       	push   $0x13c1
     a57:	e8 49 f8 ff ff       	call   2a5 <panic>

00000a5c <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     a5c:	55                   	push   %ebp
     a5d:	89 e5                	mov    %esp,%ebp
     a5f:	53                   	push   %ebx
     a60:	83 ec 04             	sub    $0x4,%esp
     a63:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     a66:	85 db                	test   %ebx,%ebx
     a68:	74 3c                	je     aa6 <nulterminate+0x4a>
    return 0;

  switch(cmd->type){
     a6a:	83 3b 05             	cmpl   $0x5,(%ebx)
     a6d:	77 37                	ja     aa6 <nulterminate+0x4a>
     a6f:	8b 03                	mov    (%ebx),%eax
     a71:	ff 24 85 14 14 00 00 	jmp    *0x1414(,%eax,4)
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     a78:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
     a7c:	74 28                	je     aa6 <nulterminate+0x4a>
     a7e:	8d 43 08             	lea    0x8(%ebx),%eax
      *ecmd->eargv[i] = 0;
     a81:	8b 50 24             	mov    0x24(%eax),%edx
     a84:	c6 02 00             	movb   $0x0,(%edx)
     a87:	83 c0 04             	add    $0x4,%eax
    for(i=0; ecmd->argv[i]; i++)
     a8a:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
     a8e:	75 f1                	jne    a81 <nulterminate+0x25>
     a90:	eb 14                	jmp    aa6 <nulterminate+0x4a>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     a92:	83 ec 0c             	sub    $0xc,%esp
     a95:	ff 73 04             	pushl  0x4(%ebx)
     a98:	e8 bf ff ff ff       	call   a5c <nulterminate>
    *rcmd->efile = 0;
     a9d:	8b 43 0c             	mov    0xc(%ebx),%eax
     aa0:	c6 00 00             	movb   $0x0,(%eax)
    break;
     aa3:	83 c4 10             	add    $0x10,%esp
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     aa6:	89 d8                	mov    %ebx,%eax
     aa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     aab:	c9                   	leave  
     aac:	c3                   	ret    
    nulterminate(pcmd->left);
     aad:	83 ec 0c             	sub    $0xc,%esp
     ab0:	ff 73 04             	pushl  0x4(%ebx)
     ab3:	e8 a4 ff ff ff       	call   a5c <nulterminate>
    nulterminate(pcmd->right);
     ab8:	83 c4 04             	add    $0x4,%esp
     abb:	ff 73 08             	pushl  0x8(%ebx)
     abe:	e8 99 ff ff ff       	call   a5c <nulterminate>
    break;
     ac3:	83 c4 10             	add    $0x10,%esp
     ac6:	eb de                	jmp    aa6 <nulterminate+0x4a>
    nulterminate(lcmd->left);
     ac8:	83 ec 0c             	sub    $0xc,%esp
     acb:	ff 73 04             	pushl  0x4(%ebx)
     ace:	e8 89 ff ff ff       	call   a5c <nulterminate>
    nulterminate(lcmd->right);
     ad3:	83 c4 04             	add    $0x4,%esp
     ad6:	ff 73 08             	pushl  0x8(%ebx)
     ad9:	e8 7e ff ff ff       	call   a5c <nulterminate>
    break;
     ade:	83 c4 10             	add    $0x10,%esp
     ae1:	eb c3                	jmp    aa6 <nulterminate+0x4a>
    nulterminate(bcmd->cmd);
     ae3:	83 ec 0c             	sub    $0xc,%esp
     ae6:	ff 73 04             	pushl  0x4(%ebx)
     ae9:	e8 6e ff ff ff       	call   a5c <nulterminate>
    break;
     aee:	83 c4 10             	add    $0x10,%esp
     af1:	eb b3                	jmp    aa6 <nulterminate+0x4a>

00000af3 <parsecmd>:
{
     af3:	55                   	push   %ebp
     af4:	89 e5                	mov    %esp,%ebp
     af6:	56                   	push   %esi
     af7:	53                   	push   %ebx
  es = s + strlen(s);
     af8:	8b 5d 08             	mov    0x8(%ebp),%ebx
     afb:	83 ec 0c             	sub    $0xc,%esp
     afe:	53                   	push   %ebx
     aff:	e8 99 01 00 00       	call   c9d <strlen>
     b04:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     b06:	83 c4 08             	add    $0x8,%esp
     b09:	53                   	push   %ebx
     b0a:	8d 45 08             	lea    0x8(%ebp),%eax
     b0d:	50                   	push   %eax
     b0e:	e8 31 fe ff ff       	call   944 <parseline>
     b13:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     b15:	83 c4 0c             	add    $0xc,%esp
     b18:	68 44 13 00 00       	push   $0x1344
     b1d:	53                   	push   %ebx
     b1e:	8d 45 08             	lea    0x8(%ebp),%eax
     b21:	50                   	push   %eax
     b22:	e8 a2 fb ff ff       	call   6c9 <peek>
  if(s != es){
     b27:	8b 45 08             	mov    0x8(%ebp),%eax
     b2a:	83 c4 10             	add    $0x10,%esp
     b2d:	39 d8                	cmp    %ebx,%eax
     b2f:	75 12                	jne    b43 <parsecmd+0x50>
  nulterminate(cmd);
     b31:	83 ec 0c             	sub    $0xc,%esp
     b34:	56                   	push   %esi
     b35:	e8 22 ff ff ff       	call   a5c <nulterminate>
}
     b3a:	89 f0                	mov    %esi,%eax
     b3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b3f:	5b                   	pop    %ebx
     b40:	5e                   	pop    %esi
     b41:	5d                   	pop    %ebp
     b42:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     b43:	83 ec 04             	sub    $0x4,%esp
     b46:	50                   	push   %eax
     b47:	68 d4 13 00 00       	push   $0x13d4
     b4c:	6a 02                	push   $0x2
     b4e:	e8 c2 04 00 00       	call   1015 <printf>
    panic("syntax");
     b53:	c7 04 24 98 13 00 00 	movl   $0x1398,(%esp)
     b5a:	e8 46 f7 ff ff       	call   2a5 <panic>

00000b5f <main>:
{
     b5f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     b63:	83 e4 f0             	and    $0xfffffff0,%esp
     b66:	ff 71 fc             	pushl  -0x4(%ecx)
     b69:	55                   	push   %ebp
     b6a:	89 e5                	mov    %esp,%ebp
     b6c:	51                   	push   %ecx
     b6d:	83 ec 04             	sub    $0x4,%esp
  while((fd = open("console", O_RDWR)) >= 0){
     b70:	83 ec 08             	sub    $0x8,%esp
     b73:	6a 02                	push   $0x2
     b75:	68 e3 13 00 00       	push   $0x13e3
     b7a:	e8 6c 03 00 00       	call   eeb <open>
     b7f:	83 c4 10             	add    $0x10,%esp
     b82:	85 c0                	test   %eax,%eax
     b84:	78 2e                	js     bb4 <main+0x55>
    if(fd >= 3){
     b86:	83 f8 02             	cmp    $0x2,%eax
     b89:	7e e5                	jle    b70 <main+0x11>
      close(fd);
     b8b:	83 ec 0c             	sub    $0xc,%esp
     b8e:	50                   	push   %eax
     b8f:	e8 3f 03 00 00       	call   ed3 <close>
      break;
     b94:	83 c4 10             	add    $0x10,%esp
     b97:	eb 1b                	jmp    bb4 <main+0x55>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     b99:	80 3d 81 1a 00 00 64 	cmpb   $0x64,0x1a81
     ba0:	74 49                	je     beb <main+0x8c>
    if(fork1() == 0)
     ba2:	e8 18 f7 ff ff       	call   2bf <fork1>
     ba7:	85 c0                	test   %eax,%eax
     ba9:	0f 84 85 00 00 00    	je     c34 <main+0xd5>
    wait();
     baf:	e8 ff 02 00 00       	call   eb3 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     bb4:	83 ec 08             	sub    $0x8,%esp
     bb7:	6a 64                	push   $0x64
     bb9:	68 80 1a 00 00       	push   $0x1a80
     bbe:	e8 3d f4 ff ff       	call   0 <getcmd>
     bc3:	83 c4 10             	add    $0x10,%esp
     bc6:	85 c0                	test   %eax,%eax
     bc8:	78 7f                	js     c49 <main+0xea>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     bca:	0f b6 05 80 1a 00 00 	movzbl 0x1a80,%eax
     bd1:	3c 63                	cmp    $0x63,%al
     bd3:	74 c4                	je     b99 <main+0x3a>
    if (buf[0]=='_') {     // assume it is a builtin command
     bd5:	3c 5f                	cmp    $0x5f,%al
     bd7:	75 c9                	jne    ba2 <main+0x43>
      dobuiltin(buf);
     bd9:	83 ec 0c             	sub    $0xc,%esp
     bdc:	68 80 1a 00 00       	push   $0x1a80
     be1:	e8 62 f6 ff ff       	call   248 <dobuiltin>
      continue;
     be6:	83 c4 10             	add    $0x10,%esp
     be9:	eb c9                	jmp    bb4 <main+0x55>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     beb:	80 3d 82 1a 00 00 20 	cmpb   $0x20,0x1a82
     bf2:	75 ae                	jne    ba2 <main+0x43>
      buf[strlen(buf)-1] = 0;  // chop \n
     bf4:	83 ec 0c             	sub    $0xc,%esp
     bf7:	68 80 1a 00 00       	push   $0x1a80
     bfc:	e8 9c 00 00 00       	call   c9d <strlen>
     c01:	c6 80 7f 1a 00 00 00 	movb   $0x0,0x1a7f(%eax)
      if(chdir(buf+3) < 0)
     c08:	c7 04 24 83 1a 00 00 	movl   $0x1a83,(%esp)
     c0f:	e8 07 03 00 00       	call   f1b <chdir>
     c14:	83 c4 10             	add    $0x10,%esp
     c17:	85 c0                	test   %eax,%eax
     c19:	79 99                	jns    bb4 <main+0x55>
        printf(2, "cannot cd %s\n", buf+3);
     c1b:	83 ec 04             	sub    $0x4,%esp
     c1e:	68 83 1a 00 00       	push   $0x1a83
     c23:	68 eb 13 00 00       	push   $0x13eb
     c28:	6a 02                	push   $0x2
     c2a:	e8 e6 03 00 00       	call   1015 <printf>
     c2f:	83 c4 10             	add    $0x10,%esp
     c32:	eb 80                	jmp    bb4 <main+0x55>
      runcmd(parsecmd(buf));
     c34:	83 ec 0c             	sub    $0xc,%esp
     c37:	68 80 1a 00 00       	push   $0x1a80
     c3c:	e8 b2 fe ff ff       	call   af3 <parsecmd>
     c41:	89 04 24             	mov    %eax,(%esp)
     c44:	e8 95 f6 ff ff       	call   2de <runcmd>
  exit();
     c49:	e8 5d 02 00 00       	call   eab <exit>

00000c4e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     c4e:	55                   	push   %ebp
     c4f:	89 e5                	mov    %esp,%ebp
     c51:	53                   	push   %ebx
     c52:	8b 45 08             	mov    0x8(%ebp),%eax
     c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c58:	89 c2                	mov    %eax,%edx
     c5a:	83 c1 01             	add    $0x1,%ecx
     c5d:	83 c2 01             	add    $0x1,%edx
     c60:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     c64:	88 5a ff             	mov    %bl,-0x1(%edx)
     c67:	84 db                	test   %bl,%bl
     c69:	75 ef                	jne    c5a <strcpy+0xc>
    ;
  return os;
}
     c6b:	5b                   	pop    %ebx
     c6c:	5d                   	pop    %ebp
     c6d:	c3                   	ret    

00000c6e <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c6e:	55                   	push   %ebp
     c6f:	89 e5                	mov    %esp,%ebp
     c71:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c74:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     c77:	0f b6 01             	movzbl (%ecx),%eax
     c7a:	84 c0                	test   %al,%al
     c7c:	74 15                	je     c93 <strcmp+0x25>
     c7e:	3a 02                	cmp    (%edx),%al
     c80:	75 11                	jne    c93 <strcmp+0x25>
    p++, q++;
     c82:	83 c1 01             	add    $0x1,%ecx
     c85:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     c88:	0f b6 01             	movzbl (%ecx),%eax
     c8b:	84 c0                	test   %al,%al
     c8d:	74 04                	je     c93 <strcmp+0x25>
     c8f:	3a 02                	cmp    (%edx),%al
     c91:	74 ef                	je     c82 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     c93:	0f b6 c0             	movzbl %al,%eax
     c96:	0f b6 12             	movzbl (%edx),%edx
     c99:	29 d0                	sub    %edx,%eax
}
     c9b:	5d                   	pop    %ebp
     c9c:	c3                   	ret    

00000c9d <strlen>:

uint
strlen(char *s)
{
     c9d:	55                   	push   %ebp
     c9e:	89 e5                	mov    %esp,%ebp
     ca0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     ca3:	80 39 00             	cmpb   $0x0,(%ecx)
     ca6:	74 12                	je     cba <strlen+0x1d>
     ca8:	ba 00 00 00 00       	mov    $0x0,%edx
     cad:	83 c2 01             	add    $0x1,%edx
     cb0:	89 d0                	mov    %edx,%eax
     cb2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     cb6:	75 f5                	jne    cad <strlen+0x10>
    ;
  return n;
}
     cb8:	5d                   	pop    %ebp
     cb9:	c3                   	ret    
  for(n = 0; s[n]; n++)
     cba:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
     cbf:	eb f7                	jmp    cb8 <strlen+0x1b>

00000cc1 <memset>:

void*
memset(void *dst, int c, uint n)
{
     cc1:	55                   	push   %ebp
     cc2:	89 e5                	mov    %esp,%ebp
     cc4:	57                   	push   %edi
     cc5:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     cc8:	89 d7                	mov    %edx,%edi
     cca:	8b 4d 10             	mov    0x10(%ebp),%ecx
     ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
     cd0:	fc                   	cld    
     cd1:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     cd3:	89 d0                	mov    %edx,%eax
     cd5:	5f                   	pop    %edi
     cd6:	5d                   	pop    %ebp
     cd7:	c3                   	ret    

00000cd8 <strchr>:

char*
strchr(const char *s, char c)
{
     cd8:	55                   	push   %ebp
     cd9:	89 e5                	mov    %esp,%ebp
     cdb:	53                   	push   %ebx
     cdc:	8b 45 08             	mov    0x8(%ebp),%eax
     cdf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
     ce2:	0f b6 10             	movzbl (%eax),%edx
     ce5:	84 d2                	test   %dl,%dl
     ce7:	74 1e                	je     d07 <strchr+0x2f>
     ce9:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
     ceb:	38 d3                	cmp    %dl,%bl
     ced:	74 15                	je     d04 <strchr+0x2c>
  for(; *s; s++)
     cef:	83 c0 01             	add    $0x1,%eax
     cf2:	0f b6 10             	movzbl (%eax),%edx
     cf5:	84 d2                	test   %dl,%dl
     cf7:	74 06                	je     cff <strchr+0x27>
    if(*s == c)
     cf9:	38 ca                	cmp    %cl,%dl
     cfb:	75 f2                	jne    cef <strchr+0x17>
     cfd:	eb 05                	jmp    d04 <strchr+0x2c>
      return (char*)s;
  return 0;
     cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d04:	5b                   	pop    %ebx
     d05:	5d                   	pop    %ebp
     d06:	c3                   	ret    
  return 0;
     d07:	b8 00 00 00 00       	mov    $0x0,%eax
     d0c:	eb f6                	jmp    d04 <strchr+0x2c>

00000d0e <gets>:

char*
gets(char *buf, int max)
{
     d0e:	55                   	push   %ebp
     d0f:	89 e5                	mov    %esp,%ebp
     d11:	57                   	push   %edi
     d12:	56                   	push   %esi
     d13:	53                   	push   %ebx
     d14:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d17:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
     d1c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
     d1f:	8d 5e 01             	lea    0x1(%esi),%ebx
     d22:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     d25:	7d 2b                	jge    d52 <gets+0x44>
    cc = read(0, &c, 1);
     d27:	83 ec 04             	sub    $0x4,%esp
     d2a:	6a 01                	push   $0x1
     d2c:	57                   	push   %edi
     d2d:	6a 00                	push   $0x0
     d2f:	e8 8f 01 00 00       	call   ec3 <read>
    if(cc < 1)
     d34:	83 c4 10             	add    $0x10,%esp
     d37:	85 c0                	test   %eax,%eax
     d39:	7e 17                	jle    d52 <gets+0x44>
      break;
    buf[i++] = c;
     d3b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     d3f:	8b 55 08             	mov    0x8(%ebp),%edx
     d42:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
     d46:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
     d48:	3c 0a                	cmp    $0xa,%al
     d4a:	74 04                	je     d50 <gets+0x42>
     d4c:	3c 0d                	cmp    $0xd,%al
     d4e:	75 cf                	jne    d1f <gets+0x11>
  for(i=0; i+1 < max; ){
     d50:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
     d52:	8b 45 08             	mov    0x8(%ebp),%eax
     d55:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
     d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d5c:	5b                   	pop    %ebx
     d5d:	5e                   	pop    %esi
     d5e:	5f                   	pop    %edi
     d5f:	5d                   	pop    %ebp
     d60:	c3                   	ret    

00000d61 <stat>:

int
stat(char *n, struct stat *st)
{
     d61:	55                   	push   %ebp
     d62:	89 e5                	mov    %esp,%ebp
     d64:	56                   	push   %esi
     d65:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d66:	83 ec 08             	sub    $0x8,%esp
     d69:	6a 00                	push   $0x0
     d6b:	ff 75 08             	pushl  0x8(%ebp)
     d6e:	e8 78 01 00 00       	call   eeb <open>
  if(fd < 0)
     d73:	83 c4 10             	add    $0x10,%esp
     d76:	85 c0                	test   %eax,%eax
     d78:	78 24                	js     d9e <stat+0x3d>
     d7a:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
     d7c:	83 ec 08             	sub    $0x8,%esp
     d7f:	ff 75 0c             	pushl  0xc(%ebp)
     d82:	50                   	push   %eax
     d83:	e8 7b 01 00 00       	call   f03 <fstat>
     d88:	89 c6                	mov    %eax,%esi
  close(fd);
     d8a:	89 1c 24             	mov    %ebx,(%esp)
     d8d:	e8 41 01 00 00       	call   ed3 <close>
  return r;
     d92:	83 c4 10             	add    $0x10,%esp
}
     d95:	89 f0                	mov    %esi,%eax
     d97:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d9a:	5b                   	pop    %ebx
     d9b:	5e                   	pop    %esi
     d9c:	5d                   	pop    %ebp
     d9d:	c3                   	ret    
    return -1;
     d9e:	be ff ff ff ff       	mov    $0xffffffff,%esi
     da3:	eb f0                	jmp    d95 <stat+0x34>

00000da5 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
     da5:	55                   	push   %ebp
     da6:	89 e5                	mov    %esp,%ebp
     da8:	56                   	push   %esi
     da9:	53                   	push   %ebx
     daa:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
     dad:	0f b6 0a             	movzbl (%edx),%ecx
     db0:	80 f9 20             	cmp    $0x20,%cl
     db3:	75 0b                	jne    dc0 <atoi+0x1b>
     db5:	83 c2 01             	add    $0x1,%edx
     db8:	0f b6 0a             	movzbl (%edx),%ecx
     dbb:	80 f9 20             	cmp    $0x20,%cl
     dbe:	74 f5                	je     db5 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
     dc0:	80 f9 2d             	cmp    $0x2d,%cl
     dc3:	74 3b                	je     e00 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
     dc5:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
     dc8:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
     dcd:	f6 c1 fd             	test   $0xfd,%cl
     dd0:	74 33                	je     e05 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
     dd2:	0f b6 0a             	movzbl (%edx),%ecx
     dd5:	8d 41 d0             	lea    -0x30(%ecx),%eax
     dd8:	3c 09                	cmp    $0x9,%al
     dda:	77 2e                	ja     e0a <atoi+0x65>
     ddc:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
     de1:	83 c2 01             	add    $0x1,%edx
     de4:	8d 04 80             	lea    (%eax,%eax,4),%eax
     de7:	0f be c9             	movsbl %cl,%ecx
     dea:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
     dee:	0f b6 0a             	movzbl (%edx),%ecx
     df1:	8d 59 d0             	lea    -0x30(%ecx),%ebx
     df4:	80 fb 09             	cmp    $0x9,%bl
     df7:	76 e8                	jbe    de1 <atoi+0x3c>
  return sign*n;
     df9:	0f af c6             	imul   %esi,%eax
}
     dfc:	5b                   	pop    %ebx
     dfd:	5e                   	pop    %esi
     dfe:	5d                   	pop    %ebp
     dff:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
     e00:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
     e05:	83 c2 01             	add    $0x1,%edx
     e08:	eb c8                	jmp    dd2 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
     e0a:	b8 00 00 00 00       	mov    $0x0,%eax
     e0f:	eb e8                	jmp    df9 <atoi+0x54>

00000e11 <atoo>:

int
atoo(const char *s)
{
     e11:	55                   	push   %ebp
     e12:	89 e5                	mov    %esp,%ebp
     e14:	56                   	push   %esi
     e15:	53                   	push   %ebx
     e16:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
     e19:	0f b6 0a             	movzbl (%edx),%ecx
     e1c:	80 f9 20             	cmp    $0x20,%cl
     e1f:	75 0b                	jne    e2c <atoo+0x1b>
     e21:	83 c2 01             	add    $0x1,%edx
     e24:	0f b6 0a             	movzbl (%edx),%ecx
     e27:	80 f9 20             	cmp    $0x20,%cl
     e2a:	74 f5                	je     e21 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
     e2c:	80 f9 2d             	cmp    $0x2d,%cl
     e2f:	74 38                	je     e69 <atoo+0x58>
  if (*s == '+'  || *s == '-')
     e31:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
     e34:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
     e39:	f6 c1 fd             	test   $0xfd,%cl
     e3c:	74 30                	je     e6e <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
     e3e:	0f b6 0a             	movzbl (%edx),%ecx
     e41:	8d 41 d0             	lea    -0x30(%ecx),%eax
     e44:	3c 07                	cmp    $0x7,%al
     e46:	77 2b                	ja     e73 <atoo+0x62>
     e48:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
     e4d:	83 c2 01             	add    $0x1,%edx
     e50:	0f be c9             	movsbl %cl,%ecx
     e53:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
     e57:	0f b6 0a             	movzbl (%edx),%ecx
     e5a:	8d 59 d0             	lea    -0x30(%ecx),%ebx
     e5d:	80 fb 07             	cmp    $0x7,%bl
     e60:	76 eb                	jbe    e4d <atoo+0x3c>
  return sign*n;
     e62:	0f af c6             	imul   %esi,%eax
}
     e65:	5b                   	pop    %ebx
     e66:	5e                   	pop    %esi
     e67:	5d                   	pop    %ebp
     e68:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
     e69:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
     e6e:	83 c2 01             	add    $0x1,%edx
     e71:	eb cb                	jmp    e3e <atoo+0x2d>
  while('0' <= *s && *s <= '7')
     e73:	b8 00 00 00 00       	mov    $0x0,%eax
     e78:	eb e8                	jmp    e62 <atoo+0x51>

00000e7a <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
     e7a:	55                   	push   %ebp
     e7b:	89 e5                	mov    %esp,%ebp
     e7d:	56                   	push   %esi
     e7e:	53                   	push   %ebx
     e7f:	8b 45 08             	mov    0x8(%ebp),%eax
     e82:	8b 75 0c             	mov    0xc(%ebp),%esi
     e85:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     e88:	85 db                	test   %ebx,%ebx
     e8a:	7e 13                	jle    e9f <memmove+0x25>
     e8c:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
     e91:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     e95:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     e98:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
     e9b:	39 d3                	cmp    %edx,%ebx
     e9d:	75 f2                	jne    e91 <memmove+0x17>
  return vdst;
}
     e9f:	5b                   	pop    %ebx
     ea0:	5e                   	pop    %esi
     ea1:	5d                   	pop    %ebp
     ea2:	c3                   	ret    

00000ea3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     ea3:	b8 01 00 00 00       	mov    $0x1,%eax
     ea8:	cd 40                	int    $0x40
     eaa:	c3                   	ret    

00000eab <exit>:
SYSCALL(exit)
     eab:	b8 02 00 00 00       	mov    $0x2,%eax
     eb0:	cd 40                	int    $0x40
     eb2:	c3                   	ret    

00000eb3 <wait>:
SYSCALL(wait)
     eb3:	b8 03 00 00 00       	mov    $0x3,%eax
     eb8:	cd 40                	int    $0x40
     eba:	c3                   	ret    

00000ebb <pipe>:
SYSCALL(pipe)
     ebb:	b8 04 00 00 00       	mov    $0x4,%eax
     ec0:	cd 40                	int    $0x40
     ec2:	c3                   	ret    

00000ec3 <read>:
SYSCALL(read)
     ec3:	b8 05 00 00 00       	mov    $0x5,%eax
     ec8:	cd 40                	int    $0x40
     eca:	c3                   	ret    

00000ecb <write>:
SYSCALL(write)
     ecb:	b8 10 00 00 00       	mov    $0x10,%eax
     ed0:	cd 40                	int    $0x40
     ed2:	c3                   	ret    

00000ed3 <close>:
SYSCALL(close)
     ed3:	b8 15 00 00 00       	mov    $0x15,%eax
     ed8:	cd 40                	int    $0x40
     eda:	c3                   	ret    

00000edb <kill>:
SYSCALL(kill)
     edb:	b8 06 00 00 00       	mov    $0x6,%eax
     ee0:	cd 40                	int    $0x40
     ee2:	c3                   	ret    

00000ee3 <exec>:
SYSCALL(exec)
     ee3:	b8 07 00 00 00       	mov    $0x7,%eax
     ee8:	cd 40                	int    $0x40
     eea:	c3                   	ret    

00000eeb <open>:
SYSCALL(open)
     eeb:	b8 0f 00 00 00       	mov    $0xf,%eax
     ef0:	cd 40                	int    $0x40
     ef2:	c3                   	ret    

00000ef3 <mknod>:
SYSCALL(mknod)
     ef3:	b8 11 00 00 00       	mov    $0x11,%eax
     ef8:	cd 40                	int    $0x40
     efa:	c3                   	ret    

00000efb <unlink>:
SYSCALL(unlink)
     efb:	b8 12 00 00 00       	mov    $0x12,%eax
     f00:	cd 40                	int    $0x40
     f02:	c3                   	ret    

00000f03 <fstat>:
SYSCALL(fstat)
     f03:	b8 08 00 00 00       	mov    $0x8,%eax
     f08:	cd 40                	int    $0x40
     f0a:	c3                   	ret    

00000f0b <link>:
SYSCALL(link)
     f0b:	b8 13 00 00 00       	mov    $0x13,%eax
     f10:	cd 40                	int    $0x40
     f12:	c3                   	ret    

00000f13 <mkdir>:
SYSCALL(mkdir)
     f13:	b8 14 00 00 00       	mov    $0x14,%eax
     f18:	cd 40                	int    $0x40
     f1a:	c3                   	ret    

00000f1b <chdir>:
SYSCALL(chdir)
     f1b:	b8 09 00 00 00       	mov    $0x9,%eax
     f20:	cd 40                	int    $0x40
     f22:	c3                   	ret    

00000f23 <dup>:
SYSCALL(dup)
     f23:	b8 0a 00 00 00       	mov    $0xa,%eax
     f28:	cd 40                	int    $0x40
     f2a:	c3                   	ret    

00000f2b <getpid>:
SYSCALL(getpid)
     f2b:	b8 0b 00 00 00       	mov    $0xb,%eax
     f30:	cd 40                	int    $0x40
     f32:	c3                   	ret    

00000f33 <sbrk>:
SYSCALL(sbrk)
     f33:	b8 0c 00 00 00       	mov    $0xc,%eax
     f38:	cd 40                	int    $0x40
     f3a:	c3                   	ret    

00000f3b <sleep>:
SYSCALL(sleep)
     f3b:	b8 0d 00 00 00       	mov    $0xd,%eax
     f40:	cd 40                	int    $0x40
     f42:	c3                   	ret    

00000f43 <uptime>:
SYSCALL(uptime)
     f43:	b8 0e 00 00 00       	mov    $0xe,%eax
     f48:	cd 40                	int    $0x40
     f4a:	c3                   	ret    

00000f4b <halt>:
SYSCALL(halt)
     f4b:	b8 16 00 00 00       	mov    $0x16,%eax
     f50:	cd 40                	int    $0x40
     f52:	c3                   	ret    

00000f53 <date>:
//proj1
SYSCALL(date)
     f53:	b8 17 00 00 00       	mov    $0x17,%eax
     f58:	cd 40                	int    $0x40
     f5a:	c3                   	ret    

00000f5b <getuid>:
//proj2
SYSCALL(getuid)
     f5b:	b8 18 00 00 00       	mov    $0x18,%eax
     f60:	cd 40                	int    $0x40
     f62:	c3                   	ret    

00000f63 <getgid>:
SYSCALL(getgid)
     f63:	b8 19 00 00 00       	mov    $0x19,%eax
     f68:	cd 40                	int    $0x40
     f6a:	c3                   	ret    

00000f6b <getppid>:
SYSCALL(getppid)
     f6b:	b8 1a 00 00 00       	mov    $0x1a,%eax
     f70:	cd 40                	int    $0x40
     f72:	c3                   	ret    

00000f73 <setuid>:
SYSCALL(setuid)
     f73:	b8 1b 00 00 00       	mov    $0x1b,%eax
     f78:	cd 40                	int    $0x40
     f7a:	c3                   	ret    

00000f7b <setgid>:
SYSCALL(setgid)
     f7b:	b8 1c 00 00 00       	mov    $0x1c,%eax
     f80:	cd 40                	int    $0x40
     f82:	c3                   	ret    

00000f83 <getprocs>:
SYSCALL(getprocs)
     f83:	b8 1d 00 00 00       	mov    $0x1d,%eax
     f88:	cd 40                	int    $0x40
     f8a:	c3                   	ret    

00000f8b <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     f8b:	55                   	push   %ebp
     f8c:	89 e5                	mov    %esp,%ebp
     f8e:	57                   	push   %edi
     f8f:	56                   	push   %esi
     f90:	53                   	push   %ebx
     f91:	83 ec 3c             	sub    $0x3c,%esp
     f94:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f9a:	74 14                	je     fb0 <printint+0x25>
     f9c:	85 d2                	test   %edx,%edx
     f9e:	79 10                	jns    fb0 <printint+0x25>
    neg = 1;
    x = -xx;
     fa0:	f7 da                	neg    %edx
    neg = 1;
     fa2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     fa9:	bf 00 00 00 00       	mov    $0x0,%edi
     fae:	eb 0b                	jmp    fbb <printint+0x30>
  neg = 0;
     fb0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     fb7:	eb f0                	jmp    fa9 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
     fb9:	89 df                	mov    %ebx,%edi
     fbb:	8d 5f 01             	lea    0x1(%edi),%ebx
     fbe:	89 d0                	mov    %edx,%eax
     fc0:	ba 00 00 00 00       	mov    $0x0,%edx
     fc5:	f7 f1                	div    %ecx
     fc7:	0f b6 92 34 14 00 00 	movzbl 0x1434(%edx),%edx
     fce:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
     fd2:	89 c2                	mov    %eax,%edx
     fd4:	85 c0                	test   %eax,%eax
     fd6:	75 e1                	jne    fb9 <printint+0x2e>
  if(neg)
     fd8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
     fdc:	74 08                	je     fe6 <printint+0x5b>
    buf[i++] = '-';
     fde:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
     fe3:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
     fe6:	83 eb 01             	sub    $0x1,%ebx
     fe9:	78 22                	js     100d <printint+0x82>
  write(fd, &c, 1);
     feb:	8d 7d d7             	lea    -0x29(%ebp),%edi
     fee:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
     ff3:	88 45 d7             	mov    %al,-0x29(%ebp)
     ff6:	83 ec 04             	sub    $0x4,%esp
     ff9:	6a 01                	push   $0x1
     ffb:	57                   	push   %edi
     ffc:	56                   	push   %esi
     ffd:	e8 c9 fe ff ff       	call   ecb <write>
  while(--i >= 0)
    1002:	83 eb 01             	sub    $0x1,%ebx
    1005:	83 c4 10             	add    $0x10,%esp
    1008:	83 fb ff             	cmp    $0xffffffff,%ebx
    100b:	75 e1                	jne    fee <printint+0x63>
    putc(fd, buf[i]);
}
    100d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1010:	5b                   	pop    %ebx
    1011:	5e                   	pop    %esi
    1012:	5f                   	pop    %edi
    1013:	5d                   	pop    %ebp
    1014:	c3                   	ret    

00001015 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1015:	55                   	push   %ebp
    1016:	89 e5                	mov    %esp,%ebp
    1018:	57                   	push   %edi
    1019:	56                   	push   %esi
    101a:	53                   	push   %ebx
    101b:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    101e:	8b 75 0c             	mov    0xc(%ebp),%esi
    1021:	0f b6 1e             	movzbl (%esi),%ebx
    1024:	84 db                	test   %bl,%bl
    1026:	0f 84 b1 01 00 00    	je     11dd <printf+0x1c8>
    102c:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    102f:	8d 45 10             	lea    0x10(%ebp),%eax
    1032:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1035:	bf 00 00 00 00       	mov    $0x0,%edi
    103a:	eb 2d                	jmp    1069 <printf+0x54>
    103c:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    103f:	83 ec 04             	sub    $0x4,%esp
    1042:	6a 01                	push   $0x1
    1044:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1047:	50                   	push   %eax
    1048:	ff 75 08             	pushl  0x8(%ebp)
    104b:	e8 7b fe ff ff       	call   ecb <write>
    1050:	83 c4 10             	add    $0x10,%esp
    1053:	eb 05                	jmp    105a <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1055:	83 ff 25             	cmp    $0x25,%edi
    1058:	74 22                	je     107c <printf+0x67>
    105a:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    105d:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    1061:	84 db                	test   %bl,%bl
    1063:	0f 84 74 01 00 00    	je     11dd <printf+0x1c8>
    c = fmt[i] & 0xff;
    1069:	0f be d3             	movsbl %bl,%edx
    106c:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    106f:	85 ff                	test   %edi,%edi
    1071:	75 e2                	jne    1055 <printf+0x40>
      if(c == '%'){
    1073:	83 f8 25             	cmp    $0x25,%eax
    1076:	75 c4                	jne    103c <printf+0x27>
        state = '%';
    1078:	89 c7                	mov    %eax,%edi
    107a:	eb de                	jmp    105a <printf+0x45>
      if(c == 'd'){
    107c:	83 f8 64             	cmp    $0x64,%eax
    107f:	74 59                	je     10da <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1081:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    1087:	83 fa 70             	cmp    $0x70,%edx
    108a:	74 7a                	je     1106 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    108c:	83 f8 73             	cmp    $0x73,%eax
    108f:	0f 84 9d 00 00 00    	je     1132 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1095:	83 f8 63             	cmp    $0x63,%eax
    1098:	0f 84 f2 00 00 00    	je     1190 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    109e:	83 f8 25             	cmp    $0x25,%eax
    10a1:	0f 84 15 01 00 00    	je     11bc <printf+0x1a7>
    10a7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    10ab:	83 ec 04             	sub    $0x4,%esp
    10ae:	6a 01                	push   $0x1
    10b0:	8d 45 e7             	lea    -0x19(%ebp),%eax
    10b3:	50                   	push   %eax
    10b4:	ff 75 08             	pushl  0x8(%ebp)
    10b7:	e8 0f fe ff ff       	call   ecb <write>
    10bc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    10bf:	83 c4 0c             	add    $0xc,%esp
    10c2:	6a 01                	push   $0x1
    10c4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    10c7:	50                   	push   %eax
    10c8:	ff 75 08             	pushl  0x8(%ebp)
    10cb:	e8 fb fd ff ff       	call   ecb <write>
    10d0:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    10d3:	bf 00 00 00 00       	mov    $0x0,%edi
    10d8:	eb 80                	jmp    105a <printf+0x45>
        printint(fd, *ap, 10, 1);
    10da:	83 ec 0c             	sub    $0xc,%esp
    10dd:	6a 01                	push   $0x1
    10df:	b9 0a 00 00 00       	mov    $0xa,%ecx
    10e4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    10e7:	8b 17                	mov    (%edi),%edx
    10e9:	8b 45 08             	mov    0x8(%ebp),%eax
    10ec:	e8 9a fe ff ff       	call   f8b <printint>
        ap++;
    10f1:	89 f8                	mov    %edi,%eax
    10f3:	83 c0 04             	add    $0x4,%eax
    10f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    10f9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    10fc:	bf 00 00 00 00       	mov    $0x0,%edi
    1101:	e9 54 ff ff ff       	jmp    105a <printf+0x45>
        printint(fd, *ap, 16, 0);
    1106:	83 ec 0c             	sub    $0xc,%esp
    1109:	6a 00                	push   $0x0
    110b:	b9 10 00 00 00       	mov    $0x10,%ecx
    1110:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1113:	8b 17                	mov    (%edi),%edx
    1115:	8b 45 08             	mov    0x8(%ebp),%eax
    1118:	e8 6e fe ff ff       	call   f8b <printint>
        ap++;
    111d:	89 f8                	mov    %edi,%eax
    111f:	83 c0 04             	add    $0x4,%eax
    1122:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1125:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1128:	bf 00 00 00 00       	mov    $0x0,%edi
    112d:	e9 28 ff ff ff       	jmp    105a <printf+0x45>
        s = (char*)*ap;
    1132:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1135:	8b 01                	mov    (%ecx),%eax
        ap++;
    1137:	83 c1 04             	add    $0x4,%ecx
    113a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    113d:	85 c0                	test   %eax,%eax
    113f:	74 13                	je     1154 <printf+0x13f>
        s = (char*)*ap;
    1141:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    1143:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1146:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    114b:	84 c0                	test   %al,%al
    114d:	75 0f                	jne    115e <printf+0x149>
    114f:	e9 06 ff ff ff       	jmp    105a <printf+0x45>
          s = "(null)";
    1154:	bb 2c 14 00 00       	mov    $0x142c,%ebx
        while(*s != 0){
    1159:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    115e:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1161:	89 75 d0             	mov    %esi,-0x30(%ebp)
    1164:	8b 75 08             	mov    0x8(%ebp),%esi
    1167:	88 45 e3             	mov    %al,-0x1d(%ebp)
    116a:	83 ec 04             	sub    $0x4,%esp
    116d:	6a 01                	push   $0x1
    116f:	57                   	push   %edi
    1170:	56                   	push   %esi
    1171:	e8 55 fd ff ff       	call   ecb <write>
          s++;
    1176:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    1179:	0f b6 03             	movzbl (%ebx),%eax
    117c:	83 c4 10             	add    $0x10,%esp
    117f:	84 c0                	test   %al,%al
    1181:	75 e4                	jne    1167 <printf+0x152>
    1183:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    1186:	bf 00 00 00 00       	mov    $0x0,%edi
    118b:	e9 ca fe ff ff       	jmp    105a <printf+0x45>
        putc(fd, *ap);
    1190:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1193:	8b 07                	mov    (%edi),%eax
    1195:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    1198:	83 ec 04             	sub    $0x4,%esp
    119b:	6a 01                	push   $0x1
    119d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    11a0:	50                   	push   %eax
    11a1:	ff 75 08             	pushl  0x8(%ebp)
    11a4:	e8 22 fd ff ff       	call   ecb <write>
        ap++;
    11a9:	83 c7 04             	add    $0x4,%edi
    11ac:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    11af:	83 c4 10             	add    $0x10,%esp
      state = 0;
    11b2:	bf 00 00 00 00       	mov    $0x0,%edi
    11b7:	e9 9e fe ff ff       	jmp    105a <printf+0x45>
    11bc:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    11bf:	83 ec 04             	sub    $0x4,%esp
    11c2:	6a 01                	push   $0x1
    11c4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    11c7:	50                   	push   %eax
    11c8:	ff 75 08             	pushl  0x8(%ebp)
    11cb:	e8 fb fc ff ff       	call   ecb <write>
    11d0:	83 c4 10             	add    $0x10,%esp
      state = 0;
    11d3:	bf 00 00 00 00       	mov    $0x0,%edi
    11d8:	e9 7d fe ff ff       	jmp    105a <printf+0x45>
    }
  }
}
    11dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11e0:	5b                   	pop    %ebx
    11e1:	5e                   	pop    %esi
    11e2:	5f                   	pop    %edi
    11e3:	5d                   	pop    %ebp
    11e4:	c3                   	ret    

000011e5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11e5:	55                   	push   %ebp
    11e6:	89 e5                	mov    %esp,%ebp
    11e8:	57                   	push   %edi
    11e9:	56                   	push   %esi
    11ea:	53                   	push   %ebx
    11eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11f1:	a1 e4 1a 00 00       	mov    0x1ae4,%eax
    11f6:	eb 0c                	jmp    1204 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11f8:	8b 10                	mov    (%eax),%edx
    11fa:	39 c2                	cmp    %eax,%edx
    11fc:	77 04                	ja     1202 <free+0x1d>
    11fe:	39 ca                	cmp    %ecx,%edx
    1200:	77 10                	ja     1212 <free+0x2d>
{
    1202:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1204:	39 c8                	cmp    %ecx,%eax
    1206:	73 f0                	jae    11f8 <free+0x13>
    1208:	8b 10                	mov    (%eax),%edx
    120a:	39 ca                	cmp    %ecx,%edx
    120c:	77 04                	ja     1212 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    120e:	39 c2                	cmp    %eax,%edx
    1210:	77 f0                	ja     1202 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1212:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1215:	8b 10                	mov    (%eax),%edx
    1217:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    121a:	39 fa                	cmp    %edi,%edx
    121c:	74 19                	je     1237 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    121e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1221:	8b 50 04             	mov    0x4(%eax),%edx
    1224:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1227:	39 f1                	cmp    %esi,%ecx
    1229:	74 1b                	je     1246 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    122b:	89 08                	mov    %ecx,(%eax)
  freep = p;
    122d:	a3 e4 1a 00 00       	mov    %eax,0x1ae4
}
    1232:	5b                   	pop    %ebx
    1233:	5e                   	pop    %esi
    1234:	5f                   	pop    %edi
    1235:	5d                   	pop    %ebp
    1236:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1237:	03 72 04             	add    0x4(%edx),%esi
    123a:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    123d:	8b 10                	mov    (%eax),%edx
    123f:	8b 12                	mov    (%edx),%edx
    1241:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1244:	eb db                	jmp    1221 <free+0x3c>
    p->s.size += bp->s.size;
    1246:	03 53 fc             	add    -0x4(%ebx),%edx
    1249:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    124c:	8b 53 f8             	mov    -0x8(%ebx),%edx
    124f:	89 10                	mov    %edx,(%eax)
    1251:	eb da                	jmp    122d <free+0x48>

00001253 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1253:	55                   	push   %ebp
    1254:	89 e5                	mov    %esp,%ebp
    1256:	57                   	push   %edi
    1257:	56                   	push   %esi
    1258:	53                   	push   %ebx
    1259:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    125c:	8b 45 08             	mov    0x8(%ebp),%eax
    125f:	8d 58 07             	lea    0x7(%eax),%ebx
    1262:	c1 eb 03             	shr    $0x3,%ebx
    1265:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    1268:	8b 15 e4 1a 00 00    	mov    0x1ae4,%edx
    126e:	85 d2                	test   %edx,%edx
    1270:	74 20                	je     1292 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1272:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1274:	8b 48 04             	mov    0x4(%eax),%ecx
    1277:	39 cb                	cmp    %ecx,%ebx
    1279:	76 3c                	jbe    12b7 <malloc+0x64>
    127b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    1281:	be 00 10 00 00       	mov    $0x1000,%esi
    1286:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    1289:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    1290:	eb 70                	jmp    1302 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    1292:	c7 05 e4 1a 00 00 e8 	movl   $0x1ae8,0x1ae4
    1299:	1a 00 00 
    129c:	c7 05 e8 1a 00 00 e8 	movl   $0x1ae8,0x1ae8
    12a3:	1a 00 00 
    base.s.size = 0;
    12a6:	c7 05 ec 1a 00 00 00 	movl   $0x0,0x1aec
    12ad:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    12b0:	ba e8 1a 00 00       	mov    $0x1ae8,%edx
    12b5:	eb bb                	jmp    1272 <malloc+0x1f>
      if(p->s.size == nunits)
    12b7:	39 cb                	cmp    %ecx,%ebx
    12b9:	74 1c                	je     12d7 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    12bb:	29 d9                	sub    %ebx,%ecx
    12bd:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    12c0:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    12c3:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    12c6:	89 15 e4 1a 00 00    	mov    %edx,0x1ae4
      return (void*)(p + 1);
    12cc:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12d2:	5b                   	pop    %ebx
    12d3:	5e                   	pop    %esi
    12d4:	5f                   	pop    %edi
    12d5:	5d                   	pop    %ebp
    12d6:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    12d7:	8b 08                	mov    (%eax),%ecx
    12d9:	89 0a                	mov    %ecx,(%edx)
    12db:	eb e9                	jmp    12c6 <malloc+0x73>
  hp->s.size = nu;
    12dd:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    12e0:	83 ec 0c             	sub    $0xc,%esp
    12e3:	83 c0 08             	add    $0x8,%eax
    12e6:	50                   	push   %eax
    12e7:	e8 f9 fe ff ff       	call   11e5 <free>
  return freep;
    12ec:	8b 15 e4 1a 00 00    	mov    0x1ae4,%edx
      if((p = morecore(nunits)) == 0)
    12f2:	83 c4 10             	add    $0x10,%esp
    12f5:	85 d2                	test   %edx,%edx
    12f7:	74 2b                	je     1324 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12f9:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    12fb:	8b 48 04             	mov    0x4(%eax),%ecx
    12fe:	39 d9                	cmp    %ebx,%ecx
    1300:	73 b5                	jae    12b7 <malloc+0x64>
    1302:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1304:	39 05 e4 1a 00 00    	cmp    %eax,0x1ae4
    130a:	75 ed                	jne    12f9 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    130c:	83 ec 0c             	sub    $0xc,%esp
    130f:	57                   	push   %edi
    1310:	e8 1e fc ff ff       	call   f33 <sbrk>
  if(p == (char*)-1)
    1315:	83 c4 10             	add    $0x10,%esp
    1318:	83 f8 ff             	cmp    $0xffffffff,%eax
    131b:	75 c0                	jne    12dd <malloc+0x8a>
        return 0;
    131d:	b8 00 00 00 00       	mov    $0x0,%eax
    1322:	eb ab                	jmp    12cf <malloc+0x7c>
    1324:	b8 00 00 00 00       	mov    $0x0,%eax
    1329:	eb a4                	jmp    12cf <malloc+0x7c>
