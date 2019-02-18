
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "fs.h"


char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   8:	83 ec 0c             	sub    $0xc,%esp
   b:	53                   	push   %ebx
   c:	e8 33 03 00 00       	call   344 <strlen>
  11:	83 c4 10             	add    $0x10,%esp
  14:	01 d8                	add    %ebx,%eax
  16:	72 11                	jb     29 <fmtname+0x29>
  18:	80 38 2f             	cmpb   $0x2f,(%eax)
  1b:	74 0c                	je     29 <fmtname+0x29>
  1d:	83 e8 01             	sub    $0x1,%eax
  20:	39 c3                	cmp    %eax,%ebx
  22:	77 05                	ja     29 <fmtname+0x29>
  24:	80 38 2f             	cmpb   $0x2f,(%eax)
  27:	75 f4                	jne    1d <fmtname+0x1d>
    ;
  p++;
  29:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  2c:	83 ec 0c             	sub    $0xc,%esp
  2f:	53                   	push   %ebx
  30:	e8 0f 03 00 00       	call   344 <strlen>
  35:	83 c4 10             	add    $0x10,%esp
  38:	83 f8 0d             	cmp    $0xd,%eax
  3b:	76 09                	jbe    46 <fmtname+0x46>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  3d:	89 d8                	mov    %ebx,%eax
  3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  42:	5b                   	pop    %ebx
  43:	5e                   	pop    %esi
  44:	5d                   	pop    %ebp
  45:	c3                   	ret    
  memmove(buf, p, strlen(p));
  46:	83 ec 0c             	sub    $0xc,%esp
  49:	53                   	push   %ebx
  4a:	e8 f5 02 00 00       	call   344 <strlen>
  4f:	83 c4 0c             	add    $0xc,%esp
  52:	50                   	push   %eax
  53:	53                   	push   %ebx
  54:	68 24 0d 00 00       	push   $0xd24
  59:	e8 c3 04 00 00       	call   521 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  5e:	89 1c 24             	mov    %ebx,(%esp)
  61:	e8 de 02 00 00       	call   344 <strlen>
  66:	89 c6                	mov    %eax,%esi
  68:	89 1c 24             	mov    %ebx,(%esp)
  6b:	e8 d4 02 00 00       	call   344 <strlen>
  70:	83 c4 0c             	add    $0xc,%esp
  73:	ba 0e 00 00 00       	mov    $0xe,%edx
  78:	29 f2                	sub    %esi,%edx
  7a:	52                   	push   %edx
  7b:	6a 20                	push   $0x20
  7d:	05 24 0d 00 00       	add    $0xd24,%eax
  82:	50                   	push   %eax
  83:	e8 e0 02 00 00       	call   368 <memset>
  return buf;
  88:	83 c4 10             	add    $0x10,%esp
  8b:	bb 24 0d 00 00       	mov    $0xd24,%ebx
  90:	eb ab                	jmp    3d <fmtname+0x3d>

00000092 <ls>:

void
ls(char *path)
{
  92:	55                   	push   %ebp
  93:	89 e5                	mov    %esp,%ebp
  95:	57                   	push   %edi
  96:	56                   	push   %esi
  97:	53                   	push   %ebx
  98:	81 ec 54 02 00 00    	sub    $0x254,%esp
  9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  a1:	6a 00                	push   $0x0
  a3:	53                   	push   %ebx
  a4:	e8 e9 04 00 00       	call   592 <open>
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	85 c0                	test   %eax,%eax
  ae:	0f 88 92 00 00 00    	js     146 <ls+0xb4>
  b4:	89 c7                	mov    %eax,%edi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
  bf:	50                   	push   %eax
  c0:	57                   	push   %edi
  c1:	e8 e4 04 00 00       	call   5aa <fstat>
  c6:	83 c4 10             	add    $0x10,%esp
  c9:	85 c0                	test   %eax,%eax
  cb:	0f 88 8a 00 00 00    	js     15b <ls+0xc9>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  d1:	0f b7 b5 c4 fd ff ff 	movzwl -0x23c(%ebp),%esi
  d8:	66 83 fe 01          	cmp    $0x1,%si
  dc:	0f 84 96 00 00 00    	je     178 <ls+0xe6>
  e2:	66 83 fe 01          	cmp    $0x1,%si
  e6:	7c 4a                	jl     132 <ls+0xa0>
  e8:	66 83 fe 03          	cmp    $0x3,%si
  ec:	7f 44                	jg     132 <ls+0xa0>
  case T_FILE:
  case T_DEV:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
  ee:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
  f4:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
  fa:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 100:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 106:	83 ec 0c             	sub    $0xc,%esp
 109:	53                   	push   %ebx
 10a:	e8 f1 fe ff ff       	call   0 <fmtname>
 10f:	83 c4 08             	add    $0x8,%esp
 112:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 118:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
  switch(st.type){
 11e:	0f bf f6             	movswl %si,%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 121:	56                   	push   %esi
 122:	50                   	push   %eax
 123:	68 fc 09 00 00       	push   $0x9fc
 128:	6a 01                	push   $0x1
 12a:	e8 8d 05 00 00       	call   6bc <printf>
    break;
 12f:	83 c4 20             	add    $0x20,%esp
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 132:	83 ec 0c             	sub    $0xc,%esp
 135:	57                   	push   %edi
 136:	e8 3f 04 00 00       	call   57a <close>
 13b:	83 c4 10             	add    $0x10,%esp
}
 13e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 141:	5b                   	pop    %ebx
 142:	5e                   	pop    %esi
 143:	5f                   	pop    %edi
 144:	5d                   	pop    %ebp
 145:	c3                   	ret    
    printf(2, "ls: cannot open %s\n", path);
 146:	83 ec 04             	sub    $0x4,%esp
 149:	53                   	push   %ebx
 14a:	68 d4 09 00 00       	push   $0x9d4
 14f:	6a 02                	push   $0x2
 151:	e8 66 05 00 00       	call   6bc <printf>
    return;
 156:	83 c4 10             	add    $0x10,%esp
 159:	eb e3                	jmp    13e <ls+0xac>
    printf(2, "ls: cannot stat %s\n", path);
 15b:	83 ec 04             	sub    $0x4,%esp
 15e:	53                   	push   %ebx
 15f:	68 e8 09 00 00       	push   $0x9e8
 164:	6a 02                	push   $0x2
 166:	e8 51 05 00 00       	call   6bc <printf>
    close(fd);
 16b:	89 3c 24             	mov    %edi,(%esp)
 16e:	e8 07 04 00 00       	call   57a <close>
    return;
 173:	83 c4 10             	add    $0x10,%esp
 176:	eb c6                	jmp    13e <ls+0xac>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 178:	83 ec 0c             	sub    $0xc,%esp
 17b:	53                   	push   %ebx
 17c:	e8 c3 01 00 00       	call   344 <strlen>
 181:	83 c0 10             	add    $0x10,%eax
 184:	83 c4 10             	add    $0x10,%esp
 187:	3d 00 02 00 00       	cmp    $0x200,%eax
 18c:	76 14                	jbe    1a2 <ls+0x110>
      printf(1, "ls: path too long\n");
 18e:	83 ec 08             	sub    $0x8,%esp
 191:	68 09 0a 00 00       	push   $0xa09
 196:	6a 01                	push   $0x1
 198:	e8 1f 05 00 00       	call   6bc <printf>
      break;
 19d:	83 c4 10             	add    $0x10,%esp
 1a0:	eb 90                	jmp    132 <ls+0xa0>
    strcpy(buf, path);
 1a2:	83 ec 08             	sub    $0x8,%esp
 1a5:	53                   	push   %ebx
 1a6:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
 1ac:	56                   	push   %esi
 1ad:	e8 43 01 00 00       	call   2f5 <strcpy>
    p = buf+strlen(buf);
 1b2:	89 34 24             	mov    %esi,(%esp)
 1b5:	e8 8a 01 00 00       	call   344 <strlen>
 1ba:	01 c6                	add    %eax,%esi
    *p++ = '/';
 1bc:	8d 46 01             	lea    0x1(%esi),%eax
 1bf:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
 1c5:	c6 06 2f             	movb   $0x2f,(%esi)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c8:	83 c4 10             	add    $0x10,%esp
 1cb:	8d 9d d8 fd ff ff    	lea    -0x228(%ebp),%ebx
 1d1:	83 ec 04             	sub    $0x4,%esp
 1d4:	6a 10                	push   $0x10
 1d6:	53                   	push   %ebx
 1d7:	57                   	push   %edi
 1d8:	e8 8d 03 00 00       	call   56a <read>
 1dd:	83 c4 10             	add    $0x10,%esp
 1e0:	83 f8 10             	cmp    $0x10,%eax
 1e3:	0f 85 49 ff ff ff    	jne    132 <ls+0xa0>
      if(de.inum == 0)
 1e9:	66 83 bd d8 fd ff ff 	cmpw   $0x0,-0x228(%ebp)
 1f0:	00 
 1f1:	74 de                	je     1d1 <ls+0x13f>
      memmove(p, de.name, DIRSIZ);
 1f3:	83 ec 04             	sub    $0x4,%esp
 1f6:	6a 0e                	push   $0xe
 1f8:	8d 85 da fd ff ff    	lea    -0x226(%ebp),%eax
 1fe:	50                   	push   %eax
 1ff:	ff b5 a8 fd ff ff    	pushl  -0x258(%ebp)
 205:	e8 17 03 00 00       	call   521 <memmove>
      p[DIRSIZ] = 0;
 20a:	c6 46 0f 00          	movb   $0x0,0xf(%esi)
      if(stat(buf, &st) < 0){
 20e:	83 c4 08             	add    $0x8,%esp
 211:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 217:	50                   	push   %eax
 218:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 21e:	50                   	push   %eax
 21f:	e8 e4 01 00 00       	call   408 <stat>
 224:	83 c4 10             	add    $0x10,%esp
 227:	85 c0                	test   %eax,%eax
 229:	78 5e                	js     289 <ls+0x1f7>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 22b:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 231:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 237:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 23d:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 243:	0f bf 8d c4 fd ff ff 	movswl -0x23c(%ebp),%ecx
 24a:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 250:	83 ec 0c             	sub    $0xc,%esp
 253:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 259:	50                   	push   %eax
 25a:	e8 a1 fd ff ff       	call   0 <fmtname>
 25f:	83 c4 08             	add    $0x8,%esp
 262:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 268:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 26e:	ff b5 ac fd ff ff    	pushl  -0x254(%ebp)
 274:	50                   	push   %eax
 275:	68 fc 09 00 00       	push   $0x9fc
 27a:	6a 01                	push   $0x1
 27c:	e8 3b 04 00 00       	call   6bc <printf>
 281:	83 c4 20             	add    $0x20,%esp
 284:	e9 48 ff ff ff       	jmp    1d1 <ls+0x13f>
        printf(1, "ls: cannot stat %s\n", buf);
 289:	83 ec 04             	sub    $0x4,%esp
 28c:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 292:	50                   	push   %eax
 293:	68 e8 09 00 00       	push   $0x9e8
 298:	6a 01                	push   $0x1
 29a:	e8 1d 04 00 00       	call   6bc <printf>
        continue;
 29f:	83 c4 10             	add    $0x10,%esp
 2a2:	e9 2a ff ff ff       	jmp    1d1 <ls+0x13f>

000002a7 <main>:

int
main(int argc, char *argv[])
{
 2a7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2ab:	83 e4 f0             	and    $0xfffffff0,%esp
 2ae:	ff 71 fc             	pushl  -0x4(%ecx)
 2b1:	55                   	push   %ebp
 2b2:	89 e5                	mov    %esp,%ebp
 2b4:	56                   	push   %esi
 2b5:	53                   	push   %ebx
 2b6:	51                   	push   %ecx
 2b7:	83 ec 0c             	sub    $0xc,%esp
 2ba:	8b 01                	mov    (%ecx),%eax
 2bc:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
 2bf:	83 f8 01             	cmp    $0x1,%eax
 2c2:	7e 1f                	jle    2e3 <main+0x3c>
 2c4:	8d 5a 04             	lea    0x4(%edx),%ebx
 2c7:	8d 34 82             	lea    (%edx,%eax,4),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2ca:	83 ec 0c             	sub    $0xc,%esp
 2cd:	ff 33                	pushl  (%ebx)
 2cf:	e8 be fd ff ff       	call   92 <ls>
 2d4:	83 c3 04             	add    $0x4,%ebx
  for(i=1; i<argc; i++)
 2d7:	83 c4 10             	add    $0x10,%esp
 2da:	39 f3                	cmp    %esi,%ebx
 2dc:	75 ec                	jne    2ca <main+0x23>
  exit();
 2de:	e8 6f 02 00 00       	call   552 <exit>
    ls(".");
 2e3:	83 ec 0c             	sub    $0xc,%esp
 2e6:	68 1c 0a 00 00       	push   $0xa1c
 2eb:	e8 a2 fd ff ff       	call   92 <ls>
    exit();
 2f0:	e8 5d 02 00 00       	call   552 <exit>

000002f5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
 2f8:	53                   	push   %ebx
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ff:	89 c2                	mov    %eax,%edx
 301:	83 c1 01             	add    $0x1,%ecx
 304:	83 c2 01             	add    $0x1,%edx
 307:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 30b:	88 5a ff             	mov    %bl,-0x1(%edx)
 30e:	84 db                	test   %bl,%bl
 310:	75 ef                	jne    301 <strcpy+0xc>
    ;
  return os;
}
 312:	5b                   	pop    %ebx
 313:	5d                   	pop    %ebp
 314:	c3                   	ret    

00000315 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 315:	55                   	push   %ebp
 316:	89 e5                	mov    %esp,%ebp
 318:	8b 4d 08             	mov    0x8(%ebp),%ecx
 31b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 31e:	0f b6 01             	movzbl (%ecx),%eax
 321:	84 c0                	test   %al,%al
 323:	74 15                	je     33a <strcmp+0x25>
 325:	3a 02                	cmp    (%edx),%al
 327:	75 11                	jne    33a <strcmp+0x25>
    p++, q++;
 329:	83 c1 01             	add    $0x1,%ecx
 32c:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 32f:	0f b6 01             	movzbl (%ecx),%eax
 332:	84 c0                	test   %al,%al
 334:	74 04                	je     33a <strcmp+0x25>
 336:	3a 02                	cmp    (%edx),%al
 338:	74 ef                	je     329 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 33a:	0f b6 c0             	movzbl %al,%eax
 33d:	0f b6 12             	movzbl (%edx),%edx
 340:	29 d0                	sub    %edx,%eax
}
 342:	5d                   	pop    %ebp
 343:	c3                   	ret    

00000344 <strlen>:

uint
strlen(char *s)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 34a:	80 39 00             	cmpb   $0x0,(%ecx)
 34d:	74 12                	je     361 <strlen+0x1d>
 34f:	ba 00 00 00 00       	mov    $0x0,%edx
 354:	83 c2 01             	add    $0x1,%edx
 357:	89 d0                	mov    %edx,%eax
 359:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 35d:	75 f5                	jne    354 <strlen+0x10>
    ;
  return n;
}
 35f:	5d                   	pop    %ebp
 360:	c3                   	ret    
  for(n = 0; s[n]; n++)
 361:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 366:	eb f7                	jmp    35f <strlen+0x1b>

