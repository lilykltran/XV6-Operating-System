
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "pdx.h"
#endif // PDX_XV6

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 01                	mov    (%ecx),%eax
  15:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 27                	jle    44 <main+0x44>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  23:	83 ec 0c             	sub    $0xc,%esp
  26:	ff 33                	pushl  (%ebx)
  28:	e8 82 01 00 00       	call   1af <atoi>
  2d:	89 04 24             	mov    %eax,(%esp)
  30:	e8 b0 02 00 00       	call   2e5 <kill>
  35:	83 c3 04             	add    $0x4,%ebx
  for(i=1; i<argc; i++)
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 f3                	cmp    %esi,%ebx
  3d:	75 e4                	jne    23 <main+0x23>
  exit();
  3f:	e8 71 02 00 00       	call   2b5 <exit>
    printf(2, "usage: kill pid...\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 38 07 00 00       	push   $0x738
  4c:	6a 02                	push   $0x2
  4e:	e8 cc 03 00 00       	call   41f <printf>
    exit();
  53:	e8 5d 02 00 00       	call   2b5 <exit>

00000058 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	53                   	push   %ebx
  5c:	8b 45 08             	mov    0x8(%ebp),%eax
  5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  62:	89 c2                	mov    %eax,%edx
  64:	83 c1 01             	add    $0x1,%ecx
  67:	83 c2 01             	add    $0x1,%edx
  6a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  6e:	88 5a ff             	mov    %bl,-0x1(%edx)
  71:	84 db                	test   %bl,%bl
  73:	75 ef                	jne    64 <strcpy+0xc>
    ;
  return os;
}
  75:	5b                   	pop    %ebx
  76:	5d                   	pop    %ebp
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  81:	0f b6 01             	movzbl (%ecx),%eax
  84:	84 c0                	test   %al,%al
  86:	74 15                	je     9d <strcmp+0x25>
  88:	3a 02                	cmp    (%edx),%al
  8a:	75 11                	jne    9d <strcmp+0x25>
    p++, q++;
  8c:	83 c1 01             	add    $0x1,%ecx
  8f:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  92:	0f b6 01             	movzbl (%ecx),%eax
  95:	84 c0                	test   %al,%al
  97:	74 04                	je     9d <strcmp+0x25>
  99:	3a 02                	cmp    (%edx),%al
  9b:	74 ef                	je     8c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  9d:	0f b6 c0             	movzbl %al,%eax
  a0:	0f b6 12             	movzbl (%edx),%edx
  a3:	29 d0                	sub    %edx,%eax
}
  a5:	5d                   	pop    %ebp
  a6:	c3                   	ret    

000000a7 <strlen>:

uint
strlen(char *s)
{
  a7:	55                   	push   %ebp
  a8:	89 e5                	mov    %esp,%ebp
  aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ad:	80 39 00             	cmpb   $0x0,(%ecx)
  b0:	74 12                	je     c4 <strlen+0x1d>
  b2:	ba 00 00 00 00       	mov    $0x0,%edx
  b7:	83 c2 01             	add    $0x1,%edx
  ba:	89 d0                	mov    %edx,%eax
  bc:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  c0:	75 f5                	jne    b7 <strlen+0x10>
    ;
  return n;
}
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    
  for(n = 0; s[n]; n++)
  c4:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  c9:	eb f7                	jmp    c2 <strlen+0x1b>

000000cb <memset>:

