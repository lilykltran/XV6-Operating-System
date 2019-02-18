
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "uproc.h"
#define MAX 72; //altered for testing

int
main(void)
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
  11:	83 ec 24             	sub    $0x24,%esp
  uint max = MAX;
  struct uproc *table = malloc(max * sizeof(struct uproc));
  14:	68 00 1b 00 00       	push   $0x1b00
  19:	e8 99 07 00 00       	call   7b7 <malloc>
  1e:	89 c3                	mov    %eax,%ebx
  int num = getprocs(max, table);  
  20:	83 c4 08             	add    $0x8,%esp
  23:	50                   	push   %eax
  24:	6a 48                	push   $0x48
  26:	e8 bc 04 00 00       	call   4e7 <getprocs>
  2b:	89 c6                	mov    %eax,%esi

  printf(1, "\nMAX = %d\n", max); //Display the current MAX value for 1, 16, 64, and 72 
  2d:	83 c4 0c             	add    $0xc,%esp
  30:	6a 48                	push   $0x48
  32:	68 90 08 00 00       	push   $0x890
  37:	6a 01                	push   $0x1
  39:	e8 3b 05 00 00       	call   579 <printf>

  printf(1, "\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n"); //Print the header
  3e:	83 c4 08             	add    $0x8,%esp
  41:	68 bc 08 00 00       	push   $0x8bc
  46:	6a 01                	push   $0x1
  48:	e8 2c 05 00 00       	call   579 <printf>

  for (int i = 0; i < num; ++i)
  4d:	83 c4 10             	add    $0x10,%esp
  50:	85 f6                	test   %esi,%esi
  52:	0f 8e 55 01 00 00    	jle    1ad <main+0x1ad>
  58:	83 c3 40             	add    $0x40,%ebx
  5b:	8d 04 76             	lea    (%esi,%esi,2),%eax
  5e:	c1 e0 05             	shl    $0x5,%eax
  61:	01 d8                	add    %ebx,%eax
  63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  66:	eb 7a                	jmp    e2 <main+0xe2>
    int sec = table[i].elapsed_ticks/1000; //Find sec
    int ms = table[i].elapsed_ticks%1000; //Find milisec for elapsed
    printf(1, "%d.", sec); 

    if(ms < 10)
      printf(1, "00%d\t", ms);
  68:	83 ec 04             	sub    $0x4,%esp
  6b:	56                   	push   %esi
  6c:	68 af 08 00 00       	push   $0x8af
  71:	6a 01                	push   $0x1
  73:	e8 01 05 00 00       	call   579 <printf>
  78:	83 c4 10             	add    $0x10,%esp
  7b:	e9 d4 00 00 00       	jmp    154 <main+0x154>

    else if(ms < 100)
      printf(1, "0%d\t", ms);

    else
      printf(1, "%d\t", ms);
  80:	83 ec 04             	sub    $0x4,%esp
  83:	56                   	push   %esi
  84:	68 a7 08 00 00       	push   $0x8a7
  89:	6a 01                	push   $0x1
  8b:	e8 e9 04 00 00       	call   579 <printf>
  90:	83 c4 10             	add    $0x10,%esp
  93:	e9 bc 00 00 00       	jmp    154 <main+0x154>
    ms = table[i].CPU_total_ticks%1000; //Find milisec for CPU

    printf(1, "%d.", sec); 

    if(ms <10)
       printf(1, "00%d\t", ms);
  98:	83 ec 04             	sub    $0x4,%esp
  9b:	56                   	push   %esi
  9c:	68 af 08 00 00       	push   $0x8af
  a1:	6a 01                	push   $0x1
  a3:	e8 d1 04 00 00       	call   579 <printf>
  a8:	83 c4 10             	add    $0x10,%esp
  ab:	eb 13                	jmp    c0 <main+0xc0>

    else if(ms < 100)
       printf(1, "0%d\t", ms);

    else
       printf(1, "%d\t", ms);
  ad:	83 ec 04             	sub    $0x4,%esp
  b0:	56                   	push   %esi
  b1:	68 a7 08 00 00       	push   $0x8a7
  b6:	6a 01                	push   $0x1
  b8:	e8 bc 04 00 00       	call   579 <printf>
  bd:	83 c4 10             	add    $0x10,%esp

    printf(1, "%s\t%d\n", table[i].state, table[i].size); // Display state and size
  c0:	ff 77 fc             	pushl  -0x4(%edi)
  c3:	8d 43 dc             	lea    -0x24(%ebx),%eax
  c6:	50                   	push   %eax
  c7:	68 b5 08 00 00       	push   $0x8b5
  cc:	6a 01                	push   $0x1
  ce:	e8 a6 04 00 00       	call   579 <printf>
  d3:	83 c3 60             	add    $0x60,%ebx
  for (int i = 0; i < num; ++i)
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  dc:	0f 84 cb 00 00 00    	je     1ad <main+0x1ad>
  e2:	89 df                	mov    %ebx,%edi
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name, table[i].uid, table[i].gid, table[i].ppid);
  e4:	83 ec 04             	sub    $0x4,%esp
  e7:	ff 73 cc             	pushl  -0x34(%ebx)
  ea:	ff 73 c8             	pushl  -0x38(%ebx)
  ed:	ff 73 c4             	pushl  -0x3c(%ebx)
  f0:	53                   	push   %ebx
  f1:	ff 73 c0             	pushl  -0x40(%ebx)
  f4:	68 9b 08 00 00       	push   $0x89b
  f9:	6a 01                	push   $0x1
  fb:	e8 79 04 00 00       	call   579 <printf>
    int sec = table[i].elapsed_ticks/1000; //Find sec
 100:	8b 4b d4             	mov    -0x2c(%ebx),%ecx
    int ms = table[i].elapsed_ticks%1000; //Find milisec for elapsed
 103:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
 108:	f7 e1                	mul    %ecx
 10a:	89 d6                	mov    %edx,%esi
 10c:	c1 ee 06             	shr    $0x6,%esi
 10f:	69 f6 e8 03 00 00    	imul   $0x3e8,%esi,%esi
 115:	29 f1                	sub    %esi,%ecx
 117:	89 ce                	mov    %ecx,%esi
    printf(1, "%d.", sec); 
 119:	83 c4 1c             	add    $0x1c,%esp
    int sec = table[i].elapsed_ticks/1000; //Find sec
 11c:	c1 ea 06             	shr    $0x6,%edx
    printf(1, "%d.", sec); 
 11f:	52                   	push   %edx
 120:	68 ab 08 00 00       	push   $0x8ab
 125:	6a 01                	push   $0x1
 127:	e8 4d 04 00 00       	call   579 <printf>
    if(ms < 10)
 12c:	83 c4 10             	add    $0x10,%esp
 12f:	83 fe 09             	cmp    $0x9,%esi
 132:	0f 8e 30 ff ff ff    	jle    68 <main+0x68>
    else if(ms < 100)
 138:	83 fe 63             	cmp    $0x63,%esi
 13b:	0f 8f 3f ff ff ff    	jg     80 <main+0x80>
      printf(1, "0%d\t", ms);
 141:	83 ec 04             	sub    $0x4,%esp
 144:	56                   	push   %esi
 145:	68 b0 08 00 00       	push   $0x8b0
 14a:	6a 01                	push   $0x1
 14c:	e8 28 04 00 00       	call   579 <printf>
 151:	83 c4 10             	add    $0x10,%esp
    sec = table[i].CPU_total_ticks/1000; //Find Sec
 154:	8b 4f d8             	mov    -0x28(%edi),%ecx
    ms = table[i].CPU_total_ticks%1000; //Find milisec for CPU
 157:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
 15c:	f7 e1                	mul    %ecx
 15e:	89 d6                	mov    %edx,%esi
 160:	c1 ee 06             	shr    $0x6,%esi
 163:	69 f6 e8 03 00 00    	imul   $0x3e8,%esi,%esi
 169:	29 f1                	sub    %esi,%ecx
 16b:	89 ce                	mov    %ecx,%esi
    printf(1, "%d.", sec); 
 16d:	83 ec 04             	sub    $0x4,%esp
    sec = table[i].CPU_total_ticks/1000; //Find Sec
 170:	c1 ea 06             	shr    $0x6,%edx
    printf(1, "%d.", sec); 
 173:	52                   	push   %edx
 174:	68 ab 08 00 00       	push   $0x8ab
 179:	6a 01                	push   $0x1
 17b:	e8 f9 03 00 00       	call   579 <printf>
    if(ms <10)
 180:	83 c4 10             	add    $0x10,%esp
 183:	83 fe 09             	cmp    $0x9,%esi
 186:	0f 8e 0c ff ff ff    	jle    98 <main+0x98>
    else if(ms < 100)
 18c:	83 fe 63             	cmp    $0x63,%esi
 18f:	0f 8f 18 ff ff ff    	jg     ad <main+0xad>
       printf(1, "0%d\t", ms);
 195:	83 ec 04             	sub    $0x4,%esp
 198:	56                   	push   %esi
 199:	68 b0 08 00 00       	push   $0x8b0
 19e:	6a 01                	push   $0x1
 1a0:	e8 d4 03 00 00       	call   579 <printf>
 1a5:	83 c4 10             	add    $0x10,%esp
 1a8:	e9 13 ff ff ff       	jmp    c0 <main+0xc0>
  }
  exit();
 1ad:	e8 5d 02 00 00       	call   40f <exit>