00000368 <memset>:

void*
memset(void *dst, int c, uint n)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	57                   	push   %edi
 36c:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 36f:	89 d7                	mov    %edx,%edi
 371:	8b 4d 10             	mov    0x10(%ebp),%ecx
 374:	8b 45 0c             	mov    0xc(%ebp),%eax
 377:	fc                   	cld    
 378:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 37a:	89 d0                	mov    %edx,%eax
 37c:	5f                   	pop    %edi
 37d:	5d                   	pop    %ebp
 37e:	c3                   	ret    

0000037f <strchr>:

char*
strchr(const char *s, char c)
{
 37f:	55                   	push   %ebp
 380:	89 e5                	mov    %esp,%ebp
 382:	53                   	push   %ebx
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 389:	0f b6 10             	movzbl (%eax),%edx
 38c:	84 d2                	test   %dl,%dl
 38e:	74 1e                	je     3ae <strchr+0x2f>
 390:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 392:	38 d3                	cmp    %dl,%bl
 394:	74 15                	je     3ab <strchr+0x2c>
  for(; *s; s++)
 396:	83 c0 01             	add    $0x1,%eax
 399:	0f b6 10             	movzbl (%eax),%edx
 39c:	84 d2                	test   %dl,%dl
 39e:	74 06                	je     3a6 <strchr+0x27>
    if(*s == c)
 3a0:	38 ca                	cmp    %cl,%dl
 3a2:	75 f2                	jne    396 <strchr+0x17>
 3a4:	eb 05                	jmp    3ab <strchr+0x2c>
      return (char*)s;
  return 0;
 3a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3ab:	5b                   	pop    %ebx
 3ac:	5d                   	pop    %ebp
 3ad:	c3                   	ret    
  return 0;
 3ae:	b8 00 00 00 00       	mov    $0x0,%eax
 3b3:	eb f6                	jmp    3ab <strchr+0x2c>

000003b5 <gets>:

char*
gets(char *buf, int max)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	57                   	push   %edi
 3b9:	56                   	push   %esi
 3ba:	53                   	push   %ebx
 3bb:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3be:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 3c3:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 3c6:	8d 5e 01             	lea    0x1(%esi),%ebx
 3c9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3cc:	7d 2b                	jge    3f9 <gets+0x44>
    cc = read(0, &c, 1);
 3ce:	83 ec 04             	sub    $0x4,%esp
 3d1:	6a 01                	push   $0x1
 3d3:	57                   	push   %edi
 3d4:	6a 00                	push   $0x0
 3d6:	e8 8f 01 00 00       	call   56a <read>
    if(cc < 1)
 3db:	83 c4 10             	add    $0x10,%esp
 3de:	85 c0                	test   %eax,%eax
 3e0:	7e 17                	jle    3f9 <gets+0x44>
      break;
    buf[i++] = c;
 3e2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3e6:	8b 55 08             	mov    0x8(%ebp),%edx
 3e9:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 3ed:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 3ef:	3c 0a                	cmp    $0xa,%al
 3f1:	74 04                	je     3f7 <gets+0x42>
 3f3:	3c 0d                	cmp    $0xd,%al
 3f5:	75 cf                	jne    3c6 <gets+0x11>
  for(i=0; i+1 < max; ){
 3f7:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
 3fc:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 400:	8d 65 f4             	lea    -0xc(%ebp),%esp
 403:	5b                   	pop    %ebx
 404:	5e                   	pop    %esi
 405:	5f                   	pop    %edi
 406:	5d                   	pop    %ebp
 407:	c3                   	ret    

00000408 <stat>:

int
stat(char *n, struct stat *st)
{
 408:	55                   	push   %ebp
 409:	89 e5                	mov    %esp,%ebp
 40b:	56                   	push   %esi
 40c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 40d:	83 ec 08             	sub    $0x8,%esp
 410:	6a 00                	push   $0x0
 412:	ff 75 08             	pushl  0x8(%ebp)
 415:	e8 78 01 00 00       	call   592 <open>
  if(fd < 0)
 41a:	83 c4 10             	add    $0x10,%esp
 41d:	85 c0                	test   %eax,%eax
 41f:	78 24                	js     445 <stat+0x3d>
 421:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 423:	83 ec 08             	sub    $0x8,%esp
 426:	ff 75 0c             	pushl  0xc(%ebp)
 429:	50                   	push   %eax
 42a:	e8 7b 01 00 00       	call   5aa <fstat>
 42f:	89 c6                	mov    %eax,%esi
  close(fd);
 431:	89 1c 24             	mov    %ebx,(%esp)
 434:	e8 41 01 00 00       	call   57a <close>
  return r;
 439:	83 c4 10             	add    $0x10,%esp
}
 43c:	89 f0                	mov    %esi,%eax
 43e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 441:	5b                   	pop    %ebx
 442:	5e                   	pop    %esi
 443:	5d                   	pop    %ebp
 444:	c3                   	ret    
    return -1;
 445:	be ff ff ff ff       	mov    $0xffffffff,%esi
 44a:	eb f0                	jmp    43c <stat+0x34>

0000044c <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	56                   	push   %esi
 450:	53                   	push   %ebx
 451:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 454:	0f b6 0a             	movzbl (%edx),%ecx
 457:	80 f9 20             	cmp    $0x20,%cl
 45a:	75 0b                	jne    467 <atoi+0x1b>
 45c:	83 c2 01             	add    $0x1,%edx
 45f:	0f b6 0a             	movzbl (%edx),%ecx
 462:	80 f9 20             	cmp    $0x20,%cl
 465:	74 f5                	je     45c <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 467:	80 f9 2d             	cmp    $0x2d,%cl
 46a:	74 3b                	je     4a7 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 46c:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 46f:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 474:	f6 c1 fd             	test   $0xfd,%cl
 477:	74 33                	je     4ac <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 479:	0f b6 0a             	movzbl (%edx),%ecx
 47c:	8d 41 d0             	lea    -0x30(%ecx),%eax
 47f:	3c 09                	cmp    $0x9,%al
 481:	77 2e                	ja     4b1 <atoi+0x65>
 483:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 488:	83 c2 01             	add    $0x1,%edx
 48b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 48e:	0f be c9             	movsbl %cl,%ecx
 491:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 495:	0f b6 0a             	movzbl (%edx),%ecx
 498:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 49b:	80 fb 09             	cmp    $0x9,%bl
 49e:	76 e8                	jbe    488 <atoi+0x3c>
  return sign*n;
 4a0:	0f af c6             	imul   %esi,%eax
}
 4a3:	5b                   	pop    %ebx
 4a4:	5e                   	pop    %esi
 4a5:	5d                   	pop    %ebp
 4a6:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 4a7:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 4ac:	83 c2 01             	add    $0x1,%edx
 4af:	eb c8                	jmp    479 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 4b1:	b8 00 00 00 00       	mov    $0x0,%eax
 4b6:	eb e8                	jmp    4a0 <atoi+0x54>

000004b8 <atoo>:

int
atoo(const char *s)
{
 4b8:	55                   	push   %ebp
 4b9:	89 e5                	mov    %esp,%ebp
 4bb:	56                   	push   %esi
 4bc:	53                   	push   %ebx
 4bd:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 4c0:	0f b6 0a             	movzbl (%edx),%ecx
 4c3:	80 f9 20             	cmp    $0x20,%cl
 4c6:	75 0b                	jne    4d3 <atoo+0x1b>
 4c8:	83 c2 01             	add    $0x1,%edx
 4cb:	0f b6 0a             	movzbl (%edx),%ecx
 4ce:	80 f9 20             	cmp    $0x20,%cl
 4d1:	74 f5                	je     4c8 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 4d3:	80 f9 2d             	cmp    $0x2d,%cl
 4d6:	74 38                	je     510 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 4d8:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 4db:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 4e0:	f6 c1 fd             	test   $0xfd,%cl
 4e3:	74 30                	je     515 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 4e5:	0f b6 0a             	movzbl (%edx),%ecx
 4e8:	8d 41 d0             	lea    -0x30(%ecx),%eax
 4eb:	3c 07                	cmp    $0x7,%al
 4ed:	77 2b                	ja     51a <atoo+0x62>
 4ef:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 4f4:	83 c2 01             	add    $0x1,%edx
 4f7:	0f be c9             	movsbl %cl,%ecx
 4fa:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 4fe:	0f b6 0a             	movzbl (%edx),%ecx
 501:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 504:	80 fb 07             	cmp    $0x7,%bl
 507:	76 eb                	jbe    4f4 <atoo+0x3c>
  return sign*n;
 509:	0f af c6             	imul   %esi,%eax
}
 50c:	5b                   	pop    %ebx
 50d:	5e                   	pop    %esi
 50e:	5d                   	pop    %ebp
 50f:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 510:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 515:	83 c2 01             	add    $0x1,%edx
 518:	eb cb                	jmp    4e5 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 51a:	b8 00 00 00 00       	mov    $0x0,%eax
 51f:	eb e8                	jmp    509 <atoo+0x51>

00000521 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 521:	55                   	push   %ebp
 522:	89 e5                	mov    %esp,%ebp
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	8b 75 0c             	mov    0xc(%ebp),%esi
 52c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 52f:	85 db                	test   %ebx,%ebx
 531:	7e 13                	jle    546 <memmove+0x25>
 533:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 538:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 53c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 53f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 542:	39 d3                	cmp    %edx,%ebx
 544:	75 f2                	jne    538 <memmove+0x17>
  return vdst;
}
 546:	5b                   	pop    %ebx
 547:	5e                   	pop    %esi
 548:	5d                   	pop    %ebp
 549:	c3                   	ret    

