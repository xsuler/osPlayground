
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
  22:	68 ee 0e 00 00       	push   $0xeee
  27:	e8 f6 09 00 00       	call   a22 <open>
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
  38:	80 3d 22 14 00 00 20 	cmpb   $0x20,0x1422
  3f:	74 7a                	je     bb <main+0xbb>
int
fork1(void)
{
  int pid;

  pid = fork();
  41:	e8 94 09 00 00       	call   9da <fork>
  if(pid == -1)
  46:	83 f8 ff             	cmp    $0xffffffff,%eax
  49:	74 3b                	je     86 <main+0x86>
    if(fork1() == 0)
  4b:	85 c0                	test   %eax,%eax
  4d:	74 57                	je     a6 <main+0xa6>
    wait();
  4f:	e8 96 09 00 00       	call   9ea <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
  54:	83 ec 08             	sub    $0x8,%esp
  57:	6a 64                	push   $0x64
  59:	68 20 14 00 00       	push   $0x1420
  5e:	e8 9d 00 00 00       	call   100 <getcmd>
  63:	83 c4 10             	add    $0x10,%esp
  66:	85 c0                	test   %eax,%eax
  68:	78 37                	js     a1 <main+0xa1>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
  6a:	80 3d 20 14 00 00 63 	cmpb   $0x63,0x1420
  71:	75 ce                	jne    41 <main+0x41>
  73:	80 3d 21 14 00 00 64 	cmpb   $0x64,0x1421
  7a:	74 bc                	je     38 <main+0x38>
  pid = fork();
  7c:	e8 59 09 00 00       	call   9da <fork>
  if(pid == -1)
  81:	83 f8 ff             	cmp    $0xffffffff,%eax
  84:	75 c5                	jne    4b <main+0x4b>
    panic("fork");
  86:	83 ec 0c             	sub    $0xc,%esp
  89:	68 c1 0e 00 00       	push   $0xec1
  8e:	e8 bd 00 00 00       	call   150 <panic>
      close(fd);
  93:	83 ec 0c             	sub    $0xc,%esp
  96:	50                   	push   %eax
  97:	e8 6e 09 00 00       	call   a0a <close>
      break;
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	eb b3                	jmp    54 <main+0x54>
  exit();
  a1:	e8 3c 09 00 00       	call   9e2 <exit>
      runexp(parseexp(buf));
  a6:	83 ec 0c             	sub    $0xc,%esp
  a9:	68 20 14 00 00       	push   $0x1420
  ae:	e8 6d 06 00 00       	call   720 <parseexp>
  b3:	89 04 24             	mov    %eax,(%esp)
  b6:	e8 b5 00 00 00       	call   170 <runexp>
      buf[strlen(buf)-1] = 0;  // chop \n
  bb:	83 ec 0c             	sub    $0xc,%esp
  be:	68 20 14 00 00       	push   $0x1420
  c3:	e8 48 07 00 00       	call   810 <strlen>
      if(chdir(buf+3) < 0)
  c8:	c7 04 24 23 14 00 00 	movl   $0x1423,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
  cf:	c6 80 1f 14 00 00 00 	movb   $0x0,0x141f(%eax)
      if(chdir(buf+3) < 0)
  d6:	e8 77 09 00 00       	call   a52 <chdir>
  db:	83 c4 10             	add    $0x10,%esp
  de:	85 c0                	test   %eax,%eax
  e0:	0f 89 6e ff ff ff    	jns    54 <main+0x54>
        printf(2, "cannot cd %s\n", buf+3);
  e6:	50                   	push   %eax
  e7:	68 23 14 00 00       	push   $0x1423
  ec:	68 2b 0f 00 00       	push   $0xf2b
  f1:	6a 02                	push   $0x2
  f3:	e8 38 0a 00 00       	call   b30 <printf>
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
 10e:	68 88 0e 00 00       	push   $0xe88
 113:	6a 02                	push   $0x2
 115:	e8 16 0a 00 00       	call   b30 <printf>
  memset(buf, 0, nbuf);
 11a:	83 c4 0c             	add    $0xc,%esp
 11d:	56                   	push   %esi
 11e:	6a 00                	push   $0x0
 120:	53                   	push   %ebx
 121:	e8 1a 07 00 00       	call   840 <memset>
  gets(buf, nbuf);
 126:	58                   	pop    %eax
 127:	5a                   	pop    %edx
 128:	56                   	push   %esi
 129:	53                   	push   %ebx
 12a:	e8 71 07 00 00       	call   8a0 <gets>
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
 159:	68 fe 0e 00 00       	push   $0xefe
 15e:	6a 02                	push   $0x2
 160:	e8 cb 09 00 00       	call   b30 <printf>
  exit();
 165:	e8 78 08 00 00       	call   9e2 <exit>
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000170 <runexp>:
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
 175:	53                   	push   %ebx
 176:	83 ec 3c             	sub    $0x3c,%esp
 179:	8b 75 08             	mov    0x8(%ebp),%esi
  if(exp== 0)
 17c:	85 f6                	test   %esi,%esi
 17e:	74 58                	je     1d8 <runexp+0x68>
  switch(exp->type){
 180:	8b 06                	mov    (%esi),%eax
 182:	83 f8 02             	cmp    $0x2,%eax
 185:	74 19                	je     1a0 <runexp+0x30>
 187:	83 f8 03             	cmp    $0x3,%eax
 18a:	74 26                	je     1b2 <runexp+0x42>
 18c:	83 e8 01             	sub    $0x1,%eax
 18f:	74 47                	je     1d8 <runexp+0x68>
    panic("runexp");
 191:	83 ec 0c             	sub    $0xc,%esp
 194:	68 8b 0e 00 00       	push   $0xe8b
 199:	e8 b2 ff ff ff       	call   150 <panic>
 19e:	66 90                	xchg   %ax,%ax
    for(i=0;i<lst->length;i++)
 1a0:	8b 7e 04             	mov    0x4(%esi),%edi
 1a3:	85 ff                	test   %edi,%edi
 1a5:	7e 31                	jle    1d8 <runexp+0x68>
      runexp(lst->sexps[i]);
 1a7:	83 ec 0c             	sub    $0xc,%esp
 1aa:	ff 76 08             	pushl  0x8(%esi)
 1ad:	e8 be ff ff ff       	call   170 <runexp>
    printf(2, "in 1\n");
 1b2:	53                   	push   %ebx
 1b3:	53                   	push   %ebx
 1b4:	68 92 0e 00 00       	push   $0xe92
 1b9:	6a 02                	push   $0x2
 1bb:	e8 70 09 00 00       	call   b30 <printf>
    argv[lst->length]=0;
 1c0:	8b 46 04             	mov    0x4(%esi),%eax
    for(i=0;i<lst->length;i++)
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	85 c0                	test   %eax,%eax
    argv[lst->length]=0;
 1c8:	c7 44 85 c0 00 00 00 	movl   $0x0,-0x40(%ebp,%eax,4)
 1cf:	00 
    for(i=0;i<lst->length;i++)
 1d0:	7f 0b                	jg     1dd <runexp+0x6d>
 1d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  exit();
 1d8:	e8 05 08 00 00       	call   9e2 <exit>
  int i,bufs=0;
 1dd:	31 ff                	xor    %edi,%edi
    for(i=0;i<lst->length;i++)
 1df:	31 db                	xor    %ebx,%ebx
 1e1:	eb 28                	jmp    20b <runexp+0x9b>
 1e3:	90                   	nop
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      else if(lst->sexps[i]->type==LIST)
 1e8:	83 f8 02             	cmp    $0x2,%eax
 1eb:	0f 84 b8 01 00 00    	je     3a9 <runexp+0x239>
      else if(lst->sexps[i]->type==APPLY)
 1f1:	83 f8 03             	cmp    $0x3,%eax
 1f4:	0f 84 a7 00 00 00    	je     2a1 <runexp+0x131>
      if(i==lst->length-1)
 1fa:	8b 46 04             	mov    0x4(%esi),%eax
 1fd:	8d 50 ff             	lea    -0x1(%eax),%edx
 200:	39 da                	cmp    %ebx,%edx
 202:	74 41                	je     245 <runexp+0xd5>
    for(i=0;i<lst->length;i++)
 204:	83 c3 01             	add    $0x1,%ebx
 207:	39 d8                	cmp    %ebx,%eax
 209:	7e cd                	jle    1d8 <runexp+0x68>
      printf(2, "in 2, length:%d\n",lst->length);
 20b:	83 ec 04             	sub    $0x4,%esp
 20e:	50                   	push   %eax
 20f:	68 98 0e 00 00       	push   $0xe98
 214:	6a 02                	push   $0x2
 216:	e8 15 09 00 00       	call   b30 <printf>
      if(lst->sexps[i]->type==ATOM)
 21b:	8b 54 9e 08          	mov    0x8(%esi,%ebx,4),%edx
 21f:	83 c4 10             	add    $0x10,%esp
 222:	8b 02                	mov    (%edx),%eax
 224:	83 f8 01             	cmp    $0x1,%eax
 227:	75 bf                	jne    1e8 <runexp+0x78>
        argv[i]=((struct atom*)lst->sexps[i])->symbol;
 229:	8b 42 04             	mov    0x4(%edx),%eax
        printf(2, "in 3, length:%d\n",lst->length);
 22c:	51                   	push   %ecx
 22d:	ff 76 04             	pushl  0x4(%esi)
 230:	68 a9 0e 00 00       	push   $0xea9
 235:	6a 02                	push   $0x2
        argv[i]=((struct atom*)lst->sexps[i])->symbol;
 237:	89 44 9d c0          	mov    %eax,-0x40(%ebp,%ebx,4)
        printf(2, "in 3, length:%d\n",lst->length);
 23b:	e8 f0 08 00 00       	call   b30 <printf>
 240:	83 c4 10             	add    $0x10,%esp
 243:	eb b5                	jmp    1fa <runexp+0x8a>
        printf(2, "in 4, length:%d\n",lst->length);
 245:	51                   	push   %ecx
 246:	50                   	push   %eax
 247:	68 02 0f 00 00       	push   $0xf02
 24c:	6a 02                	push   $0x2
 24e:	e8 dd 08 00 00       	call   b30 <printf>
        printf(2, "exec %s\n",argv[0]);
 253:	83 c4 0c             	add    $0xc,%esp
 256:	ff 75 c0             	pushl  -0x40(%ebp)
 259:	68 13 0f 00 00       	push   $0xf13
 25e:	6a 02                	push   $0x2
 260:	e8 cb 08 00 00       	call   b30 <printf>
  pid = fork();
 265:	e8 70 07 00 00       	call   9da <fork>
  if(pid == -1)
 26a:	83 c4 10             	add    $0x10,%esp
 26d:	83 f8 ff             	cmp    $0xffffffff,%eax
 270:	0f 84 40 01 00 00    	je     3b6 <runexp+0x246>
        if(fork1() == 0){
 276:	85 c0                	test   %eax,%eax
 278:	75 1a                	jne    294 <runexp+0x124>
          if(argv[0] == 0)
 27a:	8b 45 c0             	mov    -0x40(%ebp),%eax
 27d:	85 c0                	test   %eax,%eax
 27f:	0f 84 53 ff ff ff    	je     1d8 <runexp+0x68>
          exec(argv[0], argv);
 285:	52                   	push   %edx
 286:	52                   	push   %edx
 287:	8d 55 c0             	lea    -0x40(%ebp),%edx
 28a:	52                   	push   %edx
 28b:	50                   	push   %eax
 28c:	e8 89 07 00 00       	call   a1a <exec>
 291:	83 c4 10             	add    $0x10,%esp
        wait();
 294:	e8 51 07 00 00       	call   9ea <wait>
 299:	8b 46 04             	mov    0x4(%esi),%eax
 29c:	e9 63 ff ff ff       	jmp    204 <runexp+0x94>
  pid = fork();
 2a1:	e8 34 07 00 00       	call   9da <fork>
  if(pid == -1)
 2a6:	83 f8 ff             	cmp    $0xffffffff,%eax
 2a9:	0f 84 07 01 00 00    	je     3b6 <runexp+0x246>
        if(fork1() == 0){
 2af:	85 c0                	test   %eax,%eax
 2b1:	75 3e                	jne    2f1 <runexp+0x181>
          close(1);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	6a 01                	push   $0x1
 2b8:	e8 4d 07 00 00       	call   a0a <close>
          if(open(".etemp", O_WRONLY|O_CREATE) < 0){
 2bd:	58                   	pop    %eax
 2be:	5a                   	pop    %edx
 2bf:	68 01 02 00 00       	push   $0x201
 2c4:	68 c6 0e 00 00       	push   $0xec6
 2c9:	e8 54 07 00 00       	call   a22 <open>
 2ce:	83 c4 10             	add    $0x10,%esp
 2d1:	85 c0                	test   %eax,%eax
 2d3:	0f 88 fd 00 00 00    	js     3d6 <runexp+0x266>
          printf(2, "start\n");
 2d9:	51                   	push   %ecx
 2da:	51                   	push   %ecx
 2db:	68 cd 0e 00 00       	push   $0xecd
 2e0:	6a 02                	push   $0x2
 2e2:	e8 49 08 00 00       	call   b30 <printf>
          runexp(lst->sexps[i]);
 2e7:	5f                   	pop    %edi
 2e8:	ff 74 9e 08          	pushl  0x8(%esi,%ebx,4)
 2ec:	e8 7f fe ff ff       	call   170 <runexp>
        wait();
 2f1:	e8 f4 06 00 00       	call   9ea <wait>
        printf(2, "end\n");
 2f6:	50                   	push   %eax
 2f7:	50                   	push   %eax
 2f8:	68 d4 0e 00 00       	push   $0xed4
 2fd:	6a 02                	push   $0x2
 2ff:	e8 2c 08 00 00       	call   b30 <printf>
        close(2);
 304:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 30b:	e8 fa 06 00 00       	call   a0a <close>
        if((ffd=open(".etemp", O_RDONLY)) < 0){
 310:	58                   	pop    %eax
 311:	5a                   	pop    %edx
 312:	6a 00                	push   $0x0
 314:	68 c6 0e 00 00       	push   $0xec6
 319:	e8 04 07 00 00       	call   a22 <open>
 31e:	83 c4 10             	add    $0x10,%esp
 321:	85 c0                	test   %eax,%eax
 323:	0f 88 9a 00 00 00    	js     3c3 <runexp+0x253>
        printf(1,"fd: %d\n",ffd);
 329:	52                   	push   %edx
 32a:	50                   	push   %eax
 32b:	68 d9 0e 00 00       	push   $0xed9
 330:	6a 01                	push   $0x1
 332:	e8 f9 07 00 00       	call   b30 <printf>
        argv[i]=argvbuf+bufs;
 337:	8d 87 a0 14 00 00    	lea    0x14a0(%edi),%eax
        bufs+=read(2,argvbuf+bufs,20);
 33d:	83 c4 0c             	add    $0xc,%esp
 340:	6a 14                	push   $0x14
 342:	50                   	push   %eax
 343:	6a 02                	push   $0x2
        argv[i]=argvbuf+bufs;
 345:	89 44 9d c0          	mov    %eax,-0x40(%ebp,%ebx,4)
        bufs+=read(2,argvbuf+bufs,20);
 349:	e8 ac 06 00 00       	call   9fa <read>
 34e:	01 f8                	add    %edi,%eax
        printf(1, "sizeof : %d\n",bufs);
 350:	83 c4 0c             	add    $0xc,%esp
        argvbuf[bufs++]=0;
 353:	8d 78 01             	lea    0x1(%eax),%edi
 356:	c6 80 a0 14 00 00 00 	movb   $0x0,0x14a0(%eax)
        printf(1, "sizeof : %d\n",bufs);
 35d:	57                   	push   %edi
 35e:	68 e1 0e 00 00       	push   $0xee1
 363:	6a 01                	push   $0x1
 365:	e8 c6 07 00 00       	call   b30 <printf>
        close(2);
 36a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 371:	e8 94 06 00 00       	call   a0a <close>
        unlink(".etemp");
 376:	c7 04 24 c6 0e 00 00 	movl   $0xec6,(%esp)
 37d:	e8 b0 06 00 00       	call   a32 <unlink>
        open("console", O_RDWR);
 382:	59                   	pop    %ecx
 383:	58                   	pop    %eax
 384:	6a 02                	push   $0x2
 386:	68 ee 0e 00 00       	push   $0xeee
 38b:	e8 92 06 00 00       	call   a22 <open>
        printf(2,"argv%d: %s\n",i,argv[i]);
 390:	ff 74 9d c0          	pushl  -0x40(%ebp,%ebx,4)
 394:	53                   	push   %ebx
 395:	68 f6 0e 00 00       	push   $0xef6
 39a:	6a 02                	push   $0x2
 39c:	e8 8f 07 00 00       	call   b30 <printf>
 3a1:	83 c4 20             	add    $0x20,%esp
 3a4:	e9 51 fe ff ff       	jmp    1fa <runexp+0x8a>
        panic("syntax");
 3a9:	83 ec 0c             	sub    $0xc,%esp
 3ac:	68 ba 0e 00 00       	push   $0xeba
 3b1:	e8 9a fd ff ff       	call   150 <panic>
    panic("fork");
 3b6:	83 ec 0c             	sub    $0xc,%esp
 3b9:	68 c1 0e 00 00       	push   $0xec1
 3be:	e8 8d fd ff ff       	call   150 <panic>
          printf(1, "open console temp file failed\n");
 3c3:	50                   	push   %eax
 3c4:	50                   	push   %eax
 3c5:	68 3c 0f 00 00       	push   $0xf3c
 3ca:	6a 01                	push   $0x1
 3cc:	e8 5f 07 00 00       	call   b30 <printf>
          exit();
 3d1:	e8 0c 06 00 00       	call   9e2 <exit>
            printf(2, "open console temp file failed\n");
 3d6:	50                   	push   %eax
 3d7:	50                   	push   %eax
 3d8:	68 3c 0f 00 00       	push   $0xf3c
 3dd:	6a 02                	push   $0x2
 3df:	e8 4c 07 00 00       	call   b30 <printf>
            exit();
 3e4:	e8 f9 05 00 00       	call   9e2 <exit>
 3e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003f0 <fork1>:
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
 3f6:	e8 df 05 00 00       	call   9da <fork>
  if(pid == -1)
 3fb:	83 f8 ff             	cmp    $0xffffffff,%eax
 3fe:	74 02                	je     402 <fork1+0x12>
  return pid;
}
 400:	c9                   	leave  
 401:	c3                   	ret    
    panic("fork");
 402:	83 ec 0c             	sub    $0xc,%esp
 405:	68 c1 0e 00 00       	push   $0xec1
 40a:	e8 41 fd ff ff       	call   150 <panic>
 40f:	90                   	nop

00000410 <atom>:
//PAGEBREAK!
// Constructors

struct sexp*
atom(void)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	53                   	push   %ebx
 414:	83 ec 10             	sub    $0x10,%esp
  struct atom *exp;

  exp= malloc(sizeof(*exp));
 417:	6a 0c                	push   $0xc
 419:	e8 72 09 00 00       	call   d90 <malloc>
  memset(exp, 0, sizeof(*exp));
 41e:	83 c4 0c             	add    $0xc,%esp
  exp= malloc(sizeof(*exp));
 421:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
 423:	6a 0c                	push   $0xc
 425:	6a 00                	push   $0x0
 427:	50                   	push   %eax
 428:	e8 13 04 00 00       	call   840 <memset>
  return (struct sexp*)exp;
}
 42d:	89 d8                	mov    %ebx,%eax
 42f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 432:	c9                   	leave  
 433:	c3                   	ret    
 434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 43a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000440 <list>:

struct sexp*
list(void)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	53                   	push   %ebx
 444:	83 ec 10             	sub    $0x10,%esp
  struct list*exp;

  exp= malloc(sizeof(*exp));
 447:	6a 30                	push   $0x30
 449:	e8 42 09 00 00       	call   d90 <malloc>
  memset(exp, 0, sizeof(*exp));
 44e:	83 c4 0c             	add    $0xc,%esp
  exp= malloc(sizeof(*exp));
 451:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
 453:	6a 30                	push   $0x30
 455:	6a 00                	push   $0x0
 457:	50                   	push   %eax
 458:	e8 e3 03 00 00       	call   840 <memset>
  return (struct sexp*)exp;
}
 45d:	89 d8                	mov    %ebx,%eax
 45f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 462:	c9                   	leave  
 463:	c3                   	ret    
 464:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 46a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000470 <peek>:
char whitespace[] = " \t\r\n\v";
char esymbols[] = "()";

int
peek(char **ps, char *es, char *toks)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 0c             	sub    $0xc,%esp
 479:	8b 7d 08             	mov    0x8(%ebp),%edi
 47c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
 47f:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
 481:	39 f3                	cmp    %esi,%ebx
 483:	72 12                	jb     497 <peek+0x27>
 485:	eb 28                	jmp    4af <peek+0x3f>
 487:	89 f6                	mov    %esi,%esi
 489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
 490:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
 493:	39 de                	cmp    %ebx,%esi
 495:	74 18                	je     4af <peek+0x3f>
 497:	0f be 03             	movsbl (%ebx),%eax
 49a:	83 ec 08             	sub    $0x8,%esp
 49d:	50                   	push   %eax
 49e:	68 0c 14 00 00       	push   $0x140c
 4a3:	e8 b8 03 00 00       	call   860 <strchr>
 4a8:	83 c4 10             	add    $0x10,%esp
 4ab:	85 c0                	test   %eax,%eax
 4ad:	75 e1                	jne    490 <peek+0x20>
  *ps = s;
 4af:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
 4b1:	0f be 13             	movsbl (%ebx),%edx
 4b4:	31 c0                	xor    %eax,%eax
 4b6:	84 d2                	test   %dl,%dl
 4b8:	74 17                	je     4d1 <peek+0x61>
 4ba:	83 ec 08             	sub    $0x8,%esp
 4bd:	52                   	push   %edx
 4be:	ff 75 10             	pushl  0x10(%ebp)
 4c1:	e8 9a 03 00 00       	call   860 <strchr>
 4c6:	83 c4 10             	add    $0x10,%esp
 4c9:	85 c0                	test   %eax,%eax
 4cb:	0f 95 c0             	setne  %al
 4ce:	0f b6 c0             	movzbl %al,%eax
}
 4d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d4:	5b                   	pop    %ebx
 4d5:	5e                   	pop    %esi
 4d6:	5f                   	pop    %edi
 4d7:	5d                   	pop    %ebp
 4d8:	c3                   	ret    
 4d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004e0 <parseatom>:
  return ret;
}

struct sexp*
parseatom(char **ps, char *es)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
 4e6:	83 ec 0c             	sub    $0xc,%esp
 4e9:	8b 7d 08             	mov    0x8(%ebp),%edi
 4ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct atom *atm;
  struct sexp *ret;

  char *s=*ps;
 4ef:	8b 37                	mov    (%edi),%esi
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
 4f1:	39 de                	cmp    %ebx,%esi
 4f3:	89 f0                	mov    %esi,%eax
 4f5:	72 2e                	jb     525 <parseatom+0x45>
 4f7:	eb 44                	jmp    53d <parseatom+0x5d>
 4f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 500:	8b 07                	mov    (%edi),%eax
 502:	83 ec 08             	sub    $0x8,%esp
 505:	0f be 00             	movsbl (%eax),%eax
 508:	50                   	push   %eax
 509:	68 08 14 00 00       	push   $0x1408
 50e:	e8 4d 03 00 00       	call   860 <strchr>
 513:	83 c4 10             	add    $0x10,%esp
 516:	85 c0                	test   %eax,%eax
 518:	75 23                	jne    53d <parseatom+0x5d>
    (*ps)++;
 51a:	8b 07                	mov    (%edi),%eax
 51c:	83 c0 01             	add    $0x1,%eax
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
 51f:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
 521:	89 07                	mov    %eax,(%edi)
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
 523:	73 18                	jae    53d <parseatom+0x5d>
 525:	0f be 00             	movsbl (%eax),%eax
 528:	83 ec 08             	sub    $0x8,%esp
 52b:	50                   	push   %eax
 52c:	68 0c 14 00 00       	push   $0x140c
 531:	e8 2a 03 00 00       	call   860 <strchr>
 536:	83 c4 10             	add    $0x10,%esp
 539:	85 c0                	test   %eax,%eax
 53b:	74 c3                	je     500 <parseatom+0x20>

  ret=atom();
 53d:	e8 ce fe ff ff       	call   410 <atom>
  atm=(struct atom*)ret;

  atm->type=ATOM;
 542:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  atm->symbol=s;
 548:	89 70 04             	mov    %esi,0x4(%eax)
  atm->esymbol=*ps;
 54b:	8b 17                	mov    (%edi),%edx
 54d:	89 50 08             	mov    %edx,0x8(%eax)

  return ret;
}
 550:	8d 65 f4             	lea    -0xc(%ebp),%esp
 553:	5b                   	pop    %ebx
 554:	5e                   	pop    %esi
 555:	5f                   	pop    %edi
 556:	5d                   	pop    %ebp
 557:	c3                   	ret    
 558:	90                   	nop
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000560 <parsesexp>:

struct sexp*
parsesexp(char **ps, char *es)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	56                   	push   %esi
 564:	53                   	push   %ebx
 565:	8b 75 08             	mov    0x8(%ebp),%esi
 568:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct sexp *ret=0;

  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 56b:	8b 06                	mov    (%esi),%eax
 56d:	39 c3                	cmp    %eax,%ebx
 56f:	77 10                	ja     581 <parsesexp+0x21>
 571:	eb 28                	jmp    59b <parsesexp+0x3b>
 573:	90                   	nop
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    (*ps)++;
 578:	83 c0 01             	add    $0x1,%eax
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 57b:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
 57d:	89 06                	mov    %eax,(%esi)
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 57f:	73 1a                	jae    59b <parsesexp+0x3b>
 581:	0f be 00             	movsbl (%eax),%eax
 584:	83 ec 08             	sub    $0x8,%esp
 587:	50                   	push   %eax
 588:	68 0c 14 00 00       	push   $0x140c
 58d:	e8 ce 02 00 00       	call   860 <strchr>
 592:	83 c4 10             	add    $0x10,%esp
 595:	85 c0                	test   %eax,%eax
    (*ps)++;
 597:	8b 06                	mov    (%esi),%eax
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 599:	75 dd                	jne    578 <parsesexp+0x18>
  switch(*(*ps)){
 59b:	0f b6 10             	movzbl (%eax),%edx
 59e:	80 fa 27             	cmp    $0x27,%dl
 5a1:	74 55                	je     5f8 <parsesexp+0x98>
 5a3:	80 fa 28             	cmp    $0x28,%dl
 5a6:	74 28                	je     5d0 <parsesexp+0x70>
 5a8:	84 d2                	test   %dl,%dl
 5aa:	74 14                	je     5c0 <parsesexp+0x60>
    (*ps)+=2;
    ret=parselist(ps, es);
    (*ps)++;
    break;
  default:
    ret=parseatom(ps, es);
 5ac:	89 5d 0c             	mov    %ebx,0xc(%ebp)
 5af:	89 75 08             	mov    %esi,0x8(%ebp)
    break;
  }
  return ret;
}
 5b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5b5:	5b                   	pop    %ebx
 5b6:	5e                   	pop    %esi
 5b7:	5d                   	pop    %ebp
    ret=parseatom(ps, es);
 5b8:	e9 23 ff ff ff       	jmp    4e0 <parseatom>
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
}
 5c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  struct sexp *ret=0;
 5c3:	31 c0                	xor    %eax,%eax
}
 5c5:	5b                   	pop    %ebx
 5c6:	5e                   	pop    %esi
 5c7:	5d                   	pop    %ebp
 5c8:	c3                   	ret    
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret=parselist(ps, es);
 5d0:	83 ec 08             	sub    $0x8,%esp
    (*ps)++;
 5d3:	83 c0 01             	add    $0x1,%eax
 5d6:	89 06                	mov    %eax,(%esi)
    ret=parselist(ps, es);
 5d8:	53                   	push   %ebx
 5d9:	56                   	push   %esi
 5da:	e8 41 00 00 00       	call   620 <parselist>
    ret->type=APPLY;
 5df:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    break;
 5e5:	83 c4 10             	add    $0x10,%esp
    (*ps)++;
 5e8:	83 06 01             	addl   $0x1,(%esi)
}
 5eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5ee:	5b                   	pop    %ebx
 5ef:	5e                   	pop    %esi
 5f0:	5d                   	pop    %ebp
 5f1:	c3                   	ret    
 5f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ret=parselist(ps, es);
 5f8:	83 ec 08             	sub    $0x8,%esp
    (*ps)+=2;
 5fb:	83 c0 02             	add    $0x2,%eax
 5fe:	89 06                	mov    %eax,(%esi)
    ret=parselist(ps, es);
 600:	53                   	push   %ebx
 601:	56                   	push   %esi
 602:	e8 19 00 00 00       	call   620 <parselist>
    (*ps)++;
 607:	83 06 01             	addl   $0x1,(%esi)
    break;
 60a:	83 c4 10             	add    $0x10,%esp
}
 60d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 610:	5b                   	pop    %ebx
 611:	5e                   	pop    %esi
 612:	5d                   	pop    %ebp
 613:	c3                   	ret    
 614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 61a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000620 <parselist>:
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	83 ec 1c             	sub    $0x1c,%esp
 629:	8b 75 08             	mov    0x8(%ebp),%esi
 62c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  ret=list();
 62f:	e8 0c fe ff ff       	call   440 <list>
  lst->type=LIST;
 634:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  ret=list();
 63a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *res=*ps;
 63d:	8b 0e                	mov    (%esi),%ecx
  while(res<es)
 63f:	39 f9                	cmp    %edi,%ecx
 641:	89 cb                	mov    %ecx,%ebx
 643:	73 3b                	jae    680 <parselist+0x60>
  int i=1;
 645:	ba 01 00 00 00       	mov    $0x1,%edx
 64a:	eb 14                	jmp    660 <parselist+0x40>
 64c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*res==')')
 650:	3c 29                	cmp    $0x29,%al
 652:	75 05                	jne    659 <parselist+0x39>
      if(i==0)
 654:	83 ea 01             	sub    $0x1,%edx
 657:	74 27                	je     680 <parselist+0x60>
    res++;
 659:	83 c3 01             	add    $0x1,%ebx
  while(res<es)
 65c:	39 df                	cmp    %ebx,%edi
 65e:	74 11                	je     671 <parselist+0x51>
    if(*res=='(')
 660:	0f b6 03             	movzbl (%ebx),%eax
 663:	3c 28                	cmp    $0x28,%al
 665:	75 e9                	jne    650 <parselist+0x30>
    res++;
 667:	83 c3 01             	add    $0x1,%ebx
      i++;
 66a:	83 c2 01             	add    $0x1,%edx
  while(res<es)
 66d:	39 df                	cmp    %ebx,%edi
 66f:	75 ef                	jne    660 <parselist+0x40>
    panic("syntax");
 671:	83 ec 0c             	sub    $0xc,%esp
 674:	68 ba 0e 00 00       	push   $0xeba
 679:	e8 d2 fa ff ff       	call   150 <panic>
 67e:	66 90                	xchg   %ax,%ax
  if(res==es)
 680:	39 df                	cmp    %ebx,%edi
 682:	74 ed                	je     671 <parselist+0x51>
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
 684:	31 ff                	xor    %edi,%edi
 686:	eb 0a                	jmp    692 <parselist+0x72>
 688:	90                   	nop
 689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 690:	8b 0e                	mov    (%esi),%ecx
 692:	39 d9                	cmp    %ebx,%ecx
 694:	73 1c                	jae    6b2 <parselist+0x92>
    lst->sexps[i]=parsesexp(ps, res);
 696:	83 ec 08             	sub    $0x8,%esp
 699:	53                   	push   %ebx
 69a:	56                   	push   %esi
 69b:	e8 c0 fe ff ff       	call   560 <parsesexp>
 6a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
 6a3:	83 c4 10             	add    $0x10,%esp
    lst->sexps[i]=parsesexp(ps, res);
 6a6:	89 44 ba 08          	mov    %eax,0x8(%edx,%edi,4)
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
 6aa:	83 c7 01             	add    $0x1,%edi
 6ad:	83 ff 0a             	cmp    $0xa,%edi
 6b0:	75 de                	jne    690 <parselist+0x70>
  lst->length=i;
 6b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b5:	89 78 04             	mov    %edi,0x4(%eax)
}
 6b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6bb:	5b                   	pop    %ebx
 6bc:	5e                   	pop    %esi
 6bd:	5f                   	pop    %edi
 6be:	5d                   	pop    %ebp
 6bf:	c3                   	ret    

