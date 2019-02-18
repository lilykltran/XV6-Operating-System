
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 71 04             	mov    0x4(%ecx),%esi
  int pid = fork();
  17:	e8 ec 02 00 00       	call   308 <fork>
  1c:	89 c3                	mov    %eax,%ebx
  int start = uptime();
  1e:	e8 85 03 00 00       	call   3a8 <uptime>
  
  if (pid < 0) //error
  23:	85 db                	test   %ebx,%ebx
  25:	78 1a                	js     41 <main+0x41>
  27:	89 c7                	mov    %eax,%edi
  {
    printf(2, "Error. Process did not run.\n");
    exit();
  }

  if(pid == 0) //in the child. Successfully created the new process
  29:	85 db                	test   %ebx,%ebx
  2b:	75 28                	jne    55 <main+0x55>
  {
    exec(argv[1], &argv[1]);
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	8d 46 04             	lea    0x4(%esi),%eax
  33:	50                   	push   %eax
  34:	ff 76 04             	pushl  0x4(%esi)
  37:	e8 0c 03 00 00       	call   348 <exec>
    exit();
  3c:	e8 cf 02 00 00       	call   310 <exit>
    printf(2, "Error. Process did not run.\n");
  41:	83 ec 08             	sub    $0x8,%esp
  44:	68 90 07 00 00       	push   $0x790
  49:	6a 02                	push   $0x2
  4b:	e8 2a 04 00 00       	call   47a <printf>
    exit();
  50:	e8 bb 02 00 00       	call   310 <exit>
  }

  wait(); //in the parent
  55:	e8 be 02 00 00       	call   318 <wait>

  int end = uptime();
  5a:	e8 49 03 00 00       	call   3a8 <uptime>
  int total = end - start;
  5f:	29 f8                	sub    %edi,%eax
  61:	89 c1                	mov    %eax,%ecx
  int sec = total/1000;
  63:	bf e8 03 00 00       	mov    $0x3e8,%edi
  68:	99                   	cltd   
  69:	f7 ff                	idiv   %edi
  6b:	89 d7                	mov    %edx,%edi
  6d:	89 c3                	mov    %eax,%ebx
  int milisec = total%1000;

  if(total % 100 < 10)
  6f:	89 c8                	mov    %ecx,%eax
  71:	b9 64 00 00 00       	mov    $0x64,%ecx
  76:	99                   	cltd   
  77:	f7 f9                	idiv   %ecx
  79:	83 fa 09             	cmp    $0x9,%edx
  7c:	7f 1c                	jg     9a <main+0x9a>
    printf(1, "%s ran in %d.0%d seconds.\n", argv[1], sec, milisec); 
  7e:	83 ec 0c             	sub    $0xc,%esp
  81:	57                   	push   %edi
  82:	53                   	push   %ebx
  83:	ff 76 04             	pushl  0x4(%esi)
  86:	68 ad 07 00 00       	push   $0x7ad
  8b:	6a 01                	push   $0x1
  8d:	e8 e8 03 00 00       	call   47a <printf>
  92:	83 c4 20             	add    $0x20,%esp

  else
    printf(1, "%s argument ran in %d.%d seconds.\n", argv[1], sec, milisec);
  
  exit();
  95:	e8 76 02 00 00       	call   310 <exit>
    printf(1, "%s argument ran in %d.%d seconds.\n", argv[1], sec, milisec);
  9a:	83 ec 0c             	sub    $0xc,%esp
  9d:	57                   	push   %edi
  9e:	53                   	push   %ebx
  9f:	ff 76 04             	pushl  0x4(%esi)
  a2:	68 c8 07 00 00       	push   $0x7c8
  a7:	6a 01                	push   $0x1
  a9:	e8 cc 03 00 00       	call   47a <printf>
  ae:	83 c4 20             	add    $0x20,%esp
  b1:	eb e2                	jmp    95 <main+0x95>

000000b3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b3:	55                   	push   %ebp
  b4:	89 e5                	mov    %esp,%ebp
  b6:	53                   	push   %ebx
  b7:	8b 45 08             	mov    0x8(%ebp),%eax
  ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  bd:	89 c2                	mov    %eax,%edx
  bf:	83 c1 01             	add    $0x1,%ecx
  c2:	83 c2 01             	add    $0x1,%edx
  c5:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  c9:	88 5a ff             	mov    %bl,-0x1(%edx)
  cc:	84 db                	test   %bl,%bl
  ce:	75 ef                	jne    bf <strcpy+0xc>
    ;
  return os;
}
  d0:	5b                   	pop    %ebx
  d1:	5d                   	pop    %ebp
  d2:	c3                   	ret    

