
_scsh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
  11:	eb 0a                	jmp    1d <main+0x1d>
  13:	90                   	nop
  14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
  18:	83 f8 02             	cmp    $0x2,%eax
  1b:	7f 76                	jg     93 <main+0x93>
  while((fd = open("console", O_RDWR)) >= 0){
  1d:	83 ec 08             	sub    $0x8,%esp
  20:	6a 02                	push   $0x2
  22:	68 a4 0e 00 00       	push   $0xea4
  27:	e8 96 09 00 00       	call   9c2 <open>
  2c:	83 c4 10             	add    $0x10,%esp
  2f:	85 c0                	test   %eax,%eax
  31:	79 e5                	jns    18 <main+0x18>
  33:	eb 1f                	jmp    54 <main+0x54>
  35:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
  38:	80 3d a2 13 00 00 20 	cmpb   $0x20,0x13a2
  3f:	74 7a                	je     bb <main+0xbb>
int
fork1(void)
{
  int pid;

  pid = fork();
  41:	e8 34 09 00 00       	call   97a <fork>
  if(pid == -1)
  46:	83 f8 ff             	cmp    $0xffffffff,%eax
  49:	74 3b                	je     86 <main+0x86>
    if(fork1() == 0)
  4b:	85 c0                	test   %eax,%eax
  4d:	74 57                	je     a6 <main+0xa6>
    wait();
  4f:	e8 36 09 00 00       	call   98a <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
  54:	83 ec 08             	sub    $0x8,%esp
  57:	6a 64                	push   $0x64
  59:	68 a0 13 00 00       	push   $0x13a0
  5e:	e8 9d 00 00 00       	call   100 <getcmd>
  63:	83 c4 10             	add    $0x10,%esp
  66:	85 c0                	test   %eax,%eax
  68:	78 37                	js     a1 <main+0xa1>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
  6a:	80 3d a0 13 00 00 63 	cmpb   $0x63,0x13a0
  71:	75 ce                	jne    41 <main+0x41>
  73:	80 3d a1 13 00 00 64 	cmpb   $0x64,0x13a1
  7a:	74 bc                	je     38 <main+0x38>
  pid = fork();
  7c:	e8 f9 08 00 00       	call   97a <fork>
  if(pid == -1)
  81:	83 f8 ff             	cmp    $0xffffffff,%eax
  84:	75 c5                	jne    4b <main+0x4b>
    panic("fork");
  86:	83 ec 0c             	sub    $0xc,%esp
  89:	68 61 0e 00 00       	push   $0xe61
  8e:	e8 bd 00 00 00       	call   150 <panic>
      close(fd);
  93:	83 ec 0c             	sub    $0xc,%esp
  96:	50                   	push   %eax
  97:	e8 0e 09 00 00       	call   9aa <close>
      break;
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	eb b3                	jmp    54 <main+0x54>
  exit();
  a1:	e8 dc 08 00 00       	call   982 <exit>
      runexp(parseexp(buf));
  a6:	83 ec 0c             	sub    $0xc,%esp
  a9:	68 a0 13 00 00       	push   $0x13a0
  ae:	e8 0d 06 00 00       	call   6c0 <parseexp>
  b3:	89 04 24             	mov    %eax,(%esp)
  b6:	e8 b5 00 00 00       	call   170 <runexp>
      buf[strlen(buf)-1] = 0;  // chop \n
  bb:	83 ec 0c             	sub    $0xc,%esp
  be:	68 a0 13 00 00       	push   $0x13a0
  c3:	e8 e8 06 00 00       	call   7b0 <strlen>
      if(chdir(buf+3) < 0)
  c8:	c7 04 24 a3 13 00 00 	movl   $0x13a3,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
  cf:	c6 80 9f 13 00 00 00 	movb   $0x0,0x139f(%eax)
      if(chdir(buf+3) < 0)
  d6:	e8 17 09 00 00       	call   9f2 <chdir>
  db:	83 c4 10             	add    $0x10,%esp
  de:	85 c0                	test   %eax,%eax
  e0:	0f 89 6e ff ff ff    	jns    54 <main+0x54>
        printf(2, "cannot cd %s\n", buf+3);
  e6:	50                   	push   %eax
  e7:	68 a3 13 00 00       	push   $0x13a3
  ec:	68 ac 0e 00 00       	push   $0xeac
  f1:	6a 02                	push   $0x2
  f3:	e8 d8 09 00 00       	call   ad0 <printf>
  f8:	83 c4 10             	add    $0x10,%esp
  fb:	e9 54 ff ff ff       	jmp    54 <main+0x54>

00000100 <getcmd>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	56                   	push   %esi
 104:	53                   	push   %ebx
 105:	8b 75 0c             	mov    0xc(%ebp),%esi
 108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
 10b:	83 ec 08             	sub    $0x8,%esp
 10e:	68 28 0e 00 00       	push   $0xe28
 113:	6a 02                	push   $0x2
 115:	e8 b6 09 00 00       	call   ad0 <printf>
  memset(buf, 0, nbuf);
 11a:	83 c4 0c             	add    $0xc,%esp
 11d:	56                   	push   %esi
 11e:	6a 00                	push   $0x0
 120:	53                   	push   %ebx
 121:	e8 ba 06 00 00       	call   7e0 <memset>
  gets(buf, nbuf);
 126:	58                   	pop    %eax
 127:	5a                   	pop    %edx
 128:	56                   	push   %esi
 129:	53                   	push   %ebx
 12a:	e8 11 07 00 00       	call   840 <gets>
  if(buf[0] == 0) // EOF
 12f:	83 c4 10             	add    $0x10,%esp
 132:	31 c0                	xor    %eax,%eax
 134:	80 3b 00             	cmpb   $0x0,(%ebx)
 137:	0f 94 c0             	sete   %al
}
 13a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(buf[0] == 0) // EOF
 13d:	f7 d8                	neg    %eax
}
 13f:	5b                   	pop    %ebx
 140:	5e                   	pop    %esi
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <panic>:
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
 156:	ff 75 08             	pushl  0x8(%ebp)
 159:	68 a0 0e 00 00       	push   $0xea0
 15e:	6a 02                	push   $0x2
 160:	e8 6b 09 00 00       	call   ad0 <printf>
  exit();
 165:	e8 18 08 00 00       	call   982 <exit>
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000170 <runexp>:
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
 175:	53                   	push   %ebx
 176:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
 17c:	8b 75 08             	mov    0x8(%ebp),%esi
  if(exp== 0)
 17f:	85 f6                	test   %esi,%esi
 181:	74 5d                	je     1e0 <runexp+0x70>
  switch(exp->type){
 183:	8b 06                	mov    (%esi),%eax
 185:	83 f8 02             	cmp    $0x2,%eax
 188:	74 1e                	je     1a8 <runexp+0x38>
 18a:	83 f8 03             	cmp    $0x3,%eax
 18d:	74 2b                	je     1ba <runexp+0x4a>
 18f:	83 e8 01             	sub    $0x1,%eax
 192:	74 4c                	je     1e0 <runexp+0x70>
    panic("runexp");
 194:	83 ec 0c             	sub    $0xc,%esp
 197:	68 2b 0e 00 00       	push   $0xe2b
 19c:	e8 af ff ff ff       	call   150 <panic>
 1a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(i=0;i<lst->length;i++)
 1a8:	8b 7e 04             	mov    0x4(%esi),%edi
 1ab:	85 ff                	test   %edi,%edi
 1ad:	7e 31                	jle    1e0 <runexp+0x70>
      runexp(lst->sexps[i]);
 1af:	83 ec 0c             	sub    $0xc,%esp
 1b2:	ff 76 08             	pushl  0x8(%esi)
 1b5:	e8 b6 ff ff ff       	call   170 <runexp>
    printf(2, "in 1\n");
 1ba:	53                   	push   %ebx
 1bb:	53                   	push   %ebx
 1bc:	68 32 0e 00 00       	push   $0xe32
 1c1:	6a 02                	push   $0x2
 1c3:	e8 08 09 00 00       	call   ad0 <printf>
    argv[lst->length]=0;
 1c8:	8b 46 04             	mov    0x4(%esi),%eax
    for(i=0;i<lst->length;i++)
 1cb:	83 c4 10             	add    $0x10,%esp
 1ce:	85 c0                	test   %eax,%eax
    argv[lst->length]=0;
 1d0:	c7 84 85 ec fe ff ff 	movl   $0x0,-0x114(%ebp,%eax,4)
 1d7:	00 00 00 00 
    for(i=0;i<lst->length;i++)
 1db:	7f 08                	jg     1e5 <runexp+0x75>
 1dd:	8d 76 00             	lea    0x0(%esi),%esi
  exit();
 1e0:	e8 9d 07 00 00       	call   982 <exit>
    for(i=0;i<lst->length;i++)
 1e5:	31 db                	xor    %ebx,%ebx
 1e7:	eb 2a                	jmp    213 <runexp+0xa3>
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      else if(lst->sexps[i]->type==LIST)
 1f0:	83 f8 02             	cmp    $0x2,%eax
 1f3:	0f 84 65 01 00 00    	je     35e <runexp+0x1ee>
      else if(lst->sexps[i]->type==APPLY)
 1f9:	83 f8 03             	cmp    $0x3,%eax
 1fc:	0f 84 b3 00 00 00    	je     2b5 <runexp+0x145>
      if(i==lst->length-1)
 202:	8b 46 04             	mov    0x4(%esi),%eax
 205:	8d 50 ff             	lea    -0x1(%eax),%edx
 208:	39 da                	cmp    %ebx,%edx
 20a:	74 44                	je     250 <runexp+0xe0>
    for(i=0;i<lst->length;i++)
 20c:	83 c3 01             	add    $0x1,%ebx
 20f:	39 c3                	cmp    %eax,%ebx
 211:	7d cd                	jge    1e0 <runexp+0x70>
      printf(2, "in 2, length:%d\n",lst->length);
 213:	83 ec 04             	sub    $0x4,%esp
 216:	50                   	push   %eax
 217:	68 38 0e 00 00       	push   $0xe38
 21c:	6a 02                	push   $0x2
 21e:	e8 ad 08 00 00       	call   ad0 <printf>
      if(lst->sexps[i]->type==ATOM)
 223:	8b 54 9e 08          	mov    0x8(%esi,%ebx,4),%edx
 227:	83 c4 10             	add    $0x10,%esp
 22a:	8b 02                	mov    (%edx),%eax
 22c:	83 f8 01             	cmp    $0x1,%eax
 22f:	75 bf                	jne    1f0 <runexp+0x80>
        argv[i]=((struct atom*)lst->sexps[i])->symbol;
 231:	8b 42 04             	mov    0x4(%edx),%eax
        printf(2, "in 3, length:%d\n",lst->length);
 234:	51                   	push   %ecx
 235:	ff 76 04             	pushl  0x4(%esi)
 238:	68 49 0e 00 00       	push   $0xe49
 23d:	6a 02                	push   $0x2
        argv[i]=((struct atom*)lst->sexps[i])->symbol;
 23f:	89 84 9d ec fe ff ff 	mov    %eax,-0x114(%ebp,%ebx,4)
        printf(2, "in 3, length:%d\n",lst->length);
 246:	e8 85 08 00 00       	call   ad0 <printf>
 24b:	83 c4 10             	add    $0x10,%esp
 24e:	eb b2                	jmp    202 <runexp+0x92>
        printf(2, "in 4, length:%d\n",lst->length);
 250:	51                   	push   %ecx
 251:	50                   	push   %eax
 252:	68 7b 0e 00 00       	push   $0xe7b
 257:	6a 02                	push   $0x2
 259:	e8 72 08 00 00       	call   ad0 <printf>
        printf(2, "exec %s\n",argv[0]);
 25e:	83 c4 0c             	add    $0xc,%esp
 261:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
 267:	68 8c 0e 00 00       	push   $0xe8c
 26c:	6a 02                	push   $0x2
 26e:	e8 5d 08 00 00       	call   ad0 <printf>
  pid = fork();
 273:	e8 02 07 00 00       	call   97a <fork>
  if(pid == -1)
 278:	83 c4 10             	add    $0x10,%esp
 27b:	83 f8 ff             	cmp    $0xffffffff,%eax
 27e:	0f 84 e7 00 00 00    	je     36b <runexp+0x1fb>
        if(fork1() == 0){
 284:	85 c0                	test   %eax,%eax
 286:	75 20                	jne    2a8 <runexp+0x138>
          if(argv[0] == 0)
 288:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
 28e:	85 c0                	test   %eax,%eax
 290:	0f 84 4a ff ff ff    	je     1e0 <runexp+0x70>
          exec(argv[0], argv);
 296:	52                   	push   %edx
 297:	52                   	push   %edx
 298:	8d 95 ec fe ff ff    	lea    -0x114(%ebp),%edx
 29e:	52                   	push   %edx
 29f:	50                   	push   %eax
 2a0:	e8 15 07 00 00       	call   9ba <exec>
 2a5:	83 c4 10             	add    $0x10,%esp
        wait();
 2a8:	e8 dd 06 00 00       	call   98a <wait>
 2ad:	8b 46 04             	mov    0x4(%esi),%eax
 2b0:	e9 57 ff ff ff       	jmp    20c <runexp+0x9c>
  pid = fork();
 2b5:	e8 c0 06 00 00       	call   97a <fork>
  if(pid == -1)
 2ba:	83 f8 ff             	cmp    $0xffffffff,%eax
 2bd:	0f 84 a8 00 00 00    	je     36b <runexp+0x1fb>
        if(fork1() == 0){
 2c3:	85 c0                	test   %eax,%eax
 2c5:	75 3e                	jne    305 <runexp+0x195>
          close(1);
 2c7:	83 ec 0c             	sub    $0xc,%esp
 2ca:	6a 01                	push   $0x1
 2cc:	e8 d9 06 00 00       	call   9aa <close>
          if(open("./.etemp", O_WRONLY|O_CREATE) < 0){
 2d1:	58                   	pop    %eax
 2d2:	5a                   	pop    %edx
 2d3:	68 01 02 00 00       	push   $0x201
 2d8:	68 66 0e 00 00       	push   $0xe66
 2dd:	e8 e0 06 00 00       	call   9c2 <open>
 2e2:	83 c4 10             	add    $0x10,%esp
 2e5:	85 c0                	test   %eax,%eax
 2e7:	0f 88 8b 00 00 00    	js     378 <runexp+0x208>
          printf(2, "start\n");
 2ed:	51                   	push   %ecx
 2ee:	51                   	push   %ecx
 2ef:	68 6f 0e 00 00       	push   $0xe6f
 2f4:	6a 02                	push   $0x2
 2f6:	e8 d5 07 00 00       	call   ad0 <printf>
          runexp(lst->sexps[i]);
 2fb:	5f                   	pop    %edi
 2fc:	ff 74 9e 08          	pushl  0x8(%esi,%ebx,4)
 300:	e8 6b fe ff ff       	call   170 <runexp>
        wait();
 305:	e8 80 06 00 00       	call   98a <wait>
        printf(2, "end\n");
 30a:	50                   	push   %eax
 30b:	50                   	push   %eax
 30c:	68 76 0e 00 00       	push   $0xe76
 311:	6a 02                	push   $0x2
 313:	e8 b8 07 00 00       	call   ad0 <printf>
        close(0);
 318:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 31f:	e8 86 06 00 00       	call   9aa <close>
        if(open("./.etemp", O_RDONLY) < 0){
 324:	58                   	pop    %eax
 325:	5a                   	pop    %edx
 326:	6a 00                	push   $0x0
 328:	68 66 0e 00 00       	push   $0xe66
 32d:	e8 90 06 00 00       	call   9c2 <open>
 332:	83 c4 10             	add    $0x10,%esp
 335:	85 c0                	test   %eax,%eax
 337:	78 3f                	js     378 <runexp+0x208>
 339:	6b fb 15             	imul   $0x15,%ebx,%edi
 33c:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
 342:	01 c7                	add    %eax,%edi
        read(0,argvt[i],20);
 344:	50                   	push   %eax
 345:	6a 14                	push   $0x14
 347:	57                   	push   %edi
 348:	6a 00                	push   $0x0
 34a:	e8 4b 06 00 00       	call   99a <read>
        argv[i]=argvt[i];
 34f:	89 bc 9d ec fe ff ff 	mov    %edi,-0x114(%ebp,%ebx,4)
 356:	83 c4 10             	add    $0x10,%esp
 359:	e9 a4 fe ff ff       	jmp    202 <runexp+0x92>
        panic("syntax");
 35e:	83 ec 0c             	sub    $0xc,%esp
 361:	68 5a 0e 00 00       	push   $0xe5a
 366:	e8 e5 fd ff ff       	call   150 <panic>
    panic("fork");
 36b:	83 ec 0c             	sub    $0xc,%esp
 36e:	68 61 0e 00 00       	push   $0xe61
 373:	e8 d8 fd ff ff       	call   150 <panic>
            printf(2, "open console temp file failed\n");
 378:	50                   	push   %eax
 379:	50                   	push   %eax
 37a:	68 bc 0e 00 00       	push   $0xebc
 37f:	6a 02                	push   $0x2
 381:	e8 4a 07 00 00       	call   ad0 <printf>
            exit();
 386:	e8 f7 05 00 00       	call   982 <exit>
 38b:	90                   	nop
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000390 <fork1>:
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
 396:	e8 df 05 00 00       	call   97a <fork>
  if(pid == -1)
 39b:	83 f8 ff             	cmp    $0xffffffff,%eax
 39e:	74 02                	je     3a2 <fork1+0x12>
  return pid;
}
 3a0:	c9                   	leave  
 3a1:	c3                   	ret    
    panic("fork");
 3a2:	83 ec 0c             	sub    $0xc,%esp
 3a5:	68 61 0e 00 00       	push   $0xe61
 3aa:	e8 a1 fd ff ff       	call   150 <panic>
 3af:	90                   	nop

000003b0 <atom>:
//PAGEBREAK!
// Constructors

struct sexp*
atom(void)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	53                   	push   %ebx
 3b4:	83 ec 10             	sub    $0x10,%esp
  struct atom *exp;

  exp= malloc(sizeof(*exp));
 3b7:	6a 0c                	push   $0xc
 3b9:	e8 72 09 00 00       	call   d30 <malloc>
  memset(exp, 0, sizeof(*exp));
 3be:	83 c4 0c             	add    $0xc,%esp
  exp= malloc(sizeof(*exp));
 3c1:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
 3c3:	6a 0c                	push   $0xc
 3c5:	6a 00                	push   $0x0
 3c7:	50                   	push   %eax
 3c8:	e8 13 04 00 00       	call   7e0 <memset>
  return (struct sexp*)exp;
}
 3cd:	89 d8                	mov    %ebx,%eax
 3cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3d2:	c9                   	leave  
 3d3:	c3                   	ret    
 3d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003e0 <list>:

struct sexp*
list(void)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	53                   	push   %ebx
 3e4:	83 ec 10             	sub    $0x10,%esp
  struct list*exp;

  exp= malloc(sizeof(*exp));
 3e7:	6a 30                	push   $0x30
 3e9:	e8 42 09 00 00       	call   d30 <malloc>
  memset(exp, 0, sizeof(*exp));
 3ee:	83 c4 0c             	add    $0xc,%esp
  exp= malloc(sizeof(*exp));
 3f1:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
 3f3:	6a 30                	push   $0x30
 3f5:	6a 00                	push   $0x0
 3f7:	50                   	push   %eax
 3f8:	e8 e3 03 00 00       	call   7e0 <memset>
  return (struct sexp*)exp;
}
 3fd:	89 d8                	mov    %ebx,%eax
 3ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 402:	c9                   	leave  
 403:	c3                   	ret    
 404:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 40a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000410 <peek>:
char whitespace[] = " \t\r\n\v";
char esymbols[] = "()";

int
peek(char **ps, char *es, char *toks)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
 416:	83 ec 0c             	sub    $0xc,%esp
 419:	8b 7d 08             	mov    0x8(%ebp),%edi
 41c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
 41f:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
 421:	39 f3                	cmp    %esi,%ebx
 423:	72 12                	jb     437 <peek+0x27>
 425:	eb 28                	jmp    44f <peek+0x3f>
 427:	89 f6                	mov    %esi,%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
 430:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
 433:	39 de                	cmp    %ebx,%esi
 435:	74 18                	je     44f <peek+0x3f>
 437:	0f be 03             	movsbl (%ebx),%eax
 43a:	83 ec 08             	sub    $0x8,%esp
 43d:	50                   	push   %eax
 43e:	68 8c 13 00 00       	push   $0x138c
 443:	e8 b8 03 00 00       	call   800 <strchr>
 448:	83 c4 10             	add    $0x10,%esp
 44b:	85 c0                	test   %eax,%eax
 44d:	75 e1                	jne    430 <peek+0x20>
  *ps = s;
 44f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
 451:	0f be 13             	movsbl (%ebx),%edx
 454:	31 c0                	xor    %eax,%eax
 456:	84 d2                	test   %dl,%dl
 458:	74 17                	je     471 <peek+0x61>
 45a:	83 ec 08             	sub    $0x8,%esp
 45d:	52                   	push   %edx
 45e:	ff 75 10             	pushl  0x10(%ebp)
 461:	e8 9a 03 00 00       	call   800 <strchr>
 466:	83 c4 10             	add    $0x10,%esp
 469:	85 c0                	test   %eax,%eax
 46b:	0f 95 c0             	setne  %al
 46e:	0f b6 c0             	movzbl %al,%eax
}
 471:	8d 65 f4             	lea    -0xc(%ebp),%esp
 474:	5b                   	pop    %ebx
 475:	5e                   	pop    %esi
 476:	5f                   	pop    %edi
 477:	5d                   	pop    %ebp
 478:	c3                   	ret    
 479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000480 <parseatom>:
  return ret;
}

