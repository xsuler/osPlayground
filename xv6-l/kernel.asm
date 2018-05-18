
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 2f 10 80       	mov    $0x80102f20,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 73 10 80       	push   $0x80107380
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 85 44 00 00       	call   801044e0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 73 10 80       	push   $0x80107387
80100097:	50                   	push   %eax
80100098:	e8 33 43 00 00       	call   801043d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 e7 44 00 00       	call   801045d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 89 45 00 00       	call   801046f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 42 00 00       	call   80104410 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 1d 20 00 00       	call   801021a0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 8e 73 10 80       	push   $0x8010738e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 fd 42 00 00       	call   801044b0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 d7 1f 00 00       	jmp    801021a0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 73 10 80       	push   $0x8010739f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 bc 42 00 00       	call   801044b0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 6c 42 00 00       	call   80104470 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 c0 43 00 00       	call   801045d0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 8f 44 00 00       	jmp    801046f0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 73 10 80       	push   $0x801073a6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 5b 15 00 00       	call   801017e0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 3f 43 00 00       	call   801045d0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 b6 3d 00 00       	call   80104080 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 90 35 00 00       	call   80103870 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 fc 43 00 00       	call   801046f0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 04 14 00 00       	call   80101700 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 9e 43 00 00       	call   801046f0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 a6 13 00 00       	call   80101700 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 02 24 00 00       	call   801027b0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 73 10 80       	push   $0x801073ad
801003b7:	e8 b4 02 00 00       	call   80100670 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 ab 02 00 00       	call   80100670 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 03 7d 10 80 	movl   $0x80107d03,(%esp)
801003cc:	e8 9f 02 00 00       	call   80100670 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 23 41 00 00       	call   80104500 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 73 10 80       	push   $0x801073c1
801003ed:	e8 7e 02 00 00       	call   80100670 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 bf 00 00 00    	je     801004f5 <consputc+0xe5>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 31 5a 00 00       	call   80105e70 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 fa                	mov    %edi,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
80100457:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 fa                	mov    %edi,%edx
8010045c:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT+1) << 8;
80100461:	c1 e3 08             	shl    $0x8,%ebx
80100464:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100465:	89 ca                	mov    %ecx,%edx
80100467:	ec                   	in     (%dx),%al
80100468:	0f b6 c8             	movzbl %al,%ecx
  pos |= inb(CRTPORT+1);
8010046b:	09 d9                	or     %ebx,%ecx
  if(c == '\n')
8010046d:	83 fe 0a             	cmp    $0xa,%esi
80100470:	0f 84 ff 00 00 00    	je     80100575 <consputc+0x165>
  else if(c == BACKSPACE){
80100476:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047c:	0f 84 e7 00 00 00    	je     80100569 <consputc+0x159>
      crt[pos++] = (c&0xff) | 0x0b00;  // black on white
80100482:	89 f0                	mov    %esi,%eax
    if(c>='0'&&c<='9'){
80100484:	8d 7e d0             	lea    -0x30(%esi),%edi
80100487:	8d 59 01             	lea    0x1(%ecx),%ebx
      crt[pos++] = (c&0xff) | 0x0b00;  // black on white
8010048a:	0f b6 c0             	movzbl %al,%eax
8010048d:	80 cc 05             	or     $0x5,%ah
80100490:	89 c2                	mov    %eax,%edx
80100492:	89 f0                	mov    %esi,%eax
80100494:	80 cc 0b             	or     $0xb,%ah
80100497:	83 ff 0a             	cmp    $0xa,%edi
8010049a:	0f 43 c2             	cmovae %edx,%eax
8010049d:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
801004a4:	80 
  if(pos < 0 || pos > 25*80)
801004a5:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004ab:	0f 8f ab 00 00 00    	jg     8010055c <consputc+0x14c>
  if((pos/80) >= 24){  // Scroll up.
801004b1:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004b7:	7f 66                	jg     8010051f <consputc+0x10f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004b9:	be d4 03 00 00       	mov    $0x3d4,%esi
801004be:	b8 0e 00 00 00       	mov    $0xe,%eax
801004c3:	89 f2                	mov    %esi,%edx
801004c5:	ee                   	out    %al,(%dx)
801004c6:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004cb:	89 d8                	mov    %ebx,%eax
801004cd:	c1 f8 08             	sar    $0x8,%eax
801004d0:	89 ca                	mov    %ecx,%edx
801004d2:	ee                   	out    %al,(%dx)
801004d3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004d8:	89 f2                	mov    %esi,%edx
801004da:	ee                   	out    %al,(%dx)
801004db:	89 d8                	mov    %ebx,%eax
801004dd:	89 ca                	mov    %ecx,%edx
801004df:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004e0:	b8 20 07 00 00       	mov    $0x720,%eax
801004e5:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004ec:	80 
}
801004ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004f0:	5b                   	pop    %ebx
801004f1:	5e                   	pop    %esi
801004f2:	5f                   	pop    %edi
801004f3:	5d                   	pop    %ebp
801004f4:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004f5:	83 ec 0c             	sub    $0xc,%esp
801004f8:	6a 08                	push   $0x8
801004fa:	e8 71 59 00 00       	call   80105e70 <uartputc>
801004ff:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100506:	e8 65 59 00 00       	call   80105e70 <uartputc>
8010050b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100512:	e8 59 59 00 00       	call   80105e70 <uartputc>
80100517:	83 c4 10             	add    $0x10,%esp
8010051a:	e9 23 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051f:	52                   	push   %edx
80100520:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100525:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100528:	68 a0 80 0b 80       	push   $0x800b80a0
8010052d:	68 00 80 0b 80       	push   $0x800b8000
80100532:	e8 c9 42 00 00       	call   80104800 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100537:	b8 80 07 00 00       	mov    $0x780,%eax
8010053c:	83 c4 0c             	add    $0xc,%esp
8010053f:	29 d8                	sub    %ebx,%eax
80100541:	01 c0                	add    %eax,%eax
80100543:	50                   	push   %eax
80100544:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100547:	6a 00                	push   $0x0
80100549:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
8010054e:	50                   	push   %eax
8010054f:	e8 fc 41 00 00       	call   80104750 <memset>
80100554:	83 c4 10             	add    $0x10,%esp
80100557:	e9 5d ff ff ff       	jmp    801004b9 <consputc+0xa9>
    panic("pos under/overflow");
8010055c:	83 ec 0c             	sub    $0xc,%esp
8010055f:	68 c5 73 10 80       	push   $0x801073c5
80100564:	e8 27 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
80100569:	85 c9                	test   %ecx,%ecx
8010056b:	74 1b                	je     80100588 <consputc+0x178>
8010056d:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100570:	e9 30 ff ff ff       	jmp    801004a5 <consputc+0x95>
    pos += 80 - pos%80;
80100575:	89 c8                	mov    %ecx,%eax
80100577:	bb 50 00 00 00       	mov    $0x50,%ebx
8010057c:	99                   	cltd   
8010057d:	f7 fb                	idiv   %ebx
8010057f:	29 d3                	sub    %edx,%ebx
80100581:	01 cb                	add    %ecx,%ebx
80100583:	e9 1d ff ff ff       	jmp    801004a5 <consputc+0x95>
    if(pos > 0) --pos;
80100588:	31 db                	xor    %ebx,%ebx
8010058a:	e9 2a ff ff ff       	jmp    801004b9 <consputc+0xa9>
8010058f:	90                   	nop

80100590 <printint>:
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	89 d3                	mov    %edx,%ebx
80100598:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010059b:	85 c9                	test   %ecx,%ecx
{
8010059d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005a0:	74 04                	je     801005a6 <printint+0x16>
801005a2:	85 c0                	test   %eax,%eax
801005a4:	78 5a                	js     80100600 <printint+0x70>
    x = xx;
801005a6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
801005ad:	31 c9                	xor    %ecx,%ecx
801005af:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005b2:	eb 06                	jmp    801005ba <printint+0x2a>
801005b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005b8:	89 f9                	mov    %edi,%ecx
801005ba:	31 d2                	xor    %edx,%edx
801005bc:	8d 79 01             	lea    0x1(%ecx),%edi
801005bf:	f7 f3                	div    %ebx
801005c1:	0f b6 92 f0 73 10 80 	movzbl -0x7fef8c10(%edx),%edx
  }while((x /= base) != 0);
801005c8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ca:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005cd:	75 e9                	jne    801005b8 <printint+0x28>
  if(sign)
801005cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005d2:	85 c0                	test   %eax,%eax
801005d4:	74 08                	je     801005de <printint+0x4e>
    buf[i++] = '-';
801005d6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005db:	8d 79 02             	lea    0x2(%ecx),%edi
801005de:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005e8:	0f be 03             	movsbl (%ebx),%eax
801005eb:	83 eb 01             	sub    $0x1,%ebx
801005ee:	e8 1d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005f3:	39 f3                	cmp    %esi,%ebx
801005f5:	75 f1                	jne    801005e8 <printint+0x58>
}
801005f7:	83 c4 2c             	add    $0x2c,%esp
801005fa:	5b                   	pop    %ebx
801005fb:	5e                   	pop    %esi
801005fc:	5f                   	pop    %edi
801005fd:	5d                   	pop    %ebp
801005fe:	c3                   	ret    
801005ff:	90                   	nop
    x = -xx;
80100600:	f7 d8                	neg    %eax
80100602:	eb a9                	jmp    801005ad <printint+0x1d>
80100604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010060a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100610 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100610:	55                   	push   %ebp
80100611:	89 e5                	mov    %esp,%ebp
80100613:	57                   	push   %edi
80100614:	56                   	push   %esi
80100615:	53                   	push   %ebx
80100616:	83 ec 18             	sub    $0x18,%esp
80100619:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010061c:	ff 75 08             	pushl  0x8(%ebp)
8010061f:	e8 bc 11 00 00       	call   801017e0 <iunlock>
  acquire(&cons.lock);
80100624:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010062b:	e8 a0 3f 00 00       	call   801045d0 <acquire>
  for(i = 0; i < n; i++)
80100630:	83 c4 10             	add    $0x10,%esp
80100633:	85 f6                	test   %esi,%esi
80100635:	7e 18                	jle    8010064f <consolewrite+0x3f>
80100637:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010063a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010063d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100640:	0f b6 07             	movzbl (%edi),%eax
80100643:	83 c7 01             	add    $0x1,%edi
80100646:	e8 c5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010064b:	39 fb                	cmp    %edi,%ebx
8010064d:	75 f1                	jne    80100640 <consolewrite+0x30>
  release(&cons.lock);
8010064f:	83 ec 0c             	sub    $0xc,%esp
80100652:	68 20 a5 10 80       	push   $0x8010a520
80100657:	e8 94 40 00 00       	call   801046f0 <release>
  ilock(ip);
8010065c:	58                   	pop    %eax
8010065d:	ff 75 08             	pushl  0x8(%ebp)
80100660:	e8 9b 10 00 00       	call   80101700 <ilock>

  return n;
}
80100665:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100668:	89 f0                	mov    %esi,%eax
8010066a:	5b                   	pop    %ebx
8010066b:	5e                   	pop    %esi
8010066c:	5f                   	pop    %edi
8010066d:	5d                   	pop    %ebp
8010066e:	c3                   	ret    
8010066f:	90                   	nop

80100670 <cprintf>:
{
80100670:	55                   	push   %ebp
80100671:	89 e5                	mov    %esp,%ebp
80100673:	57                   	push   %edi
80100674:	56                   	push   %esi
80100675:	53                   	push   %ebx
80100676:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100679:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010067e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100680:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100683:	0f 85 6f 01 00 00    	jne    801007f8 <cprintf+0x188>
  if (fmt == 0)
80100689:	8b 45 08             	mov    0x8(%ebp),%eax
8010068c:	85 c0                	test   %eax,%eax
8010068e:	89 c7                	mov    %eax,%edi
80100690:	0f 84 77 01 00 00    	je     8010080d <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100696:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100699:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010069c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010069e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006a1:	85 c0                	test   %eax,%eax
801006a3:	75 56                	jne    801006fb <cprintf+0x8b>
801006a5:	eb 79                	jmp    80100720 <cprintf+0xb0>
801006a7:	89 f6                	mov    %esi,%esi
801006a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006b0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006b3:	85 d2                	test   %edx,%edx
801006b5:	74 69                	je     80100720 <cprintf+0xb0>
801006b7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006ba:	83 fa 70             	cmp    $0x70,%edx
801006bd:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006c0:	0f 84 84 00 00 00    	je     8010074a <cprintf+0xda>
801006c6:	7f 78                	jg     80100740 <cprintf+0xd0>
801006c8:	83 fa 25             	cmp    $0x25,%edx
801006cb:	0f 84 ff 00 00 00    	je     801007d0 <cprintf+0x160>
801006d1:	83 fa 64             	cmp    $0x64,%edx
801006d4:	0f 85 8e 00 00 00    	jne    80100768 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006dd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006e2:	8d 48 04             	lea    0x4(%eax),%ecx
801006e5:	8b 00                	mov    (%eax),%eax
801006e7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006ea:	b9 01 00 00 00       	mov    $0x1,%ecx
801006ef:	e8 9c fe ff ff       	call   80100590 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f4:	0f b6 06             	movzbl (%esi),%eax
801006f7:	85 c0                	test   %eax,%eax
801006f9:	74 25                	je     80100720 <cprintf+0xb0>
801006fb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006fe:	83 f8 25             	cmp    $0x25,%eax
80100701:	8d 34 17             	lea    (%edi,%edx,1),%esi
80100704:	74 aa                	je     801006b0 <cprintf+0x40>
80100706:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
80100709:	e8 02 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070e:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100711:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100714:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100716:	85 c0                	test   %eax,%eax
80100718:	75 e1                	jne    801006fb <cprintf+0x8b>
8010071a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100720:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100723:	85 c0                	test   %eax,%eax
80100725:	74 10                	je     80100737 <cprintf+0xc7>
    release(&cons.lock);
80100727:	83 ec 0c             	sub    $0xc,%esp
8010072a:	68 20 a5 10 80       	push   $0x8010a520
8010072f:	e8 bc 3f 00 00       	call   801046f0 <release>
80100734:	83 c4 10             	add    $0x10,%esp
}
80100737:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073a:	5b                   	pop    %ebx
8010073b:	5e                   	pop    %esi
8010073c:	5f                   	pop    %edi
8010073d:	5d                   	pop    %ebp
8010073e:	c3                   	ret    
8010073f:	90                   	nop
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	74 43                	je     80100788 <cprintf+0x118>
80100745:	83 fa 78             	cmp    $0x78,%edx
80100748:	75 1e                	jne    80100768 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010074a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010074d:	ba 10 00 00 00       	mov    $0x10,%edx
80100752:	8d 48 04             	lea    0x4(%eax),%ecx
80100755:	8b 00                	mov    (%eax),%eax
80100757:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010075a:	31 c9                	xor    %ecx,%ecx
8010075c:	e8 2f fe ff ff       	call   80100590 <printint>
      break;
80100761:	eb 91                	jmp    801006f4 <cprintf+0x84>
80100763:	90                   	nop
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100770:	e8 9b fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100775:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100778:	89 d0                	mov    %edx,%eax
8010077a:	e8 91 fc ff ff       	call   80100410 <consputc>
      break;
8010077f:	e9 70 ff ff ff       	jmp    801006f4 <cprintf+0x84>
80100784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010078b:	8b 10                	mov    (%eax),%edx
8010078d:	8d 48 04             	lea    0x4(%eax),%ecx
80100790:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100793:	85 d2                	test   %edx,%edx
80100795:	74 49                	je     801007e0 <cprintf+0x170>
      for(; *s; s++)
80100797:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010079a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010079d:	84 c0                	test   %al,%al
8010079f:	0f 84 4f ff ff ff    	je     801006f4 <cprintf+0x84>
801007a5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007a8:	89 d3                	mov    %edx,%ebx
801007aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007b0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007b3:	e8 58 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007b8:	0f be 03             	movsbl (%ebx),%eax
801007bb:	84 c0                	test   %al,%al
801007bd:	75 f1                	jne    801007b0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007c2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007c8:	e9 27 ff ff ff       	jmp    801006f4 <cprintf+0x84>
801007cd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007d0:	b8 25 00 00 00       	mov    $0x25,%eax
801007d5:	e8 36 fc ff ff       	call   80100410 <consputc>
      break;
801007da:	e9 15 ff ff ff       	jmp    801006f4 <cprintf+0x84>
801007df:	90                   	nop
        s = "(null)";
801007e0:	ba d8 73 10 80       	mov    $0x801073d8,%edx
      for(; *s; s++)
801007e5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007e8:	b8 28 00 00 00       	mov    $0x28,%eax
801007ed:	89 d3                	mov    %edx,%ebx
801007ef:	eb bf                	jmp    801007b0 <cprintf+0x140>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007f8:	83 ec 0c             	sub    $0xc,%esp
801007fb:	68 20 a5 10 80       	push   $0x8010a520
80100800:	e8 cb 3d 00 00       	call   801045d0 <acquire>
80100805:	83 c4 10             	add    $0x10,%esp
80100808:	e9 7c fe ff ff       	jmp    80100689 <cprintf+0x19>
    panic("null fmt");
8010080d:	83 ec 0c             	sub    $0xc,%esp
80100810:	68 df 73 10 80       	push   $0x801073df
80100815:	e8 76 fb ff ff       	call   80100390 <panic>
8010081a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100820 <consoleintr>:
{
80100820:	55                   	push   %ebp
80100821:	89 e5                	mov    %esp,%ebp
80100823:	57                   	push   %edi
80100824:	56                   	push   %esi
80100825:	53                   	push   %ebx
  int c, doprocdump = 0;
80100826:	31 f6                	xor    %esi,%esi
{
80100828:	83 ec 18             	sub    $0x18,%esp
8010082b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010082e:	68 20 a5 10 80       	push   $0x8010a520
80100833:	e8 98 3d 00 00       	call   801045d0 <acquire>
  while((c = getc()) >= 0){
80100838:	83 c4 10             	add    $0x10,%esp
8010083b:	90                   	nop
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100840:	ff d3                	call   *%ebx
80100842:	85 c0                	test   %eax,%eax
80100844:	89 c7                	mov    %eax,%edi
80100846:	78 48                	js     80100890 <consoleintr+0x70>
    switch(c){
80100848:	83 ff 10             	cmp    $0x10,%edi
8010084b:	0f 84 e7 00 00 00    	je     80100938 <consoleintr+0x118>
80100851:	7e 5d                	jle    801008b0 <consoleintr+0x90>
80100853:	83 ff 15             	cmp    $0x15,%edi
80100856:	0f 84 ec 00 00 00    	je     80100948 <consoleintr+0x128>
8010085c:	83 ff 7f             	cmp    $0x7f,%edi
8010085f:	75 54                	jne    801008b5 <consoleintr+0x95>
      if(input.e != input.w){
80100861:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100866:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010086c:	74 d2                	je     80100840 <consoleintr+0x20>
        input.e--;
8010086e:	83 e8 01             	sub    $0x1,%eax
80100871:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100876:	b8 00 01 00 00       	mov    $0x100,%eax
8010087b:	e8 90 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100880:	ff d3                	call   *%ebx
80100882:	85 c0                	test   %eax,%eax
80100884:	89 c7                	mov    %eax,%edi
80100886:	79 c0                	jns    80100848 <consoleintr+0x28>
80100888:	90                   	nop
80100889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100890:	83 ec 0c             	sub    $0xc,%esp
80100893:	68 20 a5 10 80       	push   $0x8010a520
80100898:	e8 53 3e 00 00       	call   801046f0 <release>
  if(doprocdump) {
8010089d:	83 c4 10             	add    $0x10,%esp
801008a0:	85 f6                	test   %esi,%esi
801008a2:	0f 85 f8 00 00 00    	jne    801009a0 <consoleintr+0x180>
}
801008a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008ab:	5b                   	pop    %ebx
801008ac:	5e                   	pop    %esi
801008ad:	5f                   	pop    %edi
801008ae:	5d                   	pop    %ebp
801008af:	c3                   	ret    
    switch(c){
801008b0:	83 ff 08             	cmp    $0x8,%edi
801008b3:	74 ac                	je     80100861 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b5:	85 ff                	test   %edi,%edi
801008b7:	74 87                	je     80100840 <consoleintr+0x20>
801008b9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008be:	89 c2                	mov    %eax,%edx
801008c0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c6:	83 fa 7f             	cmp    $0x7f,%edx
801008c9:	0f 87 71 ff ff ff    	ja     80100840 <consoleintr+0x20>
801008cf:	8d 50 01             	lea    0x1(%eax),%edx
801008d2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008d5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008d8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008de:	0f 84 cc 00 00 00    	je     801009b0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e4:	89 f9                	mov    %edi,%ecx
801008e6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008ec:	89 f8                	mov    %edi,%eax
801008ee:	e8 1d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f3:	83 ff 0a             	cmp    $0xa,%edi
801008f6:	0f 84 c5 00 00 00    	je     801009c1 <consoleintr+0x1a1>
801008fc:	83 ff 04             	cmp    $0x4,%edi
801008ff:	0f 84 bc 00 00 00    	je     801009c1 <consoleintr+0x1a1>
80100905:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090a:	83 e8 80             	sub    $0xffffff80,%eax
8010090d:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100913:	0f 85 27 ff ff ff    	jne    80100840 <consoleintr+0x20>
          wakeup(&input.r);
80100919:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010091c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100921:	68 a0 ff 10 80       	push   $0x8010ffa0
80100926:	e8 25 39 00 00       	call   80104250 <wakeup>
8010092b:	83 c4 10             	add    $0x10,%esp
8010092e:	e9 0d ff ff ff       	jmp    80100840 <consoleintr+0x20>
80100933:	90                   	nop
80100934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100938:	be 01 00 00 00       	mov    $0x1,%esi
8010093d:	e9 fe fe ff ff       	jmp    80100840 <consoleintr+0x20>
80100942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100948:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010094d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100953:	75 2b                	jne    80100980 <consoleintr+0x160>
80100955:	e9 e6 fe ff ff       	jmp    80100840 <consoleintr+0x20>
8010095a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100960:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100965:	b8 00 01 00 00       	mov    $0x100,%eax
8010096a:	e8 a1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010096f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100974:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010097a:	0f 84 c0 fe ff ff    	je     80100840 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100980:	83 e8 01             	sub    $0x1,%eax
80100983:	89 c2                	mov    %eax,%edx
80100985:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100988:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010098f:	75 cf                	jne    80100960 <consoleintr+0x140>
80100991:	e9 aa fe ff ff       	jmp    80100840 <consoleintr+0x20>
80100996:	8d 76 00             	lea    0x0(%esi),%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
801009a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009a3:	5b                   	pop    %ebx
801009a4:	5e                   	pop    %esi
801009a5:	5f                   	pop    %edi
801009a6:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009a7:	e9 54 39 00 00       	jmp    80104300 <procdump>
801009ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009b0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009b7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009bc:	e8 4f fa ff ff       	call   80100410 <consputc>
801009c1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009c6:	e9 4e ff ff ff       	jmp    80100919 <consoleintr+0xf9>
801009cb:	90                   	nop
801009cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009d0 <consoleinit>:

void
consoleinit(void)
{
801009d0:	55                   	push   %ebp
801009d1:	89 e5                	mov    %esp,%ebp
801009d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009d6:	68 e8 73 10 80       	push   $0x801073e8
801009db:	68 20 a5 10 80       	push   $0x8010a520
801009e0:	e8 fb 3a 00 00       	call   801044e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009e5:	58                   	pop    %eax
801009e6:	5a                   	pop    %edx
801009e7:	6a 00                	push   $0x0
801009e9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009eb:	c7 05 6c 09 11 80 10 	movl   $0x80100610,0x8011096c
801009f2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009f5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009fc:	02 10 80 
  cons.locking = 1;
801009ff:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a06:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a09:	e8 42 19 00 00       	call   80102350 <ioapicenable>
}
80100a0e:	83 c4 10             	add    $0x10,%esp
80100a11:	c9                   	leave  
80100a12:	c3                   	ret    
80100a13:	66 90                	xchg   %ax,%ax
80100a15:	66 90                	xchg   %ax,%ax
80100a17:	66 90                	xchg   %ax,%ax
80100a19:	66 90                	xchg   %ax,%ax
80100a1b:	66 90                	xchg   %ax,%ax
80100a1d:	66 90                	xchg   %ax,%ax
80100a1f:	90                   	nop

80100a20 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a20:	55                   	push   %ebp
80100a21:	89 e5                	mov    %esp,%ebp
80100a23:	57                   	push   %edi
80100a24:	56                   	push   %esi
80100a25:	53                   	push   %ebx
80100a26:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a2c:	e8 3f 2e 00 00       	call   80103870 <myproc>
80100a31:	89 c7                	mov    %eax,%edi

  begin_op();
80100a33:	e8 e8 21 00 00       	call   80102c20 <begin_op>

  if((ip = namei(path)) == 0){
80100a38:	83 ec 0c             	sub    $0xc,%esp
80100a3b:	ff 75 08             	pushl  0x8(%ebp)
80100a3e:	e8 1d 15 00 00       	call   80101f60 <namei>
80100a43:	83 c4 10             	add    $0x10,%esp
80100a46:	85 c0                	test   %eax,%eax
80100a48:	0f 84 d7 01 00 00    	je     80100c25 <exec+0x205>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a4e:	83 ec 0c             	sub    $0xc,%esp
80100a51:	89 c3                	mov    %eax,%ebx
80100a53:	50                   	push   %eax
80100a54:	e8 a7 0c 00 00       	call   80101700 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a59:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a5f:	6a 34                	push   $0x34
80100a61:	6a 00                	push   $0x0
80100a63:	50                   	push   %eax
80100a64:	53                   	push   %ebx
80100a65:	e8 76 0f 00 00       	call   801019e0 <readi>
80100a6a:	83 c4 20             	add    $0x20,%esp
80100a6d:	83 f8 34             	cmp    $0x34,%eax
80100a70:	74 1e                	je     80100a90 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir,curproc->nshared);
  if(ip){
    iunlockput(ip);
80100a72:	83 ec 0c             	sub    $0xc,%esp
80100a75:	53                   	push   %ebx
80100a76:	e8 15 0f 00 00       	call   80101990 <iunlockput>
    end_op();
80100a7b:	e8 10 22 00 00       	call   80102c90 <end_op>
80100a80:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a8b:	5b                   	pop    %ebx
80100a8c:	5e                   	pop    %esi
80100a8d:	5f                   	pop    %edi
80100a8e:	5d                   	pop    %ebp
80100a8f:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100a90:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a97:	45 4c 46 
80100a9a:	75 d6                	jne    80100a72 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
80100a9c:	e8 3f 66 00 00       	call   801070e0 <setupkvm>
80100aa1:	85 c0                	test   %eax,%eax
80100aa3:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100aa9:	74 c7                	je     80100a72 <exec+0x52>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aab:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab1:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  sz = 0;
80100ab7:	31 c0                	xor    %eax,%eax
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ab9:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ac0:	00 
80100ac1:	0f 84 df 02 00 00    	je     80100da6 <exec+0x386>
80100ac7:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100acd:	31 f6                	xor    %esi,%esi
80100acf:	89 c7                	mov    %eax,%edi
80100ad1:	e9 92 00 00 00       	jmp    80100b68 <exec+0x148>
80100ad6:	8d 76 00             	lea    0x0(%esi),%esi
80100ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ph.type != ELF_PROG_LOAD)
80100ae0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ae7:	75 71                	jne    80100b5a <exec+0x13a>
    if(ph.memsz < ph.filesz)
80100ae9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aef:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100af5:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100afb:	8b 92 88 00 00 00    	mov    0x88(%edx),%edx
80100b01:	0f 82 94 00 00 00    	jb     80100b9b <exec+0x17b>
80100b07:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b0d:	0f 82 88 00 00 00    	jb     80100b9b <exec+0x17b>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz,curproc->nshared)) == 0)
80100b13:	52                   	push   %edx
80100b14:	50                   	push   %eax
80100b15:	57                   	push   %edi
80100b16:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b1c:	e8 af 63 00 00       	call   80106ed0 <allocuvm>
80100b21:	83 c4 10             	add    $0x10,%esp
80100b24:	85 c0                	test   %eax,%eax
80100b26:	89 c7                	mov    %eax,%edi
80100b28:	74 65                	je     80100b8f <exec+0x16f>
    if(ph.vaddr % PGSIZE != 0)
80100b2a:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b30:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b35:	75 58                	jne    80100b8f <exec+0x16f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b37:	83 ec 0c             	sub    $0xc,%esp
80100b3a:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b40:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b46:	53                   	push   %ebx
80100b47:	50                   	push   %eax
80100b48:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b4e:	e8 cd 61 00 00       	call   80106d20 <loaduvm>
80100b53:	83 c4 20             	add    $0x20,%esp
80100b56:	85 c0                	test   %eax,%eax
80100b58:	78 35                	js     80100b8f <exec+0x16f>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b5a:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b61:	83 c6 01             	add    $0x1,%esi
80100b64:	39 f0                	cmp    %esi,%eax
80100b66:	7e 4a                	jle    80100bb2 <exec+0x192>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b68:	89 f0                	mov    %esi,%eax
80100b6a:	6a 20                	push   $0x20
80100b6c:	c1 e0 05             	shl    $0x5,%eax
80100b6f:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100b75:	50                   	push   %eax
80100b76:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b7c:	50                   	push   %eax
80100b7d:	53                   	push   %ebx
80100b7e:	e8 5d 0e 00 00       	call   801019e0 <readi>
80100b83:	83 c4 10             	add    $0x10,%esp
80100b86:	83 f8 20             	cmp    $0x20,%eax
80100b89:	0f 84 51 ff ff ff    	je     80100ae0 <exec+0xc0>
80100b8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100b95:	8b 97 88 00 00 00    	mov    0x88(%edi),%edx
    freevm(pgdir,curproc->nshared);
80100b9b:	83 ec 08             	sub    $0x8,%esp
80100b9e:	52                   	push   %edx
80100b9f:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba5:	e8 a6 64 00 00       	call   80107050 <freevm>
80100baa:	83 c4 10             	add    $0x10,%esp
80100bad:	e9 c0 fe ff ff       	jmp    80100a72 <exec+0x52>
80100bb2:	89 f8                	mov    %edi,%eax
80100bb4:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100bba:	05 ff 0f 00 00       	add    $0xfff,%eax
80100bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100bc4:	8d b0 00 20 00 00    	lea    0x2000(%eax),%esi
  iunlockput(ip);
80100bca:	83 ec 0c             	sub    $0xc,%esp
80100bcd:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bd3:	53                   	push   %ebx
80100bd4:	e8 b7 0d 00 00       	call   80101990 <iunlockput>
  end_op();
80100bd9:	e8 b2 20 00 00       	call   80102c90 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE,curproc->nshared)) == 0)
80100bde:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100be4:	ff b7 88 00 00 00    	pushl  0x88(%edi)
80100bea:	56                   	push   %esi
80100beb:	50                   	push   %eax
80100bec:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bf2:	e8 d9 62 00 00       	call   80106ed0 <allocuvm>
80100bf7:	83 c4 20             	add    $0x20,%esp
80100bfa:	85 c0                	test   %eax,%eax
80100bfc:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c02:	75 40                	jne    80100c44 <exec+0x224>
    freevm(pgdir,curproc->nshared);
80100c04:	83 ec 08             	sub    $0x8,%esp
80100c07:	ff b7 88 00 00 00    	pushl  0x88(%edi)
80100c0d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c13:	e8 38 64 00 00       	call   80107050 <freevm>
80100c18:	83 c4 10             	add    $0x10,%esp
  return -1;
80100c1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c20:	e9 63 fe ff ff       	jmp    80100a88 <exec+0x68>
    end_op();
80100c25:	e8 66 20 00 00       	call   80102c90 <end_op>
    cprintf("exec: fail\n");
80100c2a:	83 ec 0c             	sub    $0xc,%esp
80100c2d:	68 01 74 10 80       	push   $0x80107401
80100c32:	e8 39 fa ff ff       	call   80100670 <cprintf>
    return -1;
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c3f:	e9 44 fe ff ff       	jmp    80100a88 <exec+0x68>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	89 c3                	mov    %eax,%ebx
80100c46:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c4c:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100c4f:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c51:	50                   	push   %eax
80100c52:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c58:	e8 23 65 00 00       	call   80107180 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c60:	83 c4 10             	add    $0x10,%esp
80100c63:	8b 00                	mov    (%eax),%eax
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 84 43 01 00 00    	je     80100db0 <exec+0x390>
80100c6d:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100c73:	89 f7                	mov    %esi,%edi
80100c75:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7b:	eb 22                	jmp    80100c9f <exec+0x27f>
80100c7d:	8d 76 00             	lea    0x0(%esi),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 44                	je     80100cde <exec+0x2be>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 34                	je     80100cd3 <exec+0x2b3>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 c8 3c 00 00       	call   80104970 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 b5 3c 00 00       	call   80104970 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 04 66 00 00       	call   801072d0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x260>
80100cd3:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100cd9:	e9 26 ff ff ff       	jmp    80100c04 <exec+0x1e4>
80100cde:	89 fe                	mov    %edi,%esi
80100ce0:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ce6:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100ced:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100cef:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100cf6:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100cfa:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d01:	ff ff ff 
  ustack[1] = argc;
80100d04:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0a:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0c:	83 c0 0c             	add    $0xc,%eax
80100d0f:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d11:	50                   	push   %eax
80100d12:	52                   	push   %edx
80100d13:	53                   	push   %ebx
80100d14:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d1a:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d20:	e8 ab 65 00 00       	call   801072d0 <copyout>
80100d25:	83 c4 10             	add    $0x10,%esp
80100d28:	85 c0                	test   %eax,%eax
80100d2a:	0f 88 d4 fe ff ff    	js     80100c04 <exec+0x1e4>
  for(last=s=path; *s; s++)
80100d30:	8b 45 08             	mov    0x8(%ebp),%eax
80100d33:	0f b6 00             	movzbl (%eax),%eax
80100d36:	84 c0                	test   %al,%al
80100d38:	74 17                	je     80100d51 <exec+0x331>
80100d3a:	8b 55 08             	mov    0x8(%ebp),%edx
80100d3d:	89 d1                	mov    %edx,%ecx
80100d3f:	83 c1 01             	add    $0x1,%ecx
80100d42:	3c 2f                	cmp    $0x2f,%al
80100d44:	0f b6 01             	movzbl (%ecx),%eax
80100d47:	0f 44 d1             	cmove  %ecx,%edx
80100d4a:	84 c0                	test   %al,%al
80100d4c:	75 f1                	jne    80100d3f <exec+0x31f>
80100d4e:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d51:	50                   	push   %eax
80100d52:	8d 47 6c             	lea    0x6c(%edi),%eax
80100d55:	6a 10                	push   $0x10
80100d57:	ff 75 08             	pushl  0x8(%ebp)
80100d5a:	50                   	push   %eax
80100d5b:	e8 d0 3b 00 00       	call   80104930 <safestrcpy>
  curproc->pgdir = pgdir;
80100d60:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100d66:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
80100d69:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100d6c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d72:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d74:	8b 47 18             	mov    0x18(%edi),%eax
80100d77:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d7d:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d80:	8b 47 18             	mov    0x18(%edi),%eax
80100d83:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d86:	89 3c 24             	mov    %edi,(%esp)
80100d89:	e8 02 5e 00 00       	call   80106b90 <switchuvm>
  freevm(oldpgdir,curproc->nshared);
80100d8e:	5a                   	pop    %edx
80100d8f:	59                   	pop    %ecx
80100d90:	ff b7 88 00 00 00    	pushl  0x88(%edi)
80100d96:	56                   	push   %esi
80100d97:	e8 b4 62 00 00       	call   80107050 <freevm>
  return 0;
80100d9c:	83 c4 10             	add    $0x10,%esp
80100d9f:	31 c0                	xor    %eax,%eax
80100da1:	e9 e2 fc ff ff       	jmp    80100a88 <exec+0x68>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100da6:	be 00 20 00 00       	mov    $0x2000,%esi
80100dab:	e9 1a fe ff ff       	jmp    80100bca <exec+0x1aa>
  for(argc = 0; argv[argc]; argc++) {
80100db0:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100db6:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100dbc:	e9 25 ff ff ff       	jmp    80100ce6 <exec+0x2c6>
80100dc1:	66 90                	xchg   %ax,%ax
80100dc3:	66 90                	xchg   %ax,%ax
80100dc5:	66 90                	xchg   %ax,%ax
80100dc7:	66 90                	xchg   %ax,%ax
80100dc9:	66 90                	xchg   %ax,%ax
80100dcb:	66 90                	xchg   %ax,%ax
80100dcd:	66 90                	xchg   %ax,%ax
80100dcf:	90                   	nop

80100dd0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dd6:	68 0d 74 10 80       	push   $0x8010740d
80100ddb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100de0:	e8 fb 36 00 00       	call   801044e0 <initlock>
}
80100de5:	83 c4 10             	add    $0x10,%esp
80100de8:	c9                   	leave  
80100de9:	c3                   	ret    
80100dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100df0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100df4:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100df9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dfc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e01:	e8 ca 37 00 00       	call   801045d0 <acquire>
80100e06:	83 c4 10             	add    $0x10,%esp
80100e09:	eb 10                	jmp    80100e1b <filealloc+0x2b>
80100e0b:	90                   	nop
80100e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e10:	83 c3 18             	add    $0x18,%ebx
80100e13:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e19:	73 25                	jae    80100e40 <filealloc+0x50>
    if(f->ref == 0){
80100e1b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e1e:	85 c0                	test   %eax,%eax
80100e20:	75 ee                	jne    80100e10 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e22:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e25:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e2c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e31:	e8 ba 38 00 00       	call   801046f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e36:	89 d8                	mov    %ebx,%eax
      return f;
80100e38:	83 c4 10             	add    $0x10,%esp
}
80100e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e3e:	c9                   	leave  
80100e3f:	c3                   	ret    
  release(&ftable.lock);
80100e40:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e43:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e45:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e4a:	e8 a1 38 00 00       	call   801046f0 <release>
}
80100e4f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e51:	83 c4 10             	add    $0x10,%esp
}
80100e54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e57:	c9                   	leave  
80100e58:	c3                   	ret    
80100e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e60 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	53                   	push   %ebx
80100e64:	83 ec 10             	sub    $0x10,%esp
80100e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e6a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e6f:	e8 5c 37 00 00       	call   801045d0 <acquire>
  if(f->ref < 1)
80100e74:	8b 43 04             	mov    0x4(%ebx),%eax
80100e77:	83 c4 10             	add    $0x10,%esp
80100e7a:	85 c0                	test   %eax,%eax
80100e7c:	7e 1a                	jle    80100e98 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e7e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e81:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e84:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e87:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e8c:	e8 5f 38 00 00       	call   801046f0 <release>
  return f;
}
80100e91:	89 d8                	mov    %ebx,%eax
80100e93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e96:	c9                   	leave  
80100e97:	c3                   	ret    
    panic("filedup");
80100e98:	83 ec 0c             	sub    $0xc,%esp
80100e9b:	68 14 74 10 80       	push   $0x80107414
80100ea0:	e8 eb f4 ff ff       	call   80100390 <panic>
80100ea5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100eb0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	57                   	push   %edi
80100eb4:	56                   	push   %esi
80100eb5:	53                   	push   %ebx
80100eb6:	83 ec 28             	sub    $0x28,%esp
80100eb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ebc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ec1:	e8 0a 37 00 00       	call   801045d0 <acquire>
  if(f->ref < 1)
80100ec6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ec9:	83 c4 10             	add    $0x10,%esp
80100ecc:	85 c0                	test   %eax,%eax
80100ece:	0f 8e 9b 00 00 00    	jle    80100f6f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100ed4:	83 e8 01             	sub    $0x1,%eax
80100ed7:	85 c0                	test   %eax,%eax
80100ed9:	89 43 04             	mov    %eax,0x4(%ebx)
80100edc:	74 1a                	je     80100ef8 <fileclose+0x48>
    release(&ftable.lock);
80100ede:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ee5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee8:	5b                   	pop    %ebx
80100ee9:	5e                   	pop    %esi
80100eea:	5f                   	pop    %edi
80100eeb:	5d                   	pop    %ebp
    release(&ftable.lock);
80100eec:	e9 ff 37 00 00       	jmp    801046f0 <release>
80100ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100ef8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100efc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100efe:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f01:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f04:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f0d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f10:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f15:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f18:	e8 d3 37 00 00       	call   801046f0 <release>
  if(ff.type == FD_PIPE)
80100f1d:	83 c4 10             	add    $0x10,%esp
80100f20:	83 ff 01             	cmp    $0x1,%edi
80100f23:	74 13                	je     80100f38 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f25:	83 ff 02             	cmp    $0x2,%edi
80100f28:	74 26                	je     80100f50 <fileclose+0xa0>
}
80100f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f2d:	5b                   	pop    %ebx
80100f2e:	5e                   	pop    %esi
80100f2f:	5f                   	pop    %edi
80100f30:	5d                   	pop    %ebp
80100f31:	c3                   	ret    
80100f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f38:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f3c:	83 ec 08             	sub    $0x8,%esp
80100f3f:	53                   	push   %ebx
80100f40:	56                   	push   %esi
80100f41:	e8 8a 24 00 00       	call   801033d0 <pipeclose>
80100f46:	83 c4 10             	add    $0x10,%esp
80100f49:	eb df                	jmp    80100f2a <fileclose+0x7a>
80100f4b:	90                   	nop
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f50:	e8 cb 1c 00 00       	call   80102c20 <begin_op>
    iput(ff.ip);
80100f55:	83 ec 0c             	sub    $0xc,%esp
80100f58:	ff 75 e0             	pushl  -0x20(%ebp)
80100f5b:	e8 d0 08 00 00       	call   80101830 <iput>
    end_op();
80100f60:	83 c4 10             	add    $0x10,%esp
}
80100f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f66:	5b                   	pop    %ebx
80100f67:	5e                   	pop    %esi
80100f68:	5f                   	pop    %edi
80100f69:	5d                   	pop    %ebp
    end_op();
80100f6a:	e9 21 1d 00 00       	jmp    80102c90 <end_op>
    panic("fileclose");
80100f6f:	83 ec 0c             	sub    $0xc,%esp
80100f72:	68 1c 74 10 80       	push   $0x8010741c
80100f77:	e8 14 f4 ff ff       	call   80100390 <panic>
80100f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f80 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	53                   	push   %ebx
80100f84:	83 ec 04             	sub    $0x4,%esp
80100f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f8a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f8d:	75 31                	jne    80100fc0 <filestat+0x40>
    ilock(f->ip);
80100f8f:	83 ec 0c             	sub    $0xc,%esp
80100f92:	ff 73 10             	pushl  0x10(%ebx)
80100f95:	e8 66 07 00 00       	call   80101700 <ilock>
    stati(f->ip, st);
80100f9a:	58                   	pop    %eax
80100f9b:	5a                   	pop    %edx
80100f9c:	ff 75 0c             	pushl  0xc(%ebp)
80100f9f:	ff 73 10             	pushl  0x10(%ebx)
80100fa2:	e8 09 0a 00 00       	call   801019b0 <stati>
    iunlock(f->ip);
80100fa7:	59                   	pop    %ecx
80100fa8:	ff 73 10             	pushl  0x10(%ebx)
80100fab:	e8 30 08 00 00       	call   801017e0 <iunlock>
    return 0;
80100fb0:	83 c4 10             	add    $0x10,%esp
80100fb3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fb8:	c9                   	leave  
80100fb9:	c3                   	ret    
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb ee                	jmp    80100fb5 <filestat+0x35>
80100fc7:	89 f6                	mov    %esi,%esi
80100fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fd0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 0c             	sub    $0xc,%esp
80100fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fdc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fdf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fe2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fe6:	74 60                	je     80101048 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fe8:	8b 03                	mov    (%ebx),%eax
80100fea:	83 f8 01             	cmp    $0x1,%eax
80100fed:	74 41                	je     80101030 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fef:	83 f8 02             	cmp    $0x2,%eax
80100ff2:	75 5b                	jne    8010104f <fileread+0x7f>
    ilock(f->ip);
80100ff4:	83 ec 0c             	sub    $0xc,%esp
80100ff7:	ff 73 10             	pushl  0x10(%ebx)
80100ffa:	e8 01 07 00 00       	call   80101700 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fff:	57                   	push   %edi
80101000:	ff 73 14             	pushl  0x14(%ebx)
80101003:	56                   	push   %esi
80101004:	ff 73 10             	pushl  0x10(%ebx)
80101007:	e8 d4 09 00 00       	call   801019e0 <readi>
8010100c:	83 c4 20             	add    $0x20,%esp
8010100f:	85 c0                	test   %eax,%eax
80101011:	89 c6                	mov    %eax,%esi
80101013:	7e 03                	jle    80101018 <fileread+0x48>
      f->off += r;
80101015:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 bd 07 00 00       	call   801017e0 <iunlock>
    return r;
80101023:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101026:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101029:	89 f0                	mov    %esi,%eax
8010102b:	5b                   	pop    %ebx
8010102c:	5e                   	pop    %esi
8010102d:	5f                   	pop    %edi
8010102e:	5d                   	pop    %ebp
8010102f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101030:	8b 43 0c             	mov    0xc(%ebx),%eax
80101033:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101036:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101039:	5b                   	pop    %ebx
8010103a:	5e                   	pop    %esi
8010103b:	5f                   	pop    %edi
8010103c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010103d:	e9 3e 25 00 00       	jmp    80103580 <piperead>
80101042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101048:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010104d:	eb d7                	jmp    80101026 <fileread+0x56>
  panic("fileread");
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	68 26 74 10 80       	push   $0x80107426
80101057:	e8 34 f3 ff ff       	call   80100390 <panic>
8010105c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101060 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	57                   	push   %edi
80101064:	56                   	push   %esi
80101065:	53                   	push   %ebx
80101066:	83 ec 1c             	sub    $0x1c,%esp
80101069:	8b 75 08             	mov    0x8(%ebp),%esi
8010106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010106f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101073:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101076:	8b 45 10             	mov    0x10(%ebp),%eax
80101079:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010107c:	0f 84 aa 00 00 00    	je     8010112c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101082:	8b 06                	mov    (%esi),%eax
80101084:	83 f8 01             	cmp    $0x1,%eax
80101087:	0f 84 c3 00 00 00    	je     80101150 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108d:	83 f8 02             	cmp    $0x2,%eax
80101090:	0f 85 d9 00 00 00    	jne    8010116f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101099:	31 ff                	xor    %edi,%edi
    while(i < n){
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 34                	jg     801010d3 <filewrite+0x73>
8010109f:	e9 9c 00 00 00       	jmp    80101140 <filewrite+0xe0>
801010a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010a8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010b4:	e8 27 07 00 00       	call   801017e0 <iunlock>
      end_op();
801010b9:	e8 d2 1b 00 00       	call   80102c90 <end_op>
801010be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010c1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801010c4:	39 c3                	cmp    %eax,%ebx
801010c6:	0f 85 96 00 00 00    	jne    80101162 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801010cc:	01 df                	add    %ebx,%edi
    while(i < n){
801010ce:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d1:	7e 6d                	jle    80101140 <filewrite+0xe0>
      int n1 = n - i;
801010d3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010d6:	b8 00 06 00 00       	mov    $0x600,%eax
801010db:	29 fb                	sub    %edi,%ebx
801010dd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010e3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010e6:	e8 35 1b 00 00       	call   80102c20 <begin_op>
      ilock(f->ip);
801010eb:	83 ec 0c             	sub    $0xc,%esp
801010ee:	ff 76 10             	pushl  0x10(%esi)
801010f1:	e8 0a 06 00 00       	call   80101700 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010f9:	53                   	push   %ebx
801010fa:	ff 76 14             	pushl  0x14(%esi)
801010fd:	01 f8                	add    %edi,%eax
801010ff:	50                   	push   %eax
80101100:	ff 76 10             	pushl  0x10(%esi)
80101103:	e8 d8 09 00 00       	call   80101ae0 <writei>
80101108:	83 c4 20             	add    $0x20,%esp
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 99                	jg     801010a8 <filewrite+0x48>
      iunlock(f->ip);
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	ff 76 10             	pushl  0x10(%esi)
80101115:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101118:	e8 c3 06 00 00       	call   801017e0 <iunlock>
      end_op();
8010111d:	e8 6e 1b 00 00       	call   80102c90 <end_op>
      if(r < 0)
80101122:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101125:	83 c4 10             	add    $0x10,%esp
80101128:	85 c0                	test   %eax,%eax
8010112a:	74 98                	je     801010c4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010112c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010112f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101134:	89 f8                	mov    %edi,%eax
80101136:	5b                   	pop    %ebx
80101137:	5e                   	pop    %esi
80101138:	5f                   	pop    %edi
80101139:	5d                   	pop    %ebp
8010113a:	c3                   	ret    
8010113b:	90                   	nop
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101140:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101143:	75 e7                	jne    8010112c <filewrite+0xcc>
}
80101145:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101148:	89 f8                	mov    %edi,%eax
8010114a:	5b                   	pop    %ebx
8010114b:	5e                   	pop    %esi
8010114c:	5f                   	pop    %edi
8010114d:	5d                   	pop    %ebp
8010114e:	c3                   	ret    
8010114f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101150:	8b 46 0c             	mov    0xc(%esi),%eax
80101153:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101156:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101159:	5b                   	pop    %ebx
8010115a:	5e                   	pop    %esi
8010115b:	5f                   	pop    %edi
8010115c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010115d:	e9 0e 23 00 00       	jmp    80103470 <pipewrite>
        panic("short filewrite");
80101162:	83 ec 0c             	sub    $0xc,%esp
80101165:	68 2f 74 10 80       	push   $0x8010742f
8010116a:	e8 21 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	68 35 74 10 80       	push   $0x80107435
80101177:	e8 14 f2 ff ff       	call   80100390 <panic>
8010117c:	66 90                	xchg   %ax,%ax
8010117e:	66 90                	xchg   %ax,%ax

80101180 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 3f 74 10 80       	push   $0x8010743f
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 ae 1b 00 00       	call   80102df0 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 e6 34 00 00       	call   80104750 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 7e 1b 00 00       	call   80102df0 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 e0 09 11 80       	push   $0x801109e0
801012aa:	e8 21 33 00 00       	call   801045d0 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 e0 09 11 80       	push   $0x801109e0
8010130f:	e8 dc 33 00 00       	call   801046f0 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 ae 33 00 00       	call   801046f0 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 55 74 10 80       	push   $0x80107455
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 1d 1a 00 00       	call   80102df0 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 65 74 10 80       	push   $0x80107465
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 9a 33 00 00       	call   80104800 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <bfree>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	56                   	push   %esi
80101484:	53                   	push   %ebx
80101485:	89 d3                	mov    %edx,%ebx
80101487:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101489:	83 ec 08             	sub    $0x8,%esp
8010148c:	68 c0 09 11 80       	push   $0x801109c0
80101491:	50                   	push   %eax
80101492:	e8 a9 ff ff ff       	call   80101440 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101497:	58                   	pop    %eax
80101498:	5a                   	pop    %edx
80101499:	89 da                	mov    %ebx,%edx
8010149b:	c1 ea 0c             	shr    $0xc,%edx
8010149e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801014a4:	52                   	push   %edx
801014a5:	56                   	push   %esi
801014a6:	e8 25 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014ab:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ad:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014b0:	ba 01 00 00 00       	mov    $0x1,%edx
801014b5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014b8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014be:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014c1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014c3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014c8:	85 d1                	test   %edx,%ecx
801014ca:	74 25                	je     801014f1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014cc:	f7 d2                	not    %edx
801014ce:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014d0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014d3:	21 ca                	and    %ecx,%edx
801014d5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801014d9:	56                   	push   %esi
801014da:	e8 11 19 00 00       	call   80102df0 <log_write>
  brelse(bp);
801014df:	89 34 24             	mov    %esi,(%esp)
801014e2:	e8 f9 ec ff ff       	call   801001e0 <brelse>
}
801014e7:	83 c4 10             	add    $0x10,%esp
801014ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014ed:	5b                   	pop    %ebx
801014ee:	5e                   	pop    %esi
801014ef:	5d                   	pop    %ebp
801014f0:	c3                   	ret    
    panic("freeing free block");
801014f1:	83 ec 0c             	sub    $0xc,%esp
801014f4:	68 78 74 10 80       	push   $0x80107478
801014f9:	e8 92 ee ff ff       	call   80100390 <panic>
801014fe:	66 90                	xchg   %ax,%ax

80101500 <iinit>:
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	53                   	push   %ebx
80101504:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101509:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010150c:	68 8b 74 10 80       	push   $0x8010748b
80101511:	68 e0 09 11 80       	push   $0x801109e0
80101516:	e8 c5 2f 00 00       	call   801044e0 <initlock>
8010151b:	83 c4 10             	add    $0x10,%esp
8010151e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101520:	83 ec 08             	sub    $0x8,%esp
80101523:	68 92 74 10 80       	push   $0x80107492
80101528:	53                   	push   %ebx
80101529:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010152f:	e8 9c 2e 00 00       	call   801043d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101534:	83 c4 10             	add    $0x10,%esp
80101537:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010153d:	75 e1                	jne    80101520 <iinit+0x20>
  readsb(dev, &sb);
8010153f:	83 ec 08             	sub    $0x8,%esp
80101542:	68 c0 09 11 80       	push   $0x801109c0
80101547:	ff 75 08             	pushl  0x8(%ebp)
8010154a:	e8 f1 fe ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010154f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101555:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010155b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101561:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101567:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010156d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101573:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101579:	68 f8 74 10 80       	push   $0x801074f8
8010157e:	e8 ed f0 ff ff       	call   80100670 <cprintf>
}
80101583:	83 c4 30             	add    $0x30,%esp
80101586:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101589:	c9                   	leave  
8010158a:	c3                   	ret    
8010158b:	90                   	nop
8010158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101590 <ialloc>:
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	57                   	push   %edi
80101594:	56                   	push   %esi
80101595:	53                   	push   %ebx
80101596:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101599:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015a3:	8b 75 08             	mov    0x8(%ebp),%esi
801015a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015a9:	0f 86 91 00 00 00    	jbe    80101640 <ialloc+0xb0>
801015af:	bb 01 00 00 00       	mov    $0x1,%ebx
801015b4:	eb 21                	jmp    801015d7 <ialloc+0x47>
801015b6:	8d 76 00             	lea    0x0(%esi),%esi
801015b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801015c0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015c3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015c6:	57                   	push   %edi
801015c7:	e8 14 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015cc:	83 c4 10             	add    $0x10,%esp
801015cf:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
801015d5:	76 69                	jbe    80101640 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015d7:	89 d8                	mov    %ebx,%eax
801015d9:	83 ec 08             	sub    $0x8,%esp
801015dc:	c1 e8 03             	shr    $0x3,%eax
801015df:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015e5:	50                   	push   %eax
801015e6:	56                   	push   %esi
801015e7:	e8 e4 ea ff ff       	call   801000d0 <bread>
801015ec:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015ee:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015f0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015f3:	83 e0 07             	and    $0x7,%eax
801015f6:	c1 e0 06             	shl    $0x6,%eax
801015f9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015fd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101601:	75 bd                	jne    801015c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101603:	83 ec 04             	sub    $0x4,%esp
80101606:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101609:	6a 40                	push   $0x40
8010160b:	6a 00                	push   $0x0
8010160d:	51                   	push   %ecx
8010160e:	e8 3d 31 00 00       	call   80104750 <memset>
      dip->type = type;
80101613:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101617:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010161a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010161d:	89 3c 24             	mov    %edi,(%esp)
80101620:	e8 cb 17 00 00       	call   80102df0 <log_write>
      brelse(bp);
80101625:	89 3c 24             	mov    %edi,(%esp)
80101628:	e8 b3 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010162d:	83 c4 10             	add    $0x10,%esp
}
80101630:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101633:	89 da                	mov    %ebx,%edx
80101635:	89 f0                	mov    %esi,%eax
}
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5f                   	pop    %edi
8010163a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010163b:	e9 50 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
80101640:	83 ec 0c             	sub    $0xc,%esp
80101643:	68 98 74 10 80       	push   $0x80107498
80101648:	e8 43 ed ff ff       	call   80100390 <panic>
8010164d:	8d 76 00             	lea    0x0(%esi),%esi

80101650 <iupdate>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	56                   	push   %esi
80101654:	53                   	push   %ebx
80101655:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101658:	83 ec 08             	sub    $0x8,%esp
8010165b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101661:	c1 e8 03             	shr    $0x3,%eax
80101664:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010166a:	50                   	push   %eax
8010166b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010166e:	e8 5d ea ff ff       	call   801000d0 <bread>
80101673:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101675:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101678:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010167c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010167f:	83 e0 07             	and    $0x7,%eax
80101682:	c1 e0 06             	shl    $0x6,%eax
80101685:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101689:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010168c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101690:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101693:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101697:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010169b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010169f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016a3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016a7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016aa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ad:	6a 34                	push   $0x34
801016af:	53                   	push   %ebx
801016b0:	50                   	push   %eax
801016b1:	e8 4a 31 00 00       	call   80104800 <memmove>
  log_write(bp);
801016b6:	89 34 24             	mov    %esi,(%esp)
801016b9:	e8 32 17 00 00       	call   80102df0 <log_write>
  brelse(bp);
801016be:	89 75 08             	mov    %esi,0x8(%ebp)
801016c1:	83 c4 10             	add    $0x10,%esp
}
801016c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c7:	5b                   	pop    %ebx
801016c8:	5e                   	pop    %esi
801016c9:	5d                   	pop    %ebp
  brelse(bp);
801016ca:	e9 11 eb ff ff       	jmp    801001e0 <brelse>
801016cf:	90                   	nop

801016d0 <idup>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	53                   	push   %ebx
801016d4:	83 ec 10             	sub    $0x10,%esp
801016d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016da:	68 e0 09 11 80       	push   $0x801109e0
801016df:	e8 ec 2e 00 00       	call   801045d0 <acquire>
  ip->ref++;
801016e4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016e8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016ef:	e8 fc 2f 00 00       	call   801046f0 <release>
}
801016f4:	89 d8                	mov    %ebx,%eax
801016f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016f9:	c9                   	leave  
801016fa:	c3                   	ret    
801016fb:	90                   	nop
801016fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101700 <ilock>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	56                   	push   %esi
80101704:	53                   	push   %ebx
80101705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101708:	85 db                	test   %ebx,%ebx
8010170a:	0f 84 b7 00 00 00    	je     801017c7 <ilock+0xc7>
80101710:	8b 53 08             	mov    0x8(%ebx),%edx
80101713:	85 d2                	test   %edx,%edx
80101715:	0f 8e ac 00 00 00    	jle    801017c7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010171b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010171e:	83 ec 0c             	sub    $0xc,%esp
80101721:	50                   	push   %eax
80101722:	e8 e9 2c 00 00       	call   80104410 <acquiresleep>
  if(ip->valid == 0){
80101727:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010172a:	83 c4 10             	add    $0x10,%esp
8010172d:	85 c0                	test   %eax,%eax
8010172f:	74 0f                	je     80101740 <ilock+0x40>
}
80101731:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101734:	5b                   	pop    %ebx
80101735:	5e                   	pop    %esi
80101736:	5d                   	pop    %ebp
80101737:	c3                   	ret    
80101738:	90                   	nop
80101739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101740:	8b 43 04             	mov    0x4(%ebx),%eax
80101743:	83 ec 08             	sub    $0x8,%esp
80101746:	c1 e8 03             	shr    $0x3,%eax
80101749:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010174f:	50                   	push   %eax
80101750:	ff 33                	pushl  (%ebx)
80101752:	e8 79 e9 ff ff       	call   801000d0 <bread>
80101757:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101759:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010175c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010175f:	83 e0 07             	and    $0x7,%eax
80101762:	c1 e0 06             	shl    $0x6,%eax
80101765:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101769:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010176c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010176f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101773:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101777:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010177b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010177f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101783:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101787:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010178b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010178e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101791:	6a 34                	push   $0x34
80101793:	50                   	push   %eax
80101794:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101797:	50                   	push   %eax
80101798:	e8 63 30 00 00       	call   80104800 <memmove>
    brelse(bp);
8010179d:	89 34 24             	mov    %esi,(%esp)
801017a0:	e8 3b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801017a5:	83 c4 10             	add    $0x10,%esp
801017a8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017ad:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017b4:	0f 85 77 ff ff ff    	jne    80101731 <ilock+0x31>
      panic("ilock: no type");
801017ba:	83 ec 0c             	sub    $0xc,%esp
801017bd:	68 b0 74 10 80       	push   $0x801074b0
801017c2:	e8 c9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017c7:	83 ec 0c             	sub    $0xc,%esp
801017ca:	68 aa 74 10 80       	push   $0x801074aa
801017cf:	e8 bc eb ff ff       	call   80100390 <panic>
801017d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017e0 <iunlock>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017e8:	85 db                	test   %ebx,%ebx
801017ea:	74 28                	je     80101814 <iunlock+0x34>
801017ec:	8d 73 0c             	lea    0xc(%ebx),%esi
801017ef:	83 ec 0c             	sub    $0xc,%esp
801017f2:	56                   	push   %esi
801017f3:	e8 b8 2c 00 00       	call   801044b0 <holdingsleep>
801017f8:	83 c4 10             	add    $0x10,%esp
801017fb:	85 c0                	test   %eax,%eax
801017fd:	74 15                	je     80101814 <iunlock+0x34>
801017ff:	8b 43 08             	mov    0x8(%ebx),%eax
80101802:	85 c0                	test   %eax,%eax
80101804:	7e 0e                	jle    80101814 <iunlock+0x34>
  releasesleep(&ip->lock);
80101806:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101809:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010180f:	e9 5c 2c 00 00       	jmp    80104470 <releasesleep>
    panic("iunlock");
80101814:	83 ec 0c             	sub    $0xc,%esp
80101817:	68 bf 74 10 80       	push   $0x801074bf
8010181c:	e8 6f eb ff ff       	call   80100390 <panic>
80101821:	eb 0d                	jmp    80101830 <iput>
80101823:	90                   	nop
80101824:	90                   	nop
80101825:	90                   	nop
80101826:	90                   	nop
80101827:	90                   	nop
80101828:	90                   	nop
80101829:	90                   	nop
8010182a:	90                   	nop
8010182b:	90                   	nop
8010182c:	90                   	nop
8010182d:	90                   	nop
8010182e:	90                   	nop
8010182f:	90                   	nop

80101830 <iput>:
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	57                   	push   %edi
80101834:	56                   	push   %esi
80101835:	53                   	push   %ebx
80101836:	83 ec 28             	sub    $0x28,%esp
80101839:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010183c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010183f:	57                   	push   %edi
80101840:	e8 cb 2b 00 00       	call   80104410 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101845:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101848:	83 c4 10             	add    $0x10,%esp
8010184b:	85 d2                	test   %edx,%edx
8010184d:	74 07                	je     80101856 <iput+0x26>
8010184f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101854:	74 32                	je     80101888 <iput+0x58>
  releasesleep(&ip->lock);
80101856:	83 ec 0c             	sub    $0xc,%esp
80101859:	57                   	push   %edi
8010185a:	e8 11 2c 00 00       	call   80104470 <releasesleep>
  acquire(&icache.lock);
8010185f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101866:	e8 65 2d 00 00       	call   801045d0 <acquire>
  ip->ref--;
8010186b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010186f:	83 c4 10             	add    $0x10,%esp
80101872:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101879:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010187c:	5b                   	pop    %ebx
8010187d:	5e                   	pop    %esi
8010187e:	5f                   	pop    %edi
8010187f:	5d                   	pop    %ebp
  release(&icache.lock);
80101880:	e9 6b 2e 00 00       	jmp    801046f0 <release>
80101885:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 e0 09 11 80       	push   $0x801109e0
80101890:	e8 3b 2d 00 00       	call   801045d0 <acquire>
    int r = ip->ref;
80101895:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101898:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010189f:	e8 4c 2e 00 00       	call   801046f0 <release>
    if(r == 1){
801018a4:	83 c4 10             	add    $0x10,%esp
801018a7:	83 fe 01             	cmp    $0x1,%esi
801018aa:	75 aa                	jne    80101856 <iput+0x26>
801018ac:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018b2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018b5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018b8:	89 cf                	mov    %ecx,%edi
801018ba:	eb 0b                	jmp    801018c7 <iput+0x97>
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018c0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018c3:	39 fe                	cmp    %edi,%esi
801018c5:	74 19                	je     801018e0 <iput+0xb0>
    if(ip->addrs[i]){
801018c7:	8b 16                	mov    (%esi),%edx
801018c9:	85 d2                	test   %edx,%edx
801018cb:	74 f3                	je     801018c0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018cd:	8b 03                	mov    (%ebx),%eax
801018cf:	e8 ac fb ff ff       	call   80101480 <bfree>
      ip->addrs[i] = 0;
801018d4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018da:	eb e4                	jmp    801018c0 <iput+0x90>
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018e0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018e9:	85 c0                	test   %eax,%eax
801018eb:	75 33                	jne    80101920 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018ed:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018f0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018f7:	53                   	push   %ebx
801018f8:	e8 53 fd ff ff       	call   80101650 <iupdate>
      ip->type = 0;
801018fd:	31 c0                	xor    %eax,%eax
801018ff:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101903:	89 1c 24             	mov    %ebx,(%esp)
80101906:	e8 45 fd ff ff       	call   80101650 <iupdate>
      ip->valid = 0;
8010190b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101912:	83 c4 10             	add    $0x10,%esp
80101915:	e9 3c ff ff ff       	jmp    80101856 <iput+0x26>
8010191a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101920:	83 ec 08             	sub    $0x8,%esp
80101923:	50                   	push   %eax
80101924:	ff 33                	pushl  (%ebx)
80101926:	e8 a5 e7 ff ff       	call   801000d0 <bread>
8010192b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101931:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101934:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101937:	8d 70 5c             	lea    0x5c(%eax),%esi
8010193a:	83 c4 10             	add    $0x10,%esp
8010193d:	89 cf                	mov    %ecx,%edi
8010193f:	eb 0e                	jmp    8010194f <iput+0x11f>
80101941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101948:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010194b:	39 fe                	cmp    %edi,%esi
8010194d:	74 0f                	je     8010195e <iput+0x12e>
      if(a[j])
8010194f:	8b 16                	mov    (%esi),%edx
80101951:	85 d2                	test   %edx,%edx
80101953:	74 f3                	je     80101948 <iput+0x118>
        bfree(ip->dev, a[j]);
80101955:	8b 03                	mov    (%ebx),%eax
80101957:	e8 24 fb ff ff       	call   80101480 <bfree>
8010195c:	eb ea                	jmp    80101948 <iput+0x118>
    brelse(bp);
8010195e:	83 ec 0c             	sub    $0xc,%esp
80101961:	ff 75 e4             	pushl  -0x1c(%ebp)
80101964:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101967:	e8 74 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010196c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101972:	8b 03                	mov    (%ebx),%eax
80101974:	e8 07 fb ff ff       	call   80101480 <bfree>
    ip->addrs[NDIRECT] = 0;
80101979:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101980:	00 00 00 
80101983:	83 c4 10             	add    $0x10,%esp
80101986:	e9 62 ff ff ff       	jmp    801018ed <iput+0xbd>
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <iunlockput>:
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	53                   	push   %ebx
80101994:	83 ec 10             	sub    $0x10,%esp
80101997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010199a:	53                   	push   %ebx
8010199b:	e8 40 fe ff ff       	call   801017e0 <iunlock>
  iput(ip);
801019a0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019a3:	83 c4 10             	add    $0x10,%esp
}
801019a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019a9:	c9                   	leave  
  iput(ip);
801019aa:	e9 81 fe ff ff       	jmp    80101830 <iput>
801019af:	90                   	nop

801019b0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	8b 55 08             	mov    0x8(%ebp),%edx
801019b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019b9:	8b 0a                	mov    (%edx),%ecx
801019bb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019be:	8b 4a 04             	mov    0x4(%edx),%ecx
801019c1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019c4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019c8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019cb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019cf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019d3:	8b 52 58             	mov    0x58(%edx),%edx
801019d6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019d9:	5d                   	pop    %ebp
801019da:	c3                   	ret    
801019db:	90                   	nop
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019e0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 1c             	sub    $0x1c,%esp
801019e9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ec:	8b 75 0c             	mov    0xc(%ebp),%esi
801019ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019f2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019f7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019fd:	8b 75 10             	mov    0x10(%ebp),%esi
80101a00:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a03:	0f 84 a7 00 00 00    	je     80101ab0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a0c:	8b 40 58             	mov    0x58(%eax),%eax
80101a0f:	39 c6                	cmp    %eax,%esi
80101a11:	0f 87 ba 00 00 00    	ja     80101ad1 <readi+0xf1>
80101a17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a1a:	89 f9                	mov    %edi,%ecx
80101a1c:	01 f1                	add    %esi,%ecx
80101a1e:	0f 82 ad 00 00 00    	jb     80101ad1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a24:	89 c2                	mov    %eax,%edx
80101a26:	29 f2                	sub    %esi,%edx
80101a28:	39 c8                	cmp    %ecx,%eax
80101a2a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a2d:	31 ff                	xor    %edi,%edi
80101a2f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101a31:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a34:	74 6c                	je     80101aa2 <readi+0xc2>
80101a36:	8d 76 00             	lea    0x0(%esi),%esi
80101a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a43:	89 f2                	mov    %esi,%edx
80101a45:	c1 ea 09             	shr    $0x9,%edx
80101a48:	89 d8                	mov    %ebx,%eax
80101a4a:	e8 11 f9 ff ff       	call   80101360 <bmap>
80101a4f:	83 ec 08             	sub    $0x8,%esp
80101a52:	50                   	push   %eax
80101a53:	ff 33                	pushl  (%ebx)
80101a55:	e8 76 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a5d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a5f:	89 f0                	mov    %esi,%eax
80101a61:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a66:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a6b:	83 c4 0c             	add    $0xc,%esp
80101a6e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a70:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a74:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a77:	29 fb                	sub    %edi,%ebx
80101a79:	39 d9                	cmp    %ebx,%ecx
80101a7b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a7e:	53                   	push   %ebx
80101a7f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a80:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a82:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a85:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a87:	e8 74 2d 00 00       	call   80104800 <memmove>
    brelse(bp);
80101a8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a8f:	89 14 24             	mov    %edx,(%esp)
80101a92:	e8 49 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a97:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a9a:	83 c4 10             	add    $0x10,%esp
80101a9d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101aa0:	77 9e                	ja     80101a40 <readi+0x60>
  }
  return n;
80101aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101aa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aa8:	5b                   	pop    %ebx
80101aa9:	5e                   	pop    %esi
80101aaa:	5f                   	pop    %edi
80101aab:	5d                   	pop    %ebp
80101aac:	c3                   	ret    
80101aad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ab0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ab4:	66 83 f8 09          	cmp    $0x9,%ax
80101ab8:	77 17                	ja     80101ad1 <readi+0xf1>
80101aba:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101ac1:	85 c0                	test   %eax,%eax
80101ac3:	74 0c                	je     80101ad1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ac5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ac8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101acb:	5b                   	pop    %ebx
80101acc:	5e                   	pop    %esi
80101acd:	5f                   	pop    %edi
80101ace:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101acf:	ff e0                	jmp    *%eax
      return -1;
80101ad1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ad6:	eb cd                	jmp    80101aa5 <readi+0xc5>
80101ad8:	90                   	nop
80101ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ae0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 1c             	sub    $0x1c,%esp
80101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aef:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101af7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101afa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101afd:	8b 75 10             	mov    0x10(%ebp),%esi
80101b00:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b03:	0f 84 b7 00 00 00    	je     80101bc0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b0f:	0f 82 eb 00 00 00    	jb     80101c00 <writei+0x120>
80101b15:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b18:	31 d2                	xor    %edx,%edx
80101b1a:	89 f8                	mov    %edi,%eax
80101b1c:	01 f0                	add    %esi,%eax
80101b1e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b21:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b26:	0f 87 d4 00 00 00    	ja     80101c00 <writei+0x120>
80101b2c:	85 d2                	test   %edx,%edx
80101b2e:	0f 85 cc 00 00 00    	jne    80101c00 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b34:	85 ff                	test   %edi,%edi
80101b36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b3d:	74 72                	je     80101bb1 <writei+0xd1>
80101b3f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b40:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b43:	89 f2                	mov    %esi,%edx
80101b45:	c1 ea 09             	shr    $0x9,%edx
80101b48:	89 f8                	mov    %edi,%eax
80101b4a:	e8 11 f8 ff ff       	call   80101360 <bmap>
80101b4f:	83 ec 08             	sub    $0x8,%esp
80101b52:	50                   	push   %eax
80101b53:	ff 37                	pushl  (%edi)
80101b55:	e8 76 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b5a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b5d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b62:	89 f0                	mov    %esi,%eax
80101b64:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b69:	83 c4 0c             	add    $0xc,%esp
80101b6c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b71:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b73:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b77:	39 d9                	cmp    %ebx,%ecx
80101b79:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b7c:	53                   	push   %ebx
80101b7d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b80:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b82:	50                   	push   %eax
80101b83:	e8 78 2c 00 00       	call   80104800 <memmove>
    log_write(bp);
80101b88:	89 3c 24             	mov    %edi,(%esp)
80101b8b:	e8 60 12 00 00       	call   80102df0 <log_write>
    brelse(bp);
80101b90:	89 3c 24             	mov    %edi,(%esp)
80101b93:	e8 48 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b98:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b9b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b9e:	83 c4 10             	add    $0x10,%esp
80101ba1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ba4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ba7:	77 97                	ja     80101b40 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ba9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bac:	3b 70 58             	cmp    0x58(%eax),%esi
80101baf:	77 37                	ja     80101be8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bb7:	5b                   	pop    %ebx
80101bb8:	5e                   	pop    %esi
80101bb9:	5f                   	pop    %edi
80101bba:	5d                   	pop    %ebp
80101bbb:	c3                   	ret    
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bc4:	66 83 f8 09          	cmp    $0x9,%ax
80101bc8:	77 36                	ja     80101c00 <writei+0x120>
80101bca:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101bd1:	85 c0                	test   %eax,%eax
80101bd3:	74 2b                	je     80101c00 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101bd5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bdb:	5b                   	pop    %ebx
80101bdc:	5e                   	pop    %esi
80101bdd:	5f                   	pop    %edi
80101bde:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bdf:	ff e0                	jmp    *%eax
80101be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101be8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101beb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bf1:	50                   	push   %eax
80101bf2:	e8 59 fa ff ff       	call   80101650 <iupdate>
80101bf7:	83 c4 10             	add    $0x10,%esp
80101bfa:	eb b5                	jmp    80101bb1 <writei+0xd1>
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c05:	eb ad                	jmp    80101bb4 <writei+0xd4>
80101c07:	89 f6                	mov    %esi,%esi
80101c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c16:	6a 0e                	push   $0xe
80101c18:	ff 75 0c             	pushl  0xc(%ebp)
80101c1b:	ff 75 08             	pushl  0x8(%ebp)
80101c1e:	e8 4d 2c 00 00       	call   80104870 <strncmp>
}
80101c23:	c9                   	leave  
80101c24:	c3                   	ret    
80101c25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	57                   	push   %edi
80101c34:	56                   	push   %esi
80101c35:	53                   	push   %ebx
80101c36:	83 ec 1c             	sub    $0x1c,%esp
80101c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c41:	0f 85 85 00 00 00    	jne    80101ccc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c47:	8b 53 58             	mov    0x58(%ebx),%edx
80101c4a:	31 ff                	xor    %edi,%edi
80101c4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c4f:	85 d2                	test   %edx,%edx
80101c51:	74 3e                	je     80101c91 <dirlookup+0x61>
80101c53:	90                   	nop
80101c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c58:	6a 10                	push   $0x10
80101c5a:	57                   	push   %edi
80101c5b:	56                   	push   %esi
80101c5c:	53                   	push   %ebx
80101c5d:	e8 7e fd ff ff       	call   801019e0 <readi>
80101c62:	83 c4 10             	add    $0x10,%esp
80101c65:	83 f8 10             	cmp    $0x10,%eax
80101c68:	75 55                	jne    80101cbf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c6f:	74 18                	je     80101c89 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c74:	83 ec 04             	sub    $0x4,%esp
80101c77:	6a 0e                	push   $0xe
80101c79:	50                   	push   %eax
80101c7a:	ff 75 0c             	pushl  0xc(%ebp)
80101c7d:	e8 ee 2b 00 00       	call   80104870 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c82:	83 c4 10             	add    $0x10,%esp
80101c85:	85 c0                	test   %eax,%eax
80101c87:	74 17                	je     80101ca0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c89:	83 c7 10             	add    $0x10,%edi
80101c8c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c8f:	72 c7                	jb     80101c58 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c94:	31 c0                	xor    %eax,%eax
}
80101c96:	5b                   	pop    %ebx
80101c97:	5e                   	pop    %esi
80101c98:	5f                   	pop    %edi
80101c99:	5d                   	pop    %ebp
80101c9a:	c3                   	ret    
80101c9b:	90                   	nop
80101c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101ca0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ca3:	85 c0                	test   %eax,%eax
80101ca5:	74 05                	je     80101cac <dirlookup+0x7c>
        *poff = off;
80101ca7:	8b 45 10             	mov    0x10(%ebp),%eax
80101caa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cac:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cb0:	8b 03                	mov    (%ebx),%eax
80101cb2:	e8 d9 f5 ff ff       	call   80101290 <iget>
}
80101cb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cba:	5b                   	pop    %ebx
80101cbb:	5e                   	pop    %esi
80101cbc:	5f                   	pop    %edi
80101cbd:	5d                   	pop    %ebp
80101cbe:	c3                   	ret    
      panic("dirlookup read");
80101cbf:	83 ec 0c             	sub    $0xc,%esp
80101cc2:	68 d9 74 10 80       	push   $0x801074d9
80101cc7:	e8 c4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101ccc:	83 ec 0c             	sub    $0xc,%esp
80101ccf:	68 c7 74 10 80       	push   $0x801074c7
80101cd4:	e8 b7 e6 ff ff       	call   80100390 <panic>
80101cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	89 cf                	mov    %ecx,%edi
80101ce8:	89 c3                	mov    %eax,%ebx
80101cea:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ced:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cf0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cf3:	0f 84 67 01 00 00    	je     80101e60 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cf9:	e8 72 1b 00 00       	call   80103870 <myproc>
  acquire(&icache.lock);
80101cfe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d01:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d04:	68 e0 09 11 80       	push   $0x801109e0
80101d09:	e8 c2 28 00 00       	call   801045d0 <acquire>
  ip->ref++;
80101d0e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d12:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d19:	e8 d2 29 00 00       	call   801046f0 <release>
80101d1e:	83 c4 10             	add    $0x10,%esp
80101d21:	eb 08                	jmp    80101d2b <namex+0x4b>
80101d23:	90                   	nop
80101d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d28:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d2b:	0f b6 03             	movzbl (%ebx),%eax
80101d2e:	3c 2f                	cmp    $0x2f,%al
80101d30:	74 f6                	je     80101d28 <namex+0x48>
  if(*path == 0)
80101d32:	84 c0                	test   %al,%al
80101d34:	0f 84 ee 00 00 00    	je     80101e28 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d3a:	0f b6 03             	movzbl (%ebx),%eax
80101d3d:	3c 2f                	cmp    $0x2f,%al
80101d3f:	0f 84 b3 00 00 00    	je     80101df8 <namex+0x118>
80101d45:	84 c0                	test   %al,%al
80101d47:	89 da                	mov    %ebx,%edx
80101d49:	75 09                	jne    80101d54 <namex+0x74>
80101d4b:	e9 a8 00 00 00       	jmp    80101df8 <namex+0x118>
80101d50:	84 c0                	test   %al,%al
80101d52:	74 0a                	je     80101d5e <namex+0x7e>
    path++;
80101d54:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d57:	0f b6 02             	movzbl (%edx),%eax
80101d5a:	3c 2f                	cmp    $0x2f,%al
80101d5c:	75 f2                	jne    80101d50 <namex+0x70>
80101d5e:	89 d1                	mov    %edx,%ecx
80101d60:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d62:	83 f9 0d             	cmp    $0xd,%ecx
80101d65:	0f 8e 91 00 00 00    	jle    80101dfc <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d6b:	83 ec 04             	sub    $0x4,%esp
80101d6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d71:	6a 0e                	push   $0xe
80101d73:	53                   	push   %ebx
80101d74:	57                   	push   %edi
80101d75:	e8 86 2a 00 00       	call   80104800 <memmove>
    path++;
80101d7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d7d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d80:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d82:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d85:	75 11                	jne    80101d98 <namex+0xb8>
80101d87:	89 f6                	mov    %esi,%esi
80101d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d90:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d93:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d96:	74 f8                	je     80101d90 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d98:	83 ec 0c             	sub    $0xc,%esp
80101d9b:	56                   	push   %esi
80101d9c:	e8 5f f9 ff ff       	call   80101700 <ilock>
    if(ip->type != T_DIR){
80101da1:	83 c4 10             	add    $0x10,%esp
80101da4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101da9:	0f 85 91 00 00 00    	jne    80101e40 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101daf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101db2:	85 d2                	test   %edx,%edx
80101db4:	74 09                	je     80101dbf <namex+0xdf>
80101db6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101db9:	0f 84 b7 00 00 00    	je     80101e76 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dbf:	83 ec 04             	sub    $0x4,%esp
80101dc2:	6a 00                	push   $0x0
80101dc4:	57                   	push   %edi
80101dc5:	56                   	push   %esi
80101dc6:	e8 65 fe ff ff       	call   80101c30 <dirlookup>
80101dcb:	83 c4 10             	add    $0x10,%esp
80101dce:	85 c0                	test   %eax,%eax
80101dd0:	74 6e                	je     80101e40 <namex+0x160>
  iunlock(ip);
80101dd2:	83 ec 0c             	sub    $0xc,%esp
80101dd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101dd8:	56                   	push   %esi
80101dd9:	e8 02 fa ff ff       	call   801017e0 <iunlock>
  iput(ip);
80101dde:	89 34 24             	mov    %esi,(%esp)
80101de1:	e8 4a fa ff ff       	call   80101830 <iput>
80101de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101de9:	83 c4 10             	add    $0x10,%esp
80101dec:	89 c6                	mov    %eax,%esi
80101dee:	e9 38 ff ff ff       	jmp    80101d2b <namex+0x4b>
80101df3:	90                   	nop
80101df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101df8:	89 da                	mov    %ebx,%edx
80101dfa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dfc:	83 ec 04             	sub    $0x4,%esp
80101dff:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e02:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e05:	51                   	push   %ecx
80101e06:	53                   	push   %ebx
80101e07:	57                   	push   %edi
80101e08:	e8 f3 29 00 00       	call   80104800 <memmove>
    name[len] = 0;
80101e0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e10:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e13:	83 c4 10             	add    $0x10,%esp
80101e16:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e1a:	89 d3                	mov    %edx,%ebx
80101e1c:	e9 61 ff ff ff       	jmp    80101d82 <namex+0xa2>
80101e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e2b:	85 c0                	test   %eax,%eax
80101e2d:	75 5d                	jne    80101e8c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e32:	89 f0                	mov    %esi,%eax
80101e34:	5b                   	pop    %ebx
80101e35:	5e                   	pop    %esi
80101e36:	5f                   	pop    %edi
80101e37:	5d                   	pop    %ebp
80101e38:	c3                   	ret    
80101e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 97 f9 ff ff       	call   801017e0 <iunlock>
  iput(ip);
80101e49:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e4c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e4e:	e8 dd f9 ff ff       	call   80101830 <iput>
      return 0;
80101e53:	83 c4 10             	add    $0x10,%esp
}
80101e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e59:	89 f0                	mov    %esi,%eax
80101e5b:	5b                   	pop    %ebx
80101e5c:	5e                   	pop    %esi
80101e5d:	5f                   	pop    %edi
80101e5e:	5d                   	pop    %ebp
80101e5f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e60:	ba 01 00 00 00       	mov    $0x1,%edx
80101e65:	b8 01 00 00 00       	mov    $0x1,%eax
80101e6a:	e8 21 f4 ff ff       	call   80101290 <iget>
80101e6f:	89 c6                	mov    %eax,%esi
80101e71:	e9 b5 fe ff ff       	jmp    80101d2b <namex+0x4b>
      iunlock(ip);
80101e76:	83 ec 0c             	sub    $0xc,%esp
80101e79:	56                   	push   %esi
80101e7a:	e8 61 f9 ff ff       	call   801017e0 <iunlock>
      return ip;
80101e7f:	83 c4 10             	add    $0x10,%esp
}
80101e82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e85:	89 f0                	mov    %esi,%eax
80101e87:	5b                   	pop    %ebx
80101e88:	5e                   	pop    %esi
80101e89:	5f                   	pop    %edi
80101e8a:	5d                   	pop    %ebp
80101e8b:	c3                   	ret    
    iput(ip);
80101e8c:	83 ec 0c             	sub    $0xc,%esp
80101e8f:	56                   	push   %esi
    return 0;
80101e90:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e92:	e8 99 f9 ff ff       	call   80101830 <iput>
    return 0;
80101e97:	83 c4 10             	add    $0x10,%esp
80101e9a:	eb 93                	jmp    80101e2f <namex+0x14f>
80101e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ea0 <dirlink>:
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	83 ec 20             	sub    $0x20,%esp
80101ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101eac:	6a 00                	push   $0x0
80101eae:	ff 75 0c             	pushl  0xc(%ebp)
80101eb1:	53                   	push   %ebx
80101eb2:	e8 79 fd ff ff       	call   80101c30 <dirlookup>
80101eb7:	83 c4 10             	add    $0x10,%esp
80101eba:	85 c0                	test   %eax,%eax
80101ebc:	75 67                	jne    80101f25 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ebe:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ec1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ec4:	85 ff                	test   %edi,%edi
80101ec6:	74 29                	je     80101ef1 <dirlink+0x51>
80101ec8:	31 ff                	xor    %edi,%edi
80101eca:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ecd:	eb 09                	jmp    80101ed8 <dirlink+0x38>
80101ecf:	90                   	nop
80101ed0:	83 c7 10             	add    $0x10,%edi
80101ed3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ed6:	73 19                	jae    80101ef1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ed8:	6a 10                	push   $0x10
80101eda:	57                   	push   %edi
80101edb:	56                   	push   %esi
80101edc:	53                   	push   %ebx
80101edd:	e8 fe fa ff ff       	call   801019e0 <readi>
80101ee2:	83 c4 10             	add    $0x10,%esp
80101ee5:	83 f8 10             	cmp    $0x10,%eax
80101ee8:	75 4e                	jne    80101f38 <dirlink+0x98>
    if(de.inum == 0)
80101eea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eef:	75 df                	jne    80101ed0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101ef1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ef4:	83 ec 04             	sub    $0x4,%esp
80101ef7:	6a 0e                	push   $0xe
80101ef9:	ff 75 0c             	pushl  0xc(%ebp)
80101efc:	50                   	push   %eax
80101efd:	e8 ce 29 00 00       	call   801048d0 <strncpy>
  de.inum = inum;
80101f02:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f05:	6a 10                	push   $0x10
80101f07:	57                   	push   %edi
80101f08:	56                   	push   %esi
80101f09:	53                   	push   %ebx
  de.inum = inum;
80101f0a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f0e:	e8 cd fb ff ff       	call   80101ae0 <writei>
80101f13:	83 c4 20             	add    $0x20,%esp
80101f16:	83 f8 10             	cmp    $0x10,%eax
80101f19:	75 2a                	jne    80101f45 <dirlink+0xa5>
  return 0;
80101f1b:	31 c0                	xor    %eax,%eax
}
80101f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f20:	5b                   	pop    %ebx
80101f21:	5e                   	pop    %esi
80101f22:	5f                   	pop    %edi
80101f23:	5d                   	pop    %ebp
80101f24:	c3                   	ret    
    iput(ip);
80101f25:	83 ec 0c             	sub    $0xc,%esp
80101f28:	50                   	push   %eax
80101f29:	e8 02 f9 ff ff       	call   80101830 <iput>
    return -1;
80101f2e:	83 c4 10             	add    $0x10,%esp
80101f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f36:	eb e5                	jmp    80101f1d <dirlink+0x7d>
      panic("dirlink read");
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	68 e8 74 10 80       	push   $0x801074e8
80101f40:	e8 4b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f45:	83 ec 0c             	sub    $0xc,%esp
80101f48:	68 ea 7a 10 80       	push   $0x80107aea
80101f4d:	e8 3e e4 ff ff       	call   80100390 <panic>
80101f52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f60 <namei>:

struct inode*
namei(char *path)
{
80101f60:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f61:	31 d2                	xor    %edx,%edx
{
80101f63:	89 e5                	mov    %esp,%ebp
80101f65:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f68:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f6e:	e8 6d fd ff ff       	call   80101ce0 <namex>
}
80101f73:	c9                   	leave  
80101f74:	c3                   	ret    
80101f75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f80 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f80:	55                   	push   %ebp
  return namex(path, 1, name);
80101f81:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f86:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f8e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f8f:	e9 4c fd ff ff       	jmp    80101ce0 <namex>
80101f94:	66 90                	xchg   %ax,%ax
80101f96:	66 90                	xchg   %ax,%ax
80101f98:	66 90                	xchg   %ax,%ax
80101f9a:	66 90                	xchg   %ax,%ax
80101f9c:	66 90                	xchg   %ax,%ax
80101f9e:	66 90                	xchg   %ax,%ax

80101fa0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	57                   	push   %edi
80101fa4:	56                   	push   %esi
80101fa5:	53                   	push   %ebx
80101fa6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101fa9:	85 c0                	test   %eax,%eax
80101fab:	0f 84 b4 00 00 00    	je     80102065 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fb1:	8b 58 08             	mov    0x8(%eax),%ebx
80101fb4:	89 c6                	mov    %eax,%esi
80101fb6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101fbc:	0f 87 96 00 00 00    	ja     80102058 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fc2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101fd0:	89 ca                	mov    %ecx,%edx
80101fd2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fd3:	83 e0 c0             	and    $0xffffffc0,%eax
80101fd6:	3c 40                	cmp    $0x40,%al
80101fd8:	75 f6                	jne    80101fd0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fda:	31 ff                	xor    %edi,%edi
80101fdc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fe1:	89 f8                	mov    %edi,%eax
80101fe3:	ee                   	out    %al,(%dx)
80101fe4:	b8 01 00 00 00       	mov    $0x1,%eax
80101fe9:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fee:	ee                   	out    %al,(%dx)
80101fef:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101ff4:	89 d8                	mov    %ebx,%eax
80101ff6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101ff7:	89 d8                	mov    %ebx,%eax
80101ff9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101ffe:	c1 f8 08             	sar    $0x8,%eax
80102001:	ee                   	out    %al,(%dx)
80102002:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102007:	89 f8                	mov    %edi,%eax
80102009:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010200a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010200e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102013:	c1 e0 04             	shl    $0x4,%eax
80102016:	83 e0 10             	and    $0x10,%eax
80102019:	83 c8 e0             	or     $0xffffffe0,%eax
8010201c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010201d:	f6 06 04             	testb  $0x4,(%esi)
80102020:	75 16                	jne    80102038 <idestart+0x98>
80102022:	b8 20 00 00 00       	mov    $0x20,%eax
80102027:	89 ca                	mov    %ecx,%edx
80102029:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010202a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010202d:	5b                   	pop    %ebx
8010202e:	5e                   	pop    %esi
8010202f:	5f                   	pop    %edi
80102030:	5d                   	pop    %ebp
80102031:	c3                   	ret    
80102032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102038:	b8 30 00 00 00       	mov    $0x30,%eax
8010203d:	89 ca                	mov    %ecx,%edx
8010203f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102040:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102045:	83 c6 5c             	add    $0x5c,%esi
80102048:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010204d:	fc                   	cld    
8010204e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102050:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102053:	5b                   	pop    %ebx
80102054:	5e                   	pop    %esi
80102055:	5f                   	pop    %edi
80102056:	5d                   	pop    %ebp
80102057:	c3                   	ret    
    panic("incorrect blockno");
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 54 75 10 80       	push   $0x80107554
80102060:	e8 2b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	68 4b 75 10 80       	push   $0x8010754b
8010206d:	e8 1e e3 ff ff       	call   80100390 <panic>
80102072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102080 <ideinit>:
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102086:	68 66 75 10 80       	push   $0x80107566
8010208b:	68 80 a5 10 80       	push   $0x8010a580
80102090:	e8 4b 24 00 00       	call   801044e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102095:	58                   	pop    %eax
80102096:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010209b:	5a                   	pop    %edx
8010209c:	83 e8 01             	sub    $0x1,%eax
8010209f:	50                   	push   %eax
801020a0:	6a 0e                	push   $0xe
801020a2:	e8 a9 02 00 00       	call   80102350 <ioapicenable>
801020a7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020aa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020af:	90                   	nop
801020b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b1:	83 e0 c0             	and    $0xffffffc0,%eax
801020b4:	3c 40                	cmp    $0x40,%al
801020b6:	75 f8                	jne    801020b0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020b8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801020bd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020c2:	ee                   	out    %al,(%dx)
801020c3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020cd:	eb 06                	jmp    801020d5 <ideinit+0x55>
801020cf:	90                   	nop
  for(i=0; i<1000; i++){
801020d0:	83 e9 01             	sub    $0x1,%ecx
801020d3:	74 0f                	je     801020e4 <ideinit+0x64>
801020d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020d6:	84 c0                	test   %al,%al
801020d8:	74 f6                	je     801020d0 <ideinit+0x50>
      havedisk1 = 1;
801020da:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801020e1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020e4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020e9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020ee:	ee                   	out    %al,(%dx)
}
801020ef:	c9                   	leave  
801020f0:	c3                   	ret    
801020f1:	eb 0d                	jmp    80102100 <ideintr>
801020f3:	90                   	nop
801020f4:	90                   	nop
801020f5:	90                   	nop
801020f6:	90                   	nop
801020f7:	90                   	nop
801020f8:	90                   	nop
801020f9:	90                   	nop
801020fa:	90                   	nop
801020fb:	90                   	nop
801020fc:	90                   	nop
801020fd:	90                   	nop
801020fe:	90                   	nop
801020ff:	90                   	nop

80102100 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102109:	68 80 a5 10 80       	push   $0x8010a580
8010210e:	e8 bd 24 00 00       	call   801045d0 <acquire>

  if((b = idequeue) == 0){
80102113:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102119:	83 c4 10             	add    $0x10,%esp
8010211c:	85 db                	test   %ebx,%ebx
8010211e:	74 67                	je     80102187 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102120:	8b 43 58             	mov    0x58(%ebx),%eax
80102123:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102128:	8b 3b                	mov    (%ebx),%edi
8010212a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102130:	75 31                	jne    80102163 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102132:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102137:	89 f6                	mov    %esi,%esi
80102139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102140:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102141:	89 c6                	mov    %eax,%esi
80102143:	83 e6 c0             	and    $0xffffffc0,%esi
80102146:	89 f1                	mov    %esi,%ecx
80102148:	80 f9 40             	cmp    $0x40,%cl
8010214b:	75 f3                	jne    80102140 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010214d:	a8 21                	test   $0x21,%al
8010214f:	75 12                	jne    80102163 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102151:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102154:	b9 80 00 00 00       	mov    $0x80,%ecx
80102159:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010215e:	fc                   	cld    
8010215f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102161:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102163:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102166:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102169:	89 f9                	mov    %edi,%ecx
8010216b:	83 c9 02             	or     $0x2,%ecx
8010216e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102170:	53                   	push   %ebx
80102171:	e8 da 20 00 00       	call   80104250 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102176:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010217b:	83 c4 10             	add    $0x10,%esp
8010217e:	85 c0                	test   %eax,%eax
80102180:	74 05                	je     80102187 <ideintr+0x87>
    idestart(idequeue);
80102182:	e8 19 fe ff ff       	call   80101fa0 <idestart>
    release(&idelock);
80102187:	83 ec 0c             	sub    $0xc,%esp
8010218a:	68 80 a5 10 80       	push   $0x8010a580
8010218f:	e8 5c 25 00 00       	call   801046f0 <release>

  release(&idelock);
}
80102194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102197:	5b                   	pop    %ebx
80102198:	5e                   	pop    %esi
80102199:	5f                   	pop    %edi
8010219a:	5d                   	pop    %ebp
8010219b:	c3                   	ret    
8010219c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	53                   	push   %ebx
801021a4:	83 ec 10             	sub    $0x10,%esp
801021a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801021aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801021ad:	50                   	push   %eax
801021ae:	e8 fd 22 00 00       	call   801044b0 <holdingsleep>
801021b3:	83 c4 10             	add    $0x10,%esp
801021b6:	85 c0                	test   %eax,%eax
801021b8:	0f 84 c6 00 00 00    	je     80102284 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 e0 06             	and    $0x6,%eax
801021c3:	83 f8 02             	cmp    $0x2,%eax
801021c6:	0f 84 ab 00 00 00    	je     80102277 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021cc:	8b 53 04             	mov    0x4(%ebx),%edx
801021cf:	85 d2                	test   %edx,%edx
801021d1:	74 0d                	je     801021e0 <iderw+0x40>
801021d3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801021d8:	85 c0                	test   %eax,%eax
801021da:	0f 84 b1 00 00 00    	je     80102291 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021e0:	83 ec 0c             	sub    $0xc,%esp
801021e3:	68 80 a5 10 80       	push   $0x8010a580
801021e8:	e8 e3 23 00 00       	call   801045d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ed:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
801021f3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021f6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021fd:	85 d2                	test   %edx,%edx
801021ff:	75 09                	jne    8010220a <iderw+0x6a>
80102201:	eb 6d                	jmp    80102270 <iderw+0xd0>
80102203:	90                   	nop
80102204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102208:	89 c2                	mov    %eax,%edx
8010220a:	8b 42 58             	mov    0x58(%edx),%eax
8010220d:	85 c0                	test   %eax,%eax
8010220f:	75 f7                	jne    80102208 <iderw+0x68>
80102211:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102214:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102216:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010221c:	74 42                	je     80102260 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010221e:	8b 03                	mov    (%ebx),%eax
80102220:	83 e0 06             	and    $0x6,%eax
80102223:	83 f8 02             	cmp    $0x2,%eax
80102226:	74 23                	je     8010224b <iderw+0xab>
80102228:	90                   	nop
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102230:	83 ec 08             	sub    $0x8,%esp
80102233:	68 80 a5 10 80       	push   $0x8010a580
80102238:	53                   	push   %ebx
80102239:	e8 42 1e 00 00       	call   80104080 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010223e:	8b 03                	mov    (%ebx),%eax
80102240:	83 c4 10             	add    $0x10,%esp
80102243:	83 e0 06             	and    $0x6,%eax
80102246:	83 f8 02             	cmp    $0x2,%eax
80102249:	75 e5                	jne    80102230 <iderw+0x90>
  }


  release(&idelock);
8010224b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102255:	c9                   	leave  
  release(&idelock);
80102256:	e9 95 24 00 00       	jmp    801046f0 <release>
8010225b:	90                   	nop
8010225c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102260:	89 d8                	mov    %ebx,%eax
80102262:	e8 39 fd ff ff       	call   80101fa0 <idestart>
80102267:	eb b5                	jmp    8010221e <iderw+0x7e>
80102269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102270:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102275:	eb 9d                	jmp    80102214 <iderw+0x74>
    panic("iderw: nothing to do");
80102277:	83 ec 0c             	sub    $0xc,%esp
8010227a:	68 80 75 10 80       	push   $0x80107580
8010227f:	e8 0c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102284:	83 ec 0c             	sub    $0xc,%esp
80102287:	68 6a 75 10 80       	push   $0x8010756a
8010228c:	e8 ff e0 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102291:	83 ec 0c             	sub    $0xc,%esp
80102294:	68 95 75 10 80       	push   $0x80107595
80102299:	e8 f2 e0 ff ff       	call   80100390 <panic>
8010229e:	66 90                	xchg   %ax,%ax

801022a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022a0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022a1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801022a8:	00 c0 fe 
{
801022ab:	89 e5                	mov    %esp,%ebp
801022ad:	56                   	push   %esi
801022ae:	53                   	push   %ebx
  ioapic->reg = reg;
801022af:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801022b6:	00 00 00 
  return ioapic->data;
801022b9:	a1 34 26 11 80       	mov    0x80112634,%eax
801022be:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801022c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801022c7:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022cd:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022d4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801022d7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022da:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801022dd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022e0:	39 c2                	cmp    %eax,%edx
801022e2:	74 16                	je     801022fa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	68 b4 75 10 80       	push   $0x801075b4
801022ec:	e8 7f e3 ff ff       	call   80100670 <cprintf>
801022f1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022f7:	83 c4 10             	add    $0x10,%esp
801022fa:	83 c3 21             	add    $0x21,%ebx
{
801022fd:	ba 10 00 00 00       	mov    $0x10,%edx
80102302:	b8 20 00 00 00       	mov    $0x20,%eax
80102307:	89 f6                	mov    %esi,%esi
80102309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102310:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102312:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102318:	89 c6                	mov    %eax,%esi
8010231a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102320:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102323:	89 71 10             	mov    %esi,0x10(%ecx)
80102326:	8d 72 01             	lea    0x1(%edx),%esi
80102329:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010232c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010232e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102330:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102336:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010233d:	75 d1                	jne    80102310 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010233f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102342:	5b                   	pop    %ebx
80102343:	5e                   	pop    %esi
80102344:	5d                   	pop    %ebp
80102345:	c3                   	ret    
80102346:	8d 76 00             	lea    0x0(%esi),%esi
80102349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102350 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102350:	55                   	push   %ebp
  ioapic->reg = reg;
80102351:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102357:	89 e5                	mov    %esp,%ebp
80102359:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010235c:	8d 50 20             	lea    0x20(%eax),%edx
8010235f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102363:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102365:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010236b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010236e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102371:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102374:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102376:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010237b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010237e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102381:	5d                   	pop    %ebp
80102382:	c3                   	ret    
80102383:	66 90                	xchg   %ax,%ax
80102385:	66 90                	xchg   %ax,%ax
80102387:	66 90                	xchg   %ax,%ax
80102389:	66 90                	xchg   %ax,%ax
8010238b:	66 90                	xchg   %ax,%ax
8010238d:	66 90                	xchg   %ax,%ax
8010238f:	90                   	nop

80102390 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	53                   	push   %ebx
80102394:	83 ec 04             	sub    $0x4,%esp
80102397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010239a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023a0:	75 70                	jne    80102412 <kfree+0x82>
801023a2:	81 fb 50 66 11 80    	cmp    $0x80116650,%ebx
801023a8:	72 68                	jb     80102412 <kfree+0x82>
801023aa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801023b0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801023b5:	77 5b                	ja     80102412 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801023b7:	83 ec 04             	sub    $0x4,%esp
801023ba:	68 00 10 00 00       	push   $0x1000
801023bf:	6a 01                	push   $0x1
801023c1:	53                   	push   %ebx
801023c2:	e8 89 23 00 00       	call   80104750 <memset>

  if(kmem.use_lock)
801023c7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	85 d2                	test   %edx,%edx
801023d2:	75 2c                	jne    80102400 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023d4:	a1 78 26 11 80       	mov    0x80112678,%eax
801023d9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023db:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801023e0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801023e6:	85 c0                	test   %eax,%eax
801023e8:	75 06                	jne    801023f0 <kfree+0x60>
    release(&kmem.lock);
}
801023ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ed:	c9                   	leave  
801023ee:	c3                   	ret    
801023ef:	90                   	nop
    release(&kmem.lock);
801023f0:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801023f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023fa:	c9                   	leave  
    release(&kmem.lock);
801023fb:	e9 f0 22 00 00       	jmp    801046f0 <release>
    acquire(&kmem.lock);
80102400:	83 ec 0c             	sub    $0xc,%esp
80102403:	68 40 26 11 80       	push   $0x80112640
80102408:	e8 c3 21 00 00       	call   801045d0 <acquire>
8010240d:	83 c4 10             	add    $0x10,%esp
80102410:	eb c2                	jmp    801023d4 <kfree+0x44>
    panic("kfree");
80102412:	83 ec 0c             	sub    $0xc,%esp
80102415:	68 e6 75 10 80       	push   $0x801075e6
8010241a:	e8 71 df ff ff       	call   80100390 <panic>
8010241f:	90                   	nop

80102420 <freerange>:
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102425:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102428:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010242b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102431:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102437:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243d:	39 de                	cmp    %ebx,%esi
8010243f:	72 23                	jb     80102464 <freerange+0x44>
80102441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102448:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010244e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102451:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102457:	50                   	push   %eax
80102458:	e8 33 ff ff ff       	call   80102390 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	39 f3                	cmp    %esi,%ebx
80102462:	76 e4                	jbe    80102448 <freerange+0x28>
}
80102464:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102467:	5b                   	pop    %ebx
80102468:	5e                   	pop    %esi
80102469:	5d                   	pop    %ebp
8010246a:	c3                   	ret    
8010246b:	90                   	nop
8010246c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102470 <kinit1>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
80102475:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102478:	83 ec 08             	sub    $0x8,%esp
8010247b:	68 ec 75 10 80       	push   $0x801075ec
80102480:	68 40 26 11 80       	push   $0x80112640
80102485:	e8 56 20 00 00       	call   801044e0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010248a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010248d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102490:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102497:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010249a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ac:	39 de                	cmp    %ebx,%esi
801024ae:	72 1c                	jb     801024cc <kinit1+0x5c>
    kfree(p);
801024b0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024b6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024bf:	50                   	push   %eax
801024c0:	e8 cb fe ff ff       	call   80102390 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c5:	83 c4 10             	add    $0x10,%esp
801024c8:	39 de                	cmp    %ebx,%esi
801024ca:	73 e4                	jae    801024b0 <kinit1+0x40>
}
801024cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024cf:	5b                   	pop    %ebx
801024d0:	5e                   	pop    %esi
801024d1:	5d                   	pop    %ebp
801024d2:	c3                   	ret    
801024d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024e0 <kinit2>:
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	56                   	push   %esi
801024e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024fd:	39 de                	cmp    %ebx,%esi
801024ff:	72 23                	jb     80102524 <kinit2+0x44>
80102501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102508:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010250e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102511:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102517:	50                   	push   %eax
80102518:	e8 73 fe ff ff       	call   80102390 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	39 de                	cmp    %ebx,%esi
80102522:	73 e4                	jae    80102508 <kinit2+0x28>
  kmem.use_lock = 1;
80102524:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010252b:	00 00 00 
}
8010252e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102531:	5b                   	pop    %ebx
80102532:	5e                   	pop    %esi
80102533:	5d                   	pop    %ebp
80102534:	c3                   	ret    
80102535:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102540 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102540:	a1 74 26 11 80       	mov    0x80112674,%eax
80102545:	85 c0                	test   %eax,%eax
80102547:	75 1f                	jne    80102568 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102549:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010254e:	85 c0                	test   %eax,%eax
80102550:	74 0e                	je     80102560 <kalloc+0x20>
    kmem.freelist = r->next;
80102552:	8b 10                	mov    (%eax),%edx
80102554:	89 15 78 26 11 80    	mov    %edx,0x80112678
8010255a:	c3                   	ret    
8010255b:	90                   	nop
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102560:	f3 c3                	repz ret 
80102562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102568:	55                   	push   %ebp
80102569:	89 e5                	mov    %esp,%ebp
8010256b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010256e:	68 40 26 11 80       	push   $0x80112640
80102573:	e8 58 20 00 00       	call   801045d0 <acquire>
  r = kmem.freelist;
80102578:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102586:	85 c0                	test   %eax,%eax
80102588:	74 08                	je     80102592 <kalloc+0x52>
    kmem.freelist = r->next;
8010258a:	8b 08                	mov    (%eax),%ecx
8010258c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102592:	85 d2                	test   %edx,%edx
80102594:	74 16                	je     801025ac <kalloc+0x6c>
    release(&kmem.lock);
80102596:	83 ec 0c             	sub    $0xc,%esp
80102599:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010259c:	68 40 26 11 80       	push   $0x80112640
801025a1:	e8 4a 21 00 00       	call   801046f0 <release>
  return (char*)r;
801025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801025a9:	83 c4 10             	add    $0x10,%esp
}
801025ac:	c9                   	leave  
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax

801025b0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025b0:	ba 64 00 00 00       	mov    $0x64,%edx
801025b5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801025b6:	a8 01                	test   $0x1,%al
801025b8:	0f 84 c2 00 00 00    	je     80102680 <kbdgetc+0xd0>
801025be:	ba 60 00 00 00       	mov    $0x60,%edx
801025c3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801025c4:	0f b6 d0             	movzbl %al,%edx
801025c7:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
801025cd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801025d3:	0f 84 7f 00 00 00    	je     80102658 <kbdgetc+0xa8>
{
801025d9:	55                   	push   %ebp
801025da:	89 e5                	mov    %esp,%ebp
801025dc:	53                   	push   %ebx
801025dd:	89 cb                	mov    %ecx,%ebx
801025df:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025e2:	84 c0                	test   %al,%al
801025e4:	78 4a                	js     80102630 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025e6:	85 db                	test   %ebx,%ebx
801025e8:	74 09                	je     801025f3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025ea:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025ed:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025f0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025f3:	0f b6 82 20 77 10 80 	movzbl -0x7fef88e0(%edx),%eax
801025fa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025fc:	0f b6 82 20 76 10 80 	movzbl -0x7fef89e0(%edx),%eax
80102603:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102605:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102607:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010260d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102610:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102613:	8b 04 85 00 76 10 80 	mov    -0x7fef8a00(,%eax,4),%eax
8010261a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010261e:	74 31                	je     80102651 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102620:	8d 50 9f             	lea    -0x61(%eax),%edx
80102623:	83 fa 19             	cmp    $0x19,%edx
80102626:	77 40                	ja     80102668 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102628:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010262b:	5b                   	pop    %ebx
8010262c:	5d                   	pop    %ebp
8010262d:	c3                   	ret    
8010262e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102630:	83 e0 7f             	and    $0x7f,%eax
80102633:	85 db                	test   %ebx,%ebx
80102635:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102638:	0f b6 82 20 77 10 80 	movzbl -0x7fef88e0(%edx),%eax
8010263f:	83 c8 40             	or     $0x40,%eax
80102642:	0f b6 c0             	movzbl %al,%eax
80102645:	f7 d0                	not    %eax
80102647:	21 c1                	and    %eax,%ecx
    return 0;
80102649:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010264b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102651:	5b                   	pop    %ebx
80102652:	5d                   	pop    %ebp
80102653:	c3                   	ret    
80102654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102658:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010265b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010265d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102663:	c3                   	ret    
80102664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102668:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010266b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010266e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010266f:	83 f9 1a             	cmp    $0x1a,%ecx
80102672:	0f 42 c2             	cmovb  %edx,%eax
}
80102675:	5d                   	pop    %ebp
80102676:	c3                   	ret    
80102677:	89 f6                	mov    %esi,%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102685:	c3                   	ret    
80102686:	8d 76 00             	lea    0x0(%esi),%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102690 <kbdintr>:

void
kbdintr(void)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102696:	68 b0 25 10 80       	push   $0x801025b0
8010269b:	e8 80 e1 ff ff       	call   80100820 <consoleintr>
}
801026a0:	83 c4 10             	add    $0x10,%esp
801026a3:	c9                   	leave  
801026a4:	c3                   	ret    
801026a5:	66 90                	xchg   %ax,%ax
801026a7:	66 90                	xchg   %ax,%ax
801026a9:	66 90                	xchg   %ax,%ax
801026ab:	66 90                	xchg   %ax,%ax
801026ad:	66 90                	xchg   %ax,%ax
801026af:	90                   	nop

801026b0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801026b5:	55                   	push   %ebp
801026b6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026b8:	85 c0                	test   %eax,%eax
801026ba:	0f 84 c8 00 00 00    	je     80102788 <lapicinit+0xd8>
  lapic[index] = value;
801026c0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026c7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026e1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ee:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026fb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102701:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102708:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010270b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010270e:	8b 50 30             	mov    0x30(%eax),%edx
80102711:	c1 ea 10             	shr    $0x10,%edx
80102714:	80 fa 03             	cmp    $0x3,%dl
80102717:	77 77                	ja     80102790 <lapicinit+0xe0>
  lapic[index] = value;
80102719:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102720:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102723:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102726:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010272d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102730:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102733:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010273a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102740:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102747:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102754:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102757:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010275a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102761:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102764:	8b 50 20             	mov    0x20(%eax),%edx
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102770:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102776:	80 e6 10             	and    $0x10,%dh
80102779:	75 f5                	jne    80102770 <lapicinit+0xc0>
  lapic[index] = value;
8010277b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102782:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102785:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102788:	5d                   	pop    %ebp
80102789:	c3                   	ret    
8010278a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102790:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102797:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010279a:	8b 50 20             	mov    0x20(%eax),%edx
8010279d:	e9 77 ff ff ff       	jmp    80102719 <lapicinit+0x69>
801027a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801027b0:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
801027b6:	55                   	push   %ebp
801027b7:	31 c0                	xor    %eax,%eax
801027b9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027bb:	85 d2                	test   %edx,%edx
801027bd:	74 06                	je     801027c5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801027bf:	8b 42 20             	mov    0x20(%edx),%eax
801027c2:	c1 e8 18             	shr    $0x18,%eax
}
801027c5:	5d                   	pop    %ebp
801027c6:	c3                   	ret    
801027c7:	89 f6                	mov    %esi,%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027d5:	55                   	push   %ebp
801027d6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027d8:	85 c0                	test   %eax,%eax
801027da:	74 0d                	je     801027e9 <lapiceoi+0x19>
  lapic[index] = value;
801027dc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027e3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801027e9:	5d                   	pop    %ebp
801027ea:	c3                   	ret    
801027eb:	90                   	nop
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
}
801027f3:	5d                   	pop    %ebp
801027f4:	c3                   	ret    
801027f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102800 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102800:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102801:	b8 0f 00 00 00       	mov    $0xf,%eax
80102806:	ba 70 00 00 00       	mov    $0x70,%edx
8010280b:	89 e5                	mov    %esp,%ebp
8010280d:	53                   	push   %ebx
8010280e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102811:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102814:	ee                   	out    %al,(%dx)
80102815:	b8 0a 00 00 00       	mov    $0xa,%eax
8010281a:	ba 71 00 00 00       	mov    $0x71,%edx
8010281f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102820:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102822:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102825:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010282b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010282d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102830:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102833:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102835:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102838:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010283e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102843:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102849:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010284c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102853:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102856:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102859:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102860:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102866:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010286c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010286f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102875:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102878:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010287e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102881:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102887:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010288a:	5b                   	pop    %ebx
8010288b:	5d                   	pop    %ebp
8010288c:	c3                   	ret    
8010288d:	8d 76 00             	lea    0x0(%esi),%esi

80102890 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102890:	55                   	push   %ebp
80102891:	b8 0b 00 00 00       	mov    $0xb,%eax
80102896:	ba 70 00 00 00       	mov    $0x70,%edx
8010289b:	89 e5                	mov    %esp,%ebp
8010289d:	57                   	push   %edi
8010289e:	56                   	push   %esi
8010289f:	53                   	push   %ebx
801028a0:	83 ec 4c             	sub    $0x4c,%esp
801028a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a4:	ba 71 00 00 00       	mov    $0x71,%edx
801028a9:	ec                   	in     (%dx),%al
801028aa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ad:	bb 70 00 00 00       	mov    $0x70,%ebx
801028b2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801028b5:	8d 76 00             	lea    0x0(%esi),%esi
801028b8:	31 c0                	xor    %eax,%eax
801028ba:	89 da                	mov    %ebx,%edx
801028bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bd:	b9 71 00 00 00       	mov    $0x71,%ecx
801028c2:	89 ca                	mov    %ecx,%edx
801028c4:	ec                   	in     (%dx),%al
801028c5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c8:	89 da                	mov    %ebx,%edx
801028ca:	b8 02 00 00 00       	mov    $0x2,%eax
801028cf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	89 ca                	mov    %ecx,%edx
801028d2:	ec                   	in     (%dx),%al
801028d3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d6:	89 da                	mov    %ebx,%edx
801028d8:	b8 04 00 00 00       	mov    $0x4,%eax
801028dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028de:	89 ca                	mov    %ecx,%edx
801028e0:	ec                   	in     (%dx),%al
801028e1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e4:	89 da                	mov    %ebx,%edx
801028e6:	b8 07 00 00 00       	mov    $0x7,%eax
801028eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ec:	89 ca                	mov    %ecx,%edx
801028ee:	ec                   	in     (%dx),%al
801028ef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f2:	89 da                	mov    %ebx,%edx
801028f4:	b8 08 00 00 00       	mov    $0x8,%eax
801028f9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fa:	89 ca                	mov    %ecx,%edx
801028fc:	ec                   	in     (%dx),%al
801028fd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ff:	89 da                	mov    %ebx,%edx
80102901:	b8 09 00 00 00       	mov    $0x9,%eax
80102906:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102907:	89 ca                	mov    %ecx,%edx
80102909:	ec                   	in     (%dx),%al
8010290a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010290c:	89 da                	mov    %ebx,%edx
8010290e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102913:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102914:	89 ca                	mov    %ecx,%edx
80102916:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102917:	84 c0                	test   %al,%al
80102919:	78 9d                	js     801028b8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010291b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010291f:	89 fa                	mov    %edi,%edx
80102921:	0f b6 fa             	movzbl %dl,%edi
80102924:	89 f2                	mov    %esi,%edx
80102926:	0f b6 f2             	movzbl %dl,%esi
80102929:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010292c:	89 da                	mov    %ebx,%edx
8010292e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102931:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102934:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102938:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010293b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010293f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102942:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102946:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102949:	31 c0                	xor    %eax,%eax
8010294b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294c:	89 ca                	mov    %ecx,%edx
8010294e:	ec                   	in     (%dx),%al
8010294f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102952:	89 da                	mov    %ebx,%edx
80102954:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102957:	b8 02 00 00 00       	mov    $0x2,%eax
8010295c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295d:	89 ca                	mov    %ecx,%edx
8010295f:	ec                   	in     (%dx),%al
80102960:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102963:	89 da                	mov    %ebx,%edx
80102965:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102968:	b8 04 00 00 00       	mov    $0x4,%eax
8010296d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296e:	89 ca                	mov    %ecx,%edx
80102970:	ec                   	in     (%dx),%al
80102971:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102974:	89 da                	mov    %ebx,%edx
80102976:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102979:	b8 07 00 00 00       	mov    $0x7,%eax
8010297e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297f:	89 ca                	mov    %ecx,%edx
80102981:	ec                   	in     (%dx),%al
80102982:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102985:	89 da                	mov    %ebx,%edx
80102987:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010298a:	b8 08 00 00 00       	mov    $0x8,%eax
8010298f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102990:	89 ca                	mov    %ecx,%edx
80102992:	ec                   	in     (%dx),%al
80102993:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102996:	89 da                	mov    %ebx,%edx
80102998:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010299b:	b8 09 00 00 00       	mov    $0x9,%eax
801029a0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a1:	89 ca                	mov    %ecx,%edx
801029a3:	ec                   	in     (%dx),%al
801029a4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029a7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801029aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029ad:	8d 45 d0             	lea    -0x30(%ebp),%eax
801029b0:	6a 18                	push   $0x18
801029b2:	50                   	push   %eax
801029b3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801029b6:	50                   	push   %eax
801029b7:	e8 e4 1d 00 00       	call   801047a0 <memcmp>
801029bc:	83 c4 10             	add    $0x10,%esp
801029bf:	85 c0                	test   %eax,%eax
801029c1:	0f 85 f1 fe ff ff    	jne    801028b8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801029c7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801029cb:	75 78                	jne    80102a45 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801029cd:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029d0:	89 c2                	mov    %eax,%edx
801029d2:	83 e0 0f             	and    $0xf,%eax
801029d5:	c1 ea 04             	shr    $0x4,%edx
801029d8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029db:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029de:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801029e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029e4:	89 c2                	mov    %eax,%edx
801029e6:	83 e0 0f             	and    $0xf,%eax
801029e9:	c1 ea 04             	shr    $0x4,%edx
801029ec:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ef:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029f2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029f5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029f8:	89 c2                	mov    %eax,%edx
801029fa:	83 e0 0f             	and    $0xf,%eax
801029fd:	c1 ea 04             	shr    $0x4,%edx
80102a00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a06:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a0c:	89 c2                	mov    %eax,%edx
80102a0e:	83 e0 0f             	and    $0xf,%eax
80102a11:	c1 ea 04             	shr    $0x4,%edx
80102a14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a20:	89 c2                	mov    %eax,%edx
80102a22:	83 e0 0f             	and    $0xf,%eax
80102a25:	c1 ea 04             	shr    $0x4,%edx
80102a28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a31:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a34:	89 c2                	mov    %eax,%edx
80102a36:	83 e0 0f             	and    $0xf,%eax
80102a39:	c1 ea 04             	shr    $0x4,%edx
80102a3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a42:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a45:	8b 75 08             	mov    0x8(%ebp),%esi
80102a48:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a4b:	89 06                	mov    %eax,(%esi)
80102a4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a50:	89 46 04             	mov    %eax,0x4(%esi)
80102a53:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a56:	89 46 08             	mov    %eax,0x8(%esi)
80102a59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a5c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a62:	89 46 10             	mov    %eax,0x10(%esi)
80102a65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a68:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a6b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a75:	5b                   	pop    %ebx
80102a76:	5e                   	pop    %esi
80102a77:	5f                   	pop    %edi
80102a78:	5d                   	pop    %ebp
80102a79:	c3                   	ret    
80102a7a:	66 90                	xchg   %ax,%ax
80102a7c:	66 90                	xchg   %ax,%ax
80102a7e:	66 90                	xchg   %ax,%ax

80102a80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a80:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a86:	85 c9                	test   %ecx,%ecx
80102a88:	0f 8e 8a 00 00 00    	jle    80102b18 <install_trans+0x98>
{
80102a8e:	55                   	push   %ebp
80102a8f:	89 e5                	mov    %esp,%ebp
80102a91:	57                   	push   %edi
80102a92:	56                   	push   %esi
80102a93:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a94:	31 db                	xor    %ebx,%ebx
{
80102a96:	83 ec 0c             	sub    $0xc,%esp
80102a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102aa0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	01 d8                	add    %ebx,%eax
80102aaa:	83 c0 01             	add    $0x1,%eax
80102aad:	50                   	push   %eax
80102aae:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
80102ab9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102abb:	58                   	pop    %eax
80102abc:	5a                   	pop    %edx
80102abd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102ac4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102aca:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102acd:	e8 fe d5 ff ff       	call   801000d0 <bread>
80102ad2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ad4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102ad7:	83 c4 0c             	add    $0xc,%esp
80102ada:	68 00 02 00 00       	push   $0x200
80102adf:	50                   	push   %eax
80102ae0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ae3:	50                   	push   %eax
80102ae4:	e8 17 1d 00 00       	call   80104800 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ae9:	89 34 24             	mov    %esi,(%esp)
80102aec:	e8 af d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102af1:	89 3c 24             	mov    %edi,(%esp)
80102af4:	e8 e7 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102af9:	89 34 24             	mov    %esi,(%esp)
80102afc:	e8 df d6 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b01:	83 c4 10             	add    $0x10,%esp
80102b04:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102b0a:	7f 94                	jg     80102aa0 <install_trans+0x20>
  }
}
80102b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b0f:	5b                   	pop    %ebx
80102b10:	5e                   	pop    %esi
80102b11:	5f                   	pop    %edi
80102b12:	5d                   	pop    %ebp
80102b13:	c3                   	ret    
80102b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b18:	f3 c3                	repz ret 
80102b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	56                   	push   %esi
80102b24:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102b25:	83 ec 08             	sub    $0x8,%esp
80102b28:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102b2e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b34:	e8 97 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b39:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b3f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b42:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102b44:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102b46:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b49:	7e 16                	jle    80102b61 <write_head+0x41>
80102b4b:	c1 e3 02             	shl    $0x2,%ebx
80102b4e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b50:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102b56:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b5a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b5d:	39 da                	cmp    %ebx,%edx
80102b5f:	75 ef                	jne    80102b50 <write_head+0x30>
  }
  bwrite(buf);
80102b61:	83 ec 0c             	sub    $0xc,%esp
80102b64:	56                   	push   %esi
80102b65:	e8 36 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b6a:	89 34 24             	mov    %esi,(%esp)
80102b6d:	e8 6e d6 ff ff       	call   801001e0 <brelse>
}
80102b72:	83 c4 10             	add    $0x10,%esp
80102b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b78:	5b                   	pop    %ebx
80102b79:	5e                   	pop    %esi
80102b7a:	5d                   	pop    %ebp
80102b7b:	c3                   	ret    
80102b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b80 <initlog>:
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	53                   	push   %ebx
80102b84:	83 ec 2c             	sub    $0x2c,%esp
80102b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b8a:	68 20 78 10 80       	push   $0x80107820
80102b8f:	68 80 26 11 80       	push   $0x80112680
80102b94:	e8 47 19 00 00       	call   801044e0 <initlock>
  readsb(dev, &sb);
80102b99:	58                   	pop    %eax
80102b9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b9d:	5a                   	pop    %edx
80102b9e:	50                   	push   %eax
80102b9f:	53                   	push   %ebx
80102ba0:	e8 9b e8 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102ba5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102bab:	59                   	pop    %ecx
  log.dev = dev;
80102bac:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102bb2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102bb8:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102bbd:	5a                   	pop    %edx
80102bbe:	50                   	push   %eax
80102bbf:	53                   	push   %ebx
80102bc0:	e8 0b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102bc5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102bc8:	83 c4 10             	add    $0x10,%esp
80102bcb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102bcd:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102bd3:	7e 1c                	jle    80102bf1 <initlog+0x71>
80102bd5:	c1 e3 02             	shl    $0x2,%ebx
80102bd8:	31 d2                	xor    %edx,%edx
80102bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102be0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102be4:	83 c2 04             	add    $0x4,%edx
80102be7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102bed:	39 d3                	cmp    %edx,%ebx
80102bef:	75 ef                	jne    80102be0 <initlog+0x60>
  brelse(buf);
80102bf1:	83 ec 0c             	sub    $0xc,%esp
80102bf4:	50                   	push   %eax
80102bf5:	e8 e6 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bfa:	e8 81 fe ff ff       	call   80102a80 <install_trans>
  log.lh.n = 0;
80102bff:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c06:	00 00 00 
  write_head(); // clear the log
80102c09:	e8 12 ff ff ff       	call   80102b20 <write_head>
}
80102c0e:	83 c4 10             	add    $0x10,%esp
80102c11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
80102c16:	8d 76 00             	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c26:	68 80 26 11 80       	push   $0x80112680
80102c2b:	e8 a0 19 00 00       	call   801045d0 <acquire>
80102c30:	83 c4 10             	add    $0x10,%esp
80102c33:	eb 18                	jmp    80102c4d <begin_op+0x2d>
80102c35:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c38:	83 ec 08             	sub    $0x8,%esp
80102c3b:	68 80 26 11 80       	push   $0x80112680
80102c40:	68 80 26 11 80       	push   $0x80112680
80102c45:	e8 36 14 00 00       	call   80104080 <sleep>
80102c4a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c4d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102c52:	85 c0                	test   %eax,%eax
80102c54:	75 e2                	jne    80102c38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c56:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c5b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c61:	83 c0 01             	add    $0x1,%eax
80102c64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c67:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c6a:	83 fa 1e             	cmp    $0x1e,%edx
80102c6d:	7f c9                	jg     80102c38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c6f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c72:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c77:	68 80 26 11 80       	push   $0x80112680
80102c7c:	e8 6f 1a 00 00       	call   801046f0 <release>
      break;
    }
  }
}
80102c81:	83 c4 10             	add    $0x10,%esp
80102c84:	c9                   	leave  
80102c85:	c3                   	ret    
80102c86:	8d 76 00             	lea    0x0(%esi),%esi
80102c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	57                   	push   %edi
80102c94:	56                   	push   %esi
80102c95:	53                   	push   %ebx
80102c96:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c99:	68 80 26 11 80       	push   $0x80112680
80102c9e:	e8 2d 19 00 00       	call   801045d0 <acquire>
  log.outstanding -= 1;
80102ca3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102ca8:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102cae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102cb1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102cb4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102cb6:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102cbc:	0f 85 1a 01 00 00    	jne    80102ddc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102cc2:	85 db                	test   %ebx,%ebx
80102cc4:	0f 85 ee 00 00 00    	jne    80102db8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102cca:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102ccd:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102cd4:	00 00 00 
  release(&log.lock);
80102cd7:	68 80 26 11 80       	push   $0x80112680
80102cdc:	e8 0f 1a 00 00       	call   801046f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ce1:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ce7:	83 c4 10             	add    $0x10,%esp
80102cea:	85 c9                	test   %ecx,%ecx
80102cec:	0f 8e 85 00 00 00    	jle    80102d77 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cf2:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102cf7:	83 ec 08             	sub    $0x8,%esp
80102cfa:	01 d8                	add    %ebx,%eax
80102cfc:	83 c0 01             	add    $0x1,%eax
80102cff:	50                   	push   %eax
80102d00:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102d06:	e8 c5 d3 ff ff       	call   801000d0 <bread>
80102d0b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d0d:	58                   	pop    %eax
80102d0e:	5a                   	pop    %edx
80102d0f:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102d16:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d1c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d1f:	e8 ac d3 ff ff       	call   801000d0 <bread>
80102d24:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d26:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d29:	83 c4 0c             	add    $0xc,%esp
80102d2c:	68 00 02 00 00       	push   $0x200
80102d31:	50                   	push   %eax
80102d32:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d35:	50                   	push   %eax
80102d36:	e8 c5 1a 00 00       	call   80104800 <memmove>
    bwrite(to);  // write the log
80102d3b:	89 34 24             	mov    %esi,(%esp)
80102d3e:	e8 5d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d43:	89 3c 24             	mov    %edi,(%esp)
80102d46:	e8 95 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d4b:	89 34 24             	mov    %esi,(%esp)
80102d4e:	e8 8d d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d53:	83 c4 10             	add    $0x10,%esp
80102d56:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102d5c:	7c 94                	jl     80102cf2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d5e:	e8 bd fd ff ff       	call   80102b20 <write_head>
    install_trans(); // Now install writes to home locations
80102d63:	e8 18 fd ff ff       	call   80102a80 <install_trans>
    log.lh.n = 0;
80102d68:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d6f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d72:	e8 a9 fd ff ff       	call   80102b20 <write_head>
    acquire(&log.lock);
80102d77:	83 ec 0c             	sub    $0xc,%esp
80102d7a:	68 80 26 11 80       	push   $0x80112680
80102d7f:	e8 4c 18 00 00       	call   801045d0 <acquire>
    wakeup(&log);
80102d84:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d8b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d92:	00 00 00 
    wakeup(&log);
80102d95:	e8 b6 14 00 00       	call   80104250 <wakeup>
    release(&log.lock);
80102d9a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102da1:	e8 4a 19 00 00       	call   801046f0 <release>
80102da6:	83 c4 10             	add    $0x10,%esp
}
80102da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dac:	5b                   	pop    %ebx
80102dad:	5e                   	pop    %esi
80102dae:	5f                   	pop    %edi
80102daf:	5d                   	pop    %ebp
80102db0:	c3                   	ret    
80102db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102db8:	83 ec 0c             	sub    $0xc,%esp
80102dbb:	68 80 26 11 80       	push   $0x80112680
80102dc0:	e8 8b 14 00 00       	call   80104250 <wakeup>
  release(&log.lock);
80102dc5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102dcc:	e8 1f 19 00 00       	call   801046f0 <release>
80102dd1:	83 c4 10             	add    $0x10,%esp
}
80102dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dd7:	5b                   	pop    %ebx
80102dd8:	5e                   	pop    %esi
80102dd9:	5f                   	pop    %edi
80102dda:	5d                   	pop    %ebp
80102ddb:	c3                   	ret    
    panic("log.committing");
80102ddc:	83 ec 0c             	sub    $0xc,%esp
80102ddf:	68 24 78 10 80       	push   $0x80107824
80102de4:	e8 a7 d5 ff ff       	call   80100390 <panic>
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102df0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102df7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102dfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e00:	83 fa 1d             	cmp    $0x1d,%edx
80102e03:	0f 8f 9d 00 00 00    	jg     80102ea6 <log_write+0xb6>
80102e09:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102e0e:	83 e8 01             	sub    $0x1,%eax
80102e11:	39 c2                	cmp    %eax,%edx
80102e13:	0f 8d 8d 00 00 00    	jge    80102ea6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e19:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e1e:	85 c0                	test   %eax,%eax
80102e20:	0f 8e 8d 00 00 00    	jle    80102eb3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 80 26 11 80       	push   $0x80112680
80102e2e:	e8 9d 17 00 00       	call   801045d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e33:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e39:	83 c4 10             	add    $0x10,%esp
80102e3c:	83 f9 00             	cmp    $0x0,%ecx
80102e3f:	7e 57                	jle    80102e98 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e41:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e44:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e46:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102e4c:	75 0b                	jne    80102e59 <log_write+0x69>
80102e4e:	eb 38                	jmp    80102e88 <log_write+0x98>
80102e50:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102e57:	74 2f                	je     80102e88 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e59:	83 c0 01             	add    $0x1,%eax
80102e5c:	39 c1                	cmp    %eax,%ecx
80102e5e:	75 f0                	jne    80102e50 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e60:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e67:	83 c0 01             	add    $0x1,%eax
80102e6a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102e6f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e72:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102e79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e7c:	c9                   	leave  
  release(&log.lock);
80102e7d:	e9 6e 18 00 00       	jmp    801046f0 <release>
80102e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e88:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102e8f:	eb de                	jmp    80102e6f <log_write+0x7f>
80102e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e98:	8b 43 08             	mov    0x8(%ebx),%eax
80102e9b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102ea0:	75 cd                	jne    80102e6f <log_write+0x7f>
80102ea2:	31 c0                	xor    %eax,%eax
80102ea4:	eb c1                	jmp    80102e67 <log_write+0x77>
    panic("too big a transaction");
80102ea6:	83 ec 0c             	sub    $0xc,%esp
80102ea9:	68 33 78 10 80       	push   $0x80107833
80102eae:	e8 dd d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102eb3:	83 ec 0c             	sub    $0xc,%esp
80102eb6:	68 49 78 10 80       	push   $0x80107849
80102ebb:	e8 d0 d4 ff ff       	call   80100390 <panic>

80102ec0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	53                   	push   %ebx
80102ec4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ec7:	e8 84 09 00 00       	call   80103850 <cpuid>
80102ecc:	89 c3                	mov    %eax,%ebx
80102ece:	e8 7d 09 00 00       	call   80103850 <cpuid>
80102ed3:	83 ec 04             	sub    $0x4,%esp
80102ed6:	53                   	push   %ebx
80102ed7:	50                   	push   %eax
80102ed8:	68 64 78 10 80       	push   $0x80107864
80102edd:	e8 8e d7 ff ff       	call   80100670 <cprintf>
  idtinit();       // load idt register
80102ee2:	e8 89 2b 00 00       	call   80105a70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ee7:	e8 e4 08 00 00       	call   801037d0 <mycpu>
80102eec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eee:	b8 01 00 00 00       	mov    $0x1,%eax
80102ef3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102efa:	e8 41 0e 00 00       	call   80103d40 <scheduler>
80102eff:	90                   	nop

80102f00 <mpenter>:
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f06:	e8 65 3c 00 00       	call   80106b70 <switchkvm>
  seginit();
80102f0b:	e8 d0 3b 00 00       	call   80106ae0 <seginit>
  lapicinit();
80102f10:	e8 9b f7 ff ff       	call   801026b0 <lapicinit>
  mpmain();
80102f15:	e8 a6 ff ff ff       	call   80102ec0 <mpmain>
80102f1a:	66 90                	xchg   %ax,%ax
80102f1c:	66 90                	xchg   %ax,%ax
80102f1e:	66 90                	xchg   %ax,%ax

80102f20 <main>:
{
80102f20:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f24:	83 e4 f0             	and    $0xfffffff0,%esp
80102f27:	ff 71 fc             	pushl  -0x4(%ecx)
80102f2a:	55                   	push   %ebp
80102f2b:	89 e5                	mov    %esp,%ebp
80102f2d:	53                   	push   %ebx
80102f2e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f2f:	83 ec 08             	sub    $0x8,%esp
80102f32:	68 00 00 40 80       	push   $0x80400000
80102f37:	68 50 66 11 80       	push   $0x80116650
80102f3c:	e8 2f f5 ff ff       	call   80102470 <kinit1>
  kvmalloc();      // kernel page table
80102f41:	e8 1a 42 00 00       	call   80107160 <kvmalloc>
  mpinit();        // detect other processors
80102f46:	e8 75 01 00 00       	call   801030c0 <mpinit>
  lapicinit();     // interrupt controller
80102f4b:	e8 60 f7 ff ff       	call   801026b0 <lapicinit>
  seginit();       // segment descriptors
80102f50:	e8 8b 3b 00 00       	call   80106ae0 <seginit>
  picinit();       // disable pic
80102f55:	e8 46 03 00 00       	call   801032a0 <picinit>
  ioapicinit();    // another interrupt controller
80102f5a:	e8 41 f3 ff ff       	call   801022a0 <ioapicinit>
  consoleinit();   // console hardware
80102f5f:	e8 6c da ff ff       	call   801009d0 <consoleinit>
  uartinit();      // serial port
80102f64:	e8 47 2e 00 00       	call   80105db0 <uartinit>
  pinit();         // process table
80102f69:	e8 42 08 00 00       	call   801037b0 <pinit>
  tvinit();        // trap vectors
80102f6e:	e8 7d 2a 00 00       	call   801059f0 <tvinit>
  binit();         // buffer cache
80102f73:	e8 c8 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f78:	e8 53 de ff ff       	call   80100dd0 <fileinit>
  ideinit();       // disk 
80102f7d:	e8 fe f0 ff ff       	call   80102080 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f82:	83 c4 0c             	add    $0xc,%esp
80102f85:	68 8a 00 00 00       	push   $0x8a
80102f8a:	68 8c a4 10 80       	push   $0x8010a48c
80102f8f:	68 00 70 00 80       	push   $0x80007000
80102f94:	e8 67 18 00 00       	call   80104800 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f99:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102fa0:	00 00 00 
80102fa3:	83 c4 10             	add    $0x10,%esp
80102fa6:	05 80 27 11 80       	add    $0x80112780,%eax
80102fab:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102fb0:	76 71                	jbe    80103023 <main+0x103>
80102fb2:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102fb7:	89 f6                	mov    %esi,%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102fc0:	e8 0b 08 00 00       	call   801037d0 <mycpu>
80102fc5:	39 d8                	cmp    %ebx,%eax
80102fc7:	74 41                	je     8010300a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fc9:	e8 72 f5 ff ff       	call   80102540 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fce:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102fd3:	c7 05 f8 6f 00 80 00 	movl   $0x80102f00,0x80006ff8
80102fda:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fdd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fe4:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fe7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fec:	0f b6 03             	movzbl (%ebx),%eax
80102fef:	83 ec 08             	sub    $0x8,%esp
80102ff2:	68 00 70 00 00       	push   $0x7000
80102ff7:	50                   	push   %eax
80102ff8:	e8 03 f8 ff ff       	call   80102800 <lapicstartap>
80102ffd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103000:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103006:	85 c0                	test   %eax,%eax
80103008:	74 f6                	je     80103000 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010300a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103011:	00 00 00 
80103014:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010301a:	05 80 27 11 80       	add    $0x80112780,%eax
8010301f:	39 c3                	cmp    %eax,%ebx
80103021:	72 9d                	jb     80102fc0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103023:	83 ec 08             	sub    $0x8,%esp
80103026:	68 00 00 00 8e       	push   $0x8e000000
8010302b:	68 00 00 40 80       	push   $0x80400000
80103030:	e8 ab f4 ff ff       	call   801024e0 <kinit2>
  userinit();      // first user process
80103035:	e8 56 09 00 00       	call   80103990 <userinit>
  mpmain();        // finish this processor's setup
8010303a:	e8 81 fe ff ff       	call   80102ec0 <mpmain>
8010303f:	90                   	nop

80103040 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103045:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010304b:	53                   	push   %ebx
  e = addr+len;
8010304c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010304f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103052:	39 de                	cmp    %ebx,%esi
80103054:	72 10                	jb     80103066 <mpsearch1+0x26>
80103056:	eb 50                	jmp    801030a8 <mpsearch1+0x68>
80103058:	90                   	nop
80103059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103060:	39 fb                	cmp    %edi,%ebx
80103062:	89 fe                	mov    %edi,%esi
80103064:	76 42                	jbe    801030a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103066:	83 ec 04             	sub    $0x4,%esp
80103069:	8d 7e 10             	lea    0x10(%esi),%edi
8010306c:	6a 04                	push   $0x4
8010306e:	68 78 78 10 80       	push   $0x80107878
80103073:	56                   	push   %esi
80103074:	e8 27 17 00 00       	call   801047a0 <memcmp>
80103079:	83 c4 10             	add    $0x10,%esp
8010307c:	85 c0                	test   %eax,%eax
8010307e:	75 e0                	jne    80103060 <mpsearch1+0x20>
80103080:	89 f1                	mov    %esi,%ecx
80103082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103088:	0f b6 11             	movzbl (%ecx),%edx
8010308b:	83 c1 01             	add    $0x1,%ecx
8010308e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103090:	39 f9                	cmp    %edi,%ecx
80103092:	75 f4                	jne    80103088 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103094:	84 c0                	test   %al,%al
80103096:	75 c8                	jne    80103060 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103098:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309b:	89 f0                	mov    %esi,%eax
8010309d:	5b                   	pop    %ebx
8010309e:	5e                   	pop    %esi
8010309f:	5f                   	pop    %edi
801030a0:	5d                   	pop    %ebp
801030a1:	c3                   	ret    
801030a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801030ab:	31 f6                	xor    %esi,%esi
}
801030ad:	89 f0                	mov    %esi,%eax
801030af:	5b                   	pop    %ebx
801030b0:	5e                   	pop    %esi
801030b1:	5f                   	pop    %edi
801030b2:	5d                   	pop    %ebp
801030b3:	c3                   	ret    
801030b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801030c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	57                   	push   %edi
801030c4:	56                   	push   %esi
801030c5:	53                   	push   %ebx
801030c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030d7:	c1 e0 08             	shl    $0x8,%eax
801030da:	09 d0                	or     %edx,%eax
801030dc:	c1 e0 04             	shl    $0x4,%eax
801030df:	85 c0                	test   %eax,%eax
801030e1:	75 1b                	jne    801030fe <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030e3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030ea:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030f1:	c1 e0 08             	shl    $0x8,%eax
801030f4:	09 d0                	or     %edx,%eax
801030f6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030f9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030fe:	ba 00 04 00 00       	mov    $0x400,%edx
80103103:	e8 38 ff ff ff       	call   80103040 <mpsearch1>
80103108:	85 c0                	test   %eax,%eax
8010310a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010310d:	0f 84 3d 01 00 00    	je     80103250 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103116:	8b 58 04             	mov    0x4(%eax),%ebx
80103119:	85 db                	test   %ebx,%ebx
8010311b:	0f 84 4f 01 00 00    	je     80103270 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103121:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103127:	83 ec 04             	sub    $0x4,%esp
8010312a:	6a 04                	push   $0x4
8010312c:	68 95 78 10 80       	push   $0x80107895
80103131:	56                   	push   %esi
80103132:	e8 69 16 00 00       	call   801047a0 <memcmp>
80103137:	83 c4 10             	add    $0x10,%esp
8010313a:	85 c0                	test   %eax,%eax
8010313c:	0f 85 2e 01 00 00    	jne    80103270 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103142:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103149:	3c 01                	cmp    $0x1,%al
8010314b:	0f 95 c2             	setne  %dl
8010314e:	3c 04                	cmp    $0x4,%al
80103150:	0f 95 c0             	setne  %al
80103153:	20 c2                	and    %al,%dl
80103155:	0f 85 15 01 00 00    	jne    80103270 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010315b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103162:	66 85 ff             	test   %di,%di
80103165:	74 1a                	je     80103181 <mpinit+0xc1>
80103167:	89 f0                	mov    %esi,%eax
80103169:	01 f7                	add    %esi,%edi
  sum = 0;
8010316b:	31 d2                	xor    %edx,%edx
8010316d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103170:	0f b6 08             	movzbl (%eax),%ecx
80103173:	83 c0 01             	add    $0x1,%eax
80103176:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103178:	39 c7                	cmp    %eax,%edi
8010317a:	75 f4                	jne    80103170 <mpinit+0xb0>
8010317c:	84 d2                	test   %dl,%dl
8010317e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103181:	85 f6                	test   %esi,%esi
80103183:	0f 84 e7 00 00 00    	je     80103270 <mpinit+0x1b0>
80103189:	84 d2                	test   %dl,%dl
8010318b:	0f 85 df 00 00 00    	jne    80103270 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103191:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103197:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010319c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801031a3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801031a9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031ae:	01 d6                	add    %edx,%esi
801031b0:	39 c6                	cmp    %eax,%esi
801031b2:	76 23                	jbe    801031d7 <mpinit+0x117>
    switch(*p){
801031b4:	0f b6 10             	movzbl (%eax),%edx
801031b7:	80 fa 04             	cmp    $0x4,%dl
801031ba:	0f 87 ca 00 00 00    	ja     8010328a <mpinit+0x1ca>
801031c0:	ff 24 95 bc 78 10 80 	jmp    *-0x7fef8744(,%edx,4)
801031c7:	89 f6                	mov    %esi,%esi
801031c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031d0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031d3:	39 c6                	cmp    %eax,%esi
801031d5:	77 dd                	ja     801031b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801031d7:	85 db                	test   %ebx,%ebx
801031d9:	0f 84 9e 00 00 00    	je     8010327d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801031df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031e2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031e6:	74 15                	je     801031fd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031e8:	b8 70 00 00 00       	mov    $0x70,%eax
801031ed:	ba 22 00 00 00       	mov    $0x22,%edx
801031f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031f3:	ba 23 00 00 00       	mov    $0x23,%edx
801031f8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031f9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031fc:	ee                   	out    %al,(%dx)
  }
}
801031fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103200:	5b                   	pop    %ebx
80103201:	5e                   	pop    %esi
80103202:	5f                   	pop    %edi
80103203:	5d                   	pop    %ebp
80103204:	c3                   	ret    
80103205:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103208:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010320e:	83 f9 07             	cmp    $0x7,%ecx
80103211:	7f 19                	jg     8010322c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103213:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103217:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010321d:	83 c1 01             	add    $0x1,%ecx
80103220:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103226:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
8010322c:	83 c0 14             	add    $0x14,%eax
      continue;
8010322f:	e9 7c ff ff ff       	jmp    801031b0 <mpinit+0xf0>
80103234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103238:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010323c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010323f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103245:	e9 66 ff ff ff       	jmp    801031b0 <mpinit+0xf0>
8010324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103250:	ba 00 00 01 00       	mov    $0x10000,%edx
80103255:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010325a:	e8 e1 fd ff ff       	call   80103040 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010325f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103261:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103264:	0f 85 a9 fe ff ff    	jne    80103113 <mpinit+0x53>
8010326a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103270:	83 ec 0c             	sub    $0xc,%esp
80103273:	68 7d 78 10 80       	push   $0x8010787d
80103278:	e8 13 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010327d:	83 ec 0c             	sub    $0xc,%esp
80103280:	68 9c 78 10 80       	push   $0x8010789c
80103285:	e8 06 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010328a:	31 db                	xor    %ebx,%ebx
8010328c:	e9 26 ff ff ff       	jmp    801031b7 <mpinit+0xf7>
80103291:	66 90                	xchg   %ax,%ax
80103293:	66 90                	xchg   %ax,%ax
80103295:	66 90                	xchg   %ax,%ax
80103297:	66 90                	xchg   %ax,%ax
80103299:	66 90                	xchg   %ax,%ax
8010329b:	66 90                	xchg   %ax,%ax
8010329d:	66 90                	xchg   %ax,%ax
8010329f:	90                   	nop

801032a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801032a0:	55                   	push   %ebp
801032a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032a6:	ba 21 00 00 00       	mov    $0x21,%edx
801032ab:	89 e5                	mov    %esp,%ebp
801032ad:	ee                   	out    %al,(%dx)
801032ae:	ba a1 00 00 00       	mov    $0xa1,%edx
801032b3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801032b4:	5d                   	pop    %ebp
801032b5:	c3                   	ret    
801032b6:	66 90                	xchg   %ax,%ax
801032b8:	66 90                	xchg   %ax,%ax
801032ba:	66 90                	xchg   %ax,%ax
801032bc:	66 90                	xchg   %ax,%ax
801032be:	66 90                	xchg   %ax,%ax

801032c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	57                   	push   %edi
801032c4:	56                   	push   %esi
801032c5:	53                   	push   %ebx
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032cf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801032d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032db:	e8 10 db ff ff       	call   80100df0 <filealloc>
801032e0:	85 c0                	test   %eax,%eax
801032e2:	89 03                	mov    %eax,(%ebx)
801032e4:	74 22                	je     80103308 <pipealloc+0x48>
801032e6:	e8 05 db ff ff       	call   80100df0 <filealloc>
801032eb:	85 c0                	test   %eax,%eax
801032ed:	89 06                	mov    %eax,(%esi)
801032ef:	74 3f                	je     80103330 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032f1:	e8 4a f2 ff ff       	call   80102540 <kalloc>
801032f6:	85 c0                	test   %eax,%eax
801032f8:	89 c7                	mov    %eax,%edi
801032fa:	75 54                	jne    80103350 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032fc:	8b 03                	mov    (%ebx),%eax
801032fe:	85 c0                	test   %eax,%eax
80103300:	75 34                	jne    80103336 <pipealloc+0x76>
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103308:	8b 06                	mov    (%esi),%eax
8010330a:	85 c0                	test   %eax,%eax
8010330c:	74 0c                	je     8010331a <pipealloc+0x5a>
    fileclose(*f1);
8010330e:	83 ec 0c             	sub    $0xc,%esp
80103311:	50                   	push   %eax
80103312:	e8 99 db ff ff       	call   80100eb0 <fileclose>
80103317:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010331a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010331d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103322:	5b                   	pop    %ebx
80103323:	5e                   	pop    %esi
80103324:	5f                   	pop    %edi
80103325:	5d                   	pop    %ebp
80103326:	c3                   	ret    
80103327:	89 f6                	mov    %esi,%esi
80103329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103330:	8b 03                	mov    (%ebx),%eax
80103332:	85 c0                	test   %eax,%eax
80103334:	74 e4                	je     8010331a <pipealloc+0x5a>
    fileclose(*f0);
80103336:	83 ec 0c             	sub    $0xc,%esp
80103339:	50                   	push   %eax
8010333a:	e8 71 db ff ff       	call   80100eb0 <fileclose>
  if(*f1)
8010333f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103341:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103344:	85 c0                	test   %eax,%eax
80103346:	75 c6                	jne    8010330e <pipealloc+0x4e>
80103348:	eb d0                	jmp    8010331a <pipealloc+0x5a>
8010334a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103350:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103353:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010335a:	00 00 00 
  p->writeopen = 1;
8010335d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103364:	00 00 00 
  p->nwrite = 0;
80103367:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010336e:	00 00 00 
  p->nread = 0;
80103371:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103378:	00 00 00 
  initlock(&p->lock, "pipe");
8010337b:	68 d0 78 10 80       	push   $0x801078d0
80103380:	50                   	push   %eax
80103381:	e8 5a 11 00 00       	call   801044e0 <initlock>
  (*f0)->type = FD_PIPE;
80103386:	8b 03                	mov    (%ebx),%eax
  return 0;
80103388:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010338b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103391:	8b 03                	mov    (%ebx),%eax
80103393:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103397:	8b 03                	mov    (%ebx),%eax
80103399:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010339d:	8b 03                	mov    (%ebx),%eax
8010339f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033a2:	8b 06                	mov    (%esi),%eax
801033a4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033aa:	8b 06                	mov    (%esi),%eax
801033ac:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033b0:	8b 06                	mov    (%esi),%eax
801033b2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033b6:	8b 06                	mov    (%esi),%eax
801033b8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801033bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033be:	31 c0                	xor    %eax,%eax
}
801033c0:	5b                   	pop    %ebx
801033c1:	5e                   	pop    %esi
801033c2:	5f                   	pop    %edi
801033c3:	5d                   	pop    %ebp
801033c4:	c3                   	ret    
801033c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	56                   	push   %esi
801033d4:	53                   	push   %ebx
801033d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033db:	83 ec 0c             	sub    $0xc,%esp
801033de:	53                   	push   %ebx
801033df:	e8 ec 11 00 00       	call   801045d0 <acquire>
  if(writable){
801033e4:	83 c4 10             	add    $0x10,%esp
801033e7:	85 f6                	test   %esi,%esi
801033e9:	74 45                	je     80103430 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033eb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033f1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033fb:	00 00 00 
    wakeup(&p->nread);
801033fe:	50                   	push   %eax
801033ff:	e8 4c 0e 00 00       	call   80104250 <wakeup>
80103404:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103407:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010340d:	85 d2                	test   %edx,%edx
8010340f:	75 0a                	jne    8010341b <pipeclose+0x4b>
80103411:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103417:	85 c0                	test   %eax,%eax
80103419:	74 35                	je     80103450 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010341b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010341e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103421:	5b                   	pop    %ebx
80103422:	5e                   	pop    %esi
80103423:	5d                   	pop    %ebp
    release(&p->lock);
80103424:	e9 c7 12 00 00       	jmp    801046f0 <release>
80103429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103430:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103436:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103439:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103440:	00 00 00 
    wakeup(&p->nwrite);
80103443:	50                   	push   %eax
80103444:	e8 07 0e 00 00       	call   80104250 <wakeup>
80103449:	83 c4 10             	add    $0x10,%esp
8010344c:	eb b9                	jmp    80103407 <pipeclose+0x37>
8010344e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	53                   	push   %ebx
80103454:	e8 97 12 00 00       	call   801046f0 <release>
    kfree((char*)p);
80103459:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010345c:	83 c4 10             	add    $0x10,%esp
}
8010345f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103462:	5b                   	pop    %ebx
80103463:	5e                   	pop    %esi
80103464:	5d                   	pop    %ebp
    kfree((char*)p);
80103465:	e9 26 ef ff ff       	jmp    80102390 <kfree>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103470 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	57                   	push   %edi
80103474:	56                   	push   %esi
80103475:	53                   	push   %ebx
80103476:	83 ec 28             	sub    $0x28,%esp
80103479:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010347c:	53                   	push   %ebx
8010347d:	e8 4e 11 00 00       	call   801045d0 <acquire>
  for(i = 0; i < n; i++){
80103482:	8b 45 10             	mov    0x10(%ebp),%eax
80103485:	83 c4 10             	add    $0x10,%esp
80103488:	85 c0                	test   %eax,%eax
8010348a:	0f 8e c9 00 00 00    	jle    80103559 <pipewrite+0xe9>
80103490:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103493:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103499:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010349f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801034a2:	03 4d 10             	add    0x10(%ebp),%ecx
801034a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801034ae:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801034b4:	39 d0                	cmp    %edx,%eax
801034b6:	75 71                	jne    80103529 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801034b8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034be:	85 c0                	test   %eax,%eax
801034c0:	74 4e                	je     80103510 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034c2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801034c8:	eb 3a                	jmp    80103504 <pipewrite+0x94>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	57                   	push   %edi
801034d4:	e8 77 0d 00 00       	call   80104250 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034d9:	5a                   	pop    %edx
801034da:	59                   	pop    %ecx
801034db:	53                   	push   %ebx
801034dc:	56                   	push   %esi
801034dd:	e8 9e 0b 00 00       	call   80104080 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034e2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034e8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034ee:	83 c4 10             	add    $0x10,%esp
801034f1:	05 00 02 00 00       	add    $0x200,%eax
801034f6:	39 c2                	cmp    %eax,%edx
801034f8:	75 36                	jne    80103530 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034fa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103500:	85 c0                	test   %eax,%eax
80103502:	74 0c                	je     80103510 <pipewrite+0xa0>
80103504:	e8 67 03 00 00       	call   80103870 <myproc>
80103509:	8b 40 24             	mov    0x24(%eax),%eax
8010350c:	85 c0                	test   %eax,%eax
8010350e:	74 c0                	je     801034d0 <pipewrite+0x60>
        release(&p->lock);
80103510:	83 ec 0c             	sub    $0xc,%esp
80103513:	53                   	push   %ebx
80103514:	e8 d7 11 00 00       	call   801046f0 <release>
        return -1;
80103519:	83 c4 10             	add    $0x10,%esp
8010351c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103521:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103524:	5b                   	pop    %ebx
80103525:	5e                   	pop    %esi
80103526:	5f                   	pop    %edi
80103527:	5d                   	pop    %ebp
80103528:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103529:	89 c2                	mov    %eax,%edx
8010352b:	90                   	nop
8010352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103530:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103533:	8d 42 01             	lea    0x1(%edx),%eax
80103536:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010353c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103542:	83 c6 01             	add    $0x1,%esi
80103545:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103549:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010354c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010354f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103553:	0f 85 4f ff ff ff    	jne    801034a8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103559:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010355f:	83 ec 0c             	sub    $0xc,%esp
80103562:	50                   	push   %eax
80103563:	e8 e8 0c 00 00       	call   80104250 <wakeup>
  release(&p->lock);
80103568:	89 1c 24             	mov    %ebx,(%esp)
8010356b:	e8 80 11 00 00       	call   801046f0 <release>
  return n;
80103570:	83 c4 10             	add    $0x10,%esp
80103573:	8b 45 10             	mov    0x10(%ebp),%eax
80103576:	eb a9                	jmp    80103521 <pipewrite+0xb1>
80103578:	90                   	nop
80103579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103580 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	57                   	push   %edi
80103584:	56                   	push   %esi
80103585:	53                   	push   %ebx
80103586:	83 ec 18             	sub    $0x18,%esp
80103589:	8b 75 08             	mov    0x8(%ebp),%esi
8010358c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010358f:	56                   	push   %esi
80103590:	e8 3b 10 00 00       	call   801045d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103595:	83 c4 10             	add    $0x10,%esp
80103598:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010359e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035a4:	75 6a                	jne    80103610 <piperead+0x90>
801035a6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801035ac:	85 db                	test   %ebx,%ebx
801035ae:	0f 84 c4 00 00 00    	je     80103678 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035b4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035ba:	eb 2d                	jmp    801035e9 <piperead+0x69>
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c0:	83 ec 08             	sub    $0x8,%esp
801035c3:	56                   	push   %esi
801035c4:	53                   	push   %ebx
801035c5:	e8 b6 0a 00 00       	call   80104080 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035ca:	83 c4 10             	add    $0x10,%esp
801035cd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035d3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035d9:	75 35                	jne    80103610 <piperead+0x90>
801035db:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035e1:	85 d2                	test   %edx,%edx
801035e3:	0f 84 8f 00 00 00    	je     80103678 <piperead+0xf8>
    if(myproc()->killed){
801035e9:	e8 82 02 00 00       	call   80103870 <myproc>
801035ee:	8b 48 24             	mov    0x24(%eax),%ecx
801035f1:	85 c9                	test   %ecx,%ecx
801035f3:	74 cb                	je     801035c0 <piperead+0x40>
      release(&p->lock);
801035f5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035f8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035fd:	56                   	push   %esi
801035fe:	e8 ed 10 00 00       	call   801046f0 <release>
      return -1;
80103603:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103606:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103609:	89 d8                	mov    %ebx,%eax
8010360b:	5b                   	pop    %ebx
8010360c:	5e                   	pop    %esi
8010360d:	5f                   	pop    %edi
8010360e:	5d                   	pop    %ebp
8010360f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103610:	8b 45 10             	mov    0x10(%ebp),%eax
80103613:	85 c0                	test   %eax,%eax
80103615:	7e 61                	jle    80103678 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103617:	31 db                	xor    %ebx,%ebx
80103619:	eb 13                	jmp    8010362e <piperead+0xae>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103620:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103626:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010362c:	74 1f                	je     8010364d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010362e:	8d 41 01             	lea    0x1(%ecx),%eax
80103631:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103637:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010363d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103642:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103645:	83 c3 01             	add    $0x1,%ebx
80103648:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010364b:	75 d3                	jne    80103620 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010364d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103653:	83 ec 0c             	sub    $0xc,%esp
80103656:	50                   	push   %eax
80103657:	e8 f4 0b 00 00       	call   80104250 <wakeup>
  release(&p->lock);
8010365c:	89 34 24             	mov    %esi,(%esp)
8010365f:	e8 8c 10 00 00       	call   801046f0 <release>
  return i;
80103664:	83 c4 10             	add    $0x10,%esp
}
80103667:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010366a:	89 d8                	mov    %ebx,%eax
8010366c:	5b                   	pop    %ebx
8010366d:	5e                   	pop    %esi
8010366e:	5f                   	pop    %edi
8010366f:	5d                   	pop    %ebp
80103670:	c3                   	ret    
80103671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103678:	31 db                	xor    %ebx,%ebx
8010367a:	eb d1                	jmp    8010364d <piperead+0xcd>
8010367c:	66 90                	xchg   %ax,%ax
8010367e:	66 90                	xchg   %ax,%ax

80103680 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103684:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103689:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010368c:	68 20 2d 11 80       	push   $0x80112d20
80103691:	e8 3a 0f 00 00       	call   801045d0 <acquire>
80103696:	83 c4 10             	add    $0x10,%esp
80103699:	eb 17                	jmp    801036b2 <allocproc+0x32>
8010369b:	90                   	nop
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036a0:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
801036a6:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
801036ac:	0f 83 7e 00 00 00    	jae    80103730 <allocproc+0xb0>
    if(p->state == UNUSED)
801036b2:	8b 43 0c             	mov    0xc(%ebx),%eax
801036b5:	85 c0                	test   %eax,%eax
801036b7:	75 e7                	jne    801036a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036b9:	a1 04 a0 10 80       	mov    0x8010a004,%eax


  release(&ptable.lock);
801036be:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801036c1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801036c8:	8d 50 01             	lea    0x1(%eax),%edx
801036cb:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801036ce:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801036d3:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801036d9:	e8 12 10 00 00       	call   801046f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036de:	e8 5d ee ff ff       	call   80102540 <kalloc>
801036e3:	83 c4 10             	add    $0x10,%esp
801036e6:	85 c0                	test   %eax,%eax
801036e8:	89 43 08             	mov    %eax,0x8(%ebx)
801036eb:	74 5c                	je     80103749 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036ed:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036f3:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036f6:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036fb:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036fe:	c7 40 14 df 59 10 80 	movl   $0x801059df,0x14(%eax)
  p->context = (struct context*)sp;
80103705:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103708:	6a 14                	push   $0x14
8010370a:	6a 00                	push   $0x0
8010370c:	50                   	push   %eax
8010370d:	e8 3e 10 00 00       	call   80104750 <memset>
  p->context->eip = (uint)forkret;
80103712:	8b 43 1c             	mov    0x1c(%ebx),%eax

  //brand new
  p->priority=NPROCQ-1;

  return p;
80103715:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103718:	c7 40 10 60 37 10 80 	movl   $0x80103760,0x10(%eax)
  p->priority=NPROCQ-1;
8010371f:	c7 83 80 00 00 00 02 	movl   $0x2,0x80(%ebx)
80103726:	00 00 00 
}
80103729:	89 d8                	mov    %ebx,%eax
8010372b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010372e:	c9                   	leave  
8010372f:	c3                   	ret    
  release(&ptable.lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103733:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103735:	68 20 2d 11 80       	push   $0x80112d20
8010373a:	e8 b1 0f 00 00       	call   801046f0 <release>
}
8010373f:	89 d8                	mov    %ebx,%eax
  return 0;
80103741:	83 c4 10             	add    $0x10,%esp
}
80103744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103747:	c9                   	leave  
80103748:	c3                   	ret    
    p->state = UNUSED;
80103749:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103750:	31 db                	xor    %ebx,%ebx
80103752:	eb d5                	jmp    80103729 <allocproc+0xa9>
80103754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010375a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103760 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103766:	68 20 2d 11 80       	push   $0x80112d20
8010376b:	e8 80 0f 00 00       	call   801046f0 <release>

  if (first) {
80103770:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	85 c0                	test   %eax,%eax
8010377a:	75 04                	jne    80103780 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010377c:	c9                   	leave  
8010377d:	c3                   	ret    
8010377e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103780:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103783:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010378a:	00 00 00 
    iinit(ROOTDEV);
8010378d:	6a 01                	push   $0x1
8010378f:	e8 6c dd ff ff       	call   80101500 <iinit>
    initlog(ROOTDEV);
80103794:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010379b:	e8 e0 f3 ff ff       	call   80102b80 <initlog>
801037a0:	83 c4 10             	add    $0x10,%esp
}
801037a3:	c9                   	leave  
801037a4:	c3                   	ret    
801037a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037b0 <pinit>:
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037b6:	68 d5 78 10 80       	push   $0x801078d5
801037bb:	68 20 2d 11 80       	push   $0x80112d20
801037c0:	e8 1b 0d 00 00       	call   801044e0 <initlock>
}
801037c5:	83 c4 10             	add    $0x10,%esp
801037c8:	c9                   	leave  
801037c9:	c3                   	ret    
801037ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037d0 <mycpu>:
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	56                   	push   %esi
801037d4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037d5:	9c                   	pushf  
801037d6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037d7:	f6 c4 02             	test   $0x2,%ah
801037da:	75 5e                	jne    8010383a <mycpu+0x6a>
  apicid = lapicid();
801037dc:	e8 cf ef ff ff       	call   801027b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801037e1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801037e7:	85 f6                	test   %esi,%esi
801037e9:	7e 42                	jle    8010382d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037eb:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801037f2:	39 d0                	cmp    %edx,%eax
801037f4:	74 30                	je     80103826 <mycpu+0x56>
801037f6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
801037fb:	31 d2                	xor    %edx,%edx
801037fd:	8d 76 00             	lea    0x0(%esi),%esi
80103800:	83 c2 01             	add    $0x1,%edx
80103803:	39 f2                	cmp    %esi,%edx
80103805:	74 26                	je     8010382d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103807:	0f b6 19             	movzbl (%ecx),%ebx
8010380a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103810:	39 c3                	cmp    %eax,%ebx
80103812:	75 ec                	jne    80103800 <mycpu+0x30>
80103814:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010381a:	05 80 27 11 80       	add    $0x80112780,%eax
}
8010381f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103822:	5b                   	pop    %ebx
80103823:	5e                   	pop    %esi
80103824:	5d                   	pop    %ebp
80103825:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103826:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
8010382b:	eb f2                	jmp    8010381f <mycpu+0x4f>
  panic("unknown apicid\n");
8010382d:	83 ec 0c             	sub    $0xc,%esp
80103830:	68 dc 78 10 80       	push   $0x801078dc
80103835:	e8 56 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010383a:	83 ec 0c             	sub    $0xc,%esp
8010383d:	68 b8 79 10 80       	push   $0x801079b8
80103842:	e8 49 cb ff ff       	call   80100390 <panic>
80103847:	89 f6                	mov    %esi,%esi
80103849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103850 <cpuid>:
cpuid() {
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103856:	e8 75 ff ff ff       	call   801037d0 <mycpu>
8010385b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103860:	c9                   	leave  
  return mycpu()-cpus;
80103861:	c1 f8 04             	sar    $0x4,%eax
80103864:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010386a:	c3                   	ret    
8010386b:	90                   	nop
8010386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103870 <myproc>:
myproc(void) {
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	53                   	push   %ebx
80103874:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103877:	e8 14 0d 00 00       	call   80104590 <pushcli>
  c = mycpu();
8010387c:	e8 4f ff ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103881:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103887:	e8 04 0e 00 00       	call   80104690 <popcli>
}
8010388c:	83 c4 04             	add    $0x4,%esp
8010388f:	89 d8                	mov    %ebx,%eax
80103891:	5b                   	pop    %ebx
80103892:	5d                   	pop    %ebp
80103893:	c3                   	ret    
80103894:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010389a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038a0 <qpush>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	8b 45 08             	mov    0x8(%ebp),%eax
  if(ptable.count[np->priority]<=0)
801038a7:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801038ad:	8b 0c 95 6c 5d 11 80 	mov    -0x7feea294(,%edx,4),%ecx
801038b4:	85 c9                	test   %ecx,%ecx
801038b6:	74 50                	je     80103908 <qpush+0x68>
    np->next=ptable.pqueue[np->priority].head;
801038b8:	81 c2 06 06 00 00    	add    $0x606,%edx
801038be:	8b 0c d5 24 2d 11 80 	mov    -0x7feed2dc(,%edx,8),%ecx
801038c5:	89 48 7c             	mov    %ecx,0x7c(%eax)
    ptable.pqueue[np->priority].last->next=np;
801038c8:	8b 14 d5 28 2d 11 80 	mov    -0x7feed2d8(,%edx,8),%edx
801038cf:	89 42 7c             	mov    %eax,0x7c(%edx)
    ptable.pqueue[np->priority].last=np;
801038d2:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801038d8:	89 04 d5 58 5d 11 80 	mov    %eax,-0x7feea2a8(,%edx,8)
  np->timepiece=(1<<(NPROCQ-np->priority-1));
801038df:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801038e5:	b9 02 00 00 00       	mov    $0x2,%ecx
801038ea:	bb 01 00 00 00       	mov    $0x1,%ebx
801038ef:	29 d1                	sub    %edx,%ecx
801038f1:	d3 e3                	shl    %cl,%ebx
801038f3:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
  ptable.count[np->priority]++;
801038f9:	83 04 95 6c 5d 11 80 	addl   $0x1,-0x7feea294(,%edx,4)
80103900:	01 
}
80103901:	5b                   	pop    %ebx
80103902:	5d                   	pop    %ebp
80103903:	c3                   	ret    
80103904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->next=np;
80103908:	89 40 7c             	mov    %eax,0x7c(%eax)
    ptable.pqueue[np->priority].head=np;
8010390b:	89 04 d5 54 5d 11 80 	mov    %eax,-0x7feea2ac(,%edx,8)
    ptable.pqueue[np->priority].last=np;
80103912:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103918:	89 04 d5 58 5d 11 80 	mov    %eax,-0x7feea2a8(,%edx,8)
8010391f:	eb be                	jmp    801038df <qpush+0x3f>
80103921:	eb 0d                	jmp    80103930 <wakeup1>
80103923:	90                   	nop
80103924:	90                   	nop
80103925:	90                   	nop
80103926:	90                   	nop
80103927:	90                   	nop
80103928:	90                   	nop
80103929:	90                   	nop
8010392a:	90                   	nop
8010392b:	90                   	nop
8010392c:	90                   	nop
8010392d:	90                   	nop
8010392e:	90                   	nop
8010392f:	90                   	nop

80103930 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	56                   	push   %esi
80103934:	89 c6                	mov    %eax,%esi
80103936:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103937:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010393c:	eb 10                	jmp    8010394e <wakeup1+0x1e>
8010393e:	66 90                	xchg   %ax,%ax
80103940:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
80103946:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
8010394c:	73 3b                	jae    80103989 <wakeup1+0x59>
    if(p->state == SLEEPING && p->chan == chan)
8010394e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103952:	75 ec                	jne    80103940 <wakeup1+0x10>
80103954:	39 73 20             	cmp    %esi,0x20(%ebx)
80103957:	75 e7                	jne    80103940 <wakeup1+0x10>
    {
      p->state = RUNNABLE;

      //brand new
      if(p->priority<NPROCQ-1)
80103959:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
      p->state = RUNNABLE;
8010395f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      if(p->priority<NPROCQ-1)
80103966:	83 f8 01             	cmp    $0x1,%eax
80103969:	77 09                	ja     80103974 <wakeup1+0x44>
        p->priority++;
8010396b:	83 c0 01             	add    $0x1,%eax
8010396e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
      qpush(p);
80103974:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103975:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
      qpush(p);
8010397b:	e8 20 ff ff ff       	call   801038a0 <qpush>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103980:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
      qpush(p);
80103986:	58                   	pop    %eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103987:	72 c5                	jb     8010394e <wakeup1+0x1e>

    }
}
80103989:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010398c:	5b                   	pop    %ebx
8010398d:	5e                   	pop    %esi
8010398e:	5d                   	pop    %ebp
8010398f:	c3                   	ret    

80103990 <userinit>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
80103994:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103997:	e8 e4 fc ff ff       	call   80103680 <allocproc>
8010399c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010399e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801039a3:	e8 38 37 00 00       	call   801070e0 <setupkvm>
801039a8:	85 c0                	test   %eax,%eax
801039aa:	89 43 04             	mov    %eax,0x4(%ebx)
801039ad:	0f 84 c5 00 00 00    	je     80103a78 <userinit+0xe8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039b3:	83 ec 04             	sub    $0x4,%esp
801039b6:	68 2c 00 00 00       	push   $0x2c
801039bb:	68 60 a4 10 80       	push   $0x8010a460
801039c0:	50                   	push   %eax
801039c1:	e8 da 32 00 00       	call   80106ca0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039c6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039cf:	6a 4c                	push   $0x4c
801039d1:	6a 00                	push   $0x0
801039d3:	ff 73 18             	pushl  0x18(%ebx)
801039d6:	e8 75 0d 00 00       	call   80104750 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039db:	8b 43 18             	mov    0x18(%ebx),%eax
801039de:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039e3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039e8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039ef:	8b 43 18             	mov    0x18(%ebx),%eax
801039f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039f6:	8b 43 18             	mov    0x18(%ebx),%eax
801039f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039fd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a01:	8b 43 18             	mov    0x18(%ebx),%eax
80103a04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a16:	8b 43 18             	mov    0x18(%ebx),%eax
80103a19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a20:	8b 43 18             	mov    0x18(%ebx),%eax
80103a23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a2d:	6a 10                	push   $0x10
80103a2f:	68 05 79 10 80       	push   $0x80107905
80103a34:	50                   	push   %eax
80103a35:	e8 f6 0e 00 00       	call   80104930 <safestrcpy>
  p->cwd = namei("/");
80103a3a:	c7 04 24 0e 79 10 80 	movl   $0x8010790e,(%esp)
80103a41:	e8 1a e5 ff ff       	call   80101f60 <namei>
80103a46:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a49:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a50:	e8 7b 0b 00 00       	call   801045d0 <acquire>
  p->state = RUNNABLE;
80103a55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  qpush(p);
80103a5c:	89 1c 24             	mov    %ebx,(%esp)
80103a5f:	e8 3c fe ff ff       	call   801038a0 <qpush>
  release(&ptable.lock);
80103a64:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a6b:	e8 80 0c 00 00       	call   801046f0 <release>
}
80103a70:	83 c4 10             	add    $0x10,%esp
80103a73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a76:	c9                   	leave  
80103a77:	c3                   	ret    
    panic("userinit: out of memory?");
80103a78:	83 ec 0c             	sub    $0xc,%esp
80103a7b:	68 ec 78 10 80       	push   $0x801078ec
80103a80:	e8 0b c9 ff ff       	call   80100390 <panic>
80103a85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a90 <releaseshared>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
80103a94:	53                   	push   %ebx
80103a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103a98:	e8 f3 0a 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103a9d:	e8 2e fd ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103aa2:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103aa8:	e8 e3 0b 00 00       	call   80104690 <popcli>
  if(curproc->sharedrec[idx]!='s')
80103aad:	80 bc 1e 8c 00 00 00 	cmpb   $0x73,0x8c(%esi,%ebx,1)
80103ab4:	73 
80103ab5:	74 09                	je     80103ac0 <releaseshared+0x30>
}
80103ab7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aba:	31 c0                	xor    %eax,%eax
80103abc:	5b                   	pop    %ebx
80103abd:	5e                   	pop    %esi
80103abe:	5d                   	pop    %ebp
80103abf:	c3                   	ret    
  desharevm(idx);
80103ac0:	83 ec 0c             	sub    $0xc,%esp
  curproc->sharedrec[idx]=0;
80103ac3:	c6 84 1e 8c 00 00 00 	movb   $0x0,0x8c(%esi,%ebx,1)
80103aca:	00 
  desharevm(idx);
80103acb:	53                   	push   %ebx
80103acc:	e8 3f 35 00 00       	call   80107010 <desharevm>
  return 0;
80103ad1:	83 c4 10             	add    $0x10,%esp
}
80103ad4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad7:	31 c0                	xor    %eax,%eax
80103ad9:	5b                   	pop    %ebx
80103ada:	5e                   	pop    %esi
80103adb:	5d                   	pop    %ebp
80103adc:	c3                   	ret    
80103add:	8d 76 00             	lea    0x0(%esi),%esi

80103ae0 <getshared>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
80103ae5:	53                   	push   %ebx
80103ae6:	83 ec 0c             	sub    $0xc,%esp
80103ae9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aec:	e8 9f 0a 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103af1:	e8 da fc ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103af6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103afc:	e8 8f 0b 00 00       	call   80104690 <popcli>
  if(curproc->sharedrec[idx]=='s'){
80103b01:	80 bc 33 8c 00 00 00 	cmpb   $0x73,0x8c(%ebx,%esi,1)
80103b08:	73 
80103b09:	74 55                	je     80103b60 <getshared+0x80>
  sharevm(curproc->pgdir, idx, curproc->nshared);
80103b0b:	83 ec 04             	sub    $0x4,%esp
80103b0e:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80103b14:	8d 3c b3             	lea    (%ebx,%esi,4),%edi
80103b17:	56                   	push   %esi
80103b18:	ff 73 04             	pushl  0x4(%ebx)
80103b1b:	e8 c0 32 00 00       	call   80106de0 <sharevm>
  curproc->nshared++;
80103b20:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
  curproc->sharedvm[idx]=(char*)KERNBASE-(curproc->nshared)*PGSIZE;
80103b26:	ba 00 00 00 80       	mov    $0x80000000,%edx
  curproc->nshared++;
80103b2b:	83 c0 01             	add    $0x1,%eax
80103b2e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  curproc->sharedvm[idx]=(char*)KERNBASE-(curproc->nshared)*PGSIZE;
80103b34:	c1 e0 0c             	shl    $0xc,%eax
80103b37:	29 c2                	sub    %eax,%edx
80103b39:	89 97 98 00 00 00    	mov    %edx,0x98(%edi)
  curproc->sharedrec[idx]='s';
80103b3f:	c6 84 33 8c 00 00 00 	movb   $0x73,0x8c(%ebx,%esi,1)
80103b46:	73 
  switchuvm(curproc);
80103b47:	89 1c 24             	mov    %ebx,(%esp)
80103b4a:	e8 41 30 00 00       	call   80106b90 <switchuvm>
  return curproc->sharedvm[idx];
80103b4f:	8b 87 98 00 00 00    	mov    0x98(%edi),%eax
80103b55:	83 c4 10             	add    $0x10,%esp
}
80103b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b5b:	5b                   	pop    %ebx
80103b5c:	5e                   	pop    %esi
80103b5d:	5f                   	pop    %edi
80103b5e:	5d                   	pop    %ebp
80103b5f:	c3                   	ret    
    return curproc->sharedvm[idx];
80103b60:	8b 84 b3 98 00 00 00 	mov    0x98(%ebx,%esi,4),%eax
}
80103b67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b6a:	5b                   	pop    %ebx
80103b6b:	5e                   	pop    %esi
80103b6c:	5f                   	pop    %edi
80103b6d:	5d                   	pop    %ebp
80103b6e:	c3                   	ret    
80103b6f:	90                   	nop

80103b70 <growproc>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	56                   	push   %esi
80103b74:	53                   	push   %ebx
80103b75:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b78:	e8 13 0a 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103b7d:	e8 4e fc ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103b82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b88:	e8 03 0b 00 00       	call   80104690 <popcli>
  if(n > 0){
80103b8d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103b90:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b92:	7f 1c                	jg     80103bb0 <growproc+0x40>
  } else if(n < 0){
80103b94:	75 3a                	jne    80103bd0 <growproc+0x60>
  switchuvm(curproc);
80103b96:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b99:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b9b:	53                   	push   %ebx
80103b9c:	e8 ef 2f 00 00       	call   80106b90 <switchuvm>
  return 0;
80103ba1:	83 c4 10             	add    $0x10,%esp
80103ba4:	31 c0                	xor    %eax,%eax
}
80103ba6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ba9:	5b                   	pop    %ebx
80103baa:	5e                   	pop    %esi
80103bab:	5d                   	pop    %ebp
80103bac:	c3                   	ret    
80103bad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n,curproc->nshared)) == 0)
80103bb0:	01 c6                	add    %eax,%esi
80103bb2:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80103bb8:	56                   	push   %esi
80103bb9:	50                   	push   %eax
80103bba:	ff 73 04             	pushl  0x4(%ebx)
80103bbd:	e8 0e 33 00 00       	call   80106ed0 <allocuvm>
80103bc2:	83 c4 10             	add    $0x10,%esp
80103bc5:	85 c0                	test   %eax,%eax
80103bc7:	75 cd                	jne    80103b96 <growproc+0x26>
      return -1;
80103bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bce:	eb d6                	jmp    80103ba6 <growproc+0x36>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bd0:	83 ec 04             	sub    $0x4,%esp
80103bd3:	01 c6                	add    %eax,%esi
80103bd5:	56                   	push   %esi
80103bd6:	50                   	push   %eax
80103bd7:	ff 73 04             	pushl  0x4(%ebx)
80103bda:	e8 01 34 00 00       	call   80106fe0 <deallocuvm>
80103bdf:	83 c4 10             	add    $0x10,%esp
80103be2:	85 c0                	test   %eax,%eax
80103be4:	75 b0                	jne    80103b96 <growproc+0x26>
80103be6:	eb e1                	jmp    80103bc9 <growproc+0x59>
80103be8:	90                   	nop
80103be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bf0 <fork>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	57                   	push   %edi
80103bf4:	56                   	push   %esi
80103bf5:	53                   	push   %ebx
80103bf6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bf9:	e8 92 09 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103bfe:	e8 cd fb ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103c03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c09:	e8 82 0a 00 00       	call   80104690 <popcli>
  if((np = allocproc()) == 0){
80103c0e:	e8 6d fa ff ff       	call   80103680 <allocproc>
80103c13:	85 c0                	test   %eax,%eax
80103c15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c18:	0f 84 eb 00 00 00    	je     80103d09 <fork+0x119>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c1e:	83 ec 08             	sub    $0x8,%esp
80103c21:	ff 33                	pushl  (%ebx)
80103c23:	ff 73 04             	pushl  0x4(%ebx)
80103c26:	89 c7                	mov    %eax,%edi
80103c28:	e8 83 35 00 00       	call   801071b0 <copyuvm>
80103c2d:	83 c4 10             	add    $0x10,%esp
80103c30:	85 c0                	test   %eax,%eax
80103c32:	89 47 04             	mov    %eax,0x4(%edi)
80103c35:	0f 84 d5 00 00 00    	je     80103d10 <fork+0x120>
  np->sz = curproc->sz;
80103c3b:	8b 03                	mov    (%ebx),%eax
80103c3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103c40:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103c45:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103c47:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103c4a:	8b 7a 18             	mov    0x18(%edx),%edi
80103c4d:	8b 73 18             	mov    0x18(%ebx),%esi
80103c50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c52:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c54:	8b 42 18             	mov    0x18(%edx),%eax
80103c57:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103c5e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80103c60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c64:	85 c0                	test   %eax,%eax
80103c66:	74 13                	je     80103c7b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c68:	83 ec 0c             	sub    $0xc,%esp
80103c6b:	50                   	push   %eax
80103c6c:	e8 ef d1 ff ff       	call   80100e60 <filedup>
80103c71:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c74:	83 c4 10             	add    $0x10,%esp
80103c77:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c7b:	83 c6 01             	add    $0x1,%esi
80103c7e:	83 fe 10             	cmp    $0x10,%esi
80103c81:	75 dd                	jne    80103c60 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c83:	83 ec 0c             	sub    $0xc,%esp
80103c86:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c89:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c8c:	e8 3f da ff ff       	call   801016d0 <idup>
80103c91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c94:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c97:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c9d:	6a 10                	push   $0x10
80103c9f:	53                   	push   %ebx
80103ca0:	50                   	push   %eax
80103ca1:	e8 8a 0c 00 00       	call   80104930 <safestrcpy>
  pid = np->pid;
80103ca6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ca9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cb0:	e8 1b 09 00 00       	call   801045d0 <acquire>
  np->state = RUNNABLE;
80103cb5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  qpush(np);
80103cbc:	89 3c 24             	mov    %edi,(%esp)
80103cbf:	e8 dc fb ff ff       	call   801038a0 <qpush>
80103cc4:	8d 87 8c 00 00 00    	lea    0x8c(%edi),%eax
80103cca:	8d 97 96 00 00 00    	lea    0x96(%edi),%edx
80103cd0:	83 c4 10             	add    $0x10,%esp
80103cd3:	90                   	nop
80103cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->sharedrec[i]=0;
80103cd8:	c6 00 00             	movb   $0x0,(%eax)
80103cdb:	83 c0 01             	add    $0x1,%eax
  for(i=0;i<MAXSHAREDPG;i++)
80103cde:	39 c2                	cmp    %eax,%edx
80103ce0:	75 f6                	jne    80103cd8 <fork+0xe8>
  np->nshared=0;
80103ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  release(&ptable.lock);
80103ce5:	83 ec 0c             	sub    $0xc,%esp
  np->nshared=0;
80103ce8:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80103cef:	00 00 00 
  release(&ptable.lock);
80103cf2:	68 20 2d 11 80       	push   $0x80112d20
80103cf7:	e8 f4 09 00 00       	call   801046f0 <release>
  return pid;
80103cfc:	83 c4 10             	add    $0x10,%esp
}
80103cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d02:	89 d8                	mov    %ebx,%eax
80103d04:	5b                   	pop    %ebx
80103d05:	5e                   	pop    %esi
80103d06:	5f                   	pop    %edi
80103d07:	5d                   	pop    %ebp
80103d08:	c3                   	ret    
    return -1;
80103d09:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d0e:	eb ef                	jmp    80103cff <fork+0x10f>
    kfree(np->kstack);
80103d10:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d13:	83 ec 0c             	sub    $0xc,%esp
80103d16:	ff 73 08             	pushl  0x8(%ebx)
80103d19:	e8 72 e6 ff ff       	call   80102390 <kfree>
    np->kstack = 0;
80103d1e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103d25:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d2c:	83 c4 10             	add    $0x10,%esp
80103d2f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d34:	eb c9                	jmp    80103cff <fork+0x10f>
80103d36:	8d 76 00             	lea    0x0(%esi),%esi
80103d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d40 <scheduler>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103d49:	e8 82 fa ff ff       	call   801037d0 <mycpu>
  c->proc = 0;
80103d4e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d55:	00 00 00 
  struct cpu *c = mycpu();
80103d58:	89 c6                	mov    %eax,%esi
80103d5a:	8d 40 04             	lea    0x4(%eax),%eax
80103d5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103d60:	fb                   	sti    
    acquire(&ptable.lock);
80103d61:	83 ec 0c             	sub    $0xc,%esp
    int queue=NPROCQ-1;
80103d64:	bf 02 00 00 00       	mov    $0x2,%edi
    acquire(&ptable.lock);
80103d69:	68 20 2d 11 80       	push   $0x80112d20
80103d6e:	e8 5d 08 00 00       	call   801045d0 <acquire>
80103d73:	ba 20 2d 11 80       	mov    $0x80112d20,%edx
80103d78:	83 c4 10             	add    $0x10,%esp
80103d7b:	89 d1                	mov    %edx,%ecx
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103d7d:	8b 82 54 30 00 00    	mov    0x3054(%edx),%eax
80103d83:	85 c0                	test   %eax,%eax
80103d85:	74 35                	je     80103dbc <scheduler+0x7c>
80103d87:	8b 99 44 30 00 00    	mov    0x3044(%ecx),%ebx
80103d8d:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d91:	75 13                	jne    80103da6 <scheduler+0x66>
80103d93:	e9 b8 00 00 00       	jmp    80103e50 <scheduler+0x110>
80103d98:	90                   	nop
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103da0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103da4:	74 3a                	je     80103de0 <scheduler+0xa0>
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103da6:	8b 5b 7c             	mov    0x7c(%ebx),%ebx
        ptable.count[queue]--;
80103da9:	83 e8 01             	sub    $0x1,%eax
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103dac:	85 c0                	test   %eax,%eax
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103dae:	89 99 44 30 00 00    	mov    %ebx,0x3044(%ecx)
        ptable.count[queue]--;
80103db4:	89 82 54 30 00 00    	mov    %eax,0x3054(%edx)
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103dba:	75 e4                	jne    80103da0 <scheduler+0x60>
    for(;queue>=0;queue--)
80103dbc:	83 ef 01             	sub    $0x1,%edi
80103dbf:	83 ea 04             	sub    $0x4,%edx
80103dc2:	83 e9 08             	sub    $0x8,%ecx
80103dc5:	83 ff ff             	cmp    $0xffffffff,%edi
80103dc8:	75 b3                	jne    80103d7d <scheduler+0x3d>
    release(&ptable.lock);
80103dca:	83 ec 0c             	sub    $0xc,%esp
80103dcd:	68 20 2d 11 80       	push   $0x80112d20
80103dd2:	e8 19 09 00 00       	call   801046f0 <release>
  for(;;){
80103dd7:	83 c4 10             	add    $0x10,%esp
80103dda:	eb 84                	jmp    80103d60 <scheduler+0x20>
80103ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103de0:	8d 97 06 06 00 00    	lea    0x606(%edi),%edx
80103de6:	8b 1c d5 24 2d 11 80 	mov    -0x7feed2dc(,%edx,8),%ebx
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103ded:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
        switchuvm(p);
80103df0:	83 ec 0c             	sub    $0xc,%esp
        ptable.count[queue]--;
80103df3:	83 e8 01             	sub    $0x1,%eax
80103df6:	89 04 bd 6c 5d 11 80 	mov    %eax,-0x7feea294(,%edi,4)
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103dfd:	89 0c d5 24 2d 11 80 	mov    %ecx,-0x7feed2dc(,%edx,8)
        c->proc = p;
80103e04:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
        switchuvm(p);
80103e0a:	53                   	push   %ebx
80103e0b:	e8 80 2d 00 00       	call   80106b90 <switchuvm>
        p->state = RUNNING;
80103e10:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        swtch(&(c->scheduler), p->context);
80103e17:	58                   	pop    %eax
80103e18:	5a                   	pop    %edx
80103e19:	ff 73 1c             	pushl  0x1c(%ebx)
80103e1c:	ff 75 e4             	pushl  -0x1c(%ebp)
80103e1f:	e8 67 0b 00 00       	call   8010498b <swtch>
        switchkvm();
80103e24:	e8 47 2d 00 00       	call   80106b70 <switchkvm>
        break;
80103e29:	83 c4 10             	add    $0x10,%esp
        c->proc = 0;
80103e2c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e33:	00 00 00 
    release(&ptable.lock);
80103e36:	83 ec 0c             	sub    $0xc,%esp
80103e39:	68 20 2d 11 80       	push   $0x80112d20
80103e3e:	e8 ad 08 00 00       	call   801046f0 <release>
  for(;;){
80103e43:	83 c4 10             	add    $0x10,%esp
80103e46:	e9 15 ff ff ff       	jmp    80103d60 <scheduler+0x20>
80103e4b:	90                   	nop
80103e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e50:	8d 97 06 06 00 00    	lea    0x606(%edi),%edx
80103e56:	eb 95                	jmp    80103ded <scheduler+0xad>
80103e58:	90                   	nop
80103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e60 <sched>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	56                   	push   %esi
80103e64:	53                   	push   %ebx
  pushcli();
80103e65:	e8 26 07 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103e6a:	e8 61 f9 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103e6f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e75:	e8 16 08 00 00       	call   80104690 <popcli>
  if(!holding(&ptable.lock))
80103e7a:	83 ec 0c             	sub    $0xc,%esp
80103e7d:	68 20 2d 11 80       	push   $0x80112d20
80103e82:	e8 c9 06 00 00       	call   80104550 <holding>
80103e87:	83 c4 10             	add    $0x10,%esp
80103e8a:	85 c0                	test   %eax,%eax
80103e8c:	74 4f                	je     80103edd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e8e:	e8 3d f9 ff ff       	call   801037d0 <mycpu>
80103e93:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e9a:	75 68                	jne    80103f04 <sched+0xa4>
  if(p->state == RUNNING)
80103e9c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ea0:	74 55                	je     80103ef7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ea2:	9c                   	pushf  
80103ea3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ea4:	f6 c4 02             	test   $0x2,%ah
80103ea7:	75 41                	jne    80103eea <sched+0x8a>
  intena = mycpu()->intena;
80103ea9:	e8 22 f9 ff ff       	call   801037d0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103eae:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103eb1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103eb7:	e8 14 f9 ff ff       	call   801037d0 <mycpu>
80103ebc:	83 ec 08             	sub    $0x8,%esp
80103ebf:	ff 70 04             	pushl  0x4(%eax)
80103ec2:	53                   	push   %ebx
80103ec3:	e8 c3 0a 00 00       	call   8010498b <swtch>
  mycpu()->intena = intena;
80103ec8:	e8 03 f9 ff ff       	call   801037d0 <mycpu>
}
80103ecd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ed0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ed6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ed9:	5b                   	pop    %ebx
80103eda:	5e                   	pop    %esi
80103edb:	5d                   	pop    %ebp
80103edc:	c3                   	ret    
    panic("sched ptable.lock");
80103edd:	83 ec 0c             	sub    $0xc,%esp
80103ee0:	68 10 79 10 80       	push   $0x80107910
80103ee5:	e8 a6 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103eea:	83 ec 0c             	sub    $0xc,%esp
80103eed:	68 3c 79 10 80       	push   $0x8010793c
80103ef2:	e8 99 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ef7:	83 ec 0c             	sub    $0xc,%esp
80103efa:	68 2e 79 10 80       	push   $0x8010792e
80103eff:	e8 8c c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f04:	83 ec 0c             	sub    $0xc,%esp
80103f07:	68 22 79 10 80       	push   $0x80107922
80103f0c:	e8 7f c4 ff ff       	call   80100390 <panic>
80103f11:	eb 0d                	jmp    80103f20 <exit>
80103f13:	90                   	nop
80103f14:	90                   	nop
80103f15:	90                   	nop
80103f16:	90                   	nop
80103f17:	90                   	nop
80103f18:	90                   	nop
80103f19:	90                   	nop
80103f1a:	90                   	nop
80103f1b:	90                   	nop
80103f1c:	90                   	nop
80103f1d:	90                   	nop
80103f1e:	90                   	nop
80103f1f:	90                   	nop

80103f20 <exit>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f29:	e8 62 06 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103f2e:	e8 9d f8 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103f33:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f39:	e8 52 07 00 00       	call   80104690 <popcli>
  if(curproc == initproc)
80103f3e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103f44:	8d 5e 28             	lea    0x28(%esi),%ebx
80103f47:	8d 7e 68             	lea    0x68(%esi),%edi
80103f4a:	0f 84 b1 00 00 00    	je     80104001 <exit+0xe1>
    if(curproc->ofile[fd]){
80103f50:	8b 03                	mov    (%ebx),%eax
80103f52:	85 c0                	test   %eax,%eax
80103f54:	74 12                	je     80103f68 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103f56:	83 ec 0c             	sub    $0xc,%esp
80103f59:	50                   	push   %eax
80103f5a:	e8 51 cf ff ff       	call   80100eb0 <fileclose>
      curproc->ofile[fd] = 0;
80103f5f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f65:	83 c4 10             	add    $0x10,%esp
80103f68:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103f6b:	39 df                	cmp    %ebx,%edi
80103f6d:	75 e1                	jne    80103f50 <exit+0x30>
  begin_op();
80103f6f:	e8 ac ec ff ff       	call   80102c20 <begin_op>
  iput(curproc->cwd);
80103f74:	83 ec 0c             	sub    $0xc,%esp
80103f77:	ff 76 68             	pushl  0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7a:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  iput(curproc->cwd);
80103f7f:	e8 ac d8 ff ff       	call   80101830 <iput>
  end_op();
80103f84:	e8 07 ed ff ff       	call   80102c90 <end_op>
  curproc->cwd = 0;
80103f89:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103f90:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f97:	e8 34 06 00 00       	call   801045d0 <acquire>
  wakeup1(curproc->parent);
80103f9c:	8b 46 14             	mov    0x14(%esi),%eax
80103f9f:	e8 8c f9 ff ff       	call   80103930 <wakeup1>
80103fa4:	83 c4 10             	add    $0x10,%esp
80103fa7:	eb 15                	jmp    80103fbe <exit+0x9e>
80103fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb0:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
80103fb6:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
80103fbc:	73 2a                	jae    80103fe8 <exit+0xc8>
    if(p->parent == curproc){
80103fbe:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fc1:	75 ed                	jne    80103fb0 <exit+0x90>
      if(p->state == ZOMBIE)
80103fc3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
80103fc7:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103fcc:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103fcf:	75 df                	jne    80103fb0 <exit+0x90>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd1:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
        wakeup1(initproc);
80103fd7:	e8 54 f9 ff ff       	call   80103930 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fdc:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
80103fe2:	72 da                	jb     80103fbe <exit+0x9e>
80103fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
80103fe8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103fef:	e8 6c fe ff ff       	call   80103e60 <sched>
  panic("zombie exit");
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	68 5d 79 10 80       	push   $0x8010795d
80103ffc:	e8 8f c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104001:	83 ec 0c             	sub    $0xc,%esp
80104004:	68 50 79 10 80       	push   $0x80107950
80104009:	e8 82 c3 ff ff       	call   80100390 <panic>
8010400e:	66 90                	xchg   %ax,%ax

80104010 <yield>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104017:	e8 74 05 00 00       	call   80104590 <pushcli>
  c = mycpu();
8010401c:	e8 af f7 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104021:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104027:	e8 64 06 00 00       	call   80104690 <popcli>
  acquire(&ptable.lock);  //DOC: yieldlock
8010402c:	83 ec 0c             	sub    $0xc,%esp
8010402f:	68 20 2d 11 80       	push   $0x80112d20
80104034:	e8 97 05 00 00       	call   801045d0 <acquire>
  if(p->priority>0)
80104039:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010403f:	83 c4 10             	add    $0x10,%esp
  p->state = RUNNABLE;
80104042:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  if(p->priority>0)
80104049:	85 c0                	test   %eax,%eax
8010404b:	74 09                	je     80104056 <yield+0x46>
    p->priority--;
8010404d:	83 e8 01             	sub    $0x1,%eax
80104050:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  qpush(p);
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	53                   	push   %ebx
8010405a:	e8 41 f8 ff ff       	call   801038a0 <qpush>
  sched();
8010405f:	e8 fc fd ff ff       	call   80103e60 <sched>
  release(&ptable.lock);
80104064:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010406b:	e8 80 06 00 00       	call   801046f0 <release>
}
80104070:	83 c4 10             	add    $0x10,%esp
80104073:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104076:	c9                   	leave  
80104077:	c3                   	ret    
80104078:	90                   	nop
80104079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104080 <sleep>:
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	83 ec 0c             	sub    $0xc,%esp
80104089:	8b 7d 08             	mov    0x8(%ebp),%edi
8010408c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010408f:	e8 fc 04 00 00       	call   80104590 <pushcli>
  c = mycpu();
80104094:	e8 37 f7 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104099:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010409f:	e8 ec 05 00 00       	call   80104690 <popcli>
  if(p == 0)
801040a4:	85 db                	test   %ebx,%ebx
801040a6:	0f 84 87 00 00 00    	je     80104133 <sleep+0xb3>
  if(lk == 0)
801040ac:	85 f6                	test   %esi,%esi
801040ae:	74 76                	je     80104126 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040b0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801040b6:	74 50                	je     80104108 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	68 20 2d 11 80       	push   $0x80112d20
801040c0:	e8 0b 05 00 00       	call   801045d0 <acquire>
    release(lk);
801040c5:	89 34 24             	mov    %esi,(%esp)
801040c8:	e8 23 06 00 00       	call   801046f0 <release>
  p->chan = chan;
801040cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040d7:	e8 84 fd ff ff       	call   80103e60 <sched>
  p->chan = 0;
801040dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040e3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040ea:	e8 01 06 00 00       	call   801046f0 <release>
    acquire(lk);
801040ef:	89 75 08             	mov    %esi,0x8(%ebp)
801040f2:	83 c4 10             	add    $0x10,%esp
}
801040f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040f8:	5b                   	pop    %ebx
801040f9:	5e                   	pop    %esi
801040fa:	5f                   	pop    %edi
801040fb:	5d                   	pop    %ebp
    acquire(lk);
801040fc:	e9 cf 04 00 00       	jmp    801045d0 <acquire>
80104101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104108:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010410b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104112:	e8 49 fd ff ff       	call   80103e60 <sched>
  p->chan = 0;
80104117:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010411e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104121:	5b                   	pop    %ebx
80104122:	5e                   	pop    %esi
80104123:	5f                   	pop    %edi
80104124:	5d                   	pop    %ebp
80104125:	c3                   	ret    
    panic("sleep without lk");
80104126:	83 ec 0c             	sub    $0xc,%esp
80104129:	68 6f 79 10 80       	push   $0x8010796f
8010412e:	e8 5d c2 ff ff       	call   80100390 <panic>
    panic("sleep");
80104133:	83 ec 0c             	sub    $0xc,%esp
80104136:	68 69 79 10 80       	push   $0x80107969
8010413b:	e8 50 c2 ff ff       	call   80100390 <panic>

80104140 <wait>:
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	57                   	push   %edi
80104144:	56                   	push   %esi
80104145:	53                   	push   %ebx
80104146:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104149:	e8 42 04 00 00       	call   80104590 <pushcli>
  c = mycpu();
8010414e:	e8 7d f6 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104153:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104159:	e8 32 05 00 00       	call   80104690 <popcli>
  acquire(&ptable.lock);
8010415e:	83 ec 0c             	sub    $0xc,%esp
80104161:	68 20 2d 11 80       	push   $0x80112d20
80104166:	e8 65 04 00 00       	call   801045d0 <acquire>
8010416b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010416e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104170:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104175:	eb 17                	jmp    8010418e <wait+0x4e>
80104177:	89 f6                	mov    %esi,%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104180:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
80104186:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
8010418c:	73 1e                	jae    801041ac <wait+0x6c>
      if(p->parent != curproc)
8010418e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104191:	75 ed                	jne    80104180 <wait+0x40>
      if(p->state == ZOMBIE){
80104193:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104197:	74 37                	je     801041d0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104199:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
      havekids = 1;
8010419f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a4:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
801041aa:	72 e2                	jb     8010418e <wait+0x4e>
    if(!havekids || curproc->killed){
801041ac:	85 c0                	test   %eax,%eax
801041ae:	74 7e                	je     8010422e <wait+0xee>
801041b0:	8b 46 24             	mov    0x24(%esi),%eax
801041b3:	85 c0                	test   %eax,%eax
801041b5:	75 77                	jne    8010422e <wait+0xee>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801041b7:	83 ec 08             	sub    $0x8,%esp
801041ba:	68 20 2d 11 80       	push   $0x80112d20
801041bf:	56                   	push   %esi
801041c0:	e8 bb fe ff ff       	call   80104080 <sleep>
    havekids = 0;
801041c5:	83 c4 10             	add    $0x10,%esp
801041c8:	eb a4                	jmp    8010416e <wait+0x2e>
801041ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801041d0:	83 ec 0c             	sub    $0xc,%esp
801041d3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801041d6:	8b 7b 10             	mov    0x10(%ebx),%edi
        kfree(p->kstack);
801041d9:	e8 b2 e1 ff ff       	call   80102390 <kfree>
        freevm(p->pgdir,curproc->nshared);
801041de:	5a                   	pop    %edx
801041df:	59                   	pop    %ecx
        p->kstack = 0;
801041e0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir,curproc->nshared);
801041e7:	ff b6 88 00 00 00    	pushl  0x88(%esi)
801041ed:	ff 73 04             	pushl  0x4(%ebx)
801041f0:	e8 5b 2e 00 00       	call   80107050 <freevm>
        release(&ptable.lock);
801041f5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
801041fc:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104203:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010420a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010420e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104215:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010421c:	e8 cf 04 00 00       	call   801046f0 <release>
        return pid;
80104221:	83 c4 10             	add    $0x10,%esp
}
80104224:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104227:	89 f8                	mov    %edi,%eax
80104229:	5b                   	pop    %ebx
8010422a:	5e                   	pop    %esi
8010422b:	5f                   	pop    %edi
8010422c:	5d                   	pop    %ebp
8010422d:	c3                   	ret    
      release(&ptable.lock);
8010422e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104231:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      release(&ptable.lock);
80104236:	68 20 2d 11 80       	push   $0x80112d20
8010423b:	e8 b0 04 00 00       	call   801046f0 <release>
      return -1;
80104240:	83 c4 10             	add    $0x10,%esp
80104243:	eb df                	jmp    80104224 <wait+0xe4>
80104245:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 10             	sub    $0x10,%esp
80104257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010425a:	68 20 2d 11 80       	push   $0x80112d20
8010425f:	e8 6c 03 00 00       	call   801045d0 <acquire>
  wakeup1(chan);
80104264:	89 d8                	mov    %ebx,%eax
80104266:	e8 c5 f6 ff ff       	call   80103930 <wakeup1>
  release(&ptable.lock);
8010426b:	83 c4 10             	add    $0x10,%esp
8010426e:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104278:	c9                   	leave  
  release(&ptable.lock);
80104279:	e9 72 04 00 00       	jmp    801046f0 <release>
8010427e:	66 90                	xchg   %ax,%ax

80104280 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	53                   	push   %ebx
80104284:	83 ec 10             	sub    $0x10,%esp
80104287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010428a:	68 20 2d 11 80       	push   $0x80112d20
8010428f:	e8 3c 03 00 00       	call   801045d0 <acquire>
80104294:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104297:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010429c:	eb 0e                	jmp    801042ac <kill+0x2c>
8010429e:	66 90                	xchg   %ax,%ax
801042a0:	05 c0 00 00 00       	add    $0xc0,%eax
801042a5:	3d 54 5d 11 80       	cmp    $0x80115d54,%eax
801042aa:	73 34                	jae    801042e0 <kill+0x60>
    if(p->pid == pid){
801042ac:	39 58 10             	cmp    %ebx,0x10(%eax)
801042af:	75 ef                	jne    801042a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042b1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042b5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042bc:	75 07                	jne    801042c5 <kill+0x45>
        p->state = RUNNABLE;
801042be:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042c5:	83 ec 0c             	sub    $0xc,%esp
801042c8:	68 20 2d 11 80       	push   $0x80112d20
801042cd:	e8 1e 04 00 00       	call   801046f0 <release>
      return 0;
801042d2:	83 c4 10             	add    $0x10,%esp
801042d5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801042d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042da:	c9                   	leave  
801042db:	c3                   	ret    
801042dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801042e0:	83 ec 0c             	sub    $0xc,%esp
801042e3:	68 20 2d 11 80       	push   $0x80112d20
801042e8:	e8 03 04 00 00       	call   801046f0 <release>
  return -1;
801042ed:	83 c4 10             	add    $0x10,%esp
801042f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f8:	c9                   	leave  
801042f9:	c3                   	ret    
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104300 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	57                   	push   %edi
80104304:	56                   	push   %esi
80104305:	53                   	push   %ebx
80104306:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104309:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010430e:	83 ec 3c             	sub    $0x3c,%esp
80104311:	eb 27                	jmp    8010433a <procdump+0x3a>
80104313:	90                   	nop
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	68 03 7d 10 80       	push   $0x80107d03
80104320:	e8 4b c3 ff ff       	call   80100670 <cprintf>
80104325:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104328:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
8010432e:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
80104334:	0f 83 86 00 00 00    	jae    801043c0 <procdump+0xc0>
    if(p->state == UNUSED)
8010433a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010433d:	85 c0                	test   %eax,%eax
8010433f:	74 e7                	je     80104328 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104341:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104344:	ba 80 79 10 80       	mov    $0x80107980,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104349:	77 11                	ja     8010435c <procdump+0x5c>
8010434b:	8b 14 85 e0 79 10 80 	mov    -0x7fef8620(,%eax,4),%edx
      state = "???";
80104352:	b8 80 79 10 80       	mov    $0x80107980,%eax
80104357:	85 d2                	test   %edx,%edx
80104359:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010435c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010435f:	50                   	push   %eax
80104360:	52                   	push   %edx
80104361:	ff 73 10             	pushl  0x10(%ebx)
80104364:	68 84 79 10 80       	push   $0x80107984
80104369:	e8 02 c3 ff ff       	call   80100670 <cprintf>
    if(p->state == SLEEPING){
8010436e:	83 c4 10             	add    $0x10,%esp
80104371:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104375:	75 a1                	jne    80104318 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104377:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010437a:	83 ec 08             	sub    $0x8,%esp
8010437d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104380:	50                   	push   %eax
80104381:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104384:	8b 40 0c             	mov    0xc(%eax),%eax
80104387:	83 c0 08             	add    $0x8,%eax
8010438a:	50                   	push   %eax
8010438b:	e8 70 01 00 00       	call   80104500 <getcallerpcs>
80104390:	83 c4 10             	add    $0x10,%esp
80104393:	90                   	nop
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104398:	8b 17                	mov    (%edi),%edx
8010439a:	85 d2                	test   %edx,%edx
8010439c:	0f 84 76 ff ff ff    	je     80104318 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043a2:	83 ec 08             	sub    $0x8,%esp
801043a5:	83 c7 04             	add    $0x4,%edi
801043a8:	52                   	push   %edx
801043a9:	68 c1 73 10 80       	push   $0x801073c1
801043ae:	e8 bd c2 ff ff       	call   80100670 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043b3:	83 c4 10             	add    $0x10,%esp
801043b6:	39 fe                	cmp    %edi,%esi
801043b8:	75 de                	jne    80104398 <procdump+0x98>
801043ba:	e9 59 ff ff ff       	jmp    80104318 <procdump+0x18>
801043bf:	90                   	nop
  }
}
801043c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043c3:	5b                   	pop    %ebx
801043c4:	5e                   	pop    %esi
801043c5:	5f                   	pop    %edi
801043c6:	5d                   	pop    %ebp
801043c7:	c3                   	ret    
801043c8:	66 90                	xchg   %ax,%ax
801043ca:	66 90                	xchg   %ax,%ax
801043cc:	66 90                	xchg   %ax,%ax
801043ce:	66 90                	xchg   %ax,%ax

801043d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	53                   	push   %ebx
801043d4:	83 ec 0c             	sub    $0xc,%esp
801043d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043da:	68 f8 79 10 80       	push   $0x801079f8
801043df:	8d 43 04             	lea    0x4(%ebx),%eax
801043e2:	50                   	push   %eax
801043e3:	e8 f8 00 00 00       	call   801044e0 <initlock>
  lk->name = name;
801043e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104401:	c9                   	leave  
80104402:	c3                   	ret    
80104403:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104410 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
80104415:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	8d 73 04             	lea    0x4(%ebx),%esi
8010441e:	56                   	push   %esi
8010441f:	e8 ac 01 00 00       	call   801045d0 <acquire>
  while (lk->locked) {
80104424:	8b 13                	mov    (%ebx),%edx
80104426:	83 c4 10             	add    $0x10,%esp
80104429:	85 d2                	test   %edx,%edx
8010442b:	74 16                	je     80104443 <acquiresleep+0x33>
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104430:	83 ec 08             	sub    $0x8,%esp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	e8 46 fc ff ff       	call   80104080 <sleep>
  while (lk->locked) {
8010443a:	8b 03                	mov    (%ebx),%eax
8010443c:	83 c4 10             	add    $0x10,%esp
8010443f:	85 c0                	test   %eax,%eax
80104441:	75 ed                	jne    80104430 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104443:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104449:	e8 22 f4 ff ff       	call   80103870 <myproc>
8010444e:	8b 40 10             	mov    0x10(%eax),%eax
80104451:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104454:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104457:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010445a:	5b                   	pop    %ebx
8010445b:	5e                   	pop    %esi
8010445c:	5d                   	pop    %ebp
  release(&lk->lk);
8010445d:	e9 8e 02 00 00       	jmp    801046f0 <release>
80104462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104470 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
80104475:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104478:	83 ec 0c             	sub    $0xc,%esp
8010447b:	8d 73 04             	lea    0x4(%ebx),%esi
8010447e:	56                   	push   %esi
8010447f:	e8 4c 01 00 00       	call   801045d0 <acquire>
  lk->locked = 0;
80104484:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010448a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104491:	89 1c 24             	mov    %ebx,(%esp)
80104494:	e8 b7 fd ff ff       	call   80104250 <wakeup>
  release(&lk->lk);
80104499:	89 75 08             	mov    %esi,0x8(%ebp)
8010449c:	83 c4 10             	add    $0x10,%esp
}
8010449f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a2:	5b                   	pop    %ebx
801044a3:	5e                   	pop    %esi
801044a4:	5d                   	pop    %ebp
  release(&lk->lk);
801044a5:	e9 46 02 00 00       	jmp    801046f0 <release>
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
801044b5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801044b8:	83 ec 0c             	sub    $0xc,%esp
801044bb:	8d 5e 04             	lea    0x4(%esi),%ebx
801044be:	53                   	push   %ebx
801044bf:	e8 0c 01 00 00       	call   801045d0 <acquire>
  r = lk->locked;
801044c4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801044c6:	89 1c 24             	mov    %ebx,(%esp)
801044c9:	e8 22 02 00 00       	call   801046f0 <release>
  return r;
}
801044ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044d1:	89 f0                	mov    %esi,%eax
801044d3:	5b                   	pop    %ebx
801044d4:	5e                   	pop    %esi
801044d5:	5d                   	pop    %ebp
801044d6:	c3                   	ret    
801044d7:	66 90                	xchg   %ax,%ax
801044d9:	66 90                	xchg   %ax,%ax
801044db:	66 90                	xchg   %ax,%ax
801044dd:	66 90                	xchg   %ax,%ax
801044df:	90                   	nop

801044e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801044e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801044e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801044ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801044f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801044f9:	5d                   	pop    %ebp
801044fa:	c3                   	ret    
801044fb:	90                   	nop
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104500 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104500:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104501:	31 d2                	xor    %edx,%edx
{
80104503:	89 e5                	mov    %esp,%ebp
80104505:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104506:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104509:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010450c:	83 e8 08             	sub    $0x8,%eax
8010450f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104510:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104516:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010451c:	77 1a                	ja     80104538 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010451e:	8b 58 04             	mov    0x4(%eax),%ebx
80104521:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104524:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104527:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104529:	83 fa 0a             	cmp    $0xa,%edx
8010452c:	75 e2                	jne    80104510 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010452e:	5b                   	pop    %ebx
8010452f:	5d                   	pop    %ebp
80104530:	c3                   	ret    
80104531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104538:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010453b:	83 c1 28             	add    $0x28,%ecx
8010453e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104546:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104549:	39 c1                	cmp    %eax,%ecx
8010454b:	75 f3                	jne    80104540 <getcallerpcs+0x40>
}
8010454d:	5b                   	pop    %ebx
8010454e:	5d                   	pop    %ebp
8010454f:	c3                   	ret    

80104550 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 04             	sub    $0x4,%esp
80104557:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010455a:	8b 02                	mov    (%edx),%eax
8010455c:	85 c0                	test   %eax,%eax
8010455e:	75 10                	jne    80104570 <holding+0x20>
}
80104560:	83 c4 04             	add    $0x4,%esp
80104563:	31 c0                	xor    %eax,%eax
80104565:	5b                   	pop    %ebx
80104566:	5d                   	pop    %ebp
80104567:	c3                   	ret    
80104568:	90                   	nop
80104569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104570:	8b 5a 08             	mov    0x8(%edx),%ebx
80104573:	e8 58 f2 ff ff       	call   801037d0 <mycpu>
80104578:	39 c3                	cmp    %eax,%ebx
8010457a:	0f 94 c0             	sete   %al
}
8010457d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104580:	0f b6 c0             	movzbl %al,%eax
}
80104583:	5b                   	pop    %ebx
80104584:	5d                   	pop    %ebp
80104585:	c3                   	ret    
80104586:	8d 76 00             	lea    0x0(%esi),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 04             	sub    $0x4,%esp
80104597:	9c                   	pushf  
80104598:	5b                   	pop    %ebx
  asm volatile("cli");
80104599:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010459a:	e8 31 f2 ff ff       	call   801037d0 <mycpu>
8010459f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045a5:	85 c0                	test   %eax,%eax
801045a7:	75 11                	jne    801045ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801045a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045af:	e8 1c f2 ff ff       	call   801037d0 <mycpu>
801045b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801045ba:	e8 11 f2 ff ff       	call   801037d0 <mycpu>
801045bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045c6:	83 c4 04             	add    $0x4,%esp
801045c9:	5b                   	pop    %ebx
801045ca:	5d                   	pop    %ebp
801045cb:	c3                   	ret    
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045d0 <acquire>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801045d5:	e8 b6 ff ff ff       	call   80104590 <pushcli>
  if(holding(lk))
801045da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801045dd:	8b 03                	mov    (%ebx),%eax
801045df:	85 c0                	test   %eax,%eax
801045e1:	0f 85 81 00 00 00    	jne    80104668 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801045e7:	ba 01 00 00 00       	mov    $0x1,%edx
801045ec:	eb 05                	jmp    801045f3 <acquire+0x23>
801045ee:	66 90                	xchg   %ax,%ax
801045f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045f3:	89 d0                	mov    %edx,%eax
801045f5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801045f8:	85 c0                	test   %eax,%eax
801045fa:	75 f4                	jne    801045f0 <acquire+0x20>
  __sync_synchronize();
801045fc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104601:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104604:	e8 c7 f1 ff ff       	call   801037d0 <mycpu>
  for(i = 0; i < 10; i++){
80104609:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
8010460b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
8010460e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104611:	89 e8                	mov    %ebp,%eax
80104613:	90                   	nop
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104618:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010461e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104624:	77 1a                	ja     80104640 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104626:	8b 58 04             	mov    0x4(%eax),%ebx
80104629:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010462c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010462f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104631:	83 fa 0a             	cmp    $0xa,%edx
80104634:	75 e2                	jne    80104618 <acquire+0x48>
}
80104636:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104639:	5b                   	pop    %ebx
8010463a:	5e                   	pop    %esi
8010463b:	5d                   	pop    %ebp
8010463c:	c3                   	ret    
8010463d:	8d 76 00             	lea    0x0(%esi),%esi
80104640:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104643:	83 c1 28             	add    $0x28,%ecx
80104646:	8d 76 00             	lea    0x0(%esi),%esi
80104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104656:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104659:	39 c8                	cmp    %ecx,%eax
8010465b:	75 f3                	jne    80104650 <acquire+0x80>
}
8010465d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104660:	5b                   	pop    %ebx
80104661:	5e                   	pop    %esi
80104662:	5d                   	pop    %ebp
80104663:	c3                   	ret    
80104664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104668:	8b 73 08             	mov    0x8(%ebx),%esi
8010466b:	e8 60 f1 ff ff       	call   801037d0 <mycpu>
80104670:	39 c6                	cmp    %eax,%esi
80104672:	0f 85 6f ff ff ff    	jne    801045e7 <acquire+0x17>
    panic("acquire");
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	68 03 7a 10 80       	push   $0x80107a03
80104680:	e8 0b bd ff ff       	call   80100390 <panic>
80104685:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104690 <popcli>:

void
popcli(void)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104696:	9c                   	pushf  
80104697:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104698:	f6 c4 02             	test   $0x2,%ah
8010469b:	75 35                	jne    801046d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010469d:	e8 2e f1 ff ff       	call   801037d0 <mycpu>
801046a2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046a9:	78 34                	js     801046df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046ab:	e8 20 f1 ff ff       	call   801037d0 <mycpu>
801046b0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046b6:	85 d2                	test   %edx,%edx
801046b8:	74 06                	je     801046c0 <popcli+0x30>
    sti();
}
801046ba:	c9                   	leave  
801046bb:	c3                   	ret    
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046c0:	e8 0b f1 ff ff       	call   801037d0 <mycpu>
801046c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046cb:	85 c0                	test   %eax,%eax
801046cd:	74 eb                	je     801046ba <popcli+0x2a>
  asm volatile("sti");
801046cf:	fb                   	sti    
}
801046d0:	c9                   	leave  
801046d1:	c3                   	ret    
    panic("popcli - interruptible");
801046d2:	83 ec 0c             	sub    $0xc,%esp
801046d5:	68 0b 7a 10 80       	push   $0x80107a0b
801046da:	e8 b1 bc ff ff       	call   80100390 <panic>
    panic("popcli");
801046df:	83 ec 0c             	sub    $0xc,%esp
801046e2:	68 22 7a 10 80       	push   $0x80107a22
801046e7:	e8 a4 bc ff ff       	call   80100390 <panic>
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046f0 <release>:
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	56                   	push   %esi
801046f4:	53                   	push   %ebx
801046f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801046f8:	8b 03                	mov    (%ebx),%eax
801046fa:	85 c0                	test   %eax,%eax
801046fc:	74 0c                	je     8010470a <release+0x1a>
801046fe:	8b 73 08             	mov    0x8(%ebx),%esi
80104701:	e8 ca f0 ff ff       	call   801037d0 <mycpu>
80104706:	39 c6                	cmp    %eax,%esi
80104708:	74 16                	je     80104720 <release+0x30>
    panic("release");
8010470a:	83 ec 0c             	sub    $0xc,%esp
8010470d:	68 29 7a 10 80       	push   $0x80107a29
80104712:	e8 79 bc ff ff       	call   80100390 <panic>
80104717:	89 f6                	mov    %esi,%esi
80104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104720:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104727:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010472e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104733:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104739:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010473c:	5b                   	pop    %ebx
8010473d:	5e                   	pop    %esi
8010473e:	5d                   	pop    %ebp
  popcli();
8010473f:	e9 4c ff ff ff       	jmp    80104690 <popcli>
80104744:	66 90                	xchg   %ax,%ax
80104746:	66 90                	xchg   %ax,%ax
80104748:	66 90                	xchg   %ax,%ax
8010474a:	66 90                	xchg   %ax,%ax
8010474c:	66 90                	xchg   %ax,%ax
8010474e:	66 90                	xchg   %ax,%ax

80104750 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	53                   	push   %ebx
80104755:	8b 55 08             	mov    0x8(%ebp),%edx
80104758:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010475b:	f6 c2 03             	test   $0x3,%dl
8010475e:	75 05                	jne    80104765 <memset+0x15>
80104760:	f6 c1 03             	test   $0x3,%cl
80104763:	74 13                	je     80104778 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104765:	89 d7                	mov    %edx,%edi
80104767:	8b 45 0c             	mov    0xc(%ebp),%eax
8010476a:	fc                   	cld    
8010476b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010476d:	5b                   	pop    %ebx
8010476e:	89 d0                	mov    %edx,%eax
80104770:	5f                   	pop    %edi
80104771:	5d                   	pop    %ebp
80104772:	c3                   	ret    
80104773:	90                   	nop
80104774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104778:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010477c:	c1 e9 02             	shr    $0x2,%ecx
8010477f:	89 f8                	mov    %edi,%eax
80104781:	89 fb                	mov    %edi,%ebx
80104783:	c1 e0 18             	shl    $0x18,%eax
80104786:	c1 e3 10             	shl    $0x10,%ebx
80104789:	09 d8                	or     %ebx,%eax
8010478b:	09 f8                	or     %edi,%eax
8010478d:	c1 e7 08             	shl    $0x8,%edi
80104790:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104792:	89 d7                	mov    %edx,%edi
80104794:	fc                   	cld    
80104795:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104797:	5b                   	pop    %ebx
80104798:	89 d0                	mov    %edx,%eax
8010479a:	5f                   	pop    %edi
8010479b:	5d                   	pop    %ebp
8010479c:	c3                   	ret    
8010479d:	8d 76 00             	lea    0x0(%esi),%esi

801047a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	56                   	push   %esi
801047a5:	53                   	push   %ebx
801047a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801047a9:	8b 75 08             	mov    0x8(%ebp),%esi
801047ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047af:	85 db                	test   %ebx,%ebx
801047b1:	74 29                	je     801047dc <memcmp+0x3c>
    if(*s1 != *s2)
801047b3:	0f b6 16             	movzbl (%esi),%edx
801047b6:	0f b6 0f             	movzbl (%edi),%ecx
801047b9:	38 d1                	cmp    %dl,%cl
801047bb:	75 2b                	jne    801047e8 <memcmp+0x48>
801047bd:	b8 01 00 00 00       	mov    $0x1,%eax
801047c2:	eb 14                	jmp    801047d8 <memcmp+0x38>
801047c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047c8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801047cc:	83 c0 01             	add    $0x1,%eax
801047cf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801047d4:	38 ca                	cmp    %cl,%dl
801047d6:	75 10                	jne    801047e8 <memcmp+0x48>
  while(n-- > 0){
801047d8:	39 d8                	cmp    %ebx,%eax
801047da:	75 ec                	jne    801047c8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801047dc:	5b                   	pop    %ebx
  return 0;
801047dd:	31 c0                	xor    %eax,%eax
}
801047df:	5e                   	pop    %esi
801047e0:	5f                   	pop    %edi
801047e1:	5d                   	pop    %ebp
801047e2:	c3                   	ret    
801047e3:	90                   	nop
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801047e8:	0f b6 c2             	movzbl %dl,%eax
}
801047eb:	5b                   	pop    %ebx
      return *s1 - *s2;
801047ec:	29 c8                	sub    %ecx,%eax
}
801047ee:	5e                   	pop    %esi
801047ef:	5f                   	pop    %edi
801047f0:	5d                   	pop    %ebp
801047f1:	c3                   	ret    
801047f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 45 08             	mov    0x8(%ebp),%eax
80104808:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010480b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010480e:	39 c3                	cmp    %eax,%ebx
80104810:	73 26                	jae    80104838 <memmove+0x38>
80104812:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104815:	39 c8                	cmp    %ecx,%eax
80104817:	73 1f                	jae    80104838 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104819:	85 f6                	test   %esi,%esi
8010481b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010481e:	74 0f                	je     8010482f <memmove+0x2f>
      *--d = *--s;
80104820:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104824:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104827:	83 ea 01             	sub    $0x1,%edx
8010482a:	83 fa ff             	cmp    $0xffffffff,%edx
8010482d:	75 f1                	jne    80104820 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010482f:	5b                   	pop    %ebx
80104830:	5e                   	pop    %esi
80104831:	5d                   	pop    %ebp
80104832:	c3                   	ret    
80104833:	90                   	nop
80104834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104838:	31 d2                	xor    %edx,%edx
8010483a:	85 f6                	test   %esi,%esi
8010483c:	74 f1                	je     8010482f <memmove+0x2f>
8010483e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104840:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104844:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104847:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010484a:	39 d6                	cmp    %edx,%esi
8010484c:	75 f2                	jne    80104840 <memmove+0x40>
}
8010484e:	5b                   	pop    %ebx
8010484f:	5e                   	pop    %esi
80104850:	5d                   	pop    %ebp
80104851:	c3                   	ret    
80104852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104863:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104864:	eb 9a                	jmp    80104800 <memmove>
80104866:	8d 76 00             	lea    0x0(%esi),%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	57                   	push   %edi
80104874:	56                   	push   %esi
80104875:	8b 7d 10             	mov    0x10(%ebp),%edi
80104878:	53                   	push   %ebx
80104879:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010487c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010487f:	85 ff                	test   %edi,%edi
80104881:	74 2f                	je     801048b2 <strncmp+0x42>
80104883:	0f b6 01             	movzbl (%ecx),%eax
80104886:	0f b6 1e             	movzbl (%esi),%ebx
80104889:	84 c0                	test   %al,%al
8010488b:	74 37                	je     801048c4 <strncmp+0x54>
8010488d:	38 c3                	cmp    %al,%bl
8010488f:	75 33                	jne    801048c4 <strncmp+0x54>
80104891:	01 f7                	add    %esi,%edi
80104893:	eb 13                	jmp    801048a8 <strncmp+0x38>
80104895:	8d 76 00             	lea    0x0(%esi),%esi
80104898:	0f b6 01             	movzbl (%ecx),%eax
8010489b:	84 c0                	test   %al,%al
8010489d:	74 21                	je     801048c0 <strncmp+0x50>
8010489f:	0f b6 1a             	movzbl (%edx),%ebx
801048a2:	89 d6                	mov    %edx,%esi
801048a4:	38 d8                	cmp    %bl,%al
801048a6:	75 1c                	jne    801048c4 <strncmp+0x54>
    n--, p++, q++;
801048a8:	8d 56 01             	lea    0x1(%esi),%edx
801048ab:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048ae:	39 fa                	cmp    %edi,%edx
801048b0:	75 e6                	jne    80104898 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801048b2:	5b                   	pop    %ebx
    return 0;
801048b3:	31 c0                	xor    %eax,%eax
}
801048b5:	5e                   	pop    %esi
801048b6:	5f                   	pop    %edi
801048b7:	5d                   	pop    %ebp
801048b8:	c3                   	ret    
801048b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048c0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801048c4:	29 d8                	sub    %ebx,%eax
}
801048c6:	5b                   	pop    %ebx
801048c7:	5e                   	pop    %esi
801048c8:	5f                   	pop    %edi
801048c9:	5d                   	pop    %ebp
801048ca:	c3                   	ret    
801048cb:	90                   	nop
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
801048d5:	8b 45 08             	mov    0x8(%ebp),%eax
801048d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801048db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801048de:	89 c2                	mov    %eax,%edx
801048e0:	eb 19                	jmp    801048fb <strncpy+0x2b>
801048e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048e8:	83 c3 01             	add    $0x1,%ebx
801048eb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801048ef:	83 c2 01             	add    $0x1,%edx
801048f2:	84 c9                	test   %cl,%cl
801048f4:	88 4a ff             	mov    %cl,-0x1(%edx)
801048f7:	74 09                	je     80104902 <strncpy+0x32>
801048f9:	89 f1                	mov    %esi,%ecx
801048fb:	85 c9                	test   %ecx,%ecx
801048fd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104900:	7f e6                	jg     801048e8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104902:	31 c9                	xor    %ecx,%ecx
80104904:	85 f6                	test   %esi,%esi
80104906:	7e 17                	jle    8010491f <strncpy+0x4f>
80104908:	90                   	nop
80104909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104910:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104914:	89 f3                	mov    %esi,%ebx
80104916:	83 c1 01             	add    $0x1,%ecx
80104919:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010491b:	85 db                	test   %ebx,%ebx
8010491d:	7f f1                	jg     80104910 <strncpy+0x40>
  return os;
}
8010491f:	5b                   	pop    %ebx
80104920:	5e                   	pop    %esi
80104921:	5d                   	pop    %ebp
80104922:	c3                   	ret    
80104923:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104930 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	53                   	push   %ebx
80104935:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104938:	8b 45 08             	mov    0x8(%ebp),%eax
8010493b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010493e:	85 c9                	test   %ecx,%ecx
80104940:	7e 26                	jle    80104968 <safestrcpy+0x38>
80104942:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104946:	89 c1                	mov    %eax,%ecx
80104948:	eb 17                	jmp    80104961 <safestrcpy+0x31>
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104950:	83 c2 01             	add    $0x1,%edx
80104953:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104957:	83 c1 01             	add    $0x1,%ecx
8010495a:	84 db                	test   %bl,%bl
8010495c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010495f:	74 04                	je     80104965 <safestrcpy+0x35>
80104961:	39 f2                	cmp    %esi,%edx
80104963:	75 eb                	jne    80104950 <safestrcpy+0x20>
    ;
  *s = 0;
80104965:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104968:	5b                   	pop    %ebx
80104969:	5e                   	pop    %esi
8010496a:	5d                   	pop    %ebp
8010496b:	c3                   	ret    
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104970 <strlen>:

int
strlen(const char *s)
{
80104970:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104971:	31 c0                	xor    %eax,%eax
{
80104973:	89 e5                	mov    %esp,%ebp
80104975:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104978:	80 3a 00             	cmpb   $0x0,(%edx)
8010497b:	74 0c                	je     80104989 <strlen+0x19>
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
80104980:	83 c0 01             	add    $0x1,%eax
80104983:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104987:	75 f7                	jne    80104980 <strlen+0x10>
    ;
  return n;
}
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret    

8010498b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010498b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010498f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104993:	55                   	push   %ebp
  pushl %ebx
80104994:	53                   	push   %ebx
  pushl %esi
80104995:	56                   	push   %esi
  pushl %edi
80104996:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104997:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104999:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010499b:	5f                   	pop    %edi
  popl %esi
8010499c:	5e                   	pop    %esi
  popl %ebx
8010499d:	5b                   	pop    %ebx
  popl %ebp
8010499e:	5d                   	pop    %ebp
  ret
8010499f:	c3                   	ret    

801049a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
801049a4:	83 ec 04             	sub    $0x4,%esp
801049a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049aa:	e8 c1 ee ff ff       	call   80103870 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049af:	8b 00                	mov    (%eax),%eax
801049b1:	39 d8                	cmp    %ebx,%eax
801049b3:	76 1b                	jbe    801049d0 <fetchint+0x30>
801049b5:	8d 53 04             	lea    0x4(%ebx),%edx
801049b8:	39 d0                	cmp    %edx,%eax
801049ba:	72 14                	jb     801049d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049bf:	8b 13                	mov    (%ebx),%edx
801049c1:	89 10                	mov    %edx,(%eax)
  return 0;
801049c3:	31 c0                	xor    %eax,%eax
}
801049c5:	83 c4 04             	add    $0x4,%esp
801049c8:	5b                   	pop    %ebx
801049c9:	5d                   	pop    %ebp
801049ca:	c3                   	ret    
801049cb:	90                   	nop
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049d5:	eb ee                	jmp    801049c5 <fetchint+0x25>
801049d7:	89 f6                	mov    %esi,%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	83 ec 04             	sub    $0x4,%esp
801049e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801049ea:	e8 81 ee ff ff       	call   80103870 <myproc>

  if(addr >= curproc->sz)
801049ef:	39 18                	cmp    %ebx,(%eax)
801049f1:	76 29                	jbe    80104a1c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801049f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801049f6:	89 da                	mov    %ebx,%edx
801049f8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801049fa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801049fc:	39 c3                	cmp    %eax,%ebx
801049fe:	73 1c                	jae    80104a1c <fetchstr+0x3c>
    if(*s == 0)
80104a00:	80 3b 00             	cmpb   $0x0,(%ebx)
80104a03:	75 10                	jne    80104a15 <fetchstr+0x35>
80104a05:	eb 39                	jmp    80104a40 <fetchstr+0x60>
80104a07:	89 f6                	mov    %esi,%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a10:	80 3a 00             	cmpb   $0x0,(%edx)
80104a13:	74 1b                	je     80104a30 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104a15:	83 c2 01             	add    $0x1,%edx
80104a18:	39 d0                	cmp    %edx,%eax
80104a1a:	77 f4                	ja     80104a10 <fetchstr+0x30>
    return -1;
80104a1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104a21:	83 c4 04             	add    $0x4,%esp
80104a24:	5b                   	pop    %ebx
80104a25:	5d                   	pop    %ebp
80104a26:	c3                   	ret    
80104a27:	89 f6                	mov    %esi,%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a30:	83 c4 04             	add    $0x4,%esp
80104a33:	89 d0                	mov    %edx,%eax
80104a35:	29 d8                	sub    %ebx,%eax
80104a37:	5b                   	pop    %ebx
80104a38:	5d                   	pop    %ebp
80104a39:	c3                   	ret    
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104a40:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104a42:	eb dd                	jmp    80104a21 <fetchstr+0x41>
80104a44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a55:	e8 16 ee ff ff       	call   80103870 <myproc>
80104a5a:	8b 40 18             	mov    0x18(%eax),%eax
80104a5d:	8b 55 08             	mov    0x8(%ebp),%edx
80104a60:	8b 40 44             	mov    0x44(%eax),%eax
80104a63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a66:	e8 05 ee ff ff       	call   80103870 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a6b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a6d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a70:	39 c6                	cmp    %eax,%esi
80104a72:	73 1c                	jae    80104a90 <argint+0x40>
80104a74:	8d 53 08             	lea    0x8(%ebx),%edx
80104a77:	39 d0                	cmp    %edx,%eax
80104a79:	72 15                	jb     80104a90 <argint+0x40>
  *ip = *(int*)(addr);
80104a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a81:	89 10                	mov    %edx,(%eax)
  return 0;
80104a83:	31 c0                	xor    %eax,%eax
}
80104a85:	5b                   	pop    %ebx
80104a86:	5e                   	pop    %esi
80104a87:	5d                   	pop    %ebp
80104a88:	c3                   	ret    
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a95:	eb ee                	jmp    80104a85 <argint+0x35>
80104a97:	89 f6                	mov    %esi,%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	53                   	push   %ebx
80104aa5:	83 ec 10             	sub    $0x10,%esp
80104aa8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104aab:	e8 c0 ed ff ff       	call   80103870 <myproc>
80104ab0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ab2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ab5:	83 ec 08             	sub    $0x8,%esp
80104ab8:	50                   	push   %eax
80104ab9:	ff 75 08             	pushl  0x8(%ebp)
80104abc:	e8 8f ff ff ff       	call   80104a50 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ac1:	83 c4 10             	add    $0x10,%esp
80104ac4:	85 c0                	test   %eax,%eax
80104ac6:	78 28                	js     80104af0 <argptr+0x50>
80104ac8:	85 db                	test   %ebx,%ebx
80104aca:	78 24                	js     80104af0 <argptr+0x50>
80104acc:	8b 16                	mov    (%esi),%edx
80104ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad1:	39 c2                	cmp    %eax,%edx
80104ad3:	76 1b                	jbe    80104af0 <argptr+0x50>
80104ad5:	01 c3                	add    %eax,%ebx
80104ad7:	39 da                	cmp    %ebx,%edx
80104ad9:	72 15                	jb     80104af0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104adb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ade:	89 02                	mov    %eax,(%edx)
  return 0;
80104ae0:	31 c0                	xor    %eax,%eax
}
80104ae2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ae5:	5b                   	pop    %ebx
80104ae6:	5e                   	pop    %esi
80104ae7:	5d                   	pop    %ebp
80104ae8:	c3                   	ret    
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104af5:	eb eb                	jmp    80104ae2 <argptr+0x42>
80104af7:	89 f6                	mov    %esi,%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104b06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b09:	50                   	push   %eax
80104b0a:	ff 75 08             	pushl  0x8(%ebp)
80104b0d:	e8 3e ff ff ff       	call   80104a50 <argint>
80104b12:	83 c4 10             	add    $0x10,%esp
80104b15:	85 c0                	test   %eax,%eax
80104b17:	78 17                	js     80104b30 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104b19:	83 ec 08             	sub    $0x8,%esp
80104b1c:	ff 75 0c             	pushl  0xc(%ebp)
80104b1f:	ff 75 f4             	pushl  -0xc(%ebp)
80104b22:	e8 b9 fe ff ff       	call   801049e0 <fetchstr>
80104b27:	83 c4 10             	add    $0x10,%esp
}
80104b2a:	c9                   	leave  
80104b2b:	c3                   	ret    
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b35:	c9                   	leave  
80104b36:	c3                   	ret    
80104b37:	89 f6                	mov    %esi,%esi
80104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b40 <syscall>:
[SYS_releasesharem]  sys_releasesharem,
};

void
syscall(void)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	53                   	push   %ebx
80104b44:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b47:	e8 24 ed ff ff       	call   80103870 <myproc>
80104b4c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b4e:	8b 40 18             	mov    0x18(%eax),%eax
80104b51:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b54:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b57:	83 fa 17             	cmp    $0x17,%edx
80104b5a:	77 1c                	ja     80104b78 <syscall+0x38>
80104b5c:	8b 14 85 60 7a 10 80 	mov    -0x7fef85a0(,%eax,4),%edx
80104b63:	85 d2                	test   %edx,%edx
80104b65:	74 11                	je     80104b78 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104b67:	ff d2                	call   *%edx
80104b69:	8b 53 18             	mov    0x18(%ebx),%edx
80104b6c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b72:	c9                   	leave  
80104b73:	c3                   	ret    
80104b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b78:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b79:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b7c:	50                   	push   %eax
80104b7d:	ff 73 10             	pushl  0x10(%ebx)
80104b80:	68 31 7a 10 80       	push   $0x80107a31
80104b85:	e8 e6 ba ff ff       	call   80100670 <cprintf>
    curproc->tf->eax = -1;
80104b8a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b8d:	83 c4 10             	add    $0x10,%esp
80104b90:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b9a:	c9                   	leave  
80104b9b:	c3                   	ret    
80104b9c:	66 90                	xchg   %ax,%ax
80104b9e:	66 90                	xchg   %ax,%ax

80104ba0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	56                   	push   %esi
80104ba5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ba6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104ba9:	83 ec 44             	sub    $0x44,%esp
80104bac:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104baf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104bb2:	56                   	push   %esi
80104bb3:	50                   	push   %eax
{
80104bb4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104bb7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104bba:	e8 c1 d3 ff ff       	call   80101f80 <nameiparent>
80104bbf:	83 c4 10             	add    $0x10,%esp
80104bc2:	85 c0                	test   %eax,%eax
80104bc4:	0f 84 46 01 00 00    	je     80104d10 <create+0x170>
    return 0;
  ilock(dp);
80104bca:	83 ec 0c             	sub    $0xc,%esp
80104bcd:	89 c3                	mov    %eax,%ebx
80104bcf:	50                   	push   %eax
80104bd0:	e8 2b cb ff ff       	call   80101700 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104bd5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104bd8:	83 c4 0c             	add    $0xc,%esp
80104bdb:	50                   	push   %eax
80104bdc:	56                   	push   %esi
80104bdd:	53                   	push   %ebx
80104bde:	e8 4d d0 ff ff       	call   80101c30 <dirlookup>
80104be3:	83 c4 10             	add    $0x10,%esp
80104be6:	85 c0                	test   %eax,%eax
80104be8:	89 c7                	mov    %eax,%edi
80104bea:	74 34                	je     80104c20 <create+0x80>
    iunlockput(dp);
80104bec:	83 ec 0c             	sub    $0xc,%esp
80104bef:	53                   	push   %ebx
80104bf0:	e8 9b cd ff ff       	call   80101990 <iunlockput>
    ilock(ip);
80104bf5:	89 3c 24             	mov    %edi,(%esp)
80104bf8:	e8 03 cb ff ff       	call   80101700 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104bfd:	83 c4 10             	add    $0x10,%esp
80104c00:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104c05:	0f 85 95 00 00 00    	jne    80104ca0 <create+0x100>
80104c0b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104c10:	0f 85 8a 00 00 00    	jne    80104ca0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c19:	89 f8                	mov    %edi,%eax
80104c1b:	5b                   	pop    %ebx
80104c1c:	5e                   	pop    %esi
80104c1d:	5f                   	pop    %edi
80104c1e:	5d                   	pop    %ebp
80104c1f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104c20:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104c24:	83 ec 08             	sub    $0x8,%esp
80104c27:	50                   	push   %eax
80104c28:	ff 33                	pushl  (%ebx)
80104c2a:	e8 61 c9 ff ff       	call   80101590 <ialloc>
80104c2f:	83 c4 10             	add    $0x10,%esp
80104c32:	85 c0                	test   %eax,%eax
80104c34:	89 c7                	mov    %eax,%edi
80104c36:	0f 84 e8 00 00 00    	je     80104d24 <create+0x184>
  ilock(ip);
80104c3c:	83 ec 0c             	sub    $0xc,%esp
80104c3f:	50                   	push   %eax
80104c40:	e8 bb ca ff ff       	call   80101700 <ilock>
  ip->major = major;
80104c45:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104c49:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104c4d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104c51:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104c55:	b8 01 00 00 00       	mov    $0x1,%eax
80104c5a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104c5e:	89 3c 24             	mov    %edi,(%esp)
80104c61:	e8 ea c9 ff ff       	call   80101650 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c66:	83 c4 10             	add    $0x10,%esp
80104c69:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104c6e:	74 50                	je     80104cc0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c70:	83 ec 04             	sub    $0x4,%esp
80104c73:	ff 77 04             	pushl  0x4(%edi)
80104c76:	56                   	push   %esi
80104c77:	53                   	push   %ebx
80104c78:	e8 23 d2 ff ff       	call   80101ea0 <dirlink>
80104c7d:	83 c4 10             	add    $0x10,%esp
80104c80:	85 c0                	test   %eax,%eax
80104c82:	0f 88 8f 00 00 00    	js     80104d17 <create+0x177>
  iunlockput(dp);
80104c88:	83 ec 0c             	sub    $0xc,%esp
80104c8b:	53                   	push   %ebx
80104c8c:	e8 ff cc ff ff       	call   80101990 <iunlockput>
  return ip;
80104c91:	83 c4 10             	add    $0x10,%esp
}
80104c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c97:	89 f8                	mov    %edi,%eax
80104c99:	5b                   	pop    %ebx
80104c9a:	5e                   	pop    %esi
80104c9b:	5f                   	pop    %edi
80104c9c:	5d                   	pop    %ebp
80104c9d:	c3                   	ret    
80104c9e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104ca0:	83 ec 0c             	sub    $0xc,%esp
80104ca3:	57                   	push   %edi
    return 0;
80104ca4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104ca6:	e8 e5 cc ff ff       	call   80101990 <iunlockput>
    return 0;
80104cab:	83 c4 10             	add    $0x10,%esp
}
80104cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cb1:	89 f8                	mov    %edi,%eax
80104cb3:	5b                   	pop    %ebx
80104cb4:	5e                   	pop    %esi
80104cb5:	5f                   	pop    %edi
80104cb6:	5d                   	pop    %ebp
80104cb7:	c3                   	ret    
80104cb8:	90                   	nop
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104cc0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104cc5:	83 ec 0c             	sub    $0xc,%esp
80104cc8:	53                   	push   %ebx
80104cc9:	e8 82 c9 ff ff       	call   80101650 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cce:	83 c4 0c             	add    $0xc,%esp
80104cd1:	ff 77 04             	pushl  0x4(%edi)
80104cd4:	68 e0 7a 10 80       	push   $0x80107ae0
80104cd9:	57                   	push   %edi
80104cda:	e8 c1 d1 ff ff       	call   80101ea0 <dirlink>
80104cdf:	83 c4 10             	add    $0x10,%esp
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	78 1c                	js     80104d02 <create+0x162>
80104ce6:	83 ec 04             	sub    $0x4,%esp
80104ce9:	ff 73 04             	pushl  0x4(%ebx)
80104cec:	68 df 7a 10 80       	push   $0x80107adf
80104cf1:	57                   	push   %edi
80104cf2:	e8 a9 d1 ff ff       	call   80101ea0 <dirlink>
80104cf7:	83 c4 10             	add    $0x10,%esp
80104cfa:	85 c0                	test   %eax,%eax
80104cfc:	0f 89 6e ff ff ff    	jns    80104c70 <create+0xd0>
      panic("create dots");
80104d02:	83 ec 0c             	sub    $0xc,%esp
80104d05:	68 d3 7a 10 80       	push   $0x80107ad3
80104d0a:	e8 81 b6 ff ff       	call   80100390 <panic>
80104d0f:	90                   	nop
    return 0;
80104d10:	31 ff                	xor    %edi,%edi
80104d12:	e9 ff fe ff ff       	jmp    80104c16 <create+0x76>
    panic("create: dirlink");
80104d17:	83 ec 0c             	sub    $0xc,%esp
80104d1a:	68 e2 7a 10 80       	push   $0x80107ae2
80104d1f:	e8 6c b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104d24:	83 ec 0c             	sub    $0xc,%esp
80104d27:	68 c4 7a 10 80       	push   $0x80107ac4
80104d2c:	e8 5f b6 ff ff       	call   80100390 <panic>
80104d31:	eb 0d                	jmp    80104d40 <argfd.constprop.0>
80104d33:	90                   	nop
80104d34:	90                   	nop
80104d35:	90                   	nop
80104d36:	90                   	nop
80104d37:	90                   	nop
80104d38:	90                   	nop
80104d39:	90                   	nop
80104d3a:	90                   	nop
80104d3b:	90                   	nop
80104d3c:	90                   	nop
80104d3d:	90                   	nop
80104d3e:	90                   	nop
80104d3f:	90                   	nop

80104d40 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d47:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d4a:	89 d6                	mov    %edx,%esi
80104d4c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d4f:	50                   	push   %eax
80104d50:	6a 00                	push   $0x0
80104d52:	e8 f9 fc ff ff       	call   80104a50 <argint>
80104d57:	83 c4 10             	add    $0x10,%esp
80104d5a:	85 c0                	test   %eax,%eax
80104d5c:	78 2a                	js     80104d88 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d5e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d62:	77 24                	ja     80104d88 <argfd.constprop.0+0x48>
80104d64:	e8 07 eb ff ff       	call   80103870 <myproc>
80104d69:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d6c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d70:	85 c0                	test   %eax,%eax
80104d72:	74 14                	je     80104d88 <argfd.constprop.0+0x48>
  if(pfd)
80104d74:	85 db                	test   %ebx,%ebx
80104d76:	74 02                	je     80104d7a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d78:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104d7a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d7c:	31 c0                	xor    %eax,%eax
}
80104d7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d81:	5b                   	pop    %ebx
80104d82:	5e                   	pop    %esi
80104d83:	5d                   	pop    %ebp
80104d84:	c3                   	ret    
80104d85:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d8d:	eb ef                	jmp    80104d7e <argfd.constprop.0+0x3e>
80104d8f:	90                   	nop

80104d90 <sys_dup>:
{
80104d90:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104d91:	31 c0                	xor    %eax,%eax
{
80104d93:	89 e5                	mov    %esp,%ebp
80104d95:	56                   	push   %esi
80104d96:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d97:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d9a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d9d:	e8 9e ff ff ff       	call   80104d40 <argfd.constprop.0>
80104da2:	85 c0                	test   %eax,%eax
80104da4:	78 42                	js     80104de8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104da6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104da9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104dab:	e8 c0 ea ff ff       	call   80103870 <myproc>
80104db0:	eb 0e                	jmp    80104dc0 <sys_dup+0x30>
80104db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104db8:	83 c3 01             	add    $0x1,%ebx
80104dbb:	83 fb 10             	cmp    $0x10,%ebx
80104dbe:	74 28                	je     80104de8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104dc0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104dc4:	85 d2                	test   %edx,%edx
80104dc6:	75 f0                	jne    80104db8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104dc8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104dcc:	83 ec 0c             	sub    $0xc,%esp
80104dcf:	ff 75 f4             	pushl  -0xc(%ebp)
80104dd2:	e8 89 c0 ff ff       	call   80100e60 <filedup>
  return fd;
80104dd7:	83 c4 10             	add    $0x10,%esp
}
80104dda:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ddd:	89 d8                	mov    %ebx,%eax
80104ddf:	5b                   	pop    %ebx
80104de0:	5e                   	pop    %esi
80104de1:	5d                   	pop    %ebp
80104de2:	c3                   	ret    
80104de3:	90                   	nop
80104de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104de8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104deb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104df0:	89 d8                	mov    %ebx,%eax
80104df2:	5b                   	pop    %ebx
80104df3:	5e                   	pop    %esi
80104df4:	5d                   	pop    %ebp
80104df5:	c3                   	ret    
80104df6:	8d 76 00             	lea    0x0(%esi),%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <sys_read>:
{
80104e00:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e01:	31 c0                	xor    %eax,%eax
{
80104e03:	89 e5                	mov    %esp,%ebp
80104e05:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e08:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e0b:	e8 30 ff ff ff       	call   80104d40 <argfd.constprop.0>
80104e10:	85 c0                	test   %eax,%eax
80104e12:	78 4c                	js     80104e60 <sys_read+0x60>
80104e14:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e17:	83 ec 08             	sub    $0x8,%esp
80104e1a:	50                   	push   %eax
80104e1b:	6a 02                	push   $0x2
80104e1d:	e8 2e fc ff ff       	call   80104a50 <argint>
80104e22:	83 c4 10             	add    $0x10,%esp
80104e25:	85 c0                	test   %eax,%eax
80104e27:	78 37                	js     80104e60 <sys_read+0x60>
80104e29:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e2c:	83 ec 04             	sub    $0x4,%esp
80104e2f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e32:	50                   	push   %eax
80104e33:	6a 01                	push   $0x1
80104e35:	e8 66 fc ff ff       	call   80104aa0 <argptr>
80104e3a:	83 c4 10             	add    $0x10,%esp
80104e3d:	85 c0                	test   %eax,%eax
80104e3f:	78 1f                	js     80104e60 <sys_read+0x60>
  return fileread(f, p, n);
80104e41:	83 ec 04             	sub    $0x4,%esp
80104e44:	ff 75 f0             	pushl  -0x10(%ebp)
80104e47:	ff 75 f4             	pushl  -0xc(%ebp)
80104e4a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e4d:	e8 7e c1 ff ff       	call   80100fd0 <fileread>
80104e52:	83 c4 10             	add    $0x10,%esp
}
80104e55:	c9                   	leave  
80104e56:	c3                   	ret    
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <sys_write>:
{
80104e70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e71:	31 c0                	xor    %eax,%eax
{
80104e73:	89 e5                	mov    %esp,%ebp
80104e75:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e7b:	e8 c0 fe ff ff       	call   80104d40 <argfd.constprop.0>
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 4c                	js     80104ed0 <sys_write+0x60>
80104e84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e87:	83 ec 08             	sub    $0x8,%esp
80104e8a:	50                   	push   %eax
80104e8b:	6a 02                	push   $0x2
80104e8d:	e8 be fb ff ff       	call   80104a50 <argint>
80104e92:	83 c4 10             	add    $0x10,%esp
80104e95:	85 c0                	test   %eax,%eax
80104e97:	78 37                	js     80104ed0 <sys_write+0x60>
80104e99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e9c:	83 ec 04             	sub    $0x4,%esp
80104e9f:	ff 75 f0             	pushl  -0x10(%ebp)
80104ea2:	50                   	push   %eax
80104ea3:	6a 01                	push   $0x1
80104ea5:	e8 f6 fb ff ff       	call   80104aa0 <argptr>
80104eaa:	83 c4 10             	add    $0x10,%esp
80104ead:	85 c0                	test   %eax,%eax
80104eaf:	78 1f                	js     80104ed0 <sys_write+0x60>
  return filewrite(f, p, n);
80104eb1:	83 ec 04             	sub    $0x4,%esp
80104eb4:	ff 75 f0             	pushl  -0x10(%ebp)
80104eb7:	ff 75 f4             	pushl  -0xc(%ebp)
80104eba:	ff 75 ec             	pushl  -0x14(%ebp)
80104ebd:	e8 9e c1 ff ff       	call   80101060 <filewrite>
80104ec2:	83 c4 10             	add    $0x10,%esp
}
80104ec5:	c9                   	leave  
80104ec6:	c3                   	ret    
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ed5:	c9                   	leave  
80104ed6:	c3                   	ret    
80104ed7:	89 f6                	mov    %esi,%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <sys_close>:
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104ee6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ee9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104eec:	e8 4f fe ff ff       	call   80104d40 <argfd.constprop.0>
80104ef1:	85 c0                	test   %eax,%eax
80104ef3:	78 2b                	js     80104f20 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104ef5:	e8 76 e9 ff ff       	call   80103870 <myproc>
80104efa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104efd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f00:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f07:	00 
  fileclose(f);
80104f08:	ff 75 f4             	pushl  -0xc(%ebp)
80104f0b:	e8 a0 bf ff ff       	call   80100eb0 <fileclose>
  return 0;
80104f10:	83 c4 10             	add    $0x10,%esp
80104f13:	31 c0                	xor    %eax,%eax
}
80104f15:	c9                   	leave  
80104f16:	c3                   	ret    
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f25:	c9                   	leave  
80104f26:	c3                   	ret    
80104f27:	89 f6                	mov    %esi,%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f30 <sys_fstat>:
{
80104f30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f31:	31 c0                	xor    %eax,%eax
{
80104f33:	89 e5                	mov    %esp,%ebp
80104f35:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f38:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f3b:	e8 00 fe ff ff       	call   80104d40 <argfd.constprop.0>
80104f40:	85 c0                	test   %eax,%eax
80104f42:	78 2c                	js     80104f70 <sys_fstat+0x40>
80104f44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f47:	83 ec 04             	sub    $0x4,%esp
80104f4a:	6a 14                	push   $0x14
80104f4c:	50                   	push   %eax
80104f4d:	6a 01                	push   $0x1
80104f4f:	e8 4c fb ff ff       	call   80104aa0 <argptr>
80104f54:	83 c4 10             	add    $0x10,%esp
80104f57:	85 c0                	test   %eax,%eax
80104f59:	78 15                	js     80104f70 <sys_fstat+0x40>
  return filestat(f, st);
80104f5b:	83 ec 08             	sub    $0x8,%esp
80104f5e:	ff 75 f4             	pushl  -0xc(%ebp)
80104f61:	ff 75 f0             	pushl  -0x10(%ebp)
80104f64:	e8 17 c0 ff ff       	call   80100f80 <filestat>
80104f69:	83 c4 10             	add    $0x10,%esp
}
80104f6c:	c9                   	leave  
80104f6d:	c3                   	ret    
80104f6e:	66 90                	xchg   %ax,%ax
    return -1;
80104f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f75:	c9                   	leave  
80104f76:	c3                   	ret    
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f80 <sys_link>:
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	56                   	push   %esi
80104f85:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f86:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f89:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f8c:	50                   	push   %eax
80104f8d:	6a 00                	push   $0x0
80104f8f:	e8 6c fb ff ff       	call   80104b00 <argstr>
80104f94:	83 c4 10             	add    $0x10,%esp
80104f97:	85 c0                	test   %eax,%eax
80104f99:	0f 88 fb 00 00 00    	js     8010509a <sys_link+0x11a>
80104f9f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104fa2:	83 ec 08             	sub    $0x8,%esp
80104fa5:	50                   	push   %eax
80104fa6:	6a 01                	push   $0x1
80104fa8:	e8 53 fb ff ff       	call   80104b00 <argstr>
80104fad:	83 c4 10             	add    $0x10,%esp
80104fb0:	85 c0                	test   %eax,%eax
80104fb2:	0f 88 e2 00 00 00    	js     8010509a <sys_link+0x11a>
  begin_op();
80104fb8:	e8 63 dc ff ff       	call   80102c20 <begin_op>
  if((ip = namei(old)) == 0){
80104fbd:	83 ec 0c             	sub    $0xc,%esp
80104fc0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104fc3:	e8 98 cf ff ff       	call   80101f60 <namei>
80104fc8:	83 c4 10             	add    $0x10,%esp
80104fcb:	85 c0                	test   %eax,%eax
80104fcd:	89 c3                	mov    %eax,%ebx
80104fcf:	0f 84 ea 00 00 00    	je     801050bf <sys_link+0x13f>
  ilock(ip);
80104fd5:	83 ec 0c             	sub    $0xc,%esp
80104fd8:	50                   	push   %eax
80104fd9:	e8 22 c7 ff ff       	call   80101700 <ilock>
  if(ip->type == T_DIR){
80104fde:	83 c4 10             	add    $0x10,%esp
80104fe1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fe6:	0f 84 bb 00 00 00    	je     801050a7 <sys_link+0x127>
  ip->nlink++;
80104fec:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ff1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104ff4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ff7:	53                   	push   %ebx
80104ff8:	e8 53 c6 ff ff       	call   80101650 <iupdate>
  iunlock(ip);
80104ffd:	89 1c 24             	mov    %ebx,(%esp)
80105000:	e8 db c7 ff ff       	call   801017e0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105005:	58                   	pop    %eax
80105006:	5a                   	pop    %edx
80105007:	57                   	push   %edi
80105008:	ff 75 d0             	pushl  -0x30(%ebp)
8010500b:	e8 70 cf ff ff       	call   80101f80 <nameiparent>
80105010:	83 c4 10             	add    $0x10,%esp
80105013:	85 c0                	test   %eax,%eax
80105015:	89 c6                	mov    %eax,%esi
80105017:	74 5b                	je     80105074 <sys_link+0xf4>
  ilock(dp);
80105019:	83 ec 0c             	sub    $0xc,%esp
8010501c:	50                   	push   %eax
8010501d:	e8 de c6 ff ff       	call   80101700 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105022:	83 c4 10             	add    $0x10,%esp
80105025:	8b 03                	mov    (%ebx),%eax
80105027:	39 06                	cmp    %eax,(%esi)
80105029:	75 3d                	jne    80105068 <sys_link+0xe8>
8010502b:	83 ec 04             	sub    $0x4,%esp
8010502e:	ff 73 04             	pushl  0x4(%ebx)
80105031:	57                   	push   %edi
80105032:	56                   	push   %esi
80105033:	e8 68 ce ff ff       	call   80101ea0 <dirlink>
80105038:	83 c4 10             	add    $0x10,%esp
8010503b:	85 c0                	test   %eax,%eax
8010503d:	78 29                	js     80105068 <sys_link+0xe8>
  iunlockput(dp);
8010503f:	83 ec 0c             	sub    $0xc,%esp
80105042:	56                   	push   %esi
80105043:	e8 48 c9 ff ff       	call   80101990 <iunlockput>
  iput(ip);
80105048:	89 1c 24             	mov    %ebx,(%esp)
8010504b:	e8 e0 c7 ff ff       	call   80101830 <iput>
  end_op();
80105050:	e8 3b dc ff ff       	call   80102c90 <end_op>
  return 0;
80105055:	83 c4 10             	add    $0x10,%esp
80105058:	31 c0                	xor    %eax,%eax
}
8010505a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010505d:	5b                   	pop    %ebx
8010505e:	5e                   	pop    %esi
8010505f:	5f                   	pop    %edi
80105060:	5d                   	pop    %ebp
80105061:	c3                   	ret    
80105062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105068:	83 ec 0c             	sub    $0xc,%esp
8010506b:	56                   	push   %esi
8010506c:	e8 1f c9 ff ff       	call   80101990 <iunlockput>
    goto bad;
80105071:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105074:	83 ec 0c             	sub    $0xc,%esp
80105077:	53                   	push   %ebx
80105078:	e8 83 c6 ff ff       	call   80101700 <ilock>
  ip->nlink--;
8010507d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105082:	89 1c 24             	mov    %ebx,(%esp)
80105085:	e8 c6 c5 ff ff       	call   80101650 <iupdate>
  iunlockput(ip);
8010508a:	89 1c 24             	mov    %ebx,(%esp)
8010508d:	e8 fe c8 ff ff       	call   80101990 <iunlockput>
  end_op();
80105092:	e8 f9 db ff ff       	call   80102c90 <end_op>
  return -1;
80105097:	83 c4 10             	add    $0x10,%esp
}
8010509a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010509d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050a2:	5b                   	pop    %ebx
801050a3:	5e                   	pop    %esi
801050a4:	5f                   	pop    %edi
801050a5:	5d                   	pop    %ebp
801050a6:	c3                   	ret    
    iunlockput(ip);
801050a7:	83 ec 0c             	sub    $0xc,%esp
801050aa:	53                   	push   %ebx
801050ab:	e8 e0 c8 ff ff       	call   80101990 <iunlockput>
    end_op();
801050b0:	e8 db db ff ff       	call   80102c90 <end_op>
    return -1;
801050b5:	83 c4 10             	add    $0x10,%esp
801050b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050bd:	eb 9b                	jmp    8010505a <sys_link+0xda>
    end_op();
801050bf:	e8 cc db ff ff       	call   80102c90 <end_op>
    return -1;
801050c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c9:	eb 8f                	jmp    8010505a <sys_link+0xda>
801050cb:	90                   	nop
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050d0 <sys_unlink>:
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	57                   	push   %edi
801050d4:	56                   	push   %esi
801050d5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801050d6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050d9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801050dc:	50                   	push   %eax
801050dd:	6a 00                	push   $0x0
801050df:	e8 1c fa ff ff       	call   80104b00 <argstr>
801050e4:	83 c4 10             	add    $0x10,%esp
801050e7:	85 c0                	test   %eax,%eax
801050e9:	0f 88 77 01 00 00    	js     80105266 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801050ef:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801050f2:	e8 29 db ff ff       	call   80102c20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801050f7:	83 ec 08             	sub    $0x8,%esp
801050fa:	53                   	push   %ebx
801050fb:	ff 75 c0             	pushl  -0x40(%ebp)
801050fe:	e8 7d ce ff ff       	call   80101f80 <nameiparent>
80105103:	83 c4 10             	add    $0x10,%esp
80105106:	85 c0                	test   %eax,%eax
80105108:	89 c6                	mov    %eax,%esi
8010510a:	0f 84 60 01 00 00    	je     80105270 <sys_unlink+0x1a0>
  ilock(dp);
80105110:	83 ec 0c             	sub    $0xc,%esp
80105113:	50                   	push   %eax
80105114:	e8 e7 c5 ff ff       	call   80101700 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105119:	58                   	pop    %eax
8010511a:	5a                   	pop    %edx
8010511b:	68 e0 7a 10 80       	push   $0x80107ae0
80105120:	53                   	push   %ebx
80105121:	e8 ea ca ff ff       	call   80101c10 <namecmp>
80105126:	83 c4 10             	add    $0x10,%esp
80105129:	85 c0                	test   %eax,%eax
8010512b:	0f 84 03 01 00 00    	je     80105234 <sys_unlink+0x164>
80105131:	83 ec 08             	sub    $0x8,%esp
80105134:	68 df 7a 10 80       	push   $0x80107adf
80105139:	53                   	push   %ebx
8010513a:	e8 d1 ca ff ff       	call   80101c10 <namecmp>
8010513f:	83 c4 10             	add    $0x10,%esp
80105142:	85 c0                	test   %eax,%eax
80105144:	0f 84 ea 00 00 00    	je     80105234 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010514a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010514d:	83 ec 04             	sub    $0x4,%esp
80105150:	50                   	push   %eax
80105151:	53                   	push   %ebx
80105152:	56                   	push   %esi
80105153:	e8 d8 ca ff ff       	call   80101c30 <dirlookup>
80105158:	83 c4 10             	add    $0x10,%esp
8010515b:	85 c0                	test   %eax,%eax
8010515d:	89 c3                	mov    %eax,%ebx
8010515f:	0f 84 cf 00 00 00    	je     80105234 <sys_unlink+0x164>
  ilock(ip);
80105165:	83 ec 0c             	sub    $0xc,%esp
80105168:	50                   	push   %eax
80105169:	e8 92 c5 ff ff       	call   80101700 <ilock>
  if(ip->nlink < 1)
8010516e:	83 c4 10             	add    $0x10,%esp
80105171:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105176:	0f 8e 10 01 00 00    	jle    8010528c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010517c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105181:	74 6d                	je     801051f0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105183:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105186:	83 ec 04             	sub    $0x4,%esp
80105189:	6a 10                	push   $0x10
8010518b:	6a 00                	push   $0x0
8010518d:	50                   	push   %eax
8010518e:	e8 bd f5 ff ff       	call   80104750 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105193:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105196:	6a 10                	push   $0x10
80105198:	ff 75 c4             	pushl  -0x3c(%ebp)
8010519b:	50                   	push   %eax
8010519c:	56                   	push   %esi
8010519d:	e8 3e c9 ff ff       	call   80101ae0 <writei>
801051a2:	83 c4 20             	add    $0x20,%esp
801051a5:	83 f8 10             	cmp    $0x10,%eax
801051a8:	0f 85 eb 00 00 00    	jne    80105299 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801051ae:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051b3:	0f 84 97 00 00 00    	je     80105250 <sys_unlink+0x180>
  iunlockput(dp);
801051b9:	83 ec 0c             	sub    $0xc,%esp
801051bc:	56                   	push   %esi
801051bd:	e8 ce c7 ff ff       	call   80101990 <iunlockput>
  ip->nlink--;
801051c2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051c7:	89 1c 24             	mov    %ebx,(%esp)
801051ca:	e8 81 c4 ff ff       	call   80101650 <iupdate>
  iunlockput(ip);
801051cf:	89 1c 24             	mov    %ebx,(%esp)
801051d2:	e8 b9 c7 ff ff       	call   80101990 <iunlockput>
  end_op();
801051d7:	e8 b4 da ff ff       	call   80102c90 <end_op>
  return 0;
801051dc:	83 c4 10             	add    $0x10,%esp
801051df:	31 c0                	xor    %eax,%eax
}
801051e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051e4:	5b                   	pop    %ebx
801051e5:	5e                   	pop    %esi
801051e6:	5f                   	pop    %edi
801051e7:	5d                   	pop    %ebp
801051e8:	c3                   	ret    
801051e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051f0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051f4:	76 8d                	jbe    80105183 <sys_unlink+0xb3>
801051f6:	bf 20 00 00 00       	mov    $0x20,%edi
801051fb:	eb 0f                	jmp    8010520c <sys_unlink+0x13c>
801051fd:	8d 76 00             	lea    0x0(%esi),%esi
80105200:	83 c7 10             	add    $0x10,%edi
80105203:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105206:	0f 83 77 ff ff ff    	jae    80105183 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010520c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010520f:	6a 10                	push   $0x10
80105211:	57                   	push   %edi
80105212:	50                   	push   %eax
80105213:	53                   	push   %ebx
80105214:	e8 c7 c7 ff ff       	call   801019e0 <readi>
80105219:	83 c4 10             	add    $0x10,%esp
8010521c:	83 f8 10             	cmp    $0x10,%eax
8010521f:	75 5e                	jne    8010527f <sys_unlink+0x1af>
    if(de.inum != 0)
80105221:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105226:	74 d8                	je     80105200 <sys_unlink+0x130>
    iunlockput(ip);
80105228:	83 ec 0c             	sub    $0xc,%esp
8010522b:	53                   	push   %ebx
8010522c:	e8 5f c7 ff ff       	call   80101990 <iunlockput>
    goto bad;
80105231:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	56                   	push   %esi
80105238:	e8 53 c7 ff ff       	call   80101990 <iunlockput>
  end_op();
8010523d:	e8 4e da ff ff       	call   80102c90 <end_op>
  return -1;
80105242:	83 c4 10             	add    $0x10,%esp
80105245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524a:	eb 95                	jmp    801051e1 <sys_unlink+0x111>
8010524c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105250:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105255:	83 ec 0c             	sub    $0xc,%esp
80105258:	56                   	push   %esi
80105259:	e8 f2 c3 ff ff       	call   80101650 <iupdate>
8010525e:	83 c4 10             	add    $0x10,%esp
80105261:	e9 53 ff ff ff       	jmp    801051b9 <sys_unlink+0xe9>
    return -1;
80105266:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526b:	e9 71 ff ff ff       	jmp    801051e1 <sys_unlink+0x111>
    end_op();
80105270:	e8 1b da ff ff       	call   80102c90 <end_op>
    return -1;
80105275:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527a:	e9 62 ff ff ff       	jmp    801051e1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010527f:	83 ec 0c             	sub    $0xc,%esp
80105282:	68 04 7b 10 80       	push   $0x80107b04
80105287:	e8 04 b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010528c:	83 ec 0c             	sub    $0xc,%esp
8010528f:	68 f2 7a 10 80       	push   $0x80107af2
80105294:	e8 f7 b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	68 16 7b 10 80       	push   $0x80107b16
801052a1:	e8 ea b0 ff ff       	call   80100390 <panic>
801052a6:	8d 76 00             	lea    0x0(%esi),%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_open>:

int
sys_open(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
801052b5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801052b9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052bc:	50                   	push   %eax
801052bd:	6a 00                	push   $0x0
801052bf:	e8 3c f8 ff ff       	call   80104b00 <argstr>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	0f 88 1d 01 00 00    	js     801053ec <sys_open+0x13c>
801052cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052d2:	83 ec 08             	sub    $0x8,%esp
801052d5:	50                   	push   %eax
801052d6:	6a 01                	push   $0x1
801052d8:	e8 73 f7 ff ff       	call   80104a50 <argint>
801052dd:	83 c4 10             	add    $0x10,%esp
801052e0:	85 c0                	test   %eax,%eax
801052e2:	0f 88 04 01 00 00    	js     801053ec <sys_open+0x13c>
    return -1;

  begin_op();
801052e8:	e8 33 d9 ff ff       	call   80102c20 <begin_op>

  if(omode & O_CREATE){
801052ed:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801052f1:	0f 85 a9 00 00 00    	jne    801053a0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801052f7:	83 ec 0c             	sub    $0xc,%esp
801052fa:	ff 75 e0             	pushl  -0x20(%ebp)
801052fd:	e8 5e cc ff ff       	call   80101f60 <namei>
80105302:	83 c4 10             	add    $0x10,%esp
80105305:	85 c0                	test   %eax,%eax
80105307:	89 c6                	mov    %eax,%esi
80105309:	0f 84 b2 00 00 00    	je     801053c1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010530f:	83 ec 0c             	sub    $0xc,%esp
80105312:	50                   	push   %eax
80105313:	e8 e8 c3 ff ff       	call   80101700 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105318:	83 c4 10             	add    $0x10,%esp
8010531b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105320:	0f 84 aa 00 00 00    	je     801053d0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105326:	e8 c5 ba ff ff       	call   80100df0 <filealloc>
8010532b:	85 c0                	test   %eax,%eax
8010532d:	89 c7                	mov    %eax,%edi
8010532f:	0f 84 a6 00 00 00    	je     801053db <sys_open+0x12b>
  struct proc *curproc = myproc();
80105335:	e8 36 e5 ff ff       	call   80103870 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010533a:	31 db                	xor    %ebx,%ebx
8010533c:	eb 0e                	jmp    8010534c <sys_open+0x9c>
8010533e:	66 90                	xchg   %ax,%ax
80105340:	83 c3 01             	add    $0x1,%ebx
80105343:	83 fb 10             	cmp    $0x10,%ebx
80105346:	0f 84 ac 00 00 00    	je     801053f8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010534c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105350:	85 d2                	test   %edx,%edx
80105352:	75 ec                	jne    80105340 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105354:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105357:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010535b:	56                   	push   %esi
8010535c:	e8 7f c4 ff ff       	call   801017e0 <iunlock>
  end_op();
80105361:	e8 2a d9 ff ff       	call   80102c90 <end_op>

  f->type = FD_INODE;
80105366:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010536c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010536f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105372:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105375:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010537c:	89 d0                	mov    %edx,%eax
8010537e:	f7 d0                	not    %eax
80105380:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105383:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105386:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105389:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010538d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105390:	89 d8                	mov    %ebx,%eax
80105392:	5b                   	pop    %ebx
80105393:	5e                   	pop    %esi
80105394:	5f                   	pop    %edi
80105395:	5d                   	pop    %ebp
80105396:	c3                   	ret    
80105397:	89 f6                	mov    %esi,%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053a6:	31 c9                	xor    %ecx,%ecx
801053a8:	6a 00                	push   $0x0
801053aa:	ba 02 00 00 00       	mov    $0x2,%edx
801053af:	e8 ec f7 ff ff       	call   80104ba0 <create>
    if(ip == 0){
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801053b9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053bb:	0f 85 65 ff ff ff    	jne    80105326 <sys_open+0x76>
      end_op();
801053c1:	e8 ca d8 ff ff       	call   80102c90 <end_op>
      return -1;
801053c6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053cb:	eb c0                	jmp    8010538d <sys_open+0xdd>
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801053d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801053d3:	85 c9                	test   %ecx,%ecx
801053d5:	0f 84 4b ff ff ff    	je     80105326 <sys_open+0x76>
    iunlockput(ip);
801053db:	83 ec 0c             	sub    $0xc,%esp
801053de:	56                   	push   %esi
801053df:	e8 ac c5 ff ff       	call   80101990 <iunlockput>
    end_op();
801053e4:	e8 a7 d8 ff ff       	call   80102c90 <end_op>
    return -1;
801053e9:	83 c4 10             	add    $0x10,%esp
801053ec:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053f1:	eb 9a                	jmp    8010538d <sys_open+0xdd>
801053f3:	90                   	nop
801053f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801053f8:	83 ec 0c             	sub    $0xc,%esp
801053fb:	57                   	push   %edi
801053fc:	e8 af ba ff ff       	call   80100eb0 <fileclose>
80105401:	83 c4 10             	add    $0x10,%esp
80105404:	eb d5                	jmp    801053db <sys_open+0x12b>
80105406:	8d 76 00             	lea    0x0(%esi),%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105410 <sys_mkdir>:

int
sys_mkdir(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105416:	e8 05 d8 ff ff       	call   80102c20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010541b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010541e:	83 ec 08             	sub    $0x8,%esp
80105421:	50                   	push   %eax
80105422:	6a 00                	push   $0x0
80105424:	e8 d7 f6 ff ff       	call   80104b00 <argstr>
80105429:	83 c4 10             	add    $0x10,%esp
8010542c:	85 c0                	test   %eax,%eax
8010542e:	78 30                	js     80105460 <sys_mkdir+0x50>
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105436:	31 c9                	xor    %ecx,%ecx
80105438:	6a 00                	push   $0x0
8010543a:	ba 01 00 00 00       	mov    $0x1,%edx
8010543f:	e8 5c f7 ff ff       	call   80104ba0 <create>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	74 15                	je     80105460 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010544b:	83 ec 0c             	sub    $0xc,%esp
8010544e:	50                   	push   %eax
8010544f:	e8 3c c5 ff ff       	call   80101990 <iunlockput>
  end_op();
80105454:	e8 37 d8 ff ff       	call   80102c90 <end_op>
  return 0;
80105459:	83 c4 10             	add    $0x10,%esp
8010545c:	31 c0                	xor    %eax,%eax
}
8010545e:	c9                   	leave  
8010545f:	c3                   	ret    
    end_op();
80105460:	e8 2b d8 ff ff       	call   80102c90 <end_op>
    return -1;
80105465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010546a:	c9                   	leave  
8010546b:	c3                   	ret    
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_mknod>:

int
sys_mknod(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105476:	e8 a5 d7 ff ff       	call   80102c20 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010547b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010547e:	83 ec 08             	sub    $0x8,%esp
80105481:	50                   	push   %eax
80105482:	6a 00                	push   $0x0
80105484:	e8 77 f6 ff ff       	call   80104b00 <argstr>
80105489:	83 c4 10             	add    $0x10,%esp
8010548c:	85 c0                	test   %eax,%eax
8010548e:	78 60                	js     801054f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105490:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105493:	83 ec 08             	sub    $0x8,%esp
80105496:	50                   	push   %eax
80105497:	6a 01                	push   $0x1
80105499:	e8 b2 f5 ff ff       	call   80104a50 <argint>
  if((argstr(0, &path)) < 0 ||
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	85 c0                	test   %eax,%eax
801054a3:	78 4b                	js     801054f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801054a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054a8:	83 ec 08             	sub    $0x8,%esp
801054ab:	50                   	push   %eax
801054ac:	6a 02                	push   $0x2
801054ae:	e8 9d f5 ff ff       	call   80104a50 <argint>
     argint(1, &major) < 0 ||
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	78 36                	js     801054f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054ba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801054be:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801054c1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801054c5:	ba 03 00 00 00       	mov    $0x3,%edx
801054ca:	50                   	push   %eax
801054cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054ce:	e8 cd f6 ff ff       	call   80104ba0 <create>
801054d3:	83 c4 10             	add    $0x10,%esp
801054d6:	85 c0                	test   %eax,%eax
801054d8:	74 16                	je     801054f0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054da:	83 ec 0c             	sub    $0xc,%esp
801054dd:	50                   	push   %eax
801054de:	e8 ad c4 ff ff       	call   80101990 <iunlockput>
  end_op();
801054e3:	e8 a8 d7 ff ff       	call   80102c90 <end_op>
  return 0;
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	31 c0                	xor    %eax,%eax
}
801054ed:	c9                   	leave  
801054ee:	c3                   	ret    
801054ef:	90                   	nop
    end_op();
801054f0:	e8 9b d7 ff ff       	call   80102c90 <end_op>
    return -1;
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054fa:	c9                   	leave  
801054fb:	c3                   	ret    
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_chdir>:

int
sys_chdir(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	53                   	push   %ebx
80105505:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105508:	e8 63 e3 ff ff       	call   80103870 <myproc>
8010550d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010550f:	e8 0c d7 ff ff       	call   80102c20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105514:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105517:	83 ec 08             	sub    $0x8,%esp
8010551a:	50                   	push   %eax
8010551b:	6a 00                	push   $0x0
8010551d:	e8 de f5 ff ff       	call   80104b00 <argstr>
80105522:	83 c4 10             	add    $0x10,%esp
80105525:	85 c0                	test   %eax,%eax
80105527:	78 77                	js     801055a0 <sys_chdir+0xa0>
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	ff 75 f4             	pushl  -0xc(%ebp)
8010552f:	e8 2c ca ff ff       	call   80101f60 <namei>
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	85 c0                	test   %eax,%eax
80105539:	89 c3                	mov    %eax,%ebx
8010553b:	74 63                	je     801055a0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010553d:	83 ec 0c             	sub    $0xc,%esp
80105540:	50                   	push   %eax
80105541:	e8 ba c1 ff ff       	call   80101700 <ilock>
  if(ip->type != T_DIR){
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010554e:	75 30                	jne    80105580 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	53                   	push   %ebx
80105554:	e8 87 c2 ff ff       	call   801017e0 <iunlock>
  iput(curproc->cwd);
80105559:	58                   	pop    %eax
8010555a:	ff 76 68             	pushl  0x68(%esi)
8010555d:	e8 ce c2 ff ff       	call   80101830 <iput>
  end_op();
80105562:	e8 29 d7 ff ff       	call   80102c90 <end_op>
  curproc->cwd = ip;
80105567:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010556a:	83 c4 10             	add    $0x10,%esp
8010556d:	31 c0                	xor    %eax,%eax
}
8010556f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105572:	5b                   	pop    %ebx
80105573:	5e                   	pop    %esi
80105574:	5d                   	pop    %ebp
80105575:	c3                   	ret    
80105576:	8d 76 00             	lea    0x0(%esi),%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	53                   	push   %ebx
80105584:	e8 07 c4 ff ff       	call   80101990 <iunlockput>
    end_op();
80105589:	e8 02 d7 ff ff       	call   80102c90 <end_op>
    return -1;
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105596:	eb d7                	jmp    8010556f <sys_chdir+0x6f>
80105598:	90                   	nop
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801055a0:	e8 eb d6 ff ff       	call   80102c90 <end_op>
    return -1;
801055a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055aa:	eb c3                	jmp    8010556f <sys_chdir+0x6f>
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055b0 <sys_exec>:

int
sys_exec(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	56                   	push   %esi
801055b5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055b6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801055bc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055c2:	50                   	push   %eax
801055c3:	6a 00                	push   $0x0
801055c5:	e8 36 f5 ff ff       	call   80104b00 <argstr>
801055ca:	83 c4 10             	add    $0x10,%esp
801055cd:	85 c0                	test   %eax,%eax
801055cf:	0f 88 87 00 00 00    	js     8010565c <sys_exec+0xac>
801055d5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055db:	83 ec 08             	sub    $0x8,%esp
801055de:	50                   	push   %eax
801055df:	6a 01                	push   $0x1
801055e1:	e8 6a f4 ff ff       	call   80104a50 <argint>
801055e6:	83 c4 10             	add    $0x10,%esp
801055e9:	85 c0                	test   %eax,%eax
801055eb:	78 6f                	js     8010565c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055ed:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801055f3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801055f6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055f8:	68 80 00 00 00       	push   $0x80
801055fd:	6a 00                	push   $0x0
801055ff:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105605:	50                   	push   %eax
80105606:	e8 45 f1 ff ff       	call   80104750 <memset>
8010560b:	83 c4 10             	add    $0x10,%esp
8010560e:	eb 2c                	jmp    8010563c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105610:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105616:	85 c0                	test   %eax,%eax
80105618:	74 56                	je     80105670 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010561a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105620:	83 ec 08             	sub    $0x8,%esp
80105623:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105626:	52                   	push   %edx
80105627:	50                   	push   %eax
80105628:	e8 b3 f3 ff ff       	call   801049e0 <fetchstr>
8010562d:	83 c4 10             	add    $0x10,%esp
80105630:	85 c0                	test   %eax,%eax
80105632:	78 28                	js     8010565c <sys_exec+0xac>
  for(i=0;; i++){
80105634:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105637:	83 fb 20             	cmp    $0x20,%ebx
8010563a:	74 20                	je     8010565c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010563c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105642:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105649:	83 ec 08             	sub    $0x8,%esp
8010564c:	57                   	push   %edi
8010564d:	01 f0                	add    %esi,%eax
8010564f:	50                   	push   %eax
80105650:	e8 4b f3 ff ff       	call   801049a0 <fetchint>
80105655:	83 c4 10             	add    $0x10,%esp
80105658:	85 c0                	test   %eax,%eax
8010565a:	79 b4                	jns    80105610 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010565c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010565f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105664:	5b                   	pop    %ebx
80105665:	5e                   	pop    %esi
80105666:	5f                   	pop    %edi
80105667:	5d                   	pop    %ebp
80105668:	c3                   	ret    
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105670:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105676:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105679:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105680:	00 00 00 00 
  return exec(path, argv);
80105684:	50                   	push   %eax
80105685:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010568b:	e8 90 b3 ff ff       	call   80100a20 <exec>
80105690:	83 c4 10             	add    $0x10,%esp
}
80105693:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105696:	5b                   	pop    %ebx
80105697:	5e                   	pop    %esi
80105698:	5f                   	pop    %edi
80105699:	5d                   	pop    %ebp
8010569a:	c3                   	ret    
8010569b:	90                   	nop
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_pipe>:

int
sys_pipe(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
801056a5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056a6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801056a9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056ac:	6a 08                	push   $0x8
801056ae:	50                   	push   %eax
801056af:	6a 00                	push   $0x0
801056b1:	e8 ea f3 ff ff       	call   80104aa0 <argptr>
801056b6:	83 c4 10             	add    $0x10,%esp
801056b9:	85 c0                	test   %eax,%eax
801056bb:	0f 88 ae 00 00 00    	js     8010576f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801056c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056c4:	83 ec 08             	sub    $0x8,%esp
801056c7:	50                   	push   %eax
801056c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801056cb:	50                   	push   %eax
801056cc:	e8 ef db ff ff       	call   801032c0 <pipealloc>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	85 c0                	test   %eax,%eax
801056d6:	0f 88 93 00 00 00    	js     8010576f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801056df:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056e1:	e8 8a e1 ff ff       	call   80103870 <myproc>
801056e6:	eb 10                	jmp    801056f8 <sys_pipe+0x58>
801056e8:	90                   	nop
801056e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056f0:	83 c3 01             	add    $0x1,%ebx
801056f3:	83 fb 10             	cmp    $0x10,%ebx
801056f6:	74 60                	je     80105758 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801056f8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056fc:	85 f6                	test   %esi,%esi
801056fe:	75 f0                	jne    801056f0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105700:	8d 73 08             	lea    0x8(%ebx),%esi
80105703:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105707:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010570a:	e8 61 e1 ff ff       	call   80103870 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010570f:	31 d2                	xor    %edx,%edx
80105711:	eb 0d                	jmp    80105720 <sys_pipe+0x80>
80105713:	90                   	nop
80105714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105718:	83 c2 01             	add    $0x1,%edx
8010571b:	83 fa 10             	cmp    $0x10,%edx
8010571e:	74 28                	je     80105748 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105720:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105724:	85 c9                	test   %ecx,%ecx
80105726:	75 f0                	jne    80105718 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105728:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010572c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010572f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105731:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105734:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105737:	31 c0                	xor    %eax,%eax
}
80105739:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010573c:	5b                   	pop    %ebx
8010573d:	5e                   	pop    %esi
8010573e:	5f                   	pop    %edi
8010573f:	5d                   	pop    %ebp
80105740:	c3                   	ret    
80105741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105748:	e8 23 e1 ff ff       	call   80103870 <myproc>
8010574d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105754:	00 
80105755:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	ff 75 e0             	pushl  -0x20(%ebp)
8010575e:	e8 4d b7 ff ff       	call   80100eb0 <fileclose>
    fileclose(wf);
80105763:	58                   	pop    %eax
80105764:	ff 75 e4             	pushl  -0x1c(%ebp)
80105767:	e8 44 b7 ff ff       	call   80100eb0 <fileclose>
    return -1;
8010576c:	83 c4 10             	add    $0x10,%esp
8010576f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105774:	eb c3                	jmp    80105739 <sys_pipe+0x99>
80105776:	66 90                	xchg   %ax,%ax
80105778:	66 90                	xchg   %ax,%ax
8010577a:	66 90                	xchg   %ax,%ax
8010577c:	66 90                	xchg   %ax,%ax
8010577e:	66 90                	xchg   %ax,%ax

80105780 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105783:	5d                   	pop    %ebp
  return fork();
80105784:	e9 67 e4 ff ff       	jmp    80103bf0 <fork>
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_exit>:

int
sys_exit(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 08             	sub    $0x8,%esp
  exit();
80105796:	e8 85 e7 ff ff       	call   80103f20 <exit>
  return 0;  // not reached
}
8010579b:	31 c0                	xor    %eax,%eax
8010579d:	c9                   	leave  
8010579e:	c3                   	ret    
8010579f:	90                   	nop

801057a0 <sys_wait>:

int
sys_wait(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801057a3:	5d                   	pop    %ebp
  return wait();
801057a4:	e9 97 e9 ff ff       	jmp    80104140 <wait>
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057b0 <sys_kill>:

int
sys_kill(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801057b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057b9:	50                   	push   %eax
801057ba:	6a 00                	push   $0x0
801057bc:	e8 8f f2 ff ff       	call   80104a50 <argint>
801057c1:	83 c4 10             	add    $0x10,%esp
801057c4:	85 c0                	test   %eax,%eax
801057c6:	78 18                	js     801057e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801057c8:	83 ec 0c             	sub    $0xc,%esp
801057cb:	ff 75 f4             	pushl  -0xc(%ebp)
801057ce:	e8 ad ea ff ff       	call   80104280 <kill>
801057d3:	83 c4 10             	add    $0x10,%esp
}
801057d6:	c9                   	leave  
801057d7:	c3                   	ret    
801057d8:	90                   	nop
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057e5:	c9                   	leave  
801057e6:	c3                   	ret    
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <sys_getpid>:

int
sys_getpid(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057f6:	e8 75 e0 ff ff       	call   80103870 <myproc>
801057fb:	8b 40 10             	mov    0x10(%eax),%eax
}
801057fe:	c9                   	leave  
801057ff:	c3                   	ret    

80105800 <sys_sbrk>:

int
sys_sbrk(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105804:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105807:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010580a:	50                   	push   %eax
8010580b:	6a 00                	push   $0x0
8010580d:	e8 3e f2 ff ff       	call   80104a50 <argint>
80105812:	83 c4 10             	add    $0x10,%esp
80105815:	85 c0                	test   %eax,%eax
80105817:	78 27                	js     80105840 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105819:	e8 52 e0 ff ff       	call   80103870 <myproc>
  if(growproc(n) < 0)
8010581e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105821:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105823:	ff 75 f4             	pushl  -0xc(%ebp)
80105826:	e8 45 e3 ff ff       	call   80103b70 <growproc>
8010582b:	83 c4 10             	add    $0x10,%esp
8010582e:	85 c0                	test   %eax,%eax
80105830:	78 0e                	js     80105840 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105832:	89 d8                	mov    %ebx,%eax
80105834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105837:	c9                   	leave  
80105838:	c3                   	ret    
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105840:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105845:	eb eb                	jmp    80105832 <sys_sbrk+0x32>
80105847:	89 f6                	mov    %esi,%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105850 <sys_sleep>:

int
sys_sleep(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105854:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105857:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010585a:	50                   	push   %eax
8010585b:	6a 00                	push   $0x0
8010585d:	e8 ee f1 ff ff       	call   80104a50 <argint>
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	85 c0                	test   %eax,%eax
80105867:	0f 88 8a 00 00 00    	js     801058f7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010586d:	83 ec 0c             	sub    $0xc,%esp
80105870:	68 80 5d 11 80       	push   $0x80115d80
80105875:	e8 56 ed ff ff       	call   801045d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010587a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010587d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105880:	8b 1d c0 65 11 80    	mov    0x801165c0,%ebx
  while(ticks - ticks0 < n){
80105886:	85 d2                	test   %edx,%edx
80105888:	75 27                	jne    801058b1 <sys_sleep+0x61>
8010588a:	eb 54                	jmp    801058e0 <sys_sleep+0x90>
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105890:	83 ec 08             	sub    $0x8,%esp
80105893:	68 80 5d 11 80       	push   $0x80115d80
80105898:	68 c0 65 11 80       	push   $0x801165c0
8010589d:	e8 de e7 ff ff       	call   80104080 <sleep>
  while(ticks - ticks0 < n){
801058a2:	a1 c0 65 11 80       	mov    0x801165c0,%eax
801058a7:	83 c4 10             	add    $0x10,%esp
801058aa:	29 d8                	sub    %ebx,%eax
801058ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801058af:	73 2f                	jae    801058e0 <sys_sleep+0x90>
    if(myproc()->killed){
801058b1:	e8 ba df ff ff       	call   80103870 <myproc>
801058b6:	8b 40 24             	mov    0x24(%eax),%eax
801058b9:	85 c0                	test   %eax,%eax
801058bb:	74 d3                	je     80105890 <sys_sleep+0x40>
      release(&tickslock);
801058bd:	83 ec 0c             	sub    $0xc,%esp
801058c0:	68 80 5d 11 80       	push   $0x80115d80
801058c5:	e8 26 ee ff ff       	call   801046f0 <release>
      return -1;
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801058d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	68 80 5d 11 80       	push   $0x80115d80
801058e8:	e8 03 ee ff ff       	call   801046f0 <release>
  return 0;
801058ed:	83 c4 10             	add    $0x10,%esp
801058f0:	31 c0                	xor    %eax,%eax
}
801058f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058f5:	c9                   	leave  
801058f6:	c3                   	ret    
    return -1;
801058f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fc:	eb f4                	jmp    801058f2 <sys_sleep+0xa2>
801058fe:	66 90                	xchg   %ax,%ax

80105900 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	53                   	push   %ebx
80105904:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105907:	68 80 5d 11 80       	push   $0x80115d80
8010590c:	e8 bf ec ff ff       	call   801045d0 <acquire>
  xticks = ticks;
80105911:	8b 1d c0 65 11 80    	mov    0x801165c0,%ebx
  release(&tickslock);
80105917:	c7 04 24 80 5d 11 80 	movl   $0x80115d80,(%esp)
8010591e:	e8 cd ed ff ff       	call   801046f0 <release>
  return xticks;
}
80105923:	89 d8                	mov    %ebx,%eax
80105925:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105928:	c9                   	leave  
80105929:	c3                   	ret    
8010592a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105930 <sys_trace>:

int
sys_trace(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 08             	sub    $0x8,%esp
  return myproc()->timepiece;
80105936:	e8 35 df ff ff       	call   80103870 <myproc>
8010593b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80105941:	c9                   	leave  
80105942:	c3                   	ret    
80105943:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105950 <sys_releasesharem>:

int
sys_releasesharem(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 20             	sub    $0x20,%esp
  int idx;
  if(argint(0,&idx)<0)
80105956:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105959:	50                   	push   %eax
8010595a:	6a 00                	push   $0x0
8010595c:	e8 ef f0 ff ff       	call   80104a50 <argint>
80105961:	83 c4 10             	add    $0x10,%esp
80105964:	85 c0                	test   %eax,%eax
80105966:	78 18                	js     80105980 <sys_releasesharem+0x30>
    return -1;
  releaseshared(idx);
80105968:	83 ec 0c             	sub    $0xc,%esp
8010596b:	ff 75 f4             	pushl  -0xc(%ebp)
8010596e:	e8 1d e1 ff ff       	call   80103a90 <releaseshared>
  return 0;
80105973:	83 c4 10             	add    $0x10,%esp
80105976:	31 c0                	xor    %eax,%eax
}
80105978:	c9                   	leave  
80105979:	c3                   	ret    
8010597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105985:	c9                   	leave  
80105986:	c3                   	ret    
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105990 <sys_getsharem>:

int
sys_getsharem(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 20             	sub    $0x20,%esp
  int idx;
  if(argint(0,&idx)<0)
80105996:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105999:	50                   	push   %eax
8010599a:	6a 00                	push   $0x0
8010599c:	e8 af f0 ff ff       	call   80104a50 <argint>
801059a1:	83 c4 10             	add    $0x10,%esp
801059a4:	85 c0                	test   %eax,%eax
801059a6:	78 18                	js     801059c0 <sys_getsharem+0x30>
    return -1;
  return (int)getshared(idx);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	ff 75 f4             	pushl  -0xc(%ebp)
801059ae:	e8 2d e1 ff ff       	call   80103ae0 <getshared>
801059b3:	83 c4 10             	add    $0x10,%esp
}
801059b6:	c9                   	leave  
801059b7:	c3                   	ret    
801059b8:	90                   	nop
801059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c5:	c9                   	leave  
801059c6:	c3                   	ret    

801059c7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801059c7:	1e                   	push   %ds
  pushl %es
801059c8:	06                   	push   %es
  pushl %fs
801059c9:	0f a0                	push   %fs
  pushl %gs
801059cb:	0f a8                	push   %gs
  pushal
801059cd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801059ce:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801059d2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801059d4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801059d6:	54                   	push   %esp
  call trap
801059d7:	e8 c4 00 00 00       	call   80105aa0 <trap>
  addl $4, %esp
801059dc:	83 c4 04             	add    $0x4,%esp

801059df <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801059df:	61                   	popa   
  popl %gs
801059e0:	0f a9                	pop    %gs
  popl %fs
801059e2:	0f a1                	pop    %fs
  popl %es
801059e4:	07                   	pop    %es
  popl %ds
801059e5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801059e6:	83 c4 08             	add    $0x8,%esp
  iret
801059e9:	cf                   	iret   
801059ea:	66 90                	xchg   %ax,%ax
801059ec:	66 90                	xchg   %ax,%ax
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801059f0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801059f1:	31 c0                	xor    %eax,%eax
{
801059f3:	89 e5                	mov    %esp,%ebp
801059f5:	83 ec 08             	sub    $0x8,%esp
801059f8:	90                   	nop
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a00:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a07:	c7 04 c5 c2 5d 11 80 	movl   $0x8e000008,-0x7feea23e(,%eax,8)
80105a0e:	08 00 00 8e 
80105a12:	66 89 14 c5 c0 5d 11 	mov    %dx,-0x7feea240(,%eax,8)
80105a19:	80 
80105a1a:	c1 ea 10             	shr    $0x10,%edx
80105a1d:	66 89 14 c5 c6 5d 11 	mov    %dx,-0x7feea23a(,%eax,8)
80105a24:	80 
  for(i = 0; i < 256; i++)
80105a25:	83 c0 01             	add    $0x1,%eax
80105a28:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a2d:	75 d1                	jne    80105a00 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a2f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105a34:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a37:	c7 05 c2 5f 11 80 08 	movl   $0xef000008,0x80115fc2
80105a3e:	00 00 ef 
  initlock(&tickslock, "time");
80105a41:	68 25 7b 10 80       	push   $0x80107b25
80105a46:	68 80 5d 11 80       	push   $0x80115d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a4b:	66 a3 c0 5f 11 80    	mov    %ax,0x80115fc0
80105a51:	c1 e8 10             	shr    $0x10,%eax
80105a54:	66 a3 c6 5f 11 80    	mov    %ax,0x80115fc6
  initlock(&tickslock, "time");
80105a5a:	e8 81 ea ff ff       	call   801044e0 <initlock>
}
80105a5f:	83 c4 10             	add    $0x10,%esp
80105a62:	c9                   	leave  
80105a63:	c3                   	ret    
80105a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105a70 <idtinit>:

void
idtinit(void)
{
80105a70:	55                   	push   %ebp
  pd[0] = size-1;
80105a71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a76:	89 e5                	mov    %esp,%ebp
80105a78:	83 ec 10             	sub    $0x10,%esp
80105a7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105a7f:	b8 c0 5d 11 80       	mov    $0x80115dc0,%eax
80105a84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105a88:	c1 e8 10             	shr    $0x10,%eax
80105a8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105a8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
80105a97:	89 f6                	mov    %esi,%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105aa0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
80105aa5:	53                   	push   %ebx
80105aa6:	83 ec 1c             	sub    $0x1c,%esp
80105aa9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105aac:	8b 47 30             	mov    0x30(%edi),%eax
80105aaf:	83 f8 40             	cmp    $0x40,%eax
80105ab2:	0f 84 f0 00 00 00    	je     80105ba8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ab8:	83 e8 20             	sub    $0x20,%eax
80105abb:	83 f8 1f             	cmp    $0x1f,%eax
80105abe:	77 10                	ja     80105ad0 <trap+0x30>
80105ac0:	ff 24 85 cc 7b 10 80 	jmp    *-0x7fef8434(,%eax,4)
80105ac7:	89 f6                	mov    %esi,%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ad0:	e8 9b dd ff ff       	call   80103870 <myproc>
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105ada:	0f 84 24 02 00 00    	je     80105d04 <trap+0x264>
80105ae0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105ae4:	0f 84 1a 02 00 00    	je     80105d04 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105aea:	0f 20 d1             	mov    %cr2,%ecx
80105aed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105af0:	e8 5b dd ff ff       	call   80103850 <cpuid>
80105af5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105af8:	8b 47 34             	mov    0x34(%edi),%eax
80105afb:	8b 77 30             	mov    0x30(%edi),%esi
80105afe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105b01:	e8 6a dd ff ff       	call   80103870 <myproc>
80105b06:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b09:	e8 62 dd ff ff       	call   80103870 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b0e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105b11:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105b14:	51                   	push   %ecx
80105b15:	53                   	push   %ebx
80105b16:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105b17:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b1a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b1d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105b1e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b21:	52                   	push   %edx
80105b22:	ff 70 10             	pushl  0x10(%eax)
80105b25:	68 88 7b 10 80       	push   $0x80107b88
80105b2a:	e8 41 ab ff ff       	call   80100670 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105b2f:	83 c4 20             	add    $0x20,%esp
80105b32:	e8 39 dd ff ff       	call   80103870 <myproc>
80105b37:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b3e:	e8 2d dd ff ff       	call   80103870 <myproc>
80105b43:	85 c0                	test   %eax,%eax
80105b45:	74 1d                	je     80105b64 <trap+0xc4>
80105b47:	e8 24 dd ff ff       	call   80103870 <myproc>
80105b4c:	8b 50 24             	mov    0x24(%eax),%edx
80105b4f:	85 d2                	test   %edx,%edx
80105b51:	74 11                	je     80105b64 <trap+0xc4>
80105b53:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105b57:	83 e0 03             	and    $0x3,%eax
80105b5a:	66 83 f8 03          	cmp    $0x3,%ax
80105b5e:	0f 84 5c 01 00 00    	je     80105cc0 <trap+0x220>
    exit();

  //brand new
  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b64:	e8 07 dd ff ff       	call   80103870 <myproc>
80105b69:	85 c0                	test   %eax,%eax
80105b6b:	74 0b                	je     80105b78 <trap+0xd8>
80105b6d:	e8 fe dc ff ff       	call   80103870 <myproc>
80105b72:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b76:	74 68                	je     80105be0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER && (--myproc()->timepiece)<=0)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b78:	e8 f3 dc ff ff       	call   80103870 <myproc>
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	74 19                	je     80105b9a <trap+0xfa>
80105b81:	e8 ea dc ff ff       	call   80103870 <myproc>
80105b86:	8b 40 24             	mov    0x24(%eax),%eax
80105b89:	85 c0                	test   %eax,%eax
80105b8b:	74 0d                	je     80105b9a <trap+0xfa>
80105b8d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105b91:	83 e0 03             	and    $0x3,%eax
80105b94:	66 83 f8 03          	cmp    $0x3,%ax
80105b98:	74 37                	je     80105bd1 <trap+0x131>
    exit();
}
80105b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b9d:	5b                   	pop    %ebx
80105b9e:	5e                   	pop    %esi
80105b9f:	5f                   	pop    %edi
80105ba0:	5d                   	pop    %ebp
80105ba1:	c3                   	ret    
80105ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105ba8:	e8 c3 dc ff ff       	call   80103870 <myproc>
80105bad:	8b 58 24             	mov    0x24(%eax),%ebx
80105bb0:	85 db                	test   %ebx,%ebx
80105bb2:	0f 85 f8 00 00 00    	jne    80105cb0 <trap+0x210>
    myproc()->tf = tf;
80105bb8:	e8 b3 dc ff ff       	call   80103870 <myproc>
80105bbd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105bc0:	e8 7b ef ff ff       	call   80104b40 <syscall>
    if(myproc()->killed)
80105bc5:	e8 a6 dc ff ff       	call   80103870 <myproc>
80105bca:	8b 48 24             	mov    0x24(%eax),%ecx
80105bcd:	85 c9                	test   %ecx,%ecx
80105bcf:	74 c9                	je     80105b9a <trap+0xfa>
}
80105bd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bd4:	5b                   	pop    %ebx
80105bd5:	5e                   	pop    %esi
80105bd6:	5f                   	pop    %edi
80105bd7:	5d                   	pop    %ebp
      exit();
80105bd8:	e9 43 e3 ff ff       	jmp    80103f20 <exit>
80105bdd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105be0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105be4:	75 92                	jne    80105b78 <trap+0xd8>
     tf->trapno == T_IRQ0+IRQ_TIMER && (--myproc()->timepiece)<=0)
80105be6:	e8 85 dc ff ff       	call   80103870 <myproc>
80105beb:	83 a8 84 00 00 00 01 	subl   $0x1,0x84(%eax)
80105bf2:	75 84                	jne    80105b78 <trap+0xd8>
    yield();
80105bf4:	e8 17 e4 ff ff       	call   80104010 <yield>
80105bf9:	e9 7a ff ff ff       	jmp    80105b78 <trap+0xd8>
80105bfe:	66 90                	xchg   %ax,%ax
    if(cpuid() == 0){
80105c00:	e8 4b dc ff ff       	call   80103850 <cpuid>
80105c05:	85 c0                	test   %eax,%eax
80105c07:	0f 84 c3 00 00 00    	je     80105cd0 <trap+0x230>
    lapiceoi();
80105c0d:	e8 be cb ff ff       	call   801027d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c12:	e8 59 dc ff ff       	call   80103870 <myproc>
80105c17:	85 c0                	test   %eax,%eax
80105c19:	0f 85 28 ff ff ff    	jne    80105b47 <trap+0xa7>
80105c1f:	e9 40 ff ff ff       	jmp    80105b64 <trap+0xc4>
80105c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105c28:	e8 63 ca ff ff       	call   80102690 <kbdintr>
    lapiceoi();
80105c2d:	e8 9e cb ff ff       	call   801027d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c32:	e8 39 dc ff ff       	call   80103870 <myproc>
80105c37:	85 c0                	test   %eax,%eax
80105c39:	0f 85 08 ff ff ff    	jne    80105b47 <trap+0xa7>
80105c3f:	e9 20 ff ff ff       	jmp    80105b64 <trap+0xc4>
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105c48:	e8 53 02 00 00       	call   80105ea0 <uartintr>
    lapiceoi();
80105c4d:	e8 7e cb ff ff       	call   801027d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c52:	e8 19 dc ff ff       	call   80103870 <myproc>
80105c57:	85 c0                	test   %eax,%eax
80105c59:	0f 85 e8 fe ff ff    	jne    80105b47 <trap+0xa7>
80105c5f:	e9 00 ff ff ff       	jmp    80105b64 <trap+0xc4>
80105c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105c68:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105c6c:	8b 77 38             	mov    0x38(%edi),%esi
80105c6f:	e8 dc db ff ff       	call   80103850 <cpuid>
80105c74:	56                   	push   %esi
80105c75:	53                   	push   %ebx
80105c76:	50                   	push   %eax
80105c77:	68 30 7b 10 80       	push   $0x80107b30
80105c7c:	e8 ef a9 ff ff       	call   80100670 <cprintf>
    lapiceoi();
80105c81:	e8 4a cb ff ff       	call   801027d0 <lapiceoi>
    break;
80105c86:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c89:	e8 e2 db ff ff       	call   80103870 <myproc>
80105c8e:	85 c0                	test   %eax,%eax
80105c90:	0f 85 b1 fe ff ff    	jne    80105b47 <trap+0xa7>
80105c96:	e9 c9 fe ff ff       	jmp    80105b64 <trap+0xc4>
80105c9b:	90                   	nop
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105ca0:	e8 5b c4 ff ff       	call   80102100 <ideintr>
80105ca5:	e9 63 ff ff ff       	jmp    80105c0d <trap+0x16d>
80105caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105cb0:	e8 6b e2 ff ff       	call   80103f20 <exit>
80105cb5:	e9 fe fe ff ff       	jmp    80105bb8 <trap+0x118>
80105cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105cc0:	e8 5b e2 ff ff       	call   80103f20 <exit>
80105cc5:	e9 9a fe ff ff       	jmp    80105b64 <trap+0xc4>
80105cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	68 80 5d 11 80       	push   $0x80115d80
80105cd8:	e8 f3 e8 ff ff       	call   801045d0 <acquire>
      wakeup(&ticks);
80105cdd:	c7 04 24 c0 65 11 80 	movl   $0x801165c0,(%esp)
      ticks++;
80105ce4:	83 05 c0 65 11 80 01 	addl   $0x1,0x801165c0
      wakeup(&ticks);
80105ceb:	e8 60 e5 ff ff       	call   80104250 <wakeup>
      release(&tickslock);
80105cf0:	c7 04 24 80 5d 11 80 	movl   $0x80115d80,(%esp)
80105cf7:	e8 f4 e9 ff ff       	call   801046f0 <release>
80105cfc:	83 c4 10             	add    $0x10,%esp
80105cff:	e9 09 ff ff ff       	jmp    80105c0d <trap+0x16d>
80105d04:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d07:	e8 44 db ff ff       	call   80103850 <cpuid>
80105d0c:	83 ec 0c             	sub    $0xc,%esp
80105d0f:	56                   	push   %esi
80105d10:	53                   	push   %ebx
80105d11:	50                   	push   %eax
80105d12:	ff 77 30             	pushl  0x30(%edi)
80105d15:	68 54 7b 10 80       	push   $0x80107b54
80105d1a:	e8 51 a9 ff ff       	call   80100670 <cprintf>
      panic("trap");
80105d1f:	83 c4 14             	add    $0x14,%esp
80105d22:	68 2a 7b 10 80       	push   $0x80107b2a
80105d27:	e8 64 a6 ff ff       	call   80100390 <panic>
80105d2c:	66 90                	xchg   %ax,%ax
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d30:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105d35:	55                   	push   %ebp
80105d36:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105d38:	85 c0                	test   %eax,%eax
80105d3a:	74 1c                	je     80105d58 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d3c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d41:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d42:	a8 01                	test   $0x1,%al
80105d44:	74 12                	je     80105d58 <uartgetc+0x28>
80105d46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d4b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d4c:	0f b6 c0             	movzbl %al,%eax
}
80105d4f:	5d                   	pop    %ebp
80105d50:	c3                   	ret    
80105d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d5d:	5d                   	pop    %ebp
80105d5e:	c3                   	ret    
80105d5f:	90                   	nop

80105d60 <uartputc.part.0>:
uartputc(int c)
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	57                   	push   %edi
80105d64:	56                   	push   %esi
80105d65:	53                   	push   %ebx
80105d66:	89 c7                	mov    %eax,%edi
80105d68:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d72:	83 ec 0c             	sub    $0xc,%esp
80105d75:	eb 1b                	jmp    80105d92 <uartputc.part.0+0x32>
80105d77:	89 f6                	mov    %esi,%esi
80105d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	6a 0a                	push   $0xa
80105d85:	e8 66 ca ff ff       	call   801027f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d8a:	83 c4 10             	add    $0x10,%esp
80105d8d:	83 eb 01             	sub    $0x1,%ebx
80105d90:	74 07                	je     80105d99 <uartputc.part.0+0x39>
80105d92:	89 f2                	mov    %esi,%edx
80105d94:	ec                   	in     (%dx),%al
80105d95:	a8 20                	test   $0x20,%al
80105d97:	74 e7                	je     80105d80 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d9e:	89 f8                	mov    %edi,%eax
80105da0:	ee                   	out    %al,(%dx)
}
80105da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da4:	5b                   	pop    %ebx
80105da5:	5e                   	pop    %esi
80105da6:	5f                   	pop    %edi
80105da7:	5d                   	pop    %ebp
80105da8:	c3                   	ret    
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105db0 <uartinit>:
{
80105db0:	55                   	push   %ebp
80105db1:	31 c9                	xor    %ecx,%ecx
80105db3:	89 c8                	mov    %ecx,%eax
80105db5:	89 e5                	mov    %esp,%ebp
80105db7:	57                   	push   %edi
80105db8:	56                   	push   %esi
80105db9:	53                   	push   %ebx
80105dba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105dbf:	89 da                	mov    %ebx,%edx
80105dc1:	83 ec 0c             	sub    $0xc,%esp
80105dc4:	ee                   	out    %al,(%dx)
80105dc5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105dca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105dcf:	89 fa                	mov    %edi,%edx
80105dd1:	ee                   	out    %al,(%dx)
80105dd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105dd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ddc:	ee                   	out    %al,(%dx)
80105ddd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105de2:	89 c8                	mov    %ecx,%eax
80105de4:	89 f2                	mov    %esi,%edx
80105de6:	ee                   	out    %al,(%dx)
80105de7:	b8 03 00 00 00       	mov    $0x3,%eax
80105dec:	89 fa                	mov    %edi,%edx
80105dee:	ee                   	out    %al,(%dx)
80105def:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105df4:	89 c8                	mov    %ecx,%eax
80105df6:	ee                   	out    %al,(%dx)
80105df7:	b8 01 00 00 00       	mov    $0x1,%eax
80105dfc:	89 f2                	mov    %esi,%edx
80105dfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105dff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e04:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e05:	3c ff                	cmp    $0xff,%al
80105e07:	74 5a                	je     80105e63 <uartinit+0xb3>
  uart = 1;
80105e09:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105e10:	00 00 00 
80105e13:	89 da                	mov    %ebx,%edx
80105e15:	ec                   	in     (%dx),%al
80105e16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e1b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e1c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105e1f:	bb 4c 7c 10 80       	mov    $0x80107c4c,%ebx
  ioapicenable(IRQ_COM1, 0);
80105e24:	6a 00                	push   $0x0
80105e26:	6a 04                	push   $0x4
80105e28:	e8 23 c5 ff ff       	call   80102350 <ioapicenable>
80105e2d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105e30:	b8 78 00 00 00       	mov    $0x78,%eax
80105e35:	eb 13                	jmp    80105e4a <uartinit+0x9a>
80105e37:	89 f6                	mov    %esi,%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e40:	83 c3 01             	add    $0x1,%ebx
80105e43:	0f be 03             	movsbl (%ebx),%eax
80105e46:	84 c0                	test   %al,%al
80105e48:	74 19                	je     80105e63 <uartinit+0xb3>
  if(!uart)
80105e4a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105e50:	85 d2                	test   %edx,%edx
80105e52:	74 ec                	je     80105e40 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105e54:	83 c3 01             	add    $0x1,%ebx
80105e57:	e8 04 ff ff ff       	call   80105d60 <uartputc.part.0>
80105e5c:	0f be 03             	movsbl (%ebx),%eax
80105e5f:	84 c0                	test   %al,%al
80105e61:	75 e7                	jne    80105e4a <uartinit+0x9a>
}
80105e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e66:	5b                   	pop    %ebx
80105e67:	5e                   	pop    %esi
80105e68:	5f                   	pop    %edi
80105e69:	5d                   	pop    %ebp
80105e6a:	c3                   	ret    
80105e6b:	90                   	nop
80105e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e70 <uartputc>:
  if(!uart)
80105e70:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105e76:	55                   	push   %ebp
80105e77:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105e79:	85 d2                	test   %edx,%edx
{
80105e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105e7e:	74 10                	je     80105e90 <uartputc+0x20>
}
80105e80:	5d                   	pop    %ebp
80105e81:	e9 da fe ff ff       	jmp    80105d60 <uartputc.part.0>
80105e86:	8d 76 00             	lea    0x0(%esi),%esi
80105e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e90:	5d                   	pop    %ebp
80105e91:	c3                   	ret    
80105e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ea0 <uartintr>:

void
uartintr(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105ea6:	68 30 5d 10 80       	push   $0x80105d30
80105eab:	e8 70 a9 ff ff       	call   80100820 <consoleintr>
}
80105eb0:	83 c4 10             	add    $0x10,%esp
80105eb3:	c9                   	leave  
80105eb4:	c3                   	ret    

80105eb5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $0
80105eb7:	6a 00                	push   $0x0
  jmp alltraps
80105eb9:	e9 09 fb ff ff       	jmp    801059c7 <alltraps>

80105ebe <vector1>:
.globl vector1
vector1:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $1
80105ec0:	6a 01                	push   $0x1
  jmp alltraps
80105ec2:	e9 00 fb ff ff       	jmp    801059c7 <alltraps>

80105ec7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $2
80105ec9:	6a 02                	push   $0x2
  jmp alltraps
80105ecb:	e9 f7 fa ff ff       	jmp    801059c7 <alltraps>

80105ed0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $3
80105ed2:	6a 03                	push   $0x3
  jmp alltraps
80105ed4:	e9 ee fa ff ff       	jmp    801059c7 <alltraps>

80105ed9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $4
80105edb:	6a 04                	push   $0x4
  jmp alltraps
80105edd:	e9 e5 fa ff ff       	jmp    801059c7 <alltraps>

80105ee2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $5
80105ee4:	6a 05                	push   $0x5
  jmp alltraps
80105ee6:	e9 dc fa ff ff       	jmp    801059c7 <alltraps>

80105eeb <vector6>:
.globl vector6
vector6:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $6
80105eed:	6a 06                	push   $0x6
  jmp alltraps
80105eef:	e9 d3 fa ff ff       	jmp    801059c7 <alltraps>

80105ef4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $7
80105ef6:	6a 07                	push   $0x7
  jmp alltraps
80105ef8:	e9 ca fa ff ff       	jmp    801059c7 <alltraps>

80105efd <vector8>:
.globl vector8
vector8:
  pushl $8
80105efd:	6a 08                	push   $0x8
  jmp alltraps
80105eff:	e9 c3 fa ff ff       	jmp    801059c7 <alltraps>

80105f04 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f04:	6a 00                	push   $0x0
  pushl $9
80105f06:	6a 09                	push   $0x9
  jmp alltraps
80105f08:	e9 ba fa ff ff       	jmp    801059c7 <alltraps>

80105f0d <vector10>:
.globl vector10
vector10:
  pushl $10
80105f0d:	6a 0a                	push   $0xa
  jmp alltraps
80105f0f:	e9 b3 fa ff ff       	jmp    801059c7 <alltraps>

80105f14 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f14:	6a 0b                	push   $0xb
  jmp alltraps
80105f16:	e9 ac fa ff ff       	jmp    801059c7 <alltraps>

80105f1b <vector12>:
.globl vector12
vector12:
  pushl $12
80105f1b:	6a 0c                	push   $0xc
  jmp alltraps
80105f1d:	e9 a5 fa ff ff       	jmp    801059c7 <alltraps>

80105f22 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f22:	6a 0d                	push   $0xd
  jmp alltraps
80105f24:	e9 9e fa ff ff       	jmp    801059c7 <alltraps>

80105f29 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f29:	6a 0e                	push   $0xe
  jmp alltraps
80105f2b:	e9 97 fa ff ff       	jmp    801059c7 <alltraps>

80105f30 <vector15>:
.globl vector15
vector15:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $15
80105f32:	6a 0f                	push   $0xf
  jmp alltraps
80105f34:	e9 8e fa ff ff       	jmp    801059c7 <alltraps>

80105f39 <vector16>:
.globl vector16
vector16:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $16
80105f3b:	6a 10                	push   $0x10
  jmp alltraps
80105f3d:	e9 85 fa ff ff       	jmp    801059c7 <alltraps>

80105f42 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f42:	6a 11                	push   $0x11
  jmp alltraps
80105f44:	e9 7e fa ff ff       	jmp    801059c7 <alltraps>

80105f49 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $18
80105f4b:	6a 12                	push   $0x12
  jmp alltraps
80105f4d:	e9 75 fa ff ff       	jmp    801059c7 <alltraps>

80105f52 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $19
80105f54:	6a 13                	push   $0x13
  jmp alltraps
80105f56:	e9 6c fa ff ff       	jmp    801059c7 <alltraps>

80105f5b <vector20>:
.globl vector20
vector20:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $20
80105f5d:	6a 14                	push   $0x14
  jmp alltraps
80105f5f:	e9 63 fa ff ff       	jmp    801059c7 <alltraps>

80105f64 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $21
80105f66:	6a 15                	push   $0x15
  jmp alltraps
80105f68:	e9 5a fa ff ff       	jmp    801059c7 <alltraps>

80105f6d <vector22>:
.globl vector22
vector22:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $22
80105f6f:	6a 16                	push   $0x16
  jmp alltraps
80105f71:	e9 51 fa ff ff       	jmp    801059c7 <alltraps>

80105f76 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $23
80105f78:	6a 17                	push   $0x17
  jmp alltraps
80105f7a:	e9 48 fa ff ff       	jmp    801059c7 <alltraps>

80105f7f <vector24>:
.globl vector24
vector24:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $24
80105f81:	6a 18                	push   $0x18
  jmp alltraps
80105f83:	e9 3f fa ff ff       	jmp    801059c7 <alltraps>

80105f88 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $25
80105f8a:	6a 19                	push   $0x19
  jmp alltraps
80105f8c:	e9 36 fa ff ff       	jmp    801059c7 <alltraps>

80105f91 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f91:	6a 00                	push   $0x0
  pushl $26
80105f93:	6a 1a                	push   $0x1a
  jmp alltraps
80105f95:	e9 2d fa ff ff       	jmp    801059c7 <alltraps>

80105f9a <vector27>:
.globl vector27
vector27:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $27
80105f9c:	6a 1b                	push   $0x1b
  jmp alltraps
80105f9e:	e9 24 fa ff ff       	jmp    801059c7 <alltraps>

80105fa3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $28
80105fa5:	6a 1c                	push   $0x1c
  jmp alltraps
80105fa7:	e9 1b fa ff ff       	jmp    801059c7 <alltraps>

80105fac <vector29>:
.globl vector29
vector29:
  pushl $0
80105fac:	6a 00                	push   $0x0
  pushl $29
80105fae:	6a 1d                	push   $0x1d
  jmp alltraps
80105fb0:	e9 12 fa ff ff       	jmp    801059c7 <alltraps>

80105fb5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $30
80105fb7:	6a 1e                	push   $0x1e
  jmp alltraps
80105fb9:	e9 09 fa ff ff       	jmp    801059c7 <alltraps>

80105fbe <vector31>:
.globl vector31
vector31:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $31
80105fc0:	6a 1f                	push   $0x1f
  jmp alltraps
80105fc2:	e9 00 fa ff ff       	jmp    801059c7 <alltraps>

80105fc7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $32
80105fc9:	6a 20                	push   $0x20
  jmp alltraps
80105fcb:	e9 f7 f9 ff ff       	jmp    801059c7 <alltraps>

80105fd0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $33
80105fd2:	6a 21                	push   $0x21
  jmp alltraps
80105fd4:	e9 ee f9 ff ff       	jmp    801059c7 <alltraps>

80105fd9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $34
80105fdb:	6a 22                	push   $0x22
  jmp alltraps
80105fdd:	e9 e5 f9 ff ff       	jmp    801059c7 <alltraps>

80105fe2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $35
80105fe4:	6a 23                	push   $0x23
  jmp alltraps
80105fe6:	e9 dc f9 ff ff       	jmp    801059c7 <alltraps>

80105feb <vector36>:
.globl vector36
vector36:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $36
80105fed:	6a 24                	push   $0x24
  jmp alltraps
80105fef:	e9 d3 f9 ff ff       	jmp    801059c7 <alltraps>

80105ff4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $37
80105ff6:	6a 25                	push   $0x25
  jmp alltraps
80105ff8:	e9 ca f9 ff ff       	jmp    801059c7 <alltraps>

80105ffd <vector38>:
.globl vector38
vector38:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $38
80105fff:	6a 26                	push   $0x26
  jmp alltraps
80106001:	e9 c1 f9 ff ff       	jmp    801059c7 <alltraps>

80106006 <vector39>:
.globl vector39
vector39:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $39
80106008:	6a 27                	push   $0x27
  jmp alltraps
8010600a:	e9 b8 f9 ff ff       	jmp    801059c7 <alltraps>

8010600f <vector40>:
.globl vector40
vector40:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $40
80106011:	6a 28                	push   $0x28
  jmp alltraps
80106013:	e9 af f9 ff ff       	jmp    801059c7 <alltraps>

80106018 <vector41>:
.globl vector41
vector41:
  pushl $0
80106018:	6a 00                	push   $0x0
  pushl $41
8010601a:	6a 29                	push   $0x29
  jmp alltraps
8010601c:	e9 a6 f9 ff ff       	jmp    801059c7 <alltraps>

80106021 <vector42>:
.globl vector42
vector42:
  pushl $0
80106021:	6a 00                	push   $0x0
  pushl $42
80106023:	6a 2a                	push   $0x2a
  jmp alltraps
80106025:	e9 9d f9 ff ff       	jmp    801059c7 <alltraps>

8010602a <vector43>:
.globl vector43
vector43:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $43
8010602c:	6a 2b                	push   $0x2b
  jmp alltraps
8010602e:	e9 94 f9 ff ff       	jmp    801059c7 <alltraps>

80106033 <vector44>:
.globl vector44
vector44:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $44
80106035:	6a 2c                	push   $0x2c
  jmp alltraps
80106037:	e9 8b f9 ff ff       	jmp    801059c7 <alltraps>

8010603c <vector45>:
.globl vector45
vector45:
  pushl $0
8010603c:	6a 00                	push   $0x0
  pushl $45
8010603e:	6a 2d                	push   $0x2d
  jmp alltraps
80106040:	e9 82 f9 ff ff       	jmp    801059c7 <alltraps>

80106045 <vector46>:
.globl vector46
vector46:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $46
80106047:	6a 2e                	push   $0x2e
  jmp alltraps
80106049:	e9 79 f9 ff ff       	jmp    801059c7 <alltraps>

8010604e <vector47>:
.globl vector47
vector47:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $47
80106050:	6a 2f                	push   $0x2f
  jmp alltraps
80106052:	e9 70 f9 ff ff       	jmp    801059c7 <alltraps>

80106057 <vector48>:
.globl vector48
vector48:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $48
80106059:	6a 30                	push   $0x30
  jmp alltraps
8010605b:	e9 67 f9 ff ff       	jmp    801059c7 <alltraps>

80106060 <vector49>:
.globl vector49
vector49:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $49
80106062:	6a 31                	push   $0x31
  jmp alltraps
80106064:	e9 5e f9 ff ff       	jmp    801059c7 <alltraps>

80106069 <vector50>:
.globl vector50
vector50:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $50
8010606b:	6a 32                	push   $0x32
  jmp alltraps
8010606d:	e9 55 f9 ff ff       	jmp    801059c7 <alltraps>

80106072 <vector51>:
.globl vector51
vector51:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $51
80106074:	6a 33                	push   $0x33
  jmp alltraps
80106076:	e9 4c f9 ff ff       	jmp    801059c7 <alltraps>

8010607b <vector52>:
.globl vector52
vector52:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $52
8010607d:	6a 34                	push   $0x34
  jmp alltraps
8010607f:	e9 43 f9 ff ff       	jmp    801059c7 <alltraps>

80106084 <vector53>:
.globl vector53
vector53:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $53
80106086:	6a 35                	push   $0x35
  jmp alltraps
80106088:	e9 3a f9 ff ff       	jmp    801059c7 <alltraps>

8010608d <vector54>:
.globl vector54
vector54:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $54
8010608f:	6a 36                	push   $0x36
  jmp alltraps
80106091:	e9 31 f9 ff ff       	jmp    801059c7 <alltraps>

80106096 <vector55>:
.globl vector55
vector55:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $55
80106098:	6a 37                	push   $0x37
  jmp alltraps
8010609a:	e9 28 f9 ff ff       	jmp    801059c7 <alltraps>

8010609f <vector56>:
.globl vector56
vector56:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $56
801060a1:	6a 38                	push   $0x38
  jmp alltraps
801060a3:	e9 1f f9 ff ff       	jmp    801059c7 <alltraps>

801060a8 <vector57>:
.globl vector57
vector57:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $57
801060aa:	6a 39                	push   $0x39
  jmp alltraps
801060ac:	e9 16 f9 ff ff       	jmp    801059c7 <alltraps>

801060b1 <vector58>:
.globl vector58
vector58:
  pushl $0
801060b1:	6a 00                	push   $0x0
  pushl $58
801060b3:	6a 3a                	push   $0x3a
  jmp alltraps
801060b5:	e9 0d f9 ff ff       	jmp    801059c7 <alltraps>

801060ba <vector59>:
.globl vector59
vector59:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $59
801060bc:	6a 3b                	push   $0x3b
  jmp alltraps
801060be:	e9 04 f9 ff ff       	jmp    801059c7 <alltraps>

801060c3 <vector60>:
.globl vector60
vector60:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $60
801060c5:	6a 3c                	push   $0x3c
  jmp alltraps
801060c7:	e9 fb f8 ff ff       	jmp    801059c7 <alltraps>

801060cc <vector61>:
.globl vector61
vector61:
  pushl $0
801060cc:	6a 00                	push   $0x0
  pushl $61
801060ce:	6a 3d                	push   $0x3d
  jmp alltraps
801060d0:	e9 f2 f8 ff ff       	jmp    801059c7 <alltraps>

801060d5 <vector62>:
.globl vector62
vector62:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $62
801060d7:	6a 3e                	push   $0x3e
  jmp alltraps
801060d9:	e9 e9 f8 ff ff       	jmp    801059c7 <alltraps>

801060de <vector63>:
.globl vector63
vector63:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $63
801060e0:	6a 3f                	push   $0x3f
  jmp alltraps
801060e2:	e9 e0 f8 ff ff       	jmp    801059c7 <alltraps>

801060e7 <vector64>:
.globl vector64
vector64:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $64
801060e9:	6a 40                	push   $0x40
  jmp alltraps
801060eb:	e9 d7 f8 ff ff       	jmp    801059c7 <alltraps>

801060f0 <vector65>:
.globl vector65
vector65:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $65
801060f2:	6a 41                	push   $0x41
  jmp alltraps
801060f4:	e9 ce f8 ff ff       	jmp    801059c7 <alltraps>

801060f9 <vector66>:
.globl vector66
vector66:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $66
801060fb:	6a 42                	push   $0x42
  jmp alltraps
801060fd:	e9 c5 f8 ff ff       	jmp    801059c7 <alltraps>

80106102 <vector67>:
.globl vector67
vector67:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $67
80106104:	6a 43                	push   $0x43
  jmp alltraps
80106106:	e9 bc f8 ff ff       	jmp    801059c7 <alltraps>

8010610b <vector68>:
.globl vector68
vector68:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $68
8010610d:	6a 44                	push   $0x44
  jmp alltraps
8010610f:	e9 b3 f8 ff ff       	jmp    801059c7 <alltraps>

80106114 <vector69>:
.globl vector69
vector69:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $69
80106116:	6a 45                	push   $0x45
  jmp alltraps
80106118:	e9 aa f8 ff ff       	jmp    801059c7 <alltraps>

8010611d <vector70>:
.globl vector70
vector70:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $70
8010611f:	6a 46                	push   $0x46
  jmp alltraps
80106121:	e9 a1 f8 ff ff       	jmp    801059c7 <alltraps>

80106126 <vector71>:
.globl vector71
vector71:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $71
80106128:	6a 47                	push   $0x47
  jmp alltraps
8010612a:	e9 98 f8 ff ff       	jmp    801059c7 <alltraps>

8010612f <vector72>:
.globl vector72
vector72:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $72
80106131:	6a 48                	push   $0x48
  jmp alltraps
80106133:	e9 8f f8 ff ff       	jmp    801059c7 <alltraps>

80106138 <vector73>:
.globl vector73
vector73:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $73
8010613a:	6a 49                	push   $0x49
  jmp alltraps
8010613c:	e9 86 f8 ff ff       	jmp    801059c7 <alltraps>

80106141 <vector74>:
.globl vector74
vector74:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $74
80106143:	6a 4a                	push   $0x4a
  jmp alltraps
80106145:	e9 7d f8 ff ff       	jmp    801059c7 <alltraps>

8010614a <vector75>:
.globl vector75
vector75:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $75
8010614c:	6a 4b                	push   $0x4b
  jmp alltraps
8010614e:	e9 74 f8 ff ff       	jmp    801059c7 <alltraps>

80106153 <vector76>:
.globl vector76
vector76:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $76
80106155:	6a 4c                	push   $0x4c
  jmp alltraps
80106157:	e9 6b f8 ff ff       	jmp    801059c7 <alltraps>

8010615c <vector77>:
.globl vector77
vector77:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $77
8010615e:	6a 4d                	push   $0x4d
  jmp alltraps
80106160:	e9 62 f8 ff ff       	jmp    801059c7 <alltraps>

80106165 <vector78>:
.globl vector78
vector78:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $78
80106167:	6a 4e                	push   $0x4e
  jmp alltraps
80106169:	e9 59 f8 ff ff       	jmp    801059c7 <alltraps>

8010616e <vector79>:
.globl vector79
vector79:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $79
80106170:	6a 4f                	push   $0x4f
  jmp alltraps
80106172:	e9 50 f8 ff ff       	jmp    801059c7 <alltraps>

80106177 <vector80>:
.globl vector80
vector80:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $80
80106179:	6a 50                	push   $0x50
  jmp alltraps
8010617b:	e9 47 f8 ff ff       	jmp    801059c7 <alltraps>

80106180 <vector81>:
.globl vector81
vector81:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $81
80106182:	6a 51                	push   $0x51
  jmp alltraps
80106184:	e9 3e f8 ff ff       	jmp    801059c7 <alltraps>

80106189 <vector82>:
.globl vector82
vector82:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $82
8010618b:	6a 52                	push   $0x52
  jmp alltraps
8010618d:	e9 35 f8 ff ff       	jmp    801059c7 <alltraps>

80106192 <vector83>:
.globl vector83
vector83:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $83
80106194:	6a 53                	push   $0x53
  jmp alltraps
80106196:	e9 2c f8 ff ff       	jmp    801059c7 <alltraps>

8010619b <vector84>:
.globl vector84
vector84:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $84
8010619d:	6a 54                	push   $0x54
  jmp alltraps
8010619f:	e9 23 f8 ff ff       	jmp    801059c7 <alltraps>

801061a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $85
801061a6:	6a 55                	push   $0x55
  jmp alltraps
801061a8:	e9 1a f8 ff ff       	jmp    801059c7 <alltraps>

801061ad <vector86>:
.globl vector86
vector86:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $86
801061af:	6a 56                	push   $0x56
  jmp alltraps
801061b1:	e9 11 f8 ff ff       	jmp    801059c7 <alltraps>

801061b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $87
801061b8:	6a 57                	push   $0x57
  jmp alltraps
801061ba:	e9 08 f8 ff ff       	jmp    801059c7 <alltraps>

801061bf <vector88>:
.globl vector88
vector88:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $88
801061c1:	6a 58                	push   $0x58
  jmp alltraps
801061c3:	e9 ff f7 ff ff       	jmp    801059c7 <alltraps>

801061c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $89
801061ca:	6a 59                	push   $0x59
  jmp alltraps
801061cc:	e9 f6 f7 ff ff       	jmp    801059c7 <alltraps>

801061d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $90
801061d3:	6a 5a                	push   $0x5a
  jmp alltraps
801061d5:	e9 ed f7 ff ff       	jmp    801059c7 <alltraps>

801061da <vector91>:
.globl vector91
vector91:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $91
801061dc:	6a 5b                	push   $0x5b
  jmp alltraps
801061de:	e9 e4 f7 ff ff       	jmp    801059c7 <alltraps>

801061e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $92
801061e5:	6a 5c                	push   $0x5c
  jmp alltraps
801061e7:	e9 db f7 ff ff       	jmp    801059c7 <alltraps>

801061ec <vector93>:
.globl vector93
vector93:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $93
801061ee:	6a 5d                	push   $0x5d
  jmp alltraps
801061f0:	e9 d2 f7 ff ff       	jmp    801059c7 <alltraps>

801061f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $94
801061f7:	6a 5e                	push   $0x5e
  jmp alltraps
801061f9:	e9 c9 f7 ff ff       	jmp    801059c7 <alltraps>

801061fe <vector95>:
.globl vector95
vector95:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $95
80106200:	6a 5f                	push   $0x5f
  jmp alltraps
80106202:	e9 c0 f7 ff ff       	jmp    801059c7 <alltraps>

80106207 <vector96>:
.globl vector96
vector96:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $96
80106209:	6a 60                	push   $0x60
  jmp alltraps
8010620b:	e9 b7 f7 ff ff       	jmp    801059c7 <alltraps>

80106210 <vector97>:
.globl vector97
vector97:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $97
80106212:	6a 61                	push   $0x61
  jmp alltraps
80106214:	e9 ae f7 ff ff       	jmp    801059c7 <alltraps>

80106219 <vector98>:
.globl vector98
vector98:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $98
8010621b:	6a 62                	push   $0x62
  jmp alltraps
8010621d:	e9 a5 f7 ff ff       	jmp    801059c7 <alltraps>

80106222 <vector99>:
.globl vector99
vector99:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $99
80106224:	6a 63                	push   $0x63
  jmp alltraps
80106226:	e9 9c f7 ff ff       	jmp    801059c7 <alltraps>

8010622b <vector100>:
.globl vector100
vector100:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $100
8010622d:	6a 64                	push   $0x64
  jmp alltraps
8010622f:	e9 93 f7 ff ff       	jmp    801059c7 <alltraps>

80106234 <vector101>:
.globl vector101
vector101:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $101
80106236:	6a 65                	push   $0x65
  jmp alltraps
80106238:	e9 8a f7 ff ff       	jmp    801059c7 <alltraps>

8010623d <vector102>:
.globl vector102
vector102:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $102
8010623f:	6a 66                	push   $0x66
  jmp alltraps
80106241:	e9 81 f7 ff ff       	jmp    801059c7 <alltraps>

80106246 <vector103>:
.globl vector103
vector103:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $103
80106248:	6a 67                	push   $0x67
  jmp alltraps
8010624a:	e9 78 f7 ff ff       	jmp    801059c7 <alltraps>

8010624f <vector104>:
.globl vector104
vector104:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $104
80106251:	6a 68                	push   $0x68
  jmp alltraps
80106253:	e9 6f f7 ff ff       	jmp    801059c7 <alltraps>

80106258 <vector105>:
.globl vector105
vector105:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $105
8010625a:	6a 69                	push   $0x69
  jmp alltraps
8010625c:	e9 66 f7 ff ff       	jmp    801059c7 <alltraps>

80106261 <vector106>:
.globl vector106
vector106:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $106
80106263:	6a 6a                	push   $0x6a
  jmp alltraps
80106265:	e9 5d f7 ff ff       	jmp    801059c7 <alltraps>

8010626a <vector107>:
.globl vector107
vector107:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $107
8010626c:	6a 6b                	push   $0x6b
  jmp alltraps
8010626e:	e9 54 f7 ff ff       	jmp    801059c7 <alltraps>

80106273 <vector108>:
.globl vector108
vector108:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $108
80106275:	6a 6c                	push   $0x6c
  jmp alltraps
80106277:	e9 4b f7 ff ff       	jmp    801059c7 <alltraps>

8010627c <vector109>:
.globl vector109
vector109:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $109
8010627e:	6a 6d                	push   $0x6d
  jmp alltraps
80106280:	e9 42 f7 ff ff       	jmp    801059c7 <alltraps>

80106285 <vector110>:
.globl vector110
vector110:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $110
80106287:	6a 6e                	push   $0x6e
  jmp alltraps
80106289:	e9 39 f7 ff ff       	jmp    801059c7 <alltraps>

8010628e <vector111>:
.globl vector111
vector111:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $111
80106290:	6a 6f                	push   $0x6f
  jmp alltraps
80106292:	e9 30 f7 ff ff       	jmp    801059c7 <alltraps>

80106297 <vector112>:
.globl vector112
vector112:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $112
80106299:	6a 70                	push   $0x70
  jmp alltraps
8010629b:	e9 27 f7 ff ff       	jmp    801059c7 <alltraps>

801062a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $113
801062a2:	6a 71                	push   $0x71
  jmp alltraps
801062a4:	e9 1e f7 ff ff       	jmp    801059c7 <alltraps>

801062a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $114
801062ab:	6a 72                	push   $0x72
  jmp alltraps
801062ad:	e9 15 f7 ff ff       	jmp    801059c7 <alltraps>

801062b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $115
801062b4:	6a 73                	push   $0x73
  jmp alltraps
801062b6:	e9 0c f7 ff ff       	jmp    801059c7 <alltraps>

801062bb <vector116>:
.globl vector116
vector116:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $116
801062bd:	6a 74                	push   $0x74
  jmp alltraps
801062bf:	e9 03 f7 ff ff       	jmp    801059c7 <alltraps>

801062c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $117
801062c6:	6a 75                	push   $0x75
  jmp alltraps
801062c8:	e9 fa f6 ff ff       	jmp    801059c7 <alltraps>

801062cd <vector118>:
.globl vector118
vector118:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $118
801062cf:	6a 76                	push   $0x76
  jmp alltraps
801062d1:	e9 f1 f6 ff ff       	jmp    801059c7 <alltraps>

801062d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $119
801062d8:	6a 77                	push   $0x77
  jmp alltraps
801062da:	e9 e8 f6 ff ff       	jmp    801059c7 <alltraps>

801062df <vector120>:
.globl vector120
vector120:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $120
801062e1:	6a 78                	push   $0x78
  jmp alltraps
801062e3:	e9 df f6 ff ff       	jmp    801059c7 <alltraps>

801062e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $121
801062ea:	6a 79                	push   $0x79
  jmp alltraps
801062ec:	e9 d6 f6 ff ff       	jmp    801059c7 <alltraps>

801062f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $122
801062f3:	6a 7a                	push   $0x7a
  jmp alltraps
801062f5:	e9 cd f6 ff ff       	jmp    801059c7 <alltraps>

801062fa <vector123>:
.globl vector123
vector123:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $123
801062fc:	6a 7b                	push   $0x7b
  jmp alltraps
801062fe:	e9 c4 f6 ff ff       	jmp    801059c7 <alltraps>

80106303 <vector124>:
.globl vector124
vector124:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $124
80106305:	6a 7c                	push   $0x7c
  jmp alltraps
80106307:	e9 bb f6 ff ff       	jmp    801059c7 <alltraps>

8010630c <vector125>:
.globl vector125
vector125:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $125
8010630e:	6a 7d                	push   $0x7d
  jmp alltraps
80106310:	e9 b2 f6 ff ff       	jmp    801059c7 <alltraps>

80106315 <vector126>:
.globl vector126
vector126:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $126
80106317:	6a 7e                	push   $0x7e
  jmp alltraps
80106319:	e9 a9 f6 ff ff       	jmp    801059c7 <alltraps>

8010631e <vector127>:
.globl vector127
vector127:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $127
80106320:	6a 7f                	push   $0x7f
  jmp alltraps
80106322:	e9 a0 f6 ff ff       	jmp    801059c7 <alltraps>

80106327 <vector128>:
.globl vector128
vector128:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $128
80106329:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010632e:	e9 94 f6 ff ff       	jmp    801059c7 <alltraps>

80106333 <vector129>:
.globl vector129
vector129:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $129
80106335:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010633a:	e9 88 f6 ff ff       	jmp    801059c7 <alltraps>

8010633f <vector130>:
.globl vector130
vector130:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $130
80106341:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106346:	e9 7c f6 ff ff       	jmp    801059c7 <alltraps>

8010634b <vector131>:
.globl vector131
vector131:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $131
8010634d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106352:	e9 70 f6 ff ff       	jmp    801059c7 <alltraps>

80106357 <vector132>:
.globl vector132
vector132:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $132
80106359:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010635e:	e9 64 f6 ff ff       	jmp    801059c7 <alltraps>

80106363 <vector133>:
.globl vector133
vector133:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $133
80106365:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010636a:	e9 58 f6 ff ff       	jmp    801059c7 <alltraps>

8010636f <vector134>:
.globl vector134
vector134:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $134
80106371:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106376:	e9 4c f6 ff ff       	jmp    801059c7 <alltraps>

8010637b <vector135>:
.globl vector135
vector135:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $135
8010637d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106382:	e9 40 f6 ff ff       	jmp    801059c7 <alltraps>

80106387 <vector136>:
.globl vector136
vector136:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $136
80106389:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010638e:	e9 34 f6 ff ff       	jmp    801059c7 <alltraps>

80106393 <vector137>:
.globl vector137
vector137:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $137
80106395:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010639a:	e9 28 f6 ff ff       	jmp    801059c7 <alltraps>

8010639f <vector138>:
.globl vector138
vector138:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $138
801063a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801063a6:	e9 1c f6 ff ff       	jmp    801059c7 <alltraps>

801063ab <vector139>:
.globl vector139
vector139:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $139
801063ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801063b2:	e9 10 f6 ff ff       	jmp    801059c7 <alltraps>

801063b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $140
801063b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801063be:	e9 04 f6 ff ff       	jmp    801059c7 <alltraps>

801063c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $141
801063c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801063ca:	e9 f8 f5 ff ff       	jmp    801059c7 <alltraps>

801063cf <vector142>:
.globl vector142
vector142:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $142
801063d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801063d6:	e9 ec f5 ff ff       	jmp    801059c7 <alltraps>

801063db <vector143>:
.globl vector143
vector143:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $143
801063dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801063e2:	e9 e0 f5 ff ff       	jmp    801059c7 <alltraps>

801063e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $144
801063e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801063ee:	e9 d4 f5 ff ff       	jmp    801059c7 <alltraps>

801063f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $145
801063f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801063fa:	e9 c8 f5 ff ff       	jmp    801059c7 <alltraps>

801063ff <vector146>:
.globl vector146
vector146:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $146
80106401:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106406:	e9 bc f5 ff ff       	jmp    801059c7 <alltraps>

8010640b <vector147>:
.globl vector147
vector147:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $147
8010640d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106412:	e9 b0 f5 ff ff       	jmp    801059c7 <alltraps>

80106417 <vector148>:
.globl vector148
vector148:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $148
80106419:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010641e:	e9 a4 f5 ff ff       	jmp    801059c7 <alltraps>

80106423 <vector149>:
.globl vector149
vector149:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $149
80106425:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010642a:	e9 98 f5 ff ff       	jmp    801059c7 <alltraps>

8010642f <vector150>:
.globl vector150
vector150:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $150
80106431:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106436:	e9 8c f5 ff ff       	jmp    801059c7 <alltraps>

8010643b <vector151>:
.globl vector151
vector151:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $151
8010643d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106442:	e9 80 f5 ff ff       	jmp    801059c7 <alltraps>

80106447 <vector152>:
.globl vector152
vector152:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $152
80106449:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010644e:	e9 74 f5 ff ff       	jmp    801059c7 <alltraps>

80106453 <vector153>:
.globl vector153
vector153:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $153
80106455:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010645a:	e9 68 f5 ff ff       	jmp    801059c7 <alltraps>

8010645f <vector154>:
.globl vector154
vector154:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $154
80106461:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106466:	e9 5c f5 ff ff       	jmp    801059c7 <alltraps>

8010646b <vector155>:
.globl vector155
vector155:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $155
8010646d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106472:	e9 50 f5 ff ff       	jmp    801059c7 <alltraps>

80106477 <vector156>:
.globl vector156
vector156:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $156
80106479:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010647e:	e9 44 f5 ff ff       	jmp    801059c7 <alltraps>

80106483 <vector157>:
.globl vector157
vector157:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $157
80106485:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010648a:	e9 38 f5 ff ff       	jmp    801059c7 <alltraps>

8010648f <vector158>:
.globl vector158
vector158:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $158
80106491:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106496:	e9 2c f5 ff ff       	jmp    801059c7 <alltraps>

8010649b <vector159>:
.globl vector159
vector159:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $159
8010649d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801064a2:	e9 20 f5 ff ff       	jmp    801059c7 <alltraps>

801064a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $160
801064a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801064ae:	e9 14 f5 ff ff       	jmp    801059c7 <alltraps>

801064b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $161
801064b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801064ba:	e9 08 f5 ff ff       	jmp    801059c7 <alltraps>

801064bf <vector162>:
.globl vector162
vector162:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $162
801064c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801064c6:	e9 fc f4 ff ff       	jmp    801059c7 <alltraps>

801064cb <vector163>:
.globl vector163
vector163:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $163
801064cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801064d2:	e9 f0 f4 ff ff       	jmp    801059c7 <alltraps>

801064d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $164
801064d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801064de:	e9 e4 f4 ff ff       	jmp    801059c7 <alltraps>

801064e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $165
801064e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801064ea:	e9 d8 f4 ff ff       	jmp    801059c7 <alltraps>

801064ef <vector166>:
.globl vector166
vector166:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $166
801064f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801064f6:	e9 cc f4 ff ff       	jmp    801059c7 <alltraps>

801064fb <vector167>:
.globl vector167
vector167:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $167
801064fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106502:	e9 c0 f4 ff ff       	jmp    801059c7 <alltraps>

80106507 <vector168>:
.globl vector168
vector168:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $168
80106509:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010650e:	e9 b4 f4 ff ff       	jmp    801059c7 <alltraps>

80106513 <vector169>:
.globl vector169
vector169:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $169
80106515:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010651a:	e9 a8 f4 ff ff       	jmp    801059c7 <alltraps>

8010651f <vector170>:
.globl vector170
vector170:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $170
80106521:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106526:	e9 9c f4 ff ff       	jmp    801059c7 <alltraps>

8010652b <vector171>:
.globl vector171
vector171:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $171
8010652d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106532:	e9 90 f4 ff ff       	jmp    801059c7 <alltraps>

80106537 <vector172>:
.globl vector172
vector172:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $172
80106539:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010653e:	e9 84 f4 ff ff       	jmp    801059c7 <alltraps>

80106543 <vector173>:
.globl vector173
vector173:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $173
80106545:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010654a:	e9 78 f4 ff ff       	jmp    801059c7 <alltraps>

8010654f <vector174>:
.globl vector174
vector174:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $174
80106551:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106556:	e9 6c f4 ff ff       	jmp    801059c7 <alltraps>

8010655b <vector175>:
.globl vector175
vector175:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $175
8010655d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106562:	e9 60 f4 ff ff       	jmp    801059c7 <alltraps>

80106567 <vector176>:
.globl vector176
vector176:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $176
80106569:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010656e:	e9 54 f4 ff ff       	jmp    801059c7 <alltraps>

80106573 <vector177>:
.globl vector177
vector177:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $177
80106575:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010657a:	e9 48 f4 ff ff       	jmp    801059c7 <alltraps>

8010657f <vector178>:
.globl vector178
vector178:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $178
80106581:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106586:	e9 3c f4 ff ff       	jmp    801059c7 <alltraps>

8010658b <vector179>:
.globl vector179
vector179:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $179
8010658d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106592:	e9 30 f4 ff ff       	jmp    801059c7 <alltraps>

80106597 <vector180>:
.globl vector180
vector180:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $180
80106599:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010659e:	e9 24 f4 ff ff       	jmp    801059c7 <alltraps>

801065a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $181
801065a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801065aa:	e9 18 f4 ff ff       	jmp    801059c7 <alltraps>

801065af <vector182>:
.globl vector182
vector182:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $182
801065b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801065b6:	e9 0c f4 ff ff       	jmp    801059c7 <alltraps>

801065bb <vector183>:
.globl vector183
vector183:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $183
801065bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801065c2:	e9 00 f4 ff ff       	jmp    801059c7 <alltraps>

801065c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $184
801065c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801065ce:	e9 f4 f3 ff ff       	jmp    801059c7 <alltraps>

801065d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $185
801065d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801065da:	e9 e8 f3 ff ff       	jmp    801059c7 <alltraps>

801065df <vector186>:
.globl vector186
vector186:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $186
801065e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801065e6:	e9 dc f3 ff ff       	jmp    801059c7 <alltraps>

801065eb <vector187>:
.globl vector187
vector187:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $187
801065ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801065f2:	e9 d0 f3 ff ff       	jmp    801059c7 <alltraps>

801065f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $188
801065f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801065fe:	e9 c4 f3 ff ff       	jmp    801059c7 <alltraps>

80106603 <vector189>:
.globl vector189
vector189:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $189
80106605:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010660a:	e9 b8 f3 ff ff       	jmp    801059c7 <alltraps>

8010660f <vector190>:
.globl vector190
vector190:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $190
80106611:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106616:	e9 ac f3 ff ff       	jmp    801059c7 <alltraps>

8010661b <vector191>:
.globl vector191
vector191:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $191
8010661d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106622:	e9 a0 f3 ff ff       	jmp    801059c7 <alltraps>

80106627 <vector192>:
.globl vector192
vector192:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $192
80106629:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010662e:	e9 94 f3 ff ff       	jmp    801059c7 <alltraps>

80106633 <vector193>:
.globl vector193
vector193:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $193
80106635:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010663a:	e9 88 f3 ff ff       	jmp    801059c7 <alltraps>

8010663f <vector194>:
.globl vector194
vector194:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $194
80106641:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106646:	e9 7c f3 ff ff       	jmp    801059c7 <alltraps>

8010664b <vector195>:
.globl vector195
vector195:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $195
8010664d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106652:	e9 70 f3 ff ff       	jmp    801059c7 <alltraps>

80106657 <vector196>:
.globl vector196
vector196:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $196
80106659:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010665e:	e9 64 f3 ff ff       	jmp    801059c7 <alltraps>

80106663 <vector197>:
.globl vector197
vector197:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $197
80106665:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010666a:	e9 58 f3 ff ff       	jmp    801059c7 <alltraps>

8010666f <vector198>:
.globl vector198
vector198:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $198
80106671:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106676:	e9 4c f3 ff ff       	jmp    801059c7 <alltraps>

8010667b <vector199>:
.globl vector199
vector199:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $199
8010667d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106682:	e9 40 f3 ff ff       	jmp    801059c7 <alltraps>

80106687 <vector200>:
.globl vector200
vector200:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $200
80106689:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010668e:	e9 34 f3 ff ff       	jmp    801059c7 <alltraps>

80106693 <vector201>:
.globl vector201
vector201:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $201
80106695:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010669a:	e9 28 f3 ff ff       	jmp    801059c7 <alltraps>

8010669f <vector202>:
.globl vector202
vector202:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $202
801066a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801066a6:	e9 1c f3 ff ff       	jmp    801059c7 <alltraps>

801066ab <vector203>:
.globl vector203
vector203:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $203
801066ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801066b2:	e9 10 f3 ff ff       	jmp    801059c7 <alltraps>

801066b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $204
801066b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801066be:	e9 04 f3 ff ff       	jmp    801059c7 <alltraps>

801066c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $205
801066c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801066ca:	e9 f8 f2 ff ff       	jmp    801059c7 <alltraps>

801066cf <vector206>:
.globl vector206
vector206:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $206
801066d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801066d6:	e9 ec f2 ff ff       	jmp    801059c7 <alltraps>

801066db <vector207>:
.globl vector207
vector207:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $207
801066dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801066e2:	e9 e0 f2 ff ff       	jmp    801059c7 <alltraps>

801066e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $208
801066e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801066ee:	e9 d4 f2 ff ff       	jmp    801059c7 <alltraps>

801066f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $209
801066f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801066fa:	e9 c8 f2 ff ff       	jmp    801059c7 <alltraps>

801066ff <vector210>:
.globl vector210
vector210:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $210
80106701:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106706:	e9 bc f2 ff ff       	jmp    801059c7 <alltraps>

8010670b <vector211>:
.globl vector211
vector211:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $211
8010670d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106712:	e9 b0 f2 ff ff       	jmp    801059c7 <alltraps>

80106717 <vector212>:
.globl vector212
vector212:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $212
80106719:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010671e:	e9 a4 f2 ff ff       	jmp    801059c7 <alltraps>

80106723 <vector213>:
.globl vector213
vector213:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $213
80106725:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010672a:	e9 98 f2 ff ff       	jmp    801059c7 <alltraps>

8010672f <vector214>:
.globl vector214
vector214:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $214
80106731:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106736:	e9 8c f2 ff ff       	jmp    801059c7 <alltraps>

8010673b <vector215>:
.globl vector215
vector215:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $215
8010673d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106742:	e9 80 f2 ff ff       	jmp    801059c7 <alltraps>

80106747 <vector216>:
.globl vector216
vector216:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $216
80106749:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010674e:	e9 74 f2 ff ff       	jmp    801059c7 <alltraps>

80106753 <vector217>:
.globl vector217
vector217:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $217
80106755:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010675a:	e9 68 f2 ff ff       	jmp    801059c7 <alltraps>

8010675f <vector218>:
.globl vector218
vector218:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $218
80106761:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106766:	e9 5c f2 ff ff       	jmp    801059c7 <alltraps>

8010676b <vector219>:
.globl vector219
vector219:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $219
8010676d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106772:	e9 50 f2 ff ff       	jmp    801059c7 <alltraps>

80106777 <vector220>:
.globl vector220
vector220:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $220
80106779:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010677e:	e9 44 f2 ff ff       	jmp    801059c7 <alltraps>

80106783 <vector221>:
.globl vector221
vector221:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $221
80106785:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010678a:	e9 38 f2 ff ff       	jmp    801059c7 <alltraps>

8010678f <vector222>:
.globl vector222
vector222:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $222
80106791:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106796:	e9 2c f2 ff ff       	jmp    801059c7 <alltraps>

8010679b <vector223>:
.globl vector223
vector223:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $223
8010679d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801067a2:	e9 20 f2 ff ff       	jmp    801059c7 <alltraps>

801067a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $224
801067a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801067ae:	e9 14 f2 ff ff       	jmp    801059c7 <alltraps>

801067b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $225
801067b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801067ba:	e9 08 f2 ff ff       	jmp    801059c7 <alltraps>

801067bf <vector226>:
.globl vector226
vector226:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $226
801067c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801067c6:	e9 fc f1 ff ff       	jmp    801059c7 <alltraps>

801067cb <vector227>:
.globl vector227
vector227:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $227
801067cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801067d2:	e9 f0 f1 ff ff       	jmp    801059c7 <alltraps>

801067d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $228
801067d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801067de:	e9 e4 f1 ff ff       	jmp    801059c7 <alltraps>

801067e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $229
801067e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801067ea:	e9 d8 f1 ff ff       	jmp    801059c7 <alltraps>

801067ef <vector230>:
.globl vector230
vector230:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $230
801067f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801067f6:	e9 cc f1 ff ff       	jmp    801059c7 <alltraps>

801067fb <vector231>:
.globl vector231
vector231:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $231
801067fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106802:	e9 c0 f1 ff ff       	jmp    801059c7 <alltraps>

80106807 <vector232>:
.globl vector232
vector232:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $232
80106809:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010680e:	e9 b4 f1 ff ff       	jmp    801059c7 <alltraps>

80106813 <vector233>:
.globl vector233
vector233:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $233
80106815:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010681a:	e9 a8 f1 ff ff       	jmp    801059c7 <alltraps>

8010681f <vector234>:
.globl vector234
vector234:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $234
80106821:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106826:	e9 9c f1 ff ff       	jmp    801059c7 <alltraps>

8010682b <vector235>:
.globl vector235
vector235:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $235
8010682d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106832:	e9 90 f1 ff ff       	jmp    801059c7 <alltraps>

80106837 <vector236>:
.globl vector236
vector236:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $236
80106839:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010683e:	e9 84 f1 ff ff       	jmp    801059c7 <alltraps>

80106843 <vector237>:
.globl vector237
vector237:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $237
80106845:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010684a:	e9 78 f1 ff ff       	jmp    801059c7 <alltraps>

8010684f <vector238>:
.globl vector238
vector238:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $238
80106851:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106856:	e9 6c f1 ff ff       	jmp    801059c7 <alltraps>

8010685b <vector239>:
.globl vector239
vector239:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $239
8010685d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106862:	e9 60 f1 ff ff       	jmp    801059c7 <alltraps>

80106867 <vector240>:
.globl vector240
vector240:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $240
80106869:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010686e:	e9 54 f1 ff ff       	jmp    801059c7 <alltraps>

80106873 <vector241>:
.globl vector241
vector241:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $241
80106875:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010687a:	e9 48 f1 ff ff       	jmp    801059c7 <alltraps>

8010687f <vector242>:
.globl vector242
vector242:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $242
80106881:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106886:	e9 3c f1 ff ff       	jmp    801059c7 <alltraps>

8010688b <vector243>:
.globl vector243
vector243:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $243
8010688d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106892:	e9 30 f1 ff ff       	jmp    801059c7 <alltraps>

80106897 <vector244>:
.globl vector244
vector244:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $244
80106899:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010689e:	e9 24 f1 ff ff       	jmp    801059c7 <alltraps>

801068a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $245
801068a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801068aa:	e9 18 f1 ff ff       	jmp    801059c7 <alltraps>

801068af <vector246>:
.globl vector246
vector246:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $246
801068b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801068b6:	e9 0c f1 ff ff       	jmp    801059c7 <alltraps>

801068bb <vector247>:
.globl vector247
vector247:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $247
801068bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801068c2:	e9 00 f1 ff ff       	jmp    801059c7 <alltraps>

801068c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $248
801068c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801068ce:	e9 f4 f0 ff ff       	jmp    801059c7 <alltraps>

801068d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $249
801068d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801068da:	e9 e8 f0 ff ff       	jmp    801059c7 <alltraps>

801068df <vector250>:
.globl vector250
vector250:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $250
801068e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801068e6:	e9 dc f0 ff ff       	jmp    801059c7 <alltraps>

801068eb <vector251>:
.globl vector251
vector251:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $251
801068ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801068f2:	e9 d0 f0 ff ff       	jmp    801059c7 <alltraps>

801068f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $252
801068f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801068fe:	e9 c4 f0 ff ff       	jmp    801059c7 <alltraps>

80106903 <vector253>:
.globl vector253
vector253:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $253
80106905:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010690a:	e9 b8 f0 ff ff       	jmp    801059c7 <alltraps>

8010690f <vector254>:
.globl vector254
vector254:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $254
80106911:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106916:	e9 ac f0 ff ff       	jmp    801059c7 <alltraps>

8010691b <vector255>:
.globl vector255
vector255:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $255
8010691d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106922:	e9 a0 f0 ff ff       	jmp    801059c7 <alltraps>
80106927:	66 90                	xchg   %ax,%ax
80106929:	66 90                	xchg   %ax,%ax
8010692b:	66 90                	xchg   %ax,%ax
8010692d:	66 90                	xchg   %ax,%ax
8010692f:	90                   	nop

80106930 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	57                   	push   %edi
80106934:	56                   	push   %esi
80106935:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106936:	89 d3                	mov    %edx,%ebx
{
80106938:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010693a:	c1 eb 16             	shr    $0x16,%ebx
8010693d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106940:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106943:	8b 06                	mov    (%esi),%eax
80106945:	a8 01                	test   $0x1,%al
80106947:	74 27                	je     80106970 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106949:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010694e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106954:	c1 ef 0a             	shr    $0xa,%edi
}
80106957:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010695a:	89 fa                	mov    %edi,%edx
8010695c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106962:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106965:	5b                   	pop    %ebx
80106966:	5e                   	pop    %esi
80106967:	5f                   	pop    %edi
80106968:	5d                   	pop    %ebp
80106969:	c3                   	ret    
8010696a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106970:	85 c9                	test   %ecx,%ecx
80106972:	74 2c                	je     801069a0 <walkpgdir+0x70>
80106974:	e8 c7 bb ff ff       	call   80102540 <kalloc>
80106979:	85 c0                	test   %eax,%eax
8010697b:	89 c3                	mov    %eax,%ebx
8010697d:	74 21                	je     801069a0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010697f:	83 ec 04             	sub    $0x4,%esp
80106982:	68 00 10 00 00       	push   $0x1000
80106987:	6a 00                	push   $0x0
80106989:	50                   	push   %eax
8010698a:	e8 c1 dd ff ff       	call   80104750 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010698f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106995:	83 c4 10             	add    $0x10,%esp
80106998:	83 c8 07             	or     $0x7,%eax
8010699b:	89 06                	mov    %eax,(%esi)
8010699d:	eb b5                	jmp    80106954 <walkpgdir+0x24>
8010699f:	90                   	nop
}
801069a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801069a3:	31 c0                	xor    %eax,%eax
}
801069a5:	5b                   	pop    %ebx
801069a6:	5e                   	pop    %esi
801069a7:	5f                   	pop    %edi
801069a8:	5d                   	pop    %ebp
801069a9:	c3                   	ret    
801069aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	57                   	push   %edi
801069b4:	56                   	push   %esi
801069b5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801069b6:	89 d3                	mov    %edx,%ebx
801069b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801069be:	83 ec 1c             	sub    $0x1c,%esp
801069c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801069c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801069c8:	8b 7d 08             	mov    0x8(%ebp),%edi
801069cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801069d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801069d6:	29 df                	sub    %ebx,%edi
801069d8:	83 c8 01             	or     $0x1,%eax
801069db:	89 45 dc             	mov    %eax,-0x24(%ebp)
801069de:	eb 15                	jmp    801069f5 <mappages+0x45>
    if(*pte & PTE_P)
801069e0:	f6 00 01             	testb  $0x1,(%eax)
801069e3:	75 45                	jne    80106a2a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801069e5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801069e8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801069eb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801069ed:	74 31                	je     80106a20 <mappages+0x70>
      break;
    a += PGSIZE;
801069ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801069f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801069fd:	89 da                	mov    %ebx,%edx
801069ff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106a02:	e8 29 ff ff ff       	call   80106930 <walkpgdir>
80106a07:	85 c0                	test   %eax,%eax
80106a09:	75 d5                	jne    801069e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106a0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a13:	5b                   	pop    %ebx
80106a14:	5e                   	pop    %esi
80106a15:	5f                   	pop    %edi
80106a16:	5d                   	pop    %ebp
80106a17:	c3                   	ret    
80106a18:	90                   	nop
80106a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a23:	31 c0                	xor    %eax,%eax
}
80106a25:	5b                   	pop    %ebx
80106a26:	5e                   	pop    %esi
80106a27:	5f                   	pop    %edi
80106a28:	5d                   	pop    %ebp
80106a29:	c3                   	ret    
      panic("remap");
80106a2a:	83 ec 0c             	sub    $0xc,%esp
80106a2d:	68 54 7c 10 80       	push   $0x80107c54
80106a32:	e8 59 99 ff ff       	call   80100390 <panic>
80106a37:	89 f6                	mov    %esi,%esi
80106a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a40 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
80106a45:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a46:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a4c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106a4e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a54:	83 ec 1c             	sub    $0x1c,%esp
80106a57:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a5a:	39 d3                	cmp    %edx,%ebx
80106a5c:	73 66                	jae    80106ac4 <deallocuvm.part.0+0x84>
80106a5e:	89 d6                	mov    %edx,%esi
80106a60:	eb 3d                	jmp    80106a9f <deallocuvm.part.0+0x5f>
80106a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106a68:	8b 10                	mov    (%eax),%edx
80106a6a:	f6 c2 01             	test   $0x1,%dl
80106a6d:	74 26                	je     80106a95 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106a6f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a75:	74 58                	je     80106acf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106a77:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a7a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106a83:	52                   	push   %edx
80106a84:	e8 07 b9 ff ff       	call   80102390 <kfree>
      *pte = 0;
80106a89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a8c:	83 c4 10             	add    $0x10,%esp
80106a8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106a95:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a9b:	39 f3                	cmp    %esi,%ebx
80106a9d:	73 25                	jae    80106ac4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106a9f:	31 c9                	xor    %ecx,%ecx
80106aa1:	89 da                	mov    %ebx,%edx
80106aa3:	89 f8                	mov    %edi,%eax
80106aa5:	e8 86 fe ff ff       	call   80106930 <walkpgdir>
    if(!pte)
80106aaa:	85 c0                	test   %eax,%eax
80106aac:	75 ba                	jne    80106a68 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106aae:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106ab4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106aba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ac0:	39 f3                	cmp    %esi,%ebx
80106ac2:	72 db                	jb     80106a9f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ac7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106aca:	5b                   	pop    %ebx
80106acb:	5e                   	pop    %esi
80106acc:	5f                   	pop    %edi
80106acd:	5d                   	pop    %ebp
80106ace:	c3                   	ret    
        panic("kfree");
80106acf:	83 ec 0c             	sub    $0xc,%esp
80106ad2:	68 e6 75 10 80       	push   $0x801075e6
80106ad7:	e8 b4 98 ff ff       	call   80100390 <panic>
80106adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ae0 <seginit>:
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ae6:	e8 65 cd ff ff       	call   80103850 <cpuid>
80106aeb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106af1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106af6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106afa:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106b01:	ff 00 00 
80106b04:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106b0b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b0e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106b15:	ff 00 00 
80106b18:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106b1f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b22:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106b29:	ff 00 00 
80106b2c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106b33:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b36:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106b3d:	ff 00 00 
80106b40:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106b47:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106b4a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106b4f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b53:	c1 e8 10             	shr    $0x10,%eax
80106b56:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106b5a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b5d:	0f 01 10             	lgdtl  (%eax)
}
80106b60:	c9                   	leave  
80106b61:	c3                   	ret    
80106b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b70 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b70:	a1 e0 65 11 80       	mov    0x801165e0,%eax
{
80106b75:	55                   	push   %ebp
80106b76:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b78:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b7d:	0f 22 d8             	mov    %eax,%cr3
}
80106b80:	5d                   	pop    %ebp
80106b81:	c3                   	ret    
80106b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b90 <switchuvm>:
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
80106b96:	83 ec 1c             	sub    $0x1c,%esp
80106b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106b9c:	85 db                	test   %ebx,%ebx
80106b9e:	0f 84 cb 00 00 00    	je     80106c6f <switchuvm+0xdf>
  if(p->kstack == 0)
80106ba4:	8b 43 08             	mov    0x8(%ebx),%eax
80106ba7:	85 c0                	test   %eax,%eax
80106ba9:	0f 84 da 00 00 00    	je     80106c89 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106baf:	8b 43 04             	mov    0x4(%ebx),%eax
80106bb2:	85 c0                	test   %eax,%eax
80106bb4:	0f 84 c2 00 00 00    	je     80106c7c <switchuvm+0xec>
  pushcli();
80106bba:	e8 d1 d9 ff ff       	call   80104590 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106bbf:	e8 0c cc ff ff       	call   801037d0 <mycpu>
80106bc4:	89 c6                	mov    %eax,%esi
80106bc6:	e8 05 cc ff ff       	call   801037d0 <mycpu>
80106bcb:	89 c7                	mov    %eax,%edi
80106bcd:	e8 fe cb ff ff       	call   801037d0 <mycpu>
80106bd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106bd5:	83 c7 08             	add    $0x8,%edi
80106bd8:	e8 f3 cb ff ff       	call   801037d0 <mycpu>
80106bdd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106be0:	83 c0 08             	add    $0x8,%eax
80106be3:	ba 67 00 00 00       	mov    $0x67,%edx
80106be8:	c1 e8 18             	shr    $0x18,%eax
80106beb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106bf2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106bf9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106bff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c04:	83 c1 08             	add    $0x8,%ecx
80106c07:	c1 e9 10             	shr    $0x10,%ecx
80106c0a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106c10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106c15:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c1c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106c21:	e8 aa cb ff ff       	call   801037d0 <mycpu>
80106c26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c2d:	e8 9e cb ff ff       	call   801037d0 <mycpu>
80106c32:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c36:	8b 73 08             	mov    0x8(%ebx),%esi
80106c39:	e8 92 cb ff ff       	call   801037d0 <mycpu>
80106c3e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106c44:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c47:	e8 84 cb ff ff       	call   801037d0 <mycpu>
80106c4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106c50:	b8 28 00 00 00       	mov    $0x28,%eax
80106c55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106c58:	8b 43 04             	mov    0x4(%ebx),%eax
80106c5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c60:	0f 22 d8             	mov    %eax,%cr3
}
80106c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c66:	5b                   	pop    %ebx
80106c67:	5e                   	pop    %esi
80106c68:	5f                   	pop    %edi
80106c69:	5d                   	pop    %ebp
  popcli();
80106c6a:	e9 21 da ff ff       	jmp    80104690 <popcli>
    panic("switchuvm: no process");
80106c6f:	83 ec 0c             	sub    $0xc,%esp
80106c72:	68 5a 7c 10 80       	push   $0x80107c5a
80106c77:	e8 14 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106c7c:	83 ec 0c             	sub    $0xc,%esp
80106c7f:	68 85 7c 10 80       	push   $0x80107c85
80106c84:	e8 07 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106c89:	83 ec 0c             	sub    $0xc,%esp
80106c8c:	68 70 7c 10 80       	push   $0x80107c70
80106c91:	e8 fa 96 ff ff       	call   80100390 <panic>
80106c96:	8d 76 00             	lea    0x0(%esi),%esi
80106c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ca0 <inituvm>:
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
80106ca6:	83 ec 1c             	sub    $0x1c,%esp
80106ca9:	8b 75 10             	mov    0x10(%ebp),%esi
80106cac:	8b 45 08             	mov    0x8(%ebp),%eax
80106caf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106cb2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106cb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106cbb:	77 49                	ja     80106d06 <inituvm+0x66>
  mem = kalloc();
80106cbd:	e8 7e b8 ff ff       	call   80102540 <kalloc>
  memset(mem, 0, PGSIZE);
80106cc2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106cc5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106cc7:	68 00 10 00 00       	push   $0x1000
80106ccc:	6a 00                	push   $0x0
80106cce:	50                   	push   %eax
80106ccf:	e8 7c da ff ff       	call   80104750 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106cd4:	58                   	pop    %eax
80106cd5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cdb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ce0:	5a                   	pop    %edx
80106ce1:	6a 06                	push   $0x6
80106ce3:	50                   	push   %eax
80106ce4:	31 d2                	xor    %edx,%edx
80106ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ce9:	e8 c2 fc ff ff       	call   801069b0 <mappages>
  memmove(mem, init, sz);
80106cee:	89 75 10             	mov    %esi,0x10(%ebp)
80106cf1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106cf4:	83 c4 10             	add    $0x10,%esp
80106cf7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cfd:	5b                   	pop    %ebx
80106cfe:	5e                   	pop    %esi
80106cff:	5f                   	pop    %edi
80106d00:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106d01:	e9 fa da ff ff       	jmp    80104800 <memmove>
    panic("inituvm: more than a page");
80106d06:	83 ec 0c             	sub    $0xc,%esp
80106d09:	68 99 7c 10 80       	push   $0x80107c99
80106d0e:	e8 7d 96 ff ff       	call   80100390 <panic>
80106d13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d20 <loaduvm>:
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106d29:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106d30:	0f 85 91 00 00 00    	jne    80106dc7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106d36:	8b 75 18             	mov    0x18(%ebp),%esi
80106d39:	31 db                	xor    %ebx,%ebx
80106d3b:	85 f6                	test   %esi,%esi
80106d3d:	75 1a                	jne    80106d59 <loaduvm+0x39>
80106d3f:	eb 6f                	jmp    80106db0 <loaduvm+0x90>
80106d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d48:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d4e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106d54:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106d57:	76 57                	jbe    80106db0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d59:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d5f:	31 c9                	xor    %ecx,%ecx
80106d61:	01 da                	add    %ebx,%edx
80106d63:	e8 c8 fb ff ff       	call   80106930 <walkpgdir>
80106d68:	85 c0                	test   %eax,%eax
80106d6a:	74 4e                	je     80106dba <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106d6c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106d71:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106d76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106d7b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d81:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d84:	01 d9                	add    %ebx,%ecx
80106d86:	05 00 00 00 80       	add    $0x80000000,%eax
80106d8b:	57                   	push   %edi
80106d8c:	51                   	push   %ecx
80106d8d:	50                   	push   %eax
80106d8e:	ff 75 10             	pushl  0x10(%ebp)
80106d91:	e8 4a ac ff ff       	call   801019e0 <readi>
80106d96:	83 c4 10             	add    $0x10,%esp
80106d99:	39 f8                	cmp    %edi,%eax
80106d9b:	74 ab                	je     80106d48 <loaduvm+0x28>
}
80106d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106da5:	5b                   	pop    %ebx
80106da6:	5e                   	pop    %esi
80106da7:	5f                   	pop    %edi
80106da8:	5d                   	pop    %ebp
80106da9:	c3                   	ret    
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106db3:	31 c0                	xor    %eax,%eax
}
80106db5:	5b                   	pop    %ebx
80106db6:	5e                   	pop    %esi
80106db7:	5f                   	pop    %edi
80106db8:	5d                   	pop    %ebp
80106db9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106dba:	83 ec 0c             	sub    $0xc,%esp
80106dbd:	68 b3 7c 10 80       	push   $0x80107cb3
80106dc2:	e8 c9 95 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106dc7:	83 ec 0c             	sub    $0xc,%esp
80106dca:	68 54 7d 10 80       	push   $0x80107d54
80106dcf:	e8 bc 95 ff ff       	call   80100390 <panic>
80106dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106de0 <sharevm>:
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	57                   	push   %edi
80106de4:	56                   	push   %esi
80106de5:	53                   	push   %ebx
80106de6:	83 ec 1c             	sub    $0x1c,%esp
80106de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dec:	8b 7d 08             	mov    0x8(%ebp),%edi
80106def:	8b 55 10             	mov    0x10(%ebp),%edx
  if(sharedmemo.recs[idx]>0){
80106df2:	8d 59 08             	lea    0x8(%ecx),%ebx
80106df5:	8b 04 9d 08 66 11 80 	mov    -0x7fee99f8(,%ebx,4),%eax
80106dfc:	85 c0                	test   %eax,%eax
80106dfe:	74 48                	je     80106e48 <sharevm+0x68>
    mem=sharedmemo.shared[idx];
80106e00:	8b 34 8d 00 66 11 80 	mov    -0x7fee9a00(,%ecx,4),%esi
  if(mappages(pgdir, (char*)(KERNBASE-(nshared+1)*PGSIZE), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e07:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e0d:	83 ec 08             	sub    $0x8,%esp
80106e10:	f7 da                	neg    %edx
80106e12:	6a 06                	push   $0x6
80106e14:	c1 e2 0c             	shl    $0xc,%edx
80106e17:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e1c:	50                   	push   %eax
80106e1d:	81 c2 00 f0 ff 7f    	add    $0x7ffff000,%edx
80106e23:	89 f8                	mov    %edi,%eax
80106e25:	e8 86 fb ff ff       	call   801069b0 <mappages>
80106e2a:	83 c4 10             	add    $0x10,%esp
80106e2d:	85 c0                	test   %eax,%eax
80106e2f:	78 5f                	js     80106e90 <sharevm+0xb0>
  sharedmemo.recs[idx]++;
80106e31:	83 04 9d 08 66 11 80 	addl   $0x1,-0x7fee99f8(,%ebx,4)
80106e38:	01 
}
80106e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e3c:	5b                   	pop    %ebx
80106e3d:	5e                   	pop    %esi
80106e3e:	5f                   	pop    %edi
80106e3f:	5d                   	pop    %ebp
80106e40:	c3                   	ret    
80106e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e48:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106e4b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    mem = kalloc();
80106e4e:	e8 ed b6 ff ff       	call   80102540 <kalloc>
    if(mem == 0){
80106e53:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106e55:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106e57:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106e5d:	74 51                	je     80106eb0 <sharevm+0xd0>
    memset(mem, 0, PGSIZE);
80106e5f:	83 ec 04             	sub    $0x4,%esp
80106e62:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106e65:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106e68:	68 00 10 00 00       	push   $0x1000
80106e6d:	6a 00                	push   $0x0
80106e6f:	50                   	push   %eax
80106e70:	e8 db d8 ff ff       	call   80104750 <memset>
    sharedmemo.shared[idx]=mem;
80106e75:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e78:	83 c4 10             	add    $0x10,%esp
80106e7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106e7e:	89 34 8d 00 66 11 80 	mov    %esi,-0x7fee9a00(,%ecx,4)
80106e85:	eb 80                	jmp    80106e07 <sharevm+0x27>
80106e87:	89 f6                	mov    %esi,%esi
80106e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("allocuvm out of memory (2)\n");
80106e90:	83 ec 0c             	sub    $0xc,%esp
80106e93:	68 e9 7c 10 80       	push   $0x80107ce9
80106e98:	e8 d3 97 ff ff       	call   80100670 <cprintf>
    kfree(mem);
80106e9d:	89 75 08             	mov    %esi,0x8(%ebp)
80106ea0:	83 c4 10             	add    $0x10,%esp
}
80106ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ea6:	5b                   	pop    %ebx
80106ea7:	5e                   	pop    %esi
80106ea8:	5f                   	pop    %edi
80106ea9:	5d                   	pop    %ebp
    kfree(mem);
80106eaa:	e9 e1 b4 ff ff       	jmp    80102390 <kfree>
80106eaf:	90                   	nop
      cprintf("allocuvm out of memory\n");
80106eb0:	c7 45 08 d1 7c 10 80 	movl   $0x80107cd1,0x8(%ebp)
}
80106eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eba:	5b                   	pop    %ebx
80106ebb:	5e                   	pop    %esi
80106ebc:	5f                   	pop    %edi
80106ebd:	5d                   	pop    %ebp
      cprintf("allocuvm out of memory\n");
80106ebe:	e9 ad 97 ff ff       	jmp    80100670 <cprintf>
80106ec3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ed0 <allocuvm>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 0c             	sub    $0xc,%esp
  if(newsz >= KERNBASE-nshared*PGSIZE)
80106ed9:	8b 45 14             	mov    0x14(%ebp),%eax
{
80106edc:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE-nshared*PGSIZE)
80106edf:	f7 d8                	neg    %eax
80106ee1:	c1 e0 0c             	shl    $0xc,%eax
80106ee4:	05 00 00 00 80       	add    $0x80000000,%eax
80106ee9:	39 f8                	cmp    %edi,%eax
80106eeb:	0f 86 7f 00 00 00    	jbe    80106f70 <allocuvm+0xa0>
  if(newsz < oldsz)
80106ef1:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106ef7:	72 79                	jb     80106f72 <allocuvm+0xa2>
  a = PGROUNDUP(oldsz);
80106ef9:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106eff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106f05:	39 df                	cmp    %ebx,%edi
80106f07:	77 42                	ja     80106f4b <allocuvm+0x7b>
80106f09:	eb 75                	jmp    80106f80 <allocuvm+0xb0>
80106f0b:	90                   	nop
80106f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106f10:	83 ec 04             	sub    $0x4,%esp
80106f13:	68 00 10 00 00       	push   $0x1000
80106f18:	6a 00                	push   $0x0
80106f1a:	50                   	push   %eax
80106f1b:	e8 30 d8 ff ff       	call   80104750 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f20:	58                   	pop    %eax
80106f21:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f27:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f2c:	5a                   	pop    %edx
80106f2d:	6a 06                	push   $0x6
80106f2f:	50                   	push   %eax
80106f30:	89 da                	mov    %ebx,%edx
80106f32:	8b 45 08             	mov    0x8(%ebp),%eax
80106f35:	e8 76 fa ff ff       	call   801069b0 <mappages>
80106f3a:	83 c4 10             	add    $0x10,%esp
80106f3d:	85 c0                	test   %eax,%eax
80106f3f:	78 4f                	js     80106f90 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106f41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f47:	39 df                	cmp    %ebx,%edi
80106f49:	76 35                	jbe    80106f80 <allocuvm+0xb0>
    mem = kalloc();
80106f4b:	e8 f0 b5 ff ff       	call   80102540 <kalloc>
    if(mem == 0){
80106f50:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106f52:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106f54:	75 ba                	jne    80106f10 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f56:	83 ec 0c             	sub    $0xc,%esp
80106f59:	68 d1 7c 10 80       	push   $0x80107cd1
80106f5e:	e8 0d 97 ff ff       	call   80100670 <cprintf>
  if(newsz >= oldsz)
80106f63:	83 c4 10             	add    $0x10,%esp
80106f66:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f69:	77 5d                	ja     80106fc8 <allocuvm+0xf8>
80106f6b:	90                   	nop
80106f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
80106f70:	31 c0                	xor    %eax,%eax
}
80106f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f75:	5b                   	pop    %ebx
80106f76:	5e                   	pop    %esi
80106f77:	5f                   	pop    %edi
80106f78:	5d                   	pop    %ebp
80106f79:	c3                   	ret    
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return newsz;
80106f83:	89 f8                	mov    %edi,%eax
}
80106f85:	5b                   	pop    %ebx
80106f86:	5e                   	pop    %esi
80106f87:	5f                   	pop    %edi
80106f88:	5d                   	pop    %ebp
80106f89:	c3                   	ret    
80106f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f90:	83 ec 0c             	sub    $0xc,%esp
80106f93:	68 e9 7c 10 80       	push   $0x80107ce9
80106f98:	e8 d3 96 ff ff       	call   80100670 <cprintf>
  if(newsz >= oldsz)
80106f9d:	83 c4 10             	add    $0x10,%esp
80106fa0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106fa3:	76 0d                	jbe    80106fb2 <allocuvm+0xe2>
80106fa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80106fab:	89 fa                	mov    %edi,%edx
80106fad:	e8 8e fa ff ff       	call   80106a40 <deallocuvm.part.0>
      kfree(mem);
80106fb2:	83 ec 0c             	sub    $0xc,%esp
80106fb5:	56                   	push   %esi
80106fb6:	e8 d5 b3 ff ff       	call   80102390 <kfree>
      return 0;
80106fbb:	83 c4 10             	add    $0x10,%esp
80106fbe:	31 c0                	xor    %eax,%eax
80106fc0:	eb b0                	jmp    80106f72 <allocuvm+0xa2>
80106fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fce:	89 fa                	mov    %edi,%edx
80106fd0:	e8 6b fa ff ff       	call   80106a40 <deallocuvm.part.0>
      return 0;
80106fd5:	31 c0                	xor    %eax,%eax
80106fd7:	eb 99                	jmp    80106f72 <allocuvm+0xa2>
80106fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fe0 <deallocuvm>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fe6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106fec:	39 d1                	cmp    %edx,%ecx
80106fee:	73 10                	jae    80107000 <deallocuvm+0x20>
}
80106ff0:	5d                   	pop    %ebp
80106ff1:	e9 4a fa ff ff       	jmp    80106a40 <deallocuvm.part.0>
80106ff6:	8d 76 00             	lea    0x0(%esi),%esi
80106ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107000:	89 d0                	mov    %edx,%eax
80107002:	5d                   	pop    %ebp
80107003:	c3                   	ret    
80107004:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010700a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107010 <desharevm>:

void
desharevm(int idx)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(sharedmemo.recs[idx]<=0)
80107016:	8d 51 08             	lea    0x8(%ecx),%edx
80107019:	8b 04 95 08 66 11 80 	mov    -0x7fee99f8(,%edx,4),%eax
80107020:	85 c0                	test   %eax,%eax
80107022:	74 0e                	je     80107032 <desharevm+0x22>
    return;

  sharedmemo.recs[idx]--;
80107024:	83 e8 01             	sub    $0x1,%eax
  if(sharedmemo.recs[idx]<=0){
80107027:	85 c0                	test   %eax,%eax
  sharedmemo.recs[idx]--;
80107029:	89 04 95 08 66 11 80 	mov    %eax,-0x7fee99f8(,%edx,4)
  if(sharedmemo.recs[idx]<=0){
80107030:	74 06                	je     80107038 <desharevm+0x28>
    kfree(sharedmemo.shared[idx]);
  }
}
80107032:	5d                   	pop    %ebp
80107033:	c3                   	ret    
80107034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(sharedmemo.shared[idx]);
80107038:	8b 04 8d 00 66 11 80 	mov    -0x7fee9a00(,%ecx,4),%eax
8010703f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80107042:	5d                   	pop    %ebp
    kfree(sharedmemo.shared[idx]);
80107043:	e9 48 b3 ff ff       	jmp    80102390 <kfree>
80107048:	90                   	nop
80107049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107050 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir,uint nshared)
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	57                   	push   %edi
80107054:	56                   	push   %esi
80107055:	53                   	push   %ebx
80107056:	83 ec 0c             	sub    $0xc,%esp
80107059:	8b 75 08             	mov    0x8(%ebp),%esi
8010705c:	8b 45 0c             	mov    0xc(%ebp),%eax
  uint i;

  if(pgdir == 0)
8010705f:	85 f6                	test   %esi,%esi
80107061:	74 61                	je     801070c4 <freevm+0x74>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE-nshared*PGSIZE, 0);
80107063:	f7 d8                	neg    %eax
80107065:	c1 e0 0c             	shl    $0xc,%eax
  if(newsz >= oldsz)
80107068:	05 00 00 00 80       	add    $0x80000000,%eax
8010706d:	89 c2                	mov    %eax,%edx
8010706f:	75 48                	jne    801070b9 <freevm+0x69>
80107071:	89 f3                	mov    %esi,%ebx
80107073:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107079:	eb 0c                	jmp    80107087 <freevm+0x37>
8010707b:	90                   	nop
8010707c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107080:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107083:	39 fb                	cmp    %edi,%ebx
80107085:	74 23                	je     801070aa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107087:	8b 03                	mov    (%ebx),%eax
80107089:	a8 01                	test   $0x1,%al
8010708b:	74 f3                	je     80107080 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010708d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107092:	83 ec 0c             	sub    $0xc,%esp
80107095:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107098:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010709d:	50                   	push   %eax
8010709e:	e8 ed b2 ff ff       	call   80102390 <kfree>
801070a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801070a6:	39 fb                	cmp    %edi,%ebx
801070a8:	75 dd                	jne    80107087 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801070aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801070ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b0:	5b                   	pop    %ebx
801070b1:	5e                   	pop    %esi
801070b2:	5f                   	pop    %edi
801070b3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801070b4:	e9 d7 b2 ff ff       	jmp    80102390 <kfree>
801070b9:	31 c9                	xor    %ecx,%ecx
801070bb:	89 f0                	mov    %esi,%eax
801070bd:	e8 7e f9 ff ff       	call   80106a40 <deallocuvm.part.0>
801070c2:	eb ad                	jmp    80107071 <freevm+0x21>
    panic("freevm: no pgdir");
801070c4:	83 ec 0c             	sub    $0xc,%esp
801070c7:	68 05 7d 10 80       	push   $0x80107d05
801070cc:	e8 bf 92 ff ff       	call   80100390 <panic>
801070d1:	eb 0d                	jmp    801070e0 <setupkvm>
801070d3:	90                   	nop
801070d4:	90                   	nop
801070d5:	90                   	nop
801070d6:	90                   	nop
801070d7:	90                   	nop
801070d8:	90                   	nop
801070d9:	90                   	nop
801070da:	90                   	nop
801070db:	90                   	nop
801070dc:	90                   	nop
801070dd:	90                   	nop
801070de:	90                   	nop
801070df:	90                   	nop

801070e0 <setupkvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	56                   	push   %esi
801070e4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801070e5:	e8 56 b4 ff ff       	call   80102540 <kalloc>
801070ea:	85 c0                	test   %eax,%eax
801070ec:	89 c6                	mov    %eax,%esi
801070ee:	74 42                	je     80107132 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801070f0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070f3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801070f8:	68 00 10 00 00       	push   $0x1000
801070fd:	6a 00                	push   $0x0
801070ff:	50                   	push   %eax
80107100:	e8 4b d6 ff ff       	call   80104750 <memset>
80107105:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107108:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010710b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010710e:	83 ec 08             	sub    $0x8,%esp
80107111:	8b 13                	mov    (%ebx),%edx
80107113:	ff 73 0c             	pushl  0xc(%ebx)
80107116:	50                   	push   %eax
80107117:	29 c1                	sub    %eax,%ecx
80107119:	89 f0                	mov    %esi,%eax
8010711b:	e8 90 f8 ff ff       	call   801069b0 <mappages>
80107120:	83 c4 10             	add    $0x10,%esp
80107123:	85 c0                	test   %eax,%eax
80107125:	78 19                	js     80107140 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107127:	83 c3 10             	add    $0x10,%ebx
8010712a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107130:	75 d6                	jne    80107108 <setupkvm+0x28>
}
80107132:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107135:	89 f0                	mov    %esi,%eax
80107137:	5b                   	pop    %ebx
80107138:	5e                   	pop    %esi
80107139:	5d                   	pop    %ebp
8010713a:	c3                   	ret    
8010713b:	90                   	nop
8010713c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir,0);
80107140:	83 ec 08             	sub    $0x8,%esp
80107143:	6a 00                	push   $0x0
80107145:	56                   	push   %esi
      return 0;
80107146:	31 f6                	xor    %esi,%esi
      freevm(pgdir,0);
80107148:	e8 03 ff ff ff       	call   80107050 <freevm>
      return 0;
8010714d:	83 c4 10             	add    $0x10,%esp
}
80107150:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107153:	89 f0                	mov    %esi,%eax
80107155:	5b                   	pop    %ebx
80107156:	5e                   	pop    %esi
80107157:	5d                   	pop    %ebp
80107158:	c3                   	ret    
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107160 <kvmalloc>:
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107166:	e8 75 ff ff ff       	call   801070e0 <setupkvm>
8010716b:	a3 e0 65 11 80       	mov    %eax,0x801165e0
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107170:	05 00 00 00 80       	add    $0x80000000,%eax
80107175:	0f 22 d8             	mov    %eax,%cr3
}
80107178:	c9                   	leave  
80107179:	c3                   	ret    
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107180 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107180:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107181:	31 c9                	xor    %ecx,%ecx
{
80107183:	89 e5                	mov    %esp,%ebp
80107185:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107188:	8b 55 0c             	mov    0xc(%ebp),%edx
8010718b:	8b 45 08             	mov    0x8(%ebp),%eax
8010718e:	e8 9d f7 ff ff       	call   80106930 <walkpgdir>
  if(pte == 0)
80107193:	85 c0                	test   %eax,%eax
80107195:	74 05                	je     8010719c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107197:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010719a:	c9                   	leave  
8010719b:	c3                   	ret    
    panic("clearpteu");
8010719c:	83 ec 0c             	sub    $0xc,%esp
8010719f:	68 16 7d 10 80       	push   $0x80107d16
801071a4:	e8 e7 91 ff ff       	call   80100390 <panic>
801071a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071b9:	e8 22 ff ff ff       	call   801070e0 <setupkvm>
801071be:	85 c0                	test   %eax,%eax
801071c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071c3:	0f 84 a2 00 00 00    	je     8010726b <copyuvm+0xbb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801071c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071cc:	85 c9                	test   %ecx,%ecx
801071ce:	0f 84 97 00 00 00    	je     8010726b <copyuvm+0xbb>
801071d4:	31 f6                	xor    %esi,%esi
801071d6:	eb 4e                	jmp    80107226 <copyuvm+0x76>
801071d8:	90                   	nop
801071d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801071e0:	83 ec 04             	sub    $0x4,%esp
801071e3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801071e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071ec:	68 00 10 00 00       	push   $0x1000
801071f1:	57                   	push   %edi
801071f2:	50                   	push   %eax
801071f3:	e8 08 d6 ff ff       	call   80104800 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801071f8:	58                   	pop    %eax
801071f9:	5a                   	pop    %edx
801071fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107200:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107205:	53                   	push   %ebx
80107206:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010720c:	52                   	push   %edx
8010720d:	89 f2                	mov    %esi,%edx
8010720f:	e8 9c f7 ff ff       	call   801069b0 <mappages>
80107214:	83 c4 10             	add    $0x10,%esp
80107217:	85 c0                	test   %eax,%eax
80107219:	78 39                	js     80107254 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010721b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107221:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107224:	76 45                	jbe    8010726b <copyuvm+0xbb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107226:	8b 45 08             	mov    0x8(%ebp),%eax
80107229:	31 c9                	xor    %ecx,%ecx
8010722b:	89 f2                	mov    %esi,%edx
8010722d:	e8 fe f6 ff ff       	call   80106930 <walkpgdir>
80107232:	85 c0                	test   %eax,%eax
80107234:	74 40                	je     80107276 <copyuvm+0xc6>
    if(!(*pte & PTE_P))
80107236:	8b 18                	mov    (%eax),%ebx
80107238:	f6 c3 01             	test   $0x1,%bl
8010723b:	74 46                	je     80107283 <copyuvm+0xd3>
    pa = PTE_ADDR(*pte);
8010723d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010723f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107245:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010724b:	e8 f0 b2 ff ff       	call   80102540 <kalloc>
80107250:	85 c0                	test   %eax,%eax
80107252:	75 8c                	jne    801071e0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d,0);
80107254:	83 ec 08             	sub    $0x8,%esp
80107257:	6a 00                	push   $0x0
80107259:	ff 75 e0             	pushl  -0x20(%ebp)
8010725c:	e8 ef fd ff ff       	call   80107050 <freevm>
  return 0;
80107261:	83 c4 10             	add    $0x10,%esp
80107264:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
8010726b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010726e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107271:	5b                   	pop    %ebx
80107272:	5e                   	pop    %esi
80107273:	5f                   	pop    %edi
80107274:	5d                   	pop    %ebp
80107275:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107276:	83 ec 0c             	sub    $0xc,%esp
80107279:	68 20 7d 10 80       	push   $0x80107d20
8010727e:	e8 0d 91 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107283:	83 ec 0c             	sub    $0xc,%esp
80107286:	68 3a 7d 10 80       	push   $0x80107d3a
8010728b:	e8 00 91 ff ff       	call   80100390 <panic>

80107290 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107290:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107291:	31 c9                	xor    %ecx,%ecx
{
80107293:	89 e5                	mov    %esp,%ebp
80107295:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107298:	8b 55 0c             	mov    0xc(%ebp),%edx
8010729b:	8b 45 08             	mov    0x8(%ebp),%eax
8010729e:	e8 8d f6 ff ff       	call   80106930 <walkpgdir>
  if((*pte & PTE_P) == 0)
801072a3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072a5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801072a6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801072ad:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072b0:	05 00 00 00 80       	add    $0x80000000,%eax
801072b5:	83 fa 05             	cmp    $0x5,%edx
801072b8:	ba 00 00 00 00       	mov    $0x0,%edx
801072bd:	0f 45 c2             	cmovne %edx,%eax
}
801072c0:	c3                   	ret    
801072c1:	eb 0d                	jmp    801072d0 <copyout>
801072c3:	90                   	nop
801072c4:	90                   	nop
801072c5:	90                   	nop
801072c6:	90                   	nop
801072c7:	90                   	nop
801072c8:	90                   	nop
801072c9:	90                   	nop
801072ca:	90                   	nop
801072cb:	90                   	nop
801072cc:	90                   	nop
801072cd:	90                   	nop
801072ce:	90                   	nop
801072cf:	90                   	nop

801072d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	57                   	push   %edi
801072d4:	56                   	push   %esi
801072d5:	53                   	push   %ebx
801072d6:	83 ec 1c             	sub    $0x1c,%esp
801072d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801072dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801072df:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801072e2:	85 db                	test   %ebx,%ebx
801072e4:	75 40                	jne    80107326 <copyout+0x56>
801072e6:	eb 70                	jmp    80107358 <copyout+0x88>
801072e8:	90                   	nop
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801072f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801072f3:	89 f1                	mov    %esi,%ecx
801072f5:	29 d1                	sub    %edx,%ecx
801072f7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801072fd:	39 d9                	cmp    %ebx,%ecx
801072ff:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107302:	29 f2                	sub    %esi,%edx
80107304:	83 ec 04             	sub    $0x4,%esp
80107307:	01 d0                	add    %edx,%eax
80107309:	51                   	push   %ecx
8010730a:	57                   	push   %edi
8010730b:	50                   	push   %eax
8010730c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010730f:	e8 ec d4 ff ff       	call   80104800 <memmove>
    len -= n;
    buf += n;
80107314:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107317:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010731a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107320:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107322:	29 cb                	sub    %ecx,%ebx
80107324:	74 32                	je     80107358 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107326:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107328:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010732b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010732e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107334:	56                   	push   %esi
80107335:	ff 75 08             	pushl  0x8(%ebp)
80107338:	e8 53 ff ff ff       	call   80107290 <uva2ka>
    if(pa0 == 0)
8010733d:	83 c4 10             	add    $0x10,%esp
80107340:	85 c0                	test   %eax,%eax
80107342:	75 ac                	jne    801072f0 <copyout+0x20>
  }
  return 0;
}
80107344:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107347:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010734c:	5b                   	pop    %ebx
8010734d:	5e                   	pop    %esi
8010734e:	5f                   	pop    %edi
8010734f:	5d                   	pop    %ebp
80107350:	c3                   	ret    
80107351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107358:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010735b:	31 c0                	xor    %eax,%eax
}
8010735d:	5b                   	pop    %ebx
8010735e:	5e                   	pop    %esi
8010735f:	5f                   	pop    %edi
80107360:	5d                   	pop    %ebp
80107361:	c3                   	ret    