000006c0 <snulterminate>:
  return exp;
}

struct sexp*
snulterminate(struct sexp *exp)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	56                   	push   %esi
 6c4:	53                   	push   %ebx
 6c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;
  struct list *lst;
  struct atom *atm;

  if(exp== 0)
 6c8:	85 db                	test   %ebx,%ebx
 6ca:	74 2e                	je     6fa <snulterminate+0x3a>
    return 0;

  switch(exp->type){
 6cc:	8b 03                	mov    (%ebx),%eax
 6ce:	83 f8 01             	cmp    $0x1,%eax
 6d1:	74 35                	je     708 <snulterminate+0x48>
 6d3:	7c 25                	jl     6fa <snulterminate+0x3a>
 6d5:	83 f8 03             	cmp    $0x3,%eax
 6d8:	7f 20                	jg     6fa <snulterminate+0x3a>
    break;

  case APPLY:
  case LIST:
    lst = (struct list*)exp;
    for(i=0;i<lst->length;i++)
 6da:	8b 43 04             	mov    0x4(%ebx),%eax
 6dd:	31 f6                	xor    %esi,%esi
 6df:	85 c0                	test   %eax,%eax
 6e1:	7e 17                	jle    6fa <snulterminate+0x3a>
      snulterminate(lst->sexps[i]);
 6e3:	83 ec 0c             	sub    $0xc,%esp
 6e6:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
    for(i=0;i<lst->length;i++)
 6ea:	83 c6 01             	add    $0x1,%esi
      snulterminate(lst->sexps[i]);
 6ed:	e8 ce ff ff ff       	call   6c0 <snulterminate>
    for(i=0;i<lst->length;i++)
 6f2:	83 c4 10             	add    $0x10,%esp
 6f5:	3b 73 04             	cmp    0x4(%ebx),%esi
 6f8:	7c e9                	jl     6e3 <snulterminate+0x23>
    break;
  }
  return exp;
}
 6fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6fd:	89 d8                	mov    %ebx,%eax
 6ff:	5b                   	pop    %ebx
 700:	5e                   	pop    %esi
 701:	5d                   	pop    %ebp
 702:	c3                   	ret    
 703:	90                   	nop
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *atm->esymbol = 0;
 708:	8b 43 08             	mov    0x8(%ebx),%eax
 70b:	c6 00 00             	movb   $0x0,(%eax)
}
 70e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 711:	89 d8                	mov    %ebx,%eax
 713:	5b                   	pop    %ebx
 714:	5e                   	pop    %esi
 715:	5d                   	pop    %ebp
 716:	c3                   	ret    
 717:	89 f6                	mov    %esi,%esi
 719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000720 <parseexp>:
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	56                   	push   %esi
 724:	53                   	push   %ebx
  es = s + strlen(s);
 725:	8b 5d 08             	mov    0x8(%ebp),%ebx
 728:	83 ec 0c             	sub    $0xc,%esp
 72b:	53                   	push   %ebx
 72c:	e8 df 00 00 00       	call   810 <strlen>
  exp= parsesexp(&s, es);
 731:	59                   	pop    %ecx
  es = s + strlen(s);
 732:	01 c3                	add    %eax,%ebx
  exp= parsesexp(&s, es);
 734:	8d 45 08             	lea    0x8(%ebp),%eax
 737:	5e                   	pop    %esi
 738:	53                   	push   %ebx
 739:	50                   	push   %eax
 73a:	e8 21 fe ff ff       	call   560 <parsesexp>
 73f:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
 741:	8d 45 08             	lea    0x8(%ebp),%eax
 744:	83 c4 0c             	add    $0xc,%esp
 747:	68 97 0e 00 00       	push   $0xe97
 74c:	53                   	push   %ebx
 74d:	50                   	push   %eax
 74e:	e8 1d fd ff ff       	call   470 <peek>
  if(s != es){
 753:	8b 45 08             	mov    0x8(%ebp),%eax
 756:	83 c4 10             	add    $0x10,%esp
 759:	39 d8                	cmp    %ebx,%eax
 75b:	75 12                	jne    76f <parseexp+0x4f>
  snulterminate(exp);
 75d:	83 ec 0c             	sub    $0xc,%esp
 760:	56                   	push   %esi
 761:	e8 5a ff ff ff       	call   6c0 <snulterminate>
}
 766:	8d 65 f8             	lea    -0x8(%ebp),%esp
 769:	89 f0                	mov    %esi,%eax
 76b:	5b                   	pop    %ebx
 76c:	5e                   	pop    %esi
 76d:	5d                   	pop    %ebp
 76e:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
 76f:	52                   	push   %edx
 770:	50                   	push   %eax
 771:	68 1c 0f 00 00       	push   $0xf1c
 776:	6a 02                	push   $0x2
 778:	e8 b3 03 00 00       	call   b30 <printf>
    panic("syntax");
 77d:	c7 04 24 ba 0e 00 00 	movl   $0xeba,(%esp)
 784:	e8 c7 f9 ff ff       	call   150 <panic>
 789:	66 90                	xchg   %ax,%ax
 78b:	66 90                	xchg   %ax,%ax
 78d:	66 90                	xchg   %ax,%ax
 78f:	90                   	nop

