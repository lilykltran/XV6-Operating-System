
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
       6:	68 44 3d 00 00       	push   $0x3d44
       b:	ff 35 10 5d 00 00    	pushl  0x5d10
      11:	e8 83 39 00 00       	call   3999 <printf>

  if(mkdir("iputdir") < 0){
      16:	c7 04 24 d7 3c 00 00 	movl   $0x3cd7,(%esp)
      1d:	e8 75 38 00 00       	call   3897 <mkdir>
      22:	83 c4 10             	add    $0x10,%esp
      25:	85 c0                	test   %eax,%eax
      27:	78 54                	js     7d <iputtest+0x7d>
    printf(stdout, "mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
      29:	83 ec 0c             	sub    $0xc,%esp
      2c:	68 d7 3c 00 00       	push   $0x3cd7
      31:	e8 69 38 00 00       	call   389f <chdir>
      36:	83 c4 10             	add    $0x10,%esp
      39:	85 c0                	test   %eax,%eax
      3b:	78 58                	js     95 <iputtest+0x95>
    printf(stdout, "chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
      3d:	83 ec 0c             	sub    $0xc,%esp
      40:	68 d4 3c 00 00       	push   $0x3cd4
      45:	e8 35 38 00 00       	call   387f <unlink>
      4a:	83 c4 10             	add    $0x10,%esp
      4d:	85 c0                	test   %eax,%eax
      4f:	78 5c                	js     ad <iputtest+0xad>
    printf(stdout, "unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
      51:	83 ec 0c             	sub    $0xc,%esp
      54:	68 f9 3c 00 00       	push   $0x3cf9
      59:	e8 41 38 00 00       	call   389f <chdir>
      5e:	83 c4 10             	add    $0x10,%esp
      61:	85 c0                	test   %eax,%eax
      63:	78 60                	js     c5 <iputtest+0xc5>
    printf(stdout, "chdir / failed\n");
    exit();
  }
  printf(stdout, "iput test ok\n");
      65:	83 ec 08             	sub    $0x8,%esp
      68:	68 7c 3d 00 00       	push   $0x3d7c
      6d:	ff 35 10 5d 00 00    	pushl  0x5d10
      73:	e8 21 39 00 00       	call   3999 <printf>
}
      78:	83 c4 10             	add    $0x10,%esp
      7b:	c9                   	leave  
      7c:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
      7d:	83 ec 08             	sub    $0x8,%esp
      80:	68 b0 3c 00 00       	push   $0x3cb0
      85:	ff 35 10 5d 00 00    	pushl  0x5d10
      8b:	e8 09 39 00 00       	call   3999 <printf>
    exit();
      90:	e8 9a 37 00 00       	call   382f <exit>
    printf(stdout, "chdir iputdir failed\n");
      95:	83 ec 08             	sub    $0x8,%esp
      98:	68 be 3c 00 00       	push   $0x3cbe
      9d:	ff 35 10 5d 00 00    	pushl  0x5d10
      a3:	e8 f1 38 00 00       	call   3999 <printf>
    exit();
      a8:	e8 82 37 00 00       	call   382f <exit>
    printf(stdout, "unlink ../iputdir failed\n");
      ad:	83 ec 08             	sub    $0x8,%esp
      b0:	68 df 3c 00 00       	push   $0x3cdf
      b5:	ff 35 10 5d 00 00    	pushl  0x5d10
      bb:	e8 d9 38 00 00       	call   3999 <printf>
    exit();
      c0:	e8 6a 37 00 00       	call   382f <exit>
    printf(stdout, "chdir / failed\n");
      c5:	83 ec 08             	sub    $0x8,%esp
      c8:	68 fb 3c 00 00       	push   $0x3cfb
      cd:	ff 35 10 5d 00 00    	pushl  0x5d10
      d3:	e8 c1 38 00 00       	call   3999 <printf>
    exit();
      d8:	e8 52 37 00 00       	call   382f <exit>

000000dd <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      dd:	55                   	push   %ebp
      de:	89 e5                	mov    %esp,%ebp
      e0:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      e3:	68 0b 3d 00 00       	push   $0x3d0b
      e8:	ff 35 10 5d 00 00    	pushl  0x5d10
      ee:	e8 a6 38 00 00       	call   3999 <printf>

  pid = fork();
      f3:	e8 2f 37 00 00       	call   3827 <fork>
  if(pid < 0){
      f8:	83 c4 10             	add    $0x10,%esp
      fb:	85 c0                	test   %eax,%eax
      fd:	78 49                	js     148 <exitiputtest+0x6b>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
      ff:	85 c0                	test   %eax,%eax
     101:	0f 85 a1 00 00 00    	jne    1a8 <exitiputtest+0xcb>
    if(mkdir("iputdir") < 0){
     107:	83 ec 0c             	sub    $0xc,%esp
     10a:	68 d7 3c 00 00       	push   $0x3cd7
     10f:	e8 83 37 00 00       	call   3897 <mkdir>
     114:	83 c4 10             	add    $0x10,%esp
     117:	85 c0                	test   %eax,%eax
     119:	78 45                	js     160 <exitiputtest+0x83>
      printf(stdout, "mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
     11b:	83 ec 0c             	sub    $0xc,%esp
     11e:	68 d7 3c 00 00       	push   $0x3cd7
     123:	e8 77 37 00 00       	call   389f <chdir>
     128:	83 c4 10             	add    $0x10,%esp
     12b:	85 c0                	test   %eax,%eax
     12d:	78 49                	js     178 <exitiputtest+0x9b>
      printf(stdout, "child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
     12f:	83 ec 0c             	sub    $0xc,%esp
     132:	68 d4 3c 00 00       	push   $0x3cd4
     137:	e8 43 37 00 00       	call   387f <unlink>
     13c:	83 c4 10             	add    $0x10,%esp
     13f:	85 c0                	test   %eax,%eax
     141:	78 4d                	js     190 <exitiputtest+0xb3>
      printf(stdout, "unlink ../iputdir failed\n");
      exit();
    }
    exit();
     143:	e8 e7 36 00 00       	call   382f <exit>
    printf(stdout, "fork failed\n");
     148:	83 ec 08             	sub    $0x8,%esp
     14b:	68 f1 4b 00 00       	push   $0x4bf1
     150:	ff 35 10 5d 00 00    	pushl  0x5d10
     156:	e8 3e 38 00 00       	call   3999 <printf>
    exit();
     15b:	e8 cf 36 00 00       	call   382f <exit>
      printf(stdout, "mkdir failed\n");
     160:	83 ec 08             	sub    $0x8,%esp
     163:	68 b0 3c 00 00       	push   $0x3cb0
     168:	ff 35 10 5d 00 00    	pushl  0x5d10
     16e:	e8 26 38 00 00       	call   3999 <printf>
      exit();
     173:	e8 b7 36 00 00       	call   382f <exit>
      printf(stdout, "child chdir failed\n");
     178:	83 ec 08             	sub    $0x8,%esp
     17b:	68 1a 3d 00 00       	push   $0x3d1a
     180:	ff 35 10 5d 00 00    	pushl  0x5d10
     186:	e8 0e 38 00 00       	call   3999 <printf>
      exit();
     18b:	e8 9f 36 00 00       	call   382f <exit>
      printf(stdout, "unlink ../iputdir failed\n");
     190:	83 ec 08             	sub    $0x8,%esp
     193:	68 df 3c 00 00       	push   $0x3cdf
     198:	ff 35 10 5d 00 00    	pushl  0x5d10
     19e:	e8 f6 37 00 00       	call   3999 <printf>
      exit();
     1a3:	e8 87 36 00 00       	call   382f <exit>
  }
  wait();
     1a8:	e8 8a 36 00 00       	call   3837 <wait>
  printf(stdout, "exitiput test ok\n");
     1ad:	83 ec 08             	sub    $0x8,%esp
     1b0:	68 2e 3d 00 00       	push   $0x3d2e
     1b5:	ff 35 10 5d 00 00    	pushl  0x5d10
     1bb:	e8 d9 37 00 00       	call   3999 <printf>
}
     1c0:	83 c4 10             	add    $0x10,%esp
     1c3:	c9                   	leave  
     1c4:	c3                   	ret    

000001c5 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c5:	55                   	push   %ebp
     1c6:	89 e5                	mov    %esp,%ebp
     1c8:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1cb:	68 40 3d 00 00       	push   $0x3d40
     1d0:	ff 35 10 5d 00 00    	pushl  0x5d10
     1d6:	e8 be 37 00 00       	call   3999 <printf>
  if(mkdir("oidir") < 0){
     1db:	c7 04 24 4f 3d 00 00 	movl   $0x3d4f,(%esp)
     1e2:	e8 b0 36 00 00       	call   3897 <mkdir>
     1e7:	83 c4 10             	add    $0x10,%esp
     1ea:	85 c0                	test   %eax,%eax
     1ec:	78 3b                	js     229 <openiputtest+0x64>
    printf(stdout, "mkdir oidir failed\n");
    exit();
  }
  pid = fork();
     1ee:	e8 34 36 00 00       	call   3827 <fork>
  if(pid < 0){
     1f3:	85 c0                	test   %eax,%eax
     1f5:	78 4a                	js     241 <openiputtest+0x7c>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
     1f7:	85 c0                	test   %eax,%eax
     1f9:	75 63                	jne    25e <openiputtest+0x99>
    int fd = open("oidir", O_RDWR);
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	6a 02                	push   $0x2
     200:	68 4f 3d 00 00       	push   $0x3d4f
     205:	e8 65 36 00 00       	call   386f <open>
    if(fd >= 0){
     20a:	83 c4 10             	add    $0x10,%esp
     20d:	85 c0                	test   %eax,%eax
     20f:	78 48                	js     259 <openiputtest+0x94>
      printf(stdout, "open directory for write succeeded\n");
     211:	83 ec 08             	sub    $0x8,%esp
     214:	68 d4 4c 00 00       	push   $0x4cd4
     219:	ff 35 10 5d 00 00    	pushl  0x5d10
     21f:	e8 75 37 00 00       	call   3999 <printf>
      exit();
     224:	e8 06 36 00 00       	call   382f <exit>
    printf(stdout, "mkdir oidir failed\n");
     229:	83 ec 08             	sub    $0x8,%esp
     22c:	68 55 3d 00 00       	push   $0x3d55
     231:	ff 35 10 5d 00 00    	pushl  0x5d10
     237:	e8 5d 37 00 00       	call   3999 <printf>
    exit();
     23c:	e8 ee 35 00 00       	call   382f <exit>
    printf(stdout, "fork failed\n");
     241:	83 ec 08             	sub    $0x8,%esp
     244:	68 f1 4b 00 00       	push   $0x4bf1
     249:	ff 35 10 5d 00 00    	pushl  0x5d10
     24f:	e8 45 37 00 00       	call   3999 <printf>
    exit();
     254:	e8 d6 35 00 00       	call   382f <exit>
    }
    exit();
     259:	e8 d1 35 00 00       	call   382f <exit>
  }
  sleep(1);
     25e:	83 ec 0c             	sub    $0xc,%esp
     261:	6a 01                	push   $0x1
     263:	e8 57 36 00 00       	call   38bf <sleep>
  if(unlink("oidir") != 0){
     268:	c7 04 24 4f 3d 00 00 	movl   $0x3d4f,(%esp)
     26f:	e8 0b 36 00 00       	call   387f <unlink>
     274:	83 c4 10             	add    $0x10,%esp
     277:	85 c0                	test   %eax,%eax
     279:	75 1d                	jne    298 <openiputtest+0xd3>
    printf(stdout, "unlink failed\n");
    exit();
  }
  wait();
     27b:	e8 b7 35 00 00       	call   3837 <wait>
  printf(stdout, "openiput test ok\n");
     280:	83 ec 08             	sub    $0x8,%esp
     283:	68 78 3d 00 00       	push   $0x3d78
     288:	ff 35 10 5d 00 00    	pushl  0x5d10
     28e:	e8 06 37 00 00       	call   3999 <printf>
}
     293:	83 c4 10             	add    $0x10,%esp
     296:	c9                   	leave  
     297:	c3                   	ret    
    printf(stdout, "unlink failed\n");
     298:	83 ec 08             	sub    $0x8,%esp
     29b:	68 69 3d 00 00       	push   $0x3d69
     2a0:	ff 35 10 5d 00 00    	pushl  0x5d10
     2a6:	e8 ee 36 00 00       	call   3999 <printf>
    exit();
     2ab:	e8 7f 35 00 00       	call   382f <exit>

000002b0 <opentest>:

// simple file system tests

void
opentest(void)
{
     2b0:	55                   	push   %ebp
     2b1:	89 e5                	mov    %esp,%ebp
     2b3:	83 ec 10             	sub    $0x10,%esp
  int fd;

  printf(stdout, "open test\n");
     2b6:	68 8a 3d 00 00       	push   $0x3d8a
     2bb:	ff 35 10 5d 00 00    	pushl  0x5d10
     2c1:	e8 d3 36 00 00       	call   3999 <printf>
  fd = open("echo", 0);
     2c6:	83 c4 08             	add    $0x8,%esp
     2c9:	6a 00                	push   $0x0
     2cb:	68 95 3d 00 00       	push   $0x3d95
     2d0:	e8 9a 35 00 00       	call   386f <open>
  if(fd < 0){
     2d5:	83 c4 10             	add    $0x10,%esp
     2d8:	85 c0                	test   %eax,%eax
     2da:	78 37                	js     313 <opentest+0x63>
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
     2dc:	83 ec 0c             	sub    $0xc,%esp
     2df:	50                   	push   %eax
     2e0:	e8 72 35 00 00       	call   3857 <close>
  fd = open("doesnotexist", 0);
     2e5:	83 c4 08             	add    $0x8,%esp
     2e8:	6a 00                	push   $0x0
     2ea:	68 ad 3d 00 00       	push   $0x3dad
     2ef:	e8 7b 35 00 00       	call   386f <open>
  if(fd >= 0){
     2f4:	83 c4 10             	add    $0x10,%esp
     2f7:	85 c0                	test   %eax,%eax
     2f9:	79 30                	jns    32b <opentest+0x7b>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
     2fb:	83 ec 08             	sub    $0x8,%esp
     2fe:	68 d8 3d 00 00       	push   $0x3dd8
     303:	ff 35 10 5d 00 00    	pushl  0x5d10
     309:	e8 8b 36 00 00       	call   3999 <printf>
}
     30e:	83 c4 10             	add    $0x10,%esp
     311:	c9                   	leave  
     312:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     313:	83 ec 08             	sub    $0x8,%esp
     316:	68 9a 3d 00 00       	push   $0x3d9a
     31b:	ff 35 10 5d 00 00    	pushl  0x5d10
     321:	e8 73 36 00 00       	call   3999 <printf>
    exit();
     326:	e8 04 35 00 00       	call   382f <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     32b:	83 ec 08             	sub    $0x8,%esp
     32e:	68 ba 3d 00 00       	push   $0x3dba
     333:	ff 35 10 5d 00 00    	pushl  0x5d10
     339:	e8 5b 36 00 00       	call   3999 <printf>
    exit();
     33e:	e8 ec 34 00 00       	call   382f <exit>

00000343 <writetest>:

void
writetest(void)
{
     343:	55                   	push   %ebp
     344:	89 e5                	mov    %esp,%ebp
     346:	56                   	push   %esi
     347:	53                   	push   %ebx
  int fd;
  int i;

  printf(stdout, "small file test\n");
     348:	83 ec 08             	sub    $0x8,%esp
     34b:	68 e6 3d 00 00       	push   $0x3de6
     350:	ff 35 10 5d 00 00    	pushl  0x5d10
     356:	e8 3e 36 00 00       	call   3999 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     35b:	83 c4 08             	add    $0x8,%esp
     35e:	68 02 02 00 00       	push   $0x202
     363:	68 f7 3d 00 00       	push   $0x3df7
     368:	e8 02 35 00 00       	call   386f <open>
  if(fd >= 0){
     36d:	83 c4 10             	add    $0x10,%esp
     370:	85 c0                	test   %eax,%eax
     372:	0f 88 17 01 00 00    	js     48f <writetest+0x14c>
     378:	89 c6                	mov    %eax,%esi
    printf(stdout, "creat small succeeded; ok\n");
     37a:	83 ec 08             	sub    $0x8,%esp
     37d:	68 fd 3d 00 00       	push   $0x3dfd
     382:	ff 35 10 5d 00 00    	pushl  0x5d10
     388:	e8 0c 36 00 00       	call   3999 <printf>
     38d:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     390:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     395:	83 ec 04             	sub    $0x4,%esp
     398:	6a 0a                	push   $0xa
     39a:	68 34 3e 00 00       	push   $0x3e34
     39f:	56                   	push   %esi
     3a0:	e8 aa 34 00 00       	call   384f <write>
     3a5:	83 c4 10             	add    $0x10,%esp
     3a8:	83 f8 0a             	cmp    $0xa,%eax
     3ab:	0f 85 f6 00 00 00    	jne    4a7 <writetest+0x164>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     3b1:	83 ec 04             	sub    $0x4,%esp
     3b4:	6a 0a                	push   $0xa
     3b6:	68 3f 3e 00 00       	push   $0x3e3f
     3bb:	56                   	push   %esi
     3bc:	e8 8e 34 00 00       	call   384f <write>
     3c1:	83 c4 10             	add    $0x10,%esp
     3c4:	83 f8 0a             	cmp    $0xa,%eax
     3c7:	0f 85 f3 00 00 00    	jne    4c0 <writetest+0x17d>
  for(i = 0; i < 100; i++){
     3cd:	83 c3 01             	add    $0x1,%ebx
     3d0:	83 fb 64             	cmp    $0x64,%ebx
     3d3:	75 c0                	jne    395 <writetest+0x52>
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     3d5:	83 ec 08             	sub    $0x8,%esp
     3d8:	68 4a 3e 00 00       	push   $0x3e4a
     3dd:	ff 35 10 5d 00 00    	pushl  0x5d10
     3e3:	e8 b1 35 00 00       	call   3999 <printf>
  close(fd);
     3e8:	89 34 24             	mov    %esi,(%esp)
     3eb:	e8 67 34 00 00       	call   3857 <close>
  fd = open("small", O_RDONLY);
     3f0:	83 c4 08             	add    $0x8,%esp
     3f3:	6a 00                	push   $0x0
     3f5:	68 f7 3d 00 00       	push   $0x3df7
     3fa:	e8 70 34 00 00       	call   386f <open>
     3ff:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     401:	83 c4 10             	add    $0x10,%esp
     404:	85 c0                	test   %eax,%eax
     406:	0f 88 cd 00 00 00    	js     4d9 <writetest+0x196>
    printf(stdout, "open small succeeded ok\n");
     40c:	83 ec 08             	sub    $0x8,%esp
     40f:	68 55 3e 00 00       	push   $0x3e55
     414:	ff 35 10 5d 00 00    	pushl  0x5d10
     41a:	e8 7a 35 00 00       	call   3999 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     41f:	83 c4 0c             	add    $0xc,%esp
     422:	68 d0 07 00 00       	push   $0x7d0
     427:	68 00 85 00 00       	push   $0x8500
     42c:	53                   	push   %ebx
     42d:	e8 15 34 00 00       	call   3847 <read>
  if(i == 2000){
     432:	83 c4 10             	add    $0x10,%esp
     435:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     43a:	0f 85 b1 00 00 00    	jne    4f1 <writetest+0x1ae>
    printf(stdout, "read succeeded ok\n");
     440:	83 ec 08             	sub    $0x8,%esp
     443:	68 89 3e 00 00       	push   $0x3e89
     448:	ff 35 10 5d 00 00    	pushl  0x5d10
     44e:	e8 46 35 00 00       	call   3999 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     453:	89 1c 24             	mov    %ebx,(%esp)
     456:	e8 fc 33 00 00       	call   3857 <close>

  if(unlink("small") < 0){
     45b:	c7 04 24 f7 3d 00 00 	movl   $0x3df7,(%esp)
     462:	e8 18 34 00 00       	call   387f <unlink>
     467:	83 c4 10             	add    $0x10,%esp
     46a:	85 c0                	test   %eax,%eax
     46c:	0f 88 97 00 00 00    	js     509 <writetest+0x1c6>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
     472:	83 ec 08             	sub    $0x8,%esp
     475:	68 b1 3e 00 00       	push   $0x3eb1
     47a:	ff 35 10 5d 00 00    	pushl  0x5d10
     480:	e8 14 35 00 00       	call   3999 <printf>
}
     485:	83 c4 10             	add    $0x10,%esp
     488:	8d 65 f8             	lea    -0x8(%ebp),%esp
     48b:	5b                   	pop    %ebx
     48c:	5e                   	pop    %esi
     48d:	5d                   	pop    %ebp
     48e:	c3                   	ret    
    printf(stdout, "error: creat small failed!\n");
     48f:	83 ec 08             	sub    $0x8,%esp
     492:	68 18 3e 00 00       	push   $0x3e18
     497:	ff 35 10 5d 00 00    	pushl  0x5d10
     49d:	e8 f7 34 00 00       	call   3999 <printf>
    exit();
     4a2:	e8 88 33 00 00       	call   382f <exit>
      printf(stdout, "error: write aa %d new file failed\n", i);
     4a7:	83 ec 04             	sub    $0x4,%esp
     4aa:	53                   	push   %ebx
     4ab:	68 f8 4c 00 00       	push   $0x4cf8
     4b0:	ff 35 10 5d 00 00    	pushl  0x5d10
     4b6:	e8 de 34 00 00       	call   3999 <printf>
      exit();
     4bb:	e8 6f 33 00 00       	call   382f <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     4c0:	83 ec 04             	sub    $0x4,%esp
     4c3:	53                   	push   %ebx
     4c4:	68 1c 4d 00 00       	push   $0x4d1c
     4c9:	ff 35 10 5d 00 00    	pushl  0x5d10
     4cf:	e8 c5 34 00 00       	call   3999 <printf>
      exit();
     4d4:	e8 56 33 00 00       	call   382f <exit>
    printf(stdout, "error: open small failed!\n");
     4d9:	83 ec 08             	sub    $0x8,%esp
     4dc:	68 6e 3e 00 00       	push   $0x3e6e
     4e1:	ff 35 10 5d 00 00    	pushl  0x5d10
     4e7:	e8 ad 34 00 00       	call   3999 <printf>
    exit();
     4ec:	e8 3e 33 00 00       	call   382f <exit>
    printf(stdout, "read failed\n");
     4f1:	83 ec 08             	sub    $0x8,%esp
     4f4:	68 b5 41 00 00       	push   $0x41b5
     4f9:	ff 35 10 5d 00 00    	pushl  0x5d10
     4ff:	e8 95 34 00 00       	call   3999 <printf>
    exit();
     504:	e8 26 33 00 00       	call   382f <exit>
    printf(stdout, "unlink small failed\n");
     509:	83 ec 08             	sub    $0x8,%esp
     50c:	68 9c 3e 00 00       	push   $0x3e9c
     511:	ff 35 10 5d 00 00    	pushl  0x5d10
     517:	e8 7d 34 00 00       	call   3999 <printf>
    exit();
     51c:	e8 0e 33 00 00       	call   382f <exit>

00000521 <writetest1>:

void
writetest1(void)
{
     521:	55                   	push   %ebp
     522:	89 e5                	mov    %esp,%ebp
     524:	56                   	push   %esi
     525:	53                   	push   %ebx
  int i, fd, n;

  printf(stdout, "big files test\n");
     526:	83 ec 08             	sub    $0x8,%esp
     529:	68 c5 3e 00 00       	push   $0x3ec5
     52e:	ff 35 10 5d 00 00    	pushl  0x5d10
     534:	e8 60 34 00 00       	call   3999 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     539:	83 c4 08             	add    $0x8,%esp
     53c:	68 02 02 00 00       	push   $0x202
     541:	68 3f 3f 00 00       	push   $0x3f3f
     546:	e8 24 33 00 00       	call   386f <open>
  if(fd < 0){
     54b:	83 c4 10             	add    $0x10,%esp
     54e:	85 c0                	test   %eax,%eax
     550:	0f 88 96 00 00 00    	js     5ec <writetest1+0xcb>
     556:	89 c6                	mov    %eax,%esi
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     558:	bb 00 00 00 00       	mov    $0x0,%ebx
    ((int*)buf)[0] = i;
     55d:	89 1d 00 85 00 00    	mov    %ebx,0x8500
    if(write(fd, buf, 512) != 512){
     563:	83 ec 04             	sub    $0x4,%esp
     566:	68 00 02 00 00       	push   $0x200
     56b:	68 00 85 00 00       	push   $0x8500
     570:	56                   	push   %esi
     571:	e8 d9 32 00 00       	call   384f <write>
     576:	83 c4 10             	add    $0x10,%esp
     579:	3d 00 02 00 00       	cmp    $0x200,%eax
     57e:	0f 85 80 00 00 00    	jne    604 <writetest1+0xe3>
  for(i = 0; i < MAXFILE; i++){
     584:	83 c3 01             	add    $0x1,%ebx
     587:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     58d:	75 ce                	jne    55d <writetest1+0x3c>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     58f:	83 ec 0c             	sub    $0xc,%esp
     592:	56                   	push   %esi
     593:	e8 bf 32 00 00       	call   3857 <close>

  fd = open("big", O_RDONLY);
     598:	83 c4 08             	add    $0x8,%esp
     59b:	6a 00                	push   $0x0
     59d:	68 3f 3f 00 00       	push   $0x3f3f
     5a2:	e8 c8 32 00 00       	call   386f <open>
     5a7:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     5a9:	83 c4 10             	add    $0x10,%esp
     5ac:	85 c0                	test   %eax,%eax
     5ae:	78 6d                	js     61d <writetest1+0xfc>
    printf(stdout, "error: open big failed!\n");
    exit();
  }

  n = 0;
     5b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(;;){
    i = read(fd, buf, 512);
     5b5:	83 ec 04             	sub    $0x4,%esp
     5b8:	68 00 02 00 00       	push   $0x200
     5bd:	68 00 85 00 00       	push   $0x8500
     5c2:	56                   	push   %esi
     5c3:	e8 7f 32 00 00       	call   3847 <read>
    if(i == 0){
     5c8:	83 c4 10             	add    $0x10,%esp
     5cb:	85 c0                	test   %eax,%eax
     5cd:	74 66                	je     635 <writetest1+0x114>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     5cf:	3d 00 02 00 00       	cmp    $0x200,%eax
     5d4:	0f 85 b9 00 00 00    	jne    693 <writetest1+0x172>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
     5da:	a1 00 85 00 00       	mov    0x8500,%eax
     5df:	39 d8                	cmp    %ebx,%eax
     5e1:	0f 85 c5 00 00 00    	jne    6ac <writetest1+0x18b>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
     5e7:	83 c3 01             	add    $0x1,%ebx
    i = read(fd, buf, 512);
     5ea:	eb c9                	jmp    5b5 <writetest1+0x94>
    printf(stdout, "error: creat big failed!\n");
     5ec:	83 ec 08             	sub    $0x8,%esp
     5ef:	68 d5 3e 00 00       	push   $0x3ed5
     5f4:	ff 35 10 5d 00 00    	pushl  0x5d10
     5fa:	e8 9a 33 00 00       	call   3999 <printf>
    exit();
     5ff:	e8 2b 32 00 00       	call   382f <exit>
      printf(stdout, "error: write big file failed\n", i);
     604:	83 ec 04             	sub    $0x4,%esp
     607:	53                   	push   %ebx
     608:	68 ef 3e 00 00       	push   $0x3eef
     60d:	ff 35 10 5d 00 00    	pushl  0x5d10
     613:	e8 81 33 00 00       	call   3999 <printf>
      exit();
     618:	e8 12 32 00 00       	call   382f <exit>
    printf(stdout, "error: open big failed!\n");
     61d:	83 ec 08             	sub    $0x8,%esp
     620:	68 0d 3f 00 00       	push   $0x3f0d
     625:	ff 35 10 5d 00 00    	pushl  0x5d10
     62b:	e8 69 33 00 00       	call   3999 <printf>
    exit();
     630:	e8 fa 31 00 00       	call   382f <exit>
      if(n == MAXFILE - 1){
     635:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     63b:	74 39                	je     676 <writetest1+0x155>
  }
  close(fd);
     63d:	83 ec 0c             	sub    $0xc,%esp
     640:	56                   	push   %esi
     641:	e8 11 32 00 00       	call   3857 <close>
  if(unlink("big") < 0){
     646:	c7 04 24 3f 3f 00 00 	movl   $0x3f3f,(%esp)
     64d:	e8 2d 32 00 00       	call   387f <unlink>
     652:	83 c4 10             	add    $0x10,%esp
     655:	85 c0                	test   %eax,%eax
     657:	78 6a                	js     6c3 <writetest1+0x1a2>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
     659:	83 ec 08             	sub    $0x8,%esp
     65c:	68 66 3f 00 00       	push   $0x3f66
     661:	ff 35 10 5d 00 00    	pushl  0x5d10
     667:	e8 2d 33 00 00       	call   3999 <printf>
}
     66c:	83 c4 10             	add    $0x10,%esp
     66f:	8d 65 f8             	lea    -0x8(%ebp),%esp
     672:	5b                   	pop    %ebx
     673:	5e                   	pop    %esi
     674:	5d                   	pop    %ebp
     675:	c3                   	ret    
        printf(stdout, "read only %d blocks from big", n);
     676:	83 ec 04             	sub    $0x4,%esp
     679:	68 8b 00 00 00       	push   $0x8b
     67e:	68 26 3f 00 00       	push   $0x3f26
     683:	ff 35 10 5d 00 00    	pushl  0x5d10
     689:	e8 0b 33 00 00       	call   3999 <printf>
        exit();
     68e:	e8 9c 31 00 00       	call   382f <exit>
      printf(stdout, "read failed %d\n", i);
     693:	83 ec 04             	sub    $0x4,%esp
     696:	50                   	push   %eax
     697:	68 43 3f 00 00       	push   $0x3f43
     69c:	ff 35 10 5d 00 00    	pushl  0x5d10
     6a2:	e8 f2 32 00 00       	call   3999 <printf>
      exit();
     6a7:	e8 83 31 00 00       	call   382f <exit>
      printf(stdout, "read content of block %d is %d\n",
     6ac:	50                   	push   %eax
     6ad:	53                   	push   %ebx
     6ae:	68 40 4d 00 00       	push   $0x4d40
     6b3:	ff 35 10 5d 00 00    	pushl  0x5d10
     6b9:	e8 db 32 00 00       	call   3999 <printf>
      exit();
     6be:	e8 6c 31 00 00       	call   382f <exit>
    printf(stdout, "unlink big failed\n");
     6c3:	83 ec 08             	sub    $0x8,%esp
     6c6:	68 53 3f 00 00       	push   $0x3f53
     6cb:	ff 35 10 5d 00 00    	pushl  0x5d10
     6d1:	e8 c3 32 00 00       	call   3999 <printf>
    exit();
     6d6:	e8 54 31 00 00       	call   382f <exit>

000006db <createtest>:

void
createtest(void)
{
     6db:	55                   	push   %ebp
     6dc:	89 e5                	mov    %esp,%ebp
     6de:	53                   	push   %ebx
     6df:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     6e2:	68 60 4d 00 00       	push   $0x4d60
     6e7:	ff 35 10 5d 00 00    	pushl  0x5d10
     6ed:	e8 a7 32 00 00       	call   3999 <printf>

  name[0] = 'a';
     6f2:	c6 05 00 a5 00 00 61 	movb   $0x61,0xa500
  name[2] = '\0';
     6f9:	c6 05 02 a5 00 00 00 	movb   $0x0,0xa502
     700:	83 c4 10             	add    $0x10,%esp
     703:	bb 30 00 00 00       	mov    $0x30,%ebx
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     708:	88 1d 01 a5 00 00    	mov    %bl,0xa501
    fd = open(name, O_CREATE|O_RDWR);
     70e:	83 ec 08             	sub    $0x8,%esp
     711:	68 02 02 00 00       	push   $0x202
     716:	68 00 a5 00 00       	push   $0xa500
     71b:	e8 4f 31 00 00       	call   386f <open>
    close(fd);
     720:	89 04 24             	mov    %eax,(%esp)
     723:	e8 2f 31 00 00       	call   3857 <close>
     728:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; i < 52; i++){
     72b:	83 c4 10             	add    $0x10,%esp
     72e:	80 fb 64             	cmp    $0x64,%bl
     731:	75 d5                	jne    708 <createtest+0x2d>
  }
  name[0] = 'a';
     733:	c6 05 00 a5 00 00 61 	movb   $0x61,0xa500
  name[2] = '\0';
     73a:	c6 05 02 a5 00 00 00 	movb   $0x0,0xa502
     741:	bb 30 00 00 00       	mov    $0x30,%ebx
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     746:	88 1d 01 a5 00 00    	mov    %bl,0xa501
    unlink(name);
     74c:	83 ec 0c             	sub    $0xc,%esp
     74f:	68 00 a5 00 00       	push   $0xa500
     754:	e8 26 31 00 00       	call   387f <unlink>
     759:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; i < 52; i++){
     75c:	83 c4 10             	add    $0x10,%esp
     75f:	80 fb 64             	cmp    $0x64,%bl
     762:	75 e2                	jne    746 <createtest+0x6b>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     764:	83 ec 08             	sub    $0x8,%esp
     767:	68 88 4d 00 00       	push   $0x4d88
     76c:	ff 35 10 5d 00 00    	pushl  0x5d10
     772:	e8 22 32 00 00       	call   3999 <printf>
}
     777:	83 c4 10             	add    $0x10,%esp
     77a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     77d:	c9                   	leave  
     77e:	c3                   	ret    

0000077f <dirtest>:

void dirtest(void)
{
     77f:	55                   	push   %ebp
     780:	89 e5                	mov    %esp,%ebp
     782:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     785:	68 74 3f 00 00       	push   $0x3f74
     78a:	ff 35 10 5d 00 00    	pushl  0x5d10
     790:	e8 04 32 00 00       	call   3999 <printf>

  if(mkdir("dir0") < 0){
     795:	c7 04 24 80 3f 00 00 	movl   $0x3f80,(%esp)
     79c:	e8 f6 30 00 00       	call   3897 <mkdir>
     7a1:	83 c4 10             	add    $0x10,%esp
     7a4:	85 c0                	test   %eax,%eax
     7a6:	78 54                	js     7fc <dirtest+0x7d>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
     7a8:	83 ec 0c             	sub    $0xc,%esp
     7ab:	68 80 3f 00 00       	push   $0x3f80
     7b0:	e8 ea 30 00 00       	call   389f <chdir>
     7b5:	83 c4 10             	add    $0x10,%esp
     7b8:	85 c0                	test   %eax,%eax
     7ba:	78 58                	js     814 <dirtest+0x95>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
     7bc:	83 ec 0c             	sub    $0xc,%esp
     7bf:	68 25 45 00 00       	push   $0x4525
     7c4:	e8 d6 30 00 00       	call   389f <chdir>
     7c9:	83 c4 10             	add    $0x10,%esp
     7cc:	85 c0                	test   %eax,%eax
     7ce:	78 5c                	js     82c <dirtest+0xad>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
     7d0:	83 ec 0c             	sub    $0xc,%esp
     7d3:	68 80 3f 00 00       	push   $0x3f80
     7d8:	e8 a2 30 00 00       	call   387f <unlink>
     7dd:	83 c4 10             	add    $0x10,%esp
     7e0:	85 c0                	test   %eax,%eax
     7e2:	78 60                	js     844 <dirtest+0xc5>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test ok\n");
     7e4:	83 ec 08             	sub    $0x8,%esp
     7e7:	68 bd 3f 00 00       	push   $0x3fbd
     7ec:	ff 35 10 5d 00 00    	pushl  0x5d10
     7f2:	e8 a2 31 00 00       	call   3999 <printf>
}
     7f7:	83 c4 10             	add    $0x10,%esp
     7fa:	c9                   	leave  
     7fb:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     7fc:	83 ec 08             	sub    $0x8,%esp
     7ff:	68 b0 3c 00 00       	push   $0x3cb0
     804:	ff 35 10 5d 00 00    	pushl  0x5d10
     80a:	e8 8a 31 00 00       	call   3999 <printf>
    exit();
     80f:	e8 1b 30 00 00       	call   382f <exit>
    printf(stdout, "chdir dir0 failed\n");
     814:	83 ec 08             	sub    $0x8,%esp
     817:	68 85 3f 00 00       	push   $0x3f85
     81c:	ff 35 10 5d 00 00    	pushl  0x5d10
     822:	e8 72 31 00 00       	call   3999 <printf>
    exit();
     827:	e8 03 30 00 00       	call   382f <exit>
    printf(stdout, "chdir .. failed\n");
     82c:	83 ec 08             	sub    $0x8,%esp
     82f:	68 98 3f 00 00       	push   $0x3f98
     834:	ff 35 10 5d 00 00    	pushl  0x5d10
     83a:	e8 5a 31 00 00       	call   3999 <printf>
    exit();
     83f:	e8 eb 2f 00 00       	call   382f <exit>
    printf(stdout, "unlink dir0 failed\n");
     844:	83 ec 08             	sub    $0x8,%esp
     847:	68 a9 3f 00 00       	push   $0x3fa9
     84c:	ff 35 10 5d 00 00    	pushl  0x5d10
     852:	e8 42 31 00 00       	call   3999 <printf>
    exit();
     857:	e8 d3 2f 00 00       	call   382f <exit>

0000085c <exectest>:

void
exectest(void)
{
     85c:	55                   	push   %ebp
     85d:	89 e5                	mov    %esp,%ebp
     85f:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     862:	68 cc 3f 00 00       	push   $0x3fcc
     867:	ff 35 10 5d 00 00    	pushl  0x5d10
     86d:	e8 27 31 00 00       	call   3999 <printf>
  if(exec("echo", echoargv) < 0){
     872:	83 c4 08             	add    $0x8,%esp
     875:	68 14 5d 00 00       	push   $0x5d14
     87a:	68 95 3d 00 00       	push   $0x3d95
     87f:	e8 e3 2f 00 00       	call   3867 <exec>
     884:	83 c4 10             	add    $0x10,%esp
     887:	85 c0                	test   %eax,%eax
     889:	78 02                	js     88d <exectest+0x31>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
     88b:	c9                   	leave  
     88c:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     88d:	83 ec 08             	sub    $0x8,%esp
     890:	68 d7 3f 00 00       	push   $0x3fd7
     895:	ff 35 10 5d 00 00    	pushl  0x5d10
     89b:	e8 f9 30 00 00       	call   3999 <printf>
    exit();
     8a0:	e8 8a 2f 00 00       	call   382f <exit>

000008a5 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     8a5:	55                   	push   %ebp
     8a6:	89 e5                	mov    %esp,%ebp
     8a8:	57                   	push   %edi
     8a9:	56                   	push   %esi
     8aa:	53                   	push   %ebx
     8ab:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     8ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
     8b1:	50                   	push   %eax
     8b2:	e8 88 2f 00 00       	call   383f <pipe>
     8b7:	83 c4 10             	add    $0x10,%esp
     8ba:	85 c0                	test   %eax,%eax
     8bc:	75 75                	jne    933 <pipe1+0x8e>
     8be:	89 c3                	mov    %eax,%ebx
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
     8c0:	e8 62 2f 00 00       	call   3827 <fork>
  seq = 0;
  if(pid == 0){
     8c5:	85 c0                	test   %eax,%eax
     8c7:	74 7e                	je     947 <pipe1+0xa2>
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
     8c9:	85 c0                	test   %eax,%eax
     8cb:	0f 8e 62 01 00 00    	jle    a33 <pipe1+0x18e>
    close(fds[1]);
     8d1:	83 ec 0c             	sub    $0xc,%esp
     8d4:	ff 75 e4             	pushl  -0x1c(%ebp)
     8d7:	e8 7b 2f 00 00       	call   3857 <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     8dc:	83 c4 10             	add    $0x10,%esp
    total = 0;
     8df:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    cc = 1;
     8e2:	be 01 00 00 00       	mov    $0x1,%esi
    while((n = read(fds[0], buf, cc)) > 0){
     8e7:	83 ec 04             	sub    $0x4,%esp
     8ea:	56                   	push   %esi
     8eb:	68 00 85 00 00       	push   $0x8500
     8f0:	ff 75 e0             	pushl  -0x20(%ebp)
     8f3:	e8 4f 2f 00 00       	call   3847 <read>
     8f8:	83 c4 10             	add    $0x10,%esp
     8fb:	85 c0                	test   %eax,%eax
     8fd:	0f 8e ec 00 00 00    	jle    9ef <pipe1+0x14a>
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     903:	8d 53 01             	lea    0x1(%ebx),%edx
     906:	38 1d 00 85 00 00    	cmp    %bl,0x8500
     90c:	0f 85 a9 00 00 00    	jne    9bb <pipe1+0x116>
     912:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
     915:	f7 db                	neg    %ebx
      for(i = 0; i < n; i++){
     917:	39 d7                	cmp    %edx,%edi
     919:	0f 84 b6 00 00 00    	je     9d5 <pipe1+0x130>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     91f:	8d 4a 01             	lea    0x1(%edx),%ecx
     922:	38 94 13 00 85 00 00 	cmp    %dl,0x8500(%ebx,%edx,1)
     929:	0f 85 8c 00 00 00    	jne    9bb <pipe1+0x116>
     92f:	89 ca                	mov    %ecx,%edx
     931:	eb e4                	jmp    917 <pipe1+0x72>
    printf(1, "pipe() failed\n");
     933:	83 ec 08             	sub    $0x8,%esp
     936:	68 e9 3f 00 00       	push   $0x3fe9
     93b:	6a 01                	push   $0x1
     93d:	e8 57 30 00 00       	call   3999 <printf>
    exit();
     942:	e8 e8 2e 00 00       	call   382f <exit>
    close(fds[0]);
     947:	83 ec 0c             	sub    $0xc,%esp
     94a:	ff 75 e0             	pushl  -0x20(%ebp)
     94d:	e8 05 2f 00 00       	call   3857 <close>
     952:	83 c4 10             	add    $0x10,%esp
     955:	bb 00 00 00 00       	mov    $0x0,%ebx
     95a:	be 09 04 00 00       	mov    $0x409,%esi
     95f:	89 d8                	mov    %ebx,%eax
     961:	f7 d8                	neg    %eax
     963:	89 f2                	mov    %esi,%edx
     965:	29 da                	sub    %ebx,%edx
        buf[i] = seq++;
     967:	88 84 03 00 85 00 00 	mov    %al,0x8500(%ebx,%eax,1)
     96e:	83 c0 01             	add    $0x1,%eax
      for(i = 0; i < 1033; i++)
     971:	39 c2                	cmp    %eax,%edx
     973:	75 f2                	jne    967 <pipe1+0xc2>
      if(write(fds[1], buf, 1033) != 1033){
     975:	83 ec 04             	sub    $0x4,%esp
     978:	68 09 04 00 00       	push   $0x409
     97d:	68 00 85 00 00       	push   $0x8500
     982:	ff 75 e4             	pushl  -0x1c(%ebp)
     985:	e8 c5 2e 00 00       	call   384f <write>
     98a:	83 c4 10             	add    $0x10,%esp
     98d:	3d 09 04 00 00       	cmp    $0x409,%eax
     992:	75 13                	jne    9a7 <pipe1+0x102>
     994:	81 eb 09 04 00 00    	sub    $0x409,%ebx
    for(n = 0; n < 5; n++){
     99a:	81 fb d3 eb ff ff    	cmp    $0xffffebd3,%ebx
     9a0:	75 bd                	jne    95f <pipe1+0xba>
    exit();
     9a2:	e8 88 2e 00 00       	call   382f <exit>
        printf(1, "pipe1 oops 1\n");
     9a7:	83 ec 08             	sub    $0x8,%esp
     9aa:	68 f8 3f 00 00       	push   $0x3ff8
     9af:	6a 01                	push   $0x1
     9b1:	e8 e3 2f 00 00       	call   3999 <printf>
        exit();
     9b6:	e8 74 2e 00 00       	call   382f <exit>
          printf(1, "pipe1 oops 2\n");
     9bb:	83 ec 08             	sub    $0x8,%esp
     9be:	68 06 40 00 00       	push   $0x4006
     9c3:	6a 01                	push   $0x1
     9c5:	e8 cf 2f 00 00       	call   3999 <printf>
          return;
     9ca:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
     9cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9d0:	5b                   	pop    %ebx
     9d1:	5e                   	pop    %esi
     9d2:	5f                   	pop    %edi
     9d3:	5d                   	pop    %ebp
     9d4:	c3                   	ret    
      total += n;
     9d5:	01 45 d4             	add    %eax,-0x2c(%ebp)
      cc = cc * 2;
     9d8:	01 f6                	add    %esi,%esi
        cc = sizeof(buf);
     9da:	81 fe 01 20 00 00    	cmp    $0x2001,%esi
     9e0:	b8 00 20 00 00       	mov    $0x2000,%eax
     9e5:	0f 43 f0             	cmovae %eax,%esi
     9e8:	89 d3                	mov    %edx,%ebx
     9ea:	e9 f8 fe ff ff       	jmp    8e7 <pipe1+0x42>
    if(total != 5 * 1033){
     9ef:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     9f6:	75 24                	jne    a1c <pipe1+0x177>
    close(fds[0]);
     9f8:	83 ec 0c             	sub    $0xc,%esp
     9fb:	ff 75 e0             	pushl  -0x20(%ebp)
     9fe:	e8 54 2e 00 00       	call   3857 <close>
    wait();
     a03:	e8 2f 2e 00 00       	call   3837 <wait>
  printf(1, "pipe1 ok\n");
     a08:	83 c4 08             	add    $0x8,%esp
     a0b:	68 2b 40 00 00       	push   $0x402b
     a10:	6a 01                	push   $0x1
     a12:	e8 82 2f 00 00       	call   3999 <printf>
     a17:	83 c4 10             	add    $0x10,%esp
     a1a:	eb b1                	jmp    9cd <pipe1+0x128>
      printf(1, "pipe1 oops 3 total %d\n", total);
     a1c:	83 ec 04             	sub    $0x4,%esp
     a1f:	ff 75 d4             	pushl  -0x2c(%ebp)
     a22:	68 14 40 00 00       	push   $0x4014
     a27:	6a 01                	push   $0x1
     a29:	e8 6b 2f 00 00       	call   3999 <printf>
      exit();
     a2e:	e8 fc 2d 00 00       	call   382f <exit>
    printf(1, "fork() failed\n");
     a33:	83 ec 08             	sub    $0x8,%esp
     a36:	68 35 40 00 00       	push   $0x4035
     a3b:	6a 01                	push   $0x1
     a3d:	e8 57 2f 00 00       	call   3999 <printf>
    exit();
     a42:	e8 e8 2d 00 00       	call   382f <exit>

00000a47 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     a47:	55                   	push   %ebp
     a48:	89 e5                	mov    %esp,%ebp
     a4a:	57                   	push   %edi
     a4b:	56                   	push   %esi
     a4c:	53                   	push   %ebx
     a4d:	83 ec 24             	sub    $0x24,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     a50:	68 44 40 00 00       	push   $0x4044
     a55:	6a 01                	push   $0x1
     a57:	e8 3d 2f 00 00       	call   3999 <printf>
  pid1 = fork();
     a5c:	e8 c6 2d 00 00       	call   3827 <fork>
  if(pid1 == 0)
     a61:	83 c4 10             	add    $0x10,%esp
     a64:	85 c0                	test   %eax,%eax
     a66:	75 02                	jne    a6a <preempt+0x23>
     a68:	eb fe                	jmp    a68 <preempt+0x21>
     a6a:	89 c7                	mov    %eax,%edi
    for(;;)
      ;

  pid2 = fork();
     a6c:	e8 b6 2d 00 00       	call   3827 <fork>
     a71:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     a73:	85 c0                	test   %eax,%eax
     a75:	75 02                	jne    a79 <preempt+0x32>
     a77:	eb fe                	jmp    a77 <preempt+0x30>
    for(;;)
      ;

  pipe(pfds);
     a79:	83 ec 0c             	sub    $0xc,%esp
     a7c:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a7f:	50                   	push   %eax
     a80:	e8 ba 2d 00 00       	call   383f <pipe>
  pid3 = fork();
     a85:	e8 9d 2d 00 00       	call   3827 <fork>
     a8a:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     a8c:	83 c4 10             	add    $0x10,%esp
     a8f:	85 c0                	test   %eax,%eax
     a91:	75 47                	jne    ada <preempt+0x93>
    close(pfds[0]);
     a93:	83 ec 0c             	sub    $0xc,%esp
     a96:	ff 75 e0             	pushl  -0x20(%ebp)
     a99:	e8 b9 2d 00 00       	call   3857 <close>
    if(write(pfds[1], "x", 1) != 1)
     a9e:	83 c4 0c             	add    $0xc,%esp
     aa1:	6a 01                	push   $0x1
     aa3:	68 09 46 00 00       	push   $0x4609
     aa8:	ff 75 e4             	pushl  -0x1c(%ebp)
     aab:	e8 9f 2d 00 00       	call   384f <write>
     ab0:	83 c4 10             	add    $0x10,%esp
     ab3:	83 f8 01             	cmp    $0x1,%eax
     ab6:	74 12                	je     aca <preempt+0x83>
      printf(1, "preempt write error");
     ab8:	83 ec 08             	sub    $0x8,%esp
     abb:	68 4e 40 00 00       	push   $0x404e
     ac0:	6a 01                	push   $0x1
     ac2:	e8 d2 2e 00 00       	call   3999 <printf>
     ac7:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     aca:	83 ec 0c             	sub    $0xc,%esp
     acd:	ff 75 e4             	pushl  -0x1c(%ebp)
     ad0:	e8 82 2d 00 00       	call   3857 <close>
     ad5:	83 c4 10             	add    $0x10,%esp
     ad8:	eb fe                	jmp    ad8 <preempt+0x91>
    for(;;)
      ;
  }

  close(pfds[1]);
     ada:	83 ec 0c             	sub    $0xc,%esp
     add:	ff 75 e4             	pushl  -0x1c(%ebp)
     ae0:	e8 72 2d 00 00       	call   3857 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     ae5:	83 c4 0c             	add    $0xc,%esp
     ae8:	68 00 20 00 00       	push   $0x2000
     aed:	68 00 85 00 00       	push   $0x8500
     af2:	ff 75 e0             	pushl  -0x20(%ebp)
     af5:	e8 4d 2d 00 00       	call   3847 <read>
     afa:	83 c4 10             	add    $0x10,%esp
     afd:	83 f8 01             	cmp    $0x1,%eax
     b00:	74 1a                	je     b1c <preempt+0xd5>
    printf(1, "preempt read error");
     b02:	83 ec 08             	sub    $0x8,%esp
     b05:	68 62 40 00 00       	push   $0x4062
     b0a:	6a 01                	push   $0x1
     b0c:	e8 88 2e 00 00       	call   3999 <printf>
    return;
     b11:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
     b14:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b17:	5b                   	pop    %ebx
     b18:	5e                   	pop    %esi
     b19:	5f                   	pop    %edi
     b1a:	5d                   	pop    %ebp
     b1b:	c3                   	ret    
  close(pfds[0]);
     b1c:	83 ec 0c             	sub    $0xc,%esp
     b1f:	ff 75 e0             	pushl  -0x20(%ebp)
     b22:	e8 30 2d 00 00       	call   3857 <close>
  printf(1, "kill... ");
     b27:	83 c4 08             	add    $0x8,%esp
     b2a:	68 75 40 00 00       	push   $0x4075
     b2f:	6a 01                	push   $0x1
     b31:	e8 63 2e 00 00       	call   3999 <printf>
  kill(pid1);
     b36:	89 3c 24             	mov    %edi,(%esp)
     b39:	e8 21 2d 00 00       	call   385f <kill>
  kill(pid2);
     b3e:	89 34 24             	mov    %esi,(%esp)
     b41:	e8 19 2d 00 00       	call   385f <kill>
  kill(pid3);
     b46:	89 1c 24             	mov    %ebx,(%esp)
     b49:	e8 11 2d 00 00       	call   385f <kill>
  printf(1, "wait... ");
     b4e:	83 c4 08             	add    $0x8,%esp
     b51:	68 7e 40 00 00       	push   $0x407e
     b56:	6a 01                	push   $0x1
     b58:	e8 3c 2e 00 00       	call   3999 <printf>
  wait();
     b5d:	e8 d5 2c 00 00       	call   3837 <wait>
  wait();
     b62:	e8 d0 2c 00 00       	call   3837 <wait>
  wait();
     b67:	e8 cb 2c 00 00       	call   3837 <wait>
  printf(1, "preempt ok\n");
     b6c:	83 c4 08             	add    $0x8,%esp
     b6f:	68 87 40 00 00       	push   $0x4087
     b74:	6a 01                	push   $0x1
     b76:	e8 1e 2e 00 00       	call   3999 <printf>
     b7b:	83 c4 10             	add    $0x10,%esp
     b7e:	eb 94                	jmp    b14 <preempt+0xcd>

00000b80 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     b80:	55                   	push   %ebp
     b81:	89 e5                	mov    %esp,%ebp
     b83:	56                   	push   %esi
     b84:	53                   	push   %ebx
     b85:	be 64 00 00 00       	mov    $0x64,%esi
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
     b8a:	e8 98 2c 00 00       	call   3827 <fork>
     b8f:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     b91:	85 c0                	test   %eax,%eax
     b93:	78 26                	js     bbb <exitwait+0x3b>
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
     b95:	85 c0                	test   %eax,%eax
     b97:	74 4f                	je     be8 <exitwait+0x68>
      if(wait() != pid){
     b99:	e8 99 2c 00 00       	call   3837 <wait>
     b9e:	39 d8                	cmp    %ebx,%eax
     ba0:	75 32                	jne    bd4 <exitwait+0x54>
  for(i = 0; i < 100; i++){
     ba2:	83 ee 01             	sub    $0x1,%esi
     ba5:	75 e3                	jne    b8a <exitwait+0xa>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     ba7:	83 ec 08             	sub    $0x8,%esp
     baa:	68 a3 40 00 00       	push   $0x40a3
     baf:	6a 01                	push   $0x1
     bb1:	e8 e3 2d 00 00       	call   3999 <printf>
     bb6:	83 c4 10             	add    $0x10,%esp
     bb9:	eb 12                	jmp    bcd <exitwait+0x4d>
      printf(1, "fork failed\n");
     bbb:	83 ec 08             	sub    $0x8,%esp
     bbe:	68 f1 4b 00 00       	push   $0x4bf1
     bc3:	6a 01                	push   $0x1
     bc5:	e8 cf 2d 00 00       	call   3999 <printf>
      return;
     bca:	83 c4 10             	add    $0x10,%esp
}
     bcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
     bd0:	5b                   	pop    %ebx
     bd1:	5e                   	pop    %esi
     bd2:	5d                   	pop    %ebp
     bd3:	c3                   	ret    
        printf(1, "wait wrong pid\n");
     bd4:	83 ec 08             	sub    $0x8,%esp
     bd7:	68 93 40 00 00       	push   $0x4093
     bdc:	6a 01                	push   $0x1
     bde:	e8 b6 2d 00 00       	call   3999 <printf>
        return;
     be3:	83 c4 10             	add    $0x10,%esp
     be6:	eb e5                	jmp    bcd <exitwait+0x4d>
      exit();
     be8:	e8 42 2c 00 00       	call   382f <exit>

00000bed <mem>:

void
mem(void)
{
     bed:	55                   	push   %ebp
     bee:	89 e5                	mov    %esp,%ebp
     bf0:	57                   	push   %edi
     bf1:	56                   	push   %esi
     bf2:	53                   	push   %ebx
     bf3:	83 ec 14             	sub    $0x14,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     bf6:	68 b0 40 00 00       	push   $0x40b0
     bfb:	6a 01                	push   $0x1
     bfd:	e8 97 2d 00 00       	call   3999 <printf>
  ppid = getpid();
     c02:	e8 a8 2c 00 00       	call   38af <getpid>
     c07:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     c09:	e8 19 2c 00 00       	call   3827 <fork>
     c0e:	83 c4 10             	add    $0x10,%esp
    m1 = 0;
     c11:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((pid = fork()) == 0){
     c16:	85 c0                	test   %eax,%eax
     c18:	74 11                	je     c2b <mem+0x3e>
    }
    free(m1);
    printf(1, "mem ok\n");
    exit();
  } else {
    wait();
     c1a:	e8 18 2c 00 00       	call   3837 <wait>
  }
}
     c1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c22:	5b                   	pop    %ebx
     c23:	5e                   	pop    %esi
     c24:	5f                   	pop    %edi
     c25:	5d                   	pop    %ebp
     c26:	c3                   	ret    
      *(char**)m2 = m1;
     c27:	89 18                	mov    %ebx,(%eax)
      m1 = m2;
     c29:	89 c3                	mov    %eax,%ebx
    while((m2 = malloc(10001)) != 0){
     c2b:	83 ec 0c             	sub    $0xc,%esp
     c2e:	68 11 27 00 00       	push   $0x2711
     c33:	e8 9f 2f 00 00       	call   3bd7 <malloc>
     c38:	83 c4 10             	add    $0x10,%esp
     c3b:	85 c0                	test   %eax,%eax
     c3d:	75 e8                	jne    c27 <mem+0x3a>
    while(m1){
     c3f:	85 db                	test   %ebx,%ebx
     c41:	74 14                	je     c57 <mem+0x6a>
      m2 = *(char**)m1;
     c43:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     c45:	83 ec 0c             	sub    $0xc,%esp
     c48:	53                   	push   %ebx
     c49:	e8 1b 2f 00 00       	call   3b69 <free>
      m1 = m2;
     c4e:	89 fb                	mov    %edi,%ebx
    while(m1){
     c50:	83 c4 10             	add    $0x10,%esp
     c53:	85 ff                	test   %edi,%edi
     c55:	75 ec                	jne    c43 <mem+0x56>
    m1 = malloc(1024*20);
     c57:	83 ec 0c             	sub    $0xc,%esp
     c5a:	68 00 50 00 00       	push   $0x5000
     c5f:	e8 73 2f 00 00       	call   3bd7 <malloc>
    if(m1 == 0){
     c64:	83 c4 10             	add    $0x10,%esp
     c67:	85 c0                	test   %eax,%eax
     c69:	74 1d                	je     c88 <mem+0x9b>
    free(m1);
     c6b:	83 ec 0c             	sub    $0xc,%esp
     c6e:	50                   	push   %eax
     c6f:	e8 f5 2e 00 00       	call   3b69 <free>
    printf(1, "mem ok\n");
     c74:	83 c4 08             	add    $0x8,%esp
     c77:	68 d4 40 00 00       	push   $0x40d4
     c7c:	6a 01                	push   $0x1
     c7e:	e8 16 2d 00 00       	call   3999 <printf>
    exit();
     c83:	e8 a7 2b 00 00       	call   382f <exit>
      printf(1, "couldn't allocate mem?!!\n");
     c88:	83 ec 08             	sub    $0x8,%esp
     c8b:	68 ba 40 00 00       	push   $0x40ba
     c90:	6a 01                	push   $0x1
     c92:	e8 02 2d 00 00       	call   3999 <printf>
      kill(ppid);
     c97:	89 34 24             	mov    %esi,(%esp)
     c9a:	e8 c0 2b 00 00       	call   385f <kill>
      exit();
     c9f:	e8 8b 2b 00 00       	call   382f <exit>

00000ca4 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     ca4:	55                   	push   %ebp
     ca5:	89 e5                	mov    %esp,%ebp
     ca7:	57                   	push   %edi
     ca8:	56                   	push   %esi
     ca9:	53                   	push   %ebx
     caa:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     cad:	68 dc 40 00 00       	push   $0x40dc
     cb2:	6a 01                	push   $0x1
     cb4:	e8 e0 2c 00 00       	call   3999 <printf>

  unlink("sharedfd");
     cb9:	c7 04 24 eb 40 00 00 	movl   $0x40eb,(%esp)
     cc0:	e8 ba 2b 00 00       	call   387f <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     cc5:	83 c4 08             	add    $0x8,%esp
     cc8:	68 02 02 00 00       	push   $0x202
     ccd:	68 eb 40 00 00       	push   $0x40eb
     cd2:	e8 98 2b 00 00       	call   386f <open>
  if(fd < 0){
     cd7:	83 c4 10             	add    $0x10,%esp
     cda:	85 c0                	test   %eax,%eax
     cdc:	78 4a                	js     d28 <sharedfd+0x84>
     cde:	89 c6                	mov    %eax,%esi
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
     ce0:	e8 42 2b 00 00       	call   3827 <fork>
     ce5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ce8:	83 f8 01             	cmp    $0x1,%eax
     ceb:	19 c0                	sbb    %eax,%eax
     ced:	83 e0 f3             	and    $0xfffffff3,%eax
     cf0:	83 c0 70             	add    $0x70,%eax
     cf3:	83 ec 04             	sub    $0x4,%esp
     cf6:	6a 0a                	push   $0xa
     cf8:	50                   	push   %eax
     cf9:	8d 45 de             	lea    -0x22(%ebp),%eax
     cfc:	50                   	push   %eax
     cfd:	e8 43 29 00 00       	call   3645 <memset>
     d02:	83 c4 10             	add    $0x10,%esp
     d05:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  for(i = 0; i < 1000; i++){
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     d0a:	8d 7d de             	lea    -0x22(%ebp),%edi
     d0d:	83 ec 04             	sub    $0x4,%esp
     d10:	6a 0a                	push   $0xa
     d12:	57                   	push   %edi
     d13:	56                   	push   %esi
     d14:	e8 36 2b 00 00       	call   384f <write>
     d19:	83 c4 10             	add    $0x10,%esp
     d1c:	83 f8 0a             	cmp    $0xa,%eax
     d1f:	75 1e                	jne    d3f <sharedfd+0x9b>
  for(i = 0; i < 1000; i++){
     d21:	83 eb 01             	sub    $0x1,%ebx
     d24:	75 e7                	jne    d0d <sharedfd+0x69>
     d26:	eb 29                	jmp    d51 <sharedfd+0xad>
    printf(1, "fstests: cannot open sharedfd for writing");
     d28:	83 ec 08             	sub    $0x8,%esp
     d2b:	68 b0 4d 00 00       	push   $0x4db0
     d30:	6a 01                	push   $0x1
     d32:	e8 62 2c 00 00       	call   3999 <printf>
    return;
     d37:	83 c4 10             	add    $0x10,%esp
     d3a:	e9 dd 00 00 00       	jmp    e1c <sharedfd+0x178>
      printf(1, "fstests: write sharedfd failed\n");
     d3f:	83 ec 08             	sub    $0x8,%esp
     d42:	68 dc 4d 00 00       	push   $0x4ddc
     d47:	6a 01                	push   $0x1
     d49:	e8 4b 2c 00 00       	call   3999 <printf>
      break;
     d4e:	83 c4 10             	add    $0x10,%esp
    }
  }
  if(pid == 0)
     d51:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
     d55:	74 51                	je     da8 <sharedfd+0x104>
    exit();
  else
    wait();
     d57:	e8 db 2a 00 00       	call   3837 <wait>
  close(fd);
     d5c:	83 ec 0c             	sub    $0xc,%esp
     d5f:	56                   	push   %esi
     d60:	e8 f2 2a 00 00       	call   3857 <close>
  fd = open("sharedfd", 0);
     d65:	83 c4 08             	add    $0x8,%esp
     d68:	6a 00                	push   $0x0
     d6a:	68 eb 40 00 00       	push   $0x40eb
     d6f:	e8 fb 2a 00 00       	call   386f <open>
     d74:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(fd < 0){
     d77:	83 c4 10             	add    $0x10,%esp
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
     d7a:	bb 00 00 00 00       	mov    $0x0,%ebx
     d7f:	bf 00 00 00 00       	mov    $0x0,%edi
     d84:	8d 75 e8             	lea    -0x18(%ebp),%esi
  if(fd < 0){
     d87:	85 c0                	test   %eax,%eax
     d89:	78 22                	js     dad <sharedfd+0x109>
  while((n = read(fd, buf, sizeof(buf))) > 0){
     d8b:	83 ec 04             	sub    $0x4,%esp
     d8e:	6a 0a                	push   $0xa
     d90:	8d 45 de             	lea    -0x22(%ebp),%eax
     d93:	50                   	push   %eax
     d94:	ff 75 d4             	pushl  -0x2c(%ebp)
     d97:	e8 ab 2a 00 00       	call   3847 <read>
     d9c:	83 c4 10             	add    $0x10,%esp
     d9f:	85 c0                	test   %eax,%eax
     da1:	7e 3d                	jle    de0 <sharedfd+0x13c>
     da3:	8d 45 de             	lea    -0x22(%ebp),%eax
     da6:	eb 23                	jmp    dcb <sharedfd+0x127>
    exit();
     da8:	e8 82 2a 00 00       	call   382f <exit>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     dad:	83 ec 08             	sub    $0x8,%esp
     db0:	68 fc 4d 00 00       	push   $0x4dfc
     db5:	6a 01                	push   $0x1
     db7:	e8 dd 2b 00 00       	call   3999 <printf>
    return;
     dbc:	83 c4 10             	add    $0x10,%esp
     dbf:	eb 5b                	jmp    e1c <sharedfd+0x178>
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
        nc++;
     dc1:	83 c7 01             	add    $0x1,%edi
     dc4:	83 c0 01             	add    $0x1,%eax
    for(i = 0; i < sizeof(buf); i++){
     dc7:	39 f0                	cmp    %esi,%eax
     dc9:	74 c0                	je     d8b <sharedfd+0xe7>
      if(buf[i] == 'c')
     dcb:	0f b6 10             	movzbl (%eax),%edx
     dce:	80 fa 63             	cmp    $0x63,%dl
     dd1:	74 ee                	je     dc1 <sharedfd+0x11d>
      if(buf[i] == 'p')
        np++;
     dd3:	80 fa 70             	cmp    $0x70,%dl
     dd6:	0f 94 c2             	sete   %dl
     dd9:	0f b6 d2             	movzbl %dl,%edx
     ddc:	01 d3                	add    %edx,%ebx
     dde:	eb e4                	jmp    dc4 <sharedfd+0x120>
    }
  }
  close(fd);
     de0:	83 ec 0c             	sub    $0xc,%esp
     de3:	ff 75 d4             	pushl  -0x2c(%ebp)
     de6:	e8 6c 2a 00 00       	call   3857 <close>
  unlink("sharedfd");
     deb:	c7 04 24 eb 40 00 00 	movl   $0x40eb,(%esp)
     df2:	e8 88 2a 00 00       	call   387f <unlink>
  if(nc == 10000 && np == 10000){
     df7:	83 c4 10             	add    $0x10,%esp
     dfa:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
     e00:	75 22                	jne    e24 <sharedfd+0x180>
     e02:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     e08:	75 1a                	jne    e24 <sharedfd+0x180>
    printf(1, "sharedfd ok\n");
     e0a:	83 ec 08             	sub    $0x8,%esp
     e0d:	68 f4 40 00 00       	push   $0x40f4
     e12:	6a 01                	push   $0x1
     e14:	e8 80 2b 00 00       	call   3999 <printf>
     e19:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
     e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e1f:	5b                   	pop    %ebx
     e20:	5e                   	pop    %esi
     e21:	5f                   	pop    %edi
     e22:	5d                   	pop    %ebp
     e23:	c3                   	ret    
    printf(1, "sharedfd oops %d %d\n", nc, np);
     e24:	53                   	push   %ebx
     e25:	57                   	push   %edi
     e26:	68 01 41 00 00       	push   $0x4101
     e2b:	6a 01                	push   $0x1
     e2d:	e8 67 2b 00 00       	call   3999 <printf>
    exit();
     e32:	e8 f8 29 00 00       	call   382f <exit>

00000e37 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     e37:	55                   	push   %ebp
     e38:	89 e5                	mov    %esp,%ebp
     e3a:	57                   	push   %edi
     e3b:	56                   	push   %esi
     e3c:	53                   	push   %ebx
     e3d:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     e40:	c7 45 d8 16 41 00 00 	movl   $0x4116,-0x28(%ebp)
     e47:	c7 45 dc 5f 42 00 00 	movl   $0x425f,-0x24(%ebp)
     e4e:	c7 45 e0 63 42 00 00 	movl   $0x4263,-0x20(%ebp)
     e55:	c7 45 e4 19 41 00 00 	movl   $0x4119,-0x1c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
     e5c:	68 1c 41 00 00       	push   $0x411c
     e61:	6a 01                	push   $0x1
     e63:	e8 31 2b 00 00       	call   3999 <printf>
     e68:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
     e6b:	bb 00 00 00 00       	mov    $0x0,%ebx
    fname = names[pi];
     e70:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    unlink(fname);
     e74:	83 ec 0c             	sub    $0xc,%esp
     e77:	56                   	push   %esi
     e78:	e8 02 2a 00 00       	call   387f <unlink>

    pid = fork();
     e7d:	e8 a5 29 00 00       	call   3827 <fork>
    if(pid < 0){
     e82:	83 c4 10             	add    $0x10,%esp
     e85:	85 c0                	test   %eax,%eax
     e87:	78 2a                	js     eb3 <fourfiles+0x7c>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
     e89:	85 c0                	test   %eax,%eax
     e8b:	74 3a                	je     ec7 <fourfiles+0x90>
  for(pi = 0; pi < 4; pi++){
     e8d:	83 c3 01             	add    $0x1,%ebx
     e90:	83 fb 04             	cmp    $0x4,%ebx
     e93:	75 db                	jne    e70 <fourfiles+0x39>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
     e95:	e8 9d 29 00 00       	call   3837 <wait>
     e9a:	e8 98 29 00 00       	call   3837 <wait>
     e9f:	e8 93 29 00 00       	call   3837 <wait>
     ea4:	e8 8e 29 00 00       	call   3837 <wait>
     ea9:	bf 30 00 00 00       	mov    $0x30,%edi
     eae:	e9 15 01 00 00       	jmp    fc8 <fourfiles+0x191>
      printf(1, "fork failed\n");
     eb3:	83 ec 08             	sub    $0x8,%esp
     eb6:	68 f1 4b 00 00       	push   $0x4bf1
     ebb:	6a 01                	push   $0x1
     ebd:	e8 d7 2a 00 00       	call   3999 <printf>
      exit();
     ec2:	e8 68 29 00 00       	call   382f <exit>
      fd = open(fname, O_CREATE | O_RDWR);
     ec7:	83 ec 08             	sub    $0x8,%esp
     eca:	68 02 02 00 00       	push   $0x202
     ecf:	56                   	push   %esi
     ed0:	e8 9a 29 00 00       	call   386f <open>
     ed5:	89 c6                	mov    %eax,%esi
      if(fd < 0){
     ed7:	83 c4 10             	add    $0x10,%esp
     eda:	85 c0                	test   %eax,%eax
     edc:	78 45                	js     f23 <fourfiles+0xec>
      memset(buf, '0'+pi, 512);
     ede:	83 ec 04             	sub    $0x4,%esp
     ee1:	68 00 02 00 00       	push   $0x200
     ee6:	83 c3 30             	add    $0x30,%ebx
     ee9:	53                   	push   %ebx
     eea:	68 00 85 00 00       	push   $0x8500
     eef:	e8 51 27 00 00       	call   3645 <memset>
     ef4:	83 c4 10             	add    $0x10,%esp
     ef7:	bb 0c 00 00 00       	mov    $0xc,%ebx
        if((n = write(fd, buf, 500)) != 500){
     efc:	83 ec 04             	sub    $0x4,%esp
     eff:	68 f4 01 00 00       	push   $0x1f4
     f04:	68 00 85 00 00       	push   $0x8500
     f09:	56                   	push   %esi
     f0a:	e8 40 29 00 00       	call   384f <write>
     f0f:	83 c4 10             	add    $0x10,%esp
     f12:	3d f4 01 00 00       	cmp    $0x1f4,%eax
     f17:	75 1e                	jne    f37 <fourfiles+0x100>
      for(i = 0; i < 12; i++){
     f19:	83 eb 01             	sub    $0x1,%ebx
     f1c:	75 de                	jne    efc <fourfiles+0xc5>
      exit();
     f1e:	e8 0c 29 00 00       	call   382f <exit>
        printf(1, "create failed\n");
     f23:	83 ec 08             	sub    $0x8,%esp
     f26:	68 b7 43 00 00       	push   $0x43b7
     f2b:	6a 01                	push   $0x1
     f2d:	e8 67 2a 00 00       	call   3999 <printf>
        exit();
     f32:	e8 f8 28 00 00       	call   382f <exit>
          printf(1, "write failed %d\n", n);
     f37:	83 ec 04             	sub    $0x4,%esp
     f3a:	50                   	push   %eax
     f3b:	68 2c 41 00 00       	push   $0x412c
     f40:	6a 01                	push   $0x1
     f42:	e8 52 2a 00 00       	call   3999 <printf>
          exit();
     f47:	e8 e3 28 00 00       	call   382f <exit>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
     f4c:	01 d3                	add    %edx,%ebx
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f4e:	83 ec 04             	sub    $0x4,%esp
     f51:	68 00 20 00 00       	push   $0x2000
     f56:	68 00 85 00 00       	push   $0x8500
     f5b:	56                   	push   %esi
     f5c:	e8 e6 28 00 00       	call   3847 <read>
     f61:	83 c4 10             	add    $0x10,%esp
     f64:	85 c0                	test   %eax,%eax
     f66:	7e 36                	jle    f9e <fourfiles+0x167>
        if(buf[j] != '0'+i){
     f68:	0f b6 0d 00 85 00 00 	movzbl 0x8500,%ecx
     f6f:	0f be d1             	movsbl %cl,%edx
     f72:	39 fa                	cmp    %edi,%edx
     f74:	75 14                	jne    f8a <fourfiles+0x153>
      for(j = 0; j < n; j++){
     f76:	ba 00 00 00 00       	mov    $0x0,%edx
     f7b:	83 c2 01             	add    $0x1,%edx
     f7e:	39 d0                	cmp    %edx,%eax
     f80:	74 ca                	je     f4c <fourfiles+0x115>
        if(buf[j] != '0'+i){
     f82:	38 8a 00 85 00 00    	cmp    %cl,0x8500(%edx)
     f88:	74 f1                	je     f7b <fourfiles+0x144>
          printf(1, "wrong char\n");
     f8a:	83 ec 08             	sub    $0x8,%esp
     f8d:	68 3d 41 00 00       	push   $0x413d
     f92:	6a 01                	push   $0x1
     f94:	e8 00 2a 00 00       	call   3999 <printf>
          exit();
     f99:	e8 91 28 00 00       	call   382f <exit>
    }
    close(fd);
     f9e:	83 ec 0c             	sub    $0xc,%esp
     fa1:	56                   	push   %esi
     fa2:	e8 b0 28 00 00       	call   3857 <close>
    if(total != 12*500){
     fa7:	83 c4 10             	add    $0x10,%esp
     faa:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
     fb0:	75 3a                	jne    fec <fourfiles+0x1b5>
      printf(1, "wrong length %d\n", total);
      exit();
    }
    unlink(fname);
     fb2:	83 ec 0c             	sub    $0xc,%esp
     fb5:	ff 75 d4             	pushl  -0x2c(%ebp)
     fb8:	e8 c2 28 00 00       	call   387f <unlink>
     fbd:	83 c7 01             	add    $0x1,%edi
  for(i = 0; i < 2; i++){
     fc0:	83 c4 10             	add    $0x10,%esp
     fc3:	83 ff 32             	cmp    $0x32,%edi
     fc6:	74 39                	je     1001 <fourfiles+0x1ca>
    fname = names[i];
     fc8:	8b 84 bd 18 ff ff ff 	mov    -0xe8(%ebp,%edi,4),%eax
     fcf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    fd = open(fname, 0);
     fd2:	83 ec 08             	sub    $0x8,%esp
     fd5:	6a 00                	push   $0x0
     fd7:	50                   	push   %eax
     fd8:	e8 92 28 00 00       	call   386f <open>
     fdd:	89 c6                	mov    %eax,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
     fdf:	83 c4 10             	add    $0x10,%esp
    total = 0;
     fe2:	bb 00 00 00 00       	mov    $0x0,%ebx
    while((n = read(fd, buf, sizeof(buf))) > 0){
     fe7:	e9 62 ff ff ff       	jmp    f4e <fourfiles+0x117>
      printf(1, "wrong length %d\n", total);
     fec:	83 ec 04             	sub    $0x4,%esp
     fef:	53                   	push   %ebx
     ff0:	68 49 41 00 00       	push   $0x4149
     ff5:	6a 01                	push   $0x1
     ff7:	e8 9d 29 00 00       	call   3999 <printf>
      exit();
     ffc:	e8 2e 28 00 00       	call   382f <exit>
  }

  printf(1, "fourfiles ok\n");
    1001:	83 ec 08             	sub    $0x8,%esp
    1004:	68 5a 41 00 00       	push   $0x415a
    1009:	6a 01                	push   $0x1
    100b:	e8 89 29 00 00       	call   3999 <printf>
}
    1010:	83 c4 10             	add    $0x10,%esp
    1013:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1016:	5b                   	pop    %ebx
    1017:	5e                   	pop    %esi
    1018:	5f                   	pop    %edi
    1019:	5d                   	pop    %ebp
    101a:	c3                   	ret    

0000101b <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    101b:	55                   	push   %ebp
    101c:	89 e5                	mov    %esp,%ebp
    101e:	57                   	push   %edi
    101f:	56                   	push   %esi
    1020:	53                   	push   %ebx
    1021:	83 ec 44             	sub    $0x44,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    1024:	68 68 41 00 00       	push   $0x4168
    1029:	6a 01                	push   $0x1
    102b:	e8 69 29 00 00       	call   3999 <printf>
    1030:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    1033:	be 00 00 00 00       	mov    $0x0,%esi
    pid = fork();
    1038:	e8 ea 27 00 00       	call   3827 <fork>
    if(pid < 0){
    103d:	85 c0                	test   %eax,%eax
    103f:	78 3c                	js     107d <createdelete+0x62>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
    1041:	85 c0                	test   %eax,%eax
    1043:	74 4c                	je     1091 <createdelete+0x76>
  for(pi = 0; pi < 4; pi++){
    1045:	83 c6 01             	add    $0x1,%esi
    1048:	83 fe 04             	cmp    $0x4,%esi
    104b:	75 eb                	jne    1038 <createdelete+0x1d>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
    104d:	e8 e5 27 00 00       	call   3837 <wait>
    1052:	e8 e0 27 00 00       	call   3837 <wait>
    1057:	e8 db 27 00 00       	call   3837 <wait>
    105c:	e8 d6 27 00 00       	call   3837 <wait>
  }

  name[0] = name[1] = name[2] = 0;
    1061:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    1065:	c6 45 c7 30          	movb   $0x30,-0x39(%ebp)
    1069:	c7 45 c0 ff ff ff ff 	movl   $0xffffffff,-0x40(%ebp)
  for(i = 0; i < N; i++){
    1070:	be 00 00 00 00       	mov    $0x0,%esi
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
      fd = open(name, 0);
    1075:	8d 7d c8             	lea    -0x38(%ebp),%edi
    1078:	e9 38 01 00 00       	jmp    11b5 <createdelete+0x19a>
      printf(1, "fork failed\n");
    107d:	83 ec 08             	sub    $0x8,%esp
    1080:	68 f1 4b 00 00       	push   $0x4bf1
    1085:	6a 01                	push   $0x1
    1087:	e8 0d 29 00 00       	call   3999 <printf>
      exit();
    108c:	e8 9e 27 00 00       	call   382f <exit>
    1091:	89 c3                	mov    %eax,%ebx
      name[0] = 'p' + pi;
    1093:	8d 46 70             	lea    0x70(%esi),%eax
    1096:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    1099:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    109d:	8d 75 c8             	lea    -0x38(%ebp),%esi
    10a0:	eb 1c                	jmp    10be <createdelete+0xa3>
          printf(1, "create failed\n");
    10a2:	83 ec 08             	sub    $0x8,%esp
    10a5:	68 b7 43 00 00       	push   $0x43b7
    10aa:	6a 01                	push   $0x1
    10ac:	e8 e8 28 00 00       	call   3999 <printf>
          exit();
    10b1:	e8 79 27 00 00       	call   382f <exit>
      for(i = 0; i < N; i++){
    10b6:	83 c3 01             	add    $0x1,%ebx
    10b9:	83 fb 14             	cmp    $0x14,%ebx
    10bc:	74 63                	je     1121 <createdelete+0x106>
        name[1] = '0' + i;
    10be:	8d 43 30             	lea    0x30(%ebx),%eax
    10c1:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    10c4:	83 ec 08             	sub    $0x8,%esp
    10c7:	68 02 02 00 00       	push   $0x202
    10cc:	56                   	push   %esi
    10cd:	e8 9d 27 00 00       	call   386f <open>
        if(fd < 0){
    10d2:	83 c4 10             	add    $0x10,%esp
    10d5:	85 c0                	test   %eax,%eax
    10d7:	78 c9                	js     10a2 <createdelete+0x87>
        close(fd);
    10d9:	83 ec 0c             	sub    $0xc,%esp
    10dc:	50                   	push   %eax
    10dd:	e8 75 27 00 00       	call   3857 <close>
        if(i > 0 && (i % 2 ) == 0){
    10e2:	83 c4 10             	add    $0x10,%esp
    10e5:	85 db                	test   %ebx,%ebx
    10e7:	7e cd                	jle    10b6 <createdelete+0x9b>
    10e9:	f6 c3 01             	test   $0x1,%bl
    10ec:	75 c8                	jne    10b6 <createdelete+0x9b>
          name[1] = '0' + (i / 2);
    10ee:	89 d8                	mov    %ebx,%eax
    10f0:	c1 e8 1f             	shr    $0x1f,%eax
    10f3:	01 d8                	add    %ebx,%eax
    10f5:	d1 f8                	sar    %eax
    10f7:	83 c0 30             	add    $0x30,%eax
    10fa:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    10fd:	83 ec 0c             	sub    $0xc,%esp
    1100:	56                   	push   %esi
    1101:	e8 79 27 00 00       	call   387f <unlink>
    1106:	83 c4 10             	add    $0x10,%esp
    1109:	85 c0                	test   %eax,%eax
    110b:	79 a9                	jns    10b6 <createdelete+0x9b>
            printf(1, "unlink failed\n");
    110d:	83 ec 08             	sub    $0x8,%esp
    1110:	68 69 3d 00 00       	push   $0x3d69
    1115:	6a 01                	push   $0x1
    1117:	e8 7d 28 00 00       	call   3999 <printf>
            exit();
    111c:	e8 0e 27 00 00       	call   382f <exit>
      exit();
    1121:	e8 09 27 00 00       	call   382f <exit>
      if((i == 0 || i >= N/2) && fd < 0){
        printf(1, "oops createdelete %s didn't exist\n", name);
    1126:	83 ec 04             	sub    $0x4,%esp
    1129:	8d 45 c8             	lea    -0x38(%ebp),%eax
    112c:	50                   	push   %eax
    112d:	68 28 4e 00 00       	push   $0x4e28
    1132:	6a 01                	push   $0x1
    1134:	e8 60 28 00 00       	call   3999 <printf>
        exit();
    1139:	e8 f1 26 00 00       	call   382f <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
        printf(1, "oops createdelete %s did exist\n", name);
        exit();
      }
      if(fd >= 0)
    113e:	85 c0                	test   %eax,%eax
    1140:	79 55                	jns    1197 <createdelete+0x17c>
    1142:	83 c3 01             	add    $0x1,%ebx
    for(pi = 0; pi < 4; pi++){
    1145:	80 fb 74             	cmp    $0x74,%bl
    1148:	74 5b                	je     11a5 <createdelete+0x18a>
      name[0] = 'p' + pi;
    114a:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[1] = '0' + i;
    114d:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    1151:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1154:	83 ec 08             	sub    $0x8,%esp
    1157:	6a 00                	push   $0x0
    1159:	57                   	push   %edi
    115a:	e8 10 27 00 00       	call   386f <open>
      if((i == 0 || i >= N/2) && fd < 0){
    115f:	83 c4 10             	add    $0x10,%esp
    1162:	85 f6                	test   %esi,%esi
    1164:	0f 94 c1             	sete   %cl
    1167:	83 fe 09             	cmp    $0x9,%esi
    116a:	0f 9f c2             	setg   %dl
    116d:	08 d1                	or     %dl,%cl
    116f:	74 04                	je     1175 <createdelete+0x15a>
    1171:	85 c0                	test   %eax,%eax
    1173:	78 b1                	js     1126 <createdelete+0x10b>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1175:	85 c0                	test   %eax,%eax
    1177:	78 c5                	js     113e <createdelete+0x123>
    1179:	83 7d c0 08          	cmpl   $0x8,-0x40(%ebp)
    117d:	77 bf                	ja     113e <createdelete+0x123>
        printf(1, "oops createdelete %s did exist\n", name);
    117f:	83 ec 04             	sub    $0x4,%esp
    1182:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1185:	50                   	push   %eax
    1186:	68 4c 4e 00 00       	push   $0x4e4c
    118b:	6a 01                	push   $0x1
    118d:	e8 07 28 00 00       	call   3999 <printf>
        exit();
    1192:	e8 98 26 00 00       	call   382f <exit>
        close(fd);
    1197:	83 ec 0c             	sub    $0xc,%esp
    119a:	50                   	push   %eax
    119b:	e8 b7 26 00 00       	call   3857 <close>
    11a0:	83 c4 10             	add    $0x10,%esp
    11a3:	eb 9d                	jmp    1142 <createdelete+0x127>
  for(i = 0; i < N; i++){
    11a5:	83 c6 01             	add    $0x1,%esi
    11a8:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
    11ac:	80 45 c7 01          	addb   $0x1,-0x39(%ebp)
    11b0:	83 fe 14             	cmp    $0x14,%esi
    11b3:	74 38                	je     11ed <createdelete+0x1d2>
  for(pi = 0; pi < 4; pi++){
    11b5:	bb 70 00 00 00       	mov    $0x70,%ebx
    11ba:	eb 8e                	jmp    114a <createdelete+0x12f>
    11bc:	83 c6 01             	add    $0x1,%esi
    11bf:	80 45 c7 01          	addb   $0x1,-0x39(%ebp)
    }
  }

  for(i = 0; i < N; i++){
    11c3:	89 f0                	mov    %esi,%eax
    11c5:	3c 84                	cmp    $0x84,%al
    11c7:	74 32                	je     11fb <createdelete+0x1e0>
  for(i = 0; i < N; i++){
    11c9:	bb 04 00 00 00       	mov    $0x4,%ebx
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
    11ce:	89 f0                	mov    %esi,%eax
    11d0:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    11d3:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    11d7:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    11da:	83 ec 0c             	sub    $0xc,%esp
    11dd:	57                   	push   %edi
    11de:	e8 9c 26 00 00       	call   387f <unlink>
    for(pi = 0; pi < 4; pi++){
    11e3:	83 c4 10             	add    $0x10,%esp
    11e6:	83 eb 01             	sub    $0x1,%ebx
    11e9:	75 e3                	jne    11ce <createdelete+0x1b3>
    11eb:	eb cf                	jmp    11bc <createdelete+0x1a1>
    11ed:	c6 45 c7 30          	movb   $0x30,-0x39(%ebp)
    11f1:	be 70 00 00 00       	mov    $0x70,%esi
      unlink(name);
    11f6:	8d 7d c8             	lea    -0x38(%ebp),%edi
    11f9:	eb ce                	jmp    11c9 <createdelete+0x1ae>
    }
  }

  printf(1, "createdelete ok\n");
    11fb:	83 ec 08             	sub    $0x8,%esp
    11fe:	68 7b 41 00 00       	push   $0x417b
    1203:	6a 01                	push   $0x1
    1205:	e8 8f 27 00 00       	call   3999 <printf>
}
    120a:	83 c4 10             	add    $0x10,%esp
    120d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1210:	5b                   	pop    %ebx
    1211:	5e                   	pop    %esi
    1212:	5f                   	pop    %edi
    1213:	5d                   	pop    %ebp
    1214:	c3                   	ret    

00001215 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1215:	55                   	push   %ebp
    1216:	89 e5                	mov    %esp,%ebp
    1218:	56                   	push   %esi
    1219:	53                   	push   %ebx
  int fd, fd1;

  printf(1, "unlinkread test\n");
    121a:	83 ec 08             	sub    $0x8,%esp
    121d:	68 8c 41 00 00       	push   $0x418c
    1222:	6a 01                	push   $0x1
    1224:	e8 70 27 00 00       	call   3999 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1229:	83 c4 08             	add    $0x8,%esp
    122c:	68 02 02 00 00       	push   $0x202
    1231:	68 9d 41 00 00       	push   $0x419d
    1236:	e8 34 26 00 00       	call   386f <open>
  if(fd < 0){
    123b:	83 c4 10             	add    $0x10,%esp
    123e:	85 c0                	test   %eax,%eax
    1240:	0f 88 f0 00 00 00    	js     1336 <unlinkread+0x121>
    1246:	89 c3                	mov    %eax,%ebx
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
    1248:	83 ec 04             	sub    $0x4,%esp
    124b:	6a 05                	push   $0x5
    124d:	68 c2 41 00 00       	push   $0x41c2
    1252:	50                   	push   %eax
    1253:	e8 f7 25 00 00       	call   384f <write>
  close(fd);
    1258:	89 1c 24             	mov    %ebx,(%esp)
    125b:	e8 f7 25 00 00       	call   3857 <close>

  fd = open("unlinkread", O_RDWR);
    1260:	83 c4 08             	add    $0x8,%esp
    1263:	6a 02                	push   $0x2
    1265:	68 9d 41 00 00       	push   $0x419d
    126a:	e8 00 26 00 00       	call   386f <open>
    126f:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1271:	83 c4 10             	add    $0x10,%esp
    1274:	85 c0                	test   %eax,%eax
    1276:	0f 88 ce 00 00 00    	js     134a <unlinkread+0x135>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    127c:	83 ec 0c             	sub    $0xc,%esp
    127f:	68 9d 41 00 00       	push   $0x419d
    1284:	e8 f6 25 00 00       	call   387f <unlink>
    1289:	83 c4 10             	add    $0x10,%esp
    128c:	85 c0                	test   %eax,%eax
    128e:	0f 85 ca 00 00 00    	jne    135e <unlinkread+0x149>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1294:	83 ec 08             	sub    $0x8,%esp
    1297:	68 02 02 00 00       	push   $0x202
    129c:	68 9d 41 00 00       	push   $0x419d
    12a1:	e8 c9 25 00 00       	call   386f <open>
    12a6:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    12a8:	83 c4 0c             	add    $0xc,%esp
    12ab:	6a 03                	push   $0x3
    12ad:	68 fa 41 00 00       	push   $0x41fa
    12b2:	50                   	push   %eax
    12b3:	e8 97 25 00 00       	call   384f <write>
  close(fd1);
    12b8:	89 34 24             	mov    %esi,(%esp)
    12bb:	e8 97 25 00 00       	call   3857 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    12c0:	83 c4 0c             	add    $0xc,%esp
    12c3:	68 00 20 00 00       	push   $0x2000
    12c8:	68 00 85 00 00       	push   $0x8500
    12cd:	53                   	push   %ebx
    12ce:	e8 74 25 00 00       	call   3847 <read>
    12d3:	83 c4 10             	add    $0x10,%esp
    12d6:	83 f8 05             	cmp    $0x5,%eax
    12d9:	0f 85 93 00 00 00    	jne    1372 <unlinkread+0x15d>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    12df:	80 3d 00 85 00 00 68 	cmpb   $0x68,0x8500
    12e6:	0f 85 9a 00 00 00    	jne    1386 <unlinkread+0x171>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    12ec:	83 ec 04             	sub    $0x4,%esp
    12ef:	6a 0a                	push   $0xa
    12f1:	68 00 85 00 00       	push   $0x8500
    12f6:	53                   	push   %ebx
    12f7:	e8 53 25 00 00       	call   384f <write>
    12fc:	83 c4 10             	add    $0x10,%esp
    12ff:	83 f8 0a             	cmp    $0xa,%eax
    1302:	0f 85 92 00 00 00    	jne    139a <unlinkread+0x185>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
    1308:	83 ec 0c             	sub    $0xc,%esp
    130b:	53                   	push   %ebx
    130c:	e8 46 25 00 00       	call   3857 <close>
  unlink("unlinkread");
    1311:	c7 04 24 9d 41 00 00 	movl   $0x419d,(%esp)
    1318:	e8 62 25 00 00       	call   387f <unlink>
  printf(1, "unlinkread ok\n");
    131d:	83 c4 08             	add    $0x8,%esp
    1320:	68 45 42 00 00       	push   $0x4245
    1325:	6a 01                	push   $0x1
    1327:	e8 6d 26 00 00       	call   3999 <printf>
}
    132c:	83 c4 10             	add    $0x10,%esp
    132f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1332:	5b                   	pop    %ebx
    1333:	5e                   	pop    %esi
    1334:	5d                   	pop    %ebp
    1335:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    1336:	83 ec 08             	sub    $0x8,%esp
    1339:	68 a8 41 00 00       	push   $0x41a8
    133e:	6a 01                	push   $0x1
    1340:	e8 54 26 00 00       	call   3999 <printf>
    exit();
    1345:	e8 e5 24 00 00       	call   382f <exit>
    printf(1, "open unlinkread failed\n");
    134a:	83 ec 08             	sub    $0x8,%esp
    134d:	68 c8 41 00 00       	push   $0x41c8
    1352:	6a 01                	push   $0x1
    1354:	e8 40 26 00 00       	call   3999 <printf>
    exit();
    1359:	e8 d1 24 00 00       	call   382f <exit>
    printf(1, "unlink unlinkread failed\n");
    135e:	83 ec 08             	sub    $0x8,%esp
    1361:	68 e0 41 00 00       	push   $0x41e0
    1366:	6a 01                	push   $0x1
    1368:	e8 2c 26 00 00       	call   3999 <printf>
    exit();
    136d:	e8 bd 24 00 00       	call   382f <exit>
    printf(1, "unlinkread read failed");
    1372:	83 ec 08             	sub    $0x8,%esp
    1375:	68 fe 41 00 00       	push   $0x41fe
    137a:	6a 01                	push   $0x1
    137c:	e8 18 26 00 00       	call   3999 <printf>
    exit();
    1381:	e8 a9 24 00 00       	call   382f <exit>
    printf(1, "unlinkread wrong data\n");
    1386:	83 ec 08             	sub    $0x8,%esp
    1389:	68 15 42 00 00       	push   $0x4215
    138e:	6a 01                	push   $0x1
    1390:	e8 04 26 00 00       	call   3999 <printf>
    exit();
    1395:	e8 95 24 00 00       	call   382f <exit>
    printf(1, "unlinkread write failed\n");
    139a:	83 ec 08             	sub    $0x8,%esp
    139d:	68 2c 42 00 00       	push   $0x422c
    13a2:	6a 01                	push   $0x1
    13a4:	e8 f0 25 00 00       	call   3999 <printf>
    exit();
    13a9:	e8 81 24 00 00       	call   382f <exit>

000013ae <linktest>:

void
linktest(void)
{
    13ae:	55                   	push   %ebp
    13af:	89 e5                	mov    %esp,%ebp
    13b1:	53                   	push   %ebx
    13b2:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "linktest\n");
    13b5:	68 54 42 00 00       	push   $0x4254
    13ba:	6a 01                	push   $0x1
    13bc:	e8 d8 25 00 00       	call   3999 <printf>

  unlink("lf1");
    13c1:	c7 04 24 5e 42 00 00 	movl   $0x425e,(%esp)
    13c8:	e8 b2 24 00 00       	call   387f <unlink>
  unlink("lf2");
    13cd:	c7 04 24 62 42 00 00 	movl   $0x4262,(%esp)
    13d4:	e8 a6 24 00 00       	call   387f <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    13d9:	83 c4 08             	add    $0x8,%esp
    13dc:	68 02 02 00 00       	push   $0x202
    13e1:	68 5e 42 00 00       	push   $0x425e
    13e6:	e8 84 24 00 00       	call   386f <open>
  if(fd < 0){
    13eb:	83 c4 10             	add    $0x10,%esp
    13ee:	85 c0                	test   %eax,%eax
    13f0:	0f 88 2a 01 00 00    	js     1520 <linktest+0x172>
    13f6:	89 c3                	mov    %eax,%ebx
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    13f8:	83 ec 04             	sub    $0x4,%esp
    13fb:	6a 05                	push   $0x5
    13fd:	68 c2 41 00 00       	push   $0x41c2
    1402:	50                   	push   %eax
    1403:	e8 47 24 00 00       	call   384f <write>
    1408:	83 c4 10             	add    $0x10,%esp
    140b:	83 f8 05             	cmp    $0x5,%eax
    140e:	0f 85 20 01 00 00    	jne    1534 <linktest+0x186>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
    1414:	83 ec 0c             	sub    $0xc,%esp
    1417:	53                   	push   %ebx
    1418:	e8 3a 24 00 00       	call   3857 <close>

  if(link("lf1", "lf2") < 0){
    141d:	83 c4 08             	add    $0x8,%esp
    1420:	68 62 42 00 00       	push   $0x4262
    1425:	68 5e 42 00 00       	push   $0x425e
    142a:	e8 60 24 00 00       	call   388f <link>
    142f:	83 c4 10             	add    $0x10,%esp
    1432:	85 c0                	test   %eax,%eax
    1434:	0f 88 0e 01 00 00    	js     1548 <linktest+0x19a>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    143a:	83 ec 0c             	sub    $0xc,%esp
    143d:	68 5e 42 00 00       	push   $0x425e
    1442:	e8 38 24 00 00       	call   387f <unlink>

  if(open("lf1", 0) >= 0){
    1447:	83 c4 08             	add    $0x8,%esp
    144a:	6a 00                	push   $0x0
    144c:	68 5e 42 00 00       	push   $0x425e
    1451:	e8 19 24 00 00       	call   386f <open>
    1456:	83 c4 10             	add    $0x10,%esp
    1459:	85 c0                	test   %eax,%eax
    145b:	0f 89 fb 00 00 00    	jns    155c <linktest+0x1ae>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1461:	83 ec 08             	sub    $0x8,%esp
    1464:	6a 00                	push   $0x0
    1466:	68 62 42 00 00       	push   $0x4262
    146b:	e8 ff 23 00 00       	call   386f <open>
    1470:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1472:	83 c4 10             	add    $0x10,%esp
    1475:	85 c0                	test   %eax,%eax
    1477:	0f 88 f3 00 00 00    	js     1570 <linktest+0x1c2>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    147d:	83 ec 04             	sub    $0x4,%esp
    1480:	68 00 20 00 00       	push   $0x2000
    1485:	68 00 85 00 00       	push   $0x8500
    148a:	50                   	push   %eax
    148b:	e8 b7 23 00 00       	call   3847 <read>
    1490:	83 c4 10             	add    $0x10,%esp
    1493:	83 f8 05             	cmp    $0x5,%eax
    1496:	0f 85 e8 00 00 00    	jne    1584 <linktest+0x1d6>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    149c:	83 ec 0c             	sub    $0xc,%esp
    149f:	53                   	push   %ebx
    14a0:	e8 b2 23 00 00       	call   3857 <close>

  if(link("lf2", "lf2") >= 0){
    14a5:	83 c4 08             	add    $0x8,%esp
    14a8:	68 62 42 00 00       	push   $0x4262
    14ad:	68 62 42 00 00       	push   $0x4262
    14b2:	e8 d8 23 00 00       	call   388f <link>
    14b7:	83 c4 10             	add    $0x10,%esp
    14ba:	85 c0                	test   %eax,%eax
    14bc:	0f 89 d6 00 00 00    	jns    1598 <linktest+0x1ea>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    14c2:	83 ec 0c             	sub    $0xc,%esp
    14c5:	68 62 42 00 00       	push   $0x4262
    14ca:	e8 b0 23 00 00       	call   387f <unlink>
  if(link("lf2", "lf1") >= 0){
    14cf:	83 c4 08             	add    $0x8,%esp
    14d2:	68 5e 42 00 00       	push   $0x425e
    14d7:	68 62 42 00 00       	push   $0x4262
    14dc:	e8 ae 23 00 00       	call   388f <link>
    14e1:	83 c4 10             	add    $0x10,%esp
    14e4:	85 c0                	test   %eax,%eax
    14e6:	0f 89 c0 00 00 00    	jns    15ac <linktest+0x1fe>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    14ec:	83 ec 08             	sub    $0x8,%esp
    14ef:	68 5e 42 00 00       	push   $0x425e
    14f4:	68 26 45 00 00       	push   $0x4526
    14f9:	e8 91 23 00 00       	call   388f <link>
    14fe:	83 c4 10             	add    $0x10,%esp
    1501:	85 c0                	test   %eax,%eax
    1503:	0f 89 b7 00 00 00    	jns    15c0 <linktest+0x212>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    1509:	83 ec 08             	sub    $0x8,%esp
    150c:	68 fc 42 00 00       	push   $0x42fc
    1511:	6a 01                	push   $0x1
    1513:	e8 81 24 00 00       	call   3999 <printf>
}
    1518:	83 c4 10             	add    $0x10,%esp
    151b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    151e:	c9                   	leave  
    151f:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    1520:	83 ec 08             	sub    $0x8,%esp
    1523:	68 66 42 00 00       	push   $0x4266
    1528:	6a 01                	push   $0x1
    152a:	e8 6a 24 00 00       	call   3999 <printf>
    exit();
    152f:	e8 fb 22 00 00       	call   382f <exit>
    printf(1, "write lf1 failed\n");
    1534:	83 ec 08             	sub    $0x8,%esp
    1537:	68 79 42 00 00       	push   $0x4279
    153c:	6a 01                	push   $0x1
    153e:	e8 56 24 00 00       	call   3999 <printf>
    exit();
    1543:	e8 e7 22 00 00       	call   382f <exit>
    printf(1, "link lf1 lf2 failed\n");
    1548:	83 ec 08             	sub    $0x8,%esp
    154b:	68 8b 42 00 00       	push   $0x428b
    1550:	6a 01                	push   $0x1
    1552:	e8 42 24 00 00       	call   3999 <printf>
    exit();
    1557:	e8 d3 22 00 00       	call   382f <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    155c:	83 ec 08             	sub    $0x8,%esp
    155f:	68 6c 4e 00 00       	push   $0x4e6c
    1564:	6a 01                	push   $0x1
    1566:	e8 2e 24 00 00       	call   3999 <printf>
    exit();
    156b:	e8 bf 22 00 00       	call   382f <exit>
    printf(1, "open lf2 failed\n");
    1570:	83 ec 08             	sub    $0x8,%esp
    1573:	68 a0 42 00 00       	push   $0x42a0
    1578:	6a 01                	push   $0x1
    157a:	e8 1a 24 00 00       	call   3999 <printf>
    exit();
    157f:	e8 ab 22 00 00       	call   382f <exit>
    printf(1, "read lf2 failed\n");
    1584:	83 ec 08             	sub    $0x8,%esp
    1587:	68 b1 42 00 00       	push   $0x42b1
    158c:	6a 01                	push   $0x1
    158e:	e8 06 24 00 00       	call   3999 <printf>
    exit();
    1593:	e8 97 22 00 00       	call   382f <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1598:	83 ec 08             	sub    $0x8,%esp
    159b:	68 c2 42 00 00       	push   $0x42c2
    15a0:	6a 01                	push   $0x1
    15a2:	e8 f2 23 00 00       	call   3999 <printf>
    exit();
    15a7:	e8 83 22 00 00       	call   382f <exit>
    printf(1, "link non-existant succeeded! oops\n");
    15ac:	83 ec 08             	sub    $0x8,%esp
    15af:	68 94 4e 00 00       	push   $0x4e94
    15b4:	6a 01                	push   $0x1
    15b6:	e8 de 23 00 00       	call   3999 <printf>
    exit();
    15bb:	e8 6f 22 00 00       	call   382f <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    15c0:	83 ec 08             	sub    $0x8,%esp
    15c3:	68 e0 42 00 00       	push   $0x42e0
    15c8:	6a 01                	push   $0x1
    15ca:	e8 ca 23 00 00       	call   3999 <printf>
    exit();
    15cf:	e8 5b 22 00 00       	call   382f <exit>

000015d4 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    15d4:	55                   	push   %ebp
    15d5:	89 e5                	mov    %esp,%ebp
    15d7:	57                   	push   %edi
    15d8:	56                   	push   %esi
    15d9:	53                   	push   %ebx
    15da:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    15dd:	68 09 43 00 00       	push   $0x4309
    15e2:	6a 01                	push   $0x1
    15e4:	e8 b0 23 00 00       	call   3999 <printf>
  file[0] = 'C';
    15e9:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    15ed:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
    15f1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 40; i++){
    15f4:	bb 00 00 00 00       	mov    $0x0,%ebx
    file[1] = '0' + i;
    unlink(file);
    15f9:	8d 75 e5             	lea    -0x1b(%ebp),%esi
    pid = fork();
    if(pid && (i % 3) == 1){
    15fc:	bf 56 55 55 55       	mov    $0x55555556,%edi
    1601:	e9 75 02 00 00       	jmp    187b <concreate+0x2a7>
      link("C0", file);
    1606:	83 ec 08             	sub    $0x8,%esp
    1609:	56                   	push   %esi
    160a:	68 19 43 00 00       	push   $0x4319
    160f:	e8 7b 22 00 00       	call   388f <link>
    1614:	83 c4 10             	add    $0x10,%esp
    1617:	e9 4e 02 00 00       	jmp    186a <concreate+0x296>
    } else if(pid == 0 && (i % 5) == 1){
    161c:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1621:	89 d8                	mov    %ebx,%eax
    1623:	f7 ea                	imul   %edx
    1625:	d1 fa                	sar    %edx
    1627:	89 d8                	mov    %ebx,%eax
    1629:	c1 f8 1f             	sar    $0x1f,%eax
    162c:	29 c2                	sub    %eax,%edx
    162e:	8d 04 92             	lea    (%edx,%edx,4),%eax
    1631:	29 c3                	sub    %eax,%ebx
    1633:	83 fb 01             	cmp    $0x1,%ebx
    1636:	74 34                	je     166c <concreate+0x98>
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1638:	83 ec 08             	sub    $0x8,%esp
    163b:	68 02 02 00 00       	push   $0x202
    1640:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1643:	50                   	push   %eax
    1644:	e8 26 22 00 00       	call   386f <open>
      if(fd < 0){
    1649:	83 c4 10             	add    $0x10,%esp
    164c:	85 c0                	test   %eax,%eax
    164e:	0f 89 f9 01 00 00    	jns    184d <concreate+0x279>
        printf(1, "concreate create %s failed\n", file);
    1654:	83 ec 04             	sub    $0x4,%esp
    1657:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    165a:	50                   	push   %eax
    165b:	68 1c 43 00 00       	push   $0x431c
    1660:	6a 01                	push   $0x1
    1662:	e8 32 23 00 00       	call   3999 <printf>
        exit();
    1667:	e8 c3 21 00 00       	call   382f <exit>
      link("C0", file);
    166c:	83 ec 08             	sub    $0x8,%esp
    166f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1672:	50                   	push   %eax
    1673:	68 19 43 00 00       	push   $0x4319
    1678:	e8 12 22 00 00       	call   388f <link>
    167d:	83 c4 10             	add    $0x10,%esp
      }
      close(fd);
    }
    if(pid == 0)
      exit();
    1680:	e8 aa 21 00 00       	call   382f <exit>
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1685:	83 ec 04             	sub    $0x4,%esp
    1688:	6a 28                	push   $0x28
    168a:	6a 00                	push   $0x0
    168c:	8d 45 bd             	lea    -0x43(%ebp),%eax
    168f:	50                   	push   %eax
    1690:	e8 b0 1f 00 00       	call   3645 <memset>
  fd = open(".", 0);
    1695:	83 c4 08             	add    $0x8,%esp
    1698:	6a 00                	push   $0x0
    169a:	68 26 45 00 00       	push   $0x4526
    169f:	e8 cb 21 00 00       	call   386f <open>
    16a4:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    16a6:	83 c4 10             	add    $0x10,%esp
  n = 0;
    16a9:	bf 00 00 00 00       	mov    $0x0,%edi
  while(read(fd, &de, sizeof(de)) > 0){
    16ae:	8d 75 ac             	lea    -0x54(%ebp),%esi
    16b1:	83 ec 04             	sub    $0x4,%esp
    16b4:	6a 10                	push   $0x10
    16b6:	56                   	push   %esi
    16b7:	53                   	push   %ebx
    16b8:	e8 8a 21 00 00       	call   3847 <read>
    16bd:	83 c4 10             	add    $0x10,%esp
    16c0:	85 c0                	test   %eax,%eax
    16c2:	7e 60                	jle    1724 <concreate+0x150>
    if(de.inum == 0)
    16c4:	66 83 7d ac 00       	cmpw   $0x0,-0x54(%ebp)
    16c9:	74 e6                	je     16b1 <concreate+0xdd>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    16cb:	80 7d ae 43          	cmpb   $0x43,-0x52(%ebp)
    16cf:	75 e0                	jne    16b1 <concreate+0xdd>
    16d1:	80 7d b0 00          	cmpb   $0x0,-0x50(%ebp)
    16d5:	75 da                	jne    16b1 <concreate+0xdd>
      i = de.name[1] - '0';
    16d7:	0f be 45 af          	movsbl -0x51(%ebp),%eax
    16db:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    16de:	83 f8 27             	cmp    $0x27,%eax
    16e1:	77 11                	ja     16f4 <concreate+0x120>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    16e3:	80 7c 05 bd 00       	cmpb   $0x0,-0x43(%ebp,%eax,1)
    16e8:	75 22                	jne    170c <concreate+0x138>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    16ea:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
      n++;
    16ef:	83 c7 01             	add    $0x1,%edi
    16f2:	eb bd                	jmp    16b1 <concreate+0xdd>
        printf(1, "concreate weird file %s\n", de.name);
    16f4:	83 ec 04             	sub    $0x4,%esp
    16f7:	8d 45 ae             	lea    -0x52(%ebp),%eax
    16fa:	50                   	push   %eax
    16fb:	68 38 43 00 00       	push   $0x4338
    1700:	6a 01                	push   $0x1
    1702:	e8 92 22 00 00       	call   3999 <printf>
        exit();
    1707:	e8 23 21 00 00       	call   382f <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    170c:	83 ec 04             	sub    $0x4,%esp
    170f:	8d 45 ae             	lea    -0x52(%ebp),%eax
    1712:	50                   	push   %eax
    1713:	68 51 43 00 00       	push   $0x4351
    1718:	6a 01                	push   $0x1
    171a:	e8 7a 22 00 00       	call   3999 <printf>
        exit();
    171f:	e8 0b 21 00 00       	call   382f <exit>
    }
  }
  close(fd);
    1724:	83 ec 0c             	sub    $0xc,%esp
    1727:	53                   	push   %ebx
    1728:	e8 2a 21 00 00       	call   3857 <close>

  if(n != 40){
    172d:	83 c4 10             	add    $0x10,%esp
    1730:	83 ff 28             	cmp    $0x28,%edi
    1733:	75 0d                	jne    1742 <concreate+0x16e>
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1735:	bb 00 00 00 00       	mov    $0x0,%ebx
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    173a:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    173d:	e9 88 00 00 00       	jmp    17ca <concreate+0x1f6>
    printf(1, "concreate not enough files in directory listing\n");
    1742:	83 ec 08             	sub    $0x8,%esp
    1745:	68 b8 4e 00 00       	push   $0x4eb8
    174a:	6a 01                	push   $0x1
    174c:	e8 48 22 00 00       	call   3999 <printf>
    exit();
    1751:	e8 d9 20 00 00       	call   382f <exit>
      printf(1, "fork failed\n");
    1756:	83 ec 08             	sub    $0x8,%esp
    1759:	68 f1 4b 00 00       	push   $0x4bf1
    175e:	6a 01                	push   $0x1
    1760:	e8 34 22 00 00       	call   3999 <printf>
      exit();
    1765:	e8 c5 20 00 00       	call   382f <exit>
      close(open(file, 0));
    176a:	83 ec 08             	sub    $0x8,%esp
    176d:	6a 00                	push   $0x0
    176f:	57                   	push   %edi
    1770:	e8 fa 20 00 00       	call   386f <open>
    1775:	89 04 24             	mov    %eax,(%esp)
    1778:	e8 da 20 00 00       	call   3857 <close>
      close(open(file, 0));
    177d:	83 c4 08             	add    $0x8,%esp
    1780:	6a 00                	push   $0x0
    1782:	57                   	push   %edi
    1783:	e8 e7 20 00 00       	call   386f <open>
    1788:	89 04 24             	mov    %eax,(%esp)
    178b:	e8 c7 20 00 00       	call   3857 <close>
      close(open(file, 0));
    1790:	83 c4 08             	add    $0x8,%esp
    1793:	6a 00                	push   $0x0
    1795:	57                   	push   %edi
    1796:	e8 d4 20 00 00       	call   386f <open>
    179b:	89 04 24             	mov    %eax,(%esp)
    179e:	e8 b4 20 00 00       	call   3857 <close>
      close(open(file, 0));
    17a3:	83 c4 08             	add    $0x8,%esp
    17a6:	6a 00                	push   $0x0
    17a8:	57                   	push   %edi
    17a9:	e8 c1 20 00 00       	call   386f <open>
    17ae:	89 04 24             	mov    %eax,(%esp)
    17b1:	e8 a1 20 00 00       	call   3857 <close>
    17b6:	83 c4 10             	add    $0x10,%esp
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    17b9:	85 f6                	test   %esi,%esi
    17bb:	74 74                	je     1831 <concreate+0x25d>
      exit();
    else
      wait();
    17bd:	e8 75 20 00 00       	call   3837 <wait>
  for(i = 0; i < 40; i++){
    17c2:	83 c3 01             	add    $0x1,%ebx
    17c5:	83 fb 28             	cmp    $0x28,%ebx
    17c8:	74 6c                	je     1836 <concreate+0x262>
    file[1] = '0' + i;
    17ca:	8d 43 30             	lea    0x30(%ebx),%eax
    17cd:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    17d0:	e8 52 20 00 00       	call   3827 <fork>
    17d5:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    17d7:	85 c0                	test   %eax,%eax
    17d9:	0f 88 77 ff ff ff    	js     1756 <concreate+0x182>
    if(((i % 3) == 0 && pid == 0) ||
    17df:	b8 56 55 55 55       	mov    $0x55555556,%eax
    17e4:	f7 eb                	imul   %ebx
    17e6:	89 d8                	mov    %ebx,%eax
    17e8:	c1 f8 1f             	sar    $0x1f,%eax
    17eb:	29 c2                	sub    %eax,%edx
    17ed:	8d 04 52             	lea    (%edx,%edx,2),%eax
    17f0:	89 da                	mov    %ebx,%edx
    17f2:	29 c2                	sub    %eax,%edx
    17f4:	89 d0                	mov    %edx,%eax
    17f6:	09 f0                	or     %esi,%eax
    17f8:	0f 84 6c ff ff ff    	je     176a <concreate+0x196>
       ((i % 3) == 1 && pid != 0)){
    17fe:	85 f6                	test   %esi,%esi
    1800:	74 09                	je     180b <concreate+0x237>
    1802:	83 fa 01             	cmp    $0x1,%edx
    1805:	0f 84 5f ff ff ff    	je     176a <concreate+0x196>
      unlink(file);
    180b:	83 ec 0c             	sub    $0xc,%esp
    180e:	57                   	push   %edi
    180f:	e8 6b 20 00 00       	call   387f <unlink>
      unlink(file);
    1814:	89 3c 24             	mov    %edi,(%esp)
    1817:	e8 63 20 00 00       	call   387f <unlink>
      unlink(file);
    181c:	89 3c 24             	mov    %edi,(%esp)
    181f:	e8 5b 20 00 00       	call   387f <unlink>
      unlink(file);
    1824:	89 3c 24             	mov    %edi,(%esp)
    1827:	e8 53 20 00 00       	call   387f <unlink>
    182c:	83 c4 10             	add    $0x10,%esp
    182f:	eb 88                	jmp    17b9 <concreate+0x1e5>
      exit();
    1831:	e8 f9 1f 00 00       	call   382f <exit>
  }

  printf(1, "concreate ok\n");
    1836:	83 ec 08             	sub    $0x8,%esp
    1839:	68 6e 43 00 00       	push   $0x436e
    183e:	6a 01                	push   $0x1
    1840:	e8 54 21 00 00       	call   3999 <printf>
}
    1845:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1848:	5b                   	pop    %ebx
    1849:	5e                   	pop    %esi
    184a:	5f                   	pop    %edi
    184b:	5d                   	pop    %ebp
    184c:	c3                   	ret    
      close(fd);
    184d:	83 ec 0c             	sub    $0xc,%esp
    1850:	50                   	push   %eax
    1851:	e8 01 20 00 00       	call   3857 <close>
    1856:	83 c4 10             	add    $0x10,%esp
    1859:	e9 22 fe ff ff       	jmp    1680 <concreate+0xac>
    185e:	83 ec 0c             	sub    $0xc,%esp
    1861:	50                   	push   %eax
    1862:	e8 f0 1f 00 00       	call   3857 <close>
    1867:	83 c4 10             	add    $0x10,%esp
      wait();
    186a:	e8 c8 1f 00 00       	call   3837 <wait>
  for(i = 0; i < 40; i++){
    186f:	83 c3 01             	add    $0x1,%ebx
    1872:	83 fb 28             	cmp    $0x28,%ebx
    1875:	0f 84 0a fe ff ff    	je     1685 <concreate+0xb1>
    file[1] = '0' + i;
    187b:	8d 43 30             	lea    0x30(%ebx),%eax
    187e:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1881:	83 ec 0c             	sub    $0xc,%esp
    1884:	56                   	push   %esi
    1885:	e8 f5 1f 00 00       	call   387f <unlink>
    pid = fork();
    188a:	e8 98 1f 00 00       	call   3827 <fork>
    if(pid && (i % 3) == 1){
    188f:	83 c4 10             	add    $0x10,%esp
    1892:	85 c0                	test   %eax,%eax
    1894:	0f 84 82 fd ff ff    	je     161c <concreate+0x48>
    189a:	89 d8                	mov    %ebx,%eax
    189c:	f7 ef                	imul   %edi
    189e:	89 d8                	mov    %ebx,%eax
    18a0:	c1 f8 1f             	sar    $0x1f,%eax
    18a3:	29 c2                	sub    %eax,%edx
    18a5:	8d 04 52             	lea    (%edx,%edx,2),%eax
    18a8:	89 d9                	mov    %ebx,%ecx
    18aa:	29 c1                	sub    %eax,%ecx
    18ac:	83 f9 01             	cmp    $0x1,%ecx
    18af:	0f 84 51 fd ff ff    	je     1606 <concreate+0x32>
      fd = open(file, O_CREATE | O_RDWR);
    18b5:	83 ec 08             	sub    $0x8,%esp
    18b8:	68 02 02 00 00       	push   $0x202
    18bd:	56                   	push   %esi
    18be:	e8 ac 1f 00 00       	call   386f <open>
      if(fd < 0){
    18c3:	83 c4 10             	add    $0x10,%esp
    18c6:	85 c0                	test   %eax,%eax
    18c8:	79 94                	jns    185e <concreate+0x28a>
    18ca:	e9 85 fd ff ff       	jmp    1654 <concreate+0x80>

000018cf <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    18cf:	55                   	push   %ebp
    18d0:	89 e5                	mov    %esp,%ebp
    18d2:	57                   	push   %edi
    18d3:	56                   	push   %esi
    18d4:	53                   	push   %ebx
    18d5:	83 ec 24             	sub    $0x24,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    18d8:	68 7c 43 00 00       	push   $0x437c
    18dd:	6a 01                	push   $0x1
    18df:	e8 b5 20 00 00       	call   3999 <printf>

  unlink("x");
    18e4:	c7 04 24 09 46 00 00 	movl   $0x4609,(%esp)
    18eb:	e8 8f 1f 00 00       	call   387f <unlink>
  pid = fork();
    18f0:	e8 32 1f 00 00       	call   3827 <fork>
    18f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    18f8:	83 c4 10             	add    $0x10,%esp
    18fb:	85 c0                	test   %eax,%eax
    18fd:	78 18                	js     1917 <linkunlink+0x48>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    18ff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1903:	19 db                	sbb    %ebx,%ebx
    1905:	83 e3 60             	and    $0x60,%ebx
    1908:	83 c3 01             	add    $0x1,%ebx
    190b:	be 64 00 00 00       	mov    $0x64,%esi
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
    1910:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
    1915:	eb 36                	jmp    194d <linkunlink+0x7e>
    printf(1, "fork failed\n");
    1917:	83 ec 08             	sub    $0x8,%esp
    191a:	68 f1 4b 00 00       	push   $0x4bf1
    191f:	6a 01                	push   $0x1
    1921:	e8 73 20 00 00       	call   3999 <printf>
    exit();
    1926:	e8 04 1f 00 00       	call   382f <exit>
      close(open("x", O_RDWR | O_CREATE));
    192b:	83 ec 08             	sub    $0x8,%esp
    192e:	68 02 02 00 00       	push   $0x202
    1933:	68 09 46 00 00       	push   $0x4609
    1938:	e8 32 1f 00 00       	call   386f <open>
    193d:	89 04 24             	mov    %eax,(%esp)
    1940:	e8 12 1f 00 00       	call   3857 <close>
    1945:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1948:	83 ee 01             	sub    $0x1,%esi
    194b:	74 49                	je     1996 <linkunlink+0xc7>
    x = x * 1103515245 + 12345;
    194d:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
    1953:	81 c3 39 30 00 00    	add    $0x3039,%ebx
    if((x % 3) == 0){
    1959:	89 d8                	mov    %ebx,%eax
    195b:	f7 e7                	mul    %edi
    195d:	d1 ea                	shr    %edx
    195f:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1962:	89 da                	mov    %ebx,%edx
    1964:	29 c2                	sub    %eax,%edx
    1966:	74 c3                	je     192b <linkunlink+0x5c>
    } else if((x % 3) == 1){
    1968:	83 fa 01             	cmp    $0x1,%edx
    196b:	74 12                	je     197f <linkunlink+0xb0>
      link("cat", "x");
    } else {
      unlink("x");
    196d:	83 ec 0c             	sub    $0xc,%esp
    1970:	68 09 46 00 00       	push   $0x4609
    1975:	e8 05 1f 00 00       	call   387f <unlink>
    197a:	83 c4 10             	add    $0x10,%esp
    197d:	eb c9                	jmp    1948 <linkunlink+0x79>
      link("cat", "x");
    197f:	83 ec 08             	sub    $0x8,%esp
    1982:	68 09 46 00 00       	push   $0x4609
    1987:	68 8d 43 00 00       	push   $0x438d
    198c:	e8 fe 1e 00 00       	call   388f <link>
    1991:	83 c4 10             	add    $0x10,%esp
    1994:	eb b2                	jmp    1948 <linkunlink+0x79>
    }
  }

  if(pid)
    1996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    199a:	74 1c                	je     19b8 <linkunlink+0xe9>
    wait();
    199c:	e8 96 1e 00 00       	call   3837 <wait>
  else
    exit();

  printf(1, "linkunlink ok\n");
    19a1:	83 ec 08             	sub    $0x8,%esp
    19a4:	68 91 43 00 00       	push   $0x4391
    19a9:	6a 01                	push   $0x1
    19ab:	e8 e9 1f 00 00       	call   3999 <printf>
}
    19b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    19b3:	5b                   	pop    %ebx
    19b4:	5e                   	pop    %esi
    19b5:	5f                   	pop    %edi
    19b6:	5d                   	pop    %ebp
    19b7:	c3                   	ret    
    exit();
    19b8:	e8 72 1e 00 00       	call   382f <exit>

000019bd <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    19bd:	55                   	push   %ebp
    19be:	89 e5                	mov    %esp,%ebp
    19c0:	57                   	push   %edi
    19c1:	56                   	push   %esi
    19c2:	53                   	push   %ebx
    19c3:	83 ec 24             	sub    $0x24,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    19c6:	68 a0 43 00 00       	push   $0x43a0
    19cb:	6a 01                	push   $0x1
    19cd:	e8 c7 1f 00 00       	call   3999 <printf>
  unlink("bd");
    19d2:	c7 04 24 ad 43 00 00 	movl   $0x43ad,(%esp)
    19d9:	e8 a1 1e 00 00       	call   387f <unlink>

  fd = open("bd", O_CREATE);
    19de:	83 c4 08             	add    $0x8,%esp
    19e1:	68 00 02 00 00       	push   $0x200
    19e6:	68 ad 43 00 00       	push   $0x43ad
    19eb:	e8 7f 1e 00 00       	call   386f <open>
  if(fd < 0){
    19f0:	83 c4 10             	add    $0x10,%esp
    19f3:	85 c0                	test   %eax,%eax
    19f5:	0f 88 e0 00 00 00    	js     1adb <bigdir+0x11e>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
    19fb:	83 ec 0c             	sub    $0xc,%esp
    19fe:	50                   	push   %eax
    19ff:	e8 53 1e 00 00       	call   3857 <close>
    1a04:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1a07:	be 00 00 00 00       	mov    $0x0,%esi
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
    1a0c:	8d 7d de             	lea    -0x22(%ebp),%edi
    name[0] = 'x';
    1a0f:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1a13:	8d 46 3f             	lea    0x3f(%esi),%eax
    1a16:	85 f6                	test   %esi,%esi
    1a18:	0f 49 c6             	cmovns %esi,%eax
    1a1b:	c1 f8 06             	sar    $0x6,%eax
    1a1e:	83 c0 30             	add    $0x30,%eax
    1a21:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1a24:	89 f2                	mov    %esi,%edx
    1a26:	c1 fa 1f             	sar    $0x1f,%edx
    1a29:	c1 ea 1a             	shr    $0x1a,%edx
    1a2c:	8d 04 16             	lea    (%esi,%edx,1),%eax
    1a2f:	83 e0 3f             	and    $0x3f,%eax
    1a32:	29 d0                	sub    %edx,%eax
    1a34:	83 c0 30             	add    $0x30,%eax
    1a37:	88 45 e0             	mov    %al,-0x20(%ebp)
    name[3] = '\0';
    1a3a:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    if(link("bd", name) != 0){
    1a3e:	83 ec 08             	sub    $0x8,%esp
    1a41:	57                   	push   %edi
    1a42:	68 ad 43 00 00       	push   $0x43ad
    1a47:	e8 43 1e 00 00       	call   388f <link>
    1a4c:	89 c3                	mov    %eax,%ebx
    1a4e:	83 c4 10             	add    $0x10,%esp
    1a51:	85 c0                	test   %eax,%eax
    1a53:	0f 85 96 00 00 00    	jne    1aef <bigdir+0x132>
  for(i = 0; i < 500; i++){
    1a59:	83 c6 01             	add    $0x1,%esi
    1a5c:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1a62:	75 ab                	jne    1a0f <bigdir+0x52>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1a64:	83 ec 0c             	sub    $0xc,%esp
    1a67:	68 ad 43 00 00       	push   $0x43ad
    1a6c:	e8 0e 1e 00 00       	call   387f <unlink>
    1a71:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(unlink(name) != 0){
    1a74:	8d 75 de             	lea    -0x22(%ebp),%esi
    name[0] = 'x';
    1a77:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1a7b:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1a7e:	85 db                	test   %ebx,%ebx
    1a80:	0f 49 c3             	cmovns %ebx,%eax
    1a83:	c1 f8 06             	sar    $0x6,%eax
    1a86:	83 c0 30             	add    $0x30,%eax
    1a89:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1a8c:	89 da                	mov    %ebx,%edx
    1a8e:	c1 fa 1f             	sar    $0x1f,%edx
    1a91:	c1 ea 1a             	shr    $0x1a,%edx
    1a94:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    1a97:	83 e0 3f             	and    $0x3f,%eax
    1a9a:	29 d0                	sub    %edx,%eax
    1a9c:	83 c0 30             	add    $0x30,%eax
    1a9f:	88 45 e0             	mov    %al,-0x20(%ebp)
    name[3] = '\0';
    1aa2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    if(unlink(name) != 0){
    1aa6:	83 ec 0c             	sub    $0xc,%esp
    1aa9:	56                   	push   %esi
    1aaa:	e8 d0 1d 00 00       	call   387f <unlink>
    1aaf:	83 c4 10             	add    $0x10,%esp
    1ab2:	85 c0                	test   %eax,%eax
    1ab4:	75 4d                	jne    1b03 <bigdir+0x146>
  for(i = 0; i < 500; i++){
    1ab6:	83 c3 01             	add    $0x1,%ebx
    1ab9:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1abf:	75 b6                	jne    1a77 <bigdir+0xba>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1ac1:	83 ec 08             	sub    $0x8,%esp
    1ac4:	68 ef 43 00 00       	push   $0x43ef
    1ac9:	6a 01                	push   $0x1
    1acb:	e8 c9 1e 00 00       	call   3999 <printf>
}
    1ad0:	83 c4 10             	add    $0x10,%esp
    1ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1ad6:	5b                   	pop    %ebx
    1ad7:	5e                   	pop    %esi
    1ad8:	5f                   	pop    %edi
    1ad9:	5d                   	pop    %ebp
    1ada:	c3                   	ret    
    printf(1, "bigdir create failed\n");
    1adb:	83 ec 08             	sub    $0x8,%esp
    1ade:	68 b0 43 00 00       	push   $0x43b0
    1ae3:	6a 01                	push   $0x1
    1ae5:	e8 af 1e 00 00       	call   3999 <printf>
    exit();
    1aea:	e8 40 1d 00 00       	call   382f <exit>
      printf(1, "bigdir link failed\n");
    1aef:	83 ec 08             	sub    $0x8,%esp
    1af2:	68 c6 43 00 00       	push   $0x43c6
    1af7:	6a 01                	push   $0x1
    1af9:	e8 9b 1e 00 00       	call   3999 <printf>
      exit();
    1afe:	e8 2c 1d 00 00       	call   382f <exit>
      printf(1, "bigdir unlink failed");
    1b03:	83 ec 08             	sub    $0x8,%esp
    1b06:	68 da 43 00 00       	push   $0x43da
    1b0b:	6a 01                	push   $0x1
    1b0d:	e8 87 1e 00 00       	call   3999 <printf>
      exit();
    1b12:	e8 18 1d 00 00       	call   382f <exit>

00001b17 <subdir>:

void
subdir(void)
{
    1b17:	55                   	push   %ebp
    1b18:	89 e5                	mov    %esp,%ebp
    1b1a:	53                   	push   %ebx
    1b1b:	83 ec 0c             	sub    $0xc,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1b1e:	68 fa 43 00 00       	push   $0x43fa
    1b23:	6a 01                	push   $0x1
    1b25:	e8 6f 1e 00 00       	call   3999 <printf>

  unlink("ff");
    1b2a:	c7 04 24 83 44 00 00 	movl   $0x4483,(%esp)
    1b31:	e8 49 1d 00 00       	call   387f <unlink>
  if(mkdir("dd") != 0){
    1b36:	c7 04 24 20 45 00 00 	movl   $0x4520,(%esp)
    1b3d:	e8 55 1d 00 00       	call   3897 <mkdir>
    1b42:	83 c4 10             	add    $0x10,%esp
    1b45:	85 c0                	test   %eax,%eax
    1b47:	0f 85 14 04 00 00    	jne    1f61 <subdir+0x44a>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1b4d:	83 ec 08             	sub    $0x8,%esp
    1b50:	68 02 02 00 00       	push   $0x202
    1b55:	68 59 44 00 00       	push   $0x4459
    1b5a:	e8 10 1d 00 00       	call   386f <open>
    1b5f:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1b61:	83 c4 10             	add    $0x10,%esp
    1b64:	85 c0                	test   %eax,%eax
    1b66:	0f 88 09 04 00 00    	js     1f75 <subdir+0x45e>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    1b6c:	83 ec 04             	sub    $0x4,%esp
    1b6f:	6a 02                	push   $0x2
    1b71:	68 83 44 00 00       	push   $0x4483
    1b76:	50                   	push   %eax
    1b77:	e8 d3 1c 00 00       	call   384f <write>
  close(fd);
    1b7c:	89 1c 24             	mov    %ebx,(%esp)
    1b7f:	e8 d3 1c 00 00       	call   3857 <close>

  if(unlink("dd") >= 0){
    1b84:	c7 04 24 20 45 00 00 	movl   $0x4520,(%esp)
    1b8b:	e8 ef 1c 00 00       	call   387f <unlink>
    1b90:	83 c4 10             	add    $0x10,%esp
    1b93:	85 c0                	test   %eax,%eax
    1b95:	0f 89 ee 03 00 00    	jns    1f89 <subdir+0x472>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    1b9b:	83 ec 0c             	sub    $0xc,%esp
    1b9e:	68 34 44 00 00       	push   $0x4434
    1ba3:	e8 ef 1c 00 00       	call   3897 <mkdir>
    1ba8:	83 c4 10             	add    $0x10,%esp
    1bab:	85 c0                	test   %eax,%eax
    1bad:	0f 85 ea 03 00 00    	jne    1f9d <subdir+0x486>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1bb3:	83 ec 08             	sub    $0x8,%esp
    1bb6:	68 02 02 00 00       	push   $0x202
    1bbb:	68 56 44 00 00       	push   $0x4456
    1bc0:	e8 aa 1c 00 00       	call   386f <open>
    1bc5:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1bc7:	83 c4 10             	add    $0x10,%esp
    1bca:	85 c0                	test   %eax,%eax
    1bcc:	0f 88 df 03 00 00    	js     1fb1 <subdir+0x49a>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    1bd2:	83 ec 04             	sub    $0x4,%esp
    1bd5:	6a 02                	push   $0x2
    1bd7:	68 77 44 00 00       	push   $0x4477
    1bdc:	50                   	push   %eax
    1bdd:	e8 6d 1c 00 00       	call   384f <write>
  close(fd);
    1be2:	89 1c 24             	mov    %ebx,(%esp)
    1be5:	e8 6d 1c 00 00       	call   3857 <close>

  fd = open("dd/dd/../ff", 0);
    1bea:	83 c4 08             	add    $0x8,%esp
    1bed:	6a 00                	push   $0x0
    1bef:	68 7a 44 00 00       	push   $0x447a
    1bf4:	e8 76 1c 00 00       	call   386f <open>
    1bf9:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1bfb:	83 c4 10             	add    $0x10,%esp
    1bfe:	85 c0                	test   %eax,%eax
    1c00:	0f 88 bf 03 00 00    	js     1fc5 <subdir+0x4ae>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    1c06:	83 ec 04             	sub    $0x4,%esp
    1c09:	68 00 20 00 00       	push   $0x2000
    1c0e:	68 00 85 00 00       	push   $0x8500
    1c13:	50                   	push   %eax
    1c14:	e8 2e 1c 00 00       	call   3847 <read>
  if(cc != 2 || buf[0] != 'f'){
    1c19:	83 c4 10             	add    $0x10,%esp
    1c1c:	83 f8 02             	cmp    $0x2,%eax
    1c1f:	0f 85 b4 03 00 00    	jne    1fd9 <subdir+0x4c2>
    1c25:	80 3d 00 85 00 00 66 	cmpb   $0x66,0x8500
    1c2c:	0f 85 a7 03 00 00    	jne    1fd9 <subdir+0x4c2>
    printf(1, "dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
    1c32:	83 ec 0c             	sub    $0xc,%esp
    1c35:	53                   	push   %ebx
    1c36:	e8 1c 1c 00 00       	call   3857 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1c3b:	83 c4 08             	add    $0x8,%esp
    1c3e:	68 ba 44 00 00       	push   $0x44ba
    1c43:	68 56 44 00 00       	push   $0x4456
    1c48:	e8 42 1c 00 00       	call   388f <link>
    1c4d:	83 c4 10             	add    $0x10,%esp
    1c50:	85 c0                	test   %eax,%eax
    1c52:	0f 85 95 03 00 00    	jne    1fed <subdir+0x4d6>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    1c58:	83 ec 0c             	sub    $0xc,%esp
    1c5b:	68 56 44 00 00       	push   $0x4456
    1c60:	e8 1a 1c 00 00       	call   387f <unlink>
    1c65:	83 c4 10             	add    $0x10,%esp
    1c68:	85 c0                	test   %eax,%eax
    1c6a:	0f 85 91 03 00 00    	jne    2001 <subdir+0x4ea>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1c70:	83 ec 08             	sub    $0x8,%esp
    1c73:	6a 00                	push   $0x0
    1c75:	68 56 44 00 00       	push   $0x4456
    1c7a:	e8 f0 1b 00 00       	call   386f <open>
    1c7f:	83 c4 10             	add    $0x10,%esp
    1c82:	85 c0                	test   %eax,%eax
    1c84:	0f 89 8b 03 00 00    	jns    2015 <subdir+0x4fe>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    1c8a:	83 ec 0c             	sub    $0xc,%esp
    1c8d:	68 20 45 00 00       	push   $0x4520
    1c92:	e8 08 1c 00 00       	call   389f <chdir>
    1c97:	83 c4 10             	add    $0x10,%esp
    1c9a:	85 c0                	test   %eax,%eax
    1c9c:	0f 85 87 03 00 00    	jne    2029 <subdir+0x512>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    1ca2:	83 ec 0c             	sub    $0xc,%esp
    1ca5:	68 ee 44 00 00       	push   $0x44ee
    1caa:	e8 f0 1b 00 00       	call   389f <chdir>
    1caf:	83 c4 10             	add    $0x10,%esp
    1cb2:	85 c0                	test   %eax,%eax
    1cb4:	0f 85 83 03 00 00    	jne    203d <subdir+0x526>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    1cba:	83 ec 0c             	sub    $0xc,%esp
    1cbd:	68 14 45 00 00       	push   $0x4514
    1cc2:	e8 d8 1b 00 00       	call   389f <chdir>
    1cc7:	83 c4 10             	add    $0x10,%esp
    1cca:	85 c0                	test   %eax,%eax
    1ccc:	0f 85 7f 03 00 00    	jne    2051 <subdir+0x53a>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    1cd2:	83 ec 0c             	sub    $0xc,%esp
    1cd5:	68 23 45 00 00       	push   $0x4523
    1cda:	e8 c0 1b 00 00       	call   389f <chdir>
    1cdf:	83 c4 10             	add    $0x10,%esp
    1ce2:	85 c0                	test   %eax,%eax
    1ce4:	0f 85 7b 03 00 00    	jne    2065 <subdir+0x54e>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    1cea:	83 ec 08             	sub    $0x8,%esp
    1ced:	6a 00                	push   $0x0
    1cef:	68 ba 44 00 00       	push   $0x44ba
    1cf4:	e8 76 1b 00 00       	call   386f <open>
    1cf9:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1cfb:	83 c4 10             	add    $0x10,%esp
    1cfe:	85 c0                	test   %eax,%eax
    1d00:	0f 88 73 03 00 00    	js     2079 <subdir+0x562>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1d06:	83 ec 04             	sub    $0x4,%esp
    1d09:	68 00 20 00 00       	push   $0x2000
    1d0e:	68 00 85 00 00       	push   $0x8500
    1d13:	50                   	push   %eax
    1d14:	e8 2e 1b 00 00       	call   3847 <read>
    1d19:	83 c4 10             	add    $0x10,%esp
    1d1c:	83 f8 02             	cmp    $0x2,%eax
    1d1f:	0f 85 68 03 00 00    	jne    208d <subdir+0x576>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    1d25:	83 ec 0c             	sub    $0xc,%esp
    1d28:	53                   	push   %ebx
    1d29:	e8 29 1b 00 00       	call   3857 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1d2e:	83 c4 08             	add    $0x8,%esp
    1d31:	6a 00                	push   $0x0
    1d33:	68 56 44 00 00       	push   $0x4456
    1d38:	e8 32 1b 00 00       	call   386f <open>
    1d3d:	83 c4 10             	add    $0x10,%esp
    1d40:	85 c0                	test   %eax,%eax
    1d42:	0f 89 59 03 00 00    	jns    20a1 <subdir+0x58a>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1d48:	83 ec 08             	sub    $0x8,%esp
    1d4b:	68 02 02 00 00       	push   $0x202
    1d50:	68 6e 45 00 00       	push   $0x456e
    1d55:	e8 15 1b 00 00       	call   386f <open>
    1d5a:	83 c4 10             	add    $0x10,%esp
    1d5d:	85 c0                	test   %eax,%eax
    1d5f:	0f 89 50 03 00 00    	jns    20b5 <subdir+0x59e>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1d65:	83 ec 08             	sub    $0x8,%esp
    1d68:	68 02 02 00 00       	push   $0x202
    1d6d:	68 93 45 00 00       	push   $0x4593
    1d72:	e8 f8 1a 00 00       	call   386f <open>
    1d77:	83 c4 10             	add    $0x10,%esp
    1d7a:	85 c0                	test   %eax,%eax
    1d7c:	0f 89 47 03 00 00    	jns    20c9 <subdir+0x5b2>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    1d82:	83 ec 08             	sub    $0x8,%esp
    1d85:	68 00 02 00 00       	push   $0x200
    1d8a:	68 20 45 00 00       	push   $0x4520
    1d8f:	e8 db 1a 00 00       	call   386f <open>
    1d94:	83 c4 10             	add    $0x10,%esp
    1d97:	85 c0                	test   %eax,%eax
    1d99:	0f 89 3e 03 00 00    	jns    20dd <subdir+0x5c6>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    1d9f:	83 ec 08             	sub    $0x8,%esp
    1da2:	6a 02                	push   $0x2
    1da4:	68 20 45 00 00       	push   $0x4520
    1da9:	e8 c1 1a 00 00       	call   386f <open>
    1dae:	83 c4 10             	add    $0x10,%esp
    1db1:	85 c0                	test   %eax,%eax
    1db3:	0f 89 38 03 00 00    	jns    20f1 <subdir+0x5da>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    1db9:	83 ec 08             	sub    $0x8,%esp
    1dbc:	6a 01                	push   $0x1
    1dbe:	68 20 45 00 00       	push   $0x4520
    1dc3:	e8 a7 1a 00 00       	call   386f <open>
    1dc8:	83 c4 10             	add    $0x10,%esp
    1dcb:	85 c0                	test   %eax,%eax
    1dcd:	0f 89 32 03 00 00    	jns    2105 <subdir+0x5ee>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1dd3:	83 ec 08             	sub    $0x8,%esp
    1dd6:	68 02 46 00 00       	push   $0x4602
    1ddb:	68 6e 45 00 00       	push   $0x456e
    1de0:	e8 aa 1a 00 00       	call   388f <link>
    1de5:	83 c4 10             	add    $0x10,%esp
    1de8:	85 c0                	test   %eax,%eax
    1dea:	0f 84 29 03 00 00    	je     2119 <subdir+0x602>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1df0:	83 ec 08             	sub    $0x8,%esp
    1df3:	68 02 46 00 00       	push   $0x4602
    1df8:	68 93 45 00 00       	push   $0x4593
    1dfd:	e8 8d 1a 00 00       	call   388f <link>
    1e02:	83 c4 10             	add    $0x10,%esp
    1e05:	85 c0                	test   %eax,%eax
    1e07:	0f 84 20 03 00 00    	je     212d <subdir+0x616>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1e0d:	83 ec 08             	sub    $0x8,%esp
    1e10:	68 ba 44 00 00       	push   $0x44ba
    1e15:	68 59 44 00 00       	push   $0x4459
    1e1a:	e8 70 1a 00 00       	call   388f <link>
    1e1f:	83 c4 10             	add    $0x10,%esp
    1e22:	85 c0                	test   %eax,%eax
    1e24:	0f 84 17 03 00 00    	je     2141 <subdir+0x62a>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    1e2a:	83 ec 0c             	sub    $0xc,%esp
    1e2d:	68 6e 45 00 00       	push   $0x456e
    1e32:	e8 60 1a 00 00       	call   3897 <mkdir>
    1e37:	83 c4 10             	add    $0x10,%esp
    1e3a:	85 c0                	test   %eax,%eax
    1e3c:	0f 84 13 03 00 00    	je     2155 <subdir+0x63e>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    1e42:	83 ec 0c             	sub    $0xc,%esp
    1e45:	68 93 45 00 00       	push   $0x4593
    1e4a:	e8 48 1a 00 00       	call   3897 <mkdir>
    1e4f:	83 c4 10             	add    $0x10,%esp
    1e52:	85 c0                	test   %eax,%eax
    1e54:	0f 84 0f 03 00 00    	je     2169 <subdir+0x652>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    1e5a:	83 ec 0c             	sub    $0xc,%esp
    1e5d:	68 ba 44 00 00       	push   $0x44ba
    1e62:	e8 30 1a 00 00       	call   3897 <mkdir>
    1e67:	83 c4 10             	add    $0x10,%esp
    1e6a:	85 c0                	test   %eax,%eax
    1e6c:	0f 84 0b 03 00 00    	je     217d <subdir+0x666>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    1e72:	83 ec 0c             	sub    $0xc,%esp
    1e75:	68 93 45 00 00       	push   $0x4593
    1e7a:	e8 00 1a 00 00       	call   387f <unlink>
    1e7f:	83 c4 10             	add    $0x10,%esp
    1e82:	85 c0                	test   %eax,%eax
    1e84:	0f 84 07 03 00 00    	je     2191 <subdir+0x67a>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    1e8a:	83 ec 0c             	sub    $0xc,%esp
    1e8d:	68 6e 45 00 00       	push   $0x456e
    1e92:	e8 e8 19 00 00       	call   387f <unlink>
    1e97:	83 c4 10             	add    $0x10,%esp
    1e9a:	85 c0                	test   %eax,%eax
    1e9c:	0f 84 03 03 00 00    	je     21a5 <subdir+0x68e>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    1ea2:	83 ec 0c             	sub    $0xc,%esp
    1ea5:	68 59 44 00 00       	push   $0x4459
    1eaa:	e8 f0 19 00 00       	call   389f <chdir>
    1eaf:	83 c4 10             	add    $0x10,%esp
    1eb2:	85 c0                	test   %eax,%eax
    1eb4:	0f 84 ff 02 00 00    	je     21b9 <subdir+0x6a2>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    1eba:	83 ec 0c             	sub    $0xc,%esp
    1ebd:	68 05 46 00 00       	push   $0x4605
    1ec2:	e8 d8 19 00 00       	call   389f <chdir>
    1ec7:	83 c4 10             	add    $0x10,%esp
    1eca:	85 c0                	test   %eax,%eax
    1ecc:	0f 84 fb 02 00 00    	je     21cd <subdir+0x6b6>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    1ed2:	83 ec 0c             	sub    $0xc,%esp
    1ed5:	68 ba 44 00 00       	push   $0x44ba
    1eda:	e8 a0 19 00 00       	call   387f <unlink>
    1edf:	83 c4 10             	add    $0x10,%esp
    1ee2:	85 c0                	test   %eax,%eax
    1ee4:	0f 85 f7 02 00 00    	jne    21e1 <subdir+0x6ca>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    1eea:	83 ec 0c             	sub    $0xc,%esp
    1eed:	68 59 44 00 00       	push   $0x4459
    1ef2:	e8 88 19 00 00       	call   387f <unlink>
    1ef7:	83 c4 10             	add    $0x10,%esp
    1efa:	85 c0                	test   %eax,%eax
    1efc:	0f 85 f3 02 00 00    	jne    21f5 <subdir+0x6de>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    1f02:	83 ec 0c             	sub    $0xc,%esp
    1f05:	68 20 45 00 00       	push   $0x4520
    1f0a:	e8 70 19 00 00       	call   387f <unlink>
    1f0f:	83 c4 10             	add    $0x10,%esp
    1f12:	85 c0                	test   %eax,%eax
    1f14:	0f 84 ef 02 00 00    	je     2209 <subdir+0x6f2>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    1f1a:	83 ec 0c             	sub    $0xc,%esp
    1f1d:	68 35 44 00 00       	push   $0x4435
    1f22:	e8 58 19 00 00       	call   387f <unlink>
    1f27:	83 c4 10             	add    $0x10,%esp
    1f2a:	85 c0                	test   %eax,%eax
    1f2c:	0f 88 eb 02 00 00    	js     221d <subdir+0x706>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    1f32:	83 ec 0c             	sub    $0xc,%esp
    1f35:	68 20 45 00 00       	push   $0x4520
    1f3a:	e8 40 19 00 00       	call   387f <unlink>
    1f3f:	83 c4 10             	add    $0x10,%esp
    1f42:	85 c0                	test   %eax,%eax
    1f44:	0f 88 e7 02 00 00    	js     2231 <subdir+0x71a>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    1f4a:	83 ec 08             	sub    $0x8,%esp
    1f4d:	68 02 47 00 00       	push   $0x4702
    1f52:	6a 01                	push   $0x1
    1f54:	e8 40 1a 00 00       	call   3999 <printf>
}
    1f59:	83 c4 10             	add    $0x10,%esp
    1f5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1f5f:	c9                   	leave  
    1f60:	c3                   	ret    
    printf(1, "subdir mkdir dd failed\n");
    1f61:	83 ec 08             	sub    $0x8,%esp
    1f64:	68 07 44 00 00       	push   $0x4407
    1f69:	6a 01                	push   $0x1
    1f6b:	e8 29 1a 00 00       	call   3999 <printf>
    exit();
    1f70:	e8 ba 18 00 00       	call   382f <exit>
    printf(1, "create dd/ff failed\n");
    1f75:	83 ec 08             	sub    $0x8,%esp
    1f78:	68 1f 44 00 00       	push   $0x441f
    1f7d:	6a 01                	push   $0x1
    1f7f:	e8 15 1a 00 00       	call   3999 <printf>
    exit();
    1f84:	e8 a6 18 00 00       	call   382f <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1f89:	83 ec 08             	sub    $0x8,%esp
    1f8c:	68 ec 4e 00 00       	push   $0x4eec
    1f91:	6a 01                	push   $0x1
    1f93:	e8 01 1a 00 00       	call   3999 <printf>
    exit();
    1f98:	e8 92 18 00 00       	call   382f <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    1f9d:	83 ec 08             	sub    $0x8,%esp
    1fa0:	68 3b 44 00 00       	push   $0x443b
    1fa5:	6a 01                	push   $0x1
    1fa7:	e8 ed 19 00 00       	call   3999 <printf>
    exit();
    1fac:	e8 7e 18 00 00       	call   382f <exit>
    printf(1, "create dd/dd/ff failed\n");
    1fb1:	83 ec 08             	sub    $0x8,%esp
    1fb4:	68 5f 44 00 00       	push   $0x445f
    1fb9:	6a 01                	push   $0x1
    1fbb:	e8 d9 19 00 00       	call   3999 <printf>
    exit();
    1fc0:	e8 6a 18 00 00       	call   382f <exit>
    printf(1, "open dd/dd/../ff failed\n");
    1fc5:	83 ec 08             	sub    $0x8,%esp
    1fc8:	68 86 44 00 00       	push   $0x4486
    1fcd:	6a 01                	push   $0x1
    1fcf:	e8 c5 19 00 00       	call   3999 <printf>
    exit();
    1fd4:	e8 56 18 00 00       	call   382f <exit>
    printf(1, "dd/dd/../ff wrong content\n");
    1fd9:	83 ec 08             	sub    $0x8,%esp
    1fdc:	68 9f 44 00 00       	push   $0x449f
    1fe1:	6a 01                	push   $0x1
    1fe3:	e8 b1 19 00 00       	call   3999 <printf>
    exit();
    1fe8:	e8 42 18 00 00       	call   382f <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    1fed:	83 ec 08             	sub    $0x8,%esp
    1ff0:	68 14 4f 00 00       	push   $0x4f14
    1ff5:	6a 01                	push   $0x1
    1ff7:	e8 9d 19 00 00       	call   3999 <printf>
    exit();
    1ffc:	e8 2e 18 00 00       	call   382f <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    2001:	83 ec 08             	sub    $0x8,%esp
    2004:	68 c5 44 00 00       	push   $0x44c5
    2009:	6a 01                	push   $0x1
    200b:	e8 89 19 00 00       	call   3999 <printf>
    exit();
    2010:	e8 1a 18 00 00       	call   382f <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2015:	83 ec 08             	sub    $0x8,%esp
    2018:	68 38 4f 00 00       	push   $0x4f38
    201d:	6a 01                	push   $0x1
    201f:	e8 75 19 00 00       	call   3999 <printf>
    exit();
    2024:	e8 06 18 00 00       	call   382f <exit>
    printf(1, "chdir dd failed\n");
    2029:	83 ec 08             	sub    $0x8,%esp
    202c:	68 dd 44 00 00       	push   $0x44dd
    2031:	6a 01                	push   $0x1
    2033:	e8 61 19 00 00       	call   3999 <printf>
    exit();
    2038:	e8 f2 17 00 00       	call   382f <exit>
    printf(1, "chdir dd/../../dd failed\n");
    203d:	83 ec 08             	sub    $0x8,%esp
    2040:	68 fa 44 00 00       	push   $0x44fa
    2045:	6a 01                	push   $0x1
    2047:	e8 4d 19 00 00       	call   3999 <printf>
    exit();
    204c:	e8 de 17 00 00       	call   382f <exit>
    printf(1, "chdir dd/../../dd failed\n");
    2051:	83 ec 08             	sub    $0x8,%esp
    2054:	68 fa 44 00 00       	push   $0x44fa
    2059:	6a 01                	push   $0x1
    205b:	e8 39 19 00 00       	call   3999 <printf>
    exit();
    2060:	e8 ca 17 00 00       	call   382f <exit>
    printf(1, "chdir ./.. failed\n");
    2065:	83 ec 08             	sub    $0x8,%esp
    2068:	68 28 45 00 00       	push   $0x4528
    206d:	6a 01                	push   $0x1
    206f:	e8 25 19 00 00       	call   3999 <printf>
    exit();
    2074:	e8 b6 17 00 00       	call   382f <exit>
    printf(1, "open dd/dd/ffff failed\n");
    2079:	83 ec 08             	sub    $0x8,%esp
    207c:	68 3b 45 00 00       	push   $0x453b
    2081:	6a 01                	push   $0x1
    2083:	e8 11 19 00 00       	call   3999 <printf>
    exit();
    2088:	e8 a2 17 00 00       	call   382f <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    208d:	83 ec 08             	sub    $0x8,%esp
    2090:	68 53 45 00 00       	push   $0x4553
    2095:	6a 01                	push   $0x1
    2097:	e8 fd 18 00 00       	call   3999 <printf>
    exit();
    209c:	e8 8e 17 00 00       	call   382f <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    20a1:	83 ec 08             	sub    $0x8,%esp
    20a4:	68 5c 4f 00 00       	push   $0x4f5c
    20a9:	6a 01                	push   $0x1
    20ab:	e8 e9 18 00 00       	call   3999 <printf>
    exit();
    20b0:	e8 7a 17 00 00       	call   382f <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    20b5:	83 ec 08             	sub    $0x8,%esp
    20b8:	68 77 45 00 00       	push   $0x4577
    20bd:	6a 01                	push   $0x1
    20bf:	e8 d5 18 00 00       	call   3999 <printf>
    exit();
    20c4:	e8 66 17 00 00       	call   382f <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    20c9:	83 ec 08             	sub    $0x8,%esp
    20cc:	68 9c 45 00 00       	push   $0x459c
    20d1:	6a 01                	push   $0x1
    20d3:	e8 c1 18 00 00       	call   3999 <printf>
    exit();
    20d8:	e8 52 17 00 00       	call   382f <exit>
    printf(1, "create dd succeeded!\n");
    20dd:	83 ec 08             	sub    $0x8,%esp
    20e0:	68 b8 45 00 00       	push   $0x45b8
    20e5:	6a 01                	push   $0x1
    20e7:	e8 ad 18 00 00       	call   3999 <printf>
    exit();
    20ec:	e8 3e 17 00 00       	call   382f <exit>
    printf(1, "open dd rdwr succeeded!\n");
    20f1:	83 ec 08             	sub    $0x8,%esp
    20f4:	68 ce 45 00 00       	push   $0x45ce
    20f9:	6a 01                	push   $0x1
    20fb:	e8 99 18 00 00       	call   3999 <printf>
    exit();
    2100:	e8 2a 17 00 00       	call   382f <exit>
    printf(1, "open dd wronly succeeded!\n");
    2105:	83 ec 08             	sub    $0x8,%esp
    2108:	68 e7 45 00 00       	push   $0x45e7
    210d:	6a 01                	push   $0x1
    210f:	e8 85 18 00 00       	call   3999 <printf>
    exit();
    2114:	e8 16 17 00 00       	call   382f <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2119:	83 ec 08             	sub    $0x8,%esp
    211c:	68 84 4f 00 00       	push   $0x4f84
    2121:	6a 01                	push   $0x1
    2123:	e8 71 18 00 00       	call   3999 <printf>
    exit();
    2128:	e8 02 17 00 00       	call   382f <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    212d:	83 ec 08             	sub    $0x8,%esp
    2130:	68 a8 4f 00 00       	push   $0x4fa8
    2135:	6a 01                	push   $0x1
    2137:	e8 5d 18 00 00       	call   3999 <printf>
    exit();
    213c:	e8 ee 16 00 00       	call   382f <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2141:	83 ec 08             	sub    $0x8,%esp
    2144:	68 cc 4f 00 00       	push   $0x4fcc
    2149:	6a 01                	push   $0x1
    214b:	e8 49 18 00 00       	call   3999 <printf>
    exit();
    2150:	e8 da 16 00 00       	call   382f <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2155:	83 ec 08             	sub    $0x8,%esp
    2158:	68 0b 46 00 00       	push   $0x460b
    215d:	6a 01                	push   $0x1
    215f:	e8 35 18 00 00       	call   3999 <printf>
    exit();
    2164:	e8 c6 16 00 00       	call   382f <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2169:	83 ec 08             	sub    $0x8,%esp
    216c:	68 26 46 00 00       	push   $0x4626
    2171:	6a 01                	push   $0x1
    2173:	e8 21 18 00 00       	call   3999 <printf>
    exit();
    2178:	e8 b2 16 00 00       	call   382f <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    217d:	83 ec 08             	sub    $0x8,%esp
    2180:	68 41 46 00 00       	push   $0x4641
    2185:	6a 01                	push   $0x1
    2187:	e8 0d 18 00 00       	call   3999 <printf>
    exit();
    218c:	e8 9e 16 00 00       	call   382f <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2191:	83 ec 08             	sub    $0x8,%esp
    2194:	68 5e 46 00 00       	push   $0x465e
    2199:	6a 01                	push   $0x1
    219b:	e8 f9 17 00 00       	call   3999 <printf>
    exit();
    21a0:	e8 8a 16 00 00       	call   382f <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    21a5:	83 ec 08             	sub    $0x8,%esp
    21a8:	68 7a 46 00 00       	push   $0x467a
    21ad:	6a 01                	push   $0x1
    21af:	e8 e5 17 00 00       	call   3999 <printf>
    exit();
    21b4:	e8 76 16 00 00       	call   382f <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    21b9:	83 ec 08             	sub    $0x8,%esp
    21bc:	68 96 46 00 00       	push   $0x4696
    21c1:	6a 01                	push   $0x1
    21c3:	e8 d1 17 00 00       	call   3999 <printf>
    exit();
    21c8:	e8 62 16 00 00       	call   382f <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    21cd:	83 ec 08             	sub    $0x8,%esp
    21d0:	68 ae 46 00 00       	push   $0x46ae
    21d5:	6a 01                	push   $0x1
    21d7:	e8 bd 17 00 00       	call   3999 <printf>
    exit();
    21dc:	e8 4e 16 00 00       	call   382f <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    21e1:	83 ec 08             	sub    $0x8,%esp
    21e4:	68 c5 44 00 00       	push   $0x44c5
    21e9:	6a 01                	push   $0x1
    21eb:	e8 a9 17 00 00       	call   3999 <printf>
    exit();
    21f0:	e8 3a 16 00 00       	call   382f <exit>
    printf(1, "unlink dd/ff failed\n");
    21f5:	83 ec 08             	sub    $0x8,%esp
    21f8:	68 c6 46 00 00       	push   $0x46c6
    21fd:	6a 01                	push   $0x1
    21ff:	e8 95 17 00 00       	call   3999 <printf>
    exit();
    2204:	e8 26 16 00 00       	call   382f <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    2209:	83 ec 08             	sub    $0x8,%esp
    220c:	68 f0 4f 00 00       	push   $0x4ff0
    2211:	6a 01                	push   $0x1
    2213:	e8 81 17 00 00       	call   3999 <printf>
    exit();
    2218:	e8 12 16 00 00       	call   382f <exit>
    printf(1, "unlink dd/dd failed\n");
    221d:	83 ec 08             	sub    $0x8,%esp
    2220:	68 db 46 00 00       	push   $0x46db
    2225:	6a 01                	push   $0x1
    2227:	e8 6d 17 00 00       	call   3999 <printf>
    exit();
    222c:	e8 fe 15 00 00       	call   382f <exit>
    printf(1, "unlink dd failed\n");
    2231:	83 ec 08             	sub    $0x8,%esp
    2234:	68 f0 46 00 00       	push   $0x46f0
    2239:	6a 01                	push   $0x1
    223b:	e8 59 17 00 00       	call   3999 <printf>
    exit();
    2240:	e8 ea 15 00 00       	call   382f <exit>

00002245 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    2245:	55                   	push   %ebp
    2246:	89 e5                	mov    %esp,%ebp
    2248:	57                   	push   %edi
    2249:	56                   	push   %esi
    224a:	53                   	push   %ebx
    224b:	83 ec 14             	sub    $0x14,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    224e:	68 0d 47 00 00       	push   $0x470d
    2253:	6a 01                	push   $0x1
    2255:	e8 3f 17 00 00       	call   3999 <printf>

  unlink("bigwrite");
    225a:	c7 04 24 1c 47 00 00 	movl   $0x471c,(%esp)
    2261:	e8 19 16 00 00       	call   387f <unlink>
    2266:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    2269:	bb f3 01 00 00       	mov    $0x1f3,%ebx
    fd = open("bigwrite", O_CREATE | O_RDWR);
    226e:	83 ec 08             	sub    $0x8,%esp
    2271:	68 02 02 00 00       	push   $0x202
    2276:	68 1c 47 00 00       	push   $0x471c
    227b:	e8 ef 15 00 00       	call   386f <open>
    2280:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    2282:	83 c4 10             	add    $0x10,%esp
    2285:	85 c0                	test   %eax,%eax
    2287:	78 6e                	js     22f7 <bigwrite+0xb2>
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    2289:	83 ec 04             	sub    $0x4,%esp
    228c:	53                   	push   %ebx
    228d:	68 00 85 00 00       	push   $0x8500
    2292:	50                   	push   %eax
    2293:	e8 b7 15 00 00       	call   384f <write>
    2298:	89 c7                	mov    %eax,%edi
      if(cc != sz){
    229a:	83 c4 10             	add    $0x10,%esp
    229d:	39 c3                	cmp    %eax,%ebx
    229f:	75 6a                	jne    230b <bigwrite+0xc6>
      int cc = write(fd, buf, sz);
    22a1:	83 ec 04             	sub    $0x4,%esp
    22a4:	53                   	push   %ebx
    22a5:	68 00 85 00 00       	push   $0x8500
    22aa:	56                   	push   %esi
    22ab:	e8 9f 15 00 00       	call   384f <write>
      if(cc != sz){
    22b0:	83 c4 10             	add    $0x10,%esp
    22b3:	39 d8                	cmp    %ebx,%eax
    22b5:	75 56                	jne    230d <bigwrite+0xc8>
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    22b7:	83 ec 0c             	sub    $0xc,%esp
    22ba:	56                   	push   %esi
    22bb:	e8 97 15 00 00       	call   3857 <close>
    unlink("bigwrite");
    22c0:	c7 04 24 1c 47 00 00 	movl   $0x471c,(%esp)
    22c7:	e8 b3 15 00 00       	call   387f <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    22cc:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    22d2:	83 c4 10             	add    $0x10,%esp
    22d5:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    22db:	75 91                	jne    226e <bigwrite+0x29>
  }

  printf(1, "bigwrite ok\n");
    22dd:	83 ec 08             	sub    $0x8,%esp
    22e0:	68 4f 47 00 00       	push   $0x474f
    22e5:	6a 01                	push   $0x1
    22e7:	e8 ad 16 00 00       	call   3999 <printf>
}
    22ec:	83 c4 10             	add    $0x10,%esp
    22ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
    22f2:	5b                   	pop    %ebx
    22f3:	5e                   	pop    %esi
    22f4:	5f                   	pop    %edi
    22f5:	5d                   	pop    %ebp
    22f6:	c3                   	ret    
      printf(1, "cannot create bigwrite\n");
    22f7:	83 ec 08             	sub    $0x8,%esp
    22fa:	68 25 47 00 00       	push   $0x4725
    22ff:	6a 01                	push   $0x1
    2301:	e8 93 16 00 00       	call   3999 <printf>
      exit();
    2306:	e8 24 15 00 00       	call   382f <exit>
      if(cc != sz){
    230b:	89 df                	mov    %ebx,%edi
        printf(1, "write(%d) ret %d\n", sz, cc);
    230d:	50                   	push   %eax
    230e:	57                   	push   %edi
    230f:	68 3d 47 00 00       	push   $0x473d
    2314:	6a 01                	push   $0x1
    2316:	e8 7e 16 00 00       	call   3999 <printf>
        exit();
    231b:	e8 0f 15 00 00       	call   382f <exit>

00002320 <bigfile>:

void
bigfile(void)
{
    2320:	55                   	push   %ebp
    2321:	89 e5                	mov    %esp,%ebp
    2323:	57                   	push   %edi
    2324:	56                   	push   %esi
    2325:	53                   	push   %ebx
    2326:	83 ec 14             	sub    $0x14,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2329:	68 5c 47 00 00       	push   $0x475c
    232e:	6a 01                	push   $0x1
    2330:	e8 64 16 00 00       	call   3999 <printf>

  unlink("bigfile");
    2335:	c7 04 24 78 47 00 00 	movl   $0x4778,(%esp)
    233c:	e8 3e 15 00 00       	call   387f <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2341:	83 c4 08             	add    $0x8,%esp
    2344:	68 02 02 00 00       	push   $0x202
    2349:	68 78 47 00 00       	push   $0x4778
    234e:	e8 1c 15 00 00       	call   386f <open>
  if(fd < 0){
    2353:	83 c4 10             	add    $0x10,%esp
    2356:	85 c0                	test   %eax,%eax
    2358:	0f 88 c5 00 00 00    	js     2423 <bigfile+0x103>
    235e:	89 c6                	mov    %eax,%esi
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    2360:	bb 00 00 00 00       	mov    $0x0,%ebx
    memset(buf, i, 600);
    2365:	83 ec 04             	sub    $0x4,%esp
    2368:	68 58 02 00 00       	push   $0x258
    236d:	53                   	push   %ebx
    236e:	68 00 85 00 00       	push   $0x8500
    2373:	e8 cd 12 00 00       	call   3645 <memset>
    if(write(fd, buf, 600) != 600){
    2378:	83 c4 0c             	add    $0xc,%esp
    237b:	68 58 02 00 00       	push   $0x258
    2380:	68 00 85 00 00       	push   $0x8500
    2385:	56                   	push   %esi
    2386:	e8 c4 14 00 00       	call   384f <write>
    238b:	83 c4 10             	add    $0x10,%esp
    238e:	3d 58 02 00 00       	cmp    $0x258,%eax
    2393:	0f 85 9e 00 00 00    	jne    2437 <bigfile+0x117>
  for(i = 0; i < 20; i++){
    2399:	83 c3 01             	add    $0x1,%ebx
    239c:	83 fb 14             	cmp    $0x14,%ebx
    239f:	75 c4                	jne    2365 <bigfile+0x45>
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    23a1:	83 ec 0c             	sub    $0xc,%esp
    23a4:	56                   	push   %esi
    23a5:	e8 ad 14 00 00       	call   3857 <close>

  fd = open("bigfile", 0);
    23aa:	83 c4 08             	add    $0x8,%esp
    23ad:	6a 00                	push   $0x0
    23af:	68 78 47 00 00       	push   $0x4778
    23b4:	e8 b6 14 00 00       	call   386f <open>
    23b9:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    23bb:	83 c4 10             	add    $0x10,%esp
    23be:	85 c0                	test   %eax,%eax
    23c0:	0f 88 85 00 00 00    	js     244b <bigfile+0x12b>
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
    23c6:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; ; i++){
    23cb:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(fd, buf, 300);
    23d0:	83 ec 04             	sub    $0x4,%esp
    23d3:	68 2c 01 00 00       	push   $0x12c
    23d8:	68 00 85 00 00       	push   $0x8500
    23dd:	57                   	push   %edi
    23de:	e8 64 14 00 00       	call   3847 <read>
    if(cc < 0){
    23e3:	83 c4 10             	add    $0x10,%esp
    23e6:	85 c0                	test   %eax,%eax
    23e8:	78 75                	js     245f <bigfile+0x13f>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
    23ea:	85 c0                	test   %eax,%eax
    23ec:	0f 84 a9 00 00 00    	je     249b <bigfile+0x17b>
      break;
    if(cc != 300){
    23f2:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    23f7:	75 7a                	jne    2473 <bigfile+0x153>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    23f9:	0f be 15 00 85 00 00 	movsbl 0x8500,%edx
    2400:	89 d8                	mov    %ebx,%eax
    2402:	c1 e8 1f             	shr    $0x1f,%eax
    2405:	01 d8                	add    %ebx,%eax
    2407:	d1 f8                	sar    %eax
    2409:	39 c2                	cmp    %eax,%edx
    240b:	75 7a                	jne    2487 <bigfile+0x167>
    240d:	0f be 05 2b 86 00 00 	movsbl 0x862b,%eax
    2414:	39 c2                	cmp    %eax,%edx
    2416:	75 6f                	jne    2487 <bigfile+0x167>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
    2418:	81 c6 2c 01 00 00    	add    $0x12c,%esi
  for(i = 0; ; i++){
    241e:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
    2421:	eb ad                	jmp    23d0 <bigfile+0xb0>
    printf(1, "cannot create bigfile");
    2423:	83 ec 08             	sub    $0x8,%esp
    2426:	68 6a 47 00 00       	push   $0x476a
    242b:	6a 01                	push   $0x1
    242d:	e8 67 15 00 00       	call   3999 <printf>
    exit();
    2432:	e8 f8 13 00 00       	call   382f <exit>
      printf(1, "write bigfile failed\n");
    2437:	83 ec 08             	sub    $0x8,%esp
    243a:	68 80 47 00 00       	push   $0x4780
    243f:	6a 01                	push   $0x1
    2441:	e8 53 15 00 00       	call   3999 <printf>
      exit();
    2446:	e8 e4 13 00 00       	call   382f <exit>
    printf(1, "cannot open bigfile\n");
    244b:	83 ec 08             	sub    $0x8,%esp
    244e:	68 96 47 00 00       	push   $0x4796
    2453:	6a 01                	push   $0x1
    2455:	e8 3f 15 00 00       	call   3999 <printf>
    exit();
    245a:	e8 d0 13 00 00       	call   382f <exit>
      printf(1, "read bigfile failed\n");
    245f:	83 ec 08             	sub    $0x8,%esp
    2462:	68 ab 47 00 00       	push   $0x47ab
    2467:	6a 01                	push   $0x1
    2469:	e8 2b 15 00 00       	call   3999 <printf>
      exit();
    246e:	e8 bc 13 00 00       	call   382f <exit>
      printf(1, "short read bigfile\n");
    2473:	83 ec 08             	sub    $0x8,%esp
    2476:	68 c0 47 00 00       	push   $0x47c0
    247b:	6a 01                	push   $0x1
    247d:	e8 17 15 00 00       	call   3999 <printf>
      exit();
    2482:	e8 a8 13 00 00       	call   382f <exit>
      printf(1, "read bigfile wrong data\n");
    2487:	83 ec 08             	sub    $0x8,%esp
    248a:	68 d4 47 00 00       	push   $0x47d4
    248f:	6a 01                	push   $0x1
    2491:	e8 03 15 00 00       	call   3999 <printf>
      exit();
    2496:	e8 94 13 00 00       	call   382f <exit>
  }
  close(fd);
    249b:	83 ec 0c             	sub    $0xc,%esp
    249e:	57                   	push   %edi
    249f:	e8 b3 13 00 00       	call   3857 <close>
  if(total != 20*600){
    24a4:	83 c4 10             	add    $0x10,%esp
    24a7:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    24ad:	75 27                	jne    24d6 <bigfile+0x1b6>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
    24af:	83 ec 0c             	sub    $0xc,%esp
    24b2:	68 78 47 00 00       	push   $0x4778
    24b7:	e8 c3 13 00 00       	call   387f <unlink>

  printf(1, "bigfile test ok\n");
    24bc:	83 c4 08             	add    $0x8,%esp
    24bf:	68 07 48 00 00       	push   $0x4807
    24c4:	6a 01                	push   $0x1
    24c6:	e8 ce 14 00 00       	call   3999 <printf>
}
    24cb:	83 c4 10             	add    $0x10,%esp
    24ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
    24d1:	5b                   	pop    %ebx
    24d2:	5e                   	pop    %esi
    24d3:	5f                   	pop    %edi
    24d4:	5d                   	pop    %ebp
    24d5:	c3                   	ret    
    printf(1, "read bigfile wrong total\n");
    24d6:	83 ec 08             	sub    $0x8,%esp
    24d9:	68 ed 47 00 00       	push   $0x47ed
    24de:	6a 01                	push   $0x1
    24e0:	e8 b4 14 00 00       	call   3999 <printf>
    exit();
    24e5:	e8 45 13 00 00       	call   382f <exit>

000024ea <fourteen>:

void
fourteen(void)
{
    24ea:	55                   	push   %ebp
    24eb:	89 e5                	mov    %esp,%ebp
    24ed:	83 ec 10             	sub    $0x10,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    24f0:	68 18 48 00 00       	push   $0x4818
    24f5:	6a 01                	push   $0x1
    24f7:	e8 9d 14 00 00       	call   3999 <printf>

  if(mkdir("12345678901234") != 0){
    24fc:	c7 04 24 53 48 00 00 	movl   $0x4853,(%esp)
    2503:	e8 8f 13 00 00       	call   3897 <mkdir>
    2508:	83 c4 10             	add    $0x10,%esp
    250b:	85 c0                	test   %eax,%eax
    250d:	0f 85 9c 00 00 00    	jne    25af <fourteen+0xc5>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2513:	83 ec 0c             	sub    $0xc,%esp
    2516:	68 10 50 00 00       	push   $0x5010
    251b:	e8 77 13 00 00       	call   3897 <mkdir>
    2520:	83 c4 10             	add    $0x10,%esp
    2523:	85 c0                	test   %eax,%eax
    2525:	0f 85 98 00 00 00    	jne    25c3 <fourteen+0xd9>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    252b:	83 ec 08             	sub    $0x8,%esp
    252e:	68 00 02 00 00       	push   $0x200
    2533:	68 60 50 00 00       	push   $0x5060
    2538:	e8 32 13 00 00       	call   386f <open>
  if(fd < 0){
    253d:	83 c4 10             	add    $0x10,%esp
    2540:	85 c0                	test   %eax,%eax
    2542:	0f 88 8f 00 00 00    	js     25d7 <fourteen+0xed>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
    2548:	83 ec 0c             	sub    $0xc,%esp
    254b:	50                   	push   %eax
    254c:	e8 06 13 00 00       	call   3857 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2551:	83 c4 08             	add    $0x8,%esp
    2554:	6a 00                	push   $0x0
    2556:	68 d0 50 00 00       	push   $0x50d0
    255b:	e8 0f 13 00 00       	call   386f <open>
  if(fd < 0){
    2560:	83 c4 10             	add    $0x10,%esp
    2563:	85 c0                	test   %eax,%eax
    2565:	0f 88 80 00 00 00    	js     25eb <fourteen+0x101>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
    256b:	83 ec 0c             	sub    $0xc,%esp
    256e:	50                   	push   %eax
    256f:	e8 e3 12 00 00       	call   3857 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2574:	c7 04 24 44 48 00 00 	movl   $0x4844,(%esp)
    257b:	e8 17 13 00 00       	call   3897 <mkdir>
    2580:	83 c4 10             	add    $0x10,%esp
    2583:	85 c0                	test   %eax,%eax
    2585:	74 78                	je     25ff <fourteen+0x115>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2587:	83 ec 0c             	sub    $0xc,%esp
    258a:	68 6c 51 00 00       	push   $0x516c
    258f:	e8 03 13 00 00       	call   3897 <mkdir>
    2594:	83 c4 10             	add    $0x10,%esp
    2597:	85 c0                	test   %eax,%eax
    2599:	74 78                	je     2613 <fourteen+0x129>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
    259b:	83 ec 08             	sub    $0x8,%esp
    259e:	68 62 48 00 00       	push   $0x4862
    25a3:	6a 01                	push   $0x1
    25a5:	e8 ef 13 00 00       	call   3999 <printf>
}
    25aa:	83 c4 10             	add    $0x10,%esp
    25ad:	c9                   	leave  
    25ae:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    25af:	83 ec 08             	sub    $0x8,%esp
    25b2:	68 27 48 00 00       	push   $0x4827
    25b7:	6a 01                	push   $0x1
    25b9:	e8 db 13 00 00       	call   3999 <printf>
    exit();
    25be:	e8 6c 12 00 00       	call   382f <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    25c3:	83 ec 08             	sub    $0x8,%esp
    25c6:	68 30 50 00 00       	push   $0x5030
    25cb:	6a 01                	push   $0x1
    25cd:	e8 c7 13 00 00       	call   3999 <printf>
    exit();
    25d2:	e8 58 12 00 00       	call   382f <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    25d7:	83 ec 08             	sub    $0x8,%esp
    25da:	68 90 50 00 00       	push   $0x5090
    25df:	6a 01                	push   $0x1
    25e1:	e8 b3 13 00 00       	call   3999 <printf>
    exit();
    25e6:	e8 44 12 00 00       	call   382f <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    25eb:	83 ec 08             	sub    $0x8,%esp
    25ee:	68 00 51 00 00       	push   $0x5100
    25f3:	6a 01                	push   $0x1
    25f5:	e8 9f 13 00 00       	call   3999 <printf>
    exit();
    25fa:	e8 30 12 00 00       	call   382f <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    25ff:	83 ec 08             	sub    $0x8,%esp
    2602:	68 3c 51 00 00       	push   $0x513c
    2607:	6a 01                	push   $0x1
    2609:	e8 8b 13 00 00       	call   3999 <printf>
    exit();
    260e:	e8 1c 12 00 00       	call   382f <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2613:	83 ec 08             	sub    $0x8,%esp
    2616:	68 8c 51 00 00       	push   $0x518c
    261b:	6a 01                	push   $0x1
    261d:	e8 77 13 00 00       	call   3999 <printf>
    exit();
    2622:	e8 08 12 00 00       	call   382f <exit>

00002627 <rmdot>:

void
rmdot(void)
{
    2627:	55                   	push   %ebp
    2628:	89 e5                	mov    %esp,%ebp
    262a:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    262d:	68 6f 48 00 00       	push   $0x486f
    2632:	6a 01                	push   $0x1
    2634:	e8 60 13 00 00       	call   3999 <printf>
  if(mkdir("dots") != 0){
    2639:	c7 04 24 7b 48 00 00 	movl   $0x487b,(%esp)
    2640:	e8 52 12 00 00       	call   3897 <mkdir>
    2645:	83 c4 10             	add    $0x10,%esp
    2648:	85 c0                	test   %eax,%eax
    264a:	0f 85 bc 00 00 00    	jne    270c <rmdot+0xe5>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    2650:	83 ec 0c             	sub    $0xc,%esp
    2653:	68 7b 48 00 00       	push   $0x487b
    2658:	e8 42 12 00 00       	call   389f <chdir>
    265d:	83 c4 10             	add    $0x10,%esp
    2660:	85 c0                	test   %eax,%eax
    2662:	0f 85 b8 00 00 00    	jne    2720 <rmdot+0xf9>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    2668:	83 ec 0c             	sub    $0xc,%esp
    266b:	68 26 45 00 00       	push   $0x4526
    2670:	e8 0a 12 00 00       	call   387f <unlink>
    2675:	83 c4 10             	add    $0x10,%esp
    2678:	85 c0                	test   %eax,%eax
    267a:	0f 84 b4 00 00 00    	je     2734 <rmdot+0x10d>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    2680:	83 ec 0c             	sub    $0xc,%esp
    2683:	68 25 45 00 00       	push   $0x4525
    2688:	e8 f2 11 00 00       	call   387f <unlink>
    268d:	83 c4 10             	add    $0x10,%esp
    2690:	85 c0                	test   %eax,%eax
    2692:	0f 84 b0 00 00 00    	je     2748 <rmdot+0x121>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    2698:	83 ec 0c             	sub    $0xc,%esp
    269b:	68 f9 3c 00 00       	push   $0x3cf9
    26a0:	e8 fa 11 00 00       	call   389f <chdir>
    26a5:	83 c4 10             	add    $0x10,%esp
    26a8:	85 c0                	test   %eax,%eax
    26aa:	0f 85 ac 00 00 00    	jne    275c <rmdot+0x135>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    26b0:	83 ec 0c             	sub    $0xc,%esp
    26b3:	68 c3 48 00 00       	push   $0x48c3
    26b8:	e8 c2 11 00 00       	call   387f <unlink>
    26bd:	83 c4 10             	add    $0x10,%esp
    26c0:	85 c0                	test   %eax,%eax
    26c2:	0f 84 a8 00 00 00    	je     2770 <rmdot+0x149>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    26c8:	83 ec 0c             	sub    $0xc,%esp
    26cb:	68 e1 48 00 00       	push   $0x48e1
    26d0:	e8 aa 11 00 00       	call   387f <unlink>
    26d5:	83 c4 10             	add    $0x10,%esp
    26d8:	85 c0                	test   %eax,%eax
    26da:	0f 84 a4 00 00 00    	je     2784 <rmdot+0x15d>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    26e0:	83 ec 0c             	sub    $0xc,%esp
    26e3:	68 7b 48 00 00       	push   $0x487b
    26e8:	e8 92 11 00 00       	call   387f <unlink>
    26ed:	83 c4 10             	add    $0x10,%esp
    26f0:	85 c0                	test   %eax,%eax
    26f2:	0f 85 a0 00 00 00    	jne    2798 <rmdot+0x171>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
    26f8:	83 ec 08             	sub    $0x8,%esp
    26fb:	68 16 49 00 00       	push   $0x4916
    2700:	6a 01                	push   $0x1
    2702:	e8 92 12 00 00       	call   3999 <printf>
}
    2707:	83 c4 10             	add    $0x10,%esp
    270a:	c9                   	leave  
    270b:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    270c:	83 ec 08             	sub    $0x8,%esp
    270f:	68 80 48 00 00       	push   $0x4880
    2714:	6a 01                	push   $0x1
    2716:	e8 7e 12 00 00       	call   3999 <printf>
    exit();
    271b:	e8 0f 11 00 00       	call   382f <exit>
    printf(1, "chdir dots failed\n");
    2720:	83 ec 08             	sub    $0x8,%esp
    2723:	68 93 48 00 00       	push   $0x4893
    2728:	6a 01                	push   $0x1
    272a:	e8 6a 12 00 00       	call   3999 <printf>
    exit();
    272f:	e8 fb 10 00 00       	call   382f <exit>
    printf(1, "rm . worked!\n");
    2734:	83 ec 08             	sub    $0x8,%esp
    2737:	68 a6 48 00 00       	push   $0x48a6
    273c:	6a 01                	push   $0x1
    273e:	e8 56 12 00 00       	call   3999 <printf>
    exit();
    2743:	e8 e7 10 00 00       	call   382f <exit>
    printf(1, "rm .. worked!\n");
    2748:	83 ec 08             	sub    $0x8,%esp
    274b:	68 b4 48 00 00       	push   $0x48b4
    2750:	6a 01                	push   $0x1
    2752:	e8 42 12 00 00       	call   3999 <printf>
    exit();
    2757:	e8 d3 10 00 00       	call   382f <exit>
    printf(1, "chdir / failed\n");
    275c:	83 ec 08             	sub    $0x8,%esp
    275f:	68 fb 3c 00 00       	push   $0x3cfb
    2764:	6a 01                	push   $0x1
    2766:	e8 2e 12 00 00       	call   3999 <printf>
    exit();
    276b:	e8 bf 10 00 00       	call   382f <exit>
    printf(1, "unlink dots/. worked!\n");
    2770:	83 ec 08             	sub    $0x8,%esp
    2773:	68 ca 48 00 00       	push   $0x48ca
    2778:	6a 01                	push   $0x1
    277a:	e8 1a 12 00 00       	call   3999 <printf>
    exit();
    277f:	e8 ab 10 00 00       	call   382f <exit>
    printf(1, "unlink dots/.. worked!\n");
    2784:	83 ec 08             	sub    $0x8,%esp
    2787:	68 e9 48 00 00       	push   $0x48e9
    278c:	6a 01                	push   $0x1
    278e:	e8 06 12 00 00       	call   3999 <printf>
    exit();
    2793:	e8 97 10 00 00       	call   382f <exit>
    printf(1, "unlink dots failed!\n");
    2798:	83 ec 08             	sub    $0x8,%esp
    279b:	68 01 49 00 00       	push   $0x4901
    27a0:	6a 01                	push   $0x1
    27a2:	e8 f2 11 00 00       	call   3999 <printf>
    exit();
    27a7:	e8 83 10 00 00       	call   382f <exit>

000027ac <dirfile>:

void
dirfile(void)
{
    27ac:	55                   	push   %ebp
    27ad:	89 e5                	mov    %esp,%ebp
    27af:	53                   	push   %ebx
    27b0:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "dir vs file\n");
    27b3:	68 20 49 00 00       	push   $0x4920
    27b8:	6a 01                	push   $0x1
    27ba:	e8 da 11 00 00       	call   3999 <printf>

  fd = open("dirfile", O_CREATE);
    27bf:	83 c4 08             	add    $0x8,%esp
    27c2:	68 00 02 00 00       	push   $0x200
    27c7:	68 2d 49 00 00       	push   $0x492d
    27cc:	e8 9e 10 00 00       	call   386f <open>
  if(fd < 0){
    27d1:	83 c4 10             	add    $0x10,%esp
    27d4:	85 c0                	test   %eax,%eax
    27d6:	0f 88 22 01 00 00    	js     28fe <dirfile+0x152>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
    27dc:	83 ec 0c             	sub    $0xc,%esp
    27df:	50                   	push   %eax
    27e0:	e8 72 10 00 00       	call   3857 <close>
  if(chdir("dirfile") == 0){
    27e5:	c7 04 24 2d 49 00 00 	movl   $0x492d,(%esp)
    27ec:	e8 ae 10 00 00       	call   389f <chdir>
    27f1:	83 c4 10             	add    $0x10,%esp
    27f4:	85 c0                	test   %eax,%eax
    27f6:	0f 84 16 01 00 00    	je     2912 <dirfile+0x166>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
    27fc:	83 ec 08             	sub    $0x8,%esp
    27ff:	6a 00                	push   $0x0
    2801:	68 66 49 00 00       	push   $0x4966
    2806:	e8 64 10 00 00       	call   386f <open>
  if(fd >= 0){
    280b:	83 c4 10             	add    $0x10,%esp
    280e:	85 c0                	test   %eax,%eax
    2810:	0f 89 10 01 00 00    	jns    2926 <dirfile+0x17a>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    2816:	83 ec 08             	sub    $0x8,%esp
    2819:	68 00 02 00 00       	push   $0x200
    281e:	68 66 49 00 00       	push   $0x4966
    2823:	e8 47 10 00 00       	call   386f <open>
  if(fd >= 0){
    2828:	83 c4 10             	add    $0x10,%esp
    282b:	85 c0                	test   %eax,%eax
    282d:	0f 89 07 01 00 00    	jns    293a <dirfile+0x18e>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    2833:	83 ec 0c             	sub    $0xc,%esp
    2836:	68 66 49 00 00       	push   $0x4966
    283b:	e8 57 10 00 00       	call   3897 <mkdir>
    2840:	83 c4 10             	add    $0x10,%esp
    2843:	85 c0                	test   %eax,%eax
    2845:	0f 84 03 01 00 00    	je     294e <dirfile+0x1a2>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    284b:	83 ec 0c             	sub    $0xc,%esp
    284e:	68 66 49 00 00       	push   $0x4966
    2853:	e8 27 10 00 00       	call   387f <unlink>
    2858:	83 c4 10             	add    $0x10,%esp
    285b:	85 c0                	test   %eax,%eax
    285d:	0f 84 ff 00 00 00    	je     2962 <dirfile+0x1b6>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    2863:	83 ec 08             	sub    $0x8,%esp
    2866:	68 66 49 00 00       	push   $0x4966
    286b:	68 ca 49 00 00       	push   $0x49ca
    2870:	e8 1a 10 00 00       	call   388f <link>
    2875:	83 c4 10             	add    $0x10,%esp
    2878:	85 c0                	test   %eax,%eax
    287a:	0f 84 f6 00 00 00    	je     2976 <dirfile+0x1ca>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    2880:	83 ec 0c             	sub    $0xc,%esp
    2883:	68 2d 49 00 00       	push   $0x492d
    2888:	e8 f2 0f 00 00       	call   387f <unlink>
    288d:	83 c4 10             	add    $0x10,%esp
    2890:	85 c0                	test   %eax,%eax
    2892:	0f 85 f2 00 00 00    	jne    298a <dirfile+0x1de>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    2898:	83 ec 08             	sub    $0x8,%esp
    289b:	6a 02                	push   $0x2
    289d:	68 26 45 00 00       	push   $0x4526
    28a2:	e8 c8 0f 00 00       	call   386f <open>
  if(fd >= 0){
    28a7:	83 c4 10             	add    $0x10,%esp
    28aa:	85 c0                	test   %eax,%eax
    28ac:	0f 89 ec 00 00 00    	jns    299e <dirfile+0x1f2>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    28b2:	83 ec 08             	sub    $0x8,%esp
    28b5:	6a 00                	push   $0x0
    28b7:	68 26 45 00 00       	push   $0x4526
    28bc:	e8 ae 0f 00 00       	call   386f <open>
    28c1:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    28c3:	83 c4 0c             	add    $0xc,%esp
    28c6:	6a 01                	push   $0x1
    28c8:	68 09 46 00 00       	push   $0x4609
    28cd:	50                   	push   %eax
    28ce:	e8 7c 0f 00 00       	call   384f <write>
    28d3:	83 c4 10             	add    $0x10,%esp
    28d6:	85 c0                	test   %eax,%eax
    28d8:	0f 8f d4 00 00 00    	jg     29b2 <dirfile+0x206>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
    28de:	83 ec 0c             	sub    $0xc,%esp
    28e1:	53                   	push   %ebx
    28e2:	e8 70 0f 00 00       	call   3857 <close>

  printf(1, "dir vs file OK\n");
    28e7:	83 c4 08             	add    $0x8,%esp
    28ea:	68 fd 49 00 00       	push   $0x49fd
    28ef:	6a 01                	push   $0x1
    28f1:	e8 a3 10 00 00       	call   3999 <printf>
}
    28f6:	83 c4 10             	add    $0x10,%esp
    28f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    28fc:	c9                   	leave  
    28fd:	c3                   	ret    
    printf(1, "create dirfile failed\n");
    28fe:	83 ec 08             	sub    $0x8,%esp
    2901:	68 35 49 00 00       	push   $0x4935
    2906:	6a 01                	push   $0x1
    2908:	e8 8c 10 00 00       	call   3999 <printf>
    exit();
    290d:	e8 1d 0f 00 00       	call   382f <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2912:	83 ec 08             	sub    $0x8,%esp
    2915:	68 4c 49 00 00       	push   $0x494c
    291a:	6a 01                	push   $0x1
    291c:	e8 78 10 00 00       	call   3999 <printf>
    exit();
    2921:	e8 09 0f 00 00       	call   382f <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2926:	83 ec 08             	sub    $0x8,%esp
    2929:	68 71 49 00 00       	push   $0x4971
    292e:	6a 01                	push   $0x1
    2930:	e8 64 10 00 00       	call   3999 <printf>
    exit();
    2935:	e8 f5 0e 00 00       	call   382f <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    293a:	83 ec 08             	sub    $0x8,%esp
    293d:	68 71 49 00 00       	push   $0x4971
    2942:	6a 01                	push   $0x1
    2944:	e8 50 10 00 00       	call   3999 <printf>
    exit();
    2949:	e8 e1 0e 00 00       	call   382f <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    294e:	83 ec 08             	sub    $0x8,%esp
    2951:	68 8f 49 00 00       	push   $0x498f
    2956:	6a 01                	push   $0x1
    2958:	e8 3c 10 00 00       	call   3999 <printf>
    exit();
    295d:	e8 cd 0e 00 00       	call   382f <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2962:	83 ec 08             	sub    $0x8,%esp
    2965:	68 ac 49 00 00       	push   $0x49ac
    296a:	6a 01                	push   $0x1
    296c:	e8 28 10 00 00       	call   3999 <printf>
    exit();
    2971:	e8 b9 0e 00 00       	call   382f <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2976:	83 ec 08             	sub    $0x8,%esp
    2979:	68 c0 51 00 00       	push   $0x51c0
    297e:	6a 01                	push   $0x1
    2980:	e8 14 10 00 00       	call   3999 <printf>
    exit();
    2985:	e8 a5 0e 00 00       	call   382f <exit>
    printf(1, "unlink dirfile failed!\n");
    298a:	83 ec 08             	sub    $0x8,%esp
    298d:	68 d1 49 00 00       	push   $0x49d1
    2992:	6a 01                	push   $0x1
    2994:	e8 00 10 00 00       	call   3999 <printf>
    exit();
    2999:	e8 91 0e 00 00       	call   382f <exit>
    printf(1, "open . for writing succeeded!\n");
    299e:	83 ec 08             	sub    $0x8,%esp
    29a1:	68 e0 51 00 00       	push   $0x51e0
    29a6:	6a 01                	push   $0x1
    29a8:	e8 ec 0f 00 00       	call   3999 <printf>
    exit();
    29ad:	e8 7d 0e 00 00       	call   382f <exit>
    printf(1, "write . succeeded!\n");
    29b2:	83 ec 08             	sub    $0x8,%esp
    29b5:	68 e9 49 00 00       	push   $0x49e9
    29ba:	6a 01                	push   $0x1
    29bc:	e8 d8 0f 00 00       	call   3999 <printf>
    exit();
    29c1:	e8 69 0e 00 00       	call   382f <exit>

000029c6 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    29c6:	55                   	push   %ebp
    29c7:	89 e5                	mov    %esp,%ebp
    29c9:	53                   	push   %ebx
    29ca:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(1, "empty file name\n");
    29cd:	68 0d 4a 00 00       	push   $0x4a0d
    29d2:	6a 01                	push   $0x1
    29d4:	e8 c0 0f 00 00       	call   3999 <printf>
    29d9:	83 c4 10             	add    $0x10,%esp
    29dc:	bb 33 00 00 00       	mov    $0x33,%ebx
    29e1:	eb 4f                	jmp    2a32 <iref+0x6c>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    29e3:	83 ec 08             	sub    $0x8,%esp
    29e6:	68 24 4a 00 00       	push   $0x4a24
    29eb:	6a 01                	push   $0x1
    29ed:	e8 a7 0f 00 00       	call   3999 <printf>
      exit();
    29f2:	e8 38 0e 00 00       	call   382f <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    29f7:	83 ec 08             	sub    $0x8,%esp
    29fa:	68 38 4a 00 00       	push   $0x4a38
    29ff:	6a 01                	push   $0x1
    2a01:	e8 93 0f 00 00       	call   3999 <printf>
      exit();
    2a06:	e8 24 0e 00 00       	call   382f <exit>

    mkdir("");
    link("README", "");
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    2a0b:	83 ec 0c             	sub    $0xc,%esp
    2a0e:	50                   	push   %eax
    2a0f:	e8 43 0e 00 00       	call   3857 <close>
    2a14:	83 c4 10             	add    $0x10,%esp
    2a17:	eb 7d                	jmp    2a96 <iref+0xd0>
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    2a19:	83 ec 0c             	sub    $0xc,%esp
    2a1c:	68 08 46 00 00       	push   $0x4608
    2a21:	e8 59 0e 00 00       	call   387f <unlink>
  for(i = 0; i < 50 + 1; i++){
    2a26:	83 c4 10             	add    $0x10,%esp
    2a29:	83 eb 01             	sub    $0x1,%ebx
    2a2c:	0f 84 92 00 00 00    	je     2ac4 <iref+0xfe>
    if(mkdir("irefd") != 0){
    2a32:	83 ec 0c             	sub    $0xc,%esp
    2a35:	68 1e 4a 00 00       	push   $0x4a1e
    2a3a:	e8 58 0e 00 00       	call   3897 <mkdir>
    2a3f:	83 c4 10             	add    $0x10,%esp
    2a42:	85 c0                	test   %eax,%eax
    2a44:	75 9d                	jne    29e3 <iref+0x1d>
    if(chdir("irefd") != 0){
    2a46:	83 ec 0c             	sub    $0xc,%esp
    2a49:	68 1e 4a 00 00       	push   $0x4a1e
    2a4e:	e8 4c 0e 00 00       	call   389f <chdir>
    2a53:	83 c4 10             	add    $0x10,%esp
    2a56:	85 c0                	test   %eax,%eax
    2a58:	75 9d                	jne    29f7 <iref+0x31>
    mkdir("");
    2a5a:	83 ec 0c             	sub    $0xc,%esp
    2a5d:	68 d3 40 00 00       	push   $0x40d3
    2a62:	e8 30 0e 00 00       	call   3897 <mkdir>
    link("README", "");
    2a67:	83 c4 08             	add    $0x8,%esp
    2a6a:	68 d3 40 00 00       	push   $0x40d3
    2a6f:	68 ca 49 00 00       	push   $0x49ca
    2a74:	e8 16 0e 00 00       	call   388f <link>
    fd = open("", O_CREATE);
    2a79:	83 c4 08             	add    $0x8,%esp
    2a7c:	68 00 02 00 00       	push   $0x200
    2a81:	68 d3 40 00 00       	push   $0x40d3
    2a86:	e8 e4 0d 00 00       	call   386f <open>
    if(fd >= 0)
    2a8b:	83 c4 10             	add    $0x10,%esp
    2a8e:	85 c0                	test   %eax,%eax
    2a90:	0f 89 75 ff ff ff    	jns    2a0b <iref+0x45>
    fd = open("xx", O_CREATE);
    2a96:	83 ec 08             	sub    $0x8,%esp
    2a99:	68 00 02 00 00       	push   $0x200
    2a9e:	68 08 46 00 00       	push   $0x4608
    2aa3:	e8 c7 0d 00 00       	call   386f <open>
    if(fd >= 0)
    2aa8:	83 c4 10             	add    $0x10,%esp
    2aab:	85 c0                	test   %eax,%eax
    2aad:	0f 88 66 ff ff ff    	js     2a19 <iref+0x53>
      close(fd);
    2ab3:	83 ec 0c             	sub    $0xc,%esp
    2ab6:	50                   	push   %eax
    2ab7:	e8 9b 0d 00 00       	call   3857 <close>
    2abc:	83 c4 10             	add    $0x10,%esp
    2abf:	e9 55 ff ff ff       	jmp    2a19 <iref+0x53>
  }

  chdir("/");
    2ac4:	83 ec 0c             	sub    $0xc,%esp
    2ac7:	68 f9 3c 00 00       	push   $0x3cf9
    2acc:	e8 ce 0d 00 00       	call   389f <chdir>
  printf(1, "empty file name OK\n");
    2ad1:	83 c4 08             	add    $0x8,%esp
    2ad4:	68 4c 4a 00 00       	push   $0x4a4c
    2ad9:	6a 01                	push   $0x1
    2adb:	e8 b9 0e 00 00       	call   3999 <printf>
}
    2ae0:	83 c4 10             	add    $0x10,%esp
    2ae3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2ae6:	c9                   	leave  
    2ae7:	c3                   	ret    

00002ae8 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2ae8:	55                   	push   %ebp
    2ae9:	89 e5                	mov    %esp,%ebp
    2aeb:	53                   	push   %ebx
    2aec:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    2aef:	68 60 4a 00 00       	push   $0x4a60
    2af4:	6a 01                	push   $0x1
    2af6:	e8 9e 0e 00 00       	call   3999 <printf>
    2afb:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    2afe:	bb 00 00 00 00       	mov    $0x0,%ebx
    pid = fork();
    2b03:	e8 1f 0d 00 00       	call   3827 <fork>
    if(pid < 0)
    2b08:	85 c0                	test   %eax,%eax
    2b0a:	78 28                	js     2b34 <forktest+0x4c>
      break;
    if(pid == 0)
    2b0c:	85 c0                	test   %eax,%eax
    2b0e:	74 1f                	je     2b2f <forktest+0x47>
  for(n=0; n<1000; n++){
    2b10:	83 c3 01             	add    $0x1,%ebx
    2b13:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2b19:	75 e8                	jne    2b03 <forktest+0x1b>
      exit();
  }

  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    2b1b:	83 ec 08             	sub    $0x8,%esp
    2b1e:	68 00 52 00 00       	push   $0x5200
    2b23:	6a 01                	push   $0x1
    2b25:	e8 6f 0e 00 00       	call   3999 <printf>
    exit();
    2b2a:	e8 00 0d 00 00       	call   382f <exit>
      exit();
    2b2f:	e8 fb 0c 00 00       	call   382f <exit>
  if(n == 1000){
    2b34:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2b3a:	74 df                	je     2b1b <forktest+0x33>
  }

  for(; n > 0; n--){
    2b3c:	85 db                	test   %ebx,%ebx
    2b3e:	7e 0e                	jle    2b4e <forktest+0x66>
    if(wait() < 0){
    2b40:	e8 f2 0c 00 00       	call   3837 <wait>
    2b45:	85 c0                	test   %eax,%eax
    2b47:	78 26                	js     2b6f <forktest+0x87>
  for(; n > 0; n--){
    2b49:	83 eb 01             	sub    $0x1,%ebx
    2b4c:	75 f2                	jne    2b40 <forktest+0x58>
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
    2b4e:	e8 e4 0c 00 00       	call   3837 <wait>
    2b53:	83 f8 ff             	cmp    $0xffffffff,%eax
    2b56:	75 2b                	jne    2b83 <forktest+0x9b>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
    2b58:	83 ec 08             	sub    $0x8,%esp
    2b5b:	68 92 4a 00 00       	push   $0x4a92
    2b60:	6a 01                	push   $0x1
    2b62:	e8 32 0e 00 00       	call   3999 <printf>
}
    2b67:	83 c4 10             	add    $0x10,%esp
    2b6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2b6d:	c9                   	leave  
    2b6e:	c3                   	ret    
      printf(1, "wait stopped early\n");
    2b6f:	83 ec 08             	sub    $0x8,%esp
    2b72:	68 6b 4a 00 00       	push   $0x4a6b
    2b77:	6a 01                	push   $0x1
    2b79:	e8 1b 0e 00 00       	call   3999 <printf>
      exit();
    2b7e:	e8 ac 0c 00 00       	call   382f <exit>
    printf(1, "wait got too many\n");
    2b83:	83 ec 08             	sub    $0x8,%esp
    2b86:	68 7f 4a 00 00       	push   $0x4a7f
    2b8b:	6a 01                	push   $0x1
    2b8d:	e8 07 0e 00 00       	call   3999 <printf>
    exit();
    2b92:	e8 98 0c 00 00       	call   382f <exit>

00002b97 <sbrktest>:

void
sbrktest(void)
{
    2b97:	55                   	push   %ebp
    2b98:	89 e5                	mov    %esp,%ebp
    2b9a:	57                   	push   %edi
    2b9b:	56                   	push   %esi
    2b9c:	53                   	push   %ebx
    2b9d:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2ba0:	68 a0 4a 00 00       	push   $0x4aa0
    2ba5:	ff 35 10 5d 00 00    	pushl  0x5d10
    2bab:	e8 e9 0d 00 00       	call   3999 <printf>
  oldbrk = sbrk(0);
    2bb0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2bb7:	e8 fb 0c 00 00       	call   38b7 <sbrk>
    2bbc:	89 c3                	mov    %eax,%ebx

  // can one sbrk() less than a page?
  a = sbrk(0);
    2bbe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2bc5:	e8 ed 0c 00 00       	call   38b7 <sbrk>
    2bca:	89 c6                	mov    %eax,%esi
    2bcc:	83 c4 10             	add    $0x10,%esp
  int i;
  for(i = 0; i < 5000; i++){
    2bcf:	bf 00 00 00 00       	mov    $0x0,%edi
    2bd4:	eb 02                	jmp    2bd8 <sbrktest+0x41>
    if(b != a){
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
    a = b + 1;
    2bd6:	89 c6                	mov    %eax,%esi
    b = sbrk(1);
    2bd8:	83 ec 0c             	sub    $0xc,%esp
    2bdb:	6a 01                	push   $0x1
    2bdd:	e8 d5 0c 00 00       	call   38b7 <sbrk>
    if(b != a){
    2be2:	83 c4 10             	add    $0x10,%esp
    2be5:	39 f0                	cmp    %esi,%eax
    2be7:	0f 85 8e 01 00 00    	jne    2d7b <sbrktest+0x1e4>
    *b = 1;
    2bed:	c6 06 01             	movb   $0x1,(%esi)
    a = b + 1;
    2bf0:	8d 46 01             	lea    0x1(%esi),%eax
  for(i = 0; i < 5000; i++){
    2bf3:	83 c7 01             	add    $0x1,%edi
    2bf6:	81 ff 88 13 00 00    	cmp    $0x1388,%edi
    2bfc:	75 d8                	jne    2bd6 <sbrktest+0x3f>
  }
  pid = fork();
    2bfe:	e8 24 0c 00 00       	call   3827 <fork>
    2c03:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    2c05:	85 c0                	test   %eax,%eax
    2c07:	0f 88 8c 01 00 00    	js     2d99 <sbrktest+0x202>
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    2c0d:	83 ec 0c             	sub    $0xc,%esp
    2c10:	6a 01                	push   $0x1
    2c12:	e8 a0 0c 00 00       	call   38b7 <sbrk>
  c = sbrk(1);
    2c17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c1e:	e8 94 0c 00 00       	call   38b7 <sbrk>
  if(c != a + 1){
    2c23:	83 c6 02             	add    $0x2,%esi
    2c26:	83 c4 10             	add    $0x10,%esp
    2c29:	39 f0                	cmp    %esi,%eax
    2c2b:	0f 85 80 01 00 00    	jne    2db1 <sbrktest+0x21a>
    printf(stdout, "sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    2c31:	85 ff                	test   %edi,%edi
    2c33:	0f 84 90 01 00 00    	je     2dc9 <sbrktest+0x232>
    exit();
  wait();
    2c39:	e8 f9 0b 00 00       	call   3837 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    2c3e:	83 ec 0c             	sub    $0xc,%esp
    2c41:	6a 00                	push   $0x0
    2c43:	e8 6f 0c 00 00       	call   38b7 <sbrk>
    2c48:	89 c6                	mov    %eax,%esi
  amt = (BIG) - (uint)a;
    2c4a:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2c4f:	29 f0                	sub    %esi,%eax
  p = sbrk(amt);
    2c51:	89 04 24             	mov    %eax,(%esp)
    2c54:	e8 5e 0c 00 00       	call   38b7 <sbrk>
  if (p != a) {
    2c59:	83 c4 10             	add    $0x10,%esp
    2c5c:	39 c6                	cmp    %eax,%esi
    2c5e:	0f 85 6a 01 00 00    	jne    2dce <sbrktest+0x237>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    2c64:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
    2c6b:	83 ec 0c             	sub    $0xc,%esp
    2c6e:	6a 00                	push   $0x0
    2c70:	e8 42 0c 00 00       	call   38b7 <sbrk>
    2c75:	89 c6                	mov    %eax,%esi
  c = sbrk(-4096);
    2c77:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2c7e:	e8 34 0c 00 00       	call   38b7 <sbrk>
  if(c == (char*)0xffffffff){
    2c83:	83 c4 10             	add    $0x10,%esp
    2c86:	83 f8 ff             	cmp    $0xffffffff,%eax
    2c89:	0f 84 57 01 00 00    	je     2de6 <sbrktest+0x24f>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
    2c8f:	83 ec 0c             	sub    $0xc,%esp
    2c92:	6a 00                	push   $0x0
    2c94:	e8 1e 0c 00 00       	call   38b7 <sbrk>
  if(c != a - 4096){
    2c99:	8d 96 00 f0 ff ff    	lea    -0x1000(%esi),%edx
    2c9f:	83 c4 10             	add    $0x10,%esp
    2ca2:	39 d0                	cmp    %edx,%eax
    2ca4:	0f 85 54 01 00 00    	jne    2dfe <sbrktest+0x267>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    2caa:	83 ec 0c             	sub    $0xc,%esp
    2cad:	6a 00                	push   $0x0
    2caf:	e8 03 0c 00 00       	call   38b7 <sbrk>
    2cb4:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    2cb6:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2cbd:	e8 f5 0b 00 00       	call   38b7 <sbrk>
    2cc2:	89 c7                	mov    %eax,%edi
  if(c != a || sbrk(0) != a + 4096){
    2cc4:	83 c4 10             	add    $0x10,%esp
    2cc7:	39 c6                	cmp    %eax,%esi
    2cc9:	0f 85 46 01 00 00    	jne    2e15 <sbrktest+0x27e>
    2ccf:	83 ec 0c             	sub    $0xc,%esp
    2cd2:	6a 00                	push   $0x0
    2cd4:	e8 de 0b 00 00       	call   38b7 <sbrk>
    2cd9:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    2cdf:	83 c4 10             	add    $0x10,%esp
    2ce2:	39 d0                	cmp    %edx,%eax
    2ce4:	0f 85 2b 01 00 00    	jne    2e15 <sbrktest+0x27e>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    2cea:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2cf1:	0f 84 35 01 00 00    	je     2e2c <sbrktest+0x295>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    2cf7:	83 ec 0c             	sub    $0xc,%esp
    2cfa:	6a 00                	push   $0x0
    2cfc:	e8 b6 0b 00 00       	call   38b7 <sbrk>
    2d01:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    2d03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d0a:	e8 a8 0b 00 00       	call   38b7 <sbrk>
    2d0f:	89 d9                	mov    %ebx,%ecx
    2d11:	29 c1                	sub    %eax,%ecx
    2d13:	89 0c 24             	mov    %ecx,(%esp)
    2d16:	e8 9c 0b 00 00       	call   38b7 <sbrk>
  if(c != a){
    2d1b:	83 c4 10             	add    $0x10,%esp
    2d1e:	39 c6                	cmp    %eax,%esi
    2d20:	0f 85 1e 01 00 00    	jne    2e44 <sbrktest+0x2ad>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2d26:	be 00 00 00 80       	mov    $0x80000000,%esi
    ppid = getpid();
    2d2b:	e8 7f 0b 00 00       	call   38af <getpid>
    2d30:	89 c7                	mov    %eax,%edi
    pid = fork();
    2d32:	e8 f0 0a 00 00       	call   3827 <fork>
    if(pid < 0){
    2d37:	85 c0                	test   %eax,%eax
    2d39:	0f 88 1c 01 00 00    	js     2e5b <sbrktest+0x2c4>
      printf(stdout, "fork failed\n");
      exit();
    }
    if(pid == 0){
    2d3f:	85 c0                	test   %eax,%eax
    2d41:	0f 84 2c 01 00 00    	je     2e73 <sbrktest+0x2dc>
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
    2d47:	e8 eb 0a 00 00       	call   3837 <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2d4c:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    2d52:	81 fe 80 84 1e 80    	cmp    $0x801e8480,%esi
    2d58:	75 d1                	jne    2d2b <sbrktest+0x194>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    2d5a:	83 ec 0c             	sub    $0xc,%esp
    2d5d:	8d 45 e0             	lea    -0x20(%ebp),%eax
    2d60:	50                   	push   %eax
    2d61:	e8 d9 0a 00 00       	call   383f <pipe>
    2d66:	83 c4 10             	add    $0x10,%esp
    2d69:	85 c0                	test   %eax,%eax
    2d6b:	0f 85 24 01 00 00    	jne    2e95 <sbrktest+0x2fe>
    2d71:	8d 7d b8             	lea    -0x48(%ebp),%edi
    2d74:	89 fe                	mov    %edi,%esi
    2d76:	e9 78 01 00 00       	jmp    2ef3 <sbrktest+0x35c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2d7b:	83 ec 0c             	sub    $0xc,%esp
    2d7e:	50                   	push   %eax
    2d7f:	56                   	push   %esi
    2d80:	57                   	push   %edi
    2d81:	68 ab 4a 00 00       	push   $0x4aab
    2d86:	ff 35 10 5d 00 00    	pushl  0x5d10
    2d8c:	e8 08 0c 00 00       	call   3999 <printf>
      exit();
    2d91:	83 c4 20             	add    $0x20,%esp
    2d94:	e8 96 0a 00 00       	call   382f <exit>
    printf(stdout, "sbrk test fork failed\n");
    2d99:	83 ec 08             	sub    $0x8,%esp
    2d9c:	68 c6 4a 00 00       	push   $0x4ac6
    2da1:	ff 35 10 5d 00 00    	pushl  0x5d10
    2da7:	e8 ed 0b 00 00       	call   3999 <printf>
    exit();
    2dac:	e8 7e 0a 00 00       	call   382f <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    2db1:	83 ec 08             	sub    $0x8,%esp
    2db4:	68 dd 4a 00 00       	push   $0x4add
    2db9:	ff 35 10 5d 00 00    	pushl  0x5d10
    2dbf:	e8 d5 0b 00 00       	call   3999 <printf>
    exit();
    2dc4:	e8 66 0a 00 00       	call   382f <exit>
    exit();
    2dc9:	e8 61 0a 00 00       	call   382f <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2dce:	83 ec 08             	sub    $0x8,%esp
    2dd1:	68 24 52 00 00       	push   $0x5224
    2dd6:	ff 35 10 5d 00 00    	pushl  0x5d10
    2ddc:	e8 b8 0b 00 00       	call   3999 <printf>
    exit();
    2de1:	e8 49 0a 00 00       	call   382f <exit>
    printf(stdout, "sbrk could not deallocate\n");
    2de6:	83 ec 08             	sub    $0x8,%esp
    2de9:	68 f9 4a 00 00       	push   $0x4af9
    2dee:	ff 35 10 5d 00 00    	pushl  0x5d10
    2df4:	e8 a0 0b 00 00       	call   3999 <printf>
    exit();
    2df9:	e8 31 0a 00 00       	call   382f <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2dfe:	50                   	push   %eax
    2dff:	56                   	push   %esi
    2e00:	68 64 52 00 00       	push   $0x5264
    2e05:	ff 35 10 5d 00 00    	pushl  0x5d10
    2e0b:	e8 89 0b 00 00       	call   3999 <printf>
    exit();
    2e10:	e8 1a 0a 00 00       	call   382f <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    2e15:	57                   	push   %edi
    2e16:	56                   	push   %esi
    2e17:	68 9c 52 00 00       	push   $0x529c
    2e1c:	ff 35 10 5d 00 00    	pushl  0x5d10
    2e22:	e8 72 0b 00 00       	call   3999 <printf>
    exit();
    2e27:	e8 03 0a 00 00       	call   382f <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    2e2c:	83 ec 08             	sub    $0x8,%esp
    2e2f:	68 c4 52 00 00       	push   $0x52c4
    2e34:	ff 35 10 5d 00 00    	pushl  0x5d10
    2e3a:	e8 5a 0b 00 00       	call   3999 <printf>
    exit();
    2e3f:	e8 eb 09 00 00       	call   382f <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    2e44:	50                   	push   %eax
    2e45:	56                   	push   %esi
    2e46:	68 f4 52 00 00       	push   $0x52f4
    2e4b:	ff 35 10 5d 00 00    	pushl  0x5d10
    2e51:	e8 43 0b 00 00       	call   3999 <printf>
    exit();
    2e56:	e8 d4 09 00 00       	call   382f <exit>
      printf(stdout, "fork failed\n");
    2e5b:	83 ec 08             	sub    $0x8,%esp
    2e5e:	68 f1 4b 00 00       	push   $0x4bf1
    2e63:	ff 35 10 5d 00 00    	pushl  0x5d10
    2e69:	e8 2b 0b 00 00       	call   3999 <printf>
      exit();
    2e6e:	e8 bc 09 00 00       	call   382f <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    2e73:	0f be 06             	movsbl (%esi),%eax
    2e76:	50                   	push   %eax
    2e77:	56                   	push   %esi
    2e78:	68 14 4b 00 00       	push   $0x4b14
    2e7d:	ff 35 10 5d 00 00    	pushl  0x5d10
    2e83:	e8 11 0b 00 00       	call   3999 <printf>
      kill(ppid);
    2e88:	89 3c 24             	mov    %edi,(%esp)
    2e8b:	e8 cf 09 00 00       	call   385f <kill>
      exit();
    2e90:	e8 9a 09 00 00       	call   382f <exit>
    printf(1, "pipe() failed\n");
    2e95:	83 ec 08             	sub    $0x8,%esp
    2e98:	68 e9 3f 00 00       	push   $0x3fe9
    2e9d:	6a 01                	push   $0x1
    2e9f:	e8 f5 0a 00 00       	call   3999 <printf>
    exit();
    2ea4:	e8 86 09 00 00       	call   382f <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    2ea9:	83 ec 0c             	sub    $0xc,%esp
    2eac:	6a 00                	push   $0x0
    2eae:	e8 04 0a 00 00       	call   38b7 <sbrk>
    2eb3:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2eb8:	29 c2                	sub    %eax,%edx
    2eba:	89 14 24             	mov    %edx,(%esp)
    2ebd:	e8 f5 09 00 00       	call   38b7 <sbrk>
      write(fds[1], "x", 1);
    2ec2:	83 c4 0c             	add    $0xc,%esp
    2ec5:	6a 01                	push   $0x1
    2ec7:	68 09 46 00 00       	push   $0x4609
    2ecc:	ff 75 e4             	pushl  -0x1c(%ebp)
    2ecf:	e8 7b 09 00 00       	call   384f <write>
    2ed4:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    2ed7:	83 ec 0c             	sub    $0xc,%esp
    2eda:	68 e8 03 00 00       	push   $0x3e8
    2edf:	e8 db 09 00 00       	call   38bf <sleep>
    2ee4:	83 c4 10             	add    $0x10,%esp
    2ee7:	eb ee                	jmp    2ed7 <sbrktest+0x340>
    2ee9:	83 c6 04             	add    $0x4,%esi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2eec:	8d 45 e0             	lea    -0x20(%ebp),%eax
    2eef:	39 c6                	cmp    %eax,%esi
    2ef1:	74 26                	je     2f19 <sbrktest+0x382>
    if((pids[i] = fork()) == 0){
    2ef3:	e8 2f 09 00 00       	call   3827 <fork>
    2ef8:	89 06                	mov    %eax,(%esi)
    2efa:	85 c0                	test   %eax,%eax
    2efc:	74 ab                	je     2ea9 <sbrktest+0x312>
    }
    if(pids[i] != -1)
    2efe:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f01:	74 e6                	je     2ee9 <sbrktest+0x352>
      read(fds[0], &scratch, 1);
    2f03:	83 ec 04             	sub    $0x4,%esp
    2f06:	6a 01                	push   $0x1
    2f08:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2f0b:	50                   	push   %eax
    2f0c:	ff 75 e0             	pushl  -0x20(%ebp)
    2f0f:	e8 33 09 00 00       	call   3847 <read>
    2f14:	83 c4 10             	add    $0x10,%esp
    2f17:	eb d0                	jmp    2ee9 <sbrktest+0x352>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    2f19:	83 ec 0c             	sub    $0xc,%esp
    2f1c:	68 00 10 00 00       	push   $0x1000
    2f21:	e8 91 09 00 00       	call   38b7 <sbrk>
    2f26:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    2f29:	83 c4 10             	add    $0x10,%esp
    2f2c:	eb 07                	jmp    2f35 <sbrktest+0x39e>
    2f2e:	83 c7 04             	add    $0x4,%edi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f31:	39 fe                	cmp    %edi,%esi
    2f33:	74 1a                	je     2f4f <sbrktest+0x3b8>
    if(pids[i] == -1)
    2f35:	8b 07                	mov    (%edi),%eax
    2f37:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f3a:	74 f2                	je     2f2e <sbrktest+0x397>
      continue;
    kill(pids[i]);
    2f3c:	83 ec 0c             	sub    $0xc,%esp
    2f3f:	50                   	push   %eax
    2f40:	e8 1a 09 00 00       	call   385f <kill>
    wait();
    2f45:	e8 ed 08 00 00       	call   3837 <wait>
    2f4a:	83 c4 10             	add    $0x10,%esp
    2f4d:	eb df                	jmp    2f2e <sbrktest+0x397>
  }
  if(c == (char*)0xffffffff){
    2f4f:	83 7d a4 ff          	cmpl   $0xffffffff,-0x5c(%ebp)
    2f53:	74 2f                	je     2f84 <sbrktest+0x3ed>
    printf(stdout, "failed sbrk leaked memory\n");
    exit();
  }

  if(sbrk(0) > oldbrk)
    2f55:	83 ec 0c             	sub    $0xc,%esp
    2f58:	6a 00                	push   $0x0
    2f5a:	e8 58 09 00 00       	call   38b7 <sbrk>
    2f5f:	83 c4 10             	add    $0x10,%esp
    2f62:	39 d8                	cmp    %ebx,%eax
    2f64:	77 36                	ja     2f9c <sbrktest+0x405>
    sbrk(-(sbrk(0) - oldbrk));

  printf(stdout, "sbrk test OK\n");
    2f66:	83 ec 08             	sub    $0x8,%esp
    2f69:	68 48 4b 00 00       	push   $0x4b48
    2f6e:	ff 35 10 5d 00 00    	pushl  0x5d10
    2f74:	e8 20 0a 00 00       	call   3999 <printf>
}
    2f79:	83 c4 10             	add    $0x10,%esp
    2f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2f7f:	5b                   	pop    %ebx
    2f80:	5e                   	pop    %esi
    2f81:	5f                   	pop    %edi
    2f82:	5d                   	pop    %ebp
    2f83:	c3                   	ret    
    printf(stdout, "failed sbrk leaked memory\n");
    2f84:	83 ec 08             	sub    $0x8,%esp
    2f87:	68 2d 4b 00 00       	push   $0x4b2d
    2f8c:	ff 35 10 5d 00 00    	pushl  0x5d10
    2f92:	e8 02 0a 00 00       	call   3999 <printf>
    exit();
    2f97:	e8 93 08 00 00       	call   382f <exit>
    sbrk(-(sbrk(0) - oldbrk));
    2f9c:	83 ec 0c             	sub    $0xc,%esp
    2f9f:	6a 00                	push   $0x0
    2fa1:	e8 11 09 00 00       	call   38b7 <sbrk>
    2fa6:	29 c3                	sub    %eax,%ebx
    2fa8:	89 1c 24             	mov    %ebx,(%esp)
    2fab:	e8 07 09 00 00       	call   38b7 <sbrk>
    2fb0:	83 c4 10             	add    $0x10,%esp
    2fb3:	eb b1                	jmp    2f66 <sbrktest+0x3cf>

00002fb5 <validateint>:

void
validateint(int *p)
{
    2fb5:	55                   	push   %ebp
    2fb6:	89 e5                	mov    %esp,%ebp
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    2fb8:	5d                   	pop    %ebp
    2fb9:	c3                   	ret    

00002fba <validatetest>:

void
validatetest(void)
{
    2fba:	55                   	push   %ebp
    2fbb:	89 e5                	mov    %esp,%ebp
    2fbd:	56                   	push   %esi
    2fbe:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    2fbf:	83 ec 08             	sub    $0x8,%esp
    2fc2:	68 56 4b 00 00       	push   $0x4b56
    2fc7:	ff 35 10 5d 00 00    	pushl  0x5d10
    2fcd:	e8 c7 09 00 00       	call   3999 <printf>
    2fd2:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    2fd5:	bb 00 00 00 00       	mov    $0x0,%ebx
    if((pid = fork()) == 0){
    2fda:	e8 48 08 00 00       	call   3827 <fork>
    2fdf:	89 c6                	mov    %eax,%esi
    2fe1:	85 c0                	test   %eax,%eax
    2fe3:	74 64                	je     3049 <validatetest+0x8f>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit();
    }
    sleep(0);
    2fe5:	83 ec 0c             	sub    $0xc,%esp
    2fe8:	6a 00                	push   $0x0
    2fea:	e8 d0 08 00 00       	call   38bf <sleep>
    sleep(0);
    2fef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ff6:	e8 c4 08 00 00       	call   38bf <sleep>
    kill(pid);
    2ffb:	89 34 24             	mov    %esi,(%esp)
    2ffe:	e8 5c 08 00 00       	call   385f <kill>
    wait();
    3003:	e8 2f 08 00 00       	call   3837 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3008:	83 c4 08             	add    $0x8,%esp
    300b:	53                   	push   %ebx
    300c:	68 65 4b 00 00       	push   $0x4b65
    3011:	e8 79 08 00 00       	call   388f <link>
    3016:	83 c4 10             	add    $0x10,%esp
    3019:	83 f8 ff             	cmp    $0xffffffff,%eax
    301c:	75 30                	jne    304e <validatetest+0x94>
  for(p = 0; p <= (uint)hi; p += 4096){
    301e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    3024:	81 fb 00 40 11 00    	cmp    $0x114000,%ebx
    302a:	75 ae                	jne    2fda <validatetest+0x20>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    302c:	83 ec 08             	sub    $0x8,%esp
    302f:	68 89 4b 00 00       	push   $0x4b89
    3034:	ff 35 10 5d 00 00    	pushl  0x5d10
    303a:	e8 5a 09 00 00       	call   3999 <printf>
}
    303f:	83 c4 10             	add    $0x10,%esp
    3042:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3045:	5b                   	pop    %ebx
    3046:	5e                   	pop    %esi
    3047:	5d                   	pop    %ebp
    3048:	c3                   	ret    
      exit();
    3049:	e8 e1 07 00 00       	call   382f <exit>
      printf(stdout, "link should not succeed\n");
    304e:	83 ec 08             	sub    $0x8,%esp
    3051:	68 70 4b 00 00       	push   $0x4b70
    3056:	ff 35 10 5d 00 00    	pushl  0x5d10
    305c:	e8 38 09 00 00       	call   3999 <printf>
      exit();
    3061:	e8 c9 07 00 00       	call   382f <exit>

00003066 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    3066:	55                   	push   %ebp
    3067:	89 e5                	mov    %esp,%ebp
    3069:	83 ec 10             	sub    $0x10,%esp
  int i;

  printf(stdout, "bss test\n");
    306c:	68 96 4b 00 00       	push   $0x4b96
    3071:	ff 35 10 5d 00 00    	pushl  0x5d10
    3077:	e8 1d 09 00 00       	call   3999 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
    307c:	83 c4 10             	add    $0x10,%esp
    307f:	80 3d e0 5d 00 00 00 	cmpb   $0x0,0x5de0
    3086:	75 30                	jne    30b8 <bsstest+0x52>
  for(i = 0; i < sizeof(uninit); i++){
    3088:	b8 01 00 00 00       	mov    $0x1,%eax
    if(uninit[i] != '\0'){
    308d:	80 b8 e0 5d 00 00 00 	cmpb   $0x0,0x5de0(%eax)
    3094:	75 22                	jne    30b8 <bsstest+0x52>
  for(i = 0; i < sizeof(uninit); i++){
    3096:	83 c0 01             	add    $0x1,%eax
    3099:	3d 10 27 00 00       	cmp    $0x2710,%eax
    309e:	75 ed                	jne    308d <bsstest+0x27>
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    30a0:	83 ec 08             	sub    $0x8,%esp
    30a3:	68 b1 4b 00 00       	push   $0x4bb1
    30a8:	ff 35 10 5d 00 00    	pushl  0x5d10
    30ae:	e8 e6 08 00 00       	call   3999 <printf>
}
    30b3:	83 c4 10             	add    $0x10,%esp
    30b6:	c9                   	leave  
    30b7:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    30b8:	83 ec 08             	sub    $0x8,%esp
    30bb:	68 a0 4b 00 00       	push   $0x4ba0
    30c0:	ff 35 10 5d 00 00    	pushl  0x5d10
    30c6:	e8 ce 08 00 00       	call   3999 <printf>
      exit();
    30cb:	e8 5f 07 00 00       	call   382f <exit>

000030d0 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    30d0:	55                   	push   %ebp
    30d1:	89 e5                	mov    %esp,%ebp
    30d3:	83 ec 14             	sub    $0x14,%esp
  int pid, fd;

  unlink("bigarg-ok");
    30d6:	68 be 4b 00 00       	push   $0x4bbe
    30db:	e8 9f 07 00 00       	call   387f <unlink>
  pid = fork();
    30e0:	e8 42 07 00 00       	call   3827 <fork>
  if(pid == 0){
    30e5:	83 c4 10             	add    $0x10,%esp
    30e8:	85 c0                	test   %eax,%eax
    30ea:	74 41                	je     312d <bigargtest+0x5d>
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
    30ec:	85 c0                	test   %eax,%eax
    30ee:	0f 88 b1 00 00 00    	js     31a5 <bigargtest+0xd5>
    printf(stdout, "bigargtest: fork failed\n");
    exit();
  }
  wait();
    30f4:	e8 3e 07 00 00       	call   3837 <wait>
  fd = open("bigarg-ok", 0);
    30f9:	83 ec 08             	sub    $0x8,%esp
    30fc:	6a 00                	push   $0x0
    30fe:	68 be 4b 00 00       	push   $0x4bbe
    3103:	e8 67 07 00 00       	call   386f <open>
  if(fd < 0){
    3108:	83 c4 10             	add    $0x10,%esp
    310b:	85 c0                	test   %eax,%eax
    310d:	0f 88 aa 00 00 00    	js     31bd <bigargtest+0xed>
    printf(stdout, "bigarg test failed!\n");
    exit();
  }
  close(fd);
    3113:	83 ec 0c             	sub    $0xc,%esp
    3116:	50                   	push   %eax
    3117:	e8 3b 07 00 00       	call   3857 <close>
  unlink("bigarg-ok");
    311c:	c7 04 24 be 4b 00 00 	movl   $0x4bbe,(%esp)
    3123:	e8 57 07 00 00       	call   387f <unlink>
}
    3128:	83 c4 10             	add    $0x10,%esp
    312b:	c9                   	leave  
    312c:	c3                   	ret    
    312d:	b8 40 5d 00 00       	mov    $0x5d40,%eax
    3132:	ba bc 5d 00 00       	mov    $0x5dbc,%edx
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3137:	c7 00 18 53 00 00    	movl   $0x5318,(%eax)
    313d:	83 c0 04             	add    $0x4,%eax
    for(i = 0; i < MAXARG-1; i++)
    3140:	39 d0                	cmp    %edx,%eax
    3142:	75 f3                	jne    3137 <bigargtest+0x67>
    args[MAXARG-1] = 0;
    3144:	c7 05 bc 5d 00 00 00 	movl   $0x0,0x5dbc
    314b:	00 00 00 
    printf(stdout, "bigarg test\n");
    314e:	83 ec 08             	sub    $0x8,%esp
    3151:	68 c8 4b 00 00       	push   $0x4bc8
    3156:	ff 35 10 5d 00 00    	pushl  0x5d10
    315c:	e8 38 08 00 00       	call   3999 <printf>
    exec("echo", args);
    3161:	83 c4 08             	add    $0x8,%esp
    3164:	68 40 5d 00 00       	push   $0x5d40
    3169:	68 95 3d 00 00       	push   $0x3d95
    316e:	e8 f4 06 00 00       	call   3867 <exec>
    printf(stdout, "bigarg test ok\n");
    3173:	83 c4 08             	add    $0x8,%esp
    3176:	68 d5 4b 00 00       	push   $0x4bd5
    317b:	ff 35 10 5d 00 00    	pushl  0x5d10
    3181:	e8 13 08 00 00       	call   3999 <printf>
    fd = open("bigarg-ok", O_CREATE);
    3186:	83 c4 08             	add    $0x8,%esp
    3189:	68 00 02 00 00       	push   $0x200
    318e:	68 be 4b 00 00       	push   $0x4bbe
    3193:	e8 d7 06 00 00       	call   386f <open>
    close(fd);
    3198:	89 04 24             	mov    %eax,(%esp)
    319b:	e8 b7 06 00 00       	call   3857 <close>
    exit();
    31a0:	e8 8a 06 00 00       	call   382f <exit>
    printf(stdout, "bigargtest: fork failed\n");
    31a5:	83 ec 08             	sub    $0x8,%esp
    31a8:	68 e5 4b 00 00       	push   $0x4be5
    31ad:	ff 35 10 5d 00 00    	pushl  0x5d10
    31b3:	e8 e1 07 00 00       	call   3999 <printf>
    exit();
    31b8:	e8 72 06 00 00       	call   382f <exit>
    printf(stdout, "bigarg test failed!\n");
    31bd:	83 ec 08             	sub    $0x8,%esp
    31c0:	68 fe 4b 00 00       	push   $0x4bfe
    31c5:	ff 35 10 5d 00 00    	pushl  0x5d10
    31cb:	e8 c9 07 00 00       	call   3999 <printf>
    exit();
    31d0:	e8 5a 06 00 00       	call   382f <exit>

000031d5 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    31d5:	55                   	push   %ebp
    31d6:	89 e5                	mov    %esp,%ebp
    31d8:	57                   	push   %edi
    31d9:	56                   	push   %esi
    31da:	53                   	push   %ebx
    31db:	83 ec 54             	sub    $0x54,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    31de:	68 13 4c 00 00       	push   $0x4c13
    31e3:	6a 01                	push   $0x1
    31e5:	e8 af 07 00 00       	call   3999 <printf>
    31ea:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    31ed:	bb 00 00 00 00       	mov    $0x0,%ebx
    char name[64];
    name[0] = 'f';
    31f2:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    31f6:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    31fb:	f7 eb                	imul   %ebx
    31fd:	c1 fa 06             	sar    $0x6,%edx
    3200:	89 de                	mov    %ebx,%esi
    3202:	c1 fe 1f             	sar    $0x1f,%esi
    3205:	29 f2                	sub    %esi,%edx
    3207:	8d 42 30             	lea    0x30(%edx),%eax
    320a:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    320d:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    3213:	89 d9                	mov    %ebx,%ecx
    3215:	29 d1                	sub    %edx,%ecx
    3217:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    321c:	f7 e9                	imul   %ecx
    321e:	c1 fa 05             	sar    $0x5,%edx
    3221:	c1 f9 1f             	sar    $0x1f,%ecx
    3224:	29 ca                	sub    %ecx,%edx
    3226:	83 c2 30             	add    $0x30,%edx
    3229:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    322c:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3231:	f7 eb                	imul   %ebx
    3233:	c1 fa 05             	sar    $0x5,%edx
    3236:	29 f2                	sub    %esi,%edx
    3238:	6b d2 64             	imul   $0x64,%edx,%edx
    323b:	89 df                	mov    %ebx,%edi
    323d:	29 d7                	sub    %edx,%edi
    323f:	b9 67 66 66 66       	mov    $0x66666667,%ecx
    3244:	89 f8                	mov    %edi,%eax
    3246:	f7 e9                	imul   %ecx
    3248:	c1 fa 02             	sar    $0x2,%edx
    324b:	c1 ff 1f             	sar    $0x1f,%edi
    324e:	29 fa                	sub    %edi,%edx
    3250:	83 c2 30             	add    $0x30,%edx
    3253:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3256:	89 d8                	mov    %ebx,%eax
    3258:	f7 e9                	imul   %ecx
    325a:	c1 fa 02             	sar    $0x2,%edx
    325d:	29 f2                	sub    %esi,%edx
    325f:	8d 04 92             	lea    (%edx,%edx,4),%eax
    3262:	01 c0                	add    %eax,%eax
    3264:	89 df                	mov    %ebx,%edi
    3266:	29 c7                	sub    %eax,%edi
    3268:	89 f8                	mov    %edi,%eax
    326a:	83 c0 30             	add    $0x30,%eax
    326d:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    3270:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    3274:	83 ec 04             	sub    $0x4,%esp
    3277:	8d 75 a8             	lea    -0x58(%ebp),%esi
    327a:	56                   	push   %esi
    327b:	68 20 4c 00 00       	push   $0x4c20
    3280:	6a 01                	push   $0x1
    3282:	e8 12 07 00 00       	call   3999 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3287:	83 c4 08             	add    $0x8,%esp
    328a:	68 02 02 00 00       	push   $0x202
    328f:	56                   	push   %esi
    3290:	e8 da 05 00 00       	call   386f <open>
    3295:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    3297:	83 c4 10             	add    $0x10,%esp
    329a:	85 c0                	test   %eax,%eax
    329c:	0f 89 d5 00 00 00    	jns    3377 <fsfull+0x1a2>
      printf(1, "open %s failed\n", name);
    32a2:	83 ec 04             	sub    $0x4,%esp
    32a5:	8d 45 a8             	lea    -0x58(%ebp),%eax
    32a8:	50                   	push   %eax
    32a9:	68 2c 4c 00 00       	push   $0x4c2c
    32ae:	6a 01                	push   $0x1
    32b0:	e8 e4 06 00 00       	call   3999 <printf>
      break;
    32b5:	83 c4 10             	add    $0x10,%esp
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    32b8:	85 db                	test   %ebx,%ebx
    32ba:	0f 88 9d 00 00 00    	js     335d <fsfull+0x188>
    char name[64];
    name[0] = 'f';
    32c0:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    32c4:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    32c9:	f7 eb                	imul   %ebx
    32cb:	c1 fa 06             	sar    $0x6,%edx
    32ce:	89 de                	mov    %ebx,%esi
    32d0:	c1 fe 1f             	sar    $0x1f,%esi
    32d3:	29 f2                	sub    %esi,%edx
    32d5:	8d 42 30             	lea    0x30(%edx),%eax
    32d8:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    32db:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    32e1:	89 d9                	mov    %ebx,%ecx
    32e3:	29 d1                	sub    %edx,%ecx
    32e5:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    32ea:	f7 e9                	imul   %ecx
    32ec:	c1 fa 05             	sar    $0x5,%edx
    32ef:	c1 f9 1f             	sar    $0x1f,%ecx
    32f2:	29 ca                	sub    %ecx,%edx
    32f4:	83 c2 30             	add    $0x30,%edx
    32f7:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    32fa:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    32ff:	f7 eb                	imul   %ebx
    3301:	c1 fa 05             	sar    $0x5,%edx
    3304:	29 f2                	sub    %esi,%edx
    3306:	6b d2 64             	imul   $0x64,%edx,%edx
    3309:	89 df                	mov    %ebx,%edi
    330b:	29 d7                	sub    %edx,%edi
    330d:	b9 67 66 66 66       	mov    $0x66666667,%ecx
    3312:	89 f8                	mov    %edi,%eax
    3314:	f7 e9                	imul   %ecx
    3316:	c1 fa 02             	sar    $0x2,%edx
    3319:	c1 ff 1f             	sar    $0x1f,%edi
    331c:	29 fa                	sub    %edi,%edx
    331e:	83 c2 30             	add    $0x30,%edx
    3321:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3324:	89 d8                	mov    %ebx,%eax
    3326:	f7 e9                	imul   %ecx
    3328:	c1 fa 02             	sar    $0x2,%edx
    332b:	29 f2                	sub    %esi,%edx
    332d:	8d 04 92             	lea    (%edx,%edx,4),%eax
    3330:	01 c0                	add    %eax,%eax
    3332:	89 de                	mov    %ebx,%esi
    3334:	29 c6                	sub    %eax,%esi
    3336:	89 f0                	mov    %esi,%eax
    3338:	83 c0 30             	add    $0x30,%eax
    333b:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    333e:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    3342:	83 ec 0c             	sub    $0xc,%esp
    3345:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3348:	50                   	push   %eax
    3349:	e8 31 05 00 00       	call   387f <unlink>
    nfiles--;
    334e:	83 eb 01             	sub    $0x1,%ebx
  while(nfiles >= 0){
    3351:	83 c4 10             	add    $0x10,%esp
    3354:	83 fb ff             	cmp    $0xffffffff,%ebx
    3357:	0f 85 63 ff ff ff    	jne    32c0 <fsfull+0xeb>
  }

  printf(1, "fsfull test finished\n");
    335d:	83 ec 08             	sub    $0x8,%esp
    3360:	68 4c 4c 00 00       	push   $0x4c4c
    3365:	6a 01                	push   $0x1
    3367:	e8 2d 06 00 00       	call   3999 <printf>
}
    336c:	83 c4 10             	add    $0x10,%esp
    336f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3372:	5b                   	pop    %ebx
    3373:	5e                   	pop    %esi
    3374:	5f                   	pop    %edi
    3375:	5d                   	pop    %ebp
    3376:	c3                   	ret    
    int total = 0;
    3377:	bf 00 00 00 00       	mov    $0x0,%edi
    337c:	eb 02                	jmp    3380 <fsfull+0x1ab>
      total += cc;
    337e:	01 c7                	add    %eax,%edi
      int cc = write(fd, buf, 512);
    3380:	83 ec 04             	sub    $0x4,%esp
    3383:	68 00 02 00 00       	push   $0x200
    3388:	68 00 85 00 00       	push   $0x8500
    338d:	56                   	push   %esi
    338e:	e8 bc 04 00 00       	call   384f <write>
      if(cc < 512)
    3393:	83 c4 10             	add    $0x10,%esp
    3396:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    339b:	7f e1                	jg     337e <fsfull+0x1a9>
    printf(1, "wrote %d bytes\n", total);
    339d:	83 ec 04             	sub    $0x4,%esp
    33a0:	57                   	push   %edi
    33a1:	68 3c 4c 00 00       	push   $0x4c3c
    33a6:	6a 01                	push   $0x1
    33a8:	e8 ec 05 00 00       	call   3999 <printf>
    close(fd);
    33ad:	89 34 24             	mov    %esi,(%esp)
    33b0:	e8 a2 04 00 00       	call   3857 <close>
    if(total == 0)
    33b5:	83 c4 10             	add    $0x10,%esp
    33b8:	85 ff                	test   %edi,%edi
    33ba:	0f 84 f8 fe ff ff    	je     32b8 <fsfull+0xe3>
  for(nfiles = 0; ; nfiles++){
    33c0:	83 c3 01             	add    $0x1,%ebx
    33c3:	e9 2a fe ff ff       	jmp    31f2 <fsfull+0x1d>

000033c8 <uio>:

void
uio()
{
    33c8:	55                   	push   %ebp
    33c9:	89 e5                	mov    %esp,%ebp
    33cb:	83 ec 10             	sub    $0x10,%esp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
    33ce:	68 62 4c 00 00       	push   $0x4c62
    33d3:	6a 01                	push   $0x1
    33d5:	e8 bf 05 00 00       	call   3999 <printf>
  pid = fork();
    33da:	e8 48 04 00 00       	call   3827 <fork>
  if(pid == 0){
    33df:	83 c4 10             	add    $0x10,%esp
    33e2:	85 c0                	test   %eax,%eax
    33e4:	74 1d                	je     3403 <uio+0x3b>
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    printf(1, "uio: uio succeeded; test FAILED\n");
    exit();
  } else if(pid < 0){
    33e6:	85 c0                	test   %eax,%eax
    33e8:	78 3e                	js     3428 <uio+0x60>
    printf (1, "fork failed\n");
    exit();
  }
  wait();
    33ea:	e8 48 04 00 00       	call   3837 <wait>
  printf(1, "uio test done\n");
    33ef:	83 ec 08             	sub    $0x8,%esp
    33f2:	68 6c 4c 00 00       	push   $0x4c6c
    33f7:	6a 01                	push   $0x1
    33f9:	e8 9b 05 00 00       	call   3999 <printf>
}
    33fe:	83 c4 10             	add    $0x10,%esp
    3401:	c9                   	leave  
    3402:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3403:	b8 09 00 00 00       	mov    $0x9,%eax
    3408:	ba 70 00 00 00       	mov    $0x70,%edx
    340d:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    340e:	ba 71 00 00 00       	mov    $0x71,%edx
    3413:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    3414:	83 ec 08             	sub    $0x8,%esp
    3417:	68 f8 53 00 00       	push   $0x53f8
    341c:	6a 01                	push   $0x1
    341e:	e8 76 05 00 00       	call   3999 <printf>
    exit();
    3423:	e8 07 04 00 00       	call   382f <exit>
    printf (1, "fork failed\n");
    3428:	83 ec 08             	sub    $0x8,%esp
    342b:	68 f1 4b 00 00       	push   $0x4bf1
    3430:	6a 01                	push   $0x1
    3432:	e8 62 05 00 00       	call   3999 <printf>
    exit();
    3437:	e8 f3 03 00 00       	call   382f <exit>

0000343c <argptest>:

void argptest()
{
    343c:	55                   	push   %ebp
    343d:	89 e5                	mov    %esp,%ebp
    343f:	53                   	push   %ebx
    3440:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3443:	6a 00                	push   $0x0
    3445:	68 7b 4c 00 00       	push   $0x4c7b
    344a:	e8 20 04 00 00       	call   386f <open>
  if (fd < 0) {
    344f:	83 c4 10             	add    $0x10,%esp
    3452:	85 c0                	test   %eax,%eax
    3454:	78 3a                	js     3490 <argptest+0x54>
    3456:	89 c3                	mov    %eax,%ebx
    printf(2, "open failed\n");
    exit();
  }
  read(fd, sbrk(0) - 1, -1);
    3458:	83 ec 0c             	sub    $0xc,%esp
    345b:	6a 00                	push   $0x0
    345d:	e8 55 04 00 00       	call   38b7 <sbrk>
    3462:	83 c4 0c             	add    $0xc,%esp
    3465:	6a ff                	push   $0xffffffff
    3467:	83 e8 01             	sub    $0x1,%eax
    346a:	50                   	push   %eax
    346b:	53                   	push   %ebx
    346c:	e8 d6 03 00 00       	call   3847 <read>
  close(fd);
    3471:	89 1c 24             	mov    %ebx,(%esp)
    3474:	e8 de 03 00 00       	call   3857 <close>
  printf(1, "arg test passed\n");
    3479:	83 c4 08             	add    $0x8,%esp
    347c:	68 8d 4c 00 00       	push   $0x4c8d
    3481:	6a 01                	push   $0x1
    3483:	e8 11 05 00 00       	call   3999 <printf>
}
    3488:	83 c4 10             	add    $0x10,%esp
    348b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    348e:	c9                   	leave  
    348f:	c3                   	ret    
    printf(2, "open failed\n");
    3490:	83 ec 08             	sub    $0x8,%esp
    3493:	68 80 4c 00 00       	push   $0x4c80
    3498:	6a 02                	push   $0x2
    349a:	e8 fa 04 00 00       	call   3999 <printf>
    exit();
    349f:	e8 8b 03 00 00       	call   382f <exit>

000034a4 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    34a4:	55                   	push   %ebp
    34a5:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    34a7:	69 05 0c 5d 00 00 0d 	imul   $0x19660d,0x5d0c,%eax
    34ae:	66 19 00 
    34b1:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    34b6:	a3 0c 5d 00 00       	mov    %eax,0x5d0c
  return randstate;
}
    34bb:	5d                   	pop    %ebp
    34bc:	c3                   	ret    

000034bd <main>:

int
main(int argc, char *argv[])
{
    34bd:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    34c1:	83 e4 f0             	and    $0xfffffff0,%esp
    34c4:	ff 71 fc             	pushl  -0x4(%ecx)
    34c7:	55                   	push   %ebp
    34c8:	89 e5                	mov    %esp,%ebp
    34ca:	51                   	push   %ecx
    34cb:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
    34ce:	68 9e 4c 00 00       	push   $0x4c9e
    34d3:	6a 01                	push   $0x1
    34d5:	e8 bf 04 00 00       	call   3999 <printf>

  if(open("usertests.ran", 0) >= 0){
    34da:	83 c4 08             	add    $0x8,%esp
    34dd:	6a 00                	push   $0x0
    34df:	68 b2 4c 00 00       	push   $0x4cb2
    34e4:	e8 86 03 00 00       	call   386f <open>
    34e9:	83 c4 10             	add    $0x10,%esp
    34ec:	85 c0                	test   %eax,%eax
    34ee:	78 14                	js     3504 <main+0x47>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    34f0:	83 ec 08             	sub    $0x8,%esp
    34f3:	68 1c 54 00 00       	push   $0x541c
    34f8:	6a 01                	push   $0x1
    34fa:	e8 9a 04 00 00       	call   3999 <printf>
    exit();
    34ff:	e8 2b 03 00 00       	call   382f <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3504:	83 ec 08             	sub    $0x8,%esp
    3507:	68 00 02 00 00       	push   $0x200
    350c:	68 b2 4c 00 00       	push   $0x4cb2
    3511:	e8 59 03 00 00       	call   386f <open>
    3516:	89 04 24             	mov    %eax,(%esp)
    3519:	e8 39 03 00 00       	call   3857 <close>

  argptest();
    351e:	e8 19 ff ff ff       	call   343c <argptest>
  createdelete();
    3523:	e8 f3 da ff ff       	call   101b <createdelete>
  linkunlink();
    3528:	e8 a2 e3 ff ff       	call   18cf <linkunlink>
  concreate();
    352d:	e8 a2 e0 ff ff       	call   15d4 <concreate>
  fourfiles();
    3532:	e8 00 d9 ff ff       	call   e37 <fourfiles>
  sharedfd();
    3537:	e8 68 d7 ff ff       	call   ca4 <sharedfd>

  bigargtest();
    353c:	e8 8f fb ff ff       	call   30d0 <bigargtest>
  bigwrite();
    3541:	e8 ff ec ff ff       	call   2245 <bigwrite>
  bigargtest();
    3546:	e8 85 fb ff ff       	call   30d0 <bigargtest>
  bsstest();
    354b:	e8 16 fb ff ff       	call   3066 <bsstest>
  sbrktest();
    3550:	e8 42 f6 ff ff       	call   2b97 <sbrktest>
  validatetest();
    3555:	e8 60 fa ff ff       	call   2fba <validatetest>

  opentest();
    355a:	e8 51 cd ff ff       	call   2b0 <opentest>
  writetest();
    355f:	e8 df cd ff ff       	call   343 <writetest>
  writetest1();
    3564:	e8 b8 cf ff ff       	call   521 <writetest1>
  createtest();
    3569:	e8 6d d1 ff ff       	call   6db <createtest>

  openiputtest();
    356e:	e8 52 cc ff ff       	call   1c5 <openiputtest>
  exitiputtest();
    3573:	e8 65 cb ff ff       	call   dd <exitiputtest>
  iputtest();
    3578:	e8 83 ca ff ff       	call   0 <iputtest>

  mem();
    357d:	e8 6b d6 ff ff       	call   bed <mem>
  pipe1();
    3582:	e8 1e d3 ff ff       	call   8a5 <pipe1>
  preempt();
    3587:	e8 bb d4 ff ff       	call   a47 <preempt>
  exitwait();
    358c:	e8 ef d5 ff ff       	call   b80 <exitwait>

  rmdot();
    3591:	e8 91 f0 ff ff       	call   2627 <rmdot>
  fourteen();
    3596:	e8 4f ef ff ff       	call   24ea <fourteen>
  bigfile();
    359b:	e8 80 ed ff ff       	call   2320 <bigfile>
  subdir();
    35a0:	e8 72 e5 ff ff       	call   1b17 <subdir>
  linktest();
    35a5:	e8 04 de ff ff       	call   13ae <linktest>
  unlinkread();
    35aa:	e8 66 dc ff ff       	call   1215 <unlinkread>
  dirfile();
    35af:	e8 f8 f1 ff ff       	call   27ac <dirfile>
  iref();
    35b4:	e8 0d f4 ff ff       	call   29c6 <iref>
  forktest();
    35b9:	e8 2a f5 ff ff       	call   2ae8 <forktest>
  bigdir(); // slow
    35be:	e8 fa e3 ff ff       	call   19bd <bigdir>

  uio();
    35c3:	e8 00 fe ff ff       	call   33c8 <uio>

  exectest();
    35c8:	e8 8f d2 ff ff       	call   85c <exectest>

  exit();
    35cd:	e8 5d 02 00 00       	call   382f <exit>

000035d2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    35d2:	55                   	push   %ebp
    35d3:	89 e5                	mov    %esp,%ebp
    35d5:	53                   	push   %ebx
    35d6:	8b 45 08             	mov    0x8(%ebp),%eax
    35d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    35dc:	89 c2                	mov    %eax,%edx
    35de:	83 c1 01             	add    $0x1,%ecx
    35e1:	83 c2 01             	add    $0x1,%edx
    35e4:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    35e8:	88 5a ff             	mov    %bl,-0x1(%edx)
    35eb:	84 db                	test   %bl,%bl
    35ed:	75 ef                	jne    35de <strcpy+0xc>
    ;
  return os;
}
    35ef:	5b                   	pop    %ebx
    35f0:	5d                   	pop    %ebp
    35f1:	c3                   	ret    

000035f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    35f2:	55                   	push   %ebp
    35f3:	89 e5                	mov    %esp,%ebp
    35f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
    35f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    35fb:	0f b6 01             	movzbl (%ecx),%eax
    35fe:	84 c0                	test   %al,%al
    3600:	74 15                	je     3617 <strcmp+0x25>
    3602:	3a 02                	cmp    (%edx),%al
    3604:	75 11                	jne    3617 <strcmp+0x25>
    p++, q++;
    3606:	83 c1 01             	add    $0x1,%ecx
    3609:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    360c:	0f b6 01             	movzbl (%ecx),%eax
    360f:	84 c0                	test   %al,%al
    3611:	74 04                	je     3617 <strcmp+0x25>
    3613:	3a 02                	cmp    (%edx),%al
    3615:	74 ef                	je     3606 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    3617:	0f b6 c0             	movzbl %al,%eax
    361a:	0f b6 12             	movzbl (%edx),%edx
    361d:	29 d0                	sub    %edx,%eax
}
    361f:	5d                   	pop    %ebp
    3620:	c3                   	ret    

00003621 <strlen>:

uint
strlen(char *s)
{
    3621:	55                   	push   %ebp
    3622:	89 e5                	mov    %esp,%ebp
    3624:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    3627:	80 39 00             	cmpb   $0x0,(%ecx)
    362a:	74 12                	je     363e <strlen+0x1d>
    362c:	ba 00 00 00 00       	mov    $0x0,%edx
    3631:	83 c2 01             	add    $0x1,%edx
    3634:	89 d0                	mov    %edx,%eax
    3636:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    363a:	75 f5                	jne    3631 <strlen+0x10>
    ;
  return n;
}
    363c:	5d                   	pop    %ebp
    363d:	c3                   	ret    
  for(n = 0; s[n]; n++)
    363e:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    3643:	eb f7                	jmp    363c <strlen+0x1b>

00003645 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3645:	55                   	push   %ebp
    3646:	89 e5                	mov    %esp,%ebp
    3648:	57                   	push   %edi
    3649:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    364c:	89 d7                	mov    %edx,%edi
    364e:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3651:	8b 45 0c             	mov    0xc(%ebp),%eax
    3654:	fc                   	cld    
    3655:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3657:	89 d0                	mov    %edx,%eax
    3659:	5f                   	pop    %edi
    365a:	5d                   	pop    %ebp
    365b:	c3                   	ret    

0000365c <strchr>:

char*
strchr(const char *s, char c)
{
    365c:	55                   	push   %ebp
    365d:	89 e5                	mov    %esp,%ebp
    365f:	53                   	push   %ebx
    3660:	8b 45 08             	mov    0x8(%ebp),%eax
    3663:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    3666:	0f b6 10             	movzbl (%eax),%edx
    3669:	84 d2                	test   %dl,%dl
    366b:	74 1e                	je     368b <strchr+0x2f>
    366d:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    366f:	38 d3                	cmp    %dl,%bl
    3671:	74 15                	je     3688 <strchr+0x2c>
  for(; *s; s++)
    3673:	83 c0 01             	add    $0x1,%eax
    3676:	0f b6 10             	movzbl (%eax),%edx
    3679:	84 d2                	test   %dl,%dl
    367b:	74 06                	je     3683 <strchr+0x27>
    if(*s == c)
    367d:	38 ca                	cmp    %cl,%dl
    367f:	75 f2                	jne    3673 <strchr+0x17>
    3681:	eb 05                	jmp    3688 <strchr+0x2c>
      return (char*)s;
  return 0;
    3683:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3688:	5b                   	pop    %ebx
    3689:	5d                   	pop    %ebp
    368a:	c3                   	ret    
  return 0;
    368b:	b8 00 00 00 00       	mov    $0x0,%eax
    3690:	eb f6                	jmp    3688 <strchr+0x2c>

00003692 <gets>:

char*
gets(char *buf, int max)
{
    3692:	55                   	push   %ebp
    3693:	89 e5                	mov    %esp,%ebp
    3695:	57                   	push   %edi
    3696:	56                   	push   %esi
    3697:	53                   	push   %ebx
    3698:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    369b:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    36a0:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    36a3:	8d 5e 01             	lea    0x1(%esi),%ebx
    36a6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    36a9:	7d 2b                	jge    36d6 <gets+0x44>
    cc = read(0, &c, 1);
    36ab:	83 ec 04             	sub    $0x4,%esp
    36ae:	6a 01                	push   $0x1
    36b0:	57                   	push   %edi
    36b1:	6a 00                	push   $0x0
    36b3:	e8 8f 01 00 00       	call   3847 <read>
    if(cc < 1)
    36b8:	83 c4 10             	add    $0x10,%esp
    36bb:	85 c0                	test   %eax,%eax
    36bd:	7e 17                	jle    36d6 <gets+0x44>
      break;
    buf[i++] = c;
    36bf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    36c3:	8b 55 08             	mov    0x8(%ebp),%edx
    36c6:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    36ca:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    36cc:	3c 0a                	cmp    $0xa,%al
    36ce:	74 04                	je     36d4 <gets+0x42>
    36d0:	3c 0d                	cmp    $0xd,%al
    36d2:	75 cf                	jne    36a3 <gets+0x11>
  for(i=0; i+1 < max; ){
    36d4:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    36d6:	8b 45 08             	mov    0x8(%ebp),%eax
    36d9:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    36dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    36e0:	5b                   	pop    %ebx
    36e1:	5e                   	pop    %esi
    36e2:	5f                   	pop    %edi
    36e3:	5d                   	pop    %ebp
    36e4:	c3                   	ret    

000036e5 <stat>:

int
stat(char *n, struct stat *st)
{
    36e5:	55                   	push   %ebp
    36e6:	89 e5                	mov    %esp,%ebp
    36e8:	56                   	push   %esi
    36e9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    36ea:	83 ec 08             	sub    $0x8,%esp
    36ed:	6a 00                	push   $0x0
    36ef:	ff 75 08             	pushl  0x8(%ebp)
    36f2:	e8 78 01 00 00       	call   386f <open>
  if(fd < 0)
    36f7:	83 c4 10             	add    $0x10,%esp
    36fa:	85 c0                	test   %eax,%eax
    36fc:	78 24                	js     3722 <stat+0x3d>
    36fe:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    3700:	83 ec 08             	sub    $0x8,%esp
    3703:	ff 75 0c             	pushl  0xc(%ebp)
    3706:	50                   	push   %eax
    3707:	e8 7b 01 00 00       	call   3887 <fstat>
    370c:	89 c6                	mov    %eax,%esi
  close(fd);
    370e:	89 1c 24             	mov    %ebx,(%esp)
    3711:	e8 41 01 00 00       	call   3857 <close>
  return r;
    3716:	83 c4 10             	add    $0x10,%esp
}
    3719:	89 f0                	mov    %esi,%eax
    371b:	8d 65 f8             	lea    -0x8(%ebp),%esp
    371e:	5b                   	pop    %ebx
    371f:	5e                   	pop    %esi
    3720:	5d                   	pop    %ebp
    3721:	c3                   	ret    
    return -1;
    3722:	be ff ff ff ff       	mov    $0xffffffff,%esi
    3727:	eb f0                	jmp    3719 <stat+0x34>

00003729 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
    3729:	55                   	push   %ebp
    372a:	89 e5                	mov    %esp,%ebp
    372c:	56                   	push   %esi
    372d:	53                   	push   %ebx
    372e:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
    3731:	0f b6 0a             	movzbl (%edx),%ecx
    3734:	80 f9 20             	cmp    $0x20,%cl
    3737:	75 0b                	jne    3744 <atoi+0x1b>
    3739:	83 c2 01             	add    $0x1,%edx
    373c:	0f b6 0a             	movzbl (%edx),%ecx
    373f:	80 f9 20             	cmp    $0x20,%cl
    3742:	74 f5                	je     3739 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
    3744:	80 f9 2d             	cmp    $0x2d,%cl
    3747:	74 3b                	je     3784 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
    3749:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
    374c:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
    3751:	f6 c1 fd             	test   $0xfd,%cl
    3754:	74 33                	je     3789 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
    3756:	0f b6 0a             	movzbl (%edx),%ecx
    3759:	8d 41 d0             	lea    -0x30(%ecx),%eax
    375c:	3c 09                	cmp    $0x9,%al
    375e:	77 2e                	ja     378e <atoi+0x65>
    3760:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    3765:	83 c2 01             	add    $0x1,%edx
    3768:	8d 04 80             	lea    (%eax,%eax,4),%eax
    376b:	0f be c9             	movsbl %cl,%ecx
    376e:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    3772:	0f b6 0a             	movzbl (%edx),%ecx
    3775:	8d 59 d0             	lea    -0x30(%ecx),%ebx
    3778:	80 fb 09             	cmp    $0x9,%bl
    377b:	76 e8                	jbe    3765 <atoi+0x3c>
  return sign*n;
    377d:	0f af c6             	imul   %esi,%eax
}
    3780:	5b                   	pop    %ebx
    3781:	5e                   	pop    %esi
    3782:	5d                   	pop    %ebp
    3783:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
    3784:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
    3789:	83 c2 01             	add    $0x1,%edx
    378c:	eb c8                	jmp    3756 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
    378e:	b8 00 00 00 00       	mov    $0x0,%eax
    3793:	eb e8                	jmp    377d <atoi+0x54>

00003795 <atoo>:

int
atoo(const char *s)
{
    3795:	55                   	push   %ebp
    3796:	89 e5                	mov    %esp,%ebp
    3798:	56                   	push   %esi
    3799:	53                   	push   %ebx
    379a:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
    379d:	0f b6 0a             	movzbl (%edx),%ecx
    37a0:	80 f9 20             	cmp    $0x20,%cl
    37a3:	75 0b                	jne    37b0 <atoo+0x1b>
    37a5:	83 c2 01             	add    $0x1,%edx
    37a8:	0f b6 0a             	movzbl (%edx),%ecx
    37ab:	80 f9 20             	cmp    $0x20,%cl
    37ae:	74 f5                	je     37a5 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
    37b0:	80 f9 2d             	cmp    $0x2d,%cl
    37b3:	74 38                	je     37ed <atoo+0x58>
  if (*s == '+'  || *s == '-')
    37b5:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
    37b8:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
    37bd:	f6 c1 fd             	test   $0xfd,%cl
    37c0:	74 30                	je     37f2 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
    37c2:	0f b6 0a             	movzbl (%edx),%ecx
    37c5:	8d 41 d0             	lea    -0x30(%ecx),%eax
    37c8:	3c 07                	cmp    $0x7,%al
    37ca:	77 2b                	ja     37f7 <atoo+0x62>
    37cc:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
    37d1:	83 c2 01             	add    $0x1,%edx
    37d4:	0f be c9             	movsbl %cl,%ecx
    37d7:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
    37db:	0f b6 0a             	movzbl (%edx),%ecx
    37de:	8d 59 d0             	lea    -0x30(%ecx),%ebx
    37e1:	80 fb 07             	cmp    $0x7,%bl
    37e4:	76 eb                	jbe    37d1 <atoo+0x3c>
  return sign*n;
    37e6:	0f af c6             	imul   %esi,%eax
}
    37e9:	5b                   	pop    %ebx
    37ea:	5e                   	pop    %esi
    37eb:	5d                   	pop    %ebp
    37ec:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
    37ed:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
    37f2:	83 c2 01             	add    $0x1,%edx
    37f5:	eb cb                	jmp    37c2 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
    37f7:	b8 00 00 00 00       	mov    $0x0,%eax
    37fc:	eb e8                	jmp    37e6 <atoo+0x51>

000037fe <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
    37fe:	55                   	push   %ebp
    37ff:	89 e5                	mov    %esp,%ebp
    3801:	56                   	push   %esi
    3802:	53                   	push   %ebx
    3803:	8b 45 08             	mov    0x8(%ebp),%eax
    3806:	8b 75 0c             	mov    0xc(%ebp),%esi
    3809:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    380c:	85 db                	test   %ebx,%ebx
    380e:	7e 13                	jle    3823 <memmove+0x25>
    3810:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    3815:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    3819:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    381c:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    381f:	39 d3                	cmp    %edx,%ebx
    3821:	75 f2                	jne    3815 <memmove+0x17>
  return vdst;
}
    3823:	5b                   	pop    %ebx
    3824:	5e                   	pop    %esi
    3825:	5d                   	pop    %ebp
    3826:	c3                   	ret    

00003827 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3827:	b8 01 00 00 00       	mov    $0x1,%eax
    382c:	cd 40                	int    $0x40
    382e:	c3                   	ret    

0000382f <exit>:
SYSCALL(exit)
    382f:	b8 02 00 00 00       	mov    $0x2,%eax
    3834:	cd 40                	int    $0x40
    3836:	c3                   	ret    

00003837 <wait>:
SYSCALL(wait)
    3837:	b8 03 00 00 00       	mov    $0x3,%eax
    383c:	cd 40                	int    $0x40
    383e:	c3                   	ret    

0000383f <pipe>:
SYSCALL(pipe)
    383f:	b8 04 00 00 00       	mov    $0x4,%eax
    3844:	cd 40                	int    $0x40
    3846:	c3                   	ret    

00003847 <read>:
SYSCALL(read)
    3847:	b8 05 00 00 00       	mov    $0x5,%eax
    384c:	cd 40                	int    $0x40
    384e:	c3                   	ret    

0000384f <write>:
SYSCALL(write)
    384f:	b8 10 00 00 00       	mov    $0x10,%eax
    3854:	cd 40                	int    $0x40
    3856:	c3                   	ret    

00003857 <close>:
SYSCALL(close)
    3857:	b8 15 00 00 00       	mov    $0x15,%eax
    385c:	cd 40                	int    $0x40
    385e:	c3                   	ret    

0000385f <kill>:
SYSCALL(kill)
    385f:	b8 06 00 00 00       	mov    $0x6,%eax
    3864:	cd 40                	int    $0x40
    3866:	c3                   	ret    

00003867 <exec>:
SYSCALL(exec)
    3867:	b8 07 00 00 00       	mov    $0x7,%eax
    386c:	cd 40                	int    $0x40
    386e:	c3                   	ret    

0000386f <open>:
SYSCALL(open)
    386f:	b8 0f 00 00 00       	mov    $0xf,%eax
    3874:	cd 40                	int    $0x40
    3876:	c3                   	ret    

00003877 <mknod>:
SYSCALL(mknod)
    3877:	b8 11 00 00 00       	mov    $0x11,%eax
    387c:	cd 40                	int    $0x40
    387e:	c3                   	ret    

0000387f <unlink>:
SYSCALL(unlink)
    387f:	b8 12 00 00 00       	mov    $0x12,%eax
    3884:	cd 40                	int    $0x40
    3886:	c3                   	ret    

00003887 <fstat>:
SYSCALL(fstat)
    3887:	b8 08 00 00 00       	mov    $0x8,%eax
    388c:	cd 40                	int    $0x40
    388e:	c3                   	ret    

0000388f <link>:
SYSCALL(link)
    388f:	b8 13 00 00 00       	mov    $0x13,%eax
    3894:	cd 40                	int    $0x40
    3896:	c3                   	ret    

00003897 <mkdir>:
SYSCALL(mkdir)
    3897:	b8 14 00 00 00       	mov    $0x14,%eax
    389c:	cd 40                	int    $0x40
    389e:	c3                   	ret    

0000389f <chdir>:
SYSCALL(chdir)
    389f:	b8 09 00 00 00       	mov    $0x9,%eax
    38a4:	cd 40                	int    $0x40
    38a6:	c3                   	ret    

000038a7 <dup>:
SYSCALL(dup)
    38a7:	b8 0a 00 00 00       	mov    $0xa,%eax
    38ac:	cd 40                	int    $0x40
    38ae:	c3                   	ret    

000038af <getpid>:
SYSCALL(getpid)
    38af:	b8 0b 00 00 00       	mov    $0xb,%eax
    38b4:	cd 40                	int    $0x40
    38b6:	c3                   	ret    

000038b7 <sbrk>:
SYSCALL(sbrk)
    38b7:	b8 0c 00 00 00       	mov    $0xc,%eax
    38bc:	cd 40                	int    $0x40
    38be:	c3                   	ret    

000038bf <sleep>:
SYSCALL(sleep)
    38bf:	b8 0d 00 00 00       	mov    $0xd,%eax
    38c4:	cd 40                	int    $0x40
    38c6:	c3                   	ret    

000038c7 <uptime>:
SYSCALL(uptime)
    38c7:	b8 0e 00 00 00       	mov    $0xe,%eax
    38cc:	cd 40                	int    $0x40
    38ce:	c3                   	ret    

000038cf <halt>:
SYSCALL(halt)
    38cf:	b8 16 00 00 00       	mov    $0x16,%eax
    38d4:	cd 40                	int    $0x40
    38d6:	c3                   	ret    

000038d7 <date>:
//proj1
SYSCALL(date)
    38d7:	b8 17 00 00 00       	mov    $0x17,%eax
    38dc:	cd 40                	int    $0x40
    38de:	c3                   	ret    

000038df <getuid>:
//proj2
SYSCALL(getuid)
    38df:	b8 18 00 00 00       	mov    $0x18,%eax
    38e4:	cd 40                	int    $0x40
    38e6:	c3                   	ret    

000038e7 <getgid>:
SYSCALL(getgid)
    38e7:	b8 19 00 00 00       	mov    $0x19,%eax
    38ec:	cd 40                	int    $0x40
    38ee:	c3                   	ret    

000038ef <getppid>:
SYSCALL(getppid)
    38ef:	b8 1a 00 00 00       	mov    $0x1a,%eax
    38f4:	cd 40                	int    $0x40
    38f6:	c3                   	ret    

000038f7 <setuid>:
SYSCALL(setuid)
    38f7:	b8 1b 00 00 00       	mov    $0x1b,%eax
    38fc:	cd 40                	int    $0x40
    38fe:	c3                   	ret    

000038ff <setgid>:
SYSCALL(setgid)
    38ff:	b8 1c 00 00 00       	mov    $0x1c,%eax
    3904:	cd 40                	int    $0x40
    3906:	c3                   	ret    

00003907 <getprocs>:
SYSCALL(getprocs)
    3907:	b8 1d 00 00 00       	mov    $0x1d,%eax
    390c:	cd 40                	int    $0x40
    390e:	c3                   	ret    

0000390f <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    390f:	55                   	push   %ebp
    3910:	89 e5                	mov    %esp,%ebp
    3912:	57                   	push   %edi
    3913:	56                   	push   %esi
    3914:	53                   	push   %ebx
    3915:	83 ec 3c             	sub    $0x3c,%esp
    3918:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    391a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    391e:	74 14                	je     3934 <printint+0x25>
    3920:	85 d2                	test   %edx,%edx
    3922:	79 10                	jns    3934 <printint+0x25>
    neg = 1;
    x = -xx;
    3924:	f7 da                	neg    %edx
    neg = 1;
    3926:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    392d:	bf 00 00 00 00       	mov    $0x0,%edi
    3932:	eb 0b                	jmp    393f <printint+0x30>
  neg = 0;
    3934:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    393b:	eb f0                	jmp    392d <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    393d:	89 df                	mov    %ebx,%edi
    393f:	8d 5f 01             	lea    0x1(%edi),%ebx
    3942:	89 d0                	mov    %edx,%eax
    3944:	ba 00 00 00 00       	mov    $0x0,%edx
    3949:	f7 f1                	div    %ecx
    394b:	0f b6 92 50 54 00 00 	movzbl 0x5450(%edx),%edx
    3952:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    3956:	89 c2                	mov    %eax,%edx
    3958:	85 c0                	test   %eax,%eax
    395a:	75 e1                	jne    393d <printint+0x2e>
  if(neg)
    395c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    3960:	74 08                	je     396a <printint+0x5b>
    buf[i++] = '-';
    3962:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    3967:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    396a:	83 eb 01             	sub    $0x1,%ebx
    396d:	78 22                	js     3991 <printint+0x82>
  write(fd, &c, 1);
    396f:	8d 7d d7             	lea    -0x29(%ebp),%edi
    3972:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    3977:	88 45 d7             	mov    %al,-0x29(%ebp)
    397a:	83 ec 04             	sub    $0x4,%esp
    397d:	6a 01                	push   $0x1
    397f:	57                   	push   %edi
    3980:	56                   	push   %esi
    3981:	e8 c9 fe ff ff       	call   384f <write>
  while(--i >= 0)
    3986:	83 eb 01             	sub    $0x1,%ebx
    3989:	83 c4 10             	add    $0x10,%esp
    398c:	83 fb ff             	cmp    $0xffffffff,%ebx
    398f:	75 e1                	jne    3972 <printint+0x63>
    putc(fd, buf[i]);
}
    3991:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3994:	5b                   	pop    %ebx
    3995:	5e                   	pop    %esi
    3996:	5f                   	pop    %edi
    3997:	5d                   	pop    %ebp
    3998:	c3                   	ret    

00003999 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    3999:	55                   	push   %ebp
    399a:	89 e5                	mov    %esp,%ebp
    399c:	57                   	push   %edi
    399d:	56                   	push   %esi
    399e:	53                   	push   %ebx
    399f:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    39a2:	8b 75 0c             	mov    0xc(%ebp),%esi
    39a5:	0f b6 1e             	movzbl (%esi),%ebx
    39a8:	84 db                	test   %bl,%bl
    39aa:	0f 84 b1 01 00 00    	je     3b61 <printf+0x1c8>
    39b0:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    39b3:	8d 45 10             	lea    0x10(%ebp),%eax
    39b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    39b9:	bf 00 00 00 00       	mov    $0x0,%edi
    39be:	eb 2d                	jmp    39ed <printf+0x54>
    39c0:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    39c3:	83 ec 04             	sub    $0x4,%esp
    39c6:	6a 01                	push   $0x1
    39c8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    39cb:	50                   	push   %eax
    39cc:	ff 75 08             	pushl  0x8(%ebp)
    39cf:	e8 7b fe ff ff       	call   384f <write>
    39d4:	83 c4 10             	add    $0x10,%esp
    39d7:	eb 05                	jmp    39de <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    39d9:	83 ff 25             	cmp    $0x25,%edi
    39dc:	74 22                	je     3a00 <printf+0x67>
    39de:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    39e1:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    39e5:	84 db                	test   %bl,%bl
    39e7:	0f 84 74 01 00 00    	je     3b61 <printf+0x1c8>
    c = fmt[i] & 0xff;
    39ed:	0f be d3             	movsbl %bl,%edx
    39f0:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    39f3:	85 ff                	test   %edi,%edi
    39f5:	75 e2                	jne    39d9 <printf+0x40>
      if(c == '%'){
    39f7:	83 f8 25             	cmp    $0x25,%eax
    39fa:	75 c4                	jne    39c0 <printf+0x27>
        state = '%';
    39fc:	89 c7                	mov    %eax,%edi
    39fe:	eb de                	jmp    39de <printf+0x45>
      if(c == 'd'){
    3a00:	83 f8 64             	cmp    $0x64,%eax
    3a03:	74 59                	je     3a5e <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3a05:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    3a0b:	83 fa 70             	cmp    $0x70,%edx
    3a0e:	74 7a                	je     3a8a <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3a10:	83 f8 73             	cmp    $0x73,%eax
    3a13:	0f 84 9d 00 00 00    	je     3ab6 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3a19:	83 f8 63             	cmp    $0x63,%eax
    3a1c:	0f 84 f2 00 00 00    	je     3b14 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3a22:	83 f8 25             	cmp    $0x25,%eax
    3a25:	0f 84 15 01 00 00    	je     3b40 <printf+0x1a7>
    3a2b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    3a2f:	83 ec 04             	sub    $0x4,%esp
    3a32:	6a 01                	push   $0x1
    3a34:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3a37:	50                   	push   %eax
    3a38:	ff 75 08             	pushl  0x8(%ebp)
    3a3b:	e8 0f fe ff ff       	call   384f <write>
    3a40:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    3a43:	83 c4 0c             	add    $0xc,%esp
    3a46:	6a 01                	push   $0x1
    3a48:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    3a4b:	50                   	push   %eax
    3a4c:	ff 75 08             	pushl  0x8(%ebp)
    3a4f:	e8 fb fd ff ff       	call   384f <write>
    3a54:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    3a57:	bf 00 00 00 00       	mov    $0x0,%edi
    3a5c:	eb 80                	jmp    39de <printf+0x45>
        printint(fd, *ap, 10, 1);
    3a5e:	83 ec 0c             	sub    $0xc,%esp
    3a61:	6a 01                	push   $0x1
    3a63:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3a68:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3a6b:	8b 17                	mov    (%edi),%edx
    3a6d:	8b 45 08             	mov    0x8(%ebp),%eax
    3a70:	e8 9a fe ff ff       	call   390f <printint>
        ap++;
    3a75:	89 f8                	mov    %edi,%eax
    3a77:	83 c0 04             	add    $0x4,%eax
    3a7a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3a7d:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3a80:	bf 00 00 00 00       	mov    $0x0,%edi
    3a85:	e9 54 ff ff ff       	jmp    39de <printf+0x45>
        printint(fd, *ap, 16, 0);
    3a8a:	83 ec 0c             	sub    $0xc,%esp
    3a8d:	6a 00                	push   $0x0
    3a8f:	b9 10 00 00 00       	mov    $0x10,%ecx
    3a94:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3a97:	8b 17                	mov    (%edi),%edx
    3a99:	8b 45 08             	mov    0x8(%ebp),%eax
    3a9c:	e8 6e fe ff ff       	call   390f <printint>
        ap++;
    3aa1:	89 f8                	mov    %edi,%eax
    3aa3:	83 c0 04             	add    $0x4,%eax
    3aa6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3aa9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3aac:	bf 00 00 00 00       	mov    $0x0,%edi
    3ab1:	e9 28 ff ff ff       	jmp    39de <printf+0x45>
        s = (char*)*ap;
    3ab6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    3ab9:	8b 01                	mov    (%ecx),%eax
        ap++;
    3abb:	83 c1 04             	add    $0x4,%ecx
    3abe:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    3ac1:	85 c0                	test   %eax,%eax
    3ac3:	74 13                	je     3ad8 <printf+0x13f>
        s = (char*)*ap;
    3ac5:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    3ac7:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    3aca:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    3acf:	84 c0                	test   %al,%al
    3ad1:	75 0f                	jne    3ae2 <printf+0x149>
    3ad3:	e9 06 ff ff ff       	jmp    39de <printf+0x45>
          s = "(null)";
    3ad8:	bb 48 54 00 00       	mov    $0x5448,%ebx
        while(*s != 0){
    3add:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    3ae2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    3ae5:	89 75 d0             	mov    %esi,-0x30(%ebp)
    3ae8:	8b 75 08             	mov    0x8(%ebp),%esi
    3aeb:	88 45 e3             	mov    %al,-0x1d(%ebp)
    3aee:	83 ec 04             	sub    $0x4,%esp
    3af1:	6a 01                	push   $0x1
    3af3:	57                   	push   %edi
    3af4:	56                   	push   %esi
    3af5:	e8 55 fd ff ff       	call   384f <write>
          s++;
    3afa:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    3afd:	0f b6 03             	movzbl (%ebx),%eax
    3b00:	83 c4 10             	add    $0x10,%esp
    3b03:	84 c0                	test   %al,%al
    3b05:	75 e4                	jne    3aeb <printf+0x152>
    3b07:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    3b0a:	bf 00 00 00 00       	mov    $0x0,%edi
    3b0f:	e9 ca fe ff ff       	jmp    39de <printf+0x45>
        putc(fd, *ap);
    3b14:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3b17:	8b 07                	mov    (%edi),%eax
    3b19:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    3b1c:	83 ec 04             	sub    $0x4,%esp
    3b1f:	6a 01                	push   $0x1
    3b21:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    3b24:	50                   	push   %eax
    3b25:	ff 75 08             	pushl  0x8(%ebp)
    3b28:	e8 22 fd ff ff       	call   384f <write>
        ap++;
    3b2d:	83 c7 04             	add    $0x4,%edi
    3b30:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    3b33:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3b36:	bf 00 00 00 00       	mov    $0x0,%edi
    3b3b:	e9 9e fe ff ff       	jmp    39de <printf+0x45>
    3b40:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    3b43:	83 ec 04             	sub    $0x4,%esp
    3b46:	6a 01                	push   $0x1
    3b48:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    3b4b:	50                   	push   %eax
    3b4c:	ff 75 08             	pushl  0x8(%ebp)
    3b4f:	e8 fb fc ff ff       	call   384f <write>
    3b54:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3b57:	bf 00 00 00 00       	mov    $0x0,%edi
    3b5c:	e9 7d fe ff ff       	jmp    39de <printf+0x45>
    }
  }
}
    3b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3b64:	5b                   	pop    %ebx
    3b65:	5e                   	pop    %esi
    3b66:	5f                   	pop    %edi
    3b67:	5d                   	pop    %ebp
    3b68:	c3                   	ret    

00003b69 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3b69:	55                   	push   %ebp
    3b6a:	89 e5                	mov    %esp,%ebp
    3b6c:	57                   	push   %edi
    3b6d:	56                   	push   %esi
    3b6e:	53                   	push   %ebx
    3b6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3b72:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3b75:	a1 c0 5d 00 00       	mov    0x5dc0,%eax
    3b7a:	eb 0c                	jmp    3b88 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3b7c:	8b 10                	mov    (%eax),%edx
    3b7e:	39 c2                	cmp    %eax,%edx
    3b80:	77 04                	ja     3b86 <free+0x1d>
    3b82:	39 ca                	cmp    %ecx,%edx
    3b84:	77 10                	ja     3b96 <free+0x2d>
{
    3b86:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3b88:	39 c8                	cmp    %ecx,%eax
    3b8a:	73 f0                	jae    3b7c <free+0x13>
    3b8c:	8b 10                	mov    (%eax),%edx
    3b8e:	39 ca                	cmp    %ecx,%edx
    3b90:	77 04                	ja     3b96 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3b92:	39 c2                	cmp    %eax,%edx
    3b94:	77 f0                	ja     3b86 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3b96:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3b99:	8b 10                	mov    (%eax),%edx
    3b9b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3b9e:	39 fa                	cmp    %edi,%edx
    3ba0:	74 19                	je     3bbb <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3ba2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3ba5:	8b 50 04             	mov    0x4(%eax),%edx
    3ba8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3bab:	39 f1                	cmp    %esi,%ecx
    3bad:	74 1b                	je     3bca <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3baf:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3bb1:	a3 c0 5d 00 00       	mov    %eax,0x5dc0
}
    3bb6:	5b                   	pop    %ebx
    3bb7:	5e                   	pop    %esi
    3bb8:	5f                   	pop    %edi
    3bb9:	5d                   	pop    %ebp
    3bba:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    3bbb:	03 72 04             	add    0x4(%edx),%esi
    3bbe:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3bc1:	8b 10                	mov    (%eax),%edx
    3bc3:	8b 12                	mov    (%edx),%edx
    3bc5:	89 53 f8             	mov    %edx,-0x8(%ebx)
    3bc8:	eb db                	jmp    3ba5 <free+0x3c>
    p->s.size += bp->s.size;
    3bca:	03 53 fc             	add    -0x4(%ebx),%edx
    3bcd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3bd0:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3bd3:	89 10                	mov    %edx,(%eax)
    3bd5:	eb da                	jmp    3bb1 <free+0x48>

00003bd7 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3bd7:	55                   	push   %ebp
    3bd8:	89 e5                	mov    %esp,%ebp
    3bda:	57                   	push   %edi
    3bdb:	56                   	push   %esi
    3bdc:	53                   	push   %ebx
    3bdd:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3be0:	8b 45 08             	mov    0x8(%ebp),%eax
    3be3:	8d 58 07             	lea    0x7(%eax),%ebx
    3be6:	c1 eb 03             	shr    $0x3,%ebx
    3be9:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    3bec:	8b 15 c0 5d 00 00    	mov    0x5dc0,%edx
    3bf2:	85 d2                	test   %edx,%edx
    3bf4:	74 20                	je     3c16 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3bf6:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3bf8:	8b 48 04             	mov    0x4(%eax),%ecx
    3bfb:	39 cb                	cmp    %ecx,%ebx
    3bfd:	76 3c                	jbe    3c3b <malloc+0x64>
    3bff:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    3c05:	be 00 10 00 00       	mov    $0x1000,%esi
    3c0a:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    3c0d:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    3c14:	eb 70                	jmp    3c86 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    3c16:	c7 05 c0 5d 00 00 c4 	movl   $0x5dc4,0x5dc0
    3c1d:	5d 00 00 
    3c20:	c7 05 c4 5d 00 00 c4 	movl   $0x5dc4,0x5dc4
    3c27:	5d 00 00 
    base.s.size = 0;
    3c2a:	c7 05 c8 5d 00 00 00 	movl   $0x0,0x5dc8
    3c31:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    3c34:	ba c4 5d 00 00       	mov    $0x5dc4,%edx
    3c39:	eb bb                	jmp    3bf6 <malloc+0x1f>
      if(p->s.size == nunits)
    3c3b:	39 cb                	cmp    %ecx,%ebx
    3c3d:	74 1c                	je     3c5b <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    3c3f:	29 d9                	sub    %ebx,%ecx
    3c41:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    3c44:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    3c47:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    3c4a:	89 15 c0 5d 00 00    	mov    %edx,0x5dc0
      return (void*)(p + 1);
    3c50:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    3c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3c56:	5b                   	pop    %ebx
    3c57:	5e                   	pop    %esi
    3c58:	5f                   	pop    %edi
    3c59:	5d                   	pop    %ebp
    3c5a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    3c5b:	8b 08                	mov    (%eax),%ecx
    3c5d:	89 0a                	mov    %ecx,(%edx)
    3c5f:	eb e9                	jmp    3c4a <malloc+0x73>
  hp->s.size = nu;
    3c61:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    3c64:	83 ec 0c             	sub    $0xc,%esp
    3c67:	83 c0 08             	add    $0x8,%eax
    3c6a:	50                   	push   %eax
    3c6b:	e8 f9 fe ff ff       	call   3b69 <free>
  return freep;
    3c70:	8b 15 c0 5d 00 00    	mov    0x5dc0,%edx
      if((p = morecore(nunits)) == 0)
    3c76:	83 c4 10             	add    $0x10,%esp
    3c79:	85 d2                	test   %edx,%edx
    3c7b:	74 2b                	je     3ca8 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3c7d:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3c7f:	8b 48 04             	mov    0x4(%eax),%ecx
    3c82:	39 d9                	cmp    %ebx,%ecx
    3c84:	73 b5                	jae    3c3b <malloc+0x64>
    3c86:	89 c2                	mov    %eax,%edx
    if(p == freep)
    3c88:	39 05 c0 5d 00 00    	cmp    %eax,0x5dc0
    3c8e:	75 ed                	jne    3c7d <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    3c90:	83 ec 0c             	sub    $0xc,%esp
    3c93:	57                   	push   %edi
    3c94:	e8 1e fc ff ff       	call   38b7 <sbrk>
  if(p == (char*)-1)
    3c99:	83 c4 10             	add    $0x10,%esp
    3c9c:	83 f8 ff             	cmp    $0xffffffff,%eax
    3c9f:	75 c0                	jne    3c61 <malloc+0x8a>
        return 0;
    3ca1:	b8 00 00 00 00       	mov    $0x0,%eax
    3ca6:	eb ab                	jmp    3c53 <malloc+0x7c>
    3ca8:	b8 00 00 00 00       	mov    $0x0,%eax
    3cad:	eb a4                	jmp    3c53 <malloc+0x7c>