struct sexp*
parseatom(char **ps, char *es)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
 486:	83 ec 0c             	sub    $0xc,%esp
 489:	8b 7d 08             	mov    0x8(%ebp),%edi
 48c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct atom *atm;
  struct sexp *ret;

  char *s=*ps;
 48f:	8b 37                	mov    (%edi),%esi
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
 491:	39 de                	cmp    %ebx,%esi
 493:	89 f0                	mov    %esi,%eax
 495:	72 2e                	jb     4c5 <parseatom+0x45>
 497:	eb 44                	jmp    4dd <parseatom+0x5d>
 499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4a0:	8b 07                	mov    (%edi),%eax
 4a2:	83 ec 08             	sub    $0x8,%esp
 4a5:	0f be 00             	movsbl (%eax),%eax
 4a8:	50                   	push   %eax
 4a9:	68 88 13 00 00       	push   $0x1388
 4ae:	e8 4d 03 00 00       	call   800 <strchr>
 4b3:	83 c4 10             	add    $0x10,%esp
 4b6:	85 c0                	test   %eax,%eax
 4b8:	75 23                	jne    4dd <parseatom+0x5d>
    (*ps)++;
 4ba:	8b 07                	mov    (%edi),%eax
 4bc:	83 c0 01             	add    $0x1,%eax
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
 4bf:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
 4c1:	89 07                	mov    %eax,(%edi)
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
 4c3:	73 18                	jae    4dd <parseatom+0x5d>
 4c5:	0f be 00             	movsbl (%eax),%eax
 4c8:	83 ec 08             	sub    $0x8,%esp
 4cb:	50                   	push   %eax
 4cc:	68 8c 13 00 00       	push   $0x138c
 4d1:	e8 2a 03 00 00       	call   800 <strchr>
 4d6:	83 c4 10             	add    $0x10,%esp
 4d9:	85 c0                	test   %eax,%eax
 4db:	74 c3                	je     4a0 <parseatom+0x20>

  ret=atom();
 4dd:	e8 ce fe ff ff       	call   3b0 <atom>
  atm=(struct atom*)ret;

  atm->type=ATOM;
 4e2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  atm->symbol=s;
 4e8:	89 70 04             	mov    %esi,0x4(%eax)
  atm->esymbol=*ps;
 4eb:	8b 17                	mov    (%edi),%edx
 4ed:	89 50 08             	mov    %edx,0x8(%eax)

  return ret;
}
 4f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    
 4f8:	90                   	nop
 4f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000500 <parsesexp>:

struct sexp*
parsesexp(char **ps, char *es)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	56                   	push   %esi
 504:	53                   	push   %ebx
 505:	8b 75 08             	mov    0x8(%ebp),%esi
 508:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct sexp *ret=0;

  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 50b:	8b 06                	mov    (%esi),%eax
 50d:	39 c3                	cmp    %eax,%ebx
 50f:	77 10                	ja     521 <parsesexp+0x21>
 511:	eb 28                	jmp    53b <parsesexp+0x3b>
 513:	90                   	nop
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    (*ps)++;
 518:	83 c0 01             	add    $0x1,%eax
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 51b:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
 51d:	89 06                	mov    %eax,(%esi)
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 51f:	73 1a                	jae    53b <parsesexp+0x3b>
 521:	0f be 00             	movsbl (%eax),%eax
 524:	83 ec 08             	sub    $0x8,%esp
 527:	50                   	push   %eax
 528:	68 8c 13 00 00       	push   $0x138c
 52d:	e8 ce 02 00 00       	call   800 <strchr>
 532:	83 c4 10             	add    $0x10,%esp
 535:	85 c0                	test   %eax,%eax
    (*ps)++;
 537:	8b 06                	mov    (%esi),%eax
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 539:	75 dd                	jne    518 <parsesexp+0x18>
  switch(*(*ps)){
 53b:	0f b6 10             	movzbl (%eax),%edx
 53e:	80 fa 27             	cmp    $0x27,%dl
 541:	74 55                	je     598 <parsesexp+0x98>
 543:	80 fa 28             	cmp    $0x28,%dl
 546:	74 28                	je     570 <parsesexp+0x70>
 548:	84 d2                	test   %dl,%dl
 54a:	74 14                	je     560 <parsesexp+0x60>
    (*ps)+=2;
    ret=parselist(ps, es);
    (*ps)++;
    break;
  default:
    ret=parseatom(ps, es);
 54c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
 54f:	89 75 08             	mov    %esi,0x8(%ebp)
    break;
  }
  return ret;
}
 552:	8d 65 f8             	lea    -0x8(%ebp),%esp
 555:	5b                   	pop    %ebx
 556:	5e                   	pop    %esi
 557:	5d                   	pop    %ebp
    ret=parseatom(ps, es);
 558:	e9 23 ff ff ff       	jmp    480 <parseatom>
 55d:	8d 76 00             	lea    0x0(%esi),%esi
}
 560:	8d 65 f8             	lea    -0x8(%ebp),%esp
  struct sexp *ret=0;
 563:	31 c0                	xor    %eax,%eax
}
 565:	5b                   	pop    %ebx
 566:	5e                   	pop    %esi
 567:	5d                   	pop    %ebp
 568:	c3                   	ret    
 569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret=parselist(ps, es);
 570:	83 ec 08             	sub    $0x8,%esp
    (*ps)++;
 573:	83 c0 01             	add    $0x1,%eax
 576:	89 06                	mov    %eax,(%esi)
    ret=parselist(ps, es);
 578:	53                   	push   %ebx
 579:	56                   	push   %esi
 57a:	e8 41 00 00 00       	call   5c0 <parselist>
    ret->type=APPLY;
 57f:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    break;
 585:	83 c4 10             	add    $0x10,%esp
    (*ps)++;
 588:	83 06 01             	addl   $0x1,(%esi)
}
 58b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 58e:	5b                   	pop    %ebx
 58f:	5e                   	pop    %esi
 590:	5d                   	pop    %ebp
 591:	c3                   	ret    
 592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ret=parselist(ps, es);
 598:	83 ec 08             	sub    $0x8,%esp
    (*ps)+=2;
 59b:	83 c0 02             	add    $0x2,%eax
 59e:	89 06                	mov    %eax,(%esi)
    ret=parselist(ps, es);
 5a0:	53                   	push   %ebx
 5a1:	56                   	push   %esi
 5a2:	e8 19 00 00 00       	call   5c0 <parselist>
    (*ps)++;
 5a7:	83 06 01             	addl   $0x1,(%esi)
    break;
 5aa:	83 c4 10             	add    $0x10,%esp
}
 5ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5b0:	5b                   	pop    %ebx
 5b1:	5e                   	pop    %esi
 5b2:	5d                   	pop    %ebp
 5b3:	c3                   	ret    
 5b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000005c0 <parselist>:
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	56                   	push   %esi
 5c5:	53                   	push   %ebx
 5c6:	83 ec 1c             	sub    $0x1c,%esp
 5c9:	8b 75 08             	mov    0x8(%ebp),%esi
 5cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  ret=list();
 5cf:	e8 0c fe ff ff       	call   3e0 <list>
  lst->type=LIST;
 5d4:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  ret=list();
 5da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *res=*ps;
 5dd:	8b 0e                	mov    (%esi),%ecx
  while(res<es)
 5df:	39 f9                	cmp    %edi,%ecx
 5e1:	89 cb                	mov    %ecx,%ebx
 5e3:	73 3b                	jae    620 <parselist+0x60>
  int i=1;
 5e5:	ba 01 00 00 00       	mov    $0x1,%edx
 5ea:	eb 14                	jmp    600 <parselist+0x40>
 5ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*res==')')
 5f0:	3c 29                	cmp    $0x29,%al
 5f2:	75 05                	jne    5f9 <parselist+0x39>
      if(i==0)
 5f4:	83 ea 01             	sub    $0x1,%edx
 5f7:	74 27                	je     620 <parselist+0x60>
    res++;
 5f9:	83 c3 01             	add    $0x1,%ebx
  while(res<es)
 5fc:	39 df                	cmp    %ebx,%edi
 5fe:	74 11                	je     611 <parselist+0x51>
    if(*res=='(')
 600:	0f b6 03             	movzbl (%ebx),%eax
 603:	3c 28                	cmp    $0x28,%al
 605:	75 e9                	jne    5f0 <parselist+0x30>
    res++;
 607:	83 c3 01             	add    $0x1,%ebx
      i++;
 60a:	83 c2 01             	add    $0x1,%edx
  while(res<es)
 60d:	39 df                	cmp    %ebx,%edi
 60f:	75 ef                	jne    600 <parselist+0x40>
    panic("syntax");
 611:	83 ec 0c             	sub    $0xc,%esp
 614:	68 5a 0e 00 00       	push   $0xe5a
 619:	e8 32 fb ff ff       	call   150 <panic>
 61e:	66 90                	xchg   %ax,%ax
  if(res==es)
 620:	39 df                	cmp    %ebx,%edi
 622:	74 ed                	je     611 <parselist+0x51>
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
 624:	31 ff                	xor    %edi,%edi
 626:	eb 0a                	jmp    632 <parselist+0x72>
 628:	90                   	nop
 629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 630:	8b 0e                	mov    (%esi),%ecx
 632:	39 d9                	cmp    %ebx,%ecx
 634:	73 1c                	jae    652 <parselist+0x92>
    lst->sexps[i]=parsesexp(ps, res);
 636:	83 ec 08             	sub    $0x8,%esp
 639:	53                   	push   %ebx
 63a:	56                   	push   %esi
 63b:	e8 c0 fe ff ff       	call   500 <parsesexp>
 640:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
 643:	83 c4 10             	add    $0x10,%esp
    lst->sexps[i]=parsesexp(ps, res);
 646:	89 44 ba 08          	mov    %eax,0x8(%edx,%edi,4)
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
 64a:	83 c7 01             	add    $0x1,%edi
 64d:	83 ff 0a             	cmp    $0xa,%edi
 650:	75 de                	jne    630 <parselist+0x70>
  lst->length=i;
 652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 655:	89 78 04             	mov    %edi,0x4(%eax)
}
 658:	8d 65 f4             	lea    -0xc(%ebp),%esp
 65b:	5b                   	pop    %ebx
 65c:	5e                   	pop    %esi
 65d:	5f                   	pop    %edi
 65e:	5d                   	pop    %ebp
 65f:	c3                   	ret    

