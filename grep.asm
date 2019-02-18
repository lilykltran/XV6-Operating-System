
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
   f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  12:	83 ec 08             	sub    $0x8,%esp
  15:	53                   	push   %ebx
  16:	57                   	push   %edi
  17:	e8 2c 00 00 00       	call   48 <matchhere>
  1c:	83 c4 10             	add    $0x10,%esp
  1f:	85 c0                	test   %eax,%eax
  21:	75 18                	jne    3b <matchstar+0x3b>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  23:	0f b6 13             	movzbl (%ebx),%edx
  26:	84 d2                	test   %dl,%dl
  28:	74 16                	je     40 <matchstar+0x40>
  2a:	83 c3 01             	add    $0x1,%ebx
  2d:	83 fe 2e             	cmp    $0x2e,%esi
  30:	74 e0                	je     12 <matchstar+0x12>
  32:	0f be d2             	movsbl %dl,%edx
  35:	39 f2                	cmp    %esi,%edx
  37:	74 d9                	je     12 <matchstar+0x12>
  39:	eb 05                	jmp    40 <matchstar+0x40>
      return 1;
  3b:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
  40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  43:	5b                   	pop    %ebx
  44:	5e                   	pop    %esi
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <matchhere>:
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	53                   	push   %ebx
  4c:	83 ec 04             	sub    $0x4,%esp
  4f:	8b 55 08             	mov    0x8(%ebp),%edx
  if(re[0] == '\0')
  52:	0f b6 0a             	movzbl (%edx),%ecx
    return 1;
  55:	b8 01 00 00 00       	mov    $0x1,%eax
  if(re[0] == '\0')
  5a:	84 c9                	test   %cl,%cl
  5c:	74 29                	je     87 <matchhere+0x3f>
  if(re[1] == '*')
  5e:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  62:	3c 2a                	cmp    $0x2a,%al
  64:	74 26                	je     8c <matchhere+0x44>
  if(re[0] == '$' && re[1] == '\0')
  66:	84 c0                	test   %al,%al
  68:	75 05                	jne    6f <matchhere+0x27>
  6a:	80 f9 24             	cmp    $0x24,%cl
  6d:	74 35                	je     a4 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  72:	0f b6 18             	movzbl (%eax),%ebx
  return 0;
  75:	b8 00 00 00 00       	mov    $0x0,%eax
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  7a:	84 db                	test   %bl,%bl
  7c:	74 09                	je     87 <matchhere+0x3f>
  7e:	38 d9                	cmp    %bl,%cl
  80:	74 30                	je     b2 <matchhere+0x6a>
  82:	80 f9 2e             	cmp    $0x2e,%cl
  85:	74 2b                	je     b2 <matchhere+0x6a>
}
  87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8a:	c9                   	leave  
  8b:	c3                   	ret    
    return matchstar(re[0], re+2, text);
  8c:	83 ec 04             	sub    $0x4,%esp
  8f:	ff 75 0c             	pushl  0xc(%ebp)
  92:	83 c2 02             	add    $0x2,%edx
  95:	52                   	push   %edx
  96:	0f be c9             	movsbl %cl,%ecx
  99:	51                   	push   %ecx
  9a:	e8 61 ff ff ff       	call   0 <matchstar>
  9f:	83 c4 10             	add    $0x10,%esp
  a2:	eb e3                	jmp    87 <matchhere+0x3f>
    return *text == '\0';
  a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  a7:	80 38 00             	cmpb   $0x0,(%eax)
  aa:	0f 94 c0             	sete   %al
  ad:	0f b6 c0             	movzbl %al,%eax
  b0:	eb d5                	jmp    87 <matchhere+0x3f>
    return matchhere(re+1, text+1);
  b2:	83 ec 08             	sub    $0x8,%esp
  b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  b8:	83 c0 01             	add    $0x1,%eax
  bb:	50                   	push   %eax
  bc:	83 c2 01             	add    $0x1,%edx
  bf:	52                   	push   %edx
  c0:	e8 83 ff ff ff       	call   48 <matchhere>
  c5:	83 c4 10             	add    $0x10,%esp
  c8:	eb bd                	jmp    87 <matchhere+0x3f>

000000ca <match>:
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  cd:	56                   	push   %esi
  ce:	53                   	push   %ebx
  cf:	8b 75 08             	mov    0x8(%ebp),%esi
  d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
  d5:	80 3e 5e             	cmpb   $0x5e,(%esi)
  d8:	74 1c                	je     f6 <match+0x2c>
    if(matchhere(re, text))
  da:	83 ec 08             	sub    $0x8,%esp
  dd:	53                   	push   %ebx
  de:	56                   	push   %esi
  df:	e8 64 ff ff ff       	call   48 <matchhere>
  e4:	83 c4 10             	add    $0x10,%esp
  e7:	85 c0                	test   %eax,%eax
  e9:	75 1d                	jne    108 <match+0x3e>
  }while(*text++ != '\0');
  eb:	83 c3 01             	add    $0x1,%ebx
  ee:	80 7b ff 00          	cmpb   $0x0,-0x1(%ebx)
  f2:	75 e6                	jne    da <match+0x10>
  f4:	eb 17                	jmp    10d <match+0x43>
    return matchhere(re+1, text);
  f6:	83 ec 08             	sub    $0x8,%esp
  f9:	53                   	push   %ebx
  fa:	83 c6 01             	add    $0x1,%esi
  fd:	56                   	push   %esi
  fe:	e8 45 ff ff ff       	call   48 <matchhere>
 103:	83 c4 10             	add    $0x10,%esp
 106:	eb 05                	jmp    10d <match+0x43>
      return 1;
 108:	b8 01 00 00 00       	mov    $0x1,%eax
}
 10d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 110:	5b                   	pop    %ebx
 111:	5e                   	pop    %esi
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    

