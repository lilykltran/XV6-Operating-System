
_rm:     file format elf32-i386


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
  14:	8b 39                	mov    (%ecx),%edi
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  19:	83 c3 04             	add    $0x4,%ebx
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  1c:	be 01 00 00 00       	mov    $0x1,%esi
  if(argc < 2){
  21:	83 ff 01             	cmp    $0x1,%edi
  24:	7e 20                	jle    46 <main+0x46>
    if(unlink(argv[i]) < 0){
  26:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	ff 33                	pushl  (%ebx)
  2e:	e8 f0 02 00 00       	call   323 <unlink>
  33:	83 c4 10             	add    $0x10,%esp
  36:	85 c0                	test   %eax,%eax
  38:	78 20                	js     5a <main+0x5a>
  for(i = 1; i < argc; i++){
  3a:	83 c6 01             	add    $0x1,%esi
  3d:	83 c3 04             	add    $0x4,%ebx
  40:	39 f7                	cmp    %esi,%edi
  42:	75 e2                	jne    26 <main+0x26>
  44:	eb 2b                	jmp    71 <main+0x71>
    printf(2, "Usage: rm files...\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 54 07 00 00       	push   $0x754
  4e:	6a 02                	push   $0x2
  50:	e8 e8 03 00 00       	call   43d <printf>
    exit();
  55:	e8 79 02 00 00       	call   2d3 <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  60:	ff 30                	pushl  (%eax)
  62:	68 68 07 00 00       	push   $0x768
  67:	6a 02                	push   $0x2
  69:	e8 cf 03 00 00       	call   43d <printf>
      break;
  6e:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  71:	e8 5d 02 00 00       	call   2d3 <exit>

00000076 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	53                   	push   %ebx
  7a:	8b 45 08             	mov    0x8(%ebp),%eax
  7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	89 c2                	mov    %eax,%edx
  82:	83 c1 01             	add    $0x1,%ecx
  85:	83 c2 01             	add    $0x1,%edx
  88:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8c:	88 5a ff             	mov    %bl,-0x1(%edx)
  8f:	84 db                	test   %bl,%bl
  91:	75 ef                	jne    82 <strcpy+0xc>
    ;
  return os;
}
  93:	5b                   	pop    %ebx
  94:	5d                   	pop    %ebp
  95:	c3                   	ret    

00000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	55                   	push   %ebp
  97:	89 e5                	mov    %esp,%ebp
  99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9f:	0f b6 01             	movzbl (%ecx),%eax
  a2:	84 c0                	test   %al,%al
  a4:	74 15                	je     bb <strcmp+0x25>
  a6:	3a 02                	cmp    (%edx),%al
  a8:	75 11                	jne    bb <strcmp+0x25>
    p++, q++;
  aa:	83 c1 01             	add    $0x1,%ecx
  ad:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  b0:	0f b6 01             	movzbl (%ecx),%eax
  b3:	84 c0                	test   %al,%al
  b5:	74 04                	je     bb <strcmp+0x25>
  b7:	3a 02                	cmp    (%edx),%al
  b9:	74 ef                	je     aa <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  bb:	0f b6 c0             	movzbl %al,%eax
  be:	0f b6 12             	movzbl (%edx),%edx
  c1:	29 d0                	sub    %edx,%eax
}
  c3:	5d                   	pop    %ebp
  c4:	c3                   	ret    

000000c5 <strlen>:

uint
strlen(char *s)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  cb:	80 39 00             	cmpb   $0x0,(%ecx)
  ce:	74 12                	je     e2 <strlen+0x1d>
  d0:	ba 00 00 00 00       	mov    $0x0,%edx
  d5:	83 c2 01             	add    $0x1,%edx
  d8:	89 d0                	mov    %edx,%eax
  da:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  de:	75 f5                	jne    d5 <strlen+0x10>
    ;
  return n;
}
  e0:	5d                   	pop    %ebp
  e1:	c3                   	ret    
  for(n = 0; s[n]; n++)
  e2:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  e7:	eb f7                	jmp    e0 <strlen+0x1b>

000000e9 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  ec:	57                   	push   %edi
  ed:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f0:	89 d7                	mov    %edx,%edi
  f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	fc                   	cld    
  f9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  fb:	89 d0                	mov    %edx,%eax
  fd:	5f                   	pop    %edi
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 10a:	0f b6 10             	movzbl (%eax),%edx
 10d:	84 d2                	test   %dl,%dl
 10f:	74 1e                	je     12f <strchr+0x2f>
 111:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 113:	38 d3                	cmp    %dl,%bl
 115:	74 15                	je     12c <strchr+0x2c>
  for(; *s; s++)
 117:	83 c0 01             	add    $0x1,%eax
 11a:	0f b6 10             	movzbl (%eax),%edx
 11d:	84 d2                	test   %dl,%dl
 11f:	74 06                	je     127 <strchr+0x27>
    if(*s == c)
 121:	38 ca                	cmp    %cl,%dl
 123:	75 f2                	jne    117 <strchr+0x17>
 125:	eb 05                	jmp    12c <strchr+0x2c>
      return (char*)s;
  return 0;
 127:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12c:	5b                   	pop    %ebx
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    
  return 0;
 12f:	b8 00 00 00 00       	mov    $0x0,%eax
 134:	eb f6                	jmp    12c <strchr+0x2c>

00000136 <gets>:

char*
gets(char *buf, int max)
{
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
 139:	57                   	push   %edi
 13a:	56                   	push   %esi
 13b:	53                   	push   %ebx
 13c:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13f:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 144:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 147:	8d 5e 01             	lea    0x1(%esi),%ebx
 14a:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 14d:	7d 2b                	jge    17a <gets+0x44>
    cc = read(0, &c, 1);
 14f:	83 ec 04             	sub    $0x4,%esp
 152:	6a 01                	push   $0x1
 154:	57                   	push   %edi
 155:	6a 00                	push   $0x0
 157:	e8 8f 01 00 00       	call   2eb <read>
    if(cc < 1)
 15c:	83 c4 10             	add    $0x10,%esp
 15f:	85 c0                	test   %eax,%eax
 161:	7e 17                	jle    17a <gets+0x44>
      break;
    buf[i++] = c;
 163:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 167:	8b 55 08             	mov    0x8(%ebp),%edx
 16a:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 16e:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 170:	3c 0a                	cmp    $0xa,%al
 172:	74 04                	je     178 <gets+0x42>
 174:	3c 0d                	cmp    $0xd,%al
 176:	75 cf                	jne    147 <gets+0x11>
  for(i=0; i+1 < max; ){
 178:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 181:	8d 65 f4             	lea    -0xc(%ebp),%esp
 184:	5b                   	pop    %ebx
 185:	5e                   	pop    %esi
 186:	5f                   	pop    %edi
 187:	5d                   	pop    %ebp
 188:	c3                   	ret    

00000189 <stat>:

int
stat(char *n, struct stat *st)
{
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	56                   	push   %esi
 18d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18e:	83 ec 08             	sub    $0x8,%esp
 191:	6a 00                	push   $0x0
 193:	ff 75 08             	pushl  0x8(%ebp)
 196:	e8 78 01 00 00       	call   313 <open>
  if(fd < 0)
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	85 c0                	test   %eax,%eax
 1a0:	78 24                	js     1c6 <stat+0x3d>
 1a2:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a4:	83 ec 08             	sub    $0x8,%esp
 1a7:	ff 75 0c             	pushl  0xc(%ebp)
 1aa:	50                   	push   %eax
 1ab:	e8 7b 01 00 00       	call   32b <fstat>
 1b0:	89 c6                	mov    %eax,%esi
  close(fd);
 1b2:	89 1c 24             	mov    %ebx,(%esp)
 1b5:	e8 41 01 00 00       	call   2fb <close>
  return r;
 1ba:	83 c4 10             	add    $0x10,%esp
}
 1bd:	89 f0                	mov    %esi,%eax
 1bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c2:	5b                   	pop    %ebx
 1c3:	5e                   	pop    %esi
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    
    return -1;
 1c6:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1cb:	eb f0                	jmp    1bd <stat+0x34>

000001cd <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1cd:	55                   	push   %ebp
 1ce:	89 e5                	mov    %esp,%ebp
 1d0:	56                   	push   %esi
 1d1:	53                   	push   %ebx
 1d2:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1d5:	0f b6 0a             	movzbl (%edx),%ecx
 1d8:	80 f9 20             	cmp    $0x20,%cl
 1db:	75 0b                	jne    1e8 <atoi+0x1b>
 1dd:	83 c2 01             	add    $0x1,%edx
 1e0:	0f b6 0a             	movzbl (%edx),%ecx
 1e3:	80 f9 20             	cmp    $0x20,%cl
 1e6:	74 f5                	je     1dd <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 1e8:	80 f9 2d             	cmp    $0x2d,%cl
 1eb:	74 3b                	je     228 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 1ed:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 1f0:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 1f5:	f6 c1 fd             	test   $0xfd,%cl
 1f8:	74 33                	je     22d <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 1fa:	0f b6 0a             	movzbl (%edx),%ecx
 1fd:	8d 41 d0             	lea    -0x30(%ecx),%eax
 200:	3c 09                	cmp    $0x9,%al
 202:	77 2e                	ja     232 <atoi+0x65>
 204:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 209:	83 c2 01             	add    $0x1,%edx
 20c:	8d 04 80             	lea    (%eax,%eax,4),%eax
 20f:	0f be c9             	movsbl %cl,%ecx
 212:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 216:	0f b6 0a             	movzbl (%edx),%ecx
 219:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 21c:	80 fb 09             	cmp    $0x9,%bl
 21f:	76 e8                	jbe    209 <atoi+0x3c>
  return sign*n;
 221:	0f af c6             	imul   %esi,%eax
}
 224:	5b                   	pop    %ebx
 225:	5e                   	pop    %esi
 226:	5d                   	pop    %ebp
 227:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 228:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 22d:	83 c2 01             	add    $0x1,%edx
 230:	eb c8                	jmp    1fa <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 232:	b8 00 00 00 00       	mov    $0x0,%eax
 237:	eb e8                	jmp    221 <atoi+0x54>

00000239 <atoo>:

int
atoo(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	56                   	push   %esi
 23d:	53                   	push   %ebx
 23e:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 241:	0f b6 0a             	movzbl (%edx),%ecx
 244:	80 f9 20             	cmp    $0x20,%cl
 247:	75 0b                	jne    254 <atoo+0x1b>
 249:	83 c2 01             	add    $0x1,%edx
 24c:	0f b6 0a             	movzbl (%edx),%ecx
 24f:	80 f9 20             	cmp    $0x20,%cl
 252:	74 f5                	je     249 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 254:	80 f9 2d             	cmp    $0x2d,%cl
 257:	74 38                	je     291 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 259:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 25c:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 261:	f6 c1 fd             	test   $0xfd,%cl
 264:	74 30                	je     296 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 266:	0f b6 0a             	movzbl (%edx),%ecx
 269:	8d 41 d0             	lea    -0x30(%ecx),%eax
 26c:	3c 07                	cmp    $0x7,%al
 26e:	77 2b                	ja     29b <atoo+0x62>
 270:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 275:	83 c2 01             	add    $0x1,%edx
 278:	0f be c9             	movsbl %cl,%ecx
 27b:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 27f:	0f b6 0a             	movzbl (%edx),%ecx
 282:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 285:	80 fb 07             	cmp    $0x7,%bl
 288:	76 eb                	jbe    275 <atoo+0x3c>
  return sign*n;
 28a:	0f af c6             	imul   %esi,%eax
}
 28d:	5b                   	pop    %ebx
 28e:	5e                   	pop    %esi
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 291:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 296:	83 c2 01             	add    $0x1,%edx
 299:	eb cb                	jmp    266 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 29b:	b8 00 00 00 00       	mov    $0x0,%eax
 2a0:	eb e8                	jmp    28a <atoo+0x51>

000002a2 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	56                   	push   %esi
 2a6:	53                   	push   %ebx
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	8b 75 0c             	mov    0xc(%ebp),%esi
 2ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b0:	85 db                	test   %ebx,%ebx
 2b2:	7e 13                	jle    2c7 <memmove+0x25>
 2b4:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 2b9:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2bd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2c0:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2c3:	39 d3                	cmp    %edx,%ebx
 2c5:	75 f2                	jne    2b9 <memmove+0x17>
  return vdst;
}
 2c7:	5b                   	pop    %ebx
 2c8:	5e                   	pop    %esi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    

000002cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cb:	b8 01 00 00 00       	mov    $0x1,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <exit>:
SYSCALL(exit)
 2d3:	b8 02 00 00 00       	mov    $0x2,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <wait>:
SYSCALL(wait)
 2db:	b8 03 00 00 00       	mov    $0x3,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <pipe>:
SYSCALL(pipe)
 2e3:	b8 04 00 00 00       	mov    $0x4,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <read>:
SYSCALL(read)
 2eb:	b8 05 00 00 00       	mov    $0x5,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <write>:
SYSCALL(write)
 2f3:	b8 10 00 00 00       	mov    $0x10,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <close>:
SYSCALL(close)
 2fb:	b8 15 00 00 00       	mov    $0x15,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <kill>:
SYSCALL(kill)
 303:	b8 06 00 00 00       	mov    $0x6,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <exec>:
SYSCALL(exec)
 30b:	b8 07 00 00 00       	mov    $0x7,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <open>:
SYSCALL(open)
 313:	b8 0f 00 00 00       	mov    $0xf,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mknod>:
SYSCALL(mknod)
 31b:	b8 11 00 00 00       	mov    $0x11,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <unlink>:
SYSCALL(unlink)
 323:	b8 12 00 00 00       	mov    $0x12,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <fstat>:
SYSCALL(fstat)
 32b:	b8 08 00 00 00       	mov    $0x8,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <link>:
SYSCALL(link)
 333:	b8 13 00 00 00       	mov    $0x13,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mkdir>:
SYSCALL(mkdir)
 33b:	b8 14 00 00 00       	mov    $0x14,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <chdir>:
SYSCALL(chdir)
 343:	b8 09 00 00 00       	mov    $0x9,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <dup>:
SYSCALL(dup)
 34b:	b8 0a 00 00 00       	mov    $0xa,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <getpid>:
SYSCALL(getpid)
 353:	b8 0b 00 00 00       	mov    $0xb,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sbrk>:
SYSCALL(sbrk)
 35b:	b8 0c 00 00 00       	mov    $0xc,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <sleep>:
SYSCALL(sleep)
 363:	b8 0d 00 00 00       	mov    $0xd,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <uptime>:
SYSCALL(uptime)
 36b:	b8 0e 00 00 00       	mov    $0xe,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <halt>:
SYSCALL(halt)
 373:	b8 16 00 00 00       	mov    $0x16,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <date>:
//proj1
SYSCALL(date)
 37b:	b8 17 00 00 00       	mov    $0x17,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <getuid>:
//proj2
SYSCALL(getuid)
 383:	b8 18 00 00 00       	mov    $0x18,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <getgid>:
SYSCALL(getgid)
 38b:	b8 19 00 00 00       	mov    $0x19,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <getppid>:
SYSCALL(getppid)
 393:	b8 1a 00 00 00       	mov    $0x1a,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <setuid>:
SYSCALL(setuid)
 39b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <setgid>:
SYSCALL(setgid)
 3a3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <getprocs>:
SYSCALL(getprocs)
 3ab:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b3:	55                   	push   %ebp
 3b4:	89 e5                	mov    %esp,%ebp
 3b6:	57                   	push   %edi
 3b7:	56                   	push   %esi
 3b8:	53                   	push   %ebx
 3b9:	83 ec 3c             	sub    $0x3c,%esp
 3bc:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3c2:	74 14                	je     3d8 <printint+0x25>
 3c4:	85 d2                	test   %edx,%edx
 3c6:	79 10                	jns    3d8 <printint+0x25>
    neg = 1;
    x = -xx;
 3c8:	f7 da                	neg    %edx
    neg = 1;
 3ca:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3d1:	bf 00 00 00 00       	mov    $0x0,%edi
 3d6:	eb 0b                	jmp    3e3 <printint+0x30>
  neg = 0;
 3d8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3df:	eb f0                	jmp    3d1 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 3e1:	89 df                	mov    %ebx,%edi
 3e3:	8d 5f 01             	lea    0x1(%edi),%ebx
 3e6:	89 d0                	mov    %edx,%eax
 3e8:	ba 00 00 00 00       	mov    $0x0,%edx
 3ed:	f7 f1                	div    %ecx
 3ef:	0f b6 92 88 07 00 00 	movzbl 0x788(%edx),%edx
 3f6:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3fa:	89 c2                	mov    %eax,%edx
 3fc:	85 c0                	test   %eax,%eax
 3fe:	75 e1                	jne    3e1 <printint+0x2e>
  if(neg)
 400:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 404:	74 08                	je     40e <printint+0x5b>
    buf[i++] = '-';
 406:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 40b:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 40e:	83 eb 01             	sub    $0x1,%ebx
 411:	78 22                	js     435 <printint+0x82>
  write(fd, &c, 1);
 413:	8d 7d d7             	lea    -0x29(%ebp),%edi
 416:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 41b:	88 45 d7             	mov    %al,-0x29(%ebp)
 41e:	83 ec 04             	sub    $0x4,%esp
 421:	6a 01                	push   $0x1
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	e8 c9 fe ff ff       	call   2f3 <write>
  while(--i >= 0)
 42a:	83 eb 01             	sub    $0x1,%ebx
 42d:	83 c4 10             	add    $0x10,%esp
 430:	83 fb ff             	cmp    $0xffffffff,%ebx
 433:	75 e1                	jne    416 <printint+0x63>
    putc(fd, buf[i]);
}
 435:	8d 65 f4             	lea    -0xc(%ebp),%esp
 438:	5b                   	pop    %ebx
 439:	5e                   	pop    %esi
 43a:	5f                   	pop    %edi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    

