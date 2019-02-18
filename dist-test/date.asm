
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
}

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
  11:	83 ec 34             	sub    $0x34,%esp
  int day;
  struct rtcdate r;

  if (date(&r)) {
  14:	8d 45 d0             	lea    -0x30(%ebp),%eax
  17:	50                   	push   %eax
  18:	e8 3f 04 00 00       	call   45c <date>
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	74 18                	je     3c <main+0x3c>
    printf(2,"Error: date call failed. %s at line %d\n",
  24:	6a 1c                	push   $0x1c
  26:	68 40 08 00 00       	push   $0x840
  2b:	68 b4 08 00 00       	push   $0x8b4
  30:	6a 02                	push   $0x2
  32:	e8 e7 04 00 00       	call   51e <printf>
        __FILE__, __LINE__);
    exit();
  37:	e8 78 03 00 00       	call   3b4 <exit>
  }

  day = dayofweek(r.year, r.month, r.day);
  3c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  42:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
  45:	8d 71 fe             	lea    -0x2(%ecx),%esi
  48:	83 f8 02             	cmp    $0x2,%eax
  4b:	0f 8e c0 00 00 00    	jle    111 <main+0x111>

  printf(1, "%s %s %d", days[day], months[r.month], r.day);
  51:	83 ec 0c             	sub    $0xc,%esp
  54:	53                   	push   %ebx
  55:	ff 34 85 00 09 00 00 	pushl  0x900(,%eax,4)
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
  5c:	6b c0 17             	imul   $0x17,%eax,%eax
  5f:	bf 09 00 00 00       	mov    $0x9,%edi
  64:	99                   	cltd   
  65:	f7 ff                	idiv   %edi
  67:	01 f3                	add    %esi,%ebx
  69:	8d 5c 18 04          	lea    0x4(%eax,%ebx,1),%ebx
  6d:	be 04 00 00 00       	mov    $0x4,%esi
  72:	89 c8                	mov    %ecx,%eax
  74:	99                   	cltd   
  75:	f7 fe                	idiv   %esi
  77:	01 c3                	add    %eax,%ebx
  79:	be 9c ff ff ff       	mov    $0xffffff9c,%esi
  7e:	89 c8                	mov    %ecx,%eax
  80:	99                   	cltd   
  81:	f7 fe                	idiv   %esi
  83:	01 c3                	add    %eax,%ebx
  85:	be 90 01 00 00       	mov    $0x190,%esi
  8a:	89 c8                	mov    %ecx,%eax
  8c:	99                   	cltd   
  8d:	f7 fe                	idiv   %esi
  8f:	01 d8                	add    %ebx,%eax
  91:	bb 07 00 00 00       	mov    $0x7,%ebx
  96:	99                   	cltd   
  97:	f7 fb                	idiv   %ebx
  printf(1, "%s %s %d", days[day], months[r.month], r.day);
  99:	ff 34 95 e0 08 00 00 	pushl  0x8e0(,%edx,4)
  a0:	68 47 08 00 00       	push   $0x847
  a5:	6a 01                	push   $0x1
  a7:	e8 72 04 00 00       	call   51e <printf>
  printf(1, " ");
  ac:	83 c4 18             	add    $0x18,%esp
  af:	68 50 08 00 00       	push   $0x850
  b4:	6a 01                	push   $0x1
  b6:	e8 63 04 00 00       	call   51e <printf>
  if (r.hour < 10) printf(1, "0");
  bb:	83 c4 10             	add    $0x10,%esp
  be:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
  c2:	76 57                	jbe    11b <main+0x11b>
  printf(1, "%d:", r.hour);
  c4:	83 ec 04             	sub    $0x4,%esp
  c7:	ff 75 d8             	pushl  -0x28(%ebp)
  ca:	68 54 08 00 00       	push   $0x854
  cf:	6a 01                	push   $0x1
  d1:	e8 48 04 00 00       	call   51e <printf>
  if (r.minute < 10) printf(1, "0");
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	83 7d d4 09          	cmpl   $0x9,-0x2c(%ebp)
  dd:	76 50                	jbe    12f <main+0x12f>
  printf(1, "%d:", r.minute);
  df:	83 ec 04             	sub    $0x4,%esp
  e2:	ff 75 d4             	pushl  -0x2c(%ebp)
  e5:	68 54 08 00 00       	push   $0x854
  ea:	6a 01                	push   $0x1
  ec:	e8 2d 04 00 00       	call   51e <printf>
  if (r.second < 10) printf(1, "0");
  f1:	83 c4 10             	add    $0x10,%esp
  f4:	83 7d d0 09          	cmpl   $0x9,-0x30(%ebp)
  f8:	76 49                	jbe    143 <main+0x143>
  printf(1, "%d UTC %d\n", r.second, r.year);
  fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  fd:	ff 75 d0             	pushl  -0x30(%ebp)
 100:	68 58 08 00 00       	push   $0x858
 105:	6a 01                	push   $0x1
 107:	e8 12 04 00 00       	call   51e <printf>

  exit();
 10c:	e8 a3 02 00 00       	call   3b4 <exit>
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
 111:	89 ce                	mov    %ecx,%esi
 113:	8d 49 ff             	lea    -0x1(%ecx),%ecx
 116:	e9 36 ff ff ff       	jmp    51 <main+0x51>
  if (r.hour < 10) printf(1, "0");
 11b:	83 ec 08             	sub    $0x8,%esp
 11e:	68 52 08 00 00       	push   $0x852
 123:	6a 01                	push   $0x1
 125:	e8 f4 03 00 00       	call   51e <printf>
 12a:	83 c4 10             	add    $0x10,%esp
 12d:	eb 95                	jmp    c4 <main+0xc4>
  if (r.minute < 10) printf(1, "0");
 12f:	83 ec 08             	sub    $0x8,%esp
 132:	68 52 08 00 00       	push   $0x852
 137:	6a 01                	push   $0x1
 139:	e8 e0 03 00 00       	call   51e <printf>
 13e:	83 c4 10             	add    $0x10,%esp
 141:	eb 9c                	jmp    df <main+0xdf>
  if (r.second < 10) printf(1, "0");
 143:	83 ec 08             	sub    $0x8,%esp
 146:	68 52 08 00 00       	push   $0x852
 14b:	6a 01                	push   $0x1
 14d:	e8 cc 03 00 00       	call   51e <printf>
 152:	83 c4 10             	add    $0x10,%esp
 155:	eb a3                	jmp    fa <main+0xfa>