00000790 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	53                   	push   %ebx
 794:	8b 45 08             	mov    0x8(%ebp),%eax
 797:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 79a:	89 c2                	mov    %eax,%edx
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7a0:	83 c1 01             	add    $0x1,%ecx
 7a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 7a7:	83 c2 01             	add    $0x1,%edx
 7aa:	84 db                	test   %bl,%bl
 7ac:	88 5a ff             	mov    %bl,-0x1(%edx)
 7af:	75 ef                	jne    7a0 <strcpy+0x10>
    ;
  return os;
}
 7b1:	5b                   	pop    %ebx
 7b2:	5d                   	pop    %ebp
 7b3:	c3                   	ret    
 7b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000007c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	53                   	push   %ebx
 7c4:	8b 55 08             	mov    0x8(%ebp),%edx
 7c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 7ca:	0f b6 02             	movzbl (%edx),%eax
 7cd:	0f b6 19             	movzbl (%ecx),%ebx
 7d0:	84 c0                	test   %al,%al
 7d2:	75 1c                	jne    7f0 <strcmp+0x30>
 7d4:	eb 2a                	jmp    800 <strcmp+0x40>
 7d6:	8d 76 00             	lea    0x0(%esi),%esi
 7d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 7e0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 7e3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 7e6:	83 c1 01             	add    $0x1,%ecx
 7e9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 7ec:	84 c0                	test   %al,%al
 7ee:	74 10                	je     800 <strcmp+0x40>
 7f0:	38 d8                	cmp    %bl,%al
 7f2:	74 ec                	je     7e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 7f4:	29 d8                	sub    %ebx,%eax
}
 7f6:	5b                   	pop    %ebx
 7f7:	5d                   	pop    %ebp
 7f8:	c3                   	ret    
 7f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 800:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 802:	29 d8                	sub    %ebx,%eax
}
 804:	5b                   	pop    %ebx
 805:	5d                   	pop    %ebp
 806:	c3                   	ret    
 807:	89 f6                	mov    %esi,%esi
 809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000810 <strlen>:

uint
strlen(char *s)
{
 810:	55                   	push   %ebp
 811:	89 e5                	mov    %esp,%ebp
 813:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 816:	80 39 00             	cmpb   $0x0,(%ecx)
 819:	74 15                	je     830 <strlen+0x20>
 81b:	31 d2                	xor    %edx,%edx
 81d:	8d 76 00             	lea    0x0(%esi),%esi
 820:	83 c2 01             	add    $0x1,%edx
 823:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 827:	89 d0                	mov    %edx,%eax
 829:	75 f5                	jne    820 <strlen+0x10>
    ;
  return n;
}
 82b:	5d                   	pop    %ebp
 82c:	c3                   	ret    
 82d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 830:	31 c0                	xor    %eax,%eax
}
 832:	5d                   	pop    %ebp
 833:	c3                   	ret    
 834:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 83a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000840 <memset>:

void*
memset(void *dst, int c, uint n)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	57                   	push   %edi
 844:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 847:	8b 4d 10             	mov    0x10(%ebp),%ecx
 84a:	8b 45 0c             	mov    0xc(%ebp),%eax
 84d:	89 d7                	mov    %edx,%edi
 84f:	fc                   	cld    
 850:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 852:	89 d0                	mov    %edx,%eax
 854:	5f                   	pop    %edi
 855:	5d                   	pop    %ebp
 856:	c3                   	ret    
 857:	89 f6                	mov    %esi,%esi
 859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000860 <strchr>:

char*
strchr(const char *s, char c)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	53                   	push   %ebx
 864:	8b 45 08             	mov    0x8(%ebp),%eax
 867:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 86a:	0f b6 10             	movzbl (%eax),%edx
 86d:	84 d2                	test   %dl,%dl
 86f:	74 1d                	je     88e <strchr+0x2e>
    if(*s == c)
 871:	38 d3                	cmp    %dl,%bl
 873:	89 d9                	mov    %ebx,%ecx
 875:	75 0d                	jne    884 <strchr+0x24>
 877:	eb 17                	jmp    890 <strchr+0x30>
 879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 880:	38 ca                	cmp    %cl,%dl
 882:	74 0c                	je     890 <strchr+0x30>
  for(; *s; s++)
 884:	83 c0 01             	add    $0x1,%eax
 887:	0f b6 10             	movzbl (%eax),%edx
 88a:	84 d2                	test   %dl,%dl
 88c:	75 f2                	jne    880 <strchr+0x20>
      return (char*)s;
  return 0;
 88e:	31 c0                	xor    %eax,%eax
}
 890:	5b                   	pop    %ebx
 891:	5d                   	pop    %ebp
 892:	c3                   	ret    
 893:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008a0 <gets>:

char*
gets(char *buf, int max)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8a6:	31 f6                	xor    %esi,%esi
 8a8:	89 f3                	mov    %esi,%ebx
{
 8aa:	83 ec 1c             	sub    $0x1c,%esp
 8ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 8b0:	eb 2f                	jmp    8e1 <gets+0x41>
 8b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 8b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 8bb:	83 ec 04             	sub    $0x4,%esp
 8be:	6a 01                	push   $0x1
 8c0:	50                   	push   %eax
 8c1:	6a 00                	push   $0x0
 8c3:	e8 32 01 00 00       	call   9fa <read>
    if(cc < 1)
 8c8:	83 c4 10             	add    $0x10,%esp
 8cb:	85 c0                	test   %eax,%eax
 8cd:	7e 1c                	jle    8eb <gets+0x4b>
      break;
    buf[i++] = c;
 8cf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 8d3:	83 c7 01             	add    $0x1,%edi
 8d6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 8d9:	3c 0a                	cmp    $0xa,%al
 8db:	74 23                	je     900 <gets+0x60>
 8dd:	3c 0d                	cmp    $0xd,%al
 8df:	74 1f                	je     900 <gets+0x60>
  for(i=0; i+1 < max; ){
 8e1:	83 c3 01             	add    $0x1,%ebx
 8e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 8e7:	89 fe                	mov    %edi,%esi
 8e9:	7c cd                	jl     8b8 <gets+0x18>
 8eb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 8ed:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 8f0:	c6 03 00             	movb   $0x0,(%ebx)
}
 8f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8f6:	5b                   	pop    %ebx
 8f7:	5e                   	pop    %esi
 8f8:	5f                   	pop    %edi
 8f9:	5d                   	pop    %ebp
 8fa:	c3                   	ret    
 8fb:	90                   	nop
 8fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 900:	8b 75 08             	mov    0x8(%ebp),%esi
 903:	8b 45 08             	mov    0x8(%ebp),%eax
 906:	01 de                	add    %ebx,%esi
 908:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 90a:	c6 03 00             	movb   $0x0,(%ebx)
}
 90d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 910:	5b                   	pop    %ebx
 911:	5e                   	pop    %esi
 912:	5f                   	pop    %edi
 913:	5d                   	pop    %ebp
 914:	c3                   	ret    
 915:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000920 <stat>:

int
stat(char *n, struct stat *st)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	56                   	push   %esi
 924:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 925:	83 ec 08             	sub    $0x8,%esp
 928:	6a 00                	push   $0x0
 92a:	ff 75 08             	pushl  0x8(%ebp)
 92d:	e8 f0 00 00 00       	call   a22 <open>
  if(fd < 0)
 932:	83 c4 10             	add    $0x10,%esp
 935:	85 c0                	test   %eax,%eax
 937:	78 27                	js     960 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 939:	83 ec 08             	sub    $0x8,%esp
 93c:	ff 75 0c             	pushl  0xc(%ebp)
 93f:	89 c3                	mov    %eax,%ebx
 941:	50                   	push   %eax
 942:	e8 f3 00 00 00       	call   a3a <fstat>
  close(fd);
 947:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 94a:	89 c6                	mov    %eax,%esi
  close(fd);
 94c:	e8 b9 00 00 00       	call   a0a <close>
  return r;
 951:	83 c4 10             	add    $0x10,%esp
}
 954:	8d 65 f8             	lea    -0x8(%ebp),%esp
 957:	89 f0                	mov    %esi,%eax
 959:	5b                   	pop    %ebx
 95a:	5e                   	pop    %esi
 95b:	5d                   	pop    %ebp
 95c:	c3                   	ret    
 95d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 960:	be ff ff ff ff       	mov    $0xffffffff,%esi
 965:	eb ed                	jmp    954 <stat+0x34>
 967:	89 f6                	mov    %esi,%esi
 969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000970 <atoi>:

int
atoi(const char *s)
{
 970:	55                   	push   %ebp
 971:	89 e5                	mov    %esp,%ebp
 973:	53                   	push   %ebx
 974:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 977:	0f be 11             	movsbl (%ecx),%edx
 97a:	8d 42 d0             	lea    -0x30(%edx),%eax
 97d:	3c 09                	cmp    $0x9,%al
  n = 0;
 97f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 984:	77 1f                	ja     9a5 <atoi+0x35>
 986:	8d 76 00             	lea    0x0(%esi),%esi
 989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 990:	8d 04 80             	lea    (%eax,%eax,4),%eax
 993:	83 c1 01             	add    $0x1,%ecx
 996:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 99a:	0f be 11             	movsbl (%ecx),%edx
 99d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 9a0:	80 fb 09             	cmp    $0x9,%bl
 9a3:	76 eb                	jbe    990 <atoi+0x20>
  return n;
}
 9a5:	5b                   	pop    %ebx
 9a6:	5d                   	pop    %ebp
 9a7:	c3                   	ret    
 9a8:	90                   	nop
 9a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000009b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 9b0:	55                   	push   %ebp
 9b1:	89 e5                	mov    %esp,%ebp
 9b3:	56                   	push   %esi
 9b4:	53                   	push   %ebx
 9b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9b8:	8b 45 08             	mov    0x8(%ebp),%eax
 9bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 9be:	85 db                	test   %ebx,%ebx
 9c0:	7e 14                	jle    9d6 <memmove+0x26>
 9c2:	31 d2                	xor    %edx,%edx
 9c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 9c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 9cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 9cf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 9d2:	39 d3                	cmp    %edx,%ebx
 9d4:	75 f2                	jne    9c8 <memmove+0x18>
  return vdst;
}
 9d6:	5b                   	pop    %ebx
 9d7:	5e                   	pop    %esi
 9d8:	5d                   	pop    %ebp
 9d9:	c3                   	ret    

000009da <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 9da:	b8 01 00 00 00       	mov    $0x1,%eax
 9df:	cd 40                	int    $0x40
 9e1:	c3                   	ret    

000009e2 <exit>:
SYSCALL(exit)
 9e2:	b8 02 00 00 00       	mov    $0x2,%eax
 9e7:	cd 40                	int    $0x40
 9e9:	c3                   	ret    

000009ea <wait>:
SYSCALL(wait)
 9ea:	b8 03 00 00 00       	mov    $0x3,%eax
 9ef:	cd 40                	int    $0x40
 9f1:	c3                   	ret    

000009f2 <pipe>:
SYSCALL(pipe)
 9f2:	b8 04 00 00 00       	mov    $0x4,%eax
 9f7:	cd 40                	int    $0x40
 9f9:	c3                   	ret    

000009fa <read>:
SYSCALL(read)
 9fa:	b8 05 00 00 00       	mov    $0x5,%eax
 9ff:	cd 40                	int    $0x40
 a01:	c3                   	ret    

00000a02 <write>:
SYSCALL(write)
 a02:	b8 10 00 00 00       	mov    $0x10,%eax
 a07:	cd 40                	int    $0x40
 a09:	c3                   	ret    

00000a0a <close>:
SYSCALL(close)
 a0a:	b8 15 00 00 00       	mov    $0x15,%eax
 a0f:	cd 40                	int    $0x40
 a11:	c3                   	ret    

00000a12 <kill>:
SYSCALL(kill)
 a12:	b8 06 00 00 00       	mov    $0x6,%eax
 a17:	cd 40                	int    $0x40
 a19:	c3                   	ret    

00000a1a <exec>:
SYSCALL(exec)
 a1a:	b8 07 00 00 00       	mov    $0x7,%eax
 a1f:	cd 40                	int    $0x40
 a21:	c3                   	ret    

00000a22 <open>:
SYSCALL(open)
 a22:	b8 0f 00 00 00       	mov    $0xf,%eax
 a27:	cd 40                	int    $0x40
 a29:	c3                   	ret    

00000a2a <mknod>:
SYSCALL(mknod)
 a2a:	b8 11 00 00 00       	mov    $0x11,%eax
 a2f:	cd 40                	int    $0x40
 a31:	c3                   	ret    

00000a32 <unlink>:
SYSCALL(unlink)
 a32:	b8 12 00 00 00       	mov    $0x12,%eax
 a37:	cd 40                	int    $0x40
 a39:	c3                   	ret    

00000a3a <fstat>:
SYSCALL(fstat)
 a3a:	b8 08 00 00 00       	mov    $0x8,%eax
 a3f:	cd 40                	int    $0x40
 a41:	c3                   	ret    

00000a42 <link>:
SYSCALL(link)
 a42:	b8 13 00 00 00       	mov    $0x13,%eax
 a47:	cd 40                	int    $0x40
 a49:	c3                   	ret    

00000a4a <mkdir>:
SYSCALL(mkdir)
 a4a:	b8 14 00 00 00       	mov    $0x14,%eax
 a4f:	cd 40                	int    $0x40
 a51:	c3                   	ret    

00000a52 <chdir>:
SYSCALL(chdir)
 a52:	b8 09 00 00 00       	mov    $0x9,%eax
 a57:	cd 40                	int    $0x40
 a59:	c3                   	ret    

00000a5a <dup>:
SYSCALL(dup)
 a5a:	b8 0a 00 00 00       	mov    $0xa,%eax
 a5f:	cd 40                	int    $0x40
 a61:	c3                   	ret    

00000a62 <getpid>:
SYSCALL(getpid)
 a62:	b8 0b 00 00 00       	mov    $0xb,%eax
 a67:	cd 40                	int    $0x40
 a69:	c3                   	ret    

00000a6a <sbrk>:
SYSCALL(sbrk)
 a6a:	b8 0c 00 00 00       	mov    $0xc,%eax
 a6f:	cd 40                	int    $0x40
 a71:	c3                   	ret    

00000a72 <sleep>:
SYSCALL(sleep)
 a72:	b8 0d 00 00 00       	mov    $0xd,%eax
 a77:	cd 40                	int    $0x40
 a79:	c3                   	ret    