000000d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  dc:	0f b6 01             	movzbl (%ecx),%eax
  df:	84 c0                	test   %al,%al
  e1:	74 15                	je     f8 <strcmp+0x25>
  e3:	3a 02                	cmp    (%edx),%al
  e5:	75 11                	jne    f8 <strcmp+0x25>
    p++, q++;
  e7:	83 c1 01             	add    $0x1,%ecx
  ea:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  ed:	0f b6 01             	movzbl (%ecx),%eax
  f0:	84 c0                	test   %al,%al
  f2:	74 04                	je     f8 <strcmp+0x25>
  f4:	3a 02                	cmp    (%edx),%al
  f6:	74 ef                	je     e7 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  f8:	0f b6 c0             	movzbl %al,%eax
  fb:	0f b6 12             	movzbl (%edx),%edx
  fe:	29 d0                	sub    %edx,%eax
}
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    

00000102 <strlen>:

uint
strlen(char *s)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 108:	80 39 00             	cmpb   $0x0,(%ecx)
 10b:	74 12                	je     11f <strlen+0x1d>
 10d:	ba 00 00 00 00       	mov    $0x0,%edx
 112:	83 c2 01             	add    $0x1,%edx
 115:	89 d0                	mov    %edx,%eax
 117:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 11b:	75 f5                	jne    112 <strlen+0x10>
    ;
  return n;
}
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    
  for(n = 0; s[n]; n++)
 11f:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 124:	eb f7                	jmp    11d <strlen+0x1b>

00000126 <memset>:

void*
memset(void *dst, int c, uint n)
{
 126:	55                   	push   %ebp
 127:	89 e5                	mov    %esp,%ebp
 129:	57                   	push   %edi
 12a:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 12d:	89 d7                	mov    %edx,%edi
 12f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 132:	8b 45 0c             	mov    0xc(%ebp),%eax
 135:	fc                   	cld    
 136:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 138:	89 d0                	mov    %edx,%eax
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <strchr>:

char*
strchr(const char *s, char c)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	53                   	push   %ebx
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 147:	0f b6 10             	movzbl (%eax),%edx
 14a:	84 d2                	test   %dl,%dl
 14c:	74 1e                	je     16c <strchr+0x2f>
 14e:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 150:	38 d3                	cmp    %dl,%bl
 152:	74 15                	je     169 <strchr+0x2c>
  for(; *s; s++)
 154:	83 c0 01             	add    $0x1,%eax
 157:	0f b6 10             	movzbl (%eax),%edx
 15a:	84 d2                	test   %dl,%dl
 15c:	74 06                	je     164 <strchr+0x27>
    if(*s == c)
 15e:	38 ca                	cmp    %cl,%dl
 160:	75 f2                	jne    154 <strchr+0x17>
 162:	eb 05                	jmp    169 <strchr+0x2c>
      return (char*)s;
  return 0;
 164:	b8 00 00 00 00       	mov    $0x0,%eax
}
 169:	5b                   	pop    %ebx
 16a:	5d                   	pop    %ebp
 16b:	c3                   	ret    
  return 0;
 16c:	b8 00 00 00 00       	mov    $0x0,%eax
 171:	eb f6                	jmp    169 <strchr+0x2c>

00000173 <gets>:

