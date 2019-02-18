
_testuidgid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "Done!\n");
  return 0;
}

int
main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  uint uid = getuid();
   f:	e8 f9 05 00 00       	call   60d <getuid>
  printf(1, "Current UID is: %d\n", uid);
  14:	83 ec 04             	sub    $0x4,%esp
  17:	50                   	push   %eax
  18:	68 e0 09 00 00       	push   $0x9e0
  1d:	6a 01                	push   $0x1
  1f:	e8 a3 06 00 00       	call   6c7 <printf>
  printf(1, "Setting UID to %d\n", nval);
  24:	83 c4 0c             	add    $0xc,%esp
  27:	6a 64                	push   $0x64
  29:	68 f4 09 00 00       	push   $0x9f4
  2e:	6a 01                	push   $0x1
  30:	e8 92 06 00 00       	call   6c7 <printf>
  if (setuid(nval) < 0)
  35:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  3c:	e8 e4 05 00 00       	call   625 <setuid>
  41:	83 c4 10             	add    $0x10,%esp
  44:	85 c0                	test   %eax,%eax
  46:	0f 88 dd 01 00 00    	js     229 <main+0x229>
  uid = getuid();
  4c:	e8 bc 05 00 00       	call   60d <getuid>
  printf(1, "Current UID is: %d\n", uid);
  51:	83 ec 04             	sub    $0x4,%esp
  54:	50                   	push   %eax
  55:	68 e0 09 00 00       	push   $0x9e0
  5a:	6a 01                	push   $0x1
  5c:	e8 66 06 00 00       	call   6c7 <printf>
  sleep(5 * TPS);  // now type control-p
  61:	c7 04 24 88 13 00 00 	movl   $0x1388,(%esp)
  68:	e8 80 05 00 00       	call   5ed <sleep>
  uint gid = getgid();
  6d:	e8 a3 05 00 00       	call   615 <getgid>
  printf(1, "Current GID is: %d\n", gid);
  72:	83 c4 0c             	add    $0xc,%esp
  75:	50                   	push   %eax
  76:	68 1f 0a 00 00       	push   $0xa1f
  7b:	6a 01                	push   $0x1
  7d:	e8 45 06 00 00       	call   6c7 <printf>
  printf(1, "Setting GID to %d\n", nval);
  82:	83 c4 0c             	add    $0xc,%esp
  85:	68 c8 00 00 00       	push   $0xc8
  8a:	68 33 0a 00 00       	push   $0xa33
  8f:	6a 01                	push   $0x1
  91:	e8 31 06 00 00       	call   6c7 <printf>
  if (setgid(nval) < 0)
  96:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
  9d:	e8 8b 05 00 00       	call   62d <setgid>
  a2:	83 c4 10             	add    $0x10,%esp
  a5:	85 c0                	test   %eax,%eax
  a7:	0f 88 95 01 00 00    	js     242 <main+0x242>
  setgid(nval);
  ad:	83 ec 0c             	sub    $0xc,%esp
  b0:	68 c8 00 00 00       	push   $0xc8
  b5:	e8 73 05 00 00       	call   62d <setgid>
  gid = getgid();
  ba:	e8 56 05 00 00       	call   615 <getgid>
  printf(1, "Current GID is: %d\n", gid);
  bf:	83 c4 0c             	add    $0xc,%esp
  c2:	50                   	push   %eax
  c3:	68 1f 0a 00 00       	push   $0xa1f
  c8:	6a 01                	push   $0x1
  ca:	e8 f8 05 00 00       	call   6c7 <printf>
  sleep(5 * TPS);  // now type control-p
  cf:	c7 04 24 88 13 00 00 	movl   $0x1388,(%esp)
  d6:	e8 12 05 00 00       	call   5ed <sleep>
  ppid = getppid();
  db:	e8 3d 05 00 00       	call   61d <getppid>
  printf(1, "My parent process is: %d\n", ppid);
  e0:	83 c4 0c             	add    $0xc,%esp
  e3:	50                   	push   %eax
  e4:	68 5e 0a 00 00       	push   $0xa5e
  e9:	6a 01                	push   $0x1
  eb:	e8 d7 05 00 00       	call   6c7 <printf>
  printf(1, "Setting UID to %d and GID to %d before fork(). Value"
  f0:	6a 6f                	push   $0x6f
  f2:	6a 6f                	push   $0x6f
  f4:	68 80 0a 00 00       	push   $0xa80
  f9:	6a 01                	push   $0x1
  fb:	e8 c7 05 00 00       	call   6c7 <printf>
  if (setuid(nval) < 0)
 100:	83 c4 14             	add    $0x14,%esp
 103:	6a 6f                	push   $0x6f
 105:	e8 1b 05 00 00       	call   625 <setuid>
 10a:	83 c4 10             	add    $0x10,%esp
 10d:	85 c0                	test   %eax,%eax
 10f:	0f 88 49 01 00 00    	js     25e <main+0x25e>
  if (setgid(nval) < 0)
 115:	83 ec 0c             	sub    $0xc,%esp
 118:	6a 6f                	push   $0x6f
 11a:	e8 0e 05 00 00       	call   62d <setgid>
 11f:	83 c4 10             	add    $0x10,%esp
 122:	85 c0                	test   %eax,%eax
 124:	0f 88 4d 01 00 00    	js     277 <main+0x277>
  printf(1, "Before fork(), UID = %d, GID = %d\n", getuid(), getgid());
 12a:	e8 e6 04 00 00       	call   615 <getgid>
 12f:	89 c3                	mov    %eax,%ebx
 131:	e8 d7 04 00 00       	call   60d <getuid>
 136:	53                   	push   %ebx
 137:	50                   	push   %eax
 138:	68 cc 0a 00 00       	push   $0xacc
 13d:	6a 01                	push   $0x1
 13f:	e8 83 05 00 00       	call   6c7 <printf>
  pid = fork();
 144:	e8 0c 04 00 00       	call   555 <fork>
  if (pid == 0) {  // child
 149:	83 c4 10             	add    $0x10,%esp
 14c:	85 c0                	test   %eax,%eax
 14e:	0f 84 3c 01 00 00    	je     290 <main+0x290>
    sleep(10 * TPS); // wait for child to exit before proceeding
 154:	83 ec 0c             	sub    $0xc,%esp
 157:	68 10 27 00 00       	push   $0x2710
 15c:	e8 8c 04 00 00       	call   5ed <sleep>
  printf(1, "Setting UID to %d. This test should FAIL\n", nval);
 161:	83 c4 0c             	add    $0xc,%esp
 164:	68 20 80 00 00       	push   $0x8020
 169:	68 10 0b 00 00       	push   $0xb10
 16e:	6a 01                	push   $0x1
 170:	e8 52 05 00 00       	call   6c7 <printf>
  if (setuid(nval) < 0)
 175:	c7 04 24 20 80 00 00 	movl   $0x8020,(%esp)
 17c:	e8 a4 04 00 00       	call   625 <setuid>
 181:	83 c4 10             	add    $0x10,%esp
 184:	85 c0                	test   %eax,%eax
 186:	0f 88 2f 01 00 00    	js     2bb <main+0x2bb>
    printf(2, "FAILURE! The setuid system call indicates success\n");
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	68 70 0b 00 00       	push   $0xb70
 194:	6a 02                	push   $0x2
 196:	e8 2c 05 00 00       	call   6c7 <printf>
 19b:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to %d. This test should FAIL\n", nval);
 19e:	83 ec 04             	sub    $0x4,%esp
 1a1:	68 20 80 00 00       	push   $0x8020
 1a6:	68 a4 0b 00 00       	push   $0xba4
 1ab:	6a 01                	push   $0x1
 1ad:	e8 15 05 00 00       	call   6c7 <printf>
  if (setgid(nval) < 0)
 1b2:	c7 04 24 20 80 00 00 	movl   $0x8020,(%esp)
 1b9:	e8 6f 04 00 00       	call   62d <setgid>
 1be:	83 c4 10             	add    $0x10,%esp
 1c1:	85 c0                	test   %eax,%eax
 1c3:	0f 88 09 01 00 00    	js     2d2 <main+0x2d2>
    printf(2, "FAILURE! The setgid system call indicates success\n");
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	68 04 0c 00 00       	push   $0xc04
 1d1:	6a 02                	push   $0x2
 1d3:	e8 ef 04 00 00       	call   6c7 <printf>
 1d8:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to %d. This test should FAIL\n", -1);
 1db:	83 ec 04             	sub    $0x4,%esp
 1de:	6a ff                	push   $0xffffffff
 1e0:	68 10 0b 00 00       	push   $0xb10
 1e5:	6a 01                	push   $0x1
 1e7:	e8 db 04 00 00       	call   6c7 <printf>
  if (setuid(-1) < 0)
 1ec:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 1f3:	e8 2d 04 00 00       	call   625 <setuid>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	85 c0                	test   %eax,%eax
 1fd:	0f 88 e6 00 00 00    	js     2e9 <main+0x2e9>
    printf(2, "FAILURE! The setgid system call indicates success\n");
 203:	83 ec 08             	sub    $0x8,%esp
 206:	68 04 0c 00 00       	push   $0xc04
 20b:	6a 02                	push   $0x2
 20d:	e8 b5 04 00 00       	call   6c7 <printf>
 212:	83 c4 10             	add    $0x10,%esp
  printf(1, "Done!\n");
 215:	83 ec 08             	sub    $0x8,%esp
 218:	68 78 0a 00 00       	push   $0xa78
 21d:	6a 01                	push   $0x1
 21f:	e8 a3 04 00 00       	call   6c7 <printf>
  testuidgid();
  exit();
 224:	e8 34 03 00 00       	call   55d <exit>
    printf(2, "Error. Invalid UID: %d\n", nval);
 229:	83 ec 04             	sub    $0x4,%esp
 22c:	6a 64                	push   $0x64
 22e:	68 07 0a 00 00       	push   $0xa07
 233:	6a 02                	push   $0x2
 235:	e8 8d 04 00 00       	call   6c7 <printf>
 23a:	83 c4 10             	add    $0x10,%esp
 23d:	e9 0a fe ff ff       	jmp    4c <main+0x4c>
    printf(2, "Error. Invalid GID: %d\n", nval);
 242:	83 ec 04             	sub    $0x4,%esp
 245:	68 c8 00 00 00       	push   $0xc8
 24a:	68 46 0a 00 00       	push   $0xa46
 24f:	6a 02                	push   $0x2
 251:	e8 71 04 00 00       	call   6c7 <printf>
 256:	83 c4 10             	add    $0x10,%esp
 259:	e9 4f fe ff ff       	jmp    ad <main+0xad>
    printf(2, "Error. Invalid UID: %d\n", nval);
 25e:	83 ec 04             	sub    $0x4,%esp
 261:	6a 6f                	push   $0x6f
 263:	68 07 0a 00 00       	push   $0xa07
 268:	6a 02                	push   $0x2
 26a:	e8 58 04 00 00       	call   6c7 <printf>
 26f:	83 c4 10             	add    $0x10,%esp
 272:	e9 9e fe ff ff       	jmp    115 <main+0x115>
    printf(2, "Error. Invalid UID: %d\n", nval);
 277:	83 ec 04             	sub    $0x4,%esp
 27a:	6a 6f                	push   $0x6f
 27c:	68 07 0a 00 00       	push   $0xa07
 281:	6a 02                	push   $0x2
 283:	e8 3f 04 00 00       	call   6c7 <printf>
 288:	83 c4 10             	add    $0x10,%esp
 28b:	e9 9a fe ff ff       	jmp    12a <main+0x12a>
    uid = getuid();
 290:	e8 78 03 00 00       	call   60d <getuid>
 295:	89 c3                	mov    %eax,%ebx
    gid = getgid();
 297:	e8 79 03 00 00       	call   615 <getgid>
    printf(1, "Child: UID is: %d, GID is: %d\n", uid, gid);
 29c:	50                   	push   %eax
 29d:	53                   	push   %ebx
 29e:	68 f0 0a 00 00       	push   $0xaf0
 2a3:	6a 01                	push   $0x1
 2a5:	e8 1d 04 00 00       	call   6c7 <printf>
    sleep(5 * TPS);  // now type control-p
 2aa:	c7 04 24 88 13 00 00 	movl   $0x1388,(%esp)
 2b1:	e8 37 03 00 00       	call   5ed <sleep>
    exit();
 2b6:	e8 a2 02 00 00       	call   55d <exit>
    printf(1, "SUCCESS! The setuid sytem call indicated failure\n");
 2bb:	83 ec 08             	sub    $0x8,%esp
 2be:	68 3c 0b 00 00       	push   $0xb3c
 2c3:	6a 01                	push   $0x1
 2c5:	e8 fd 03 00 00       	call   6c7 <printf>
 2ca:	83 c4 10             	add    $0x10,%esp
 2cd:	e9 cc fe ff ff       	jmp    19e <main+0x19e>
    printf(1, "SUCCESS! The setgid sytem call indicated failure\n");
 2d2:	83 ec 08             	sub    $0x8,%esp
 2d5:	68 d0 0b 00 00       	push   $0xbd0
 2da:	6a 01                	push   $0x1
 2dc:	e8 e6 03 00 00       	call   6c7 <printf>
 2e1:	83 c4 10             	add    $0x10,%esp
 2e4:	e9 f2 fe ff ff       	jmp    1db <main+0x1db>
    printf(1, "SUCCESS! The setuid sytem call indicated failure\n");
 2e9:	83 ec 08             	sub    $0x8,%esp
 2ec:	68 3c 0b 00 00       	push   $0xb3c
 2f1:	6a 01                	push   $0x1
 2f3:	e8 cf 03 00 00       	call   6c7 <printf>
 2f8:	83 c4 10             	add    $0x10,%esp
 2fb:	e9 15 ff ff ff       	jmp    215 <main+0x215>

00000300 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	53                   	push   %ebx
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 30a:	89 c2                	mov    %eax,%edx
 30c:	83 c1 01             	add    $0x1,%ecx
 30f:	83 c2 01             	add    $0x1,%edx
 312:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 316:	88 5a ff             	mov    %bl,-0x1(%edx)
 319:	84 db                	test   %bl,%bl
 31b:	75 ef                	jne    30c <strcpy+0xc>
    ;
  return os;
}
 31d:	5b                   	pop    %ebx
 31e:	5d                   	pop    %ebp
 31f:	c3                   	ret    

00000320 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	8b 4d 08             	mov    0x8(%ebp),%ecx
 326:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 329:	0f b6 01             	movzbl (%ecx),%eax
 32c:	84 c0                	test   %al,%al
 32e:	74 15                	je     345 <strcmp+0x25>
 330:	3a 02                	cmp    (%edx),%al
 332:	75 11                	jne    345 <strcmp+0x25>
    p++, q++;
 334:	83 c1 01             	add    $0x1,%ecx
 337:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 33a:	0f b6 01             	movzbl (%ecx),%eax
 33d:	84 c0                	test   %al,%al
 33f:	74 04                	je     345 <strcmp+0x25>
 341:	3a 02                	cmp    (%edx),%al
 343:	74 ef                	je     334 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 345:	0f b6 c0             	movzbl %al,%eax
 348:	0f b6 12             	movzbl (%edx),%edx
 34b:	29 d0                	sub    %edx,%eax
}
 34d:	5d                   	pop    %ebp
 34e:	c3                   	ret    