0000054a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 54a:	b8 01 00 00 00       	mov    $0x1,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <exit>:
SYSCALL(exit)
 552:	b8 02 00 00 00       	mov    $0x2,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <wait>:
SYSCALL(wait)
 55a:	b8 03 00 00 00       	mov    $0x3,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <pipe>:
SYSCALL(pipe)
 562:	b8 04 00 00 00       	mov    $0x4,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <read>:
SYSCALL(read)
 56a:	b8 05 00 00 00       	mov    $0x5,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <write>:
SYSCALL(write)
 572:	b8 10 00 00 00       	mov    $0x10,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <close>:
SYSCALL(close)
 57a:	b8 15 00 00 00       	mov    $0x15,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <kill>:
SYSCALL(kill)
 582:	b8 06 00 00 00       	mov    $0x6,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <exec>:
SYSCALL(exec)
 58a:	b8 07 00 00 00       	mov    $0x7,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <open>:
SYSCALL(open)
 592:	b8 0f 00 00 00       	mov    $0xf,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <mknod>:
SYSCALL(mknod)
 59a:	b8 11 00 00 00       	mov    $0x11,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <unlink>:
SYSCALL(unlink)
 5a2:	b8 12 00 00 00       	mov    $0x12,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <fstat>:
SYSCALL(fstat)
 5aa:	b8 08 00 00 00       	mov    $0x8,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <link>:
SYSCALL(link)
 5b2:	b8 13 00 00 00       	mov    $0x13,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <mkdir>:
SYSCALL(mkdir)
 5ba:	b8 14 00 00 00       	mov    $0x14,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <chdir>:
SYSCALL(chdir)
 5c2:	b8 09 00 00 00       	mov    $0x9,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <dup>:
SYSCALL(dup)
 5ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <getpid>:
SYSCALL(getpid)
 5d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <sbrk>:
SYSCALL(sbrk)
 5da:	b8 0c 00 00 00       	mov    $0xc,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <sleep>:
SYSCALL(sleep)
 5e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <uptime>:
SYSCALL(uptime)
 5ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <halt>:
SYSCALL(halt)
 5f2:	b8 16 00 00 00       	mov    $0x16,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <date>:
//proj1
SYSCALL(date)
 5fa:	b8 17 00 00 00       	mov    $0x17,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <getuid>:
//proj2
SYSCALL(getuid)
 602:	b8 18 00 00 00       	mov    $0x18,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <getgid>:
SYSCALL(getgid)
 60a:	b8 19 00 00 00       	mov    $0x19,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <getppid>:
SYSCALL(getppid)
 612:	b8 1a 00 00 00       	mov    $0x1a,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <setuid>:
SYSCALL(setuid)
 61a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <setgid>:
SYSCALL(setgid)
 622:	b8 1c 00 00 00       	mov    $0x1c,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <getprocs>:
SYSCALL(getprocs)
 62a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 632:	55                   	push   %ebp
 633:	89 e5                	mov    %esp,%ebp
 635:	57                   	push   %edi
 636:	56                   	push   %esi
 637:	53                   	push   %ebx
 638:	83 ec 3c             	sub    $0x3c,%esp
 63b:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 63d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 641:	74 14                	je     657 <printint+0x25>
 643:	85 d2                	test   %edx,%edx
 645:	79 10                	jns    657 <printint+0x25>
    neg = 1;
    x = -xx;
 647:	f7 da                	neg    %edx
    neg = 1;
 649:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 650:	bf 00 00 00 00       	mov    $0x0,%edi
 655:	eb 0b                	jmp    662 <printint+0x30>
  neg = 0;
 657:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 65e:	eb f0                	jmp    650 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 660:	89 df                	mov    %ebx,%edi
 662:	8d 5f 01             	lea    0x1(%edi),%ebx
 665:	89 d0                	mov    %edx,%eax
 667:	ba 00 00 00 00       	mov    $0x0,%edx
 66c:	f7 f1                	div    %ecx
 66e:	0f b6 92 28 0a 00 00 	movzbl 0xa28(%edx),%edx
 675:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 679:	89 c2                	mov    %eax,%edx
 67b:	85 c0                	test   %eax,%eax
 67d:	75 e1                	jne    660 <printint+0x2e>
  if(neg)
 67f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 683:	74 08                	je     68d <printint+0x5b>
    buf[i++] = '-';
 685:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 68a:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 68d:	83 eb 01             	sub    $0x1,%ebx
 690:	78 22                	js     6b4 <printint+0x82>
  write(fd, &c, 1);
 692:	8d 7d d7             	lea    -0x29(%ebp),%edi
 695:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 69a:	88 45 d7             	mov    %al,-0x29(%ebp)
 69d:	83 ec 04             	sub    $0x4,%esp
 6a0:	6a 01                	push   $0x1
 6a2:	57                   	push   %edi
 6a3:	56                   	push   %esi
 6a4:	e8 c9 fe ff ff       	call   572 <write>
  while(--i >= 0)
 6a9:	83 eb 01             	sub    $0x1,%ebx
 6ac:	83 c4 10             	add    $0x10,%esp
 6af:	83 fb ff             	cmp    $0xffffffff,%ebx
 6b2:	75 e1                	jne    695 <printint+0x63>
    putc(fd, buf[i]);
}
 6b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6b7:	5b                   	pop    %ebx
 6b8:	5e                   	pop    %esi
 6b9:	5f                   	pop    %edi
 6ba:	5d                   	pop    %ebp
 6bb:	c3                   	ret    

