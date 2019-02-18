
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 6d 02 00 00       	call   283 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7f 05                	jg     1f <main+0x1f>
    sleep(5);  // Let child exit before parent.
  exit();
  1a:	e8 6c 02 00 00       	call   28b <exit>
    sleep(5);  // Let child exit before parent.
  1f:	83 ec 0c             	sub    $0xc,%esp
  22:	6a 05                	push   $0x5
  24:	e8 f2 02 00 00       	call   31b <sleep>
  29:	83 c4 10             	add    $0x10,%esp
  2c:	eb ec                	jmp    1a <main+0x1a>

0000002e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  2e:	55                   	push   %ebp
  2f:	89 e5                	mov    %esp,%ebp
  31:	53                   	push   %ebx
  32:	8b 45 08             	mov    0x8(%ebp),%eax
  35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  38:	89 c2                	mov    %eax,%edx
  3a:	83 c1 01             	add    $0x1,%ecx
  3d:	83 c2 01             	add    $0x1,%edx
  40:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  44:	88 5a ff             	mov    %bl,-0x1(%edx)
  47:	84 db                	test   %bl,%bl
  49:	75 ef                	jne    3a <strcpy+0xc>
    ;
  return os;
}
  4b:	5b                   	pop    %ebx
  4c:	5d                   	pop    %ebp
  4d:	c3                   	ret    

0000004e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4e:	55                   	push   %ebp
  4f:	89 e5                	mov    %esp,%ebp
  51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  54:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  57:	0f b6 01             	movzbl (%ecx),%eax
  5a:	84 c0                	test   %al,%al
  5c:	74 15                	je     73 <strcmp+0x25>
  5e:	3a 02                	cmp    (%edx),%al
  60:	75 11                	jne    73 <strcmp+0x25>
    p++, q++;
  62:	83 c1 01             	add    $0x1,%ecx
  65:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  68:	0f b6 01             	movzbl (%ecx),%eax
  6b:	84 c0                	test   %al,%al
  6d:	74 04                	je     73 <strcmp+0x25>
  6f:	3a 02                	cmp    (%edx),%al
  71:	74 ef                	je     62 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  73:	0f b6 c0             	movzbl %al,%eax
  76:	0f b6 12             	movzbl (%edx),%edx
  79:	29 d0                	sub    %edx,%eax
}
  7b:	5d                   	pop    %ebp
  7c:	c3                   	ret    

0000007d <strlen>:

uint
strlen(char *s)
{
  7d:	55                   	push   %ebp
  7e:	89 e5                	mov    %esp,%ebp
  80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  83:	80 39 00             	cmpb   $0x0,(%ecx)
  86:	74 12                	je     9a <strlen+0x1d>
  88:	ba 00 00 00 00       	mov    $0x0,%edx
  8d:	83 c2 01             	add    $0x1,%edx
  90:	89 d0                	mov    %edx,%eax
  92:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  96:	75 f5                	jne    8d <strlen+0x10>
    ;
  return n;
}
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    
  for(n = 0; s[n]; n++)
  9a:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  9f:	eb f7                	jmp    98 <strlen+0x1b>

000000a1 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	57                   	push   %edi
  a5:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  a8:	89 d7                	mov    %edx,%edi
  aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  b0:	fc                   	cld    
  b1:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b3:	89 d0                	mov    %edx,%eax
  b5:	5f                   	pop    %edi
  b6:	5d                   	pop    %ebp
  b7:	c3                   	ret    

000000b8 <strchr>:

char*
strchr(const char *s, char c)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	53                   	push   %ebx
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  c2:	0f b6 10             	movzbl (%eax),%edx
  c5:	84 d2                	test   %dl,%dl
  c7:	74 1e                	je     e7 <strchr+0x2f>
  c9:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
  cb:	38 d3                	cmp    %dl,%bl
  cd:	74 15                	je     e4 <strchr+0x2c>
  for(; *s; s++)
  cf:	83 c0 01             	add    $0x1,%eax
  d2:	0f b6 10             	movzbl (%eax),%edx
  d5:	84 d2                	test   %dl,%dl
  d7:	74 06                	je     df <strchr+0x27>
    if(*s == c)
  d9:	38 ca                	cmp    %cl,%dl
  db:	75 f2                	jne    cf <strchr+0x17>
  dd:	eb 05                	jmp    e4 <strchr+0x2c>
      return (char*)s;
  return 0;
  df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e4:	5b                   	pop    %ebx
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  return 0;
  e7:	b8 00 00 00 00       	mov    $0x0,%eax
  ec:	eb f6                	jmp    e4 <strchr+0x2c>

000000ee <gets>:

char*
gets(char *buf, int max)
{
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	57                   	push   %edi
  f2:	56                   	push   %esi
  f3:	53                   	push   %ebx
  f4:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f7:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
  fc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
  ff:	8d 5e 01             	lea    0x1(%esi),%ebx
 102:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 105:	7d 2b                	jge    132 <gets+0x44>
    cc = read(0, &c, 1);
 107:	83 ec 04             	sub    $0x4,%esp
 10a:	6a 01                	push   $0x1
 10c:	57                   	push   %edi
 10d:	6a 00                	push   $0x0
 10f:	e8 8f 01 00 00       	call   2a3 <read>
    if(cc < 1)
 114:	83 c4 10             	add    $0x10,%esp
 117:	85 c0                	test   %eax,%eax
 119:	7e 17                	jle    132 <gets+0x44>
      break;
    buf[i++] = c;
 11b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 11f:	8b 55 08             	mov    0x8(%ebp),%edx
 122:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 126:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 128:	3c 0a                	cmp    $0xa,%al
 12a:	74 04                	je     130 <gets+0x42>
 12c:	3c 0d                	cmp    $0xd,%al
 12e:	75 cf                	jne    ff <gets+0x11>
  for(i=0; i+1 < max; ){
 130:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 132:	8b 45 08             	mov    0x8(%ebp),%eax
 135:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 139:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13c:	5b                   	pop    %ebx
 13d:	5e                   	pop    %esi
 13e:	5f                   	pop    %edi
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    

00000141 <stat>:

int
stat(char *n, struct stat *st)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	56                   	push   %esi
 145:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 146:	83 ec 08             	sub    $0x8,%esp
 149:	6a 00                	push   $0x0
 14b:	ff 75 08             	pushl  0x8(%ebp)
 14e:	e8 78 01 00 00       	call   2cb <open>
  if(fd < 0)
 153:	83 c4 10             	add    $0x10,%esp
 156:	85 c0                	test   %eax,%eax
 158:	78 24                	js     17e <stat+0x3d>
 15a:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 15c:	83 ec 08             	sub    $0x8,%esp
 15f:	ff 75 0c             	pushl  0xc(%ebp)
 162:	50                   	push   %eax
 163:	e8 7b 01 00 00       	call   2e3 <fstat>
 168:	89 c6                	mov    %eax,%esi
  close(fd);
 16a:	89 1c 24             	mov    %ebx,(%esp)
 16d:	e8 41 01 00 00       	call   2b3 <close>
  return r;
 172:	83 c4 10             	add    $0x10,%esp
}
 175:	89 f0                	mov    %esi,%eax
 177:	8d 65 f8             	lea    -0x8(%ebp),%esp
 17a:	5b                   	pop    %ebx
 17b:	5e                   	pop    %esi
 17c:	5d                   	pop    %ebp
 17d:	c3                   	ret    
    return -1;
 17e:	be ff ff ff ff       	mov    $0xffffffff,%esi
 183:	eb f0                	jmp    175 <stat+0x34>

00000185 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	56                   	push   %esi
 189:	53                   	push   %ebx
 18a:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 18d:	0f b6 0a             	movzbl (%edx),%ecx
 190:	80 f9 20             	cmp    $0x20,%cl
 193:	75 0b                	jne    1a0 <atoi+0x1b>
 195:	83 c2 01             	add    $0x1,%edx
 198:	0f b6 0a             	movzbl (%edx),%ecx
 19b:	80 f9 20             	cmp    $0x20,%cl
 19e:	74 f5                	je     195 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 1a0:	80 f9 2d             	cmp    $0x2d,%cl
 1a3:	74 3b                	je     1e0 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 1a5:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 1a8:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 1ad:	f6 c1 fd             	test   $0xfd,%cl
 1b0:	74 33                	je     1e5 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 1b2:	0f b6 0a             	movzbl (%edx),%ecx
 1b5:	8d 41 d0             	lea    -0x30(%ecx),%eax
 1b8:	3c 09                	cmp    $0x9,%al
 1ba:	77 2e                	ja     1ea <atoi+0x65>
 1bc:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1c1:	83 c2 01             	add    $0x1,%edx
 1c4:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1c7:	0f be c9             	movsbl %cl,%ecx
 1ca:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 1ce:	0f b6 0a             	movzbl (%edx),%ecx
 1d1:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1d4:	80 fb 09             	cmp    $0x9,%bl
 1d7:	76 e8                	jbe    1c1 <atoi+0x3c>
  return sign*n;
 1d9:	0f af c6             	imul   %esi,%eax
}
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5d                   	pop    %ebp
 1df:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 1e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 1e5:	83 c2 01             	add    $0x1,%edx
 1e8:	eb c8                	jmp    1b2 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 1ea:	b8 00 00 00 00       	mov    $0x0,%eax
 1ef:	eb e8                	jmp    1d9 <atoi+0x54>

