
_testsetuid:     file format elf32-i386


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
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  printf(1, "***** In %s: my uid is %d\n\n", argv[0], getuid());
  12:	e8 21 03 00 00       	call   338 <getuid>
  17:	50                   	push   %eax
  18:	ff 33                	pushl  (%ebx)
  1a:	68 08 07 00 00       	push   $0x708
  1f:	6a 01                	push   $0x1
  21:	e8 cc 03 00 00       	call   3f2 <printf>
  exit();
  26:	e8 5d 02 00 00       	call   288 <exit>

0000002b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  2b:	55                   	push   %ebp
  2c:	89 e5                	mov    %esp,%ebp
  2e:	53                   	push   %ebx
  2f:	8b 45 08             	mov    0x8(%ebp),%eax
  32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  35:	89 c2                	mov    %eax,%edx
  37:	83 c1 01             	add    $0x1,%ecx
  3a:	83 c2 01             	add    $0x1,%edx
  3d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  41:	88 5a ff             	mov    %bl,-0x1(%edx)
  44:	84 db                	test   %bl,%bl
  46:	75 ef                	jne    37 <strcpy+0xc>
    ;
  return os;
}
  48:	5b                   	pop    %ebx
  49:	5d                   	pop    %ebp
  4a:	c3                   	ret    

0000004b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4b:	55                   	push   %ebp
  4c:	89 e5                	mov    %esp,%ebp
  4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  51:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  54:	0f b6 01             	movzbl (%ecx),%eax
  57:	84 c0                	test   %al,%al
  59:	74 15                	je     70 <strcmp+0x25>
  5b:	3a 02                	cmp    (%edx),%al
  5d:	75 11                	jne    70 <strcmp+0x25>
    p++, q++;
  5f:	83 c1 01             	add    $0x1,%ecx
  62:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  65:	0f b6 01             	movzbl (%ecx),%eax
  68:	84 c0                	test   %al,%al
  6a:	74 04                	je     70 <strcmp+0x25>
  6c:	3a 02                	cmp    (%edx),%al
  6e:	74 ef                	je     5f <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  70:	0f b6 c0             	movzbl %al,%eax
  73:	0f b6 12             	movzbl (%edx),%edx
  76:	29 d0                	sub    %edx,%eax
}
  78:	5d                   	pop    %ebp
  79:	c3                   	ret    

0000007a <strlen>:

uint
strlen(char *s)
{
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  80:	80 39 00             	cmpb   $0x0,(%ecx)
  83:	74 12                	je     97 <strlen+0x1d>
  85:	ba 00 00 00 00       	mov    $0x0,%edx
  8a:	83 c2 01             	add    $0x1,%edx
  8d:	89 d0                	mov    %edx,%eax
  8f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  93:	75 f5                	jne    8a <strlen+0x10>
    ;
  return n;
}
  95:	5d                   	pop    %ebp
  96:	c3                   	ret    
  for(n = 0; s[n]; n++)
  97:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  9c:	eb f7                	jmp    95 <strlen+0x1b>

0000009e <memset>:

void*
memset(void *dst, int c, uint n)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	57                   	push   %edi
  a2:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  a5:	89 d7                	mov    %edx,%edi
  a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  ad:	fc                   	cld    
  ae:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b0:	89 d0                	mov    %edx,%eax
  b2:	5f                   	pop    %edi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strchr>:

char*
strchr(const char *s, char c)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	53                   	push   %ebx
  b9:	8b 45 08             	mov    0x8(%ebp),%eax
  bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  bf:	0f b6 10             	movzbl (%eax),%edx
  c2:	84 d2                	test   %dl,%dl
  c4:	74 1e                	je     e4 <strchr+0x2f>
  c6:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
  c8:	38 d3                	cmp    %dl,%bl
  ca:	74 15                	je     e1 <strchr+0x2c>
  for(; *s; s++)
  cc:	83 c0 01             	add    $0x1,%eax
  cf:	0f b6 10             	movzbl (%eax),%edx
  d2:	84 d2                	test   %dl,%dl
  d4:	74 06                	je     dc <strchr+0x27>
    if(*s == c)
  d6:	38 ca                	cmp    %cl,%dl
  d8:	75 f2                	jne    cc <strchr+0x17>
  da:	eb 05                	jmp    e1 <strchr+0x2c>
      return (char*)s;
  return 0;
  dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e1:	5b                   	pop    %ebx
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    
  return 0;
  e4:	b8 00 00 00 00       	mov    $0x0,%eax
  e9:	eb f6                	jmp    e1 <strchr+0x2c>