000006bc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6bc:	55                   	push   %ebp
 6bd:	89 e5                	mov    %esp,%ebp
 6bf:	57                   	push   %edi
 6c0:	56                   	push   %esi
 6c1:	53                   	push   %ebx
 6c2:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c5:	8b 75 0c             	mov    0xc(%ebp),%esi
 6c8:	0f b6 1e             	movzbl (%esi),%ebx
 6cb:	84 db                	test   %bl,%bl
 6cd:	0f 84 b1 01 00 00    	je     884 <printf+0x1c8>
 6d3:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 6d6:	8d 45 10             	lea    0x10(%ebp),%eax
 6d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 6dc:	bf 00 00 00 00       	mov    $0x0,%edi
 6e1:	eb 2d                	jmp    710 <printf+0x54>
 6e3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 6e6:	83 ec 04             	sub    $0x4,%esp
 6e9:	6a 01                	push   $0x1
 6eb:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 6ee:	50                   	push   %eax
 6ef:	ff 75 08             	pushl  0x8(%ebp)
 6f2:	e8 7b fe ff ff       	call   572 <write>
 6f7:	83 c4 10             	add    $0x10,%esp
 6fa:	eb 05                	jmp    701 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6fc:	83 ff 25             	cmp    $0x25,%edi
 6ff:	74 22                	je     723 <printf+0x67>
 701:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 704:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 708:	84 db                	test   %bl,%bl
 70a:	0f 84 74 01 00 00    	je     884 <printf+0x1c8>
    c = fmt[i] & 0xff;
 710:	0f be d3             	movsbl %bl,%edx
 713:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 716:	85 ff                	test   %edi,%edi
 718:	75 e2                	jne    6fc <printf+0x40>
      if(c == '%'){
 71a:	83 f8 25             	cmp    $0x25,%eax
 71d:	75 c4                	jne    6e3 <printf+0x27>
        state = '%';
 71f:	89 c7                	mov    %eax,%edi
 721:	eb de                	jmp    701 <printf+0x45>
      if(c == 'd'){
 723:	83 f8 64             	cmp    $0x64,%eax
 726:	74 59                	je     781 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 728:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 72e:	83 fa 70             	cmp    $0x70,%edx
 731:	74 7a                	je     7ad <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 733:	83 f8 73             	cmp    $0x73,%eax
 736:	0f 84 9d 00 00 00    	je     7d9 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 73c:	83 f8 63             	cmp    $0x63,%eax
 73f:	0f 84 f2 00 00 00    	je     837 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 745:	83 f8 25             	cmp    $0x25,%eax
 748:	0f 84 15 01 00 00    	je     863 <printf+0x1a7>
 74e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 752:	83 ec 04             	sub    $0x4,%esp
 755:	6a 01                	push   $0x1
 757:	8d 45 e7             	lea    -0x19(%ebp),%eax
 75a:	50                   	push   %eax
 75b:	ff 75 08             	pushl  0x8(%ebp)
 75e:	e8 0f fe ff ff       	call   572 <write>
 763:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 766:	83 c4 0c             	add    $0xc,%esp
 769:	6a 01                	push   $0x1
 76b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 76e:	50                   	push   %eax
 76f:	ff 75 08             	pushl  0x8(%ebp)
 772:	e8 fb fd ff ff       	call   572 <write>
 777:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 77a:	bf 00 00 00 00       	mov    $0x0,%edi
 77f:	eb 80                	jmp    701 <printf+0x45>
        printint(fd, *ap, 10, 1);
 781:	83 ec 0c             	sub    $0xc,%esp
 784:	6a 01                	push   $0x1
 786:	b9 0a 00 00 00       	mov    $0xa,%ecx
 78b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 78e:	8b 17                	mov    (%edi),%edx
 790:	8b 45 08             	mov    0x8(%ebp),%eax
 793:	e8 9a fe ff ff       	call   632 <printint>
        ap++;
 798:	89 f8                	mov    %edi,%eax
 79a:	83 c0 04             	add    $0x4,%eax
 79d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7a0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7a3:	bf 00 00 00 00       	mov    $0x0,%edi
 7a8:	e9 54 ff ff ff       	jmp    701 <printf+0x45>
        printint(fd, *ap, 16, 0);
 7ad:	83 ec 0c             	sub    $0xc,%esp
 7b0:	6a 00                	push   $0x0
 7b2:	b9 10 00 00 00       	mov    $0x10,%ecx
 7b7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 7ba:	8b 17                	mov    (%edi),%edx
 7bc:	8b 45 08             	mov    0x8(%ebp),%eax
 7bf:	e8 6e fe ff ff       	call   632 <printint>
        ap++;
 7c4:	89 f8                	mov    %edi,%eax
 7c6:	83 c0 04             	add    $0x4,%eax
 7c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7cc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7cf:	bf 00 00 00 00       	mov    $0x0,%edi
 7d4:	e9 28 ff ff ff       	jmp    701 <printf+0x45>
        s = (char*)*ap;
 7d9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 7dc:	8b 01                	mov    (%ecx),%eax
        ap++;
 7de:	83 c1 04             	add    $0x4,%ecx
 7e1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 7e4:	85 c0                	test   %eax,%eax
 7e6:	74 13                	je     7fb <printf+0x13f>
        s = (char*)*ap;
 7e8:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 7ea:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 7ed:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 7f2:	84 c0                	test   %al,%al
 7f4:	75 0f                	jne    805 <printf+0x149>
 7f6:	e9 06 ff ff ff       	jmp    701 <printf+0x45>
          s = "(null)";
 7fb:	bb 1e 0a 00 00       	mov    $0xa1e,%ebx
        while(*s != 0){
 800:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 805:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 808:	89 75 d0             	mov    %esi,-0x30(%ebp)
 80b:	8b 75 08             	mov    0x8(%ebp),%esi
 80e:	88 45 e3             	mov    %al,-0x1d(%ebp)
 811:	83 ec 04             	sub    $0x4,%esp
 814:	6a 01                	push   $0x1
 816:	57                   	push   %edi
 817:	56                   	push   %esi
 818:	e8 55 fd ff ff       	call   572 <write>
          s++;
 81d:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 820:	0f b6 03             	movzbl (%ebx),%eax
 823:	83 c4 10             	add    $0x10,%esp
 826:	84 c0                	test   %al,%al
 828:	75 e4                	jne    80e <printf+0x152>
 82a:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 82d:	bf 00 00 00 00       	mov    $0x0,%edi
 832:	e9 ca fe ff ff       	jmp    701 <printf+0x45>
        putc(fd, *ap);
 837:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 83a:	8b 07                	mov    (%edi),%eax
 83c:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 83f:	83 ec 04             	sub    $0x4,%esp
 842:	6a 01                	push   $0x1
 844:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 847:	50                   	push   %eax
 848:	ff 75 08             	pushl  0x8(%ebp)
 84b:	e8 22 fd ff ff       	call   572 <write>
        ap++;
 850:	83 c7 04             	add    $0x4,%edi
 853:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 856:	83 c4 10             	add    $0x10,%esp
      state = 0;
 859:	bf 00 00 00 00       	mov    $0x0,%edi
 85e:	e9 9e fe ff ff       	jmp    701 <printf+0x45>
 863:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 866:	83 ec 04             	sub    $0x4,%esp
 869:	6a 01                	push   $0x1
 86b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 86e:	50                   	push   %eax
 86f:	ff 75 08             	pushl  0x8(%ebp)
 872:	e8 fb fc ff ff       	call   572 <write>
 877:	83 c4 10             	add    $0x10,%esp
      state = 0;
 87a:	bf 00 00 00 00       	mov    $0x0,%edi
 87f:	e9 7d fe ff ff       	jmp    701 <printf+0x45>
    }
  }
}
 884:	8d 65 f4             	lea    -0xc(%ebp),%esp
 887:	5b                   	pop    %ebx
 888:	5e                   	pop    %esi
 889:	5f                   	pop    %edi
 88a:	5d                   	pop    %ebp
 88b:	c3                   	ret    