000001f1 <atoo>:

int
atoo(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	56                   	push   %esi
 1f5:	53                   	push   %ebx
 1f6:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1f9:	0f b6 0a             	movzbl (%edx),%ecx
 1fc:	80 f9 20             	cmp    $0x20,%cl
 1ff:	75 0b                	jne    20c <atoo+0x1b>
 201:	83 c2 01             	add    $0x1,%edx
 204:	0f b6 0a             	movzbl (%edx),%ecx
 207:	80 f9 20             	cmp    $0x20,%cl
 20a:	74 f5                	je     201 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 20c:	80 f9 2d             	cmp    $0x2d,%cl
 20f:	74 38                	je     249 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 211:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 214:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 219:	f6 c1 fd             	test   $0xfd,%cl
 21c:	74 30                	je     24e <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 21e:	0f b6 0a             	movzbl (%edx),%ecx
 221:	8d 41 d0             	lea    -0x30(%ecx),%eax
 224:	3c 07                	cmp    $0x7,%al
 226:	77 2b                	ja     253 <atoo+0x62>
 228:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 22d:	83 c2 01             	add    $0x1,%edx
 230:	0f be c9             	movsbl %cl,%ecx
 233:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 237:	0f b6 0a             	movzbl (%edx),%ecx
 23a:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 23d:	80 fb 07             	cmp    $0x7,%bl
 240:	76 eb                	jbe    22d <atoo+0x3c>
  return sign*n;
 242:	0f af c6             	imul   %esi,%eax
}
 245:	5b                   	pop    %ebx
 246:	5e                   	pop    %esi
 247:	5d                   	pop    %ebp
 248:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 249:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 24e:	83 c2 01             	add    $0x1,%edx
 251:	eb cb                	jmp    21e <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 253:	b8 00 00 00 00       	mov    $0x0,%eax
 258:	eb e8                	jmp    242 <atoo+0x51>

0000025a <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 25a:	55                   	push   %ebp
 25b:	89 e5                	mov    %esp,%ebp
 25d:	56                   	push   %esi
 25e:	53                   	push   %ebx
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	8b 75 0c             	mov    0xc(%ebp),%esi
 265:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 268:	85 db                	test   %ebx,%ebx
 26a:	7e 13                	jle    27f <memmove+0x25>
 26c:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 271:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 275:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 278:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 27b:	39 d3                	cmp    %edx,%ebx
 27d:	75 f2                	jne    271 <memmove+0x17>
  return vdst;
}
 27f:	5b                   	pop    %ebx
 280:	5e                   	pop    %esi
 281:	5d                   	pop    %ebp
 282:	c3                   	ret    