000000eb <gets>:

char*
gets(char *buf, int max)
{
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  ee:	57                   	push   %edi
  ef:	56                   	push   %esi
  f0:	53                   	push   %ebx
  f1:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f4:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
  f9:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
  fc:	8d 5e 01             	lea    0x1(%esi),%ebx
  ff:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 102:	7d 2b                	jge    12f <gets+0x44>
    cc = read(0, &c, 1);
 104:	83 ec 04             	sub    $0x4,%esp
 107:	6a 01                	push   $0x1
 109:	57                   	push   %edi
 10a:	6a 00                	push   $0x0
 10c:	e8 8f 01 00 00       	call   2a0 <read>
    if(cc < 1)
 111:	83 c4 10             	add    $0x10,%esp
 114:	85 c0                	test   %eax,%eax
 116:	7e 17                	jle    12f <gets+0x44>
      break;
    buf[i++] = c;
 118:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 11c:	8b 55 08             	mov    0x8(%ebp),%edx
 11f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 123:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 125:	3c 0a                	cmp    $0xa,%al
 127:	74 04                	je     12d <gets+0x42>
 129:	3c 0d                	cmp    $0xd,%al
 12b:	75 cf                	jne    fc <gets+0x11>
  for(i=0; i+1 < max; ){
 12d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 136:	8d 65 f4             	lea    -0xc(%ebp),%esp
 139:	5b                   	pop    %ebx
 13a:	5e                   	pop    %esi
 13b:	5f                   	pop    %edi
 13c:	5d                   	pop    %ebp
 13d:	c3                   	ret    

0000013e <stat>:

int
stat(char *n, struct stat *st)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	56                   	push   %esi
 142:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 143:	83 ec 08             	sub    $0x8,%esp
 146:	6a 00                	push   $0x0
 148:	ff 75 08             	pushl  0x8(%ebp)
 14b:	e8 78 01 00 00       	call   2c8 <open>
  if(fd < 0)
 150:	83 c4 10             	add    $0x10,%esp
 153:	85 c0                	test   %eax,%eax
 155:	78 24                	js     17b <stat+0x3d>
 157:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 159:	83 ec 08             	sub    $0x8,%esp
 15c:	ff 75 0c             	pushl  0xc(%ebp)
 15f:	50                   	push   %eax
 160:	e8 7b 01 00 00       	call   2e0 <fstat>
 165:	89 c6                	mov    %eax,%esi
  close(fd);
 167:	89 1c 24             	mov    %ebx,(%esp)
 16a:	e8 41 01 00 00       	call   2b0 <close>
  return r;
 16f:	83 c4 10             	add    $0x10,%esp
}
 172:	89 f0                	mov    %esi,%eax
 174:	8d 65 f8             	lea    -0x8(%ebp),%esp
 177:	5b                   	pop    %ebx
 178:	5e                   	pop    %esi
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret    
    return -1;
 17b:	be ff ff ff ff       	mov    $0xffffffff,%esi
 180:	eb f0                	jmp    172 <stat+0x34>

00000182 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
 185:	56                   	push   %esi
 186:	53                   	push   %ebx
 187:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 18a:	0f b6 0a             	movzbl (%edx),%ecx
 18d:	80 f9 20             	cmp    $0x20,%cl
 190:	75 0b                	jne    19d <atoi+0x1b>
 192:	83 c2 01             	add    $0x1,%edx
 195:	0f b6 0a             	movzbl (%edx),%ecx
 198:	80 f9 20             	cmp    $0x20,%cl
 19b:	74 f5                	je     192 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 19d:	80 f9 2d             	cmp    $0x2d,%cl
 1a0:	74 3b                	je     1dd <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 1a2:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 1a5:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 1aa:	f6 c1 fd             	test   $0xfd,%cl
 1ad:	74 33                	je     1e2 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 1af:	0f b6 0a             	movzbl (%edx),%ecx
 1b2:	8d 41 d0             	lea    -0x30(%ecx),%eax
 1b5:	3c 09                	cmp    $0x9,%al
 1b7:	77 2e                	ja     1e7 <atoi+0x65>
 1b9:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1be:	83 c2 01             	add    $0x1,%edx
 1c1:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1c4:	0f be c9             	movsbl %cl,%ecx
 1c7:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 1cb:	0f b6 0a             	movzbl (%edx),%ecx
 1ce:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1d1:	80 fb 09             	cmp    $0x9,%bl
 1d4:	76 e8                	jbe    1be <atoi+0x3c>
  return sign*n;
 1d6:	0f af c6             	imul   %esi,%eax
}
 1d9:	5b                   	pop    %ebx
 1da:	5e                   	pop    %esi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 1dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 1e2:	83 c2 01             	add    $0x1,%edx
 1e5:	eb c8                	jmp    1af <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 1e7:	b8 00 00 00 00       	mov    $0x0,%eax
 1ec:	eb e8                	jmp    1d6 <atoi+0x54>

