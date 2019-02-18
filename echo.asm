
_echo:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  19:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	7e 41                	jle    62 <main+0x62>
  21:	8d 5f 04             	lea    0x4(%edi),%ebx
  24:	8d 74 87 fc          	lea    -0x4(%edi,%eax,4),%esi
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  28:	39 f3                	cmp    %esi,%ebx
  2a:	74 1b                	je     47 <main+0x47>
  2c:	68 44 07 00 00       	push   $0x744
  31:	ff 33                	pushl  (%ebx)
  33:	68 46 07 00 00       	push   $0x746
  38:	6a 01                	push   $0x1
  3a:	e8 ef 03 00 00       	call   42e <printf>
  3f:	83 c3 04             	add    $0x4,%ebx
  42:	83 c4 10             	add    $0x10,%esp
  45:	eb e1                	jmp    28 <main+0x28>
  47:	68 4b 07 00 00       	push   $0x74b
  4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  4f:	ff 74 87 fc          	pushl  -0x4(%edi,%eax,4)
  53:	68 46 07 00 00       	push   $0x746
  58:	6a 01                	push   $0x1
  5a:	e8 cf 03 00 00       	call   42e <printf>
  5f:	83 c4 10             	add    $0x10,%esp
  exit();
  62:	e8 5d 02 00 00       	call   2c4 <exit>

00000067 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	53                   	push   %ebx
  6b:	8b 45 08             	mov    0x8(%ebp),%eax
  6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  71:	89 c2                	mov    %eax,%edx
  73:	83 c1 01             	add    $0x1,%ecx
  76:	83 c2 01             	add    $0x1,%edx
  79:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  7d:	88 5a ff             	mov    %bl,-0x1(%edx)
  80:	84 db                	test   %bl,%bl
  82:	75 ef                	jne    73 <strcpy+0xc>
    ;
  return os;
}
  84:	5b                   	pop    %ebx
  85:	5d                   	pop    %ebp
  86:	c3                   	ret    

00000087 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  87:	55                   	push   %ebp
  88:	89 e5                	mov    %esp,%ebp
  8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  90:	0f b6 01             	movzbl (%ecx),%eax
  93:	84 c0                	test   %al,%al
  95:	74 15                	je     ac <strcmp+0x25>
  97:	3a 02                	cmp    (%edx),%al
  99:	75 11                	jne    ac <strcmp+0x25>
    p++, q++;
  9b:	83 c1 01             	add    $0x1,%ecx
  9e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  a1:	0f b6 01             	movzbl (%ecx),%eax
  a4:	84 c0                	test   %al,%al
  a6:	74 04                	je     ac <strcmp+0x25>
  a8:	3a 02                	cmp    (%edx),%al
  aa:	74 ef                	je     9b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  ac:	0f b6 c0             	movzbl %al,%eax
  af:	0f b6 12             	movzbl (%edx),%edx
  b2:	29 d0                	sub    %edx,%eax
}
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret    

000000b6 <strlen>:

uint
strlen(char *s)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  bc:	80 39 00             	cmpb   $0x0,(%ecx)
  bf:	74 12                	je     d3 <strlen+0x1d>
  c1:	ba 00 00 00 00       	mov    $0x0,%edx
  c6:	83 c2 01             	add    $0x1,%edx
  c9:	89 d0                	mov    %edx,%eax
  cb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  cf:	75 f5                	jne    c6 <strlen+0x10>
    ;
  return n;
}
  d1:	5d                   	pop    %ebp
  d2:	c3                   	ret    
  for(n = 0; s[n]; n++)
  d3:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  d8:	eb f7                	jmp    d1 <strlen+0x1b>

000000da <memset>:

void*
memset(void *dst, int c, uint n)
{
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  dd:	57                   	push   %edi
  de:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  e1:	89 d7                	mov    %edx,%edi
  e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  e9:	fc                   	cld    
  ea:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  ec:	89 d0                	mov    %edx,%eax
  ee:	5f                   	pop    %edi
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    

000000f1 <strchr>:

char*
strchr(const char *s, char c)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	53                   	push   %ebx
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  fb:	0f b6 10             	movzbl (%eax),%edx
  fe:	84 d2                	test   %dl,%dl
 100:	74 1e                	je     120 <strchr+0x2f>
 102:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 104:	38 d3                	cmp    %dl,%bl
 106:	74 15                	je     11d <strchr+0x2c>
  for(; *s; s++)
 108:	83 c0 01             	add    $0x1,%eax
 10b:	0f b6 10             	movzbl (%eax),%edx
 10e:	84 d2                	test   %dl,%dl
 110:	74 06                	je     118 <strchr+0x27>
    if(*s == c)
 112:	38 ca                	cmp    %cl,%dl
 114:	75 f2                	jne    108 <strchr+0x17>
 116:	eb 05                	jmp    11d <strchr+0x2c>
      return (char*)s;
  return 0;
 118:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11d:	5b                   	pop    %ebx
 11e:	5d                   	pop    %ebp
 11f:	c3                   	ret    
  return 0;
 120:	b8 00 00 00 00       	mov    $0x0,%eax
 125:	eb f6                	jmp    11d <strchr+0x2c>

00000127 <gets>:

char*
gets(char *buf, int max)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	57                   	push   %edi
 12b:	56                   	push   %esi
 12c:	53                   	push   %ebx
 12d:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 130:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 135:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 138:	8d 5e 01             	lea    0x1(%esi),%ebx
 13b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 13e:	7d 2b                	jge    16b <gets+0x44>
    cc = read(0, &c, 1);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	6a 01                	push   $0x1
 145:	57                   	push   %edi
 146:	6a 00                	push   $0x0
 148:	e8 8f 01 00 00       	call   2dc <read>
    if(cc < 1)
 14d:	83 c4 10             	add    $0x10,%esp
 150:	85 c0                	test   %eax,%eax
 152:	7e 17                	jle    16b <gets+0x44>
      break;
    buf[i++] = c;
 154:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 158:	8b 55 08             	mov    0x8(%ebp),%edx
 15b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 15f:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 161:	3c 0a                	cmp    $0xa,%al
 163:	74 04                	je     169 <gets+0x42>
 165:	3c 0d                	cmp    $0xd,%al
 167:	75 cf                	jne    138 <gets+0x11>
  for(i=0; i+1 < max; ){
 169:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 172:	8d 65 f4             	lea    -0xc(%ebp),%esp
 175:	5b                   	pop    %ebx
 176:	5e                   	pop    %esi
 177:	5f                   	pop    %edi
 178:	5d                   	pop    %ebp
 179:	c3                   	ret    

0000017a <stat>:

int
stat(char *n, struct stat *st)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
 17d:	56                   	push   %esi
 17e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17f:	83 ec 08             	sub    $0x8,%esp
 182:	6a 00                	push   $0x0
 184:	ff 75 08             	pushl  0x8(%ebp)
 187:	e8 78 01 00 00       	call   304 <open>
  if(fd < 0)
 18c:	83 c4 10             	add    $0x10,%esp
 18f:	85 c0                	test   %eax,%eax
 191:	78 24                	js     1b7 <stat+0x3d>
 193:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 195:	83 ec 08             	sub    $0x8,%esp
 198:	ff 75 0c             	pushl  0xc(%ebp)
 19b:	50                   	push   %eax
 19c:	e8 7b 01 00 00       	call   31c <fstat>
 1a1:	89 c6                	mov    %eax,%esi
  close(fd);
 1a3:	89 1c 24             	mov    %ebx,(%esp)
 1a6:	e8 41 01 00 00       	call   2ec <close>
  return r;
 1ab:	83 c4 10             	add    $0x10,%esp
}
 1ae:	89 f0                	mov    %esi,%eax
 1b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b3:	5b                   	pop    %ebx
 1b4:	5e                   	pop    %esi
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
    return -1;
 1b7:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1bc:	eb f0                	jmp    1ae <stat+0x34>

000001be <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	56                   	push   %esi
 1c2:	53                   	push   %ebx
 1c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1c6:	0f b6 0a             	movzbl (%edx),%ecx
 1c9:	80 f9 20             	cmp    $0x20,%cl
 1cc:	75 0b                	jne    1d9 <atoi+0x1b>
 1ce:	83 c2 01             	add    $0x1,%edx
 1d1:	0f b6 0a             	movzbl (%edx),%ecx
 1d4:	80 f9 20             	cmp    $0x20,%cl
 1d7:	74 f5                	je     1ce <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 1d9:	80 f9 2d             	cmp    $0x2d,%cl
 1dc:	74 3b                	je     219 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 1de:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 1e1:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 1e6:	f6 c1 fd             	test   $0xfd,%cl
 1e9:	74 33                	je     21e <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 1eb:	0f b6 0a             	movzbl (%edx),%ecx
 1ee:	8d 41 d0             	lea    -0x30(%ecx),%eax
 1f1:	3c 09                	cmp    $0x9,%al
 1f3:	77 2e                	ja     223 <atoi+0x65>
 1f5:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1fa:	83 c2 01             	add    $0x1,%edx
 1fd:	8d 04 80             	lea    (%eax,%eax,4),%eax
 200:	0f be c9             	movsbl %cl,%ecx
 203:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 207:	0f b6 0a             	movzbl (%edx),%ecx
 20a:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 20d:	80 fb 09             	cmp    $0x9,%bl
 210:	76 e8                	jbe    1fa <atoi+0x3c>
  return sign*n;
 212:	0f af c6             	imul   %esi,%eax
}
 215:	5b                   	pop    %ebx
 216:	5e                   	pop    %esi
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 219:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 21e:	83 c2 01             	add    $0x1,%edx
 221:	eb c8                	jmp    1eb <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 223:	b8 00 00 00 00       	mov    $0x0,%eax
 228:	eb e8                	jmp    212 <atoi+0x54>