00000283 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 283:	b8 01 00 00 00       	mov    $0x1,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <exit>:
SYSCALL(exit)
 28b:	b8 02 00 00 00       	mov    $0x2,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <wait>:
SYSCALL(wait)
 293:	b8 03 00 00 00       	mov    $0x3,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <pipe>:
SYSCALL(pipe)
 29b:	b8 04 00 00 00       	mov    $0x4,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <read>:
SYSCALL(read)
 2a3:	b8 05 00 00 00       	mov    $0x5,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <write>:
SYSCALL(write)
 2ab:	b8 10 00 00 00       	mov    $0x10,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <close>:
SYSCALL(close)
 2b3:	b8 15 00 00 00       	mov    $0x15,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <kill>:
SYSCALL(kill)
 2bb:	b8 06 00 00 00       	mov    $0x6,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <exec>:
SYSCALL(exec)
 2c3:	b8 07 00 00 00       	mov    $0x7,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <open>:
SYSCALL(open)
 2cb:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <mknod>:
SYSCALL(mknod)
 2d3:	b8 11 00 00 00       	mov    $0x11,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <unlink>:
SYSCALL(unlink)
 2db:	b8 12 00 00 00       	mov    $0x12,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <fstat>:
SYSCALL(fstat)
 2e3:	b8 08 00 00 00       	mov    $0x8,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <link>:
SYSCALL(link)
 2eb:	b8 13 00 00 00       	mov    $0x13,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <mkdir>:
SYSCALL(mkdir)
 2f3:	b8 14 00 00 00       	mov    $0x14,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <chdir>:
SYSCALL(chdir)
 2fb:	b8 09 00 00 00       	mov    $0x9,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <dup>:
SYSCALL(dup)
 303:	b8 0a 00 00 00       	mov    $0xa,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <getpid>:
SYSCALL(getpid)
 30b:	b8 0b 00 00 00       	mov    $0xb,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <sbrk>:
SYSCALL(sbrk)
 313:	b8 0c 00 00 00       	mov    $0xc,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <sleep>:
SYSCALL(sleep)
 31b:	b8 0d 00 00 00       	mov    $0xd,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <uptime>:
SYSCALL(uptime)
 323:	b8 0e 00 00 00       	mov    $0xe,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <halt>:
SYSCALL(halt)
 32b:	b8 16 00 00 00       	mov    $0x16,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <date>:
//proj1
SYSCALL(date)
 333:	b8 17 00 00 00       	mov    $0x17,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <getuid>:
//proj2
SYSCALL(getuid)
 33b:	b8 18 00 00 00       	mov    $0x18,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <getgid>:
SYSCALL(getgid)
 343:	b8 19 00 00 00       	mov    $0x19,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <getppid>:
SYSCALL(getppid)
 34b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <setuid>:
SYSCALL(setuid)
 353:	b8 1b 00 00 00       	mov    $0x1b,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <setgid>:
SYSCALL(setgid)
 35b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <getprocs>:
SYSCALL(getprocs)
 363:	b8 1d 00 00 00       	mov    $0x1d,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	57                   	push   %edi
 36f:	56                   	push   %esi
 370:	53                   	push   %ebx
 371:	83 ec 3c             	sub    $0x3c,%esp
 374:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 376:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 37a:	74 14                	je     390 <printint+0x25>
 37c:	85 d2                	test   %edx,%edx
 37e:	79 10                	jns    390 <printint+0x25>
    neg = 1;
    x = -xx;
 380:	f7 da                	neg    %edx
    neg = 1;
 382:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 389:	bf 00 00 00 00       	mov    $0x0,%edi
 38e:	eb 0b                	jmp    39b <printint+0x30>
  neg = 0;
 390:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 397:	eb f0                	jmp    389 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 399:	89 df                	mov    %ebx,%edi
 39b:	8d 5f 01             	lea    0x1(%edi),%ebx
 39e:	89 d0                	mov    %edx,%eax
 3a0:	ba 00 00 00 00       	mov    $0x0,%edx
 3a5:	f7 f1                	div    %ecx
 3a7:	0f b6 92 14 07 00 00 	movzbl 0x714(%edx),%edx
 3ae:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3b2:	89 c2                	mov    %eax,%edx
 3b4:	85 c0                	test   %eax,%eax
 3b6:	75 e1                	jne    399 <printint+0x2e>
  if(neg)
 3b8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3bc:	74 08                	je     3c6 <printint+0x5b>
    buf[i++] = '-';
 3be:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3c3:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3c6:	83 eb 01             	sub    $0x1,%ebx
 3c9:	78 22                	js     3ed <printint+0x82>
  write(fd, &c, 1);
 3cb:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3ce:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 3d3:	88 45 d7             	mov    %al,-0x29(%ebp)
 3d6:	83 ec 04             	sub    $0x4,%esp
 3d9:	6a 01                	push   $0x1
 3db:	57                   	push   %edi
 3dc:	56                   	push   %esi
 3dd:	e8 c9 fe ff ff       	call   2ab <write>
  while(--i >= 0)
 3e2:	83 eb 01             	sub    $0x1,%ebx
 3e5:	83 c4 10             	add    $0x10,%esp
 3e8:	83 fb ff             	cmp    $0xffffffff,%ebx
 3eb:	75 e1                	jne    3ce <printint+0x63>
    putc(fd, buf[i]);
}
 3ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f0:	5b                   	pop    %ebx
 3f1:	5e                   	pop    %esi
 3f2:	5f                   	pop    %edi
 3f3:	5d                   	pop    %ebp
 3f4:	c3                   	ret    