0000034f <strlen>:

uint
strlen(char *s)
{
 34f:	55                   	push   %ebp
 350:	89 e5                	mov    %esp,%ebp
 352:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 355:	80 39 00             	cmpb   $0x0,(%ecx)
 358:	74 12                	je     36c <strlen+0x1d>
 35a:	ba 00 00 00 00       	mov    $0x0,%edx
 35f:	83 c2 01             	add    $0x1,%edx
 362:	89 d0                	mov    %edx,%eax
 364:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 368:	75 f5                	jne    35f <strlen+0x10>
    ;
  return n;
}
 36a:	5d                   	pop    %ebp
 36b:	c3                   	ret    
  for(n = 0; s[n]; n++)
 36c:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 371:	eb f7                	jmp    36a <strlen+0x1b>

00000373 <memset>:

void*
memset(void *dst, int c, uint n)
{
 373:	55                   	push   %ebp
 374:	89 e5                	mov    %esp,%ebp
 376:	57                   	push   %edi
 377:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 37a:	89 d7                	mov    %edx,%edi
 37c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 37f:	8b 45 0c             	mov    0xc(%ebp),%eax
 382:	fc                   	cld    
 383:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 385:	89 d0                	mov    %edx,%eax
 387:	5f                   	pop    %edi
 388:	5d                   	pop    %ebp
 389:	c3                   	ret    

0000038a <strchr>:

char*
strchr(const char *s, char c)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	53                   	push   %ebx
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 394:	0f b6 10             	movzbl (%eax),%edx
 397:	84 d2                	test   %dl,%dl
 399:	74 1e                	je     3b9 <strchr+0x2f>
 39b:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 39d:	38 d3                	cmp    %dl,%bl
 39f:	74 15                	je     3b6 <strchr+0x2c>
  for(; *s; s++)
 3a1:	83 c0 01             	add    $0x1,%eax
 3a4:	0f b6 10             	movzbl (%eax),%edx
 3a7:	84 d2                	test   %dl,%dl
 3a9:	74 06                	je     3b1 <strchr+0x27>
    if(*s == c)
 3ab:	38 ca                	cmp    %cl,%dl
 3ad:	75 f2                	jne    3a1 <strchr+0x17>
 3af:	eb 05                	jmp    3b6 <strchr+0x2c>
      return (char*)s;
  return 0;
 3b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3b6:	5b                   	pop    %ebx
 3b7:	5d                   	pop    %ebp
 3b8:	c3                   	ret    
  return 0;
 3b9:	b8 00 00 00 00       	mov    $0x0,%eax
 3be:	eb f6                	jmp    3b6 <strchr+0x2c>

000003c0 <gets>:

char*
gets(char *buf, int max)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
 3c5:	53                   	push   %ebx
 3c6:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c9:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 3ce:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 3d1:	8d 5e 01             	lea    0x1(%esi),%ebx
 3d4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3d7:	7d 2b                	jge    404 <gets+0x44>
    cc = read(0, &c, 1);
 3d9:	83 ec 04             	sub    $0x4,%esp
 3dc:	6a 01                	push   $0x1
 3de:	57                   	push   %edi
 3df:	6a 00                	push   $0x0
 3e1:	e8 8f 01 00 00       	call   575 <read>
    if(cc < 1)
 3e6:	83 c4 10             	add    $0x10,%esp
 3e9:	85 c0                	test   %eax,%eax
 3eb:	7e 17                	jle    404 <gets+0x44>
      break;
    buf[i++] = c;
 3ed:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3f1:	8b 55 08             	mov    0x8(%ebp),%edx
 3f4:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 3f8:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 3fa:	3c 0a                	cmp    $0xa,%al
 3fc:	74 04                	je     402 <gets+0x42>
 3fe:	3c 0d                	cmp    $0xd,%al
 400:	75 cf                	jne    3d1 <gets+0x11>
  for(i=0; i+1 < max; ){
 402:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 404:	8b 45 08             	mov    0x8(%ebp),%eax
 407:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 40b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40e:	5b                   	pop    %ebx
 40f:	5e                   	pop    %esi
 410:	5f                   	pop    %edi
 411:	5d                   	pop    %ebp
 412:	c3                   	ret    

00000413 <stat>:

int
stat(char *n, struct stat *st)
{
 413:	55                   	push   %ebp
 414:	89 e5                	mov    %esp,%ebp
 416:	56                   	push   %esi
 417:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 418:	83 ec 08             	sub    $0x8,%esp
 41b:	6a 00                	push   $0x0
 41d:	ff 75 08             	pushl  0x8(%ebp)
 420:	e8 78 01 00 00       	call   59d <open>
  if(fd < 0)
 425:	83 c4 10             	add    $0x10,%esp
 428:	85 c0                	test   %eax,%eax
 42a:	78 24                	js     450 <stat+0x3d>
 42c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 42e:	83 ec 08             	sub    $0x8,%esp
 431:	ff 75 0c             	pushl  0xc(%ebp)
 434:	50                   	push   %eax
 435:	e8 7b 01 00 00       	call   5b5 <fstat>
 43a:	89 c6                	mov    %eax,%esi
  close(fd);
 43c:	89 1c 24             	mov    %ebx,(%esp)
 43f:	e8 41 01 00 00       	call   585 <close>
  return r;
 444:	83 c4 10             	add    $0x10,%esp
}
 447:	89 f0                	mov    %esi,%eax
 449:	8d 65 f8             	lea    -0x8(%ebp),%esp
 44c:	5b                   	pop    %ebx
 44d:	5e                   	pop    %esi
 44e:	5d                   	pop    %ebp
 44f:	c3                   	ret    
    return -1;
 450:	be ff ff ff ff       	mov    $0xffffffff,%esi
 455:	eb f0                	jmp    447 <stat+0x34>

00000457 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 457:	55                   	push   %ebp
 458:	89 e5                	mov    %esp,%ebp
 45a:	56                   	push   %esi
 45b:	53                   	push   %ebx
 45c:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 45f:	0f b6 0a             	movzbl (%edx),%ecx
 462:	80 f9 20             	cmp    $0x20,%cl
 465:	75 0b                	jne    472 <atoi+0x1b>
 467:	83 c2 01             	add    $0x1,%edx
 46a:	0f b6 0a             	movzbl (%edx),%ecx
 46d:	80 f9 20             	cmp    $0x20,%cl
 470:	74 f5                	je     467 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 472:	80 f9 2d             	cmp    $0x2d,%cl
 475:	74 3b                	je     4b2 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 477:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 47a:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 47f:	f6 c1 fd             	test   $0xfd,%cl
 482:	74 33                	je     4b7 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 484:	0f b6 0a             	movzbl (%edx),%ecx
 487:	8d 41 d0             	lea    -0x30(%ecx),%eax
 48a:	3c 09                	cmp    $0x9,%al
 48c:	77 2e                	ja     4bc <atoi+0x65>
 48e:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 493:	83 c2 01             	add    $0x1,%edx
 496:	8d 04 80             	lea    (%eax,%eax,4),%eax
 499:	0f be c9             	movsbl %cl,%ecx
 49c:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 4a0:	0f b6 0a             	movzbl (%edx),%ecx
 4a3:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 4a6:	80 fb 09             	cmp    $0x9,%bl
 4a9:	76 e8                	jbe    493 <atoi+0x3c>
  return sign*n;
 4ab:	0f af c6             	imul   %esi,%eax
}
 4ae:	5b                   	pop    %ebx
 4af:	5e                   	pop    %esi
 4b0:	5d                   	pop    %ebp
 4b1:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 4b2:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 4b7:	83 c2 01             	add    $0x1,%edx
 4ba:	eb c8                	jmp    484 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 4bc:	b8 00 00 00 00       	mov    $0x0,%eax
 4c1:	eb e8                	jmp    4ab <atoi+0x54>

000004c3 <atoo>:

int
atoo(const char *s)
{
 4c3:	55                   	push   %ebp
 4c4:	89 e5                	mov    %esp,%ebp
 4c6:	56                   	push   %esi
 4c7:	53                   	push   %ebx
 4c8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 4cb:	0f b6 0a             	movzbl (%edx),%ecx
 4ce:	80 f9 20             	cmp    $0x20,%cl
 4d1:	75 0b                	jne    4de <atoo+0x1b>
 4d3:	83 c2 01             	add    $0x1,%edx
 4d6:	0f b6 0a             	movzbl (%edx),%ecx
 4d9:	80 f9 20             	cmp    $0x20,%cl
 4dc:	74 f5                	je     4d3 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 4de:	80 f9 2d             	cmp    $0x2d,%cl
 4e1:	74 38                	je     51b <atoo+0x58>
  if (*s == '+'  || *s == '-')
 4e3:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 4e6:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 4eb:	f6 c1 fd             	test   $0xfd,%cl
 4ee:	74 30                	je     520 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 4f0:	0f b6 0a             	movzbl (%edx),%ecx
 4f3:	8d 41 d0             	lea    -0x30(%ecx),%eax
 4f6:	3c 07                	cmp    $0x7,%al
 4f8:	77 2b                	ja     525 <atoo+0x62>
 4fa:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 4ff:	83 c2 01             	add    $0x1,%edx
 502:	0f be c9             	movsbl %cl,%ecx
 505:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 509:	0f b6 0a             	movzbl (%edx),%ecx
 50c:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 50f:	80 fb 07             	cmp    $0x7,%bl
 512:	76 eb                	jbe    4ff <atoo+0x3c>
  return sign*n;
 514:	0f af c6             	imul   %esi,%eax
}
 517:	5b                   	pop    %ebx
 518:	5e                   	pop    %esi
 519:	5d                   	pop    %ebp
 51a:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 51b:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 520:	83 c2 01             	add    $0x1,%edx
 523:	eb cb                	jmp    4f0 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 525:	b8 00 00 00 00       	mov    $0x0,%eax
 52a:	eb e8                	jmp    514 <atoo+0x51>

0000052c <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 52c:	55                   	push   %ebp
 52d:	89 e5                	mov    %esp,%ebp
 52f:	56                   	push   %esi
 530:	53                   	push   %ebx
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	8b 75 0c             	mov    0xc(%ebp),%esi
 537:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 53a:	85 db                	test   %ebx,%ebx
 53c:	7e 13                	jle    551 <memmove+0x25>
 53e:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 543:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 547:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 54a:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 54d:	39 d3                	cmp    %edx,%ebx
 54f:	75 f2                	jne    543 <memmove+0x17>
  return vdst;
}
 551:	5b                   	pop    %ebx
 552:	5e                   	pop    %esi
 553:	5d                   	pop    %ebp
 554:	c3                   	ret    