void*
memset(void *dst, int c, uint n)
{
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  ce:	57                   	push   %edi
  cf:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d2:	89 d7                	mov    %edx,%edi
  d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  da:	fc                   	cld    
  db:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  dd:	89 d0                	mov    %edx,%eax
  df:	5f                   	pop    %edi
  e0:	5d                   	pop    %ebp
  e1:	c3                   	ret    

000000e2 <strchr>:

char*
strchr(const char *s, char c)
{
  e2:	55                   	push   %ebp
  e3:	89 e5                	mov    %esp,%ebp
  e5:	53                   	push   %ebx
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
  e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  ec:	0f b6 10             	movzbl (%eax),%edx
  ef:	84 d2                	test   %dl,%dl
  f1:	74 1e                	je     111 <strchr+0x2f>
  f3:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
  f5:	38 d3                	cmp    %dl,%bl
  f7:	74 15                	je     10e <strchr+0x2c>
  for(; *s; s++)
  f9:	83 c0 01             	add    $0x1,%eax
  fc:	0f b6 10             	movzbl (%eax),%edx
  ff:	84 d2                	test   %dl,%dl
 101:	74 06                	je     109 <strchr+0x27>
    if(*s == c)
 103:	38 ca                	cmp    %cl,%dl
 105:	75 f2                	jne    f9 <strchr+0x17>
 107:	eb 05                	jmp    10e <strchr+0x2c>
      return (char*)s;
  return 0;
 109:	b8 00 00 00 00       	mov    $0x0,%eax
}
 10e:	5b                   	pop    %ebx
 10f:	5d                   	pop    %ebp
 110:	c3                   	ret    
  return 0;
 111:	b8 00 00 00 00       	mov    $0x0,%eax
 116:	eb f6                	jmp    10e <strchr+0x2c>

00000118 <gets>:

char*
gets(char *buf, int max)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	57                   	push   %edi
 11c:	56                   	push   %esi
 11d:	53                   	push   %ebx
 11e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 121:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 126:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 129:	8d 5e 01             	lea    0x1(%esi),%ebx
 12c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 12f:	7d 2b                	jge    15c <gets+0x44>
    cc = read(0, &c, 1);
 131:	83 ec 04             	sub    $0x4,%esp
 134:	6a 01                	push   $0x1
 136:	57                   	push   %edi
 137:	6a 00                	push   $0x0
 139:	e8 8f 01 00 00       	call   2cd <read>
    if(cc < 1)
 13e:	83 c4 10             	add    $0x10,%esp
 141:	85 c0                	test   %eax,%eax
 143:	7e 17                	jle    15c <gets+0x44>
      break;
    buf[i++] = c;
 145:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 149:	8b 55 08             	mov    0x8(%ebp),%edx
 14c:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 150:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 152:	3c 0a                	cmp    $0xa,%al
 154:	74 04                	je     15a <gets+0x42>
 156:	3c 0d                	cmp    $0xd,%al
 158:	75 cf                	jne    129 <gets+0x11>
  for(i=0; i+1 < max; ){
 15a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 163:	8d 65 f4             	lea    -0xc(%ebp),%esp
 166:	5b                   	pop    %ebx
 167:	5e                   	pop    %esi
 168:	5f                   	pop    %edi
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    

0000016b <stat>:

int
stat(char *n, struct stat *st)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	56                   	push   %esi
 16f:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 170:	83 ec 08             	sub    $0x8,%esp
 173:	6a 00                	push   $0x0
 175:	ff 75 08             	pushl  0x8(%ebp)
 178:	e8 78 01 00 00       	call   2f5 <open>
  if(fd < 0)
 17d:	83 c4 10             	add    $0x10,%esp
 180:	85 c0                	test   %eax,%eax
 182:	78 24                	js     1a8 <stat+0x3d>
 184:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 186:	83 ec 08             	sub    $0x8,%esp
 189:	ff 75 0c             	pushl  0xc(%ebp)
 18c:	50                   	push   %eax
 18d:	e8 7b 01 00 00       	call   30d <fstat>
 192:	89 c6                	mov    %eax,%esi
  close(fd);
 194:	89 1c 24             	mov    %ebx,(%esp)
 197:	e8 41 01 00 00       	call   2dd <close>
  return r;
 19c:	83 c4 10             	add    $0x10,%esp
}
 19f:	89 f0                	mov    %esi,%eax
 1a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a4:	5b                   	pop    %ebx
 1a5:	5e                   	pop    %esi
 1a6:	5d                   	pop    %ebp
 1a7:	c3                   	ret    
    return -1;
 1a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1ad:	eb f0                	jmp    19f <stat+0x34>

000001af <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
 1b2:	56                   	push   %esi
 1b3:	53                   	push   %ebx
 1b4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1b7:	0f b6 0a             	movzbl (%edx),%ecx
 1ba:	80 f9 20             	cmp    $0x20,%cl
 1bd:	75 0b                	jne    1ca <atoi+0x1b>
 1bf:	83 c2 01             	add    $0x1,%edx
 1c2:	0f b6 0a             	movzbl (%edx),%ecx
 1c5:	80 f9 20             	cmp    $0x20,%cl
 1c8:	74 f5                	je     1bf <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 1ca:	80 f9 2d             	cmp    $0x2d,%cl
 1cd:	74 3b                	je     20a <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 1cf:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 1d2:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 1d7:	f6 c1 fd             	test   $0xfd,%cl
 1da:	74 33                	je     20f <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 1dc:	0f b6 0a             	movzbl (%edx),%ecx
 1df:	8d 41 d0             	lea    -0x30(%ecx),%eax
 1e2:	3c 09                	cmp    $0x9,%al
 1e4:	77 2e                	ja     214 <atoi+0x65>
 1e6:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1eb:	83 c2 01             	add    $0x1,%edx
 1ee:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1f1:	0f be c9             	movsbl %cl,%ecx
 1f4:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 1f8:	0f b6 0a             	movzbl (%edx),%ecx
 1fb:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1fe:	80 fb 09             	cmp    $0x9,%bl
 201:	76 e8                	jbe    1eb <atoi+0x3c>
  return sign*n;
 203:	0f af c6             	imul   %esi,%eax
}
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5d                   	pop    %ebp
 209:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 20a:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 20f:	83 c2 01             	add    $0x1,%edx
 212:	eb c8                	jmp    1dc <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 214:	b8 00 00 00 00       	mov    $0x0,%eax
 219:	eb e8                	jmp    203 <atoi+0x54>