000003f5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f5:	55                   	push   %ebp
 3f6:	89 e5                	mov    %esp,%ebp
 3f8:	57                   	push   %edi
 3f9:	56                   	push   %esi
 3fa:	53                   	push   %ebx
 3fb:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3fe:	8b 75 0c             	mov    0xc(%ebp),%esi
 401:	0f b6 1e             	movzbl (%esi),%ebx
 404:	84 db                	test   %bl,%bl
 406:	0f 84 b1 01 00 00    	je     5bd <printf+0x1c8>
 40c:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 40f:	8d 45 10             	lea    0x10(%ebp),%eax
 412:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 415:	bf 00 00 00 00       	mov    $0x0,%edi
 41a:	eb 2d                	jmp    449 <printf+0x54>
 41c:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 41f:	83 ec 04             	sub    $0x4,%esp
 422:	6a 01                	push   $0x1
 424:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 427:	50                   	push   %eax
 428:	ff 75 08             	pushl  0x8(%ebp)
 42b:	e8 7b fe ff ff       	call   2ab <write>
 430:	83 c4 10             	add    $0x10,%esp
 433:	eb 05                	jmp    43a <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 435:	83 ff 25             	cmp    $0x25,%edi
 438:	74 22                	je     45c <printf+0x67>
 43a:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 43d:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 441:	84 db                	test   %bl,%bl
 443:	0f 84 74 01 00 00    	je     5bd <printf+0x1c8>
    c = fmt[i] & 0xff;
 449:	0f be d3             	movsbl %bl,%edx
 44c:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 44f:	85 ff                	test   %edi,%edi
 451:	75 e2                	jne    435 <printf+0x40>
      if(c == '%'){
 453:	83 f8 25             	cmp    $0x25,%eax
 456:	75 c4                	jne    41c <printf+0x27>
        state = '%';
 458:	89 c7                	mov    %eax,%edi
 45a:	eb de                	jmp    43a <printf+0x45>
      if(c == 'd'){
 45c:	83 f8 64             	cmp    $0x64,%eax
 45f:	74 59                	je     4ba <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 461:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 467:	83 fa 70             	cmp    $0x70,%edx
 46a:	74 7a                	je     4e6 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 46c:	83 f8 73             	cmp    $0x73,%eax
 46f:	0f 84 9d 00 00 00    	je     512 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 475:	83 f8 63             	cmp    $0x63,%eax
 478:	0f 84 f2 00 00 00    	je     570 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 47e:	83 f8 25             	cmp    $0x25,%eax
 481:	0f 84 15 01 00 00    	je     59c <printf+0x1a7>
 487:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 48b:	83 ec 04             	sub    $0x4,%esp
 48e:	6a 01                	push   $0x1
 490:	8d 45 e7             	lea    -0x19(%ebp),%eax
 493:	50                   	push   %eax
 494:	ff 75 08             	pushl  0x8(%ebp)
 497:	e8 0f fe ff ff       	call   2ab <write>
 49c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 49f:	83 c4 0c             	add    $0xc,%esp
 4a2:	6a 01                	push   $0x1
 4a4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4a7:	50                   	push   %eax
 4a8:	ff 75 08             	pushl  0x8(%ebp)
 4ab:	e8 fb fd ff ff       	call   2ab <write>
 4b0:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b3:	bf 00 00 00 00       	mov    $0x0,%edi
 4b8:	eb 80                	jmp    43a <printf+0x45>
        printint(fd, *ap, 10, 1);
 4ba:	83 ec 0c             	sub    $0xc,%esp
 4bd:	6a 01                	push   $0x1
 4bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4c4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4c7:	8b 17                	mov    (%edi),%edx
 4c9:	8b 45 08             	mov    0x8(%ebp),%eax
 4cc:	e8 9a fe ff ff       	call   36b <printint>
        ap++;
 4d1:	89 f8                	mov    %edi,%eax
 4d3:	83 c0 04             	add    $0x4,%eax
 4d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4dc:	bf 00 00 00 00       	mov    $0x0,%edi
 4e1:	e9 54 ff ff ff       	jmp    43a <printf+0x45>
        printint(fd, *ap, 16, 0);
 4e6:	83 ec 0c             	sub    $0xc,%esp
 4e9:	6a 00                	push   $0x0
 4eb:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4f3:	8b 17                	mov    (%edi),%edx
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	e8 6e fe ff ff       	call   36b <printint>
        ap++;
 4fd:	89 f8                	mov    %edi,%eax
 4ff:	83 c0 04             	add    $0x4,%eax
 502:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 505:	83 c4 10             	add    $0x10,%esp
      state = 0;
 508:	bf 00 00 00 00       	mov    $0x0,%edi
 50d:	e9 28 ff ff ff       	jmp    43a <printf+0x45>
        s = (char*)*ap;
 512:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 515:	8b 01                	mov    (%ecx),%eax
        ap++;
 517:	83 c1 04             	add    $0x4,%ecx
 51a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 51d:	85 c0                	test   %eax,%eax
 51f:	74 13                	je     534 <printf+0x13f>
        s = (char*)*ap;
 521:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 523:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 526:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 52b:	84 c0                	test   %al,%al
 52d:	75 0f                	jne    53e <printf+0x149>
 52f:	e9 06 ff ff ff       	jmp    43a <printf+0x45>
          s = "(null)";
 534:	bb 0c 07 00 00       	mov    $0x70c,%ebx
        while(*s != 0){
 539:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 53e:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 541:	89 75 d0             	mov    %esi,-0x30(%ebp)
 544:	8b 75 08             	mov    0x8(%ebp),%esi
 547:	88 45 e3             	mov    %al,-0x1d(%ebp)
 54a:	83 ec 04             	sub    $0x4,%esp
 54d:	6a 01                	push   $0x1
 54f:	57                   	push   %edi
 550:	56                   	push   %esi
 551:	e8 55 fd ff ff       	call   2ab <write>
          s++;
 556:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 559:	0f b6 03             	movzbl (%ebx),%eax
 55c:	83 c4 10             	add    $0x10,%esp
 55f:	84 c0                	test   %al,%al
 561:	75 e4                	jne    547 <printf+0x152>
 563:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 566:	bf 00 00 00 00       	mov    $0x0,%edi
 56b:	e9 ca fe ff ff       	jmp    43a <printf+0x45>
        putc(fd, *ap);
 570:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 573:	8b 07                	mov    (%edi),%eax
 575:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 578:	83 ec 04             	sub    $0x4,%esp
 57b:	6a 01                	push   $0x1
 57d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 580:	50                   	push   %eax
 581:	ff 75 08             	pushl  0x8(%ebp)
 584:	e8 22 fd ff ff       	call   2ab <write>
        ap++;
 589:	83 c7 04             	add    $0x4,%edi
 58c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 58f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 592:	bf 00 00 00 00       	mov    $0x0,%edi
 597:	e9 9e fe ff ff       	jmp    43a <printf+0x45>
 59c:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 59f:	83 ec 04             	sub    $0x4,%esp
 5a2:	6a 01                	push   $0x1
 5a4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5a7:	50                   	push   %eax
 5a8:	ff 75 08             	pushl  0x8(%ebp)
 5ab:	e8 fb fc ff ff       	call   2ab <write>
 5b0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b3:	bf 00 00 00 00       	mov    $0x0,%edi
 5b8:	e9 7d fe ff ff       	jmp    43a <printf+0x45>
    }
  }
}
 5bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c0:	5b                   	pop    %ebx
 5c1:	5e                   	pop    %esi
 5c2:	5f                   	pop    %edi
 5c3:	5d                   	pop    %ebp
 5c4:	c3                   	ret    