0000043d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43d:	55                   	push   %ebp
 43e:	89 e5                	mov    %esp,%ebp
 440:	57                   	push   %edi
 441:	56                   	push   %esi
 442:	53                   	push   %ebx
 443:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 446:	8b 75 0c             	mov    0xc(%ebp),%esi
 449:	0f b6 1e             	movzbl (%esi),%ebx
 44c:	84 db                	test   %bl,%bl
 44e:	0f 84 b1 01 00 00    	je     605 <printf+0x1c8>
 454:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 457:	8d 45 10             	lea    0x10(%ebp),%eax
 45a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 45d:	bf 00 00 00 00       	mov    $0x0,%edi
 462:	eb 2d                	jmp    491 <printf+0x54>
 464:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 467:	83 ec 04             	sub    $0x4,%esp
 46a:	6a 01                	push   $0x1
 46c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 46f:	50                   	push   %eax
 470:	ff 75 08             	pushl  0x8(%ebp)
 473:	e8 7b fe ff ff       	call   2f3 <write>
 478:	83 c4 10             	add    $0x10,%esp
 47b:	eb 05                	jmp    482 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 47d:	83 ff 25             	cmp    $0x25,%edi
 480:	74 22                	je     4a4 <printf+0x67>
 482:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 485:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 489:	84 db                	test   %bl,%bl
 48b:	0f 84 74 01 00 00    	je     605 <printf+0x1c8>
    c = fmt[i] & 0xff;
 491:	0f be d3             	movsbl %bl,%edx
 494:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 497:	85 ff                	test   %edi,%edi
 499:	75 e2                	jne    47d <printf+0x40>
      if(c == '%'){
 49b:	83 f8 25             	cmp    $0x25,%eax
 49e:	75 c4                	jne    464 <printf+0x27>
        state = '%';
 4a0:	89 c7                	mov    %eax,%edi
 4a2:	eb de                	jmp    482 <printf+0x45>
      if(c == 'd'){
 4a4:	83 f8 64             	cmp    $0x64,%eax
 4a7:	74 59                	je     502 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4a9:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 4af:	83 fa 70             	cmp    $0x70,%edx
 4b2:	74 7a                	je     52e <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4b4:	83 f8 73             	cmp    $0x73,%eax
 4b7:	0f 84 9d 00 00 00    	je     55a <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4bd:	83 f8 63             	cmp    $0x63,%eax
 4c0:	0f 84 f2 00 00 00    	je     5b8 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4c6:	83 f8 25             	cmp    $0x25,%eax
 4c9:	0f 84 15 01 00 00    	je     5e4 <printf+0x1a7>
 4cf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4d3:	83 ec 04             	sub    $0x4,%esp
 4d6:	6a 01                	push   $0x1
 4d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4db:	50                   	push   %eax
 4dc:	ff 75 08             	pushl  0x8(%ebp)
 4df:	e8 0f fe ff ff       	call   2f3 <write>
 4e4:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4e7:	83 c4 0c             	add    $0xc,%esp
 4ea:	6a 01                	push   $0x1
 4ec:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4ef:	50                   	push   %eax
 4f0:	ff 75 08             	pushl  0x8(%ebp)
 4f3:	e8 fb fd ff ff       	call   2f3 <write>
 4f8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4fb:	bf 00 00 00 00       	mov    $0x0,%edi
 500:	eb 80                	jmp    482 <printf+0x45>
        printint(fd, *ap, 10, 1);
 502:	83 ec 0c             	sub    $0xc,%esp
 505:	6a 01                	push   $0x1
 507:	b9 0a 00 00 00       	mov    $0xa,%ecx
 50c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 50f:	8b 17                	mov    (%edi),%edx
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	e8 9a fe ff ff       	call   3b3 <printint>
        ap++;
 519:	89 f8                	mov    %edi,%eax
 51b:	83 c0 04             	add    $0x4,%eax
 51e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 521:	83 c4 10             	add    $0x10,%esp
      state = 0;
 524:	bf 00 00 00 00       	mov    $0x0,%edi
 529:	e9 54 ff ff ff       	jmp    482 <printf+0x45>
        printint(fd, *ap, 16, 0);
 52e:	83 ec 0c             	sub    $0xc,%esp
 531:	6a 00                	push   $0x0
 533:	b9 10 00 00 00       	mov    $0x10,%ecx
 538:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 53b:	8b 17                	mov    (%edi),%edx
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	e8 6e fe ff ff       	call   3b3 <printint>
        ap++;
 545:	89 f8                	mov    %edi,%eax
 547:	83 c0 04             	add    $0x4,%eax
 54a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 54d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 550:	bf 00 00 00 00       	mov    $0x0,%edi
 555:	e9 28 ff ff ff       	jmp    482 <printf+0x45>
        s = (char*)*ap;
 55a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 55d:	8b 01                	mov    (%ecx),%eax
        ap++;
 55f:	83 c1 04             	add    $0x4,%ecx
 562:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 565:	85 c0                	test   %eax,%eax
 567:	74 13                	je     57c <printf+0x13f>
        s = (char*)*ap;
 569:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 56b:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 56e:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 573:	84 c0                	test   %al,%al
 575:	75 0f                	jne    586 <printf+0x149>
 577:	e9 06 ff ff ff       	jmp    482 <printf+0x45>
          s = "(null)";
 57c:	bb 81 07 00 00       	mov    $0x781,%ebx
        while(*s != 0){
 581:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 586:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 589:	89 75 d0             	mov    %esi,-0x30(%ebp)
 58c:	8b 75 08             	mov    0x8(%ebp),%esi
 58f:	88 45 e3             	mov    %al,-0x1d(%ebp)
 592:	83 ec 04             	sub    $0x4,%esp
 595:	6a 01                	push   $0x1
 597:	57                   	push   %edi
 598:	56                   	push   %esi
 599:	e8 55 fd ff ff       	call   2f3 <write>
          s++;
 59e:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 5a1:	0f b6 03             	movzbl (%ebx),%eax
 5a4:	83 c4 10             	add    $0x10,%esp
 5a7:	84 c0                	test   %al,%al
 5a9:	75 e4                	jne    58f <printf+0x152>
 5ab:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 5ae:	bf 00 00 00 00       	mov    $0x0,%edi
 5b3:	e9 ca fe ff ff       	jmp    482 <printf+0x45>
        putc(fd, *ap);
 5b8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5bb:	8b 07                	mov    (%edi),%eax
 5bd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5c0:	83 ec 04             	sub    $0x4,%esp
 5c3:	6a 01                	push   $0x1
 5c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5c8:	50                   	push   %eax
 5c9:	ff 75 08             	pushl  0x8(%ebp)
 5cc:	e8 22 fd ff ff       	call   2f3 <write>
        ap++;
 5d1:	83 c7 04             	add    $0x4,%edi
 5d4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5d7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5da:	bf 00 00 00 00       	mov    $0x0,%edi
 5df:	e9 9e fe ff ff       	jmp    482 <printf+0x45>
 5e4:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 5e7:	83 ec 04             	sub    $0x4,%esp
 5ea:	6a 01                	push   $0x1
 5ec:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5ef:	50                   	push   %eax
 5f0:	ff 75 08             	pushl  0x8(%ebp)
 5f3:	e8 fb fc ff ff       	call   2f3 <write>
 5f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5fb:	bf 00 00 00 00       	mov    $0x0,%edi
 600:	e9 7d fe ff ff       	jmp    482 <printf+0x45>
    }
  }
}
 605:	8d 65 f4             	lea    -0xc(%ebp),%esp
 608:	5b                   	pop    %ebx
 609:	5e                   	pop    %esi
 60a:	5f                   	pop    %edi
 60b:	5d                   	pop    %ebp
 60c:	c3                   	ret    