0000021b <atoo>:

int
atoo(const char *s)
{
 21b:	55                   	push   %ebp
 21c:	89 e5                	mov    %esp,%ebp
 21e:	56                   	push   %esi
 21f:	53                   	push   %ebx
 220:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 223:	0f b6 0a             	movzbl (%edx),%ecx
 226:	80 f9 20             	cmp    $0x20,%cl
 229:	75 0b                	jne    236 <atoo+0x1b>
 22b:	83 c2 01             	add    $0x1,%edx
 22e:	0f b6 0a             	movzbl (%edx),%ecx
 231:	80 f9 20             	cmp    $0x20,%cl
 234:	74 f5                	je     22b <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 236:	80 f9 2d             	cmp    $0x2d,%cl
 239:	74 38                	je     273 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 23b:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 23e:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 243:	f6 c1 fd             	test   $0xfd,%cl
 246:	74 30                	je     278 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 248:	0f b6 0a             	movzbl (%edx),%ecx
 24b:	8d 41 d0             	lea    -0x30(%ecx),%eax
 24e:	3c 07                	cmp    $0x7,%al
 250:	77 2b                	ja     27d <atoo+0x62>
 252:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 257:	83 c2 01             	add    $0x1,%edx
 25a:	0f be c9             	movsbl %cl,%ecx
 25d:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 261:	0f b6 0a             	movzbl (%edx),%ecx
 264:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 267:	80 fb 07             	cmp    $0x7,%bl
 26a:	76 eb                	jbe    257 <atoo+0x3c>
  return sign*n;
 26c:	0f af c6             	imul   %esi,%eax
}
 26f:	5b                   	pop    %ebx
 270:	5e                   	pop    %esi
 271:	5d                   	pop    %ebp
 272:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 273:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 278:	83 c2 01             	add    $0x1,%edx
 27b:	eb cb                	jmp    248 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 27d:	b8 00 00 00 00       	mov    $0x0,%eax
 282:	eb e8                	jmp    26c <atoo+0x51>