000005c5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c5:	55                   	push   %ebp
 5c6:	89 e5                	mov    %esp,%ebp
 5c8:	57                   	push   %edi
 5c9:	56                   	push   %esi
 5ca:	53                   	push   %ebx
 5cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 ac 09 00 00       	mov    0x9ac,%eax
 5d6:	eb 0c                	jmp    5e4 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d8:	8b 10                	mov    (%eax),%edx
 5da:	39 c2                	cmp    %eax,%edx
 5dc:	77 04                	ja     5e2 <free+0x1d>
 5de:	39 ca                	cmp    %ecx,%edx
 5e0:	77 10                	ja     5f2 <free+0x2d>
{
 5e2:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e4:	39 c8                	cmp    %ecx,%eax
 5e6:	73 f0                	jae    5d8 <free+0x13>
 5e8:	8b 10                	mov    (%eax),%edx
 5ea:	39 ca                	cmp    %ecx,%edx
 5ec:	77 04                	ja     5f2 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ee:	39 c2                	cmp    %eax,%edx
 5f0:	77 f0                	ja     5e2 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f2:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5f5:	8b 10                	mov    (%eax),%edx
 5f7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5fa:	39 fa                	cmp    %edi,%edx
 5fc:	74 19                	je     617 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5fe:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 601:	8b 50 04             	mov    0x4(%eax),%edx
 604:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 607:	39 f1                	cmp    %esi,%ecx
 609:	74 1b                	je     626 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 60b:	89 08                	mov    %ecx,(%eax)
  freep = p;
 60d:	a3 ac 09 00 00       	mov    %eax,0x9ac
}
 612:	5b                   	pop    %ebx
 613:	5e                   	pop    %esi
 614:	5f                   	pop    %edi
 615:	5d                   	pop    %ebp
 616:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 617:	03 72 04             	add    0x4(%edx),%esi
 61a:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 61d:	8b 10                	mov    (%eax),%edx
 61f:	8b 12                	mov    (%edx),%edx
 621:	89 53 f8             	mov    %edx,-0x8(%ebx)
 624:	eb db                	jmp    601 <free+0x3c>
    p->s.size += bp->s.size;
 626:	03 53 fc             	add    -0x4(%ebx),%edx
 629:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 62c:	8b 53 f8             	mov    -0x8(%ebx),%edx
 62f:	89 10                	mov    %edx,(%eax)
 631:	eb da                	jmp    60d <free+0x48>

