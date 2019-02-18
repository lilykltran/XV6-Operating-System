
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 14                	je     2b <main+0x2b>
    printf(2, "Usage: ln old new\n");
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	68 3c 07 00 00       	push   $0x73c
  1f:	6a 02                	push   $0x2
  21:	e8 fd 03 00 00       	call   423 <printf>
    exit();
  26:	e8 8e 02 00 00       	call   2b9 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2b:	83 ec 08             	sub    $0x8,%esp
  2e:	ff 73 08             	pushl  0x8(%ebx)
  31:	ff 73 04             	pushl  0x4(%ebx)
  34:	e8 e0 02 00 00       	call   319 <link>
  39:	83 c4 10             	add    $0x10,%esp
  3c:	85 c0                	test   %eax,%eax
  3e:	78 05                	js     45 <main+0x45>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  40:	e8 74 02 00 00       	call   2b9 <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  45:	ff 73 08             	pushl  0x8(%ebx)
  48:	ff 73 04             	pushl  0x4(%ebx)
  4b:	68 4f 07 00 00       	push   $0x74f
  50:	6a 02                	push   $0x2
  52:	e8 cc 03 00 00       	call   423 <printf>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	eb e4                	jmp    40 <main+0x40>

0000005c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	53                   	push   %ebx
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	89 c2                	mov    %eax,%edx
  68:	83 c1 01             	add    $0x1,%ecx
  6b:	83 c2 01             	add    $0x1,%edx
  6e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  72:	88 5a ff             	mov    %bl,-0x1(%edx)
  75:	84 db                	test   %bl,%bl
  77:	75 ef                	jne    68 <strcpy+0xc>
    ;
  return os;
}
  79:	5b                   	pop    %ebx
  7a:	5d                   	pop    %ebp
  7b:	c3                   	ret    

0000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  82:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  85:	0f b6 01             	movzbl (%ecx),%eax
  88:	84 c0                	test   %al,%al
  8a:	74 15                	je     a1 <strcmp+0x25>
  8c:	3a 02                	cmp    (%edx),%al
  8e:	75 11                	jne    a1 <strcmp+0x25>
    p++, q++;
  90:	83 c1 01             	add    $0x1,%ecx
  93:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  96:	0f b6 01             	movzbl (%ecx),%eax
  99:	84 c0                	test   %al,%al
  9b:	74 04                	je     a1 <strcmp+0x25>
  9d:	3a 02                	cmp    (%edx),%al
  9f:	74 ef                	je     90 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  a1:	0f b6 c0             	movzbl %al,%eax
  a4:	0f b6 12             	movzbl (%edx),%edx
  a7:	29 d0                	sub    %edx,%eax
}
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    

000000ab <strlen>:

uint
strlen(char *s)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  b1:	80 39 00             	cmpb   $0x0,(%ecx)
  b4:	74 12                	je     c8 <strlen+0x1d>
  b6:	ba 00 00 00 00       	mov    $0x0,%edx
  bb:	83 c2 01             	add    $0x1,%edx
  be:	89 d0                	mov    %edx,%eax
  c0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  c4:	75 f5                	jne    bb <strlen+0x10>
    ;
  return n;
}
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    
  for(n = 0; s[n]; n++)
  c8:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  cd:	eb f7                	jmp    c6 <strlen+0x1b>

000000cf <memset>:

void*
memset(void *dst, int c, uint n)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  d2:	57                   	push   %edi
  d3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d6:	89 d7                	mov    %edx,%edi
  d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  db:	8b 45 0c             	mov    0xc(%ebp),%eax
  de:	fc                   	cld    
  df:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e1:	89 d0                	mov    %edx,%eax
  e3:	5f                   	pop    %edi
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    

000000e6 <strchr>:

char*
strchr(const char *s, char c)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  e9:	53                   	push   %ebx
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  f0:	0f b6 10             	movzbl (%eax),%edx
  f3:	84 d2                	test   %dl,%dl
  f5:	74 1e                	je     115 <strchr+0x2f>
  f7:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
  f9:	38 d3                	cmp    %dl,%bl
  fb:	74 15                	je     112 <strchr+0x2c>
  for(; *s; s++)
  fd:	83 c0 01             	add    $0x1,%eax
 100:	0f b6 10             	movzbl (%eax),%edx
 103:	84 d2                	test   %dl,%dl
 105:	74 06                	je     10d <strchr+0x27>
    if(*s == c)
 107:	38 ca                	cmp    %cl,%dl
 109:	75 f2                	jne    fd <strchr+0x17>
 10b:	eb 05                	jmp    112 <strchr+0x2c>
      return (char*)s;
  return 0;
 10d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 112:	5b                   	pop    %ebx
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    
  return 0;
 115:	b8 00 00 00 00       	mov    $0x0,%eax
 11a:	eb f6                	jmp    112 <strchr+0x2c>

0000011c <gets>:

char*
gets(char *buf, int max)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	57                   	push   %edi
 120:	56                   	push   %esi
 121:	53                   	push   %ebx
 122:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 125:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 12a:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 12d:	8d 5e 01             	lea    0x1(%esi),%ebx
 130:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 133:	7d 2b                	jge    160 <gets+0x44>
    cc = read(0, &c, 1);
 135:	83 ec 04             	sub    $0x4,%esp
 138:	6a 01                	push   $0x1
 13a:	57                   	push   %edi
 13b:	6a 00                	push   $0x0
 13d:	e8 8f 01 00 00       	call   2d1 <read>
    if(cc < 1)
 142:	83 c4 10             	add    $0x10,%esp
 145:	85 c0                	test   %eax,%eax
 147:	7e 17                	jle    160 <gets+0x44>
      break;
    buf[i++] = c;
 149:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 14d:	8b 55 08             	mov    0x8(%ebp),%edx
 150:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 154:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 156:	3c 0a                	cmp    $0xa,%al
 158:	74 04                	je     15e <gets+0x42>
 15a:	3c 0d                	cmp    $0xd,%al
 15c:	75 cf                	jne    12d <gets+0x11>
  for(i=0; i+1 < max; ){
 15e:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 167:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16a:	5b                   	pop    %ebx
 16b:	5e                   	pop    %esi
 16c:	5f                   	pop    %edi
 16d:	5d                   	pop    %ebp
 16e:	c3                   	ret    

0000016f <stat>:

int
stat(char *n, struct stat *st)
{
 16f:	55                   	push   %ebp
 170:	89 e5                	mov    %esp,%ebp
 172:	56                   	push   %esi
 173:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 174:	83 ec 08             	sub    $0x8,%esp
 177:	6a 00                	push   $0x0
 179:	ff 75 08             	pushl  0x8(%ebp)
 17c:	e8 78 01 00 00       	call   2f9 <open>
  if(fd < 0)
 181:	83 c4 10             	add    $0x10,%esp
 184:	85 c0                	test   %eax,%eax
 186:	78 24                	js     1ac <stat+0x3d>
 188:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 18a:	83 ec 08             	sub    $0x8,%esp
 18d:	ff 75 0c             	pushl  0xc(%ebp)
 190:	50                   	push   %eax
 191:	e8 7b 01 00 00       	call   311 <fstat>
 196:	89 c6                	mov    %eax,%esi
  close(fd);
 198:	89 1c 24             	mov    %ebx,(%esp)
 19b:	e8 41 01 00 00       	call   2e1 <close>
  return r;
 1a0:	83 c4 10             	add    $0x10,%esp
}
 1a3:	89 f0                	mov    %esi,%eax
 1a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a8:	5b                   	pop    %ebx
 1a9:	5e                   	pop    %esi
 1aa:	5d                   	pop    %ebp
 1ab:	c3                   	ret    
    return -1;
 1ac:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b1:	eb f0                	jmp    1a3 <stat+0x34>

000001b3 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	56                   	push   %esi
 1b7:	53                   	push   %ebx
 1b8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1bb:	0f b6 0a             	movzbl (%edx),%ecx
 1be:	80 f9 20             	cmp    $0x20,%cl
 1c1:	75 0b                	jne    1ce <atoi+0x1b>
 1c3:	83 c2 01             	add    $0x1,%edx
 1c6:	0f b6 0a             	movzbl (%edx),%ecx
 1c9:	80 f9 20             	cmp    $0x20,%cl
 1cc:	74 f5                	je     1c3 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 1ce:	80 f9 2d             	cmp    $0x2d,%cl
 1d1:	74 3b                	je     20e <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 1d3:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 1d6:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 1db:	f6 c1 fd             	test   $0xfd,%cl
 1de:	74 33                	je     213 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 1e0:	0f b6 0a             	movzbl (%edx),%ecx
 1e3:	8d 41 d0             	lea    -0x30(%ecx),%eax
 1e6:	3c 09                	cmp    $0x9,%al
 1e8:	77 2e                	ja     218 <atoi+0x65>
 1ea:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1ef:	83 c2 01             	add    $0x1,%edx
 1f2:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1f5:	0f be c9             	movsbl %cl,%ecx
 1f8:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 1fc:	0f b6 0a             	movzbl (%edx),%ecx
 1ff:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 202:	80 fb 09             	cmp    $0x9,%bl
 205:	76 e8                	jbe    1ef <atoi+0x3c>
  return sign*n;
 207:	0f af c6             	imul   %esi,%eax
}
 20a:	5b                   	pop    %ebx
 20b:	5e                   	pop    %esi
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 20e:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 213:	83 c2 01             	add    $0x1,%edx
 216:	eb c8                	jmp    1e0 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 218:	b8 00 00 00 00       	mov    $0x0,%eax
 21d:	eb e8                	jmp    207 <atoi+0x54>