000001b2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	53                   	push   %ebx
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1bc:	89 c2                	mov    %eax,%edx
 1be:	83 c1 01             	add    $0x1,%ecx
 1c1:	83 c2 01             	add    $0x1,%edx
 1c4:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1c8:	88 5a ff             	mov    %bl,-0x1(%edx)
 1cb:	84 db                	test   %bl,%bl
 1cd:	75 ef                	jne    1be <strcpy+0xc>
    ;
  return os;
}
 1cf:	5b                   	pop    %ebx
 1d0:	5d                   	pop    %ebp
 1d1:	c3                   	ret    

000001d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d2:	55                   	push   %ebp
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1db:	0f b6 01             	movzbl (%ecx),%eax
 1de:	84 c0                	test   %al,%al
 1e0:	74 15                	je     1f7 <strcmp+0x25>
 1e2:	3a 02                	cmp    (%edx),%al
 1e4:	75 11                	jne    1f7 <strcmp+0x25>
    p++, q++;
 1e6:	83 c1 01             	add    $0x1,%ecx
 1e9:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1ec:	0f b6 01             	movzbl (%ecx),%eax
 1ef:	84 c0                	test   %al,%al
 1f1:	74 04                	je     1f7 <strcmp+0x25>
 1f3:	3a 02                	cmp    (%edx),%al
 1f5:	74 ef                	je     1e6 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1f7:	0f b6 c0             	movzbl %al,%eax
 1fa:	0f b6 12             	movzbl (%edx),%edx
 1fd:	29 d0                	sub    %edx,%eax
}
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    