0000022a <atoo>:

int
atoo(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	56                   	push   %esi
 22e:	53                   	push   %ebx
 22f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 232:	0f b6 0a             	movzbl (%edx),%ecx
 235:	80 f9 20             	cmp    $0x20,%cl
 238:	75 0b                	jne    245 <atoo+0x1b>
 23a:	83 c2 01             	add    $0x1,%edx
 23d:	0f b6 0a             	movzbl (%edx),%ecx
 240:	80 f9 20             	cmp    $0x20,%cl
 243:	74 f5                	je     23a <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 245:	80 f9 2d             	cmp    $0x2d,%cl
 248:	74 38                	je     282 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 24a:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 24d:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 252:	f6 c1 fd             	test   $0xfd,%cl
 255:	74 30                	je     287 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 257:	0f b6 0a             	movzbl (%edx),%ecx
 25a:	8d 41 d0             	lea    -0x30(%ecx),%eax
 25d:	3c 07                	cmp    $0x7,%al
 25f:	77 2b                	ja     28c <atoo+0x62>
 261:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 266:	83 c2 01             	add    $0x1,%edx
 269:	0f be c9             	movsbl %cl,%ecx
 26c:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 270:	0f b6 0a             	movzbl (%edx),%ecx
 273:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 276:	80 fb 07             	cmp    $0x7,%bl
 279:	76 eb                	jbe    266 <atoo+0x3c>
  return sign*n;
 27b:	0f af c6             	imul   %esi,%eax
}
 27e:	5b                   	pop    %ebx
 27f:	5e                   	pop    %esi
 280:	5d                   	pop    %ebp
 281:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 282:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 287:	83 c2 01             	add    $0x1,%edx
 28a:	eb cb                	jmp    257 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 28c:	b8 00 00 00 00       	mov    $0x0,%eax
 291:	eb e8                	jmp    27b <atoo+0x51>