000001ee <atoo>:

int
atoo(const char *s)
{
 1ee:	55                   	push   %ebp
 1ef:	89 e5                	mov    %esp,%ebp
 1f1:	56                   	push   %esi
 1f2:	53                   	push   %ebx
 1f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1f6:	0f b6 0a             	movzbl (%edx),%ecx
 1f9:	80 f9 20             	cmp    $0x20,%cl
 1fc:	75 0b                	jne    209 <atoo+0x1b>
 1fe:	83 c2 01             	add    $0x1,%edx
 201:	0f b6 0a             	movzbl (%edx),%ecx
 204:	80 f9 20             	cmp    $0x20,%cl
 207:	74 f5                	je     1fe <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 209:	80 f9 2d             	cmp    $0x2d,%cl
 20c:	74 38                	je     246 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 20e:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 211:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 216:	f6 c1 fd             	test   $0xfd,%cl
 219:	74 30                	je     24b <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 21b:	0f b6 0a             	movzbl (%edx),%ecx
 21e:	8d 41 d0             	lea    -0x30(%ecx),%eax
 221:	3c 07                	cmp    $0x7,%al
 223:	77 2b                	ja     250 <atoo+0x62>
 225:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 22a:	83 c2 01             	add    $0x1,%edx
 22d:	0f be c9             	movsbl %cl,%ecx
 230:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 234:	0f b6 0a             	movzbl (%edx),%ecx
 237:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 23a:	80 fb 07             	cmp    $0x7,%bl
 23d:	76 eb                	jbe    22a <atoo+0x3c>
  return sign*n;
 23f:	0f af c6             	imul   %esi,%eax
}
 242:	5b                   	pop    %ebx
 243:	5e                   	pop    %esi
 244:	5d                   	pop    %ebp
 245:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 246:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 24b:	83 c2 01             	add    $0x1,%edx
 24e:	eb cb                	jmp    21b <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 250:	b8 00 00 00 00       	mov    $0x0,%eax
 255:	eb e8                	jmp    23f <atoo+0x51>

00000257 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	56                   	push   %esi
 25b:	53                   	push   %ebx
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	8b 75 0c             	mov    0xc(%ebp),%esi
 262:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 265:	85 db                	test   %ebx,%ebx
 267:	7e 13                	jle    27c <memmove+0x25>
 269:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 26e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 272:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 275:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 278:	39 d3                	cmp    %edx,%ebx
 27a:	75 f2                	jne    26e <memmove+0x17>
  return vdst;
}
 27c:	5b                   	pop    %ebx
 27d:	5e                   	pop    %esi
 27e:	5d                   	pop    %ebp
 27f:	c3                   	ret    

