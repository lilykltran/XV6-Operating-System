
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 10             	sub    $0x10,%esp
   7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
   a:	53                   	push   %ebx
   b:	e8 33 01 00 00       	call   143 <strlen>
  10:	83 c4 0c             	add    $0xc,%esp
  13:	50                   	push   %eax
  14:	53                   	push   %ebx
  15:	ff 75 08             	pushl  0x8(%ebp)
  18:	e8 54 03 00 00       	call   371 <write>
}
  1d:	83 c4 10             	add    $0x10,%esp
  20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  23:	c9                   	leave  
  24:	c3                   	ret    

00000025 <forktest>:

void
forktest(void)
{
  25:	55                   	push   %ebp
  26:	89 e5                	mov    %esp,%ebp
  28:	53                   	push   %ebx
  29:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
  2c:	68 34 04 00 00       	push   $0x434
  31:	6a 01                	push   $0x1
  33:	e8 c8 ff ff ff       	call   0 <printf>
  38:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  3b:	bb 00 00 00 00       	mov    $0x0,%ebx
    pid = fork();
  40:	e8 04 03 00 00       	call   349 <fork>
    if(pid < 0)
  45:	85 c0                	test   %eax,%eax
  47:	78 2d                	js     76 <forktest+0x51>
      break;
    if(pid == 0)
  49:	85 c0                	test   %eax,%eax
  4b:	74 24                	je     71 <forktest+0x4c>
  for(n=0; n<N; n++){
  4d:	83 c3 01             	add    $0x1,%ebx
  50:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  56:	75 e8                	jne    40 <forktest+0x1b>
      exit();
  }

  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
  58:	83 ec 04             	sub    $0x4,%esp
  5b:	68 e8 03 00 00       	push   $0x3e8
  60:	68 74 04 00 00       	push   $0x474
  65:	6a 01                	push   $0x1
  67:	e8 94 ff ff ff       	call   0 <printf>
    exit();
  6c:	e8 e0 02 00 00       	call   351 <exit>
      exit();
  71:	e8 db 02 00 00       	call   351 <exit>
  if(n == N){
  76:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  7c:	74 da                	je     58 <forktest+0x33>
  }

  for(; n > 0; n--){
  7e:	85 db                	test   %ebx,%ebx
  80:	7e 0e                	jle    90 <forktest+0x6b>
    if(wait() < 0){
  82:	e8 d2 02 00 00       	call   359 <wait>
  87:	85 c0                	test   %eax,%eax
  89:	78 26                	js     b1 <forktest+0x8c>
  for(; n > 0; n--){
  8b:	83 eb 01             	sub    $0x1,%ebx
  8e:	75 f2                	jne    82 <forktest+0x5d>
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
  90:	e8 c4 02 00 00       	call   359 <wait>
  95:	83 f8 ff             	cmp    $0xffffffff,%eax
  98:	75 2b                	jne    c5 <forktest+0xa0>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
  9a:	83 ec 08             	sub    $0x8,%esp
  9d:	68 66 04 00 00       	push   $0x466
  a2:	6a 01                	push   $0x1
  a4:	e8 57 ff ff ff       	call   0 <printf>
}
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  af:	c9                   	leave  
  b0:	c3                   	ret    
      printf(1, "wait stopped early\n");
  b1:	83 ec 08             	sub    $0x8,%esp
  b4:	68 3f 04 00 00       	push   $0x43f
  b9:	6a 01                	push   $0x1
  bb:	e8 40 ff ff ff       	call   0 <printf>
      exit();
  c0:	e8 8c 02 00 00       	call   351 <exit>
    printf(1, "wait got too many\n");
  c5:	83 ec 08             	sub    $0x8,%esp
  c8:	68 53 04 00 00       	push   $0x453
  cd:	6a 01                	push   $0x1
  cf:	e8 2c ff ff ff       	call   0 <printf>
    exit();
  d4:	e8 78 02 00 00       	call   351 <exit>

000000d9 <main>:

int
main(void)
{
  d9:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  dd:	83 e4 f0             	and    $0xfffffff0,%esp
  e0:	ff 71 fc             	pushl  -0x4(%ecx)
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	51                   	push   %ecx
  e7:	83 ec 04             	sub    $0x4,%esp
  forktest();
  ea:	e8 36 ff ff ff       	call   25 <forktest>
  exit();
  ef:	e8 5d 02 00 00       	call   351 <exit>

000000f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	53                   	push   %ebx
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	89 c2                	mov    %eax,%edx
 100:	83 c1 01             	add    $0x1,%ecx
 103:	83 c2 01             	add    $0x1,%edx
 106:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 10a:	88 5a ff             	mov    %bl,-0x1(%edx)
 10d:	84 db                	test   %bl,%bl
 10f:	75 ef                	jne    100 <strcpy+0xc>
    ;
  return os;
}
 111:	5b                   	pop    %ebx
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    

00000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 11d:	0f b6 01             	movzbl (%ecx),%eax
 120:	84 c0                	test   %al,%al
 122:	74 15                	je     139 <strcmp+0x25>
 124:	3a 02                	cmp    (%edx),%al
 126:	75 11                	jne    139 <strcmp+0x25>
    p++, q++;
 128:	83 c1 01             	add    $0x1,%ecx
 12b:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 12e:	0f b6 01             	movzbl (%ecx),%eax
 131:	84 c0                	test   %al,%al
 133:	74 04                	je     139 <strcmp+0x25>
 135:	3a 02                	cmp    (%edx),%al
 137:	74 ef                	je     128 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 139:	0f b6 c0             	movzbl %al,%eax
 13c:	0f b6 12             	movzbl (%edx),%edx
 13f:	29 d0                	sub    %edx,%eax
}
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    

00000143 <strlen>:

uint
strlen(char *s)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
 146:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 149:	80 39 00             	cmpb   $0x0,(%ecx)
 14c:	74 12                	je     160 <strlen+0x1d>
 14e:	ba 00 00 00 00       	mov    $0x0,%edx
 153:	83 c2 01             	add    $0x1,%edx
 156:	89 d0                	mov    %edx,%eax
 158:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 15c:	75 f5                	jne    153 <strlen+0x10>
    ;
  return n;
}
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    
  for(n = 0; s[n]; n++)
 160:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 165:	eb f7                	jmp    15e <strlen+0x1b>

00000167 <memset>:

void*
memset(void *dst, int c, uint n)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
 16a:	57                   	push   %edi
 16b:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 16e:	89 d7                	mov    %edx,%edi
 170:	8b 4d 10             	mov    0x10(%ebp),%ecx
 173:	8b 45 0c             	mov    0xc(%ebp),%eax
 176:	fc                   	cld    
 177:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 179:	89 d0                	mov    %edx,%eax
 17b:	5f                   	pop    %edi
 17c:	5d                   	pop    %ebp
 17d:	c3                   	ret    

0000017e <strchr>:

char*
strchr(const char *s, char c)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	53                   	push   %ebx
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 188:	0f b6 10             	movzbl (%eax),%edx
 18b:	84 d2                	test   %dl,%dl
 18d:	74 1e                	je     1ad <strchr+0x2f>
 18f:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 191:	38 d3                	cmp    %dl,%bl
 193:	74 15                	je     1aa <strchr+0x2c>
  for(; *s; s++)
 195:	83 c0 01             	add    $0x1,%eax
 198:	0f b6 10             	movzbl (%eax),%edx
 19b:	84 d2                	test   %dl,%dl
 19d:	74 06                	je     1a5 <strchr+0x27>
    if(*s == c)
 19f:	38 ca                	cmp    %cl,%dl
 1a1:	75 f2                	jne    195 <strchr+0x17>
 1a3:	eb 05                	jmp    1aa <strchr+0x2c>
      return (char*)s;
  return 0;
 1a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1aa:	5b                   	pop    %ebx
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
  return 0;
 1ad:	b8 00 00 00 00       	mov    $0x0,%eax
 1b2:	eb f6                	jmp    1aa <strchr+0x2c>

000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	56                   	push   %esi
 1b9:	53                   	push   %ebx
 1ba:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bd:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 1c2:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1c5:	8d 5e 01             	lea    0x1(%esi),%ebx
 1c8:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1cb:	7d 2b                	jge    1f8 <gets+0x44>
    cc = read(0, &c, 1);
 1cd:	83 ec 04             	sub    $0x4,%esp
 1d0:	6a 01                	push   $0x1
 1d2:	57                   	push   %edi
 1d3:	6a 00                	push   $0x0
 1d5:	e8 8f 01 00 00       	call   369 <read>
    if(cc < 1)
 1da:	83 c4 10             	add    $0x10,%esp
 1dd:	85 c0                	test   %eax,%eax
 1df:	7e 17                	jle    1f8 <gets+0x44>
      break;
    buf[i++] = c;
 1e1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1e5:	8b 55 08             	mov    0x8(%ebp),%edx
 1e8:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 1ec:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1ee:	3c 0a                	cmp    $0xa,%al
 1f0:	74 04                	je     1f6 <gets+0x42>
 1f2:	3c 0d                	cmp    $0xd,%al
 1f4:	75 cf                	jne    1c5 <gets+0x11>
  for(i=0; i+1 < max; ){
 1f6:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
 202:	5b                   	pop    %ebx
 203:	5e                   	pop    %esi
 204:	5f                   	pop    %edi
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    

00000207 <stat>:

int
stat(char *n, struct stat *st)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	56                   	push   %esi
 20b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	83 ec 08             	sub    $0x8,%esp
 20f:	6a 00                	push   $0x0
 211:	ff 75 08             	pushl  0x8(%ebp)
 214:	e8 78 01 00 00       	call   391 <open>
  if(fd < 0)
 219:	83 c4 10             	add    $0x10,%esp
 21c:	85 c0                	test   %eax,%eax
 21e:	78 24                	js     244 <stat+0x3d>
 220:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 222:	83 ec 08             	sub    $0x8,%esp
 225:	ff 75 0c             	pushl  0xc(%ebp)
 228:	50                   	push   %eax
 229:	e8 7b 01 00 00       	call   3a9 <fstat>
 22e:	89 c6                	mov    %eax,%esi
  close(fd);
 230:	89 1c 24             	mov    %ebx,(%esp)
 233:	e8 41 01 00 00       	call   379 <close>
  return r;
 238:	83 c4 10             	add    $0x10,%esp
}
 23b:	89 f0                	mov    %esi,%eax
 23d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 240:	5b                   	pop    %ebx
 241:	5e                   	pop    %esi
 242:	5d                   	pop    %ebp
 243:	c3                   	ret    
    return -1;
 244:	be ff ff ff ff       	mov    $0xffffffff,%esi
 249:	eb f0                	jmp    23b <stat+0x34>

0000024b <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
 24e:	56                   	push   %esi
 24f:	53                   	push   %ebx
 250:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 253:	0f b6 0a             	movzbl (%edx),%ecx
 256:	80 f9 20             	cmp    $0x20,%cl
 259:	75 0b                	jne    266 <atoi+0x1b>
 25b:	83 c2 01             	add    $0x1,%edx
 25e:	0f b6 0a             	movzbl (%edx),%ecx
 261:	80 f9 20             	cmp    $0x20,%cl
 264:	74 f5                	je     25b <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 266:	80 f9 2d             	cmp    $0x2d,%cl
 269:	74 3b                	je     2a6 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 26b:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 26e:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 273:	f6 c1 fd             	test   $0xfd,%cl
 276:	74 33                	je     2ab <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 278:	0f b6 0a             	movzbl (%edx),%ecx
 27b:	8d 41 d0             	lea    -0x30(%ecx),%eax
 27e:	3c 09                	cmp    $0x9,%al
 280:	77 2e                	ja     2b0 <atoi+0x65>
 282:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 287:	83 c2 01             	add    $0x1,%edx
 28a:	8d 04 80             	lea    (%eax,%eax,4),%eax
 28d:	0f be c9             	movsbl %cl,%ecx
 290:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 294:	0f b6 0a             	movzbl (%edx),%ecx
 297:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 29a:	80 fb 09             	cmp    $0x9,%bl
 29d:	76 e8                	jbe    287 <atoi+0x3c>
  return sign*n;
 29f:	0f af c6             	imul   %esi,%eax
}
 2a2:	5b                   	pop    %ebx
 2a3:	5e                   	pop    %esi
 2a4:	5d                   	pop    %ebp
 2a5:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 2a6:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 2ab:	83 c2 01             	add    $0x1,%edx
 2ae:	eb c8                	jmp    278 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 2b0:	b8 00 00 00 00       	mov    $0x0,%eax
 2b5:	eb e8                	jmp    29f <atoi+0x54>