00000293 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	56                   	push   %esi
 297:	53                   	push   %ebx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	8b 75 0c             	mov    0xc(%ebp),%esi
 29e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a1:	85 db                	test   %ebx,%ebx
 2a3:	7e 13                	jle    2b8 <memmove+0x25>
 2a5:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 2aa:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ae:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2b1:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2b4:	39 d3                	cmp    %edx,%ebx
 2b6:	75 f2                	jne    2aa <memmove+0x17>
  return vdst;
}
 2b8:	5b                   	pop    %ebx
 2b9:	5e                   	pop    %esi
 2ba:	5d                   	pop    %ebp
 2bb:	c3                   	ret    

000002bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bc:	b8 01 00 00 00       	mov    $0x1,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <exit>:
SYSCALL(exit)
 2c4:	b8 02 00 00 00       	mov    $0x2,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <wait>:
SYSCALL(wait)
 2cc:	b8 03 00 00 00       	mov    $0x3,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <pipe>:
SYSCALL(pipe)
 2d4:	b8 04 00 00 00       	mov    $0x4,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <read>:
SYSCALL(read)
 2dc:	b8 05 00 00 00       	mov    $0x5,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <write>:
SYSCALL(write)
 2e4:	b8 10 00 00 00       	mov    $0x10,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <close>:
SYSCALL(close)
 2ec:	b8 15 00 00 00       	mov    $0x15,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <kill>:
SYSCALL(kill)
 2f4:	b8 06 00 00 00       	mov    $0x6,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <exec>:
SYSCALL(exec)
 2fc:	b8 07 00 00 00       	mov    $0x7,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <open>:
SYSCALL(open)
 304:	b8 0f 00 00 00       	mov    $0xf,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <mknod>:
SYSCALL(mknod)
 30c:	b8 11 00 00 00       	mov    $0x11,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <unlink>:
SYSCALL(unlink)
 314:	b8 12 00 00 00       	mov    $0x12,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <fstat>:
SYSCALL(fstat)
 31c:	b8 08 00 00 00       	mov    $0x8,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <link>:
SYSCALL(link)
 324:	b8 13 00 00 00       	mov    $0x13,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <mkdir>:
SYSCALL(mkdir)
 32c:	b8 14 00 00 00       	mov    $0x14,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <chdir>:
SYSCALL(chdir)
 334:	b8 09 00 00 00       	mov    $0x9,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <dup>:
SYSCALL(dup)
 33c:	b8 0a 00 00 00       	mov    $0xa,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <getpid>:
SYSCALL(getpid)
 344:	b8 0b 00 00 00       	mov    $0xb,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <sbrk>:
SYSCALL(sbrk)
 34c:	b8 0c 00 00 00       	mov    $0xc,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <sleep>:
SYSCALL(sleep)
 354:	b8 0d 00 00 00       	mov    $0xd,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <uptime>:
SYSCALL(uptime)
 35c:	b8 0e 00 00 00       	mov    $0xe,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <halt>:
SYSCALL(halt)
 364:	b8 16 00 00 00       	mov    $0x16,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <date>:
//proj1
SYSCALL(date)
 36c:	b8 17 00 00 00       	mov    $0x17,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <getuid>:
//proj2
SYSCALL(getuid)
 374:	b8 18 00 00 00       	mov    $0x18,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <getgid>:
SYSCALL(getgid)
 37c:	b8 19 00 00 00       	mov    $0x19,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <getppid>:
SYSCALL(getppid)
 384:	b8 1a 00 00 00       	mov    $0x1a,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <setuid>:
SYSCALL(setuid)
 38c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <setgid>:
SYSCALL(setgid)
 394:	b8 1c 00 00 00       	mov    $0x1c,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <getprocs>:
SYSCALL(getprocs)
 39c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	57                   	push   %edi
 3a8:	56                   	push   %esi
 3a9:	53                   	push   %ebx
 3aa:	83 ec 3c             	sub    $0x3c,%esp
 3ad:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3b3:	74 14                	je     3c9 <printint+0x25>
 3b5:	85 d2                	test   %edx,%edx
 3b7:	79 10                	jns    3c9 <printint+0x25>
    neg = 1;
    x = -xx;
 3b9:	f7 da                	neg    %edx
    neg = 1;
 3bb:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3c2:	bf 00 00 00 00       	mov    $0x0,%edi
 3c7:	eb 0b                	jmp    3d4 <printint+0x30>
  neg = 0;
 3c9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3d0:	eb f0                	jmp    3c2 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 3d2:	89 df                	mov    %ebx,%edi
 3d4:	8d 5f 01             	lea    0x1(%edi),%ebx
 3d7:	89 d0                	mov    %edx,%eax
 3d9:	ba 00 00 00 00       	mov    $0x0,%edx
 3de:	f7 f1                	div    %ecx
 3e0:	0f b6 92 54 07 00 00 	movzbl 0x754(%edx),%edx
 3e7:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3eb:	89 c2                	mov    %eax,%edx
 3ed:	85 c0                	test   %eax,%eax
 3ef:	75 e1                	jne    3d2 <printint+0x2e>
  if(neg)
 3f1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3f5:	74 08                	je     3ff <printint+0x5b>
    buf[i++] = '-';
 3f7:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3fc:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3ff:	83 eb 01             	sub    $0x1,%ebx
 402:	78 22                	js     426 <printint+0x82>
  write(fd, &c, 1);
 404:	8d 7d d7             	lea    -0x29(%ebp),%edi
 407:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 40c:	88 45 d7             	mov    %al,-0x29(%ebp)
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	6a 01                	push   $0x1
 414:	57                   	push   %edi
 415:	56                   	push   %esi
 416:	e8 c9 fe ff ff       	call   2e4 <write>
  while(--i >= 0)
 41b:	83 eb 01             	sub    $0x1,%ebx
 41e:	83 c4 10             	add    $0x10,%esp
 421:	83 fb ff             	cmp    $0xffffffff,%ebx
 424:	75 e1                	jne    407 <printint+0x63>
    putc(fd, buf[i]);
}
 426:	8d 65 f4             	lea    -0xc(%ebp),%esp
 429:	5b                   	pop    %ebx
 42a:	5e                   	pop    %esi
 42b:	5f                   	pop    %edi
 42c:	5d                   	pop    %ebp
 42d:	c3                   	ret    