00000284 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	56                   	push   %esi
 288:	53                   	push   %ebx
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	8b 75 0c             	mov    0xc(%ebp),%esi
 28f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 292:	85 db                	test   %ebx,%ebx
 294:	7e 13                	jle    2a9 <memmove+0x25>
 296:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 29b:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 29f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2a2:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2a5:	39 d3                	cmp    %edx,%ebx
 2a7:	75 f2                	jne    29b <memmove+0x17>
  return vdst;
}
 2a9:	5b                   	pop    %ebx
 2aa:	5e                   	pop    %esi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    

000002ad <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ad:	b8 01 00 00 00       	mov    $0x1,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <exit>:
SYSCALL(exit)
 2b5:	b8 02 00 00 00       	mov    $0x2,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <wait>:
SYSCALL(wait)
 2bd:	b8 03 00 00 00       	mov    $0x3,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <pipe>:
SYSCALL(pipe)
 2c5:	b8 04 00 00 00       	mov    $0x4,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <read>:
SYSCALL(read)
 2cd:	b8 05 00 00 00       	mov    $0x5,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <write>:
SYSCALL(write)
 2d5:	b8 10 00 00 00       	mov    $0x10,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <close>:
SYSCALL(close)
 2dd:	b8 15 00 00 00       	mov    $0x15,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <kill>:
SYSCALL(kill)
 2e5:	b8 06 00 00 00       	mov    $0x6,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <exec>:
SYSCALL(exec)
 2ed:	b8 07 00 00 00       	mov    $0x7,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <open>:
SYSCALL(open)
 2f5:	b8 0f 00 00 00       	mov    $0xf,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <mknod>:
SYSCALL(mknod)
 2fd:	b8 11 00 00 00       	mov    $0x11,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <unlink>:
SYSCALL(unlink)
 305:	b8 12 00 00 00       	mov    $0x12,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <fstat>:
SYSCALL(fstat)
 30d:	b8 08 00 00 00       	mov    $0x8,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <link>:
SYSCALL(link)
 315:	b8 13 00 00 00       	mov    $0x13,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <mkdir>:
SYSCALL(mkdir)
 31d:	b8 14 00 00 00       	mov    $0x14,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <chdir>:
SYSCALL(chdir)
 325:	b8 09 00 00 00       	mov    $0x9,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <dup>:
SYSCALL(dup)
 32d:	b8 0a 00 00 00       	mov    $0xa,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <getpid>:
SYSCALL(getpid)
 335:	b8 0b 00 00 00       	mov    $0xb,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <sbrk>:
SYSCALL(sbrk)
 33d:	b8 0c 00 00 00       	mov    $0xc,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <sleep>:
SYSCALL(sleep)
 345:	b8 0d 00 00 00       	mov    $0xd,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <uptime>:
SYSCALL(uptime)
 34d:	b8 0e 00 00 00       	mov    $0xe,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <halt>:
SYSCALL(halt)
 355:	b8 16 00 00 00       	mov    $0x16,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <date>:
//proj1
SYSCALL(date)
 35d:	b8 17 00 00 00       	mov    $0x17,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <getuid>:
//proj2
SYSCALL(getuid)
 365:	b8 18 00 00 00       	mov    $0x18,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <getgid>:
SYSCALL(getgid)
 36d:	b8 19 00 00 00       	mov    $0x19,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <getppid>:
SYSCALL(getppid)
 375:	b8 1a 00 00 00       	mov    $0x1a,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <setuid>:
SYSCALL(setuid)
 37d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <setgid>:
SYSCALL(setgid)
 385:	b8 1c 00 00 00       	mov    $0x1c,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <getprocs>:
SYSCALL(getprocs)
 38d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 395:	55                   	push   %ebp
 396:	89 e5                	mov    %esp,%ebp
 398:	57                   	push   %edi
 399:	56                   	push   %esi
 39a:	53                   	push   %ebx
 39b:	83 ec 3c             	sub    $0x3c,%esp
 39e:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a4:	74 14                	je     3ba <printint+0x25>
 3a6:	85 d2                	test   %edx,%edx
 3a8:	79 10                	jns    3ba <printint+0x25>
    neg = 1;
    x = -xx;
 3aa:	f7 da                	neg    %edx
    neg = 1;
 3ac:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3b3:	bf 00 00 00 00       	mov    $0x0,%edi
 3b8:	eb 0b                	jmp    3c5 <printint+0x30>
  neg = 0;
 3ba:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3c1:	eb f0                	jmp    3b3 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 3c3:	89 df                	mov    %ebx,%edi
 3c5:	8d 5f 01             	lea    0x1(%edi),%ebx
 3c8:	89 d0                	mov    %edx,%eax
 3ca:	ba 00 00 00 00       	mov    $0x0,%edx
 3cf:	f7 f1                	div    %ecx
 3d1:	0f b6 92 54 07 00 00 	movzbl 0x754(%edx),%edx
 3d8:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3dc:	89 c2                	mov    %eax,%edx
 3de:	85 c0                	test   %eax,%eax
 3e0:	75 e1                	jne    3c3 <printint+0x2e>
  if(neg)
 3e2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3e6:	74 08                	je     3f0 <printint+0x5b>
    buf[i++] = '-';
 3e8:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3ed:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3f0:	83 eb 01             	sub    $0x1,%ebx
 3f3:	78 22                	js     417 <printint+0x82>
  write(fd, &c, 1);
 3f5:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3f8:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 3fd:	88 45 d7             	mov    %al,-0x29(%ebp)
 400:	83 ec 04             	sub    $0x4,%esp
 403:	6a 01                	push   $0x1
 405:	57                   	push   %edi
 406:	56                   	push   %esi
 407:	e8 c9 fe ff ff       	call   2d5 <write>
  while(--i >= 0)
 40c:	83 eb 01             	sub    $0x1,%ebx
 40f:	83 c4 10             	add    $0x10,%esp
 412:	83 fb ff             	cmp    $0xffffffff,%ebx
 415:	75 e1                	jne    3f8 <printint+0x63>
    putc(fd, buf[i]);
}
 417:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41a:	5b                   	pop    %ebx
 41b:	5e                   	pop    %esi
 41c:	5f                   	pop    %edi
 41d:	5d                   	pop    %ebp
 41e:	c3                   	ret    