00000201 <strlen>:

uint
strlen(char *s)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 207:	80 39 00             	cmpb   $0x0,(%ecx)
 20a:	74 12                	je     21e <strlen+0x1d>
 20c:	ba 00 00 00 00       	mov    $0x0,%edx
 211:	83 c2 01             	add    $0x1,%edx
 214:	89 d0                	mov    %edx,%eax
 216:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 21a:	75 f5                	jne    211 <strlen+0x10>
    ;
  return n;
}
 21c:	5d                   	pop    %ebp
 21d:	c3                   	ret    
  for(n = 0; s[n]; n++)
 21e:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 223:	eb f7                	jmp    21c <strlen+0x1b>

00000225 <memset>:

void*
memset(void *dst, int c, uint n)
{
 225:	55                   	push   %ebp
 226:	89 e5                	mov    %esp,%ebp
 228:	57                   	push   %edi
 229:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 22c:	89 d7                	mov    %edx,%edi
 22e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 231:	8b 45 0c             	mov    0xc(%ebp),%eax
 234:	fc                   	cld    
 235:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 237:	89 d0                	mov    %edx,%eax
 239:	5f                   	pop    %edi
 23a:	5d                   	pop    %ebp
 23b:	c3                   	ret    

0000023c <strchr>:

char*
strchr(const char *s, char c)
{
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	53                   	push   %ebx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 246:	0f b6 10             	movzbl (%eax),%edx
 249:	84 d2                	test   %dl,%dl
 24b:	74 1e                	je     26b <strchr+0x2f>
 24d:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 24f:	38 d3                	cmp    %dl,%bl
 251:	74 15                	je     268 <strchr+0x2c>
  for(; *s; s++)
 253:	83 c0 01             	add    $0x1,%eax
 256:	0f b6 10             	movzbl (%eax),%edx
 259:	84 d2                	test   %dl,%dl
 25b:	74 06                	je     263 <strchr+0x27>
    if(*s == c)
 25d:	38 ca                	cmp    %cl,%dl
 25f:	75 f2                	jne    253 <strchr+0x17>
 261:	eb 05                	jmp    268 <strchr+0x2c>
      return (char*)s;
  return 0;
 263:	b8 00 00 00 00       	mov    $0x0,%eax
}
 268:	5b                   	pop    %ebx
 269:	5d                   	pop    %ebp
 26a:	c3                   	ret    
  return 0;
 26b:	b8 00 00 00 00       	mov    $0x0,%eax
 270:	eb f6                	jmp    268 <strchr+0x2c>

00000272 <gets>:

char*
gets(char *buf, int max)
{
 272:	55                   	push   %ebp
 273:	89 e5                	mov    %esp,%ebp
 275:	57                   	push   %edi
 276:	56                   	push   %esi
 277:	53                   	push   %ebx
 278:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27b:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 280:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 283:	8d 5e 01             	lea    0x1(%esi),%ebx
 286:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 289:	7d 2b                	jge    2b6 <gets+0x44>
    cc = read(0, &c, 1);
 28b:	83 ec 04             	sub    $0x4,%esp
 28e:	6a 01                	push   $0x1
 290:	57                   	push   %edi
 291:	6a 00                	push   $0x0
 293:	e8 8f 01 00 00       	call   427 <read>
    if(cc < 1)
 298:	83 c4 10             	add    $0x10,%esp
 29b:	85 c0                	test   %eax,%eax
 29d:	7e 17                	jle    2b6 <gets+0x44>
      break;
    buf[i++] = c;
 29f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2a3:	8b 55 08             	mov    0x8(%ebp),%edx
 2a6:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 2aa:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 2ac:	3c 0a                	cmp    $0xa,%al
 2ae:	74 04                	je     2b4 <gets+0x42>
 2b0:	3c 0d                	cmp    $0xd,%al
 2b2:	75 cf                	jne    283 <gets+0x11>
  for(i=0; i+1 < max; ){
 2b4:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2c0:	5b                   	pop    %ebx
 2c1:	5e                   	pop    %esi
 2c2:	5f                   	pop    %edi
 2c3:	5d                   	pop    %ebp
 2c4:	c3                   	ret    

000002c5 <stat>:

int
stat(char *n, struct stat *st)
{
 2c5:	55                   	push   %ebp
 2c6:	89 e5                	mov    %esp,%ebp
 2c8:	56                   	push   %esi
 2c9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ca:	83 ec 08             	sub    $0x8,%esp
 2cd:	6a 00                	push   $0x0
 2cf:	ff 75 08             	pushl  0x8(%ebp)
 2d2:	e8 78 01 00 00       	call   44f <open>
  if(fd < 0)
 2d7:	83 c4 10             	add    $0x10,%esp
 2da:	85 c0                	test   %eax,%eax
 2dc:	78 24                	js     302 <stat+0x3d>
 2de:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2e0:	83 ec 08             	sub    $0x8,%esp
 2e3:	ff 75 0c             	pushl  0xc(%ebp)
 2e6:	50                   	push   %eax
 2e7:	e8 7b 01 00 00       	call   467 <fstat>
 2ec:	89 c6                	mov    %eax,%esi
  close(fd);
 2ee:	89 1c 24             	mov    %ebx,(%esp)
 2f1:	e8 41 01 00 00       	call   437 <close>
  return r;
 2f6:	83 c4 10             	add    $0x10,%esp
}
 2f9:	89 f0                	mov    %esi,%eax
 2fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2fe:	5b                   	pop    %ebx
 2ff:	5e                   	pop    %esi
 300:	5d                   	pop    %ebp
 301:	c3                   	ret    
    return -1;
 302:	be ff ff ff ff       	mov    $0xffffffff,%esi
 307:	eb f0                	jmp    2f9 <stat+0x34>

00000309 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp
 30c:	56                   	push   %esi
 30d:	53                   	push   %ebx
 30e:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 311:	0f b6 0a             	movzbl (%edx),%ecx
 314:	80 f9 20             	cmp    $0x20,%cl
 317:	75 0b                	jne    324 <atoi+0x1b>
 319:	83 c2 01             	add    $0x1,%edx
 31c:	0f b6 0a             	movzbl (%edx),%ecx
 31f:	80 f9 20             	cmp    $0x20,%cl
 322:	74 f5                	je     319 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 324:	80 f9 2d             	cmp    $0x2d,%cl
 327:	74 3b                	je     364 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 329:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 32c:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 331:	f6 c1 fd             	test   $0xfd,%cl
 334:	74 33                	je     369 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 336:	0f b6 0a             	movzbl (%edx),%ecx
 339:	8d 41 d0             	lea    -0x30(%ecx),%eax
 33c:	3c 09                	cmp    $0x9,%al
 33e:	77 2e                	ja     36e <atoi+0x65>
 340:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 345:	83 c2 01             	add    $0x1,%edx
 348:	8d 04 80             	lea    (%eax,%eax,4),%eax
 34b:	0f be c9             	movsbl %cl,%ecx
 34e:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 352:	0f b6 0a             	movzbl (%edx),%ecx
 355:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 358:	80 fb 09             	cmp    $0x9,%bl
 35b:	76 e8                	jbe    345 <atoi+0x3c>
  return sign*n;
 35d:	0f af c6             	imul   %esi,%eax
}
 360:	5b                   	pop    %ebx
 361:	5e                   	pop    %esi
 362:	5d                   	pop    %ebp
 363:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 364:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 369:	83 c2 01             	add    $0x1,%edx
 36c:	eb c8                	jmp    336 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 36e:	b8 00 00 00 00       	mov    $0x0,%eax
 373:	eb e8                	jmp    35d <atoi+0x54>

00000375 <atoo>:

int
atoo(const char *s)
{
 375:	55                   	push   %ebp
 376:	89 e5                	mov    %esp,%ebp
 378:	56                   	push   %esi
 379:	53                   	push   %ebx
 37a:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 37d:	0f b6 0a             	movzbl (%edx),%ecx
 380:	80 f9 20             	cmp    $0x20,%cl
 383:	75 0b                	jne    390 <atoo+0x1b>
 385:	83 c2 01             	add    $0x1,%edx
 388:	0f b6 0a             	movzbl (%edx),%ecx
 38b:	80 f9 20             	cmp    $0x20,%cl
 38e:	74 f5                	je     385 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 390:	80 f9 2d             	cmp    $0x2d,%cl
 393:	74 38                	je     3cd <atoo+0x58>
  if (*s == '+'  || *s == '-')
 395:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 398:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 39d:	f6 c1 fd             	test   $0xfd,%cl
 3a0:	74 30                	je     3d2 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 3a2:	0f b6 0a             	movzbl (%edx),%ecx
 3a5:	8d 41 d0             	lea    -0x30(%ecx),%eax
 3a8:	3c 07                	cmp    $0x7,%al
 3aa:	77 2b                	ja     3d7 <atoo+0x62>
 3ac:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 3b1:	83 c2 01             	add    $0x1,%edx
 3b4:	0f be c9             	movsbl %cl,%ecx
 3b7:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 3bb:	0f b6 0a             	movzbl (%edx),%ecx
 3be:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 3c1:	80 fb 07             	cmp    $0x7,%bl
 3c4:	76 eb                	jbe    3b1 <atoo+0x3c>
  return sign*n;
 3c6:	0f af c6             	imul   %esi,%eax
}
 3c9:	5b                   	pop    %ebx
 3ca:	5e                   	pop    %esi
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 3cd:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 3d2:	83 c2 01             	add    $0x1,%edx
 3d5:	eb cb                	jmp    3a2 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 3d7:	b8 00 00 00 00       	mov    $0x0,%eax
 3dc:	eb e8                	jmp    3c6 <atoo+0x51>

000003de <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
 3e1:	56                   	push   %esi
 3e2:	53                   	push   %ebx
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	8b 75 0c             	mov    0xc(%ebp),%esi
 3e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ec:	85 db                	test   %ebx,%ebx
 3ee:	7e 13                	jle    403 <memmove+0x25>
 3f0:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 3f5:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3f9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3fc:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3ff:	39 d3                	cmp    %edx,%ebx
 401:	75 f2                	jne    3f5 <memmove+0x17>
  return vdst;
}
 403:	5b                   	pop    %ebx
 404:	5e                   	pop    %esi
 405:	5d                   	pop    %ebp
 406:	c3                   	ret    

00000407 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 407:	b8 01 00 00 00       	mov    $0x1,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <exit>:
SYSCALL(exit)
 40f:	b8 02 00 00 00       	mov    $0x2,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <wait>:
SYSCALL(wait)
 417:	b8 03 00 00 00       	mov    $0x3,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <pipe>:
SYSCALL(pipe)
 41f:	b8 04 00 00 00       	mov    $0x4,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <read>:
SYSCALL(read)
 427:	b8 05 00 00 00       	mov    $0x5,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <write>:
SYSCALL(write)
 42f:	b8 10 00 00 00       	mov    $0x10,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <close>:
SYSCALL(close)
 437:	b8 15 00 00 00       	mov    $0x15,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <kill>:
SYSCALL(kill)
 43f:	b8 06 00 00 00       	mov    $0x6,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <exec>:
SYSCALL(exec)
 447:	b8 07 00 00 00       	mov    $0x7,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <open>:
SYSCALL(open)
 44f:	b8 0f 00 00 00       	mov    $0xf,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <mknod>:
SYSCALL(mknod)
 457:	b8 11 00 00 00       	mov    $0x11,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <unlink>:
SYSCALL(unlink)
 45f:	b8 12 00 00 00       	mov    $0x12,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <fstat>:
SYSCALL(fstat)
 467:	b8 08 00 00 00       	mov    $0x8,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <link>:
SYSCALL(link)
 46f:	b8 13 00 00 00       	mov    $0x13,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <mkdir>:
SYSCALL(mkdir)
 477:	b8 14 00 00 00       	mov    $0x14,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <chdir>:
SYSCALL(chdir)
 47f:	b8 09 00 00 00       	mov    $0x9,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <dup>:
SYSCALL(dup)
 487:	b8 0a 00 00 00       	mov    $0xa,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <getpid>:
SYSCALL(getpid)
 48f:	b8 0b 00 00 00       	mov    $0xb,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <sbrk>:
SYSCALL(sbrk)
 497:	b8 0c 00 00 00       	mov    $0xc,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <sleep>:
SYSCALL(sleep)
 49f:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <uptime>:
SYSCALL(uptime)
 4a7:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <halt>:
SYSCALL(halt)
 4af:	b8 16 00 00 00       	mov    $0x16,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <date>:
//proj1
SYSCALL(date)
 4b7:	b8 17 00 00 00       	mov    $0x17,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <getuid>:
//proj2
SYSCALL(getuid)
 4bf:	b8 18 00 00 00       	mov    $0x18,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <getgid>:
SYSCALL(getgid)
 4c7:	b8 19 00 00 00       	mov    $0x19,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <getppid>:
SYSCALL(getppid)
 4cf:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <setuid>:
SYSCALL(setuid)
 4d7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <setgid>:
SYSCALL(setgid)
 4df:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <getprocs>:
SYSCALL(getprocs)
 4e7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	57                   	push   %edi
 4f3:	56                   	push   %esi
 4f4:	53                   	push   %ebx
 4f5:	83 ec 3c             	sub    $0x3c,%esp
 4f8:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 4fe:	74 14                	je     514 <printint+0x25>
 500:	85 d2                	test   %edx,%edx
 502:	79 10                	jns    514 <printint+0x25>
    neg = 1;
    x = -xx;
 504:	f7 da                	neg    %edx
    neg = 1;
 506:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 50d:	bf 00 00 00 00       	mov    $0x0,%edi
 512:	eb 0b                	jmp    51f <printint+0x30>
  neg = 0;
 514:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 51b:	eb f0                	jmp    50d <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 51d:	89 df                	mov    %ebx,%edi
 51f:	8d 5f 01             	lea    0x1(%edi),%ebx
 522:	89 d0                	mov    %edx,%eax
 524:	ba 00 00 00 00       	mov    $0x0,%edx
 529:	f7 f1                	div    %ecx
 52b:	0f b6 92 f4 08 00 00 	movzbl 0x8f4(%edx),%edx
 532:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 536:	89 c2                	mov    %eax,%edx
 538:	85 c0                	test   %eax,%eax
 53a:	75 e1                	jne    51d <printint+0x2e>
  if(neg)
 53c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 540:	74 08                	je     54a <printint+0x5b>
    buf[i++] = '-';
 542:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 547:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 54a:	83 eb 01             	sub    $0x1,%ebx
 54d:	78 22                	js     571 <printint+0x82>
  write(fd, &c, 1);
 54f:	8d 7d d7             	lea    -0x29(%ebp),%edi
 552:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 557:	88 45 d7             	mov    %al,-0x29(%ebp)
 55a:	83 ec 04             	sub    $0x4,%esp
 55d:	6a 01                	push   $0x1
 55f:	57                   	push   %edi
 560:	56                   	push   %esi
 561:	e8 c9 fe ff ff       	call   42f <write>
  while(--i >= 0)
 566:	83 eb 01             	sub    $0x1,%ebx
 569:	83 c4 10             	add    $0x10,%esp
 56c:	83 fb ff             	cmp    $0xffffffff,%ebx
 56f:	75 e1                	jne    552 <printint+0x63>
    putc(fd, buf[i]);
}
 571:	8d 65 f4             	lea    -0xc(%ebp),%esp
 574:	5b                   	pop    %ebx
 575:	5e                   	pop    %esi
 576:	5f                   	pop    %edi
 577:	5d                   	pop    %ebp
 578:	c3                   	ret    