0000042e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 42e:	55                   	push   %ebp
 42f:	89 e5                	mov    %esp,%ebp
 431:	57                   	push   %edi
 432:	56                   	push   %esi
 433:	53                   	push   %ebx
 434:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 437:	8b 75 0c             	mov    0xc(%ebp),%esi
 43a:	0f b6 1e             	movzbl (%esi),%ebx
 43d:	84 db                	test   %bl,%bl
 43f:	0f 84 b1 01 00 00    	je     5f6 <printf+0x1c8>
 445:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 448:	8d 45 10             	lea    0x10(%ebp),%eax
 44b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 44e:	bf 00 00 00 00       	mov    $0x0,%edi
 453:	eb 2d                	jmp    482 <printf+0x54>
 455:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 458:	83 ec 04             	sub    $0x4,%esp
 45b:	6a 01                	push   $0x1
 45d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 460:	50                   	push   %eax
 461:	ff 75 08             	pushl  0x8(%ebp)
 464:	e8 7b fe ff ff       	call   2e4 <write>
 469:	83 c4 10             	add    $0x10,%esp
 46c:	eb 05                	jmp    473 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 46e:	83 ff 25             	cmp    $0x25,%edi
 471:	74 22                	je     495 <printf+0x67>
 473:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 476:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 47a:	84 db                	test   %bl,%bl
 47c:	0f 84 74 01 00 00    	je     5f6 <printf+0x1c8>
    c = fmt[i] & 0xff;
 482:	0f be d3             	movsbl %bl,%edx
 485:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 488:	85 ff                	test   %edi,%edi
 48a:	75 e2                	jne    46e <printf+0x40>
      if(c == '%'){
 48c:	83 f8 25             	cmp    $0x25,%eax
 48f:	75 c4                	jne    455 <printf+0x27>
        state = '%';
 491:	89 c7                	mov    %eax,%edi
 493:	eb de                	jmp    473 <printf+0x45>
      if(c == 'd'){
 495:	83 f8 64             	cmp    $0x64,%eax
 498:	74 59                	je     4f3 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 49a:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 4a0:	83 fa 70             	cmp    $0x70,%edx
 4a3:	74 7a                	je     51f <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4a5:	83 f8 73             	cmp    $0x73,%eax
 4a8:	0f 84 9d 00 00 00    	je     54b <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ae:	83 f8 63             	cmp    $0x63,%eax
 4b1:	0f 84 f2 00 00 00    	je     5a9 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4b7:	83 f8 25             	cmp    $0x25,%eax
 4ba:	0f 84 15 01 00 00    	je     5d5 <printf+0x1a7>
 4c0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4c4:	83 ec 04             	sub    $0x4,%esp
 4c7:	6a 01                	push   $0x1
 4c9:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4cc:	50                   	push   %eax
 4cd:	ff 75 08             	pushl  0x8(%ebp)
 4d0:	e8 0f fe ff ff       	call   2e4 <write>
 4d5:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4d8:	83 c4 0c             	add    $0xc,%esp
 4db:	6a 01                	push   $0x1
 4dd:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4e0:	50                   	push   %eax
 4e1:	ff 75 08             	pushl  0x8(%ebp)
 4e4:	e8 fb fd ff ff       	call   2e4 <write>
 4e9:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ec:	bf 00 00 00 00       	mov    $0x0,%edi
 4f1:	eb 80                	jmp    473 <printf+0x45>
        printint(fd, *ap, 10, 1);
 4f3:	83 ec 0c             	sub    $0xc,%esp
 4f6:	6a 01                	push   $0x1
 4f8:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4fd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 500:	8b 17                	mov    (%edi),%edx
 502:	8b 45 08             	mov    0x8(%ebp),%eax
 505:	e8 9a fe ff ff       	call   3a4 <printint>
        ap++;
 50a:	89 f8                	mov    %edi,%eax
 50c:	83 c0 04             	add    $0x4,%eax
 50f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 512:	83 c4 10             	add    $0x10,%esp
      state = 0;
 515:	bf 00 00 00 00       	mov    $0x0,%edi
 51a:	e9 54 ff ff ff       	jmp    473 <printf+0x45>
        printint(fd, *ap, 16, 0);
 51f:	83 ec 0c             	sub    $0xc,%esp
 522:	6a 00                	push   $0x0
 524:	b9 10 00 00 00       	mov    $0x10,%ecx
 529:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 52c:	8b 17                	mov    (%edi),%edx
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	e8 6e fe ff ff       	call   3a4 <printint>
        ap++;
 536:	89 f8                	mov    %edi,%eax
 538:	83 c0 04             	add    $0x4,%eax
 53b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 53e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 541:	bf 00 00 00 00       	mov    $0x0,%edi
 546:	e9 28 ff ff ff       	jmp    473 <printf+0x45>
        s = (char*)*ap;
 54b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 54e:	8b 01                	mov    (%ecx),%eax
        ap++;
 550:	83 c1 04             	add    $0x4,%ecx
 553:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 556:	85 c0                	test   %eax,%eax
 558:	74 13                	je     56d <printf+0x13f>
        s = (char*)*ap;
 55a:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 55c:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 55f:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 564:	84 c0                	test   %al,%al
 566:	75 0f                	jne    577 <printf+0x149>
 568:	e9 06 ff ff ff       	jmp    473 <printf+0x45>
          s = "(null)";
 56d:	bb 4d 07 00 00       	mov    $0x74d,%ebx
        while(*s != 0){
 572:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 577:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 57a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 57d:	8b 75 08             	mov    0x8(%ebp),%esi
 580:	88 45 e3             	mov    %al,-0x1d(%ebp)
 583:	83 ec 04             	sub    $0x4,%esp
 586:	6a 01                	push   $0x1
 588:	57                   	push   %edi
 589:	56                   	push   %esi
 58a:	e8 55 fd ff ff       	call   2e4 <write>
          s++;
 58f:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 592:	0f b6 03             	movzbl (%ebx),%eax
 595:	83 c4 10             	add    $0x10,%esp
 598:	84 c0                	test   %al,%al
 59a:	75 e4                	jne    580 <printf+0x152>
 59c:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 59f:	bf 00 00 00 00       	mov    $0x0,%edi
 5a4:	e9 ca fe ff ff       	jmp    473 <printf+0x45>
        putc(fd, *ap);
 5a9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5ac:	8b 07                	mov    (%edi),%eax
 5ae:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5b1:	83 ec 04             	sub    $0x4,%esp
 5b4:	6a 01                	push   $0x1
 5b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5b9:	50                   	push   %eax
 5ba:	ff 75 08             	pushl  0x8(%ebp)
 5bd:	e8 22 fd ff ff       	call   2e4 <write>
        ap++;
 5c2:	83 c7 04             	add    $0x4,%edi
 5c5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5c8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5cb:	bf 00 00 00 00       	mov    $0x0,%edi
 5d0:	e9 9e fe ff ff       	jmp    473 <printf+0x45>
 5d5:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 5d8:	83 ec 04             	sub    $0x4,%esp
 5db:	6a 01                	push   $0x1
 5dd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5e0:	50                   	push   %eax
 5e1:	ff 75 08             	pushl  0x8(%ebp)
 5e4:	e8 fb fc ff ff       	call   2e4 <write>
 5e9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ec:	bf 00 00 00 00       	mov    $0x0,%edi
 5f1:	e9 7d fe ff ff       	jmp    473 <printf+0x45>
    }
  }
}
 5f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f9:	5b                   	pop    %ebx
 5fa:	5e                   	pop    %esi
 5fb:	5f                   	pop    %edi
 5fc:	5d                   	pop    %ebp
 5fd:	c3                   	ret    