00000633 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 633:	55                   	push   %ebp
 634:	89 e5                	mov    %esp,%ebp
 636:	57                   	push   %edi
 637:	56                   	push   %esi
 638:	53                   	push   %ebx
 639:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 63c:	8b 45 08             	mov    0x8(%ebp),%eax
 63f:	8d 58 07             	lea    0x7(%eax),%ebx
 642:	c1 eb 03             	shr    $0x3,%ebx
 645:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 648:	8b 15 ac 09 00 00    	mov    0x9ac,%edx
 64e:	85 d2                	test   %edx,%edx
 650:	74 20                	je     672 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 652:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 654:	8b 48 04             	mov    0x4(%eax),%ecx
 657:	39 cb                	cmp    %ecx,%ebx
 659:	76 3c                	jbe    697 <malloc+0x64>
 65b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 661:	be 00 10 00 00       	mov    $0x1000,%esi
 666:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 669:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 670:	eb 70                	jmp    6e2 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 672:	c7 05 ac 09 00 00 b0 	movl   $0x9b0,0x9ac
 679:	09 00 00 
 67c:	c7 05 b0 09 00 00 b0 	movl   $0x9b0,0x9b0
 683:	09 00 00 
    base.s.size = 0;
 686:	c7 05 b4 09 00 00 00 	movl   $0x0,0x9b4
 68d:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 690:	ba b0 09 00 00       	mov    $0x9b0,%edx
 695:	eb bb                	jmp    652 <malloc+0x1f>
      if(p->s.size == nunits)
 697:	39 cb                	cmp    %ecx,%ebx
 699:	74 1c                	je     6b7 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 69b:	29 d9                	sub    %ebx,%ecx
 69d:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6a0:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6a3:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6a6:	89 15 ac 09 00 00    	mov    %edx,0x9ac
      return (void*)(p + 1);
 6ac:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6b2:	5b                   	pop    %ebx
 6b3:	5e                   	pop    %esi
 6b4:	5f                   	pop    %edi
 6b5:	5d                   	pop    %ebp
 6b6:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6b7:	8b 08                	mov    (%eax),%ecx
 6b9:	89 0a                	mov    %ecx,(%edx)
 6bb:	eb e9                	jmp    6a6 <malloc+0x73>
  hp->s.size = nu;
 6bd:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	83 c0 08             	add    $0x8,%eax
 6c6:	50                   	push   %eax
 6c7:	e8 f9 fe ff ff       	call   5c5 <free>
  return freep;
 6cc:	8b 15 ac 09 00 00    	mov    0x9ac,%edx
      if((p = morecore(nunits)) == 0)
 6d2:	83 c4 10             	add    $0x10,%esp
 6d5:	85 d2                	test   %edx,%edx
 6d7:	74 2b                	je     704 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d9:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6db:	8b 48 04             	mov    0x4(%eax),%ecx
 6de:	39 d9                	cmp    %ebx,%ecx
 6e0:	73 b5                	jae    697 <malloc+0x64>
 6e2:	89 c2                	mov    %eax,%edx
    if(p == freep)
 6e4:	39 05 ac 09 00 00    	cmp    %eax,0x9ac
 6ea:	75 ed                	jne    6d9 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 6ec:	83 ec 0c             	sub    $0xc,%esp
 6ef:	57                   	push   %edi
 6f0:	e8 1e fc ff ff       	call   313 <sbrk>
  if(p == (char*)-1)
 6f5:	83 c4 10             	add    $0x10,%esp
 6f8:	83 f8 ff             	cmp    $0xffffffff,%eax
 6fb:	75 c0                	jne    6bd <malloc+0x8a>
        return 0;
 6fd:	b8 00 00 00 00       	mov    $0x0,%eax
 702:	eb ab                	jmp    6af <malloc+0x7c>
 704:	b8 00 00 00 00       	mov    $0x0,%eax
 709:	eb a4                	jmp    6af <malloc+0x7c>