00000114 <grep>:
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	56                   	push   %esi
 119:	53                   	push   %ebx
 11a:	83 ec 1c             	sub    $0x1c,%esp
  m = 0;
 11d:	bf 00 00 00 00       	mov    $0x0,%edi
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 122:	eb 53                	jmp    177 <grep+0x63>
      p = q+1;
 124:	8d 73 01             	lea    0x1(%ebx),%esi
    while((q = strchr(p, '\n')) != 0){
 127:	83 ec 08             	sub    $0x8,%esp
 12a:	6a 0a                	push   $0xa
 12c:	56                   	push   %esi
 12d:	e8 e6 01 00 00       	call   318 <strchr>
 132:	89 c3                	mov    %eax,%ebx
 134:	83 c4 10             	add    $0x10,%esp
 137:	85 c0                	test   %eax,%eax
 139:	74 2d                	je     168 <grep+0x54>
      *q = 0;
 13b:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 13e:	83 ec 08             	sub    $0x8,%esp
 141:	56                   	push   %esi
 142:	57                   	push   %edi
 143:	e8 82 ff ff ff       	call   ca <match>
 148:	83 c4 10             	add    $0x10,%esp
 14b:	85 c0                	test   %eax,%eax
 14d:	74 d5                	je     124 <grep+0x10>
        *q = '\n';
 14f:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 152:	83 ec 04             	sub    $0x4,%esp
 155:	8d 43 01             	lea    0x1(%ebx),%eax
 158:	29 f0                	sub    %esi,%eax
 15a:	50                   	push   %eax
 15b:	56                   	push   %esi
 15c:	6a 01                	push   $0x1
 15e:	e8 a8 03 00 00       	call   50b <write>
 163:	83 c4 10             	add    $0x10,%esp
 166:	eb bc                	jmp    124 <grep+0x10>
 168:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    if(p == buf)
 16b:	81 fe 20 0d 00 00    	cmp    $0xd20,%esi
 171:	74 5b                	je     1ce <grep+0xba>
    if(m > 0){
 173:	85 ff                	test   %edi,%edi
 175:	7f 3a                	jg     1b1 <grep+0x9d>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 177:	83 ec 04             	sub    $0x4,%esp
 17a:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 17f:	29 f8                	sub    %edi,%eax
 181:	50                   	push   %eax
 182:	8d 87 20 0d 00 00    	lea    0xd20(%edi),%eax
 188:	50                   	push   %eax
 189:	ff 75 0c             	pushl  0xc(%ebp)
 18c:	e8 72 03 00 00       	call   503 <read>
 191:	83 c4 10             	add    $0x10,%esp
 194:	85 c0                	test   %eax,%eax
 196:	7e 3d                	jle    1d5 <grep+0xc1>
    m += n;
 198:	01 c7                	add    %eax,%edi
    buf[m] = '\0';
 19a:	c6 87 20 0d 00 00 00 	movb   $0x0,0xd20(%edi)
    p = buf;
 1a1:	be 20 0d 00 00       	mov    $0xd20,%esi
 1a6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 1a9:	8b 7d 08             	mov    0x8(%ebp),%edi
    while((q = strchr(p, '\n')) != 0){
 1ac:	e9 76 ff ff ff       	jmp    127 <grep+0x13>
      m -= p - buf;
 1b1:	89 f0                	mov    %esi,%eax
 1b3:	2d 20 0d 00 00       	sub    $0xd20,%eax
 1b8:	29 c7                	sub    %eax,%edi
      memmove(buf, p, m);
 1ba:	83 ec 04             	sub    $0x4,%esp
 1bd:	57                   	push   %edi
 1be:	56                   	push   %esi
 1bf:	68 20 0d 00 00       	push   $0xd20
 1c4:	e8 f1 02 00 00       	call   4ba <memmove>
 1c9:	83 c4 10             	add    $0x10,%esp
 1cc:	eb a9                	jmp    177 <grep+0x63>
      m = 0;
 1ce:	bf 00 00 00 00       	mov    $0x0,%edi
 1d3:	eb a2                	jmp    177 <grep+0x63>
}
 1d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1d8:	5b                   	pop    %ebx
 1d9:	5e                   	pop    %esi
 1da:	5f                   	pop    %edi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    

000001dd <main>:
{
 1dd:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1e1:	83 e4 f0             	and    $0xfffffff0,%esp
 1e4:	ff 71 fc             	pushl  -0x4(%ecx)
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	57                   	push   %edi
 1eb:	56                   	push   %esi
 1ec:	53                   	push   %ebx
 1ed:	51                   	push   %ecx
 1ee:	83 ec 18             	sub    $0x18,%esp
 1f1:	8b 01                	mov    (%ecx),%eax
 1f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 1f6:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc <= 1){
 1f9:	83 f8 01             	cmp    $0x1,%eax
 1fc:	7e 53                	jle    251 <main+0x74>
  pattern = argv[1];
 1fe:	8b 43 04             	mov    0x4(%ebx),%eax
 201:	89 45 e0             	mov    %eax,-0x20(%ebp)
 204:	83 c3 08             	add    $0x8,%ebx
  for(i = 2; i < argc; i++){
 207:	bf 02 00 00 00       	mov    $0x2,%edi
  if(argc <= 2){
 20c:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
 210:	7e 53                	jle    265 <main+0x88>
    if((fd = open(argv[i], 0)) < 0){
 212:	89 5d dc             	mov    %ebx,-0x24(%ebp)
 215:	83 ec 08             	sub    $0x8,%esp
 218:	6a 00                	push   $0x0
 21a:	ff 33                	pushl  (%ebx)
 21c:	e8 0a 03 00 00       	call   52b <open>
 221:	89 c6                	mov    %eax,%esi
 223:	83 c4 10             	add    $0x10,%esp
 226:	85 c0                	test   %eax,%eax
 228:	78 4b                	js     275 <main+0x98>
    grep(pattern, fd);
 22a:	83 ec 08             	sub    $0x8,%esp
 22d:	50                   	push   %eax
 22e:	ff 75 e0             	pushl  -0x20(%ebp)
 231:	e8 de fe ff ff       	call   114 <grep>
    close(fd);
 236:	89 34 24             	mov    %esi,(%esp)
 239:	e8 d5 02 00 00       	call   513 <close>
  for(i = 2; i < argc; i++){
 23e:	83 c7 01             	add    $0x1,%edi
 241:	83 c3 04             	add    $0x4,%ebx
 244:	83 c4 10             	add    $0x10,%esp
 247:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
 24a:	75 c6                	jne    212 <main+0x35>
  exit();
 24c:	e8 9a 02 00 00       	call   4eb <exit>
    printf(2, "usage: grep pattern [file ...]\n");
 251:	83 ec 08             	sub    $0x8,%esp
 254:	68 6c 09 00 00       	push   $0x96c
 259:	6a 02                	push   $0x2
 25b:	e8 f5 03 00 00       	call   655 <printf>
    exit();
 260:	e8 86 02 00 00       	call   4eb <exit>
    grep(pattern, 0);
 265:	83 ec 08             	sub    $0x8,%esp
 268:	6a 00                	push   $0x0
 26a:	50                   	push   %eax
 26b:	e8 a4 fe ff ff       	call   114 <grep>
    exit();
 270:	e8 76 02 00 00       	call   4eb <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
 275:	83 ec 04             	sub    $0x4,%esp
 278:	8b 45 dc             	mov    -0x24(%ebp),%eax
 27b:	ff 30                	pushl  (%eax)
 27d:	68 8c 09 00 00       	push   $0x98c
 282:	6a 01                	push   $0x1
 284:	e8 cc 03 00 00       	call   655 <printf>
      exit();
 289:	e8 5d 02 00 00       	call   4eb <exit>

0000028e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 28e:	55                   	push   %ebp
 28f:	89 e5                	mov    %esp,%ebp
 291:	53                   	push   %ebx
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 298:	89 c2                	mov    %eax,%edx
 29a:	83 c1 01             	add    $0x1,%ecx
 29d:	83 c2 01             	add    $0x1,%edx
 2a0:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 2a4:	88 5a ff             	mov    %bl,-0x1(%edx)
 2a7:	84 db                	test   %bl,%bl
 2a9:	75 ef                	jne    29a <strcpy+0xc>
    ;
  return os;
}
 2ab:	5b                   	pop    %ebx
 2ac:	5d                   	pop    %ebp
 2ad:	c3                   	ret    

000002ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ae:	55                   	push   %ebp
 2af:	89 e5                	mov    %esp,%ebp
 2b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2b7:	0f b6 01             	movzbl (%ecx),%eax
 2ba:	84 c0                	test   %al,%al
 2bc:	74 15                	je     2d3 <strcmp+0x25>
 2be:	3a 02                	cmp    (%edx),%al
 2c0:	75 11                	jne    2d3 <strcmp+0x25>
    p++, q++;
 2c2:	83 c1 01             	add    $0x1,%ecx
 2c5:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2c8:	0f b6 01             	movzbl (%ecx),%eax
 2cb:	84 c0                	test   %al,%al
 2cd:	74 04                	je     2d3 <strcmp+0x25>
 2cf:	3a 02                	cmp    (%edx),%al
 2d1:	74 ef                	je     2c2 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 2d3:	0f b6 c0             	movzbl %al,%eax
 2d6:	0f b6 12             	movzbl (%edx),%edx
 2d9:	29 d0                	sub    %edx,%eax
}
 2db:	5d                   	pop    %ebp
 2dc:	c3                   	ret    

000002dd <strlen>:

uint
strlen(char *s)
{
 2dd:	55                   	push   %ebp
 2de:	89 e5                	mov    %esp,%ebp
 2e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2e3:	80 39 00             	cmpb   $0x0,(%ecx)
 2e6:	74 12                	je     2fa <strlen+0x1d>
 2e8:	ba 00 00 00 00       	mov    $0x0,%edx
 2ed:	83 c2 01             	add    $0x1,%edx
 2f0:	89 d0                	mov    %edx,%eax
 2f2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2f6:	75 f5                	jne    2ed <strlen+0x10>
    ;
  return n;
}
 2f8:	5d                   	pop    %ebp
 2f9:	c3                   	ret    
  for(n = 0; s[n]; n++)
 2fa:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 2ff:	eb f7                	jmp    2f8 <strlen+0x1b>

00000301 <memset>:

void*
memset(void *dst, int c, uint n)
{
 301:	55                   	push   %ebp
 302:	89 e5                	mov    %esp,%ebp
 304:	57                   	push   %edi
 305:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 308:	89 d7                	mov    %edx,%edi
 30a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 30d:	8b 45 0c             	mov    0xc(%ebp),%eax
 310:	fc                   	cld    
 311:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 313:	89 d0                	mov    %edx,%eax
 315:	5f                   	pop    %edi
 316:	5d                   	pop    %ebp
 317:	c3                   	ret    

00000318 <strchr>:

char*
strchr(const char *s, char c)
{
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	53                   	push   %ebx
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 322:	0f b6 10             	movzbl (%eax),%edx
 325:	84 d2                	test   %dl,%dl
 327:	74 1e                	je     347 <strchr+0x2f>
 329:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 32b:	38 d3                	cmp    %dl,%bl
 32d:	74 15                	je     344 <strchr+0x2c>
  for(; *s; s++)
 32f:	83 c0 01             	add    $0x1,%eax
 332:	0f b6 10             	movzbl (%eax),%edx
 335:	84 d2                	test   %dl,%dl
 337:	74 06                	je     33f <strchr+0x27>
    if(*s == c)
 339:	38 ca                	cmp    %cl,%dl
 33b:	75 f2                	jne    32f <strchr+0x17>
 33d:	eb 05                	jmp    344 <strchr+0x2c>
      return (char*)s;
  return 0;
 33f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 344:	5b                   	pop    %ebx
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    
  return 0;
 347:	b8 00 00 00 00       	mov    $0x0,%eax
 34c:	eb f6                	jmp    344 <strchr+0x2c>

0000034e <gets>:

char*
gets(char *buf, int max)
{
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	57                   	push   %edi
 352:	56                   	push   %esi
 353:	53                   	push   %ebx
 354:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 357:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 35c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 35f:	8d 5e 01             	lea    0x1(%esi),%ebx
 362:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 365:	7d 2b                	jge    392 <gets+0x44>
    cc = read(0, &c, 1);
 367:	83 ec 04             	sub    $0x4,%esp
 36a:	6a 01                	push   $0x1
 36c:	57                   	push   %edi
 36d:	6a 00                	push   $0x0
 36f:	e8 8f 01 00 00       	call   503 <read>
    if(cc < 1)
 374:	83 c4 10             	add    $0x10,%esp
 377:	85 c0                	test   %eax,%eax
 379:	7e 17                	jle    392 <gets+0x44>
      break;
    buf[i++] = c;
 37b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 37f:	8b 55 08             	mov    0x8(%ebp),%edx
 382:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 386:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 388:	3c 0a                	cmp    $0xa,%al
 38a:	74 04                	je     390 <gets+0x42>
 38c:	3c 0d                	cmp    $0xd,%al
 38e:	75 cf                	jne    35f <gets+0x11>
  for(i=0; i+1 < max; ){
 390:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 392:	8b 45 08             	mov    0x8(%ebp),%eax
 395:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 399:	8d 65 f4             	lea    -0xc(%ebp),%esp
 39c:	5b                   	pop    %ebx
 39d:	5e                   	pop    %esi
 39e:	5f                   	pop    %edi
 39f:	5d                   	pop    %ebp
 3a0:	c3                   	ret    

000003a1 <stat>:

int
stat(char *n, struct stat *st)
{
 3a1:	55                   	push   %ebp
 3a2:	89 e5                	mov    %esp,%ebp
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a6:	83 ec 08             	sub    $0x8,%esp
 3a9:	6a 00                	push   $0x0
 3ab:	ff 75 08             	pushl  0x8(%ebp)
 3ae:	e8 78 01 00 00       	call   52b <open>
  if(fd < 0)
 3b3:	83 c4 10             	add    $0x10,%esp
 3b6:	85 c0                	test   %eax,%eax
 3b8:	78 24                	js     3de <stat+0x3d>
 3ba:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3bc:	83 ec 08             	sub    $0x8,%esp
 3bf:	ff 75 0c             	pushl  0xc(%ebp)
 3c2:	50                   	push   %eax
 3c3:	e8 7b 01 00 00       	call   543 <fstat>
 3c8:	89 c6                	mov    %eax,%esi
  close(fd);
 3ca:	89 1c 24             	mov    %ebx,(%esp)
 3cd:	e8 41 01 00 00       	call   513 <close>
  return r;
 3d2:	83 c4 10             	add    $0x10,%esp
}
 3d5:	89 f0                	mov    %esi,%eax
 3d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3da:	5b                   	pop    %ebx
 3db:	5e                   	pop    %esi
 3dc:	5d                   	pop    %ebp
 3dd:	c3                   	ret    
    return -1;
 3de:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3e3:	eb f0                	jmp    3d5 <stat+0x34>

000003e5 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 3e5:	55                   	push   %ebp
 3e6:	89 e5                	mov    %esp,%ebp
 3e8:	56                   	push   %esi
 3e9:	53                   	push   %ebx
 3ea:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 3ed:	0f b6 0a             	movzbl (%edx),%ecx
 3f0:	80 f9 20             	cmp    $0x20,%cl
 3f3:	75 0b                	jne    400 <atoi+0x1b>
 3f5:	83 c2 01             	add    $0x1,%edx
 3f8:	0f b6 0a             	movzbl (%edx),%ecx
 3fb:	80 f9 20             	cmp    $0x20,%cl
 3fe:	74 f5                	je     3f5 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 400:	80 f9 2d             	cmp    $0x2d,%cl
 403:	74 3b                	je     440 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 405:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 408:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 40d:	f6 c1 fd             	test   $0xfd,%cl
 410:	74 33                	je     445 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 412:	0f b6 0a             	movzbl (%edx),%ecx
 415:	8d 41 d0             	lea    -0x30(%ecx),%eax
 418:	3c 09                	cmp    $0x9,%al
 41a:	77 2e                	ja     44a <atoi+0x65>
 41c:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 421:	83 c2 01             	add    $0x1,%edx
 424:	8d 04 80             	lea    (%eax,%eax,4),%eax
 427:	0f be c9             	movsbl %cl,%ecx
 42a:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 42e:	0f b6 0a             	movzbl (%edx),%ecx
 431:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 434:	80 fb 09             	cmp    $0x9,%bl
 437:	76 e8                	jbe    421 <atoi+0x3c>
  return sign*n;
 439:	0f af c6             	imul   %esi,%eax
}
 43c:	5b                   	pop    %ebx
 43d:	5e                   	pop    %esi
 43e:	5d                   	pop    %ebp
 43f:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 440:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 445:	83 c2 01             	add    $0x1,%edx
 448:	eb c8                	jmp    412 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 44a:	b8 00 00 00 00       	mov    $0x0,%eax
 44f:	eb e8                	jmp    439 <atoi+0x54>

00000451 <atoo>:

int
atoo(const char *s)
{
 451:	55                   	push   %ebp
 452:	89 e5                	mov    %esp,%ebp
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 459:	0f b6 0a             	movzbl (%edx),%ecx
 45c:	80 f9 20             	cmp    $0x20,%cl
 45f:	75 0b                	jne    46c <atoo+0x1b>
 461:	83 c2 01             	add    $0x1,%edx
 464:	0f b6 0a             	movzbl (%edx),%ecx
 467:	80 f9 20             	cmp    $0x20,%cl
 46a:	74 f5                	je     461 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 46c:	80 f9 2d             	cmp    $0x2d,%cl
 46f:	74 38                	je     4a9 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 471:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 474:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 479:	f6 c1 fd             	test   $0xfd,%cl
 47c:	74 30                	je     4ae <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 47e:	0f b6 0a             	movzbl (%edx),%ecx
 481:	8d 41 d0             	lea    -0x30(%ecx),%eax
 484:	3c 07                	cmp    $0x7,%al
 486:	77 2b                	ja     4b3 <atoo+0x62>
 488:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 48d:	83 c2 01             	add    $0x1,%edx
 490:	0f be c9             	movsbl %cl,%ecx
 493:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 497:	0f b6 0a             	movzbl (%edx),%ecx
 49a:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 49d:	80 fb 07             	cmp    $0x7,%bl
 4a0:	76 eb                	jbe    48d <atoo+0x3c>
  return sign*n;
 4a2:	0f af c6             	imul   %esi,%eax
}
 4a5:	5b                   	pop    %ebx
 4a6:	5e                   	pop    %esi
 4a7:	5d                   	pop    %ebp
 4a8:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 4a9:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 4ae:	83 c2 01             	add    $0x1,%edx
 4b1:	eb cb                	jmp    47e <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 4b3:	b8 00 00 00 00       	mov    $0x0,%eax
 4b8:	eb e8                	jmp    4a2 <atoo+0x51>

000004ba <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 4ba:	55                   	push   %ebp
 4bb:	89 e5                	mov    %esp,%ebp
 4bd:	56                   	push   %esi
 4be:	53                   	push   %ebx
 4bf:	8b 45 08             	mov    0x8(%ebp),%eax
 4c2:	8b 75 0c             	mov    0xc(%ebp),%esi
 4c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4c8:	85 db                	test   %ebx,%ebx
 4ca:	7e 13                	jle    4df <memmove+0x25>
 4cc:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 4d1:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4d5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4d8:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 4db:	39 d3                	cmp    %edx,%ebx
 4dd:	75 f2                	jne    4d1 <memmove+0x17>
  return vdst;
}
 4df:	5b                   	pop    %ebx
 4e0:	5e                   	pop    %esi
 4e1:	5d                   	pop    %ebp
 4e2:	c3                   	ret    

000004e3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4e3:	b8 01 00 00 00       	mov    $0x1,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <exit>:
SYSCALL(exit)
 4eb:	b8 02 00 00 00       	mov    $0x2,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <wait>:
SYSCALL(wait)
 4f3:	b8 03 00 00 00       	mov    $0x3,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <pipe>:
SYSCALL(pipe)
 4fb:	b8 04 00 00 00       	mov    $0x4,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <read>:
SYSCALL(read)
 503:	b8 05 00 00 00       	mov    $0x5,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <write>:
SYSCALL(write)
 50b:	b8 10 00 00 00       	mov    $0x10,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <close>:
SYSCALL(close)
 513:	b8 15 00 00 00       	mov    $0x15,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <kill>:
SYSCALL(kill)
 51b:	b8 06 00 00 00       	mov    $0x6,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <exec>:
SYSCALL(exec)
 523:	b8 07 00 00 00       	mov    $0x7,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <open>:
SYSCALL(open)
 52b:	b8 0f 00 00 00       	mov    $0xf,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <mknod>:
SYSCALL(mknod)
 533:	b8 11 00 00 00       	mov    $0x11,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <unlink>:
SYSCALL(unlink)
 53b:	b8 12 00 00 00       	mov    $0x12,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <fstat>:
SYSCALL(fstat)
 543:	b8 08 00 00 00       	mov    $0x8,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <link>:
SYSCALL(link)
 54b:	b8 13 00 00 00       	mov    $0x13,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <mkdir>:
SYSCALL(mkdir)
 553:	b8 14 00 00 00       	mov    $0x14,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <chdir>:
SYSCALL(chdir)
 55b:	b8 09 00 00 00       	mov    $0x9,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <dup>:
SYSCALL(dup)
 563:	b8 0a 00 00 00       	mov    $0xa,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <getpid>:
SYSCALL(getpid)
 56b:	b8 0b 00 00 00       	mov    $0xb,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <sbrk>:
SYSCALL(sbrk)
 573:	b8 0c 00 00 00       	mov    $0xc,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <sleep>:
SYSCALL(sleep)
 57b:	b8 0d 00 00 00       	mov    $0xd,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <uptime>:
SYSCALL(uptime)
 583:	b8 0e 00 00 00       	mov    $0xe,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <halt>:
SYSCALL(halt)
 58b:	b8 16 00 00 00       	mov    $0x16,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <date>:
//proj1
SYSCALL(date)
 593:	b8 17 00 00 00       	mov    $0x17,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <getuid>:
//proj2
SYSCALL(getuid)
 59b:	b8 18 00 00 00       	mov    $0x18,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <getgid>:
SYSCALL(getgid)
 5a3:	b8 19 00 00 00       	mov    $0x19,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <getppid>:
SYSCALL(getppid)
 5ab:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <setuid>:
SYSCALL(setuid)
 5b3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <setgid>:
SYSCALL(setgid)
 5bb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <getprocs>:
SYSCALL(getprocs)
 5c3:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5cb:	55                   	push   %ebp
 5cc:	89 e5                	mov    %esp,%ebp
 5ce:	57                   	push   %edi
 5cf:	56                   	push   %esi
 5d0:	53                   	push   %ebx
 5d1:	83 ec 3c             	sub    $0x3c,%esp
 5d4:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 5da:	74 14                	je     5f0 <printint+0x25>
 5dc:	85 d2                	test   %edx,%edx
 5de:	79 10                	jns    5f0 <printint+0x25>
    neg = 1;
    x = -xx;
 5e0:	f7 da                	neg    %edx
    neg = 1;
 5e2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5e9:	bf 00 00 00 00       	mov    $0x0,%edi
 5ee:	eb 0b                	jmp    5fb <printint+0x30>
  neg = 0;
 5f0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5f7:	eb f0                	jmp    5e9 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 5f9:	89 df                	mov    %ebx,%edi
 5fb:	8d 5f 01             	lea    0x1(%edi),%ebx
 5fe:	89 d0                	mov    %edx,%eax
 600:	ba 00 00 00 00       	mov    $0x0,%edx
 605:	f7 f1                	div    %ecx
 607:	0f b6 92 ac 09 00 00 	movzbl 0x9ac(%edx),%edx
 60e:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 612:	89 c2                	mov    %eax,%edx
 614:	85 c0                	test   %eax,%eax
 616:	75 e1                	jne    5f9 <printint+0x2e>
  if(neg)
 618:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 61c:	74 08                	je     626 <printint+0x5b>
    buf[i++] = '-';
 61e:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 623:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 626:	83 eb 01             	sub    $0x1,%ebx
 629:	78 22                	js     64d <printint+0x82>
  write(fd, &c, 1);
 62b:	8d 7d d7             	lea    -0x29(%ebp),%edi
 62e:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 633:	88 45 d7             	mov    %al,-0x29(%ebp)
 636:	83 ec 04             	sub    $0x4,%esp
 639:	6a 01                	push   $0x1
 63b:	57                   	push   %edi
 63c:	56                   	push   %esi
 63d:	e8 c9 fe ff ff       	call   50b <write>
  while(--i >= 0)
 642:	83 eb 01             	sub    $0x1,%ebx
 645:	83 c4 10             	add    $0x10,%esp
 648:	83 fb ff             	cmp    $0xffffffff,%ebx
 64b:	75 e1                	jne    62e <printint+0x63>
    putc(fd, buf[i]);
}
 64d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 650:	5b                   	pop    %ebx
 651:	5e                   	pop    %esi
 652:	5f                   	pop    %edi
 653:	5d                   	pop    %ebp
 654:	c3                   	ret    

00000655 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 655:	55                   	push   %ebp
 656:	89 e5                	mov    %esp,%ebp
 658:	57                   	push   %edi
 659:	56                   	push   %esi
 65a:	53                   	push   %ebx
 65b:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 65e:	8b 75 0c             	mov    0xc(%ebp),%esi
 661:	0f b6 1e             	movzbl (%esi),%ebx
 664:	84 db                	test   %bl,%bl
 666:	0f 84 b1 01 00 00    	je     81d <printf+0x1c8>
 66c:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 66f:	8d 45 10             	lea    0x10(%ebp),%eax
 672:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 675:	bf 00 00 00 00       	mov    $0x0,%edi
 67a:	eb 2d                	jmp    6a9 <printf+0x54>
 67c:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 67f:	83 ec 04             	sub    $0x4,%esp
 682:	6a 01                	push   $0x1
 684:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 687:	50                   	push   %eax
 688:	ff 75 08             	pushl  0x8(%ebp)
 68b:	e8 7b fe ff ff       	call   50b <write>
 690:	83 c4 10             	add    $0x10,%esp
 693:	eb 05                	jmp    69a <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 695:	83 ff 25             	cmp    $0x25,%edi
 698:	74 22                	je     6bc <printf+0x67>
 69a:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 69d:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 6a1:	84 db                	test   %bl,%bl
 6a3:	0f 84 74 01 00 00    	je     81d <printf+0x1c8>
    c = fmt[i] & 0xff;
 6a9:	0f be d3             	movsbl %bl,%edx
 6ac:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6af:	85 ff                	test   %edi,%edi
 6b1:	75 e2                	jne    695 <printf+0x40>
      if(c == '%'){
 6b3:	83 f8 25             	cmp    $0x25,%eax
 6b6:	75 c4                	jne    67c <printf+0x27>
        state = '%';
 6b8:	89 c7                	mov    %eax,%edi
 6ba:	eb de                	jmp    69a <printf+0x45>
      if(c == 'd'){
 6bc:	83 f8 64             	cmp    $0x64,%eax
 6bf:	74 59                	je     71a <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6c1:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 6c7:	83 fa 70             	cmp    $0x70,%edx
 6ca:	74 7a                	je     746 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6cc:	83 f8 73             	cmp    $0x73,%eax
 6cf:	0f 84 9d 00 00 00    	je     772 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d5:	83 f8 63             	cmp    $0x63,%eax
 6d8:	0f 84 f2 00 00 00    	je     7d0 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6de:	83 f8 25             	cmp    $0x25,%eax
 6e1:	0f 84 15 01 00 00    	je     7fc <printf+0x1a7>
 6e7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 6eb:	83 ec 04             	sub    $0x4,%esp
 6ee:	6a 01                	push   $0x1
 6f0:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6f3:	50                   	push   %eax
 6f4:	ff 75 08             	pushl  0x8(%ebp)
 6f7:	e8 0f fe ff ff       	call   50b <write>
 6fc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6ff:	83 c4 0c             	add    $0xc,%esp
 702:	6a 01                	push   $0x1
 704:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 707:	50                   	push   %eax
 708:	ff 75 08             	pushl  0x8(%ebp)
 70b:	e8 fb fd ff ff       	call   50b <write>
 710:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 713:	bf 00 00 00 00       	mov    $0x0,%edi
 718:	eb 80                	jmp    69a <printf+0x45>
        printint(fd, *ap, 10, 1);
 71a:	83 ec 0c             	sub    $0xc,%esp
 71d:	6a 01                	push   $0x1
 71f:	b9 0a 00 00 00       	mov    $0xa,%ecx
 724:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 727:	8b 17                	mov    (%edi),%edx
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	e8 9a fe ff ff       	call   5cb <printint>
        ap++;
 731:	89 f8                	mov    %edi,%eax
 733:	83 c0 04             	add    $0x4,%eax
 736:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 739:	83 c4 10             	add    $0x10,%esp
      state = 0;
 73c:	bf 00 00 00 00       	mov    $0x0,%edi
 741:	e9 54 ff ff ff       	jmp    69a <printf+0x45>
        printint(fd, *ap, 16, 0);
 746:	83 ec 0c             	sub    $0xc,%esp
 749:	6a 00                	push   $0x0
 74b:	b9 10 00 00 00       	mov    $0x10,%ecx
 750:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 753:	8b 17                	mov    (%edi),%edx
 755:	8b 45 08             	mov    0x8(%ebp),%eax
 758:	e8 6e fe ff ff       	call   5cb <printint>
        ap++;
 75d:	89 f8                	mov    %edi,%eax
 75f:	83 c0 04             	add    $0x4,%eax
 762:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 765:	83 c4 10             	add    $0x10,%esp
      state = 0;
 768:	bf 00 00 00 00       	mov    $0x0,%edi
 76d:	e9 28 ff ff ff       	jmp    69a <printf+0x45>
        s = (char*)*ap;
 772:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 775:	8b 01                	mov    (%ecx),%eax
        ap++;
 777:	83 c1 04             	add    $0x4,%ecx
 77a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 77d:	85 c0                	test   %eax,%eax
 77f:	74 13                	je     794 <printf+0x13f>
        s = (char*)*ap;
 781:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 783:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 786:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 78b:	84 c0                	test   %al,%al
 78d:	75 0f                	jne    79e <printf+0x149>
 78f:	e9 06 ff ff ff       	jmp    69a <printf+0x45>
          s = "(null)";
 794:	bb a2 09 00 00       	mov    $0x9a2,%ebx
        while(*s != 0){
 799:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 79e:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 7a1:	89 75 d0             	mov    %esi,-0x30(%ebp)
 7a4:	8b 75 08             	mov    0x8(%ebp),%esi
 7a7:	88 45 e3             	mov    %al,-0x1d(%ebp)
 7aa:	83 ec 04             	sub    $0x4,%esp
 7ad:	6a 01                	push   $0x1
 7af:	57                   	push   %edi
 7b0:	56                   	push   %esi
 7b1:	e8 55 fd ff ff       	call   50b <write>
          s++;
 7b6:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 7b9:	0f b6 03             	movzbl (%ebx),%eax
 7bc:	83 c4 10             	add    $0x10,%esp
 7bf:	84 c0                	test   %al,%al
 7c1:	75 e4                	jne    7a7 <printf+0x152>
 7c3:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 7c6:	bf 00 00 00 00       	mov    $0x0,%edi
 7cb:	e9 ca fe ff ff       	jmp    69a <printf+0x45>
        putc(fd, *ap);
 7d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 7d3:	8b 07                	mov    (%edi),%eax
 7d5:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 7d8:	83 ec 04             	sub    $0x4,%esp
 7db:	6a 01                	push   $0x1
 7dd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7e0:	50                   	push   %eax
 7e1:	ff 75 08             	pushl  0x8(%ebp)
 7e4:	e8 22 fd ff ff       	call   50b <write>
        ap++;
 7e9:	83 c7 04             	add    $0x4,%edi
 7ec:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 7ef:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7f2:	bf 00 00 00 00       	mov    $0x0,%edi
 7f7:	e9 9e fe ff ff       	jmp    69a <printf+0x45>
 7fc:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 7ff:	83 ec 04             	sub    $0x4,%esp
 802:	6a 01                	push   $0x1
 804:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 807:	50                   	push   %eax
 808:	ff 75 08             	pushl  0x8(%ebp)
 80b:	e8 fb fc ff ff       	call   50b <write>
 810:	83 c4 10             	add    $0x10,%esp
      state = 0;
 813:	bf 00 00 00 00       	mov    $0x0,%edi
 818:	e9 7d fe ff ff       	jmp    69a <printf+0x45>
    }
  }
}
 81d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 820:	5b                   	pop    %ebx
 821:	5e                   	pop    %esi
 822:	5f                   	pop    %edi
 823:	5d                   	pop    %ebp
 824:	c3                   	ret    

00000825 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 825:	55                   	push   %ebp
 826:	89 e5                	mov    %esp,%ebp
 828:	57                   	push   %edi
 829:	56                   	push   %esi
 82a:	53                   	push   %ebx
 82b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 82e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 831:	a1 00 0d 00 00       	mov    0xd00,%eax
 836:	eb 0c                	jmp    844 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 838:	8b 10                	mov    (%eax),%edx
 83a:	39 c2                	cmp    %eax,%edx
 83c:	77 04                	ja     842 <free+0x1d>
 83e:	39 ca                	cmp    %ecx,%edx
 840:	77 10                	ja     852 <free+0x2d>
{
 842:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 844:	39 c8                	cmp    %ecx,%eax
 846:	73 f0                	jae    838 <free+0x13>
 848:	8b 10                	mov    (%eax),%edx
 84a:	39 ca                	cmp    %ecx,%edx
 84c:	77 04                	ja     852 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	39 c2                	cmp    %eax,%edx
 850:	77 f0                	ja     842 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 852:	8b 73 fc             	mov    -0x4(%ebx),%esi
 855:	8b 10                	mov    (%eax),%edx
 857:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 85a:	39 fa                	cmp    %edi,%edx
 85c:	74 19                	je     877 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 85e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 861:	8b 50 04             	mov    0x4(%eax),%edx
 864:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 867:	39 f1                	cmp    %esi,%ecx
 869:	74 1b                	je     886 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 86b:	89 08                	mov    %ecx,(%eax)
  freep = p;
 86d:	a3 00 0d 00 00       	mov    %eax,0xd00
}
 872:	5b                   	pop    %ebx
 873:	5e                   	pop    %esi
 874:	5f                   	pop    %edi
 875:	5d                   	pop    %ebp
 876:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 877:	03 72 04             	add    0x4(%edx),%esi
 87a:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 87d:	8b 10                	mov    (%eax),%edx
 87f:	8b 12                	mov    (%edx),%edx
 881:	89 53 f8             	mov    %edx,-0x8(%ebx)
 884:	eb db                	jmp    861 <free+0x3c>
    p->s.size += bp->s.size;
 886:	03 53 fc             	add    -0x4(%ebx),%edx
 889:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 88c:	8b 53 f8             	mov    -0x8(%ebx),%edx
 88f:	89 10                	mov    %edx,(%eax)
 891:	eb da                	jmp    86d <free+0x48>

00000893 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 893:	55                   	push   %ebp
 894:	89 e5                	mov    %esp,%ebp
 896:	57                   	push   %edi
 897:	56                   	push   %esi
 898:	53                   	push   %ebx
 899:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 89c:	8b 45 08             	mov    0x8(%ebp),%eax
 89f:	8d 58 07             	lea    0x7(%eax),%ebx
 8a2:	c1 eb 03             	shr    $0x3,%ebx
 8a5:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 8a8:	8b 15 00 0d 00 00    	mov    0xd00,%edx
 8ae:	85 d2                	test   %edx,%edx
 8b0:	74 20                	je     8d2 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8b4:	8b 48 04             	mov    0x4(%eax),%ecx
 8b7:	39 cb                	cmp    %ecx,%ebx
 8b9:	76 3c                	jbe    8f7 <malloc+0x64>
 8bb:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 8c1:	be 00 10 00 00       	mov    $0x1000,%esi
 8c6:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 8c9:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 8d0:	eb 70                	jmp    942 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 8d2:	c7 05 00 0d 00 00 04 	movl   $0xd04,0xd00
 8d9:	0d 00 00 
 8dc:	c7 05 04 0d 00 00 04 	movl   $0xd04,0xd04
 8e3:	0d 00 00 
    base.s.size = 0;
 8e6:	c7 05 08 0d 00 00 00 	movl   $0x0,0xd08
 8ed:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 8f0:	ba 04 0d 00 00       	mov    $0xd04,%edx
 8f5:	eb bb                	jmp    8b2 <malloc+0x1f>
      if(p->s.size == nunits)
 8f7:	39 cb                	cmp    %ecx,%ebx
 8f9:	74 1c                	je     917 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 8fb:	29 d9                	sub    %ebx,%ecx
 8fd:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 900:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 903:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 906:	89 15 00 0d 00 00    	mov    %edx,0xd00
      return (void*)(p + 1);
 90c:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 90f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 912:	5b                   	pop    %ebx
 913:	5e                   	pop    %esi
 914:	5f                   	pop    %edi
 915:	5d                   	pop    %ebp
 916:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 917:	8b 08                	mov    (%eax),%ecx
 919:	89 0a                	mov    %ecx,(%edx)
 91b:	eb e9                	jmp    906 <malloc+0x73>
  hp->s.size = nu;
 91d:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 920:	83 ec 0c             	sub    $0xc,%esp
 923:	83 c0 08             	add    $0x8,%eax
 926:	50                   	push   %eax
 927:	e8 f9 fe ff ff       	call   825 <free>
  return freep;
 92c:	8b 15 00 0d 00 00    	mov    0xd00,%edx
      if((p = morecore(nunits)) == 0)
 932:	83 c4 10             	add    $0x10,%esp
 935:	85 d2                	test   %edx,%edx
 937:	74 2b                	je     964 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 939:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 93b:	8b 48 04             	mov    0x4(%eax),%ecx
 93e:	39 d9                	cmp    %ebx,%ecx
 940:	73 b5                	jae    8f7 <malloc+0x64>
 942:	89 c2                	mov    %eax,%edx
    if(p == freep)
 944:	39 05 00 0d 00 00    	cmp    %eax,0xd00
 94a:	75 ed                	jne    939 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 94c:	83 ec 0c             	sub    $0xc,%esp
 94f:	57                   	push   %edi
 950:	e8 1e fc ff ff       	call   573 <sbrk>
  if(p == (char*)-1)
 955:	83 c4 10             	add    $0x10,%esp
 958:	83 f8 ff             	cmp    $0xffffffff,%eax
 95b:	75 c0                	jne    91d <malloc+0x8a>
        return 0;
 95d:	b8 00 00 00 00       	mov    $0x0,%eax
 962:	eb ab                	jmp    90f <malloc+0x7c>
 964:	b8 00 00 00 00       	mov    $0x0,%eax
 969:	eb a4                	jmp    90f <malloc+0x7c>