00000579 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 579:	55                   	push   %ebp
 57a:	89 e5                	mov    %esp,%ebp
 57c:	57                   	push   %edi
 57d:	56                   	push   %esi
 57e:	53                   	push   %ebx
 57f:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 582:	8b 75 0c             	mov    0xc(%ebp),%esi
 585:	0f b6 1e             	movzbl (%esi),%ebx
 588:	84 db                	test   %bl,%bl
 58a:	0f 84 b1 01 00 00    	je     741 <printf+0x1c8>
 590:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 593:	8d 45 10             	lea    0x10(%ebp),%eax
 596:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 599:	bf 00 00 00 00       	mov    $0x0,%edi
 59e:	eb 2d                	jmp    5cd <printf+0x54>
 5a0:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 5a3:	83 ec 04             	sub    $0x4,%esp
 5a6:	6a 01                	push   $0x1
 5a8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5ab:	50                   	push   %eax
 5ac:	ff 75 08             	pushl  0x8(%ebp)
 5af:	e8 7b fe ff ff       	call   42f <write>
 5b4:	83 c4 10             	add    $0x10,%esp
 5b7:	eb 05                	jmp    5be <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5b9:	83 ff 25             	cmp    $0x25,%edi
 5bc:	74 22                	je     5e0 <printf+0x67>
 5be:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 5c1:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5c5:	84 db                	test   %bl,%bl
 5c7:	0f 84 74 01 00 00    	je     741 <printf+0x1c8>
    c = fmt[i] & 0xff;
 5cd:	0f be d3             	movsbl %bl,%edx
 5d0:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5d3:	85 ff                	test   %edi,%edi
 5d5:	75 e2                	jne    5b9 <printf+0x40>
      if(c == '%'){
 5d7:	83 f8 25             	cmp    $0x25,%eax
 5da:	75 c4                	jne    5a0 <printf+0x27>
        state = '%';
 5dc:	89 c7                	mov    %eax,%edi
 5de:	eb de                	jmp    5be <printf+0x45>
      if(c == 'd'){
 5e0:	83 f8 64             	cmp    $0x64,%eax
 5e3:	74 59                	je     63e <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5e5:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 5eb:	83 fa 70             	cmp    $0x70,%edx
 5ee:	74 7a                	je     66a <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5f0:	83 f8 73             	cmp    $0x73,%eax
 5f3:	0f 84 9d 00 00 00    	je     696 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f9:	83 f8 63             	cmp    $0x63,%eax
 5fc:	0f 84 f2 00 00 00    	je     6f4 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 602:	83 f8 25             	cmp    $0x25,%eax
 605:	0f 84 15 01 00 00    	je     720 <printf+0x1a7>
 60b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 60f:	83 ec 04             	sub    $0x4,%esp
 612:	6a 01                	push   $0x1
 614:	8d 45 e7             	lea    -0x19(%ebp),%eax
 617:	50                   	push   %eax
 618:	ff 75 08             	pushl  0x8(%ebp)
 61b:	e8 0f fe ff ff       	call   42f <write>
 620:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 623:	83 c4 0c             	add    $0xc,%esp
 626:	6a 01                	push   $0x1
 628:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 62b:	50                   	push   %eax
 62c:	ff 75 08             	pushl  0x8(%ebp)
 62f:	e8 fb fd ff ff       	call   42f <write>
 634:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 637:	bf 00 00 00 00       	mov    $0x0,%edi
 63c:	eb 80                	jmp    5be <printf+0x45>
        printint(fd, *ap, 10, 1);
 63e:	83 ec 0c             	sub    $0xc,%esp
 641:	6a 01                	push   $0x1
 643:	b9 0a 00 00 00       	mov    $0xa,%ecx
 648:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 64b:	8b 17                	mov    (%edi),%edx
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	e8 9a fe ff ff       	call   4ef <printint>
        ap++;
 655:	89 f8                	mov    %edi,%eax
 657:	83 c0 04             	add    $0x4,%eax
 65a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 65d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 660:	bf 00 00 00 00       	mov    $0x0,%edi
 665:	e9 54 ff ff ff       	jmp    5be <printf+0x45>
        printint(fd, *ap, 16, 0);
 66a:	83 ec 0c             	sub    $0xc,%esp
 66d:	6a 00                	push   $0x0
 66f:	b9 10 00 00 00       	mov    $0x10,%ecx
 674:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 677:	8b 17                	mov    (%edi),%edx
 679:	8b 45 08             	mov    0x8(%ebp),%eax
 67c:	e8 6e fe ff ff       	call   4ef <printint>
        ap++;
 681:	89 f8                	mov    %edi,%eax
 683:	83 c0 04             	add    $0x4,%eax
 686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 689:	83 c4 10             	add    $0x10,%esp
      state = 0;
 68c:	bf 00 00 00 00       	mov    $0x0,%edi
 691:	e9 28 ff ff ff       	jmp    5be <printf+0x45>
        s = (char*)*ap;
 696:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 699:	8b 01                	mov    (%ecx),%eax
        ap++;
 69b:	83 c1 04             	add    $0x4,%ecx
 69e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 6a1:	85 c0                	test   %eax,%eax
 6a3:	74 13                	je     6b8 <printf+0x13f>
        s = (char*)*ap;
 6a5:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 6a7:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 6aa:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 6af:	84 c0                	test   %al,%al
 6b1:	75 0f                	jne    6c2 <printf+0x149>
 6b3:	e9 06 ff ff ff       	jmp    5be <printf+0x45>
          s = "(null)";
 6b8:	bb ec 08 00 00       	mov    $0x8ec,%ebx
        while(*s != 0){
 6bd:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 6c2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 6c5:	89 75 d0             	mov    %esi,-0x30(%ebp)
 6c8:	8b 75 08             	mov    0x8(%ebp),%esi
 6cb:	88 45 e3             	mov    %al,-0x1d(%ebp)
 6ce:	83 ec 04             	sub    $0x4,%esp
 6d1:	6a 01                	push   $0x1
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	e8 55 fd ff ff       	call   42f <write>
          s++;
 6da:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 6dd:	0f b6 03             	movzbl (%ebx),%eax
 6e0:	83 c4 10             	add    $0x10,%esp
 6e3:	84 c0                	test   %al,%al
 6e5:	75 e4                	jne    6cb <printf+0x152>
 6e7:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 6ea:	bf 00 00 00 00       	mov    $0x0,%edi
 6ef:	e9 ca fe ff ff       	jmp    5be <printf+0x45>
        putc(fd, *ap);
 6f4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6f7:	8b 07                	mov    (%edi),%eax
 6f9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 6fc:	83 ec 04             	sub    $0x4,%esp
 6ff:	6a 01                	push   $0x1
 701:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 704:	50                   	push   %eax
 705:	ff 75 08             	pushl  0x8(%ebp)
 708:	e8 22 fd ff ff       	call   42f <write>
        ap++;
 70d:	83 c7 04             	add    $0x4,%edi
 710:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 713:	83 c4 10             	add    $0x10,%esp
      state = 0;
 716:	bf 00 00 00 00       	mov    $0x0,%edi
 71b:	e9 9e fe ff ff       	jmp    5be <printf+0x45>
 720:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 723:	83 ec 04             	sub    $0x4,%esp
 726:	6a 01                	push   $0x1
 728:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 72b:	50                   	push   %eax
 72c:	ff 75 08             	pushl  0x8(%ebp)
 72f:	e8 fb fc ff ff       	call   42f <write>
 734:	83 c4 10             	add    $0x10,%esp
      state = 0;
 737:	bf 00 00 00 00       	mov    $0x0,%edi
 73c:	e9 7d fe ff ff       	jmp    5be <printf+0x45>
    }
  }
}
 741:	8d 65 f4             	lea    -0xc(%ebp),%esp
 744:	5b                   	pop    %ebx
 745:	5e                   	pop    %esi
 746:	5f                   	pop    %edi
 747:	5d                   	pop    %ebp
 748:	c3                   	ret    