0000041f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 41f:	55                   	push   %ebp
 420:	89 e5                	mov    %esp,%ebp
 422:	57                   	push   %edi
 423:	56                   	push   %esi
 424:	53                   	push   %ebx
 425:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 428:	8b 75 0c             	mov    0xc(%ebp),%esi
 42b:	0f b6 1e             	movzbl (%esi),%ebx
 42e:	84 db                	test   %bl,%bl
 430:	0f 84 b1 01 00 00    	je     5e7 <printf+0x1c8>
 436:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 439:	8d 45 10             	lea    0x10(%ebp),%eax
 43c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 43f:	bf 00 00 00 00       	mov    $0x0,%edi
 444:	eb 2d                	jmp    473 <printf+0x54>
 446:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 449:	83 ec 04             	sub    $0x4,%esp
 44c:	6a 01                	push   $0x1
 44e:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 451:	50                   	push   %eax
 452:	ff 75 08             	pushl  0x8(%ebp)
 455:	e8 7b fe ff ff       	call   2d5 <write>
 45a:	83 c4 10             	add    $0x10,%esp
 45d:	eb 05                	jmp    464 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45f:	83 ff 25             	cmp    $0x25,%edi
 462:	74 22                	je     486 <printf+0x67>
 464:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 467:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 46b:	84 db                	test   %bl,%bl
 46d:	0f 84 74 01 00 00    	je     5e7 <printf+0x1c8>
    c = fmt[i] & 0xff;
 473:	0f be d3             	movsbl %bl,%edx
 476:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 479:	85 ff                	test   %edi,%edi
 47b:	75 e2                	jne    45f <printf+0x40>
      if(c == '%'){
 47d:	83 f8 25             	cmp    $0x25,%eax
 480:	75 c4                	jne    446 <printf+0x27>
        state = '%';
 482:	89 c7                	mov    %eax,%edi
 484:	eb de                	jmp    464 <printf+0x45>
      if(c == 'd'){
 486:	83 f8 64             	cmp    $0x64,%eax
 489:	74 59                	je     4e4 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 48b:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 491:	83 fa 70             	cmp    $0x70,%edx
 494:	74 7a                	je     510 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 496:	83 f8 73             	cmp    $0x73,%eax
 499:	0f 84 9d 00 00 00    	je     53c <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 49f:	83 f8 63             	cmp    $0x63,%eax
 4a2:	0f 84 f2 00 00 00    	je     59a <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4a8:	83 f8 25             	cmp    $0x25,%eax
 4ab:	0f 84 15 01 00 00    	je     5c6 <printf+0x1a7>
 4b1:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4b5:	83 ec 04             	sub    $0x4,%esp
 4b8:	6a 01                	push   $0x1
 4ba:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4bd:	50                   	push   %eax
 4be:	ff 75 08             	pushl  0x8(%ebp)
 4c1:	e8 0f fe ff ff       	call   2d5 <write>
 4c6:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4c9:	83 c4 0c             	add    $0xc,%esp
 4cc:	6a 01                	push   $0x1
 4ce:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4d1:	50                   	push   %eax
 4d2:	ff 75 08             	pushl  0x8(%ebp)
 4d5:	e8 fb fd ff ff       	call   2d5 <write>
 4da:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4dd:	bf 00 00 00 00       	mov    $0x0,%edi
 4e2:	eb 80                	jmp    464 <printf+0x45>
        printint(fd, *ap, 10, 1);
 4e4:	83 ec 0c             	sub    $0xc,%esp
 4e7:	6a 01                	push   $0x1
 4e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4ee:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4f1:	8b 17                	mov    (%edi),%edx
 4f3:	8b 45 08             	mov    0x8(%ebp),%eax
 4f6:	e8 9a fe ff ff       	call   395 <printint>
        ap++;
 4fb:	89 f8                	mov    %edi,%eax
 4fd:	83 c0 04             	add    $0x4,%eax
 500:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 503:	83 c4 10             	add    $0x10,%esp
      state = 0;
 506:	bf 00 00 00 00       	mov    $0x0,%edi
 50b:	e9 54 ff ff ff       	jmp    464 <printf+0x45>
        printint(fd, *ap, 16, 0);
 510:	83 ec 0c             	sub    $0xc,%esp
 513:	6a 00                	push   $0x0
 515:	b9 10 00 00 00       	mov    $0x10,%ecx
 51a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 51d:	8b 17                	mov    (%edi),%edx
 51f:	8b 45 08             	mov    0x8(%ebp),%eax
 522:	e8 6e fe ff ff       	call   395 <printint>
        ap++;
 527:	89 f8                	mov    %edi,%eax
 529:	83 c0 04             	add    $0x4,%eax
 52c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 52f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 532:	bf 00 00 00 00       	mov    $0x0,%edi
 537:	e9 28 ff ff ff       	jmp    464 <printf+0x45>
        s = (char*)*ap;
 53c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 53f:	8b 01                	mov    (%ecx),%eax
        ap++;
 541:	83 c1 04             	add    $0x4,%ecx
 544:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 547:	85 c0                	test   %eax,%eax
 549:	74 13                	je     55e <printf+0x13f>
        s = (char*)*ap;
 54b:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 54d:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 550:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 555:	84 c0                	test   %al,%al
 557:	75 0f                	jne    568 <printf+0x149>
 559:	e9 06 ff ff ff       	jmp    464 <printf+0x45>
          s = "(null)";
 55e:	bb 4c 07 00 00       	mov    $0x74c,%ebx
        while(*s != 0){
 563:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 568:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 56b:	89 75 d0             	mov    %esi,-0x30(%ebp)
 56e:	8b 75 08             	mov    0x8(%ebp),%esi
 571:	88 45 e3             	mov    %al,-0x1d(%ebp)
 574:	83 ec 04             	sub    $0x4,%esp
 577:	6a 01                	push   $0x1
 579:	57                   	push   %edi
 57a:	56                   	push   %esi
 57b:	e8 55 fd ff ff       	call   2d5 <write>
          s++;
 580:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 583:	0f b6 03             	movzbl (%ebx),%eax
 586:	83 c4 10             	add    $0x10,%esp
 589:	84 c0                	test   %al,%al
 58b:	75 e4                	jne    571 <printf+0x152>
 58d:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 590:	bf 00 00 00 00       	mov    $0x0,%edi
 595:	e9 ca fe ff ff       	jmp    464 <printf+0x45>
        putc(fd, *ap);
 59a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 59d:	8b 07                	mov    (%edi),%eax
 59f:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5a2:	83 ec 04             	sub    $0x4,%esp
 5a5:	6a 01                	push   $0x1
 5a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5aa:	50                   	push   %eax
 5ab:	ff 75 08             	pushl  0x8(%ebp)
 5ae:	e8 22 fd ff ff       	call   2d5 <write>
        ap++;
 5b3:	83 c7 04             	add    $0x4,%edi
 5b6:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5b9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5bc:	bf 00 00 00 00       	mov    $0x0,%edi
 5c1:	e9 9e fe ff ff       	jmp    464 <printf+0x45>
 5c6:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 5c9:	83 ec 04             	sub    $0x4,%esp
 5cc:	6a 01                	push   $0x1
 5ce:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5d1:	50                   	push   %eax
 5d2:	ff 75 08             	pushl  0x8(%ebp)
 5d5:	e8 fb fc ff ff       	call   2d5 <write>
 5da:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5dd:	bf 00 00 00 00       	mov    $0x0,%edi
 5e2:	e9 7d fe ff ff       	jmp    464 <printf+0x45>
    }
  }
}
 5e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ea:	5b                   	pop    %ebx
 5eb:	5e                   	pop    %esi
 5ec:	5f                   	pop    %edi
 5ed:	5d                   	pop    %ebp
 5ee:	c3                   	ret    