00000a7a <uptime>:
SYSCALL(uptime)
 a7a:	b8 0e 00 00 00       	mov    $0xe,%eax
 a7f:	cd 40                	int    $0x40
 a81:	c3                   	ret    

00000a82 <trace>:
SYSCALL(trace)
 a82:	b8 16 00 00 00       	mov    $0x16,%eax
 a87:	cd 40                	int    $0x40
 a89:	c3                   	ret    
 a8a:	66 90                	xchg   %ax,%ax
 a8c:	66 90                	xchg   %ax,%ax
 a8e:	66 90                	xchg   %ax,%ax

00000a90 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 a90:	55                   	push   %ebp
 a91:	89 e5                	mov    %esp,%ebp
 a93:	57                   	push   %edi
 a94:	56                   	push   %esi
 a95:	53                   	push   %ebx
 a96:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a99:	85 d2                	test   %edx,%edx
{
 a9b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 a9e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 aa0:	79 76                	jns    b18 <printint+0x88>
 aa2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 aa6:	74 70                	je     b18 <printint+0x88>
    x = -xx;
 aa8:	f7 d8                	neg    %eax
    neg = 1;
 aaa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 ab1:	31 f6                	xor    %esi,%esi
 ab3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 ab6:	eb 0a                	jmp    ac2 <printint+0x32>
 ab8:	90                   	nop
 ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 ac0:	89 fe                	mov    %edi,%esi
 ac2:	31 d2                	xor    %edx,%edx
 ac4:	8d 7e 01             	lea    0x1(%esi),%edi
 ac7:	f7 f1                	div    %ecx
 ac9:	0f b6 92 64 0f 00 00 	movzbl 0xf64(%edx),%edx
  }while((x /= base) != 0);
 ad0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 ad2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 ad5:	75 e9                	jne    ac0 <printint+0x30>
  if(neg)
 ad7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 ada:	85 c0                	test   %eax,%eax
 adc:	74 08                	je     ae6 <printint+0x56>
    buf[i++] = '-';
 ade:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 ae3:	8d 7e 02             	lea    0x2(%esi),%edi
 ae6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 aea:	8b 7d c0             	mov    -0x40(%ebp),%edi
 aed:	8d 76 00             	lea    0x0(%esi),%esi
 af0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 af3:	83 ec 04             	sub    $0x4,%esp
 af6:	83 ee 01             	sub    $0x1,%esi
 af9:	6a 01                	push   $0x1
 afb:	53                   	push   %ebx
 afc:	57                   	push   %edi
 afd:	88 45 d7             	mov    %al,-0x29(%ebp)
 b00:	e8 fd fe ff ff       	call   a02 <write>

  while(--i >= 0)
 b05:	83 c4 10             	add    $0x10,%esp
 b08:	39 de                	cmp    %ebx,%esi
 b0a:	75 e4                	jne    af0 <printint+0x60>
    putc(fd, buf[i]);
}
 b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b0f:	5b                   	pop    %ebx
 b10:	5e                   	pop    %esi
 b11:	5f                   	pop    %edi
 b12:	5d                   	pop    %ebp
 b13:	c3                   	ret    
 b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 b18:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 b1f:	eb 90                	jmp    ab1 <printint+0x21>
 b21:	eb 0d                	jmp    b30 <printf>
 b23:	90                   	nop
 b24:	90                   	nop
 b25:	90                   	nop
 b26:	90                   	nop
 b27:	90                   	nop
 b28:	90                   	nop
 b29:	90                   	nop
 b2a:	90                   	nop
 b2b:	90                   	nop
 b2c:	90                   	nop
 b2d:	90                   	nop
 b2e:	90                   	nop
 b2f:	90                   	nop