00000157 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	53                   	push   %ebx
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 161:	89 c2                	mov    %eax,%edx
 163:	83 c1 01             	add    $0x1,%ecx
 166:	83 c2 01             	add    $0x1,%edx
 169:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 16d:	88 5a ff             	mov    %bl,-0x1(%edx)
 170:	84 db                	test   %bl,%bl
 172:	75 ef                	jne    163 <strcpy+0xc>
    ;
  return os;
}
 174:	5b                   	pop    %ebx
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    

00000177 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 177:	55                   	push   %ebp
 178:	89 e5                	mov    %esp,%ebp
 17a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 17d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 180:	0f b6 01             	movzbl (%ecx),%eax
 183:	84 c0                	test   %al,%al
 185:	74 15                	je     19c <strcmp+0x25>
 187:	3a 02                	cmp    (%edx),%al
 189:	75 11                	jne    19c <strcmp+0x25>
    p++, q++;
 18b:	83 c1 01             	add    $0x1,%ecx
 18e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 191:	0f b6 01             	movzbl (%ecx),%eax
 194:	84 c0                	test   %al,%al
 196:	74 04                	je     19c <strcmp+0x25>
 198:	3a 02                	cmp    (%edx),%al
 19a:	74 ef                	je     18b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 19c:	0f b6 c0             	movzbl %al,%eax
 19f:	0f b6 12             	movzbl (%edx),%edx
 1a2:	29 d0                	sub    %edx,%eax
}
 1a4:	5d                   	pop    %ebp
 1a5:	c3                   	ret    

000001a6 <strlen>:

uint
strlen(char *s)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1ac:	80 39 00             	cmpb   $0x0,(%ecx)
 1af:	74 12                	je     1c3 <strlen+0x1d>
 1b1:	ba 00 00 00 00       	mov    $0x0,%edx
 1b6:	83 c2 01             	add    $0x1,%edx
 1b9:	89 d0                	mov    %edx,%eax
 1bb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1bf:	75 f5                	jne    1b6 <strlen+0x10>
    ;
  return n;
}
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
  for(n = 0; s[n]; n++)
 1c3:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 1c8:	eb f7                	jmp    1c1 <strlen+0x1b>

000001ca <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	57                   	push   %edi
 1ce:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1d1:	89 d7                	mov    %edx,%edi
 1d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d9:	fc                   	cld    
 1da:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1dc:	89 d0                	mov    %edx,%eax
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    

000001e1 <strchr>:

char*
strchr(const char *s, char c)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	53                   	push   %ebx
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1eb:	0f b6 10             	movzbl (%eax),%edx
 1ee:	84 d2                	test   %dl,%dl
 1f0:	74 1e                	je     210 <strchr+0x2f>
 1f2:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 1f4:	38 d3                	cmp    %dl,%bl
 1f6:	74 15                	je     20d <strchr+0x2c>
  for(; *s; s++)
 1f8:	83 c0 01             	add    $0x1,%eax
 1fb:	0f b6 10             	movzbl (%eax),%edx
 1fe:	84 d2                	test   %dl,%dl
 200:	74 06                	je     208 <strchr+0x27>
    if(*s == c)
 202:	38 ca                	cmp    %cl,%dl
 204:	75 f2                	jne    1f8 <strchr+0x17>
 206:	eb 05                	jmp    20d <strchr+0x2c>
      return (char*)s;
  return 0;
 208:	b8 00 00 00 00       	mov    $0x0,%eax
}
 20d:	5b                   	pop    %ebx
 20e:	5d                   	pop    %ebp
 20f:	c3                   	ret    
  return 0;
 210:	b8 00 00 00 00       	mov    $0x0,%eax
 215:	eb f6                	jmp    20d <strchr+0x2c>

00000217 <gets>:

char*
gets(char *buf, int max)
{
 217:	55                   	push   %ebp
 218:	89 e5                	mov    %esp,%ebp
 21a:	57                   	push   %edi
 21b:	56                   	push   %esi
 21c:	53                   	push   %ebx
 21d:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 220:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 225:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 228:	8d 5e 01             	lea    0x1(%esi),%ebx
 22b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 22e:	7d 2b                	jge    25b <gets+0x44>
    cc = read(0, &c, 1);
 230:	83 ec 04             	sub    $0x4,%esp
 233:	6a 01                	push   $0x1
 235:	57                   	push   %edi
 236:	6a 00                	push   $0x0
 238:	e8 8f 01 00 00       	call   3cc <read>
    if(cc < 1)
 23d:	83 c4 10             	add    $0x10,%esp
 240:	85 c0                	test   %eax,%eax
 242:	7e 17                	jle    25b <gets+0x44>
      break;
    buf[i++] = c;
 244:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 248:	8b 55 08             	mov    0x8(%ebp),%edx
 24b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 24f:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 251:	3c 0a                	cmp    $0xa,%al
 253:	74 04                	je     259 <gets+0x42>
 255:	3c 0d                	cmp    $0xd,%al
 257:	75 cf                	jne    228 <gets+0x11>
  for(i=0; i+1 < max; ){
 259:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 262:	8d 65 f4             	lea    -0xc(%ebp),%esp
 265:	5b                   	pop    %ebx
 266:	5e                   	pop    %esi
 267:	5f                   	pop    %edi
 268:	5d                   	pop    %ebp
 269:	c3                   	ret    

0000026a <stat>:

int
stat(char *n, struct stat *st)
{
 26a:	55                   	push   %ebp
 26b:	89 e5                	mov    %esp,%ebp
 26d:	56                   	push   %esi
 26e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26f:	83 ec 08             	sub    $0x8,%esp
 272:	6a 00                	push   $0x0
 274:	ff 75 08             	pushl  0x8(%ebp)
 277:	e8 78 01 00 00       	call   3f4 <open>
  if(fd < 0)
 27c:	83 c4 10             	add    $0x10,%esp
 27f:	85 c0                	test   %eax,%eax
 281:	78 24                	js     2a7 <stat+0x3d>
 283:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 285:	83 ec 08             	sub    $0x8,%esp
 288:	ff 75 0c             	pushl  0xc(%ebp)
 28b:	50                   	push   %eax
 28c:	e8 7b 01 00 00       	call   40c <fstat>
 291:	89 c6                	mov    %eax,%esi
  close(fd);
 293:	89 1c 24             	mov    %ebx,(%esp)
 296:	e8 41 01 00 00       	call   3dc <close>
  return r;
 29b:	83 c4 10             	add    $0x10,%esp
}
 29e:	89 f0                	mov    %esi,%eax
 2a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2a3:	5b                   	pop    %ebx
 2a4:	5e                   	pop    %esi
 2a5:	5d                   	pop    %ebp
 2a6:	c3                   	ret    
    return -1;
 2a7:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2ac:	eb f0                	jmp    29e <stat+0x34>

000002ae <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 2ae:	55                   	push   %ebp
 2af:	89 e5                	mov    %esp,%ebp
 2b1:	56                   	push   %esi
 2b2:	53                   	push   %ebx
 2b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2b6:	0f b6 0a             	movzbl (%edx),%ecx
 2b9:	80 f9 20             	cmp    $0x20,%cl
 2bc:	75 0b                	jne    2c9 <atoi+0x1b>
 2be:	83 c2 01             	add    $0x1,%edx
 2c1:	0f b6 0a             	movzbl (%edx),%ecx
 2c4:	80 f9 20             	cmp    $0x20,%cl
 2c7:	74 f5                	je     2be <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 2c9:	80 f9 2d             	cmp    $0x2d,%cl
 2cc:	74 3b                	je     309 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 2ce:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 2d1:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 2d6:	f6 c1 fd             	test   $0xfd,%cl
 2d9:	74 33                	je     30e <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 2db:	0f b6 0a             	movzbl (%edx),%ecx
 2de:	8d 41 d0             	lea    -0x30(%ecx),%eax
 2e1:	3c 09                	cmp    $0x9,%al
 2e3:	77 2e                	ja     313 <atoi+0x65>
 2e5:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 2ea:	83 c2 01             	add    $0x1,%edx
 2ed:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2f0:	0f be c9             	movsbl %cl,%ecx
 2f3:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2f7:	0f b6 0a             	movzbl (%edx),%ecx
 2fa:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2fd:	80 fb 09             	cmp    $0x9,%bl
 300:	76 e8                	jbe    2ea <atoi+0x3c>
  return sign*n;
 302:	0f af c6             	imul   %esi,%eax
}
 305:	5b                   	pop    %ebx
 306:	5e                   	pop    %esi
 307:	5d                   	pop    %ebp
 308:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 309:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 30e:	83 c2 01             	add    $0x1,%edx
 311:	eb c8                	jmp    2db <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 313:	b8 00 00 00 00       	mov    $0x0,%eax
 318:	eb e8                	jmp    302 <atoi+0x54>

0000031a <atoo>:

int
atoo(const char *s)
{
 31a:	55                   	push   %ebp
 31b:	89 e5                	mov    %esp,%ebp
 31d:	56                   	push   %esi
 31e:	53                   	push   %ebx
 31f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 322:	0f b6 0a             	movzbl (%edx),%ecx
 325:	80 f9 20             	cmp    $0x20,%cl
 328:	75 0b                	jne    335 <atoo+0x1b>
 32a:	83 c2 01             	add    $0x1,%edx
 32d:	0f b6 0a             	movzbl (%edx),%ecx
 330:	80 f9 20             	cmp    $0x20,%cl
 333:	74 f5                	je     32a <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 335:	80 f9 2d             	cmp    $0x2d,%cl
 338:	74 38                	je     372 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 33a:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 33d:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 342:	f6 c1 fd             	test   $0xfd,%cl
 345:	74 30                	je     377 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 347:	0f b6 0a             	movzbl (%edx),%ecx
 34a:	8d 41 d0             	lea    -0x30(%ecx),%eax
 34d:	3c 07                	cmp    $0x7,%al
 34f:	77 2b                	ja     37c <atoo+0x62>
 351:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 356:	83 c2 01             	add    $0x1,%edx
 359:	0f be c9             	movsbl %cl,%ecx
 35c:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 360:	0f b6 0a             	movzbl (%edx),%ecx
 363:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 366:	80 fb 07             	cmp    $0x7,%bl
 369:	76 eb                	jbe    356 <atoo+0x3c>
  return sign*n;
 36b:	0f af c6             	imul   %esi,%eax
}
 36e:	5b                   	pop    %ebx
 36f:	5e                   	pop    %esi
 370:	5d                   	pop    %ebp
 371:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 372:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 377:	83 c2 01             	add    $0x1,%edx
 37a:	eb cb                	jmp    347 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 37c:	b8 00 00 00 00       	mov    $0x0,%eax
 381:	eb e8                	jmp    36b <atoo+0x51>

00000383 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	56                   	push   %esi
 387:	53                   	push   %ebx
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	8b 75 0c             	mov    0xc(%ebp),%esi
 38e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 391:	85 db                	test   %ebx,%ebx
 393:	7e 13                	jle    3a8 <memmove+0x25>
 395:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 39a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 39e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3a1:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3a4:	39 d3                	cmp    %edx,%ebx
 3a6:	75 f2                	jne    39a <memmove+0x17>
  return vdst;
}
 3a8:	5b                   	pop    %ebx
 3a9:	5e                   	pop    %esi
 3aa:	5d                   	pop    %ebp
 3ab:	c3                   	ret    