00000660 <snulterminate>:
  return exp;
}

struct sexp*
snulterminate(struct sexp *exp)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	56                   	push   %esi
 664:	53                   	push   %ebx
 665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;
  struct list *lst;
  struct atom *atm;

  if(exp== 0)
 668:	85 db                	test   %ebx,%ebx
 66a:	74 2e                	je     69a <snulterminate+0x3a>
    return 0;

  switch(exp->type){
 66c:	8b 03                	mov    (%ebx),%eax
 66e:	83 f8 01             	cmp    $0x1,%eax
 671:	74 35                	je     6a8 <snulterminate+0x48>
 673:	7c 25                	jl     69a <snulterminate+0x3a>
 675:	83 f8 03             	cmp    $0x3,%eax
 678:	7f 20                	jg     69a <snulterminate+0x3a>
    break;

  case APPLY:
  case LIST:
    lst = (struct list*)exp;
    for(i=0;i<lst->length;i++)
 67a:	8b 43 04             	mov    0x4(%ebx),%eax
 67d:	31 f6                	xor    %esi,%esi
 67f:	85 c0                	test   %eax,%eax
 681:	7e 17                	jle    69a <snulterminate+0x3a>
      snulterminate(lst->sexps[i]);
 683:	83 ec 0c             	sub    $0xc,%esp
 686:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
    for(i=0;i<lst->length;i++)
 68a:	83 c6 01             	add    $0x1,%esi
      snulterminate(lst->sexps[i]);
 68d:	e8 ce ff ff ff       	call   660 <snulterminate>
    for(i=0;i<lst->length;i++)
 692:	83 c4 10             	add    $0x10,%esp
 695:	3b 73 04             	cmp    0x4(%ebx),%esi
 698:	7c e9                	jl     683 <snulterminate+0x23>
    break;
  }
  return exp;
}
 69a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 69d:	89 d8                	mov    %ebx,%eax
 69f:	5b                   	pop    %ebx
 6a0:	5e                   	pop    %esi
 6a1:	5d                   	pop    %ebp
 6a2:	c3                   	ret    
 6a3:	90                   	nop
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *atm->esymbol = 0;
 6a8:	8b 43 08             	mov    0x8(%ebx),%eax
 6ab:	c6 00 00             	movb   $0x0,(%eax)
}
 6ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6b1:	89 d8                	mov    %ebx,%eax
 6b3:	5b                   	pop    %ebx
 6b4:	5e                   	pop    %esi
 6b5:	5d                   	pop    %ebp
 6b6:	c3                   	ret    
 6b7:	89 f6                	mov    %esi,%esi
 6b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006c0 <parseexp>:
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	56                   	push   %esi
 6c4:	53                   	push   %ebx
  es = s + strlen(s);
 6c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6c8:	83 ec 0c             	sub    $0xc,%esp
 6cb:	53                   	push   %ebx
 6cc:	e8 df 00 00 00       	call   7b0 <strlen>
  exp= parsesexp(&s, es);
 6d1:	59                   	pop    %ecx
  es = s + strlen(s);
 6d2:	01 c3                	add    %eax,%ebx
  exp= parsesexp(&s, es);
 6d4:	8d 45 08             	lea    0x8(%ebp),%eax
 6d7:	5e                   	pop    %esi
 6d8:	53                   	push   %ebx
 6d9:	50                   	push   %eax
 6da:	e8 21 fe ff ff       	call   500 <parsesexp>
 6df:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
 6e1:	8d 45 08             	lea    0x8(%ebp),%eax
 6e4:	83 c4 0c             	add    $0xc,%esp
 6e7:	68 37 0e 00 00       	push   $0xe37
 6ec:	53                   	push   %ebx
 6ed:	50                   	push   %eax
 6ee:	e8 1d fd ff ff       	call   410 <peek>
  if(s != es){
 6f3:	8b 45 08             	mov    0x8(%ebp),%eax
 6f6:	83 c4 10             	add    $0x10,%esp
 6f9:	39 d8                	cmp    %ebx,%eax
 6fb:	75 12                	jne    70f <parseexp+0x4f>
  snulterminate(exp);
 6fd:	83 ec 0c             	sub    $0xc,%esp
 700:	56                   	push   %esi
 701:	e8 5a ff ff ff       	call   660 <snulterminate>
}
 706:	8d 65 f8             	lea    -0x8(%ebp),%esp
 709:	89 f0                	mov    %esi,%eax
 70b:	5b                   	pop    %ebx
 70c:	5e                   	pop    %esi
 70d:	5d                   	pop    %ebp
 70e:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
 70f:	52                   	push   %edx
 710:	50                   	push   %eax
 711:	68 95 0e 00 00       	push   $0xe95
 716:	6a 02                	push   $0x2
 718:	e8 b3 03 00 00       	call   ad0 <printf>
    panic("syntax");
 71d:	c7 04 24 5a 0e 00 00 	movl   $0xe5a,(%esp)
 724:	e8 27 fa ff ff       	call   150 <panic>
 729:	66 90                	xchg   %ax,%ax
 72b:	66 90                	xchg   %ax,%ax
 72d:	66 90                	xchg   %ax,%ax
 72f:	90                   	nop