char*
gets(char *buf, int max)
{
 173:	55                   	push   %ebp
 174:	89 e5                	mov    %esp,%ebp
 176:	57                   	push   %edi
 177:	56                   	push   %esi
 178:	53                   	push   %ebx
 179:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17c:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 181:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 184:	8d 5e 01             	lea    0x1(%esi),%ebx
 187:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 18a:	7d 2b                	jge    1b7 <gets+0x44>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	57                   	push   %edi
 192:	6a 00                	push   $0x0
 194:	e8 8f 01 00 00       	call   328 <read>
    if(cc < 1)
 199:	83 c4 10             	add    $0x10,%esp
 19c:	85 c0                	test   %eax,%eax
 19e:	7e 17                	jle    1b7 <gets+0x44>
      break;
    buf[i++] = c;
 1a0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a4:	8b 55 08             	mov    0x8(%ebp),%edx
 1a7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 1ab:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1ad:	3c 0a                	cmp    $0xa,%al
 1af:	74 04                	je     1b5 <gets+0x42>
 1b1:	3c 0d                	cmp    $0xd,%al
 1b3:	75 cf                	jne    184 <gets+0x11>
  for(i=0; i+1 < max; ){
 1b5:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1be:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c1:	5b                   	pop    %ebx
 1c2:	5e                   	pop    %esi
 1c3:	5f                   	pop    %edi
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    

000001c6 <stat>:

int
stat(char *n, struct stat *st)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	56                   	push   %esi
 1ca:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cb:	83 ec 08             	sub    $0x8,%esp
 1ce:	6a 00                	push   $0x0
 1d0:	ff 75 08             	pushl  0x8(%ebp)
 1d3:	e8 78 01 00 00       	call   350 <open>
  if(fd < 0)
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	85 c0                	test   %eax,%eax
 1dd:	78 24                	js     203 <stat+0x3d>
 1df:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1e1:	83 ec 08             	sub    $0x8,%esp
 1e4:	ff 75 0c             	pushl  0xc(%ebp)
 1e7:	50                   	push   %eax
 1e8:	e8 7b 01 00 00       	call   368 <fstat>
 1ed:	89 c6                	mov    %eax,%esi
  close(fd);
 1ef:	89 1c 24             	mov    %ebx,(%esp)
 1f2:	e8 41 01 00 00       	call   338 <close>
  return r;
 1f7:	83 c4 10             	add    $0x10,%esp
}
 1fa:	89 f0                	mov    %esi,%eax
 1fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1ff:	5b                   	pop    %ebx
 200:	5e                   	pop    %esi
 201:	5d                   	pop    %ebp
 202:	c3                   	ret    
    return -1;
 203:	be ff ff ff ff       	mov    $0xffffffff,%esi
 208:	eb f0                	jmp    1fa <stat+0x34>

0000020a <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	56                   	push   %esi
 20e:	53                   	push   %ebx
 20f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 212:	0f b6 0a             	movzbl (%edx),%ecx
 215:	80 f9 20             	cmp    $0x20,%cl
 218:	75 0b                	jne    225 <atoi+0x1b>
 21a:	83 c2 01             	add    $0x1,%edx
 21d:	0f b6 0a             	movzbl (%edx),%ecx
 220:	80 f9 20             	cmp    $0x20,%cl
 223:	74 f5                	je     21a <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 225:	80 f9 2d             	cmp    $0x2d,%cl
 228:	74 3b                	je     265 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 22a:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 22d:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 232:	f6 c1 fd             	test   $0xfd,%cl
 235:	74 33                	je     26a <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 237:	0f b6 0a             	movzbl (%edx),%ecx
 23a:	8d 41 d0             	lea    -0x30(%ecx),%eax
 23d:	3c 09                	cmp    $0x9,%al
 23f:	77 2e                	ja     26f <atoi+0x65>
 241:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 246:	83 c2 01             	add    $0x1,%edx
 249:	8d 04 80             	lea    (%eax,%eax,4),%eax
 24c:	0f be c9             	movsbl %cl,%ecx
 24f:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 253:	0f b6 0a             	movzbl (%edx),%ecx
 256:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 259:	80 fb 09             	cmp    $0x9,%bl
 25c:	76 e8                	jbe    246 <atoi+0x3c>
  return sign*n;
 25e:	0f af c6             	imul   %esi,%eax
}
 261:	5b                   	pop    %ebx
 262:	5e                   	pop    %esi
 263:	5d                   	pop    %ebp
 264:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 265:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 26a:	83 c2 01             	add    $0x1,%edx
 26d:	eb c8                	jmp    237 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 26f:	b8 00 00 00 00       	mov    $0x0,%eax
 274:	eb e8                	jmp    25e <atoi+0x54>

00000276 <atoo>:

