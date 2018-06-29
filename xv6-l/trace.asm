
_trace:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return pid;
}

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
    int n;
  };

  char *ssh;
  struct shared* sh;
  ssh=(char*)(uint)getsharem(0);
   f:	83 ec 0c             	sub    $0xc,%esp
  12:	6a 00                	push   $0x0
  14:	e8 40 04 00 00       	call   459 <getsharem>
  sh=(struct shared*)ssh;
  printf(2, "try-1\n");
  19:	59                   	pop    %ecx
  ssh=(char*)(uint)getsharem(0);
  1a:	89 c3                	mov    %eax,%ebx
  printf(2, "try-1\n");
  1c:	58                   	pop    %eax
  1d:	68 d1 08 00 00       	push   $0x8d1
  22:	6a 02                	push   $0x2
  24:	e8 37 05 00 00       	call   560 <printf>
  sh->n=10;
  printf(2, "ssh: %d\n",(uint)ssh);
  29:	83 c4 0c             	add    $0xc,%esp
  sh->n=10;
  2c:	c7 03 0a 00 00 00    	movl   $0xa,(%ebx)
  printf(2, "ssh: %d\n",(uint)ssh);
  32:	53                   	push   %ebx
  33:	68 d8 08 00 00       	push   $0x8d8
  38:	6a 02                	push   $0x2
  3a:	e8 21 05 00 00       	call   560 <printf>
  printf(2, "ans: %d\n", sh->n);
  3f:	83 c4 0c             	add    $0xc,%esp
  42:	ff 33                	pushl  (%ebx)
  44:	68 e1 08 00 00       	push   $0x8e1
  49:	6a 02                	push   $0x2
  4b:	e8 10 05 00 00       	call   560 <printf>
  pid = fork();
  50:	e8 54 03 00 00       	call   3a9 <fork>
  if(pid == -1)
  55:	83 c4 10             	add    $0x10,%esp
  58:	83 f8 ff             	cmp    $0xffffffff,%eax
  5b:	0f 84 a9 00 00 00    	je     10a <main+0x10a>
  if(fork1()==0)
  61:	85 c0                	test   %eax,%eax
  63:	75 59                	jne    be <main+0xbe>
  {
    printf(2, "try1\n");
  65:	52                   	push   %edx
  66:	52                   	push   %edx
  67:	68 ea 08 00 00       	push   $0x8ea
  6c:	6a 02                	push   $0x2
  6e:	e8 ed 04 00 00       	call   560 <printf>
    char *ssh;
    struct shared* sh;
    ssh=(char*)getsharem(0);
  73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7a:	e8 da 03 00 00       	call   459 <getsharem>
    printf(2, "ssh: %d\n",(uint)ssh);
  7f:	83 c4 0c             	add    $0xc,%esp
  82:	50                   	push   %eax
    ssh=(char*)getsharem(0);
  83:	89 c3                	mov    %eax,%ebx
    printf(2, "ssh: %d\n",(uint)ssh);
  85:	68 d8 08 00 00       	push   $0x8d8
  8a:	6a 02                	push   $0x2
  8c:	e8 cf 04 00 00       	call   560 <printf>
    sh=(struct shared*)ssh;
    printf(2, "ans: %d\n", sh->n);
  91:	83 c4 0c             	add    $0xc,%esp
  94:	ff 33                	pushl  (%ebx)
  96:	68 e1 08 00 00       	push   $0x8e1
  9b:	6a 02                	push   $0x2
  9d:	e8 be 04 00 00       	call   560 <printf>
    sh->n=100;
    printf(2, "ans: %d\n", sh->n);
  a2:	83 c4 0c             	add    $0xc,%esp
    sh->n=100;
  a5:	c7 03 64 00 00 00    	movl   $0x64,(%ebx)
    printf(2, "ans: %d\n", sh->n);
  ab:	6a 64                	push   $0x64
  ad:	68 e1 08 00 00       	push   $0x8e1
  b2:	6a 02                	push   $0x2
  b4:	e8 a7 04 00 00       	call   560 <printf>
    exit();
  b9:	e8 f3 02 00 00       	call   3b1 <exit>
  }
  wait();
  be:	e8 f6 02 00 00       	call   3b9 <wait>
  printf(2, "ssh: %d\n",(uint)ssh);
  c3:	50                   	push   %eax
  c4:	53                   	push   %ebx
  c5:	68 d8 08 00 00       	push   $0x8d8
  ca:	6a 02                	push   $0x2
  cc:	e8 8f 04 00 00       	call   560 <printf>
  printf(2, "ans: %d\n", sh->n);
  d1:	83 c4 0c             	add    $0xc,%esp
  d4:	ff 33                	pushl  (%ebx)
  d6:	68 e1 08 00 00       	push   $0x8e1
  db:	6a 02                	push   $0x2
  dd:	e8 7e 04 00 00       	call   560 <printf>
  sh->n=10;
  printf(2, "ans: %d\n", sh->n);
  e2:	83 c4 0c             	add    $0xc,%esp
  sh->n=10;
  e5:	c7 03 0a 00 00 00    	movl   $0xa,(%ebx)
  printf(2, "ans: %d\n", sh->n);
  eb:	6a 0a                	push   $0xa
  ed:	68 e1 08 00 00       	push   $0x8e1
  f2:	6a 02                	push   $0x2
  f4:	e8 67 04 00 00       	call   560 <printf>
  releasesharem(0);
  f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 100:	e8 5c 03 00 00       	call   461 <releasesharem>
  /* struct shared* shared=(struct shared*)getshared */
  /* printf(1,"fib 4: %c\n",*t); */
  exit();
 105:	e8 a7 02 00 00       	call   3b1 <exit>
    panic("fork");
 10a:	83 ec 0c             	sub    $0xc,%esp
 10d:	68 cc 08 00 00       	push   $0x8cc
 112:	e8 09 00 00 00       	call   120 <panic>
 117:	66 90                	xchg   %ax,%ax
 119:	66 90                	xchg   %ax,%ax
 11b:	66 90                	xchg   %ax,%ax
 11d:	66 90                	xchg   %ax,%ax
 11f:	90                   	nop