00000730 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	53                   	push   %ebx
 734:	8b 45 08             	mov    0x8(%ebp),%eax
 737:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 73a:	89 c2                	mov    %eax,%edx
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 740:	83 c1 01             	add    $0x1,%ecx
 743:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 747:	83 c2 01             	add    $0x1,%edx
 74a:	84 db                	test   %bl,%bl
 74c:	88 5a ff             	mov    %bl,-0x1(%edx)
 74f:	75 ef                	jne    740 <strcpy+0x10>
    ;
  return os;
}
 751:	5b                   	pop    %ebx
 752:	5d                   	pop    %ebp
 753:	c3                   	ret    
 754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 75a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000760 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	53                   	push   %ebx
 764:	8b 55 08             	mov    0x8(%ebp),%edx
 767:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 76a:	0f b6 02             	movzbl (%edx),%eax
 76d:	0f b6 19             	movzbl (%ecx),%ebx
 770:	84 c0                	test   %al,%al
 772:	75 1c                	jne    790 <strcmp+0x30>
 774:	eb 2a                	jmp    7a0 <strcmp+0x40>
 776:	8d 76 00             	lea    0x0(%esi),%esi
 779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 780:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 783:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 786:	83 c1 01             	add    $0x1,%ecx
 789:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 78c:	84 c0                	test   %al,%al
 78e:	74 10                	je     7a0 <strcmp+0x40>
 790:	38 d8                	cmp    %bl,%al
 792:	74 ec                	je     780 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 794:	29 d8                	sub    %ebx,%eax
}
 796:	5b                   	pop    %ebx
 797:	5d                   	pop    %ebp
 798:	c3                   	ret    
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 7a2:	29 d8                	sub    %ebx,%eax
}
 7a4:	5b                   	pop    %ebx
 7a5:	5d                   	pop    %ebp
 7a6:	c3                   	ret    
 7a7:	89 f6                	mov    %esi,%esi
 7a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007b0 <strlen>:

uint
strlen(char *s)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 7b6:	80 39 00             	cmpb   $0x0,(%ecx)
 7b9:	74 15                	je     7d0 <strlen+0x20>
 7bb:	31 d2                	xor    %edx,%edx
 7bd:	8d 76 00             	lea    0x0(%esi),%esi
 7c0:	83 c2 01             	add    $0x1,%edx
 7c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 7c7:	89 d0                	mov    %edx,%eax
 7c9:	75 f5                	jne    7c0 <strlen+0x10>
    ;
  return n;
}
 7cb:	5d                   	pop    %ebp
 7cc:	c3                   	ret    
 7cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 7d0:	31 c0                	xor    %eax,%eax
}
 7d2:	5d                   	pop    %ebp
 7d3:	c3                   	ret    
 7d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000007e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 7e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 7ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ed:	89 d7                	mov    %edx,%edi
 7ef:	fc                   	cld    
 7f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 7f2:	89 d0                	mov    %edx,%eax
 7f4:	5f                   	pop    %edi
 7f5:	5d                   	pop    %ebp
 7f6:	c3                   	ret    
 7f7:	89 f6                	mov    %esi,%esi
 7f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000800 <strchr>:

char*
strchr(const char *s, char c)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	53                   	push   %ebx
 804:	8b 45 08             	mov    0x8(%ebp),%eax
 807:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 80a:	0f b6 10             	movzbl (%eax),%edx
 80d:	84 d2                	test   %dl,%dl
 80f:	74 1d                	je     82e <strchr+0x2e>
    if(*s == c)
 811:	38 d3                	cmp    %dl,%bl
 813:	89 d9                	mov    %ebx,%ecx
 815:	75 0d                	jne    824 <strchr+0x24>
 817:	eb 17                	jmp    830 <strchr+0x30>
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 820:	38 ca                	cmp    %cl,%dl
 822:	74 0c                	je     830 <strchr+0x30>
  for(; *s; s++)
 824:	83 c0 01             	add    $0x1,%eax
 827:	0f b6 10             	movzbl (%eax),%edx
 82a:	84 d2                	test   %dl,%dl
 82c:	75 f2                	jne    820 <strchr+0x20>
      return (char*)s;
  return 0;
 82e:	31 c0                	xor    %eax,%eax
}
 830:	5b                   	pop    %ebx
 831:	5d                   	pop    %ebp
 832:	c3                   	ret    
 833:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000840 <gets>:

char*
gets(char *buf, int max)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	57                   	push   %edi
 844:	56                   	push   %esi
 845:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 846:	31 f6                	xor    %esi,%esi
 848:	89 f3                	mov    %esi,%ebx
{
 84a:	83 ec 1c             	sub    $0x1c,%esp
 84d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 850:	eb 2f                	jmp    881 <gets+0x41>
 852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 858:	8d 45 e7             	lea    -0x19(%ebp),%eax
 85b:	83 ec 04             	sub    $0x4,%esp
 85e:	6a 01                	push   $0x1
 860:	50                   	push   %eax
 861:	6a 00                	push   $0x0
 863:	e8 32 01 00 00       	call   99a <read>
    if(cc < 1)
 868:	83 c4 10             	add    $0x10,%esp
 86b:	85 c0                	test   %eax,%eax
 86d:	7e 1c                	jle    88b <gets+0x4b>
      break;
    buf[i++] = c;
 86f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 873:	83 c7 01             	add    $0x1,%edi
 876:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 879:	3c 0a                	cmp    $0xa,%al
 87b:	74 23                	je     8a0 <gets+0x60>
 87d:	3c 0d                	cmp    $0xd,%al
 87f:	74 1f                	je     8a0 <gets+0x60>
  for(i=0; i+1 < max; ){
 881:	83 c3 01             	add    $0x1,%ebx
 884:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 887:	89 fe                	mov    %edi,%esi
 889:	7c cd                	jl     858 <gets+0x18>
 88b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 88d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 890:	c6 03 00             	movb   $0x0,(%ebx)
}
 893:	8d 65 f4             	lea    -0xc(%ebp),%esp
 896:	5b                   	pop    %ebx
 897:	5e                   	pop    %esi
 898:	5f                   	pop    %edi
 899:	5d                   	pop    %ebp
 89a:	c3                   	ret    
 89b:	90                   	nop
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8a0:	8b 75 08             	mov    0x8(%ebp),%esi
 8a3:	8b 45 08             	mov    0x8(%ebp),%eax
 8a6:	01 de                	add    %ebx,%esi
 8a8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 8aa:	c6 03 00             	movb   $0x0,(%ebx)
}
 8ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8b0:	5b                   	pop    %ebx
 8b1:	5e                   	pop    %esi
 8b2:	5f                   	pop    %edi
 8b3:	5d                   	pop    %ebp
 8b4:	c3                   	ret    
 8b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008c0 <stat>:

int
stat(char *n, struct stat *st)
{
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	56                   	push   %esi
 8c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 8c5:	83 ec 08             	sub    $0x8,%esp
 8c8:	6a 00                	push   $0x0
 8ca:	ff 75 08             	pushl  0x8(%ebp)
 8cd:	e8 f0 00 00 00       	call   9c2 <open>
  if(fd < 0)
 8d2:	83 c4 10             	add    $0x10,%esp
 8d5:	85 c0                	test   %eax,%eax
 8d7:	78 27                	js     900 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 8d9:	83 ec 08             	sub    $0x8,%esp
 8dc:	ff 75 0c             	pushl  0xc(%ebp)
 8df:	89 c3                	mov    %eax,%ebx
 8e1:	50                   	push   %eax
 8e2:	e8 f3 00 00 00       	call   9da <fstat>
  close(fd);
 8e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 8ea:	89 c6                	mov    %eax,%esi
  close(fd);
 8ec:	e8 b9 00 00 00       	call   9aa <close>
  return r;
 8f1:	83 c4 10             	add    $0x10,%esp
}
 8f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8f7:	89 f0                	mov    %esi,%eax
 8f9:	5b                   	pop    %ebx
 8fa:	5e                   	pop    %esi
 8fb:	5d                   	pop    %ebp
 8fc:	c3                   	ret    
 8fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 900:	be ff ff ff ff       	mov    $0xffffffff,%esi
 905:	eb ed                	jmp    8f4 <stat+0x34>
 907:	89 f6                	mov    %esi,%esi
 909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000910 <atoi>:

int
atoi(const char *s)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	53                   	push   %ebx
 914:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 917:	0f be 11             	movsbl (%ecx),%edx
 91a:	8d 42 d0             	lea    -0x30(%edx),%eax
 91d:	3c 09                	cmp    $0x9,%al
  n = 0;
 91f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 924:	77 1f                	ja     945 <atoi+0x35>
 926:	8d 76 00             	lea    0x0(%esi),%esi
 929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 930:	8d 04 80             	lea    (%eax,%eax,4),%eax
 933:	83 c1 01             	add    $0x1,%ecx
 936:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 93a:	0f be 11             	movsbl (%ecx),%edx
 93d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 940:	80 fb 09             	cmp    $0x9,%bl
 943:	76 eb                	jbe    930 <atoi+0x20>
  return n;
}
 945:	5b                   	pop    %ebx
 946:	5d                   	pop    %ebp
 947:	c3                   	ret    
 948:	90                   	nop
 949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000950 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	56                   	push   %esi
 954:	53                   	push   %ebx
 955:	8b 5d 10             	mov    0x10(%ebp),%ebx
 958:	8b 45 08             	mov    0x8(%ebp),%eax
 95b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 95e:	85 db                	test   %ebx,%ebx
 960:	7e 14                	jle    976 <memmove+0x26>
 962:	31 d2                	xor    %edx,%edx
 964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 968:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 96c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 96f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 972:	39 d3                	cmp    %edx,%ebx
 974:	75 f2                	jne    968 <memmove+0x18>
  return vdst;
}
 976:	5b                   	pop    %ebx
 977:	5e                   	pop    %esi
 978:	5d                   	pop    %ebp
 979:	c3                   	ret    

0000097a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 97a:	b8 01 00 00 00       	mov    $0x1,%eax
 97f:	cd 40                	int    $0x40
 981:	c3                   	ret    

00000982 <exit>:
SYSCALL(exit)
 982:	b8 02 00 00 00       	mov    $0x2,%eax
 987:	cd 40                	int    $0x40
 989:	c3                   	ret    

0000098a <wait>:
SYSCALL(wait)
 98a:	b8 03 00 00 00       	mov    $0x3,%eax
 98f:	cd 40                	int    $0x40
 991:	c3                   	ret    

00000992 <pipe>:
SYSCALL(pipe)
 992:	b8 04 00 00 00       	mov    $0x4,%eax
 997:	cd 40                	int    $0x40
 999:	c3                   	ret    

0000099a <read>:
SYSCALL(read)
 99a:	b8 05 00 00 00       	mov    $0x5,%eax
 99f:	cd 40                	int    $0x40
 9a1:	c3                   	ret    

000009a2 <write>:
SYSCALL(write)
 9a2:	b8 10 00 00 00       	mov    $0x10,%eax
 9a7:	cd 40                	int    $0x40
 9a9:	c3                   	ret    

000009aa <close>:
SYSCALL(close)
 9aa:	b8 15 00 00 00       	mov    $0x15,%eax
 9af:	cd 40                	int    $0x40
 9b1:	c3                   	ret    

000009b2 <kill>:
SYSCALL(kill)
 9b2:	b8 06 00 00 00       	mov    $0x6,%eax
 9b7:	cd 40                	int    $0x40
 9b9:	c3                   	ret    

000009ba <exec>:
SYSCALL(exec)
 9ba:	b8 07 00 00 00       	mov    $0x7,%eax
 9bf:	cd 40                	int    $0x40
 9c1:	c3                   	ret    

000009c2 <open>:
SYSCALL(open)
 9c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 9c7:	cd 40                	int    $0x40
 9c9:	c3                   	ret    

000009ca <mknod>:
SYSCALL(mknod)
 9ca:	b8 11 00 00 00       	mov    $0x11,%eax
 9cf:	cd 40                	int    $0x40
 9d1:	c3                   	ret    

000009d2 <unlink>:
SYSCALL(unlink)
 9d2:	b8 12 00 00 00       	mov    $0x12,%eax
 9d7:	cd 40                	int    $0x40
 9d9:	c3                   	ret    

000009da <fstat>:
SYSCALL(fstat)
 9da:	b8 08 00 00 00       	mov    $0x8,%eax
 9df:	cd 40                	int    $0x40
 9e1:	c3                   	ret    

000009e2 <link>:
SYSCALL(link)
 9e2:	b8 13 00 00 00       	mov    $0x13,%eax
 9e7:	cd 40                	int    $0x40
 9e9:	c3                   	ret    

000009ea <mkdir>:
SYSCALL(mkdir)
 9ea:	b8 14 00 00 00       	mov    $0x14,%eax
 9ef:	cd 40                	int    $0x40
 9f1:	c3                   	ret    

000009f2 <chdir>:
SYSCALL(chdir)
 9f2:	b8 09 00 00 00       	mov    $0x9,%eax
 9f7:	cd 40                	int    $0x40
 9f9:	c3                   	ret    

000009fa <dup>:
SYSCALL(dup)
 9fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 9ff:	cd 40                	int    $0x40
 a01:	c3                   	ret    

00000a02 <getpid>:
SYSCALL(getpid)
 a02:	b8 0b 00 00 00       	mov    $0xb,%eax
 a07:	cd 40                	int    $0x40
 a09:	c3                   	ret    

00000a0a <sbrk>:
SYSCALL(sbrk)
 a0a:	b8 0c 00 00 00       	mov    $0xc,%eax
 a0f:	cd 40                	int    $0x40
 a11:	c3                   	ret    

00000a12 <sleep>:
SYSCALL(sleep)
 a12:	b8 0d 00 00 00       	mov    $0xd,%eax
 a17:	cd 40                	int    $0x40
 a19:	c3                   	ret    

00000a1a <uptime>:
SYSCALL(uptime)
 a1a:	b8 0e 00 00 00       	mov    $0xe,%eax
 a1f:	cd 40                	int    $0x40
 a21:	c3                   	ret    

00000a22 <trace>:
SYSCALL(trace)
 a22:	b8 16 00 00 00       	mov    $0x16,%eax
 a27:	cd 40                	int    $0x40
 a29:	c3                   	ret    
 a2a:	66 90                	xchg   %ax,%ax
 a2c:	66 90                	xchg   %ax,%ax
 a2e:	66 90                	xchg   %ax,%ax