000005fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5fe:	55                   	push   %ebp
 5ff:	89 e5                	mov    %esp,%ebp
 601:	57                   	push   %edi
 602:	56                   	push   %esi
 603:	53                   	push   %ebx
 604:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 607:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60a:	a1 f8 09 00 00       	mov    0x9f8,%eax
 60f:	eb 0c                	jmp    61d <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 611:	8b 10                	mov    (%eax),%edx
 613:	39 c2                	cmp    %eax,%edx
 615:	77 04                	ja     61b <free+0x1d>
 617:	39 ca                	cmp    %ecx,%edx
 619:	77 10                	ja     62b <free+0x2d>
{
 61b:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61d:	39 c8                	cmp    %ecx,%eax
 61f:	73 f0                	jae    611 <free+0x13>
 621:	8b 10                	mov    (%eax),%edx
 623:	39 ca                	cmp    %ecx,%edx
 625:	77 04                	ja     62b <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 627:	39 c2                	cmp    %eax,%edx
 629:	77 f0                	ja     61b <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 62b:	8b 73 fc             	mov    -0x4(%ebx),%esi
 62e:	8b 10                	mov    (%eax),%edx
 630:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 633:	39 fa                	cmp    %edi,%edx
 635:	74 19                	je     650 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 637:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 63a:	8b 50 04             	mov    0x4(%eax),%edx
 63d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 640:	39 f1                	cmp    %esi,%ecx
 642:	74 1b                	je     65f <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 644:	89 08                	mov    %ecx,(%eax)
  freep = p;
 646:	a3 f8 09 00 00       	mov    %eax,0x9f8
}
 64b:	5b                   	pop    %ebx
 64c:	5e                   	pop    %esi
 64d:	5f                   	pop    %edi
 64e:	5d                   	pop    %ebp
 64f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 650:	03 72 04             	add    0x4(%edx),%esi
 653:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 656:	8b 10                	mov    (%eax),%edx
 658:	8b 12                	mov    (%edx),%edx
 65a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 65d:	eb db                	jmp    63a <free+0x3c>
    p->s.size += bp->s.size;
 65f:	03 53 fc             	add    -0x4(%ebx),%edx
 662:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 665:	8b 53 f8             	mov    -0x8(%ebx),%edx
 668:	89 10                	mov    %edx,(%eax)
 66a:	eb da                	jmp    646 <free+0x48>