00000555 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 555:	b8 01 00 00 00       	mov    $0x1,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <exit>:
SYSCALL(exit)
 55d:	b8 02 00 00 00       	mov    $0x2,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <wait>:
SYSCALL(wait)
 565:	b8 03 00 00 00       	mov    $0x3,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <pipe>:
SYSCALL(pipe)
 56d:	b8 04 00 00 00       	mov    $0x4,%eax
 572:	cd 40                	int    $0x40
 574:	c3                   	ret    

00000575 <read>:
SYSCALL(read)
 575:	b8 05 00 00 00       	mov    $0x5,%eax
 57a:	cd 40                	int    $0x40
 57c:	c3                   	ret    

0000057d <write>:
SYSCALL(write)
 57d:	b8 10 00 00 00       	mov    $0x10,%eax
 582:	cd 40                	int    $0x40
 584:	c3                   	ret    

00000585 <close>:
SYSCALL(close)
 585:	b8 15 00 00 00       	mov    $0x15,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <kill>:
SYSCALL(kill)
 58d:	b8 06 00 00 00       	mov    $0x6,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <exec>:
SYSCALL(exec)
 595:	b8 07 00 00 00       	mov    $0x7,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <open>:
SYSCALL(open)
 59d:	b8 0f 00 00 00       	mov    $0xf,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <mknod>:
SYSCALL(mknod)
 5a5:	b8 11 00 00 00       	mov    $0x11,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <unlink>:
SYSCALL(unlink)
 5ad:	b8 12 00 00 00       	mov    $0x12,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <fstat>:
SYSCALL(fstat)
 5b5:	b8 08 00 00 00       	mov    $0x8,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <link>:
SYSCALL(link)
 5bd:	b8 13 00 00 00       	mov    $0x13,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <mkdir>:
SYSCALL(mkdir)
 5c5:	b8 14 00 00 00       	mov    $0x14,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <chdir>:
SYSCALL(chdir)
 5cd:	b8 09 00 00 00       	mov    $0x9,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <dup>:
SYSCALL(dup)
 5d5:	b8 0a 00 00 00       	mov    $0xa,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <getpid>:
SYSCALL(getpid)
 5dd:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <sbrk>:
SYSCALL(sbrk)
 5e5:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <sleep>:
SYSCALL(sleep)
 5ed:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <uptime>:
SYSCALL(uptime)
 5f5:	b8 0e 00 00 00       	mov    $0xe,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <halt>:
SYSCALL(halt)
 5fd:	b8 16 00 00 00       	mov    $0x16,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <date>:
//proj1
SYSCALL(date)
 605:	b8 17 00 00 00       	mov    $0x17,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <getuid>:
//proj2
SYSCALL(getuid)
 60d:	b8 18 00 00 00       	mov    $0x18,%eax
 612:	cd 40                	int    $0x40
 614:	c3                   	ret    

00000615 <getgid>:
SYSCALL(getgid)
 615:	b8 19 00 00 00       	mov    $0x19,%eax
 61a:	cd 40                	int    $0x40
 61c:	c3                   	ret    

0000061d <getppid>:
SYSCALL(getppid)
 61d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 622:	cd 40                	int    $0x40
 624:	c3                   	ret    

00000625 <setuid>:
SYSCALL(setuid)
 625:	b8 1b 00 00 00       	mov    $0x1b,%eax
 62a:	cd 40                	int    $0x40
 62c:	c3                   	ret    

0000062d <setgid>:
SYSCALL(setgid)
 62d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 632:	cd 40                	int    $0x40
 634:	c3                   	ret    

00000635 <getprocs>:
SYSCALL(getprocs)
 635:	b8 1d 00 00 00       	mov    $0x1d,%eax
 63a:	cd 40                	int    $0x40
 63c:	c3                   	ret    

0000063d <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	57                   	push   %edi
 641:	56                   	push   %esi
 642:	53                   	push   %ebx
 643:	83 ec 3c             	sub    $0x3c,%esp
 646:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 648:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 64c:	74 14                	je     662 <printint+0x25>
 64e:	85 d2                	test   %edx,%edx
 650:	79 10                	jns    662 <printint+0x25>
    neg = 1;
    x = -xx;
 652:	f7 da                	neg    %edx
    neg = 1;
 654:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 65b:	bf 00 00 00 00       	mov    $0x0,%edi
 660:	eb 0b                	jmp    66d <printint+0x30>
  neg = 0;
 662:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 669:	eb f0                	jmp    65b <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 66b:	89 df                	mov    %ebx,%edi
 66d:	8d 5f 01             	lea    0x1(%edi),%ebx
 670:	89 d0                	mov    %edx,%eax
 672:	ba 00 00 00 00       	mov    $0x0,%edx
 677:	f7 f1                	div    %ecx
 679:	0f b6 92 40 0c 00 00 	movzbl 0xc40(%edx),%edx
 680:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 684:	89 c2                	mov    %eax,%edx
 686:	85 c0                	test   %eax,%eax
 688:	75 e1                	jne    66b <printint+0x2e>
  if(neg)
 68a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 68e:	74 08                	je     698 <printint+0x5b>
    buf[i++] = '-';
 690:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 695:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 698:	83 eb 01             	sub    $0x1,%ebx
 69b:	78 22                	js     6bf <printint+0x82>
  write(fd, &c, 1);
 69d:	8d 7d d7             	lea    -0x29(%ebp),%edi
 6a0:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 6a5:	88 45 d7             	mov    %al,-0x29(%ebp)
 6a8:	83 ec 04             	sub    $0x4,%esp
 6ab:	6a 01                	push   $0x1
 6ad:	57                   	push   %edi
 6ae:	56                   	push   %esi
 6af:	e8 c9 fe ff ff       	call   57d <write>
  while(--i >= 0)
 6b4:	83 eb 01             	sub    $0x1,%ebx
 6b7:	83 c4 10             	add    $0x10,%esp
 6ba:	83 fb ff             	cmp    $0xffffffff,%ebx
 6bd:	75 e1                	jne    6a0 <printint+0x63>
    putc(fd, buf[i]);
}
 6bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c2:	5b                   	pop    %ebx
 6c3:	5e                   	pop    %esi
 6c4:	5f                   	pop    %edi
 6c5:	5d                   	pop    %ebp
 6c6:	c3                   	ret    