0000021f <atoo>:

int
atoo(const char *s)
{
 21f:	55                   	push   %ebp
 220:	89 e5                	mov    %esp,%ebp
 222:	56                   	push   %esi
 223:	53                   	push   %ebx
 224:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 227:	0f b6 0a             	movzbl (%edx),%ecx
 22a:	80 f9 20             	cmp    $0x20,%cl
 22d:	75 0b                	jne    23a <atoo+0x1b>
 22f:	83 c2 01             	add    $0x1,%edx
 232:	0f b6 0a             	movzbl (%edx),%ecx
 235:	80 f9 20             	cmp    $0x20,%cl
 238:	74 f5                	je     22f <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 23a:	80 f9 2d             	cmp    $0x2d,%cl
 23d:	74 38                	je     277 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 23f:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 242:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 247:	f6 c1 fd             	test   $0xfd,%cl
 24a:	74 30                	je     27c <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 24c:	0f b6 0a             	movzbl (%edx),%ecx
 24f:	8d 41 d0             	lea    -0x30(%ecx),%eax
 252:	3c 07                	cmp    $0x7,%al
 254:	77 2b                	ja     281 <atoo+0x62>
 256:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 25b:	83 c2 01             	add    $0x1,%edx
 25e:	0f be c9             	movsbl %cl,%ecx
 261:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 265:	0f b6 0a             	movzbl (%edx),%ecx
 268:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 26b:	80 fb 07             	cmp    $0x7,%bl
 26e:	76 eb                	jbe    25b <atoo+0x3c>
  return sign*n;
 270:	0f af c6             	imul   %esi,%eax
}
 273:	5b                   	pop    %ebx
 274:	5e                   	pop    %esi
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 277:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 27c:	83 c2 01             	add    $0x1,%edx
 27f:	eb cb                	jmp    24c <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 281:	b8 00 00 00 00       	mov    $0x0,%eax
 286:	eb e8                	jmp    270 <atoo+0x51>

00000288 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 288:	55                   	push   %ebp
 289:	89 e5                	mov    %esp,%ebp
 28b:	56                   	push   %esi
 28c:	53                   	push   %ebx
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	8b 75 0c             	mov    0xc(%ebp),%esi
 293:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 296:	85 db                	test   %ebx,%ebx
 298:	7e 13                	jle    2ad <memmove+0x25>
 29a:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 29f:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2a3:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2a6:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2a9:	39 d3                	cmp    %edx,%ebx
 2ab:	75 f2                	jne    29f <memmove+0x17>
  return vdst;
}
 2ad:	5b                   	pop    %ebx
 2ae:	5e                   	pop    %esi
 2af:	5d                   	pop    %ebp
 2b0:	c3                   	ret    

