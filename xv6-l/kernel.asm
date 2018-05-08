
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
8010002d:	b8 c0 2e 10 80       	mov    $0x80102ec0,%eax
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
8010004c:	68 60 70 10 80       	push   $0x80107060
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 05 43 00 00       	call   80104360 <initlock>
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
80100092:	68 67 70 10 80       	push   $0x80107067
80100097:	50                   	push   %eax
80100098:	e8 b3 41 00 00       	call   80104250 <initsleeplock>
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
801000e4:	e8 67 43 00 00       	call   80104450 <acquire>
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
80100162:	e8 09 44 00 00       	call   80104570 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 41 00 00       	call   80104290 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 bd 1f 00 00       	call   80102140 <iderw>
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
80100193:	68 6e 70 10 80       	push   $0x8010706e
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
801001ae:	e8 7d 41 00 00       	call   80104330 <holdingsleep>
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
801001c4:	e9 77 1f 00 00       	jmp    80102140 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 70 10 80       	push   $0x8010707f
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
801001ef:	e8 3c 41 00 00       	call   80104330 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 40 00 00       	call   801042f0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 40 42 00 00       	call   80104450 <acquire>
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
8010025c:	e9 0f 43 00 00       	jmp    80104570 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 70 10 80       	push   $0x80107086
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
80100280:	e8 fb 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 bf 41 00 00       	call   80104450 <acquire>
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
801002c5:	e8 46 3c 00 00       	call   80103f10 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 30 35 00 00       	call   80103810 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 7c 42 00 00       	call   80104570 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 a4 13 00 00       	call   801016a0 <ilock>
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
8010034d:	e8 1e 42 00 00       	call   80104570 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 46 13 00 00       	call   801016a0 <ilock>
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
801003a9:	e8 a2 23 00 00       	call   80102750 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 70 10 80       	push   $0x8010708d
801003b7:	e8 b4 02 00 00       	call   80100670 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 ab 02 00 00       	call   80100670 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 db 79 10 80 	movl   $0x801079db,(%esp)
801003cc:	e8 9f 02 00 00       	call   80100670 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 a3 3f 00 00       	call   80104380 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 70 10 80       	push   $0x801070a1
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
8010043a:	e8 31 58 00 00       	call   80105c70 <uartputc>
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
801004fa:	e8 71 57 00 00       	call   80105c70 <uartputc>
801004ff:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100506:	e8 65 57 00 00       	call   80105c70 <uartputc>
8010050b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100512:	e8 59 57 00 00       	call   80105c70 <uartputc>
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
80100532:	e8 49 41 00 00       	call   80104680 <memmove>
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
8010054f:	e8 7c 40 00 00       	call   801045d0 <memset>
80100554:	83 c4 10             	add    $0x10,%esp
80100557:	e9 5d ff ff ff       	jmp    801004b9 <consputc+0xa9>
    panic("pos under/overflow");
8010055c:	83 ec 0c             	sub    $0xc,%esp
8010055f:	68 a5 70 10 80       	push   $0x801070a5
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
801005c1:	0f b6 92 d0 70 10 80 	movzbl -0x7fef8f30(%edx),%edx
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
8010061f:	e8 5c 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100624:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010062b:	e8 20 3e 00 00       	call   80104450 <acquire>
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
80100657:	e8 14 3f 00 00       	call   80104570 <release>
  ilock(ip);
8010065c:	58                   	pop    %eax
8010065d:	ff 75 08             	pushl  0x8(%ebp)
80100660:	e8 3b 10 00 00       	call   801016a0 <ilock>

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
8010072f:	e8 3c 3e 00 00       	call   80104570 <release>
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
801007e0:	ba b8 70 10 80       	mov    $0x801070b8,%edx
      for(; *s; s++)
801007e5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007e8:	b8 28 00 00 00       	mov    $0x28,%eax
801007ed:	89 d3                	mov    %edx,%ebx
801007ef:	eb bf                	jmp    801007b0 <cprintf+0x140>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007f8:	83 ec 0c             	sub    $0xc,%esp
801007fb:	68 20 a5 10 80       	push   $0x8010a520
80100800:	e8 4b 3c 00 00       	call   80104450 <acquire>
80100805:	83 c4 10             	add    $0x10,%esp
80100808:	e9 7c fe ff ff       	jmp    80100689 <cprintf+0x19>
    panic("null fmt");
8010080d:	83 ec 0c             	sub    $0xc,%esp
80100810:	68 bf 70 10 80       	push   $0x801070bf
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
80100833:	e8 18 3c 00 00       	call   80104450 <acquire>
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
80100898:	e8 d3 3c 00 00       	call   80104570 <release>
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
80100926:	e8 a5 37 00 00       	call   801040d0 <wakeup>
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
801009a7:	e9 d4 37 00 00       	jmp    80104180 <procdump>
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
801009d6:	68 c8 70 10 80       	push   $0x801070c8
801009db:	68 20 a5 10 80       	push   $0x8010a520
801009e0:	e8 7b 39 00 00       	call   80104360 <initlock>

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
80100a09:	e8 e2 18 00 00       	call   801022f0 <ioapicenable>
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
80100a2c:	e8 df 2d 00 00       	call   80103810 <myproc>
80100a31:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a37:	e8 84 21 00 00       	call   80102bc0 <begin_op>

  if((ip = namei(path)) == 0){
80100a3c:	83 ec 0c             	sub    $0xc,%esp
80100a3f:	ff 75 08             	pushl  0x8(%ebp)
80100a42:	e8 b9 14 00 00       	call   80101f00 <namei>
80100a47:	83 c4 10             	add    $0x10,%esp
80100a4a:	85 c0                	test   %eax,%eax
80100a4c:	0f 84 91 01 00 00    	je     80100be3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a52:	83 ec 0c             	sub    $0xc,%esp
80100a55:	89 c3                	mov    %eax,%ebx
80100a57:	50                   	push   %eax
80100a58:	e8 43 0c 00 00       	call   801016a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a5d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a63:	6a 34                	push   $0x34
80100a65:	6a 00                	push   $0x0
80100a67:	50                   	push   %eax
80100a68:	53                   	push   %ebx
80100a69:	e8 12 0f 00 00       	call   80101980 <readi>
80100a6e:	83 c4 20             	add    $0x20,%esp
80100a71:	83 f8 34             	cmp    $0x34,%eax
80100a74:	74 22                	je     80100a98 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	53                   	push   %ebx
80100a7a:	e8 b1 0e 00 00       	call   80101930 <iunlockput>
    end_op();
80100a7f:	e8 ac 21 00 00       	call   80102c30 <end_op>
80100a84:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a8f:	5b                   	pop    %ebx
80100a90:	5e                   	pop    %esi
80100a91:	5f                   	pop    %edi
80100a92:	5d                   	pop    %ebp
80100a93:	c3                   	ret    
80100a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a98:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a9f:	45 4c 46 
80100aa2:	75 d2                	jne    80100a76 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100aa4:	e8 17 63 00 00       	call   80106dc0 <setupkvm>
80100aa9:	85 c0                	test   %eax,%eax
80100aab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ab1:	74 c3                	je     80100a76 <exec+0x56>
  sz = 0;
80100ab3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ab5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100abc:	00 
80100abd:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ac3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ac9:	0f 84 8c 02 00 00    	je     80100d5b <exec+0x33b>
80100acf:	31 f6                	xor    %esi,%esi
80100ad1:	eb 7f                	jmp    80100b52 <exec+0x132>
80100ad3:	90                   	nop
80100ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ad8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adf:	75 63                	jne    80100b44 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ae1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aed:	0f 82 86 00 00 00    	jb     80100b79 <exec+0x159>
80100af3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af9:	72 7e                	jb     80100b79 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100afb:	83 ec 04             	sub    $0x4,%esp
80100afe:	50                   	push   %eax
80100aff:	57                   	push   %edi
80100b00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b06:	e8 d5 60 00 00       	call   80106be0 <allocuvm>
80100b0b:	83 c4 10             	add    $0x10,%esp
80100b0e:	85 c0                	test   %eax,%eax
80100b10:	89 c7                	mov    %eax,%edi
80100b12:	74 65                	je     80100b79 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b14:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b1f:	75 58                	jne    80100b79 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b21:	83 ec 0c             	sub    $0xc,%esp
80100b24:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b30:	53                   	push   %ebx
80100b31:	50                   	push   %eax
80100b32:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b38:	e8 e3 5f 00 00       	call   80106b20 <loaduvm>
80100b3d:	83 c4 20             	add    $0x20,%esp
80100b40:	85 c0                	test   %eax,%eax
80100b42:	78 35                	js     80100b79 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b44:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b4b:	83 c6 01             	add    $0x1,%esi
80100b4e:	39 f0                	cmp    %esi,%eax
80100b50:	7e 3d                	jle    80100b8f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b52:	89 f0                	mov    %esi,%eax
80100b54:	6a 20                	push   $0x20
80100b56:	c1 e0 05             	shl    $0x5,%eax
80100b59:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b5f:	50                   	push   %eax
80100b60:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b66:	50                   	push   %eax
80100b67:	53                   	push   %ebx
80100b68:	e8 13 0e 00 00       	call   80101980 <readi>
80100b6d:	83 c4 10             	add    $0x10,%esp
80100b70:	83 f8 20             	cmp    $0x20,%eax
80100b73:	0f 84 5f ff ff ff    	je     80100ad8 <exec+0xb8>
    freevm(pgdir);
80100b79:	83 ec 0c             	sub    $0xc,%esp
80100b7c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b82:	e8 b9 61 00 00       	call   80106d40 <freevm>
80100b87:	83 c4 10             	add    $0x10,%esp
80100b8a:	e9 e7 fe ff ff       	jmp    80100a76 <exec+0x56>
80100b8f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b95:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b9b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100ba1:	83 ec 0c             	sub    $0xc,%esp
80100ba4:	53                   	push   %ebx
80100ba5:	e8 86 0d 00 00       	call   80101930 <iunlockput>
  end_op();
80100baa:	e8 81 20 00 00       	call   80102c30 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100baf:	83 c4 0c             	add    $0xc,%esp
80100bb2:	56                   	push   %esi
80100bb3:	57                   	push   %edi
80100bb4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bba:	e8 21 60 00 00       	call   80106be0 <allocuvm>
80100bbf:	83 c4 10             	add    $0x10,%esp
80100bc2:	85 c0                	test   %eax,%eax
80100bc4:	89 c6                	mov    %eax,%esi
80100bc6:	75 3a                	jne    80100c02 <exec+0x1e2>
    freevm(pgdir);
80100bc8:	83 ec 0c             	sub    $0xc,%esp
80100bcb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bd1:	e8 6a 61 00 00       	call   80106d40 <freevm>
80100bd6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bde:	e9 a9 fe ff ff       	jmp    80100a8c <exec+0x6c>
    end_op();
80100be3:	e8 48 20 00 00       	call   80102c30 <end_op>
    cprintf("exec: fail\n");
80100be8:	83 ec 0c             	sub    $0xc,%esp
80100beb:	68 e1 70 10 80       	push   $0x801070e1
80100bf0:	e8 7b fa ff ff       	call   80100670 <cprintf>
    return -1;
80100bf5:	83 c4 10             	add    $0x10,%esp
80100bf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bfd:	e9 8a fe ff ff       	jmp    80100a8c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c02:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c08:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	31 ff                	xor    %edi,%edi
80100c0d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c0f:	50                   	push   %eax
80100c10:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c16:	e8 45 62 00 00       	call   80106e60 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c1e:	83 c4 10             	add    $0x10,%esp
80100c21:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c27:	8b 00                	mov    (%eax),%eax
80100c29:	85 c0                	test   %eax,%eax
80100c2b:	74 70                	je     80100c9d <exec+0x27d>
80100c2d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c33:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c39:	eb 0a                	jmp    80100c45 <exec+0x225>
80100c3b:	90                   	nop
80100c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c40:	83 ff 20             	cmp    $0x20,%edi
80100c43:	74 83                	je     80100bc8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c45:	83 ec 0c             	sub    $0xc,%esp
80100c48:	50                   	push   %eax
80100c49:	e8 a2 3b 00 00       	call   801047f0 <strlen>
80100c4e:	f7 d0                	not    %eax
80100c50:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c52:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c55:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c56:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c59:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5c:	e8 8f 3b 00 00       	call   801047f0 <strlen>
80100c61:	83 c0 01             	add    $0x1,%eax
80100c64:	50                   	push   %eax
80100c65:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c68:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c6b:	53                   	push   %ebx
80100c6c:	56                   	push   %esi
80100c6d:	e8 3e 63 00 00       	call   80106fb0 <copyout>
80100c72:	83 c4 20             	add    $0x20,%esp
80100c75:	85 c0                	test   %eax,%eax
80100c77:	0f 88 4b ff ff ff    	js     80100bc8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c80:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c87:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c90:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c93:	85 c0                	test   %eax,%eax
80100c95:	75 a9                	jne    80100c40 <exec+0x220>
80100c97:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100ca4:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100ca6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100cad:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100cb1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cb8:	ff ff ff 
  ustack[1] = argc;
80100cbb:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cc3:	83 c0 0c             	add    $0xc,%eax
80100cc6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc8:	50                   	push   %eax
80100cc9:	52                   	push   %edx
80100cca:	53                   	push   %ebx
80100ccb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cd1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cd7:	e8 d4 62 00 00       	call   80106fb0 <copyout>
80100cdc:	83 c4 10             	add    $0x10,%esp
80100cdf:	85 c0                	test   %eax,%eax
80100ce1:	0f 88 e1 fe ff ff    	js     80100bc8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100ce7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cea:	0f b6 00             	movzbl (%eax),%eax
80100ced:	84 c0                	test   %al,%al
80100cef:	74 17                	je     80100d08 <exec+0x2e8>
80100cf1:	8b 55 08             	mov    0x8(%ebp),%edx
80100cf4:	89 d1                	mov    %edx,%ecx
80100cf6:	83 c1 01             	add    $0x1,%ecx
80100cf9:	3c 2f                	cmp    $0x2f,%al
80100cfb:	0f b6 01             	movzbl (%ecx),%eax
80100cfe:	0f 44 d1             	cmove  %ecx,%edx
80100d01:	84 c0                	test   %al,%al
80100d03:	75 f1                	jne    80100cf6 <exec+0x2d6>
80100d05:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d08:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d0e:	50                   	push   %eax
80100d0f:	6a 10                	push   $0x10
80100d11:	ff 75 08             	pushl  0x8(%ebp)
80100d14:	89 f8                	mov    %edi,%eax
80100d16:	83 c0 6c             	add    $0x6c,%eax
80100d19:	50                   	push   %eax
80100d1a:	e8 91 3a 00 00       	call   801047b0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d1f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d25:	89 f9                	mov    %edi,%ecx
80100d27:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d2a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d2d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d2f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d32:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d38:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d3b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d3e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d41:	89 0c 24             	mov    %ecx,(%esp)
80100d44:	e8 47 5c 00 00       	call   80106990 <switchuvm>
  freevm(oldpgdir);
80100d49:	89 3c 24             	mov    %edi,(%esp)
80100d4c:	e8 ef 5f 00 00       	call   80106d40 <freevm>
  return 0;
80100d51:	83 c4 10             	add    $0x10,%esp
80100d54:	31 c0                	xor    %eax,%eax
80100d56:	e9 31 fd ff ff       	jmp    80100a8c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d5b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d60:	e9 3c fe ff ff       	jmp    80100ba1 <exec+0x181>
80100d65:	66 90                	xchg   %ax,%ax
80100d67:	66 90                	xchg   %ax,%ax
80100d69:	66 90                	xchg   %ax,%ax
80100d6b:	66 90                	xchg   %ax,%ax
80100d6d:	66 90                	xchg   %ax,%ax
80100d6f:	90                   	nop

80100d70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d76:	68 ed 70 10 80       	push   $0x801070ed
80100d7b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d80:	e8 db 35 00 00       	call   80104360 <initlock>
}
80100d85:	83 c4 10             	add    $0x10,%esp
80100d88:	c9                   	leave  
80100d89:	c3                   	ret    
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d90 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d94:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d99:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d9c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100da1:	e8 aa 36 00 00       	call   80104450 <acquire>
80100da6:	83 c4 10             	add    $0x10,%esp
80100da9:	eb 10                	jmp    80100dbb <filealloc+0x2b>
80100dab:	90                   	nop
80100dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db0:	83 c3 18             	add    $0x18,%ebx
80100db3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100db9:	73 25                	jae    80100de0 <filealloc+0x50>
    if(f->ref == 0){
80100dbb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dbe:	85 c0                	test   %eax,%eax
80100dc0:	75 ee                	jne    80100db0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dc2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100dc5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dcc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dd1:	e8 9a 37 00 00       	call   80104570 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dd6:	89 d8                	mov    %ebx,%eax
      return f;
80100dd8:	83 c4 10             	add    $0x10,%esp
}
80100ddb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dde:	c9                   	leave  
80100ddf:	c3                   	ret    
  release(&ftable.lock);
80100de0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100de3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100de5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dea:	e8 81 37 00 00       	call   80104570 <release>
}
80100def:	89 d8                	mov    %ebx,%eax
  return 0;
80100df1:	83 c4 10             	add    $0x10,%esp
}
80100df4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100df7:	c9                   	leave  
80100df8:	c3                   	ret    
80100df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e00 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
80100e04:	83 ec 10             	sub    $0x10,%esp
80100e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e0a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e0f:	e8 3c 36 00 00       	call   80104450 <acquire>
  if(f->ref < 1)
80100e14:	8b 43 04             	mov    0x4(%ebx),%eax
80100e17:	83 c4 10             	add    $0x10,%esp
80100e1a:	85 c0                	test   %eax,%eax
80100e1c:	7e 1a                	jle    80100e38 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e1e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e21:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e24:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e27:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e2c:	e8 3f 37 00 00       	call   80104570 <release>
  return f;
}
80100e31:	89 d8                	mov    %ebx,%eax
80100e33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e36:	c9                   	leave  
80100e37:	c3                   	ret    
    panic("filedup");
80100e38:	83 ec 0c             	sub    $0xc,%esp
80100e3b:	68 f4 70 10 80       	push   $0x801070f4
80100e40:	e8 4b f5 ff ff       	call   80100390 <panic>
80100e45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e50 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	57                   	push   %edi
80100e54:	56                   	push   %esi
80100e55:	53                   	push   %ebx
80100e56:	83 ec 28             	sub    $0x28,%esp
80100e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e5c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e61:	e8 ea 35 00 00       	call   80104450 <acquire>
  if(f->ref < 1)
80100e66:	8b 43 04             	mov    0x4(%ebx),%eax
80100e69:	83 c4 10             	add    $0x10,%esp
80100e6c:	85 c0                	test   %eax,%eax
80100e6e:	0f 8e 9b 00 00 00    	jle    80100f0f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e74:	83 e8 01             	sub    $0x1,%eax
80100e77:	85 c0                	test   %eax,%eax
80100e79:	89 43 04             	mov    %eax,0x4(%ebx)
80100e7c:	74 1a                	je     80100e98 <fileclose+0x48>
    release(&ftable.lock);
80100e7e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e88:	5b                   	pop    %ebx
80100e89:	5e                   	pop    %esi
80100e8a:	5f                   	pop    %edi
80100e8b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e8c:	e9 df 36 00 00       	jmp    80104570 <release>
80100e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e98:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e9c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e9e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ea1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ea4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eaa:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ead:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100eb0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100eb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100eb8:	e8 b3 36 00 00       	call   80104570 <release>
  if(ff.type == FD_PIPE)
80100ebd:	83 c4 10             	add    $0x10,%esp
80100ec0:	83 ff 01             	cmp    $0x1,%edi
80100ec3:	74 13                	je     80100ed8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ec5:	83 ff 02             	cmp    $0x2,%edi
80100ec8:	74 26                	je     80100ef0 <fileclose+0xa0>
}
80100eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ecd:	5b                   	pop    %ebx
80100ece:	5e                   	pop    %esi
80100ecf:	5f                   	pop    %edi
80100ed0:	5d                   	pop    %ebp
80100ed1:	c3                   	ret    
80100ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ed8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100edc:	83 ec 08             	sub    $0x8,%esp
80100edf:	53                   	push   %ebx
80100ee0:	56                   	push   %esi
80100ee1:	e8 8a 24 00 00       	call   80103370 <pipeclose>
80100ee6:	83 c4 10             	add    $0x10,%esp
80100ee9:	eb df                	jmp    80100eca <fileclose+0x7a>
80100eeb:	90                   	nop
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ef0:	e8 cb 1c 00 00       	call   80102bc0 <begin_op>
    iput(ff.ip);
80100ef5:	83 ec 0c             	sub    $0xc,%esp
80100ef8:	ff 75 e0             	pushl  -0x20(%ebp)
80100efb:	e8 d0 08 00 00       	call   801017d0 <iput>
    end_op();
80100f00:	83 c4 10             	add    $0x10,%esp
}
80100f03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f06:	5b                   	pop    %ebx
80100f07:	5e                   	pop    %esi
80100f08:	5f                   	pop    %edi
80100f09:	5d                   	pop    %ebp
    end_op();
80100f0a:	e9 21 1d 00 00       	jmp    80102c30 <end_op>
    panic("fileclose");
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	68 fc 70 10 80       	push   $0x801070fc
80100f17:	e8 74 f4 ff ff       	call   80100390 <panic>
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f20 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
80100f24:	83 ec 04             	sub    $0x4,%esp
80100f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f2a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f2d:	75 31                	jne    80100f60 <filestat+0x40>
    ilock(f->ip);
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	ff 73 10             	pushl  0x10(%ebx)
80100f35:	e8 66 07 00 00       	call   801016a0 <ilock>
    stati(f->ip, st);
80100f3a:	58                   	pop    %eax
80100f3b:	5a                   	pop    %edx
80100f3c:	ff 75 0c             	pushl  0xc(%ebp)
80100f3f:	ff 73 10             	pushl  0x10(%ebx)
80100f42:	e8 09 0a 00 00       	call   80101950 <stati>
    iunlock(f->ip);
80100f47:	59                   	pop    %ecx
80100f48:	ff 73 10             	pushl  0x10(%ebx)
80100f4b:	e8 30 08 00 00       	call   80101780 <iunlock>
    return 0;
80100f50:	83 c4 10             	add    $0x10,%esp
80100f53:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f58:	c9                   	leave  
80100f59:	c3                   	ret    
80100f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f65:	eb ee                	jmp    80100f55 <filestat+0x35>
80100f67:	89 f6                	mov    %esi,%esi
80100f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f70 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	83 ec 0c             	sub    $0xc,%esp
80100f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f7f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f82:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f86:	74 60                	je     80100fe8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f88:	8b 03                	mov    (%ebx),%eax
80100f8a:	83 f8 01             	cmp    $0x1,%eax
80100f8d:	74 41                	je     80100fd0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f8f:	83 f8 02             	cmp    $0x2,%eax
80100f92:	75 5b                	jne    80100fef <fileread+0x7f>
    ilock(f->ip);
80100f94:	83 ec 0c             	sub    $0xc,%esp
80100f97:	ff 73 10             	pushl  0x10(%ebx)
80100f9a:	e8 01 07 00 00       	call   801016a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9f:	57                   	push   %edi
80100fa0:	ff 73 14             	pushl  0x14(%ebx)
80100fa3:	56                   	push   %esi
80100fa4:	ff 73 10             	pushl  0x10(%ebx)
80100fa7:	e8 d4 09 00 00       	call   80101980 <readi>
80100fac:	83 c4 20             	add    $0x20,%esp
80100faf:	85 c0                	test   %eax,%eax
80100fb1:	89 c6                	mov    %eax,%esi
80100fb3:	7e 03                	jle    80100fb8 <fileread+0x48>
      f->off += r;
80100fb5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fb8:	83 ec 0c             	sub    $0xc,%esp
80100fbb:	ff 73 10             	pushl  0x10(%ebx)
80100fbe:	e8 bd 07 00 00       	call   80101780 <iunlock>
    return r;
80100fc3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	89 f0                	mov    %esi,%eax
80100fcb:	5b                   	pop    %ebx
80100fcc:	5e                   	pop    %esi
80100fcd:	5f                   	pop    %edi
80100fce:	5d                   	pop    %ebp
80100fcf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fd0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fd3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd9:	5b                   	pop    %ebx
80100fda:	5e                   	pop    %esi
80100fdb:	5f                   	pop    %edi
80100fdc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fdd:	e9 3e 25 00 00       	jmp    80103520 <piperead>
80100fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fe8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fed:	eb d7                	jmp    80100fc6 <fileread+0x56>
  panic("fileread");
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	68 06 71 10 80       	push   $0x80107106
80100ff7:	e8 94 f3 ff ff       	call   80100390 <panic>
80100ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101000 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 1c             	sub    $0x1c,%esp
80101009:	8b 75 08             	mov    0x8(%ebp),%esi
8010100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010100f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101013:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101016:	8b 45 10             	mov    0x10(%ebp),%eax
80101019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010101c:	0f 84 aa 00 00 00    	je     801010cc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101022:	8b 06                	mov    (%esi),%eax
80101024:	83 f8 01             	cmp    $0x1,%eax
80101027:	0f 84 c3 00 00 00    	je     801010f0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010102d:	83 f8 02             	cmp    $0x2,%eax
80101030:	0f 85 d9 00 00 00    	jne    8010110f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101039:	31 ff                	xor    %edi,%edi
    while(i < n){
8010103b:	85 c0                	test   %eax,%eax
8010103d:	7f 34                	jg     80101073 <filewrite+0x73>
8010103f:	e9 9c 00 00 00       	jmp    801010e0 <filewrite+0xe0>
80101044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101048:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010104b:	83 ec 0c             	sub    $0xc,%esp
8010104e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101051:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101054:	e8 27 07 00 00       	call   80101780 <iunlock>
      end_op();
80101059:	e8 d2 1b 00 00       	call   80102c30 <end_op>
8010105e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101061:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101064:	39 c3                	cmp    %eax,%ebx
80101066:	0f 85 96 00 00 00    	jne    80101102 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010106c:	01 df                	add    %ebx,%edi
    while(i < n){
8010106e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101071:	7e 6d                	jle    801010e0 <filewrite+0xe0>
      int n1 = n - i;
80101073:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101076:	b8 00 06 00 00       	mov    $0x600,%eax
8010107b:	29 fb                	sub    %edi,%ebx
8010107d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101083:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101086:	e8 35 1b 00 00       	call   80102bc0 <begin_op>
      ilock(f->ip);
8010108b:	83 ec 0c             	sub    $0xc,%esp
8010108e:	ff 76 10             	pushl  0x10(%esi)
80101091:	e8 0a 06 00 00       	call   801016a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101096:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101099:	53                   	push   %ebx
8010109a:	ff 76 14             	pushl  0x14(%esi)
8010109d:	01 f8                	add    %edi,%eax
8010109f:	50                   	push   %eax
801010a0:	ff 76 10             	pushl  0x10(%esi)
801010a3:	e8 d8 09 00 00       	call   80101a80 <writei>
801010a8:	83 c4 20             	add    $0x20,%esp
801010ab:	85 c0                	test   %eax,%eax
801010ad:	7f 99                	jg     80101048 <filewrite+0x48>
      iunlock(f->ip);
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	ff 76 10             	pushl  0x10(%esi)
801010b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010b8:	e8 c3 06 00 00       	call   80101780 <iunlock>
      end_op();
801010bd:	e8 6e 1b 00 00       	call   80102c30 <end_op>
      if(r < 0)
801010c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010c5:	83 c4 10             	add    $0x10,%esp
801010c8:	85 c0                	test   %eax,%eax
801010ca:	74 98                	je     80101064 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010cf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010d4:	89 f8                	mov    %edi,%eax
801010d6:	5b                   	pop    %ebx
801010d7:	5e                   	pop    %esi
801010d8:	5f                   	pop    %edi
801010d9:	5d                   	pop    %ebp
801010da:	c3                   	ret    
801010db:	90                   	nop
801010dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010e0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010e3:	75 e7                	jne    801010cc <filewrite+0xcc>
}
801010e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e8:	89 f8                	mov    %edi,%eax
801010ea:	5b                   	pop    %ebx
801010eb:	5e                   	pop    %esi
801010ec:	5f                   	pop    %edi
801010ed:	5d                   	pop    %ebp
801010ee:	c3                   	ret    
801010ef:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010f0:	8b 46 0c             	mov    0xc(%esi),%eax
801010f3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f9:	5b                   	pop    %ebx
801010fa:	5e                   	pop    %esi
801010fb:	5f                   	pop    %edi
801010fc:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010fd:	e9 0e 23 00 00       	jmp    80103410 <pipewrite>
        panic("short filewrite");
80101102:	83 ec 0c             	sub    $0xc,%esp
80101105:	68 0f 71 10 80       	push   $0x8010710f
8010110a:	e8 81 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	68 15 71 10 80       	push   $0x80107115
80101117:	e8 74 f2 ff ff       	call   80100390 <panic>
8010111c:	66 90                	xchg   %ax,%ax
8010111e:	66 90                	xchg   %ax,%ax

80101120 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101129:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010112f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101132:	85 c9                	test   %ecx,%ecx
80101134:	0f 84 87 00 00 00    	je     801011c1 <balloc+0xa1>
8010113a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101141:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101144:	83 ec 08             	sub    $0x8,%esp
80101147:	89 f0                	mov    %esi,%eax
80101149:	c1 f8 0c             	sar    $0xc,%eax
8010114c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101152:	50                   	push   %eax
80101153:	ff 75 d8             	pushl  -0x28(%ebp)
80101156:	e8 75 ef ff ff       	call   801000d0 <bread>
8010115b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010115e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101163:	83 c4 10             	add    $0x10,%esp
80101166:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101169:	31 c0                	xor    %eax,%eax
8010116b:	eb 2f                	jmp    8010119c <balloc+0x7c>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101170:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101172:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101175:	bb 01 00 00 00       	mov    $0x1,%ebx
8010117a:	83 e1 07             	and    $0x7,%ecx
8010117d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010117f:	89 c1                	mov    %eax,%ecx
80101181:	c1 f9 03             	sar    $0x3,%ecx
80101184:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101189:	85 df                	test   %ebx,%edi
8010118b:	89 fa                	mov    %edi,%edx
8010118d:	74 41                	je     801011d0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010118f:	83 c0 01             	add    $0x1,%eax
80101192:	83 c6 01             	add    $0x1,%esi
80101195:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010119a:	74 05                	je     801011a1 <balloc+0x81>
8010119c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010119f:	77 cf                	ja     80101170 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011a1:	83 ec 0c             	sub    $0xc,%esp
801011a4:	ff 75 e4             	pushl  -0x1c(%ebp)
801011a7:	e8 34 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011ac:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011b3:	83 c4 10             	add    $0x10,%esp
801011b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011b9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801011bf:	77 80                	ja     80101141 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	68 1f 71 10 80       	push   $0x8010711f
801011c9:	e8 c2 f1 ff ff       	call   80100390 <panic>
801011ce:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011d3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011d6:	09 da                	or     %ebx,%edx
801011d8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011dc:	57                   	push   %edi
801011dd:	e8 ae 1b 00 00       	call   80102d90 <log_write>
        brelse(bp);
801011e2:	89 3c 24             	mov    %edi,(%esp)
801011e5:	e8 f6 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011ea:	58                   	pop    %eax
801011eb:	5a                   	pop    %edx
801011ec:	56                   	push   %esi
801011ed:	ff 75 d8             	pushl  -0x28(%ebp)
801011f0:	e8 db ee ff ff       	call   801000d0 <bread>
801011f5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011fa:	83 c4 0c             	add    $0xc,%esp
801011fd:	68 00 02 00 00       	push   $0x200
80101202:	6a 00                	push   $0x0
80101204:	50                   	push   %eax
80101205:	e8 c6 33 00 00       	call   801045d0 <memset>
  log_write(bp);
8010120a:	89 1c 24             	mov    %ebx,(%esp)
8010120d:	e8 7e 1b 00 00       	call   80102d90 <log_write>
  brelse(bp);
80101212:	89 1c 24             	mov    %ebx,(%esp)
80101215:	e8 c6 ef ff ff       	call   801001e0 <brelse>
}
8010121a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010121d:	89 f0                	mov    %esi,%eax
8010121f:	5b                   	pop    %ebx
80101220:	5e                   	pop    %esi
80101221:	5f                   	pop    %edi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
80101224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010122a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101230 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101238:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010123f:	83 ec 28             	sub    $0x28,%esp
80101242:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101245:	68 e0 09 11 80       	push   $0x801109e0
8010124a:	e8 01 32 00 00       	call   80104450 <acquire>
8010124f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101252:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101255:	eb 17                	jmp    8010126e <iget+0x3e>
80101257:	89 f6                	mov    %esi,%esi
80101259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101260:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101266:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010126c:	73 22                	jae    80101290 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010126e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101271:	85 c9                	test   %ecx,%ecx
80101273:	7e 04                	jle    80101279 <iget+0x49>
80101275:	39 3b                	cmp    %edi,(%ebx)
80101277:	74 4f                	je     801012c8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101279:	85 f6                	test   %esi,%esi
8010127b:	75 e3                	jne    80101260 <iget+0x30>
8010127d:	85 c9                	test   %ecx,%ecx
8010127f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101282:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101288:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010128e:	72 de                	jb     8010126e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101290:	85 f6                	test   %esi,%esi
80101292:	74 5b                	je     801012ef <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101294:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101297:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101299:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010129c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012a3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012aa:	68 e0 09 11 80       	push   $0x801109e0
801012af:	e8 bc 32 00 00       	call   80104570 <release>

  return ip;
801012b4:	83 c4 10             	add    $0x10,%esp
}
801012b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ba:	89 f0                	mov    %esi,%eax
801012bc:	5b                   	pop    %ebx
801012bd:	5e                   	pop    %esi
801012be:	5f                   	pop    %edi
801012bf:	5d                   	pop    %ebp
801012c0:	c3                   	ret    
801012c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012c8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012cb:	75 ac                	jne    80101279 <iget+0x49>
      release(&icache.lock);
801012cd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012d0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012d3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012d5:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801012da:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012dd:	e8 8e 32 00 00       	call   80104570 <release>
      return ip;
801012e2:	83 c4 10             	add    $0x10,%esp
}
801012e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e8:	89 f0                	mov    %esi,%eax
801012ea:	5b                   	pop    %ebx
801012eb:	5e                   	pop    %esi
801012ec:	5f                   	pop    %edi
801012ed:	5d                   	pop    %ebp
801012ee:	c3                   	ret    
    panic("iget: no inodes");
801012ef:	83 ec 0c             	sub    $0xc,%esp
801012f2:	68 35 71 10 80       	push   $0x80107135
801012f7:	e8 94 f0 ff ff       	call   80100390 <panic>
801012fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101300 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	57                   	push   %edi
80101304:	56                   	push   %esi
80101305:	53                   	push   %ebx
80101306:	89 c6                	mov    %eax,%esi
80101308:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010130b:	83 fa 0b             	cmp    $0xb,%edx
8010130e:	77 18                	ja     80101328 <bmap+0x28>
80101310:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101313:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101316:	85 db                	test   %ebx,%ebx
80101318:	74 76                	je     80101390 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010131a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131d:	89 d8                	mov    %ebx,%eax
8010131f:	5b                   	pop    %ebx
80101320:	5e                   	pop    %esi
80101321:	5f                   	pop    %edi
80101322:	5d                   	pop    %ebp
80101323:	c3                   	ret    
80101324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101328:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010132b:	83 fb 7f             	cmp    $0x7f,%ebx
8010132e:	0f 87 90 00 00 00    	ja     801013c4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101334:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010133a:	8b 00                	mov    (%eax),%eax
8010133c:	85 d2                	test   %edx,%edx
8010133e:	74 70                	je     801013b0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101340:	83 ec 08             	sub    $0x8,%esp
80101343:	52                   	push   %edx
80101344:	50                   	push   %eax
80101345:	e8 86 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010134a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010134e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101351:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101353:	8b 1a                	mov    (%edx),%ebx
80101355:	85 db                	test   %ebx,%ebx
80101357:	75 1d                	jne    80101376 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101359:	8b 06                	mov    (%esi),%eax
8010135b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010135e:	e8 bd fd ff ff       	call   80101120 <balloc>
80101363:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101369:	89 c3                	mov    %eax,%ebx
8010136b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010136d:	57                   	push   %edi
8010136e:	e8 1d 1a 00 00       	call   80102d90 <log_write>
80101373:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101376:	83 ec 0c             	sub    $0xc,%esp
80101379:	57                   	push   %edi
8010137a:	e8 61 ee ff ff       	call   801001e0 <brelse>
8010137f:	83 c4 10             	add    $0x10,%esp
}
80101382:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101385:	89 d8                	mov    %ebx,%eax
80101387:	5b                   	pop    %ebx
80101388:	5e                   	pop    %esi
80101389:	5f                   	pop    %edi
8010138a:	5d                   	pop    %ebp
8010138b:	c3                   	ret    
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101390:	8b 00                	mov    (%eax),%eax
80101392:	e8 89 fd ff ff       	call   80101120 <balloc>
80101397:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010139d:	89 c3                	mov    %eax,%ebx
}
8010139f:	89 d8                	mov    %ebx,%eax
801013a1:	5b                   	pop    %ebx
801013a2:	5e                   	pop    %esi
801013a3:	5f                   	pop    %edi
801013a4:	5d                   	pop    %ebp
801013a5:	c3                   	ret    
801013a6:	8d 76 00             	lea    0x0(%esi),%esi
801013a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013b0:	e8 6b fd ff ff       	call   80101120 <balloc>
801013b5:	89 c2                	mov    %eax,%edx
801013b7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013bd:	8b 06                	mov    (%esi),%eax
801013bf:	e9 7c ff ff ff       	jmp    80101340 <bmap+0x40>
  panic("bmap: out of range");
801013c4:	83 ec 0c             	sub    $0xc,%esp
801013c7:	68 45 71 10 80       	push   $0x80107145
801013cc:	e8 bf ef ff ff       	call   80100390 <panic>
801013d1:	eb 0d                	jmp    801013e0 <readsb>
801013d3:	90                   	nop
801013d4:	90                   	nop
801013d5:	90                   	nop
801013d6:	90                   	nop
801013d7:	90                   	nop
801013d8:	90                   	nop
801013d9:	90                   	nop
801013da:	90                   	nop
801013db:	90                   	nop
801013dc:	90                   	nop
801013dd:	90                   	nop
801013de:	90                   	nop
801013df:	90                   	nop

801013e0 <readsb>:
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	56                   	push   %esi
801013e4:	53                   	push   %ebx
801013e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013e8:	83 ec 08             	sub    $0x8,%esp
801013eb:	6a 01                	push   $0x1
801013ed:	ff 75 08             	pushl  0x8(%ebp)
801013f0:	e8 db ec ff ff       	call   801000d0 <bread>
801013f5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013fa:	83 c4 0c             	add    $0xc,%esp
801013fd:	6a 1c                	push   $0x1c
801013ff:	50                   	push   %eax
80101400:	56                   	push   %esi
80101401:	e8 7a 32 00 00       	call   80104680 <memmove>
  brelse(bp);
80101406:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101409:	83 c4 10             	add    $0x10,%esp
}
8010140c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010140f:	5b                   	pop    %ebx
80101410:	5e                   	pop    %esi
80101411:	5d                   	pop    %ebp
  brelse(bp);
80101412:	e9 c9 ed ff ff       	jmp    801001e0 <brelse>
80101417:	89 f6                	mov    %esi,%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101420 <bfree>:
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	89 d3                	mov    %edx,%ebx
80101427:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101429:	83 ec 08             	sub    $0x8,%esp
8010142c:	68 c0 09 11 80       	push   $0x801109c0
80101431:	50                   	push   %eax
80101432:	e8 a9 ff ff ff       	call   801013e0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101437:	58                   	pop    %eax
80101438:	5a                   	pop    %edx
80101439:	89 da                	mov    %ebx,%edx
8010143b:	c1 ea 0c             	shr    $0xc,%edx
8010143e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101444:	52                   	push   %edx
80101445:	56                   	push   %esi
80101446:	e8 85 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010144b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010144d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101450:	ba 01 00 00 00       	mov    $0x1,%edx
80101455:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101458:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010145e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101461:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101463:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101468:	85 d1                	test   %edx,%ecx
8010146a:	74 25                	je     80101491 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010146c:	f7 d2                	not    %edx
8010146e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101470:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101473:	21 ca                	and    %ecx,%edx
80101475:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101479:	56                   	push   %esi
8010147a:	e8 11 19 00 00       	call   80102d90 <log_write>
  brelse(bp);
8010147f:	89 34 24             	mov    %esi,(%esp)
80101482:	e8 59 ed ff ff       	call   801001e0 <brelse>
}
80101487:	83 c4 10             	add    $0x10,%esp
8010148a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010148d:	5b                   	pop    %ebx
8010148e:	5e                   	pop    %esi
8010148f:	5d                   	pop    %ebp
80101490:	c3                   	ret    
    panic("freeing free block");
80101491:	83 ec 0c             	sub    $0xc,%esp
80101494:	68 58 71 10 80       	push   $0x80107158
80101499:	e8 f2 ee ff ff       	call   80100390 <panic>
8010149e:	66 90                	xchg   %ax,%ax

801014a0 <iinit>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	53                   	push   %ebx
801014a4:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801014a9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014ac:	68 6b 71 10 80       	push   $0x8010716b
801014b1:	68 e0 09 11 80       	push   $0x801109e0
801014b6:	e8 a5 2e 00 00       	call   80104360 <initlock>
801014bb:	83 c4 10             	add    $0x10,%esp
801014be:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014c0:	83 ec 08             	sub    $0x8,%esp
801014c3:	68 72 71 10 80       	push   $0x80107172
801014c8:	53                   	push   %ebx
801014c9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014cf:	e8 7c 2d 00 00       	call   80104250 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014d4:	83 c4 10             	add    $0x10,%esp
801014d7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014dd:	75 e1                	jne    801014c0 <iinit+0x20>
  readsb(dev, &sb);
801014df:	83 ec 08             	sub    $0x8,%esp
801014e2:	68 c0 09 11 80       	push   $0x801109c0
801014e7:	ff 75 08             	pushl  0x8(%ebp)
801014ea:	e8 f1 fe ff ff       	call   801013e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ef:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014f5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014fb:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101501:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101507:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010150d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101513:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101519:	68 d8 71 10 80       	push   $0x801071d8
8010151e:	e8 4d f1 ff ff       	call   80100670 <cprintf>
}
80101523:	83 c4 30             	add    $0x30,%esp
80101526:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101529:	c9                   	leave  
8010152a:	c3                   	ret    
8010152b:	90                   	nop
8010152c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101530 <ialloc>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101540:	8b 45 0c             	mov    0xc(%ebp),%eax
80101543:	8b 75 08             	mov    0x8(%ebp),%esi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 91 00 00 00    	jbe    801015e0 <ialloc+0xb0>
8010154f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101554:	eb 21                	jmp    80101577 <ialloc+0x47>
80101556:	8d 76 00             	lea    0x0(%esi),%esi
80101559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101560:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101566:	57                   	push   %edi
80101567:	e8 74 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010156c:	83 c4 10             	add    $0x10,%esp
8010156f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101575:	76 69                	jbe    801015e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101577:	89 d8                	mov    %ebx,%eax
80101579:	83 ec 08             	sub    $0x8,%esp
8010157c:	c1 e8 03             	shr    $0x3,%eax
8010157f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101585:	50                   	push   %eax
80101586:	56                   	push   %esi
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101590:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101593:	83 e0 07             	and    $0x7,%eax
80101596:	c1 e0 06             	shl    $0x6,%eax
80101599:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015a1:	75 bd                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a3:	83 ec 04             	sub    $0x4,%esp
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	6a 40                	push   $0x40
801015ab:	6a 00                	push   $0x0
801015ad:	51                   	push   %ecx
801015ae:	e8 1d 30 00 00       	call   801045d0 <memset>
      dip->type = type;
801015b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015bd:	89 3c 24             	mov    %edi,(%esp)
801015c0:	e8 cb 17 00 00       	call   80102d90 <log_write>
      brelse(bp);
801015c5:	89 3c 24             	mov    %edi,(%esp)
801015c8:	e8 13 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015cd:	83 c4 10             	add    $0x10,%esp
}
801015d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015d3:	89 da                	mov    %ebx,%edx
801015d5:	89 f0                	mov    %esi,%eax
}
801015d7:	5b                   	pop    %ebx
801015d8:	5e                   	pop    %esi
801015d9:	5f                   	pop    %edi
801015da:	5d                   	pop    %ebp
      return iget(dev, inum);
801015db:	e9 50 fc ff ff       	jmp    80101230 <iget>
  panic("ialloc: no inodes");
801015e0:	83 ec 0c             	sub    $0xc,%esp
801015e3:	68 78 71 10 80       	push   $0x80107178
801015e8:	e8 a3 ed ff ff       	call   80100390 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f8:	83 ec 08             	sub    $0x8,%esp
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010160a:	50                   	push   %eax
8010160b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010160e:	e8 bd ea ff ff       	call   801000d0 <bread>
80101613:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101615:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101618:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010161f:	83 e0 07             	and    $0x7,%eax
80101622:	c1 e0 06             	shl    $0x6,%eax
80101625:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101629:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010162c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101630:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101633:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101637:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010163b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010163f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101643:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101647:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010164a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010164d:	6a 34                	push   $0x34
8010164f:	53                   	push   %ebx
80101650:	50                   	push   %eax
80101651:	e8 2a 30 00 00       	call   80104680 <memmove>
  log_write(bp);
80101656:	89 34 24             	mov    %esi,(%esp)
80101659:	e8 32 17 00 00       	call   80102d90 <log_write>
  brelse(bp);
8010165e:	89 75 08             	mov    %esi,0x8(%ebp)
80101661:	83 c4 10             	add    $0x10,%esp
}
80101664:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101667:	5b                   	pop    %ebx
80101668:	5e                   	pop    %esi
80101669:	5d                   	pop    %ebp
  brelse(bp);
8010166a:	e9 71 eb ff ff       	jmp    801001e0 <brelse>
8010166f:	90                   	nop

80101670 <idup>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	83 ec 10             	sub    $0x10,%esp
80101677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010167a:	68 e0 09 11 80       	push   $0x801109e0
8010167f:	e8 cc 2d 00 00       	call   80104450 <acquire>
  ip->ref++;
80101684:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101688:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010168f:	e8 dc 2e 00 00       	call   80104570 <release>
}
80101694:	89 d8                	mov    %ebx,%eax
80101696:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101699:	c9                   	leave  
8010169a:	c3                   	ret    
8010169b:	90                   	nop
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016a0 <ilock>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	56                   	push   %esi
801016a4:	53                   	push   %ebx
801016a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016a8:	85 db                	test   %ebx,%ebx
801016aa:	0f 84 b7 00 00 00    	je     80101767 <ilock+0xc7>
801016b0:	8b 53 08             	mov    0x8(%ebx),%edx
801016b3:	85 d2                	test   %edx,%edx
801016b5:	0f 8e ac 00 00 00    	jle    80101767 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016bb:	8d 43 0c             	lea    0xc(%ebx),%eax
801016be:	83 ec 0c             	sub    $0xc,%esp
801016c1:	50                   	push   %eax
801016c2:	e8 c9 2b 00 00       	call   80104290 <acquiresleep>
  if(ip->valid == 0){
801016c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ca:	83 c4 10             	add    $0x10,%esp
801016cd:	85 c0                	test   %eax,%eax
801016cf:	74 0f                	je     801016e0 <ilock+0x40>
}
801016d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016d4:	5b                   	pop    %ebx
801016d5:	5e                   	pop    %esi
801016d6:	5d                   	pop    %ebp
801016d7:	c3                   	ret    
801016d8:	90                   	nop
801016d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e0:	8b 43 04             	mov    0x4(%ebx),%eax
801016e3:	83 ec 08             	sub    $0x8,%esp
801016e6:	c1 e8 03             	shr    $0x3,%eax
801016e9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016ef:	50                   	push   %eax
801016f0:	ff 33                	pushl  (%ebx)
801016f2:	e8 d9 e9 ff ff       	call   801000d0 <bread>
801016f7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101709:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010170c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010170f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101713:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101717:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010171b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010171f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101723:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101727:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010172b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010172e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101731:	6a 34                	push   $0x34
80101733:	50                   	push   %eax
80101734:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101737:	50                   	push   %eax
80101738:	e8 43 2f 00 00       	call   80104680 <memmove>
    brelse(bp);
8010173d:	89 34 24             	mov    %esi,(%esp)
80101740:	e8 9b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101745:	83 c4 10             	add    $0x10,%esp
80101748:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010174d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101754:	0f 85 77 ff ff ff    	jne    801016d1 <ilock+0x31>
      panic("ilock: no type");
8010175a:	83 ec 0c             	sub    $0xc,%esp
8010175d:	68 90 71 10 80       	push   $0x80107190
80101762:	e8 29 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101767:	83 ec 0c             	sub    $0xc,%esp
8010176a:	68 8a 71 10 80       	push   $0x8010718a
8010176f:	e8 1c ec ff ff       	call   80100390 <panic>
80101774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010177a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101780 <iunlock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	74 28                	je     801017b4 <iunlock+0x34>
8010178c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	56                   	push   %esi
80101793:	e8 98 2b 00 00       	call   80104330 <holdingsleep>
80101798:	83 c4 10             	add    $0x10,%esp
8010179b:	85 c0                	test   %eax,%eax
8010179d:	74 15                	je     801017b4 <iunlock+0x34>
8010179f:	8b 43 08             	mov    0x8(%ebx),%eax
801017a2:	85 c0                	test   %eax,%eax
801017a4:	7e 0e                	jle    801017b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017ac:	5b                   	pop    %ebx
801017ad:	5e                   	pop    %esi
801017ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017af:	e9 3c 2b 00 00       	jmp    801042f0 <releasesleep>
    panic("iunlock");
801017b4:	83 ec 0c             	sub    $0xc,%esp
801017b7:	68 9f 71 10 80       	push   $0x8010719f
801017bc:	e8 cf eb ff ff       	call   80100390 <panic>
801017c1:	eb 0d                	jmp    801017d0 <iput>
801017c3:	90                   	nop
801017c4:	90                   	nop
801017c5:	90                   	nop
801017c6:	90                   	nop
801017c7:	90                   	nop
801017c8:	90                   	nop
801017c9:	90                   	nop
801017ca:	90                   	nop
801017cb:	90                   	nop
801017cc:	90                   	nop
801017cd:	90                   	nop
801017ce:	90                   	nop
801017cf:	90                   	nop

801017d0 <iput>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 28             	sub    $0x28,%esp
801017d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017df:	57                   	push   %edi
801017e0:	e8 ab 2a 00 00       	call   80104290 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017e8:	83 c4 10             	add    $0x10,%esp
801017eb:	85 d2                	test   %edx,%edx
801017ed:	74 07                	je     801017f6 <iput+0x26>
801017ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017f4:	74 32                	je     80101828 <iput+0x58>
  releasesleep(&ip->lock);
801017f6:	83 ec 0c             	sub    $0xc,%esp
801017f9:	57                   	push   %edi
801017fa:	e8 f1 2a 00 00       	call   801042f0 <releasesleep>
  acquire(&icache.lock);
801017ff:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101806:	e8 45 2c 00 00       	call   80104450 <acquire>
  ip->ref--;
8010180b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010180f:	83 c4 10             	add    $0x10,%esp
80101812:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101819:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010181c:	5b                   	pop    %ebx
8010181d:	5e                   	pop    %esi
8010181e:	5f                   	pop    %edi
8010181f:	5d                   	pop    %ebp
  release(&icache.lock);
80101820:	e9 4b 2d 00 00       	jmp    80104570 <release>
80101825:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101828:	83 ec 0c             	sub    $0xc,%esp
8010182b:	68 e0 09 11 80       	push   $0x801109e0
80101830:	e8 1b 2c 00 00       	call   80104450 <acquire>
    int r = ip->ref;
80101835:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101838:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010183f:	e8 2c 2d 00 00       	call   80104570 <release>
    if(r == 1){
80101844:	83 c4 10             	add    $0x10,%esp
80101847:	83 fe 01             	cmp    $0x1,%esi
8010184a:	75 aa                	jne    801017f6 <iput+0x26>
8010184c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101852:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101855:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101858:	89 cf                	mov    %ecx,%edi
8010185a:	eb 0b                	jmp    80101867 <iput+0x97>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101863:	39 fe                	cmp    %edi,%esi
80101865:	74 19                	je     80101880 <iput+0xb0>
    if(ip->addrs[i]){
80101867:	8b 16                	mov    (%esi),%edx
80101869:	85 d2                	test   %edx,%edx
8010186b:	74 f3                	je     80101860 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010186d:	8b 03                	mov    (%ebx),%eax
8010186f:	e8 ac fb ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
80101874:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010187a:	eb e4                	jmp    80101860 <iput+0x90>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101880:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101889:	85 c0                	test   %eax,%eax
8010188b:	75 33                	jne    801018c0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010188d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101890:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101897:	53                   	push   %ebx
80101898:	e8 53 fd ff ff       	call   801015f0 <iupdate>
      ip->type = 0;
8010189d:	31 c0                	xor    %eax,%eax
8010189f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018a3:	89 1c 24             	mov    %ebx,(%esp)
801018a6:	e8 45 fd ff ff       	call   801015f0 <iupdate>
      ip->valid = 0;
801018ab:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018b2:	83 c4 10             	add    $0x10,%esp
801018b5:	e9 3c ff ff ff       	jmp    801017f6 <iput+0x26>
801018ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c0:	83 ec 08             	sub    $0x8,%esp
801018c3:	50                   	push   %eax
801018c4:	ff 33                	pushl  (%ebx)
801018c6:	e8 05 e8 ff ff       	call   801000d0 <bread>
801018cb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018d1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018d7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018da:	83 c4 10             	add    $0x10,%esp
801018dd:	89 cf                	mov    %ecx,%edi
801018df:	eb 0e                	jmp    801018ef <iput+0x11f>
801018e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018e8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018eb:	39 fe                	cmp    %edi,%esi
801018ed:	74 0f                	je     801018fe <iput+0x12e>
      if(a[j])
801018ef:	8b 16                	mov    (%esi),%edx
801018f1:	85 d2                	test   %edx,%edx
801018f3:	74 f3                	je     801018e8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018f5:	8b 03                	mov    (%ebx),%eax
801018f7:	e8 24 fb ff ff       	call   80101420 <bfree>
801018fc:	eb ea                	jmp    801018e8 <iput+0x118>
    brelse(bp);
801018fe:	83 ec 0c             	sub    $0xc,%esp
80101901:	ff 75 e4             	pushl  -0x1c(%ebp)
80101904:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101907:	e8 d4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010190c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101912:	8b 03                	mov    (%ebx),%eax
80101914:	e8 07 fb ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
80101919:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101920:	00 00 00 
80101923:	83 c4 10             	add    $0x10,%esp
80101926:	e9 62 ff ff ff       	jmp    8010188d <iput+0xbd>
8010192b:	90                   	nop
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101930 <iunlockput>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	53                   	push   %ebx
80101934:	83 ec 10             	sub    $0x10,%esp
80101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010193a:	53                   	push   %ebx
8010193b:	e8 40 fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101940:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101943:	83 c4 10             	add    $0x10,%esp
}
80101946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101949:	c9                   	leave  
  iput(ip);
8010194a:	e9 81 fe ff ff       	jmp    801017d0 <iput>
8010194f:	90                   	nop

80101950 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	8b 55 08             	mov    0x8(%ebp),%edx
80101956:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101959:	8b 0a                	mov    (%edx),%ecx
8010195b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010195e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101961:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101964:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101968:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010196b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010196f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101973:	8b 52 58             	mov    0x58(%edx),%edx
80101976:	89 50 10             	mov    %edx,0x10(%eax)
}
80101979:	5d                   	pop    %ebp
8010197a:	c3                   	ret    
8010197b:	90                   	nop
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	53                   	push   %ebx
80101986:	83 ec 1c             	sub    $0x1c,%esp
80101989:	8b 45 08             	mov    0x8(%ebp),%eax
8010198c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010198f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101992:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101997:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010199a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010199d:	8b 75 10             	mov    0x10(%ebp),%esi
801019a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019a3:	0f 84 a7 00 00 00    	je     80101a50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019ac:	8b 40 58             	mov    0x58(%eax),%eax
801019af:	39 c6                	cmp    %eax,%esi
801019b1:	0f 87 ba 00 00 00    	ja     80101a71 <readi+0xf1>
801019b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ba:	89 f9                	mov    %edi,%ecx
801019bc:	01 f1                	add    %esi,%ecx
801019be:	0f 82 ad 00 00 00    	jb     80101a71 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019c4:	89 c2                	mov    %eax,%edx
801019c6:	29 f2                	sub    %esi,%edx
801019c8:	39 c8                	cmp    %ecx,%eax
801019ca:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019cd:	31 ff                	xor    %edi,%edi
801019cf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019d1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d4:	74 6c                	je     80101a42 <readi+0xc2>
801019d6:	8d 76 00             	lea    0x0(%esi),%esi
801019d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019e3:	89 f2                	mov    %esi,%edx
801019e5:	c1 ea 09             	shr    $0x9,%edx
801019e8:	89 d8                	mov    %ebx,%eax
801019ea:	e8 11 f9 ff ff       	call   80101300 <bmap>
801019ef:	83 ec 08             	sub    $0x8,%esp
801019f2:	50                   	push   %eax
801019f3:	ff 33                	pushl  (%ebx)
801019f5:	e8 d6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019fa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019fd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ff:	89 f0                	mov    %esi,%eax
80101a01:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a06:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a0b:	83 c4 0c             	add    $0xc,%esp
80101a0e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a10:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a14:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a17:	29 fb                	sub    %edi,%ebx
80101a19:	39 d9                	cmp    %ebx,%ecx
80101a1b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a1e:	53                   	push   %ebx
80101a1f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a20:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a22:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a25:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a27:	e8 54 2c 00 00       	call   80104680 <memmove>
    brelse(bp);
80101a2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a2f:	89 14 24             	mov    %edx,(%esp)
80101a32:	e8 a9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a3a:	83 c4 10             	add    $0x10,%esp
80101a3d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a40:	77 9e                	ja     801019e0 <readi+0x60>
  }
  return n;
80101a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5f                   	pop    %edi
80101a4b:	5d                   	pop    %ebp
80101a4c:	c3                   	ret    
80101a4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a54:	66 83 f8 09          	cmp    $0x9,%ax
80101a58:	77 17                	ja     80101a71 <readi+0xf1>
80101a5a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a61:	85 c0                	test   %eax,%eax
80101a63:	74 0c                	je     80101a71 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a6b:	5b                   	pop    %ebx
80101a6c:	5e                   	pop    %esi
80101a6d:	5f                   	pop    %edi
80101a6e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a6f:	ff e0                	jmp    *%eax
      return -1;
80101a71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a76:	eb cd                	jmp    80101a45 <readi+0xc5>
80101a78:	90                   	nop
80101a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	57                   	push   %edi
80101a84:	56                   	push   %esi
80101a85:	53                   	push   %ebx
80101a86:	83 ec 1c             	sub    $0x1c,%esp
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a97:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a9d:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101aa3:	0f 84 b7 00 00 00    	je     80101b60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101aa9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aac:	39 70 58             	cmp    %esi,0x58(%eax)
80101aaf:	0f 82 eb 00 00 00    	jb     80101ba0 <writei+0x120>
80101ab5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ab8:	31 d2                	xor    %edx,%edx
80101aba:	89 f8                	mov    %edi,%eax
80101abc:	01 f0                	add    %esi,%eax
80101abe:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ac1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ac6:	0f 87 d4 00 00 00    	ja     80101ba0 <writei+0x120>
80101acc:	85 d2                	test   %edx,%edx
80101ace:	0f 85 cc 00 00 00    	jne    80101ba0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad4:	85 ff                	test   %edi,%edi
80101ad6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101add:	74 72                	je     80101b51 <writei+0xd1>
80101adf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ae3:	89 f2                	mov    %esi,%edx
80101ae5:	c1 ea 09             	shr    $0x9,%edx
80101ae8:	89 f8                	mov    %edi,%eax
80101aea:	e8 11 f8 ff ff       	call   80101300 <bmap>
80101aef:	83 ec 08             	sub    $0x8,%esp
80101af2:	50                   	push   %eax
80101af3:	ff 37                	pushl  (%edi)
80101af5:	e8 d6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101afa:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101afd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b02:	89 f0                	mov    %esi,%eax
80101b04:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b09:	83 c4 0c             	add    $0xc,%esp
80101b0c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b11:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b17:	39 d9                	cmp    %ebx,%ecx
80101b19:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b1c:	53                   	push   %ebx
80101b1d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b20:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b22:	50                   	push   %eax
80101b23:	e8 58 2b 00 00       	call   80104680 <memmove>
    log_write(bp);
80101b28:	89 3c 24             	mov    %edi,(%esp)
80101b2b:	e8 60 12 00 00       	call   80102d90 <log_write>
    brelse(bp);
80101b30:	89 3c 24             	mov    %edi,(%esp)
80101b33:	e8 a8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b38:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b3b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b3e:	83 c4 10             	add    $0x10,%esp
80101b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b44:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b47:	77 97                	ja     80101ae0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b4f:	77 37                	ja     80101b88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b57:	5b                   	pop    %ebx
80101b58:	5e                   	pop    %esi
80101b59:	5f                   	pop    %edi
80101b5a:	5d                   	pop    %ebp
80101b5b:	c3                   	ret    
80101b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 36                	ja     80101ba0 <writei+0x120>
80101b6a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 2b                	je     80101ba0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b7f:	ff e0                	jmp    *%eax
80101b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b88:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b8b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b8e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b91:	50                   	push   %eax
80101b92:	e8 59 fa ff ff       	call   801015f0 <iupdate>
80101b97:	83 c4 10             	add    $0x10,%esp
80101b9a:	eb b5                	jmp    80101b51 <writei+0xd1>
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba5:	eb ad                	jmp    80101b54 <writei+0xd4>
80101ba7:	89 f6                	mov    %esi,%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bb6:	6a 0e                	push   $0xe
80101bb8:	ff 75 0c             	pushl  0xc(%ebp)
80101bbb:	ff 75 08             	pushl  0x8(%ebp)
80101bbe:	e8 2d 2b 00 00       	call   801046f0 <strncmp>
}
80101bc3:	c9                   	leave  
80101bc4:	c3                   	ret    
80101bc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 1c             	sub    $0x1c,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101be1:	0f 85 85 00 00 00    	jne    80101c6c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101be7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bea:	31 ff                	xor    %edi,%edi
80101bec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bef:	85 d2                	test   %edx,%edx
80101bf1:	74 3e                	je     80101c31 <dirlookup+0x61>
80101bf3:	90                   	nop
80101bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf8:	6a 10                	push   $0x10
80101bfa:	57                   	push   %edi
80101bfb:	56                   	push   %esi
80101bfc:	53                   	push   %ebx
80101bfd:	e8 7e fd ff ff       	call   80101980 <readi>
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	83 f8 10             	cmp    $0x10,%eax
80101c08:	75 55                	jne    80101c5f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c0a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c0f:	74 18                	je     80101c29 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c11:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c14:	83 ec 04             	sub    $0x4,%esp
80101c17:	6a 0e                	push   $0xe
80101c19:	50                   	push   %eax
80101c1a:	ff 75 0c             	pushl  0xc(%ebp)
80101c1d:	e8 ce 2a 00 00       	call   801046f0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c22:	83 c4 10             	add    $0x10,%esp
80101c25:	85 c0                	test   %eax,%eax
80101c27:	74 17                	je     80101c40 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c29:	83 c7 10             	add    $0x10,%edi
80101c2c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c2f:	72 c7                	jb     80101bf8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c34:	31 c0                	xor    %eax,%eax
}
80101c36:	5b                   	pop    %ebx
80101c37:	5e                   	pop    %esi
80101c38:	5f                   	pop    %edi
80101c39:	5d                   	pop    %ebp
80101c3a:	c3                   	ret    
80101c3b:	90                   	nop
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c40:	8b 45 10             	mov    0x10(%ebp),%eax
80101c43:	85 c0                	test   %eax,%eax
80101c45:	74 05                	je     80101c4c <dirlookup+0x7c>
        *poff = off;
80101c47:	8b 45 10             	mov    0x10(%ebp),%eax
80101c4a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c4c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c50:	8b 03                	mov    (%ebx),%eax
80101c52:	e8 d9 f5 ff ff       	call   80101230 <iget>
}
80101c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5a:	5b                   	pop    %ebx
80101c5b:	5e                   	pop    %esi
80101c5c:	5f                   	pop    %edi
80101c5d:	5d                   	pop    %ebp
80101c5e:	c3                   	ret    
      panic("dirlookup read");
80101c5f:	83 ec 0c             	sub    $0xc,%esp
80101c62:	68 b9 71 10 80       	push   $0x801071b9
80101c67:	e8 24 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c6c:	83 ec 0c             	sub    $0xc,%esp
80101c6f:	68 a7 71 10 80       	push   $0x801071a7
80101c74:	e8 17 e7 ff ff       	call   80100390 <panic>
80101c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	56                   	push   %esi
80101c85:	53                   	push   %ebx
80101c86:	89 cf                	mov    %ecx,%edi
80101c88:	89 c3                	mov    %eax,%ebx
80101c8a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c8d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c93:	0f 84 67 01 00 00    	je     80101e00 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c99:	e8 72 1b 00 00       	call   80103810 <myproc>
  acquire(&icache.lock);
80101c9e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ca1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ca4:	68 e0 09 11 80       	push   $0x801109e0
80101ca9:	e8 a2 27 00 00       	call   80104450 <acquire>
  ip->ref++;
80101cae:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cb2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb9:	e8 b2 28 00 00       	call   80104570 <release>
80101cbe:	83 c4 10             	add    $0x10,%esp
80101cc1:	eb 08                	jmp    80101ccb <namex+0x4b>
80101cc3:	90                   	nop
80101cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cc8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ccb:	0f b6 03             	movzbl (%ebx),%eax
80101cce:	3c 2f                	cmp    $0x2f,%al
80101cd0:	74 f6                	je     80101cc8 <namex+0x48>
  if(*path == 0)
80101cd2:	84 c0                	test   %al,%al
80101cd4:	0f 84 ee 00 00 00    	je     80101dc8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cda:	0f b6 03             	movzbl (%ebx),%eax
80101cdd:	3c 2f                	cmp    $0x2f,%al
80101cdf:	0f 84 b3 00 00 00    	je     80101d98 <namex+0x118>
80101ce5:	84 c0                	test   %al,%al
80101ce7:	89 da                	mov    %ebx,%edx
80101ce9:	75 09                	jne    80101cf4 <namex+0x74>
80101ceb:	e9 a8 00 00 00       	jmp    80101d98 <namex+0x118>
80101cf0:	84 c0                	test   %al,%al
80101cf2:	74 0a                	je     80101cfe <namex+0x7e>
    path++;
80101cf4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cf7:	0f b6 02             	movzbl (%edx),%eax
80101cfa:	3c 2f                	cmp    $0x2f,%al
80101cfc:	75 f2                	jne    80101cf0 <namex+0x70>
80101cfe:	89 d1                	mov    %edx,%ecx
80101d00:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d02:	83 f9 0d             	cmp    $0xd,%ecx
80101d05:	0f 8e 91 00 00 00    	jle    80101d9c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d0b:	83 ec 04             	sub    $0x4,%esp
80101d0e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d11:	6a 0e                	push   $0xe
80101d13:	53                   	push   %ebx
80101d14:	57                   	push   %edi
80101d15:	e8 66 29 00 00       	call   80104680 <memmove>
    path++;
80101d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d1d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d20:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d22:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d25:	75 11                	jne    80101d38 <namex+0xb8>
80101d27:	89 f6                	mov    %esi,%esi
80101d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d36:	74 f8                	je     80101d30 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d38:	83 ec 0c             	sub    $0xc,%esp
80101d3b:	56                   	push   %esi
80101d3c:	e8 5f f9 ff ff       	call   801016a0 <ilock>
    if(ip->type != T_DIR){
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d49:	0f 85 91 00 00 00    	jne    80101de0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d52:	85 d2                	test   %edx,%edx
80101d54:	74 09                	je     80101d5f <namex+0xdf>
80101d56:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d59:	0f 84 b7 00 00 00    	je     80101e16 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d5f:	83 ec 04             	sub    $0x4,%esp
80101d62:	6a 00                	push   $0x0
80101d64:	57                   	push   %edi
80101d65:	56                   	push   %esi
80101d66:	e8 65 fe ff ff       	call   80101bd0 <dirlookup>
80101d6b:	83 c4 10             	add    $0x10,%esp
80101d6e:	85 c0                	test   %eax,%eax
80101d70:	74 6e                	je     80101de0 <namex+0x160>
  iunlock(ip);
80101d72:	83 ec 0c             	sub    $0xc,%esp
80101d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d78:	56                   	push   %esi
80101d79:	e8 02 fa ff ff       	call   80101780 <iunlock>
  iput(ip);
80101d7e:	89 34 24             	mov    %esi,(%esp)
80101d81:	e8 4a fa ff ff       	call   801017d0 <iput>
80101d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d89:	83 c4 10             	add    $0x10,%esp
80101d8c:	89 c6                	mov    %eax,%esi
80101d8e:	e9 38 ff ff ff       	jmp    80101ccb <namex+0x4b>
80101d93:	90                   	nop
80101d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d98:	89 da                	mov    %ebx,%edx
80101d9a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d9c:	83 ec 04             	sub    $0x4,%esp
80101d9f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da5:	51                   	push   %ecx
80101da6:	53                   	push   %ebx
80101da7:	57                   	push   %edi
80101da8:	e8 d3 28 00 00       	call   80104680 <memmove>
    name[len] = 0;
80101dad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101db0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101db3:	83 c4 10             	add    $0x10,%esp
80101db6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dba:	89 d3                	mov    %edx,%ebx
80101dbc:	e9 61 ff ff ff       	jmp    80101d22 <namex+0xa2>
80101dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dcb:	85 c0                	test   %eax,%eax
80101dcd:	75 5d                	jne    80101e2c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd2:	89 f0                	mov    %esi,%eax
80101dd4:	5b                   	pop    %ebx
80101dd5:	5e                   	pop    %esi
80101dd6:	5f                   	pop    %edi
80101dd7:	5d                   	pop    %ebp
80101dd8:	c3                   	ret    
80101dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101de0:	83 ec 0c             	sub    $0xc,%esp
80101de3:	56                   	push   %esi
80101de4:	e8 97 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101de9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dec:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dee:	e8 dd f9 ff ff       	call   801017d0 <iput>
      return 0;
80101df3:	83 c4 10             	add    $0x10,%esp
}
80101df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df9:	89 f0                	mov    %esi,%eax
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5f                   	pop    %edi
80101dfe:	5d                   	pop    %ebp
80101dff:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e00:	ba 01 00 00 00       	mov    $0x1,%edx
80101e05:	b8 01 00 00 00       	mov    $0x1,%eax
80101e0a:	e8 21 f4 ff ff       	call   80101230 <iget>
80101e0f:	89 c6                	mov    %eax,%esi
80101e11:	e9 b5 fe ff ff       	jmp    80101ccb <namex+0x4b>
      iunlock(ip);
80101e16:	83 ec 0c             	sub    $0xc,%esp
80101e19:	56                   	push   %esi
80101e1a:	e8 61 f9 ff ff       	call   80101780 <iunlock>
      return ip;
80101e1f:	83 c4 10             	add    $0x10,%esp
}
80101e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e25:	89 f0                	mov    %esi,%eax
80101e27:	5b                   	pop    %ebx
80101e28:	5e                   	pop    %esi
80101e29:	5f                   	pop    %edi
80101e2a:	5d                   	pop    %ebp
80101e2b:	c3                   	ret    
    iput(ip);
80101e2c:	83 ec 0c             	sub    $0xc,%esp
80101e2f:	56                   	push   %esi
    return 0;
80101e30:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e32:	e8 99 f9 ff ff       	call   801017d0 <iput>
    return 0;
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	eb 93                	jmp    80101dcf <namex+0x14f>
80101e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e40 <dirlink>:
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	57                   	push   %edi
80101e44:	56                   	push   %esi
80101e45:	53                   	push   %ebx
80101e46:	83 ec 20             	sub    $0x20,%esp
80101e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e4c:	6a 00                	push   $0x0
80101e4e:	ff 75 0c             	pushl  0xc(%ebp)
80101e51:	53                   	push   %ebx
80101e52:	e8 79 fd ff ff       	call   80101bd0 <dirlookup>
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	75 67                	jne    80101ec5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e5e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e61:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e64:	85 ff                	test   %edi,%edi
80101e66:	74 29                	je     80101e91 <dirlink+0x51>
80101e68:	31 ff                	xor    %edi,%edi
80101e6a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e6d:	eb 09                	jmp    80101e78 <dirlink+0x38>
80101e6f:	90                   	nop
80101e70:	83 c7 10             	add    $0x10,%edi
80101e73:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e76:	73 19                	jae    80101e91 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e78:	6a 10                	push   $0x10
80101e7a:	57                   	push   %edi
80101e7b:	56                   	push   %esi
80101e7c:	53                   	push   %ebx
80101e7d:	e8 fe fa ff ff       	call   80101980 <readi>
80101e82:	83 c4 10             	add    $0x10,%esp
80101e85:	83 f8 10             	cmp    $0x10,%eax
80101e88:	75 4e                	jne    80101ed8 <dirlink+0x98>
    if(de.inum == 0)
80101e8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8f:	75 df                	jne    80101e70 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e94:	83 ec 04             	sub    $0x4,%esp
80101e97:	6a 0e                	push   $0xe
80101e99:	ff 75 0c             	pushl  0xc(%ebp)
80101e9c:	50                   	push   %eax
80101e9d:	e8 ae 28 00 00       	call   80104750 <strncpy>
  de.inum = inum;
80101ea2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ea5:	6a 10                	push   $0x10
80101ea7:	57                   	push   %edi
80101ea8:	56                   	push   %esi
80101ea9:	53                   	push   %ebx
  de.inum = inum;
80101eaa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eae:	e8 cd fb ff ff       	call   80101a80 <writei>
80101eb3:	83 c4 20             	add    $0x20,%esp
80101eb6:	83 f8 10             	cmp    $0x10,%eax
80101eb9:	75 2a                	jne    80101ee5 <dirlink+0xa5>
  return 0;
80101ebb:	31 c0                	xor    %eax,%eax
}
80101ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ec0:	5b                   	pop    %ebx
80101ec1:	5e                   	pop    %esi
80101ec2:	5f                   	pop    %edi
80101ec3:	5d                   	pop    %ebp
80101ec4:	c3                   	ret    
    iput(ip);
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	50                   	push   %eax
80101ec9:	e8 02 f9 ff ff       	call   801017d0 <iput>
    return -1;
80101ece:	83 c4 10             	add    $0x10,%esp
80101ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed6:	eb e5                	jmp    80101ebd <dirlink+0x7d>
      panic("dirlink read");
80101ed8:	83 ec 0c             	sub    $0xc,%esp
80101edb:	68 c8 71 10 80       	push   $0x801071c8
80101ee0:	e8 ab e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	68 c2 77 10 80       	push   $0x801077c2
80101eed:	e8 9e e4 ff ff       	call   80100390 <panic>
80101ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <namei>:

struct inode*
namei(char *path)
{
80101f00:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f01:	31 d2                	xor    %edx,%edx
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f0e:	e8 6d fd ff ff       	call   80101c80 <namex>
}
80101f13:	c9                   	leave  
80101f14:	c3                   	ret    
80101f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f20:	55                   	push   %ebp
  return namex(path, 1, name);
80101f21:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f26:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f2e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f2f:	e9 4c fd ff ff       	jmp    80101c80 <namex>
80101f34:	66 90                	xchg   %ax,%ax
80101f36:	66 90                	xchg   %ax,%ax
80101f38:	66 90                	xchg   %ax,%ax
80101f3a:	66 90                	xchg   %ax,%ax
80101f3c:	66 90                	xchg   %ax,%ax
80101f3e:	66 90                	xchg   %ax,%ax

80101f40 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	57                   	push   %edi
80101f44:	56                   	push   %esi
80101f45:	53                   	push   %ebx
80101f46:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f49:	85 c0                	test   %eax,%eax
80101f4b:	0f 84 b4 00 00 00    	je     80102005 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f51:	8b 58 08             	mov    0x8(%eax),%ebx
80101f54:	89 c6                	mov    %eax,%esi
80101f56:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f5c:	0f 87 96 00 00 00    	ja     80101ff8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f62:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f67:	89 f6                	mov    %esi,%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f70:	89 ca                	mov    %ecx,%edx
80101f72:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f73:	83 e0 c0             	and    $0xffffffc0,%eax
80101f76:	3c 40                	cmp    $0x40,%al
80101f78:	75 f6                	jne    80101f70 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f7a:	31 ff                	xor    %edi,%edi
80101f7c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f81:	89 f8                	mov    %edi,%eax
80101f83:	ee                   	out    %al,(%dx)
80101f84:	b8 01 00 00 00       	mov    $0x1,%eax
80101f89:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f8e:	ee                   	out    %al,(%dx)
80101f8f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f94:	89 d8                	mov    %ebx,%eax
80101f96:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f97:	89 d8                	mov    %ebx,%eax
80101f99:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f9e:	c1 f8 08             	sar    $0x8,%eax
80101fa1:	ee                   	out    %al,(%dx)
80101fa2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fa7:	89 f8                	mov    %edi,%eax
80101fa9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101faa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fae:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fb3:	c1 e0 04             	shl    $0x4,%eax
80101fb6:	83 e0 10             	and    $0x10,%eax
80101fb9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fbc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fbd:	f6 06 04             	testb  $0x4,(%esi)
80101fc0:	75 16                	jne    80101fd8 <idestart+0x98>
80101fc2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fc7:	89 ca                	mov    %ecx,%edx
80101fc9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcd:	5b                   	pop    %ebx
80101fce:	5e                   	pop    %esi
80101fcf:	5f                   	pop    %edi
80101fd0:	5d                   	pop    %ebp
80101fd1:	c3                   	ret    
80101fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fd8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fdd:	89 ca                	mov    %ecx,%edx
80101fdf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fe0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fe5:	83 c6 5c             	add    $0x5c,%esi
80101fe8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fed:	fc                   	cld    
80101fee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff3:	5b                   	pop    %ebx
80101ff4:	5e                   	pop    %esi
80101ff5:	5f                   	pop    %edi
80101ff6:	5d                   	pop    %ebp
80101ff7:	c3                   	ret    
    panic("incorrect blockno");
80101ff8:	83 ec 0c             	sub    $0xc,%esp
80101ffb:	68 34 72 10 80       	push   $0x80107234
80102000:	e8 8b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102005:	83 ec 0c             	sub    $0xc,%esp
80102008:	68 2b 72 10 80       	push   $0x8010722b
8010200d:	e8 7e e3 ff ff       	call   80100390 <panic>
80102012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102020 <ideinit>:
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102026:	68 46 72 10 80       	push   $0x80107246
8010202b:	68 80 a5 10 80       	push   $0x8010a580
80102030:	e8 2b 23 00 00       	call   80104360 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102035:	58                   	pop    %eax
80102036:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010203b:	5a                   	pop    %edx
8010203c:	83 e8 01             	sub    $0x1,%eax
8010203f:	50                   	push   %eax
80102040:	6a 0e                	push   $0xe
80102042:	e8 a9 02 00 00       	call   801022f0 <ioapicenable>
80102047:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010204a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204f:	90                   	nop
80102050:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102051:	83 e0 c0             	and    $0xffffffc0,%eax
80102054:	3c 40                	cmp    $0x40,%al
80102056:	75 f8                	jne    80102050 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102058:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010205d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102062:	ee                   	out    %al,(%dx)
80102063:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102068:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010206d:	eb 06                	jmp    80102075 <ideinit+0x55>
8010206f:	90                   	nop
  for(i=0; i<1000; i++){
80102070:	83 e9 01             	sub    $0x1,%ecx
80102073:	74 0f                	je     80102084 <ideinit+0x64>
80102075:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102076:	84 c0                	test   %al,%al
80102078:	74 f6                	je     80102070 <ideinit+0x50>
      havedisk1 = 1;
8010207a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102081:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102084:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102089:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010208e:	ee                   	out    %al,(%dx)
}
8010208f:	c9                   	leave  
80102090:	c3                   	ret    
80102091:	eb 0d                	jmp    801020a0 <ideintr>
80102093:	90                   	nop
80102094:	90                   	nop
80102095:	90                   	nop
80102096:	90                   	nop
80102097:	90                   	nop
80102098:	90                   	nop
80102099:	90                   	nop
8010209a:	90                   	nop
8010209b:	90                   	nop
8010209c:	90                   	nop
8010209d:	90                   	nop
8010209e:	90                   	nop
8010209f:	90                   	nop

801020a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020a9:	68 80 a5 10 80       	push   $0x8010a580
801020ae:	e8 9d 23 00 00       	call   80104450 <acquire>

  if((b = idequeue) == 0){
801020b3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020b9:	83 c4 10             	add    $0x10,%esp
801020bc:	85 db                	test   %ebx,%ebx
801020be:	74 67                	je     80102127 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020c0:	8b 43 58             	mov    0x58(%ebx),%eax
801020c3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020c8:	8b 3b                	mov    (%ebx),%edi
801020ca:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020d0:	75 31                	jne    80102103 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020d7:	89 f6                	mov    %esi,%esi
801020d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c6                	mov    %eax,%esi
801020e3:	83 e6 c0             	and    $0xffffffc0,%esi
801020e6:	89 f1                	mov    %esi,%ecx
801020e8:	80 f9 40             	cmp    $0x40,%cl
801020eb:	75 f3                	jne    801020e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020ed:	a8 21                	test   $0x21,%al
801020ef:	75 12                	jne    80102103 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020f1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020f4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fe:	fc                   	cld    
801020ff:	f3 6d                	rep insl (%dx),%es:(%edi)
80102101:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102103:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102106:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102109:	89 f9                	mov    %edi,%ecx
8010210b:	83 c9 02             	or     $0x2,%ecx
8010210e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102110:	53                   	push   %ebx
80102111:	e8 ba 1f 00 00       	call   801040d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102116:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010211b:	83 c4 10             	add    $0x10,%esp
8010211e:	85 c0                	test   %eax,%eax
80102120:	74 05                	je     80102127 <ideintr+0x87>
    idestart(idequeue);
80102122:	e8 19 fe ff ff       	call   80101f40 <idestart>
    release(&idelock);
80102127:	83 ec 0c             	sub    $0xc,%esp
8010212a:	68 80 a5 10 80       	push   $0x8010a580
8010212f:	e8 3c 24 00 00       	call   80104570 <release>

  release(&idelock);
}
80102134:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102137:	5b                   	pop    %ebx
80102138:	5e                   	pop    %esi
80102139:	5f                   	pop    %edi
8010213a:	5d                   	pop    %ebp
8010213b:	c3                   	ret    
8010213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102140 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	53                   	push   %ebx
80102144:	83 ec 10             	sub    $0x10,%esp
80102147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010214a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010214d:	50                   	push   %eax
8010214e:	e8 dd 21 00 00       	call   80104330 <holdingsleep>
80102153:	83 c4 10             	add    $0x10,%esp
80102156:	85 c0                	test   %eax,%eax
80102158:	0f 84 c6 00 00 00    	je     80102224 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010215e:	8b 03                	mov    (%ebx),%eax
80102160:	83 e0 06             	and    $0x6,%eax
80102163:	83 f8 02             	cmp    $0x2,%eax
80102166:	0f 84 ab 00 00 00    	je     80102217 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010216c:	8b 53 04             	mov    0x4(%ebx),%edx
8010216f:	85 d2                	test   %edx,%edx
80102171:	74 0d                	je     80102180 <iderw+0x40>
80102173:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102178:	85 c0                	test   %eax,%eax
8010217a:	0f 84 b1 00 00 00    	je     80102231 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	68 80 a5 10 80       	push   $0x8010a580
80102188:	e8 c3 22 00 00       	call   80104450 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102193:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102196:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219d:	85 d2                	test   %edx,%edx
8010219f:	75 09                	jne    801021aa <iderw+0x6a>
801021a1:	eb 6d                	jmp    80102210 <iderw+0xd0>
801021a3:	90                   	nop
801021a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021a8:	89 c2                	mov    %eax,%edx
801021aa:	8b 42 58             	mov    0x58(%edx),%eax
801021ad:	85 c0                	test   %eax,%eax
801021af:	75 f7                	jne    801021a8 <iderw+0x68>
801021b1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021b4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021b6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021bc:	74 42                	je     80102200 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 e0 06             	and    $0x6,%eax
801021c3:	83 f8 02             	cmp    $0x2,%eax
801021c6:	74 23                	je     801021eb <iderw+0xab>
801021c8:	90                   	nop
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021d0:	83 ec 08             	sub    $0x8,%esp
801021d3:	68 80 a5 10 80       	push   $0x8010a580
801021d8:	53                   	push   %ebx
801021d9:	e8 32 1d 00 00       	call   80103f10 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021de:	8b 03                	mov    (%ebx),%eax
801021e0:	83 c4 10             	add    $0x10,%esp
801021e3:	83 e0 06             	and    $0x6,%eax
801021e6:	83 f8 02             	cmp    $0x2,%eax
801021e9:	75 e5                	jne    801021d0 <iderw+0x90>
  }


  release(&idelock);
801021eb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021f5:	c9                   	leave  
  release(&idelock);
801021f6:	e9 75 23 00 00       	jmp    80104570 <release>
801021fb:	90                   	nop
801021fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102200:	89 d8                	mov    %ebx,%eax
80102202:	e8 39 fd ff ff       	call   80101f40 <idestart>
80102207:	eb b5                	jmp    801021be <iderw+0x7e>
80102209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102210:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102215:	eb 9d                	jmp    801021b4 <iderw+0x74>
    panic("iderw: nothing to do");
80102217:	83 ec 0c             	sub    $0xc,%esp
8010221a:	68 60 72 10 80       	push   $0x80107260
8010221f:	e8 6c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102224:	83 ec 0c             	sub    $0xc,%esp
80102227:	68 4a 72 10 80       	push   $0x8010724a
8010222c:	e8 5f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102231:	83 ec 0c             	sub    $0xc,%esp
80102234:	68 75 72 10 80       	push   $0x80107275
80102239:	e8 52 e1 ff ff       	call   80100390 <panic>
8010223e:	66 90                	xchg   %ax,%ax

80102240 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102240:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102241:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102248:	00 c0 fe 
{
8010224b:	89 e5                	mov    %esp,%ebp
8010224d:	56                   	push   %esi
8010224e:	53                   	push   %ebx
  ioapic->reg = reg;
8010224f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102256:	00 00 00 
  return ioapic->data;
80102259:	a1 34 26 11 80       	mov    0x80112634,%eax
8010225e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102267:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010226d:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102274:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102277:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010227a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010227d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102280:	39 c2                	cmp    %eax,%edx
80102282:	74 16                	je     8010229a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102284:	83 ec 0c             	sub    $0xc,%esp
80102287:	68 94 72 10 80       	push   $0x80107294
8010228c:	e8 df e3 ff ff       	call   80100670 <cprintf>
80102291:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	83 c3 21             	add    $0x21,%ebx
{
8010229d:	ba 10 00 00 00       	mov    $0x10,%edx
801022a2:	b8 20 00 00 00       	mov    $0x20,%eax
801022a7:	89 f6                	mov    %esi,%esi
801022a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022b0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022b2:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022b8:	89 c6                	mov    %eax,%esi
801022ba:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022c0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022c3:	89 71 10             	mov    %esi,0x10(%ecx)
801022c6:	8d 72 01             	lea    0x1(%edx),%esi
801022c9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022cc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ce:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022d0:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022d6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022dd:	75 d1                	jne    801022b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022e2:	5b                   	pop    %ebx
801022e3:	5e                   	pop    %esi
801022e4:	5d                   	pop    %ebp
801022e5:	c3                   	ret    
801022e6:	8d 76 00             	lea    0x0(%esi),%esi
801022e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022f0:	55                   	push   %ebp
  ioapic->reg = reg;
801022f1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801022f7:	89 e5                	mov    %esp,%ebp
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022fc:	8d 50 20             	lea    0x20(%eax),%edx
801022ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102303:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102305:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010230b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010230e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102311:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102314:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102316:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010231b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010231e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102321:	5d                   	pop    %ebp
80102322:	c3                   	ret    
80102323:	66 90                	xchg   %ax,%ax
80102325:	66 90                	xchg   %ax,%ax
80102327:	66 90                	xchg   %ax,%ax
80102329:	66 90                	xchg   %ax,%ax
8010232b:	66 90                	xchg   %ax,%ax
8010232d:	66 90                	xchg   %ax,%ax
8010232f:	90                   	nop

80102330 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	53                   	push   %ebx
80102334:	83 ec 04             	sub    $0x4,%esp
80102337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010233a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102340:	75 70                	jne    801023b2 <kfree+0x82>
80102342:	81 fb c8 57 11 80    	cmp    $0x801157c8,%ebx
80102348:	72 68                	jb     801023b2 <kfree+0x82>
8010234a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102350:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102355:	77 5b                	ja     801023b2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102357:	83 ec 04             	sub    $0x4,%esp
8010235a:	68 00 10 00 00       	push   $0x1000
8010235f:	6a 01                	push   $0x1
80102361:	53                   	push   %ebx
80102362:	e8 69 22 00 00       	call   801045d0 <memset>

  if(kmem.use_lock)
80102367:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010236d:	83 c4 10             	add    $0x10,%esp
80102370:	85 d2                	test   %edx,%edx
80102372:	75 2c                	jne    801023a0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102374:	a1 78 26 11 80       	mov    0x80112678,%eax
80102379:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010237b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102380:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102386:	85 c0                	test   %eax,%eax
80102388:	75 06                	jne    80102390 <kfree+0x60>
    release(&kmem.lock);
}
8010238a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238d:	c9                   	leave  
8010238e:	c3                   	ret    
8010238f:	90                   	nop
    release(&kmem.lock);
80102390:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010239a:	c9                   	leave  
    release(&kmem.lock);
8010239b:	e9 d0 21 00 00       	jmp    80104570 <release>
    acquire(&kmem.lock);
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 40 26 11 80       	push   $0x80112640
801023a8:	e8 a3 20 00 00       	call   80104450 <acquire>
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	eb c2                	jmp    80102374 <kfree+0x44>
    panic("kfree");
801023b2:	83 ec 0c             	sub    $0xc,%esp
801023b5:	68 c6 72 10 80       	push   $0x801072c6
801023ba:	e8 d1 df ff ff       	call   80100390 <panic>
801023bf:	90                   	nop

801023c0 <freerange>:
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023dd:	39 de                	cmp    %ebx,%esi
801023df:	72 23                	jb     80102404 <freerange+0x44>
801023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023f7:	50                   	push   %eax
801023f8:	e8 33 ff ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023fd:	83 c4 10             	add    $0x10,%esp
80102400:	39 f3                	cmp    %esi,%ebx
80102402:	76 e4                	jbe    801023e8 <freerange+0x28>
}
80102404:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102407:	5b                   	pop    %ebx
80102408:	5e                   	pop    %esi
80102409:	5d                   	pop    %ebp
8010240a:	c3                   	ret    
8010240b:	90                   	nop
8010240c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102410 <kinit1>:
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
80102415:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102418:	83 ec 08             	sub    $0x8,%esp
8010241b:	68 cc 72 10 80       	push   $0x801072cc
80102420:	68 40 26 11 80       	push   $0x80112640
80102425:	e8 36 1f 00 00       	call   80104360 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010242a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010242d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102430:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102437:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010243a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102440:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102446:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244c:	39 de                	cmp    %ebx,%esi
8010244e:	72 1c                	jb     8010246c <kinit1+0x5c>
    kfree(p);
80102450:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102456:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102459:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010245f:	50                   	push   %eax
80102460:	e8 cb fe ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102465:	83 c4 10             	add    $0x10,%esp
80102468:	39 de                	cmp    %ebx,%esi
8010246a:	73 e4                	jae    80102450 <kinit1+0x40>
}
8010246c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010246f:	5b                   	pop    %ebx
80102470:	5e                   	pop    %esi
80102471:	5d                   	pop    %ebp
80102472:	c3                   	ret    
80102473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kinit2>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102485:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102488:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010248b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102491:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102497:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010249d:	39 de                	cmp    %ebx,%esi
8010249f:	72 23                	jb     801024c4 <kinit2+0x44>
801024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ae:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024b7:	50                   	push   %eax
801024b8:	e8 73 fe ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	39 de                	cmp    %ebx,%esi
801024c2:	73 e4                	jae    801024a8 <kinit2+0x28>
  kmem.use_lock = 1;
801024c4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024cb:	00 00 00 
}
801024ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024d1:	5b                   	pop    %ebx
801024d2:	5e                   	pop    %esi
801024d3:	5d                   	pop    %ebp
801024d4:	c3                   	ret    
801024d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024e0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024e0:	a1 74 26 11 80       	mov    0x80112674,%eax
801024e5:	85 c0                	test   %eax,%eax
801024e7:	75 1f                	jne    80102508 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024e9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801024ee:	85 c0                	test   %eax,%eax
801024f0:	74 0e                	je     80102500 <kalloc+0x20>
    kmem.freelist = r->next;
801024f2:	8b 10                	mov    (%eax),%edx
801024f4:	89 15 78 26 11 80    	mov    %edx,0x80112678
801024fa:	c3                   	ret    
801024fb:	90                   	nop
801024fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102500:	f3 c3                	repz ret 
80102502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102508:	55                   	push   %ebp
80102509:	89 e5                	mov    %esp,%ebp
8010250b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010250e:	68 40 26 11 80       	push   $0x80112640
80102513:	e8 38 1f 00 00       	call   80104450 <acquire>
  r = kmem.freelist;
80102518:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102526:	85 c0                	test   %eax,%eax
80102528:	74 08                	je     80102532 <kalloc+0x52>
    kmem.freelist = r->next;
8010252a:	8b 08                	mov    (%eax),%ecx
8010252c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102532:	85 d2                	test   %edx,%edx
80102534:	74 16                	je     8010254c <kalloc+0x6c>
    release(&kmem.lock);
80102536:	83 ec 0c             	sub    $0xc,%esp
80102539:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010253c:	68 40 26 11 80       	push   $0x80112640
80102541:	e8 2a 20 00 00       	call   80104570 <release>
  return (char*)r;
80102546:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102549:	83 c4 10             	add    $0x10,%esp
}
8010254c:	c9                   	leave  
8010254d:	c3                   	ret    
8010254e:	66 90                	xchg   %ax,%ax

80102550 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102550:	ba 64 00 00 00       	mov    $0x64,%edx
80102555:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102556:	a8 01                	test   $0x1,%al
80102558:	0f 84 c2 00 00 00    	je     80102620 <kbdgetc+0xd0>
8010255e:	ba 60 00 00 00       	mov    $0x60,%edx
80102563:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102564:	0f b6 d0             	movzbl %al,%edx
80102567:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010256d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102573:	0f 84 7f 00 00 00    	je     801025f8 <kbdgetc+0xa8>
{
80102579:	55                   	push   %ebp
8010257a:	89 e5                	mov    %esp,%ebp
8010257c:	53                   	push   %ebx
8010257d:	89 cb                	mov    %ecx,%ebx
8010257f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102582:	84 c0                	test   %al,%al
80102584:	78 4a                	js     801025d0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102586:	85 db                	test   %ebx,%ebx
80102588:	74 09                	je     80102593 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010258a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010258d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102590:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102593:	0f b6 82 00 74 10 80 	movzbl -0x7fef8c00(%edx),%eax
8010259a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010259c:	0f b6 82 00 73 10 80 	movzbl -0x7fef8d00(%edx),%eax
801025a3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025a5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025a7:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025ad:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025b0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025b3:	8b 04 85 e0 72 10 80 	mov    -0x7fef8d20(,%eax,4),%eax
801025ba:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025be:	74 31                	je     801025f1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025c0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025c3:	83 fa 19             	cmp    $0x19,%edx
801025c6:	77 40                	ja     80102608 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025c8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025cb:	5b                   	pop    %ebx
801025cc:	5d                   	pop    %ebp
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025d0:	83 e0 7f             	and    $0x7f,%eax
801025d3:	85 db                	test   %ebx,%ebx
801025d5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025d8:	0f b6 82 00 74 10 80 	movzbl -0x7fef8c00(%edx),%eax
801025df:	83 c8 40             	or     $0x40,%eax
801025e2:	0f b6 c0             	movzbl %al,%eax
801025e5:	f7 d0                	not    %eax
801025e7:	21 c1                	and    %eax,%ecx
    return 0;
801025e9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025eb:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801025f1:	5b                   	pop    %ebx
801025f2:	5d                   	pop    %ebp
801025f3:	c3                   	ret    
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025f8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025fb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025fd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102603:	c3                   	ret    
80102604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102608:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010260b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010260e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010260f:	83 f9 1a             	cmp    $0x1a,%ecx
80102612:	0f 42 c2             	cmovb  %edx,%eax
}
80102615:	5d                   	pop    %ebp
80102616:	c3                   	ret    
80102617:	89 f6                	mov    %esi,%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102625:	c3                   	ret    
80102626:	8d 76 00             	lea    0x0(%esi),%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102630 <kbdintr>:

void
kbdintr(void)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102636:	68 50 25 10 80       	push   $0x80102550
8010263b:	e8 e0 e1 ff ff       	call   80100820 <consoleintr>
}
80102640:	83 c4 10             	add    $0x10,%esp
80102643:	c9                   	leave  
80102644:	c3                   	ret    
80102645:	66 90                	xchg   %ax,%ax
80102647:	66 90                	xchg   %ax,%ax
80102649:	66 90                	xchg   %ax,%ax
8010264b:	66 90                	xchg   %ax,%ax
8010264d:	66 90                	xchg   %ax,%ax
8010264f:	90                   	nop

80102650 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102650:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102655:	55                   	push   %ebp
80102656:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102658:	85 c0                	test   %eax,%eax
8010265a:	0f 84 c8 00 00 00    	je     80102728 <lapicinit+0xd8>
  lapic[index] = value;
80102660:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102667:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010266d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102677:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010267a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102681:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102684:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102687:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010268e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102691:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102694:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010269b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ae:	8b 50 30             	mov    0x30(%eax),%edx
801026b1:	c1 ea 10             	shr    $0x10,%edx
801026b4:	80 fa 03             	cmp    $0x3,%dl
801026b7:	77 77                	ja     80102730 <lapicinit+0xe0>
  lapic[index] = value;
801026b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102701:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102704:	8b 50 20             	mov    0x20(%eax),%edx
80102707:	89 f6                	mov    %esi,%esi
80102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102710:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102716:	80 e6 10             	and    $0x10,%dh
80102719:	75 f5                	jne    80102710 <lapicinit+0xc0>
  lapic[index] = value;
8010271b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102722:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102725:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102730:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102737:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	8b 50 20             	mov    0x20(%eax),%edx
8010273d:	e9 77 ff ff ff       	jmp    801026b9 <lapicinit+0x69>
80102742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102750:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
80102756:	55                   	push   %ebp
80102757:	31 c0                	xor    %eax,%eax
80102759:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010275b:	85 d2                	test   %edx,%edx
8010275d:	74 06                	je     80102765 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010275f:	8b 42 20             	mov    0x20(%edx),%eax
80102762:	c1 e8 18             	shr    $0x18,%eax
}
80102765:	5d                   	pop    %ebp
80102766:	c3                   	ret    
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0d                	je     80102789 <lapiceoi+0x19>
  lapic[index] = value;
8010277c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102783:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
}
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027a6:	ba 70 00 00 00       	mov    $0x70,%edx
801027ab:	89 e5                	mov    %esp,%ebp
801027ad:	53                   	push   %ebx
801027ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027b4:	ee                   	out    %al,(%dx)
801027b5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ba:	ba 71 00 00 00       	mov    $0x71,%edx
801027bf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027c0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027c2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027c5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027cb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027cd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027d0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027d3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027d5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027d8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027de:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027e3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027f3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102800:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102803:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102806:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010280f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102815:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102818:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010282a:	5b                   	pop    %ebx
8010282b:	5d                   	pop    %ebp
8010282c:	c3                   	ret    
8010282d:	8d 76 00             	lea    0x0(%esi),%esi

80102830 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102830:	55                   	push   %ebp
80102831:	b8 0b 00 00 00       	mov    $0xb,%eax
80102836:	ba 70 00 00 00       	mov    $0x70,%edx
8010283b:	89 e5                	mov    %esp,%ebp
8010283d:	57                   	push   %edi
8010283e:	56                   	push   %esi
8010283f:	53                   	push   %ebx
80102840:	83 ec 4c             	sub    $0x4c,%esp
80102843:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102844:	ba 71 00 00 00       	mov    $0x71,%edx
80102849:	ec                   	in     (%dx),%al
8010284a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010284d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102852:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102855:	8d 76 00             	lea    0x0(%esi),%esi
80102858:	31 c0                	xor    %eax,%eax
8010285a:	89 da                	mov    %ebx,%edx
8010285c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102862:	89 ca                	mov    %ecx,%edx
80102864:	ec                   	in     (%dx),%al
80102865:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102868:	89 da                	mov    %ebx,%edx
8010286a:	b8 02 00 00 00       	mov    $0x2,%eax
8010286f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102870:	89 ca                	mov    %ecx,%edx
80102872:	ec                   	in     (%dx),%al
80102873:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102876:	89 da                	mov    %ebx,%edx
80102878:	b8 04 00 00 00       	mov    $0x4,%eax
8010287d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287e:	89 ca                	mov    %ecx,%edx
80102880:	ec                   	in     (%dx),%al
80102881:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102884:	89 da                	mov    %ebx,%edx
80102886:	b8 07 00 00 00       	mov    $0x7,%eax
8010288b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	89 ca                	mov    %ecx,%edx
8010288e:	ec                   	in     (%dx),%al
8010288f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102892:	89 da                	mov    %ebx,%edx
80102894:	b8 08 00 00 00       	mov    $0x8,%eax
80102899:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289a:	89 ca                	mov    %ecx,%edx
8010289c:	ec                   	in     (%dx),%al
8010289d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010289f:	89 da                	mov    %ebx,%edx
801028a1:	b8 09 00 00 00       	mov    $0x9,%eax
801028a6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a7:	89 ca                	mov    %ecx,%edx
801028a9:	ec                   	in     (%dx),%al
801028aa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	b8 0a 00 00 00       	mov    $0xa,%eax
801028b3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b4:	89 ca                	mov    %ecx,%edx
801028b6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028b7:	84 c0                	test   %al,%al
801028b9:	78 9d                	js     80102858 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028bb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028bf:	89 fa                	mov    %edi,%edx
801028c1:	0f b6 fa             	movzbl %dl,%edi
801028c4:	89 f2                	mov    %esi,%edx
801028c6:	0f b6 f2             	movzbl %dl,%esi
801028c9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028cc:	89 da                	mov    %ebx,%edx
801028ce:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028d1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028d4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028db:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028df:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028e2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028e9:	31 c0                	xor    %eax,%eax
801028eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ec:	89 ca                	mov    %ecx,%edx
801028ee:	ec                   	in     (%dx),%al
801028ef:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f2:	89 da                	mov    %ebx,%edx
801028f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028f7:	b8 02 00 00 00       	mov    $0x2,%eax
801028fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fd:	89 ca                	mov    %ecx,%edx
801028ff:	ec                   	in     (%dx),%al
80102900:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102903:	89 da                	mov    %ebx,%edx
80102905:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102908:	b8 04 00 00 00       	mov    $0x4,%eax
8010290d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290e:	89 ca                	mov    %ecx,%edx
80102910:	ec                   	in     (%dx),%al
80102911:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102914:	89 da                	mov    %ebx,%edx
80102916:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102919:	b8 07 00 00 00       	mov    $0x7,%eax
8010291e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291f:	89 ca                	mov    %ecx,%edx
80102921:	ec                   	in     (%dx),%al
80102922:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102925:	89 da                	mov    %ebx,%edx
80102927:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010292a:	b8 08 00 00 00       	mov    $0x8,%eax
8010292f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102930:	89 ca                	mov    %ecx,%edx
80102932:	ec                   	in     (%dx),%al
80102933:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102936:	89 da                	mov    %ebx,%edx
80102938:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010293b:	b8 09 00 00 00       	mov    $0x9,%eax
80102940:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102941:	89 ca                	mov    %ecx,%edx
80102943:	ec                   	in     (%dx),%al
80102944:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102947:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010294a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010294d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102950:	6a 18                	push   $0x18
80102952:	50                   	push   %eax
80102953:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102956:	50                   	push   %eax
80102957:	e8 c4 1c 00 00       	call   80104620 <memcmp>
8010295c:	83 c4 10             	add    $0x10,%esp
8010295f:	85 c0                	test   %eax,%eax
80102961:	0f 85 f1 fe ff ff    	jne    80102858 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102967:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010296b:	75 78                	jne    801029e5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010296d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102970:	89 c2                	mov    %eax,%edx
80102972:	83 e0 0f             	and    $0xf,%eax
80102975:	c1 ea 04             	shr    $0x4,%edx
80102978:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102981:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102984:	89 c2                	mov    %eax,%edx
80102986:	83 e0 0f             	and    $0xf,%eax
80102989:	c1 ea 04             	shr    $0x4,%edx
8010298c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102992:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102995:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102998:	89 c2                	mov    %eax,%edx
8010299a:	83 e0 0f             	and    $0xf,%eax
8010299d:	c1 ea 04             	shr    $0x4,%edx
801029a0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ac:	89 c2                	mov    %eax,%edx
801029ae:	83 e0 0f             	and    $0xf,%eax
801029b1:	c1 ea 04             	shr    $0x4,%edx
801029b4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029c0:	89 c2                	mov    %eax,%edx
801029c2:	83 e0 0f             	and    $0xf,%eax
801029c5:	c1 ea 04             	shr    $0x4,%edx
801029c8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029d4:	89 c2                	mov    %eax,%edx
801029d6:	83 e0 0f             	and    $0xf,%eax
801029d9:	c1 ea 04             	shr    $0x4,%edx
801029dc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029df:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029e5:	8b 75 08             	mov    0x8(%ebp),%esi
801029e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029eb:	89 06                	mov    %eax,(%esi)
801029ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029f0:	89 46 04             	mov    %eax,0x4(%esi)
801029f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029f6:	89 46 08             	mov    %eax,0x8(%esi)
801029f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029fc:	89 46 0c             	mov    %eax,0xc(%esi)
801029ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a02:	89 46 10             	mov    %eax,0x10(%esi)
80102a05:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a08:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a0b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a15:	5b                   	pop    %ebx
80102a16:	5e                   	pop    %esi
80102a17:	5f                   	pop    %edi
80102a18:	5d                   	pop    %ebp
80102a19:	c3                   	ret    
80102a1a:	66 90                	xchg   %ax,%ax
80102a1c:	66 90                	xchg   %ax,%ax
80102a1e:	66 90                	xchg   %ax,%ax

80102a20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a20:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a26:	85 c9                	test   %ecx,%ecx
80102a28:	0f 8e 8a 00 00 00    	jle    80102ab8 <install_trans+0x98>
{
80102a2e:	55                   	push   %ebp
80102a2f:	89 e5                	mov    %esp,%ebp
80102a31:	57                   	push   %edi
80102a32:	56                   	push   %esi
80102a33:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a34:	31 db                	xor    %ebx,%ebx
{
80102a36:	83 ec 0c             	sub    $0xc,%esp
80102a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a40:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a45:	83 ec 08             	sub    $0x8,%esp
80102a48:	01 d8                	add    %ebx,%eax
80102a4a:	83 c0 01             	add    $0x1,%eax
80102a4d:	50                   	push   %eax
80102a4e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a54:	e8 77 d6 ff ff       	call   801000d0 <bread>
80102a59:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5b:	58                   	pop    %eax
80102a5c:	5a                   	pop    %edx
80102a5d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102a64:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a6d:	e8 5e d6 ff ff       	call   801000d0 <bread>
80102a72:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a74:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a77:	83 c4 0c             	add    $0xc,%esp
80102a7a:	68 00 02 00 00       	push   $0x200
80102a7f:	50                   	push   %eax
80102a80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a83:	50                   	push   %eax
80102a84:	e8 f7 1b 00 00       	call   80104680 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 0f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a91:	89 3c 24             	mov    %edi,(%esp)
80102a94:	e8 47 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a99:	89 34 24             	mov    %esi,(%esp)
80102a9c:	e8 3f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102aa1:	83 c4 10             	add    $0x10,%esp
80102aa4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102aaa:	7f 94                	jg     80102a40 <install_trans+0x20>
  }
}
80102aac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102aaf:	5b                   	pop    %ebx
80102ab0:	5e                   	pop    %esi
80102ab1:	5f                   	pop    %edi
80102ab2:	5d                   	pop    %ebp
80102ab3:	c3                   	ret    
80102ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ab8:	f3 c3                	repz ret 
80102aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ac0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	56                   	push   %esi
80102ac4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ac5:	83 ec 08             	sub    $0x8,%esp
80102ac8:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102ace:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ad4:	e8 f7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ad9:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102adf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ae2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ae4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ae6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ae9:	7e 16                	jle    80102b01 <write_head+0x41>
80102aeb:	c1 e3 02             	shl    $0x2,%ebx
80102aee:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102af0:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102af6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102afa:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102afd:	39 da                	cmp    %ebx,%edx
80102aff:	75 ef                	jne    80102af0 <write_head+0x30>
  }
  bwrite(buf);
80102b01:	83 ec 0c             	sub    $0xc,%esp
80102b04:	56                   	push   %esi
80102b05:	e8 96 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b0a:	89 34 24             	mov    %esi,(%esp)
80102b0d:	e8 ce d6 ff ff       	call   801001e0 <brelse>
}
80102b12:	83 c4 10             	add    $0x10,%esp
80102b15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b18:	5b                   	pop    %ebx
80102b19:	5e                   	pop    %esi
80102b1a:	5d                   	pop    %ebp
80102b1b:	c3                   	ret    
80102b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b20 <initlog>:
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	53                   	push   %ebx
80102b24:	83 ec 2c             	sub    $0x2c,%esp
80102b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b2a:	68 00 75 10 80       	push   $0x80107500
80102b2f:	68 80 26 11 80       	push   $0x80112680
80102b34:	e8 27 18 00 00       	call   80104360 <initlock>
  readsb(dev, &sb);
80102b39:	58                   	pop    %eax
80102b3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 9b e8 ff ff       	call   801013e0 <readsb>
  log.size = sb.nlog;
80102b45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b4b:	59                   	pop    %ecx
  log.dev = dev;
80102b4c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102b52:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102b58:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102b5d:	5a                   	pop    %edx
80102b5e:	50                   	push   %eax
80102b5f:	53                   	push   %ebx
80102b60:	e8 6b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b65:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b68:	83 c4 10             	add    $0x10,%esp
80102b6b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b6d:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b73:	7e 1c                	jle    80102b91 <initlog+0x71>
80102b75:	c1 e3 02             	shl    $0x2,%ebx
80102b78:	31 d2                	xor    %edx,%edx
80102b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b80:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b84:	83 c2 04             	add    $0x4,%edx
80102b87:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b8d:	39 d3                	cmp    %edx,%ebx
80102b8f:	75 ef                	jne    80102b80 <initlog+0x60>
  brelse(buf);
80102b91:	83 ec 0c             	sub    $0xc,%esp
80102b94:	50                   	push   %eax
80102b95:	e8 46 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b9a:	e8 81 fe ff ff       	call   80102a20 <install_trans>
  log.lh.n = 0;
80102b9f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ba6:	00 00 00 
  write_head(); // clear the log
80102ba9:	e8 12 ff ff ff       	call   80102ac0 <write_head>
}
80102bae:	83 c4 10             	add    $0x10,%esp
80102bb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bb4:	c9                   	leave  
80102bb5:	c3                   	ret    
80102bb6:	8d 76 00             	lea    0x0(%esi),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bc6:	68 80 26 11 80       	push   $0x80112680
80102bcb:	e8 80 18 00 00       	call   80104450 <acquire>
80102bd0:	83 c4 10             	add    $0x10,%esp
80102bd3:	eb 18                	jmp    80102bed <begin_op+0x2d>
80102bd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bd8:	83 ec 08             	sub    $0x8,%esp
80102bdb:	68 80 26 11 80       	push   $0x80112680
80102be0:	68 80 26 11 80       	push   $0x80112680
80102be5:	e8 26 13 00 00       	call   80103f10 <sleep>
80102bea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bed:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102bf2:	85 c0                	test   %eax,%eax
80102bf4:	75 e2                	jne    80102bd8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bf6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102bfb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c01:	83 c0 01             	add    $0x1,%eax
80102c04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c0a:	83 fa 1e             	cmp    $0x1e,%edx
80102c0d:	7f c9                	jg     80102bd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c0f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c12:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c17:	68 80 26 11 80       	push   $0x80112680
80102c1c:	e8 4f 19 00 00       	call   80104570 <release>
      break;
    }
  }
}
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	c9                   	leave  
80102c25:	c3                   	ret    
80102c26:	8d 76 00             	lea    0x0(%esi),%esi
80102c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	57                   	push   %edi
80102c34:	56                   	push   %esi
80102c35:	53                   	push   %ebx
80102c36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c39:	68 80 26 11 80       	push   $0x80112680
80102c3e:	e8 0d 18 00 00       	call   80104450 <acquire>
  log.outstanding -= 1;
80102c43:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c48:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102c4e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c51:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c54:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c56:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102c5c:	0f 85 1a 01 00 00    	jne    80102d7c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c62:	85 db                	test   %ebx,%ebx
80102c64:	0f 85 ee 00 00 00    	jne    80102d58 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c6a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c6d:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c74:	00 00 00 
  release(&log.lock);
80102c77:	68 80 26 11 80       	push   $0x80112680
80102c7c:	e8 ef 18 00 00       	call   80104570 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c81:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c87:	83 c4 10             	add    $0x10,%esp
80102c8a:	85 c9                	test   %ecx,%ecx
80102c8c:	0f 8e 85 00 00 00    	jle    80102d17 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c92:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c97:	83 ec 08             	sub    $0x8,%esp
80102c9a:	01 d8                	add    %ebx,%eax
80102c9c:	83 c0 01             	add    $0x1,%eax
80102c9f:	50                   	push   %eax
80102ca0:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ca6:	e8 25 d4 ff ff       	call   801000d0 <bread>
80102cab:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cad:	58                   	pop    %eax
80102cae:	5a                   	pop    %edx
80102caf:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102cb6:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cbc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cbf:	e8 0c d4 ff ff       	call   801000d0 <bread>
80102cc4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cc6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cc9:	83 c4 0c             	add    $0xc,%esp
80102ccc:	68 00 02 00 00       	push   $0x200
80102cd1:	50                   	push   %eax
80102cd2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cd5:	50                   	push   %eax
80102cd6:	e8 a5 19 00 00       	call   80104680 <memmove>
    bwrite(to);  // write the log
80102cdb:	89 34 24             	mov    %esi,(%esp)
80102cde:	e8 bd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ce3:	89 3c 24             	mov    %edi,(%esp)
80102ce6:	e8 f5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ceb:	89 34 24             	mov    %esi,(%esp)
80102cee:	e8 ed d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cf3:	83 c4 10             	add    $0x10,%esp
80102cf6:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102cfc:	7c 94                	jl     80102c92 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cfe:	e8 bd fd ff ff       	call   80102ac0 <write_head>
    install_trans(); // Now install writes to home locations
80102d03:	e8 18 fd ff ff       	call   80102a20 <install_trans>
    log.lh.n = 0;
80102d08:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d0f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d12:	e8 a9 fd ff ff       	call   80102ac0 <write_head>
    acquire(&log.lock);
80102d17:	83 ec 0c             	sub    $0xc,%esp
80102d1a:	68 80 26 11 80       	push   $0x80112680
80102d1f:	e8 2c 17 00 00       	call   80104450 <acquire>
    wakeup(&log);
80102d24:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d2b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d32:	00 00 00 
    wakeup(&log);
80102d35:	e8 96 13 00 00       	call   801040d0 <wakeup>
    release(&log.lock);
80102d3a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d41:	e8 2a 18 00 00       	call   80104570 <release>
80102d46:	83 c4 10             	add    $0x10,%esp
}
80102d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d4c:	5b                   	pop    %ebx
80102d4d:	5e                   	pop    %esi
80102d4e:	5f                   	pop    %edi
80102d4f:	5d                   	pop    %ebp
80102d50:	c3                   	ret    
80102d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d58:	83 ec 0c             	sub    $0xc,%esp
80102d5b:	68 80 26 11 80       	push   $0x80112680
80102d60:	e8 6b 13 00 00       	call   801040d0 <wakeup>
  release(&log.lock);
80102d65:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d6c:	e8 ff 17 00 00       	call   80104570 <release>
80102d71:	83 c4 10             	add    $0x10,%esp
}
80102d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d77:	5b                   	pop    %ebx
80102d78:	5e                   	pop    %esi
80102d79:	5f                   	pop    %edi
80102d7a:	5d                   	pop    %ebp
80102d7b:	c3                   	ret    
    panic("log.committing");
80102d7c:	83 ec 0c             	sub    $0xc,%esp
80102d7f:	68 04 75 10 80       	push   $0x80107504
80102d84:	e8 07 d6 ff ff       	call   80100390 <panic>
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d97:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102d9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102da0:	83 fa 1d             	cmp    $0x1d,%edx
80102da3:	0f 8f 9d 00 00 00    	jg     80102e46 <log_write+0xb6>
80102da9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102dae:	83 e8 01             	sub    $0x1,%eax
80102db1:	39 c2                	cmp    %eax,%edx
80102db3:	0f 8d 8d 00 00 00    	jge    80102e46 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102db9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102dbe:	85 c0                	test   %eax,%eax
80102dc0:	0f 8e 8d 00 00 00    	jle    80102e53 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dc6:	83 ec 0c             	sub    $0xc,%esp
80102dc9:	68 80 26 11 80       	push   $0x80112680
80102dce:	e8 7d 16 00 00       	call   80104450 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dd3:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102dd9:	83 c4 10             	add    $0x10,%esp
80102ddc:	83 f9 00             	cmp    $0x0,%ecx
80102ddf:	7e 57                	jle    80102e38 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102de4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de6:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102dec:	75 0b                	jne    80102df9 <log_write+0x69>
80102dee:	eb 38                	jmp    80102e28 <log_write+0x98>
80102df0:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102df7:	74 2f                	je     80102e28 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102df9:	83 c0 01             	add    $0x1,%eax
80102dfc:	39 c1                	cmp    %eax,%ecx
80102dfe:	75 f0                	jne    80102df0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e00:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e07:	83 c0 01             	add    $0x1,%eax
80102e0a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102e0f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e12:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102e19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e1c:	c9                   	leave  
  release(&log.lock);
80102e1d:	e9 4e 17 00 00       	jmp    80104570 <release>
80102e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e28:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102e2f:	eb de                	jmp    80102e0f <log_write+0x7f>
80102e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e38:	8b 43 08             	mov    0x8(%ebx),%eax
80102e3b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e40:	75 cd                	jne    80102e0f <log_write+0x7f>
80102e42:	31 c0                	xor    %eax,%eax
80102e44:	eb c1                	jmp    80102e07 <log_write+0x77>
    panic("too big a transaction");
80102e46:	83 ec 0c             	sub    $0xc,%esp
80102e49:	68 13 75 10 80       	push   $0x80107513
80102e4e:	e8 3d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e53:	83 ec 0c             	sub    $0xc,%esp
80102e56:	68 29 75 10 80       	push   $0x80107529
80102e5b:	e8 30 d5 ff ff       	call   80100390 <panic>

80102e60 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
80102e64:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e67:	e8 84 09 00 00       	call   801037f0 <cpuid>
80102e6c:	89 c3                	mov    %eax,%ebx
80102e6e:	e8 7d 09 00 00       	call   801037f0 <cpuid>
80102e73:	83 ec 04             	sub    $0x4,%esp
80102e76:	53                   	push   %ebx
80102e77:	50                   	push   %eax
80102e78:	68 44 75 10 80       	push   $0x80107544
80102e7d:	e8 ee d7 ff ff       	call   80100670 <cprintf>
  idtinit();       // load idt register
80102e82:	e8 e9 29 00 00       	call   80105870 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e87:	e8 e4 08 00 00       	call   80103770 <mycpu>
80102e8c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e8e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e93:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e9a:	e8 31 0d 00 00       	call   80103bd0 <scheduler>
80102e9f:	90                   	nop

80102ea0 <mpenter>:
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ea6:	e8 c5 3a 00 00       	call   80106970 <switchkvm>
  seginit();
80102eab:	e8 30 3a 00 00       	call   801068e0 <seginit>
  lapicinit();
80102eb0:	e8 9b f7 ff ff       	call   80102650 <lapicinit>
  mpmain();
80102eb5:	e8 a6 ff ff ff       	call   80102e60 <mpmain>
80102eba:	66 90                	xchg   %ax,%ax
80102ebc:	66 90                	xchg   %ax,%ax
80102ebe:	66 90                	xchg   %ax,%ax

80102ec0 <main>:
{
80102ec0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ec4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ec7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eca:	55                   	push   %ebp
80102ecb:	89 e5                	mov    %esp,%ebp
80102ecd:	53                   	push   %ebx
80102ece:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ecf:	83 ec 08             	sub    $0x8,%esp
80102ed2:	68 00 00 40 80       	push   $0x80400000
80102ed7:	68 c8 57 11 80       	push   $0x801157c8
80102edc:	e8 2f f5 ff ff       	call   80102410 <kinit1>
  kvmalloc();      // kernel page table
80102ee1:	e8 5a 3f 00 00       	call   80106e40 <kvmalloc>
  mpinit();        // detect other processors
80102ee6:	e8 75 01 00 00       	call   80103060 <mpinit>
  lapicinit();     // interrupt controller
80102eeb:	e8 60 f7 ff ff       	call   80102650 <lapicinit>
  seginit();       // segment descriptors
80102ef0:	e8 eb 39 00 00       	call   801068e0 <seginit>
  picinit();       // disable pic
80102ef5:	e8 46 03 00 00       	call   80103240 <picinit>
  ioapicinit();    // another interrupt controller
80102efa:	e8 41 f3 ff ff       	call   80102240 <ioapicinit>
  consoleinit();   // console hardware
80102eff:	e8 cc da ff ff       	call   801009d0 <consoleinit>
  uartinit();      // serial port
80102f04:	e8 a7 2c 00 00       	call   80105bb0 <uartinit>
  pinit();         // process table
80102f09:	e8 42 08 00 00       	call   80103750 <pinit>
  tvinit();        // trap vectors
80102f0e:	e8 dd 28 00 00       	call   801057f0 <tvinit>
  binit();         // buffer cache
80102f13:	e8 28 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f18:	e8 53 de ff ff       	call   80100d70 <fileinit>
  ideinit();       // disk 
80102f1d:	e8 fe f0 ff ff       	call   80102020 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f22:	83 c4 0c             	add    $0xc,%esp
80102f25:	68 8a 00 00 00       	push   $0x8a
80102f2a:	68 8c a4 10 80       	push   $0x8010a48c
80102f2f:	68 00 70 00 80       	push   $0x80007000
80102f34:	e8 47 17 00 00       	call   80104680 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f39:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f40:	00 00 00 
80102f43:	83 c4 10             	add    $0x10,%esp
80102f46:	05 80 27 11 80       	add    $0x80112780,%eax
80102f4b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102f50:	76 71                	jbe    80102fc3 <main+0x103>
80102f52:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102f57:	89 f6                	mov    %esi,%esi
80102f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f60:	e8 0b 08 00 00       	call   80103770 <mycpu>
80102f65:	39 d8                	cmp    %ebx,%eax
80102f67:	74 41                	je     80102faa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f69:	e8 72 f5 ff ff       	call   801024e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f6e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102f73:	c7 05 f8 6f 00 80 a0 	movl   $0x80102ea0,0x80006ff8
80102f7a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f7d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f84:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f87:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f8c:	0f b6 03             	movzbl (%ebx),%eax
80102f8f:	83 ec 08             	sub    $0x8,%esp
80102f92:	68 00 70 00 00       	push   $0x7000
80102f97:	50                   	push   %eax
80102f98:	e8 03 f8 ff ff       	call   801027a0 <lapicstartap>
80102f9d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fa0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fa6:	85 c0                	test   %eax,%eax
80102fa8:	74 f6                	je     80102fa0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102faa:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102fb1:	00 00 00 
80102fb4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fba:	05 80 27 11 80       	add    $0x80112780,%eax
80102fbf:	39 c3                	cmp    %eax,%ebx
80102fc1:	72 9d                	jb     80102f60 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fc3:	83 ec 08             	sub    $0x8,%esp
80102fc6:	68 00 00 00 8e       	push   $0x8e000000
80102fcb:	68 00 00 40 80       	push   $0x80400000
80102fd0:	e8 ab f4 ff ff       	call   80102480 <kinit2>
  userinit();      // first user process
80102fd5:	e8 56 09 00 00       	call   80103930 <userinit>
  mpmain();        // finish this processor's setup
80102fda:	e8 81 fe ff ff       	call   80102e60 <mpmain>
80102fdf:	90                   	nop

80102fe0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fe5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102feb:	53                   	push   %ebx
  e = addr+len;
80102fec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102ff2:	39 de                	cmp    %ebx,%esi
80102ff4:	72 10                	jb     80103006 <mpsearch1+0x26>
80102ff6:	eb 50                	jmp    80103048 <mpsearch1+0x68>
80102ff8:	90                   	nop
80102ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103000:	39 fb                	cmp    %edi,%ebx
80103002:	89 fe                	mov    %edi,%esi
80103004:	76 42                	jbe    80103048 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103006:	83 ec 04             	sub    $0x4,%esp
80103009:	8d 7e 10             	lea    0x10(%esi),%edi
8010300c:	6a 04                	push   $0x4
8010300e:	68 58 75 10 80       	push   $0x80107558
80103013:	56                   	push   %esi
80103014:	e8 07 16 00 00       	call   80104620 <memcmp>
80103019:	83 c4 10             	add    $0x10,%esp
8010301c:	85 c0                	test   %eax,%eax
8010301e:	75 e0                	jne    80103000 <mpsearch1+0x20>
80103020:	89 f1                	mov    %esi,%ecx
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103028:	0f b6 11             	movzbl (%ecx),%edx
8010302b:	83 c1 01             	add    $0x1,%ecx
8010302e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103030:	39 f9                	cmp    %edi,%ecx
80103032:	75 f4                	jne    80103028 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103034:	84 c0                	test   %al,%al
80103036:	75 c8                	jne    80103000 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103038:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010303b:	89 f0                	mov    %esi,%eax
8010303d:	5b                   	pop    %ebx
8010303e:	5e                   	pop    %esi
8010303f:	5f                   	pop    %edi
80103040:	5d                   	pop    %ebp
80103041:	c3                   	ret    
80103042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103048:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010304b:	31 f6                	xor    %esi,%esi
}
8010304d:	89 f0                	mov    %esi,%eax
8010304f:	5b                   	pop    %ebx
80103050:	5e                   	pop    %esi
80103051:	5f                   	pop    %edi
80103052:	5d                   	pop    %ebp
80103053:	c3                   	ret    
80103054:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010305a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103060 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	57                   	push   %edi
80103064:	56                   	push   %esi
80103065:	53                   	push   %ebx
80103066:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103069:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103070:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103077:	c1 e0 08             	shl    $0x8,%eax
8010307a:	09 d0                	or     %edx,%eax
8010307c:	c1 e0 04             	shl    $0x4,%eax
8010307f:	85 c0                	test   %eax,%eax
80103081:	75 1b                	jne    8010309e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103083:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010308a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103091:	c1 e0 08             	shl    $0x8,%eax
80103094:	09 d0                	or     %edx,%eax
80103096:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103099:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010309e:	ba 00 04 00 00       	mov    $0x400,%edx
801030a3:	e8 38 ff ff ff       	call   80102fe0 <mpsearch1>
801030a8:	85 c0                	test   %eax,%eax
801030aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030ad:	0f 84 3d 01 00 00    	je     801031f0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030b6:	8b 58 04             	mov    0x4(%eax),%ebx
801030b9:	85 db                	test   %ebx,%ebx
801030bb:	0f 84 4f 01 00 00    	je     80103210 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030c1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030c7:	83 ec 04             	sub    $0x4,%esp
801030ca:	6a 04                	push   $0x4
801030cc:	68 75 75 10 80       	push   $0x80107575
801030d1:	56                   	push   %esi
801030d2:	e8 49 15 00 00       	call   80104620 <memcmp>
801030d7:	83 c4 10             	add    $0x10,%esp
801030da:	85 c0                	test   %eax,%eax
801030dc:	0f 85 2e 01 00 00    	jne    80103210 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030e2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030e9:	3c 01                	cmp    $0x1,%al
801030eb:	0f 95 c2             	setne  %dl
801030ee:	3c 04                	cmp    $0x4,%al
801030f0:	0f 95 c0             	setne  %al
801030f3:	20 c2                	and    %al,%dl
801030f5:	0f 85 15 01 00 00    	jne    80103210 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030fb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103102:	66 85 ff             	test   %di,%di
80103105:	74 1a                	je     80103121 <mpinit+0xc1>
80103107:	89 f0                	mov    %esi,%eax
80103109:	01 f7                	add    %esi,%edi
  sum = 0;
8010310b:	31 d2                	xor    %edx,%edx
8010310d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103110:	0f b6 08             	movzbl (%eax),%ecx
80103113:	83 c0 01             	add    $0x1,%eax
80103116:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103118:	39 c7                	cmp    %eax,%edi
8010311a:	75 f4                	jne    80103110 <mpinit+0xb0>
8010311c:	84 d2                	test   %dl,%dl
8010311e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103121:	85 f6                	test   %esi,%esi
80103123:	0f 84 e7 00 00 00    	je     80103210 <mpinit+0x1b0>
80103129:	84 d2                	test   %dl,%dl
8010312b:	0f 85 df 00 00 00    	jne    80103210 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103131:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103137:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010313c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103143:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103149:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010314e:	01 d6                	add    %edx,%esi
80103150:	39 c6                	cmp    %eax,%esi
80103152:	76 23                	jbe    80103177 <mpinit+0x117>
    switch(*p){
80103154:	0f b6 10             	movzbl (%eax),%edx
80103157:	80 fa 04             	cmp    $0x4,%dl
8010315a:	0f 87 ca 00 00 00    	ja     8010322a <mpinit+0x1ca>
80103160:	ff 24 95 9c 75 10 80 	jmp    *-0x7fef8a64(,%edx,4)
80103167:	89 f6                	mov    %esi,%esi
80103169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103170:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103173:	39 c6                	cmp    %eax,%esi
80103175:	77 dd                	ja     80103154 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103177:	85 db                	test   %ebx,%ebx
80103179:	0f 84 9e 00 00 00    	je     8010321d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010317f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103182:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103186:	74 15                	je     8010319d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103188:	b8 70 00 00 00       	mov    $0x70,%eax
8010318d:	ba 22 00 00 00       	mov    $0x22,%edx
80103192:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103193:	ba 23 00 00 00       	mov    $0x23,%edx
80103198:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103199:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010319c:	ee                   	out    %al,(%dx)
  }
}
8010319d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031a0:	5b                   	pop    %ebx
801031a1:	5e                   	pop    %esi
801031a2:	5f                   	pop    %edi
801031a3:	5d                   	pop    %ebp
801031a4:	c3                   	ret    
801031a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031a8:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
801031ae:	83 f9 07             	cmp    $0x7,%ecx
801031b1:	7f 19                	jg     801031cc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031b3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031b7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031bd:	83 c1 01             	add    $0x1,%ecx
801031c0:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031c6:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801031cc:	83 c0 14             	add    $0x14,%eax
      continue;
801031cf:	e9 7c ff ff ff       	jmp    80103150 <mpinit+0xf0>
801031d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031dc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031df:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
801031e5:	e9 66 ff ff ff       	jmp    80103150 <mpinit+0xf0>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031f0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031f5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031fa:	e8 e1 fd ff ff       	call   80102fe0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ff:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103201:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103204:	0f 85 a9 fe ff ff    	jne    801030b3 <mpinit+0x53>
8010320a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103210:	83 ec 0c             	sub    $0xc,%esp
80103213:	68 5d 75 10 80       	push   $0x8010755d
80103218:	e8 73 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010321d:	83 ec 0c             	sub    $0xc,%esp
80103220:	68 7c 75 10 80       	push   $0x8010757c
80103225:	e8 66 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010322a:	31 db                	xor    %ebx,%ebx
8010322c:	e9 26 ff ff ff       	jmp    80103157 <mpinit+0xf7>
80103231:	66 90                	xchg   %ax,%ax
80103233:	66 90                	xchg   %ax,%ax
80103235:	66 90                	xchg   %ax,%ax
80103237:	66 90                	xchg   %ax,%ax
80103239:	66 90                	xchg   %ax,%ax
8010323b:	66 90                	xchg   %ax,%ax
8010323d:	66 90                	xchg   %ax,%ax
8010323f:	90                   	nop

80103240 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103240:	55                   	push   %ebp
80103241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103246:	ba 21 00 00 00       	mov    $0x21,%edx
8010324b:	89 e5                	mov    %esp,%ebp
8010324d:	ee                   	out    %al,(%dx)
8010324e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103253:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103254:	5d                   	pop    %ebp
80103255:	c3                   	ret    
80103256:	66 90                	xchg   %ax,%ax
80103258:	66 90                	xchg   %ax,%ax
8010325a:	66 90                	xchg   %ax,%ax
8010325c:	66 90                	xchg   %ax,%ax
8010325e:	66 90                	xchg   %ax,%ax

80103260 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	57                   	push   %edi
80103264:	56                   	push   %esi
80103265:	53                   	push   %ebx
80103266:	83 ec 0c             	sub    $0xc,%esp
80103269:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010326c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010326f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103275:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010327b:	e8 10 db ff ff       	call   80100d90 <filealloc>
80103280:	85 c0                	test   %eax,%eax
80103282:	89 03                	mov    %eax,(%ebx)
80103284:	74 22                	je     801032a8 <pipealloc+0x48>
80103286:	e8 05 db ff ff       	call   80100d90 <filealloc>
8010328b:	85 c0                	test   %eax,%eax
8010328d:	89 06                	mov    %eax,(%esi)
8010328f:	74 3f                	je     801032d0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103291:	e8 4a f2 ff ff       	call   801024e0 <kalloc>
80103296:	85 c0                	test   %eax,%eax
80103298:	89 c7                	mov    %eax,%edi
8010329a:	75 54                	jne    801032f0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010329c:	8b 03                	mov    (%ebx),%eax
8010329e:	85 c0                	test   %eax,%eax
801032a0:	75 34                	jne    801032d6 <pipealloc+0x76>
801032a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032a8:	8b 06                	mov    (%esi),%eax
801032aa:	85 c0                	test   %eax,%eax
801032ac:	74 0c                	je     801032ba <pipealloc+0x5a>
    fileclose(*f1);
801032ae:	83 ec 0c             	sub    $0xc,%esp
801032b1:	50                   	push   %eax
801032b2:	e8 99 db ff ff       	call   80100e50 <fileclose>
801032b7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032c2:	5b                   	pop    %ebx
801032c3:	5e                   	pop    %esi
801032c4:	5f                   	pop    %edi
801032c5:	5d                   	pop    %ebp
801032c6:	c3                   	ret    
801032c7:	89 f6                	mov    %esi,%esi
801032c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032d0:	8b 03                	mov    (%ebx),%eax
801032d2:	85 c0                	test   %eax,%eax
801032d4:	74 e4                	je     801032ba <pipealloc+0x5a>
    fileclose(*f0);
801032d6:	83 ec 0c             	sub    $0xc,%esp
801032d9:	50                   	push   %eax
801032da:	e8 71 db ff ff       	call   80100e50 <fileclose>
  if(*f1)
801032df:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032e1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032e4:	85 c0                	test   %eax,%eax
801032e6:	75 c6                	jne    801032ae <pipealloc+0x4e>
801032e8:	eb d0                	jmp    801032ba <pipealloc+0x5a>
801032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032f0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032f3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032fa:	00 00 00 
  p->writeopen = 1;
801032fd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103304:	00 00 00 
  p->nwrite = 0;
80103307:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010330e:	00 00 00 
  p->nread = 0;
80103311:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103318:	00 00 00 
  initlock(&p->lock, "pipe");
8010331b:	68 b0 75 10 80       	push   $0x801075b0
80103320:	50                   	push   %eax
80103321:	e8 3a 10 00 00       	call   80104360 <initlock>
  (*f0)->type = FD_PIPE;
80103326:	8b 03                	mov    (%ebx),%eax
  return 0;
80103328:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010332b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103331:	8b 03                	mov    (%ebx),%eax
80103333:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103337:	8b 03                	mov    (%ebx),%eax
80103339:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010333d:	8b 03                	mov    (%ebx),%eax
8010333f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103342:	8b 06                	mov    (%esi),%eax
80103344:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010334a:	8b 06                	mov    (%esi),%eax
8010334c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103350:	8b 06                	mov    (%esi),%eax
80103352:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103356:	8b 06                	mov    (%esi),%eax
80103358:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010335b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010335e:	31 c0                	xor    %eax,%eax
}
80103360:	5b                   	pop    %ebx
80103361:	5e                   	pop    %esi
80103362:	5f                   	pop    %edi
80103363:	5d                   	pop    %ebp
80103364:	c3                   	ret    
80103365:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103370 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	56                   	push   %esi
80103374:	53                   	push   %ebx
80103375:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103378:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010337b:	83 ec 0c             	sub    $0xc,%esp
8010337e:	53                   	push   %ebx
8010337f:	e8 cc 10 00 00       	call   80104450 <acquire>
  if(writable){
80103384:	83 c4 10             	add    $0x10,%esp
80103387:	85 f6                	test   %esi,%esi
80103389:	74 45                	je     801033d0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010338b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103391:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103394:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010339b:	00 00 00 
    wakeup(&p->nread);
8010339e:	50                   	push   %eax
8010339f:	e8 2c 0d 00 00       	call   801040d0 <wakeup>
801033a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033ad:	85 d2                	test   %edx,%edx
801033af:	75 0a                	jne    801033bb <pipeclose+0x4b>
801033b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033b7:	85 c0                	test   %eax,%eax
801033b9:	74 35                	je     801033f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033c1:	5b                   	pop    %ebx
801033c2:	5e                   	pop    %esi
801033c3:	5d                   	pop    %ebp
    release(&p->lock);
801033c4:	e9 a7 11 00 00       	jmp    80104570 <release>
801033c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033d0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033d6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033e0:	00 00 00 
    wakeup(&p->nwrite);
801033e3:	50                   	push   %eax
801033e4:	e8 e7 0c 00 00       	call   801040d0 <wakeup>
801033e9:	83 c4 10             	add    $0x10,%esp
801033ec:	eb b9                	jmp    801033a7 <pipeclose+0x37>
801033ee:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033f0:	83 ec 0c             	sub    $0xc,%esp
801033f3:	53                   	push   %ebx
801033f4:	e8 77 11 00 00       	call   80104570 <release>
    kfree((char*)p);
801033f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033fc:	83 c4 10             	add    $0x10,%esp
}
801033ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103402:	5b                   	pop    %ebx
80103403:	5e                   	pop    %esi
80103404:	5d                   	pop    %ebp
    kfree((char*)p);
80103405:	e9 26 ef ff ff       	jmp    80102330 <kfree>
8010340a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103410 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 28             	sub    $0x28,%esp
80103419:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010341c:	53                   	push   %ebx
8010341d:	e8 2e 10 00 00       	call   80104450 <acquire>
  for(i = 0; i < n; i++){
80103422:	8b 45 10             	mov    0x10(%ebp),%eax
80103425:	83 c4 10             	add    $0x10,%esp
80103428:	85 c0                	test   %eax,%eax
8010342a:	0f 8e c9 00 00 00    	jle    801034f9 <pipewrite+0xe9>
80103430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103433:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103439:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010343f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103442:	03 4d 10             	add    0x10(%ebp),%ecx
80103445:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103448:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010344e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103454:	39 d0                	cmp    %edx,%eax
80103456:	75 71                	jne    801034c9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103458:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010345e:	85 c0                	test   %eax,%eax
80103460:	74 4e                	je     801034b0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103462:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103468:	eb 3a                	jmp    801034a4 <pipewrite+0x94>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103470:	83 ec 0c             	sub    $0xc,%esp
80103473:	57                   	push   %edi
80103474:	e8 57 0c 00 00       	call   801040d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103479:	5a                   	pop    %edx
8010347a:	59                   	pop    %ecx
8010347b:	53                   	push   %ebx
8010347c:	56                   	push   %esi
8010347d:	e8 8e 0a 00 00       	call   80103f10 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103482:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103488:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010348e:	83 c4 10             	add    $0x10,%esp
80103491:	05 00 02 00 00       	add    $0x200,%eax
80103496:	39 c2                	cmp    %eax,%edx
80103498:	75 36                	jne    801034d0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010349a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034a0:	85 c0                	test   %eax,%eax
801034a2:	74 0c                	je     801034b0 <pipewrite+0xa0>
801034a4:	e8 67 03 00 00       	call   80103810 <myproc>
801034a9:	8b 40 24             	mov    0x24(%eax),%eax
801034ac:	85 c0                	test   %eax,%eax
801034ae:	74 c0                	je     80103470 <pipewrite+0x60>
        release(&p->lock);
801034b0:	83 ec 0c             	sub    $0xc,%esp
801034b3:	53                   	push   %ebx
801034b4:	e8 b7 10 00 00       	call   80104570 <release>
        return -1;
801034b9:	83 c4 10             	add    $0x10,%esp
801034bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c4:	5b                   	pop    %ebx
801034c5:	5e                   	pop    %esi
801034c6:	5f                   	pop    %edi
801034c7:	5d                   	pop    %ebp
801034c8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034c9:	89 c2                	mov    %eax,%edx
801034cb:	90                   	nop
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034d0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034d3:	8d 42 01             	lea    0x1(%edx),%eax
801034d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034dc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034e2:	83 c6 01             	add    $0x1,%esi
801034e5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034e9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034ec:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034ef:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034f3:	0f 85 4f ff ff ff    	jne    80103448 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034f9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034ff:	83 ec 0c             	sub    $0xc,%esp
80103502:	50                   	push   %eax
80103503:	e8 c8 0b 00 00       	call   801040d0 <wakeup>
  release(&p->lock);
80103508:	89 1c 24             	mov    %ebx,(%esp)
8010350b:	e8 60 10 00 00       	call   80104570 <release>
  return n;
80103510:	83 c4 10             	add    $0x10,%esp
80103513:	8b 45 10             	mov    0x10(%ebp),%eax
80103516:	eb a9                	jmp    801034c1 <pipewrite+0xb1>
80103518:	90                   	nop
80103519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103520 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	57                   	push   %edi
80103524:	56                   	push   %esi
80103525:	53                   	push   %ebx
80103526:	83 ec 18             	sub    $0x18,%esp
80103529:	8b 75 08             	mov    0x8(%ebp),%esi
8010352c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010352f:	56                   	push   %esi
80103530:	e8 1b 0f 00 00       	call   80104450 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103535:	83 c4 10             	add    $0x10,%esp
80103538:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010353e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103544:	75 6a                	jne    801035b0 <piperead+0x90>
80103546:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010354c:	85 db                	test   %ebx,%ebx
8010354e:	0f 84 c4 00 00 00    	je     80103618 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103554:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010355a:	eb 2d                	jmp    80103589 <piperead+0x69>
8010355c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103560:	83 ec 08             	sub    $0x8,%esp
80103563:	56                   	push   %esi
80103564:	53                   	push   %ebx
80103565:	e8 a6 09 00 00       	call   80103f10 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010356a:	83 c4 10             	add    $0x10,%esp
8010356d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103573:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103579:	75 35                	jne    801035b0 <piperead+0x90>
8010357b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103581:	85 d2                	test   %edx,%edx
80103583:	0f 84 8f 00 00 00    	je     80103618 <piperead+0xf8>
    if(myproc()->killed){
80103589:	e8 82 02 00 00       	call   80103810 <myproc>
8010358e:	8b 48 24             	mov    0x24(%eax),%ecx
80103591:	85 c9                	test   %ecx,%ecx
80103593:	74 cb                	je     80103560 <piperead+0x40>
      release(&p->lock);
80103595:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103598:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010359d:	56                   	push   %esi
8010359e:	e8 cd 0f 00 00       	call   80104570 <release>
      return -1;
801035a3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035a9:	89 d8                	mov    %ebx,%eax
801035ab:	5b                   	pop    %ebx
801035ac:	5e                   	pop    %esi
801035ad:	5f                   	pop    %edi
801035ae:	5d                   	pop    %ebp
801035af:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035b0:	8b 45 10             	mov    0x10(%ebp),%eax
801035b3:	85 c0                	test   %eax,%eax
801035b5:	7e 61                	jle    80103618 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035b7:	31 db                	xor    %ebx,%ebx
801035b9:	eb 13                	jmp    801035ce <piperead+0xae>
801035bb:	90                   	nop
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035c6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035cc:	74 1f                	je     801035ed <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ce:	8d 41 01             	lea    0x1(%ecx),%eax
801035d1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035d7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035dd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035e2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035e5:	83 c3 01             	add    $0x1,%ebx
801035e8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035eb:	75 d3                	jne    801035c0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035ed:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035f3:	83 ec 0c             	sub    $0xc,%esp
801035f6:	50                   	push   %eax
801035f7:	e8 d4 0a 00 00       	call   801040d0 <wakeup>
  release(&p->lock);
801035fc:	89 34 24             	mov    %esi,(%esp)
801035ff:	e8 6c 0f 00 00       	call   80104570 <release>
  return i;
80103604:	83 c4 10             	add    $0x10,%esp
}
80103607:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010360a:	89 d8                	mov    %ebx,%eax
8010360c:	5b                   	pop    %ebx
8010360d:	5e                   	pop    %esi
8010360e:	5f                   	pop    %edi
8010360f:	5d                   	pop    %ebp
80103610:	c3                   	ret    
80103611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103618:	31 db                	xor    %ebx,%ebx
8010361a:	eb d1                	jmp    801035ed <piperead+0xcd>
8010361c:	66 90                	xchg   %ax,%ax
8010361e:	66 90                	xchg   %ax,%ax

80103620 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103624:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103629:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010362c:	68 20 2d 11 80       	push   $0x80112d20
80103631:	e8 1a 0e 00 00       	call   80104450 <acquire>
80103636:	83 c4 10             	add    $0x10,%esp
80103639:	eb 17                	jmp    80103652 <allocproc+0x32>
8010363b:	90                   	nop
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103640:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103646:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
8010364c:	0f 83 7e 00 00 00    	jae    801036d0 <allocproc+0xb0>
    if(p->state == UNUSED)
80103652:	8b 43 0c             	mov    0xc(%ebx),%eax
80103655:	85 c0                	test   %eax,%eax
80103657:	75 e7                	jne    80103640 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103659:	a1 04 a0 10 80       	mov    0x8010a004,%eax


  release(&ptable.lock);
8010365e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103661:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103668:	8d 50 01             	lea    0x1(%eax),%edx
8010366b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010366e:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103673:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103679:	e8 f2 0e 00 00       	call   80104570 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010367e:	e8 5d ee ff ff       	call   801024e0 <kalloc>
80103683:	83 c4 10             	add    $0x10,%esp
80103686:	85 c0                	test   %eax,%eax
80103688:	89 43 08             	mov    %eax,0x8(%ebx)
8010368b:	74 5c                	je     801036e9 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010368d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103693:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103696:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010369b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010369e:	c7 40 14 db 57 10 80 	movl   $0x801057db,0x14(%eax)
  p->context = (struct context*)sp;
801036a5:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036a8:	6a 14                	push   $0x14
801036aa:	6a 00                	push   $0x0
801036ac:	50                   	push   %eax
801036ad:	e8 1e 0f 00 00       	call   801045d0 <memset>
  p->context->eip = (uint)forkret;
801036b2:	8b 43 1c             	mov    0x1c(%ebx),%eax

  //brand new
  p->priority=NPROCQ-1;

  return p;
801036b5:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036b8:	c7 40 10 00 37 10 80 	movl   $0x80103700,0x10(%eax)
  p->priority=NPROCQ-1;
801036bf:	c7 83 80 00 00 00 02 	movl   $0x2,0x80(%ebx)
801036c6:	00 00 00 
}
801036c9:	89 d8                	mov    %ebx,%eax
801036cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036ce:	c9                   	leave  
801036cf:	c3                   	ret    
  release(&ptable.lock);
801036d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801036d3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801036d5:	68 20 2d 11 80       	push   $0x80112d20
801036da:	e8 91 0e 00 00       	call   80104570 <release>
}
801036df:	89 d8                	mov    %ebx,%eax
  return 0;
801036e1:	83 c4 10             	add    $0x10,%esp
}
801036e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036e7:	c9                   	leave  
801036e8:	c3                   	ret    
    p->state = UNUSED;
801036e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801036f0:	31 db                	xor    %ebx,%ebx
801036f2:	eb d5                	jmp    801036c9 <allocproc+0xa9>
801036f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103700 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103706:	68 20 2d 11 80       	push   $0x80112d20
8010370b:	e8 60 0e 00 00       	call   80104570 <release>

  if (first) {
80103710:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	85 c0                	test   %eax,%eax
8010371a:	75 04                	jne    80103720 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010371c:	c9                   	leave  
8010371d:	c3                   	ret    
8010371e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103720:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103723:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010372a:	00 00 00 
    iinit(ROOTDEV);
8010372d:	6a 01                	push   $0x1
8010372f:	e8 6c dd ff ff       	call   801014a0 <iinit>
    initlog(ROOTDEV);
80103734:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010373b:	e8 e0 f3 ff ff       	call   80102b20 <initlog>
80103740:	83 c4 10             	add    $0x10,%esp
}
80103743:	c9                   	leave  
80103744:	c3                   	ret    
80103745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103750 <pinit>:
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103756:	68 b5 75 10 80       	push   $0x801075b5
8010375b:	68 20 2d 11 80       	push   $0x80112d20
80103760:	e8 fb 0b 00 00       	call   80104360 <initlock>
}
80103765:	83 c4 10             	add    $0x10,%esp
80103768:	c9                   	leave  
80103769:	c3                   	ret    
8010376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103770 <mycpu>:
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	56                   	push   %esi
80103774:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103775:	9c                   	pushf  
80103776:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103777:	f6 c4 02             	test   $0x2,%ah
8010377a:	75 5e                	jne    801037da <mycpu+0x6a>
  apicid = lapicid();
8010377c:	e8 cf ef ff ff       	call   80102750 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103781:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103787:	85 f6                	test   %esi,%esi
80103789:	7e 42                	jle    801037cd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010378b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103792:	39 d0                	cmp    %edx,%eax
80103794:	74 30                	je     801037c6 <mycpu+0x56>
80103796:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010379b:	31 d2                	xor    %edx,%edx
8010379d:	8d 76 00             	lea    0x0(%esi),%esi
801037a0:	83 c2 01             	add    $0x1,%edx
801037a3:	39 f2                	cmp    %esi,%edx
801037a5:	74 26                	je     801037cd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037a7:	0f b6 19             	movzbl (%ecx),%ebx
801037aa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037b0:	39 c3                	cmp    %eax,%ebx
801037b2:	75 ec                	jne    801037a0 <mycpu+0x30>
801037b4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037ba:	05 80 27 11 80       	add    $0x80112780,%eax
}
801037bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037c2:	5b                   	pop    %ebx
801037c3:	5e                   	pop    %esi
801037c4:	5d                   	pop    %ebp
801037c5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801037c6:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
801037cb:	eb f2                	jmp    801037bf <mycpu+0x4f>
  panic("unknown apicid\n");
801037cd:	83 ec 0c             	sub    $0xc,%esp
801037d0:	68 bc 75 10 80       	push   $0x801075bc
801037d5:	e8 b6 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801037da:	83 ec 0c             	sub    $0xc,%esp
801037dd:	68 98 76 10 80       	push   $0x80107698
801037e2:	e8 a9 cb ff ff       	call   80100390 <panic>
801037e7:	89 f6                	mov    %esi,%esi
801037e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037f0 <cpuid>:
cpuid() {
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037f6:	e8 75 ff ff ff       	call   80103770 <mycpu>
801037fb:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103800:	c9                   	leave  
  return mycpu()-cpus;
80103801:	c1 f8 04             	sar    $0x4,%eax
80103804:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010380a:	c3                   	ret    
8010380b:	90                   	nop
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103810 <myproc>:
myproc(void) {
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
80103814:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103817:	e8 f4 0b 00 00       	call   80104410 <pushcli>
  c = mycpu();
8010381c:	e8 4f ff ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103821:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103827:	e8 e4 0c 00 00       	call   80104510 <popcli>
}
8010382c:	83 c4 04             	add    $0x4,%esp
8010382f:	89 d8                	mov    %ebx,%eax
80103831:	5b                   	pop    %ebx
80103832:	5d                   	pop    %ebp
80103833:	c3                   	ret    
80103834:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010383a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103840 <qpush>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	53                   	push   %ebx
80103844:	8b 45 08             	mov    0x8(%ebp),%eax
  if(ptable.count[np->priority]<=0)
80103847:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
8010384d:	8b 0c 95 6c 4f 11 80 	mov    -0x7feeb094(,%edx,4),%ecx
80103854:	85 c9                	test   %ecx,%ecx
80103856:	74 50                	je     801038a8 <qpush+0x68>
    np->next=ptable.pqueue[np->priority].head;
80103858:	81 c2 46 04 00 00    	add    $0x446,%edx
8010385e:	8b 0c d5 24 2d 11 80 	mov    -0x7feed2dc(,%edx,8),%ecx
80103865:	89 48 7c             	mov    %ecx,0x7c(%eax)
    ptable.pqueue[np->priority].last->next=np;
80103868:	8b 14 d5 28 2d 11 80 	mov    -0x7feed2d8(,%edx,8),%edx
8010386f:	89 42 7c             	mov    %eax,0x7c(%edx)
    ptable.pqueue[np->priority].last=np;
80103872:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103878:	89 04 d5 58 4f 11 80 	mov    %eax,-0x7feeb0a8(,%edx,8)
  np->timepiece=(1<<(NPROCQ-np->priority-1));
8010387f:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103885:	b9 02 00 00 00       	mov    $0x2,%ecx
8010388a:	bb 01 00 00 00       	mov    $0x1,%ebx
8010388f:	29 d1                	sub    %edx,%ecx
80103891:	d3 e3                	shl    %cl,%ebx
80103893:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
  ptable.count[np->priority]++;
80103899:	83 04 95 6c 4f 11 80 	addl   $0x1,-0x7feeb094(,%edx,4)
801038a0:	01 
}
801038a1:	5b                   	pop    %ebx
801038a2:	5d                   	pop    %ebp
801038a3:	c3                   	ret    
801038a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->next=np;
801038a8:	89 40 7c             	mov    %eax,0x7c(%eax)
    ptable.pqueue[np->priority].head=np;
801038ab:	89 04 d5 54 4f 11 80 	mov    %eax,-0x7feeb0ac(,%edx,8)
    ptable.pqueue[np->priority].last=np;
801038b2:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801038b8:	89 04 d5 58 4f 11 80 	mov    %eax,-0x7feeb0a8(,%edx,8)
801038bf:	eb be                	jmp    8010387f <qpush+0x3f>
801038c1:	eb 0d                	jmp    801038d0 <wakeup1>
801038c3:	90                   	nop
801038c4:	90                   	nop
801038c5:	90                   	nop
801038c6:	90                   	nop
801038c7:	90                   	nop
801038c8:	90                   	nop
801038c9:	90                   	nop
801038ca:	90                   	nop
801038cb:	90                   	nop
801038cc:	90                   	nop
801038cd:	90                   	nop
801038ce:	90                   	nop
801038cf:	90                   	nop

801038d0 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	56                   	push   %esi
801038d4:	89 c6                	mov    %eax,%esi
801038d6:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038d7:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801038dc:	eb 10                	jmp    801038ee <wakeup1+0x1e>
801038de:	66 90                	xchg   %ax,%ax
801038e0:	81 c3 88 00 00 00    	add    $0x88,%ebx
801038e6:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801038ec:	73 3b                	jae    80103929 <wakeup1+0x59>
    if(p->state == SLEEPING && p->chan == chan)
801038ee:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801038f2:	75 ec                	jne    801038e0 <wakeup1+0x10>
801038f4:	39 73 20             	cmp    %esi,0x20(%ebx)
801038f7:	75 e7                	jne    801038e0 <wakeup1+0x10>
    {
      p->state = RUNNABLE;

      //brand new
      if(p->priority<NPROCQ-1)
801038f9:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
      p->state = RUNNABLE;
801038ff:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      if(p->priority<NPROCQ-1)
80103906:	83 f8 01             	cmp    $0x1,%eax
80103909:	77 09                	ja     80103914 <wakeup1+0x44>
        p->priority++;
8010390b:	83 c0 01             	add    $0x1,%eax
8010390e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
      qpush(p);
80103914:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103915:	81 c3 88 00 00 00    	add    $0x88,%ebx
      qpush(p);
8010391b:	e8 20 ff ff ff       	call   80103840 <qpush>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103920:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
      qpush(p);
80103926:	58                   	pop    %eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103927:	72 c5                	jb     801038ee <wakeup1+0x1e>

    }
}
80103929:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010392c:	5b                   	pop    %ebx
8010392d:	5e                   	pop    %esi
8010392e:	5d                   	pop    %ebp
8010392f:	c3                   	ret    

80103930 <userinit>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	53                   	push   %ebx
80103934:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103937:	e8 e4 fc ff ff       	call   80103620 <allocproc>
8010393c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010393e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103943:	e8 78 34 00 00       	call   80106dc0 <setupkvm>
80103948:	85 c0                	test   %eax,%eax
8010394a:	89 43 04             	mov    %eax,0x4(%ebx)
8010394d:	0f 84 c5 00 00 00    	je     80103a18 <userinit+0xe8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103953:	83 ec 04             	sub    $0x4,%esp
80103956:	68 2c 00 00 00       	push   $0x2c
8010395b:	68 60 a4 10 80       	push   $0x8010a460
80103960:	50                   	push   %eax
80103961:	e8 3a 31 00 00       	call   80106aa0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103966:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103969:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010396f:	6a 4c                	push   $0x4c
80103971:	6a 00                	push   $0x0
80103973:	ff 73 18             	pushl  0x18(%ebx)
80103976:	e8 55 0c 00 00       	call   801045d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010397b:	8b 43 18             	mov    0x18(%ebx),%eax
8010397e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103983:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103988:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010398b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010398f:	8b 43 18             	mov    0x18(%ebx),%eax
80103992:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103996:	8b 43 18             	mov    0x18(%ebx),%eax
80103999:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010399d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039a1:	8b 43 18             	mov    0x18(%ebx),%eax
801039a4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039a8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039ac:	8b 43 18             	mov    0x18(%ebx),%eax
801039af:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039b6:	8b 43 18             	mov    0x18(%ebx),%eax
801039b9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039c0:	8b 43 18             	mov    0x18(%ebx),%eax
801039c3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039ca:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039cd:	6a 10                	push   $0x10
801039cf:	68 e5 75 10 80       	push   $0x801075e5
801039d4:	50                   	push   %eax
801039d5:	e8 d6 0d 00 00       	call   801047b0 <safestrcpy>
  p->cwd = namei("/");
801039da:	c7 04 24 ee 75 10 80 	movl   $0x801075ee,(%esp)
801039e1:	e8 1a e5 ff ff       	call   80101f00 <namei>
801039e6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801039e9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039f0:	e8 5b 0a 00 00       	call   80104450 <acquire>
  p->state = RUNNABLE;
801039f5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  qpush(p);
801039fc:	89 1c 24             	mov    %ebx,(%esp)
801039ff:	e8 3c fe ff ff       	call   80103840 <qpush>
  release(&ptable.lock);
80103a04:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a0b:	e8 60 0b 00 00       	call   80104570 <release>
}
80103a10:	83 c4 10             	add    $0x10,%esp
80103a13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a16:	c9                   	leave  
80103a17:	c3                   	ret    
    panic("userinit: out of memory?");
80103a18:	83 ec 0c             	sub    $0xc,%esp
80103a1b:	68 cc 75 10 80       	push   $0x801075cc
80103a20:	e8 6b c9 ff ff       	call   80100390 <panic>
80103a25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a30 <growproc>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
80103a35:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a38:	e8 d3 09 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103a3d:	e8 2e fd ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103a42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a48:	e8 c3 0a 00 00       	call   80104510 <popcli>
  if(n > 0){
80103a4d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103a50:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a52:	7f 1c                	jg     80103a70 <growproc+0x40>
  } else if(n < 0){
80103a54:	75 3a                	jne    80103a90 <growproc+0x60>
  switchuvm(curproc);
80103a56:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a59:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a5b:	53                   	push   %ebx
80103a5c:	e8 2f 2f 00 00       	call   80106990 <switchuvm>
  return 0;
80103a61:	83 c4 10             	add    $0x10,%esp
80103a64:	31 c0                	xor    %eax,%eax
}
80103a66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a69:	5b                   	pop    %ebx
80103a6a:	5e                   	pop    %esi
80103a6b:	5d                   	pop    %ebp
80103a6c:	c3                   	ret    
80103a6d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a70:	83 ec 04             	sub    $0x4,%esp
80103a73:	01 c6                	add    %eax,%esi
80103a75:	56                   	push   %esi
80103a76:	50                   	push   %eax
80103a77:	ff 73 04             	pushl  0x4(%ebx)
80103a7a:	e8 61 31 00 00       	call   80106be0 <allocuvm>
80103a7f:	83 c4 10             	add    $0x10,%esp
80103a82:	85 c0                	test   %eax,%eax
80103a84:	75 d0                	jne    80103a56 <growproc+0x26>
      return -1;
80103a86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a8b:	eb d9                	jmp    80103a66 <growproc+0x36>
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a90:	83 ec 04             	sub    $0x4,%esp
80103a93:	01 c6                	add    %eax,%esi
80103a95:	56                   	push   %esi
80103a96:	50                   	push   %eax
80103a97:	ff 73 04             	pushl  0x4(%ebx)
80103a9a:	e8 71 32 00 00       	call   80106d10 <deallocuvm>
80103a9f:	83 c4 10             	add    $0x10,%esp
80103aa2:	85 c0                	test   %eax,%eax
80103aa4:	75 b0                	jne    80103a56 <growproc+0x26>
80103aa6:	eb de                	jmp    80103a86 <growproc+0x56>
80103aa8:	90                   	nop
80103aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ab0 <fork>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	57                   	push   %edi
80103ab4:	56                   	push   %esi
80103ab5:	53                   	push   %ebx
80103ab6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ab9:	e8 52 09 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103abe:	e8 ad fc ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103ac3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac9:	e8 42 0a 00 00       	call   80104510 <popcli>
  if((np = allocproc()) == 0){
80103ace:	e8 4d fb ff ff       	call   80103620 <allocproc>
80103ad3:	85 c0                	test   %eax,%eax
80103ad5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ad8:	0f 84 bf 00 00 00    	je     80103b9d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ade:	83 ec 08             	sub    $0x8,%esp
80103ae1:	ff 33                	pushl  (%ebx)
80103ae3:	ff 73 04             	pushl  0x4(%ebx)
80103ae6:	89 c7                	mov    %eax,%edi
80103ae8:	e8 a3 33 00 00       	call   80106e90 <copyuvm>
80103aed:	83 c4 10             	add    $0x10,%esp
80103af0:	85 c0                	test   %eax,%eax
80103af2:	89 47 04             	mov    %eax,0x4(%edi)
80103af5:	0f 84 a9 00 00 00    	je     80103ba4 <fork+0xf4>
  np->sz = curproc->sz;
80103afb:	8b 03                	mov    (%ebx),%eax
80103afd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b00:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103b02:	89 59 14             	mov    %ebx,0x14(%ecx)
80103b05:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103b07:	8b 79 18             	mov    0x18(%ecx),%edi
80103b0a:	8b 73 18             	mov    0x18(%ebx),%esi
80103b0d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b14:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b16:	8b 40 18             	mov    0x18(%eax),%eax
80103b19:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b20:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b24:	85 c0                	test   %eax,%eax
80103b26:	74 13                	je     80103b3b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b28:	83 ec 0c             	sub    $0xc,%esp
80103b2b:	50                   	push   %eax
80103b2c:	e8 cf d2 ff ff       	call   80100e00 <filedup>
80103b31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b34:	83 c4 10             	add    $0x10,%esp
80103b37:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b3b:	83 c6 01             	add    $0x1,%esi
80103b3e:	83 fe 10             	cmp    $0x10,%esi
80103b41:	75 dd                	jne    80103b20 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b43:	83 ec 0c             	sub    $0xc,%esp
80103b46:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b49:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b4c:	e8 1f db ff ff       	call   80101670 <idup>
80103b51:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b54:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b57:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b5a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b5d:	6a 10                	push   $0x10
80103b5f:	53                   	push   %ebx
80103b60:	50                   	push   %eax
80103b61:	e8 4a 0c 00 00       	call   801047b0 <safestrcpy>
  pid = np->pid;
80103b66:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b69:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b70:	e8 db 08 00 00       	call   80104450 <acquire>
  np->state = RUNNABLE;
80103b75:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  qpush(np);
80103b7c:	89 3c 24             	mov    %edi,(%esp)
80103b7f:	e8 bc fc ff ff       	call   80103840 <qpush>
  release(&ptable.lock);
80103b84:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b8b:	e8 e0 09 00 00       	call   80104570 <release>
  return pid;
80103b90:	83 c4 10             	add    $0x10,%esp
}
80103b93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b96:	89 d8                	mov    %ebx,%eax
80103b98:	5b                   	pop    %ebx
80103b99:	5e                   	pop    %esi
80103b9a:	5f                   	pop    %edi
80103b9b:	5d                   	pop    %ebp
80103b9c:	c3                   	ret    
    return -1;
80103b9d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ba2:	eb ef                	jmp    80103b93 <fork+0xe3>
    kfree(np->kstack);
80103ba4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ba7:	83 ec 0c             	sub    $0xc,%esp
80103baa:	ff 73 08             	pushl  0x8(%ebx)
80103bad:	e8 7e e7 ff ff       	call   80102330 <kfree>
    np->kstack = 0;
80103bb2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103bb9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103bc0:	83 c4 10             	add    $0x10,%esp
80103bc3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bc8:	eb c9                	jmp    80103b93 <fork+0xe3>
80103bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bd0 <scheduler>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
80103bd6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103bd9:	e8 92 fb ff ff       	call   80103770 <mycpu>
  c->proc = 0;
80103bde:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103be5:	00 00 00 
  struct cpu *c = mycpu();
80103be8:	89 c6                	mov    %eax,%esi
80103bea:	8d 40 04             	lea    0x4(%eax),%eax
80103bed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103bf0:	fb                   	sti    
    acquire(&ptable.lock);
80103bf1:	83 ec 0c             	sub    $0xc,%esp
    int queue=NPROCQ-1;
80103bf4:	bf 02 00 00 00       	mov    $0x2,%edi
    acquire(&ptable.lock);
80103bf9:	68 20 2d 11 80       	push   $0x80112d20
80103bfe:	e8 4d 08 00 00       	call   80104450 <acquire>
80103c03:	ba 20 2d 11 80       	mov    $0x80112d20,%edx
80103c08:	83 c4 10             	add    $0x10,%esp
80103c0b:	89 d1                	mov    %edx,%ecx
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103c0d:	8b 82 54 22 00 00    	mov    0x2254(%edx),%eax
80103c13:	85 c0                	test   %eax,%eax
80103c15:	74 35                	je     80103c4c <scheduler+0x7c>
80103c17:	8b 99 44 22 00 00    	mov    0x2244(%ecx),%ebx
80103c1d:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c21:	75 13                	jne    80103c36 <scheduler+0x66>
80103c23:	e9 b8 00 00 00       	jmp    80103ce0 <scheduler+0x110>
80103c28:	90                   	nop
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c34:	74 3a                	je     80103c70 <scheduler+0xa0>
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103c36:	8b 5b 7c             	mov    0x7c(%ebx),%ebx
        ptable.count[queue]--;
80103c39:	83 e8 01             	sub    $0x1,%eax
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103c3c:	85 c0                	test   %eax,%eax
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103c3e:	89 99 44 22 00 00    	mov    %ebx,0x2244(%ecx)
        ptable.count[queue]--;
80103c44:	89 82 54 22 00 00    	mov    %eax,0x2254(%edx)
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103c4a:	75 e4                	jne    80103c30 <scheduler+0x60>
    for(;queue>=0;queue--)
80103c4c:	83 ef 01             	sub    $0x1,%edi
80103c4f:	83 ea 04             	sub    $0x4,%edx
80103c52:	83 e9 08             	sub    $0x8,%ecx
80103c55:	83 ff ff             	cmp    $0xffffffff,%edi
80103c58:	75 b3                	jne    80103c0d <scheduler+0x3d>
    release(&ptable.lock);
80103c5a:	83 ec 0c             	sub    $0xc,%esp
80103c5d:	68 20 2d 11 80       	push   $0x80112d20
80103c62:	e8 09 09 00 00       	call   80104570 <release>
  for(;;){
80103c67:	83 c4 10             	add    $0x10,%esp
80103c6a:	eb 84                	jmp    80103bf0 <scheduler+0x20>
80103c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c70:	8d 97 46 04 00 00    	lea    0x446(%edi),%edx
80103c76:	8b 1c d5 24 2d 11 80 	mov    -0x7feed2dc(,%edx,8),%ebx
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103c7d:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
        switchuvm(p);
80103c80:	83 ec 0c             	sub    $0xc,%esp
        ptable.count[queue]--;
80103c83:	83 e8 01             	sub    $0x1,%eax
80103c86:	89 04 bd 6c 4f 11 80 	mov    %eax,-0x7feeb094(,%edi,4)
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103c8d:	89 0c d5 24 2d 11 80 	mov    %ecx,-0x7feed2dc(,%edx,8)
        c->proc = p;
80103c94:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
        switchuvm(p);
80103c9a:	53                   	push   %ebx
80103c9b:	e8 f0 2c 00 00       	call   80106990 <switchuvm>
        p->state = RUNNING;
80103ca0:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        swtch(&(c->scheduler), p->context);
80103ca7:	58                   	pop    %eax
80103ca8:	5a                   	pop    %edx
80103ca9:	ff 73 1c             	pushl  0x1c(%ebx)
80103cac:	ff 75 e4             	pushl  -0x1c(%ebp)
80103caf:	e8 57 0b 00 00       	call   8010480b <swtch>
        switchkvm();
80103cb4:	e8 b7 2c 00 00       	call   80106970 <switchkvm>
        break;
80103cb9:	83 c4 10             	add    $0x10,%esp
        c->proc = 0;
80103cbc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cc3:	00 00 00 
    release(&ptable.lock);
80103cc6:	83 ec 0c             	sub    $0xc,%esp
80103cc9:	68 20 2d 11 80       	push   $0x80112d20
80103cce:	e8 9d 08 00 00       	call   80104570 <release>
  for(;;){
80103cd3:	83 c4 10             	add    $0x10,%esp
80103cd6:	e9 15 ff ff ff       	jmp    80103bf0 <scheduler+0x20>
80103cdb:	90                   	nop
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ce0:	8d 97 46 04 00 00    	lea    0x446(%edi),%edx
80103ce6:	eb 95                	jmp    80103c7d <scheduler+0xad>
80103ce8:	90                   	nop
80103ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cf0 <sched>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	56                   	push   %esi
80103cf4:	53                   	push   %ebx
  pushcli();
80103cf5:	e8 16 07 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103cfa:	e8 71 fa ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103cff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d05:	e8 06 08 00 00       	call   80104510 <popcli>
  if(!holding(&ptable.lock))
80103d0a:	83 ec 0c             	sub    $0xc,%esp
80103d0d:	68 20 2d 11 80       	push   $0x80112d20
80103d12:	e8 b9 06 00 00       	call   801043d0 <holding>
80103d17:	83 c4 10             	add    $0x10,%esp
80103d1a:	85 c0                	test   %eax,%eax
80103d1c:	74 4f                	je     80103d6d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d1e:	e8 4d fa ff ff       	call   80103770 <mycpu>
80103d23:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d2a:	75 68                	jne    80103d94 <sched+0xa4>
  if(p->state == RUNNING)
80103d2c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d30:	74 55                	je     80103d87 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d32:	9c                   	pushf  
80103d33:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d34:	f6 c4 02             	test   $0x2,%ah
80103d37:	75 41                	jne    80103d7a <sched+0x8a>
  intena = mycpu()->intena;
80103d39:	e8 32 fa ff ff       	call   80103770 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d3e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d41:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d47:	e8 24 fa ff ff       	call   80103770 <mycpu>
80103d4c:	83 ec 08             	sub    $0x8,%esp
80103d4f:	ff 70 04             	pushl  0x4(%eax)
80103d52:	53                   	push   %ebx
80103d53:	e8 b3 0a 00 00       	call   8010480b <swtch>
  mycpu()->intena = intena;
80103d58:	e8 13 fa ff ff       	call   80103770 <mycpu>
}
80103d5d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d60:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d69:	5b                   	pop    %ebx
80103d6a:	5e                   	pop    %esi
80103d6b:	5d                   	pop    %ebp
80103d6c:	c3                   	ret    
    panic("sched ptable.lock");
80103d6d:	83 ec 0c             	sub    $0xc,%esp
80103d70:	68 f0 75 10 80       	push   $0x801075f0
80103d75:	e8 16 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d7a:	83 ec 0c             	sub    $0xc,%esp
80103d7d:	68 1c 76 10 80       	push   $0x8010761c
80103d82:	e8 09 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d87:	83 ec 0c             	sub    $0xc,%esp
80103d8a:	68 0e 76 10 80       	push   $0x8010760e
80103d8f:	e8 fc c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d94:	83 ec 0c             	sub    $0xc,%esp
80103d97:	68 02 76 10 80       	push   $0x80107602
80103d9c:	e8 ef c5 ff ff       	call   80100390 <panic>
80103da1:	eb 0d                	jmp    80103db0 <exit>
80103da3:	90                   	nop
80103da4:	90                   	nop
80103da5:	90                   	nop
80103da6:	90                   	nop
80103da7:	90                   	nop
80103da8:	90                   	nop
80103da9:	90                   	nop
80103daa:	90                   	nop
80103dab:	90                   	nop
80103dac:	90                   	nop
80103dad:	90                   	nop
80103dae:	90                   	nop
80103daf:	90                   	nop

80103db0 <exit>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103db9:	e8 52 06 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103dbe:	e8 ad f9 ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103dc3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103dc9:	e8 42 07 00 00       	call   80104510 <popcli>
  if(curproc == initproc)
80103dce:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103dd4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103dd7:	8d 7e 68             	lea    0x68(%esi),%edi
80103dda:	0f 84 b1 00 00 00    	je     80103e91 <exit+0xe1>
    if(curproc->ofile[fd]){
80103de0:	8b 03                	mov    (%ebx),%eax
80103de2:	85 c0                	test   %eax,%eax
80103de4:	74 12                	je     80103df8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103de6:	83 ec 0c             	sub    $0xc,%esp
80103de9:	50                   	push   %eax
80103dea:	e8 61 d0 ff ff       	call   80100e50 <fileclose>
      curproc->ofile[fd] = 0;
80103def:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103df5:	83 c4 10             	add    $0x10,%esp
80103df8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103dfb:	39 df                	cmp    %ebx,%edi
80103dfd:	75 e1                	jne    80103de0 <exit+0x30>
  begin_op();
80103dff:	e8 bc ed ff ff       	call   80102bc0 <begin_op>
  iput(curproc->cwd);
80103e04:	83 ec 0c             	sub    $0xc,%esp
80103e07:	ff 76 68             	pushl  0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e0a:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  iput(curproc->cwd);
80103e0f:	e8 bc d9 ff ff       	call   801017d0 <iput>
  end_op();
80103e14:	e8 17 ee ff ff       	call   80102c30 <end_op>
  curproc->cwd = 0;
80103e19:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e20:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e27:	e8 24 06 00 00       	call   80104450 <acquire>
  wakeup1(curproc->parent);
80103e2c:	8b 46 14             	mov    0x14(%esi),%eax
80103e2f:	e8 9c fa ff ff       	call   801038d0 <wakeup1>
80103e34:	83 c4 10             	add    $0x10,%esp
80103e37:	eb 15                	jmp    80103e4e <exit+0x9e>
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e40:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103e46:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103e4c:	73 2a                	jae    80103e78 <exit+0xc8>
    if(p->parent == curproc){
80103e4e:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e51:	75 ed                	jne    80103e40 <exit+0x90>
      if(p->state == ZOMBIE)
80103e53:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
80103e57:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103e5c:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103e5f:	75 df                	jne    80103e40 <exit+0x90>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e61:	81 c3 88 00 00 00    	add    $0x88,%ebx
        wakeup1(initproc);
80103e67:	e8 64 fa ff ff       	call   801038d0 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e6c:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103e72:	72 da                	jb     80103e4e <exit+0x9e>
80103e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
80103e78:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e7f:	e8 6c fe ff ff       	call   80103cf0 <sched>
  panic("zombie exit");
80103e84:	83 ec 0c             	sub    $0xc,%esp
80103e87:	68 3d 76 10 80       	push   $0x8010763d
80103e8c:	e8 ff c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e91:	83 ec 0c             	sub    $0xc,%esp
80103e94:	68 30 76 10 80       	push   $0x80107630
80103e99:	e8 f2 c4 ff ff       	call   80100390 <panic>
80103e9e:	66 90                	xchg   %ax,%ax

80103ea0 <yield>:
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	53                   	push   %ebx
80103ea4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ea7:	e8 64 05 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103eac:	e8 bf f8 ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103eb1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103eb7:	e8 54 06 00 00       	call   80104510 <popcli>
  acquire(&ptable.lock);  //DOC: yieldlock
80103ebc:	83 ec 0c             	sub    $0xc,%esp
80103ebf:	68 20 2d 11 80       	push   $0x80112d20
80103ec4:	e8 87 05 00 00       	call   80104450 <acquire>
  if(p->priority>0)
80103ec9:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103ecf:	83 c4 10             	add    $0x10,%esp
  p->state = RUNNABLE;
80103ed2:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  if(p->priority>0)
80103ed9:	85 c0                	test   %eax,%eax
80103edb:	74 09                	je     80103ee6 <yield+0x46>
    p->priority--;
80103edd:	83 e8 01             	sub    $0x1,%eax
80103ee0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  qpush(p);
80103ee6:	83 ec 0c             	sub    $0xc,%esp
80103ee9:	53                   	push   %ebx
80103eea:	e8 51 f9 ff ff       	call   80103840 <qpush>
  sched();
80103eef:	e8 fc fd ff ff       	call   80103cf0 <sched>
  release(&ptable.lock);
80103ef4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103efb:	e8 70 06 00 00       	call   80104570 <release>
}
80103f00:	83 c4 10             	add    $0x10,%esp
80103f03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f06:	c9                   	leave  
80103f07:	c3                   	ret    
80103f08:	90                   	nop
80103f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f10 <sleep>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	57                   	push   %edi
80103f14:	56                   	push   %esi
80103f15:	53                   	push   %ebx
80103f16:	83 ec 0c             	sub    $0xc,%esp
80103f19:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103f1f:	e8 ec 04 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103f24:	e8 47 f8 ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103f29:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f2f:	e8 dc 05 00 00       	call   80104510 <popcli>
  if(p == 0)
80103f34:	85 db                	test   %ebx,%ebx
80103f36:	0f 84 87 00 00 00    	je     80103fc3 <sleep+0xb3>
  if(lk == 0)
80103f3c:	85 f6                	test   %esi,%esi
80103f3e:	74 76                	je     80103fb6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f40:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f46:	74 50                	je     80103f98 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f48:	83 ec 0c             	sub    $0xc,%esp
80103f4b:	68 20 2d 11 80       	push   $0x80112d20
80103f50:	e8 fb 04 00 00       	call   80104450 <acquire>
    release(lk);
80103f55:	89 34 24             	mov    %esi,(%esp)
80103f58:	e8 13 06 00 00       	call   80104570 <release>
  p->chan = chan;
80103f5d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f60:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f67:	e8 84 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103f6c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103f73:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f7a:	e8 f1 05 00 00       	call   80104570 <release>
    acquire(lk);
80103f7f:	89 75 08             	mov    %esi,0x8(%ebp)
80103f82:	83 c4 10             	add    $0x10,%esp
}
80103f85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f88:	5b                   	pop    %ebx
80103f89:	5e                   	pop    %esi
80103f8a:	5f                   	pop    %edi
80103f8b:	5d                   	pop    %ebp
    acquire(lk);
80103f8c:	e9 bf 04 00 00       	jmp    80104450 <acquire>
80103f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f98:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f9b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fa2:	e8 49 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103fa7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fb1:	5b                   	pop    %ebx
80103fb2:	5e                   	pop    %esi
80103fb3:	5f                   	pop    %edi
80103fb4:	5d                   	pop    %ebp
80103fb5:	c3                   	ret    
    panic("sleep without lk");
80103fb6:	83 ec 0c             	sub    $0xc,%esp
80103fb9:	68 4f 76 10 80       	push   $0x8010764f
80103fbe:	e8 cd c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80103fc3:	83 ec 0c             	sub    $0xc,%esp
80103fc6:	68 49 76 10 80       	push   $0x80107649
80103fcb:	e8 c0 c3 ff ff       	call   80100390 <panic>

80103fd0 <wait>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
  pushcli();
80103fd5:	e8 36 04 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103fda:	e8 91 f7 ff ff       	call   80103770 <mycpu>
  p = c->proc;
80103fdf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fe5:	e8 26 05 00 00       	call   80104510 <popcli>
  acquire(&ptable.lock);
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 20 2d 11 80       	push   $0x80112d20
80103ff2:	e8 59 04 00 00       	call   80104450 <acquire>
80103ff7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103ffa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ffc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104001:	eb 13                	jmp    80104016 <wait+0x46>
80104003:	90                   	nop
80104004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104008:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010400e:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80104014:	73 1e                	jae    80104034 <wait+0x64>
      if(p->parent != curproc)
80104016:	39 73 14             	cmp    %esi,0x14(%ebx)
80104019:	75 ed                	jne    80104008 <wait+0x38>
      if(p->state == ZOMBIE){
8010401b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010401f:	74 37                	je     80104058 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104021:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
80104027:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402c:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80104032:	72 e2                	jb     80104016 <wait+0x46>
    if(!havekids || curproc->killed){
80104034:	85 c0                	test   %eax,%eax
80104036:	74 76                	je     801040ae <wait+0xde>
80104038:	8b 46 24             	mov    0x24(%esi),%eax
8010403b:	85 c0                	test   %eax,%eax
8010403d:	75 6f                	jne    801040ae <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010403f:	83 ec 08             	sub    $0x8,%esp
80104042:	68 20 2d 11 80       	push   $0x80112d20
80104047:	56                   	push   %esi
80104048:	e8 c3 fe ff ff       	call   80103f10 <sleep>
    havekids = 0;
8010404d:	83 c4 10             	add    $0x10,%esp
80104050:	eb a8                	jmp    80103ffa <wait+0x2a>
80104052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104058:	83 ec 0c             	sub    $0xc,%esp
8010405b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010405e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104061:	e8 ca e2 ff ff       	call   80102330 <kfree>
        freevm(p->pgdir);
80104066:	5a                   	pop    %edx
80104067:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010406a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104071:	e8 ca 2c 00 00       	call   80106d40 <freevm>
        release(&ptable.lock);
80104076:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
8010407d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104084:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010408b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010408f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104096:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010409d:	e8 ce 04 00 00       	call   80104570 <release>
        return pid;
801040a2:	83 c4 10             	add    $0x10,%esp
}
801040a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040a8:	89 f0                	mov    %esi,%eax
801040aa:	5b                   	pop    %ebx
801040ab:	5e                   	pop    %esi
801040ac:	5d                   	pop    %ebp
801040ad:	c3                   	ret    
      release(&ptable.lock);
801040ae:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040b1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040b6:	68 20 2d 11 80       	push   $0x80112d20
801040bb:	e8 b0 04 00 00       	call   80104570 <release>
      return -1;
801040c0:	83 c4 10             	add    $0x10,%esp
801040c3:	eb e0                	jmp    801040a5 <wait+0xd5>
801040c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040d0 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 10             	sub    $0x10,%esp
801040d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801040da:	68 20 2d 11 80       	push   $0x80112d20
801040df:	e8 6c 03 00 00       	call   80104450 <acquire>
  wakeup1(chan);
801040e4:	89 d8                	mov    %ebx,%eax
801040e6:	e8 e5 f7 ff ff       	call   801038d0 <wakeup1>
  release(&ptable.lock);
801040eb:	83 c4 10             	add    $0x10,%esp
801040ee:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801040f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f8:	c9                   	leave  
  release(&ptable.lock);
801040f9:	e9 72 04 00 00       	jmp    80104570 <release>
801040fe:	66 90                	xchg   %ax,%ax

80104100 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	53                   	push   %ebx
80104104:	83 ec 10             	sub    $0x10,%esp
80104107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010410a:	68 20 2d 11 80       	push   $0x80112d20
8010410f:	e8 3c 03 00 00       	call   80104450 <acquire>
80104114:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104117:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010411c:	eb 0e                	jmp    8010412c <kill+0x2c>
8010411e:	66 90                	xchg   %ax,%ax
80104120:	05 88 00 00 00       	add    $0x88,%eax
80104125:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
8010412a:	73 34                	jae    80104160 <kill+0x60>
    if(p->pid == pid){
8010412c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010412f:	75 ef                	jne    80104120 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104131:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104135:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010413c:	75 07                	jne    80104145 <kill+0x45>
        p->state = RUNNABLE;
8010413e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104145:	83 ec 0c             	sub    $0xc,%esp
80104148:	68 20 2d 11 80       	push   $0x80112d20
8010414d:	e8 1e 04 00 00       	call   80104570 <release>
      return 0;
80104152:	83 c4 10             	add    $0x10,%esp
80104155:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104157:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010415a:	c9                   	leave  
8010415b:	c3                   	ret    
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104160:	83 ec 0c             	sub    $0xc,%esp
80104163:	68 20 2d 11 80       	push   $0x80112d20
80104168:	e8 03 04 00 00       	call   80104570 <release>
  return -1;
8010416d:	83 c4 10             	add    $0x10,%esp
80104170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104178:	c9                   	leave  
80104179:	c3                   	ret    
8010417a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104180 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104189:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010418e:	83 ec 3c             	sub    $0x3c,%esp
80104191:	eb 27                	jmp    801041ba <procdump+0x3a>
80104193:	90                   	nop
80104194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	68 db 79 10 80       	push   $0x801079db
801041a0:	e8 cb c4 ff ff       	call   80100670 <cprintf>
801041a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a8:	81 c3 88 00 00 00    	add    $0x88,%ebx
801041ae:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801041b4:	0f 83 86 00 00 00    	jae    80104240 <procdump+0xc0>
    if(p->state == UNUSED)
801041ba:	8b 43 0c             	mov    0xc(%ebx),%eax
801041bd:	85 c0                	test   %eax,%eax
801041bf:	74 e7                	je     801041a8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041c1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801041c4:	ba 60 76 10 80       	mov    $0x80107660,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041c9:	77 11                	ja     801041dc <procdump+0x5c>
801041cb:	8b 14 85 c0 76 10 80 	mov    -0x7fef8940(,%eax,4),%edx
      state = "???";
801041d2:	b8 60 76 10 80       	mov    $0x80107660,%eax
801041d7:	85 d2                	test   %edx,%edx
801041d9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801041dc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041df:	50                   	push   %eax
801041e0:	52                   	push   %edx
801041e1:	ff 73 10             	pushl  0x10(%ebx)
801041e4:	68 64 76 10 80       	push   $0x80107664
801041e9:	e8 82 c4 ff ff       	call   80100670 <cprintf>
    if(p->state == SLEEPING){
801041ee:	83 c4 10             	add    $0x10,%esp
801041f1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801041f5:	75 a1                	jne    80104198 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801041f7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801041fa:	83 ec 08             	sub    $0x8,%esp
801041fd:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104200:	50                   	push   %eax
80104201:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104204:	8b 40 0c             	mov    0xc(%eax),%eax
80104207:	83 c0 08             	add    $0x8,%eax
8010420a:	50                   	push   %eax
8010420b:	e8 70 01 00 00       	call   80104380 <getcallerpcs>
80104210:	83 c4 10             	add    $0x10,%esp
80104213:	90                   	nop
80104214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104218:	8b 17                	mov    (%edi),%edx
8010421a:	85 d2                	test   %edx,%edx
8010421c:	0f 84 76 ff ff ff    	je     80104198 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104222:	83 ec 08             	sub    $0x8,%esp
80104225:	83 c7 04             	add    $0x4,%edi
80104228:	52                   	push   %edx
80104229:	68 a1 70 10 80       	push   $0x801070a1
8010422e:	e8 3d c4 ff ff       	call   80100670 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104233:	83 c4 10             	add    $0x10,%esp
80104236:	39 fe                	cmp    %edi,%esi
80104238:	75 de                	jne    80104218 <procdump+0x98>
8010423a:	e9 59 ff ff ff       	jmp    80104198 <procdump+0x18>
8010423f:	90                   	nop
  }
}
80104240:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104243:	5b                   	pop    %ebx
80104244:	5e                   	pop    %esi
80104245:	5f                   	pop    %edi
80104246:	5d                   	pop    %ebp
80104247:	c3                   	ret    
80104248:	66 90                	xchg   %ax,%ax
8010424a:	66 90                	xchg   %ax,%ax
8010424c:	66 90                	xchg   %ax,%ax
8010424e:	66 90                	xchg   %ax,%ax

80104250 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 0c             	sub    $0xc,%esp
80104257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010425a:	68 d8 76 10 80       	push   $0x801076d8
8010425f:	8d 43 04             	lea    0x4(%ebx),%eax
80104262:	50                   	push   %eax
80104263:	e8 f8 00 00 00       	call   80104360 <initlock>
  lk->name = name;
80104268:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010426b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104271:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104274:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010427b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010427e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104281:	c9                   	leave  
80104282:	c3                   	ret    
80104283:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104290 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	56                   	push   %esi
80104294:	53                   	push   %ebx
80104295:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	8d 73 04             	lea    0x4(%ebx),%esi
8010429e:	56                   	push   %esi
8010429f:	e8 ac 01 00 00       	call   80104450 <acquire>
  while (lk->locked) {
801042a4:	8b 13                	mov    (%ebx),%edx
801042a6:	83 c4 10             	add    $0x10,%esp
801042a9:	85 d2                	test   %edx,%edx
801042ab:	74 16                	je     801042c3 <acquiresleep+0x33>
801042ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801042b0:	83 ec 08             	sub    $0x8,%esp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
801042b5:	e8 56 fc ff ff       	call   80103f10 <sleep>
  while (lk->locked) {
801042ba:	8b 03                	mov    (%ebx),%eax
801042bc:	83 c4 10             	add    $0x10,%esp
801042bf:	85 c0                	test   %eax,%eax
801042c1:	75 ed                	jne    801042b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801042c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801042c9:	e8 42 f5 ff ff       	call   80103810 <myproc>
801042ce:	8b 40 10             	mov    0x10(%eax),%eax
801042d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801042d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801042d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042da:	5b                   	pop    %ebx
801042db:	5e                   	pop    %esi
801042dc:	5d                   	pop    %ebp
  release(&lk->lk);
801042dd:	e9 8e 02 00 00       	jmp    80104570 <release>
801042e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	56                   	push   %esi
801042f4:	53                   	push   %ebx
801042f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	8d 73 04             	lea    0x4(%ebx),%esi
801042fe:	56                   	push   %esi
801042ff:	e8 4c 01 00 00       	call   80104450 <acquire>
  lk->locked = 0;
80104304:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010430a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104311:	89 1c 24             	mov    %ebx,(%esp)
80104314:	e8 b7 fd ff ff       	call   801040d0 <wakeup>
  release(&lk->lk);
80104319:	89 75 08             	mov    %esi,0x8(%ebp)
8010431c:	83 c4 10             	add    $0x10,%esp
}
8010431f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104322:	5b                   	pop    %ebx
80104323:	5e                   	pop    %esi
80104324:	5d                   	pop    %ebp
  release(&lk->lk);
80104325:	e9 46 02 00 00       	jmp    80104570 <release>
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	56                   	push   %esi
80104334:	53                   	push   %ebx
80104335:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010433e:	53                   	push   %ebx
8010433f:	e8 0c 01 00 00       	call   80104450 <acquire>
  r = lk->locked;
80104344:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104346:	89 1c 24             	mov    %ebx,(%esp)
80104349:	e8 22 02 00 00       	call   80104570 <release>
  return r;
}
8010434e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104351:	89 f0                	mov    %esi,%eax
80104353:	5b                   	pop    %ebx
80104354:	5e                   	pop    %esi
80104355:	5d                   	pop    %ebp
80104356:	c3                   	ret    
80104357:	66 90                	xchg   %ax,%ax
80104359:	66 90                	xchg   %ax,%ax
8010435b:	66 90                	xchg   %ax,%ax
8010435d:	66 90                	xchg   %ax,%ax
8010435f:	90                   	nop

80104360 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104366:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104369:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010436f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104372:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104379:	5d                   	pop    %ebp
8010437a:	c3                   	ret    
8010437b:	90                   	nop
8010437c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104380 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104380:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104381:	31 d2                	xor    %edx,%edx
{
80104383:	89 e5                	mov    %esp,%ebp
80104385:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104386:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104389:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010438c:	83 e8 08             	sub    $0x8,%eax
8010438f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104390:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104396:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010439c:	77 1a                	ja     801043b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010439e:	8b 58 04             	mov    0x4(%eax),%ebx
801043a1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801043a4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801043a7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801043a9:	83 fa 0a             	cmp    $0xa,%edx
801043ac:	75 e2                	jne    80104390 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801043ae:	5b                   	pop    %ebx
801043af:	5d                   	pop    %ebp
801043b0:	c3                   	ret    
801043b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043b8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801043bb:	83 c1 28             	add    $0x28,%ecx
801043be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801043c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801043c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801043c9:	39 c1                	cmp    %eax,%ecx
801043cb:	75 f3                	jne    801043c0 <getcallerpcs+0x40>
}
801043cd:	5b                   	pop    %ebx
801043ce:	5d                   	pop    %ebp
801043cf:	c3                   	ret    

801043d0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	53                   	push   %ebx
801043d4:	83 ec 04             	sub    $0x4,%esp
801043d7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801043da:	8b 02                	mov    (%edx),%eax
801043dc:	85 c0                	test   %eax,%eax
801043de:	75 10                	jne    801043f0 <holding+0x20>
}
801043e0:	83 c4 04             	add    $0x4,%esp
801043e3:	31 c0                	xor    %eax,%eax
801043e5:	5b                   	pop    %ebx
801043e6:	5d                   	pop    %ebp
801043e7:	c3                   	ret    
801043e8:	90                   	nop
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801043f0:	8b 5a 08             	mov    0x8(%edx),%ebx
801043f3:	e8 78 f3 ff ff       	call   80103770 <mycpu>
801043f8:	39 c3                	cmp    %eax,%ebx
801043fa:	0f 94 c0             	sete   %al
}
801043fd:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104400:	0f b6 c0             	movzbl %al,%eax
}
80104403:	5b                   	pop    %ebx
80104404:	5d                   	pop    %ebp
80104405:	c3                   	ret    
80104406:	8d 76 00             	lea    0x0(%esi),%esi
80104409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104410 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 04             	sub    $0x4,%esp
80104417:	9c                   	pushf  
80104418:	5b                   	pop    %ebx
  asm volatile("cli");
80104419:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010441a:	e8 51 f3 ff ff       	call   80103770 <mycpu>
8010441f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104425:	85 c0                	test   %eax,%eax
80104427:	75 11                	jne    8010443a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104429:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010442f:	e8 3c f3 ff ff       	call   80103770 <mycpu>
80104434:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010443a:	e8 31 f3 ff ff       	call   80103770 <mycpu>
8010443f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104446:	83 c4 04             	add    $0x4,%esp
80104449:	5b                   	pop    %ebx
8010444a:	5d                   	pop    %ebp
8010444b:	c3                   	ret    
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104450 <acquire>:
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104455:	e8 b6 ff ff ff       	call   80104410 <pushcli>
  if(holding(lk))
8010445a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010445d:	8b 03                	mov    (%ebx),%eax
8010445f:	85 c0                	test   %eax,%eax
80104461:	0f 85 81 00 00 00    	jne    801044e8 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104467:	ba 01 00 00 00       	mov    $0x1,%edx
8010446c:	eb 05                	jmp    80104473 <acquire+0x23>
8010446e:	66 90                	xchg   %ax,%ax
80104470:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104473:	89 d0                	mov    %edx,%eax
80104475:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104478:	85 c0                	test   %eax,%eax
8010447a:	75 f4                	jne    80104470 <acquire+0x20>
  __sync_synchronize();
8010447c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104481:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104484:	e8 e7 f2 ff ff       	call   80103770 <mycpu>
  for(i = 0; i < 10; i++){
80104489:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
8010448b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
8010448e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104491:	89 e8                	mov    %ebp,%eax
80104493:	90                   	nop
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104498:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010449e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044a4:	77 1a                	ja     801044c0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801044a6:	8b 58 04             	mov    0x4(%eax),%ebx
801044a9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801044ac:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801044af:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801044b1:	83 fa 0a             	cmp    $0xa,%edx
801044b4:	75 e2                	jne    80104498 <acquire+0x48>
}
801044b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044b9:	5b                   	pop    %ebx
801044ba:	5e                   	pop    %esi
801044bb:	5d                   	pop    %ebp
801044bc:	c3                   	ret    
801044bd:	8d 76 00             	lea    0x0(%esi),%esi
801044c0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801044c3:	83 c1 28             	add    $0x28,%ecx
801044c6:	8d 76 00             	lea    0x0(%esi),%esi
801044c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801044d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801044d6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801044d9:	39 c8                	cmp    %ecx,%eax
801044db:	75 f3                	jne    801044d0 <acquire+0x80>
}
801044dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044e0:	5b                   	pop    %ebx
801044e1:	5e                   	pop    %esi
801044e2:	5d                   	pop    %ebp
801044e3:	c3                   	ret    
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801044e8:	8b 73 08             	mov    0x8(%ebx),%esi
801044eb:	e8 80 f2 ff ff       	call   80103770 <mycpu>
801044f0:	39 c6                	cmp    %eax,%esi
801044f2:	0f 85 6f ff ff ff    	jne    80104467 <acquire+0x17>
    panic("acquire");
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	68 e3 76 10 80       	push   $0x801076e3
80104500:	e8 8b be ff ff       	call   80100390 <panic>
80104505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104510 <popcli>:

void
popcli(void)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104516:	9c                   	pushf  
80104517:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104518:	f6 c4 02             	test   $0x2,%ah
8010451b:	75 35                	jne    80104552 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010451d:	e8 4e f2 ff ff       	call   80103770 <mycpu>
80104522:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104529:	78 34                	js     8010455f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010452b:	e8 40 f2 ff ff       	call   80103770 <mycpu>
80104530:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104536:	85 d2                	test   %edx,%edx
80104538:	74 06                	je     80104540 <popcli+0x30>
    sti();
}
8010453a:	c9                   	leave  
8010453b:	c3                   	ret    
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104540:	e8 2b f2 ff ff       	call   80103770 <mycpu>
80104545:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010454b:	85 c0                	test   %eax,%eax
8010454d:	74 eb                	je     8010453a <popcli+0x2a>
  asm volatile("sti");
8010454f:	fb                   	sti    
}
80104550:	c9                   	leave  
80104551:	c3                   	ret    
    panic("popcli - interruptible");
80104552:	83 ec 0c             	sub    $0xc,%esp
80104555:	68 eb 76 10 80       	push   $0x801076eb
8010455a:	e8 31 be ff ff       	call   80100390 <panic>
    panic("popcli");
8010455f:	83 ec 0c             	sub    $0xc,%esp
80104562:	68 02 77 10 80       	push   $0x80107702
80104567:	e8 24 be ff ff       	call   80100390 <panic>
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104570 <release>:
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104578:	8b 03                	mov    (%ebx),%eax
8010457a:	85 c0                	test   %eax,%eax
8010457c:	74 0c                	je     8010458a <release+0x1a>
8010457e:	8b 73 08             	mov    0x8(%ebx),%esi
80104581:	e8 ea f1 ff ff       	call   80103770 <mycpu>
80104586:	39 c6                	cmp    %eax,%esi
80104588:	74 16                	je     801045a0 <release+0x30>
    panic("release");
8010458a:	83 ec 0c             	sub    $0xc,%esp
8010458d:	68 09 77 10 80       	push   $0x80107709
80104592:	e8 f9 bd ff ff       	call   80100390 <panic>
80104597:	89 f6                	mov    %esi,%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
801045a0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045a7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045ae:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045bc:	5b                   	pop    %ebx
801045bd:	5e                   	pop    %esi
801045be:	5d                   	pop    %ebp
  popcli();
801045bf:	e9 4c ff ff ff       	jmp    80104510 <popcli>
801045c4:	66 90                	xchg   %ax,%ax
801045c6:	66 90                	xchg   %ax,%ax
801045c8:	66 90                	xchg   %ax,%ax
801045ca:	66 90                	xchg   %ax,%ax
801045cc:	66 90                	xchg   %ax,%ax
801045ce:	66 90                	xchg   %ax,%ax

801045d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	53                   	push   %ebx
801045d5:	8b 55 08             	mov    0x8(%ebp),%edx
801045d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801045db:	f6 c2 03             	test   $0x3,%dl
801045de:	75 05                	jne    801045e5 <memset+0x15>
801045e0:	f6 c1 03             	test   $0x3,%cl
801045e3:	74 13                	je     801045f8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801045e5:	89 d7                	mov    %edx,%edi
801045e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801045ea:	fc                   	cld    
801045eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801045ed:	5b                   	pop    %ebx
801045ee:	89 d0                	mov    %edx,%eax
801045f0:	5f                   	pop    %edi
801045f1:	5d                   	pop    %ebp
801045f2:	c3                   	ret    
801045f3:	90                   	nop
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801045f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801045fc:	c1 e9 02             	shr    $0x2,%ecx
801045ff:	89 f8                	mov    %edi,%eax
80104601:	89 fb                	mov    %edi,%ebx
80104603:	c1 e0 18             	shl    $0x18,%eax
80104606:	c1 e3 10             	shl    $0x10,%ebx
80104609:	09 d8                	or     %ebx,%eax
8010460b:	09 f8                	or     %edi,%eax
8010460d:	c1 e7 08             	shl    $0x8,%edi
80104610:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104612:	89 d7                	mov    %edx,%edi
80104614:	fc                   	cld    
80104615:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104617:	5b                   	pop    %ebx
80104618:	89 d0                	mov    %edx,%eax
8010461a:	5f                   	pop    %edi
8010461b:	5d                   	pop    %ebp
8010461c:	c3                   	ret    
8010461d:	8d 76 00             	lea    0x0(%esi),%esi

80104620 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	56                   	push   %esi
80104625:	53                   	push   %ebx
80104626:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104629:	8b 75 08             	mov    0x8(%ebp),%esi
8010462c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010462f:	85 db                	test   %ebx,%ebx
80104631:	74 29                	je     8010465c <memcmp+0x3c>
    if(*s1 != *s2)
80104633:	0f b6 16             	movzbl (%esi),%edx
80104636:	0f b6 0f             	movzbl (%edi),%ecx
80104639:	38 d1                	cmp    %dl,%cl
8010463b:	75 2b                	jne    80104668 <memcmp+0x48>
8010463d:	b8 01 00 00 00       	mov    $0x1,%eax
80104642:	eb 14                	jmp    80104658 <memcmp+0x38>
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104648:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010464c:	83 c0 01             	add    $0x1,%eax
8010464f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104654:	38 ca                	cmp    %cl,%dl
80104656:	75 10                	jne    80104668 <memcmp+0x48>
  while(n-- > 0){
80104658:	39 d8                	cmp    %ebx,%eax
8010465a:	75 ec                	jne    80104648 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010465c:	5b                   	pop    %ebx
  return 0;
8010465d:	31 c0                	xor    %eax,%eax
}
8010465f:	5e                   	pop    %esi
80104660:	5f                   	pop    %edi
80104661:	5d                   	pop    %ebp
80104662:	c3                   	ret    
80104663:	90                   	nop
80104664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104668:	0f b6 c2             	movzbl %dl,%eax
}
8010466b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010466c:	29 c8                	sub    %ecx,%eax
}
8010466e:	5e                   	pop    %esi
8010466f:	5f                   	pop    %edi
80104670:	5d                   	pop    %ebp
80104671:	c3                   	ret    
80104672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104680 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 45 08             	mov    0x8(%ebp),%eax
80104688:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010468b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010468e:	39 c3                	cmp    %eax,%ebx
80104690:	73 26                	jae    801046b8 <memmove+0x38>
80104692:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104695:	39 c8                	cmp    %ecx,%eax
80104697:	73 1f                	jae    801046b8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104699:	85 f6                	test   %esi,%esi
8010469b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010469e:	74 0f                	je     801046af <memmove+0x2f>
      *--d = *--s;
801046a0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801046a4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801046a7:	83 ea 01             	sub    $0x1,%edx
801046aa:	83 fa ff             	cmp    $0xffffffff,%edx
801046ad:	75 f1                	jne    801046a0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801046af:	5b                   	pop    %ebx
801046b0:	5e                   	pop    %esi
801046b1:	5d                   	pop    %ebp
801046b2:	c3                   	ret    
801046b3:	90                   	nop
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801046b8:	31 d2                	xor    %edx,%edx
801046ba:	85 f6                	test   %esi,%esi
801046bc:	74 f1                	je     801046af <memmove+0x2f>
801046be:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801046c0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801046c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801046c7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801046ca:	39 d6                	cmp    %edx,%esi
801046cc:	75 f2                	jne    801046c0 <memmove+0x40>
}
801046ce:	5b                   	pop    %ebx
801046cf:	5e                   	pop    %esi
801046d0:	5d                   	pop    %ebp
801046d1:	c3                   	ret    
801046d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801046e3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801046e4:	eb 9a                	jmp    80104680 <memmove>
801046e6:	8d 76 00             	lea    0x0(%esi),%esi
801046e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046f0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	56                   	push   %esi
801046f5:	8b 7d 10             	mov    0x10(%ebp),%edi
801046f8:	53                   	push   %ebx
801046f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801046ff:	85 ff                	test   %edi,%edi
80104701:	74 2f                	je     80104732 <strncmp+0x42>
80104703:	0f b6 01             	movzbl (%ecx),%eax
80104706:	0f b6 1e             	movzbl (%esi),%ebx
80104709:	84 c0                	test   %al,%al
8010470b:	74 37                	je     80104744 <strncmp+0x54>
8010470d:	38 c3                	cmp    %al,%bl
8010470f:	75 33                	jne    80104744 <strncmp+0x54>
80104711:	01 f7                	add    %esi,%edi
80104713:	eb 13                	jmp    80104728 <strncmp+0x38>
80104715:	8d 76 00             	lea    0x0(%esi),%esi
80104718:	0f b6 01             	movzbl (%ecx),%eax
8010471b:	84 c0                	test   %al,%al
8010471d:	74 21                	je     80104740 <strncmp+0x50>
8010471f:	0f b6 1a             	movzbl (%edx),%ebx
80104722:	89 d6                	mov    %edx,%esi
80104724:	38 d8                	cmp    %bl,%al
80104726:	75 1c                	jne    80104744 <strncmp+0x54>
    n--, p++, q++;
80104728:	8d 56 01             	lea    0x1(%esi),%edx
8010472b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010472e:	39 fa                	cmp    %edi,%edx
80104730:	75 e6                	jne    80104718 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104732:	5b                   	pop    %ebx
    return 0;
80104733:	31 c0                	xor    %eax,%eax
}
80104735:	5e                   	pop    %esi
80104736:	5f                   	pop    %edi
80104737:	5d                   	pop    %ebp
80104738:	c3                   	ret    
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104740:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104744:	29 d8                	sub    %ebx,%eax
}
80104746:	5b                   	pop    %ebx
80104747:	5e                   	pop    %esi
80104748:	5f                   	pop    %edi
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret    
8010474b:	90                   	nop
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104750 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	8b 45 08             	mov    0x8(%ebp),%eax
80104758:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010475b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010475e:	89 c2                	mov    %eax,%edx
80104760:	eb 19                	jmp    8010477b <strncpy+0x2b>
80104762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104768:	83 c3 01             	add    $0x1,%ebx
8010476b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010476f:	83 c2 01             	add    $0x1,%edx
80104772:	84 c9                	test   %cl,%cl
80104774:	88 4a ff             	mov    %cl,-0x1(%edx)
80104777:	74 09                	je     80104782 <strncpy+0x32>
80104779:	89 f1                	mov    %esi,%ecx
8010477b:	85 c9                	test   %ecx,%ecx
8010477d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104780:	7f e6                	jg     80104768 <strncpy+0x18>
    ;
  while(n-- > 0)
80104782:	31 c9                	xor    %ecx,%ecx
80104784:	85 f6                	test   %esi,%esi
80104786:	7e 17                	jle    8010479f <strncpy+0x4f>
80104788:	90                   	nop
80104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104790:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104794:	89 f3                	mov    %esi,%ebx
80104796:	83 c1 01             	add    $0x1,%ecx
80104799:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010479b:	85 db                	test   %ebx,%ebx
8010479d:	7f f1                	jg     80104790 <strncpy+0x40>
  return os;
}
8010479f:	5b                   	pop    %ebx
801047a0:	5e                   	pop    %esi
801047a1:	5d                   	pop    %ebp
801047a2:	c3                   	ret    
801047a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047b8:	8b 45 08             	mov    0x8(%ebp),%eax
801047bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801047be:	85 c9                	test   %ecx,%ecx
801047c0:	7e 26                	jle    801047e8 <safestrcpy+0x38>
801047c2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801047c6:	89 c1                	mov    %eax,%ecx
801047c8:	eb 17                	jmp    801047e1 <safestrcpy+0x31>
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801047d0:	83 c2 01             	add    $0x1,%edx
801047d3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801047d7:	83 c1 01             	add    $0x1,%ecx
801047da:	84 db                	test   %bl,%bl
801047dc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801047df:	74 04                	je     801047e5 <safestrcpy+0x35>
801047e1:	39 f2                	cmp    %esi,%edx
801047e3:	75 eb                	jne    801047d0 <safestrcpy+0x20>
    ;
  *s = 0;
801047e5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801047e8:	5b                   	pop    %ebx
801047e9:	5e                   	pop    %esi
801047ea:	5d                   	pop    %ebp
801047eb:	c3                   	ret    
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047f0 <strlen>:

int
strlen(const char *s)
{
801047f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801047f1:	31 c0                	xor    %eax,%eax
{
801047f3:	89 e5                	mov    %esp,%ebp
801047f5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801047f8:	80 3a 00             	cmpb   $0x0,(%edx)
801047fb:	74 0c                	je     80104809 <strlen+0x19>
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
80104800:	83 c0 01             	add    $0x1,%eax
80104803:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104807:	75 f7                	jne    80104800 <strlen+0x10>
    ;
  return n;
}
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    

8010480b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010480b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010480f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104813:	55                   	push   %ebp
  pushl %ebx
80104814:	53                   	push   %ebx
  pushl %esi
80104815:	56                   	push   %esi
  pushl %edi
80104816:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104817:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104819:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010481b:	5f                   	pop    %edi
  popl %esi
8010481c:	5e                   	pop    %esi
  popl %ebx
8010481d:	5b                   	pop    %ebx
  popl %ebp
8010481e:	5d                   	pop    %ebp
  ret
8010481f:	c3                   	ret    

80104820 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	53                   	push   %ebx
80104824:	83 ec 04             	sub    $0x4,%esp
80104827:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010482a:	e8 e1 ef ff ff       	call   80103810 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010482f:	8b 00                	mov    (%eax),%eax
80104831:	39 d8                	cmp    %ebx,%eax
80104833:	76 1b                	jbe    80104850 <fetchint+0x30>
80104835:	8d 53 04             	lea    0x4(%ebx),%edx
80104838:	39 d0                	cmp    %edx,%eax
8010483a:	72 14                	jb     80104850 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010483c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010483f:	8b 13                	mov    (%ebx),%edx
80104841:	89 10                	mov    %edx,(%eax)
  return 0;
80104843:	31 c0                	xor    %eax,%eax
}
80104845:	83 c4 04             	add    $0x4,%esp
80104848:	5b                   	pop    %ebx
80104849:	5d                   	pop    %ebp
8010484a:	c3                   	ret    
8010484b:	90                   	nop
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104855:	eb ee                	jmp    80104845 <fetchint+0x25>
80104857:	89 f6                	mov    %esi,%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 04             	sub    $0x4,%esp
80104867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010486a:	e8 a1 ef ff ff       	call   80103810 <myproc>

  if(addr >= curproc->sz)
8010486f:	39 18                	cmp    %ebx,(%eax)
80104871:	76 29                	jbe    8010489c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104873:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104876:	89 da                	mov    %ebx,%edx
80104878:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010487a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010487c:	39 c3                	cmp    %eax,%ebx
8010487e:	73 1c                	jae    8010489c <fetchstr+0x3c>
    if(*s == 0)
80104880:	80 3b 00             	cmpb   $0x0,(%ebx)
80104883:	75 10                	jne    80104895 <fetchstr+0x35>
80104885:	eb 39                	jmp    801048c0 <fetchstr+0x60>
80104887:	89 f6                	mov    %esi,%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104890:	80 3a 00             	cmpb   $0x0,(%edx)
80104893:	74 1b                	je     801048b0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104895:	83 c2 01             	add    $0x1,%edx
80104898:	39 d0                	cmp    %edx,%eax
8010489a:	77 f4                	ja     80104890 <fetchstr+0x30>
    return -1;
8010489c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801048a1:	83 c4 04             	add    $0x4,%esp
801048a4:	5b                   	pop    %ebx
801048a5:	5d                   	pop    %ebp
801048a6:	c3                   	ret    
801048a7:	89 f6                	mov    %esi,%esi
801048a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801048b0:	83 c4 04             	add    $0x4,%esp
801048b3:	89 d0                	mov    %edx,%eax
801048b5:	29 d8                	sub    %ebx,%eax
801048b7:	5b                   	pop    %ebx
801048b8:	5d                   	pop    %ebp
801048b9:	c3                   	ret    
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801048c0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801048c2:	eb dd                	jmp    801048a1 <fetchstr+0x41>
801048c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048d5:	e8 36 ef ff ff       	call   80103810 <myproc>
801048da:	8b 40 18             	mov    0x18(%eax),%eax
801048dd:	8b 55 08             	mov    0x8(%ebp),%edx
801048e0:	8b 40 44             	mov    0x44(%eax),%eax
801048e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801048e6:	e8 25 ef ff ff       	call   80103810 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048eb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048ed:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048f0:	39 c6                	cmp    %eax,%esi
801048f2:	73 1c                	jae    80104910 <argint+0x40>
801048f4:	8d 53 08             	lea    0x8(%ebx),%edx
801048f7:	39 d0                	cmp    %edx,%eax
801048f9:	72 15                	jb     80104910 <argint+0x40>
  *ip = *(int*)(addr);
801048fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801048fe:	8b 53 04             	mov    0x4(%ebx),%edx
80104901:	89 10                	mov    %edx,(%eax)
  return 0;
80104903:	31 c0                	xor    %eax,%eax
}
80104905:	5b                   	pop    %ebx
80104906:	5e                   	pop    %esi
80104907:	5d                   	pop    %ebp
80104908:	c3                   	ret    
80104909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104915:	eb ee                	jmp    80104905 <argint+0x35>
80104917:	89 f6                	mov    %esi,%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	56                   	push   %esi
80104924:	53                   	push   %ebx
80104925:	83 ec 10             	sub    $0x10,%esp
80104928:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010492b:	e8 e0 ee ff ff       	call   80103810 <myproc>
80104930:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104932:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104935:	83 ec 08             	sub    $0x8,%esp
80104938:	50                   	push   %eax
80104939:	ff 75 08             	pushl  0x8(%ebp)
8010493c:	e8 8f ff ff ff       	call   801048d0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104941:	83 c4 10             	add    $0x10,%esp
80104944:	85 c0                	test   %eax,%eax
80104946:	78 28                	js     80104970 <argptr+0x50>
80104948:	85 db                	test   %ebx,%ebx
8010494a:	78 24                	js     80104970 <argptr+0x50>
8010494c:	8b 16                	mov    (%esi),%edx
8010494e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104951:	39 c2                	cmp    %eax,%edx
80104953:	76 1b                	jbe    80104970 <argptr+0x50>
80104955:	01 c3                	add    %eax,%ebx
80104957:	39 da                	cmp    %ebx,%edx
80104959:	72 15                	jb     80104970 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010495b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010495e:	89 02                	mov    %eax,(%edx)
  return 0;
80104960:	31 c0                	xor    %eax,%eax
}
80104962:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104965:	5b                   	pop    %ebx
80104966:	5e                   	pop    %esi
80104967:	5d                   	pop    %ebp
80104968:	c3                   	ret    
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104975:	eb eb                	jmp    80104962 <argptr+0x42>
80104977:	89 f6                	mov    %esi,%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104986:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104989:	50                   	push   %eax
8010498a:	ff 75 08             	pushl  0x8(%ebp)
8010498d:	e8 3e ff ff ff       	call   801048d0 <argint>
80104992:	83 c4 10             	add    $0x10,%esp
80104995:	85 c0                	test   %eax,%eax
80104997:	78 17                	js     801049b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104999:	83 ec 08             	sub    $0x8,%esp
8010499c:	ff 75 0c             	pushl  0xc(%ebp)
8010499f:	ff 75 f4             	pushl  -0xc(%ebp)
801049a2:	e8 b9 fe ff ff       	call   80104860 <fetchstr>
801049a7:	83 c4 10             	add    $0x10,%esp
}
801049aa:	c9                   	leave  
801049ab:	c3                   	ret    
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049b5:	c9                   	leave  
801049b6:	c3                   	ret    
801049b7:	89 f6                	mov    %esi,%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <syscall>:
[SYS_trace]   sys_trace,
};

void
syscall(void)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	53                   	push   %ebx
801049c4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801049c7:	e8 44 ee ff ff       	call   80103810 <myproc>
801049cc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801049ce:	8b 40 18             	mov    0x18(%eax),%eax
801049d1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801049d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801049d7:	83 fa 15             	cmp    $0x15,%edx
801049da:	77 1c                	ja     801049f8 <syscall+0x38>
801049dc:	8b 14 85 40 77 10 80 	mov    -0x7fef88c0(,%eax,4),%edx
801049e3:	85 d2                	test   %edx,%edx
801049e5:	74 11                	je     801049f8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801049e7:	ff d2                	call   *%edx
801049e9:	8b 53 18             	mov    0x18(%ebx),%edx
801049ec:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801049ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f2:	c9                   	leave  
801049f3:	c3                   	ret    
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801049f8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801049f9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801049fc:	50                   	push   %eax
801049fd:	ff 73 10             	pushl  0x10(%ebx)
80104a00:	68 11 77 10 80       	push   $0x80107711
80104a05:	e8 66 bc ff ff       	call   80100670 <cprintf>
    curproc->tf->eax = -1;
80104a0a:	8b 43 18             	mov    0x18(%ebx),%eax
80104a0d:	83 c4 10             	add    $0x10,%esp
80104a10:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104a17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a1a:	c9                   	leave  
80104a1b:	c3                   	ret    
80104a1c:	66 90                	xchg   %ax,%ax
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	56                   	push   %esi
80104a25:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a26:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104a29:	83 ec 44             	sub    $0x44,%esp
80104a2c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104a2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a32:	56                   	push   %esi
80104a33:	50                   	push   %eax
{
80104a34:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104a37:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a3a:	e8 e1 d4 ff ff       	call   80101f20 <nameiparent>
80104a3f:	83 c4 10             	add    $0x10,%esp
80104a42:	85 c0                	test   %eax,%eax
80104a44:	0f 84 46 01 00 00    	je     80104b90 <create+0x170>
    return 0;
  ilock(dp);
80104a4a:	83 ec 0c             	sub    $0xc,%esp
80104a4d:	89 c3                	mov    %eax,%ebx
80104a4f:	50                   	push   %eax
80104a50:	e8 4b cc ff ff       	call   801016a0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104a55:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a58:	83 c4 0c             	add    $0xc,%esp
80104a5b:	50                   	push   %eax
80104a5c:	56                   	push   %esi
80104a5d:	53                   	push   %ebx
80104a5e:	e8 6d d1 ff ff       	call   80101bd0 <dirlookup>
80104a63:	83 c4 10             	add    $0x10,%esp
80104a66:	85 c0                	test   %eax,%eax
80104a68:	89 c7                	mov    %eax,%edi
80104a6a:	74 34                	je     80104aa0 <create+0x80>
    iunlockput(dp);
80104a6c:	83 ec 0c             	sub    $0xc,%esp
80104a6f:	53                   	push   %ebx
80104a70:	e8 bb ce ff ff       	call   80101930 <iunlockput>
    ilock(ip);
80104a75:	89 3c 24             	mov    %edi,(%esp)
80104a78:	e8 23 cc ff ff       	call   801016a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104a85:	0f 85 95 00 00 00    	jne    80104b20 <create+0x100>
80104a8b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104a90:	0f 85 8a 00 00 00    	jne    80104b20 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a99:	89 f8                	mov    %edi,%eax
80104a9b:	5b                   	pop    %ebx
80104a9c:	5e                   	pop    %esi
80104a9d:	5f                   	pop    %edi
80104a9e:	5d                   	pop    %ebp
80104a9f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104aa0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104aa4:	83 ec 08             	sub    $0x8,%esp
80104aa7:	50                   	push   %eax
80104aa8:	ff 33                	pushl  (%ebx)
80104aaa:	e8 81 ca ff ff       	call   80101530 <ialloc>
80104aaf:	83 c4 10             	add    $0x10,%esp
80104ab2:	85 c0                	test   %eax,%eax
80104ab4:	89 c7                	mov    %eax,%edi
80104ab6:	0f 84 e8 00 00 00    	je     80104ba4 <create+0x184>
  ilock(ip);
80104abc:	83 ec 0c             	sub    $0xc,%esp
80104abf:	50                   	push   %eax
80104ac0:	e8 db cb ff ff       	call   801016a0 <ilock>
  ip->major = major;
80104ac5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104ac9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104acd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104ad1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104ad5:	b8 01 00 00 00       	mov    $0x1,%eax
80104ada:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104ade:	89 3c 24             	mov    %edi,(%esp)
80104ae1:	e8 0a cb ff ff       	call   801015f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ae6:	83 c4 10             	add    $0x10,%esp
80104ae9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104aee:	74 50                	je     80104b40 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104af0:	83 ec 04             	sub    $0x4,%esp
80104af3:	ff 77 04             	pushl  0x4(%edi)
80104af6:	56                   	push   %esi
80104af7:	53                   	push   %ebx
80104af8:	e8 43 d3 ff ff       	call   80101e40 <dirlink>
80104afd:	83 c4 10             	add    $0x10,%esp
80104b00:	85 c0                	test   %eax,%eax
80104b02:	0f 88 8f 00 00 00    	js     80104b97 <create+0x177>
  iunlockput(dp);
80104b08:	83 ec 0c             	sub    $0xc,%esp
80104b0b:	53                   	push   %ebx
80104b0c:	e8 1f ce ff ff       	call   80101930 <iunlockput>
  return ip;
80104b11:	83 c4 10             	add    $0x10,%esp
}
80104b14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b17:	89 f8                	mov    %edi,%eax
80104b19:	5b                   	pop    %ebx
80104b1a:	5e                   	pop    %esi
80104b1b:	5f                   	pop    %edi
80104b1c:	5d                   	pop    %ebp
80104b1d:	c3                   	ret    
80104b1e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104b20:	83 ec 0c             	sub    $0xc,%esp
80104b23:	57                   	push   %edi
    return 0;
80104b24:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104b26:	e8 05 ce ff ff       	call   80101930 <iunlockput>
    return 0;
80104b2b:	83 c4 10             	add    $0x10,%esp
}
80104b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b31:	89 f8                	mov    %edi,%eax
80104b33:	5b                   	pop    %ebx
80104b34:	5e                   	pop    %esi
80104b35:	5f                   	pop    %edi
80104b36:	5d                   	pop    %ebp
80104b37:	c3                   	ret    
80104b38:	90                   	nop
80104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104b40:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104b45:	83 ec 0c             	sub    $0xc,%esp
80104b48:	53                   	push   %ebx
80104b49:	e8 a2 ca ff ff       	call   801015f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b4e:	83 c4 0c             	add    $0xc,%esp
80104b51:	ff 77 04             	pushl  0x4(%edi)
80104b54:	68 b8 77 10 80       	push   $0x801077b8
80104b59:	57                   	push   %edi
80104b5a:	e8 e1 d2 ff ff       	call   80101e40 <dirlink>
80104b5f:	83 c4 10             	add    $0x10,%esp
80104b62:	85 c0                	test   %eax,%eax
80104b64:	78 1c                	js     80104b82 <create+0x162>
80104b66:	83 ec 04             	sub    $0x4,%esp
80104b69:	ff 73 04             	pushl  0x4(%ebx)
80104b6c:	68 b7 77 10 80       	push   $0x801077b7
80104b71:	57                   	push   %edi
80104b72:	e8 c9 d2 ff ff       	call   80101e40 <dirlink>
80104b77:	83 c4 10             	add    $0x10,%esp
80104b7a:	85 c0                	test   %eax,%eax
80104b7c:	0f 89 6e ff ff ff    	jns    80104af0 <create+0xd0>
      panic("create dots");
80104b82:	83 ec 0c             	sub    $0xc,%esp
80104b85:	68 ab 77 10 80       	push   $0x801077ab
80104b8a:	e8 01 b8 ff ff       	call   80100390 <panic>
80104b8f:	90                   	nop
    return 0;
80104b90:	31 ff                	xor    %edi,%edi
80104b92:	e9 ff fe ff ff       	jmp    80104a96 <create+0x76>
    panic("create: dirlink");
80104b97:	83 ec 0c             	sub    $0xc,%esp
80104b9a:	68 ba 77 10 80       	push   $0x801077ba
80104b9f:	e8 ec b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104ba4:	83 ec 0c             	sub    $0xc,%esp
80104ba7:	68 9c 77 10 80       	push   $0x8010779c
80104bac:	e8 df b7 ff ff       	call   80100390 <panic>
80104bb1:	eb 0d                	jmp    80104bc0 <argfd.constprop.0>
80104bb3:	90                   	nop
80104bb4:	90                   	nop
80104bb5:	90                   	nop
80104bb6:	90                   	nop
80104bb7:	90                   	nop
80104bb8:	90                   	nop
80104bb9:	90                   	nop
80104bba:	90                   	nop
80104bbb:	90                   	nop
80104bbc:	90                   	nop
80104bbd:	90                   	nop
80104bbe:	90                   	nop
80104bbf:	90                   	nop

80104bc0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104bc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104bca:	89 d6                	mov    %edx,%esi
80104bcc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104bcf:	50                   	push   %eax
80104bd0:	6a 00                	push   $0x0
80104bd2:	e8 f9 fc ff ff       	call   801048d0 <argint>
80104bd7:	83 c4 10             	add    $0x10,%esp
80104bda:	85 c0                	test   %eax,%eax
80104bdc:	78 2a                	js     80104c08 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104bde:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104be2:	77 24                	ja     80104c08 <argfd.constprop.0+0x48>
80104be4:	e8 27 ec ff ff       	call   80103810 <myproc>
80104be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	74 14                	je     80104c08 <argfd.constprop.0+0x48>
  if(pfd)
80104bf4:	85 db                	test   %ebx,%ebx
80104bf6:	74 02                	je     80104bfa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104bf8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104bfa:	89 06                	mov    %eax,(%esi)
  return 0;
80104bfc:	31 c0                	xor    %eax,%eax
}
80104bfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c01:	5b                   	pop    %ebx
80104c02:	5e                   	pop    %esi
80104c03:	5d                   	pop    %ebp
80104c04:	c3                   	ret    
80104c05:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c0d:	eb ef                	jmp    80104bfe <argfd.constprop.0+0x3e>
80104c0f:	90                   	nop

80104c10 <sys_dup>:
{
80104c10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c11:	31 c0                	xor    %eax,%eax
{
80104c13:	89 e5                	mov    %esp,%ebp
80104c15:	56                   	push   %esi
80104c16:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104c17:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104c1a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104c1d:	e8 9e ff ff ff       	call   80104bc0 <argfd.constprop.0>
80104c22:	85 c0                	test   %eax,%eax
80104c24:	78 42                	js     80104c68 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104c26:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c29:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104c2b:	e8 e0 eb ff ff       	call   80103810 <myproc>
80104c30:	eb 0e                	jmp    80104c40 <sys_dup+0x30>
80104c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c38:	83 c3 01             	add    $0x1,%ebx
80104c3b:	83 fb 10             	cmp    $0x10,%ebx
80104c3e:	74 28                	je     80104c68 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104c40:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c44:	85 d2                	test   %edx,%edx
80104c46:	75 f0                	jne    80104c38 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104c48:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104c4c:	83 ec 0c             	sub    $0xc,%esp
80104c4f:	ff 75 f4             	pushl  -0xc(%ebp)
80104c52:	e8 a9 c1 ff ff       	call   80100e00 <filedup>
  return fd;
80104c57:	83 c4 10             	add    $0x10,%esp
}
80104c5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c5d:	89 d8                	mov    %ebx,%eax
80104c5f:	5b                   	pop    %ebx
80104c60:	5e                   	pop    %esi
80104c61:	5d                   	pop    %ebp
80104c62:	c3                   	ret    
80104c63:	90                   	nop
80104c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c68:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104c70:	89 d8                	mov    %ebx,%eax
80104c72:	5b                   	pop    %ebx
80104c73:	5e                   	pop    %esi
80104c74:	5d                   	pop    %ebp
80104c75:	c3                   	ret    
80104c76:	8d 76 00             	lea    0x0(%esi),%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <sys_read>:
{
80104c80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c81:	31 c0                	xor    %eax,%eax
{
80104c83:	89 e5                	mov    %esp,%ebp
80104c85:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c88:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c8b:	e8 30 ff ff ff       	call   80104bc0 <argfd.constprop.0>
80104c90:	85 c0                	test   %eax,%eax
80104c92:	78 4c                	js     80104ce0 <sys_read+0x60>
80104c94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c97:	83 ec 08             	sub    $0x8,%esp
80104c9a:	50                   	push   %eax
80104c9b:	6a 02                	push   $0x2
80104c9d:	e8 2e fc ff ff       	call   801048d0 <argint>
80104ca2:	83 c4 10             	add    $0x10,%esp
80104ca5:	85 c0                	test   %eax,%eax
80104ca7:	78 37                	js     80104ce0 <sys_read+0x60>
80104ca9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cac:	83 ec 04             	sub    $0x4,%esp
80104caf:	ff 75 f0             	pushl  -0x10(%ebp)
80104cb2:	50                   	push   %eax
80104cb3:	6a 01                	push   $0x1
80104cb5:	e8 66 fc ff ff       	call   80104920 <argptr>
80104cba:	83 c4 10             	add    $0x10,%esp
80104cbd:	85 c0                	test   %eax,%eax
80104cbf:	78 1f                	js     80104ce0 <sys_read+0x60>
  return fileread(f, p, n);
80104cc1:	83 ec 04             	sub    $0x4,%esp
80104cc4:	ff 75 f0             	pushl  -0x10(%ebp)
80104cc7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cca:	ff 75 ec             	pushl  -0x14(%ebp)
80104ccd:	e8 9e c2 ff ff       	call   80100f70 <fileread>
80104cd2:	83 c4 10             	add    $0x10,%esp
}
80104cd5:	c9                   	leave  
80104cd6:	c3                   	ret    
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ce5:	c9                   	leave  
80104ce6:	c3                   	ret    
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <sys_write>:
{
80104cf0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cf1:	31 c0                	xor    %eax,%eax
{
80104cf3:	89 e5                	mov    %esp,%ebp
80104cf5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cf8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cfb:	e8 c0 fe ff ff       	call   80104bc0 <argfd.constprop.0>
80104d00:	85 c0                	test   %eax,%eax
80104d02:	78 4c                	js     80104d50 <sys_write+0x60>
80104d04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d07:	83 ec 08             	sub    $0x8,%esp
80104d0a:	50                   	push   %eax
80104d0b:	6a 02                	push   $0x2
80104d0d:	e8 be fb ff ff       	call   801048d0 <argint>
80104d12:	83 c4 10             	add    $0x10,%esp
80104d15:	85 c0                	test   %eax,%eax
80104d17:	78 37                	js     80104d50 <sys_write+0x60>
80104d19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d1c:	83 ec 04             	sub    $0x4,%esp
80104d1f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d22:	50                   	push   %eax
80104d23:	6a 01                	push   $0x1
80104d25:	e8 f6 fb ff ff       	call   80104920 <argptr>
80104d2a:	83 c4 10             	add    $0x10,%esp
80104d2d:	85 c0                	test   %eax,%eax
80104d2f:	78 1f                	js     80104d50 <sys_write+0x60>
  return filewrite(f, p, n);
80104d31:	83 ec 04             	sub    $0x4,%esp
80104d34:	ff 75 f0             	pushl  -0x10(%ebp)
80104d37:	ff 75 f4             	pushl  -0xc(%ebp)
80104d3a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d3d:	e8 be c2 ff ff       	call   80101000 <filewrite>
80104d42:	83 c4 10             	add    $0x10,%esp
}
80104d45:	c9                   	leave  
80104d46:	c3                   	ret    
80104d47:	89 f6                	mov    %esi,%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d55:	c9                   	leave  
80104d56:	c3                   	ret    
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d60 <sys_close>:
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104d66:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d69:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d6c:	e8 4f fe ff ff       	call   80104bc0 <argfd.constprop.0>
80104d71:	85 c0                	test   %eax,%eax
80104d73:	78 2b                	js     80104da0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104d75:	e8 96 ea ff ff       	call   80103810 <myproc>
80104d7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104d7d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104d80:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104d87:	00 
  fileclose(f);
80104d88:	ff 75 f4             	pushl  -0xc(%ebp)
80104d8b:	e8 c0 c0 ff ff       	call   80100e50 <fileclose>
  return 0;
80104d90:	83 c4 10             	add    $0x10,%esp
80104d93:	31 c0                	xor    %eax,%eax
}
80104d95:	c9                   	leave  
80104d96:	c3                   	ret    
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104da5:	c9                   	leave  
80104da6:	c3                   	ret    
80104da7:	89 f6                	mov    %esi,%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <sys_fstat>:
{
80104db0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104db1:	31 c0                	xor    %eax,%eax
{
80104db3:	89 e5                	mov    %esp,%ebp
80104db5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104db8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104dbb:	e8 00 fe ff ff       	call   80104bc0 <argfd.constprop.0>
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	78 2c                	js     80104df0 <sys_fstat+0x40>
80104dc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dc7:	83 ec 04             	sub    $0x4,%esp
80104dca:	6a 14                	push   $0x14
80104dcc:	50                   	push   %eax
80104dcd:	6a 01                	push   $0x1
80104dcf:	e8 4c fb ff ff       	call   80104920 <argptr>
80104dd4:	83 c4 10             	add    $0x10,%esp
80104dd7:	85 c0                	test   %eax,%eax
80104dd9:	78 15                	js     80104df0 <sys_fstat+0x40>
  return filestat(f, st);
80104ddb:	83 ec 08             	sub    $0x8,%esp
80104dde:	ff 75 f4             	pushl  -0xc(%ebp)
80104de1:	ff 75 f0             	pushl  -0x10(%ebp)
80104de4:	e8 37 c1 ff ff       	call   80100f20 <filestat>
80104de9:	83 c4 10             	add    $0x10,%esp
}
80104dec:	c9                   	leave  
80104ded:	c3                   	ret    
80104dee:	66 90                	xchg   %ax,%ax
    return -1;
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104df5:	c9                   	leave  
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <sys_link>:
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	57                   	push   %edi
80104e04:	56                   	push   %esi
80104e05:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e06:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104e09:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e0c:	50                   	push   %eax
80104e0d:	6a 00                	push   $0x0
80104e0f:	e8 6c fb ff ff       	call   80104980 <argstr>
80104e14:	83 c4 10             	add    $0x10,%esp
80104e17:	85 c0                	test   %eax,%eax
80104e19:	0f 88 fb 00 00 00    	js     80104f1a <sys_link+0x11a>
80104e1f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e22:	83 ec 08             	sub    $0x8,%esp
80104e25:	50                   	push   %eax
80104e26:	6a 01                	push   $0x1
80104e28:	e8 53 fb ff ff       	call   80104980 <argstr>
80104e2d:	83 c4 10             	add    $0x10,%esp
80104e30:	85 c0                	test   %eax,%eax
80104e32:	0f 88 e2 00 00 00    	js     80104f1a <sys_link+0x11a>
  begin_op();
80104e38:	e8 83 dd ff ff       	call   80102bc0 <begin_op>
  if((ip = namei(old)) == 0){
80104e3d:	83 ec 0c             	sub    $0xc,%esp
80104e40:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e43:	e8 b8 d0 ff ff       	call   80101f00 <namei>
80104e48:	83 c4 10             	add    $0x10,%esp
80104e4b:	85 c0                	test   %eax,%eax
80104e4d:	89 c3                	mov    %eax,%ebx
80104e4f:	0f 84 ea 00 00 00    	je     80104f3f <sys_link+0x13f>
  ilock(ip);
80104e55:	83 ec 0c             	sub    $0xc,%esp
80104e58:	50                   	push   %eax
80104e59:	e8 42 c8 ff ff       	call   801016a0 <ilock>
  if(ip->type == T_DIR){
80104e5e:	83 c4 10             	add    $0x10,%esp
80104e61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e66:	0f 84 bb 00 00 00    	je     80104f27 <sys_link+0x127>
  ip->nlink++;
80104e6c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e71:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104e74:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104e77:	53                   	push   %ebx
80104e78:	e8 73 c7 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
80104e7d:	89 1c 24             	mov    %ebx,(%esp)
80104e80:	e8 fb c8 ff ff       	call   80101780 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104e85:	58                   	pop    %eax
80104e86:	5a                   	pop    %edx
80104e87:	57                   	push   %edi
80104e88:	ff 75 d0             	pushl  -0x30(%ebp)
80104e8b:	e8 90 d0 ff ff       	call   80101f20 <nameiparent>
80104e90:	83 c4 10             	add    $0x10,%esp
80104e93:	85 c0                	test   %eax,%eax
80104e95:	89 c6                	mov    %eax,%esi
80104e97:	74 5b                	je     80104ef4 <sys_link+0xf4>
  ilock(dp);
80104e99:	83 ec 0c             	sub    $0xc,%esp
80104e9c:	50                   	push   %eax
80104e9d:	e8 fe c7 ff ff       	call   801016a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ea2:	83 c4 10             	add    $0x10,%esp
80104ea5:	8b 03                	mov    (%ebx),%eax
80104ea7:	39 06                	cmp    %eax,(%esi)
80104ea9:	75 3d                	jne    80104ee8 <sys_link+0xe8>
80104eab:	83 ec 04             	sub    $0x4,%esp
80104eae:	ff 73 04             	pushl  0x4(%ebx)
80104eb1:	57                   	push   %edi
80104eb2:	56                   	push   %esi
80104eb3:	e8 88 cf ff ff       	call   80101e40 <dirlink>
80104eb8:	83 c4 10             	add    $0x10,%esp
80104ebb:	85 c0                	test   %eax,%eax
80104ebd:	78 29                	js     80104ee8 <sys_link+0xe8>
  iunlockput(dp);
80104ebf:	83 ec 0c             	sub    $0xc,%esp
80104ec2:	56                   	push   %esi
80104ec3:	e8 68 ca ff ff       	call   80101930 <iunlockput>
  iput(ip);
80104ec8:	89 1c 24             	mov    %ebx,(%esp)
80104ecb:	e8 00 c9 ff ff       	call   801017d0 <iput>
  end_op();
80104ed0:	e8 5b dd ff ff       	call   80102c30 <end_op>
  return 0;
80104ed5:	83 c4 10             	add    $0x10,%esp
80104ed8:	31 c0                	xor    %eax,%eax
}
80104eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104edd:	5b                   	pop    %ebx
80104ede:	5e                   	pop    %esi
80104edf:	5f                   	pop    %edi
80104ee0:	5d                   	pop    %ebp
80104ee1:	c3                   	ret    
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104ee8:	83 ec 0c             	sub    $0xc,%esp
80104eeb:	56                   	push   %esi
80104eec:	e8 3f ca ff ff       	call   80101930 <iunlockput>
    goto bad;
80104ef1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104ef4:	83 ec 0c             	sub    $0xc,%esp
80104ef7:	53                   	push   %ebx
80104ef8:	e8 a3 c7 ff ff       	call   801016a0 <ilock>
  ip->nlink--;
80104efd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f02:	89 1c 24             	mov    %ebx,(%esp)
80104f05:	e8 e6 c6 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104f0a:	89 1c 24             	mov    %ebx,(%esp)
80104f0d:	e8 1e ca ff ff       	call   80101930 <iunlockput>
  end_op();
80104f12:	e8 19 dd ff ff       	call   80102c30 <end_op>
  return -1;
80104f17:	83 c4 10             	add    $0x10,%esp
}
80104f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104f1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f22:	5b                   	pop    %ebx
80104f23:	5e                   	pop    %esi
80104f24:	5f                   	pop    %edi
80104f25:	5d                   	pop    %ebp
80104f26:	c3                   	ret    
    iunlockput(ip);
80104f27:	83 ec 0c             	sub    $0xc,%esp
80104f2a:	53                   	push   %ebx
80104f2b:	e8 00 ca ff ff       	call   80101930 <iunlockput>
    end_op();
80104f30:	e8 fb dc ff ff       	call   80102c30 <end_op>
    return -1;
80104f35:	83 c4 10             	add    $0x10,%esp
80104f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f3d:	eb 9b                	jmp    80104eda <sys_link+0xda>
    end_op();
80104f3f:	e8 ec dc ff ff       	call   80102c30 <end_op>
    return -1;
80104f44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f49:	eb 8f                	jmp    80104eda <sys_link+0xda>
80104f4b:	90                   	nop
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f50 <sys_unlink>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	56                   	push   %esi
80104f55:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80104f56:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f59:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104f5c:	50                   	push   %eax
80104f5d:	6a 00                	push   $0x0
80104f5f:	e8 1c fa ff ff       	call   80104980 <argstr>
80104f64:	83 c4 10             	add    $0x10,%esp
80104f67:	85 c0                	test   %eax,%eax
80104f69:	0f 88 77 01 00 00    	js     801050e6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80104f6f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80104f72:	e8 49 dc ff ff       	call   80102bc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f77:	83 ec 08             	sub    $0x8,%esp
80104f7a:	53                   	push   %ebx
80104f7b:	ff 75 c0             	pushl  -0x40(%ebp)
80104f7e:	e8 9d cf ff ff       	call   80101f20 <nameiparent>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	89 c6                	mov    %eax,%esi
80104f8a:	0f 84 60 01 00 00    	je     801050f0 <sys_unlink+0x1a0>
  ilock(dp);
80104f90:	83 ec 0c             	sub    $0xc,%esp
80104f93:	50                   	push   %eax
80104f94:	e8 07 c7 ff ff       	call   801016a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f99:	58                   	pop    %eax
80104f9a:	5a                   	pop    %edx
80104f9b:	68 b8 77 10 80       	push   $0x801077b8
80104fa0:	53                   	push   %ebx
80104fa1:	e8 0a cc ff ff       	call   80101bb0 <namecmp>
80104fa6:	83 c4 10             	add    $0x10,%esp
80104fa9:	85 c0                	test   %eax,%eax
80104fab:	0f 84 03 01 00 00    	je     801050b4 <sys_unlink+0x164>
80104fb1:	83 ec 08             	sub    $0x8,%esp
80104fb4:	68 b7 77 10 80       	push   $0x801077b7
80104fb9:	53                   	push   %ebx
80104fba:	e8 f1 cb ff ff       	call   80101bb0 <namecmp>
80104fbf:	83 c4 10             	add    $0x10,%esp
80104fc2:	85 c0                	test   %eax,%eax
80104fc4:	0f 84 ea 00 00 00    	je     801050b4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104fca:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104fcd:	83 ec 04             	sub    $0x4,%esp
80104fd0:	50                   	push   %eax
80104fd1:	53                   	push   %ebx
80104fd2:	56                   	push   %esi
80104fd3:	e8 f8 cb ff ff       	call   80101bd0 <dirlookup>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	89 c3                	mov    %eax,%ebx
80104fdf:	0f 84 cf 00 00 00    	je     801050b4 <sys_unlink+0x164>
  ilock(ip);
80104fe5:	83 ec 0c             	sub    $0xc,%esp
80104fe8:	50                   	push   %eax
80104fe9:	e8 b2 c6 ff ff       	call   801016a0 <ilock>
  if(ip->nlink < 1)
80104fee:	83 c4 10             	add    $0x10,%esp
80104ff1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104ff6:	0f 8e 10 01 00 00    	jle    8010510c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104ffc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105001:	74 6d                	je     80105070 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105003:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105006:	83 ec 04             	sub    $0x4,%esp
80105009:	6a 10                	push   $0x10
8010500b:	6a 00                	push   $0x0
8010500d:	50                   	push   %eax
8010500e:	e8 bd f5 ff ff       	call   801045d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105013:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105016:	6a 10                	push   $0x10
80105018:	ff 75 c4             	pushl  -0x3c(%ebp)
8010501b:	50                   	push   %eax
8010501c:	56                   	push   %esi
8010501d:	e8 5e ca ff ff       	call   80101a80 <writei>
80105022:	83 c4 20             	add    $0x20,%esp
80105025:	83 f8 10             	cmp    $0x10,%eax
80105028:	0f 85 eb 00 00 00    	jne    80105119 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010502e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105033:	0f 84 97 00 00 00    	je     801050d0 <sys_unlink+0x180>
  iunlockput(dp);
80105039:	83 ec 0c             	sub    $0xc,%esp
8010503c:	56                   	push   %esi
8010503d:	e8 ee c8 ff ff       	call   80101930 <iunlockput>
  ip->nlink--;
80105042:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105047:	89 1c 24             	mov    %ebx,(%esp)
8010504a:	e8 a1 c5 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
8010504f:	89 1c 24             	mov    %ebx,(%esp)
80105052:	e8 d9 c8 ff ff       	call   80101930 <iunlockput>
  end_op();
80105057:	e8 d4 db ff ff       	call   80102c30 <end_op>
  return 0;
8010505c:	83 c4 10             	add    $0x10,%esp
8010505f:	31 c0                	xor    %eax,%eax
}
80105061:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105064:	5b                   	pop    %ebx
80105065:	5e                   	pop    %esi
80105066:	5f                   	pop    %edi
80105067:	5d                   	pop    %ebp
80105068:	c3                   	ret    
80105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105070:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105074:	76 8d                	jbe    80105003 <sys_unlink+0xb3>
80105076:	bf 20 00 00 00       	mov    $0x20,%edi
8010507b:	eb 0f                	jmp    8010508c <sys_unlink+0x13c>
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
80105080:	83 c7 10             	add    $0x10,%edi
80105083:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105086:	0f 83 77 ff ff ff    	jae    80105003 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010508c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010508f:	6a 10                	push   $0x10
80105091:	57                   	push   %edi
80105092:	50                   	push   %eax
80105093:	53                   	push   %ebx
80105094:	e8 e7 c8 ff ff       	call   80101980 <readi>
80105099:	83 c4 10             	add    $0x10,%esp
8010509c:	83 f8 10             	cmp    $0x10,%eax
8010509f:	75 5e                	jne    801050ff <sys_unlink+0x1af>
    if(de.inum != 0)
801050a1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050a6:	74 d8                	je     80105080 <sys_unlink+0x130>
    iunlockput(ip);
801050a8:	83 ec 0c             	sub    $0xc,%esp
801050ab:	53                   	push   %ebx
801050ac:	e8 7f c8 ff ff       	call   80101930 <iunlockput>
    goto bad;
801050b1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801050b4:	83 ec 0c             	sub    $0xc,%esp
801050b7:	56                   	push   %esi
801050b8:	e8 73 c8 ff ff       	call   80101930 <iunlockput>
  end_op();
801050bd:	e8 6e db ff ff       	call   80102c30 <end_op>
  return -1;
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ca:	eb 95                	jmp    80105061 <sys_unlink+0x111>
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801050d0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801050d5:	83 ec 0c             	sub    $0xc,%esp
801050d8:	56                   	push   %esi
801050d9:	e8 12 c5 ff ff       	call   801015f0 <iupdate>
801050de:	83 c4 10             	add    $0x10,%esp
801050e1:	e9 53 ff ff ff       	jmp    80105039 <sys_unlink+0xe9>
    return -1;
801050e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050eb:	e9 71 ff ff ff       	jmp    80105061 <sys_unlink+0x111>
    end_op();
801050f0:	e8 3b db ff ff       	call   80102c30 <end_op>
    return -1;
801050f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fa:	e9 62 ff ff ff       	jmp    80105061 <sys_unlink+0x111>
      panic("isdirempty: readi");
801050ff:	83 ec 0c             	sub    $0xc,%esp
80105102:	68 dc 77 10 80       	push   $0x801077dc
80105107:	e8 84 b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	68 ca 77 10 80       	push   $0x801077ca
80105114:	e8 77 b2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105119:	83 ec 0c             	sub    $0xc,%esp
8010511c:	68 ee 77 10 80       	push   $0x801077ee
80105121:	e8 6a b2 ff ff       	call   80100390 <panic>
80105126:	8d 76 00             	lea    0x0(%esi),%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <sys_open>:

int
sys_open(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
80105135:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105136:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105139:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010513c:	50                   	push   %eax
8010513d:	6a 00                	push   $0x0
8010513f:	e8 3c f8 ff ff       	call   80104980 <argstr>
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	85 c0                	test   %eax,%eax
80105149:	0f 88 1d 01 00 00    	js     8010526c <sys_open+0x13c>
8010514f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105152:	83 ec 08             	sub    $0x8,%esp
80105155:	50                   	push   %eax
80105156:	6a 01                	push   $0x1
80105158:	e8 73 f7 ff ff       	call   801048d0 <argint>
8010515d:	83 c4 10             	add    $0x10,%esp
80105160:	85 c0                	test   %eax,%eax
80105162:	0f 88 04 01 00 00    	js     8010526c <sys_open+0x13c>
    return -1;

  begin_op();
80105168:	e8 53 da ff ff       	call   80102bc0 <begin_op>

  if(omode & O_CREATE){
8010516d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105171:	0f 85 a9 00 00 00    	jne    80105220 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105177:	83 ec 0c             	sub    $0xc,%esp
8010517a:	ff 75 e0             	pushl  -0x20(%ebp)
8010517d:	e8 7e cd ff ff       	call   80101f00 <namei>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	85 c0                	test   %eax,%eax
80105187:	89 c6                	mov    %eax,%esi
80105189:	0f 84 b2 00 00 00    	je     80105241 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010518f:	83 ec 0c             	sub    $0xc,%esp
80105192:	50                   	push   %eax
80105193:	e8 08 c5 ff ff       	call   801016a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105198:	83 c4 10             	add    $0x10,%esp
8010519b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801051a0:	0f 84 aa 00 00 00    	je     80105250 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051a6:	e8 e5 bb ff ff       	call   80100d90 <filealloc>
801051ab:	85 c0                	test   %eax,%eax
801051ad:	89 c7                	mov    %eax,%edi
801051af:	0f 84 a6 00 00 00    	je     8010525b <sys_open+0x12b>
  struct proc *curproc = myproc();
801051b5:	e8 56 e6 ff ff       	call   80103810 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051ba:	31 db                	xor    %ebx,%ebx
801051bc:	eb 0e                	jmp    801051cc <sys_open+0x9c>
801051be:	66 90                	xchg   %ax,%ax
801051c0:	83 c3 01             	add    $0x1,%ebx
801051c3:	83 fb 10             	cmp    $0x10,%ebx
801051c6:	0f 84 ac 00 00 00    	je     80105278 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801051cc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051d0:	85 d2                	test   %edx,%edx
801051d2:	75 ec                	jne    801051c0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801051d4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801051d7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801051db:	56                   	push   %esi
801051dc:	e8 9f c5 ff ff       	call   80101780 <iunlock>
  end_op();
801051e1:	e8 4a da ff ff       	call   80102c30 <end_op>

  f->type = FD_INODE;
801051e6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051ef:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801051f2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801051f5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801051fc:	89 d0                	mov    %edx,%eax
801051fe:	f7 d0                	not    %eax
80105200:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105203:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105206:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105209:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010520d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105210:	89 d8                	mov    %ebx,%eax
80105212:	5b                   	pop    %ebx
80105213:	5e                   	pop    %esi
80105214:	5f                   	pop    %edi
80105215:	5d                   	pop    %ebp
80105216:	c3                   	ret    
80105217:	89 f6                	mov    %esi,%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105226:	31 c9                	xor    %ecx,%ecx
80105228:	6a 00                	push   $0x0
8010522a:	ba 02 00 00 00       	mov    $0x2,%edx
8010522f:	e8 ec f7 ff ff       	call   80104a20 <create>
    if(ip == 0){
80105234:	83 c4 10             	add    $0x10,%esp
80105237:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105239:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010523b:	0f 85 65 ff ff ff    	jne    801051a6 <sys_open+0x76>
      end_op();
80105241:	e8 ea d9 ff ff       	call   80102c30 <end_op>
      return -1;
80105246:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010524b:	eb c0                	jmp    8010520d <sys_open+0xdd>
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105250:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105253:	85 c9                	test   %ecx,%ecx
80105255:	0f 84 4b ff ff ff    	je     801051a6 <sys_open+0x76>
    iunlockput(ip);
8010525b:	83 ec 0c             	sub    $0xc,%esp
8010525e:	56                   	push   %esi
8010525f:	e8 cc c6 ff ff       	call   80101930 <iunlockput>
    end_op();
80105264:	e8 c7 d9 ff ff       	call   80102c30 <end_op>
    return -1;
80105269:	83 c4 10             	add    $0x10,%esp
8010526c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105271:	eb 9a                	jmp    8010520d <sys_open+0xdd>
80105273:	90                   	nop
80105274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105278:	83 ec 0c             	sub    $0xc,%esp
8010527b:	57                   	push   %edi
8010527c:	e8 cf bb ff ff       	call   80100e50 <fileclose>
80105281:	83 c4 10             	add    $0x10,%esp
80105284:	eb d5                	jmp    8010525b <sys_open+0x12b>
80105286:	8d 76 00             	lea    0x0(%esi),%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_mkdir>:

int
sys_mkdir(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105296:	e8 25 d9 ff ff       	call   80102bc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010529b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010529e:	83 ec 08             	sub    $0x8,%esp
801052a1:	50                   	push   %eax
801052a2:	6a 00                	push   $0x0
801052a4:	e8 d7 f6 ff ff       	call   80104980 <argstr>
801052a9:	83 c4 10             	add    $0x10,%esp
801052ac:	85 c0                	test   %eax,%eax
801052ae:	78 30                	js     801052e0 <sys_mkdir+0x50>
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b6:	31 c9                	xor    %ecx,%ecx
801052b8:	6a 00                	push   $0x0
801052ba:	ba 01 00 00 00       	mov    $0x1,%edx
801052bf:	e8 5c f7 ff ff       	call   80104a20 <create>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	74 15                	je     801052e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052cb:	83 ec 0c             	sub    $0xc,%esp
801052ce:	50                   	push   %eax
801052cf:	e8 5c c6 ff ff       	call   80101930 <iunlockput>
  end_op();
801052d4:	e8 57 d9 ff ff       	call   80102c30 <end_op>
  return 0;
801052d9:	83 c4 10             	add    $0x10,%esp
801052dc:	31 c0                	xor    %eax,%eax
}
801052de:	c9                   	leave  
801052df:	c3                   	ret    
    end_op();
801052e0:	e8 4b d9 ff ff       	call   80102c30 <end_op>
    return -1;
801052e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ea:	c9                   	leave  
801052eb:	c3                   	ret    
801052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052f0 <sys_mknod>:

int
sys_mknod(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801052f6:	e8 c5 d8 ff ff       	call   80102bc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801052fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052fe:	83 ec 08             	sub    $0x8,%esp
80105301:	50                   	push   %eax
80105302:	6a 00                	push   $0x0
80105304:	e8 77 f6 ff ff       	call   80104980 <argstr>
80105309:	83 c4 10             	add    $0x10,%esp
8010530c:	85 c0                	test   %eax,%eax
8010530e:	78 60                	js     80105370 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105310:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105313:	83 ec 08             	sub    $0x8,%esp
80105316:	50                   	push   %eax
80105317:	6a 01                	push   $0x1
80105319:	e8 b2 f5 ff ff       	call   801048d0 <argint>
  if((argstr(0, &path)) < 0 ||
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	85 c0                	test   %eax,%eax
80105323:	78 4b                	js     80105370 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105325:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105328:	83 ec 08             	sub    $0x8,%esp
8010532b:	50                   	push   %eax
8010532c:	6a 02                	push   $0x2
8010532e:	e8 9d f5 ff ff       	call   801048d0 <argint>
     argint(1, &major) < 0 ||
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	78 36                	js     80105370 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010533a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010533e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105341:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105345:	ba 03 00 00 00       	mov    $0x3,%edx
8010534a:	50                   	push   %eax
8010534b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010534e:	e8 cd f6 ff ff       	call   80104a20 <create>
80105353:	83 c4 10             	add    $0x10,%esp
80105356:	85 c0                	test   %eax,%eax
80105358:	74 16                	je     80105370 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010535a:	83 ec 0c             	sub    $0xc,%esp
8010535d:	50                   	push   %eax
8010535e:	e8 cd c5 ff ff       	call   80101930 <iunlockput>
  end_op();
80105363:	e8 c8 d8 ff ff       	call   80102c30 <end_op>
  return 0;
80105368:	83 c4 10             	add    $0x10,%esp
8010536b:	31 c0                	xor    %eax,%eax
}
8010536d:	c9                   	leave  
8010536e:	c3                   	ret    
8010536f:	90                   	nop
    end_op();
80105370:	e8 bb d8 ff ff       	call   80102c30 <end_op>
    return -1;
80105375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010537a:	c9                   	leave  
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105380 <sys_chdir>:

int
sys_chdir(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	56                   	push   %esi
80105384:	53                   	push   %ebx
80105385:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105388:	e8 83 e4 ff ff       	call   80103810 <myproc>
8010538d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010538f:	e8 2c d8 ff ff       	call   80102bc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105394:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105397:	83 ec 08             	sub    $0x8,%esp
8010539a:	50                   	push   %eax
8010539b:	6a 00                	push   $0x0
8010539d:	e8 de f5 ff ff       	call   80104980 <argstr>
801053a2:	83 c4 10             	add    $0x10,%esp
801053a5:	85 c0                	test   %eax,%eax
801053a7:	78 77                	js     80105420 <sys_chdir+0xa0>
801053a9:	83 ec 0c             	sub    $0xc,%esp
801053ac:	ff 75 f4             	pushl  -0xc(%ebp)
801053af:	e8 4c cb ff ff       	call   80101f00 <namei>
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
801053b9:	89 c3                	mov    %eax,%ebx
801053bb:	74 63                	je     80105420 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801053bd:	83 ec 0c             	sub    $0xc,%esp
801053c0:	50                   	push   %eax
801053c1:	e8 da c2 ff ff       	call   801016a0 <ilock>
  if(ip->type != T_DIR){
801053c6:	83 c4 10             	add    $0x10,%esp
801053c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053ce:	75 30                	jne    80105400 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	53                   	push   %ebx
801053d4:	e8 a7 c3 ff ff       	call   80101780 <iunlock>
  iput(curproc->cwd);
801053d9:	58                   	pop    %eax
801053da:	ff 76 68             	pushl  0x68(%esi)
801053dd:	e8 ee c3 ff ff       	call   801017d0 <iput>
  end_op();
801053e2:	e8 49 d8 ff ff       	call   80102c30 <end_op>
  curproc->cwd = ip;
801053e7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	31 c0                	xor    %eax,%eax
}
801053ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053f2:	5b                   	pop    %ebx
801053f3:	5e                   	pop    %esi
801053f4:	5d                   	pop    %ebp
801053f5:	c3                   	ret    
801053f6:	8d 76 00             	lea    0x0(%esi),%esi
801053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105400:	83 ec 0c             	sub    $0xc,%esp
80105403:	53                   	push   %ebx
80105404:	e8 27 c5 ff ff       	call   80101930 <iunlockput>
    end_op();
80105409:	e8 22 d8 ff ff       	call   80102c30 <end_op>
    return -1;
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105416:	eb d7                	jmp    801053ef <sys_chdir+0x6f>
80105418:	90                   	nop
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105420:	e8 0b d8 ff ff       	call   80102c30 <end_op>
    return -1;
80105425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542a:	eb c3                	jmp    801053ef <sys_chdir+0x6f>
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105430 <sys_exec>:

int
sys_exec(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	56                   	push   %esi
80105435:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105436:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010543c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105442:	50                   	push   %eax
80105443:	6a 00                	push   $0x0
80105445:	e8 36 f5 ff ff       	call   80104980 <argstr>
8010544a:	83 c4 10             	add    $0x10,%esp
8010544d:	85 c0                	test   %eax,%eax
8010544f:	0f 88 87 00 00 00    	js     801054dc <sys_exec+0xac>
80105455:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010545b:	83 ec 08             	sub    $0x8,%esp
8010545e:	50                   	push   %eax
8010545f:	6a 01                	push   $0x1
80105461:	e8 6a f4 ff ff       	call   801048d0 <argint>
80105466:	83 c4 10             	add    $0x10,%esp
80105469:	85 c0                	test   %eax,%eax
8010546b:	78 6f                	js     801054dc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010546d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105473:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105476:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105478:	68 80 00 00 00       	push   $0x80
8010547d:	6a 00                	push   $0x0
8010547f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105485:	50                   	push   %eax
80105486:	e8 45 f1 ff ff       	call   801045d0 <memset>
8010548b:	83 c4 10             	add    $0x10,%esp
8010548e:	eb 2c                	jmp    801054bc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105490:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105496:	85 c0                	test   %eax,%eax
80105498:	74 56                	je     801054f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010549a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801054a0:	83 ec 08             	sub    $0x8,%esp
801054a3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801054a6:	52                   	push   %edx
801054a7:	50                   	push   %eax
801054a8:	e8 b3 f3 ff ff       	call   80104860 <fetchstr>
801054ad:	83 c4 10             	add    $0x10,%esp
801054b0:	85 c0                	test   %eax,%eax
801054b2:	78 28                	js     801054dc <sys_exec+0xac>
  for(i=0;; i++){
801054b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801054b7:	83 fb 20             	cmp    $0x20,%ebx
801054ba:	74 20                	je     801054dc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054bc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054c2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801054c9:	83 ec 08             	sub    $0x8,%esp
801054cc:	57                   	push   %edi
801054cd:	01 f0                	add    %esi,%eax
801054cf:	50                   	push   %eax
801054d0:	e8 4b f3 ff ff       	call   80104820 <fetchint>
801054d5:	83 c4 10             	add    $0x10,%esp
801054d8:	85 c0                	test   %eax,%eax
801054da:	79 b4                	jns    80105490 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801054dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801054df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054e4:	5b                   	pop    %ebx
801054e5:	5e                   	pop    %esi
801054e6:	5f                   	pop    %edi
801054e7:	5d                   	pop    %ebp
801054e8:	c3                   	ret    
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801054f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801054f6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801054f9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105500:	00 00 00 00 
  return exec(path, argv);
80105504:	50                   	push   %eax
80105505:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010550b:	e8 10 b5 ff ff       	call   80100a20 <exec>
80105510:	83 c4 10             	add    $0x10,%esp
}
80105513:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105516:	5b                   	pop    %ebx
80105517:	5e                   	pop    %esi
80105518:	5f                   	pop    %edi
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    
8010551b:	90                   	nop
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_pipe>:

int
sys_pipe(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	57                   	push   %edi
80105524:	56                   	push   %esi
80105525:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105526:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105529:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010552c:	6a 08                	push   $0x8
8010552e:	50                   	push   %eax
8010552f:	6a 00                	push   $0x0
80105531:	e8 ea f3 ff ff       	call   80104920 <argptr>
80105536:	83 c4 10             	add    $0x10,%esp
80105539:	85 c0                	test   %eax,%eax
8010553b:	0f 88 ae 00 00 00    	js     801055ef <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105541:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105544:	83 ec 08             	sub    $0x8,%esp
80105547:	50                   	push   %eax
80105548:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010554b:	50                   	push   %eax
8010554c:	e8 0f dd ff ff       	call   80103260 <pipealloc>
80105551:	83 c4 10             	add    $0x10,%esp
80105554:	85 c0                	test   %eax,%eax
80105556:	0f 88 93 00 00 00    	js     801055ef <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010555c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010555f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105561:	e8 aa e2 ff ff       	call   80103810 <myproc>
80105566:	eb 10                	jmp    80105578 <sys_pipe+0x58>
80105568:	90                   	nop
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105570:	83 c3 01             	add    $0x1,%ebx
80105573:	83 fb 10             	cmp    $0x10,%ebx
80105576:	74 60                	je     801055d8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105578:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010557c:	85 f6                	test   %esi,%esi
8010557e:	75 f0                	jne    80105570 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105580:	8d 73 08             	lea    0x8(%ebx),%esi
80105583:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105587:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010558a:	e8 81 e2 ff ff       	call   80103810 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010558f:	31 d2                	xor    %edx,%edx
80105591:	eb 0d                	jmp    801055a0 <sys_pipe+0x80>
80105593:	90                   	nop
80105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105598:	83 c2 01             	add    $0x1,%edx
8010559b:	83 fa 10             	cmp    $0x10,%edx
8010559e:	74 28                	je     801055c8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801055a0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801055a4:	85 c9                	test   %ecx,%ecx
801055a6:	75 f0                	jne    80105598 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801055a8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801055ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055af:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801055b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055b4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801055b7:	31 c0                	xor    %eax,%eax
}
801055b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055bc:	5b                   	pop    %ebx
801055bd:	5e                   	pop    %esi
801055be:	5f                   	pop    %edi
801055bf:	5d                   	pop    %ebp
801055c0:	c3                   	ret    
801055c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801055c8:	e8 43 e2 ff ff       	call   80103810 <myproc>
801055cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801055d4:	00 
801055d5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	ff 75 e0             	pushl  -0x20(%ebp)
801055de:	e8 6d b8 ff ff       	call   80100e50 <fileclose>
    fileclose(wf);
801055e3:	58                   	pop    %eax
801055e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801055e7:	e8 64 b8 ff ff       	call   80100e50 <fileclose>
    return -1;
801055ec:	83 c4 10             	add    $0x10,%esp
801055ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f4:	eb c3                	jmp    801055b9 <sys_pipe+0x99>
801055f6:	66 90                	xchg   %ax,%ax
801055f8:	66 90                	xchg   %ax,%ax
801055fa:	66 90                	xchg   %ax,%ax
801055fc:	66 90                	xchg   %ax,%ax
801055fe:	66 90                	xchg   %ax,%ax

80105600 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105603:	5d                   	pop    %ebp
  return fork();
80105604:	e9 a7 e4 ff ff       	jmp    80103ab0 <fork>
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_exit>:

int
sys_exit(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 08             	sub    $0x8,%esp
  exit();
80105616:	e8 95 e7 ff ff       	call   80103db0 <exit>
  return 0;  // not reached
}
8010561b:	31 c0                	xor    %eax,%eax
8010561d:	c9                   	leave  
8010561e:	c3                   	ret    
8010561f:	90                   	nop

80105620 <sys_wait>:

int
sys_wait(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105623:	5d                   	pop    %ebp
  return wait();
80105624:	e9 a7 e9 ff ff       	jmp    80103fd0 <wait>
80105629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105630 <sys_kill>:

int
sys_kill(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105636:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105639:	50                   	push   %eax
8010563a:	6a 00                	push   $0x0
8010563c:	e8 8f f2 ff ff       	call   801048d0 <argint>
80105641:	83 c4 10             	add    $0x10,%esp
80105644:	85 c0                	test   %eax,%eax
80105646:	78 18                	js     80105660 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	ff 75 f4             	pushl  -0xc(%ebp)
8010564e:	e8 ad ea ff ff       	call   80104100 <kill>
80105653:	83 c4 10             	add    $0x10,%esp
}
80105656:	c9                   	leave  
80105657:	c3                   	ret    
80105658:	90                   	nop
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105665:	c9                   	leave  
80105666:	c3                   	ret    
80105667:	89 f6                	mov    %esi,%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105670 <sys_getpid>:

int
sys_getpid(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105676:	e8 95 e1 ff ff       	call   80103810 <myproc>
8010567b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010567e:	c9                   	leave  
8010567f:	c3                   	ret    

80105680 <sys_sbrk>:

int
sys_sbrk(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105684:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105687:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010568a:	50                   	push   %eax
8010568b:	6a 00                	push   $0x0
8010568d:	e8 3e f2 ff ff       	call   801048d0 <argint>
80105692:	83 c4 10             	add    $0x10,%esp
80105695:	85 c0                	test   %eax,%eax
80105697:	78 27                	js     801056c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105699:	e8 72 e1 ff ff       	call   80103810 <myproc>
  if(growproc(n) < 0)
8010569e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801056a1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801056a3:	ff 75 f4             	pushl  -0xc(%ebp)
801056a6:	e8 85 e3 ff ff       	call   80103a30 <growproc>
801056ab:	83 c4 10             	add    $0x10,%esp
801056ae:	85 c0                	test   %eax,%eax
801056b0:	78 0e                	js     801056c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801056b2:	89 d8                	mov    %ebx,%eax
801056b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056b7:	c9                   	leave  
801056b8:	c3                   	ret    
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056c5:	eb eb                	jmp    801056b2 <sys_sbrk+0x32>
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056d0 <sys_sleep>:

int
sys_sleep(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801056d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801056d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801056da:	50                   	push   %eax
801056db:	6a 00                	push   $0x0
801056dd:	e8 ee f1 ff ff       	call   801048d0 <argint>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	85 c0                	test   %eax,%eax
801056e7:	0f 88 8a 00 00 00    	js     80105777 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801056ed:	83 ec 0c             	sub    $0xc,%esp
801056f0:	68 80 4f 11 80       	push   $0x80114f80
801056f5:	e8 56 ed ff ff       	call   80104450 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801056fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056fd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105700:	8b 1d c0 57 11 80    	mov    0x801157c0,%ebx
  while(ticks - ticks0 < n){
80105706:	85 d2                	test   %edx,%edx
80105708:	75 27                	jne    80105731 <sys_sleep+0x61>
8010570a:	eb 54                	jmp    80105760 <sys_sleep+0x90>
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105710:	83 ec 08             	sub    $0x8,%esp
80105713:	68 80 4f 11 80       	push   $0x80114f80
80105718:	68 c0 57 11 80       	push   $0x801157c0
8010571d:	e8 ee e7 ff ff       	call   80103f10 <sleep>
  while(ticks - ticks0 < n){
80105722:	a1 c0 57 11 80       	mov    0x801157c0,%eax
80105727:	83 c4 10             	add    $0x10,%esp
8010572a:	29 d8                	sub    %ebx,%eax
8010572c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010572f:	73 2f                	jae    80105760 <sys_sleep+0x90>
    if(myproc()->killed){
80105731:	e8 da e0 ff ff       	call   80103810 <myproc>
80105736:	8b 40 24             	mov    0x24(%eax),%eax
80105739:	85 c0                	test   %eax,%eax
8010573b:	74 d3                	je     80105710 <sys_sleep+0x40>
      release(&tickslock);
8010573d:	83 ec 0c             	sub    $0xc,%esp
80105740:	68 80 4f 11 80       	push   $0x80114f80
80105745:	e8 26 ee ff ff       	call   80104570 <release>
      return -1;
8010574a:	83 c4 10             	add    $0x10,%esp
8010574d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105752:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105755:	c9                   	leave  
80105756:	c3                   	ret    
80105757:	89 f6                	mov    %esi,%esi
80105759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	68 80 4f 11 80       	push   $0x80114f80
80105768:	e8 03 ee ff ff       	call   80104570 <release>
  return 0;
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	31 c0                	xor    %eax,%eax
}
80105772:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105775:	c9                   	leave  
80105776:	c3                   	ret    
    return -1;
80105777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577c:	eb f4                	jmp    80105772 <sys_sleep+0xa2>
8010577e:	66 90                	xchg   %ax,%ax

80105780 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
80105784:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105787:	68 80 4f 11 80       	push   $0x80114f80
8010578c:	e8 bf ec ff ff       	call   80104450 <acquire>
  xticks = ticks;
80105791:	8b 1d c0 57 11 80    	mov    0x801157c0,%ebx
  release(&tickslock);
80105797:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
8010579e:	e8 cd ed ff ff       	call   80104570 <release>
  return xticks;
}
801057a3:	89 d8                	mov    %ebx,%eax
801057a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057a8:	c9                   	leave  
801057a9:	c3                   	ret    
801057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057b0 <sys_trace>:

int
sys_trace(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->timepiece;
801057b6:	e8 55 e0 ff ff       	call   80103810 <myproc>
801057bb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
801057c1:	c9                   	leave  
801057c2:	c3                   	ret    

801057c3 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801057c3:	1e                   	push   %ds
  pushl %es
801057c4:	06                   	push   %es
  pushl %fs
801057c5:	0f a0                	push   %fs
  pushl %gs
801057c7:	0f a8                	push   %gs
  pushal
801057c9:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801057ca:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801057ce:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801057d0:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801057d2:	54                   	push   %esp
  call trap
801057d3:	e8 c8 00 00 00       	call   801058a0 <trap>
  addl $4, %esp
801057d8:	83 c4 04             	add    $0x4,%esp

801057db <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801057db:	61                   	popa   
  popl %gs
801057dc:	0f a9                	pop    %gs
  popl %fs
801057de:	0f a1                	pop    %fs
  popl %es
801057e0:	07                   	pop    %es
  popl %ds
801057e1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801057e2:	83 c4 08             	add    $0x8,%esp
  iret
801057e5:	cf                   	iret   
801057e6:	66 90                	xchg   %ax,%ax
801057e8:	66 90                	xchg   %ax,%ax
801057ea:	66 90                	xchg   %ax,%ax
801057ec:	66 90                	xchg   %ax,%ax
801057ee:	66 90                	xchg   %ax,%ax

801057f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801057f0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801057f1:	31 c0                	xor    %eax,%eax
{
801057f3:	89 e5                	mov    %esp,%ebp
801057f5:	83 ec 08             	sub    $0x8,%esp
801057f8:	90                   	nop
801057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105800:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105807:	c7 04 c5 c2 4f 11 80 	movl   $0x8e000008,-0x7feeb03e(,%eax,8)
8010580e:	08 00 00 8e 
80105812:	66 89 14 c5 c0 4f 11 	mov    %dx,-0x7feeb040(,%eax,8)
80105819:	80 
8010581a:	c1 ea 10             	shr    $0x10,%edx
8010581d:	66 89 14 c5 c6 4f 11 	mov    %dx,-0x7feeb03a(,%eax,8)
80105824:	80 
  for(i = 0; i < 256; i++)
80105825:	83 c0 01             	add    $0x1,%eax
80105828:	3d 00 01 00 00       	cmp    $0x100,%eax
8010582d:	75 d1                	jne    80105800 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010582f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105834:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105837:	c7 05 c2 51 11 80 08 	movl   $0xef000008,0x801151c2
8010583e:	00 00 ef 
  initlock(&tickslock, "time");
80105841:	68 fd 77 10 80       	push   $0x801077fd
80105846:	68 80 4f 11 80       	push   $0x80114f80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010584b:	66 a3 c0 51 11 80    	mov    %ax,0x801151c0
80105851:	c1 e8 10             	shr    $0x10,%eax
80105854:	66 a3 c6 51 11 80    	mov    %ax,0x801151c6
  initlock(&tickslock, "time");
8010585a:	e8 01 eb ff ff       	call   80104360 <initlock>
}
8010585f:	83 c4 10             	add    $0x10,%esp
80105862:	c9                   	leave  
80105863:	c3                   	ret    
80105864:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010586a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105870 <idtinit>:

void
idtinit(void)
{
80105870:	55                   	push   %ebp
  pd[0] = size-1;
80105871:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105876:	89 e5                	mov    %esp,%ebp
80105878:	83 ec 10             	sub    $0x10,%esp
8010587b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010587f:	b8 c0 4f 11 80       	mov    $0x80114fc0,%eax
80105884:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105888:	c1 e8 10             	shr    $0x10,%eax
8010588b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010588f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105892:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105895:	c9                   	leave  
80105896:	c3                   	ret    
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	57                   	push   %edi
801058a4:	56                   	push   %esi
801058a5:	53                   	push   %ebx
801058a6:	83 ec 1c             	sub    $0x1c,%esp
801058a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801058ac:	8b 47 30             	mov    0x30(%edi),%eax
801058af:	83 f8 40             	cmp    $0x40,%eax
801058b2:	0f 84 f0 00 00 00    	je     801059a8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801058b8:	83 e8 20             	sub    $0x20,%eax
801058bb:	83 f8 1f             	cmp    $0x1f,%eax
801058be:	77 10                	ja     801058d0 <trap+0x30>
801058c0:	ff 24 85 a4 78 10 80 	jmp    *-0x7fef875c(,%eax,4)
801058c7:	89 f6                	mov    %esi,%esi
801058c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801058d0:	e8 3b df ff ff       	call   80103810 <myproc>
801058d5:	85 c0                	test   %eax,%eax
801058d7:	8b 5f 38             	mov    0x38(%edi),%ebx
801058da:	0f 84 24 02 00 00    	je     80105b04 <trap+0x264>
801058e0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801058e4:	0f 84 1a 02 00 00    	je     80105b04 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801058ea:	0f 20 d1             	mov    %cr2,%ecx
801058ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058f0:	e8 fb de ff ff       	call   801037f0 <cpuid>
801058f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801058f8:	8b 47 34             	mov    0x34(%edi),%eax
801058fb:	8b 77 30             	mov    0x30(%edi),%esi
801058fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105901:	e8 0a df ff ff       	call   80103810 <myproc>
80105906:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105909:	e8 02 df ff ff       	call   80103810 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010590e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105911:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105914:	51                   	push   %ecx
80105915:	53                   	push   %ebx
80105916:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105917:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010591a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010591d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010591e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105921:	52                   	push   %edx
80105922:	ff 70 10             	pushl  0x10(%eax)
80105925:	68 60 78 10 80       	push   $0x80107860
8010592a:	e8 41 ad ff ff       	call   80100670 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010592f:	83 c4 20             	add    $0x20,%esp
80105932:	e8 d9 de ff ff       	call   80103810 <myproc>
80105937:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010593e:	e8 cd de ff ff       	call   80103810 <myproc>
80105943:	85 c0                	test   %eax,%eax
80105945:	74 1d                	je     80105964 <trap+0xc4>
80105947:	e8 c4 de ff ff       	call   80103810 <myproc>
8010594c:	8b 50 24             	mov    0x24(%eax),%edx
8010594f:	85 d2                	test   %edx,%edx
80105951:	74 11                	je     80105964 <trap+0xc4>
80105953:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105957:	83 e0 03             	and    $0x3,%eax
8010595a:	66 83 f8 03          	cmp    $0x3,%ax
8010595e:	0f 84 5c 01 00 00    	je     80105ac0 <trap+0x220>
    exit();

  //brand new
  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105964:	e8 a7 de ff ff       	call   80103810 <myproc>
80105969:	85 c0                	test   %eax,%eax
8010596b:	74 0b                	je     80105978 <trap+0xd8>
8010596d:	e8 9e de ff ff       	call   80103810 <myproc>
80105972:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105976:	74 68                	je     801059e0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER && (--myproc()->timepiece)<=0)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105978:	e8 93 de ff ff       	call   80103810 <myproc>
8010597d:	85 c0                	test   %eax,%eax
8010597f:	74 19                	je     8010599a <trap+0xfa>
80105981:	e8 8a de ff ff       	call   80103810 <myproc>
80105986:	8b 40 24             	mov    0x24(%eax),%eax
80105989:	85 c0                	test   %eax,%eax
8010598b:	74 0d                	je     8010599a <trap+0xfa>
8010598d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105991:	83 e0 03             	and    $0x3,%eax
80105994:	66 83 f8 03          	cmp    $0x3,%ax
80105998:	74 37                	je     801059d1 <trap+0x131>
    exit();
}
8010599a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010599d:	5b                   	pop    %ebx
8010599e:	5e                   	pop    %esi
8010599f:	5f                   	pop    %edi
801059a0:	5d                   	pop    %ebp
801059a1:	c3                   	ret    
801059a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801059a8:	e8 63 de ff ff       	call   80103810 <myproc>
801059ad:	8b 58 24             	mov    0x24(%eax),%ebx
801059b0:	85 db                	test   %ebx,%ebx
801059b2:	0f 85 f8 00 00 00    	jne    80105ab0 <trap+0x210>
    myproc()->tf = tf;
801059b8:	e8 53 de ff ff       	call   80103810 <myproc>
801059bd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801059c0:	e8 fb ef ff ff       	call   801049c0 <syscall>
    if(myproc()->killed)
801059c5:	e8 46 de ff ff       	call   80103810 <myproc>
801059ca:	8b 48 24             	mov    0x24(%eax),%ecx
801059cd:	85 c9                	test   %ecx,%ecx
801059cf:	74 c9                	je     8010599a <trap+0xfa>
}
801059d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059d4:	5b                   	pop    %ebx
801059d5:	5e                   	pop    %esi
801059d6:	5f                   	pop    %edi
801059d7:	5d                   	pop    %ebp
      exit();
801059d8:	e9 d3 e3 ff ff       	jmp    80103db0 <exit>
801059dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801059e0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801059e4:	75 92                	jne    80105978 <trap+0xd8>
     tf->trapno == T_IRQ0+IRQ_TIMER && (--myproc()->timepiece)<=0)
801059e6:	e8 25 de ff ff       	call   80103810 <myproc>
801059eb:	83 a8 84 00 00 00 01 	subl   $0x1,0x84(%eax)
801059f2:	75 84                	jne    80105978 <trap+0xd8>
    yield();
801059f4:	e8 a7 e4 ff ff       	call   80103ea0 <yield>
801059f9:	e9 7a ff ff ff       	jmp    80105978 <trap+0xd8>
801059fe:	66 90                	xchg   %ax,%ax
    if(cpuid() == 0){
80105a00:	e8 eb dd ff ff       	call   801037f0 <cpuid>
80105a05:	85 c0                	test   %eax,%eax
80105a07:	0f 84 c3 00 00 00    	je     80105ad0 <trap+0x230>
    lapiceoi();
80105a0d:	e8 5e cd ff ff       	call   80102770 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a12:	e8 f9 dd ff ff       	call   80103810 <myproc>
80105a17:	85 c0                	test   %eax,%eax
80105a19:	0f 85 28 ff ff ff    	jne    80105947 <trap+0xa7>
80105a1f:	e9 40 ff ff ff       	jmp    80105964 <trap+0xc4>
80105a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105a28:	e8 03 cc ff ff       	call   80102630 <kbdintr>
    lapiceoi();
80105a2d:	e8 3e cd ff ff       	call   80102770 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a32:	e8 d9 dd ff ff       	call   80103810 <myproc>
80105a37:	85 c0                	test   %eax,%eax
80105a39:	0f 85 08 ff ff ff    	jne    80105947 <trap+0xa7>
80105a3f:	e9 20 ff ff ff       	jmp    80105964 <trap+0xc4>
80105a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105a48:	e8 53 02 00 00       	call   80105ca0 <uartintr>
    lapiceoi();
80105a4d:	e8 1e cd ff ff       	call   80102770 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a52:	e8 b9 dd ff ff       	call   80103810 <myproc>
80105a57:	85 c0                	test   %eax,%eax
80105a59:	0f 85 e8 fe ff ff    	jne    80105947 <trap+0xa7>
80105a5f:	e9 00 ff ff ff       	jmp    80105964 <trap+0xc4>
80105a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a68:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105a6c:	8b 77 38             	mov    0x38(%edi),%esi
80105a6f:	e8 7c dd ff ff       	call   801037f0 <cpuid>
80105a74:	56                   	push   %esi
80105a75:	53                   	push   %ebx
80105a76:	50                   	push   %eax
80105a77:	68 08 78 10 80       	push   $0x80107808
80105a7c:	e8 ef ab ff ff       	call   80100670 <cprintf>
    lapiceoi();
80105a81:	e8 ea cc ff ff       	call   80102770 <lapiceoi>
    break;
80105a86:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a89:	e8 82 dd ff ff       	call   80103810 <myproc>
80105a8e:	85 c0                	test   %eax,%eax
80105a90:	0f 85 b1 fe ff ff    	jne    80105947 <trap+0xa7>
80105a96:	e9 c9 fe ff ff       	jmp    80105964 <trap+0xc4>
80105a9b:	90                   	nop
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105aa0:	e8 fb c5 ff ff       	call   801020a0 <ideintr>
80105aa5:	e9 63 ff ff ff       	jmp    80105a0d <trap+0x16d>
80105aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105ab0:	e8 fb e2 ff ff       	call   80103db0 <exit>
80105ab5:	e9 fe fe ff ff       	jmp    801059b8 <trap+0x118>
80105aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105ac0:	e8 eb e2 ff ff       	call   80103db0 <exit>
80105ac5:	e9 9a fe ff ff       	jmp    80105964 <trap+0xc4>
80105aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	68 80 4f 11 80       	push   $0x80114f80
80105ad8:	e8 73 e9 ff ff       	call   80104450 <acquire>
      wakeup(&ticks);
80105add:	c7 04 24 c0 57 11 80 	movl   $0x801157c0,(%esp)
      ticks++;
80105ae4:	83 05 c0 57 11 80 01 	addl   $0x1,0x801157c0
      wakeup(&ticks);
80105aeb:	e8 e0 e5 ff ff       	call   801040d0 <wakeup>
      release(&tickslock);
80105af0:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105af7:	e8 74 ea ff ff       	call   80104570 <release>
80105afc:	83 c4 10             	add    $0x10,%esp
80105aff:	e9 09 ff ff ff       	jmp    80105a0d <trap+0x16d>
80105b04:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b07:	e8 e4 dc ff ff       	call   801037f0 <cpuid>
80105b0c:	83 ec 0c             	sub    $0xc,%esp
80105b0f:	56                   	push   %esi
80105b10:	53                   	push   %ebx
80105b11:	50                   	push   %eax
80105b12:	ff 77 30             	pushl  0x30(%edi)
80105b15:	68 2c 78 10 80       	push   $0x8010782c
80105b1a:	e8 51 ab ff ff       	call   80100670 <cprintf>
      panic("trap");
80105b1f:	83 c4 14             	add    $0x14,%esp
80105b22:	68 02 78 10 80       	push   $0x80107802
80105b27:	e8 64 a8 ff ff       	call   80100390 <panic>
80105b2c:	66 90                	xchg   %ax,%ax
80105b2e:	66 90                	xchg   %ax,%ax

80105b30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105b30:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105b35:	55                   	push   %ebp
80105b36:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105b38:	85 c0                	test   %eax,%eax
80105b3a:	74 1c                	je     80105b58 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b3c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b41:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105b42:	a8 01                	test   $0x1,%al
80105b44:	74 12                	je     80105b58 <uartgetc+0x28>
80105b46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b4b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105b4c:	0f b6 c0             	movzbl %al,%eax
}
80105b4f:	5d                   	pop    %ebp
80105b50:	c3                   	ret    
80105b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b5d:	5d                   	pop    %ebp
80105b5e:	c3                   	ret    
80105b5f:	90                   	nop

80105b60 <uartputc.part.0>:
uartputc(int c)
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
80105b66:	89 c7                	mov    %eax,%edi
80105b68:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b72:	83 ec 0c             	sub    $0xc,%esp
80105b75:	eb 1b                	jmp    80105b92 <uartputc.part.0+0x32>
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	6a 0a                	push   $0xa
80105b85:	e8 06 cc ff ff       	call   80102790 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	83 eb 01             	sub    $0x1,%ebx
80105b90:	74 07                	je     80105b99 <uartputc.part.0+0x39>
80105b92:	89 f2                	mov    %esi,%edx
80105b94:	ec                   	in     (%dx),%al
80105b95:	a8 20                	test   $0x20,%al
80105b97:	74 e7                	je     80105b80 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b9e:	89 f8                	mov    %edi,%eax
80105ba0:	ee                   	out    %al,(%dx)
}
80105ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba4:	5b                   	pop    %ebx
80105ba5:	5e                   	pop    %esi
80105ba6:	5f                   	pop    %edi
80105ba7:	5d                   	pop    %ebp
80105ba8:	c3                   	ret    
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <uartinit>:
{
80105bb0:	55                   	push   %ebp
80105bb1:	31 c9                	xor    %ecx,%ecx
80105bb3:	89 c8                	mov    %ecx,%eax
80105bb5:	89 e5                	mov    %esp,%ebp
80105bb7:	57                   	push   %edi
80105bb8:	56                   	push   %esi
80105bb9:	53                   	push   %ebx
80105bba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105bbf:	89 da                	mov    %ebx,%edx
80105bc1:	83 ec 0c             	sub    $0xc,%esp
80105bc4:	ee                   	out    %al,(%dx)
80105bc5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105bca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105bcf:	89 fa                	mov    %edi,%edx
80105bd1:	ee                   	out    %al,(%dx)
80105bd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105bd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bdc:	ee                   	out    %al,(%dx)
80105bdd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105be2:	89 c8                	mov    %ecx,%eax
80105be4:	89 f2                	mov    %esi,%edx
80105be6:	ee                   	out    %al,(%dx)
80105be7:	b8 03 00 00 00       	mov    $0x3,%eax
80105bec:	89 fa                	mov    %edi,%edx
80105bee:	ee                   	out    %al,(%dx)
80105bef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105bf4:	89 c8                	mov    %ecx,%eax
80105bf6:	ee                   	out    %al,(%dx)
80105bf7:	b8 01 00 00 00       	mov    $0x1,%eax
80105bfc:	89 f2                	mov    %esi,%edx
80105bfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105bff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c04:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105c05:	3c ff                	cmp    $0xff,%al
80105c07:	74 5a                	je     80105c63 <uartinit+0xb3>
  uart = 1;
80105c09:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105c10:	00 00 00 
80105c13:	89 da                	mov    %ebx,%edx
80105c15:	ec                   	in     (%dx),%al
80105c16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c1b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105c1c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105c1f:	bb 24 79 10 80       	mov    $0x80107924,%ebx
  ioapicenable(IRQ_COM1, 0);
80105c24:	6a 00                	push   $0x0
80105c26:	6a 04                	push   $0x4
80105c28:	e8 c3 c6 ff ff       	call   801022f0 <ioapicenable>
80105c2d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105c30:	b8 78 00 00 00       	mov    $0x78,%eax
80105c35:	eb 13                	jmp    80105c4a <uartinit+0x9a>
80105c37:	89 f6                	mov    %esi,%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c40:	83 c3 01             	add    $0x1,%ebx
80105c43:	0f be 03             	movsbl (%ebx),%eax
80105c46:	84 c0                	test   %al,%al
80105c48:	74 19                	je     80105c63 <uartinit+0xb3>
  if(!uart)
80105c4a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105c50:	85 d2                	test   %edx,%edx
80105c52:	74 ec                	je     80105c40 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105c54:	83 c3 01             	add    $0x1,%ebx
80105c57:	e8 04 ff ff ff       	call   80105b60 <uartputc.part.0>
80105c5c:	0f be 03             	movsbl (%ebx),%eax
80105c5f:	84 c0                	test   %al,%al
80105c61:	75 e7                	jne    80105c4a <uartinit+0x9a>
}
80105c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c66:	5b                   	pop    %ebx
80105c67:	5e                   	pop    %esi
80105c68:	5f                   	pop    %edi
80105c69:	5d                   	pop    %ebp
80105c6a:	c3                   	ret    
80105c6b:	90                   	nop
80105c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c70 <uartputc>:
  if(!uart)
80105c70:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105c76:	55                   	push   %ebp
80105c77:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105c79:	85 d2                	test   %edx,%edx
{
80105c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105c7e:	74 10                	je     80105c90 <uartputc+0x20>
}
80105c80:	5d                   	pop    %ebp
80105c81:	e9 da fe ff ff       	jmp    80105b60 <uartputc.part.0>
80105c86:	8d 76 00             	lea    0x0(%esi),%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c90:	5d                   	pop    %ebp
80105c91:	c3                   	ret    
80105c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ca0 <uartintr>:

void
uartintr(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105ca6:	68 30 5b 10 80       	push   $0x80105b30
80105cab:	e8 70 ab ff ff       	call   80100820 <consoleintr>
}
80105cb0:	83 c4 10             	add    $0x10,%esp
80105cb3:	c9                   	leave  
80105cb4:	c3                   	ret    

80105cb5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105cb5:	6a 00                	push   $0x0
  pushl $0
80105cb7:	6a 00                	push   $0x0
  jmp alltraps
80105cb9:	e9 05 fb ff ff       	jmp    801057c3 <alltraps>

80105cbe <vector1>:
.globl vector1
vector1:
  pushl $0
80105cbe:	6a 00                	push   $0x0
  pushl $1
80105cc0:	6a 01                	push   $0x1
  jmp alltraps
80105cc2:	e9 fc fa ff ff       	jmp    801057c3 <alltraps>

80105cc7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105cc7:	6a 00                	push   $0x0
  pushl $2
80105cc9:	6a 02                	push   $0x2
  jmp alltraps
80105ccb:	e9 f3 fa ff ff       	jmp    801057c3 <alltraps>

80105cd0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $3
80105cd2:	6a 03                	push   $0x3
  jmp alltraps
80105cd4:	e9 ea fa ff ff       	jmp    801057c3 <alltraps>

80105cd9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $4
80105cdb:	6a 04                	push   $0x4
  jmp alltraps
80105cdd:	e9 e1 fa ff ff       	jmp    801057c3 <alltraps>

80105ce2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ce2:	6a 00                	push   $0x0
  pushl $5
80105ce4:	6a 05                	push   $0x5
  jmp alltraps
80105ce6:	e9 d8 fa ff ff       	jmp    801057c3 <alltraps>

80105ceb <vector6>:
.globl vector6
vector6:
  pushl $0
80105ceb:	6a 00                	push   $0x0
  pushl $6
80105ced:	6a 06                	push   $0x6
  jmp alltraps
80105cef:	e9 cf fa ff ff       	jmp    801057c3 <alltraps>

80105cf4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $7
80105cf6:	6a 07                	push   $0x7
  jmp alltraps
80105cf8:	e9 c6 fa ff ff       	jmp    801057c3 <alltraps>

80105cfd <vector8>:
.globl vector8
vector8:
  pushl $8
80105cfd:	6a 08                	push   $0x8
  jmp alltraps
80105cff:	e9 bf fa ff ff       	jmp    801057c3 <alltraps>

80105d04 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $9
80105d06:	6a 09                	push   $0x9
  jmp alltraps
80105d08:	e9 b6 fa ff ff       	jmp    801057c3 <alltraps>

80105d0d <vector10>:
.globl vector10
vector10:
  pushl $10
80105d0d:	6a 0a                	push   $0xa
  jmp alltraps
80105d0f:	e9 af fa ff ff       	jmp    801057c3 <alltraps>

80105d14 <vector11>:
.globl vector11
vector11:
  pushl $11
80105d14:	6a 0b                	push   $0xb
  jmp alltraps
80105d16:	e9 a8 fa ff ff       	jmp    801057c3 <alltraps>

80105d1b <vector12>:
.globl vector12
vector12:
  pushl $12
80105d1b:	6a 0c                	push   $0xc
  jmp alltraps
80105d1d:	e9 a1 fa ff ff       	jmp    801057c3 <alltraps>

80105d22 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d22:	6a 0d                	push   $0xd
  jmp alltraps
80105d24:	e9 9a fa ff ff       	jmp    801057c3 <alltraps>

80105d29 <vector14>:
.globl vector14
vector14:
  pushl $14
80105d29:	6a 0e                	push   $0xe
  jmp alltraps
80105d2b:	e9 93 fa ff ff       	jmp    801057c3 <alltraps>

80105d30 <vector15>:
.globl vector15
vector15:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $15
80105d32:	6a 0f                	push   $0xf
  jmp alltraps
80105d34:	e9 8a fa ff ff       	jmp    801057c3 <alltraps>

80105d39 <vector16>:
.globl vector16
vector16:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $16
80105d3b:	6a 10                	push   $0x10
  jmp alltraps
80105d3d:	e9 81 fa ff ff       	jmp    801057c3 <alltraps>

80105d42 <vector17>:
.globl vector17
vector17:
  pushl $17
80105d42:	6a 11                	push   $0x11
  jmp alltraps
80105d44:	e9 7a fa ff ff       	jmp    801057c3 <alltraps>

80105d49 <vector18>:
.globl vector18
vector18:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $18
80105d4b:	6a 12                	push   $0x12
  jmp alltraps
80105d4d:	e9 71 fa ff ff       	jmp    801057c3 <alltraps>

80105d52 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $19
80105d54:	6a 13                	push   $0x13
  jmp alltraps
80105d56:	e9 68 fa ff ff       	jmp    801057c3 <alltraps>

80105d5b <vector20>:
.globl vector20
vector20:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $20
80105d5d:	6a 14                	push   $0x14
  jmp alltraps
80105d5f:	e9 5f fa ff ff       	jmp    801057c3 <alltraps>

80105d64 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $21
80105d66:	6a 15                	push   $0x15
  jmp alltraps
80105d68:	e9 56 fa ff ff       	jmp    801057c3 <alltraps>

80105d6d <vector22>:
.globl vector22
vector22:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $22
80105d6f:	6a 16                	push   $0x16
  jmp alltraps
80105d71:	e9 4d fa ff ff       	jmp    801057c3 <alltraps>

80105d76 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $23
80105d78:	6a 17                	push   $0x17
  jmp alltraps
80105d7a:	e9 44 fa ff ff       	jmp    801057c3 <alltraps>

80105d7f <vector24>:
.globl vector24
vector24:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $24
80105d81:	6a 18                	push   $0x18
  jmp alltraps
80105d83:	e9 3b fa ff ff       	jmp    801057c3 <alltraps>

80105d88 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d88:	6a 00                	push   $0x0
  pushl $25
80105d8a:	6a 19                	push   $0x19
  jmp alltraps
80105d8c:	e9 32 fa ff ff       	jmp    801057c3 <alltraps>

80105d91 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d91:	6a 00                	push   $0x0
  pushl $26
80105d93:	6a 1a                	push   $0x1a
  jmp alltraps
80105d95:	e9 29 fa ff ff       	jmp    801057c3 <alltraps>

80105d9a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $27
80105d9c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d9e:	e9 20 fa ff ff       	jmp    801057c3 <alltraps>

80105da3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $28
80105da5:	6a 1c                	push   $0x1c
  jmp alltraps
80105da7:	e9 17 fa ff ff       	jmp    801057c3 <alltraps>

80105dac <vector29>:
.globl vector29
vector29:
  pushl $0
80105dac:	6a 00                	push   $0x0
  pushl $29
80105dae:	6a 1d                	push   $0x1d
  jmp alltraps
80105db0:	e9 0e fa ff ff       	jmp    801057c3 <alltraps>

80105db5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $30
80105db7:	6a 1e                	push   $0x1e
  jmp alltraps
80105db9:	e9 05 fa ff ff       	jmp    801057c3 <alltraps>

80105dbe <vector31>:
.globl vector31
vector31:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $31
80105dc0:	6a 1f                	push   $0x1f
  jmp alltraps
80105dc2:	e9 fc f9 ff ff       	jmp    801057c3 <alltraps>

80105dc7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $32
80105dc9:	6a 20                	push   $0x20
  jmp alltraps
80105dcb:	e9 f3 f9 ff ff       	jmp    801057c3 <alltraps>

80105dd0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $33
80105dd2:	6a 21                	push   $0x21
  jmp alltraps
80105dd4:	e9 ea f9 ff ff       	jmp    801057c3 <alltraps>

80105dd9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $34
80105ddb:	6a 22                	push   $0x22
  jmp alltraps
80105ddd:	e9 e1 f9 ff ff       	jmp    801057c3 <alltraps>

80105de2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $35
80105de4:	6a 23                	push   $0x23
  jmp alltraps
80105de6:	e9 d8 f9 ff ff       	jmp    801057c3 <alltraps>

80105deb <vector36>:
.globl vector36
vector36:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $36
80105ded:	6a 24                	push   $0x24
  jmp alltraps
80105def:	e9 cf f9 ff ff       	jmp    801057c3 <alltraps>

80105df4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $37
80105df6:	6a 25                	push   $0x25
  jmp alltraps
80105df8:	e9 c6 f9 ff ff       	jmp    801057c3 <alltraps>

80105dfd <vector38>:
.globl vector38
vector38:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $38
80105dff:	6a 26                	push   $0x26
  jmp alltraps
80105e01:	e9 bd f9 ff ff       	jmp    801057c3 <alltraps>

80105e06 <vector39>:
.globl vector39
vector39:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $39
80105e08:	6a 27                	push   $0x27
  jmp alltraps
80105e0a:	e9 b4 f9 ff ff       	jmp    801057c3 <alltraps>

80105e0f <vector40>:
.globl vector40
vector40:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $40
80105e11:	6a 28                	push   $0x28
  jmp alltraps
80105e13:	e9 ab f9 ff ff       	jmp    801057c3 <alltraps>

80105e18 <vector41>:
.globl vector41
vector41:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $41
80105e1a:	6a 29                	push   $0x29
  jmp alltraps
80105e1c:	e9 a2 f9 ff ff       	jmp    801057c3 <alltraps>

80105e21 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e21:	6a 00                	push   $0x0
  pushl $42
80105e23:	6a 2a                	push   $0x2a
  jmp alltraps
80105e25:	e9 99 f9 ff ff       	jmp    801057c3 <alltraps>

80105e2a <vector43>:
.globl vector43
vector43:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $43
80105e2c:	6a 2b                	push   $0x2b
  jmp alltraps
80105e2e:	e9 90 f9 ff ff       	jmp    801057c3 <alltraps>

80105e33 <vector44>:
.globl vector44
vector44:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $44
80105e35:	6a 2c                	push   $0x2c
  jmp alltraps
80105e37:	e9 87 f9 ff ff       	jmp    801057c3 <alltraps>

80105e3c <vector45>:
.globl vector45
vector45:
  pushl $0
80105e3c:	6a 00                	push   $0x0
  pushl $45
80105e3e:	6a 2d                	push   $0x2d
  jmp alltraps
80105e40:	e9 7e f9 ff ff       	jmp    801057c3 <alltraps>

80105e45 <vector46>:
.globl vector46
vector46:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $46
80105e47:	6a 2e                	push   $0x2e
  jmp alltraps
80105e49:	e9 75 f9 ff ff       	jmp    801057c3 <alltraps>

80105e4e <vector47>:
.globl vector47
vector47:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $47
80105e50:	6a 2f                	push   $0x2f
  jmp alltraps
80105e52:	e9 6c f9 ff ff       	jmp    801057c3 <alltraps>

80105e57 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $48
80105e59:	6a 30                	push   $0x30
  jmp alltraps
80105e5b:	e9 63 f9 ff ff       	jmp    801057c3 <alltraps>

80105e60 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $49
80105e62:	6a 31                	push   $0x31
  jmp alltraps
80105e64:	e9 5a f9 ff ff       	jmp    801057c3 <alltraps>

80105e69 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $50
80105e6b:	6a 32                	push   $0x32
  jmp alltraps
80105e6d:	e9 51 f9 ff ff       	jmp    801057c3 <alltraps>

80105e72 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $51
80105e74:	6a 33                	push   $0x33
  jmp alltraps
80105e76:	e9 48 f9 ff ff       	jmp    801057c3 <alltraps>

80105e7b <vector52>:
.globl vector52
vector52:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $52
80105e7d:	6a 34                	push   $0x34
  jmp alltraps
80105e7f:	e9 3f f9 ff ff       	jmp    801057c3 <alltraps>

80105e84 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $53
80105e86:	6a 35                	push   $0x35
  jmp alltraps
80105e88:	e9 36 f9 ff ff       	jmp    801057c3 <alltraps>

80105e8d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e8d:	6a 00                	push   $0x0
  pushl $54
80105e8f:	6a 36                	push   $0x36
  jmp alltraps
80105e91:	e9 2d f9 ff ff       	jmp    801057c3 <alltraps>

80105e96 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $55
80105e98:	6a 37                	push   $0x37
  jmp alltraps
80105e9a:	e9 24 f9 ff ff       	jmp    801057c3 <alltraps>

80105e9f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $56
80105ea1:	6a 38                	push   $0x38
  jmp alltraps
80105ea3:	e9 1b f9 ff ff       	jmp    801057c3 <alltraps>

80105ea8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $57
80105eaa:	6a 39                	push   $0x39
  jmp alltraps
80105eac:	e9 12 f9 ff ff       	jmp    801057c3 <alltraps>

80105eb1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105eb1:	6a 00                	push   $0x0
  pushl $58
80105eb3:	6a 3a                	push   $0x3a
  jmp alltraps
80105eb5:	e9 09 f9 ff ff       	jmp    801057c3 <alltraps>

80105eba <vector59>:
.globl vector59
vector59:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $59
80105ebc:	6a 3b                	push   $0x3b
  jmp alltraps
80105ebe:	e9 00 f9 ff ff       	jmp    801057c3 <alltraps>

80105ec3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $60
80105ec5:	6a 3c                	push   $0x3c
  jmp alltraps
80105ec7:	e9 f7 f8 ff ff       	jmp    801057c3 <alltraps>

80105ecc <vector61>:
.globl vector61
vector61:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $61
80105ece:	6a 3d                	push   $0x3d
  jmp alltraps
80105ed0:	e9 ee f8 ff ff       	jmp    801057c3 <alltraps>

80105ed5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ed5:	6a 00                	push   $0x0
  pushl $62
80105ed7:	6a 3e                	push   $0x3e
  jmp alltraps
80105ed9:	e9 e5 f8 ff ff       	jmp    801057c3 <alltraps>

80105ede <vector63>:
.globl vector63
vector63:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $63
80105ee0:	6a 3f                	push   $0x3f
  jmp alltraps
80105ee2:	e9 dc f8 ff ff       	jmp    801057c3 <alltraps>

80105ee7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $64
80105ee9:	6a 40                	push   $0x40
  jmp alltraps
80105eeb:	e9 d3 f8 ff ff       	jmp    801057c3 <alltraps>

80105ef0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $65
80105ef2:	6a 41                	push   $0x41
  jmp alltraps
80105ef4:	e9 ca f8 ff ff       	jmp    801057c3 <alltraps>

80105ef9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $66
80105efb:	6a 42                	push   $0x42
  jmp alltraps
80105efd:	e9 c1 f8 ff ff       	jmp    801057c3 <alltraps>

80105f02 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $67
80105f04:	6a 43                	push   $0x43
  jmp alltraps
80105f06:	e9 b8 f8 ff ff       	jmp    801057c3 <alltraps>

80105f0b <vector68>:
.globl vector68
vector68:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $68
80105f0d:	6a 44                	push   $0x44
  jmp alltraps
80105f0f:	e9 af f8 ff ff       	jmp    801057c3 <alltraps>

80105f14 <vector69>:
.globl vector69
vector69:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $69
80105f16:	6a 45                	push   $0x45
  jmp alltraps
80105f18:	e9 a6 f8 ff ff       	jmp    801057c3 <alltraps>

80105f1d <vector70>:
.globl vector70
vector70:
  pushl $0
80105f1d:	6a 00                	push   $0x0
  pushl $70
80105f1f:	6a 46                	push   $0x46
  jmp alltraps
80105f21:	e9 9d f8 ff ff       	jmp    801057c3 <alltraps>

80105f26 <vector71>:
.globl vector71
vector71:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $71
80105f28:	6a 47                	push   $0x47
  jmp alltraps
80105f2a:	e9 94 f8 ff ff       	jmp    801057c3 <alltraps>

80105f2f <vector72>:
.globl vector72
vector72:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $72
80105f31:	6a 48                	push   $0x48
  jmp alltraps
80105f33:	e9 8b f8 ff ff       	jmp    801057c3 <alltraps>

80105f38 <vector73>:
.globl vector73
vector73:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $73
80105f3a:	6a 49                	push   $0x49
  jmp alltraps
80105f3c:	e9 82 f8 ff ff       	jmp    801057c3 <alltraps>

80105f41 <vector74>:
.globl vector74
vector74:
  pushl $0
80105f41:	6a 00                	push   $0x0
  pushl $74
80105f43:	6a 4a                	push   $0x4a
  jmp alltraps
80105f45:	e9 79 f8 ff ff       	jmp    801057c3 <alltraps>

80105f4a <vector75>:
.globl vector75
vector75:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $75
80105f4c:	6a 4b                	push   $0x4b
  jmp alltraps
80105f4e:	e9 70 f8 ff ff       	jmp    801057c3 <alltraps>

80105f53 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $76
80105f55:	6a 4c                	push   $0x4c
  jmp alltraps
80105f57:	e9 67 f8 ff ff       	jmp    801057c3 <alltraps>

80105f5c <vector77>:
.globl vector77
vector77:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $77
80105f5e:	6a 4d                	push   $0x4d
  jmp alltraps
80105f60:	e9 5e f8 ff ff       	jmp    801057c3 <alltraps>

80105f65 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f65:	6a 00                	push   $0x0
  pushl $78
80105f67:	6a 4e                	push   $0x4e
  jmp alltraps
80105f69:	e9 55 f8 ff ff       	jmp    801057c3 <alltraps>

80105f6e <vector79>:
.globl vector79
vector79:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $79
80105f70:	6a 4f                	push   $0x4f
  jmp alltraps
80105f72:	e9 4c f8 ff ff       	jmp    801057c3 <alltraps>

80105f77 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $80
80105f79:	6a 50                	push   $0x50
  jmp alltraps
80105f7b:	e9 43 f8 ff ff       	jmp    801057c3 <alltraps>

80105f80 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $81
80105f82:	6a 51                	push   $0x51
  jmp alltraps
80105f84:	e9 3a f8 ff ff       	jmp    801057c3 <alltraps>

80105f89 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $82
80105f8b:	6a 52                	push   $0x52
  jmp alltraps
80105f8d:	e9 31 f8 ff ff       	jmp    801057c3 <alltraps>

80105f92 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $83
80105f94:	6a 53                	push   $0x53
  jmp alltraps
80105f96:	e9 28 f8 ff ff       	jmp    801057c3 <alltraps>

80105f9b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $84
80105f9d:	6a 54                	push   $0x54
  jmp alltraps
80105f9f:	e9 1f f8 ff ff       	jmp    801057c3 <alltraps>

80105fa4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $85
80105fa6:	6a 55                	push   $0x55
  jmp alltraps
80105fa8:	e9 16 f8 ff ff       	jmp    801057c3 <alltraps>

80105fad <vector86>:
.globl vector86
vector86:
  pushl $0
80105fad:	6a 00                	push   $0x0
  pushl $86
80105faf:	6a 56                	push   $0x56
  jmp alltraps
80105fb1:	e9 0d f8 ff ff       	jmp    801057c3 <alltraps>

80105fb6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $87
80105fb8:	6a 57                	push   $0x57
  jmp alltraps
80105fba:	e9 04 f8 ff ff       	jmp    801057c3 <alltraps>

80105fbf <vector88>:
.globl vector88
vector88:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $88
80105fc1:	6a 58                	push   $0x58
  jmp alltraps
80105fc3:	e9 fb f7 ff ff       	jmp    801057c3 <alltraps>

80105fc8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $89
80105fca:	6a 59                	push   $0x59
  jmp alltraps
80105fcc:	e9 f2 f7 ff ff       	jmp    801057c3 <alltraps>

80105fd1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105fd1:	6a 00                	push   $0x0
  pushl $90
80105fd3:	6a 5a                	push   $0x5a
  jmp alltraps
80105fd5:	e9 e9 f7 ff ff       	jmp    801057c3 <alltraps>

80105fda <vector91>:
.globl vector91
vector91:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $91
80105fdc:	6a 5b                	push   $0x5b
  jmp alltraps
80105fde:	e9 e0 f7 ff ff       	jmp    801057c3 <alltraps>

80105fe3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $92
80105fe5:	6a 5c                	push   $0x5c
  jmp alltraps
80105fe7:	e9 d7 f7 ff ff       	jmp    801057c3 <alltraps>

80105fec <vector93>:
.globl vector93
vector93:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $93
80105fee:	6a 5d                	push   $0x5d
  jmp alltraps
80105ff0:	e9 ce f7 ff ff       	jmp    801057c3 <alltraps>

80105ff5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $94
80105ff7:	6a 5e                	push   $0x5e
  jmp alltraps
80105ff9:	e9 c5 f7 ff ff       	jmp    801057c3 <alltraps>

80105ffe <vector95>:
.globl vector95
vector95:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $95
80106000:	6a 5f                	push   $0x5f
  jmp alltraps
80106002:	e9 bc f7 ff ff       	jmp    801057c3 <alltraps>

80106007 <vector96>:
.globl vector96
vector96:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $96
80106009:	6a 60                	push   $0x60
  jmp alltraps
8010600b:	e9 b3 f7 ff ff       	jmp    801057c3 <alltraps>

80106010 <vector97>:
.globl vector97
vector97:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $97
80106012:	6a 61                	push   $0x61
  jmp alltraps
80106014:	e9 aa f7 ff ff       	jmp    801057c3 <alltraps>

80106019 <vector98>:
.globl vector98
vector98:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $98
8010601b:	6a 62                	push   $0x62
  jmp alltraps
8010601d:	e9 a1 f7 ff ff       	jmp    801057c3 <alltraps>

80106022 <vector99>:
.globl vector99
vector99:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $99
80106024:	6a 63                	push   $0x63
  jmp alltraps
80106026:	e9 98 f7 ff ff       	jmp    801057c3 <alltraps>

8010602b <vector100>:
.globl vector100
vector100:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $100
8010602d:	6a 64                	push   $0x64
  jmp alltraps
8010602f:	e9 8f f7 ff ff       	jmp    801057c3 <alltraps>

80106034 <vector101>:
.globl vector101
vector101:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $101
80106036:	6a 65                	push   $0x65
  jmp alltraps
80106038:	e9 86 f7 ff ff       	jmp    801057c3 <alltraps>

8010603d <vector102>:
.globl vector102
vector102:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $102
8010603f:	6a 66                	push   $0x66
  jmp alltraps
80106041:	e9 7d f7 ff ff       	jmp    801057c3 <alltraps>

80106046 <vector103>:
.globl vector103
vector103:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $103
80106048:	6a 67                	push   $0x67
  jmp alltraps
8010604a:	e9 74 f7 ff ff       	jmp    801057c3 <alltraps>

8010604f <vector104>:
.globl vector104
vector104:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $104
80106051:	6a 68                	push   $0x68
  jmp alltraps
80106053:	e9 6b f7 ff ff       	jmp    801057c3 <alltraps>

80106058 <vector105>:
.globl vector105
vector105:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $105
8010605a:	6a 69                	push   $0x69
  jmp alltraps
8010605c:	e9 62 f7 ff ff       	jmp    801057c3 <alltraps>

80106061 <vector106>:
.globl vector106
vector106:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $106
80106063:	6a 6a                	push   $0x6a
  jmp alltraps
80106065:	e9 59 f7 ff ff       	jmp    801057c3 <alltraps>

8010606a <vector107>:
.globl vector107
vector107:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $107
8010606c:	6a 6b                	push   $0x6b
  jmp alltraps
8010606e:	e9 50 f7 ff ff       	jmp    801057c3 <alltraps>

80106073 <vector108>:
.globl vector108
vector108:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $108
80106075:	6a 6c                	push   $0x6c
  jmp alltraps
80106077:	e9 47 f7 ff ff       	jmp    801057c3 <alltraps>

8010607c <vector109>:
.globl vector109
vector109:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $109
8010607e:	6a 6d                	push   $0x6d
  jmp alltraps
80106080:	e9 3e f7 ff ff       	jmp    801057c3 <alltraps>

80106085 <vector110>:
.globl vector110
vector110:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $110
80106087:	6a 6e                	push   $0x6e
  jmp alltraps
80106089:	e9 35 f7 ff ff       	jmp    801057c3 <alltraps>

8010608e <vector111>:
.globl vector111
vector111:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $111
80106090:	6a 6f                	push   $0x6f
  jmp alltraps
80106092:	e9 2c f7 ff ff       	jmp    801057c3 <alltraps>

80106097 <vector112>:
.globl vector112
vector112:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $112
80106099:	6a 70                	push   $0x70
  jmp alltraps
8010609b:	e9 23 f7 ff ff       	jmp    801057c3 <alltraps>

801060a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $113
801060a2:	6a 71                	push   $0x71
  jmp alltraps
801060a4:	e9 1a f7 ff ff       	jmp    801057c3 <alltraps>

801060a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $114
801060ab:	6a 72                	push   $0x72
  jmp alltraps
801060ad:	e9 11 f7 ff ff       	jmp    801057c3 <alltraps>

801060b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $115
801060b4:	6a 73                	push   $0x73
  jmp alltraps
801060b6:	e9 08 f7 ff ff       	jmp    801057c3 <alltraps>

801060bb <vector116>:
.globl vector116
vector116:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $116
801060bd:	6a 74                	push   $0x74
  jmp alltraps
801060bf:	e9 ff f6 ff ff       	jmp    801057c3 <alltraps>

801060c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $117
801060c6:	6a 75                	push   $0x75
  jmp alltraps
801060c8:	e9 f6 f6 ff ff       	jmp    801057c3 <alltraps>

801060cd <vector118>:
.globl vector118
vector118:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $118
801060cf:	6a 76                	push   $0x76
  jmp alltraps
801060d1:	e9 ed f6 ff ff       	jmp    801057c3 <alltraps>

801060d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $119
801060d8:	6a 77                	push   $0x77
  jmp alltraps
801060da:	e9 e4 f6 ff ff       	jmp    801057c3 <alltraps>

801060df <vector120>:
.globl vector120
vector120:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $120
801060e1:	6a 78                	push   $0x78
  jmp alltraps
801060e3:	e9 db f6 ff ff       	jmp    801057c3 <alltraps>

801060e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $121
801060ea:	6a 79                	push   $0x79
  jmp alltraps
801060ec:	e9 d2 f6 ff ff       	jmp    801057c3 <alltraps>

801060f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $122
801060f3:	6a 7a                	push   $0x7a
  jmp alltraps
801060f5:	e9 c9 f6 ff ff       	jmp    801057c3 <alltraps>

801060fa <vector123>:
.globl vector123
vector123:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $123
801060fc:	6a 7b                	push   $0x7b
  jmp alltraps
801060fe:	e9 c0 f6 ff ff       	jmp    801057c3 <alltraps>

80106103 <vector124>:
.globl vector124
vector124:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $124
80106105:	6a 7c                	push   $0x7c
  jmp alltraps
80106107:	e9 b7 f6 ff ff       	jmp    801057c3 <alltraps>

8010610c <vector125>:
.globl vector125
vector125:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $125
8010610e:	6a 7d                	push   $0x7d
  jmp alltraps
80106110:	e9 ae f6 ff ff       	jmp    801057c3 <alltraps>

80106115 <vector126>:
.globl vector126
vector126:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $126
80106117:	6a 7e                	push   $0x7e
  jmp alltraps
80106119:	e9 a5 f6 ff ff       	jmp    801057c3 <alltraps>

8010611e <vector127>:
.globl vector127
vector127:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $127
80106120:	6a 7f                	push   $0x7f
  jmp alltraps
80106122:	e9 9c f6 ff ff       	jmp    801057c3 <alltraps>

80106127 <vector128>:
.globl vector128
vector128:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $128
80106129:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010612e:	e9 90 f6 ff ff       	jmp    801057c3 <alltraps>

80106133 <vector129>:
.globl vector129
vector129:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $129
80106135:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010613a:	e9 84 f6 ff ff       	jmp    801057c3 <alltraps>

8010613f <vector130>:
.globl vector130
vector130:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $130
80106141:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106146:	e9 78 f6 ff ff       	jmp    801057c3 <alltraps>

8010614b <vector131>:
.globl vector131
vector131:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $131
8010614d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106152:	e9 6c f6 ff ff       	jmp    801057c3 <alltraps>

80106157 <vector132>:
.globl vector132
vector132:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $132
80106159:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010615e:	e9 60 f6 ff ff       	jmp    801057c3 <alltraps>

80106163 <vector133>:
.globl vector133
vector133:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $133
80106165:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010616a:	e9 54 f6 ff ff       	jmp    801057c3 <alltraps>

8010616f <vector134>:
.globl vector134
vector134:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $134
80106171:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106176:	e9 48 f6 ff ff       	jmp    801057c3 <alltraps>

8010617b <vector135>:
.globl vector135
vector135:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $135
8010617d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106182:	e9 3c f6 ff ff       	jmp    801057c3 <alltraps>

80106187 <vector136>:
.globl vector136
vector136:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $136
80106189:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010618e:	e9 30 f6 ff ff       	jmp    801057c3 <alltraps>

80106193 <vector137>:
.globl vector137
vector137:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $137
80106195:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010619a:	e9 24 f6 ff ff       	jmp    801057c3 <alltraps>

8010619f <vector138>:
.globl vector138
vector138:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $138
801061a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801061a6:	e9 18 f6 ff ff       	jmp    801057c3 <alltraps>

801061ab <vector139>:
.globl vector139
vector139:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $139
801061ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801061b2:	e9 0c f6 ff ff       	jmp    801057c3 <alltraps>

801061b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $140
801061b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801061be:	e9 00 f6 ff ff       	jmp    801057c3 <alltraps>

801061c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $141
801061c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801061ca:	e9 f4 f5 ff ff       	jmp    801057c3 <alltraps>

801061cf <vector142>:
.globl vector142
vector142:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $142
801061d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801061d6:	e9 e8 f5 ff ff       	jmp    801057c3 <alltraps>

801061db <vector143>:
.globl vector143
vector143:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $143
801061dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801061e2:	e9 dc f5 ff ff       	jmp    801057c3 <alltraps>

801061e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $144
801061e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801061ee:	e9 d0 f5 ff ff       	jmp    801057c3 <alltraps>

801061f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $145
801061f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801061fa:	e9 c4 f5 ff ff       	jmp    801057c3 <alltraps>

801061ff <vector146>:
.globl vector146
vector146:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $146
80106201:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106206:	e9 b8 f5 ff ff       	jmp    801057c3 <alltraps>

8010620b <vector147>:
.globl vector147
vector147:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $147
8010620d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106212:	e9 ac f5 ff ff       	jmp    801057c3 <alltraps>

80106217 <vector148>:
.globl vector148
vector148:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $148
80106219:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010621e:	e9 a0 f5 ff ff       	jmp    801057c3 <alltraps>

80106223 <vector149>:
.globl vector149
vector149:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $149
80106225:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010622a:	e9 94 f5 ff ff       	jmp    801057c3 <alltraps>

8010622f <vector150>:
.globl vector150
vector150:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $150
80106231:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106236:	e9 88 f5 ff ff       	jmp    801057c3 <alltraps>

8010623b <vector151>:
.globl vector151
vector151:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $151
8010623d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106242:	e9 7c f5 ff ff       	jmp    801057c3 <alltraps>

80106247 <vector152>:
.globl vector152
vector152:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $152
80106249:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010624e:	e9 70 f5 ff ff       	jmp    801057c3 <alltraps>

80106253 <vector153>:
.globl vector153
vector153:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $153
80106255:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010625a:	e9 64 f5 ff ff       	jmp    801057c3 <alltraps>

8010625f <vector154>:
.globl vector154
vector154:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $154
80106261:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106266:	e9 58 f5 ff ff       	jmp    801057c3 <alltraps>

8010626b <vector155>:
.globl vector155
vector155:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $155
8010626d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106272:	e9 4c f5 ff ff       	jmp    801057c3 <alltraps>

80106277 <vector156>:
.globl vector156
vector156:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $156
80106279:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010627e:	e9 40 f5 ff ff       	jmp    801057c3 <alltraps>

80106283 <vector157>:
.globl vector157
vector157:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $157
80106285:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010628a:	e9 34 f5 ff ff       	jmp    801057c3 <alltraps>

8010628f <vector158>:
.globl vector158
vector158:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $158
80106291:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106296:	e9 28 f5 ff ff       	jmp    801057c3 <alltraps>

8010629b <vector159>:
.globl vector159
vector159:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $159
8010629d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801062a2:	e9 1c f5 ff ff       	jmp    801057c3 <alltraps>

801062a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $160
801062a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801062ae:	e9 10 f5 ff ff       	jmp    801057c3 <alltraps>

801062b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $161
801062b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801062ba:	e9 04 f5 ff ff       	jmp    801057c3 <alltraps>

801062bf <vector162>:
.globl vector162
vector162:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $162
801062c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801062c6:	e9 f8 f4 ff ff       	jmp    801057c3 <alltraps>

801062cb <vector163>:
.globl vector163
vector163:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $163
801062cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801062d2:	e9 ec f4 ff ff       	jmp    801057c3 <alltraps>

801062d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $164
801062d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801062de:	e9 e0 f4 ff ff       	jmp    801057c3 <alltraps>

801062e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $165
801062e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801062ea:	e9 d4 f4 ff ff       	jmp    801057c3 <alltraps>

801062ef <vector166>:
.globl vector166
vector166:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $166
801062f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801062f6:	e9 c8 f4 ff ff       	jmp    801057c3 <alltraps>

801062fb <vector167>:
.globl vector167
vector167:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $167
801062fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106302:	e9 bc f4 ff ff       	jmp    801057c3 <alltraps>

80106307 <vector168>:
.globl vector168
vector168:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $168
80106309:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010630e:	e9 b0 f4 ff ff       	jmp    801057c3 <alltraps>

80106313 <vector169>:
.globl vector169
vector169:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $169
80106315:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010631a:	e9 a4 f4 ff ff       	jmp    801057c3 <alltraps>

8010631f <vector170>:
.globl vector170
vector170:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $170
80106321:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106326:	e9 98 f4 ff ff       	jmp    801057c3 <alltraps>

8010632b <vector171>:
.globl vector171
vector171:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $171
8010632d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106332:	e9 8c f4 ff ff       	jmp    801057c3 <alltraps>

80106337 <vector172>:
.globl vector172
vector172:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $172
80106339:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010633e:	e9 80 f4 ff ff       	jmp    801057c3 <alltraps>

80106343 <vector173>:
.globl vector173
vector173:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $173
80106345:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010634a:	e9 74 f4 ff ff       	jmp    801057c3 <alltraps>

8010634f <vector174>:
.globl vector174
vector174:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $174
80106351:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106356:	e9 68 f4 ff ff       	jmp    801057c3 <alltraps>

8010635b <vector175>:
.globl vector175
vector175:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $175
8010635d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106362:	e9 5c f4 ff ff       	jmp    801057c3 <alltraps>

80106367 <vector176>:
.globl vector176
vector176:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $176
80106369:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010636e:	e9 50 f4 ff ff       	jmp    801057c3 <alltraps>

80106373 <vector177>:
.globl vector177
vector177:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $177
80106375:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010637a:	e9 44 f4 ff ff       	jmp    801057c3 <alltraps>

8010637f <vector178>:
.globl vector178
vector178:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $178
80106381:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106386:	e9 38 f4 ff ff       	jmp    801057c3 <alltraps>

8010638b <vector179>:
.globl vector179
vector179:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $179
8010638d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106392:	e9 2c f4 ff ff       	jmp    801057c3 <alltraps>

80106397 <vector180>:
.globl vector180
vector180:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $180
80106399:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010639e:	e9 20 f4 ff ff       	jmp    801057c3 <alltraps>

801063a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $181
801063a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801063aa:	e9 14 f4 ff ff       	jmp    801057c3 <alltraps>

801063af <vector182>:
.globl vector182
vector182:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $182
801063b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801063b6:	e9 08 f4 ff ff       	jmp    801057c3 <alltraps>

801063bb <vector183>:
.globl vector183
vector183:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $183
801063bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801063c2:	e9 fc f3 ff ff       	jmp    801057c3 <alltraps>

801063c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $184
801063c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801063ce:	e9 f0 f3 ff ff       	jmp    801057c3 <alltraps>

801063d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $185
801063d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801063da:	e9 e4 f3 ff ff       	jmp    801057c3 <alltraps>

801063df <vector186>:
.globl vector186
vector186:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $186
801063e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801063e6:	e9 d8 f3 ff ff       	jmp    801057c3 <alltraps>

801063eb <vector187>:
.globl vector187
vector187:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $187
801063ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801063f2:	e9 cc f3 ff ff       	jmp    801057c3 <alltraps>

801063f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $188
801063f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801063fe:	e9 c0 f3 ff ff       	jmp    801057c3 <alltraps>

80106403 <vector189>:
.globl vector189
vector189:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $189
80106405:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010640a:	e9 b4 f3 ff ff       	jmp    801057c3 <alltraps>

8010640f <vector190>:
.globl vector190
vector190:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $190
80106411:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106416:	e9 a8 f3 ff ff       	jmp    801057c3 <alltraps>

8010641b <vector191>:
.globl vector191
vector191:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $191
8010641d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106422:	e9 9c f3 ff ff       	jmp    801057c3 <alltraps>

80106427 <vector192>:
.globl vector192
vector192:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $192
80106429:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010642e:	e9 90 f3 ff ff       	jmp    801057c3 <alltraps>

80106433 <vector193>:
.globl vector193
vector193:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $193
80106435:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010643a:	e9 84 f3 ff ff       	jmp    801057c3 <alltraps>

8010643f <vector194>:
.globl vector194
vector194:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $194
80106441:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106446:	e9 78 f3 ff ff       	jmp    801057c3 <alltraps>

8010644b <vector195>:
.globl vector195
vector195:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $195
8010644d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106452:	e9 6c f3 ff ff       	jmp    801057c3 <alltraps>

80106457 <vector196>:
.globl vector196
vector196:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $196
80106459:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010645e:	e9 60 f3 ff ff       	jmp    801057c3 <alltraps>

80106463 <vector197>:
.globl vector197
vector197:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $197
80106465:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010646a:	e9 54 f3 ff ff       	jmp    801057c3 <alltraps>

8010646f <vector198>:
.globl vector198
vector198:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $198
80106471:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106476:	e9 48 f3 ff ff       	jmp    801057c3 <alltraps>

8010647b <vector199>:
.globl vector199
vector199:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $199
8010647d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106482:	e9 3c f3 ff ff       	jmp    801057c3 <alltraps>

80106487 <vector200>:
.globl vector200
vector200:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $200
80106489:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010648e:	e9 30 f3 ff ff       	jmp    801057c3 <alltraps>

80106493 <vector201>:
.globl vector201
vector201:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $201
80106495:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010649a:	e9 24 f3 ff ff       	jmp    801057c3 <alltraps>

8010649f <vector202>:
.globl vector202
vector202:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $202
801064a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801064a6:	e9 18 f3 ff ff       	jmp    801057c3 <alltraps>

801064ab <vector203>:
.globl vector203
vector203:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $203
801064ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801064b2:	e9 0c f3 ff ff       	jmp    801057c3 <alltraps>

801064b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $204
801064b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801064be:	e9 00 f3 ff ff       	jmp    801057c3 <alltraps>

801064c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $205
801064c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801064ca:	e9 f4 f2 ff ff       	jmp    801057c3 <alltraps>

801064cf <vector206>:
.globl vector206
vector206:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $206
801064d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801064d6:	e9 e8 f2 ff ff       	jmp    801057c3 <alltraps>

801064db <vector207>:
.globl vector207
vector207:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $207
801064dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801064e2:	e9 dc f2 ff ff       	jmp    801057c3 <alltraps>

801064e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $208
801064e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801064ee:	e9 d0 f2 ff ff       	jmp    801057c3 <alltraps>

801064f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $209
801064f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801064fa:	e9 c4 f2 ff ff       	jmp    801057c3 <alltraps>

801064ff <vector210>:
.globl vector210
vector210:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $210
80106501:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106506:	e9 b8 f2 ff ff       	jmp    801057c3 <alltraps>

8010650b <vector211>:
.globl vector211
vector211:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $211
8010650d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106512:	e9 ac f2 ff ff       	jmp    801057c3 <alltraps>

80106517 <vector212>:
.globl vector212
vector212:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $212
80106519:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010651e:	e9 a0 f2 ff ff       	jmp    801057c3 <alltraps>

80106523 <vector213>:
.globl vector213
vector213:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $213
80106525:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010652a:	e9 94 f2 ff ff       	jmp    801057c3 <alltraps>

8010652f <vector214>:
.globl vector214
vector214:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $214
80106531:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106536:	e9 88 f2 ff ff       	jmp    801057c3 <alltraps>

8010653b <vector215>:
.globl vector215
vector215:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $215
8010653d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106542:	e9 7c f2 ff ff       	jmp    801057c3 <alltraps>

80106547 <vector216>:
.globl vector216
vector216:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $216
80106549:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010654e:	e9 70 f2 ff ff       	jmp    801057c3 <alltraps>

80106553 <vector217>:
.globl vector217
vector217:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $217
80106555:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010655a:	e9 64 f2 ff ff       	jmp    801057c3 <alltraps>

8010655f <vector218>:
.globl vector218
vector218:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $218
80106561:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106566:	e9 58 f2 ff ff       	jmp    801057c3 <alltraps>

8010656b <vector219>:
.globl vector219
vector219:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $219
8010656d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106572:	e9 4c f2 ff ff       	jmp    801057c3 <alltraps>

80106577 <vector220>:
.globl vector220
vector220:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $220
80106579:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010657e:	e9 40 f2 ff ff       	jmp    801057c3 <alltraps>

80106583 <vector221>:
.globl vector221
vector221:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $221
80106585:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010658a:	e9 34 f2 ff ff       	jmp    801057c3 <alltraps>

8010658f <vector222>:
.globl vector222
vector222:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $222
80106591:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106596:	e9 28 f2 ff ff       	jmp    801057c3 <alltraps>

8010659b <vector223>:
.globl vector223
vector223:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $223
8010659d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801065a2:	e9 1c f2 ff ff       	jmp    801057c3 <alltraps>

801065a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $224
801065a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801065ae:	e9 10 f2 ff ff       	jmp    801057c3 <alltraps>

801065b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $225
801065b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801065ba:	e9 04 f2 ff ff       	jmp    801057c3 <alltraps>

801065bf <vector226>:
.globl vector226
vector226:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $226
801065c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801065c6:	e9 f8 f1 ff ff       	jmp    801057c3 <alltraps>

801065cb <vector227>:
.globl vector227
vector227:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $227
801065cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801065d2:	e9 ec f1 ff ff       	jmp    801057c3 <alltraps>

801065d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $228
801065d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801065de:	e9 e0 f1 ff ff       	jmp    801057c3 <alltraps>

801065e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $229
801065e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801065ea:	e9 d4 f1 ff ff       	jmp    801057c3 <alltraps>

801065ef <vector230>:
.globl vector230
vector230:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $230
801065f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801065f6:	e9 c8 f1 ff ff       	jmp    801057c3 <alltraps>

801065fb <vector231>:
.globl vector231
vector231:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $231
801065fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106602:	e9 bc f1 ff ff       	jmp    801057c3 <alltraps>

80106607 <vector232>:
.globl vector232
vector232:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $232
80106609:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010660e:	e9 b0 f1 ff ff       	jmp    801057c3 <alltraps>

80106613 <vector233>:
.globl vector233
vector233:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $233
80106615:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010661a:	e9 a4 f1 ff ff       	jmp    801057c3 <alltraps>

8010661f <vector234>:
.globl vector234
vector234:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $234
80106621:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106626:	e9 98 f1 ff ff       	jmp    801057c3 <alltraps>

8010662b <vector235>:
.globl vector235
vector235:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $235
8010662d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106632:	e9 8c f1 ff ff       	jmp    801057c3 <alltraps>

80106637 <vector236>:
.globl vector236
vector236:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $236
80106639:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010663e:	e9 80 f1 ff ff       	jmp    801057c3 <alltraps>

80106643 <vector237>:
.globl vector237
vector237:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $237
80106645:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010664a:	e9 74 f1 ff ff       	jmp    801057c3 <alltraps>

8010664f <vector238>:
.globl vector238
vector238:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $238
80106651:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106656:	e9 68 f1 ff ff       	jmp    801057c3 <alltraps>

8010665b <vector239>:
.globl vector239
vector239:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $239
8010665d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106662:	e9 5c f1 ff ff       	jmp    801057c3 <alltraps>

80106667 <vector240>:
.globl vector240
vector240:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $240
80106669:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010666e:	e9 50 f1 ff ff       	jmp    801057c3 <alltraps>

80106673 <vector241>:
.globl vector241
vector241:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $241
80106675:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010667a:	e9 44 f1 ff ff       	jmp    801057c3 <alltraps>

8010667f <vector242>:
.globl vector242
vector242:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $242
80106681:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106686:	e9 38 f1 ff ff       	jmp    801057c3 <alltraps>

8010668b <vector243>:
.globl vector243
vector243:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $243
8010668d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106692:	e9 2c f1 ff ff       	jmp    801057c3 <alltraps>

80106697 <vector244>:
.globl vector244
vector244:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $244
80106699:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010669e:	e9 20 f1 ff ff       	jmp    801057c3 <alltraps>

801066a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $245
801066a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801066aa:	e9 14 f1 ff ff       	jmp    801057c3 <alltraps>

801066af <vector246>:
.globl vector246
vector246:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $246
801066b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801066b6:	e9 08 f1 ff ff       	jmp    801057c3 <alltraps>

801066bb <vector247>:
.globl vector247
vector247:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $247
801066bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801066c2:	e9 fc f0 ff ff       	jmp    801057c3 <alltraps>

801066c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $248
801066c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801066ce:	e9 f0 f0 ff ff       	jmp    801057c3 <alltraps>

801066d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $249
801066d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801066da:	e9 e4 f0 ff ff       	jmp    801057c3 <alltraps>

801066df <vector250>:
.globl vector250
vector250:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $250
801066e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801066e6:	e9 d8 f0 ff ff       	jmp    801057c3 <alltraps>

801066eb <vector251>:
.globl vector251
vector251:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $251
801066ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801066f2:	e9 cc f0 ff ff       	jmp    801057c3 <alltraps>

801066f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $252
801066f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801066fe:	e9 c0 f0 ff ff       	jmp    801057c3 <alltraps>

80106703 <vector253>:
.globl vector253
vector253:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $253
80106705:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010670a:	e9 b4 f0 ff ff       	jmp    801057c3 <alltraps>

8010670f <vector254>:
.globl vector254
vector254:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $254
80106711:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106716:	e9 a8 f0 ff ff       	jmp    801057c3 <alltraps>

8010671b <vector255>:
.globl vector255
vector255:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $255
8010671d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106722:	e9 9c f0 ff ff       	jmp    801057c3 <alltraps>
80106727:	66 90                	xchg   %ax,%ax
80106729:	66 90                	xchg   %ax,%ax
8010672b:	66 90                	xchg   %ax,%ax
8010672d:	66 90                	xchg   %ax,%ax
8010672f:	90                   	nop

80106730 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	57                   	push   %edi
80106734:	56                   	push   %esi
80106735:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106736:	89 d3                	mov    %edx,%ebx
{
80106738:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010673a:	c1 eb 16             	shr    $0x16,%ebx
8010673d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106740:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106743:	8b 06                	mov    (%esi),%eax
80106745:	a8 01                	test   $0x1,%al
80106747:	74 27                	je     80106770 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106749:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010674e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106754:	c1 ef 0a             	shr    $0xa,%edi
}
80106757:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010675a:	89 fa                	mov    %edi,%edx
8010675c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106762:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106765:	5b                   	pop    %ebx
80106766:	5e                   	pop    %esi
80106767:	5f                   	pop    %edi
80106768:	5d                   	pop    %ebp
80106769:	c3                   	ret    
8010676a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106770:	85 c9                	test   %ecx,%ecx
80106772:	74 2c                	je     801067a0 <walkpgdir+0x70>
80106774:	e8 67 bd ff ff       	call   801024e0 <kalloc>
80106779:	85 c0                	test   %eax,%eax
8010677b:	89 c3                	mov    %eax,%ebx
8010677d:	74 21                	je     801067a0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010677f:	83 ec 04             	sub    $0x4,%esp
80106782:	68 00 10 00 00       	push   $0x1000
80106787:	6a 00                	push   $0x0
80106789:	50                   	push   %eax
8010678a:	e8 41 de ff ff       	call   801045d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010678f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106795:	83 c4 10             	add    $0x10,%esp
80106798:	83 c8 07             	or     $0x7,%eax
8010679b:	89 06                	mov    %eax,(%esi)
8010679d:	eb b5                	jmp    80106754 <walkpgdir+0x24>
8010679f:	90                   	nop
}
801067a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801067a3:	31 c0                	xor    %eax,%eax
}
801067a5:	5b                   	pop    %ebx
801067a6:	5e                   	pop    %esi
801067a7:	5f                   	pop    %edi
801067a8:	5d                   	pop    %ebp
801067a9:	c3                   	ret    
801067aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	56                   	push   %esi
801067b5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801067b6:	89 d3                	mov    %edx,%ebx
801067b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801067be:	83 ec 1c             	sub    $0x1c,%esp
801067c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801067c8:	8b 7d 08             	mov    0x8(%ebp),%edi
801067cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801067d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801067d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801067d6:	29 df                	sub    %ebx,%edi
801067d8:	83 c8 01             	or     $0x1,%eax
801067db:	89 45 dc             	mov    %eax,-0x24(%ebp)
801067de:	eb 15                	jmp    801067f5 <mappages+0x45>
    if(*pte & PTE_P)
801067e0:	f6 00 01             	testb  $0x1,(%eax)
801067e3:	75 45                	jne    8010682a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801067e5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801067e8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801067eb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801067ed:	74 31                	je     80106820 <mappages+0x70>
      break;
    a += PGSIZE;
801067ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801067f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801067fd:	89 da                	mov    %ebx,%edx
801067ff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106802:	e8 29 ff ff ff       	call   80106730 <walkpgdir>
80106807:	85 c0                	test   %eax,%eax
80106809:	75 d5                	jne    801067e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010680b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010680e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106813:	5b                   	pop    %ebx
80106814:	5e                   	pop    %esi
80106815:	5f                   	pop    %edi
80106816:	5d                   	pop    %ebp
80106817:	c3                   	ret    
80106818:	90                   	nop
80106819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106823:	31 c0                	xor    %eax,%eax
}
80106825:	5b                   	pop    %ebx
80106826:	5e                   	pop    %esi
80106827:	5f                   	pop    %edi
80106828:	5d                   	pop    %ebp
80106829:	c3                   	ret    
      panic("remap");
8010682a:	83 ec 0c             	sub    $0xc,%esp
8010682d:	68 2c 79 10 80       	push   $0x8010792c
80106832:	e8 59 9b ff ff       	call   80100390 <panic>
80106837:	89 f6                	mov    %esi,%esi
80106839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106840 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	57                   	push   %edi
80106844:	56                   	push   %esi
80106845:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106846:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010684c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010684e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106854:	83 ec 1c             	sub    $0x1c,%esp
80106857:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010685a:	39 d3                	cmp    %edx,%ebx
8010685c:	73 66                	jae    801068c4 <deallocuvm.part.0+0x84>
8010685e:	89 d6                	mov    %edx,%esi
80106860:	eb 3d                	jmp    8010689f <deallocuvm.part.0+0x5f>
80106862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106868:	8b 10                	mov    (%eax),%edx
8010686a:	f6 c2 01             	test   $0x1,%dl
8010686d:	74 26                	je     80106895 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010686f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106875:	74 58                	je     801068cf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106877:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010687a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106880:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106883:	52                   	push   %edx
80106884:	e8 a7 ba ff ff       	call   80102330 <kfree>
      *pte = 0;
80106889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010688c:	83 c4 10             	add    $0x10,%esp
8010688f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106895:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010689b:	39 f3                	cmp    %esi,%ebx
8010689d:	73 25                	jae    801068c4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010689f:	31 c9                	xor    %ecx,%ecx
801068a1:	89 da                	mov    %ebx,%edx
801068a3:	89 f8                	mov    %edi,%eax
801068a5:	e8 86 fe ff ff       	call   80106730 <walkpgdir>
    if(!pte)
801068aa:	85 c0                	test   %eax,%eax
801068ac:	75 ba                	jne    80106868 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068ae:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801068b4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801068ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068c0:	39 f3                	cmp    %esi,%ebx
801068c2:	72 db                	jb     8010689f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801068c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068ca:	5b                   	pop    %ebx
801068cb:	5e                   	pop    %esi
801068cc:	5f                   	pop    %edi
801068cd:	5d                   	pop    %ebp
801068ce:	c3                   	ret    
        panic("kfree");
801068cf:	83 ec 0c             	sub    $0xc,%esp
801068d2:	68 c6 72 10 80       	push   $0x801072c6
801068d7:	e8 b4 9a ff ff       	call   80100390 <panic>
801068dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801068e0 <seginit>:
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801068e6:	e8 05 cf ff ff       	call   801037f0 <cpuid>
801068eb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801068f1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801068f6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068fa:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106901:	ff 00 00 
80106904:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
8010690b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010690e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106915:	ff 00 00 
80106918:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
8010691f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106922:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106929:	ff 00 00 
8010692c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106933:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106936:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
8010693d:	ff 00 00 
80106940:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106947:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010694a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
8010694f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106953:	c1 e8 10             	shr    $0x10,%eax
80106956:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010695a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010695d:	0f 01 10             	lgdtl  (%eax)
}
80106960:	c9                   	leave  
80106961:	c3                   	ret    
80106962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106970 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106970:	a1 c4 57 11 80       	mov    0x801157c4,%eax
{
80106975:	55                   	push   %ebp
80106976:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106978:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010697d:	0f 22 d8             	mov    %eax,%cr3
}
80106980:	5d                   	pop    %ebp
80106981:	c3                   	ret    
80106982:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106990 <switchuvm>:
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	57                   	push   %edi
80106994:	56                   	push   %esi
80106995:	53                   	push   %ebx
80106996:	83 ec 1c             	sub    $0x1c,%esp
80106999:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010699c:	85 db                	test   %ebx,%ebx
8010699e:	0f 84 cb 00 00 00    	je     80106a6f <switchuvm+0xdf>
  if(p->kstack == 0)
801069a4:	8b 43 08             	mov    0x8(%ebx),%eax
801069a7:	85 c0                	test   %eax,%eax
801069a9:	0f 84 da 00 00 00    	je     80106a89 <switchuvm+0xf9>
  if(p->pgdir == 0)
801069af:	8b 43 04             	mov    0x4(%ebx),%eax
801069b2:	85 c0                	test   %eax,%eax
801069b4:	0f 84 c2 00 00 00    	je     80106a7c <switchuvm+0xec>
  pushcli();
801069ba:	e8 51 da ff ff       	call   80104410 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069bf:	e8 ac cd ff ff       	call   80103770 <mycpu>
801069c4:	89 c6                	mov    %eax,%esi
801069c6:	e8 a5 cd ff ff       	call   80103770 <mycpu>
801069cb:	89 c7                	mov    %eax,%edi
801069cd:	e8 9e cd ff ff       	call   80103770 <mycpu>
801069d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069d5:	83 c7 08             	add    $0x8,%edi
801069d8:	e8 93 cd ff ff       	call   80103770 <mycpu>
801069dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801069e0:	83 c0 08             	add    $0x8,%eax
801069e3:	ba 67 00 00 00       	mov    $0x67,%edx
801069e8:	c1 e8 18             	shr    $0x18,%eax
801069eb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801069f2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801069f9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a04:	83 c1 08             	add    $0x8,%ecx
80106a07:	c1 e9 10             	shr    $0x10,%ecx
80106a0a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106a10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106a15:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a1c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106a21:	e8 4a cd ff ff       	call   80103770 <mycpu>
80106a26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a2d:	e8 3e cd ff ff       	call   80103770 <mycpu>
80106a32:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a36:	8b 73 08             	mov    0x8(%ebx),%esi
80106a39:	e8 32 cd ff ff       	call   80103770 <mycpu>
80106a3e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106a44:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a47:	e8 24 cd ff ff       	call   80103770 <mycpu>
80106a4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106a50:	b8 28 00 00 00       	mov    $0x28,%eax
80106a55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106a58:	8b 43 04             	mov    0x4(%ebx),%eax
80106a5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a60:	0f 22 d8             	mov    %eax,%cr3
}
80106a63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a66:	5b                   	pop    %ebx
80106a67:	5e                   	pop    %esi
80106a68:	5f                   	pop    %edi
80106a69:	5d                   	pop    %ebp
  popcli();
80106a6a:	e9 a1 da ff ff       	jmp    80104510 <popcli>
    panic("switchuvm: no process");
80106a6f:	83 ec 0c             	sub    $0xc,%esp
80106a72:	68 32 79 10 80       	push   $0x80107932
80106a77:	e8 14 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106a7c:	83 ec 0c             	sub    $0xc,%esp
80106a7f:	68 5d 79 10 80       	push   $0x8010795d
80106a84:	e8 07 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106a89:	83 ec 0c             	sub    $0xc,%esp
80106a8c:	68 48 79 10 80       	push   $0x80107948
80106a91:	e8 fa 98 ff ff       	call   80100390 <panic>
80106a96:	8d 76 00             	lea    0x0(%esi),%esi
80106a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106aa0 <inituvm>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 1c             	sub    $0x1c,%esp
80106aa9:	8b 75 10             	mov    0x10(%ebp),%esi
80106aac:	8b 45 08             	mov    0x8(%ebp),%eax
80106aaf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106ab2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106ab8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106abb:	77 49                	ja     80106b06 <inituvm+0x66>
  mem = kalloc();
80106abd:	e8 1e ba ff ff       	call   801024e0 <kalloc>
  memset(mem, 0, PGSIZE);
80106ac2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106ac5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ac7:	68 00 10 00 00       	push   $0x1000
80106acc:	6a 00                	push   $0x0
80106ace:	50                   	push   %eax
80106acf:	e8 fc da ff ff       	call   801045d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ad4:	58                   	pop    %eax
80106ad5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106adb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ae0:	5a                   	pop    %edx
80106ae1:	6a 06                	push   $0x6
80106ae3:	50                   	push   %eax
80106ae4:	31 d2                	xor    %edx,%edx
80106ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ae9:	e8 c2 fc ff ff       	call   801067b0 <mappages>
  memmove(mem, init, sz);
80106aee:	89 75 10             	mov    %esi,0x10(%ebp)
80106af1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106af4:	83 c4 10             	add    $0x10,%esp
80106af7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106afa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106afd:	5b                   	pop    %ebx
80106afe:	5e                   	pop    %esi
80106aff:	5f                   	pop    %edi
80106b00:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106b01:	e9 7a db ff ff       	jmp    80104680 <memmove>
    panic("inituvm: more than a page");
80106b06:	83 ec 0c             	sub    $0xc,%esp
80106b09:	68 71 79 10 80       	push   $0x80107971
80106b0e:	e8 7d 98 ff ff       	call   80100390 <panic>
80106b13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b20 <loaduvm>:
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	57                   	push   %edi
80106b24:	56                   	push   %esi
80106b25:	53                   	push   %ebx
80106b26:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106b29:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106b30:	0f 85 91 00 00 00    	jne    80106bc7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106b36:	8b 75 18             	mov    0x18(%ebp),%esi
80106b39:	31 db                	xor    %ebx,%ebx
80106b3b:	85 f6                	test   %esi,%esi
80106b3d:	75 1a                	jne    80106b59 <loaduvm+0x39>
80106b3f:	eb 6f                	jmp    80106bb0 <loaduvm+0x90>
80106b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b48:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b4e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106b54:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106b57:	76 57                	jbe    80106bb0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b59:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5f:	31 c9                	xor    %ecx,%ecx
80106b61:	01 da                	add    %ebx,%edx
80106b63:	e8 c8 fb ff ff       	call   80106730 <walkpgdir>
80106b68:	85 c0                	test   %eax,%eax
80106b6a:	74 4e                	je     80106bba <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106b6c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106b71:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106b76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b7b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b81:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b84:	01 d9                	add    %ebx,%ecx
80106b86:	05 00 00 00 80       	add    $0x80000000,%eax
80106b8b:	57                   	push   %edi
80106b8c:	51                   	push   %ecx
80106b8d:	50                   	push   %eax
80106b8e:	ff 75 10             	pushl  0x10(%ebp)
80106b91:	e8 ea ad ff ff       	call   80101980 <readi>
80106b96:	83 c4 10             	add    $0x10,%esp
80106b99:	39 f8                	cmp    %edi,%eax
80106b9b:	74 ab                	je     80106b48 <loaduvm+0x28>
}
80106b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret    
80106baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106bb3:	31 c0                	xor    %eax,%eax
}
80106bb5:	5b                   	pop    %ebx
80106bb6:	5e                   	pop    %esi
80106bb7:	5f                   	pop    %edi
80106bb8:	5d                   	pop    %ebp
80106bb9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106bba:	83 ec 0c             	sub    $0xc,%esp
80106bbd:	68 8b 79 10 80       	push   $0x8010798b
80106bc2:	e8 c9 97 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106bc7:	83 ec 0c             	sub    $0xc,%esp
80106bca:	68 2c 7a 10 80       	push   $0x80107a2c
80106bcf:	e8 bc 97 ff ff       	call   80100390 <panic>
80106bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106be0 <allocuvm>:
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	56                   	push   %esi
80106be5:	53                   	push   %ebx
80106be6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106be9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106bec:	85 ff                	test   %edi,%edi
80106bee:	0f 88 8e 00 00 00    	js     80106c82 <allocuvm+0xa2>
  if(newsz < oldsz)
80106bf4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bf7:	0f 82 93 00 00 00    	jb     80106c90 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c00:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c06:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c0c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106c0f:	0f 86 7e 00 00 00    	jbe    80106c93 <allocuvm+0xb3>
80106c15:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106c18:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c1b:	eb 42                	jmp    80106c5f <allocuvm+0x7f>
80106c1d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106c20:	83 ec 04             	sub    $0x4,%esp
80106c23:	68 00 10 00 00       	push   $0x1000
80106c28:	6a 00                	push   $0x0
80106c2a:	50                   	push   %eax
80106c2b:	e8 a0 d9 ff ff       	call   801045d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c30:	58                   	pop    %eax
80106c31:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c37:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c3c:	5a                   	pop    %edx
80106c3d:	6a 06                	push   $0x6
80106c3f:	50                   	push   %eax
80106c40:	89 da                	mov    %ebx,%edx
80106c42:	89 f8                	mov    %edi,%eax
80106c44:	e8 67 fb ff ff       	call   801067b0 <mappages>
80106c49:	83 c4 10             	add    $0x10,%esp
80106c4c:	85 c0                	test   %eax,%eax
80106c4e:	78 50                	js     80106ca0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106c50:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c56:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106c59:	0f 86 81 00 00 00    	jbe    80106ce0 <allocuvm+0x100>
    mem = kalloc();
80106c5f:	e8 7c b8 ff ff       	call   801024e0 <kalloc>
    if(mem == 0){
80106c64:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106c66:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c68:	75 b6                	jne    80106c20 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106c6a:	83 ec 0c             	sub    $0xc,%esp
80106c6d:	68 a9 79 10 80       	push   $0x801079a9
80106c72:	e8 f9 99 ff ff       	call   80100670 <cprintf>
  if(newsz >= oldsz)
80106c77:	83 c4 10             	add    $0x10,%esp
80106c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c7d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c80:	77 6e                	ja     80106cf0 <allocuvm+0x110>
}
80106c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106c85:	31 ff                	xor    %edi,%edi
}
80106c87:	89 f8                	mov    %edi,%eax
80106c89:	5b                   	pop    %ebx
80106c8a:	5e                   	pop    %esi
80106c8b:	5f                   	pop    %edi
80106c8c:	5d                   	pop    %ebp
80106c8d:	c3                   	ret    
80106c8e:	66 90                	xchg   %ax,%ax
    return oldsz;
80106c90:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c96:	89 f8                	mov    %edi,%eax
80106c98:	5b                   	pop    %ebx
80106c99:	5e                   	pop    %esi
80106c9a:	5f                   	pop    %edi
80106c9b:	5d                   	pop    %ebp
80106c9c:	c3                   	ret    
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ca0:	83 ec 0c             	sub    $0xc,%esp
80106ca3:	68 c1 79 10 80       	push   $0x801079c1
80106ca8:	e8 c3 99 ff ff       	call   80100670 <cprintf>
  if(newsz >= oldsz)
80106cad:	83 c4 10             	add    $0x10,%esp
80106cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cb3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106cb6:	76 0d                	jbe    80106cc5 <allocuvm+0xe5>
80106cb8:	89 c1                	mov    %eax,%ecx
80106cba:	8b 55 10             	mov    0x10(%ebp),%edx
80106cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc0:	e8 7b fb ff ff       	call   80106840 <deallocuvm.part.0>
      kfree(mem);
80106cc5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106cc8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106cca:	56                   	push   %esi
80106ccb:	e8 60 b6 ff ff       	call   80102330 <kfree>
      return 0;
80106cd0:	83 c4 10             	add    $0x10,%esp
}
80106cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cd6:	89 f8                	mov    %edi,%eax
80106cd8:	5b                   	pop    %ebx
80106cd9:	5e                   	pop    %esi
80106cda:	5f                   	pop    %edi
80106cdb:	5d                   	pop    %ebp
80106cdc:	c3                   	ret    
80106cdd:	8d 76 00             	lea    0x0(%esi),%esi
80106ce0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ce6:	5b                   	pop    %ebx
80106ce7:	89 f8                	mov    %edi,%eax
80106ce9:	5e                   	pop    %esi
80106cea:	5f                   	pop    %edi
80106ceb:	5d                   	pop    %ebp
80106cec:	c3                   	ret    
80106ced:	8d 76 00             	lea    0x0(%esi),%esi
80106cf0:	89 c1                	mov    %eax,%ecx
80106cf2:	8b 55 10             	mov    0x10(%ebp),%edx
80106cf5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106cf8:	31 ff                	xor    %edi,%edi
80106cfa:	e8 41 fb ff ff       	call   80106840 <deallocuvm.part.0>
80106cff:	eb 92                	jmp    80106c93 <allocuvm+0xb3>
80106d01:	eb 0d                	jmp    80106d10 <deallocuvm>
80106d03:	90                   	nop
80106d04:	90                   	nop
80106d05:	90                   	nop
80106d06:	90                   	nop
80106d07:	90                   	nop
80106d08:	90                   	nop
80106d09:	90                   	nop
80106d0a:	90                   	nop
80106d0b:	90                   	nop
80106d0c:	90                   	nop
80106d0d:	90                   	nop
80106d0e:	90                   	nop
80106d0f:	90                   	nop

80106d10 <deallocuvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106d1c:	39 d1                	cmp    %edx,%ecx
80106d1e:	73 10                	jae    80106d30 <deallocuvm+0x20>
}
80106d20:	5d                   	pop    %ebp
80106d21:	e9 1a fb ff ff       	jmp    80106840 <deallocuvm.part.0>
80106d26:	8d 76 00             	lea    0x0(%esi),%esi
80106d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d30:	89 d0                	mov    %edx,%eax
80106d32:	5d                   	pop    %ebp
80106d33:	c3                   	ret    
80106d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
80106d46:	83 ec 0c             	sub    $0xc,%esp
80106d49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d4c:	85 f6                	test   %esi,%esi
80106d4e:	74 59                	je     80106da9 <freevm+0x69>
80106d50:	31 c9                	xor    %ecx,%ecx
80106d52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d57:	89 f0                	mov    %esi,%eax
80106d59:	e8 e2 fa ff ff       	call   80106840 <deallocuvm.part.0>
80106d5e:	89 f3                	mov    %esi,%ebx
80106d60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d66:	eb 0f                	jmp    80106d77 <freevm+0x37>
80106d68:	90                   	nop
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d70:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d73:	39 fb                	cmp    %edi,%ebx
80106d75:	74 23                	je     80106d9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d77:	8b 03                	mov    (%ebx),%eax
80106d79:	a8 01                	test   $0x1,%al
80106d7b:	74 f3                	je     80106d70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106d82:	83 ec 0c             	sub    $0xc,%esp
80106d85:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d88:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106d8d:	50                   	push   %eax
80106d8e:	e8 9d b5 ff ff       	call   80102330 <kfree>
80106d93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106d96:	39 fb                	cmp    %edi,%ebx
80106d98:	75 dd                	jne    80106d77 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106d9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da0:	5b                   	pop    %ebx
80106da1:	5e                   	pop    %esi
80106da2:	5f                   	pop    %edi
80106da3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106da4:	e9 87 b5 ff ff       	jmp    80102330 <kfree>
    panic("freevm: no pgdir");
80106da9:	83 ec 0c             	sub    $0xc,%esp
80106dac:	68 dd 79 10 80       	push   $0x801079dd
80106db1:	e8 da 95 ff ff       	call   80100390 <panic>
80106db6:	8d 76 00             	lea    0x0(%esi),%esi
80106db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dc0 <setupkvm>:
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	56                   	push   %esi
80106dc4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106dc5:	e8 16 b7 ff ff       	call   801024e0 <kalloc>
80106dca:	85 c0                	test   %eax,%eax
80106dcc:	89 c6                	mov    %eax,%esi
80106dce:	74 42                	je     80106e12 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106dd0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106dd3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106dd8:	68 00 10 00 00       	push   $0x1000
80106ddd:	6a 00                	push   $0x0
80106ddf:	50                   	push   %eax
80106de0:	e8 eb d7 ff ff       	call   801045d0 <memset>
80106de5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106de8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106deb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106dee:	83 ec 08             	sub    $0x8,%esp
80106df1:	8b 13                	mov    (%ebx),%edx
80106df3:	ff 73 0c             	pushl  0xc(%ebx)
80106df6:	50                   	push   %eax
80106df7:	29 c1                	sub    %eax,%ecx
80106df9:	89 f0                	mov    %esi,%eax
80106dfb:	e8 b0 f9 ff ff       	call   801067b0 <mappages>
80106e00:	83 c4 10             	add    $0x10,%esp
80106e03:	85 c0                	test   %eax,%eax
80106e05:	78 19                	js     80106e20 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e07:	83 c3 10             	add    $0x10,%ebx
80106e0a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106e10:	75 d6                	jne    80106de8 <setupkvm+0x28>
}
80106e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e15:	89 f0                	mov    %esi,%eax
80106e17:	5b                   	pop    %ebx
80106e18:	5e                   	pop    %esi
80106e19:	5d                   	pop    %ebp
80106e1a:	c3                   	ret    
80106e1b:	90                   	nop
80106e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106e20:	83 ec 0c             	sub    $0xc,%esp
80106e23:	56                   	push   %esi
      return 0;
80106e24:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106e26:	e8 15 ff ff ff       	call   80106d40 <freevm>
      return 0;
80106e2b:	83 c4 10             	add    $0x10,%esp
}
80106e2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e31:	89 f0                	mov    %esi,%eax
80106e33:	5b                   	pop    %ebx
80106e34:	5e                   	pop    %esi
80106e35:	5d                   	pop    %ebp
80106e36:	c3                   	ret    
80106e37:	89 f6                	mov    %esi,%esi
80106e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e40 <kvmalloc>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e46:	e8 75 ff ff ff       	call   80106dc0 <setupkvm>
80106e4b:	a3 c4 57 11 80       	mov    %eax,0x801157c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e50:	05 00 00 00 80       	add    $0x80000000,%eax
80106e55:	0f 22 d8             	mov    %eax,%cr3
}
80106e58:	c9                   	leave  
80106e59:	c3                   	ret    
80106e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e61:	31 c9                	xor    %ecx,%ecx
{
80106e63:	89 e5                	mov    %esp,%ebp
80106e65:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106e68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e6e:	e8 bd f8 ff ff       	call   80106730 <walkpgdir>
  if(pte == 0)
80106e73:	85 c0                	test   %eax,%eax
80106e75:	74 05                	je     80106e7c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106e77:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106e7a:	c9                   	leave  
80106e7b:	c3                   	ret    
    panic("clearpteu");
80106e7c:	83 ec 0c             	sub    $0xc,%esp
80106e7f:	68 ee 79 10 80       	push   $0x801079ee
80106e84:	e8 07 95 ff ff       	call   80100390 <panic>
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e99:	e8 22 ff ff ff       	call   80106dc0 <setupkvm>
80106e9e:	85 c0                	test   %eax,%eax
80106ea0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ea3:	0f 84 a0 00 00 00    	je     80106f49 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106eac:	85 c9                	test   %ecx,%ecx
80106eae:	0f 84 95 00 00 00    	je     80106f49 <copyuvm+0xb9>
80106eb4:	31 f6                	xor    %esi,%esi
80106eb6:	eb 4e                	jmp    80106f06 <copyuvm+0x76>
80106eb8:	90                   	nop
80106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ec0:	83 ec 04             	sub    $0x4,%esp
80106ec3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106ec9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ecc:	68 00 10 00 00       	push   $0x1000
80106ed1:	57                   	push   %edi
80106ed2:	50                   	push   %eax
80106ed3:	e8 a8 d7 ff ff       	call   80104680 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106ed8:	58                   	pop    %eax
80106ed9:	5a                   	pop    %edx
80106eda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ee0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ee5:	53                   	push   %ebx
80106ee6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106eec:	52                   	push   %edx
80106eed:	89 f2                	mov    %esi,%edx
80106eef:	e8 bc f8 ff ff       	call   801067b0 <mappages>
80106ef4:	83 c4 10             	add    $0x10,%esp
80106ef7:	85 c0                	test   %eax,%eax
80106ef9:	78 39                	js     80106f34 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80106efb:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f01:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106f04:	76 43                	jbe    80106f49 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f06:	8b 45 08             	mov    0x8(%ebp),%eax
80106f09:	31 c9                	xor    %ecx,%ecx
80106f0b:	89 f2                	mov    %esi,%edx
80106f0d:	e8 1e f8 ff ff       	call   80106730 <walkpgdir>
80106f12:	85 c0                	test   %eax,%eax
80106f14:	74 3e                	je     80106f54 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80106f16:	8b 18                	mov    (%eax),%ebx
80106f18:	f6 c3 01             	test   $0x1,%bl
80106f1b:	74 44                	je     80106f61 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80106f1d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106f1f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80106f25:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106f2b:	e8 b0 b5 ff ff       	call   801024e0 <kalloc>
80106f30:	85 c0                	test   %eax,%eax
80106f32:	75 8c                	jne    80106ec0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106f34:	83 ec 0c             	sub    $0xc,%esp
80106f37:	ff 75 e0             	pushl  -0x20(%ebp)
80106f3a:	e8 01 fe ff ff       	call   80106d40 <freevm>
  return 0;
80106f3f:	83 c4 10             	add    $0x10,%esp
80106f42:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106f49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f4f:	5b                   	pop    %ebx
80106f50:	5e                   	pop    %esi
80106f51:	5f                   	pop    %edi
80106f52:	5d                   	pop    %ebp
80106f53:	c3                   	ret    
      panic("copyuvm: pte should exist");
80106f54:	83 ec 0c             	sub    $0xc,%esp
80106f57:	68 f8 79 10 80       	push   $0x801079f8
80106f5c:	e8 2f 94 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80106f61:	83 ec 0c             	sub    $0xc,%esp
80106f64:	68 12 7a 10 80       	push   $0x80107a12
80106f69:	e8 22 94 ff ff       	call   80100390 <panic>
80106f6e:	66 90                	xchg   %ax,%ax

80106f70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f71:	31 c9                	xor    %ecx,%ecx
{
80106f73:	89 e5                	mov    %esp,%ebp
80106f75:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f78:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f7e:	e8 ad f7 ff ff       	call   80106730 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f83:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f85:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106f86:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106f8d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f90:	05 00 00 00 80       	add    $0x80000000,%eax
80106f95:	83 fa 05             	cmp    $0x5,%edx
80106f98:	ba 00 00 00 00       	mov    $0x0,%edx
80106f9d:	0f 45 c2             	cmovne %edx,%eax
}
80106fa0:	c3                   	ret    
80106fa1:	eb 0d                	jmp    80106fb0 <copyout>
80106fa3:	90                   	nop
80106fa4:	90                   	nop
80106fa5:	90                   	nop
80106fa6:	90                   	nop
80106fa7:	90                   	nop
80106fa8:	90                   	nop
80106fa9:	90                   	nop
80106faa:	90                   	nop
80106fab:	90                   	nop
80106fac:	90                   	nop
80106fad:	90                   	nop
80106fae:	90                   	nop
80106faf:	90                   	nop

80106fb0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
80106fb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fbf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fc2:	85 db                	test   %ebx,%ebx
80106fc4:	75 40                	jne    80107006 <copyout+0x56>
80106fc6:	eb 70                	jmp    80107038 <copyout+0x88>
80106fc8:	90                   	nop
80106fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106fd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106fd3:	89 f1                	mov    %esi,%ecx
80106fd5:	29 d1                	sub    %edx,%ecx
80106fd7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106fdd:	39 d9                	cmp    %ebx,%ecx
80106fdf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106fe2:	29 f2                	sub    %esi,%edx
80106fe4:	83 ec 04             	sub    $0x4,%esp
80106fe7:	01 d0                	add    %edx,%eax
80106fe9:	51                   	push   %ecx
80106fea:	57                   	push   %edi
80106feb:	50                   	push   %eax
80106fec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106fef:	e8 8c d6 ff ff       	call   80104680 <memmove>
    len -= n;
    buf += n;
80106ff4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80106ff7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80106ffa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107000:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107002:	29 cb                	sub    %ecx,%ebx
80107004:	74 32                	je     80107038 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107006:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107008:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010700b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010700e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107014:	56                   	push   %esi
80107015:	ff 75 08             	pushl  0x8(%ebp)
80107018:	e8 53 ff ff ff       	call   80106f70 <uva2ka>
    if(pa0 == 0)
8010701d:	83 c4 10             	add    $0x10,%esp
80107020:	85 c0                	test   %eax,%eax
80107022:	75 ac                	jne    80106fd0 <copyout+0x20>
  }
  return 0;
}
80107024:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107027:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010702c:	5b                   	pop    %ebx
8010702d:	5e                   	pop    %esi
8010702e:	5f                   	pop    %edi
8010702f:	5d                   	pop    %ebp
80107030:	c3                   	ret    
80107031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107038:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010703b:	31 c0                	xor    %eax,%eax
}
8010703d:	5b                   	pop    %ebx
8010703e:	5e                   	pop    %esi
8010703f:	5f                   	pop    %edi
80107040:	5d                   	pop    %ebp
80107041:	c3                   	ret    