int
atoo(const char *s)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	56                   	push   %esi
 27a:	53                   	push   %ebx
 27b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 27e:	0f b6 0a             	movzbl (%edx),%ecx
 281:	80 f9 20             	cmp    $0x20,%cl
 284:	75 0b                	jne    291 <atoo+0x1b>
 286:	83 c2 01             	add    $0x1,%edx
 289:	0f b6 0a             	movzbl (%edx),%ecx
 28c:	80 f9 20             	cmp    $0x20,%cl
 28f:	74 f5                	je     286 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 291:	80 f9 2d             	cmp    $0x2d,%cl
 294:	74 38                	je     2ce <atoo+0x58>
  if (*s == '+'  || *s == '-')
 296:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 299:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 29e:	f6 c1 fd             	test   $0xfd,%cl
 2a1:	74 30                	je     2d3 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 2a3:	0f b6 0a             	movzbl (%edx),%ecx
 2a6:	8d 41 d0             	lea    -0x30(%ecx),%eax
 2a9:	3c 07                	cmp    $0x7,%al
 2ab:	77 2b                	ja     2d8 <atoo+0x62>
 2ad:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 2b2:	83 c2 01             	add    $0x1,%edx
 2b5:	0f be c9             	movsbl %cl,%ecx
 2b8:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2bc:	0f b6 0a             	movzbl (%edx),%ecx
 2bf:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2c2:	80 fb 07             	cmp    $0x7,%bl
 2c5:	76 eb                	jbe    2b2 <atoo+0x3c>
  return sign*n;
 2c7:	0f af c6             	imul   %esi,%eax
}
 2ca:	5b                   	pop    %ebx
 2cb:	5e                   	pop    %esi
 2cc:	5d                   	pop    %ebp
 2cd:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 2ce:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 2d3:	83 c2 01             	add    $0x1,%edx
 2d6:	eb cb                	jmp    2a3 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 2d8:	b8 00 00 00 00       	mov    $0x0,%eax
 2dd:	eb e8                	jmp    2c7 <atoo+0x51>

000002df <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	56                   	push   %esi
 2e3:	53                   	push   %ebx
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	8b 75 0c             	mov    0xc(%ebp),%esi
 2ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ed:	85 db                	test   %ebx,%ebx
 2ef:	7e 13                	jle    304 <memmove+0x25>
 2f1:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 2f6:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2fa:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2fd:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 300:	39 d3                	cmp    %edx,%ebx
 302:	75 f2                	jne    2f6 <memmove+0x17>
  return vdst;
}
 304:	5b                   	pop    %ebx
 305:	5e                   	pop    %esi
 306:	5d                   	pop    %ebp
 307:	c3                   	ret    

00000308 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 308:	b8 01 00 00 00       	mov    $0x1,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <exit>:
SYSCALL(exit)
 310:	b8 02 00 00 00       	mov    $0x2,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <wait>:
SYSCALL(wait)
 318:	b8 03 00 00 00       	mov    $0x3,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <pipe>:
SYSCALL(pipe)
 320:	b8 04 00 00 00       	mov    $0x4,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <read>:
SYSCALL(read)
 328:	b8 05 00 00 00       	mov    $0x5,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <write>:
SYSCALL(write)
 330:	b8 10 00 00 00       	mov    $0x10,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <close>:
SYSCALL(close)
 338:	b8 15 00 00 00       	mov    $0x15,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <kill>:
SYSCALL(kill)
 340:	b8 06 00 00 00       	mov    $0x6,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <exec>:
SYSCALL(exec)
 348:	b8 07 00 00 00       	mov    $0x7,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <open>:
SYSCALL(open)
 350:	b8 0f 00 00 00       	mov    $0xf,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <mknod>:
SYSCALL(mknod)
 358:	b8 11 00 00 00       	mov    $0x11,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <unlink>:
SYSCALL(unlink)
 360:	b8 12 00 00 00       	mov    $0x12,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <fstat>:
SYSCALL(fstat)
 368:	b8 08 00 00 00       	mov    $0x8,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <link>:
SYSCALL(link)
 370:	b8 13 00 00 00       	mov    $0x13,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <mkdir>:
SYSCALL(mkdir)
 378:	b8 14 00 00 00       	mov    $0x14,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <chdir>:
SYSCALL(chdir)
 380:	b8 09 00 00 00       	mov    $0x9,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <dup>:
SYSCALL(dup)
 388:	b8 0a 00 00 00       	mov    $0xa,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <getpid>:
SYSCALL(getpid)
 390:	b8 0b 00 00 00       	mov    $0xb,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <sbrk>:
SYSCALL(sbrk)
 398:	b8 0c 00 00 00       	mov    $0xc,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <sleep>:
SYSCALL(sleep)
 3a0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <uptime>:
SYSCALL(uptime)
 3a8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <halt>:
SYSCALL(halt)
 3b0:	b8 16 00 00 00       	mov    $0x16,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <date>:
//proj1
SYSCALL(date)
 3b8:	b8 17 00 00 00       	mov    $0x17,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <getuid>:
//proj2
SYSCALL(getuid)
 3c0:	b8 18 00 00 00       	mov    $0x18,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <getgid>:
SYSCALL(getgid)
 3c8:	b8 19 00 00 00       	mov    $0x19,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <getppid>:
SYSCALL(getppid)
 3d0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <setuid>:
SYSCALL(setuid)
 3d8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <setgid>:
SYSCALL(setgid)
 3e0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <getprocs>:
SYSCALL(getprocs)
 3e8:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 3c             	sub    $0x3c,%esp
 3f9:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3ff:	74 14                	je     415 <printint+0x25>
 401:	85 d2                	test   %edx,%edx
 403:	79 10                	jns    415 <printint+0x25>
    neg = 1;
    x = -xx;
 405:	f7 da                	neg    %edx
    neg = 1;
 407:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 40e:	bf 00 00 00 00       	mov    $0x0,%edi
 413:	eb 0b                	jmp    420 <printint+0x30>
  neg = 0;
 415:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 41c:	eb f0                	jmp    40e <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 41e:	89 df                	mov    %ebx,%edi
 420:	8d 5f 01             	lea    0x1(%edi),%ebx
 423:	89 d0                	mov    %edx,%eax
 425:	ba 00 00 00 00       	mov    $0x0,%edx
 42a:	f7 f1                	div    %ecx
 42c:	0f b6 92 f4 07 00 00 	movzbl 0x7f4(%edx),%edx
 433:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 437:	89 c2                	mov    %eax,%edx
 439:	85 c0                	test   %eax,%eax
 43b:	75 e1                	jne    41e <printint+0x2e>
  if(neg)
 43d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 441:	74 08                	je     44b <printint+0x5b>
    buf[i++] = '-';
 443:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 448:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 44b:	83 eb 01             	sub    $0x1,%ebx
 44e:	78 22                	js     472 <printint+0x82>
  write(fd, &c, 1);
 450:	8d 7d d7             	lea    -0x29(%ebp),%edi
 453:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 458:	88 45 d7             	mov    %al,-0x29(%ebp)
 45b:	83 ec 04             	sub    $0x4,%esp
 45e:	6a 01                	push   $0x1
 460:	57                   	push   %edi
 461:	56                   	push   %esi
 462:	e8 c9 fe ff ff       	call   330 <write>
  while(--i >= 0)
 467:	83 eb 01             	sub    $0x1,%ebx
 46a:	83 c4 10             	add    $0x10,%esp
 46d:	83 fb ff             	cmp    $0xffffffff,%ebx
 470:	75 e1                	jne    453 <printint+0x63>
    putc(fd, buf[i]);
}
 472:	8d 65 f4             	lea    -0xc(%ebp),%esp
 475:	5b                   	pop    %ebx
 476:	5e                   	pop    %esi
 477:	5f                   	pop    %edi
 478:	5d                   	pop    %ebp
 479:	c3                   	ret    