000002b1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b1:	b8 01 00 00 00       	mov    $0x1,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <exit>:
SYSCALL(exit)
 2b9:	b8 02 00 00 00       	mov    $0x2,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <wait>:
SYSCALL(wait)
 2c1:	b8 03 00 00 00       	mov    $0x3,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <pipe>:
SYSCALL(pipe)
 2c9:	b8 04 00 00 00       	mov    $0x4,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <read>:
SYSCALL(read)
 2d1:	b8 05 00 00 00       	mov    $0x5,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <write>:
SYSCALL(write)
 2d9:	b8 10 00 00 00       	mov    $0x10,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <close>:
SYSCALL(close)
 2e1:	b8 15 00 00 00       	mov    $0x15,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <kill>:
SYSCALL(kill)
 2e9:	b8 06 00 00 00       	mov    $0x6,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <exec>:
SYSCALL(exec)
 2f1:	b8 07 00 00 00       	mov    $0x7,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <open>:
SYSCALL(open)
 2f9:	b8 0f 00 00 00       	mov    $0xf,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <mknod>:
SYSCALL(mknod)
 301:	b8 11 00 00 00       	mov    $0x11,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <unlink>:
SYSCALL(unlink)
 309:	b8 12 00 00 00       	mov    $0x12,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <fstat>:
SYSCALL(fstat)
 311:	b8 08 00 00 00       	mov    $0x8,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <link>:
SYSCALL(link)
 319:	b8 13 00 00 00       	mov    $0x13,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <mkdir>:
SYSCALL(mkdir)
 321:	b8 14 00 00 00       	mov    $0x14,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <chdir>:
SYSCALL(chdir)
 329:	b8 09 00 00 00       	mov    $0x9,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <dup>:
SYSCALL(dup)
 331:	b8 0a 00 00 00       	mov    $0xa,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <getpid>:
SYSCALL(getpid)
 339:	b8 0b 00 00 00       	mov    $0xb,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <sbrk>:
SYSCALL(sbrk)
 341:	b8 0c 00 00 00       	mov    $0xc,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <sleep>:
SYSCALL(sleep)
 349:	b8 0d 00 00 00       	mov    $0xd,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <uptime>:
SYSCALL(uptime)
 351:	b8 0e 00 00 00       	mov    $0xe,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <halt>:
SYSCALL(halt)
 359:	b8 16 00 00 00       	mov    $0x16,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <date>:
//proj1
SYSCALL(date)
 361:	b8 17 00 00 00       	mov    $0x17,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <getuid>:
//proj2
SYSCALL(getuid)
 369:	b8 18 00 00 00       	mov    $0x18,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <getgid>:
SYSCALL(getgid)
 371:	b8 19 00 00 00       	mov    $0x19,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <getppid>:
SYSCALL(getppid)
 379:	b8 1a 00 00 00       	mov    $0x1a,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <setuid>:
SYSCALL(setuid)
 381:	b8 1b 00 00 00       	mov    $0x1b,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <setgid>:
SYSCALL(setgid)
 389:	b8 1c 00 00 00       	mov    $0x1c,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <getprocs>:
SYSCALL(getprocs)
 391:	b8 1d 00 00 00       	mov    $0x1d,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 399:	55                   	push   %ebp
 39a:	89 e5                	mov    %esp,%ebp
 39c:	57                   	push   %edi
 39d:	56                   	push   %esi
 39e:	53                   	push   %ebx
 39f:	83 ec 3c             	sub    $0x3c,%esp
 3a2:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a8:	74 14                	je     3be <printint+0x25>
 3aa:	85 d2                	test   %edx,%edx
 3ac:	79 10                	jns    3be <printint+0x25>
    neg = 1;
    x = -xx;
 3ae:	f7 da                	neg    %edx
    neg = 1;
 3b0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3b7:	bf 00 00 00 00       	mov    $0x0,%edi
 3bc:	eb 0b                	jmp    3c9 <printint+0x30>
  neg = 0;
 3be:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3c5:	eb f0                	jmp    3b7 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 3c7:	89 df                	mov    %ebx,%edi
 3c9:	8d 5f 01             	lea    0x1(%edi),%ebx
 3cc:	89 d0                	mov    %edx,%eax
 3ce:	ba 00 00 00 00       	mov    $0x0,%edx
 3d3:	f7 f1                	div    %ecx
 3d5:	0f b6 92 6c 07 00 00 	movzbl 0x76c(%edx),%edx
 3dc:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3e0:	89 c2                	mov    %eax,%edx
 3e2:	85 c0                	test   %eax,%eax
 3e4:	75 e1                	jne    3c7 <printint+0x2e>
  if(neg)
 3e6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3ea:	74 08                	je     3f4 <printint+0x5b>
    buf[i++] = '-';
 3ec:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3f1:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3f4:	83 eb 01             	sub    $0x1,%ebx
 3f7:	78 22                	js     41b <printint+0x82>
  write(fd, &c, 1);
 3f9:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3fc:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 401:	88 45 d7             	mov    %al,-0x29(%ebp)
 404:	83 ec 04             	sub    $0x4,%esp
 407:	6a 01                	push   $0x1
 409:	57                   	push   %edi
 40a:	56                   	push   %esi
 40b:	e8 c9 fe ff ff       	call   2d9 <write>
  while(--i >= 0)
 410:	83 eb 01             	sub    $0x1,%ebx
 413:	83 c4 10             	add    $0x10,%esp
 416:	83 fb ff             	cmp    $0xffffffff,%ebx
 419:	75 e1                	jne    3fc <printint+0x63>
    putc(fd, buf[i]);
}
 41b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41e:	5b                   	pop    %ebx
 41f:	5e                   	pop    %esi
 420:	5f                   	pop    %edi
 421:	5d                   	pop    %ebp
 422:	c3                   	ret    