000005ef <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ef:	55                   	push   %ebp
 5f0:	89 e5                	mov    %esp,%ebp
 5f2:	57                   	push   %edi
 5f3:	56                   	push   %esi
 5f4:	53                   	push   %ebx
 5f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f8:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fb:	a1 f4 09 00 00       	mov    0x9f4,%eax
 600:	eb 0c                	jmp    60e <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 602:	8b 10                	mov    (%eax),%edx
 604:	39 c2                	cmp    %eax,%edx
 606:	77 04                	ja     60c <free+0x1d>
 608:	39 ca                	cmp    %ecx,%edx
 60a:	77 10                	ja     61c <free+0x2d>
{
 60c:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60e:	39 c8                	cmp    %ecx,%eax
 610:	73 f0                	jae    602 <free+0x13>
 612:	8b 10                	mov    (%eax),%edx
 614:	39 ca                	cmp    %ecx,%edx
 616:	77 04                	ja     61c <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 618:	39 c2                	cmp    %eax,%edx
 61a:	77 f0                	ja     60c <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 61c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 61f:	8b 10                	mov    (%eax),%edx
 621:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 624:	39 fa                	cmp    %edi,%edx
 626:	74 19                	je     641 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 628:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 62b:	8b 50 04             	mov    0x4(%eax),%edx
 62e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 631:	39 f1                	cmp    %esi,%ecx
 633:	74 1b                	je     650 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 635:	89 08                	mov    %ecx,(%eax)
  freep = p;
 637:	a3 f4 09 00 00       	mov    %eax,0x9f4
}
 63c:	5b                   	pop    %ebx
 63d:	5e                   	pop    %esi
 63e:	5f                   	pop    %edi
 63f:	5d                   	pop    %ebp
 640:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 641:	03 72 04             	add    0x4(%edx),%esi
 644:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 647:	8b 10                	mov    (%eax),%edx
 649:	8b 12                	mov    (%edx),%edx
 64b:	89 53 f8             	mov    %edx,-0x8(%ebx)
 64e:	eb db                	jmp    62b <free+0x3c>
    p->s.size += bp->s.size;
 650:	03 53 fc             	add    -0x4(%ebx),%edx
 653:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 656:	8b 53 f8             	mov    -0x8(%ebx),%edx
 659:	89 10                	mov    %edx,(%eax)
 65b:	eb da                	jmp    637 <free+0x48>