000003ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ac:	b8 01 00 00 00       	mov    $0x1,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <exit>:
SYSCALL(exit)
 3b4:	b8 02 00 00 00       	mov    $0x2,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <wait>:
SYSCALL(wait)
 3bc:	b8 03 00 00 00       	mov    $0x3,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <pipe>:
SYSCALL(pipe)
 3c4:	b8 04 00 00 00       	mov    $0x4,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <read>:
SYSCALL(read)
 3cc:	b8 05 00 00 00       	mov    $0x5,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <write>:
SYSCALL(write)
 3d4:	b8 10 00 00 00       	mov    $0x10,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <close>:
SYSCALL(close)
 3dc:	b8 15 00 00 00       	mov    $0x15,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <kill>:
SYSCALL(kill)
 3e4:	b8 06 00 00 00       	mov    $0x6,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <exec>:
SYSCALL(exec)
 3ec:	b8 07 00 00 00       	mov    $0x7,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <open>:
SYSCALL(open)
 3f4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <mknod>:
SYSCALL(mknod)
 3fc:	b8 11 00 00 00       	mov    $0x11,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <unlink>:
SYSCALL(unlink)
 404:	b8 12 00 00 00       	mov    $0x12,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <fstat>:
SYSCALL(fstat)
 40c:	b8 08 00 00 00       	mov    $0x8,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <link>:
SYSCALL(link)
 414:	b8 13 00 00 00       	mov    $0x13,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <mkdir>:
SYSCALL(mkdir)
 41c:	b8 14 00 00 00       	mov    $0x14,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <chdir>:
SYSCALL(chdir)
 424:	b8 09 00 00 00       	mov    $0x9,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <dup>:
SYSCALL(dup)
 42c:	b8 0a 00 00 00       	mov    $0xa,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <getpid>:
SYSCALL(getpid)
 434:	b8 0b 00 00 00       	mov    $0xb,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <sbrk>:
SYSCALL(sbrk)
 43c:	b8 0c 00 00 00       	mov    $0xc,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <sleep>:
SYSCALL(sleep)
 444:	b8 0d 00 00 00       	mov    $0xd,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <uptime>:
SYSCALL(uptime)
 44c:	b8 0e 00 00 00       	mov    $0xe,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <halt>:
SYSCALL(halt)
 454:	b8 16 00 00 00       	mov    $0x16,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <date>:
//proj1
SYSCALL(date)
 45c:	b8 17 00 00 00       	mov    $0x17,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <getuid>:
//proj2
SYSCALL(getuid)
 464:	b8 18 00 00 00       	mov    $0x18,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <getgid>:
SYSCALL(getgid)
 46c:	b8 19 00 00 00       	mov    $0x19,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <getppid>:
SYSCALL(getppid)
 474:	b8 1a 00 00 00       	mov    $0x1a,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <setuid>:
SYSCALL(setuid)
 47c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <setgid>:
SYSCALL(setgid)
 484:	b8 1c 00 00 00       	mov    $0x1c,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <getprocs>:
SYSCALL(getprocs)
 48c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 494:	55                   	push   %ebp
 495:	89 e5                	mov    %esp,%ebp
 497:	57                   	push   %edi
 498:	56                   	push   %esi
 499:	53                   	push   %ebx
 49a:	83 ec 3c             	sub    $0x3c,%esp
 49d:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 49f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 4a3:	74 14                	je     4b9 <printint+0x25>
 4a5:	85 d2                	test   %edx,%edx
 4a7:	79 10                	jns    4b9 <printint+0x25>
    neg = 1;
    x = -xx;
 4a9:	f7 da                	neg    %edx
    neg = 1;
 4ab:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4b2:	bf 00 00 00 00       	mov    $0x0,%edi
 4b7:	eb 0b                	jmp    4c4 <printint+0x30>
  neg = 0;
 4b9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4c0:	eb f0                	jmp    4b2 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 4c2:	89 df                	mov    %ebx,%edi
 4c4:	8d 5f 01             	lea    0x1(%edi),%ebx
 4c7:	89 d0                	mov    %edx,%eax
 4c9:	ba 00 00 00 00       	mov    $0x0,%edx
 4ce:	f7 f1                	div    %ecx
 4d0:	0f b6 92 3c 09 00 00 	movzbl 0x93c(%edx),%edx
 4d7:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 4db:	89 c2                	mov    %eax,%edx
 4dd:	85 c0                	test   %eax,%eax
 4df:	75 e1                	jne    4c2 <printint+0x2e>
  if(neg)
 4e1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 4e5:	74 08                	je     4ef <printint+0x5b>
    buf[i++] = '-';
 4e7:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4ec:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 4ef:	83 eb 01             	sub    $0x1,%ebx
 4f2:	78 22                	js     516 <printint+0x82>
  write(fd, &c, 1);
 4f4:	8d 7d d7             	lea    -0x29(%ebp),%edi
 4f7:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 4fc:	88 45 d7             	mov    %al,-0x29(%ebp)
 4ff:	83 ec 04             	sub    $0x4,%esp
 502:	6a 01                	push   $0x1
 504:	57                   	push   %edi
 505:	56                   	push   %esi
 506:	e8 c9 fe ff ff       	call   3d4 <write>
  while(--i >= 0)
 50b:	83 eb 01             	sub    $0x1,%ebx
 50e:	83 c4 10             	add    $0x10,%esp
 511:	83 fb ff             	cmp    $0xffffffff,%ebx
 514:	75 e1                	jne    4f7 <printint+0x63>
    putc(fd, buf[i]);
}
 516:	8d 65 f4             	lea    -0xc(%ebp),%esp
 519:	5b                   	pop    %ebx
 51a:	5e                   	pop    %esi
 51b:	5f                   	pop    %edi
 51c:	5d                   	pop    %ebp
 51d:	c3                   	ret    