00000423 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 423:	55                   	push   %ebp
 424:	89 e5                	mov    %esp,%ebp
 426:	57                   	push   %edi
 427:	56                   	push   %esi
 428:	53                   	push   %ebx
 429:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 42c:	8b 75 0c             	mov    0xc(%ebp),%esi
 42f:	0f b6 1e             	movzbl (%esi),%ebx
 432:	84 db                	test   %bl,%bl
 434:	0f 84 b1 01 00 00    	je     5eb <printf+0x1c8>
 43a:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 43d:	8d 45 10             	lea    0x10(%ebp),%eax
 440:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 443:	bf 00 00 00 00       	mov    $0x0,%edi
 448:	eb 2d                	jmp    477 <printf+0x54>
 44a:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 44d:	83 ec 04             	sub    $0x4,%esp
 450:	6a 01                	push   $0x1
 452:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 455:	50                   	push   %eax
 456:	ff 75 08             	pushl  0x8(%ebp)
 459:	e8 7b fe ff ff       	call   2d9 <write>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	eb 05                	jmp    468 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 463:	83 ff 25             	cmp    $0x25,%edi
 466:	74 22                	je     48a <printf+0x67>
 468:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 46b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 46f:	84 db                	test   %bl,%bl
 471:	0f 84 74 01 00 00    	je     5eb <printf+0x1c8>
    c = fmt[i] & 0xff;
 477:	0f be d3             	movsbl %bl,%edx
 47a:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 47d:	85 ff                	test   %edi,%edi
 47f:	75 e2                	jne    463 <printf+0x40>
      if(c == '%'){
 481:	83 f8 25             	cmp    $0x25,%eax
 484:	75 c4                	jne    44a <printf+0x27>
        state = '%';
 486:	89 c7                	mov    %eax,%edi
 488:	eb de                	jmp    468 <printf+0x45>
      if(c == 'd'){
 48a:	83 f8 64             	cmp    $0x64,%eax
 48d:	74 59                	je     4e8 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 48f:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 495:	83 fa 70             	cmp    $0x70,%edx
 498:	74 7a                	je     514 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 49a:	83 f8 73             	cmp    $0x73,%eax
 49d:	0f 84 9d 00 00 00    	je     540 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4a3:	83 f8 63             	cmp    $0x63,%eax
 4a6:	0f 84 f2 00 00 00    	je     59e <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ac:	83 f8 25             	cmp    $0x25,%eax
 4af:	0f 84 15 01 00 00    	je     5ca <printf+0x1a7>
 4b5:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4b9:	83 ec 04             	sub    $0x4,%esp
 4bc:	6a 01                	push   $0x1
 4be:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4c1:	50                   	push   %eax
 4c2:	ff 75 08             	pushl  0x8(%ebp)
 4c5:	e8 0f fe ff ff       	call   2d9 <write>
 4ca:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4cd:	83 c4 0c             	add    $0xc,%esp
 4d0:	6a 01                	push   $0x1
 4d2:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4d5:	50                   	push   %eax
 4d6:	ff 75 08             	pushl  0x8(%ebp)
 4d9:	e8 fb fd ff ff       	call   2d9 <write>
 4de:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e1:	bf 00 00 00 00       	mov    $0x0,%edi
 4e6:	eb 80                	jmp    468 <printf+0x45>
        printint(fd, *ap, 10, 1);
 4e8:	83 ec 0c             	sub    $0xc,%esp
 4eb:	6a 01                	push   $0x1
 4ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4f2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4f5:	8b 17                	mov    (%edi),%edx
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	e8 9a fe ff ff       	call   399 <printint>
        ap++;
 4ff:	89 f8                	mov    %edi,%eax
 501:	83 c0 04             	add    $0x4,%eax
 504:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 507:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50a:	bf 00 00 00 00       	mov    $0x0,%edi
 50f:	e9 54 ff ff ff       	jmp    468 <printf+0x45>
        printint(fd, *ap, 16, 0);
 514:	83 ec 0c             	sub    $0xc,%esp
 517:	6a 00                	push   $0x0
 519:	b9 10 00 00 00       	mov    $0x10,%ecx
 51e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 521:	8b 17                	mov    (%edi),%edx
 523:	8b 45 08             	mov    0x8(%ebp),%eax
 526:	e8 6e fe ff ff       	call   399 <printint>
        ap++;
 52b:	89 f8                	mov    %edi,%eax
 52d:	83 c0 04             	add    $0x4,%eax
 530:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 533:	83 c4 10             	add    $0x10,%esp
      state = 0;
 536:	bf 00 00 00 00       	mov    $0x0,%edi
 53b:	e9 28 ff ff ff       	jmp    468 <printf+0x45>
        s = (char*)*ap;
 540:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 543:	8b 01                	mov    (%ecx),%eax
        ap++;
 545:	83 c1 04             	add    $0x4,%ecx
 548:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 54b:	85 c0                	test   %eax,%eax
 54d:	74 13                	je     562 <printf+0x13f>
        s = (char*)*ap;
 54f:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 551:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 554:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 559:	84 c0                	test   %al,%al
 55b:	75 0f                	jne    56c <printf+0x149>
 55d:	e9 06 ff ff ff       	jmp    468 <printf+0x45>
          s = "(null)";
 562:	bb 63 07 00 00       	mov    $0x763,%ebx
        while(*s != 0){
 567:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 56c:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 56f:	89 75 d0             	mov    %esi,-0x30(%ebp)
 572:	8b 75 08             	mov    0x8(%ebp),%esi
 575:	88 45 e3             	mov    %al,-0x1d(%ebp)
 578:	83 ec 04             	sub    $0x4,%esp
 57b:	6a 01                	push   $0x1
 57d:	57                   	push   %edi
 57e:	56                   	push   %esi
 57f:	e8 55 fd ff ff       	call   2d9 <write>
          s++;
 584:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 587:	0f b6 03             	movzbl (%ebx),%eax
 58a:	83 c4 10             	add    $0x10,%esp
 58d:	84 c0                	test   %al,%al
 58f:	75 e4                	jne    575 <printf+0x152>
 591:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 594:	bf 00 00 00 00       	mov    $0x0,%edi
 599:	e9 ca fe ff ff       	jmp    468 <printf+0x45>
        putc(fd, *ap);
 59e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5a1:	8b 07                	mov    (%edi),%eax
 5a3:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5a6:	83 ec 04             	sub    $0x4,%esp
 5a9:	6a 01                	push   $0x1
 5ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5ae:	50                   	push   %eax
 5af:	ff 75 08             	pushl  0x8(%ebp)
 5b2:	e8 22 fd ff ff       	call   2d9 <write>
        ap++;
 5b7:	83 c7 04             	add    $0x4,%edi
 5ba:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5bd:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5c0:	bf 00 00 00 00       	mov    $0x0,%edi
 5c5:	e9 9e fe ff ff       	jmp    468 <printf+0x45>
 5ca:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 5cd:	83 ec 04             	sub    $0x4,%esp
 5d0:	6a 01                	push   $0x1
 5d2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5d5:	50                   	push   %eax
 5d6:	ff 75 08             	pushl  0x8(%ebp)
 5d9:	e8 fb fc ff ff       	call   2d9 <write>
 5de:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5e1:	bf 00 00 00 00       	mov    $0x0,%edi
 5e6:	e9 7d fe ff ff       	jmp    468 <printf+0x45>
    }
  }
}
 5eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ee:	5b                   	pop    %ebx
 5ef:	5e                   	pop    %esi
 5f0:	5f                   	pop    %edi
 5f1:	5d                   	pop    %ebp
 5f2:	c3                   	ret    