00000280 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 280:	b8 01 00 00 00       	mov    $0x1,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <exit>:
SYSCALL(exit)
 288:	b8 02 00 00 00       	mov    $0x2,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <wait>:
SYSCALL(wait)
 290:	b8 03 00 00 00       	mov    $0x3,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <pipe>:
SYSCALL(pipe)
 298:	b8 04 00 00 00       	mov    $0x4,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <read>:
SYSCALL(read)
 2a0:	b8 05 00 00 00       	mov    $0x5,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <write>:
SYSCALL(write)
 2a8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <close>:
SYSCALL(close)
 2b0:	b8 15 00 00 00       	mov    $0x15,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <kill>:
SYSCALL(kill)
 2b8:	b8 06 00 00 00       	mov    $0x6,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <exec>:
SYSCALL(exec)
 2c0:	b8 07 00 00 00       	mov    $0x7,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <open>:
SYSCALL(open)
 2c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <mknod>:
SYSCALL(mknod)
 2d0:	b8 11 00 00 00       	mov    $0x11,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <unlink>:
SYSCALL(unlink)
 2d8:	b8 12 00 00 00       	mov    $0x12,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <fstat>:
SYSCALL(fstat)
 2e0:	b8 08 00 00 00       	mov    $0x8,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <link>:
SYSCALL(link)
 2e8:	b8 13 00 00 00       	mov    $0x13,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <mkdir>:
SYSCALL(mkdir)
 2f0:	b8 14 00 00 00       	mov    $0x14,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <chdir>:
SYSCALL(chdir)
 2f8:	b8 09 00 00 00       	mov    $0x9,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <dup>:
SYSCALL(dup)
 300:	b8 0a 00 00 00       	mov    $0xa,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <getpid>:
SYSCALL(getpid)
 308:	b8 0b 00 00 00       	mov    $0xb,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <sbrk>:
SYSCALL(sbrk)
 310:	b8 0c 00 00 00       	mov    $0xc,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <sleep>:
SYSCALL(sleep)
 318:	b8 0d 00 00 00       	mov    $0xd,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <uptime>:
SYSCALL(uptime)
 320:	b8 0e 00 00 00       	mov    $0xe,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <halt>:
SYSCALL(halt)
 328:	b8 16 00 00 00       	mov    $0x16,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <date>:
//proj1
SYSCALL(date)
 330:	b8 17 00 00 00       	mov    $0x17,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <getuid>:
//proj2
SYSCALL(getuid)
 338:	b8 18 00 00 00       	mov    $0x18,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <getgid>:
SYSCALL(getgid)
 340:	b8 19 00 00 00       	mov    $0x19,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <getppid>:
SYSCALL(getppid)
 348:	b8 1a 00 00 00       	mov    $0x1a,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <setuid>:
SYSCALL(setuid)
 350:	b8 1b 00 00 00       	mov    $0x1b,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <setgid>:
SYSCALL(setgid)
 358:	b8 1c 00 00 00       	mov    $0x1c,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <getprocs>:
SYSCALL(getprocs)
 360:	b8 1d 00 00 00       	mov    $0x1d,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	57                   	push   %edi
 36c:	56                   	push   %esi
 36d:	53                   	push   %ebx
 36e:	83 ec 3c             	sub    $0x3c,%esp
 371:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 373:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 377:	74 14                	je     38d <printint+0x25>
 379:	85 d2                	test   %edx,%edx
 37b:	79 10                	jns    38d <printint+0x25>
    neg = 1;
    x = -xx;
 37d:	f7 da                	neg    %edx
    neg = 1;
 37f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 386:	bf 00 00 00 00       	mov    $0x0,%edi
 38b:	eb 0b                	jmp    398 <printint+0x30>
  neg = 0;
 38d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 394:	eb f0                	jmp    386 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 396:	89 df                	mov    %ebx,%edi
 398:	8d 5f 01             	lea    0x1(%edi),%ebx
 39b:	89 d0                	mov    %edx,%eax
 39d:	ba 00 00 00 00       	mov    $0x0,%edx
 3a2:	f7 f1                	div    %ecx
 3a4:	0f b6 92 2c 07 00 00 	movzbl 0x72c(%edx),%edx
 3ab:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3af:	89 c2                	mov    %eax,%edx
 3b1:	85 c0                	test   %eax,%eax
 3b3:	75 e1                	jne    396 <printint+0x2e>
  if(neg)
 3b5:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3b9:	74 08                	je     3c3 <printint+0x5b>
    buf[i++] = '-';
 3bb:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3c0:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3c3:	83 eb 01             	sub    $0x1,%ebx
 3c6:	78 22                	js     3ea <printint+0x82>
  write(fd, &c, 1);
 3c8:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3cb:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 3d0:	88 45 d7             	mov    %al,-0x29(%ebp)
 3d3:	83 ec 04             	sub    $0x4,%esp
 3d6:	6a 01                	push   $0x1
 3d8:	57                   	push   %edi
 3d9:	56                   	push   %esi
 3da:	e8 c9 fe ff ff       	call   2a8 <write>
  while(--i >= 0)
 3df:	83 eb 01             	sub    $0x1,%ebx
 3e2:	83 c4 10             	add    $0x10,%esp
 3e5:	83 fb ff             	cmp    $0xffffffff,%ebx
 3e8:	75 e1                	jne    3cb <printint+0x63>
    putc(fd, buf[i]);
}
 3ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ed:	5b                   	pop    %ebx
 3ee:	5e                   	pop    %esi
 3ef:	5f                   	pop    %edi
 3f0:	5d                   	pop    %ebp
 3f1:	c3                   	ret    