0000051e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 51e:	55                   	push   %ebp
 51f:	89 e5                	mov    %esp,%ebp
 521:	57                   	push   %edi
 522:	56                   	push   %esi
 523:	53                   	push   %ebx
 524:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 527:	8b 75 0c             	mov    0xc(%ebp),%esi
 52a:	0f b6 1e             	movzbl (%esi),%ebx
 52d:	84 db                	test   %bl,%bl
 52f:	0f 84 b1 01 00 00    	je     6e6 <printf+0x1c8>
 535:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 538:	8d 45 10             	lea    0x10(%ebp),%eax
 53b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 53e:	bf 00 00 00 00       	mov    $0x0,%edi
 543:	eb 2d                	jmp    572 <printf+0x54>
 545:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 548:	83 ec 04             	sub    $0x4,%esp
 54b:	6a 01                	push   $0x1
 54d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 550:	50                   	push   %eax
 551:	ff 75 08             	pushl  0x8(%ebp)
 554:	e8 7b fe ff ff       	call   3d4 <write>
 559:	83 c4 10             	add    $0x10,%esp
 55c:	eb 05                	jmp    563 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 55e:	83 ff 25             	cmp    $0x25,%edi
 561:	74 22                	je     585 <printf+0x67>
 563:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 566:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 56a:	84 db                	test   %bl,%bl
 56c:	0f 84 74 01 00 00    	je     6e6 <printf+0x1c8>
    c = fmt[i] & 0xff;
 572:	0f be d3             	movsbl %bl,%edx
 575:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 578:	85 ff                	test   %edi,%edi
 57a:	75 e2                	jne    55e <printf+0x40>
      if(c == '%'){
 57c:	83 f8 25             	cmp    $0x25,%eax
 57f:	75 c4                	jne    545 <printf+0x27>
        state = '%';
 581:	89 c7                	mov    %eax,%edi
 583:	eb de                	jmp    563 <printf+0x45>
      if(c == 'd'){
 585:	83 f8 64             	cmp    $0x64,%eax
 588:	74 59                	je     5e3 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 58a:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 590:	83 fa 70             	cmp    $0x70,%edx
 593:	74 7a                	je     60f <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 595:	83 f8 73             	cmp    $0x73,%eax
 598:	0f 84 9d 00 00 00    	je     63b <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59e:	83 f8 63             	cmp    $0x63,%eax
 5a1:	0f 84 f2 00 00 00    	je     699 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5a7:	83 f8 25             	cmp    $0x25,%eax
 5aa:	0f 84 15 01 00 00    	je     6c5 <printf+0x1a7>
 5b0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 5b4:	83 ec 04             	sub    $0x4,%esp
 5b7:	6a 01                	push   $0x1
 5b9:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 0f fe ff ff       	call   3d4 <write>
 5c5:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5c8:	83 c4 0c             	add    $0xc,%esp
 5cb:	6a 01                	push   $0x1
 5cd:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5d0:	50                   	push   %eax
 5d1:	ff 75 08             	pushl  0x8(%ebp)
 5d4:	e8 fb fd ff ff       	call   3d4 <write>
 5d9:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5dc:	bf 00 00 00 00       	mov    $0x0,%edi
 5e1:	eb 80                	jmp    563 <printf+0x45>
        printint(fd, *ap, 10, 1);
 5e3:	83 ec 0c             	sub    $0xc,%esp
 5e6:	6a 01                	push   $0x1
 5e8:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5ed:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5f0:	8b 17                	mov    (%edi),%edx
 5f2:	8b 45 08             	mov    0x8(%ebp),%eax
 5f5:	e8 9a fe ff ff       	call   494 <printint>
        ap++;
 5fa:	89 f8                	mov    %edi,%eax
 5fc:	83 c0 04             	add    $0x4,%eax
 5ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 602:	83 c4 10             	add    $0x10,%esp
      state = 0;
 605:	bf 00 00 00 00       	mov    $0x0,%edi
 60a:	e9 54 ff ff ff       	jmp    563 <printf+0x45>
        printint(fd, *ap, 16, 0);
 60f:	83 ec 0c             	sub    $0xc,%esp
 612:	6a 00                	push   $0x0
 614:	b9 10 00 00 00       	mov    $0x10,%ecx
 619:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 61c:	8b 17                	mov    (%edi),%edx
 61e:	8b 45 08             	mov    0x8(%ebp),%eax
 621:	e8 6e fe ff ff       	call   494 <printint>
        ap++;
 626:	89 f8                	mov    %edi,%eax
 628:	83 c0 04             	add    $0x4,%eax
 62b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 62e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 631:	bf 00 00 00 00       	mov    $0x0,%edi
 636:	e9 28 ff ff ff       	jmp    563 <printf+0x45>
        s = (char*)*ap;
 63b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 63e:	8b 01                	mov    (%ecx),%eax
        ap++;
 640:	83 c1 04             	add    $0x4,%ecx
 643:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 646:	85 c0                	test   %eax,%eax
 648:	74 13                	je     65d <printf+0x13f>
        s = (char*)*ap;
 64a:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 64c:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 64f:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 654:	84 c0                	test   %al,%al
 656:	75 0f                	jne    667 <printf+0x149>
 658:	e9 06 ff ff ff       	jmp    563 <printf+0x45>
          s = "(null)";
 65d:	bb 34 09 00 00       	mov    $0x934,%ebx
        while(*s != 0){
 662:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 667:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 66a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 66d:	8b 75 08             	mov    0x8(%ebp),%esi
 670:	88 45 e3             	mov    %al,-0x1d(%ebp)
 673:	83 ec 04             	sub    $0x4,%esp
 676:	6a 01                	push   $0x1
 678:	57                   	push   %edi
 679:	56                   	push   %esi
 67a:	e8 55 fd ff ff       	call   3d4 <write>
          s++;
 67f:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 682:	0f b6 03             	movzbl (%ebx),%eax
 685:	83 c4 10             	add    $0x10,%esp
 688:	84 c0                	test   %al,%al
 68a:	75 e4                	jne    670 <printf+0x152>
 68c:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 68f:	bf 00 00 00 00       	mov    $0x0,%edi
 694:	e9 ca fe ff ff       	jmp    563 <printf+0x45>
        putc(fd, *ap);
 699:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 69c:	8b 07                	mov    (%edi),%eax
 69e:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 6a1:	83 ec 04             	sub    $0x4,%esp
 6a4:	6a 01                	push   $0x1
 6a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6a9:	50                   	push   %eax
 6aa:	ff 75 08             	pushl  0x8(%ebp)
 6ad:	e8 22 fd ff ff       	call   3d4 <write>
        ap++;
 6b2:	83 c7 04             	add    $0x4,%edi
 6b5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 6b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6bb:	bf 00 00 00 00       	mov    $0x0,%edi
 6c0:	e9 9e fe ff ff       	jmp    563 <printf+0x45>
 6c5:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 6c8:	83 ec 04             	sub    $0x4,%esp
 6cb:	6a 01                	push   $0x1
 6cd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6d0:	50                   	push   %eax
 6d1:	ff 75 08             	pushl  0x8(%ebp)
 6d4:	e8 fb fc ff ff       	call   3d4 <write>
 6d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6dc:	bf 00 00 00 00       	mov    $0x0,%edi
 6e1:	e9 7d fe ff ff       	jmp    563 <printf+0x45>
    }
  }
}
 6e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e9:	5b                   	pop    %ebx
 6ea:	5e                   	pop    %esi
 6eb:	5f                   	pop    %edi
 6ec:	5d                   	pop    %ebp
 6ed:	c3                   	ret    