00000120 <panic>:
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
 126:	ff 75 08             	pushl  0x8(%ebp)
 129:	68 c8 08 00 00       	push   $0x8c8
 12e:	6a 02                	push   $0x2
 130:	e8 2b 04 00 00       	call   560 <printf>
  exit();
 135:	e8 77 02 00 00       	call   3b1 <exit>
 13a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000140 <fork1>:
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
 146:	e8 5e 02 00 00       	call   3a9 <fork>
  if(pid == -1)
 14b:	83 f8 ff             	cmp    $0xffffffff,%eax
 14e:	74 02                	je     152 <fork1+0x12>
}
 150:	c9                   	leave  
 151:	c3                   	ret    
    panic("fork");
 152:	83 ec 0c             	sub    $0xc,%esp
 155:	68 cc 08 00 00       	push   $0x8cc
 15a:	e8 c1 ff ff ff       	call   120 <panic>
 15f:	90                   	nop

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 160:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 161:	31 d2                	xor    %edx,%edx
{
 163:	89 e5                	mov    %esp,%ebp
 165:	53                   	push   %ebx
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 170:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 174:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 177:	83 c2 01             	add    $0x1,%edx
 17a:	84 c9                	test   %cl,%cl
 17c:	75 f2                	jne    170 <strcpy+0x10>
    ;
  return os;
}
 17e:	5b                   	pop    %ebx
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret    
 181:	eb 0d                	jmp    190 <strcmp>
 183:	90                   	nop
 184:	90                   	nop
 185:	90                   	nop
 186:	90                   	nop
 187:	90                   	nop
 188:	90                   	nop
 189:	90                   	nop
 18a:	90                   	nop
 18b:	90                   	nop
 18c:	90                   	nop
 18d:	90                   	nop
 18e:	90                   	nop
 18f:	90                   	nop

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
 195:	8b 5d 08             	mov    0x8(%ebp),%ebx
 198:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 19b:	0f b6 13             	movzbl (%ebx),%edx
 19e:	0f b6 0e             	movzbl (%esi),%ecx
 1a1:	84 d2                	test   %dl,%dl
 1a3:	74 1e                	je     1c3 <strcmp+0x33>
 1a5:	b8 01 00 00 00       	mov    $0x1,%eax
 1aa:	38 ca                	cmp    %cl,%dl
 1ac:	74 09                	je     1b7 <strcmp+0x27>
 1ae:	eb 20                	jmp    1d0 <strcmp+0x40>
 1b0:	83 c0 01             	add    $0x1,%eax
 1b3:	38 ca                	cmp    %cl,%dl
 1b5:	75 19                	jne    1d0 <strcmp+0x40>
 1b7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1bb:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 1bf:	84 d2                	test   %dl,%dl
 1c1:	75 ed                	jne    1b0 <strcmp+0x20>
 1c3:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 1c5:	5b                   	pop    %ebx
 1c6:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 1c7:	29 c8                	sub    %ecx,%eax
}
 1c9:	5d                   	pop    %ebp
 1ca:	c3                   	ret    
 1cb:	90                   	nop
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d0:	0f b6 c2             	movzbl %dl,%eax
 1d3:	5b                   	pop    %ebx
 1d4:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 1d5:	29 c8                	sub    %ecx,%eax
}
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001e0 <strlen>:

uint
strlen(char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1e6:	80 39 00             	cmpb   $0x0,(%ecx)
 1e9:	74 15                	je     200 <strlen+0x20>
 1eb:	31 d2                	xor    %edx,%edx
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
 1f0:	83 c2 01             	add    $0x1,%edx
 1f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1f7:	89 d0                	mov    %edx,%eax
 1f9:	75 f5                	jne    1f0 <strlen+0x10>
    ;
  return n;
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 200:	31 c0                	xor    %eax,%eax
}
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    
 204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 20a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 217:	8b 4d 10             	mov    0x10(%ebp),%ecx
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 d7                	mov    %edx,%edi
 21f:	fc                   	cld    
 220:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 222:	89 d0                	mov    %edx,%eax
 224:	5f                   	pop    %edi
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <strchr>:

char*
strchr(const char *s, char c)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 23a:	0f b6 18             	movzbl (%eax),%ebx
 23d:	84 db                	test   %bl,%bl
 23f:	74 1d                	je     25e <strchr+0x2e>
 241:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 243:	38 d3                	cmp    %dl,%bl
 245:	75 0d                	jne    254 <strchr+0x24>
 247:	eb 17                	jmp    260 <strchr+0x30>
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 250:	38 ca                	cmp    %cl,%dl
 252:	74 0c                	je     260 <strchr+0x30>
  for(; *s; s++)
 254:	83 c0 01             	add    $0x1,%eax
 257:	0f b6 10             	movzbl (%eax),%edx
 25a:	84 d2                	test   %dl,%dl
 25c:	75 f2                	jne    250 <strchr+0x20>
      return (char*)s;
  return 0;
 25e:	31 c0                	xor    %eax,%eax
}
 260:	5b                   	pop    %ebx
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <gets>:

char*
gets(char *buf, int max)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 275:	31 f6                	xor    %esi,%esi
{
 277:	53                   	push   %ebx
 278:	89 f3                	mov    %esi,%ebx
 27a:	83 ec 1c             	sub    $0x1c,%esp
 27d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 280:	eb 2f                	jmp    2b1 <gets+0x41>
 282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 288:	83 ec 04             	sub    $0x4,%esp
 28b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 28e:	6a 01                	push   $0x1
 290:	50                   	push   %eax
 291:	6a 00                	push   $0x0
 293:	e8 31 01 00 00       	call   3c9 <read>
    if(cc < 1)
 298:	83 c4 10             	add    $0x10,%esp
 29b:	85 c0                	test   %eax,%eax
 29d:	7e 1c                	jle    2bb <gets+0x4b>
      break;
    buf[i++] = c;
 29f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2a3:	83 c7 01             	add    $0x1,%edi
 2a6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 2a9:	3c 0a                	cmp    $0xa,%al
 2ab:	74 23                	je     2d0 <gets+0x60>
 2ad:	3c 0d                	cmp    $0xd,%al
 2af:	74 1f                	je     2d0 <gets+0x60>
  for(i=0; i+1 < max; ){
 2b1:	83 c3 01             	add    $0x1,%ebx
 2b4:	89 fe                	mov    %edi,%esi
 2b6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2b9:	7c cd                	jl     288 <gets+0x18>
 2bb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 2c0:	c6 03 00             	movb   $0x0,(%ebx)
}
 2c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    
 2cb:	90                   	nop
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2d0:	8b 75 08             	mov    0x8(%ebp),%esi
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	01 de                	add    %ebx,%esi
 2d8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2da:	c6 03 00             	movb   $0x0,(%ebx)
}
 2dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e0:	5b                   	pop    %ebx
 2e1:	5e                   	pop    %esi
 2e2:	5f                   	pop    %edi
 2e3:	5d                   	pop    %ebp
 2e4:	c3                   	ret    
 2e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <stat>:

int
stat(char *n, struct stat *st)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	56                   	push   %esi
 2f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f5:	83 ec 08             	sub    $0x8,%esp
 2f8:	6a 00                	push   $0x0
 2fa:	ff 75 08             	pushl  0x8(%ebp)
 2fd:	e8 ef 00 00 00       	call   3f1 <open>
  if(fd < 0)
 302:	83 c4 10             	add    $0x10,%esp
 305:	85 c0                	test   %eax,%eax
 307:	78 27                	js     330 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 309:	83 ec 08             	sub    $0x8,%esp
 30c:	ff 75 0c             	pushl  0xc(%ebp)
 30f:	89 c3                	mov    %eax,%ebx
 311:	50                   	push   %eax
 312:	e8 f2 00 00 00       	call   409 <fstat>
  close(fd);
 317:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 31a:	89 c6                	mov    %eax,%esi
  close(fd);
 31c:	e8 b8 00 00 00       	call   3d9 <close>
  return r;
 321:	83 c4 10             	add    $0x10,%esp
}
 324:	8d 65 f8             	lea    -0x8(%ebp),%esp
 327:	89 f0                	mov    %esi,%eax
 329:	5b                   	pop    %ebx
 32a:	5e                   	pop    %esi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
 32d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 330:	be ff ff ff ff       	mov    $0xffffffff,%esi
 335:	eb ed                	jmp    324 <stat+0x34>
 337:	89 f6                	mov    %esi,%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000340 <atoi>:

int
atoi(const char *s)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 347:	0f be 11             	movsbl (%ecx),%edx
 34a:	8d 42 d0             	lea    -0x30(%edx),%eax
 34d:	3c 09                	cmp    $0x9,%al
  n = 0;
 34f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 354:	77 1f                	ja     375 <atoi+0x35>
 356:	8d 76 00             	lea    0x0(%esi),%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 360:	83 c1 01             	add    $0x1,%ecx
 363:	8d 04 80             	lea    (%eax,%eax,4),%eax
 366:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 36a:	0f be 11             	movsbl (%ecx),%edx
 36d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 370:	80 fb 09             	cmp    $0x9,%bl
 373:	76 eb                	jbe    360 <atoi+0x20>
  return n;
}
 375:	5b                   	pop    %ebx
 376:	5d                   	pop    %ebp
 377:	c3                   	ret    
 378:	90                   	nop
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000380 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	8b 55 10             	mov    0x10(%ebp),%edx
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	56                   	push   %esi
 38b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38e:	85 d2                	test   %edx,%edx
 390:	7e 13                	jle    3a5 <memmove+0x25>
 392:	01 c2                	add    %eax,%edx
  dst = vdst;
 394:	89 c7                	mov    %eax,%edi
 396:	8d 76 00             	lea    0x0(%esi),%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    *dst++ = *src++;
 3a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3a1:	39 fa                	cmp    %edi,%edx
 3a3:	75 fb                	jne    3a0 <memmove+0x20>
  return vdst;
}
 3a5:	5e                   	pop    %esi
 3a6:	5f                   	pop    %edi
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret    

000003a9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a9:	b8 01 00 00 00       	mov    $0x1,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <exit>:
SYSCALL(exit)
 3b1:	b8 02 00 00 00       	mov    $0x2,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <wait>:
SYSCALL(wait)
 3b9:	b8 03 00 00 00       	mov    $0x3,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <pipe>:
SYSCALL(pipe)
 3c1:	b8 04 00 00 00       	mov    $0x4,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <read>:
SYSCALL(read)
 3c9:	b8 05 00 00 00       	mov    $0x5,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <write>:
SYSCALL(write)
 3d1:	b8 10 00 00 00       	mov    $0x10,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <close>:
SYSCALL(close)
 3d9:	b8 15 00 00 00       	mov    $0x15,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <kill>:
SYSCALL(kill)
 3e1:	b8 06 00 00 00       	mov    $0x6,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <exec>:
SYSCALL(exec)
 3e9:	b8 07 00 00 00       	mov    $0x7,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <open>:
SYSCALL(open)
 3f1:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <mknod>:
SYSCALL(mknod)
 3f9:	b8 11 00 00 00       	mov    $0x11,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <unlink>:
SYSCALL(unlink)
 401:	b8 12 00 00 00       	mov    $0x12,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <fstat>:
SYSCALL(fstat)
 409:	b8 08 00 00 00       	mov    $0x8,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <link>:
SYSCALL(link)
 411:	b8 13 00 00 00       	mov    $0x13,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <mkdir>:
SYSCALL(mkdir)
 419:	b8 14 00 00 00       	mov    $0x14,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <chdir>:
SYSCALL(chdir)
 421:	b8 09 00 00 00       	mov    $0x9,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <dup>:
SYSCALL(dup)
 429:	b8 0a 00 00 00       	mov    $0xa,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <getpid>:
SYSCALL(getpid)
 431:	b8 0b 00 00 00       	mov    $0xb,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <sbrk>:
SYSCALL(sbrk)
 439:	b8 0c 00 00 00       	mov    $0xc,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <sleep>:
SYSCALL(sleep)
 441:	b8 0d 00 00 00       	mov    $0xd,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <uptime>:
SYSCALL(uptime)
 449:	b8 0e 00 00 00       	mov    $0xe,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <trace>:
SYSCALL(trace)
 451:	b8 16 00 00 00       	mov    $0x16,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <getsharem>:
SYSCALL(getsharem)
 459:	b8 17 00 00 00       	mov    $0x17,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <releasesharem>:
SYSCALL(releasesharem)
 461:	b8 18 00 00 00       	mov    $0x18,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <split>:
SYSCALL(split)
 469:	b8 19 00 00 00       	mov    $0x19,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <memo>:
SYSCALL(memo)
 471:	b8 1a 00 00 00       	mov    $0x1a,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <getmemo>:
SYSCALL(getmemo)
 479:	b8 1b 00 00 00       	mov    $0x1b,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <setmemo>:
SYSCALL(setmemo)
 481:	b8 1c 00 00 00       	mov    $0x1c,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <att>:
SYSCALL(att)
 489:	b8 1d 00 00 00       	mov    $0x1d,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    
 491:	66 90                	xchg   %ax,%ax
 493:	66 90                	xchg   %ax,%ax
 495:	66 90                	xchg   %ax,%ax
 497:	66 90                	xchg   %ax,%ax
 499:	66 90                	xchg   %ax,%ax
 49b:	66 90                	xchg   %ax,%ax
 49d:	66 90                	xchg   %ax,%ax
 49f:	90                   	nop