0000047a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 47a:	55                   	push   %ebp
 47b:	89 e5                	mov    %esp,%ebp
 47d:	57                   	push   %edi
 47e:	56                   	push   %esi
 47f:	53                   	push   %ebx
 480:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 483:	8b 75 0c             	mov    0xc(%ebp),%esi
 486:	0f b6 1e             	movzbl (%esi),%ebx
 489:	84 db                	test   %bl,%bl
 48b:	0f 84 b1 01 00 00    	je     642 <printf+0x1c8>
 491:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 494:	8d 45 10             	lea    0x10(%ebp),%eax
 497:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 49a:	bf 00 00 00 00       	mov    $0x0,%edi
 49f:	eb 2d                	jmp    4ce <printf+0x54>
 4a1:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 4a4:	83 ec 04             	sub    $0x4,%esp
 4a7:	6a 01                	push   $0x1
 4a9:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4ac:	50                   	push   %eax
 4ad:	ff 75 08             	pushl  0x8(%ebp)
 4b0:	e8 7b fe ff ff       	call   330 <write>
 4b5:	83 c4 10             	add    $0x10,%esp
 4b8:	eb 05                	jmp    4bf <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ba:	83 ff 25             	cmp    $0x25,%edi
 4bd:	74 22                	je     4e1 <printf+0x67>
 4bf:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4c2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4c6:	84 db                	test   %bl,%bl
 4c8:	0f 84 74 01 00 00    	je     642 <printf+0x1c8>
    c = fmt[i] & 0xff;
 4ce:	0f be d3             	movsbl %bl,%edx
 4d1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4d4:	85 ff                	test   %edi,%edi
 4d6:	75 e2                	jne    4ba <printf+0x40>
      if(c == '%'){
 4d8:	83 f8 25             	cmp    $0x25,%eax
 4db:	75 c4                	jne    4a1 <printf+0x27>
        state = '%';
 4dd:	89 c7                	mov    %eax,%edi
 4df:	eb de                	jmp    4bf <printf+0x45>
      if(c == 'd'){
 4e1:	83 f8 64             	cmp    $0x64,%eax
 4e4:	74 59                	je     53f <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4e6:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 4ec:	83 fa 70             	cmp    $0x70,%edx
 4ef:	74 7a                	je     56b <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4f1:	83 f8 73             	cmp    $0x73,%eax
 4f4:	0f 84 9d 00 00 00    	je     597 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4fa:	83 f8 63             	cmp    $0x63,%eax
 4fd:	0f 84 f2 00 00 00    	je     5f5 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 503:	83 f8 25             	cmp    $0x25,%eax
 506:	0f 84 15 01 00 00    	je     621 <printf+0x1a7>
 50c:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 510:	83 ec 04             	sub    $0x4,%esp
 513:	6a 01                	push   $0x1
 515:	8d 45 e7             	lea    -0x19(%ebp),%eax
 518:	50                   	push   %eax
 519:	ff 75 08             	pushl  0x8(%ebp)
 51c:	e8 0f fe ff ff       	call   330 <write>
 521:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 524:	83 c4 0c             	add    $0xc,%esp
 527:	6a 01                	push   $0x1
 529:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 52c:	50                   	push   %eax
 52d:	ff 75 08             	pushl  0x8(%ebp)
 530:	e8 fb fd ff ff       	call   330 <write>
 535:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 538:	bf 00 00 00 00       	mov    $0x0,%edi
 53d:	eb 80                	jmp    4bf <printf+0x45>
        printint(fd, *ap, 10, 1);
 53f:	83 ec 0c             	sub    $0xc,%esp
 542:	6a 01                	push   $0x1
 544:	b9 0a 00 00 00       	mov    $0xa,%ecx
 549:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 54c:	8b 17                	mov    (%edi),%edx
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	e8 9a fe ff ff       	call   3f0 <printint>
        ap++;
 556:	89 f8                	mov    %edi,%eax
 558:	83 c0 04             	add    $0x4,%eax
 55b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 55e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 561:	bf 00 00 00 00       	mov    $0x0,%edi
 566:	e9 54 ff ff ff       	jmp    4bf <printf+0x45>
        printint(fd, *ap, 16, 0);
 56b:	83 ec 0c             	sub    $0xc,%esp
 56e:	6a 00                	push   $0x0
 570:	b9 10 00 00 00       	mov    $0x10,%ecx
 575:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 578:	8b 17                	mov    (%edi),%edx
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	e8 6e fe ff ff       	call   3f0 <printint>
        ap++;
 582:	89 f8                	mov    %edi,%eax
 584:	83 c0 04             	add    $0x4,%eax
 587:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 58a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58d:	bf 00 00 00 00       	mov    $0x0,%edi
 592:	e9 28 ff ff ff       	jmp    4bf <printf+0x45>
        s = (char*)*ap;
 597:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 59a:	8b 01                	mov    (%ecx),%eax
        ap++;
 59c:	83 c1 04             	add    $0x4,%ecx
 59f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 5a2:	85 c0                	test   %eax,%eax
 5a4:	74 13                	je     5b9 <printf+0x13f>
        s = (char*)*ap;
 5a6:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 5a8:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 5ab:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 5b0:	84 c0                	test   %al,%al
 5b2:	75 0f                	jne    5c3 <printf+0x149>
 5b4:	e9 06 ff ff ff       	jmp    4bf <printf+0x45>
          s = "(null)";
 5b9:	bb ec 07 00 00       	mov    $0x7ec,%ebx
        while(*s != 0){
 5be:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 5c3:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 5c6:	89 75 d0             	mov    %esi,-0x30(%ebp)
 5c9:	8b 75 08             	mov    0x8(%ebp),%esi
 5cc:	88 45 e3             	mov    %al,-0x1d(%ebp)
 5cf:	83 ec 04             	sub    $0x4,%esp
 5d2:	6a 01                	push   $0x1
 5d4:	57                   	push   %edi
 5d5:	56                   	push   %esi
 5d6:	e8 55 fd ff ff       	call   330 <write>
          s++;
 5db:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 5de:	0f b6 03             	movzbl (%ebx),%eax
 5e1:	83 c4 10             	add    $0x10,%esp
 5e4:	84 c0                	test   %al,%al
 5e6:	75 e4                	jne    5cc <printf+0x152>
 5e8:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 5eb:	bf 00 00 00 00       	mov    $0x0,%edi
 5f0:	e9 ca fe ff ff       	jmp    4bf <printf+0x45>
        putc(fd, *ap);
 5f5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5f8:	8b 07                	mov    (%edi),%eax
 5fa:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5fd:	83 ec 04             	sub    $0x4,%esp
 600:	6a 01                	push   $0x1
 602:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 605:	50                   	push   %eax
 606:	ff 75 08             	pushl  0x8(%ebp)
 609:	e8 22 fd ff ff       	call   330 <write>
        ap++;
 60e:	83 c7 04             	add    $0x4,%edi
 611:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 614:	83 c4 10             	add    $0x10,%esp
      state = 0;
 617:	bf 00 00 00 00       	mov    $0x0,%edi
 61c:	e9 9e fe ff ff       	jmp    4bf <printf+0x45>
 621:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 624:	83 ec 04             	sub    $0x4,%esp
 627:	6a 01                	push   $0x1
 629:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 62c:	50                   	push   %eax
 62d:	ff 75 08             	pushl  0x8(%ebp)
 630:	e8 fb fc ff ff       	call   330 <write>
 635:	83 c4 10             	add    $0x10,%esp
      state = 0;
 638:	bf 00 00 00 00       	mov    $0x0,%edi
 63d:	e9 7d fe ff ff       	jmp    4bf <printf+0x45>
    }
  }
}
 642:	8d 65 f4             	lea    -0xc(%ebp),%esp
 645:	5b                   	pop    %ebx
 646:	5e                   	pop    %esi
 647:	5f                   	pop    %edi
 648:	5d                   	pop    %ebp
 649:	c3                   	ret    