0000066c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 66c:	55                   	push   %ebp
 66d:	89 e5                	mov    %esp,%ebp
 66f:	57                   	push   %edi
 670:	56                   	push   %esi
 671:	53                   	push   %ebx
 672:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	8d 58 07             	lea    0x7(%eax),%ebx
 67b:	c1 eb 03             	shr    $0x3,%ebx
 67e:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 681:	8b 15 f8 09 00 00    	mov    0x9f8,%edx
 687:	85 d2                	test   %edx,%edx
 689:	74 20                	je     6ab <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 68b:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 68d:	8b 48 04             	mov    0x4(%eax),%ecx
 690:	39 cb                	cmp    %ecx,%ebx
 692:	76 3c                	jbe    6d0 <malloc+0x64>
 694:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 69a:	be 00 10 00 00       	mov    $0x1000,%esi
 69f:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 6a2:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 6a9:	eb 70                	jmp    71b <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 6ab:	c7 05 f8 09 00 00 fc 	movl   $0x9fc,0x9f8
 6b2:	09 00 00 
 6b5:	c7 05 fc 09 00 00 fc 	movl   $0x9fc,0x9fc
 6bc:	09 00 00 
    base.s.size = 0;
 6bf:	c7 05 00 0a 00 00 00 	movl   $0x0,0xa00
 6c6:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6c9:	ba fc 09 00 00       	mov    $0x9fc,%edx
 6ce:	eb bb                	jmp    68b <malloc+0x1f>
      if(p->s.size == nunits)
 6d0:	39 cb                	cmp    %ecx,%ebx
 6d2:	74 1c                	je     6f0 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6d4:	29 d9                	sub    %ebx,%ecx
 6d6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6d9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6dc:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6df:	89 15 f8 09 00 00    	mov    %edx,0x9f8
      return (void*)(p + 1);
 6e5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6eb:	5b                   	pop    %ebx
 6ec:	5e                   	pop    %esi
 6ed:	5f                   	pop    %edi
 6ee:	5d                   	pop    %ebp
 6ef:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6f0:	8b 08                	mov    (%eax),%ecx
 6f2:	89 0a                	mov    %ecx,(%edx)
 6f4:	eb e9                	jmp    6df <malloc+0x73>
  hp->s.size = nu;
 6f6:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6f9:	83 ec 0c             	sub    $0xc,%esp
 6fc:	83 c0 08             	add    $0x8,%eax
 6ff:	50                   	push   %eax
 700:	e8 f9 fe ff ff       	call   5fe <free>
  return freep;
 705:	8b 15 f8 09 00 00    	mov    0x9f8,%edx
      if((p = morecore(nunits)) == 0)
 70b:	83 c4 10             	add    $0x10,%esp
 70e:	85 d2                	test   %edx,%edx
 710:	74 2b                	je     73d <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 712:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 714:	8b 48 04             	mov    0x4(%eax),%ecx
 717:	39 d9                	cmp    %ebx,%ecx
 719:	73 b5                	jae    6d0 <malloc+0x64>
 71b:	89 c2                	mov    %eax,%edx
    if(p == freep)
 71d:	39 05 f8 09 00 00    	cmp    %eax,0x9f8
 723:	75 ed                	jne    712 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 725:	83 ec 0c             	sub    $0xc,%esp
 728:	57                   	push   %edi
 729:	e8 1e fc ff ff       	call   34c <sbrk>
  if(p == (char*)-1)
 72e:	83 c4 10             	add    $0x10,%esp
 731:	83 f8 ff             	cmp    $0xffffffff,%eax
 734:	75 c0                	jne    6f6 <malloc+0x8a>
        return 0;
 736:	b8 00 00 00 00       	mov    $0x0,%eax
 73b:	eb ab                	jmp    6e8 <malloc+0x7c>
 73d:	b8 00 00 00 00       	mov    $0x0,%eax
 742:	eb a4                	jmp    6e8 <malloc+0x7c>