0000065d <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 65d:	55                   	push   %ebp
 65e:	89 e5                	mov    %esp,%ebp
 660:	57                   	push   %edi
 661:	56                   	push   %esi
 662:	53                   	push   %ebx
 663:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 666:	8b 45 08             	mov    0x8(%ebp),%eax
 669:	8d 58 07             	lea    0x7(%eax),%ebx
 66c:	c1 eb 03             	shr    $0x3,%ebx
 66f:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 672:	8b 15 f4 09 00 00    	mov    0x9f4,%edx
 678:	85 d2                	test   %edx,%edx
 67a:	74 20                	je     69c <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 67c:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 67e:	8b 48 04             	mov    0x4(%eax),%ecx
 681:	39 cb                	cmp    %ecx,%ebx
 683:	76 3c                	jbe    6c1 <malloc+0x64>
 685:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 68b:	be 00 10 00 00       	mov    $0x1000,%esi
 690:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 693:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 69a:	eb 70                	jmp    70c <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 69c:	c7 05 f4 09 00 00 f8 	movl   $0x9f8,0x9f4
 6a3:	09 00 00 
 6a6:	c7 05 f8 09 00 00 f8 	movl   $0x9f8,0x9f8
 6ad:	09 00 00 
    base.s.size = 0;
 6b0:	c7 05 fc 09 00 00 00 	movl   $0x0,0x9fc
 6b7:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6ba:	ba f8 09 00 00       	mov    $0x9f8,%edx
 6bf:	eb bb                	jmp    67c <malloc+0x1f>
      if(p->s.size == nunits)
 6c1:	39 cb                	cmp    %ecx,%ebx
 6c3:	74 1c                	je     6e1 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6c5:	29 d9                	sub    %ebx,%ecx
 6c7:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6ca:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6cd:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6d0:	89 15 f4 09 00 00    	mov    %edx,0x9f4
      return (void*)(p + 1);
 6d6:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6dc:	5b                   	pop    %ebx
 6dd:	5e                   	pop    %esi
 6de:	5f                   	pop    %edi
 6df:	5d                   	pop    %ebp
 6e0:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6e1:	8b 08                	mov    (%eax),%ecx
 6e3:	89 0a                	mov    %ecx,(%edx)
 6e5:	eb e9                	jmp    6d0 <malloc+0x73>
  hp->s.size = nu;
 6e7:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6ea:	83 ec 0c             	sub    $0xc,%esp
 6ed:	83 c0 08             	add    $0x8,%eax
 6f0:	50                   	push   %eax
 6f1:	e8 f9 fe ff ff       	call   5ef <free>
  return freep;
 6f6:	8b 15 f4 09 00 00    	mov    0x9f4,%edx
      if((p = morecore(nunits)) == 0)
 6fc:	83 c4 10             	add    $0x10,%esp
 6ff:	85 d2                	test   %edx,%edx
 701:	74 2b                	je     72e <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 703:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 705:	8b 48 04             	mov    0x4(%eax),%ecx
 708:	39 d9                	cmp    %ebx,%ecx
 70a:	73 b5                	jae    6c1 <malloc+0x64>
 70c:	89 c2                	mov    %eax,%edx
    if(p == freep)
 70e:	39 05 f4 09 00 00    	cmp    %eax,0x9f4
 714:	75 ed                	jne    703 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 716:	83 ec 0c             	sub    $0xc,%esp
 719:	57                   	push   %edi
 71a:	e8 1e fc ff ff       	call   33d <sbrk>
  if(p == (char*)-1)
 71f:	83 c4 10             	add    $0x10,%esp
 722:	83 f8 ff             	cmp    $0xffffffff,%eax
 725:	75 c0                	jne    6e7 <malloc+0x8a>
        return 0;
 727:	b8 00 00 00 00       	mov    $0x0,%eax
 72c:	eb ab                	jmp    6d9 <malloc+0x7c>
 72e:	b8 00 00 00 00       	mov    $0x0,%eax
 733:	eb a4                	jmp    6d9 <malloc+0x7c>