00000a30 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 a30:	55                   	push   %ebp
 a31:	89 e5                	mov    %esp,%ebp
 a33:	57                   	push   %edi
 a34:	56                   	push   %esi
 a35:	53                   	push   %ebx
 a36:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a39:	85 d2                	test   %edx,%edx
{
 a3b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 a3e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 a40:	79 76                	jns    ab8 <printint+0x88>
 a42:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 a46:	74 70                	je     ab8 <printint+0x88>
    x = -xx;
 a48:	f7 d8                	neg    %eax
    neg = 1;
 a4a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 a51:	31 f6                	xor    %esi,%esi
 a53:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 a56:	eb 0a                	jmp    a62 <printint+0x32>
 a58:	90                   	nop
 a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 a60:	89 fe                	mov    %edi,%esi
 a62:	31 d2                	xor    %edx,%edx
 a64:	8d 7e 01             	lea    0x1(%esi),%edi
 a67:	f7 f1                	div    %ecx
 a69:	0f b6 92 e4 0e 00 00 	movzbl 0xee4(%edx),%edx
  }while((x /= base) != 0);
 a70:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 a72:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 a75:	75 e9                	jne    a60 <printint+0x30>
  if(neg)
 a77:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 a7a:	85 c0                	test   %eax,%eax
 a7c:	74 08                	je     a86 <printint+0x56>
    buf[i++] = '-';
 a7e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 a83:	8d 7e 02             	lea    0x2(%esi),%edi
 a86:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 a8a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 a8d:	8d 76 00             	lea    0x0(%esi),%esi
 a90:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 a93:	83 ec 04             	sub    $0x4,%esp
 a96:	83 ee 01             	sub    $0x1,%esi
 a99:	6a 01                	push   $0x1
 a9b:	53                   	push   %ebx
 a9c:	57                   	push   %edi
 a9d:	88 45 d7             	mov    %al,-0x29(%ebp)
 aa0:	e8 fd fe ff ff       	call   9a2 <write>

  while(--i >= 0)
 aa5:	83 c4 10             	add    $0x10,%esp
 aa8:	39 de                	cmp    %ebx,%esi
 aaa:	75 e4                	jne    a90 <printint+0x60>
    putc(fd, buf[i]);
}
 aac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 aaf:	5b                   	pop    %ebx
 ab0:	5e                   	pop    %esi
 ab1:	5f                   	pop    %edi
 ab2:	5d                   	pop    %ebp
 ab3:	c3                   	ret    
 ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 ab8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 abf:	eb 90                	jmp    a51 <printint+0x21>
 ac1:	eb 0d                	jmp    ad0 <printf>
 ac3:	90                   	nop
 ac4:	90                   	nop
 ac5:	90                   	nop
 ac6:	90                   	nop
 ac7:	90                   	nop
 ac8:	90                   	nop
 ac9:	90                   	nop
 aca:	90                   	nop
 acb:	90                   	nop
 acc:	90                   	nop
 acd:	90                   	nop
 ace:	90                   	nop
 acf:	90                   	nop