000006ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ee:	55                   	push   %ebp
 6ef:	89 e5                	mov    %esp,%ebp
 6f1:	57                   	push   %edi
 6f2:	56                   	push   %esi
 6f3:	53                   	push   %ebx
 6f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f7:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 6ff:	eb 0c                	jmp    70d <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 701:	8b 10                	mov    (%eax),%edx
 703:	39 c2                	cmp    %eax,%edx
 705:	77 04                	ja     70b <free+0x1d>
 707:	39 ca                	cmp    %ecx,%edx
 709:	77 10                	ja     71b <free+0x2d>
{
 70b:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70d:	39 c8                	cmp    %ecx,%eax
 70f:	73 f0                	jae    701 <free+0x13>
 711:	8b 10                	mov    (%eax),%edx
 713:	39 ca                	cmp    %ecx,%edx
 715:	77 04                	ja     71b <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 717:	39 c2                	cmp    %eax,%edx
 719:	77 f0                	ja     70b <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 71b:	8b 73 fc             	mov    -0x4(%ebx),%esi
 71e:	8b 10                	mov    (%eax),%edx
 720:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 723:	39 fa                	cmp    %edi,%edx
 725:	74 19                	je     740 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 727:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 72a:	8b 50 04             	mov    0x4(%eax),%edx
 72d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 730:	39 f1                	cmp    %esi,%ecx
 732:	74 1b                	je     74f <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 734:	89 08                	mov    %ecx,(%eax)
  freep = p;
 736:	a3 e0 0b 00 00       	mov    %eax,0xbe0
}
 73b:	5b                   	pop    %ebx
 73c:	5e                   	pop    %esi
 73d:	5f                   	pop    %edi
 73e:	5d                   	pop    %ebp
 73f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 740:	03 72 04             	add    0x4(%edx),%esi
 743:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 746:	8b 10                	mov    (%eax),%edx
 748:	8b 12                	mov    (%edx),%edx
 74a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 74d:	eb db                	jmp    72a <free+0x3c>
    p->s.size += bp->s.size;
 74f:	03 53 fc             	add    -0x4(%ebx),%edx
 752:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 755:	8b 53 f8             	mov    -0x8(%ebx),%edx
 758:	89 10                	mov    %edx,(%eax)
 75a:	eb da                	jmp    736 <free+0x48>