0000064a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64a:	55                   	push   %ebp
 64b:	89 e5                	mov    %esp,%ebp
 64d:	57                   	push   %edi
 64e:	56                   	push   %esi
 64f:	53                   	push   %ebx
 650:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 653:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 656:	a1 98 0a 00 00       	mov    0xa98,%eax
 65b:	eb 0c                	jmp    669 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65d:	8b 10                	mov    (%eax),%edx
 65f:	39 c2                	cmp    %eax,%edx
 661:	77 04                	ja     667 <free+0x1d>
 663:	39 ca                	cmp    %ecx,%edx
 665:	77 10                	ja     677 <free+0x2d>
{
 667:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 669:	39 c8                	cmp    %ecx,%eax
 66b:	73 f0                	jae    65d <free+0x13>
 66d:	8b 10                	mov    (%eax),%edx
 66f:	39 ca                	cmp    %ecx,%edx
 671:	77 04                	ja     677 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 673:	39 c2                	cmp    %eax,%edx
 675:	77 f0                	ja     667 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 677:	8b 73 fc             	mov    -0x4(%ebx),%esi
 67a:	8b 10                	mov    (%eax),%edx
 67c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 67f:	39 fa                	cmp    %edi,%edx
 681:	74 19                	je     69c <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 683:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 686:	8b 50 04             	mov    0x4(%eax),%edx
 689:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 68c:	39 f1                	cmp    %esi,%ecx
 68e:	74 1b                	je     6ab <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 690:	89 08                	mov    %ecx,(%eax)
  freep = p;
 692:	a3 98 0a 00 00       	mov    %eax,0xa98
}
 697:	5b                   	pop    %ebx
 698:	5e                   	pop    %esi
 699:	5f                   	pop    %edi
 69a:	5d                   	pop    %ebp
 69b:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 69c:	03 72 04             	add    0x4(%edx),%esi
 69f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	8b 12                	mov    (%edx),%edx
 6a6:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6a9:	eb db                	jmp    686 <free+0x3c>
    p->s.size += bp->s.size;
 6ab:	03 53 fc             	add    -0x4(%ebx),%edx
 6ae:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b1:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6b4:	89 10                	mov    %edx,(%eax)
 6b6:	eb da                	jmp    692 <free+0x48>