0000060d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60d:	55                   	push   %ebp
 60e:	89 e5                	mov    %esp,%ebp
 610:	57                   	push   %edi
 611:	56                   	push   %esi
 612:	53                   	push   %ebx
 613:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 616:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 619:	a1 2c 0a 00 00       	mov    0xa2c,%eax
 61e:	eb 0c                	jmp    62c <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	8b 10                	mov    (%eax),%edx
 622:	39 c2                	cmp    %eax,%edx
 624:	77 04                	ja     62a <free+0x1d>
 626:	39 ca                	cmp    %ecx,%edx
 628:	77 10                	ja     63a <free+0x2d>
{
 62a:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62c:	39 c8                	cmp    %ecx,%eax
 62e:	73 f0                	jae    620 <free+0x13>
 630:	8b 10                	mov    (%eax),%edx
 632:	39 ca                	cmp    %ecx,%edx
 634:	77 04                	ja     63a <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 636:	39 c2                	cmp    %eax,%edx
 638:	77 f0                	ja     62a <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 63a:	8b 73 fc             	mov    -0x4(%ebx),%esi
 63d:	8b 10                	mov    (%eax),%edx
 63f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 642:	39 fa                	cmp    %edi,%edx
 644:	74 19                	je     65f <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 646:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 649:	8b 50 04             	mov    0x4(%eax),%edx
 64c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 64f:	39 f1                	cmp    %esi,%ecx
 651:	74 1b                	je     66e <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 653:	89 08                	mov    %ecx,(%eax)
  freep = p;
 655:	a3 2c 0a 00 00       	mov    %eax,0xa2c
}
 65a:	5b                   	pop    %ebx
 65b:	5e                   	pop    %esi
 65c:	5f                   	pop    %edi
 65d:	5d                   	pop    %ebp
 65e:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 65f:	03 72 04             	add    0x4(%edx),%esi
 662:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 665:	8b 10                	mov    (%eax),%edx
 667:	8b 12                	mov    (%edx),%edx
 669:	89 53 f8             	mov    %edx,-0x8(%ebx)
 66c:	eb db                	jmp    649 <free+0x3c>
    p->s.size += bp->s.size;
 66e:	03 53 fc             	add    -0x4(%ebx),%edx
 671:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 674:	8b 53 f8             	mov    -0x8(%ebx),%edx
 677:	89 10                	mov    %edx,(%eax)
 679:	eb da                	jmp    655 <free+0x48>