0000075c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 75c:	55                   	push   %ebp
 75d:	89 e5                	mov    %esp,%ebp
 75f:	57                   	push   %edi
 760:	56                   	push   %esi
 761:	53                   	push   %ebx
 762:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 765:	8b 45 08             	mov    0x8(%ebp),%eax
 768:	8d 58 07             	lea    0x7(%eax),%ebx
 76b:	c1 eb 03             	shr    $0x3,%ebx
 76e:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 771:	8b 15 e0 0b 00 00    	mov    0xbe0,%edx
 777:	85 d2                	test   %edx,%edx
 779:	74 20                	je     79b <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77b:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 77d:	8b 48 04             	mov    0x4(%eax),%ecx
 780:	39 cb                	cmp    %ecx,%ebx
 782:	76 3c                	jbe    7c0 <malloc+0x64>
 784:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 78a:	be 00 10 00 00       	mov    $0x1000,%esi
 78f:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 792:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 799:	eb 70                	jmp    80b <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 79b:	c7 05 e0 0b 00 00 e4 	movl   $0xbe4,0xbe0
 7a2:	0b 00 00 
 7a5:	c7 05 e4 0b 00 00 e4 	movl   $0xbe4,0xbe4
 7ac:	0b 00 00 
    base.s.size = 0;
 7af:	c7 05 e8 0b 00 00 00 	movl   $0x0,0xbe8
 7b6:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 7b9:	ba e4 0b 00 00       	mov    $0xbe4,%edx
 7be:	eb bb                	jmp    77b <malloc+0x1f>
      if(p->s.size == nunits)
 7c0:	39 cb                	cmp    %ecx,%ebx
 7c2:	74 1c                	je     7e0 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7c4:	29 d9                	sub    %ebx,%ecx
 7c6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7c9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7cc:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7cf:	89 15 e0 0b 00 00    	mov    %edx,0xbe0
      return (void*)(p + 1);
 7d5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7db:	5b                   	pop    %ebx
 7dc:	5e                   	pop    %esi
 7dd:	5f                   	pop    %edi
 7de:	5d                   	pop    %ebp
 7df:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 7e0:	8b 08                	mov    (%eax),%ecx
 7e2:	89 0a                	mov    %ecx,(%edx)
 7e4:	eb e9                	jmp    7cf <malloc+0x73>
  hp->s.size = nu;
 7e6:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 7e9:	83 ec 0c             	sub    $0xc,%esp
 7ec:	83 c0 08             	add    $0x8,%eax
 7ef:	50                   	push   %eax
 7f0:	e8 f9 fe ff ff       	call   6ee <free>
  return freep;
 7f5:	8b 15 e0 0b 00 00    	mov    0xbe0,%edx
      if((p = morecore(nunits)) == 0)
 7fb:	83 c4 10             	add    $0x10,%esp
 7fe:	85 d2                	test   %edx,%edx
 800:	74 2b                	je     82d <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 802:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 804:	8b 48 04             	mov    0x4(%eax),%ecx
 807:	39 d9                	cmp    %ebx,%ecx
 809:	73 b5                	jae    7c0 <malloc+0x64>
 80b:	89 c2                	mov    %eax,%edx
    if(p == freep)
 80d:	39 05 e0 0b 00 00    	cmp    %eax,0xbe0
 813:	75 ed                	jne    802 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 815:	83 ec 0c             	sub    $0xc,%esp
 818:	57                   	push   %edi
 819:	e8 1e fc ff ff       	call   43c <sbrk>
  if(p == (char*)-1)
 81e:	83 c4 10             	add    $0x10,%esp
 821:	83 f8 ff             	cmp    $0xffffffff,%eax
 824:	75 c0                	jne    7e6 <malloc+0x8a>
        return 0;
 826:	b8 00 00 00 00       	mov    $0x0,%eax
 82b:	eb ab                	jmp    7d8 <malloc+0x7c>
 82d:	b8 00 00 00 00       	mov    $0x0,%eax
 832:	eb a4                	jmp    7d8 <malloc+0x7c>
