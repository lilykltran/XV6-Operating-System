
_p2-test:     file format elf32-i386


Disassembly of section .text:

00000000 <testprocarray>:

#ifdef GETPROCS_TEST
// Fork to 64 process and then make sure we get all when passing table array
// of sizes 1, 16, 64, 72. NOTE: caller does all forks.
static int
testprocarray(int max, int expected_ret){
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	57                   	push   %edi
       4:	56                   	push   %esi
       5:	53                   	push   %ebx
       6:	83 ec 18             	sub    $0x18,%esp
       9:	89 c3                	mov    %eax,%ebx
       b:	89 d6                	mov    %edx,%esi
  struct uproc * table;
  int ret, success = 0;

  table = malloc(sizeof(struct uproc) * max);  // bad code, assumes success
       d:	8d 04 40             	lea    (%eax,%eax,2),%eax
      10:	c1 e0 05             	shl    $0x5,%eax
      13:	50                   	push   %eax
      14:	e8 a6 10 00 00       	call   10bf <malloc>
  if (!table) {
      19:	83 c4 10             	add    $0x10,%esp
      1c:	85 c0                	test   %eax,%eax
      1e:	74 3c                	je     5c <testprocarray+0x5c>
      20:	89 c7                	mov    %eax,%edi
    printf(2, "Error: malloc() call failed. %s at line %d\n", __FUNCTION__, __LINE__);
    exit();
  }
  ret = getprocs(max, table);
      22:	83 ec 08             	sub    $0x8,%esp
      25:	50                   	push   %eax
      26:	53                   	push   %ebx
      27:	e8 c3 0d 00 00       	call   def <getprocs>
  if (ret != expected_ret){
      2c:	83 c4 10             	add    $0x10,%esp
      2f:	39 f0                	cmp    %esi,%eax
      31:	75 44                	jne    77 <testprocarray+0x77>
    printf(2, "FAILED: getprocs(%d) returned %d, expected %d\n", max, ret, expected_ret);
    success = -1;
  }
  else{
    printf(2, "getprocs() was asked for %d processes and returned %d. SUCCESS\n", max, expected_ret);
      33:	56                   	push   %esi
      34:	53                   	push   %ebx
      35:	68 f4 11 00 00       	push   $0x11f4
      3a:	6a 02                	push   $0x2
      3c:	e8 40 0e 00 00       	call   e81 <printf>
      41:	83 c4 10             	add    $0x10,%esp
  int ret, success = 0;
      44:	bb 00 00 00 00       	mov    $0x0,%ebx
  }
  free(table);
      49:	83 ec 0c             	sub    $0xc,%esp
      4c:	57                   	push   %edi
      4d:	e8 ff 0f 00 00       	call   1051 <free>
  return success;
}
      52:	89 d8                	mov    %ebx,%eax
      54:	8d 65 f4             	lea    -0xc(%ebp),%esp
      57:	5b                   	pop    %ebx
      58:	5e                   	pop    %esi
      59:	5f                   	pop    %edi
      5a:	5d                   	pop    %ebp
      5b:	c3                   	ret    
    printf(2, "Error: malloc() call failed. %s at line %d\n", __FUNCTION__, __LINE__);
      5c:	68 f0 00 00 00       	push   $0xf0
      61:	68 e8 17 00 00       	push   $0x17e8
      66:	68 98 11 00 00       	push   $0x1198
      6b:	6a 02                	push   $0x2
      6d:	e8 0f 0e 00 00       	call   e81 <printf>
    exit();
      72:	e8 a0 0c 00 00       	call   d17 <exit>
    printf(2, "FAILED: getprocs(%d) returned %d, expected %d\n", max, ret, expected_ret);
      77:	83 ec 0c             	sub    $0xc,%esp
      7a:	56                   	push   %esi
      7b:	50                   	push   %eax
      7c:	53                   	push   %ebx
      7d:	68 c4 11 00 00       	push   $0x11c4
      82:	6a 02                	push   $0x2
      84:	e8 f8 0d 00 00       	call   e81 <printf>
      89:	83 c4 20             	add    $0x20,%esp
    success = -1;
      8c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      91:	eb b6                	jmp    49 <testprocarray+0x49>