000005f3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f3:	55                   	push   %ebp
 5f4:	89 e5                	mov    %esp,%ebp
 5f6:	57                   	push   %edi
 5f7:	56                   	push   %esi
 5f8:	53                   	push   %ebx
 5f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5fc:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ff:	a1 08 0a 00 00       	mov    0xa08,%eax
 604:	eb 0c                	jmp    612 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 606:	8b 10                	mov    (%eax),%edx
 608:	39 c2                	cmp    %eax,%edx
 60a:	77 04                	ja     610 <free+0x1d>
 60c:	39 ca                	cmp    %ecx,%edx
 60e:	77 10                	ja     620 <free+0x2d>
{
 610:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 612:	39 c8                	cmp    %ecx,%eax
 614:	73 f0                	jae    606 <free+0x13>
 616:	8b 10                	mov    (%eax),%edx
 618:	39 ca                	cmp    %ecx,%edx
 61a:	77 04                	ja     620 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61c:	39 c2                	cmp    %eax,%edx
 61e:	77 f0                	ja     610 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 620:	8b 73 fc             	mov    -0x4(%ebx),%esi
 623:	8b 10                	mov    (%eax),%edx
 625:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 628:	39 fa                	cmp    %edi,%edx
 62a:	74 19                	je     645 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 62c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 62f:	8b 50 04             	mov    0x4(%eax),%edx
 632:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 635:	39 f1                	cmp    %esi,%ecx
 637:	74 1b                	je     654 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 639:	89 08                	mov    %ecx,(%eax)
  freep = p;
 63b:	a3 08 0a 00 00       	mov    %eax,0xa08
}
 640:	5b                   	pop    %ebx
 641:	5e                   	pop    %esi
 642:	5f                   	pop    %edi
 643:	5d                   	pop    %ebp
 644:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 645:	03 72 04             	add    0x4(%edx),%esi
 648:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 64b:	8b 10                	mov    (%eax),%edx
 64d:	8b 12                	mov    (%edx),%edx
 64f:	89 53 f8             	mov    %edx,-0x8(%ebx)
 652:	eb db                	jmp    62f <free+0x3c>
    p->s.size += bp->s.size;
 654:	03 53 fc             	add    -0x4(%ebx),%edx
 657:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 65a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 65d:	89 10                	mov    %edx,(%eax)
 65f:	eb da                	jmp    63b <free+0x48>