000003f2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	57                   	push   %edi
 3f6:	56                   	push   %esi
 3f7:	53                   	push   %ebx
 3f8:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3fb:	8b 75 0c             	mov    0xc(%ebp),%esi
 3fe:	0f b6 1e             	movzbl (%esi),%ebx
 401:	84 db                	test   %bl,%bl
 403:	0f 84 b1 01 00 00    	je     5ba <printf+0x1c8>
 409:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 40c:	8d 45 10             	lea    0x10(%ebp),%eax
 40f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 412:	bf 00 00 00 00       	mov    $0x0,%edi
 417:	eb 2d                	jmp    446 <printf+0x54>
 419:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 41c:	83 ec 04             	sub    $0x4,%esp
 41f:	6a 01                	push   $0x1
 421:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 424:	50                   	push   %eax
 425:	ff 75 08             	pushl  0x8(%ebp)
 428:	e8 7b fe ff ff       	call   2a8 <write>
 42d:	83 c4 10             	add    $0x10,%esp
 430:	eb 05                	jmp    437 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 432:	83 ff 25             	cmp    $0x25,%edi
 435:	74 22                	je     459 <printf+0x67>
 437:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 43a:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 43e:	84 db                	test   %bl,%bl
 440:	0f 84 74 01 00 00    	je     5ba <printf+0x1c8>
    c = fmt[i] & 0xff;
 446:	0f be d3             	movsbl %bl,%edx
 449:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 44c:	85 ff                	test   %edi,%edi
 44e:	75 e2                	jne    432 <printf+0x40>
      if(c == '%'){
 450:	83 f8 25             	cmp    $0x25,%eax
 453:	75 c4                	jne    419 <printf+0x27>
        state = '%';
 455:	89 c7                	mov    %eax,%edi
 457:	eb de                	jmp    437 <printf+0x45>
      if(c == 'd'){
 459:	83 f8 64             	cmp    $0x64,%eax
 45c:	74 59                	je     4b7 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 45e:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 464:	83 fa 70             	cmp    $0x70,%edx
 467:	74 7a                	je     4e3 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 469:	83 f8 73             	cmp    $0x73,%eax
 46c:	0f 84 9d 00 00 00    	je     50f <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 472:	83 f8 63             	cmp    $0x63,%eax
 475:	0f 84 f2 00 00 00    	je     56d <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 47b:	83 f8 25             	cmp    $0x25,%eax
 47e:	0f 84 15 01 00 00    	je     599 <printf+0x1a7>
 484:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 488:	83 ec 04             	sub    $0x4,%esp
 48b:	6a 01                	push   $0x1
 48d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 490:	50                   	push   %eax
 491:	ff 75 08             	pushl  0x8(%ebp)
 494:	e8 0f fe ff ff       	call   2a8 <write>
 499:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 49c:	83 c4 0c             	add    $0xc,%esp
 49f:	6a 01                	push   $0x1
 4a1:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4a4:	50                   	push   %eax
 4a5:	ff 75 08             	pushl  0x8(%ebp)
 4a8:	e8 fb fd ff ff       	call   2a8 <write>
 4ad:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b0:	bf 00 00 00 00       	mov    $0x0,%edi
 4b5:	eb 80                	jmp    437 <printf+0x45>
        printint(fd, *ap, 10, 1);
 4b7:	83 ec 0c             	sub    $0xc,%esp
 4ba:	6a 01                	push   $0x1
 4bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4c1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4c4:	8b 17                	mov    (%edi),%edx
 4c6:	8b 45 08             	mov    0x8(%ebp),%eax
 4c9:	e8 9a fe ff ff       	call   368 <printint>
        ap++;
 4ce:	89 f8                	mov    %edi,%eax
 4d0:	83 c0 04             	add    $0x4,%eax
 4d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4d6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4d9:	bf 00 00 00 00       	mov    $0x0,%edi
 4de:	e9 54 ff ff ff       	jmp    437 <printf+0x45>
        printint(fd, *ap, 16, 0);
 4e3:	83 ec 0c             	sub    $0xc,%esp
 4e6:	6a 00                	push   $0x0
 4e8:	b9 10 00 00 00       	mov    $0x10,%ecx
 4ed:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4f0:	8b 17                	mov    (%edi),%edx
 4f2:	8b 45 08             	mov    0x8(%ebp),%eax
 4f5:	e8 6e fe ff ff       	call   368 <printint>
        ap++;
 4fa:	89 f8                	mov    %edi,%eax
 4fc:	83 c0 04             	add    $0x4,%eax
 4ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 502:	83 c4 10             	add    $0x10,%esp
      state = 0;
 505:	bf 00 00 00 00       	mov    $0x0,%edi
 50a:	e9 28 ff ff ff       	jmp    437 <printf+0x45>
        s = (char*)*ap;
 50f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 512:	8b 01                	mov    (%ecx),%eax
        ap++;
 514:	83 c1 04             	add    $0x4,%ecx
 517:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 51a:	85 c0                	test   %eax,%eax
 51c:	74 13                	je     531 <printf+0x13f>
        s = (char*)*ap;
 51e:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 520:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 523:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 528:	84 c0                	test   %al,%al
 52a:	75 0f                	jne    53b <printf+0x149>
 52c:	e9 06 ff ff ff       	jmp    437 <printf+0x45>
          s = "(null)";
 531:	bb 24 07 00 00       	mov    $0x724,%ebx
        while(*s != 0){
 536:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 53b:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 53e:	89 75 d0             	mov    %esi,-0x30(%ebp)
 541:	8b 75 08             	mov    0x8(%ebp),%esi
 544:	88 45 e3             	mov    %al,-0x1d(%ebp)
 547:	83 ec 04             	sub    $0x4,%esp
 54a:	6a 01                	push   $0x1
 54c:	57                   	push   %edi
 54d:	56                   	push   %esi
 54e:	e8 55 fd ff ff       	call   2a8 <write>
          s++;
 553:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 556:	0f b6 03             	movzbl (%ebx),%eax
 559:	83 c4 10             	add    $0x10,%esp
 55c:	84 c0                	test   %al,%al
 55e:	75 e4                	jne    544 <printf+0x152>
 560:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 563:	bf 00 00 00 00       	mov    $0x0,%edi
 568:	e9 ca fe ff ff       	jmp    437 <printf+0x45>
        putc(fd, *ap);
 56d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 570:	8b 07                	mov    (%edi),%eax
 572:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 575:	83 ec 04             	sub    $0x4,%esp
 578:	6a 01                	push   $0x1
 57a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 57d:	50                   	push   %eax
 57e:	ff 75 08             	pushl  0x8(%ebp)
 581:	e8 22 fd ff ff       	call   2a8 <write>
        ap++;
 586:	83 c7 04             	add    $0x4,%edi
 589:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 58c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58f:	bf 00 00 00 00       	mov    $0x0,%edi
 594:	e9 9e fe ff ff       	jmp    437 <printf+0x45>
 599:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 59c:	83 ec 04             	sub    $0x4,%esp
 59f:	6a 01                	push   $0x1
 5a1:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5a4:	50                   	push   %eax
 5a5:	ff 75 08             	pushl  0x8(%ebp)
 5a8:	e8 fb fc ff ff       	call   2a8 <write>
 5ad:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b0:	bf 00 00 00 00       	mov    $0x0,%edi
 5b5:	e9 7d fe ff ff       	jmp    437 <printf+0x45>
    }
  }
}
 5ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5bd:	5b                   	pop    %ebx
 5be:	5e                   	pop    %esi
 5bf:	5f                   	pop    %edi
 5c0:	5d                   	pop    %ebp
 5c1:	c3                   	ret    