0000067b <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 67b:	55                   	push   %ebp
 67c:	89 e5                	mov    %esp,%ebp
 67e:	57                   	push   %edi
 67f:	56                   	push   %esi
 680:	53                   	push   %ebx
 681:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 684:	8b 45 08             	mov    0x8(%ebp),%eax
 687:	8d 58 07             	lea    0x7(%eax),%ebx
 68a:	c1 eb 03             	shr    $0x3,%ebx
 68d:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 690:	8b 15 2c 0a 00 00    	mov    0xa2c,%edx
 696:	85 d2                	test   %edx,%edx
 698:	74 20                	je     6ba <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 69a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 69c:	8b 48 04             	mov    0x4(%eax),%ecx
 69f:	39 cb                	cmp    %ecx,%ebx
 6a1:	76 3c                	jbe    6df <malloc+0x64>
 6a3:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6a9:	be 00 10 00 00       	mov    $0x1000,%esi
 6ae:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 6b1:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 6b8:	eb 70                	jmp    72a <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 6ba:	c7 05 2c 0a 00 00 30 	movl   $0xa30,0xa2c
 6c1:	0a 00 00 
 6c4:	c7 05 30 0a 00 00 30 	movl   $0xa30,0xa30
 6cb:	0a 00 00 
    base.s.size = 0;
 6ce:	c7 05 34 0a 00 00 00 	movl   $0x0,0xa34
 6d5:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6d8:	ba 30 0a 00 00       	mov    $0xa30,%edx
 6dd:	eb bb                	jmp    69a <malloc+0x1f>
      if(p->s.size == nunits)
 6df:	39 cb                	cmp    %ecx,%ebx
 6e1:	74 1c                	je     6ff <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6e3:	29 d9                	sub    %ebx,%ecx
 6e5:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6e8:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6eb:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6ee:	89 15 2c 0a 00 00    	mov    %edx,0xa2c
      return (void*)(p + 1);
 6f4:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6fa:	5b                   	pop    %ebx
 6fb:	5e                   	pop    %esi
 6fc:	5f                   	pop    %edi
 6fd:	5d                   	pop    %ebp
 6fe:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6ff:	8b 08                	mov    (%eax),%ecx
 701:	89 0a                	mov    %ecx,(%edx)
 703:	eb e9                	jmp    6ee <malloc+0x73>
  hp->s.size = nu;
 705:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 708:	83 ec 0c             	sub    $0xc,%esp
 70b:	83 c0 08             	add    $0x8,%eax
 70e:	50                   	push   %eax
 70f:	e8 f9 fe ff ff       	call   60d <free>
  return freep;
 714:	8b 15 2c 0a 00 00    	mov    0xa2c,%edx
      if((p = morecore(nunits)) == 0)
 71a:	83 c4 10             	add    $0x10,%esp
 71d:	85 d2                	test   %edx,%edx
 71f:	74 2b                	je     74c <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 721:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 723:	8b 48 04             	mov    0x4(%eax),%ecx
 726:	39 d9                	cmp    %ebx,%ecx
 728:	73 b5                	jae    6df <malloc+0x64>
 72a:	89 c2                	mov    %eax,%edx
    if(p == freep)
 72c:	39 05 2c 0a 00 00    	cmp    %eax,0xa2c
 732:	75 ed                	jne    721 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 734:	83 ec 0c             	sub    $0xc,%esp
 737:	57                   	push   %edi
 738:	e8 1e fc ff ff       	call   35b <sbrk>
  if(p == (char*)-1)
 73d:	83 c4 10             	add    $0x10,%esp
 740:	83 f8 ff             	cmp    $0xffffffff,%eax
 743:	75 c0                	jne    705 <malloc+0x8a>
        return 0;
 745:	b8 00 00 00 00       	mov    $0x0,%eax
 74a:	eb ab                	jmp    6f7 <malloc+0x7c>
 74c:	b8 00 00 00 00       	mov    $0x0,%eax
 751:	eb a4                	jmp    6f7 <malloc+0x7c>