0000088c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88c:	55                   	push   %ebp
 88d:	89 e5                	mov    %esp,%ebp
 88f:	57                   	push   %edi
 890:	56                   	push   %esi
 891:	53                   	push   %ebx
 892:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 895:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 898:	a1 34 0d 00 00       	mov    0xd34,%eax
 89d:	eb 0c                	jmp    8ab <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89f:	8b 10                	mov    (%eax),%edx
 8a1:	39 c2                	cmp    %eax,%edx
 8a3:	77 04                	ja     8a9 <free+0x1d>
 8a5:	39 ca                	cmp    %ecx,%edx
 8a7:	77 10                	ja     8b9 <free+0x2d>
{
 8a9:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ab:	39 c8                	cmp    %ecx,%eax
 8ad:	73 f0                	jae    89f <free+0x13>
 8af:	8b 10                	mov    (%eax),%edx
 8b1:	39 ca                	cmp    %ecx,%edx
 8b3:	77 04                	ja     8b9 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b5:	39 c2                	cmp    %eax,%edx
 8b7:	77 f0                	ja     8a9 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8b9:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8bc:	8b 10                	mov    (%eax),%edx
 8be:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8c1:	39 fa                	cmp    %edi,%edx
 8c3:	74 19                	je     8de <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8c5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8c8:	8b 50 04             	mov    0x4(%eax),%edx
 8cb:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8ce:	39 f1                	cmp    %esi,%ecx
 8d0:	74 1b                	je     8ed <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8d2:	89 08                	mov    %ecx,(%eax)
  freep = p;
 8d4:	a3 34 0d 00 00       	mov    %eax,0xd34
}
 8d9:	5b                   	pop    %ebx
 8da:	5e                   	pop    %esi
 8db:	5f                   	pop    %edi
 8dc:	5d                   	pop    %ebp
 8dd:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 8de:	03 72 04             	add    0x4(%edx),%esi
 8e1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e4:	8b 10                	mov    (%eax),%edx
 8e6:	8b 12                	mov    (%edx),%edx
 8e8:	89 53 f8             	mov    %edx,-0x8(%ebx)
 8eb:	eb db                	jmp    8c8 <free+0x3c>
    p->s.size += bp->s.size;
 8ed:	03 53 fc             	add    -0x4(%ebx),%edx
 8f0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8f3:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8f6:	89 10                	mov    %edx,(%eax)
 8f8:	eb da                	jmp    8d4 <free+0x48>

000008fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8fa:	55                   	push   %ebp
 8fb:	89 e5                	mov    %esp,%ebp
 8fd:	57                   	push   %edi
 8fe:	56                   	push   %esi
 8ff:	53                   	push   %ebx
 900:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 903:	8b 45 08             	mov    0x8(%ebp),%eax
 906:	8d 58 07             	lea    0x7(%eax),%ebx
 909:	c1 eb 03             	shr    $0x3,%ebx
 90c:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 90f:	8b 15 34 0d 00 00    	mov    0xd34,%edx
 915:	85 d2                	test   %edx,%edx
 917:	74 20                	je     939 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 919:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 91b:	8b 48 04             	mov    0x4(%eax),%ecx
 91e:	39 cb                	cmp    %ecx,%ebx
 920:	76 3c                	jbe    95e <malloc+0x64>
 922:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 928:	be 00 10 00 00       	mov    $0x1000,%esi
 92d:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 930:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 937:	eb 70                	jmp    9a9 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 939:	c7 05 34 0d 00 00 38 	movl   $0xd38,0xd34
 940:	0d 00 00 
 943:	c7 05 38 0d 00 00 38 	movl   $0xd38,0xd38
 94a:	0d 00 00 
    base.s.size = 0;
 94d:	c7 05 3c 0d 00 00 00 	movl   $0x0,0xd3c
 954:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 957:	ba 38 0d 00 00       	mov    $0xd38,%edx
 95c:	eb bb                	jmp    919 <malloc+0x1f>
      if(p->s.size == nunits)
 95e:	39 cb                	cmp    %ecx,%ebx
 960:	74 1c                	je     97e <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 962:	29 d9                	sub    %ebx,%ecx
 964:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 967:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 96a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 96d:	89 15 34 0d 00 00    	mov    %edx,0xd34
      return (void*)(p + 1);
 973:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 976:	8d 65 f4             	lea    -0xc(%ebp),%esp
 979:	5b                   	pop    %ebx
 97a:	5e                   	pop    %esi
 97b:	5f                   	pop    %edi
 97c:	5d                   	pop    %ebp
 97d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 97e:	8b 08                	mov    (%eax),%ecx
 980:	89 0a                	mov    %ecx,(%edx)
 982:	eb e9                	jmp    96d <malloc+0x73>
  hp->s.size = nu;
 984:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 987:	83 ec 0c             	sub    $0xc,%esp
 98a:	83 c0 08             	add    $0x8,%eax
 98d:	50                   	push   %eax
 98e:	e8 f9 fe ff ff       	call   88c <free>
  return freep;
 993:	8b 15 34 0d 00 00    	mov    0xd34,%edx
      if((p = morecore(nunits)) == 0)
 999:	83 c4 10             	add    $0x10,%esp
 99c:	85 d2                	test   %edx,%edx
 99e:	74 2b                	je     9cb <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9a2:	8b 48 04             	mov    0x4(%eax),%ecx
 9a5:	39 d9                	cmp    %ebx,%ecx
 9a7:	73 b5                	jae    95e <malloc+0x64>
 9a9:	89 c2                	mov    %eax,%edx
    if(p == freep)
 9ab:	39 05 34 0d 00 00    	cmp    %eax,0xd34
 9b1:	75 ed                	jne    9a0 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 9b3:	83 ec 0c             	sub    $0xc,%esp
 9b6:	57                   	push   %edi
 9b7:	e8 1e fc ff ff       	call   5da <sbrk>
  if(p == (char*)-1)
 9bc:	83 c4 10             	add    $0x10,%esp
 9bf:	83 f8 ff             	cmp    $0xffffffff,%eax
 9c2:	75 c0                	jne    984 <malloc+0x8a>
        return 0;
 9c4:	b8 00 00 00 00       	mov    $0x0,%eax
 9c9:	eb ab                	jmp    976 <malloc+0x7c>
 9cb:	b8 00 00 00 00       	mov    $0x0,%eax
 9d0:	eb a4                	jmp    976 <malloc+0x7c>