000005c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c2:	55                   	push   %ebp
 5c3:	89 e5                	mov    %esp,%ebp
 5c5:	57                   	push   %edi
 5c6:	56                   	push   %esi
 5c7:	53                   	push   %ebx
 5c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5cb:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ce:	a1 c8 09 00 00       	mov    0x9c8,%eax
 5d3:	eb 0c                	jmp    5e1 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d5:	8b 10                	mov    (%eax),%edx
 5d7:	39 c2                	cmp    %eax,%edx
 5d9:	77 04                	ja     5df <free+0x1d>
 5db:	39 ca                	cmp    %ecx,%edx
 5dd:	77 10                	ja     5ef <free+0x2d>
{
 5df:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	39 c8                	cmp    %ecx,%eax
 5e3:	73 f0                	jae    5d5 <free+0x13>
 5e5:	8b 10                	mov    (%eax),%edx
 5e7:	39 ca                	cmp    %ecx,%edx
 5e9:	77 04                	ja     5ef <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5eb:	39 c2                	cmp    %eax,%edx
 5ed:	77 f0                	ja     5df <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5ef:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5f2:	8b 10                	mov    (%eax),%edx
 5f4:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5f7:	39 fa                	cmp    %edi,%edx
 5f9:	74 19                	je     614 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5fb:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5fe:	8b 50 04             	mov    0x4(%eax),%edx
 601:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 604:	39 f1                	cmp    %esi,%ecx
 606:	74 1b                	je     623 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 608:	89 08                	mov    %ecx,(%eax)
  freep = p;
 60a:	a3 c8 09 00 00       	mov    %eax,0x9c8
}
 60f:	5b                   	pop    %ebx
 610:	5e                   	pop    %esi
 611:	5f                   	pop    %edi
 612:	5d                   	pop    %ebp
 613:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 614:	03 72 04             	add    0x4(%edx),%esi
 617:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 61a:	8b 10                	mov    (%eax),%edx
 61c:	8b 12                	mov    (%edx),%edx
 61e:	89 53 f8             	mov    %edx,-0x8(%ebx)
 621:	eb db                	jmp    5fe <free+0x3c>
    p->s.size += bp->s.size;
 623:	03 53 fc             	add    -0x4(%ebx),%edx
 626:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 629:	8b 53 f8             	mov    -0x8(%ebx),%edx
 62c:	89 10                	mov    %edx,(%eax)
 62e:	eb da                	jmp    60a <free+0x48>