000006c7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6c7:	55                   	push   %ebp
 6c8:	89 e5                	mov    %esp,%ebp
 6ca:	57                   	push   %edi
 6cb:	56                   	push   %esi
 6cc:	53                   	push   %ebx
 6cd:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d0:	8b 75 0c             	mov    0xc(%ebp),%esi
 6d3:	0f b6 1e             	movzbl (%esi),%ebx
 6d6:	84 db                	test   %bl,%bl
 6d8:	0f 84 b1 01 00 00    	je     88f <printf+0x1c8>
 6de:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 6e1:	8d 45 10             	lea    0x10(%ebp),%eax
 6e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 6e7:	bf 00 00 00 00       	mov    $0x0,%edi
 6ec:	eb 2d                	jmp    71b <printf+0x54>
 6ee:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 6f1:	83 ec 04             	sub    $0x4,%esp
 6f4:	6a 01                	push   $0x1
 6f6:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 6f9:	50                   	push   %eax
 6fa:	ff 75 08             	pushl  0x8(%ebp)
 6fd:	e8 7b fe ff ff       	call   57d <write>
 702:	83 c4 10             	add    $0x10,%esp
 705:	eb 05                	jmp    70c <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 707:	83 ff 25             	cmp    $0x25,%edi
 70a:	74 22                	je     72e <printf+0x67>
 70c:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 70f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 713:	84 db                	test   %bl,%bl
 715:	0f 84 74 01 00 00    	je     88f <printf+0x1c8>
    c = fmt[i] & 0xff;
 71b:	0f be d3             	movsbl %bl,%edx
 71e:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 721:	85 ff                	test   %edi,%edi
 723:	75 e2                	jne    707 <printf+0x40>
      if(c == '%'){
 725:	83 f8 25             	cmp    $0x25,%eax
 728:	75 c4                	jne    6ee <printf+0x27>
        state = '%';
 72a:	89 c7                	mov    %eax,%edi
 72c:	eb de                	jmp    70c <printf+0x45>
      if(c == 'd'){
 72e:	83 f8 64             	cmp    $0x64,%eax
 731:	74 59                	je     78c <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 733:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 739:	83 fa 70             	cmp    $0x70,%edx
 73c:	74 7a                	je     7b8 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 73e:	83 f8 73             	cmp    $0x73,%eax
 741:	0f 84 9d 00 00 00    	je     7e4 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 747:	83 f8 63             	cmp    $0x63,%eax
 74a:	0f 84 f2 00 00 00    	je     842 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 750:	83 f8 25             	cmp    $0x25,%eax
 753:	0f 84 15 01 00 00    	je     86e <printf+0x1a7>
 759:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 75d:	83 ec 04             	sub    $0x4,%esp
 760:	6a 01                	push   $0x1
 762:	8d 45 e7             	lea    -0x19(%ebp),%eax
 765:	50                   	push   %eax
 766:	ff 75 08             	pushl  0x8(%ebp)
 769:	e8 0f fe ff ff       	call   57d <write>
 76e:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 771:	83 c4 0c             	add    $0xc,%esp
 774:	6a 01                	push   $0x1
 776:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 779:	50                   	push   %eax
 77a:	ff 75 08             	pushl  0x8(%ebp)
 77d:	e8 fb fd ff ff       	call   57d <write>
 782:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 785:	bf 00 00 00 00       	mov    $0x0,%edi
 78a:	eb 80                	jmp    70c <printf+0x45>
        printint(fd, *ap, 10, 1);
 78c:	83 ec 0c             	sub    $0xc,%esp
 78f:	6a 01                	push   $0x1
 791:	b9 0a 00 00 00       	mov    $0xa,%ecx
 796:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 799:	8b 17                	mov    (%edi),%edx
 79b:	8b 45 08             	mov    0x8(%ebp),%eax
 79e:	e8 9a fe ff ff       	call   63d <printint>
        ap++;
 7a3:	89 f8                	mov    %edi,%eax
 7a5:	83 c0 04             	add    $0x4,%eax
 7a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7ab:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7ae:	bf 00 00 00 00       	mov    $0x0,%edi
 7b3:	e9 54 ff ff ff       	jmp    70c <printf+0x45>
        printint(fd, *ap, 16, 0);
 7b8:	83 ec 0c             	sub    $0xc,%esp
 7bb:	6a 00                	push   $0x0
 7bd:	b9 10 00 00 00       	mov    $0x10,%ecx
 7c2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 7c5:	8b 17                	mov    (%edi),%edx
 7c7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ca:	e8 6e fe ff ff       	call   63d <printint>
        ap++;
 7cf:	89 f8                	mov    %edi,%eax
 7d1:	83 c0 04             	add    $0x4,%eax
 7d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7d7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7da:	bf 00 00 00 00       	mov    $0x0,%edi
 7df:	e9 28 ff ff ff       	jmp    70c <printf+0x45>
        s = (char*)*ap;
 7e4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 7e7:	8b 01                	mov    (%ecx),%eax
        ap++;
 7e9:	83 c1 04             	add    $0x4,%ecx
 7ec:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 7ef:	85 c0                	test   %eax,%eax
 7f1:	74 13                	je     806 <printf+0x13f>
        s = (char*)*ap;
 7f3:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 7f5:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 7f8:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 7fd:	84 c0                	test   %al,%al
 7ff:	75 0f                	jne    810 <printf+0x149>
 801:	e9 06 ff ff ff       	jmp    70c <printf+0x45>
          s = "(null)";
 806:	bb 38 0c 00 00       	mov    $0xc38,%ebx
        while(*s != 0){
 80b:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 810:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 813:	89 75 d0             	mov    %esi,-0x30(%ebp)
 816:	8b 75 08             	mov    0x8(%ebp),%esi
 819:	88 45 e3             	mov    %al,-0x1d(%ebp)
 81c:	83 ec 04             	sub    $0x4,%esp
 81f:	6a 01                	push   $0x1
 821:	57                   	push   %edi
 822:	56                   	push   %esi
 823:	e8 55 fd ff ff       	call   57d <write>
          s++;
 828:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 82b:	0f b6 03             	movzbl (%ebx),%eax
 82e:	83 c4 10             	add    $0x10,%esp
 831:	84 c0                	test   %al,%al
 833:	75 e4                	jne    819 <printf+0x152>
 835:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 838:	bf 00 00 00 00       	mov    $0x0,%edi
 83d:	e9 ca fe ff ff       	jmp    70c <printf+0x45>
        putc(fd, *ap);
 842:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 845:	8b 07                	mov    (%edi),%eax
 847:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 84a:	83 ec 04             	sub    $0x4,%esp
 84d:	6a 01                	push   $0x1
 84f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 852:	50                   	push   %eax
 853:	ff 75 08             	pushl  0x8(%ebp)
 856:	e8 22 fd ff ff       	call   57d <write>
        ap++;
 85b:	83 c7 04             	add    $0x4,%edi
 85e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 861:	83 c4 10             	add    $0x10,%esp
      state = 0;
 864:	bf 00 00 00 00       	mov    $0x0,%edi
 869:	e9 9e fe ff ff       	jmp    70c <printf+0x45>
 86e:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 871:	83 ec 04             	sub    $0x4,%esp
 874:	6a 01                	push   $0x1
 876:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 879:	50                   	push   %eax
 87a:	ff 75 08             	pushl  0x8(%ebp)
 87d:	e8 fb fc ff ff       	call   57d <write>
 882:	83 c4 10             	add    $0x10,%esp
      state = 0;
 885:	bf 00 00 00 00       	mov    $0x0,%edi
 88a:	e9 7d fe ff ff       	jmp    70c <printf+0x45>
    }
  }
}
 88f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 892:	5b                   	pop    %ebx
 893:	5e                   	pop    %esi
 894:	5f                   	pop    %edi
 895:	5d                   	pop    %ebp
 896:	c3                   	ret    

