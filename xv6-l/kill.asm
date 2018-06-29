
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 01                	mov    (%ecx),%eax
  15:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 2c                	jle    49 <main+0x49>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	pushl  (%ebx)
  2d:	83 c3 04             	add    $0x4,%ebx
  30:	e8 0b 02 00 00       	call   240 <atoi>
  35:	89 04 24             	mov    %eax,(%esp)
  38:	e8 a4 02 00 00       	call   2e1 <kill>
  for(i=1; i<argc; i++)
  3d:	83 c4 10             	add    $0x10,%esp
  40:	39 f3                	cmp    %esi,%ebx
  42:	75 e4                	jne    28 <main+0x28>
  exit();
  44:	e8 68 02 00 00       	call   2b1 <exit>
    printf(2, "usage: kill pid...\n");
  49:	50                   	push   %eax
  4a:	50                   	push   %eax
  4b:	68 c8 07 00 00       	push   $0x7c8
  50:	6a 02                	push   $0x2
  52:	e8 09 04 00 00       	call   460 <printf>
    exit();
  57:	e8 55 02 00 00       	call   2b1 <exit>
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  60:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  61:	31 d2                	xor    %edx,%edx
{
  63:	89 e5                	mov    %esp,%ebp
  65:	53                   	push   %ebx
  66:	8b 45 08             	mov    0x8(%ebp),%eax
  69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  77:	83 c2 01             	add    $0x1,%edx
  7a:	84 c9                	test   %cl,%cl
  7c:	75 f2                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  7e:	5b                   	pop    %ebx
  7f:	5d                   	pop    %ebp
  80:	c3                   	ret    
  81:	eb 0d                	jmp    90 <strcmp>
  83:	90                   	nop
  84:	90                   	nop
  85:	90                   	nop
  86:	90                   	nop
  87:	90                   	nop
  88:	90                   	nop
  89:	90                   	nop
  8a:	90                   	nop
  8b:	90                   	nop
  8c:	90                   	nop
  8d:	90                   	nop
  8e:	90                   	nop
  8f:	90                   	nop

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	56                   	push   %esi
  94:	53                   	push   %ebx
  95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  98:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
  9b:	0f b6 13             	movzbl (%ebx),%edx
  9e:	0f b6 0e             	movzbl (%esi),%ecx
  a1:	84 d2                	test   %dl,%dl
  a3:	74 1e                	je     c3 <strcmp+0x33>
  a5:	b8 01 00 00 00       	mov    $0x1,%eax
  aa:	38 ca                	cmp    %cl,%dl
  ac:	74 09                	je     b7 <strcmp+0x27>
  ae:	eb 20                	jmp    d0 <strcmp+0x40>
  b0:	83 c0 01             	add    $0x1,%eax
  b3:	38 ca                	cmp    %cl,%dl
  b5:	75 19                	jne    d0 <strcmp+0x40>
  b7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  bb:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
  bf:	84 d2                	test   %dl,%dl
  c1:	75 ed                	jne    b0 <strcmp+0x20>
  c3:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  c5:	5b                   	pop    %ebx
  c6:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
  c7:	29 c8                	sub    %ecx,%eax
}
  c9:	5d                   	pop    %ebp
  ca:	c3                   	ret    
  cb:	90                   	nop
  cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  d0:	0f b6 c2             	movzbl %dl,%eax
  d3:	5b                   	pop    %ebx
  d4:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
  d5:	29 c8                	sub    %ecx,%eax
}
  d7:	5d                   	pop    %ebp
  d8:	c3                   	ret    
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000e0 <strlen>:

uint
strlen(char *s)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  e6:	80 39 00             	cmpb   $0x0,(%ecx)
  e9:	74 15                	je     100 <strlen+0x20>
  eb:	31 d2                	xor    %edx,%edx
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  f0:	83 c2 01             	add    $0x1,%edx
  f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  f7:	89 d0                	mov    %edx,%eax
  f9:	75 f5                	jne    f0 <strlen+0x10>
    ;
  return n;
}
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 100:	31 c0                	xor    %eax,%eax
}
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    
 104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 10a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 117:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 d7                	mov    %edx,%edi
 11f:	fc                   	cld    
 120:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 122:	89 d0                	mov    %edx,%eax
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    
 127:	89 f6                	mov    %esi,%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	53                   	push   %ebx
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 13a:	0f b6 18             	movzbl (%eax),%ebx
 13d:	84 db                	test   %bl,%bl
 13f:	74 1d                	je     15e <strchr+0x2e>
 141:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 143:	38 d3                	cmp    %dl,%bl
 145:	75 0d                	jne    154 <strchr+0x24>
 147:	eb 17                	jmp    160 <strchr+0x30>
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 150:	38 ca                	cmp    %cl,%dl
 152:	74 0c                	je     160 <strchr+0x30>
  for(; *s; s++)
 154:	83 c0 01             	add    $0x1,%eax
 157:	0f b6 10             	movzbl (%eax),%edx
 15a:	84 d2                	test   %dl,%dl
 15c:	75 f2                	jne    150 <strchr+0x20>
      return (char*)s;
  return 0;
 15e:	31 c0                	xor    %eax,%eax
}
 160:	5b                   	pop    %ebx
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000170 <gets>:

char*
gets(char *buf, int max)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 175:	31 f6                	xor    %esi,%esi
{
 177:	53                   	push   %ebx
 178:	89 f3                	mov    %esi,%ebx
 17a:	83 ec 1c             	sub    $0x1c,%esp
 17d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 180:	eb 2f                	jmp    1b1 <gets+0x41>
 182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 188:	83 ec 04             	sub    $0x4,%esp
 18b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 18e:	6a 01                	push   $0x1
 190:	50                   	push   %eax
 191:	6a 00                	push   $0x0
 193:	e8 31 01 00 00       	call   2c9 <read>
    if(cc < 1)
 198:	83 c4 10             	add    $0x10,%esp
 19b:	85 c0                	test   %eax,%eax
 19d:	7e 1c                	jle    1bb <gets+0x4b>
      break;
    buf[i++] = c;
 19f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a3:	83 c7 01             	add    $0x1,%edi
 1a6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 1a9:	3c 0a                	cmp    $0xa,%al
 1ab:	74 23                	je     1d0 <gets+0x60>
 1ad:	3c 0d                	cmp    $0xd,%al
 1af:	74 1f                	je     1d0 <gets+0x60>
  for(i=0; i+1 < max; ){
 1b1:	83 c3 01             	add    $0x1,%ebx
 1b4:	89 fe                	mov    %edi,%esi
 1b6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1b9:	7c cd                	jl     188 <gets+0x18>
 1bb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 1c0:	c6 03 00             	movb   $0x0,(%ebx)
}
 1c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5f                   	pop    %edi
 1c9:	5d                   	pop    %ebp
 1ca:	c3                   	ret    
 1cb:	90                   	nop
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d0:	8b 75 08             	mov    0x8(%ebp),%esi
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	01 de                	add    %ebx,%esi
 1d8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 1da:	c6 03 00             	movb   $0x0,(%ebx)
}
 1dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e0:	5b                   	pop    %ebx
 1e1:	5e                   	pop    %esi
 1e2:	5f                   	pop    %edi
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    
 1e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <stat>:

int
stat(char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	6a 00                	push   $0x0
 1fa:	ff 75 08             	pushl  0x8(%ebp)
 1fd:	e8 ef 00 00 00       	call   2f1 <open>
  if(fd < 0)
 202:	83 c4 10             	add    $0x10,%esp
 205:	85 c0                	test   %eax,%eax
 207:	78 27                	js     230 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	ff 75 0c             	pushl  0xc(%ebp)
 20f:	89 c3                	mov    %eax,%ebx
 211:	50                   	push   %eax
 212:	e8 f2 00 00 00       	call   309 <fstat>
  close(fd);
 217:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 21a:	89 c6                	mov    %eax,%esi
  close(fd);
 21c:	e8 b8 00 00 00       	call   2d9 <close>
  return r;
 221:	83 c4 10             	add    $0x10,%esp
}
 224:	8d 65 f8             	lea    -0x8(%ebp),%esp
 227:	89 f0                	mov    %esi,%eax
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 230:	be ff ff ff ff       	mov    $0xffffffff,%esi
 235:	eb ed                	jmp    224 <stat+0x34>
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <atoi>:

int
atoi(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 247:	0f be 11             	movsbl (%ecx),%edx
 24a:	8d 42 d0             	lea    -0x30(%edx),%eax
 24d:	3c 09                	cmp    $0x9,%al
  n = 0;
 24f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 254:	77 1f                	ja     275 <atoi+0x35>
 256:	8d 76 00             	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 260:	83 c1 01             	add    $0x1,%ecx
 263:	8d 04 80             	lea    (%eax,%eax,4),%eax
 266:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 26a:	0f be 11             	movsbl (%ecx),%edx
 26d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x20>
  return n;
}
 275:	5b                   	pop    %ebx
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    
 278:	90                   	nop
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	8b 55 10             	mov    0x10(%ebp),%edx
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	56                   	push   %esi
 28b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28e:	85 d2                	test   %edx,%edx
 290:	7e 13                	jle    2a5 <memmove+0x25>
 292:	01 c2                	add    %eax,%edx
  dst = vdst;
 294:	89 c7                	mov    %eax,%edi
 296:	8d 76 00             	lea    0x0(%esi),%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    *dst++ = *src++;
 2a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2a1:	39 fa                	cmp    %edi,%edx
 2a3:	75 fb                	jne    2a0 <memmove+0x20>
  return vdst;
}
 2a5:	5e                   	pop    %esi
 2a6:	5f                   	pop    %edi
 2a7:	5d                   	pop    %ebp
 2a8:	c3                   	ret    

000002a9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <exit>:
SYSCALL(exit)
 2b1:	b8 02 00 00 00       	mov    $0x2,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <wait>:
SYSCALL(wait)
 2b9:	b8 03 00 00 00       	mov    $0x3,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <pipe>:
SYSCALL(pipe)
 2c1:	b8 04 00 00 00       	mov    $0x4,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <read>:
SYSCALL(read)
 2c9:	b8 05 00 00 00       	mov    $0x5,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <write>:
SYSCALL(write)
 2d1:	b8 10 00 00 00       	mov    $0x10,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <close>:
SYSCALL(close)
 2d9:	b8 15 00 00 00       	mov    $0x15,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <kill>:
SYSCALL(kill)
 2e1:	b8 06 00 00 00       	mov    $0x6,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <exec>:
SYSCALL(exec)
 2e9:	b8 07 00 00 00       	mov    $0x7,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <open>:
SYSCALL(open)
 2f1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <mknod>:
SYSCALL(mknod)
 2f9:	b8 11 00 00 00       	mov    $0x11,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <unlink>:
SYSCALL(unlink)
 301:	b8 12 00 00 00       	mov    $0x12,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <fstat>:
SYSCALL(fstat)
 309:	b8 08 00 00 00       	mov    $0x8,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <link>:
SYSCALL(link)
 311:	b8 13 00 00 00       	mov    $0x13,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <mkdir>:
SYSCALL(mkdir)
 319:	b8 14 00 00 00       	mov    $0x14,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <chdir>:
SYSCALL(chdir)
 321:	b8 09 00 00 00       	mov    $0x9,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <dup>:
SYSCALL(dup)
 329:	b8 0a 00 00 00       	mov    $0xa,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <getpid>:
SYSCALL(getpid)
 331:	b8 0b 00 00 00       	mov    $0xb,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <sbrk>:
SYSCALL(sbrk)
 339:	b8 0c 00 00 00       	mov    $0xc,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <sleep>:
SYSCALL(sleep)
 341:	b8 0d 00 00 00       	mov    $0xd,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <uptime>:
SYSCALL(uptime)
 349:	b8 0e 00 00 00       	mov    $0xe,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <trace>:
SYSCALL(trace)
 351:	b8 16 00 00 00       	mov    $0x16,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <getsharem>:
SYSCALL(getsharem)
 359:	b8 17 00 00 00       	mov    $0x17,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <releasesharem>:
SYSCALL(releasesharem)
 361:	b8 18 00 00 00       	mov    $0x18,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <split>:
SYSCALL(split)
 369:	b8 19 00 00 00       	mov    $0x19,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <memo>:
SYSCALL(memo)
 371:	b8 1a 00 00 00       	mov    $0x1a,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <getmemo>:
SYSCALL(getmemo)
 379:	b8 1b 00 00 00       	mov    $0x1b,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <setmemo>:
SYSCALL(setmemo)
 381:	b8 1c 00 00 00       	mov    $0x1c,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <att>:
SYSCALL(att)
 389:	b8 1d 00 00 00       	mov    $0x1d,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    
 391:	66 90                	xchg   %ax,%ax
 393:	66 90                	xchg   %ax,%ax
 395:	66 90                	xchg   %ax,%ax
 397:	66 90                	xchg   %ax,%ax
 399:	66 90                	xchg   %ax,%ax
 39b:	66 90                	xchg   %ax,%ax
 39d:	66 90                	xchg   %ax,%ax
 39f:	90                   	nop

000003a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3a6:	89 d3                	mov    %edx,%ebx
{
 3a8:	83 ec 3c             	sub    $0x3c,%esp
 3ab:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 3ae:	85 d2                	test   %edx,%edx
 3b0:	0f 89 92 00 00 00    	jns    448 <printint+0xa8>
 3b6:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3ba:	0f 84 88 00 00 00    	je     448 <printint+0xa8>
    neg = 1;
 3c0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 3c7:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 3c9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3d0:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3d3:	eb 08                	jmp    3dd <printint+0x3d>
 3d5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3d8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 3db:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 3dd:	89 d8                	mov    %ebx,%eax
 3df:	31 d2                	xor    %edx,%edx
 3e1:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 3e4:	f7 f1                	div    %ecx
 3e6:	83 c7 01             	add    $0x1,%edi
 3e9:	0f b6 92 e4 07 00 00 	movzbl 0x7e4(%edx),%edx
 3f0:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 3f3:	39 d9                	cmp    %ebx,%ecx
 3f5:	76 e1                	jbe    3d8 <printint+0x38>
  if(neg)
 3f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
 3fa:	85 c0                	test   %eax,%eax
 3fc:	74 0d                	je     40b <printint+0x6b>
    buf[i++] = '-';
 3fe:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 403:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 408:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 40b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 40e:	8b 7d bc             	mov    -0x44(%ebp),%edi
 411:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 415:	eb 0f                	jmp    426 <printint+0x86>
 417:	89 f6                	mov    %esi,%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 420:	0f b6 13             	movzbl (%ebx),%edx
 423:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 426:	83 ec 04             	sub    $0x4,%esp
 429:	88 55 d7             	mov    %dl,-0x29(%ebp)
 42c:	6a 01                	push   $0x1
 42e:	56                   	push   %esi
 42f:	57                   	push   %edi
 430:	e8 9c fe ff ff       	call   2d1 <write>

  while(--i >= 0)
 435:	83 c4 10             	add    $0x10,%esp
 438:	39 de                	cmp    %ebx,%esi
 43a:	75 e4                	jne    420 <printint+0x80>
    putc(fd, buf[i]);
}
 43c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43f:	5b                   	pop    %ebx
 440:	5e                   	pop    %esi
 441:	5f                   	pop    %edi
 442:	5d                   	pop    %ebp
 443:	c3                   	ret    
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 448:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 44f:	e9 75 ff ff ff       	jmp    3c9 <printint+0x29>
 454:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 45a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000460 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
 466:	83 ec 2c             	sub    $0x2c,%esp
  uint *ap;


  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 469:	8b 75 0c             	mov    0xc(%ebp),%esi
 46c:	0f b6 1e             	movzbl (%esi),%ebx
 46f:	84 db                	test   %bl,%bl
 471:	0f 84 b9 00 00 00    	je     530 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 477:	8d 45 10             	lea    0x10(%ebp),%eax
 47a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 47d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 480:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 482:	89 45 d0             	mov    %eax,-0x30(%ebp)
 485:	eb 38                	jmp    4bf <printf+0x5f>
 487:	89 f6                	mov    %esi,%esi
 489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 490:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 493:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 498:	83 f8 25             	cmp    $0x25,%eax
 49b:	74 17                	je     4b4 <printf+0x54>
  write(fd, &c, 1);
 49d:	83 ec 04             	sub    $0x4,%esp
 4a0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4a3:	6a 01                	push   $0x1
 4a5:	57                   	push   %edi
 4a6:	ff 75 08             	pushl  0x8(%ebp)
 4a9:	e8 23 fe ff ff       	call   2d1 <write>
 4ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 4b1:	83 c4 10             	add    $0x10,%esp
 4b4:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4b7:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4bb:	84 db                	test   %bl,%bl
 4bd:	74 71                	je     530 <printf+0xd0>
    c = fmt[i] & 0xff;
 4bf:	0f be cb             	movsbl %bl,%ecx
 4c2:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4c5:	85 d2                	test   %edx,%edx
 4c7:	74 c7                	je     490 <printf+0x30>
      }
    } else if(state == '%'){
 4c9:	83 fa 25             	cmp    $0x25,%edx
 4cc:	75 e6                	jne    4b4 <printf+0x54>
      if(c == 'd'){
 4ce:	83 f8 64             	cmp    $0x64,%eax
 4d1:	0f 84 99 00 00 00    	je     570 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4d7:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4dd:	83 f9 70             	cmp    $0x70,%ecx
 4e0:	74 5e                	je     540 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4e2:	83 f8 73             	cmp    $0x73,%eax
 4e5:	0f 84 d5 00 00 00    	je     5c0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4eb:	83 f8 63             	cmp    $0x63,%eax
 4ee:	0f 84 8c 00 00 00    	je     580 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4f4:	83 f8 25             	cmp    $0x25,%eax
 4f7:	0f 84 b3 00 00 00    	je     5b0 <printf+0x150>
  write(fd, &c, 1);
 4fd:	83 ec 04             	sub    $0x4,%esp
 500:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 504:	6a 01                	push   $0x1
 506:	57                   	push   %edi
 507:	ff 75 08             	pushl  0x8(%ebp)
 50a:	e8 c2 fd ff ff       	call   2d1 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 50f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 512:	83 c4 0c             	add    $0xc,%esp
 515:	6a 01                	push   $0x1
 517:	83 c6 01             	add    $0x1,%esi
 51a:	57                   	push   %edi
 51b:	ff 75 08             	pushl  0x8(%ebp)
 51e:	e8 ae fd ff ff       	call   2d1 <write>
  for(i = 0; fmt[i]; i++){
 523:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 527:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 52a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 52c:	84 db                	test   %bl,%bl
 52e:	75 8f                	jne    4bf <printf+0x5f>
    }
  }
}
 530:	8d 65 f4             	lea    -0xc(%ebp),%esp
 533:	5b                   	pop    %ebx
 534:	5e                   	pop    %esi
 535:	5f                   	pop    %edi
 536:	5d                   	pop    %ebp
 537:	c3                   	ret    
 538:	90                   	nop
 539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 540:	83 ec 0c             	sub    $0xc,%esp
 543:	b9 10 00 00 00       	mov    $0x10,%ecx
 548:	6a 00                	push   $0x0
 54a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 54d:	8b 45 08             	mov    0x8(%ebp),%eax
 550:	8b 13                	mov    (%ebx),%edx
 552:	e8 49 fe ff ff       	call   3a0 <printint>
        ap++;
 557:	89 d8                	mov    %ebx,%eax
 559:	83 c4 10             	add    $0x10,%esp
      state = 0;
 55c:	31 d2                	xor    %edx,%edx
        ap++;
 55e:	83 c0 04             	add    $0x4,%eax
 561:	89 45 d0             	mov    %eax,-0x30(%ebp)
 564:	e9 4b ff ff ff       	jmp    4b4 <printf+0x54>
 569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	b9 0a 00 00 00       	mov    $0xa,%ecx
 578:	6a 01                	push   $0x1
 57a:	eb ce                	jmp    54a <printf+0xea>
 57c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 580:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 583:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 586:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 588:	6a 01                	push   $0x1
        ap++;
 58a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 58d:	57                   	push   %edi
 58e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 591:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 594:	e8 38 fd ff ff       	call   2d1 <write>
        ap++;
 599:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 59c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 59f:	31 d2                	xor    %edx,%edx
 5a1:	e9 0e ff ff ff       	jmp    4b4 <printf+0x54>
 5a6:	8d 76 00             	lea    0x0(%esi),%esi
 5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        putc(fd, c);
 5b0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5b3:	83 ec 04             	sub    $0x4,%esp
 5b6:	e9 5a ff ff ff       	jmp    515 <printf+0xb5>
 5bb:	90                   	nop
 5bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5c3:	8b 18                	mov    (%eax),%ebx
        ap++;
 5c5:	83 c0 04             	add    $0x4,%eax
 5c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5cb:	85 db                	test   %ebx,%ebx
 5cd:	74 17                	je     5e6 <printf+0x186>
        while(*s != 0){
 5cf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 5d2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 5d4:	84 c0                	test   %al,%al
 5d6:	0f 84 d8 fe ff ff    	je     4b4 <printf+0x54>
 5dc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5df:	89 de                	mov    %ebx,%esi
 5e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5e4:	eb 1a                	jmp    600 <printf+0x1a0>
          s = "(null)";
 5e6:	bb dc 07 00 00       	mov    $0x7dc,%ebx
        while(*s != 0){
 5eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5ee:	b8 28 00 00 00       	mov    $0x28,%eax
 5f3:	89 de                	mov    %ebx,%esi
 5f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5f8:	90                   	nop
 5f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 600:	83 ec 04             	sub    $0x4,%esp
          s++;
 603:	83 c6 01             	add    $0x1,%esi
 606:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 609:	6a 01                	push   $0x1
 60b:	57                   	push   %edi
 60c:	53                   	push   %ebx
 60d:	e8 bf fc ff ff       	call   2d1 <write>
        while(*s != 0){
 612:	0f b6 06             	movzbl (%esi),%eax
 615:	83 c4 10             	add    $0x10,%esp
 618:	84 c0                	test   %al,%al
 61a:	75 e4                	jne    600 <printf+0x1a0>
 61c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 61f:	31 d2                	xor    %edx,%edx
 621:	e9 8e fe ff ff       	jmp    4b4 <printf+0x54>
 626:	66 90                	xchg   %ax,%ax
 628:	66 90                	xchg   %ax,%ax
 62a:	66 90                	xchg   %ax,%ax
 62c:	66 90                	xchg   %ax,%ax
 62e:	66 90                	xchg   %ax,%ax

00000630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 630:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	a1 94 0a 00 00       	mov    0xa94,%eax
{
 636:	89 e5                	mov    %esp,%ebp
 638:	57                   	push   %edi
 639:	56                   	push   %esi
 63a:	53                   	push   %ebx
 63b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 63e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 640:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 643:	39 c8                	cmp    %ecx,%eax
 645:	73 19                	jae    660 <free+0x30>
 647:	89 f6                	mov    %esi,%esi
 649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 650:	39 d1                	cmp    %edx,%ecx
 652:	72 14                	jb     668 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 654:	39 d0                	cmp    %edx,%eax
 656:	73 10                	jae    668 <free+0x38>
{
 658:	89 d0                	mov    %edx,%eax
 65a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65c:	39 c8                	cmp    %ecx,%eax
 65e:	72 f0                	jb     650 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 660:	39 d0                	cmp    %edx,%eax
 662:	72 f4                	jb     658 <free+0x28>
 664:	39 d1                	cmp    %edx,%ecx
 666:	73 f0                	jae    658 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 668:	8b 73 fc             	mov    -0x4(%ebx),%esi
 66b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 66e:	39 fa                	cmp    %edi,%edx
 670:	74 1e                	je     690 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 672:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 675:	8b 50 04             	mov    0x4(%eax),%edx
 678:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 67b:	39 f1                	cmp    %esi,%ecx
 67d:	74 28                	je     6a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 67f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 681:	5b                   	pop    %ebx
  freep = p;
 682:	a3 94 0a 00 00       	mov    %eax,0xa94
}
 687:	5e                   	pop    %esi
 688:	5f                   	pop    %edi
 689:	5d                   	pop    %ebp
 68a:	c3                   	ret    
 68b:	90                   	nop
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 690:	03 72 04             	add    0x4(%edx),%esi
 693:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 696:	8b 10                	mov    (%eax),%edx
 698:	8b 12                	mov    (%edx),%edx
 69a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 69d:	8b 50 04             	mov    0x4(%eax),%edx
 6a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6a3:	39 f1                	cmp    %esi,%ecx
 6a5:	75 d8                	jne    67f <free+0x4f>
    p->s.size += bp->s.size;
 6a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6aa:	a3 94 0a 00 00       	mov    %eax,0xa94
    p->s.size += bp->s.size;
 6af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6b5:	89 10                	mov    %edx,(%eax)
}
 6b7:	5b                   	pop    %ebx
 6b8:	5e                   	pop    %esi
 6b9:	5f                   	pop    %edi
 6ba:	5d                   	pop    %ebp
 6bb:	c3                   	ret    
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6cc:	8b 3d 94 0a 00 00    	mov    0xa94,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d2:	8d 70 07             	lea    0x7(%eax),%esi
 6d5:	c1 ee 03             	shr    $0x3,%esi
 6d8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6db:	85 ff                	test   %edi,%edi
 6dd:	0f 84 ad 00 00 00    	je     790 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 6e5:	8b 4a 04             	mov    0x4(%edx),%ecx
 6e8:	39 ce                	cmp    %ecx,%esi
 6ea:	76 72                	jbe    75e <malloc+0x9e>
 6ec:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6f2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6f7:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6fa:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 701:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 704:	eb 1b                	jmp    721 <malloc+0x61>
 706:	8d 76 00             	lea    0x0(%esi),%esi
 709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 710:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 712:	8b 48 04             	mov    0x4(%eax),%ecx
 715:	39 f1                	cmp    %esi,%ecx
 717:	73 4f                	jae    768 <malloc+0xa8>
 719:	8b 3d 94 0a 00 00    	mov    0xa94,%edi
 71f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 721:	39 d7                	cmp    %edx,%edi
 723:	75 eb                	jne    710 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 725:	83 ec 0c             	sub    $0xc,%esp
 728:	ff 75 e4             	pushl  -0x1c(%ebp)
 72b:	e8 09 fc ff ff       	call   339 <sbrk>
  if(p == (char*)-1)
 730:	83 c4 10             	add    $0x10,%esp
 733:	83 f8 ff             	cmp    $0xffffffff,%eax
 736:	74 1c                	je     754 <malloc+0x94>
  hp->s.size = nu;
 738:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 73b:	83 ec 0c             	sub    $0xc,%esp
 73e:	83 c0 08             	add    $0x8,%eax
 741:	50                   	push   %eax
 742:	e8 e9 fe ff ff       	call   630 <free>
  return freep;
 747:	8b 15 94 0a 00 00    	mov    0xa94,%edx
      if((p = morecore(nunits)) == 0)
 74d:	83 c4 10             	add    $0x10,%esp
 750:	85 d2                	test   %edx,%edx
 752:	75 bc                	jne    710 <malloc+0x50>
        return 0;
  }
}
 754:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 757:	31 c0                	xor    %eax,%eax
}
 759:	5b                   	pop    %ebx
 75a:	5e                   	pop    %esi
 75b:	5f                   	pop    %edi
 75c:	5d                   	pop    %ebp
 75d:	c3                   	ret    
    if(p->s.size >= nunits){
 75e:	89 d0                	mov    %edx,%eax
 760:	89 fa                	mov    %edi,%edx
 762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 768:	39 ce                	cmp    %ecx,%esi
 76a:	74 54                	je     7c0 <malloc+0x100>
        p->s.size -= nunits;
 76c:	29 f1                	sub    %esi,%ecx
 76e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 771:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 774:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 777:	89 15 94 0a 00 00    	mov    %edx,0xa94
}
 77d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 780:	83 c0 08             	add    $0x8,%eax
}
 783:	5b                   	pop    %ebx
 784:	5e                   	pop    %esi
 785:	5f                   	pop    %edi
 786:	5d                   	pop    %ebp
 787:	c3                   	ret    
 788:	90                   	nop
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 790:	c7 05 94 0a 00 00 98 	movl   $0xa98,0xa94
 797:	0a 00 00 
    base.s.size = 0;
 79a:	bf 98 0a 00 00       	mov    $0xa98,%edi
    base.s.ptr = freep = prevp = &base;
 79f:	c7 05 98 0a 00 00 98 	movl   $0xa98,0xa98
 7a6:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 7ab:	c7 05 9c 0a 00 00 00 	movl   $0x0,0xa9c
 7b2:	00 00 00 
    if(p->s.size >= nunits){
 7b5:	e9 32 ff ff ff       	jmp    6ec <malloc+0x2c>
 7ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 7c0:	8b 08                	mov    (%eax),%ecx
 7c2:	89 0a                	mov    %ecx,(%edx)
 7c4:	eb b1                	jmp    777 <malloc+0xb7>