00000630 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
 636:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	8d 58 07             	lea    0x7(%eax),%ebx
 63f:	c1 eb 03             	shr    $0x3,%ebx
 642:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 645:	8b 15 c8 09 00 00    	mov    0x9c8,%edx
 64b:	85 d2                	test   %edx,%edx
 64d:	74 20                	je     66f <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 64f:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 651:	8b 48 04             	mov    0x4(%eax),%ecx
 654:	39 cb                	cmp    %ecx,%ebx
 656:	76 3c                	jbe    694 <malloc+0x64>
 658:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 65e:	be 00 10 00 00       	mov    $0x1000,%esi
 663:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 666:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 66d:	eb 70                	jmp    6df <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 66f:	c7 05 c8 09 00 00 cc 	movl   $0x9cc,0x9c8
 676:	09 00 00 
 679:	c7 05 cc 09 00 00 cc 	movl   $0x9cc,0x9cc
 680:	09 00 00 
    base.s.size = 0;
 683:	c7 05 d0 09 00 00 00 	movl   $0x0,0x9d0
 68a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 68d:	ba cc 09 00 00       	mov    $0x9cc,%edx
 692:	eb bb                	jmp    64f <malloc+0x1f>
      if(p->s.size == nunits)
 694:	39 cb                	cmp    %ecx,%ebx
 696:	74 1c                	je     6b4 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 698:	29 d9                	sub    %ebx,%ecx
 69a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 69d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6a0:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6a3:	89 15 c8 09 00 00    	mov    %edx,0x9c8
      return (void*)(p + 1);
 6a9:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6af:	5b                   	pop    %ebx
 6b0:	5e                   	pop    %esi
 6b1:	5f                   	pop    %edi
 6b2:	5d                   	pop    %ebp
 6b3:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6b4:	8b 08                	mov    (%eax),%ecx
 6b6:	89 0a                	mov    %ecx,(%edx)
 6b8:	eb e9                	jmp    6a3 <malloc+0x73>
  hp->s.size = nu;
 6ba:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6bd:	83 ec 0c             	sub    $0xc,%esp
 6c0:	83 c0 08             	add    $0x8,%eax
 6c3:	50                   	push   %eax
 6c4:	e8 f9 fe ff ff       	call   5c2 <free>
  return freep;
 6c9:	8b 15 c8 09 00 00    	mov    0x9c8,%edx
      if((p = morecore(nunits)) == 0)
 6cf:	83 c4 10             	add    $0x10,%esp
 6d2:	85 d2                	test   %edx,%edx
 6d4:	74 2b                	je     701 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d6:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6d8:	8b 48 04             	mov    0x4(%eax),%ecx
 6db:	39 d9                	cmp    %ebx,%ecx
 6dd:	73 b5                	jae    694 <malloc+0x64>
 6df:	89 c2                	mov    %eax,%edx
    if(p == freep)
 6e1:	39 05 c8 09 00 00    	cmp    %eax,0x9c8
 6e7:	75 ed                	jne    6d6 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 6e9:	83 ec 0c             	sub    $0xc,%esp
 6ec:	57                   	push   %edi
 6ed:	e8 1e fc ff ff       	call   310 <sbrk>
  if(p == (char*)-1)
 6f2:	83 c4 10             	add    $0x10,%esp
 6f5:	83 f8 ff             	cmp    $0xffffffff,%eax
 6f8:	75 c0                	jne    6ba <malloc+0x8a>
        return 0;
 6fa:	b8 00 00 00 00       	mov    $0x0,%eax
 6ff:	eb ab                	jmp    6ac <malloc+0x7c>
 701:	b8 00 00 00 00       	mov    $0x0,%eax
 706:	eb a4                	jmp    6ac <malloc+0x7c>