00000661 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 661:	55                   	push   %ebp
 662:	89 e5                	mov    %esp,%ebp
 664:	57                   	push   %edi
 665:	56                   	push   %esi
 666:	53                   	push   %ebx
 667:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	8d 58 07             	lea    0x7(%eax),%ebx
 670:	c1 eb 03             	shr    $0x3,%ebx
 673:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 676:	8b 15 08 0a 00 00    	mov    0xa08,%edx
 67c:	85 d2                	test   %edx,%edx
 67e:	74 20                	je     6a0 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 680:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 682:	8b 48 04             	mov    0x4(%eax),%ecx
 685:	39 cb                	cmp    %ecx,%ebx
 687:	76 3c                	jbe    6c5 <malloc+0x64>
 689:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 68f:	be 00 10 00 00       	mov    $0x1000,%esi
 694:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 697:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 69e:	eb 70                	jmp    710 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 6a0:	c7 05 08 0a 00 00 0c 	movl   $0xa0c,0xa08
 6a7:	0a 00 00 
 6aa:	c7 05 0c 0a 00 00 0c 	movl   $0xa0c,0xa0c
 6b1:	0a 00 00 
    base.s.size = 0;
 6b4:	c7 05 10 0a 00 00 00 	movl   $0x0,0xa10
 6bb:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6be:	ba 0c 0a 00 00       	mov    $0xa0c,%edx
 6c3:	eb bb                	jmp    680 <malloc+0x1f>
      if(p->s.size == nunits)
 6c5:	39 cb                	cmp    %ecx,%ebx
 6c7:	74 1c                	je     6e5 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6c9:	29 d9                	sub    %ebx,%ecx
 6cb:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6ce:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6d1:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6d4:	89 15 08 0a 00 00    	mov    %edx,0xa08
      return (void*)(p + 1);
 6da:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e0:	5b                   	pop    %ebx
 6e1:	5e                   	pop    %esi
 6e2:	5f                   	pop    %edi
 6e3:	5d                   	pop    %ebp
 6e4:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6e5:	8b 08                	mov    (%eax),%ecx
 6e7:	89 0a                	mov    %ecx,(%edx)
 6e9:	eb e9                	jmp    6d4 <malloc+0x73>
  hp->s.size = nu;
 6eb:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6ee:	83 ec 0c             	sub    $0xc,%esp
 6f1:	83 c0 08             	add    $0x8,%eax
 6f4:	50                   	push   %eax
 6f5:	e8 f9 fe ff ff       	call   5f3 <free>
  return freep;
 6fa:	8b 15 08 0a 00 00    	mov    0xa08,%edx
      if((p = morecore(nunits)) == 0)
 700:	83 c4 10             	add    $0x10,%esp
 703:	85 d2                	test   %edx,%edx
 705:	74 2b                	je     732 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 707:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 709:	8b 48 04             	mov    0x4(%eax),%ecx
 70c:	39 d9                	cmp    %ebx,%ecx
 70e:	73 b5                	jae    6c5 <malloc+0x64>
 710:	89 c2                	mov    %eax,%edx
    if(p == freep)
 712:	39 05 08 0a 00 00    	cmp    %eax,0xa08
 718:	75 ed                	jne    707 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 71a:	83 ec 0c             	sub    $0xc,%esp
 71d:	57                   	push   %edi
 71e:	e8 1e fc ff ff       	call   341 <sbrk>
  if(p == (char*)-1)
 723:	83 c4 10             	add    $0x10,%esp
 726:	83 f8 ff             	cmp    $0xffffffff,%eax
 729:	75 c0                	jne    6eb <malloc+0x8a>
        return 0;
 72b:	b8 00 00 00 00       	mov    $0x0,%eax
 730:	eb ab                	jmp    6dd <malloc+0x7c>
 732:	b8 00 00 00 00       	mov    $0x0,%eax
 737:	eb a4                	jmp    6dd <malloc+0x7c>