000002b7 <atoo>:

int
atoo(const char *s)
{
 2b7:	55                   	push   %ebp
 2b8:	89 e5                	mov    %esp,%ebp
 2ba:	56                   	push   %esi
 2bb:	53                   	push   %ebx
 2bc:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2bf:	0f b6 0a             	movzbl (%edx),%ecx
 2c2:	80 f9 20             	cmp    $0x20,%cl
 2c5:	75 0b                	jne    2d2 <atoo+0x1b>
 2c7:	83 c2 01             	add    $0x1,%edx
 2ca:	0f b6 0a             	movzbl (%edx),%ecx
 2cd:	80 f9 20             	cmp    $0x20,%cl
 2d0:	74 f5                	je     2c7 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 2d2:	80 f9 2d             	cmp    $0x2d,%cl
 2d5:	74 38                	je     30f <atoo+0x58>
  if (*s == '+'  || *s == '-')
 2d7:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 2da:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 2df:	f6 c1 fd             	test   $0xfd,%cl
 2e2:	74 30                	je     314 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 2e4:	0f b6 0a             	movzbl (%edx),%ecx
 2e7:	8d 41 d0             	lea    -0x30(%ecx),%eax
 2ea:	3c 07                	cmp    $0x7,%al
 2ec:	77 2b                	ja     319 <atoo+0x62>
 2ee:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 2f3:	83 c2 01             	add    $0x1,%edx
 2f6:	0f be c9             	movsbl %cl,%ecx
 2f9:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2fd:	0f b6 0a             	movzbl (%edx),%ecx
 300:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 303:	80 fb 07             	cmp    $0x7,%bl
 306:	76 eb                	jbe    2f3 <atoo+0x3c>
  return sign*n;
 308:	0f af c6             	imul   %esi,%eax
}
 30b:	5b                   	pop    %ebx
 30c:	5e                   	pop    %esi
 30d:	5d                   	pop    %ebp
 30e:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 30f:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 314:	83 c2 01             	add    $0x1,%edx
 317:	eb cb                	jmp    2e4 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 319:	b8 00 00 00 00       	mov    $0x0,%eax
 31e:	eb e8                	jmp    308 <atoo+0x51>