00000897 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 897:	55                   	push   %ebp
 898:	89 e5                	mov    %esp,%ebp
 89a:	57                   	push   %edi
 89b:	56                   	push   %esi
 89c:	53                   	push   %ebx
 89d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a3:	a1 dc 0e 00 00       	mov    0xedc,%eax
 8a8:	eb 0c                	jmp    8b6 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8aa:	8b 10                	mov    (%eax),%edx
 8ac:	39 c2                	cmp    %eax,%edx
 8ae:	77 04                	ja     8b4 <free+0x1d>
 8b0:	39 ca                	cmp    %ecx,%edx
 8b2:	77 10                	ja     8c4 <free+0x2d>
{
 8b4:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b6:	39 c8                	cmp    %ecx,%eax
 8b8:	73 f0                	jae    8aa <free+0x13>
 8ba:	8b 10                	mov    (%eax),%edx
 8bc:	39 ca                	cmp    %ecx,%edx
 8be:	77 04                	ja     8c4 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c0:	39 c2                	cmp    %eax,%edx
 8c2:	77 f0                	ja     8b4 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8c4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8c7:	8b 10                	mov    (%eax),%edx
 8c9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8cc:	39 fa                	cmp    %edi,%edx
 8ce:	74 19                	je     8e9 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8d0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8d3:	8b 50 04             	mov    0x4(%eax),%edx
 8d6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8d9:	39 f1                	cmp    %esi,%ecx
 8db:	74 1b                	je     8f8 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8dd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 8df:	a3 dc 0e 00 00       	mov    %eax,0xedc
}
 8e4:	5b                   	pop    %ebx
 8e5:	5e                   	pop    %esi
 8e6:	5f                   	pop    %edi
 8e7:	5d                   	pop    %ebp
 8e8:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 8e9:	03 72 04             	add    0x4(%edx),%esi
 8ec:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ef:	8b 10                	mov    (%eax),%edx
 8f1:	8b 12                	mov    (%edx),%edx
 8f3:	89 53 f8             	mov    %edx,-0x8(%ebx)
 8f6:	eb db                	jmp    8d3 <free+0x3c>
    p->s.size += bp->s.size;
 8f8:	03 53 fc             	add    -0x4(%ebx),%edx
 8fb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8fe:	8b 53 f8             	mov    -0x8(%ebx),%edx
 901:	89 10                	mov    %edx,(%eax)
 903:	eb da                	jmp    8df <free+0x48>