00000093 <getcputime>:
getcputime(char * name, struct uproc * table){
      93:	55                   	push   %ebp
      94:	89 e5                	mov    %esp,%ebp
      96:	57                   	push   %edi
      97:	56                   	push   %esi
      98:	53                   	push   %ebx
      99:	83 ec 24             	sub    $0x24,%esp
      9c:	89 c7                	mov    %eax,%edi
      9e:	89 d3                	mov    %edx,%ebx
  size = getprocs(64, table);
      a0:	52                   	push   %edx
      a1:	6a 40                	push   $0x40
      a3:	e8 47 0d 00 00       	call   def <getprocs>
      a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i = 0; i < size; ++i){
      ab:	83 c4 10             	add    $0x10,%esp
      ae:	85 c0                	test   %eax,%eax
      b0:	7e 27                	jle    d9 <getcputime+0x46>
      b2:	be 00 00 00 00       	mov    $0x0,%esi
    if(strcmp(table[i].name, name) == 0){
      b7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
      ba:	83 ec 08             	sub    $0x8,%esp
      bd:	57                   	push   %edi
      be:	8d 43 40             	lea    0x40(%ebx),%eax
      c1:	50                   	push   %eax
      c2:	e8 13 0a 00 00       	call   ada <strcmp>
      c7:	83 c4 10             	add    $0x10,%esp
      ca:	85 c0                	test   %eax,%eax
      cc:	74 25                	je     f3 <getcputime+0x60>
  for(int i = 0; i < size; ++i){
      ce:	83 c6 01             	add    $0x1,%esi
      d1:	83 c3 60             	add    $0x60,%ebx
      d4:	39 75 e0             	cmp    %esi,-0x20(%ebp)
      d7:	75 de                	jne    b7 <getcputime+0x24>
    printf(2, "FAILED: Test program \"%s\" not found in table returned by getprocs\n", name);
      d9:	83 ec 04             	sub    $0x4,%esp
      dc:	57                   	push   %edi
      dd:	68 34 12 00 00       	push   $0x1234
      e2:	6a 02                	push   $0x2
      e4:	e8 98 0d 00 00       	call   e81 <printf>
    return -1;
      e9:	83 c4 10             	add    $0x10,%esp
      ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      f1:	eb 0a                	jmp    fd <getcputime+0x6a>
  if(p == 0){
      f3:	85 db                	test   %ebx,%ebx
      f5:	74 e2                	je     d9 <getcputime+0x46>
    return p->CPU_total_ticks;
      f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      fa:	8b 40 18             	mov    0x18(%eax),%eax
}
      fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     100:	5b                   	pop    %ebx
     101:	5e                   	pop    %esi
     102:	5f                   	pop    %edi
     103:	5d                   	pop    %ebp
     104:	c3                   	ret    

00000105 <testuid>:
testuid(uint new_val, uint expected_get_val, int expected_set_ret){
     105:	55                   	push   %ebp
     106:	89 e5                	mov    %esp,%ebp
     108:	57                   	push   %edi
     109:	56                   	push   %esi
     10a:	53                   	push   %ebx
     10b:	83 ec 1c             	sub    $0x1c,%esp
     10e:	89 c6                	mov    %eax,%esi
     110:	89 55 e4             	mov    %edx,-0x1c(%ebp)
     113:	89 cf                	mov    %ecx,%edi
  pre_uid = getuid();
     115:	e8 ad 0c 00 00       	call   dc7 <getuid>
     11a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  ret = setuid(new_val);
     11d:	83 ec 0c             	sub    $0xc,%esp
     120:	56                   	push   %esi
     121:	e8 b9 0c 00 00       	call   ddf <setuid>
  if((ret < 0 && expected_set_ret >= 0) || (ret >= 0 && expected_set_ret < 0)){
     126:	89 c1                	mov    %eax,%ecx
     128:	c1 e9 1f             	shr    $0x1f,%ecx
     12b:	89 fa                	mov    %edi,%edx
     12d:	c1 ea 1f             	shr    $0x1f,%edx
     130:	83 c4 10             	add    $0x10,%esp
  int success = 0;
     133:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((ret < 0 && expected_set_ret >= 0) || (ret >= 0 && expected_set_ret < 0)){
     138:	38 d1                	cmp    %dl,%cl
     13a:	75 14                	jne    150 <testuid+0x4b>
  post_uid = getuid();
     13c:	e8 86 0c 00 00       	call   dc7 <getuid>
  if(post_uid != expected_get_val){
     141:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     144:	75 26                	jne    16c <testuid+0x67>
}
     146:	89 d8                	mov    %ebx,%eax
     148:	8d 65 f4             	lea    -0xc(%ebp),%esp
     14b:	5b                   	pop    %ebx
     14c:	5e                   	pop    %esi
     14d:	5f                   	pop    %edi
     14e:	5d                   	pop    %ebp
     14f:	c3                   	ret    
    printf(2, "FAILED: setuid(%d) returned %d, expected %d\n", new_val, ret, expected_set_ret);
     150:	83 ec 0c             	sub    $0xc,%esp
     153:	57                   	push   %edi
     154:	50                   	push   %eax
     155:	56                   	push   %esi
     156:	68 78 12 00 00       	push   $0x1278
     15b:	6a 02                	push   $0x2
     15d:	e8 1f 0d 00 00       	call   e81 <printf>
     162:	83 c4 20             	add    $0x20,%esp
    success = -1;
     165:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
     16a:	eb d0                	jmp    13c <testuid+0x37>
    printf(2, "FAILED: UID was %d. After setuid(%d), getuid() returned %d, expected %d\n",
     16c:	83 ec 08             	sub    $0x8,%esp
     16f:	ff 75 e4             	pushl  -0x1c(%ebp)
     172:	50                   	push   %eax
     173:	56                   	push   %esi
     174:	ff 75 e0             	pushl  -0x20(%ebp)
     177:	68 a8 12 00 00       	push   $0x12a8
     17c:	6a 02                	push   $0x2
     17e:	e8 fe 0c 00 00       	call   e81 <printf>
     183:	83 c4 20             	add    $0x20,%esp
    success = -1;
     186:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  return success;
     18b:	eb b9                	jmp    146 <testuid+0x41>

0000018d <testgid>:
testgid(uint new_val, uint expected_get_val, int expected_set_ret){
     18d:	55                   	push   %ebp
     18e:	89 e5                	mov    %esp,%ebp
     190:	57                   	push   %edi
     191:	56                   	push   %esi
     192:	53                   	push   %ebx
     193:	83 ec 1c             	sub    $0x1c,%esp
     196:	89 c6                	mov    %eax,%esi
     198:	89 55 e4             	mov    %edx,-0x1c(%ebp)
     19b:	89 cf                	mov    %ecx,%edi
  pre_gid = getgid();
     19d:	e8 2d 0c 00 00       	call   dcf <getgid>
     1a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  ret = setgid(new_val);
     1a5:	83 ec 0c             	sub    $0xc,%esp
     1a8:	56                   	push   %esi
     1a9:	e8 39 0c 00 00       	call   de7 <setgid>
  if((ret < 0 && expected_set_ret >= 0) || (ret >= 0 && expected_set_ret < 0)){
     1ae:	89 c1                	mov    %eax,%ecx
     1b0:	c1 e9 1f             	shr    $0x1f,%ecx
     1b3:	89 fa                	mov    %edi,%edx
     1b5:	c1 ea 1f             	shr    $0x1f,%edx
     1b8:	83 c4 10             	add    $0x10,%esp
  int success = 0;
     1bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((ret < 0 && expected_set_ret >= 0) || (ret >= 0 && expected_set_ret < 0)){
     1c0:	38 d1                	cmp    %dl,%cl
     1c2:	75 14                	jne    1d8 <testgid+0x4b>
  post_gid = getgid();
     1c4:	e8 06 0c 00 00       	call   dcf <getgid>
  if(post_gid != expected_get_val){
     1c9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     1cc:	75 26                	jne    1f4 <testgid+0x67>
}
     1ce:	89 d8                	mov    %ebx,%eax
     1d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
     1d3:	5b                   	pop    %ebx
     1d4:	5e                   	pop    %esi
     1d5:	5f                   	pop    %edi
     1d6:	5d                   	pop    %ebp
     1d7:	c3                   	ret    
    printf(2, "FAILED: setgid(%d) returned %d, expected %d\n", new_val, ret, expected_set_ret);
     1d8:	83 ec 0c             	sub    $0xc,%esp
     1db:	57                   	push   %edi
     1dc:	50                   	push   %eax
     1dd:	56                   	push   %esi
     1de:	68 f4 12 00 00       	push   $0x12f4
     1e3:	6a 02                	push   $0x2
     1e5:	e8 97 0c 00 00       	call   e81 <printf>
     1ea:	83 c4 20             	add    $0x20,%esp
    success = -1;
     1ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
     1f2:	eb d0                	jmp    1c4 <testgid+0x37>
    printf(2, "FAILED: UID was %d. After setgid(%d), getgid() returned %d, expected %d\n",
     1f4:	83 ec 08             	sub    $0x8,%esp
     1f7:	ff 75 e4             	pushl  -0x1c(%ebp)
     1fa:	50                   	push   %eax
     1fb:	56                   	push   %esi
     1fc:	ff 75 e0             	pushl  -0x20(%ebp)
     1ff:	68 24 13 00 00       	push   $0x1324
     204:	6a 02                	push   $0x2
     206:	e8 76 0c 00 00       	call   e81 <printf>
     20b:	83 c4 20             	add    $0x20,%esp
    success = -1;
     20e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  return success;
     213:	eb b9                	jmp    1ce <testgid+0x41>

00000215 <testtimewitharg>:
#endif

#ifdef TIME_TEST
// Forks a process and execs with time + args to see how it handles no args, invalid args, mulitple args
void
testtimewitharg(char **arg){
     215:	55                   	push   %ebp
     216:	89 e5                	mov    %esp,%ebp
     218:	83 ec 08             	sub    $0x8,%esp
  int ret;

  ret = fork();
     21b:	e8 ef 0a 00 00       	call   d0f <fork>
  if (ret == 0){
     220:	85 c0                	test   %eax,%eax
     222:	74 0c                	je     230 <testtimewitharg+0x1b>
    exec(arg[0], arg);
    printf(2, "FAILED: exec failed to execute %s\n", arg[0]);
    exit();
  }
  else if(ret == -1){
     224:	83 f8 ff             	cmp    $0xffffffff,%eax
     227:	74 30                	je     259 <testtimewitharg+0x44>
    printf(2, "FAILED: fork failed\n");
  }
  else
    wait();
     229:	e8 f1 0a 00 00       	call   d1f <wait>
}
     22e:	c9                   	leave  
     22f:	c3                   	ret    
    exec(arg[0], arg);
     230:	83 ec 08             	sub    $0x8,%esp
     233:	ff 75 08             	pushl  0x8(%ebp)
     236:	8b 45 08             	mov    0x8(%ebp),%eax
     239:	ff 30                	pushl  (%eax)
     23b:	e8 0f 0b 00 00       	call   d4f <exec>
    printf(2, "FAILED: exec failed to execute %s\n", arg[0]);
     240:	83 c4 0c             	add    $0xc,%esp
     243:	8b 45 08             	mov    0x8(%ebp),%eax
     246:	ff 30                	pushl  (%eax)
     248:	68 70 13 00 00       	push   $0x1370
     24d:	6a 02                	push   $0x2
     24f:	e8 2d 0c 00 00       	call   e81 <printf>
    exit();
     254:	e8 be 0a 00 00       	call   d17 <exit>
    printf(2, "FAILED: fork failed\n");
     259:	83 ec 08             	sub    $0x8,%esp
     25c:	68 fc 16 00 00       	push   $0x16fc
     261:	6a 02                	push   $0x2
     263:	e8 19 0c 00 00       	call   e81 <printf>
     268:	83 c4 10             	add    $0x10,%esp
     26b:	eb c1                	jmp    22e <testtimewitharg+0x19>

0000026d <testtime>:
void
testtime(void){
     26d:	55                   	push   %ebp
     26e:	89 e5                	mov    %esp,%ebp
     270:	57                   	push   %edi
     271:	56                   	push   %esi
     272:	53                   	push   %ebx
     273:	83 ec 28             	sub    $0x28,%esp
  char **arg1 = malloc(sizeof(char *));
     276:	6a 04                	push   $0x4
     278:	e8 42 0e 00 00       	call   10bf <malloc>
     27d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char **arg2 = malloc(sizeof(char *)*2);
     280:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     287:	e8 33 0e 00 00       	call   10bf <malloc>
     28c:	89 c7                	mov    %eax,%edi
  char **arg3 = malloc(sizeof(char *)*2);
     28e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     295:	e8 25 0e 00 00       	call   10bf <malloc>
     29a:	89 c6                	mov    %eax,%esi
  char **arg4 = malloc(sizeof(char *)*4);
     29c:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
     2a3:	e8 17 0e 00 00       	call   10bf <malloc>
     2a8:	89 c3                	mov    %eax,%ebx

  arg1[0] = malloc(sizeof(char) * 5);
     2aa:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     2b1:	e8 09 0e 00 00       	call   10bf <malloc>
     2b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     2b9:	89 02                	mov    %eax,(%edx)
  strcpy(arg1[0], "time");
     2bb:	83 c4 08             	add    $0x8,%esp
     2be:	68 11 17 00 00       	push   $0x1711
     2c3:	50                   	push   %eax
     2c4:	e8 f1 07 00 00       	call   aba <strcpy>

  arg2[0] = malloc(sizeof(char) * 5);
     2c9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     2d0:	e8 ea 0d 00 00       	call   10bf <malloc>
     2d5:	89 07                	mov    %eax,(%edi)
  strcpy(arg2[0], "time");
     2d7:	83 c4 08             	add    $0x8,%esp
     2da:	68 11 17 00 00       	push   $0x1711
     2df:	50                   	push   %eax
     2e0:	e8 d5 07 00 00       	call   aba <strcpy>
  arg2[1] = malloc(sizeof(char) * 4);
     2e5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     2ec:	e8 ce 0d 00 00       	call   10bf <malloc>
     2f1:	89 47 04             	mov    %eax,0x4(%edi)
  strcpy(arg2[1], "abc");
     2f4:	83 c4 08             	add    $0x8,%esp
     2f7:	68 16 17 00 00       	push   $0x1716
     2fc:	50                   	push   %eax
     2fd:	e8 b8 07 00 00       	call   aba <strcpy>

  arg3[0] = malloc(sizeof(char) * 5);
     302:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     309:	e8 b1 0d 00 00       	call   10bf <malloc>
     30e:	89 06                	mov    %eax,(%esi)
  strcpy(arg3[0], "time");
     310:	83 c4 08             	add    $0x8,%esp
     313:	68 11 17 00 00       	push   $0x1711
     318:	50                   	push   %eax
     319:	e8 9c 07 00 00       	call   aba <strcpy>
  arg3[1] = malloc(sizeof(char) * 5);
     31e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     325:	e8 95 0d 00 00       	call   10bf <malloc>
     32a:	89 46 04             	mov    %eax,0x4(%esi)
  strcpy(arg3[1], "date");
     32d:	83 c4 08             	add    $0x8,%esp
     330:	68 1a 17 00 00       	push   $0x171a
     335:	50                   	push   %eax
     336:	e8 7f 07 00 00       	call   aba <strcpy>

  arg4[0] = malloc(sizeof(char) * 5);
     33b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     342:	e8 78 0d 00 00       	call   10bf <malloc>
     347:	89 03                	mov    %eax,(%ebx)
  strcpy(arg4[0], "time");
     349:	83 c4 08             	add    $0x8,%esp
     34c:	68 11 17 00 00       	push   $0x1711
     351:	50                   	push   %eax
     352:	e8 63 07 00 00       	call   aba <strcpy>
  arg4[1] = malloc(sizeof(char) * 5);
     357:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     35e:	e8 5c 0d 00 00       	call   10bf <malloc>
     363:	89 43 04             	mov    %eax,0x4(%ebx)
  strcpy(arg4[1], "time");
     366:	83 c4 08             	add    $0x8,%esp
     369:	68 11 17 00 00       	push   $0x1711
     36e:	50                   	push   %eax
     36f:	e8 46 07 00 00       	call   aba <strcpy>
  arg4[2] = malloc(sizeof(char) * 5);
     374:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     37b:	e8 3f 0d 00 00       	call   10bf <malloc>
     380:	89 43 08             	mov    %eax,0x8(%ebx)
  strcpy(arg4[2], "echo");
     383:	83 c4 08             	add    $0x8,%esp
     386:	68 1f 17 00 00       	push   $0x171f
     38b:	50                   	push   %eax
     38c:	e8 29 07 00 00       	call   aba <strcpy>
  arg4[3] = malloc(sizeof(char) * 6);
     391:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
     398:	e8 22 0d 00 00       	call   10bf <malloc>
     39d:	89 43 0c             	mov    %eax,0xc(%ebx)
  strcpy(arg4[3], "\"abc\"");
     3a0:	83 c4 08             	add    $0x8,%esp
     3a3:	68 24 17 00 00       	push   $0x1724
     3a8:	50                   	push   %eax
     3a9:	e8 0c 07 00 00       	call   aba <strcpy>

  printf(1, "\n----------\nRunning Time Test\n----------\n");
     3ae:	83 c4 08             	add    $0x8,%esp
     3b1:	68 94 13 00 00       	push   $0x1394
     3b6:	6a 01                	push   $0x1
     3b8:	e8 c4 0a 00 00       	call   e81 <printf>
  printf(1, "You will need to verify these tests passed\n");
     3bd:	83 c4 08             	add    $0x8,%esp
     3c0:	68 c0 13 00 00       	push   $0x13c0
     3c5:	6a 01                	push   $0x1
     3c7:	e8 b5 0a 00 00       	call   e81 <printf>

  printf(1,"\n%s\n", arg1[0]);
     3cc:	83 c4 0c             	add    $0xc,%esp
     3cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     3d2:	ff 32                	pushl  (%edx)
     3d4:	68 2a 17 00 00       	push   $0x172a
     3d9:	6a 01                	push   $0x1
     3db:	e8 a1 0a 00 00       	call   e81 <printf>
  testtimewitharg(arg1);
     3e0:	83 c4 04             	add    $0x4,%esp
     3e3:	ff 75 e4             	pushl  -0x1c(%ebp)
     3e6:	e8 2a fe ff ff       	call   215 <testtimewitharg>
  printf(1,"\n%s %s\n", arg2[0], arg2[1]);
     3eb:	ff 77 04             	pushl  0x4(%edi)
     3ee:	ff 37                	pushl  (%edi)
     3f0:	68 2f 17 00 00       	push   $0x172f
     3f5:	6a 01                	push   $0x1
     3f7:	e8 85 0a 00 00       	call   e81 <printf>
  testtimewitharg(arg2);
     3fc:	83 c4 14             	add    $0x14,%esp
     3ff:	57                   	push   %edi
     400:	e8 10 fe ff ff       	call   215 <testtimewitharg>
  printf(1,"\n%s %s\n", arg3[0], arg3[1]);
     405:	ff 76 04             	pushl  0x4(%esi)
     408:	ff 36                	pushl  (%esi)
     40a:	68 2f 17 00 00       	push   $0x172f
     40f:	6a 01                	push   $0x1
     411:	e8 6b 0a 00 00       	call   e81 <printf>
  testtimewitharg(arg3);
     416:	83 c4 14             	add    $0x14,%esp
     419:	56                   	push   %esi
     41a:	e8 f6 fd ff ff       	call   215 <testtimewitharg>
  printf(1,"\n%s %s %s %s\n", arg4[0], arg4[1], arg4[2], arg4[3]);
     41f:	83 c4 08             	add    $0x8,%esp
     422:	ff 73 0c             	pushl  0xc(%ebx)
     425:	ff 73 08             	pushl  0x8(%ebx)
     428:	ff 73 04             	pushl  0x4(%ebx)
     42b:	ff 33                	pushl  (%ebx)
     42d:	68 37 17 00 00       	push   $0x1737
     432:	6a 01                	push   $0x1
     434:	e8 48 0a 00 00       	call   e81 <printf>
  testtimewitharg(arg4);
     439:	83 c4 14             	add    $0x14,%esp
     43c:	53                   	push   %ebx
     43d:	e8 d3 fd ff ff       	call   215 <testtimewitharg>

  free(arg1[0]);
     442:	83 c4 04             	add    $0x4,%esp
     445:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     448:	ff 32                	pushl  (%edx)
     44a:	e8 02 0c 00 00       	call   1051 <free>
  free(arg1);
     44f:	83 c4 04             	add    $0x4,%esp
     452:	ff 75 e4             	pushl  -0x1c(%ebp)
     455:	e8 f7 0b 00 00       	call   1051 <free>
  free(arg2[0]); free(arg2[1]);
     45a:	83 c4 04             	add    $0x4,%esp
     45d:	ff 37                	pushl  (%edi)
     45f:	e8 ed 0b 00 00       	call   1051 <free>
     464:	83 c4 04             	add    $0x4,%esp
     467:	ff 77 04             	pushl  0x4(%edi)
     46a:	e8 e2 0b 00 00       	call   1051 <free>
  free(arg2);
     46f:	89 3c 24             	mov    %edi,(%esp)
     472:	e8 da 0b 00 00       	call   1051 <free>
  free(arg3[0]); free(arg3[1]);
     477:	83 c4 04             	add    $0x4,%esp
     47a:	ff 36                	pushl  (%esi)
     47c:	e8 d0 0b 00 00       	call   1051 <free>
     481:	83 c4 04             	add    $0x4,%esp
     484:	ff 76 04             	pushl  0x4(%esi)
     487:	e8 c5 0b 00 00       	call   1051 <free>
  free(arg3);
     48c:	89 34 24             	mov    %esi,(%esp)
     48f:	e8 bd 0b 00 00       	call   1051 <free>
  free(arg4[0]); free(arg4[1]); free(arg4[2]); free(arg4[3]);
     494:	83 c4 04             	add    $0x4,%esp
     497:	ff 33                	pushl  (%ebx)
     499:	e8 b3 0b 00 00       	call   1051 <free>
     49e:	83 c4 04             	add    $0x4,%esp
     4a1:	ff 73 04             	pushl  0x4(%ebx)
     4a4:	e8 a8 0b 00 00       	call   1051 <free>
     4a9:	83 c4 04             	add    $0x4,%esp
     4ac:	ff 73 08             	pushl  0x8(%ebx)
     4af:	e8 9d 0b 00 00       	call   1051 <free>
     4b4:	83 c4 04             	add    $0x4,%esp
     4b7:	ff 73 0c             	pushl  0xc(%ebx)
     4ba:	e8 92 0b 00 00       	call   1051 <free>
  free(arg4);
     4bf:	89 1c 24             	mov    %ebx,(%esp)
     4c2:	e8 8a 0b 00 00       	call   1051 <free>
}
     4c7:	83 c4 10             	add    $0x10,%esp
     4ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
     4cd:	5b                   	pop    %ebx
     4ce:	5e                   	pop    %esi
     4cf:	5f                   	pop    %edi
     4d0:	5d                   	pop    %ebp
     4d1:	c3                   	ret    

000004d2 <main>:
#endif

int
main(int argc, char *argv[])
{
     4d2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     4d6:	83 e4 f0             	and    $0xfffffff0,%esp
     4d9:	ff 71 fc             	pushl  -0x4(%ecx)
     4dc:	55                   	push   %ebp
     4dd:	89 e5                	mov    %esp,%ebp
     4df:	57                   	push   %edi
     4e0:	56                   	push   %esi
     4e1:	53                   	push   %ebx
     4e2:	51                   	push   %ecx
     4e3:	83 ec 20             	sub    $0x20,%esp
     4e6:	8b 41 04             	mov    0x4(%ecx),%eax
  #ifdef CPUTIME_TEST
  testcputime(argv[0]);
     4e9:	8b 00                	mov    (%eax),%eax
     4eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  printf(1, "\n----------\nRunning CPU Time Test\n----------\n");
     4ee:	68 ec 13 00 00       	push   $0x13ec
     4f3:	6a 01                	push   $0x1
     4f5:	e8 87 09 00 00       	call   e81 <printf>
  table = malloc(sizeof(struct uproc) * 64);
     4fa:	c7 04 24 00 18 00 00 	movl   $0x1800,(%esp)
     501:	e8 b9 0b 00 00       	call   10bf <malloc>
  if (!table) {
     506:	83 c4 10             	add    $0x10,%esp
     509:	85 c0                	test   %eax,%eax
     50b:	74 34                	je     541 <main+0x6f>
     50d:	89 c7                	mov    %eax,%edi
  printf(1, "This will take a couple seconds\n");
     50f:	83 ec 08             	sub    $0x8,%esp
     512:	68 1c 14 00 00       	push   $0x141c
     517:	6a 01                	push   $0x1
     519:	e8 63 09 00 00       	call   e81 <printf>
  time1 = getcputime(name, table);
     51e:	89 fa                	mov    %edi,%edx
     520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     523:	e8 6b fb ff ff       	call   93 <getcputime>
     528:	89 45 d8             	mov    %eax,-0x28(%ebp)
     52b:	83 c4 10             	add    $0x10,%esp
    ++num;
     52e:	bb 01 00 00 00       	mov    $0x1,%ebx
  int success = 0;
     533:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    if(num % 100000 == 0){
     53a:	be 89 b5 f8 14       	mov    $0x14f8b589,%esi
     53f:	eb 23                	jmp    564 <main+0x92>
    printf(2, "Error: malloc() call failed. %s at line %d\n", __FUNCTION__, __LINE__);
     541:	68 c1 00 00 00       	push   $0xc1
     546:	68 0c 18 00 00       	push   $0x180c
     54b:	68 98 11 00 00       	push   $0x1198
     550:	6a 02                	push   $0x2
     552:	e8 2a 09 00 00       	call   e81 <printf>
    exit();
     557:	e8 bb 07 00 00       	call   d17 <exit>
  for(i = 0, num = 0; i < 1000000; ++i){
     55c:	81 fb 40 42 0f 00    	cmp    $0xf4240,%ebx
     562:	74 65                	je     5c9 <main+0xf7>
    ++num;
     564:	83 c3 01             	add    $0x1,%ebx
    if(num % 100000 == 0){
     567:	89 d8                	mov    %ebx,%eax
     569:	f7 ee                	imul   %esi
     56b:	c1 fa 0d             	sar    $0xd,%edx
     56e:	89 d8                	mov    %ebx,%eax
     570:	c1 f8 1f             	sar    $0x1f,%eax
     573:	29 c2                	sub    %eax,%edx
     575:	69 d2 a0 86 01 00    	imul   $0x186a0,%edx,%edx
     57b:	39 d3                	cmp    %edx,%ebx
     57d:	75 dd                	jne    55c <main+0x8a>
      pre_sleep = getcputime(name, table);
     57f:	89 fa                	mov    %edi,%edx
     581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     584:	e8 0a fb ff ff       	call   93 <getcputime>
     589:	89 45 e0             	mov    %eax,-0x20(%ebp)
      sleep(200);
     58c:	83 ec 0c             	sub    $0xc,%esp
     58f:	68 c8 00 00 00       	push   $0xc8
     594:	e8 0e 08 00 00       	call   da7 <sleep>
      post_sleep = getcputime(name, table);
     599:	89 fa                	mov    %edi,%edx
     59b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     59e:	e8 f0 fa ff ff       	call   93 <getcputime>
      if((post_sleep - pre_sleep) >= 100){
     5a3:	2b 45 e0             	sub    -0x20(%ebp),%eax
     5a6:	83 c4 10             	add    $0x10,%esp
     5a9:	83 f8 63             	cmp    $0x63,%eax
     5ac:	76 ae                	jbe    55c <main+0x8a>
        printf(2, "FAILED: CPU_total_ticks changed by 100+ milliseconds while process was asleep\n");
     5ae:	83 ec 08             	sub    $0x8,%esp
     5b1:	68 40 14 00 00       	push   $0x1440
     5b6:	6a 02                	push   $0x2
     5b8:	e8 c4 08 00 00       	call   e81 <printf>
     5bd:	83 c4 10             	add    $0x10,%esp
        success = -1;
     5c0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
     5c7:	eb 93                	jmp    55c <main+0x8a>
  time2 = getcputime(name, table);
     5c9:	89 fa                	mov    %edi,%edx
     5cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5ce:	e8 c0 fa ff ff       	call   93 <getcputime>
  if((time2 - time1) > 400){
     5d3:	2b 45 d8             	sub    -0x28(%ebp),%eax
     5d6:	89 c3                	mov    %eax,%ebx
     5d8:	3d 90 01 00 00       	cmp    $0x190,%eax
     5dd:	0f 87 a2 01 00 00    	ja     785 <main+0x2b3>
  printf(1, "T2 - T1 = %d milliseconds\n", (time2 - time1));
     5e3:	83 ec 04             	sub    $0x4,%esp
     5e6:	50                   	push   %eax
     5e7:	68 45 17 00 00       	push   $0x1745
     5ec:	6a 01                	push   $0x1
     5ee:	e8 8e 08 00 00       	call   e81 <printf>
  free(table);
     5f3:	89 3c 24             	mov    %edi,(%esp)
     5f6:	e8 56 0a 00 00       	call   1051 <free>
  if(success == 0)
     5fb:	83 c4 10             	add    $0x10,%esp
     5fe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
     602:	75 12                	jne    616 <main+0x144>
    printf(1, "** All Tests Passed! **\n");
     604:	83 ec 08             	sub    $0x8,%esp
     607:	68 60 17 00 00       	push   $0x1760
     60c:	6a 01                	push   $0x1
     60e:	e8 6e 08 00 00       	call   e81 <printf>
     613:	83 c4 10             	add    $0x10,%esp
  printf(1, "\n----------\nRunning UID / GID Tests\n----------\n");
     616:	83 ec 08             	sub    $0x8,%esp
     619:	68 d0 14 00 00       	push   $0x14d0
     61e:	6a 01                	push   $0x1
     620:	e8 5c 08 00 00       	call   e81 <printf>
  uid = getuid();
     625:	e8 9d 07 00 00       	call   dc7 <getuid>
  if(uid < 0 || uid > 32767){
     62a:	83 c4 10             	add    $0x10,%esp
  int success = 0;
     62d:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(uid < 0 || uid > 32767){
     632:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
     637:	0f 87 78 01 00 00    	ja     7b5 <main+0x2e3>
  if (testuid(0, 0, 0))
     63d:	b9 00 00 00 00       	mov    $0x0,%ecx
     642:	ba 00 00 00 00       	mov    $0x0,%edx
     647:	b8 00 00 00 00       	mov    $0x0,%eax
     64c:	e8 b4 fa ff ff       	call   105 <testuid>
    success = -1;
     651:	85 c0                	test   %eax,%eax
     653:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     658:	0f 45 d8             	cmovne %eax,%ebx
  if (testuid(5, 5, 0))
     65b:	b9 00 00 00 00       	mov    $0x0,%ecx
     660:	ba 05 00 00 00       	mov    $0x5,%edx
     665:	b8 05 00 00 00       	mov    $0x5,%eax
     66a:	e8 96 fa ff ff       	call   105 <testuid>
    success = -1;
     66f:	85 c0                	test   %eax,%eax
     671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     676:	0f 45 d8             	cmovne %eax,%ebx
  if (testuid(32767, 32767, 0))
     679:	b9 00 00 00 00       	mov    $0x0,%ecx
     67e:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     683:	b8 ff 7f 00 00       	mov    $0x7fff,%eax
     688:	e8 78 fa ff ff       	call   105 <testuid>
    success = -1;
     68d:	85 c0                	test   %eax,%eax
     68f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     694:	0f 45 d8             	cmovne %eax,%ebx
  if (testuid(32768, 32767, -1))
     697:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
     69c:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     6a1:	b8 00 80 00 00       	mov    $0x8000,%eax
     6a6:	e8 5a fa ff ff       	call   105 <testuid>
    success = -1;
     6ab:	85 c0                	test   %eax,%eax
     6ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     6b2:	0f 45 d8             	cmovne %eax,%ebx
  if (testuid(-1, 32767, -1))
     6b5:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
     6ba:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     6bf:	e8 41 fa ff ff       	call   105 <testuid>
    success = -1;
     6c4:	85 c0                	test   %eax,%eax
     6c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     6cb:	0f 45 d8             	cmovne %eax,%ebx
  gid = getgid();
     6ce:	e8 fc 06 00 00       	call   dcf <getgid>
  if(gid < 0 || gid > 32767){
     6d3:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
     6d8:	0f 87 f4 00 00 00    	ja     7d2 <main+0x300>
  if (testgid(0, 0, 0))
     6de:	b9 00 00 00 00       	mov    $0x0,%ecx
     6e3:	ba 00 00 00 00       	mov    $0x0,%edx
     6e8:	b8 00 00 00 00       	mov    $0x0,%eax
     6ed:	e8 9b fa ff ff       	call   18d <testgid>
    success = -1;
     6f2:	85 c0                	test   %eax,%eax
     6f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     6f9:	0f 45 d8             	cmovne %eax,%ebx
  if (testgid(5, 5, 0))
     6fc:	b9 00 00 00 00       	mov    $0x0,%ecx
     701:	ba 05 00 00 00       	mov    $0x5,%edx
     706:	b8 05 00 00 00       	mov    $0x5,%eax
     70b:	e8 7d fa ff ff       	call   18d <testgid>
    success = -1;
     710:	85 c0                	test   %eax,%eax
     712:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     717:	0f 45 d8             	cmovne %eax,%ebx
  if (testgid(32767, 32767, 0))
     71a:	b9 00 00 00 00       	mov    $0x0,%ecx
     71f:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     724:	b8 ff 7f 00 00       	mov    $0x7fff,%eax
     729:	e8 5f fa ff ff       	call   18d <testgid>
     72e:	85 c0                	test   %eax,%eax
     730:	0f 85 4f 03 00 00    	jne    a85 <main+0x5b3>
  if (testgid(-1, 32767, -1))
     736:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
     73b:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     745:	e8 43 fa ff ff       	call   18d <testgid>
     74a:	85 c0                	test   %eax,%eax
     74c:	0f 85 5d 02 00 00    	jne    9af <main+0x4dd>
  if (testgid(32768, 32767, -1))
     752:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
     757:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     75c:	b8 00 80 00 00       	mov    $0x8000,%eax
     761:	e8 27 fa ff ff       	call   18d <testgid>
  if (success == 0)
     766:	09 d8                	or     %ebx,%eax
     768:	0f 85 55 02 00 00    	jne    9c3 <main+0x4f1>
    printf(1, "** All tests passed! **\n");
     76e:	83 ec 08             	sub    $0x8,%esp
     771:	68 79 17 00 00       	push   $0x1779
     776:	6a 01                	push   $0x1
     778:	e8 04 07 00 00       	call   e81 <printf>
     77d:	83 c4 10             	add    $0x10,%esp
     780:	e9 3e 02 00 00       	jmp    9c3 <main+0x4f1>
    printf(2, "ABNORMALLY HIGH: T2 - T1 = %d milliseconds.  Run test again\n", (time2 - time1));
     785:	83 ec 04             	sub    $0x4,%esp
     788:	50                   	push   %eax
     789:	68 90 14 00 00       	push   $0x1490
     78e:	6a 02                	push   $0x2
     790:	e8 ec 06 00 00       	call   e81 <printf>
  printf(1, "T2 - T1 = %d milliseconds\n", (time2 - time1));
     795:	83 c4 0c             	add    $0xc,%esp
     798:	53                   	push   %ebx
     799:	68 45 17 00 00       	push   $0x1745
     79e:	6a 01                	push   $0x1
     7a0:	e8 dc 06 00 00       	call   e81 <printf>
  free(table);
     7a5:	89 3c 24             	mov    %edi,(%esp)
     7a8:	e8 a4 08 00 00       	call   1051 <free>
     7ad:	83 c4 10             	add    $0x10,%esp
     7b0:	e9 61 fe ff ff       	jmp    616 <main+0x144>
    printf(1, "FAILED: Default UID %d, out of range\n", uid);
     7b5:	83 ec 04             	sub    $0x4,%esp
     7b8:	50                   	push   %eax
     7b9:	68 00 15 00 00       	push   $0x1500
     7be:	6a 01                	push   $0x1
     7c0:	e8 bc 06 00 00       	call   e81 <printf>
     7c5:	83 c4 10             	add    $0x10,%esp
    success = -1;
     7c8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
     7cd:	e9 6b fe ff ff       	jmp    63d <main+0x16b>
    printf(1, "FAILED: Default GID %d, out of range\n", gid);
     7d2:	83 ec 04             	sub    $0x4,%esp
     7d5:	50                   	push   %eax
     7d6:	68 28 15 00 00       	push   $0x1528
     7db:	6a 01                	push   $0x1
     7dd:	e8 9f 06 00 00       	call   e81 <printf>
     7e2:	83 c4 10             	add    $0x10,%esp
    success = -1;
     7e5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
     7ea:	e9 ef fe ff ff       	jmp    6de <main+0x20c>
  ret = fork();
     7ef:	e8 1b 05 00 00       	call   d0f <fork>
  if(ret == 0){
     7f4:	85 c0                	test   %eax,%eax
     7f6:	74 0a                	je     802 <main+0x330>
    wait();
     7f8:	e8 22 05 00 00       	call   d1f <wait>
     7fd:	e9 0f 02 00 00       	jmp    a11 <main+0x53f>
    uid = getuid();
     802:	e8 c0 05 00 00       	call   dc7 <getuid>
     807:	89 c3                	mov    %eax,%ebx
    gid = getgid();
     809:	e8 c1 05 00 00       	call   dcf <getgid>
    if(uid != 12345){
     80e:	81 fb 39 30 00 00    	cmp    $0x3039,%ebx
     814:	74 18                	je     82e <main+0x35c>
      printf(2, "FAILED: Parent UID is 12345, child UID is %d\n", uid);
     816:	83 ec 04             	sub    $0x4,%esp
     819:	53                   	push   %ebx
     81a:	68 8c 15 00 00       	push   $0x158c
     81f:	6a 02                	push   $0x2
     821:	e8 5b 06 00 00       	call   e81 <printf>
     826:	83 c4 10             	add    $0x10,%esp
    exit();
     829:	e8 e9 04 00 00       	call   d17 <exit>
    else if(gid != 12345){
     82e:	3d 39 30 00 00       	cmp    $0x3039,%eax
     833:	74 15                	je     84a <main+0x378>
      printf(2, "FAILED: Parent GID is 12345, child GID is %d\n", gid);
     835:	83 ec 04             	sub    $0x4,%esp
     838:	50                   	push   %eax
     839:	68 bc 15 00 00       	push   $0x15bc
     83e:	6a 02                	push   $0x2
     840:	e8 3c 06 00 00       	call   e81 <printf>
     845:	83 c4 10             	add    $0x10,%esp
     848:	eb df                	jmp    829 <main+0x357>
      printf(1, "** Test Passed! **\n");
     84a:	83 ec 08             	sub    $0x8,%esp
     84d:	68 92 17 00 00       	push   $0x1792
     852:	6a 01                	push   $0x1
     854:	e8 28 06 00 00       	call   e81 <printf>
     859:	83 c4 10             	add    $0x10,%esp
     85c:	eb cb                	jmp    829 <main+0x357>
    ppid = getppid();
     85e:	e8 74 05 00 00       	call   dd7 <getppid>
    if(ppid != pid)
     863:	39 c3                	cmp    %eax,%ebx
     865:	74 16                	je     87d <main+0x3ab>
      printf(2, "FAILED: Parent PID is %d, Child's PPID is %d\n", pid, ppid);
     867:	50                   	push   %eax
     868:	53                   	push   %ebx
     869:	68 18 16 00 00       	push   $0x1618
     86e:	6a 02                	push   $0x2
     870:	e8 0c 06 00 00       	call   e81 <printf>
     875:	83 c4 10             	add    $0x10,%esp
    exit();
     878:	e8 9a 04 00 00       	call   d17 <exit>
      printf(1, "** Test passed! **\n");
     87d:	83 ec 08             	sub    $0x8,%esp
     880:	68 a6 17 00 00       	push   $0x17a6
     885:	6a 01                	push   $0x1
     887:	e8 f5 05 00 00       	call   e81 <printf>
     88c:	83 c4 10             	add    $0x10,%esp
     88f:	eb e7                	jmp    878 <main+0x3a6>
  table = malloc(sizeof(struct uproc));
     891:	83 ec 0c             	sub    $0xc,%esp
     894:	6a 60                	push   $0x60
     896:	e8 24 08 00 00       	call   10bf <malloc>
     89b:	89 c3                	mov    %eax,%ebx
  if (!table) {
     89d:	83 c4 10             	add    $0x10,%esp
     8a0:	85 c0                	test   %eax,%eax
     8a2:	74 6a                	je     90e <main+0x43c>
  ret = getprocs(1024, table);
     8a4:	83 ec 08             	sub    $0x8,%esp
     8a7:	50                   	push   %eax
     8a8:	68 00 04 00 00       	push   $0x400
     8ad:	e8 3d 05 00 00       	call   def <getprocs>
     8b2:	89 c6                	mov    %eax,%esi
  free(table);
     8b4:	89 1c 24             	mov    %ebx,(%esp)
     8b7:	e8 95 07 00 00       	call   1051 <free>
  if(ret >= 0){
     8bc:	83 c4 10             	add    $0x10,%esp
     8bf:	85 f6                	test   %esi,%esi
     8c1:	79 66                	jns    929 <main+0x457>
    success |= testprocarray( 1,  1);
     8c3:	ba 01 00 00 00       	mov    $0x1,%edx
     8c8:	b8 01 00 00 00       	mov    $0x1,%eax
     8cd:	e8 2e f7 ff ff       	call   0 <testprocarray>
     8d2:	89 c3                	mov    %eax,%ebx
    success |= testprocarray(16, 16);
     8d4:	ba 10 00 00 00       	mov    $0x10,%edx
     8d9:	b8 10 00 00 00       	mov    $0x10,%eax
     8de:	e8 1d f7 ff ff       	call   0 <testprocarray>
     8e3:	09 c3                	or     %eax,%ebx
    success |= testprocarray(64, 64);
     8e5:	ba 40 00 00 00       	mov    $0x40,%edx
     8ea:	b8 40 00 00 00       	mov    $0x40,%eax
     8ef:	e8 0c f7 ff ff       	call   0 <testprocarray>
     8f4:	09 c3                	or     %eax,%ebx
    success |= testprocarray(72, 64);
     8f6:	ba 40 00 00 00       	mov    $0x40,%edx
     8fb:	b8 48 00 00 00       	mov    $0x48,%eax
     900:	e8 fb f6 ff ff       	call   0 <testprocarray>
    if (success == 0)
     905:	09 c3                	or     %eax,%ebx
     907:	74 71                	je     97a <main+0x4a8>
    exit();
     909:	e8 09 04 00 00       	call   d17 <exit>
    printf(2, "Error: malloc() call failed. %s at line %d\n", __FUNCTION__, __LINE__);
     90e:	68 06 01 00 00       	push   $0x106
     913:	68 f8 17 00 00       	push   $0x17f8
     918:	68 98 11 00 00       	push   $0x1198
     91d:	6a 02                	push   $0x2
     91f:	e8 5d 05 00 00       	call   e81 <printf>
    exit();
     924:	e8 ee 03 00 00       	call   d17 <exit>
    printf(2, "FAILED: called getprocs with max way larger than table and returned %d, not error\n", ret);
     929:	83 ec 04             	sub    $0x4,%esp
     92c:	56                   	push   %esi
     92d:	68 a8 16 00 00       	push   $0x16a8
     932:	6a 02                	push   $0x2
     934:	e8 48 05 00 00       	call   e81 <printf>
    success |= testprocarray( 1,  1);
     939:	ba 01 00 00 00       	mov    $0x1,%edx
     93e:	b8 01 00 00 00       	mov    $0x1,%eax
     943:	e8 b8 f6 ff ff       	call   0 <testprocarray>
    success |= testprocarray(16, 16);
     948:	ba 10 00 00 00       	mov    $0x10,%edx
     94d:	b8 10 00 00 00       	mov    $0x10,%eax
     952:	e8 a9 f6 ff ff       	call   0 <testprocarray>
    success |= testprocarray(64, 64);
     957:	ba 40 00 00 00       	mov    $0x40,%edx
     95c:	b8 40 00 00 00       	mov    $0x40,%eax
     961:	e8 9a f6 ff ff       	call   0 <testprocarray>
    success |= testprocarray(72, 64);
     966:	ba 40 00 00 00       	mov    $0x40,%edx
     96b:	b8 48 00 00 00       	mov    $0x48,%eax
     970:	e8 8b f6 ff ff       	call   0 <testprocarray>
     975:	83 c4 10             	add    $0x10,%esp
     978:	eb 8f                	jmp    909 <main+0x437>
      printf(1, "** All Tests Passed **\n");
     97a:	83 ec 08             	sub    $0x8,%esp
     97d:	68 ba 17 00 00       	push   $0x17ba
     982:	6a 01                	push   $0x1
     984:	e8 f8 04 00 00       	call   e81 <printf>
     989:	83 c4 10             	add    $0x10,%esp
     98c:	e9 78 ff ff ff       	jmp    909 <main+0x437>
  wait();
     991:	e8 89 03 00 00       	call   d1f <wait>
  #endif
  #ifdef GETPROCS_TEST
  testgetprocs();  // no need to pass argv[0]
  #endif
  #ifdef TIME_TEST
  testtime();
     996:	e8 d2 f8 ff ff       	call   26d <testtime>
  #endif
  printf(1, "\n** End of Tests **\n");
     99b:	83 ec 08             	sub    $0x8,%esp
     99e:	68 d2 17 00 00       	push   $0x17d2
     9a3:	6a 01                	push   $0x1
     9a5:	e8 d7 04 00 00       	call   e81 <printf>
  exit();
     9aa:	e8 68 03 00 00       	call   d17 <exit>
  if (testgid(32768, 32767, -1))
     9af:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
     9b4:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     9b9:	b8 00 80 00 00       	mov    $0x8000,%eax
     9be:	e8 ca f7 ff ff       	call   18d <testgid>
  printf(1, "\n----------\nRunning UID / GID Inheritance Test\n----------\n");
     9c3:	83 ec 08             	sub    $0x8,%esp
     9c6:	68 50 15 00 00       	push   $0x1550
     9cb:	6a 01                	push   $0x1
     9cd:	e8 af 04 00 00       	call   e81 <printf>
  if (testuid(12345, 12345, 0))
     9d2:	b9 00 00 00 00       	mov    $0x0,%ecx
     9d7:	ba 39 30 00 00       	mov    $0x3039,%edx
     9dc:	b8 39 30 00 00       	mov    $0x3039,%eax
     9e1:	e8 1f f7 ff ff       	call   105 <testuid>
     9e6:	89 c3                	mov    %eax,%ebx
  if (testgid(12345, 12345, 0))
     9e8:	b9 00 00 00 00       	mov    $0x0,%ecx
     9ed:	ba 39 30 00 00       	mov    $0x3039,%edx
     9f2:	b8 39 30 00 00       	mov    $0x3039,%eax
     9f7:	e8 91 f7 ff ff       	call   18d <testgid>
  if (testuid(12345, 12345, 0))
     9fc:	83 c4 10             	add    $0x10,%esp
     9ff:	85 db                	test   %ebx,%ebx
     a01:	0f 95 c2             	setne  %dl
     a04:	0f b6 d2             	movzbl %dl,%edx
     a07:	f7 da                	neg    %edx
  if(success != 0)
     a09:	09 c2                	or     %eax,%edx
     a0b:	0f 84 de fd ff ff    	je     7ef <main+0x31d>
  printf(1, "\n----------\nRunning PPID Test\n----------\n");
     a11:	83 ec 08             	sub    $0x8,%esp
     a14:	68 ec 15 00 00       	push   $0x15ec
     a19:	6a 01                	push   $0x1
     a1b:	e8 61 04 00 00       	call   e81 <printf>
  pid = getpid();
     a20:	e8 72 03 00 00       	call   d97 <getpid>
     a25:	89 c3                	mov    %eax,%ebx
  ret = fork();
     a27:	e8 e3 02 00 00       	call   d0f <fork>
  if(ret == 0){
     a2c:	83 c4 10             	add    $0x10,%esp
     a2f:	85 c0                	test   %eax,%eax
     a31:	0f 84 27 fe ff ff    	je     85e <main+0x38c>
    wait();
     a37:	e8 e3 02 00 00       	call   d1f <wait>
  printf(1, "\n----------\nRunning GetProcs Test\n----------\n");
     a3c:	83 ec 08             	sub    $0x8,%esp
     a3f:	68 48 16 00 00       	push   $0x1648
     a44:	6a 01                	push   $0x1
     a46:	e8 36 04 00 00       	call   e81 <printf>
  printf(1, "Filling the proc[] array with dummy processes\n");
     a4b:	83 c4 08             	add    $0x8,%esp
     a4e:	68 78 16 00 00       	push   $0x1678
     a53:	6a 01                	push   $0x1
     a55:	e8 27 04 00 00       	call   e81 <printf>
  ret = fork();
     a5a:	e8 b0 02 00 00       	call   d0f <fork>
  if (ret == 0){
     a5f:	83 c4 10             	add    $0x10,%esp
     a62:	85 c0                	test   %eax,%eax
     a64:	0f 85 27 ff ff ff    	jne    991 <main+0x4bf>
    while((ret = fork()) == 0);
     a6a:	e8 a0 02 00 00       	call   d0f <fork>
     a6f:	85 c0                	test   %eax,%eax
     a71:	74 f7                	je     a6a <main+0x598>
    if(ret > 0){
     a73:	85 c0                	test   %eax,%eax
     a75:	0f 8e 16 fe ff ff    	jle    891 <main+0x3bf>
      wait();
     a7b:	e8 9f 02 00 00       	call   d1f <wait>
      exit();
     a80:	e8 92 02 00 00       	call   d17 <exit>
  if (testgid(-1, 32767, -1))
     a85:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
     a8a:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     a8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a94:	e8 f4 f6 ff ff       	call   18d <testgid>
     a99:	85 c0                	test   %eax,%eax
     a9b:	0f 85 0e ff ff ff    	jne    9af <main+0x4dd>
  if (testgid(32768, 32767, -1))
     aa1:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
     aa6:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     aab:	b8 00 80 00 00       	mov    $0x8000,%eax
     ab0:	e8 d8 f6 ff ff       	call   18d <testgid>
     ab5:	e9 09 ff ff ff       	jmp    9c3 <main+0x4f1>

00000aba <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     aba:	55                   	push   %ebp
     abb:	89 e5                	mov    %esp,%ebp
     abd:	53                   	push   %ebx
     abe:	8b 45 08             	mov    0x8(%ebp),%eax
     ac1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ac4:	89 c2                	mov    %eax,%edx
     ac6:	83 c1 01             	add    $0x1,%ecx
     ac9:	83 c2 01             	add    $0x1,%edx
     acc:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     ad0:	88 5a ff             	mov    %bl,-0x1(%edx)
     ad3:	84 db                	test   %bl,%bl
     ad5:	75 ef                	jne    ac6 <strcpy+0xc>
    ;
  return os;
}
     ad7:	5b                   	pop    %ebx
     ad8:	5d                   	pop    %ebp
     ad9:	c3                   	ret    

00000ada <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ada:	55                   	push   %ebp
     adb:	89 e5                	mov    %esp,%ebp
     add:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     ae3:	0f b6 01             	movzbl (%ecx),%eax
     ae6:	84 c0                	test   %al,%al
     ae8:	74 15                	je     aff <strcmp+0x25>
     aea:	3a 02                	cmp    (%edx),%al
     aec:	75 11                	jne    aff <strcmp+0x25>
    p++, q++;
     aee:	83 c1 01             	add    $0x1,%ecx
     af1:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     af4:	0f b6 01             	movzbl (%ecx),%eax
     af7:	84 c0                	test   %al,%al
     af9:	74 04                	je     aff <strcmp+0x25>
     afb:	3a 02                	cmp    (%edx),%al
     afd:	74 ef                	je     aee <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     aff:	0f b6 c0             	movzbl %al,%eax
     b02:	0f b6 12             	movzbl (%edx),%edx
     b05:	29 d0                	sub    %edx,%eax
}
     b07:	5d                   	pop    %ebp
     b08:	c3                   	ret    

00000b09 <strlen>:

uint
strlen(char *s)
{
     b09:	55                   	push   %ebp
     b0a:	89 e5                	mov    %esp,%ebp
     b0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     b0f:	80 39 00             	cmpb   $0x0,(%ecx)
     b12:	74 12                	je     b26 <strlen+0x1d>
     b14:	ba 00 00 00 00       	mov    $0x0,%edx
     b19:	83 c2 01             	add    $0x1,%edx
     b1c:	89 d0                	mov    %edx,%eax
     b1e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     b22:	75 f5                	jne    b19 <strlen+0x10>
    ;
  return n;
}
     b24:	5d                   	pop    %ebp
     b25:	c3                   	ret    
  for(n = 0; s[n]; n++)
     b26:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
     b2b:	eb f7                	jmp    b24 <strlen+0x1b>

00000b2d <memset>:

void*
memset(void *dst, int c, uint n)
{
     b2d:	55                   	push   %ebp
     b2e:	89 e5                	mov    %esp,%ebp
     b30:	57                   	push   %edi
     b31:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     b34:	89 d7                	mov    %edx,%edi
     b36:	8b 4d 10             	mov    0x10(%ebp),%ecx
     b39:	8b 45 0c             	mov    0xc(%ebp),%eax
     b3c:	fc                   	cld    
     b3d:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     b3f:	89 d0                	mov    %edx,%eax
     b41:	5f                   	pop    %edi
     b42:	5d                   	pop    %ebp
     b43:	c3                   	ret    

00000b44 <strchr>:

char*
strchr(const char *s, char c)
{
     b44:	55                   	push   %ebp
     b45:	89 e5                	mov    %esp,%ebp
     b47:	53                   	push   %ebx
     b48:	8b 45 08             	mov    0x8(%ebp),%eax
     b4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
     b4e:	0f b6 10             	movzbl (%eax),%edx
     b51:	84 d2                	test   %dl,%dl
     b53:	74 1e                	je     b73 <strchr+0x2f>
     b55:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
     b57:	38 d3                	cmp    %dl,%bl
     b59:	74 15                	je     b70 <strchr+0x2c>
  for(; *s; s++)
     b5b:	83 c0 01             	add    $0x1,%eax
     b5e:	0f b6 10             	movzbl (%eax),%edx
     b61:	84 d2                	test   %dl,%dl
     b63:	74 06                	je     b6b <strchr+0x27>
    if(*s == c)
     b65:	38 ca                	cmp    %cl,%dl
     b67:	75 f2                	jne    b5b <strchr+0x17>
     b69:	eb 05                	jmp    b70 <strchr+0x2c>
      return (char*)s;
  return 0;
     b6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     b70:	5b                   	pop    %ebx
     b71:	5d                   	pop    %ebp
     b72:	c3                   	ret    
  return 0;
     b73:	b8 00 00 00 00       	mov    $0x0,%eax
     b78:	eb f6                	jmp    b70 <strchr+0x2c>

00000b7a <gets>:

char*
gets(char *buf, int max)
{
     b7a:	55                   	push   %ebp
     b7b:	89 e5                	mov    %esp,%ebp
     b7d:	57                   	push   %edi
     b7e:	56                   	push   %esi
     b7f:	53                   	push   %ebx
     b80:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b83:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
     b88:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
     b8b:	8d 5e 01             	lea    0x1(%esi),%ebx
     b8e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     b91:	7d 2b                	jge    bbe <gets+0x44>
    cc = read(0, &c, 1);
     b93:	83 ec 04             	sub    $0x4,%esp
     b96:	6a 01                	push   $0x1
     b98:	57                   	push   %edi
     b99:	6a 00                	push   $0x0
     b9b:	e8 8f 01 00 00       	call   d2f <read>
    if(cc < 1)
     ba0:	83 c4 10             	add    $0x10,%esp
     ba3:	85 c0                	test   %eax,%eax
     ba5:	7e 17                	jle    bbe <gets+0x44>
      break;
    buf[i++] = c;
     ba7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     bab:	8b 55 08             	mov    0x8(%ebp),%edx
     bae:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
     bb2:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
     bb4:	3c 0a                	cmp    $0xa,%al
     bb6:	74 04                	je     bbc <gets+0x42>
     bb8:	3c 0d                	cmp    $0xd,%al
     bba:	75 cf                	jne    b8b <gets+0x11>
  for(i=0; i+1 < max; ){
     bbc:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
     bbe:	8b 45 08             	mov    0x8(%ebp),%eax
     bc1:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
     bc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
     bc8:	5b                   	pop    %ebx
     bc9:	5e                   	pop    %esi
     bca:	5f                   	pop    %edi
     bcb:	5d                   	pop    %ebp
     bcc:	c3                   	ret    

00000bcd <stat>:

int
stat(char *n, struct stat *st)
{
     bcd:	55                   	push   %ebp
     bce:	89 e5                	mov    %esp,%ebp
     bd0:	56                   	push   %esi
     bd1:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     bd2:	83 ec 08             	sub    $0x8,%esp
     bd5:	6a 00                	push   $0x0
     bd7:	ff 75 08             	pushl  0x8(%ebp)
     bda:	e8 78 01 00 00       	call   d57 <open>
  if(fd < 0)
     bdf:	83 c4 10             	add    $0x10,%esp
     be2:	85 c0                	test   %eax,%eax
     be4:	78 24                	js     c0a <stat+0x3d>
     be6:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
     be8:	83 ec 08             	sub    $0x8,%esp
     beb:	ff 75 0c             	pushl  0xc(%ebp)
     bee:	50                   	push   %eax
     bef:	e8 7b 01 00 00       	call   d6f <fstat>
     bf4:	89 c6                	mov    %eax,%esi
  close(fd);
     bf6:	89 1c 24             	mov    %ebx,(%esp)
     bf9:	e8 41 01 00 00       	call   d3f <close>
  return r;
     bfe:	83 c4 10             	add    $0x10,%esp
}
     c01:	89 f0                	mov    %esi,%eax
     c03:	8d 65 f8             	lea    -0x8(%ebp),%esp
     c06:	5b                   	pop    %ebx
     c07:	5e                   	pop    %esi
     c08:	5d                   	pop    %ebp
     c09:	c3                   	ret    
    return -1;
     c0a:	be ff ff ff ff       	mov    $0xffffffff,%esi
     c0f:	eb f0                	jmp    c01 <stat+0x34>

00000c11 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
     c11:	55                   	push   %ebp
     c12:	89 e5                	mov    %esp,%ebp
     c14:	56                   	push   %esi
     c15:	53                   	push   %ebx
     c16:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
     c19:	0f b6 0a             	movzbl (%edx),%ecx
     c1c:	80 f9 20             	cmp    $0x20,%cl
     c1f:	75 0b                	jne    c2c <atoi+0x1b>
     c21:	83 c2 01             	add    $0x1,%edx
     c24:	0f b6 0a             	movzbl (%edx),%ecx
     c27:	80 f9 20             	cmp    $0x20,%cl
     c2a:	74 f5                	je     c21 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
     c2c:	80 f9 2d             	cmp    $0x2d,%cl
     c2f:	74 3b                	je     c6c <atoi+0x5b>
  if (*s == '+'  || *s == '-')
     c31:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
     c34:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
     c39:	f6 c1 fd             	test   $0xfd,%cl
     c3c:	74 33                	je     c71 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
     c3e:	0f b6 0a             	movzbl (%edx),%ecx
     c41:	8d 41 d0             	lea    -0x30(%ecx),%eax
     c44:	3c 09                	cmp    $0x9,%al
     c46:	77 2e                	ja     c76 <atoi+0x65>
     c48:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
     c4d:	83 c2 01             	add    $0x1,%edx
     c50:	8d 04 80             	lea    (%eax,%eax,4),%eax
     c53:	0f be c9             	movsbl %cl,%ecx
     c56:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
     c5a:	0f b6 0a             	movzbl (%edx),%ecx
     c5d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
     c60:	80 fb 09             	cmp    $0x9,%bl
     c63:	76 e8                	jbe    c4d <atoi+0x3c>
  return sign*n;
     c65:	0f af c6             	imul   %esi,%eax
}
     c68:	5b                   	pop    %ebx
     c69:	5e                   	pop    %esi
     c6a:	5d                   	pop    %ebp
     c6b:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
     c6c:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
     c71:	83 c2 01             	add    $0x1,%edx
     c74:	eb c8                	jmp    c3e <atoi+0x2d>
  while('0' <= *s && *s <= '9')
     c76:	b8 00 00 00 00       	mov    $0x0,%eax
     c7b:	eb e8                	jmp    c65 <atoi+0x54>

00000c7d <atoo>:

int
atoo(const char *s)
{
     c7d:	55                   	push   %ebp
     c7e:	89 e5                	mov    %esp,%ebp
     c80:	56                   	push   %esi
     c81:	53                   	push   %ebx
     c82:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
     c85:	0f b6 0a             	movzbl (%edx),%ecx
     c88:	80 f9 20             	cmp    $0x20,%cl
     c8b:	75 0b                	jne    c98 <atoo+0x1b>
     c8d:	83 c2 01             	add    $0x1,%edx
     c90:	0f b6 0a             	movzbl (%edx),%ecx
     c93:	80 f9 20             	cmp    $0x20,%cl
     c96:	74 f5                	je     c8d <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
     c98:	80 f9 2d             	cmp    $0x2d,%cl
     c9b:	74 38                	je     cd5 <atoo+0x58>
  if (*s == '+'  || *s == '-')
     c9d:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
     ca0:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
     ca5:	f6 c1 fd             	test   $0xfd,%cl
     ca8:	74 30                	je     cda <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
     caa:	0f b6 0a             	movzbl (%edx),%ecx
     cad:	8d 41 d0             	lea    -0x30(%ecx),%eax
     cb0:	3c 07                	cmp    $0x7,%al
     cb2:	77 2b                	ja     cdf <atoo+0x62>
     cb4:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
     cb9:	83 c2 01             	add    $0x1,%edx
     cbc:	0f be c9             	movsbl %cl,%ecx
     cbf:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
     cc3:	0f b6 0a             	movzbl (%edx),%ecx
     cc6:	8d 59 d0             	lea    -0x30(%ecx),%ebx
     cc9:	80 fb 07             	cmp    $0x7,%bl
     ccc:	76 eb                	jbe    cb9 <atoo+0x3c>
  return sign*n;
     cce:	0f af c6             	imul   %esi,%eax
}
     cd1:	5b                   	pop    %ebx
     cd2:	5e                   	pop    %esi
     cd3:	5d                   	pop    %ebp
     cd4:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
     cd5:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
     cda:	83 c2 01             	add    $0x1,%edx
     cdd:	eb cb                	jmp    caa <atoo+0x2d>
  while('0' <= *s && *s <= '7')
     cdf:	b8 00 00 00 00       	mov    $0x0,%eax
     ce4:	eb e8                	jmp    cce <atoo+0x51>

00000ce6 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
     ce6:	55                   	push   %ebp
     ce7:	89 e5                	mov    %esp,%ebp
     ce9:	56                   	push   %esi
     cea:	53                   	push   %ebx
     ceb:	8b 45 08             	mov    0x8(%ebp),%eax
     cee:	8b 75 0c             	mov    0xc(%ebp),%esi
     cf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     cf4:	85 db                	test   %ebx,%ebx
     cf6:	7e 13                	jle    d0b <memmove+0x25>
     cf8:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
     cfd:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     d01:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     d04:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
     d07:	39 d3                	cmp    %edx,%ebx
     d09:	75 f2                	jne    cfd <memmove+0x17>
  return vdst;
}
     d0b:	5b                   	pop    %ebx
     d0c:	5e                   	pop    %esi
     d0d:	5d                   	pop    %ebp
     d0e:	c3                   	ret    

00000d0f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d0f:	b8 01 00 00 00       	mov    $0x1,%eax
     d14:	cd 40                	int    $0x40
     d16:	c3                   	ret    

00000d17 <exit>:
SYSCALL(exit)
     d17:	b8 02 00 00 00       	mov    $0x2,%eax
     d1c:	cd 40                	int    $0x40
     d1e:	c3                   	ret    

00000d1f <wait>:
SYSCALL(wait)
     d1f:	b8 03 00 00 00       	mov    $0x3,%eax
     d24:	cd 40                	int    $0x40
     d26:	c3                   	ret    

00000d27 <pipe>:
SYSCALL(pipe)
     d27:	b8 04 00 00 00       	mov    $0x4,%eax
     d2c:	cd 40                	int    $0x40
     d2e:	c3                   	ret    

00000d2f <read>:
SYSCALL(read)
     d2f:	b8 05 00 00 00       	mov    $0x5,%eax
     d34:	cd 40                	int    $0x40
     d36:	c3                   	ret    

00000d37 <write>:
SYSCALL(write)
     d37:	b8 10 00 00 00       	mov    $0x10,%eax
     d3c:	cd 40                	int    $0x40
     d3e:	c3                   	ret    

00000d3f <close>:
SYSCALL(close)
     d3f:	b8 15 00 00 00       	mov    $0x15,%eax
     d44:	cd 40                	int    $0x40
     d46:	c3                   	ret    

00000d47 <kill>:
SYSCALL(kill)
     d47:	b8 06 00 00 00       	mov    $0x6,%eax
     d4c:	cd 40                	int    $0x40
     d4e:	c3                   	ret    

00000d4f <exec>:
SYSCALL(exec)
     d4f:	b8 07 00 00 00       	mov    $0x7,%eax
     d54:	cd 40                	int    $0x40
     d56:	c3                   	ret    

00000d57 <open>:
SYSCALL(open)
     d57:	b8 0f 00 00 00       	mov    $0xf,%eax
     d5c:	cd 40                	int    $0x40
     d5e:	c3                   	ret    

00000d5f <mknod>:
SYSCALL(mknod)
     d5f:	b8 11 00 00 00       	mov    $0x11,%eax
     d64:	cd 40                	int    $0x40
     d66:	c3                   	ret    

00000d67 <unlink>:
SYSCALL(unlink)
     d67:	b8 12 00 00 00       	mov    $0x12,%eax
     d6c:	cd 40                	int    $0x40
     d6e:	c3                   	ret    

00000d6f <fstat>:
SYSCALL(fstat)
     d6f:	b8 08 00 00 00       	mov    $0x8,%eax
     d74:	cd 40                	int    $0x40
     d76:	c3                   	ret    

00000d77 <link>:
SYSCALL(link)
     d77:	b8 13 00 00 00       	mov    $0x13,%eax
     d7c:	cd 40                	int    $0x40
     d7e:	c3                   	ret    

00000d7f <mkdir>:
SYSCALL(mkdir)
     d7f:	b8 14 00 00 00       	mov    $0x14,%eax
     d84:	cd 40                	int    $0x40
     d86:	c3                   	ret    

00000d87 <chdir>:
SYSCALL(chdir)
     d87:	b8 09 00 00 00       	mov    $0x9,%eax
     d8c:	cd 40                	int    $0x40
     d8e:	c3                   	ret    

00000d8f <dup>:
SYSCALL(dup)
     d8f:	b8 0a 00 00 00       	mov    $0xa,%eax
     d94:	cd 40                	int    $0x40
     d96:	c3                   	ret    

00000d97 <getpid>:
SYSCALL(getpid)
     d97:	b8 0b 00 00 00       	mov    $0xb,%eax
     d9c:	cd 40                	int    $0x40
     d9e:	c3                   	ret    

00000d9f <sbrk>:
SYSCALL(sbrk)
     d9f:	b8 0c 00 00 00       	mov    $0xc,%eax
     da4:	cd 40                	int    $0x40
     da6:	c3                   	ret    

00000da7 <sleep>:
SYSCALL(sleep)
     da7:	b8 0d 00 00 00       	mov    $0xd,%eax
     dac:	cd 40                	int    $0x40
     dae:	c3                   	ret    

00000daf <uptime>:
SYSCALL(uptime)
     daf:	b8 0e 00 00 00       	mov    $0xe,%eax
     db4:	cd 40                	int    $0x40
     db6:	c3                   	ret    

00000db7 <halt>:
SYSCALL(halt)
     db7:	b8 16 00 00 00       	mov    $0x16,%eax
     dbc:	cd 40                	int    $0x40
     dbe:	c3                   	ret    

00000dbf <date>:
//proj1
SYSCALL(date)
     dbf:	b8 17 00 00 00       	mov    $0x17,%eax
     dc4:	cd 40                	int    $0x40
     dc6:	c3                   	ret    

00000dc7 <getuid>:
//proj2
SYSCALL(getuid)
     dc7:	b8 18 00 00 00       	mov    $0x18,%eax
     dcc:	cd 40                	int    $0x40
     dce:	c3                   	ret    

00000dcf <getgid>:
SYSCALL(getgid)
     dcf:	b8 19 00 00 00       	mov    $0x19,%eax
     dd4:	cd 40                	int    $0x40
     dd6:	c3                   	ret    

00000dd7 <getppid>:
SYSCALL(getppid)
     dd7:	b8 1a 00 00 00       	mov    $0x1a,%eax
     ddc:	cd 40                	int    $0x40
     dde:	c3                   	ret    

00000ddf <setuid>:
SYSCALL(setuid)
     ddf:	b8 1b 00 00 00       	mov    $0x1b,%eax
     de4:	cd 40                	int    $0x40
     de6:	c3                   	ret    

00000de7 <setgid>:
SYSCALL(setgid)
     de7:	b8 1c 00 00 00       	mov    $0x1c,%eax
     dec:	cd 40                	int    $0x40
     dee:	c3                   	ret    

00000def <getprocs>:
SYSCALL(getprocs)
     def:	b8 1d 00 00 00       	mov    $0x1d,%eax
     df4:	cd 40                	int    $0x40
     df6:	c3                   	ret    

00000df7 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     df7:	55                   	push   %ebp
     df8:	89 e5                	mov    %esp,%ebp
     dfa:	57                   	push   %edi
     dfb:	56                   	push   %esi
     dfc:	53                   	push   %ebx
     dfd:	83 ec 3c             	sub    $0x3c,%esp
     e00:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e06:	74 14                	je     e1c <printint+0x25>
     e08:	85 d2                	test   %edx,%edx
     e0a:	79 10                	jns    e1c <printint+0x25>
    neg = 1;
    x = -xx;
     e0c:	f7 da                	neg    %edx
    neg = 1;
     e0e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     e15:	bf 00 00 00 00       	mov    $0x0,%edi
     e1a:	eb 0b                	jmp    e27 <printint+0x30>
  neg = 0;
     e1c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     e23:	eb f0                	jmp    e15 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
     e25:	89 df                	mov    %ebx,%edi
     e27:	8d 5f 01             	lea    0x1(%edi),%ebx
     e2a:	89 d0                	mov    %edx,%eax
     e2c:	ba 00 00 00 00       	mov    $0x0,%edx
     e31:	f7 f1                	div    %ecx
     e33:	0f b6 92 20 18 00 00 	movzbl 0x1820(%edx),%edx
     e3a:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
     e3e:	89 c2                	mov    %eax,%edx
     e40:	85 c0                	test   %eax,%eax
     e42:	75 e1                	jne    e25 <printint+0x2e>
  if(neg)
     e44:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
     e48:	74 08                	je     e52 <printint+0x5b>
    buf[i++] = '-';
     e4a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
     e4f:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
     e52:	83 eb 01             	sub    $0x1,%ebx
     e55:	78 22                	js     e79 <printint+0x82>
  write(fd, &c, 1);
     e57:	8d 7d d7             	lea    -0x29(%ebp),%edi
     e5a:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
     e5f:	88 45 d7             	mov    %al,-0x29(%ebp)
     e62:	83 ec 04             	sub    $0x4,%esp
     e65:	6a 01                	push   $0x1
     e67:	57                   	push   %edi
     e68:	56                   	push   %esi
     e69:	e8 c9 fe ff ff       	call   d37 <write>
  while(--i >= 0)
     e6e:	83 eb 01             	sub    $0x1,%ebx
     e71:	83 c4 10             	add    $0x10,%esp
     e74:	83 fb ff             	cmp    $0xffffffff,%ebx
     e77:	75 e1                	jne    e5a <printint+0x63>
    putc(fd, buf[i]);
}
     e79:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e7c:	5b                   	pop    %ebx
     e7d:	5e                   	pop    %esi
     e7e:	5f                   	pop    %edi
     e7f:	5d                   	pop    %ebp
     e80:	c3                   	ret    

00000e81 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     e81:	55                   	push   %ebp
     e82:	89 e5                	mov    %esp,%ebp
     e84:	57                   	push   %edi
     e85:	56                   	push   %esi
     e86:	53                   	push   %ebx
     e87:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     e8a:	8b 75 0c             	mov    0xc(%ebp),%esi
     e8d:	0f b6 1e             	movzbl (%esi),%ebx
     e90:	84 db                	test   %bl,%bl
     e92:	0f 84 b1 01 00 00    	je     1049 <printf+0x1c8>
     e98:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
     e9b:	8d 45 10             	lea    0x10(%ebp),%eax
     e9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
     ea1:	bf 00 00 00 00       	mov    $0x0,%edi
     ea6:	eb 2d                	jmp    ed5 <printf+0x54>
     ea8:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
     eab:	83 ec 04             	sub    $0x4,%esp
     eae:	6a 01                	push   $0x1
     eb0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
     eb3:	50                   	push   %eax
     eb4:	ff 75 08             	pushl  0x8(%ebp)
     eb7:	e8 7b fe ff ff       	call   d37 <write>
     ebc:	83 c4 10             	add    $0x10,%esp
     ebf:	eb 05                	jmp    ec6 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ec1:	83 ff 25             	cmp    $0x25,%edi
     ec4:	74 22                	je     ee8 <printf+0x67>
     ec6:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
     ec9:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
     ecd:	84 db                	test   %bl,%bl
     ecf:	0f 84 74 01 00 00    	je     1049 <printf+0x1c8>
    c = fmt[i] & 0xff;
     ed5:	0f be d3             	movsbl %bl,%edx
     ed8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     edb:	85 ff                	test   %edi,%edi
     edd:	75 e2                	jne    ec1 <printf+0x40>
      if(c == '%'){
     edf:	83 f8 25             	cmp    $0x25,%eax
     ee2:	75 c4                	jne    ea8 <printf+0x27>
        state = '%';
     ee4:	89 c7                	mov    %eax,%edi
     ee6:	eb de                	jmp    ec6 <printf+0x45>
      if(c == 'd'){
     ee8:	83 f8 64             	cmp    $0x64,%eax
     eeb:	74 59                	je     f46 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     eed:	81 e2 f7 00 00 00    	and    $0xf7,%edx
     ef3:	83 fa 70             	cmp    $0x70,%edx
     ef6:	74 7a                	je     f72 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     ef8:	83 f8 73             	cmp    $0x73,%eax
     efb:	0f 84 9d 00 00 00    	je     f9e <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f01:	83 f8 63             	cmp    $0x63,%eax
     f04:	0f 84 f2 00 00 00    	je     ffc <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     f0a:	83 f8 25             	cmp    $0x25,%eax
     f0d:	0f 84 15 01 00 00    	je     1028 <printf+0x1a7>
     f13:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
     f17:	83 ec 04             	sub    $0x4,%esp
     f1a:	6a 01                	push   $0x1
     f1c:	8d 45 e7             	lea    -0x19(%ebp),%eax
     f1f:	50                   	push   %eax
     f20:	ff 75 08             	pushl  0x8(%ebp)
     f23:	e8 0f fe ff ff       	call   d37 <write>
     f28:	88 5d e6             	mov    %bl,-0x1a(%ebp)
     f2b:	83 c4 0c             	add    $0xc,%esp
     f2e:	6a 01                	push   $0x1
     f30:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     f33:	50                   	push   %eax
     f34:	ff 75 08             	pushl  0x8(%ebp)
     f37:	e8 fb fd ff ff       	call   d37 <write>
     f3c:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     f3f:	bf 00 00 00 00       	mov    $0x0,%edi
     f44:	eb 80                	jmp    ec6 <printf+0x45>
        printint(fd, *ap, 10, 1);
     f46:	83 ec 0c             	sub    $0xc,%esp
     f49:	6a 01                	push   $0x1
     f4b:	b9 0a 00 00 00       	mov    $0xa,%ecx
     f50:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     f53:	8b 17                	mov    (%edi),%edx
     f55:	8b 45 08             	mov    0x8(%ebp),%eax
     f58:	e8 9a fe ff ff       	call   df7 <printint>
        ap++;
     f5d:	89 f8                	mov    %edi,%eax
     f5f:	83 c0 04             	add    $0x4,%eax
     f62:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     f65:	83 c4 10             	add    $0x10,%esp
      state = 0;
     f68:	bf 00 00 00 00       	mov    $0x0,%edi
     f6d:	e9 54 ff ff ff       	jmp    ec6 <printf+0x45>
        printint(fd, *ap, 16, 0);
     f72:	83 ec 0c             	sub    $0xc,%esp
     f75:	6a 00                	push   $0x0
     f77:	b9 10 00 00 00       	mov    $0x10,%ecx
     f7c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     f7f:	8b 17                	mov    (%edi),%edx
     f81:	8b 45 08             	mov    0x8(%ebp),%eax
     f84:	e8 6e fe ff ff       	call   df7 <printint>
        ap++;
     f89:	89 f8                	mov    %edi,%eax
     f8b:	83 c0 04             	add    $0x4,%eax
     f8e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     f91:	83 c4 10             	add    $0x10,%esp
      state = 0;
     f94:	bf 00 00 00 00       	mov    $0x0,%edi
     f99:	e9 28 ff ff ff       	jmp    ec6 <printf+0x45>
        s = (char*)*ap;
     f9e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     fa1:	8b 01                	mov    (%ecx),%eax
        ap++;
     fa3:	83 c1 04             	add    $0x4,%ecx
     fa6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
     fa9:	85 c0                	test   %eax,%eax
     fab:	74 13                	je     fc0 <printf+0x13f>
        s = (char*)*ap;
     fad:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
     faf:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
     fb2:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
     fb7:	84 c0                	test   %al,%al
     fb9:	75 0f                	jne    fca <printf+0x149>
     fbb:	e9 06 ff ff ff       	jmp    ec6 <printf+0x45>
          s = "(null)";
     fc0:	bb 18 18 00 00       	mov    $0x1818,%ebx
        while(*s != 0){
     fc5:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
     fca:	8d 7d e3             	lea    -0x1d(%ebp),%edi
     fcd:	89 75 d0             	mov    %esi,-0x30(%ebp)
     fd0:	8b 75 08             	mov    0x8(%ebp),%esi
     fd3:	88 45 e3             	mov    %al,-0x1d(%ebp)
     fd6:	83 ec 04             	sub    $0x4,%esp
     fd9:	6a 01                	push   $0x1
     fdb:	57                   	push   %edi
     fdc:	56                   	push   %esi
     fdd:	e8 55 fd ff ff       	call   d37 <write>
          s++;
     fe2:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
     fe5:	0f b6 03             	movzbl (%ebx),%eax
     fe8:	83 c4 10             	add    $0x10,%esp
     feb:	84 c0                	test   %al,%al
     fed:	75 e4                	jne    fd3 <printf+0x152>
     fef:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
     ff2:	bf 00 00 00 00       	mov    $0x0,%edi
     ff7:	e9 ca fe ff ff       	jmp    ec6 <printf+0x45>
        putc(fd, *ap);
     ffc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     fff:	8b 07                	mov    (%edi),%eax
    1001:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    1004:	83 ec 04             	sub    $0x4,%esp
    1007:	6a 01                	push   $0x1
    1009:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    100c:	50                   	push   %eax
    100d:	ff 75 08             	pushl  0x8(%ebp)
    1010:	e8 22 fd ff ff       	call   d37 <write>
        ap++;
    1015:	83 c7 04             	add    $0x4,%edi
    1018:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    101b:	83 c4 10             	add    $0x10,%esp
      state = 0;
    101e:	bf 00 00 00 00       	mov    $0x0,%edi
    1023:	e9 9e fe ff ff       	jmp    ec6 <printf+0x45>
    1028:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    102b:	83 ec 04             	sub    $0x4,%esp
    102e:	6a 01                	push   $0x1
    1030:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1033:	50                   	push   %eax
    1034:	ff 75 08             	pushl  0x8(%ebp)
    1037:	e8 fb fc ff ff       	call   d37 <write>
    103c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    103f:	bf 00 00 00 00       	mov    $0x0,%edi
    1044:	e9 7d fe ff ff       	jmp    ec6 <printf+0x45>
    }
  }
}
    1049:	8d 65 f4             	lea    -0xc(%ebp),%esp
    104c:	5b                   	pop    %ebx
    104d:	5e                   	pop    %esi
    104e:	5f                   	pop    %edi
    104f:	5d                   	pop    %ebp
    1050:	c3                   	ret    

00001051 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1051:	55                   	push   %ebp
    1052:	89 e5                	mov    %esp,%ebp
    1054:	57                   	push   %edi
    1055:	56                   	push   %esi
    1056:	53                   	push   %ebx
    1057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    105a:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    105d:	a1 d4 1b 00 00       	mov    0x1bd4,%eax
    1062:	eb 0c                	jmp    1070 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1064:	8b 10                	mov    (%eax),%edx
    1066:	39 c2                	cmp    %eax,%edx
    1068:	77 04                	ja     106e <free+0x1d>
    106a:	39 ca                	cmp    %ecx,%edx
    106c:	77 10                	ja     107e <free+0x2d>
{
    106e:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1070:	39 c8                	cmp    %ecx,%eax
    1072:	73 f0                	jae    1064 <free+0x13>
    1074:	8b 10                	mov    (%eax),%edx
    1076:	39 ca                	cmp    %ecx,%edx
    1078:	77 04                	ja     107e <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    107a:	39 c2                	cmp    %eax,%edx
    107c:	77 f0                	ja     106e <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    107e:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1081:	8b 10                	mov    (%eax),%edx
    1083:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1086:	39 fa                	cmp    %edi,%edx
    1088:	74 19                	je     10a3 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    108a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    108d:	8b 50 04             	mov    0x4(%eax),%edx
    1090:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1093:	39 f1                	cmp    %esi,%ecx
    1095:	74 1b                	je     10b2 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1097:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1099:	a3 d4 1b 00 00       	mov    %eax,0x1bd4
}
    109e:	5b                   	pop    %ebx
    109f:	5e                   	pop    %esi
    10a0:	5f                   	pop    %edi
    10a1:	5d                   	pop    %ebp
    10a2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    10a3:	03 72 04             	add    0x4(%edx),%esi
    10a6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    10a9:	8b 10                	mov    (%eax),%edx
    10ab:	8b 12                	mov    (%edx),%edx
    10ad:	89 53 f8             	mov    %edx,-0x8(%ebx)
    10b0:	eb db                	jmp    108d <free+0x3c>
    p->s.size += bp->s.size;
    10b2:	03 53 fc             	add    -0x4(%ebx),%edx
    10b5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    10b8:	8b 53 f8             	mov    -0x8(%ebx),%edx
    10bb:	89 10                	mov    %edx,(%eax)
    10bd:	eb da                	jmp    1099 <free+0x48>

000010bf <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10bf:	55                   	push   %ebp
    10c0:	89 e5                	mov    %esp,%ebp
    10c2:	57                   	push   %edi
    10c3:	56                   	push   %esi
    10c4:	53                   	push   %ebx
    10c5:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10c8:	8b 45 08             	mov    0x8(%ebp),%eax
    10cb:	8d 58 07             	lea    0x7(%eax),%ebx
    10ce:	c1 eb 03             	shr    $0x3,%ebx
    10d1:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    10d4:	8b 15 d4 1b 00 00    	mov    0x1bd4,%edx
    10da:	85 d2                	test   %edx,%edx
    10dc:	74 20                	je     10fe <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10de:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    10e0:	8b 48 04             	mov    0x4(%eax),%ecx
    10e3:	39 cb                	cmp    %ecx,%ebx
    10e5:	76 3c                	jbe    1123 <malloc+0x64>
    10e7:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    10ed:	be 00 10 00 00       	mov    $0x1000,%esi
    10f2:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    10f5:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    10fc:	eb 70                	jmp    116e <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    10fe:	c7 05 d4 1b 00 00 d8 	movl   $0x1bd8,0x1bd4
    1105:	1b 00 00 
    1108:	c7 05 d8 1b 00 00 d8 	movl   $0x1bd8,0x1bd8
    110f:	1b 00 00 
    base.s.size = 0;
    1112:	c7 05 dc 1b 00 00 00 	movl   $0x0,0x1bdc
    1119:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    111c:	ba d8 1b 00 00       	mov    $0x1bd8,%edx
    1121:	eb bb                	jmp    10de <malloc+0x1f>
      if(p->s.size == nunits)
    1123:	39 cb                	cmp    %ecx,%ebx
    1125:	74 1c                	je     1143 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1127:	29 d9                	sub    %ebx,%ecx
    1129:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    112c:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    112f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1132:	89 15 d4 1b 00 00    	mov    %edx,0x1bd4
      return (void*)(p + 1);
    1138:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    113b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    113e:	5b                   	pop    %ebx
    113f:	5e                   	pop    %esi
    1140:	5f                   	pop    %edi
    1141:	5d                   	pop    %ebp
    1142:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1143:	8b 08                	mov    (%eax),%ecx
    1145:	89 0a                	mov    %ecx,(%edx)
    1147:	eb e9                	jmp    1132 <malloc+0x73>
  hp->s.size = nu;
    1149:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    114c:	83 ec 0c             	sub    $0xc,%esp
    114f:	83 c0 08             	add    $0x8,%eax
    1152:	50                   	push   %eax
    1153:	e8 f9 fe ff ff       	call   1051 <free>
  return freep;
    1158:	8b 15 d4 1b 00 00    	mov    0x1bd4,%edx
      if((p = morecore(nunits)) == 0)
    115e:	83 c4 10             	add    $0x10,%esp
    1161:	85 d2                	test   %edx,%edx
    1163:	74 2b                	je     1190 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1165:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1167:	8b 48 04             	mov    0x4(%eax),%ecx
    116a:	39 d9                	cmp    %ebx,%ecx
    116c:	73 b5                	jae    1123 <malloc+0x64>
    116e:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1170:	39 05 d4 1b 00 00    	cmp    %eax,0x1bd4
    1176:	75 ed                	jne    1165 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    1178:	83 ec 0c             	sub    $0xc,%esp
    117b:	57                   	push   %edi
    117c:	e8 1e fc ff ff       	call   d9f <sbrk>
  if(p == (char*)-1)
    1181:	83 c4 10             	add    $0x10,%esp
    1184:	83 f8 ff             	cmp    $0xffffffff,%eax
    1187:	75 c0                	jne    1149 <malloc+0x8a>
        return 0;
    1189:	b8 00 00 00 00       	mov    $0x0,%eax
    118e:	eb ab                	jmp    113b <malloc+0x7c>
    1190:	b8 00 00 00 00       	mov    $0x0,%eax
    1195:	eb a4                	jmp    113b <malloc+0x7c>