000006b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	57                   	push   %edi
 6bc:	56                   	push   %esi
 6bd:	53                   	push   %ebx
 6be:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c1:	8b 45 08             	mov    0x8(%ebp),%eax
 6c4:	8d 58 07             	lea    0x7(%eax),%ebx
 6c7:	c1 eb 03             	shr    $0x3,%ebx
 6ca:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6cd:	8b 15 98 0a 00 00    	mov    0xa98,%edx
 6d3:	85 d2                	test   %edx,%edx
 6d5:	74 20                	je     6f7 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d7:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6d9:	8b 48 04             	mov    0x4(%eax),%ecx
 6dc:	39 cb                	cmp    %ecx,%ebx
 6de:	76 3c                	jbe    71c <malloc+0x64>
 6e0:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6e6:	be 00 10 00 00       	mov    $0x1000,%esi
 6eb:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 6ee:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 6f5:	eb 70                	jmp    767 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 6f7:	c7 05 98 0a 00 00 9c 	movl   $0xa9c,0xa98
 6fe:	0a 00 00 
 701:	c7 05 9c 0a 00 00 9c 	movl   $0xa9c,0xa9c
 708:	0a 00 00 
    base.s.size = 0;
 70b:	c7 05 a0 0a 00 00 00 	movl   $0x0,0xaa0
 712:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 715:	ba 9c 0a 00 00       	mov    $0xa9c,%edx
 71a:	eb bb                	jmp    6d7 <malloc+0x1f>
      if(p->s.size == nunits)
 71c:	39 cb                	cmp    %ecx,%ebx
 71e:	74 1c                	je     73c <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 720:	29 d9                	sub    %ebx,%ecx
 722:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 725:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 728:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 72b:	89 15 98 0a 00 00    	mov    %edx,0xa98
      return (void*)(p + 1);
 731:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 734:	8d 65 f4             	lea    -0xc(%ebp),%esp
 737:	5b                   	pop    %ebx
 738:	5e                   	pop    %esi
 739:	5f                   	pop    %edi
 73a:	5d                   	pop    %ebp
 73b:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 73c:	8b 08                	mov    (%eax),%ecx
 73e:	89 0a                	mov    %ecx,(%edx)
 740:	eb e9                	jmp    72b <malloc+0x73>
  hp->s.size = nu;
 742:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 745:	83 ec 0c             	sub    $0xc,%esp
 748:	83 c0 08             	add    $0x8,%eax
 74b:	50                   	push   %eax
 74c:	e8 f9 fe ff ff       	call   64a <free>
  return freep;
 751:	8b 15 98 0a 00 00    	mov    0xa98,%edx
      if((p = morecore(nunits)) == 0)
 757:	83 c4 10             	add    $0x10,%esp
 75a:	85 d2                	test   %edx,%edx
 75c:	74 2b                	je     789 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 760:	8b 48 04             	mov    0x4(%eax),%ecx
 763:	39 d9                	cmp    %ebx,%ecx
 765:	73 b5                	jae    71c <malloc+0x64>
 767:	89 c2                	mov    %eax,%edx
    if(p == freep)
 769:	39 05 98 0a 00 00    	cmp    %eax,0xa98
 76f:	75 ed                	jne    75e <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 771:	83 ec 0c             	sub    $0xc,%esp
 774:	57                   	push   %edi
 775:	e8 1e fc ff ff       	call   398 <sbrk>
  if(p == (char*)-1)
 77a:	83 c4 10             	add    $0x10,%esp
 77d:	83 f8 ff             	cmp    $0xffffffff,%eax
 780:	75 c0                	jne    742 <malloc+0x8a>
        return 0;
 782:	b8 00 00 00 00       	mov    $0x0,%eax
 787:	eb ab                	jmp    734 <malloc+0x7c>
 789:	b8 00 00 00 00       	mov    $0x0,%eax
 78e:	eb a4                	jmp    734 <malloc+0x7c>