00000749 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 749:	55                   	push   %ebp
 74a:	89 e5                	mov    %esp,%ebp
 74c:	57                   	push   %edi
 74d:	56                   	push   %esi
 74e:	53                   	push   %ebx
 74f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 752:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 755:	a1 98 0b 00 00       	mov    0xb98,%eax
 75a:	eb 0c                	jmp    768 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75c:	8b 10                	mov    (%eax),%edx
 75e:	39 c2                	cmp    %eax,%edx
 760:	77 04                	ja     766 <free+0x1d>
 762:	39 ca                	cmp    %ecx,%edx
 764:	77 10                	ja     776 <free+0x2d>
{
 766:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	39 c8                	cmp    %ecx,%eax
 76a:	73 f0                	jae    75c <free+0x13>
 76c:	8b 10                	mov    (%eax),%edx
 76e:	39 ca                	cmp    %ecx,%edx
 770:	77 04                	ja     776 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 772:	39 c2                	cmp    %eax,%edx
 774:	77 f0                	ja     766 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 776:	8b 73 fc             	mov    -0x4(%ebx),%esi
 779:	8b 10                	mov    (%eax),%edx
 77b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 77e:	39 fa                	cmp    %edi,%edx
 780:	74 19                	je     79b <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 782:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 785:	8b 50 04             	mov    0x4(%eax),%edx
 788:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 78b:	39 f1                	cmp    %esi,%ecx
 78d:	74 1b                	je     7aa <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 78f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 791:	a3 98 0b 00 00       	mov    %eax,0xb98
}
 796:	5b                   	pop    %ebx
 797:	5e                   	pop    %esi
 798:	5f                   	pop    %edi
 799:	5d                   	pop    %ebp
 79a:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 79b:	03 72 04             	add    0x4(%edx),%esi
 79e:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a1:	8b 10                	mov    (%eax),%edx
 7a3:	8b 12                	mov    (%edx),%edx
 7a5:	89 53 f8             	mov    %edx,-0x8(%ebx)
 7a8:	eb db                	jmp    785 <free+0x3c>
    p->s.size += bp->s.size;
 7aa:	03 53 fc             	add    -0x4(%ebx),%edx
 7ad:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b0:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7b3:	89 10                	mov    %edx,(%eax)
 7b5:	eb da                	jmp    791 <free+0x48>