00000320 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	56                   	push   %esi
 324:	53                   	push   %ebx
 325:	8b 45 08             	mov    0x8(%ebp),%eax
 328:	8b 75 0c             	mov    0xc(%ebp),%esi
 32b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32e:	85 db                	test   %ebx,%ebx
 330:	7e 13                	jle    345 <memmove+0x25>
 332:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 337:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 33b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 33e:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 341:	39 d3                	cmp    %edx,%ebx
 343:	75 f2                	jne    337 <memmove+0x17>
  return vdst;
}
 345:	5b                   	pop    %ebx
 346:	5e                   	pop    %esi
 347:	5d                   	pop    %ebp
 348:	c3                   	ret    

00000349 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 349:	b8 01 00 00 00       	mov    $0x1,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <exit>:
SYSCALL(exit)
 351:	b8 02 00 00 00       	mov    $0x2,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <wait>:
SYSCALL(wait)
 359:	b8 03 00 00 00       	mov    $0x3,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <pipe>:
SYSCALL(pipe)
 361:	b8 04 00 00 00       	mov    $0x4,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <read>:
SYSCALL(read)
 369:	b8 05 00 00 00       	mov    $0x5,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <write>:
SYSCALL(write)
 371:	b8 10 00 00 00       	mov    $0x10,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <close>:
SYSCALL(close)
 379:	b8 15 00 00 00       	mov    $0x15,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <kill>:
SYSCALL(kill)
 381:	b8 06 00 00 00       	mov    $0x6,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <exec>:
SYSCALL(exec)
 389:	b8 07 00 00 00       	mov    $0x7,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <open>:
SYSCALL(open)
 391:	b8 0f 00 00 00       	mov    $0xf,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <mknod>:
SYSCALL(mknod)
 399:	b8 11 00 00 00       	mov    $0x11,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <unlink>:
SYSCALL(unlink)
 3a1:	b8 12 00 00 00       	mov    $0x12,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <fstat>:
SYSCALL(fstat)
 3a9:	b8 08 00 00 00       	mov    $0x8,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <link>:
SYSCALL(link)
 3b1:	b8 13 00 00 00       	mov    $0x13,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <mkdir>:
SYSCALL(mkdir)
 3b9:	b8 14 00 00 00       	mov    $0x14,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <chdir>:
SYSCALL(chdir)
 3c1:	b8 09 00 00 00       	mov    $0x9,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <dup>:
SYSCALL(dup)
 3c9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <getpid>:
SYSCALL(getpid)
 3d1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <sbrk>:
SYSCALL(sbrk)
 3d9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <sleep>:
SYSCALL(sleep)
 3e1:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <uptime>:
SYSCALL(uptime)
 3e9:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <halt>:
SYSCALL(halt)
 3f1:	b8 16 00 00 00       	mov    $0x16,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <date>:
//proj1
SYSCALL(date)
 3f9:	b8 17 00 00 00       	mov    $0x17,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <getuid>:
//proj2
SYSCALL(getuid)
 401:	b8 18 00 00 00       	mov    $0x18,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <getgid>:
SYSCALL(getgid)
 409:	b8 19 00 00 00       	mov    $0x19,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <getppid>:
SYSCALL(getppid)
 411:	b8 1a 00 00 00       	mov    $0x1a,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <setuid>:
SYSCALL(setuid)
 419:	b8 1b 00 00 00       	mov    $0x1b,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <setgid>:
SYSCALL(setgid)
 421:	b8 1c 00 00 00       	mov    $0x1c,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <getprocs>:
SYSCALL(getprocs)
 429:	b8 1d 00 00 00       	mov    $0x1d,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    