00000ad0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 ad0:	55                   	push   %ebp
 ad1:	89 e5                	mov    %esp,%ebp
 ad3:	57                   	push   %edi
 ad4:	56                   	push   %esi
 ad5:	53                   	push   %ebx
 ad6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 ad9:	8b 75 0c             	mov    0xc(%ebp),%esi
 adc:	0f b6 1e             	movzbl (%esi),%ebx
 adf:	84 db                	test   %bl,%bl
 ae1:	0f 84 b3 00 00 00    	je     b9a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 ae7:	8d 45 10             	lea    0x10(%ebp),%eax
 aea:	83 c6 01             	add    $0x1,%esi
  state = 0;
 aed:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 aef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 af2:	eb 2f                	jmp    b23 <printf+0x53>
 af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 af8:	83 f8 25             	cmp    $0x25,%eax
 afb:	0f 84 a7 00 00 00    	je     ba8 <printf+0xd8>
  write(fd, &c, 1);
 b01:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 b04:	83 ec 04             	sub    $0x4,%esp
 b07:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 b0a:	6a 01                	push   $0x1
 b0c:	50                   	push   %eax
 b0d:	ff 75 08             	pushl  0x8(%ebp)
 b10:	e8 8d fe ff ff       	call   9a2 <write>
 b15:	83 c4 10             	add    $0x10,%esp
 b18:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 b1b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 b1f:	84 db                	test   %bl,%bl
 b21:	74 77                	je     b9a <printf+0xca>
    if(state == 0){
 b23:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 b25:	0f be cb             	movsbl %bl,%ecx
 b28:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 b2b:	74 cb                	je     af8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 b2d:	83 ff 25             	cmp    $0x25,%edi
 b30:	75 e6                	jne    b18 <printf+0x48>
      if(c == 'd'){
 b32:	83 f8 64             	cmp    $0x64,%eax
 b35:	0f 84 05 01 00 00    	je     c40 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 b3b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 b41:	83 f9 70             	cmp    $0x70,%ecx
 b44:	74 72                	je     bb8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 b46:	83 f8 73             	cmp    $0x73,%eax
 b49:	0f 84 99 00 00 00    	je     be8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b4f:	83 f8 63             	cmp    $0x63,%eax
 b52:	0f 84 08 01 00 00    	je     c60 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 b58:	83 f8 25             	cmp    $0x25,%eax
 b5b:	0f 84 ef 00 00 00    	je     c50 <printf+0x180>
  write(fd, &c, 1);
 b61:	8d 45 e7             	lea    -0x19(%ebp),%eax
 b64:	83 ec 04             	sub    $0x4,%esp
 b67:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 b6b:	6a 01                	push   $0x1
 b6d:	50                   	push   %eax
 b6e:	ff 75 08             	pushl  0x8(%ebp)
 b71:	e8 2c fe ff ff       	call   9a2 <write>
 b76:	83 c4 0c             	add    $0xc,%esp
 b79:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 b7c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 b7f:	6a 01                	push   $0x1
 b81:	50                   	push   %eax
 b82:	ff 75 08             	pushl  0x8(%ebp)
 b85:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b88:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 b8a:	e8 13 fe ff ff       	call   9a2 <write>
  for(i = 0; fmt[i]; i++){
 b8f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 b93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 b96:	84 db                	test   %bl,%bl
 b98:	75 89                	jne    b23 <printf+0x53>
    }
  }
}
 b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b9d:	5b                   	pop    %ebx
 b9e:	5e                   	pop    %esi
 b9f:	5f                   	pop    %edi
 ba0:	5d                   	pop    %ebp
 ba1:	c3                   	ret    
 ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 ba8:	bf 25 00 00 00       	mov    $0x25,%edi
 bad:	e9 66 ff ff ff       	jmp    b18 <printf+0x48>
 bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 bb8:	83 ec 0c             	sub    $0xc,%esp
 bbb:	b9 10 00 00 00       	mov    $0x10,%ecx
 bc0:	6a 00                	push   $0x0
 bc2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 bc5:	8b 45 08             	mov    0x8(%ebp),%eax
 bc8:	8b 17                	mov    (%edi),%edx
 bca:	e8 61 fe ff ff       	call   a30 <printint>
        ap++;
 bcf:	89 f8                	mov    %edi,%eax
 bd1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 bd4:	31 ff                	xor    %edi,%edi
        ap++;
 bd6:	83 c0 04             	add    $0x4,%eax
 bd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 bdc:	e9 37 ff ff ff       	jmp    b18 <printf+0x48>
 be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 be8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 beb:	8b 08                	mov    (%eax),%ecx
        ap++;
 bed:	83 c0 04             	add    $0x4,%eax
 bf0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 bf3:	85 c9                	test   %ecx,%ecx
 bf5:	0f 84 8e 00 00 00    	je     c89 <printf+0x1b9>
        while(*s != 0){
 bfb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 bfe:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 c00:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 c02:	84 c0                	test   %al,%al
 c04:	0f 84 0e ff ff ff    	je     b18 <printf+0x48>
 c0a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 c0d:	89 de                	mov    %ebx,%esi
 c0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 c12:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 c15:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 c18:	83 ec 04             	sub    $0x4,%esp
          s++;
 c1b:	83 c6 01             	add    $0x1,%esi
 c1e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 c21:	6a 01                	push   $0x1
 c23:	57                   	push   %edi
 c24:	53                   	push   %ebx
 c25:	e8 78 fd ff ff       	call   9a2 <write>
        while(*s != 0){
 c2a:	0f b6 06             	movzbl (%esi),%eax
 c2d:	83 c4 10             	add    $0x10,%esp
 c30:	84 c0                	test   %al,%al
 c32:	75 e4                	jne    c18 <printf+0x148>
 c34:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 c37:	31 ff                	xor    %edi,%edi
 c39:	e9 da fe ff ff       	jmp    b18 <printf+0x48>
 c3e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 c40:	83 ec 0c             	sub    $0xc,%esp
 c43:	b9 0a 00 00 00       	mov    $0xa,%ecx
 c48:	6a 01                	push   $0x1
 c4a:	e9 73 ff ff ff       	jmp    bc2 <printf+0xf2>
 c4f:	90                   	nop
  write(fd, &c, 1);
 c50:	83 ec 04             	sub    $0x4,%esp
 c53:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 c56:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 c59:	6a 01                	push   $0x1
 c5b:	e9 21 ff ff ff       	jmp    b81 <printf+0xb1>
        putc(fd, *ap);
 c60:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 c63:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 c66:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 c68:	6a 01                	push   $0x1
        ap++;
 c6a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 c6d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 c70:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 c73:	50                   	push   %eax
 c74:	ff 75 08             	pushl  0x8(%ebp)
 c77:	e8 26 fd ff ff       	call   9a2 <write>
        ap++;
 c7c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 c7f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 c82:	31 ff                	xor    %edi,%edi
 c84:	e9 8f fe ff ff       	jmp    b18 <printf+0x48>
          s = "(null)";
 c89:	bb dc 0e 00 00       	mov    $0xedc,%ebx
        while(*s != 0){
 c8e:	b8 28 00 00 00       	mov    $0x28,%eax
 c93:	e9 72 ff ff ff       	jmp    c0a <printf+0x13a>
 c98:	66 90                	xchg   %ax,%ax
 c9a:	66 90                	xchg   %ax,%ax
 c9c:	66 90                	xchg   %ax,%ax
 c9e:	66 90                	xchg   %ax,%ax

00000ca0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ca0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ca1:	a1 04 14 00 00       	mov    0x1404,%eax
{
 ca6:	89 e5                	mov    %esp,%ebp
 ca8:	57                   	push   %edi
 ca9:	56                   	push   %esi
 caa:	53                   	push   %ebx
 cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 cae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cb8:	39 c8                	cmp    %ecx,%eax
 cba:	8b 10                	mov    (%eax),%edx
 cbc:	73 32                	jae    cf0 <free+0x50>
 cbe:	39 d1                	cmp    %edx,%ecx
 cc0:	72 04                	jb     cc6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cc2:	39 d0                	cmp    %edx,%eax
 cc4:	72 32                	jb     cf8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cc6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 cc9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 ccc:	39 fa                	cmp    %edi,%edx
 cce:	74 30                	je     d00 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 cd0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 cd3:	8b 50 04             	mov    0x4(%eax),%edx
 cd6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 cd9:	39 f1                	cmp    %esi,%ecx
 cdb:	74 3a                	je     d17 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 cdd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 cdf:	a3 04 14 00 00       	mov    %eax,0x1404
}
 ce4:	5b                   	pop    %ebx
 ce5:	5e                   	pop    %esi
 ce6:	5f                   	pop    %edi
 ce7:	5d                   	pop    %ebp
 ce8:	c3                   	ret    
 ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cf0:	39 d0                	cmp    %edx,%eax
 cf2:	72 04                	jb     cf8 <free+0x58>
 cf4:	39 d1                	cmp    %edx,%ecx
 cf6:	72 ce                	jb     cc6 <free+0x26>
{
 cf8:	89 d0                	mov    %edx,%eax
 cfa:	eb bc                	jmp    cb8 <free+0x18>
 cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 d00:	03 72 04             	add    0x4(%edx),%esi
 d03:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 d06:	8b 10                	mov    (%eax),%edx
 d08:	8b 12                	mov    (%edx),%edx
 d0a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 d0d:	8b 50 04             	mov    0x4(%eax),%edx
 d10:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 d13:	39 f1                	cmp    %esi,%ecx
 d15:	75 c6                	jne    cdd <free+0x3d>
    p->s.size += bp->s.size;
 d17:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 d1a:	a3 04 14 00 00       	mov    %eax,0x1404
    p->s.size += bp->s.size;
 d1f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d22:	8b 53 f8             	mov    -0x8(%ebx),%edx
 d25:	89 10                	mov    %edx,(%eax)
}
 d27:	5b                   	pop    %ebx
 d28:	5e                   	pop    %esi
 d29:	5f                   	pop    %edi
 d2a:	5d                   	pop    %ebp
 d2b:	c3                   	ret    
 d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d30 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d30:	55                   	push   %ebp
 d31:	89 e5                	mov    %esp,%ebp
 d33:	57                   	push   %edi
 d34:	56                   	push   %esi
 d35:	53                   	push   %ebx
 d36:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d39:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 d3c:	8b 15 04 14 00 00    	mov    0x1404,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d42:	8d 78 07             	lea    0x7(%eax),%edi
 d45:	c1 ef 03             	shr    $0x3,%edi
 d48:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 d4b:	85 d2                	test   %edx,%edx
 d4d:	0f 84 9d 00 00 00    	je     df0 <malloc+0xc0>
 d53:	8b 02                	mov    (%edx),%eax
 d55:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 d58:	39 cf                	cmp    %ecx,%edi
 d5a:	76 6c                	jbe    dc8 <malloc+0x98>
 d5c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 d62:	bb 00 10 00 00       	mov    $0x1000,%ebx
 d67:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 d6a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 d71:	eb 0e                	jmp    d81 <malloc+0x51>
 d73:	90                   	nop
 d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d78:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 d7a:	8b 48 04             	mov    0x4(%eax),%ecx
 d7d:	39 f9                	cmp    %edi,%ecx
 d7f:	73 47                	jae    dc8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d81:	39 05 04 14 00 00    	cmp    %eax,0x1404
 d87:	89 c2                	mov    %eax,%edx
 d89:	75 ed                	jne    d78 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 d8b:	83 ec 0c             	sub    $0xc,%esp
 d8e:	56                   	push   %esi
 d8f:	e8 76 fc ff ff       	call   a0a <sbrk>
  if(p == (char*)-1)
 d94:	83 c4 10             	add    $0x10,%esp
 d97:	83 f8 ff             	cmp    $0xffffffff,%eax
 d9a:	74 1c                	je     db8 <malloc+0x88>
  hp->s.size = nu;
 d9c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 d9f:	83 ec 0c             	sub    $0xc,%esp
 da2:	83 c0 08             	add    $0x8,%eax
 da5:	50                   	push   %eax
 da6:	e8 f5 fe ff ff       	call   ca0 <free>
  return freep;
 dab:	8b 15 04 14 00 00    	mov    0x1404,%edx
      if((p = morecore(nunits)) == 0)
 db1:	83 c4 10             	add    $0x10,%esp
 db4:	85 d2                	test   %edx,%edx
 db6:	75 c0                	jne    d78 <malloc+0x48>
        return 0;
  }
}
 db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 dbb:	31 c0                	xor    %eax,%eax
}
 dbd:	5b                   	pop    %ebx
 dbe:	5e                   	pop    %esi
 dbf:	5f                   	pop    %edi
 dc0:	5d                   	pop    %ebp
 dc1:	c3                   	ret    
 dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 dc8:	39 cf                	cmp    %ecx,%edi
 dca:	74 54                	je     e20 <malloc+0xf0>
        p->s.size -= nunits;
 dcc:	29 f9                	sub    %edi,%ecx
 dce:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 dd1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 dd4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 dd7:	89 15 04 14 00 00    	mov    %edx,0x1404
}
 ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 de0:	83 c0 08             	add    $0x8,%eax
}
 de3:	5b                   	pop    %ebx
 de4:	5e                   	pop    %esi
 de5:	5f                   	pop    %edi
 de6:	5d                   	pop    %ebp
 de7:	c3                   	ret    
 de8:	90                   	nop
 de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 df0:	c7 05 04 14 00 00 08 	movl   $0x1408,0x1404
 df7:	14 00 00 
 dfa:	c7 05 08 14 00 00 08 	movl   $0x1408,0x1408
 e01:	14 00 00 
    base.s.size = 0;
 e04:	b8 08 14 00 00       	mov    $0x1408,%eax
 e09:	c7 05 0c 14 00 00 00 	movl   $0x0,0x140c
 e10:	00 00 00 
 e13:	e9 44 ff ff ff       	jmp    d5c <malloc+0x2c>
 e18:	90                   	nop
 e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 e20:	8b 08                	mov    (%eax),%ecx
 e22:	89 0a                	mov    %ecx,(%edx)
 e24:	eb b1                	jmp    dd7 <malloc+0xa7>