000007b7 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b7:	55                   	push   %ebp
 7b8:	89 e5                	mov    %esp,%ebp
 7ba:	57                   	push   %edi
 7bb:	56                   	push   %esi
 7bc:	53                   	push   %ebx
 7bd:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c0:	8b 45 08             	mov    0x8(%ebp),%eax
 7c3:	8d 58 07             	lea    0x7(%eax),%ebx
 7c6:	c1 eb 03             	shr    $0x3,%ebx
 7c9:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 7cc:	8b 15 98 0b 00 00    	mov    0xb98,%edx
 7d2:	85 d2                	test   %edx,%edx
 7d4:	74 20                	je     7f6 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d6:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7d8:	8b 48 04             	mov    0x4(%eax),%ecx
 7db:	39 cb                	cmp    %ecx,%ebx
 7dd:	76 3c                	jbe    81b <malloc+0x64>
 7df:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 7e5:	be 00 10 00 00       	mov    $0x1000,%esi
 7ea:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 7ed:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 7f4:	eb 70                	jmp    866 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 7f6:	c7 05 98 0b 00 00 9c 	movl   $0xb9c,0xb98
 7fd:	0b 00 00 
 800:	c7 05 9c 0b 00 00 9c 	movl   $0xb9c,0xb9c
 807:	0b 00 00 
    base.s.size = 0;
 80a:	c7 05 a0 0b 00 00 00 	movl   $0x0,0xba0
 811:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 814:	ba 9c 0b 00 00       	mov    $0xb9c,%edx
 819:	eb bb                	jmp    7d6 <malloc+0x1f>
      if(p->s.size == nunits)
 81b:	39 cb                	cmp    %ecx,%ebx
 81d:	74 1c                	je     83b <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 81f:	29 d9                	sub    %ebx,%ecx
 821:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 824:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 827:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 82a:	89 15 98 0b 00 00    	mov    %edx,0xb98
      return (void*)(p + 1);
 830:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 833:	8d 65 f4             	lea    -0xc(%ebp),%esp
 836:	5b                   	pop    %ebx
 837:	5e                   	pop    %esi
 838:	5f                   	pop    %edi
 839:	5d                   	pop    %ebp
 83a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 83b:	8b 08                	mov    (%eax),%ecx
 83d:	89 0a                	mov    %ecx,(%edx)
 83f:	eb e9                	jmp    82a <malloc+0x73>
  hp->s.size = nu;
 841:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 844:	83 ec 0c             	sub    $0xc,%esp
 847:	83 c0 08             	add    $0x8,%eax
 84a:	50                   	push   %eax
 84b:	e8 f9 fe ff ff       	call   749 <free>
  return freep;
 850:	8b 15 98 0b 00 00    	mov    0xb98,%edx
      if((p = morecore(nunits)) == 0)
 856:	83 c4 10             	add    $0x10,%esp
 859:	85 d2                	test   %edx,%edx
 85b:	74 2b                	je     888 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85d:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 85f:	8b 48 04             	mov    0x4(%eax),%ecx
 862:	39 d9                	cmp    %ebx,%ecx
 864:	73 b5                	jae    81b <malloc+0x64>
 866:	89 c2                	mov    %eax,%edx
    if(p == freep)
 868:	39 05 98 0b 00 00    	cmp    %eax,0xb98
 86e:	75 ed                	jne    85d <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 870:	83 ec 0c             	sub    $0xc,%esp
 873:	57                   	push   %edi
 874:	e8 1e fc ff ff       	call   497 <sbrk>
  if(p == (char*)-1)
 879:	83 c4 10             	add    $0x10,%esp
 87c:	83 f8 ff             	cmp    $0xffffffff,%eax
 87f:	75 c0                	jne    841 <malloc+0x8a>
        return 0;
 881:	b8 00 00 00 00       	mov    $0x0,%eax
 886:	eb ab                	jmp    833 <malloc+0x7c>
 888:	b8 00 00 00 00       	mov    $0x0,%eax
 88d:	eb a4                	jmp    833 <malloc+0x7c>