000004a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4a6:	89 d3                	mov    %edx,%ebx
{
 4a8:	83 ec 3c             	sub    $0x3c,%esp
 4ab:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 4ae:	85 d2                	test   %edx,%edx
 4b0:	0f 89 92 00 00 00    	jns    548 <printint+0xa8>
 4b6:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4ba:	0f 84 88 00 00 00    	je     548 <printint+0xa8>
    neg = 1;
 4c0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 4c7:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 4c9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4d0:	8d 75 d7             	lea    -0x29(%ebp),%esi
 4d3:	eb 08                	jmp    4dd <printint+0x3d>
 4d5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4d8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 4db:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 4dd:	89 d8                	mov    %ebx,%eax
 4df:	31 d2                	xor    %edx,%edx
 4e1:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 4e4:	f7 f1                	div    %ecx
 4e6:	83 c7 01             	add    $0x1,%edi
 4e9:	0f b6 92 f8 08 00 00 	movzbl 0x8f8(%edx),%edx
 4f0:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 4f3:	39 d9                	cmp    %ebx,%ecx
 4f5:	76 e1                	jbe    4d8 <printint+0x38>
  if(neg)
 4f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
 4fa:	85 c0                	test   %eax,%eax
 4fc:	74 0d                	je     50b <printint+0x6b>
    buf[i++] = '-';
 4fe:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 503:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 508:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 50b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 50e:	8b 7d bc             	mov    -0x44(%ebp),%edi
 511:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 515:	eb 0f                	jmp    526 <printint+0x86>
 517:	89 f6                	mov    %esi,%esi
 519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 520:	0f b6 13             	movzbl (%ebx),%edx
 523:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 526:	83 ec 04             	sub    $0x4,%esp
 529:	88 55 d7             	mov    %dl,-0x29(%ebp)
 52c:	6a 01                	push   $0x1
 52e:	56                   	push   %esi
 52f:	57                   	push   %edi
 530:	e8 9c fe ff ff       	call   3d1 <write>

  while(--i >= 0)
 535:	83 c4 10             	add    $0x10,%esp
 538:	39 de                	cmp    %ebx,%esi
 53a:	75 e4                	jne    520 <printint+0x80>
    putc(fd, buf[i]);
}
 53c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53f:	5b                   	pop    %ebx
 540:	5e                   	pop    %esi
 541:	5f                   	pop    %edi
 542:	5d                   	pop    %ebp
 543:	c3                   	ret    
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 548:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 54f:	e9 75 ff ff ff       	jmp    4c9 <printint+0x29>
 554:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 55a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000560 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	56                   	push   %esi
 565:	53                   	push   %ebx
 566:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 569:	8b 75 0c             	mov    0xc(%ebp),%esi
 56c:	0f b6 1e             	movzbl (%esi),%ebx
 56f:	84 db                	test   %bl,%bl
 571:	0f 84 b9 00 00 00    	je     630 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 577:	8d 45 10             	lea    0x10(%ebp),%eax
 57a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 57d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 580:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 582:	89 45 d0             	mov    %eax,-0x30(%ebp)
 585:	eb 38                	jmp    5bf <printf+0x5f>
 587:	89 f6                	mov    %esi,%esi
 589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 590:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 593:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 598:	83 f8 25             	cmp    $0x25,%eax
 59b:	74 17                	je     5b4 <printf+0x54>
  write(fd, &c, 1);
 59d:	83 ec 04             	sub    $0x4,%esp
 5a0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5a3:	6a 01                	push   $0x1
 5a5:	57                   	push   %edi
 5a6:	ff 75 08             	pushl  0x8(%ebp)
 5a9:	e8 23 fe ff ff       	call   3d1 <write>
 5ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5b1:	83 c4 10             	add    $0x10,%esp
 5b4:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 5b7:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5bb:	84 db                	test   %bl,%bl
 5bd:	74 71                	je     630 <printf+0xd0>
    c = fmt[i] & 0xff;
 5bf:	0f be cb             	movsbl %bl,%ecx
 5c2:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5c5:	85 d2                	test   %edx,%edx
 5c7:	74 c7                	je     590 <printf+0x30>
      }
    } else if(state == '%'){
 5c9:	83 fa 25             	cmp    $0x25,%edx
 5cc:	75 e6                	jne    5b4 <printf+0x54>
      if(c == 'd'){
 5ce:	83 f8 64             	cmp    $0x64,%eax
 5d1:	0f 84 99 00 00 00    	je     670 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5d7:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5dd:	83 f9 70             	cmp    $0x70,%ecx
 5e0:	74 5e                	je     640 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5e2:	83 f8 73             	cmp    $0x73,%eax
 5e5:	0f 84 d5 00 00 00    	je     6c0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5eb:	83 f8 63             	cmp    $0x63,%eax
 5ee:	0f 84 8c 00 00 00    	je     680 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5f4:	83 f8 25             	cmp    $0x25,%eax
 5f7:	0f 84 b3 00 00 00    	je     6b0 <printf+0x150>
  write(fd, &c, 1);
 5fd:	83 ec 04             	sub    $0x4,%esp
 600:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 604:	6a 01                	push   $0x1
 606:	57                   	push   %edi
 607:	ff 75 08             	pushl  0x8(%ebp)
 60a:	e8 c2 fd ff ff       	call   3d1 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 60f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 612:	83 c4 0c             	add    $0xc,%esp
 615:	6a 01                	push   $0x1
 617:	83 c6 01             	add    $0x1,%esi
 61a:	57                   	push   %edi
 61b:	ff 75 08             	pushl  0x8(%ebp)
 61e:	e8 ae fd ff ff       	call   3d1 <write>
  for(i = 0; fmt[i]; i++){
 623:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 627:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 62a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 62c:	84 db                	test   %bl,%bl
 62e:	75 8f                	jne    5bf <printf+0x5f>
    }
  }
}
 630:	8d 65 f4             	lea    -0xc(%ebp),%esp
 633:	5b                   	pop    %ebx
 634:	5e                   	pop    %esi
 635:	5f                   	pop    %edi
 636:	5d                   	pop    %ebp
 637:	c3                   	ret    
 638:	90                   	nop
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 640:	83 ec 0c             	sub    $0xc,%esp
 643:	b9 10 00 00 00       	mov    $0x10,%ecx
 648:	6a 00                	push   $0x0
 64a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	8b 13                	mov    (%ebx),%edx
 652:	e8 49 fe ff ff       	call   4a0 <printint>
        ap++;
 657:	89 d8                	mov    %ebx,%eax
 659:	83 c4 10             	add    $0x10,%esp
      state = 0;
 65c:	31 d2                	xor    %edx,%edx
        ap++;
 65e:	83 c0 04             	add    $0x4,%eax
 661:	89 45 d0             	mov    %eax,-0x30(%ebp)
 664:	e9 4b ff ff ff       	jmp    5b4 <printf+0x54>
 669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 670:	83 ec 0c             	sub    $0xc,%esp
 673:	b9 0a 00 00 00       	mov    $0xa,%ecx
 678:	6a 01                	push   $0x1
 67a:	eb ce                	jmp    64a <printf+0xea>
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 680:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 683:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 686:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 688:	6a 01                	push   $0x1
        ap++;
 68a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 68d:	57                   	push   %edi
 68e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 691:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 694:	e8 38 fd ff ff       	call   3d1 <write>
        ap++;
 699:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 69c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 69f:	31 d2                	xor    %edx,%edx
 6a1:	e9 0e ff ff ff       	jmp    5b4 <printf+0x54>
 6a6:	8d 76 00             	lea    0x0(%esi),%esi
 6a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        putc(fd, c);
 6b0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6b3:	83 ec 04             	sub    $0x4,%esp
 6b6:	e9 5a ff ff ff       	jmp    615 <printf+0xb5>
 6bb:	90                   	nop
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 6c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6c3:	8b 18                	mov    (%eax),%ebx
        ap++;
 6c5:	83 c0 04             	add    $0x4,%eax
 6c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6cb:	85 db                	test   %ebx,%ebx
 6cd:	74 17                	je     6e6 <printf+0x186>
        while(*s != 0){
 6cf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 6d2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 6d4:	84 c0                	test   %al,%al
 6d6:	0f 84 d8 fe ff ff    	je     5b4 <printf+0x54>
 6dc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6df:	89 de                	mov    %ebx,%esi
 6e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6e4:	eb 1a                	jmp    700 <printf+0x1a0>
          s = "(null)";
 6e6:	bb f0 08 00 00       	mov    $0x8f0,%ebx
        while(*s != 0){
 6eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6ee:	b8 28 00 00 00       	mov    $0x28,%eax
 6f3:	89 de                	mov    %ebx,%esi
 6f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6f8:	90                   	nop
 6f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
          s++;
 703:	83 c6 01             	add    $0x1,%esi
 706:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 709:	6a 01                	push   $0x1
 70b:	57                   	push   %edi
 70c:	53                   	push   %ebx
 70d:	e8 bf fc ff ff       	call   3d1 <write>
        while(*s != 0){
 712:	0f b6 06             	movzbl (%esi),%eax
 715:	83 c4 10             	add    $0x10,%esp
 718:	84 c0                	test   %al,%al
 71a:	75 e4                	jne    700 <printf+0x1a0>
 71c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 71f:	31 d2                	xor    %edx,%edx
 721:	e9 8e fe ff ff       	jmp    5b4 <printf+0x54>
 726:	66 90                	xchg   %ax,%ax
 728:	66 90                	xchg   %ax,%ax
 72a:	66 90                	xchg   %ax,%ax
 72c:	66 90                	xchg   %ax,%ax
 72e:	66 90                	xchg   %ax,%ax

00000730 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 730:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	a1 e4 0b 00 00       	mov    0xbe4,%eax
{
 736:	89 e5                	mov    %esp,%ebp
 738:	57                   	push   %edi
 739:	56                   	push   %esi
 73a:	53                   	push   %ebx
 73b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 73e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 740:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 743:	39 c8                	cmp    %ecx,%eax
 745:	73 19                	jae    760 <free+0x30>
 747:	89 f6                	mov    %esi,%esi
 749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 750:	39 d1                	cmp    %edx,%ecx
 752:	72 14                	jb     768 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 754:	39 d0                	cmp    %edx,%eax
 756:	73 10                	jae    768 <free+0x38>
{
 758:	89 d0                	mov    %edx,%eax
 75a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75c:	39 c8                	cmp    %ecx,%eax
 75e:	72 f0                	jb     750 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	39 d0                	cmp    %edx,%eax
 762:	72 f4                	jb     758 <free+0x28>
 764:	39 d1                	cmp    %edx,%ecx
 766:	73 f0                	jae    758 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 768:	8b 73 fc             	mov    -0x4(%ebx),%esi
 76b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 76e:	39 fa                	cmp    %edi,%edx
 770:	74 1e                	je     790 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 772:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 775:	8b 50 04             	mov    0x4(%eax),%edx
 778:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 77b:	39 f1                	cmp    %esi,%ecx
 77d:	74 28                	je     7a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 77f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 781:	5b                   	pop    %ebx
  freep = p;
 782:	a3 e4 0b 00 00       	mov    %eax,0xbe4
}
 787:	5e                   	pop    %esi
 788:	5f                   	pop    %edi
 789:	5d                   	pop    %ebp
 78a:	c3                   	ret    
 78b:	90                   	nop
 78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 790:	03 72 04             	add    0x4(%edx),%esi
 793:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 12                	mov    (%edx),%edx
 79a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 79d:	8b 50 04             	mov    0x4(%eax),%edx
 7a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7a3:	39 f1                	cmp    %esi,%ecx
 7a5:	75 d8                	jne    77f <free+0x4f>
    p->s.size += bp->s.size;
 7a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7aa:	a3 e4 0b 00 00       	mov    %eax,0xbe4
    p->s.size += bp->s.size;
 7af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7b5:	89 10                	mov    %edx,(%eax)
}
 7b7:	5b                   	pop    %ebx
 7b8:	5e                   	pop    %esi
 7b9:	5f                   	pop    %edi
 7ba:	5d                   	pop    %ebp
 7bb:	c3                   	ret    
 7bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	57                   	push   %edi
 7c4:	56                   	push   %esi
 7c5:	53                   	push   %ebx
 7c6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7cc:	8b 3d e4 0b 00 00    	mov    0xbe4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d2:	8d 70 07             	lea    0x7(%eax),%esi
 7d5:	c1 ee 03             	shr    $0x3,%esi
 7d8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 7db:	85 ff                	test   %edi,%edi
 7dd:	0f 84 ad 00 00 00    	je     890 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 7e5:	8b 4a 04             	mov    0x4(%edx),%ecx
 7e8:	39 ce                	cmp    %ecx,%esi
 7ea:	76 72                	jbe    85e <malloc+0x9e>
 7ec:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7f2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7f7:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7fa:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 801:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 804:	eb 1b                	jmp    821 <malloc+0x61>
 806:	8d 76 00             	lea    0x0(%esi),%esi
 809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 812:	8b 48 04             	mov    0x4(%eax),%ecx
 815:	39 f1                	cmp    %esi,%ecx
 817:	73 4f                	jae    868 <malloc+0xa8>
 819:	8b 3d e4 0b 00 00    	mov    0xbe4,%edi
 81f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 821:	39 d7                	cmp    %edx,%edi
 823:	75 eb                	jne    810 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 825:	83 ec 0c             	sub    $0xc,%esp
 828:	ff 75 e4             	pushl  -0x1c(%ebp)
 82b:	e8 09 fc ff ff       	call   439 <sbrk>
  if(p == (char*)-1)
 830:	83 c4 10             	add    $0x10,%esp
 833:	83 f8 ff             	cmp    $0xffffffff,%eax
 836:	74 1c                	je     854 <malloc+0x94>
  hp->s.size = nu;
 838:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 83b:	83 ec 0c             	sub    $0xc,%esp
 83e:	83 c0 08             	add    $0x8,%eax
 841:	50                   	push   %eax
 842:	e8 e9 fe ff ff       	call   730 <free>
  return freep;
 847:	8b 15 e4 0b 00 00    	mov    0xbe4,%edx
      if((p = morecore(nunits)) == 0)
 84d:	83 c4 10             	add    $0x10,%esp
 850:	85 d2                	test   %edx,%edx
 852:	75 bc                	jne    810 <malloc+0x50>
        return 0;
  }
}
 854:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 857:	31 c0                	xor    %eax,%eax
}
 859:	5b                   	pop    %ebx
 85a:	5e                   	pop    %esi
 85b:	5f                   	pop    %edi
 85c:	5d                   	pop    %ebp
 85d:	c3                   	ret    
    if(p->s.size >= nunits){
 85e:	89 d0                	mov    %edx,%eax
 860:	89 fa                	mov    %edi,%edx
 862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 868:	39 ce                	cmp    %ecx,%esi
 86a:	74 54                	je     8c0 <malloc+0x100>
        p->s.size -= nunits;
 86c:	29 f1                	sub    %esi,%ecx
 86e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 871:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 874:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 877:	89 15 e4 0b 00 00    	mov    %edx,0xbe4
}
 87d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 880:	83 c0 08             	add    $0x8,%eax
}
 883:	5b                   	pop    %ebx
 884:	5e                   	pop    %esi
 885:	5f                   	pop    %edi
 886:	5d                   	pop    %ebp
 887:	c3                   	ret    
 888:	90                   	nop
 889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 890:	c7 05 e4 0b 00 00 e8 	movl   $0xbe8,0xbe4
 897:	0b 00 00 
    base.s.size = 0;
 89a:	bf e8 0b 00 00       	mov    $0xbe8,%edi
    base.s.ptr = freep = prevp = &base;
 89f:	c7 05 e8 0b 00 00 e8 	movl   $0xbe8,0xbe8
 8a6:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 8ab:	c7 05 ec 0b 00 00 00 	movl   $0x0,0xbec
 8b2:	00 00 00 
    if(p->s.size >= nunits){
 8b5:	e9 32 ff ff ff       	jmp    7ec <malloc+0x2c>
 8ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 8c0:	8b 08                	mov    (%eax),%ecx
 8c2:	89 0a                	mov    %ecx,(%edx)
 8c4:	eb b1                	jmp    877 <malloc+0xb7>