00000905 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 905:	55                   	push   %ebp
 906:	89 e5                	mov    %esp,%ebp
 908:	57                   	push   %edi
 909:	56                   	push   %esi
 90a:	53                   	push   %ebx
 90b:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90e:	8b 45 08             	mov    0x8(%ebp),%eax
 911:	8d 58 07             	lea    0x7(%eax),%ebx
 914:	c1 eb 03             	shr    $0x3,%ebx
 917:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 91a:	8b 15 dc 0e 00 00    	mov    0xedc,%edx
 920:	85 d2                	test   %edx,%edx
 922:	74 20                	je     944 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 924:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 926:	8b 48 04             	mov    0x4(%eax),%ecx
 929:	39 cb                	cmp    %ecx,%ebx
 92b:	76 3c                	jbe    969 <malloc+0x64>
 92d:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 933:	be 00 10 00 00       	mov    $0x1000,%esi
 938:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 93b:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 942:	eb 70                	jmp    9b4 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 944:	c7 05 dc 0e 00 00 e0 	movl   $0xee0,0xedc
 94b:	0e 00 00 
 94e:	c7 05 e0 0e 00 00 e0 	movl   $0xee0,0xee0
 955:	0e 00 00 
    base.s.size = 0;
 958:	c7 05 e4 0e 00 00 00 	movl   $0x0,0xee4
 95f:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 962:	ba e0 0e 00 00       	mov    $0xee0,%edx
 967:	eb bb                	jmp    924 <malloc+0x1f>
      if(p->s.size == nunits)
 969:	39 cb                	cmp    %ecx,%ebx
 96b:	74 1c                	je     989 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 96d:	29 d9                	sub    %ebx,%ecx
 96f:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 972:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 975:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 978:	89 15 dc 0e 00 00    	mov    %edx,0xedc
      return (void*)(p + 1);
 97e:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 981:	8d 65 f4             	lea    -0xc(%ebp),%esp
 984:	5b                   	pop    %ebx
 985:	5e                   	pop    %esi
 986:	5f                   	pop    %edi
 987:	5d                   	pop    %ebp
 988:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 989:	8b 08                	mov    (%eax),%ecx
 98b:	89 0a                	mov    %ecx,(%edx)
 98d:	eb e9                	jmp    978 <malloc+0x73>
  hp->s.size = nu;
 98f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 992:	83 ec 0c             	sub    $0xc,%esp
 995:	83 c0 08             	add    $0x8,%eax
 998:	50                   	push   %eax
 999:	e8 f9 fe ff ff       	call   897 <free>
  return freep;
 99e:	8b 15 dc 0e 00 00    	mov    0xedc,%edx
      if((p = morecore(nunits)) == 0)
 9a4:	83 c4 10             	add    $0x10,%esp
 9a7:	85 d2                	test   %edx,%edx
 9a9:	74 2b                	je     9d6 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ab:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9ad:	8b 48 04             	mov    0x4(%eax),%ecx
 9b0:	39 d9                	cmp    %ebx,%ecx
 9b2:	73 b5                	jae    969 <malloc+0x64>
 9b4:	89 c2                	mov    %eax,%edx
    if(p == freep)
 9b6:	39 05 dc 0e 00 00    	cmp    %eax,0xedc
 9bc:	75 ed                	jne    9ab <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 9be:	83 ec 0c             	sub    $0xc,%esp
 9c1:	57                   	push   %edi
 9c2:	e8 1e fc ff ff       	call   5e5 <sbrk>
  if(p == (char*)-1)
 9c7:	83 c4 10             	add    $0x10,%esp
 9ca:	83 f8 ff             	cmp    $0xffffffff,%eax
 9cd:	75 c0                	jne    98f <malloc+0x8a>
        return 0;
 9cf:	b8 00 00 00 00       	mov    $0x0,%eax
 9d4:	eb ab                	jmp    981 <malloc+0x7c>
 9d6:	b8 00 00 00 00       	mov    $0x0,%eax
 9db:	eb a4                	jmp    981 <malloc+0x7c>