00000b30 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b30:	55                   	push   %ebp
 b31:	89 e5                	mov    %esp,%ebp
 b33:	57                   	push   %edi
 b34:	56                   	push   %esi
 b35:	53                   	push   %ebx
 b36:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b39:	8b 75 0c             	mov    0xc(%ebp),%esi
 b3c:	0f b6 1e             	movzbl (%esi),%ebx
 b3f:	84 db                	test   %bl,%bl
 b41:	0f 84 b3 00 00 00    	je     bfa <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 b47:	8d 45 10             	lea    0x10(%ebp),%eax
 b4a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 b4d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 b4f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 b52:	eb 2f                	jmp    b83 <printf+0x53>
 b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 b58:	83 f8 25             	cmp    $0x25,%eax
 b5b:	0f 84 a7 00 00 00    	je     c08 <printf+0xd8>
  write(fd, &c, 1);
 b61:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 b64:	83 ec 04             	sub    $0x4,%esp
 b67:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 b6a:	6a 01                	push   $0x1
 b6c:	50                   	push   %eax
 b6d:	ff 75 08             	pushl  0x8(%ebp)
 b70:	e8 8d fe ff ff       	call   a02 <write>
 b75:	83 c4 10             	add    $0x10,%esp
 b78:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 b7b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 b7f:	84 db                	test   %bl,%bl
 b81:	74 77                	je     bfa <printf+0xca>
    if(state == 0){
 b83:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 b85:	0f be cb             	movsbl %bl,%ecx
 b88:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 b8b:	74 cb                	je     b58 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 b8d:	83 ff 25             	cmp    $0x25,%edi
 b90:	75 e6                	jne    b78 <printf+0x48>
      if(c == 'd'){
 b92:	83 f8 64             	cmp    $0x64,%eax
 b95:	0f 84 05 01 00 00    	je     ca0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 b9b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 ba1:	83 f9 70             	cmp    $0x70,%ecx
 ba4:	74 72                	je     c18 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 ba6:	83 f8 73             	cmp    $0x73,%eax
 ba9:	0f 84 99 00 00 00    	je     c48 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 baf:	83 f8 63             	cmp    $0x63,%eax
 bb2:	0f 84 08 01 00 00    	je     cc0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 bb8:	83 f8 25             	cmp    $0x25,%eax
 bbb:	0f 84 ef 00 00 00    	je     cb0 <printf+0x180>
  write(fd, &c, 1);
 bc1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 bc4:	83 ec 04             	sub    $0x4,%esp
 bc7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 bcb:	6a 01                	push   $0x1
 bcd:	50                   	push   %eax
 bce:	ff 75 08             	pushl  0x8(%ebp)
 bd1:	e8 2c fe ff ff       	call   a02 <write>
 bd6:	83 c4 0c             	add    $0xc,%esp
 bd9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 bdc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 bdf:	6a 01                	push   $0x1
 be1:	50                   	push   %eax
 be2:	ff 75 08             	pushl  0x8(%ebp)
 be5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 be8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 bea:	e8 13 fe ff ff       	call   a02 <write>
  for(i = 0; fmt[i]; i++){
 bef:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 bf3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 bf6:	84 db                	test   %bl,%bl
 bf8:	75 89                	jne    b83 <printf+0x53>
    }
  }
}
 bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 bfd:	5b                   	pop    %ebx
 bfe:	5e                   	pop    %esi
 bff:	5f                   	pop    %edi
 c00:	5d                   	pop    %ebp
 c01:	c3                   	ret    
 c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 c08:	bf 25 00 00 00       	mov    $0x25,%edi
 c0d:	e9 66 ff ff ff       	jmp    b78 <printf+0x48>
 c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 c18:	83 ec 0c             	sub    $0xc,%esp
 c1b:	b9 10 00 00 00       	mov    $0x10,%ecx
 c20:	6a 00                	push   $0x0
 c22:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 c25:	8b 45 08             	mov    0x8(%ebp),%eax
 c28:	8b 17                	mov    (%edi),%edx
 c2a:	e8 61 fe ff ff       	call   a90 <printint>
        ap++;
 c2f:	89 f8                	mov    %edi,%eax
 c31:	83 c4 10             	add    $0x10,%esp
      state = 0;
 c34:	31 ff                	xor    %edi,%edi
        ap++;
 c36:	83 c0 04             	add    $0x4,%eax
 c39:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 c3c:	e9 37 ff ff ff       	jmp    b78 <printf+0x48>
 c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 c48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 c4b:	8b 08                	mov    (%eax),%ecx
        ap++;
 c4d:	83 c0 04             	add    $0x4,%eax
 c50:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 c53:	85 c9                	test   %ecx,%ecx
 c55:	0f 84 8e 00 00 00    	je     ce9 <printf+0x1b9>
        while(*s != 0){
 c5b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 c5e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 c60:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 c62:	84 c0                	test   %al,%al
 c64:	0f 84 0e ff ff ff    	je     b78 <printf+0x48>
 c6a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 c6d:	89 de                	mov    %ebx,%esi
 c6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 c72:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 c75:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 c78:	83 ec 04             	sub    $0x4,%esp
          s++;
 c7b:	83 c6 01             	add    $0x1,%esi
 c7e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 c81:	6a 01                	push   $0x1
 c83:	57                   	push   %edi
 c84:	53                   	push   %ebx
 c85:	e8 78 fd ff ff       	call   a02 <write>
        while(*s != 0){
 c8a:	0f b6 06             	movzbl (%esi),%eax
 c8d:	83 c4 10             	add    $0x10,%esp
 c90:	84 c0                	test   %al,%al
 c92:	75 e4                	jne    c78 <printf+0x148>
 c94:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 c97:	31 ff                	xor    %edi,%edi
 c99:	e9 da fe ff ff       	jmp    b78 <printf+0x48>
 c9e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 ca0:	83 ec 0c             	sub    $0xc,%esp
 ca3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 ca8:	6a 01                	push   $0x1
 caa:	e9 73 ff ff ff       	jmp    c22 <printf+0xf2>
 caf:	90                   	nop
  write(fd, &c, 1);
 cb0:	83 ec 04             	sub    $0x4,%esp
 cb3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 cb6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 cb9:	6a 01                	push   $0x1
 cbb:	e9 21 ff ff ff       	jmp    be1 <printf+0xb1>
        putc(fd, *ap);
 cc0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 cc3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 cc6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 cc8:	6a 01                	push   $0x1
        ap++;
 cca:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 ccd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 cd0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 cd3:	50                   	push   %eax
 cd4:	ff 75 08             	pushl  0x8(%ebp)
 cd7:	e8 26 fd ff ff       	call   a02 <write>
        ap++;
 cdc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 cdf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 ce2:	31 ff                	xor    %edi,%edi
 ce4:	e9 8f fe ff ff       	jmp    b78 <printf+0x48>
          s = "(null)";
 ce9:	bb 5c 0f 00 00       	mov    $0xf5c,%ebx
        while(*s != 0){
 cee:	b8 28 00 00 00       	mov    $0x28,%eax
 cf3:	e9 72 ff ff ff       	jmp    c6a <printf+0x13a>
 cf8:	66 90                	xchg   %ax,%ax
 cfa:	66 90                	xchg   %ax,%ax
 cfc:	66 90                	xchg   %ax,%ax
 cfe:	66 90                	xchg   %ax,%ax

00000d00 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d00:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d01:	a1 04 15 00 00       	mov    0x1504,%eax
{
 d06:	89 e5                	mov    %esp,%ebp
 d08:	57                   	push   %edi
 d09:	56                   	push   %esi
 d0a:	53                   	push   %ebx
 d0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 d0e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d18:	39 c8                	cmp    %ecx,%eax
 d1a:	8b 10                	mov    (%eax),%edx
 d1c:	73 32                	jae    d50 <free+0x50>
 d1e:	39 d1                	cmp    %edx,%ecx
 d20:	72 04                	jb     d26 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d22:	39 d0                	cmp    %edx,%eax
 d24:	72 32                	jb     d58 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 d26:	8b 73 fc             	mov    -0x4(%ebx),%esi
 d29:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 d2c:	39 fa                	cmp    %edi,%edx
 d2e:	74 30                	je     d60 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 d30:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 d33:	8b 50 04             	mov    0x4(%eax),%edx
 d36:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 d39:	39 f1                	cmp    %esi,%ecx
 d3b:	74 3a                	je     d77 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 d3d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 d3f:	a3 04 15 00 00       	mov    %eax,0x1504
}
 d44:	5b                   	pop    %ebx
 d45:	5e                   	pop    %esi
 d46:	5f                   	pop    %edi
 d47:	5d                   	pop    %ebp
 d48:	c3                   	ret    
 d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d50:	39 d0                	cmp    %edx,%eax
 d52:	72 04                	jb     d58 <free+0x58>
 d54:	39 d1                	cmp    %edx,%ecx
 d56:	72 ce                	jb     d26 <free+0x26>
{
 d58:	89 d0                	mov    %edx,%eax
 d5a:	eb bc                	jmp    d18 <free+0x18>
 d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 d60:	03 72 04             	add    0x4(%edx),%esi
 d63:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 d66:	8b 10                	mov    (%eax),%edx
 d68:	8b 12                	mov    (%edx),%edx
 d6a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 d6d:	8b 50 04             	mov    0x4(%eax),%edx
 d70:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 d73:	39 f1                	cmp    %esi,%ecx
 d75:	75 c6                	jne    d3d <free+0x3d>
    p->s.size += bp->s.size;
 d77:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 d7a:	a3 04 15 00 00       	mov    %eax,0x1504
    p->s.size += bp->s.size;
 d7f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d82:	8b 53 f8             	mov    -0x8(%ebx),%edx
 d85:	89 10                	mov    %edx,(%eax)
}
 d87:	5b                   	pop    %ebx
 d88:	5e                   	pop    %esi
 d89:	5f                   	pop    %edi
 d8a:	5d                   	pop    %ebp
 d8b:	c3                   	ret    
 d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d90 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d90:	55                   	push   %ebp
 d91:	89 e5                	mov    %esp,%ebp
 d93:	57                   	push   %edi
 d94:	56                   	push   %esi
 d95:	53                   	push   %ebx
 d96:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d99:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 d9c:	8b 15 04 15 00 00    	mov    0x1504,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 da2:	8d 78 07             	lea    0x7(%eax),%edi
 da5:	c1 ef 03             	shr    $0x3,%edi
 da8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 dab:	85 d2                	test   %edx,%edx
 dad:	0f 84 9d 00 00 00    	je     e50 <malloc+0xc0>
 db3:	8b 02                	mov    (%edx),%eax
 db5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 db8:	39 cf                	cmp    %ecx,%edi
 dba:	76 6c                	jbe    e28 <malloc+0x98>
 dbc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 dc2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 dc7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 dca:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 dd1:	eb 0e                	jmp    de1 <malloc+0x51>
 dd3:	90                   	nop
 dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dd8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 dda:	8b 48 04             	mov    0x4(%eax),%ecx
 ddd:	39 f9                	cmp    %edi,%ecx
 ddf:	73 47                	jae    e28 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 de1:	39 05 04 15 00 00    	cmp    %eax,0x1504
 de7:	89 c2                	mov    %eax,%edx
 de9:	75 ed                	jne    dd8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 deb:	83 ec 0c             	sub    $0xc,%esp
 dee:	56                   	push   %esi
 def:	e8 76 fc ff ff       	call   a6a <sbrk>
  if(p == (char*)-1)
 df4:	83 c4 10             	add    $0x10,%esp
 df7:	83 f8 ff             	cmp    $0xffffffff,%eax
 dfa:	74 1c                	je     e18 <malloc+0x88>
  hp->s.size = nu;
 dfc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 dff:	83 ec 0c             	sub    $0xc,%esp
 e02:	83 c0 08             	add    $0x8,%eax
 e05:	50                   	push   %eax
 e06:	e8 f5 fe ff ff       	call   d00 <free>
  return freep;
 e0b:	8b 15 04 15 00 00    	mov    0x1504,%edx
      if((p = morecore(nunits)) == 0)
 e11:	83 c4 10             	add    $0x10,%esp
 e14:	85 d2                	test   %edx,%edx
 e16:	75 c0                	jne    dd8 <malloc+0x48>
        return 0;
  }
}
 e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 e1b:	31 c0                	xor    %eax,%eax
}
 e1d:	5b                   	pop    %ebx
 e1e:	5e                   	pop    %esi
 e1f:	5f                   	pop    %edi
 e20:	5d                   	pop    %ebp
 e21:	c3                   	ret    
 e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 e28:	39 cf                	cmp    %ecx,%edi
 e2a:	74 54                	je     e80 <malloc+0xf0>
        p->s.size -= nunits;
 e2c:	29 f9                	sub    %edi,%ecx
 e2e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 e31:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 e34:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 e37:	89 15 04 15 00 00    	mov    %edx,0x1504
}
 e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 e40:	83 c0 08             	add    $0x8,%eax
}
 e43:	5b                   	pop    %ebx
 e44:	5e                   	pop    %esi
 e45:	5f                   	pop    %edi
 e46:	5d                   	pop    %ebp
 e47:	c3                   	ret    
 e48:	90                   	nop
 e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 e50:	c7 05 04 15 00 00 08 	movl   $0x1508,0x1504
 e57:	15 00 00 
 e5a:	c7 05 08 15 00 00 08 	movl   $0x1508,0x1508
 e61:	15 00 00 
    base.s.size = 0;
 e64:	b8 08 15 00 00       	mov    $0x1508,%eax
 e69:	c7 05 0c 15 00 00 00 	movl   $0x0,0x150c
 e70:	00 00 00 
 e73:	e9 44 ff ff ff       	jmp    dbc <malloc+0x2c>
 e78:	90                   	nop
 e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 e80:	8b 08                	mov    (%eax),%ecx
 e82:	89 0a                	mov    %ecx,(%edx)
 e84:	eb b1                	jmp    e37 <malloc+0xa7>
