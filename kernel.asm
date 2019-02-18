
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
80100028:	bc 50 db 10 80       	mov    $0x8010db50,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 12 2b 10 80       	mov    $0x80102b12,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	53                   	push   %ebx
80100038:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003b:	68 00 73 10 80       	push   $0x80107300
80100040:	68 60 db 10 80       	push   $0x8010db60
80100045:	e8 23 48 00 00       	call   8010486d <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004a:	c7 05 ac 22 11 80 5c 	movl   $0x8011225c,0x801122ac
80100051:	22 11 80 
  bcache.head.next = &bcache.head;
80100054:	c7 05 b0 22 11 80 5c 	movl   $0x8011225c,0x801122b0
8010005b:	22 11 80 
8010005e:	83 c4 10             	add    $0x10,%esp
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100061:	bb 94 db 10 80       	mov    $0x8010db94,%ebx
    b->next = bcache.head.next;
80100066:	a1 b0 22 11 80       	mov    0x801122b0,%eax
8010006b:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010006e:	c7 43 50 5c 22 11 80 	movl   $0x8011225c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100075:	83 ec 08             	sub    $0x8,%esp
80100078:	68 07 73 10 80       	push   $0x80107307
8010007d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100080:	50                   	push   %eax
80100081:	e8 00 47 00 00       	call   80104786 <initsleeplock>
    bcache.head.next->prev = b;
80100086:	a1 b0 22 11 80       	mov    0x801122b0,%eax
8010008b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010008e:	89 1d b0 22 11 80    	mov    %ebx,0x801122b0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100094:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010009a:	83 c4 10             	add    $0x10,%esp
8010009d:	81 fb 5c 22 11 80    	cmp    $0x8011225c,%ebx
801000a3:	72 c1                	jb     80100066 <binit+0x32>
  }
}
801000a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000a8:	c9                   	leave  
801000a9:	c3                   	ret    

801000aa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000aa:	55                   	push   %ebp
801000ab:	89 e5                	mov    %esp,%ebp
801000ad:	57                   	push   %edi
801000ae:	56                   	push   %esi
801000af:	53                   	push   %ebx
801000b0:	83 ec 18             	sub    $0x18,%esp
801000b3:	8b 75 08             	mov    0x8(%ebp),%esi
801000b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000b9:	68 60 db 10 80       	push   $0x8010db60
801000be:	e8 f2 48 00 00       	call   801049b5 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c3:	8b 1d b0 22 11 80    	mov    0x801122b0,%ebx
801000c9:	83 c4 10             	add    $0x10,%esp
801000cc:	81 fb 5c 22 11 80    	cmp    $0x8011225c,%ebx
801000d2:	75 26                	jne    801000fa <bread+0x50>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000d4:	8b 1d ac 22 11 80    	mov    0x801122ac,%ebx
801000da:	81 fb 5c 22 11 80    	cmp    $0x8011225c,%ebx
801000e0:	75 4e                	jne    80100130 <bread+0x86>
  panic("bget: no buffers");
801000e2:	83 ec 0c             	sub    $0xc,%esp
801000e5:	68 0e 73 10 80       	push   $0x8010730e
801000ea:	e8 55 02 00 00       	call   80100344 <panic>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ef:	8b 5b 54             	mov    0x54(%ebx),%ebx
801000f2:	81 fb 5c 22 11 80    	cmp    $0x8011225c,%ebx
801000f8:	74 da                	je     801000d4 <bread+0x2a>
    if(b->dev == dev && b->blockno == blockno){
801000fa:	3b 73 04             	cmp    0x4(%ebx),%esi
801000fd:	75 f0                	jne    801000ef <bread+0x45>
801000ff:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100102:	75 eb                	jne    801000ef <bread+0x45>
      b->refcnt++;
80100104:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100108:	83 ec 0c             	sub    $0xc,%esp
8010010b:	68 60 db 10 80       	push   $0x8010db60
80100110:	e8 07 49 00 00       	call   80104a1c <release>
      acquiresleep(&b->lock);
80100115:	8d 43 0c             	lea    0xc(%ebx),%eax
80100118:	89 04 24             	mov    %eax,(%esp)
8010011b:	e8 99 46 00 00       	call   801047b9 <acquiresleep>
80100120:	83 c4 10             	add    $0x10,%esp
80100123:	eb 44                	jmp    80100169 <bread+0xbf>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100125:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100128:	81 fb 5c 22 11 80    	cmp    $0x8011225c,%ebx
8010012e:	74 b2                	je     801000e2 <bread+0x38>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100130:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80100134:	75 ef                	jne    80100125 <bread+0x7b>
80100136:	f6 03 04             	testb  $0x4,(%ebx)
80100139:	75 ea                	jne    80100125 <bread+0x7b>
      b->dev = dev;
8010013b:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010013e:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100141:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100147:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	68 60 db 10 80       	push   $0x8010db60
80100156:	e8 c1 48 00 00       	call   80104a1c <release>
      acquiresleep(&b->lock);
8010015b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010015e:	89 04 24             	mov    %eax,(%esp)
80100161:	e8 53 46 00 00       	call   801047b9 <acquiresleep>
80100166:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100169:	f6 03 02             	testb  $0x2,(%ebx)
8010016c:	74 0a                	je     80100178 <bread+0xce>
    iderw(b);
  }
  return b;
}
8010016e:	89 d8                	mov    %ebx,%eax
80100170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100173:	5b                   	pop    %ebx
80100174:	5e                   	pop    %esi
80100175:	5f                   	pop    %edi
80100176:	5d                   	pop    %ebp
80100177:	c3                   	ret    
    iderw(b);
80100178:	83 ec 0c             	sub    $0xc,%esp
8010017b:	53                   	push   %ebx
8010017c:	e8 95 1d 00 00       	call   80101f16 <iderw>
80100181:	83 c4 10             	add    $0x10,%esp
  return b;
80100184:	eb e8                	jmp    8010016e <bread+0xc4>

80100186 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100186:	55                   	push   %ebp
80100187:	89 e5                	mov    %esp,%ebp
80100189:	53                   	push   %ebx
8010018a:	83 ec 10             	sub    $0x10,%esp
8010018d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100190:	8d 43 0c             	lea    0xc(%ebx),%eax
80100193:	50                   	push   %eax
80100194:	e8 ad 46 00 00       	call   80104846 <holdingsleep>
80100199:	83 c4 10             	add    $0x10,%esp
8010019c:	85 c0                	test   %eax,%eax
8010019e:	74 14                	je     801001b4 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001a0:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001a3:	83 ec 0c             	sub    $0xc,%esp
801001a6:	53                   	push   %ebx
801001a7:	e8 6a 1d 00 00       	call   80101f16 <iderw>
}
801001ac:	83 c4 10             	add    $0x10,%esp
801001af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    
    panic("bwrite");
801001b4:	83 ec 0c             	sub    $0xc,%esp
801001b7:	68 1f 73 10 80       	push   $0x8010731f
801001bc:	e8 83 01 00 00       	call   80100344 <panic>

801001c1 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001c1:	55                   	push   %ebp
801001c2:	89 e5                	mov    %esp,%ebp
801001c4:	56                   	push   %esi
801001c5:	53                   	push   %ebx
801001c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001c9:	8d 73 0c             	lea    0xc(%ebx),%esi
801001cc:	83 ec 0c             	sub    $0xc,%esp
801001cf:	56                   	push   %esi
801001d0:	e8 71 46 00 00       	call   80104846 <holdingsleep>
801001d5:	83 c4 10             	add    $0x10,%esp
801001d8:	85 c0                	test   %eax,%eax
801001da:	74 6b                	je     80100247 <brelse+0x86>
    panic("brelse");

  releasesleep(&b->lock);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	56                   	push   %esi
801001e0:	e8 26 46 00 00       	call   8010480b <releasesleep>

  acquire(&bcache.lock);
801001e5:	c7 04 24 60 db 10 80 	movl   $0x8010db60,(%esp)
801001ec:	e8 c4 47 00 00       	call   801049b5 <acquire>
  b->refcnt--;
801001f1:	8b 43 4c             	mov    0x4c(%ebx),%eax
801001f4:	83 e8 01             	sub    $0x1,%eax
801001f7:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
801001fa:	83 c4 10             	add    $0x10,%esp
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 2f                	jne    80100230 <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100201:	8b 43 54             	mov    0x54(%ebx),%eax
80100204:	8b 53 50             	mov    0x50(%ebx),%edx
80100207:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010020a:	8b 43 50             	mov    0x50(%ebx),%eax
8010020d:	8b 53 54             	mov    0x54(%ebx),%edx
80100210:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100213:	a1 b0 22 11 80       	mov    0x801122b0,%eax
80100218:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010021b:	c7 43 50 5c 22 11 80 	movl   $0x8011225c,0x50(%ebx)
    bcache.head.next->prev = b;
80100222:	a1 b0 22 11 80       	mov    0x801122b0,%eax
80100227:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010022a:	89 1d b0 22 11 80    	mov    %ebx,0x801122b0
  }
  
  release(&bcache.lock);
80100230:	83 ec 0c             	sub    $0xc,%esp
80100233:	68 60 db 10 80       	push   $0x8010db60
80100238:	e8 df 47 00 00       	call   80104a1c <release>
}
8010023d:	83 c4 10             	add    $0x10,%esp
80100240:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100243:	5b                   	pop    %ebx
80100244:	5e                   	pop    %esi
80100245:	5d                   	pop    %ebp
80100246:	c3                   	ret    
    panic("brelse");
80100247:	83 ec 0c             	sub    $0xc,%esp
8010024a:	68 26 73 10 80       	push   $0x80107326
8010024f:	e8 f0 00 00 00       	call   80100344 <panic>

80100254 <consoleread>:
  #endif
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100254:	55                   	push   %ebp
80100255:	89 e5                	mov    %esp,%ebp
80100257:	57                   	push   %edi
80100258:	56                   	push   %esi
80100259:	53                   	push   %ebx
8010025a:	83 ec 28             	sub    $0x28,%esp
8010025d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100260:	8b 75 10             	mov    0x10(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
80100263:	ff 75 08             	pushl  0x8(%ebp)
80100266:	e8 c4 13 00 00       	call   8010162f <iunlock>
  target = n;
8010026b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  acquire(&cons.lock);
8010026e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100275:	e8 3b 47 00 00       	call   801049b5 <acquire>
  while(n > 0){
8010027a:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
8010027d:	bb c0 24 11 80       	mov    $0x801124c0,%ebx
  while(n > 0){
80100282:	85 f6                	test   %esi,%esi
80100284:	7e 68                	jle    801002ee <consoleread+0x9a>
    while(input.r == input.w){
80100286:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010028c:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100292:	75 2e                	jne    801002c2 <consoleread+0x6e>
      if(myproc()->killed){
80100294:	e8 10 33 00 00       	call   801035a9 <myproc>
80100299:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010029d:	75 71                	jne    80100310 <consoleread+0xbc>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
8010029f:	83 ec 08             	sub    $0x8,%esp
801002a2:	68 20 a5 10 80       	push   $0x8010a520
801002a7:	68 40 25 11 80       	push   $0x80112540
801002ac:	e8 a6 3a 00 00       	call   80103d57 <sleep>
    while(input.r == input.w){
801002b1:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801002b7:	83 c4 10             	add    $0x10,%esp
801002ba:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
801002c0:	74 d2                	je     80100294 <consoleread+0x40>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002c2:	8d 50 01             	lea    0x1(%eax),%edx
801002c5:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
801002cb:	89 c2                	mov    %eax,%edx
801002cd:	83 e2 7f             	and    $0x7f,%edx
801002d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801002d4:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002d7:	83 fa 04             	cmp    $0x4,%edx
801002da:	74 5c                	je     80100338 <consoleread+0xe4>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002dc:	83 c7 01             	add    $0x1,%edi
801002df:	88 4f ff             	mov    %cl,-0x1(%edi)
    --n;
801002e2:	83 ee 01             	sub    $0x1,%esi
    if(c == '\n')
801002e5:	83 fa 0a             	cmp    $0xa,%edx
801002e8:	74 04                	je     801002ee <consoleread+0x9a>
  while(n > 0){
801002ea:	85 f6                	test   %esi,%esi
801002ec:	75 98                	jne    80100286 <consoleread+0x32>
      break;
  }
  release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 a5 10 80       	push   $0x8010a520
801002f6:	e8 21 47 00 00       	call   80104a1c <release>
  ilock(ip);
801002fb:	83 c4 04             	add    $0x4,%esp
801002fe:	ff 75 08             	pushl  0x8(%ebp)
80100301:	e8 67 12 00 00       	call   8010156d <ilock>

  return target - n;
80100306:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100309:	29 f0                	sub    %esi,%eax
8010030b:	83 c4 10             	add    $0x10,%esp
8010030e:	eb 20                	jmp    80100330 <consoleread+0xdc>
        release(&cons.lock);
80100310:	83 ec 0c             	sub    $0xc,%esp
80100313:	68 20 a5 10 80       	push   $0x8010a520
80100318:	e8 ff 46 00 00       	call   80104a1c <release>
        ilock(ip);
8010031d:	83 c4 04             	add    $0x4,%esp
80100320:	ff 75 08             	pushl  0x8(%ebp)
80100323:	e8 45 12 00 00       	call   8010156d <ilock>
        return -1;
80100328:	83 c4 10             	add    $0x10,%esp
8010032b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100333:	5b                   	pop    %ebx
80100334:	5e                   	pop    %esi
80100335:	5f                   	pop    %edi
80100336:	5d                   	pop    %ebp
80100337:	c3                   	ret    
      if(n < target){
80100338:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010033b:	73 b1                	jae    801002ee <consoleread+0x9a>
        input.r--;
8010033d:	a3 40 25 11 80       	mov    %eax,0x80112540
80100342:	eb aa                	jmp    801002ee <consoleread+0x9a>

80100344 <panic>:
{
80100344:	55                   	push   %ebp
80100345:	89 e5                	mov    %esp,%ebp
80100347:	56                   	push   %esi
80100348:	53                   	push   %ebx
80100349:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010034c:	fa                   	cli    
  cons.locking = 0;
8010034d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100354:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100357:	e8 6b 21 00 00       	call   801024c7 <lapicid>
8010035c:	83 ec 08             	sub    $0x8,%esp
8010035f:	50                   	push   %eax
80100360:	68 2d 73 10 80       	push   $0x8010732d
80100365:	e8 77 02 00 00       	call   801005e1 <cprintf>
  cprintf(s);
8010036a:	83 c4 04             	add    $0x4,%esp
8010036d:	ff 75 08             	pushl  0x8(%ebp)
80100370:	e8 6c 02 00 00       	call   801005e1 <cprintf>
  cprintf("\n");
80100375:	c7 04 24 5f 7f 10 80 	movl   $0x80107f5f,(%esp)
8010037c:	e8 60 02 00 00       	call   801005e1 <cprintf>
  getcallerpcs(&s, pcs);
80100381:	83 c4 08             	add    $0x8,%esp
80100384:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100387:	53                   	push   %ebx
80100388:	8d 45 08             	lea    0x8(%ebp),%eax
8010038b:	50                   	push   %eax
8010038c:	e8 f7 44 00 00       	call   80104888 <getcallerpcs>
80100391:	8d 75 f8             	lea    -0x8(%ebp),%esi
80100394:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100397:	83 ec 08             	sub    $0x8,%esp
8010039a:	ff 33                	pushl  (%ebx)
8010039c:	68 41 73 10 80       	push   $0x80107341
801003a1:	e8 3b 02 00 00       	call   801005e1 <cprintf>
801003a6:	83 c3 04             	add    $0x4,%ebx
  for(i=0; i<10; i++)
801003a9:	83 c4 10             	add    $0x10,%esp
801003ac:	39 f3                	cmp    %esi,%ebx
801003ae:	75 e7                	jne    80100397 <panic+0x53>
  panicked = 1; // freeze other CPU
801003b0:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003b7:	00 00 00 
801003ba:	eb fe                	jmp    801003ba <panic+0x76>

801003bc <consputc>:
  if(panicked){
801003bc:	83 3d 58 a5 10 80 00 	cmpl   $0x0,0x8010a558
801003c3:	74 03                	je     801003c8 <consputc+0xc>
801003c5:	fa                   	cli    
801003c6:	eb fe                	jmp    801003c6 <consputc+0xa>
{
801003c8:	55                   	push   %ebp
801003c9:	89 e5                	mov    %esp,%ebp
801003cb:	57                   	push   %edi
801003cc:	56                   	push   %esi
801003cd:	53                   	push   %ebx
801003ce:	83 ec 0c             	sub    $0xc,%esp
801003d1:	89 c6                	mov    %eax,%esi
  if(c == BACKSPACE){
801003d3:	3d 00 01 00 00       	cmp    $0x100,%eax
801003d8:	74 5f                	je     80100439 <consputc+0x7d>
    uartputc(c);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	50                   	push   %eax
801003de:	e8 63 5b 00 00       	call   80105f46 <uartputc>
801003e3:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e6:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801003eb:	b8 0e 00 00 00       	mov    $0xe,%eax
801003f0:	89 da                	mov    %ebx,%edx
801003f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003f8:	89 ca                	mov    %ecx,%edx
801003fa:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003fb:	0f b6 c0             	movzbl %al,%eax
801003fe:	c1 e0 08             	shl    $0x8,%eax
80100401:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100403:	b8 0f 00 00 00       	mov    $0xf,%eax
80100408:	89 da                	mov    %ebx,%edx
8010040a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010040b:	89 ca                	mov    %ecx,%edx
8010040d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010040e:	0f b6 d8             	movzbl %al,%ebx
80100411:	09 fb                	or     %edi,%ebx
  if(c == '\n')
80100413:	83 fe 0a             	cmp    $0xa,%esi
80100416:	74 48                	je     80100460 <consputc+0xa4>
  else if(c == BACKSPACE){
80100418:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010041e:	0f 84 93 00 00 00    	je     801004b7 <consputc+0xfb>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100424:	89 f0                	mov    %esi,%eax
80100426:	0f b6 c0             	movzbl %al,%eax
80100429:	80 cc 07             	or     $0x7,%ah
8010042c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100433:	80 
80100434:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100437:	eb 35                	jmp    8010046e <consputc+0xb2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100439:	83 ec 0c             	sub    $0xc,%esp
8010043c:	6a 08                	push   $0x8
8010043e:	e8 03 5b 00 00       	call   80105f46 <uartputc>
80100443:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010044a:	e8 f7 5a 00 00       	call   80105f46 <uartputc>
8010044f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100456:	e8 eb 5a 00 00       	call   80105f46 <uartputc>
8010045b:	83 c4 10             	add    $0x10,%esp
8010045e:	eb 86                	jmp    801003e6 <consputc+0x2a>
    pos += 80 - pos%80;
80100460:	b9 50 00 00 00       	mov    $0x50,%ecx
80100465:	89 d8                	mov    %ebx,%eax
80100467:	99                   	cltd   
80100468:	f7 f9                	idiv   %ecx
8010046a:	29 d1                	sub    %edx,%ecx
8010046c:	01 cb                	add    %ecx,%ebx
  if(pos < 0 || pos > 25*80)
8010046e:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100474:	77 4a                	ja     801004c0 <consputc+0x104>
  if((pos/80) >= 24){  // Scroll up.
80100476:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010047c:	7f 4f                	jg     801004cd <consputc+0x111>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010047e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100483:	b8 0e 00 00 00       	mov    $0xe,%eax
80100488:	89 f2                	mov    %esi,%edx
8010048a:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
8010048b:	89 d8                	mov    %ebx,%eax
8010048d:	c1 f8 08             	sar    $0x8,%eax
80100490:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100495:	89 ca                	mov    %ecx,%edx
80100497:	ee                   	out    %al,(%dx)
80100498:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049d:	89 f2                	mov    %esi,%edx
8010049f:	ee                   	out    %al,(%dx)
801004a0:	89 d8                	mov    %ebx,%eax
801004a2:	89 ca                	mov    %ecx,%edx
801004a4:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a5:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
801004ac:	80 20 07 
}
801004af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004b2:	5b                   	pop    %ebx
801004b3:	5e                   	pop    %esi
801004b4:	5f                   	pop    %edi
801004b5:	5d                   	pop    %ebp
801004b6:	c3                   	ret    
    if(pos > 0) --pos;
801004b7:	85 db                	test   %ebx,%ebx
801004b9:	7e b3                	jle    8010046e <consputc+0xb2>
801004bb:	83 eb 01             	sub    $0x1,%ebx
801004be:	eb ae                	jmp    8010046e <consputc+0xb2>
    panic("pos under/overflow");
801004c0:	83 ec 0c             	sub    $0xc,%esp
801004c3:	68 45 73 10 80       	push   $0x80107345
801004c8:	e8 77 fe ff ff       	call   80100344 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004cd:	83 ec 04             	sub    $0x4,%esp
801004d0:	68 60 0e 00 00       	push   $0xe60
801004d5:	68 a0 80 0b 80       	push   $0x800b80a0
801004da:	68 00 80 0b 80       	push   $0x800b8000
801004df:	e8 14 46 00 00       	call   80104af8 <memmove>
    pos -= 80;
801004e4:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004e7:	83 c4 0c             	add    $0xc,%esp
801004ea:	b8 80 07 00 00       	mov    $0x780,%eax
801004ef:	29 d8                	sub    %ebx,%eax
801004f1:	01 c0                	add    %eax,%eax
801004f3:	50                   	push   %eax
801004f4:	6a 00                	push   $0x0
801004f6:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
801004f9:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
801004fe:	50                   	push   %eax
801004ff:	e8 5f 45 00 00       	call   80104a63 <memset>
80100504:	83 c4 10             	add    $0x10,%esp
80100507:	e9 72 ff ff ff       	jmp    8010047e <consputc+0xc2>

8010050c <printint>:
{
8010050c:	55                   	push   %ebp
8010050d:	89 e5                	mov    %esp,%ebp
8010050f:	57                   	push   %edi
80100510:	56                   	push   %esi
80100511:	53                   	push   %ebx
80100512:	83 ec 1c             	sub    $0x1c,%esp
80100515:	89 d6                	mov    %edx,%esi
  if(sign && (sign = xx < 0))
80100517:	85 c9                	test   %ecx,%ecx
80100519:	74 04                	je     8010051f <printint+0x13>
8010051b:	85 c0                	test   %eax,%eax
8010051d:	78 0e                	js     8010052d <printint+0x21>
    x = xx;
8010051f:	89 c2                	mov    %eax,%edx
80100521:	bf 00 00 00 00       	mov    $0x0,%edi
  i = 0;
80100526:	b9 00 00 00 00       	mov    $0x0,%ecx
8010052b:	eb 0d                	jmp    8010053a <printint+0x2e>
    x = -xx;
8010052d:	f7 d8                	neg    %eax
8010052f:	89 c2                	mov    %eax,%edx
  if(sign && (sign = xx < 0))
80100531:	bf 01 00 00 00       	mov    $0x1,%edi
    x = -xx;
80100536:	eb ee                	jmp    80100526 <printint+0x1a>
    buf[i++] = digits[x % base];
80100538:	89 d9                	mov    %ebx,%ecx
8010053a:	8d 59 01             	lea    0x1(%ecx),%ebx
8010053d:	89 d0                	mov    %edx,%eax
8010053f:	ba 00 00 00 00       	mov    $0x0,%edx
80100544:	f7 f6                	div    %esi
80100546:	0f b6 92 70 73 10 80 	movzbl -0x7fef8c90(%edx),%edx
8010054d:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100551:	89 c2                	mov    %eax,%edx
80100553:	85 c0                	test   %eax,%eax
80100555:	75 e1                	jne    80100538 <printint+0x2c>
  if(sign)
80100557:	85 ff                	test   %edi,%edi
80100559:	74 08                	je     80100563 <printint+0x57>
    buf[i++] = '-';
8010055b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100560:	8d 59 02             	lea    0x2(%ecx),%ebx
  while(--i >= 0)
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	78 12                	js     8010057a <printint+0x6e>
    consputc(buf[i]);
80100568:	0f be 44 2b d8       	movsbl -0x28(%ebx,%ebp,1),%eax
8010056d:	e8 4a fe ff ff       	call   801003bc <consputc>
  while(--i >= 0)
80100572:	83 eb 01             	sub    $0x1,%ebx
80100575:	83 fb ff             	cmp    $0xffffffff,%ebx
80100578:	75 ee                	jne    80100568 <printint+0x5c>
}
8010057a:	83 c4 1c             	add    $0x1c,%esp
8010057d:	5b                   	pop    %ebx
8010057e:	5e                   	pop    %esi
8010057f:	5f                   	pop    %edi
80100580:	5d                   	pop    %ebp
80100581:	c3                   	ret    

80100582 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100582:	55                   	push   %ebp
80100583:	89 e5                	mov    %esp,%ebp
80100585:	57                   	push   %edi
80100586:	56                   	push   %esi
80100587:	53                   	push   %ebx
80100588:	83 ec 18             	sub    $0x18,%esp
8010058b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010058e:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  iunlock(ip);
80100591:	ff 75 08             	pushl  0x8(%ebp)
80100594:	e8 96 10 00 00       	call   8010162f <iunlock>
  acquire(&cons.lock);
80100599:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005a0:	e8 10 44 00 00       	call   801049b5 <acquire>
  for(i = 0; i < n; i++)
801005a5:	83 c4 10             	add    $0x10,%esp
801005a8:	85 ff                	test   %edi,%edi
801005aa:	7e 13                	jle    801005bf <consolewrite+0x3d>
801005ac:	89 f3                	mov    %esi,%ebx
801005ae:	01 fe                	add    %edi,%esi
    consputc(buf[i] & 0xff);
801005b0:	0f b6 03             	movzbl (%ebx),%eax
801005b3:	e8 04 fe ff ff       	call   801003bc <consputc>
801005b8:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; i < n; i++)
801005bb:	39 f3                	cmp    %esi,%ebx
801005bd:	75 f1                	jne    801005b0 <consolewrite+0x2e>
  release(&cons.lock);
801005bf:	83 ec 0c             	sub    $0xc,%esp
801005c2:	68 20 a5 10 80       	push   $0x8010a520
801005c7:	e8 50 44 00 00       	call   80104a1c <release>
  ilock(ip);
801005cc:	83 c4 04             	add    $0x4,%esp
801005cf:	ff 75 08             	pushl  0x8(%ebp)
801005d2:	e8 96 0f 00 00       	call   8010156d <ilock>

  return n;
}
801005d7:	89 f8                	mov    %edi,%eax
801005d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005dc:	5b                   	pop    %ebx
801005dd:	5e                   	pop    %esi
801005de:	5f                   	pop    %edi
801005df:	5d                   	pop    %ebp
801005e0:	c3                   	ret    

801005e1 <cprintf>:
{
801005e1:	55                   	push   %ebp
801005e2:	89 e5                	mov    %esp,%ebp
801005e4:	57                   	push   %edi
801005e5:	56                   	push   %esi
801005e6:	53                   	push   %ebx
801005e7:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801005ea:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801005f2:	85 c0                	test   %eax,%eax
801005f4:	75 2b                	jne    80100621 <cprintf+0x40>
  if (fmt == 0)
801005f6:	8b 7d 08             	mov    0x8(%ebp),%edi
801005f9:	85 ff                	test   %edi,%edi
801005fb:	74 36                	je     80100633 <cprintf+0x52>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005fd:	0f b6 07             	movzbl (%edi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100600:	8d 4d 0c             	lea    0xc(%ebp),%ecx
80100603:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100606:	bb 00 00 00 00       	mov    $0x0,%ebx
8010060b:	85 c0                	test   %eax,%eax
8010060d:	75 41                	jne    80100650 <cprintf+0x6f>
  if(locking)
8010060f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100613:	0f 85 0d 01 00 00    	jne    80100726 <cprintf+0x145>
}
80100619:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010061c:	5b                   	pop    %ebx
8010061d:	5e                   	pop    %esi
8010061e:	5f                   	pop    %edi
8010061f:	5d                   	pop    %ebp
80100620:	c3                   	ret    
    acquire(&cons.lock);
80100621:	83 ec 0c             	sub    $0xc,%esp
80100624:	68 20 a5 10 80       	push   $0x8010a520
80100629:	e8 87 43 00 00       	call   801049b5 <acquire>
8010062e:	83 c4 10             	add    $0x10,%esp
80100631:	eb c3                	jmp    801005f6 <cprintf+0x15>
    panic("null fmt");
80100633:	83 ec 0c             	sub    $0xc,%esp
80100636:	68 5f 73 10 80       	push   $0x8010735f
8010063b:	e8 04 fd ff ff       	call   80100344 <panic>
      consputc(c);
80100640:	e8 77 fd ff ff       	call   801003bc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100645:	83 c3 01             	add    $0x1,%ebx
80100648:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
8010064c:	85 c0                	test   %eax,%eax
8010064e:	74 bf                	je     8010060f <cprintf+0x2e>
    if(c != '%'){
80100650:	83 f8 25             	cmp    $0x25,%eax
80100653:	75 eb                	jne    80100640 <cprintf+0x5f>
    c = fmt[++i] & 0xff;
80100655:	83 c3 01             	add    $0x1,%ebx
80100658:	0f b6 34 1f          	movzbl (%edi,%ebx,1),%esi
    if(c == 0)
8010065c:	85 f6                	test   %esi,%esi
8010065e:	74 af                	je     8010060f <cprintf+0x2e>
    switch(c){
80100660:	83 fe 70             	cmp    $0x70,%esi
80100663:	74 4c                	je     801006b1 <cprintf+0xd0>
80100665:	83 fe 70             	cmp    $0x70,%esi
80100668:	7f 2a                	jg     80100694 <cprintf+0xb3>
8010066a:	83 fe 25             	cmp    $0x25,%esi
8010066d:	0f 84 a4 00 00 00    	je     80100717 <cprintf+0x136>
80100673:	83 fe 64             	cmp    $0x64,%esi
80100676:	75 26                	jne    8010069e <cprintf+0xbd>
      printint(*argp++, 10, 1);
80100678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010067b:	8d 70 04             	lea    0x4(%eax),%esi
8010067e:	b9 01 00 00 00       	mov    $0x1,%ecx
80100683:	ba 0a 00 00 00       	mov    $0xa,%edx
80100688:	8b 00                	mov    (%eax),%eax
8010068a:	e8 7d fe ff ff       	call   8010050c <printint>
8010068f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
80100692:	eb b1                	jmp    80100645 <cprintf+0x64>
    switch(c){
80100694:	83 fe 73             	cmp    $0x73,%esi
80100697:	74 37                	je     801006d0 <cprintf+0xef>
80100699:	83 fe 78             	cmp    $0x78,%esi
8010069c:	74 13                	je     801006b1 <cprintf+0xd0>
      consputc('%');
8010069e:	b8 25 00 00 00       	mov    $0x25,%eax
801006a3:	e8 14 fd ff ff       	call   801003bc <consputc>
      consputc(c);
801006a8:	89 f0                	mov    %esi,%eax
801006aa:	e8 0d fd ff ff       	call   801003bc <consputc>
      break;
801006af:	eb 94                	jmp    80100645 <cprintf+0x64>
      printint(*argp++, 16, 0);
801006b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006b4:	8d 70 04             	lea    0x4(%eax),%esi
801006b7:	b9 00 00 00 00       	mov    $0x0,%ecx
801006bc:	ba 10 00 00 00       	mov    $0x10,%edx
801006c1:	8b 00                	mov    (%eax),%eax
801006c3:	e8 44 fe ff ff       	call   8010050c <printint>
801006c8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
801006cb:	e9 75 ff ff ff       	jmp    80100645 <cprintf+0x64>
      if((s = (char*)*argp++) == 0)
801006d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006d3:	8d 50 04             	lea    0x4(%eax),%edx
801006d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
801006d9:	8b 00                	mov    (%eax),%eax
801006db:	85 c0                	test   %eax,%eax
801006dd:	74 11                	je     801006f0 <cprintf+0x10f>
801006df:	89 c6                	mov    %eax,%esi
      for(; *s; s++)
801006e1:	0f b6 00             	movzbl (%eax),%eax
      if((s = (char*)*argp++) == 0)
801006e4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      for(; *s; s++)
801006e7:	84 c0                	test   %al,%al
801006e9:	75 0f                	jne    801006fa <cprintf+0x119>
801006eb:	e9 55 ff ff ff       	jmp    80100645 <cprintf+0x64>
        s = "(null)";
801006f0:	be 58 73 10 80       	mov    $0x80107358,%esi
      for(; *s; s++)
801006f5:	b8 28 00 00 00       	mov    $0x28,%eax
        consputc(*s);
801006fa:	0f be c0             	movsbl %al,%eax
801006fd:	e8 ba fc ff ff       	call   801003bc <consputc>
      for(; *s; s++)
80100702:	83 c6 01             	add    $0x1,%esi
80100705:	0f b6 06             	movzbl (%esi),%eax
80100708:	84 c0                	test   %al,%al
8010070a:	75 ee                	jne    801006fa <cprintf+0x119>
      if((s = (char*)*argp++) == 0)
8010070c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	e9 2e ff ff ff       	jmp    80100645 <cprintf+0x64>
      consputc('%');
80100717:	b8 25 00 00 00       	mov    $0x25,%eax
8010071c:	e8 9b fc ff ff       	call   801003bc <consputc>
      break;
80100721:	e9 1f ff ff ff       	jmp    80100645 <cprintf+0x64>
    release(&cons.lock);
80100726:	83 ec 0c             	sub    $0xc,%esp
80100729:	68 20 a5 10 80       	push   $0x8010a520
8010072e:	e8 e9 42 00 00       	call   80104a1c <release>
80100733:	83 c4 10             	add    $0x10,%esp
}
80100736:	e9 de fe ff ff       	jmp    80100619 <cprintf+0x38>

8010073b <consoleintr>:
{
8010073b:	55                   	push   %ebp
8010073c:	89 e5                	mov    %esp,%ebp
8010073e:	57                   	push   %edi
8010073f:	56                   	push   %esi
80100740:	53                   	push   %ebx
80100741:	83 ec 28             	sub    $0x28,%esp
80100744:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100747:	68 20 a5 10 80       	push   $0x8010a520
8010074c:	e8 64 42 00 00       	call   801049b5 <acquire>
  while((c = getc()) >= 0){
80100751:	83 c4 10             	add    $0x10,%esp
  int which = -1;
80100754:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  int c, doprocdump = 0;
8010075b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100762:	be c0 24 11 80       	mov    $0x801124c0,%esi
  while((c = getc()) >= 0){
80100767:	ff d7                	call   *%edi
80100769:	89 c3                	mov    %eax,%ebx
8010076b:	85 c0                	test   %eax,%eax
8010076d:	0f 88 6c 01 00 00    	js     801008df <consoleintr+0x1a4>
    switch(c){
80100773:	83 fb 12             	cmp    $0x12,%ebx
80100776:	0f 84 e6 00 00 00    	je     80100862 <consoleintr+0x127>
8010077c:	83 fb 12             	cmp    $0x12,%ebx
8010077f:	7e 24                	jle    801007a5 <consoleintr+0x6a>
80100781:	83 fb 15             	cmp    $0x15,%ebx
80100784:	0f 84 e4 00 00 00    	je     8010086e <consoleintr+0x133>
8010078a:	83 fb 15             	cmp    $0x15,%ebx
8010078d:	0f 8e 8f 00 00 00    	jle    80100822 <consoleintr+0xe7>
80100793:	83 fb 1a             	cmp    $0x1a,%ebx
80100796:	0f 85 97 00 00 00    	jne    80100833 <consoleintr+0xf8>
      which = 5;
8010079c:	c7 45 e4 05 00 00 00 	movl   $0x5,-0x1c(%ebp)
      break;
801007a3:	eb c2                	jmp    80100767 <consoleintr+0x2c>
    switch(c){
801007a5:	83 fb 08             	cmp    $0x8,%ebx
801007a8:	0f 84 8a 00 00 00    	je     80100838 <consoleintr+0xfd>
801007ae:	83 fb 10             	cmp    $0x10,%ebx
801007b1:	0f 84 1c 01 00 00    	je     801008d3 <consoleintr+0x198>
801007b7:	83 fb 06             	cmp    $0x6,%ebx
801007ba:	0f 84 07 01 00 00    	je     801008c7 <consoleintr+0x18c>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007c0:	85 db                	test   %ebx,%ebx
801007c2:	74 a3                	je     80100767 <consoleintr+0x2c>
801007c4:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
801007ca:	89 c2                	mov    %eax,%edx
801007cc:	2b 96 80 00 00 00    	sub    0x80(%esi),%edx
801007d2:	83 fa 7f             	cmp    $0x7f,%edx
801007d5:	77 90                	ja     80100767 <consoleintr+0x2c>
        c = (c == '\r') ? '\n' : c;
801007d7:	83 fb 0d             	cmp    $0xd,%ebx
801007da:	0f 84 38 01 00 00    	je     80100918 <consoleintr+0x1dd>
        input.buf[input.e++ % INPUT_BUF] = c;
801007e0:	8d 50 01             	lea    0x1(%eax),%edx
801007e3:	89 96 88 00 00 00    	mov    %edx,0x88(%esi)
801007e9:	83 e0 7f             	and    $0x7f,%eax
801007ec:	88 1c 06             	mov    %bl,(%esi,%eax,1)
        consputc(c);
801007ef:	89 d8                	mov    %ebx,%eax
801007f1:	e8 c6 fb ff ff       	call   801003bc <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007f6:	83 fb 0a             	cmp    $0xa,%ebx
801007f9:	0f 84 33 01 00 00    	je     80100932 <consoleintr+0x1f7>
801007ff:	83 fb 04             	cmp    $0x4,%ebx
80100802:	0f 84 2a 01 00 00    	je     80100932 <consoleintr+0x1f7>
80100808:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
8010080e:	83 e8 80             	sub    $0xffffff80,%eax
80100811:	39 86 88 00 00 00    	cmp    %eax,0x88(%esi)
80100817:	0f 85 4a ff ff ff    	jne    80100767 <consoleintr+0x2c>
8010081d:	e9 10 01 00 00       	jmp    80100932 <consoleintr+0x1f7>
    switch(c){
80100822:	83 fb 13             	cmp    $0x13,%ebx
80100825:	75 99                	jne    801007c0 <consoleintr+0x85>
      which = 2;
80100827:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
      break;
8010082e:	e9 34 ff ff ff       	jmp    80100767 <consoleintr+0x2c>
    switch(c){
80100833:	83 fb 7f             	cmp    $0x7f,%ebx
80100836:	75 88                	jne    801007c0 <consoleintr+0x85>
      if(input.e != input.w){
80100838:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
8010083e:	3b 86 84 00 00 00    	cmp    0x84(%esi),%eax
80100844:	0f 84 1d ff ff ff    	je     80100767 <consoleintr+0x2c>
        input.e--;
8010084a:	83 e8 01             	sub    $0x1,%eax
8010084d:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
        consputc(BACKSPACE);
80100853:	b8 00 01 00 00       	mov    $0x100,%eax
80100858:	e8 5f fb ff ff       	call   801003bc <consputc>
8010085d:	e9 05 ff ff ff       	jmp    80100767 <consoleintr+0x2c>
      which = 3; 
80100862:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
80100869:	e9 f9 fe ff ff       	jmp    80100767 <consoleintr+0x2c>
      while(input.e != input.w &&
8010086e:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
80100874:	3b 86 84 00 00 00    	cmp    0x84(%esi),%eax
8010087a:	0f 84 e7 fe ff ff    	je     80100767 <consoleintr+0x2c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100880:	83 e8 01             	sub    $0x1,%eax
80100883:	89 c2                	mov    %eax,%edx
80100885:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100888:	80 3c 16 0a          	cmpb   $0xa,(%esi,%edx,1)
8010088c:	0f 84 d5 fe ff ff    	je     80100767 <consoleintr+0x2c>
        input.e--;
80100892:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
        consputc(BACKSPACE);
80100898:	b8 00 01 00 00       	mov    $0x100,%eax
8010089d:	e8 1a fb ff ff       	call   801003bc <consputc>
      while(input.e != input.w &&
801008a2:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
801008a8:	3b 86 84 00 00 00    	cmp    0x84(%esi),%eax
801008ae:	0f 84 b3 fe ff ff    	je     80100767 <consoleintr+0x2c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008b4:	83 e8 01             	sub    $0x1,%eax
801008b7:	89 c2                	mov    %eax,%edx
801008b9:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008bc:	80 3c 16 0a          	cmpb   $0xa,(%esi,%edx,1)
801008c0:	75 d0                	jne    80100892 <consoleintr+0x157>
801008c2:	e9 a0 fe ff ff       	jmp    80100767 <consoleintr+0x2c>
      which = 0;
801008c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      break;
801008ce:	e9 94 fe ff ff       	jmp    80100767 <consoleintr+0x2c>
      doprocdump = 1;
801008d3:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
801008da:	e9 88 fe ff ff       	jmp    80100767 <consoleintr+0x2c>
  release(&cons.lock);
801008df:	83 ec 0c             	sub    $0xc,%esp
801008e2:	68 20 a5 10 80       	push   $0x8010a520
801008e7:	e8 30 41 00 00       	call   80104a1c <release>
  if(doprocdump) {
801008ec:	83 c4 10             	add    $0x10,%esp
801008ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801008f3:	75 1c                	jne    80100911 <consoleintr+0x1d6>
  if(which != -1)
801008f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801008f8:	83 f8 ff             	cmp    $0xffffffff,%eax
801008fb:	74 0c                	je     80100909 <consoleintr+0x1ce>
    traverse(which);
801008fd:	83 ec 0c             	sub    $0xc,%esp
80100900:	50                   	push   %eax
80100901:	e8 7d 2e 00 00       	call   80103783 <traverse>
80100906:	83 c4 10             	add    $0x10,%esp
}
80100909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010090c:	5b                   	pop    %ebx
8010090d:	5e                   	pop    %esi
8010090e:	5f                   	pop    %edi
8010090f:	5d                   	pop    %ebp
80100910:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
80100911:	e8 be 3b 00 00       	call   801044d4 <procdump>
80100916:	eb dd                	jmp    801008f5 <consoleintr+0x1ba>
        input.buf[input.e++ % INPUT_BUF] = c;
80100918:	8d 50 01             	lea    0x1(%eax),%edx
8010091b:	89 96 88 00 00 00    	mov    %edx,0x88(%esi)
80100921:	83 e0 7f             	and    $0x7f,%eax
80100924:	c6 04 06 0a          	movb   $0xa,(%esi,%eax,1)
        consputc(c);
80100928:	b8 0a 00 00 00       	mov    $0xa,%eax
8010092d:	e8 8a fa ff ff       	call   801003bc <consputc>
          input.w = input.e;
80100932:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
80100938:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
          wakeup(&input.r);
8010093e:	83 ec 0c             	sub    $0xc,%esp
80100941:	68 40 25 11 80       	push   $0x80112540
80100946:	e8 ff 36 00 00       	call   8010404a <wakeup>
8010094b:	83 c4 10             	add    $0x10,%esp
8010094e:	e9 14 fe ff ff       	jmp    80100767 <consoleintr+0x2c>

80100953 <consoleinit>:

void
consoleinit(void)
{
80100953:	55                   	push   %ebp
80100954:	89 e5                	mov    %esp,%ebp
80100956:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100959:	68 68 73 10 80       	push   $0x80107368
8010095e:	68 20 a5 10 80       	push   $0x8010a520
80100963:	e8 05 3f 00 00       	call   8010486d <initlock>

  devsw[CONSOLE].write = consolewrite;
80100968:	c7 05 0c 2f 11 80 82 	movl   $0x80100582,0x80112f0c
8010096f:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100972:	c7 05 08 2f 11 80 54 	movl   $0x80100254,0x80112f08
80100979:	02 10 80 
  cons.locking = 1;
8010097c:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100983:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100986:	83 c4 08             	add    $0x8,%esp
80100989:	6a 00                	push   $0x0
8010098b:	6a 01                	push   $0x1
8010098d:	e8 fb 16 00 00       	call   8010208d <ioapicenable>
}
80100992:	83 c4 10             	add    $0x10,%esp
80100995:	c9                   	leave  
80100996:	c3                   	ret    

80100997 <exec>:
#include "elf.h"


int
exec(char *path, char **argv)
{
80100997:	55                   	push   %ebp
80100998:	89 e5                	mov    %esp,%ebp
8010099a:	57                   	push   %edi
8010099b:	56                   	push   %esi
8010099c:	53                   	push   %ebx
8010099d:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009a3:	e8 01 2c 00 00       	call   801035a9 <myproc>
801009a8:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009ae:	e8 81 1e 00 00       	call   80102834 <begin_op>

  if((ip = namei(path)) == 0){
801009b3:	83 ec 0c             	sub    $0xc,%esp
801009b6:	ff 75 08             	pushl  0x8(%ebp)
801009b9:	e8 4c 13 00 00       	call   80101d0a <namei>
801009be:	83 c4 10             	add    $0x10,%esp
801009c1:	85 c0                	test   %eax,%eax
801009c3:	74 42                	je     80100a07 <exec+0x70>
801009c5:	89 c3                	mov    %eax,%ebx
#ifndef PDX_XV6
    cprintf("exec: fail\n");
#endif
    return -1;
  }
  ilock(ip);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	50                   	push   %eax
801009cb:	e8 9d 0b 00 00       	call   8010156d <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d0:	6a 34                	push   $0x34
801009d2:	6a 00                	push   $0x0
801009d4:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009da:	50                   	push   %eax
801009db:	53                   	push   %ebx
801009dc:	e8 20 0e 00 00       	call   80101801 <readi>
801009e1:	83 c4 20             	add    $0x20,%esp
801009e4:	83 f8 34             	cmp    $0x34,%eax
801009e7:	74 2a                	je     80100a13 <exec+0x7c>

bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
801009e9:	83 ec 0c             	sub    $0xc,%esp
801009ec:	53                   	push   %ebx
801009ed:	e8 c4 0d 00 00       	call   801017b6 <iunlockput>
    end_op();
801009f2:	e8 b8 1e 00 00       	call   801028af <end_op>
801009f7:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
801009fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801009ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a02:	5b                   	pop    %ebx
80100a03:	5e                   	pop    %esi
80100a04:	5f                   	pop    %edi
80100a05:	5d                   	pop    %ebp
80100a06:	c3                   	ret    
    end_op();
80100a07:	e8 a3 1e 00 00       	call   801028af <end_op>
    return -1;
80100a0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a11:	eb ec                	jmp    801009ff <exec+0x68>
  if(elf.magic != ELF_MAGIC)
80100a13:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a1a:	45 4c 46 
80100a1d:	75 ca                	jne    801009e9 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
80100a1f:	e8 93 66 00 00       	call   801070b7 <setupkvm>
80100a24:	89 c7                	mov    %eax,%edi
80100a26:	85 c0                	test   %eax,%eax
80100a28:	74 bf                	je     801009e9 <exec+0x52>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a2a:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100a30:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a36:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a3d:	00 
80100a3e:	0f 84 bf 00 00 00    	je     80100b03 <exec+0x16c>
  sz = 0;
80100a44:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a4b:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a4e:	be 00 00 00 00       	mov    $0x0,%esi
80100a53:	eb 12                	jmp    80100a67 <exec+0xd0>
80100a55:	83 c6 01             	add    $0x1,%esi
80100a58:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a5f:	39 f0                	cmp    %esi,%eax
80100a61:	0f 8e a6 00 00 00    	jle    80100b0d <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a67:	6a 20                	push   $0x20
80100a69:	89 f0                	mov    %esi,%eax
80100a6b:	c1 e0 05             	shl    $0x5,%eax
80100a6e:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100a74:	50                   	push   %eax
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	50                   	push   %eax
80100a7c:	53                   	push   %ebx
80100a7d:	e8 7f 0d 00 00       	call   80101801 <readi>
80100a82:	83 c4 10             	add    $0x10,%esp
80100a85:	83 f8 20             	cmp    $0x20,%eax
80100a88:	0f 85 c2 00 00 00    	jne    80100b50 <exec+0x1b9>
    if(ph.type != ELF_PROG_LOAD)
80100a8e:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a95:	75 be                	jne    80100a55 <exec+0xbe>
    if(ph.memsz < ph.filesz)
80100a97:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a9d:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aa3:	0f 82 a7 00 00 00    	jb     80100b50 <exec+0x1b9>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aa9:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100aaf:	0f 82 9b 00 00 00    	jb     80100b50 <exec+0x1b9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ab5:	83 ec 04             	sub    $0x4,%esp
80100ab8:	50                   	push   %eax
80100ab9:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100abf:	57                   	push   %edi
80100ac0:	e8 91 64 00 00       	call   80106f56 <allocuvm>
80100ac5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100acb:	83 c4 10             	add    $0x10,%esp
80100ace:	85 c0                	test   %eax,%eax
80100ad0:	74 7e                	je     80100b50 <exec+0x1b9>
    if(ph.vaddr % PGSIZE != 0)
80100ad2:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ad8:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100add:	75 71                	jne    80100b50 <exec+0x1b9>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100adf:	83 ec 0c             	sub    $0xc,%esp
80100ae2:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100ae8:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100aee:	53                   	push   %ebx
80100aef:	50                   	push   %eax
80100af0:	57                   	push   %edi
80100af1:	e8 23 63 00 00       	call   80106e19 <loaduvm>
80100af6:	83 c4 20             	add    $0x20,%esp
80100af9:	85 c0                	test   %eax,%eax
80100afb:	0f 89 54 ff ff ff    	jns    80100a55 <exec+0xbe>
bad:
80100b01:	eb 4d                	jmp    80100b50 <exec+0x1b9>
  sz = 0;
80100b03:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100b0a:	00 00 00 
  iunlockput(ip);
80100b0d:	83 ec 0c             	sub    $0xc,%esp
80100b10:	53                   	push   %ebx
80100b11:	e8 a0 0c 00 00       	call   801017b6 <iunlockput>
  end_op();
80100b16:	e8 94 1d 00 00       	call   801028af <end_op>
  sz = PGROUNDUP(sz);
80100b1b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b21:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100b2b:	89 c2                	mov    %eax,%edx
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b2d:	83 c4 0c             	add    $0xc,%esp
80100b30:	8d 80 00 20 00 00    	lea    0x2000(%eax),%eax
80100b36:	50                   	push   %eax
80100b37:	52                   	push   %edx
80100b38:	57                   	push   %edi
80100b39:	e8 18 64 00 00       	call   80106f56 <allocuvm>
80100b3e:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b44:	83 c4 10             	add    $0x10,%esp
  ip = 0;
80100b47:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b4c:	85 c0                	test   %eax,%eax
80100b4e:	75 1e                	jne    80100b6e <exec+0x1d7>
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	57                   	push   %edi
80100b54:	e8 eb 64 00 00       	call   80107044 <freevm>
  if(ip){
80100b59:	83 c4 10             	add    $0x10,%esp
80100b5c:	85 db                	test   %ebx,%ebx
80100b5e:	0f 85 85 fe ff ff    	jne    801009e9 <exec+0x52>
  return -1;
80100b64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b69:	e9 91 fe ff ff       	jmp    801009ff <exec+0x68>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b6e:	83 ec 08             	sub    $0x8,%esp
80100b71:	89 c3                	mov    %eax,%ebx
80100b73:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100b79:	50                   	push   %eax
80100b7a:	57                   	push   %edi
80100b7b:	e8 bc 65 00 00       	call   8010713c <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100b80:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b83:	8b 00                	mov    (%eax),%eax
80100b85:	83 c4 10             	add    $0x10,%esp
80100b88:	be 00 00 00 00       	mov    $0x0,%esi
80100b8d:	85 c0                	test   %eax,%eax
80100b8f:	74 5f                	je     80100bf0 <exec+0x259>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	50                   	push   %eax
80100b95:	e8 8c 40 00 00       	call   80104c26 <strlen>
80100b9a:	f7 d0                	not    %eax
80100b9c:	01 d8                	add    %ebx,%eax
80100b9e:	83 e0 fc             	and    $0xfffffffc,%eax
80100ba1:	89 c3                	mov    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ba3:	83 c4 04             	add    $0x4,%esp
80100ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ba9:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bac:	e8 75 40 00 00       	call   80104c26 <strlen>
80100bb1:	83 c0 01             	add    $0x1,%eax
80100bb4:	50                   	push   %eax
80100bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb8:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bbb:	53                   	push   %ebx
80100bbc:	57                   	push   %edi
80100bbd:	e8 b9 66 00 00       	call   8010727b <copyout>
80100bc2:	83 c4 20             	add    $0x20,%esp
80100bc5:	85 c0                	test   %eax,%eax
80100bc7:	0f 88 f4 00 00 00    	js     80100cc1 <exec+0x32a>
    ustack[3+argc] = sp;
80100bcd:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100bd4:	83 c6 01             	add    $0x1,%esi
80100bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bda:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100bdd:	85 c0                	test   %eax,%eax
80100bdf:	74 15                	je     80100bf6 <exec+0x25f>
    if(argc >= MAXARG)
80100be1:	83 fe 20             	cmp    $0x20,%esi
80100be4:	75 ab                	jne    80100b91 <exec+0x1fa>
  ip = 0;
80100be6:	bb 00 00 00 00       	mov    $0x0,%ebx
80100beb:	e9 60 ff ff ff       	jmp    80100b50 <exec+0x1b9>
  sp = sz;
80100bf0:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
  ustack[3+argc] = 0;
80100bf6:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100bfd:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100c01:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c08:	ff ff ff 
  ustack[1] = argc;
80100c0b:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c11:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c18:	89 da                	mov    %ebx,%edx
80100c1a:	29 c2                	sub    %eax,%edx
80100c1c:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100c22:	83 c0 0c             	add    $0xc,%eax
80100c25:	89 de                	mov    %ebx,%esi
80100c27:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c29:	50                   	push   %eax
80100c2a:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100c30:	50                   	push   %eax
80100c31:	56                   	push   %esi
80100c32:	57                   	push   %edi
80100c33:	e8 43 66 00 00       	call   8010727b <copyout>
80100c38:	83 c4 10             	add    $0x10,%esp
80100c3b:	85 c0                	test   %eax,%eax
80100c3d:	0f 88 88 00 00 00    	js     80100ccb <exec+0x334>
  for(last=s=path; *s; s++)
80100c43:	8b 45 08             	mov    0x8(%ebp),%eax
80100c46:	0f b6 10             	movzbl (%eax),%edx
80100c49:	84 d2                	test   %dl,%dl
80100c4b:	74 1a                	je     80100c67 <exec+0x2d0>
80100c4d:	83 c0 01             	add    $0x1,%eax
80100c50:	8b 4d 08             	mov    0x8(%ebp),%ecx
      last = s+1;
80100c53:	80 fa 2f             	cmp    $0x2f,%dl
80100c56:	0f 44 c8             	cmove  %eax,%ecx
80100c59:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100c5c:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
80100c60:	84 d2                	test   %dl,%dl
80100c62:	75 ef                	jne    80100c53 <exec+0x2bc>
80100c64:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100c67:	83 ec 04             	sub    $0x4,%esp
80100c6a:	6a 10                	push   $0x10
80100c6c:	ff 75 08             	pushl  0x8(%ebp)
80100c6f:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100c75:	89 d8                	mov    %ebx,%eax
80100c77:	83 c0 6c             	add    $0x6c,%eax
80100c7a:	50                   	push   %eax
80100c7b:	e8 72 3f 00 00       	call   80104bf2 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100c80:	89 d8                	mov    %ebx,%eax
80100c82:	8b 5b 04             	mov    0x4(%ebx),%ebx
  curproc->pgdir = pgdir;
80100c85:	89 78 04             	mov    %edi,0x4(%eax)
  curproc->sz = sz;
80100c88:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c8e:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100c90:	89 c7                	mov    %eax,%edi
80100c92:	8b 40 18             	mov    0x18(%eax),%eax
80100c95:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c9b:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c9e:	8b 47 18             	mov    0x18(%edi),%eax
80100ca1:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100ca4:	89 3c 24             	mov    %edi,(%esp)
80100ca7:	e8 06 60 00 00       	call   80106cb2 <switchuvm>
  freevm(oldpgdir);
80100cac:	89 1c 24             	mov    %ebx,(%esp)
80100caf:	e8 90 63 00 00       	call   80107044 <freevm>
  return 0;
80100cb4:	83 c4 10             	add    $0x10,%esp
80100cb7:	b8 00 00 00 00       	mov    $0x0,%eax
80100cbc:	e9 3e fd ff ff       	jmp    801009ff <exec+0x68>
  ip = 0;
80100cc1:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cc6:	e9 85 fe ff ff       	jmp    80100b50 <exec+0x1b9>
80100ccb:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cd0:	e9 7b fe ff ff       	jmp    80100b50 <exec+0x1b9>

80100cd5 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100cd5:	55                   	push   %ebp
80100cd6:	89 e5                	mov    %esp,%ebp
80100cd8:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100cdb:	68 81 73 10 80       	push   $0x80107381
80100ce0:	68 60 25 11 80       	push   $0x80112560
80100ce5:	e8 83 3b 00 00       	call   8010486d <initlock>
}
80100cea:	83 c4 10             	add    $0x10,%esp
80100ced:	c9                   	leave  
80100cee:	c3                   	ret    

80100cef <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100cef:	55                   	push   %ebp
80100cf0:	89 e5                	mov    %esp,%ebp
80100cf2:	53                   	push   %ebx
80100cf3:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100cf6:	68 60 25 11 80       	push   $0x80112560
80100cfb:	e8 b5 3c 00 00       	call   801049b5 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
80100d00:	83 c4 10             	add    $0x10,%esp
80100d03:	83 3d 98 25 11 80 00 	cmpl   $0x0,0x80112598
80100d0a:	74 2d                	je     80100d39 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d0c:	bb ac 25 11 80       	mov    $0x801125ac,%ebx
    if(f->ref == 0){
80100d11:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100d15:	74 27                	je     80100d3e <filealloc+0x4f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d17:	83 c3 18             	add    $0x18,%ebx
80100d1a:	81 fb f4 2e 11 80    	cmp    $0x80112ef4,%ebx
80100d20:	72 ef                	jb     80100d11 <filealloc+0x22>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100d22:	83 ec 0c             	sub    $0xc,%esp
80100d25:	68 60 25 11 80       	push   $0x80112560
80100d2a:	e8 ed 3c 00 00       	call   80104a1c <release>
  return 0;
80100d2f:	83 c4 10             	add    $0x10,%esp
80100d32:	bb 00 00 00 00       	mov    $0x0,%ebx
80100d37:	eb 1c                	jmp    80100d55 <filealloc+0x66>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d39:	bb 94 25 11 80       	mov    $0x80112594,%ebx
      f->ref = 1;
80100d3e:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d45:	83 ec 0c             	sub    $0xc,%esp
80100d48:	68 60 25 11 80       	push   $0x80112560
80100d4d:	e8 ca 3c 00 00       	call   80104a1c <release>
      return f;
80100d52:	83 c4 10             	add    $0x10,%esp
}
80100d55:	89 d8                	mov    %ebx,%eax
80100d57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d5a:	c9                   	leave  
80100d5b:	c3                   	ret    

80100d5c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100d5c:	55                   	push   %ebp
80100d5d:	89 e5                	mov    %esp,%ebp
80100d5f:	53                   	push   %ebx
80100d60:	83 ec 10             	sub    $0x10,%esp
80100d63:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100d66:	68 60 25 11 80       	push   $0x80112560
80100d6b:	e8 45 3c 00 00       	call   801049b5 <acquire>
  if(f->ref < 1)
80100d70:	8b 43 04             	mov    0x4(%ebx),%eax
80100d73:	83 c4 10             	add    $0x10,%esp
80100d76:	85 c0                	test   %eax,%eax
80100d78:	7e 1a                	jle    80100d94 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100d7a:	83 c0 01             	add    $0x1,%eax
80100d7d:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d80:	83 ec 0c             	sub    $0xc,%esp
80100d83:	68 60 25 11 80       	push   $0x80112560
80100d88:	e8 8f 3c 00 00       	call   80104a1c <release>
  return f;
}
80100d8d:	89 d8                	mov    %ebx,%eax
80100d8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d92:	c9                   	leave  
80100d93:	c3                   	ret    
    panic("filedup");
80100d94:	83 ec 0c             	sub    $0xc,%esp
80100d97:	68 88 73 10 80       	push   $0x80107388
80100d9c:	e8 a3 f5 ff ff       	call   80100344 <panic>

80100da1 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100da1:	55                   	push   %ebp
80100da2:	89 e5                	mov    %esp,%ebp
80100da4:	57                   	push   %edi
80100da5:	56                   	push   %esi
80100da6:	53                   	push   %ebx
80100da7:	83 ec 28             	sub    $0x28,%esp
80100daa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100dad:	68 60 25 11 80       	push   $0x80112560
80100db2:	e8 fe 3b 00 00       	call   801049b5 <acquire>
  if(f->ref < 1)
80100db7:	8b 43 04             	mov    0x4(%ebx),%eax
80100dba:	83 c4 10             	add    $0x10,%esp
80100dbd:	85 c0                	test   %eax,%eax
80100dbf:	7e 22                	jle    80100de3 <fileclose+0x42>
    panic("fileclose");
  if(--f->ref > 0){
80100dc1:	83 e8 01             	sub    $0x1,%eax
80100dc4:	89 43 04             	mov    %eax,0x4(%ebx)
80100dc7:	85 c0                	test   %eax,%eax
80100dc9:	7e 25                	jle    80100df0 <fileclose+0x4f>
    release(&ftable.lock);
80100dcb:	83 ec 0c             	sub    $0xc,%esp
80100dce:	68 60 25 11 80       	push   $0x80112560
80100dd3:	e8 44 3c 00 00       	call   80104a1c <release>
80100dd8:	83 c4 10             	add    $0x10,%esp
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ddb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100dde:	5b                   	pop    %ebx
80100ddf:	5e                   	pop    %esi
80100de0:	5f                   	pop    %edi
80100de1:	5d                   	pop    %ebp
80100de2:	c3                   	ret    
    panic("fileclose");
80100de3:	83 ec 0c             	sub    $0xc,%esp
80100de6:	68 90 73 10 80       	push   $0x80107390
80100deb:	e8 54 f5 ff ff       	call   80100344 <panic>
  ff = *f;
80100df0:	8b 33                	mov    (%ebx),%esi
80100df2:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100df6:	88 45 e7             	mov    %al,-0x19(%ebp)
80100df9:	8b 7b 0c             	mov    0xc(%ebx),%edi
80100dfc:	8b 43 10             	mov    0x10(%ebx),%eax
80100dff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
80100e02:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100e09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100e0f:	83 ec 0c             	sub    $0xc,%esp
80100e12:	68 60 25 11 80       	push   $0x80112560
80100e17:	e8 00 3c 00 00       	call   80104a1c <release>
  if(ff.type == FD_PIPE)
80100e1c:	83 c4 10             	add    $0x10,%esp
80100e1f:	83 fe 01             	cmp    $0x1,%esi
80100e22:	74 1f                	je     80100e43 <fileclose+0xa2>
  else if(ff.type == FD_INODE){
80100e24:	83 fe 02             	cmp    $0x2,%esi
80100e27:	75 b2                	jne    80100ddb <fileclose+0x3a>
    begin_op();
80100e29:	e8 06 1a 00 00       	call   80102834 <begin_op>
    iput(ff.ip);
80100e2e:	83 ec 0c             	sub    $0xc,%esp
80100e31:	ff 75 e0             	pushl  -0x20(%ebp)
80100e34:	e8 3b 08 00 00       	call   80101674 <iput>
    end_op();
80100e39:	e8 71 1a 00 00       	call   801028af <end_op>
80100e3e:	83 c4 10             	add    $0x10,%esp
80100e41:	eb 98                	jmp    80100ddb <fileclose+0x3a>
    pipeclose(ff.pipe, ff.writable);
80100e43:	83 ec 08             	sub    $0x8,%esp
80100e46:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100e4a:	50                   	push   %eax
80100e4b:	57                   	push   %edi
80100e4c:	e8 10 21 00 00       	call   80102f61 <pipeclose>
80100e51:	83 c4 10             	add    $0x10,%esp
80100e54:	eb 85                	jmp    80100ddb <fileclose+0x3a>

80100e56 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100e56:	55                   	push   %ebp
80100e57:	89 e5                	mov    %esp,%ebp
80100e59:	53                   	push   %ebx
80100e5a:	83 ec 04             	sub    $0x4,%esp
80100e5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100e60:	83 3b 02             	cmpl   $0x2,(%ebx)
80100e63:	75 31                	jne    80100e96 <filestat+0x40>
    ilock(f->ip);
80100e65:	83 ec 0c             	sub    $0xc,%esp
80100e68:	ff 73 10             	pushl  0x10(%ebx)
80100e6b:	e8 fd 06 00 00       	call   8010156d <ilock>
    stati(f->ip, st);
80100e70:	83 c4 08             	add    $0x8,%esp
80100e73:	ff 75 0c             	pushl  0xc(%ebp)
80100e76:	ff 73 10             	pushl  0x10(%ebx)
80100e79:	e8 58 09 00 00       	call   801017d6 <stati>
    iunlock(f->ip);
80100e7e:	83 c4 04             	add    $0x4,%esp
80100e81:	ff 73 10             	pushl  0x10(%ebx)
80100e84:	e8 a6 07 00 00       	call   8010162f <iunlock>
    return 0;
80100e89:	83 c4 10             	add    $0x10,%esp
80100e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e94:	c9                   	leave  
80100e95:	c3                   	ret    
  return -1;
80100e96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e9b:	eb f4                	jmp    80100e91 <filestat+0x3b>

80100e9d <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e9d:	55                   	push   %ebp
80100e9e:	89 e5                	mov    %esp,%ebp
80100ea0:	56                   	push   %esi
80100ea1:	53                   	push   %ebx
80100ea2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100ea5:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100ea9:	74 70                	je     80100f1b <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100eab:	8b 03                	mov    (%ebx),%eax
80100ead:	83 f8 01             	cmp    $0x1,%eax
80100eb0:	74 44                	je     80100ef6 <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100eb2:	83 f8 02             	cmp    $0x2,%eax
80100eb5:	75 57                	jne    80100f0e <fileread+0x71>
    ilock(f->ip);
80100eb7:	83 ec 0c             	sub    $0xc,%esp
80100eba:	ff 73 10             	pushl  0x10(%ebx)
80100ebd:	e8 ab 06 00 00       	call   8010156d <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100ec2:	ff 75 10             	pushl  0x10(%ebp)
80100ec5:	ff 73 14             	pushl  0x14(%ebx)
80100ec8:	ff 75 0c             	pushl  0xc(%ebp)
80100ecb:	ff 73 10             	pushl  0x10(%ebx)
80100ece:	e8 2e 09 00 00       	call   80101801 <readi>
80100ed3:	89 c6                	mov    %eax,%esi
80100ed5:	83 c4 20             	add    $0x20,%esp
80100ed8:	85 c0                	test   %eax,%eax
80100eda:	7e 03                	jle    80100edf <fileread+0x42>
      f->off += r;
80100edc:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100edf:	83 ec 0c             	sub    $0xc,%esp
80100ee2:	ff 73 10             	pushl  0x10(%ebx)
80100ee5:	e8 45 07 00 00       	call   8010162f <iunlock>
    return r;
80100eea:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100eed:	89 f0                	mov    %esi,%eax
80100eef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100ef2:	5b                   	pop    %ebx
80100ef3:	5e                   	pop    %esi
80100ef4:	5d                   	pop    %ebp
80100ef5:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100ef6:	83 ec 04             	sub    $0x4,%esp
80100ef9:	ff 75 10             	pushl  0x10(%ebp)
80100efc:	ff 75 0c             	pushl  0xc(%ebp)
80100eff:	ff 73 0c             	pushl  0xc(%ebx)
80100f02:	e8 df 21 00 00       	call   801030e6 <piperead>
80100f07:	89 c6                	mov    %eax,%esi
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	eb df                	jmp    80100eed <fileread+0x50>
  panic("fileread");
80100f0e:	83 ec 0c             	sub    $0xc,%esp
80100f11:	68 9a 73 10 80       	push   $0x8010739a
80100f16:	e8 29 f4 ff ff       	call   80100344 <panic>
    return -1;
80100f1b:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100f20:	eb cb                	jmp    80100eed <fileread+0x50>

80100f22 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100f22:	55                   	push   %ebp
80100f23:	89 e5                	mov    %esp,%ebp
80100f25:	57                   	push   %edi
80100f26:	56                   	push   %esi
80100f27:	53                   	push   %ebx
80100f28:	83 ec 1c             	sub    $0x1c,%esp
80100f2b:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100f2e:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100f32:	0f 84 e8 00 00 00    	je     80101020 <filewrite+0xfe>
    return -1;
  if(f->type == FD_PIPE)
80100f38:	8b 06                	mov    (%esi),%eax
80100f3a:	83 f8 01             	cmp    $0x1,%eax
80100f3d:	74 1a                	je     80100f59 <filewrite+0x37>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f3f:	83 f8 02             	cmp    $0x2,%eax
80100f42:	0f 85 cb 00 00 00    	jne    80101013 <filewrite+0xf1>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100f48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100f4c:	0f 8e 9e 00 00 00    	jle    80100ff0 <filewrite+0xce>
    int i = 0;
80100f52:	bf 00 00 00 00       	mov    $0x0,%edi
80100f57:	eb 3f                	jmp    80100f98 <filewrite+0x76>
    return pipewrite(f->pipe, addr, n);
80100f59:	83 ec 04             	sub    $0x4,%esp
80100f5c:	ff 75 10             	pushl  0x10(%ebp)
80100f5f:	ff 75 0c             	pushl  0xc(%ebp)
80100f62:	ff 76 0c             	pushl  0xc(%esi)
80100f65:	e8 83 20 00 00       	call   80102fed <pipewrite>
80100f6a:	89 45 10             	mov    %eax,0x10(%ebp)
80100f6d:	83 c4 10             	add    $0x10,%esp
80100f70:	e9 93 00 00 00       	jmp    80101008 <filewrite+0xe6>

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80100f75:	83 ec 0c             	sub    $0xc,%esp
80100f78:	ff 76 10             	pushl  0x10(%esi)
80100f7b:	e8 af 06 00 00       	call   8010162f <iunlock>
      end_op();
80100f80:	e8 2a 19 00 00       	call   801028af <end_op>

      if(r < 0)
80100f85:	83 c4 10             	add    $0x10,%esp
80100f88:	85 db                	test   %ebx,%ebx
80100f8a:	78 6b                	js     80100ff7 <filewrite+0xd5>
        break;
      if(r != n1)
80100f8c:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100f8f:	75 4e                	jne    80100fdf <filewrite+0xbd>
        panic("short filewrite");
      i += r;
80100f91:	01 df                	add    %ebx,%edi
    while(i < n){
80100f93:	39 7d 10             	cmp    %edi,0x10(%ebp)
80100f96:	7e 54                	jle    80100fec <filewrite+0xca>
      int n1 = n - i;
80100f98:	8b 45 10             	mov    0x10(%ebp),%eax
80100f9b:	29 f8                	sub    %edi,%eax
80100f9d:	3d 00 06 00 00       	cmp    $0x600,%eax
80100fa2:	ba 00 06 00 00       	mov    $0x600,%edx
80100fa7:	0f 4f c2             	cmovg  %edx,%eax
80100faa:	89 c3                	mov    %eax,%ebx
80100fac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      begin_op();
80100faf:	e8 80 18 00 00       	call   80102834 <begin_op>
      ilock(f->ip);
80100fb4:	83 ec 0c             	sub    $0xc,%esp
80100fb7:	ff 76 10             	pushl  0x10(%esi)
80100fba:	e8 ae 05 00 00       	call   8010156d <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100fbf:	53                   	push   %ebx
80100fc0:	ff 76 14             	pushl  0x14(%esi)
80100fc3:	89 f8                	mov    %edi,%eax
80100fc5:	03 45 0c             	add    0xc(%ebp),%eax
80100fc8:	50                   	push   %eax
80100fc9:	ff 76 10             	pushl  0x10(%esi)
80100fcc:	e8 2c 09 00 00       	call   801018fd <writei>
80100fd1:	89 c3                	mov    %eax,%ebx
80100fd3:	83 c4 20             	add    $0x20,%esp
80100fd6:	85 c0                	test   %eax,%eax
80100fd8:	7e 9b                	jle    80100f75 <filewrite+0x53>
        f->off += r;
80100fda:	01 46 14             	add    %eax,0x14(%esi)
80100fdd:	eb 96                	jmp    80100f75 <filewrite+0x53>
        panic("short filewrite");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 a3 73 10 80       	push   $0x801073a3
80100fe7:	e8 58 f3 ff ff       	call   80100344 <panic>
80100fec:	89 f8                	mov    %edi,%eax
80100fee:	eb 09                	jmp    80100ff9 <filewrite+0xd7>
    int i = 0;
80100ff0:	b8 00 00 00 00       	mov    $0x0,%eax
80100ff5:	eb 02                	jmp    80100ff9 <filewrite+0xd7>
80100ff7:	89 f8                	mov    %edi,%eax
    }
    return i == n ? n : -1;
80100ff9:	39 45 10             	cmp    %eax,0x10(%ebp)
80100ffc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101001:	0f 44 45 10          	cmove  0x10(%ebp),%eax
80101005:	89 45 10             	mov    %eax,0x10(%ebp)
  }
  panic("filewrite");
}
80101008:	8b 45 10             	mov    0x10(%ebp),%eax
8010100b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010100e:	5b                   	pop    %ebx
8010100f:	5e                   	pop    %esi
80101010:	5f                   	pop    %edi
80101011:	5d                   	pop    %ebp
80101012:	c3                   	ret    
  panic("filewrite");
80101013:	83 ec 0c             	sub    $0xc,%esp
80101016:	68 a9 73 10 80       	push   $0x801073a9
8010101b:	e8 24 f3 ff ff       	call   80100344 <panic>
    return -1;
80101020:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
80101027:	eb df                	jmp    80101008 <filewrite+0xe6>

80101029 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101029:	55                   	push   %ebp
8010102a:	89 e5                	mov    %esp,%ebp
8010102c:	57                   	push   %edi
8010102d:	56                   	push   %esi
8010102e:	53                   	push   %ebx
8010102f:	83 ec 2c             	sub    $0x2c,%esp
80101032:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101035:	83 3d 60 2f 11 80 00 	cmpl   $0x0,0x80112f60
8010103c:	0f 84 32 01 00 00    	je     80101174 <balloc+0x14b>
80101042:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80101049:	e9 8f 00 00 00       	jmp    801010dd <balloc+0xb4>
8010104e:	89 c3                	mov    %eax,%ebx
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101050:	09 ca                	or     %ecx,%edx
80101052:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101055:	88 54 03 5c          	mov    %dl,0x5c(%ebx,%eax,1)
        log_write(bp);
80101059:	83 ec 0c             	sub    $0xc,%esp
8010105c:	53                   	push   %ebx
8010105d:	e8 92 19 00 00       	call   801029f4 <log_write>
        brelse(bp);
80101062:	89 1c 24             	mov    %ebx,(%esp)
80101065:	e8 57 f1 ff ff       	call   801001c1 <brelse>
  bp = bread(dev, bno);
8010106a:	83 c4 08             	add    $0x8,%esp
8010106d:	ff 75 e4             	pushl  -0x1c(%ebp)
80101070:	ff 75 d4             	pushl  -0x2c(%ebp)
80101073:	e8 32 f0 ff ff       	call   801000aa <bread>
80101078:	89 c6                	mov    %eax,%esi
  memset(bp->data, 0, BSIZE);
8010107a:	83 c4 0c             	add    $0xc,%esp
8010107d:	68 00 02 00 00       	push   $0x200
80101082:	6a 00                	push   $0x0
80101084:	8d 40 5c             	lea    0x5c(%eax),%eax
80101087:	50                   	push   %eax
80101088:	e8 d6 39 00 00       	call   80104a63 <memset>
  log_write(bp);
8010108d:	89 34 24             	mov    %esi,(%esp)
80101090:	e8 5f 19 00 00       	call   801029f4 <log_write>
  brelse(bp);
80101095:	89 34 24             	mov    %esi,(%esp)
80101098:	e8 24 f1 ff ff       	call   801001c1 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010109d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a3:	5b                   	pop    %ebx
801010a4:	5e                   	pop    %esi
801010a5:	5f                   	pop    %edi
801010a6:	5d                   	pop    %ebp
801010a7:	c3                   	ret    
801010a8:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010aa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      m = 1 << (bi % 8);
801010ad:	b9 01 00 00 00       	mov    $0x1,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801010b2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801010b9:	eb 95                	jmp    80101050 <balloc+0x27>
    brelse(bp);
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	50                   	push   %eax
801010bf:	e8 fd f0 ff ff       	call   801001c1 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801010c4:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
801010cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801010ce:	83 c4 10             	add    $0x10,%esp
801010d1:	39 05 60 2f 11 80    	cmp    %eax,0x80112f60
801010d7:	0f 86 97 00 00 00    	jbe    80101174 <balloc+0x14b>
    bp = bread(dev, BBLOCK(b, sb));
801010dd:	83 ec 08             	sub    $0x8,%esp
801010e0:	8b 7d d8             	mov    -0x28(%ebp),%edi
801010e3:	89 fb                	mov    %edi,%ebx
801010e5:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
801010eb:	85 ff                	test   %edi,%edi
801010ed:	0f 49 c7             	cmovns %edi,%eax
801010f0:	c1 f8 0c             	sar    $0xc,%eax
801010f3:	03 05 78 2f 11 80    	add    0x80112f78,%eax
801010f9:	50                   	push   %eax
801010fa:	ff 75 d4             	pushl  -0x2c(%ebp)
801010fd:	e8 a8 ef ff ff       	call   801000aa <bread>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101102:	8b 0d 60 2f 11 80    	mov    0x80112f60,%ecx
80101108:	83 c4 10             	add    $0x10,%esp
8010110b:	39 cf                	cmp    %ecx,%edi
8010110d:	73 ac                	jae    801010bb <balloc+0x92>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010110f:	0f b6 50 5c          	movzbl 0x5c(%eax),%edx
80101113:	f6 c2 01             	test   $0x1,%dl
80101116:	74 90                	je     801010a8 <balloc+0x7f>
80101118:	29 f9                	sub    %edi,%ecx
8010111a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010111d:	be 01 00 00 00       	mov    $0x1,%esi
80101122:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
80101125:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101128:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010112b:	74 8e                	je     801010bb <balloc+0x92>
      m = 1 << (bi % 8);
8010112d:	89 f2                	mov    %esi,%edx
8010112f:	c1 fa 1f             	sar    $0x1f,%edx
80101132:	c1 ea 1d             	shr    $0x1d,%edx
80101135:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
80101138:	83 e1 07             	and    $0x7,%ecx
8010113b:	29 d1                	sub    %edx,%ecx
8010113d:	bf 01 00 00 00       	mov    $0x1,%edi
80101142:	d3 e7                	shl    %cl,%edi
80101144:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101146:	8d 56 07             	lea    0x7(%esi),%edx
80101149:	85 f6                	test   %esi,%esi
8010114b:	0f 49 d6             	cmovns %esi,%edx
8010114e:	c1 fa 03             	sar    $0x3,%edx
80101151:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101154:	0f b6 54 10 5c       	movzbl 0x5c(%eax,%edx,1),%edx
80101159:	0f b6 fa             	movzbl %dl,%edi
8010115c:	85 cf                	test   %ecx,%edi
8010115e:	0f 84 ea fe ff ff    	je     8010104e <balloc+0x25>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101164:	83 c6 01             	add    $0x1,%esi
80101167:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
8010116d:	75 b3                	jne    80101122 <balloc+0xf9>
8010116f:	e9 47 ff ff ff       	jmp    801010bb <balloc+0x92>
  panic("balloc: out of blocks");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 b3 73 10 80       	push   $0x801073b3
8010117c:	e8 c3 f1 ff ff       	call   80100344 <panic>

80101181 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101181:	55                   	push   %ebp
80101182:	89 e5                	mov    %esp,%ebp
80101184:	57                   	push   %edi
80101185:	56                   	push   %esi
80101186:	53                   	push   %ebx
80101187:	83 ec 1c             	sub    $0x1c,%esp
8010118a:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010118c:	83 fa 0b             	cmp    $0xb,%edx
8010118f:	77 18                	ja     801011a9 <bmap+0x28>
80101191:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101194:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101197:	85 db                	test   %ebx,%ebx
80101199:	75 49                	jne    801011e4 <bmap+0x63>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010119b:	8b 00                	mov    (%eax),%eax
8010119d:	e8 87 fe ff ff       	call   80101029 <balloc>
801011a2:	89 c3                	mov    %eax,%ebx
801011a4:	89 47 5c             	mov    %eax,0x5c(%edi)
801011a7:	eb 3b                	jmp    801011e4 <bmap+0x63>
    return addr;
  }
  bn -= NDIRECT;
801011a9:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801011ac:	83 fb 7f             	cmp    $0x7f,%ebx
801011af:	77 68                	ja     80101219 <bmap+0x98>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801011b1:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801011b7:	85 c0                	test   %eax,%eax
801011b9:	74 33                	je     801011ee <bmap+0x6d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801011bb:	83 ec 08             	sub    $0x8,%esp
801011be:	50                   	push   %eax
801011bf:	ff 36                	pushl  (%esi)
801011c1:	e8 e4 ee ff ff       	call   801000aa <bread>
801011c6:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801011c8:	8d 44 98 5c          	lea    0x5c(%eax,%ebx,4),%eax
801011cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011cf:	8b 18                	mov    (%eax),%ebx
801011d1:	83 c4 10             	add    $0x10,%esp
801011d4:	85 db                	test   %ebx,%ebx
801011d6:	74 25                	je     801011fd <bmap+0x7c>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801011d8:	83 ec 0c             	sub    $0xc,%esp
801011db:	57                   	push   %edi
801011dc:	e8 e0 ef ff ff       	call   801001c1 <brelse>
    return addr;
801011e1:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801011e4:	89 d8                	mov    %ebx,%eax
801011e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e9:	5b                   	pop    %ebx
801011ea:	5e                   	pop    %esi
801011eb:	5f                   	pop    %edi
801011ec:	5d                   	pop    %ebp
801011ed:	c3                   	ret    
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801011ee:	8b 06                	mov    (%esi),%eax
801011f0:	e8 34 fe ff ff       	call   80101029 <balloc>
801011f5:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801011fb:	eb be                	jmp    801011bb <bmap+0x3a>
      a[bn] = addr = balloc(ip->dev);
801011fd:	8b 06                	mov    (%esi),%eax
801011ff:	e8 25 fe ff ff       	call   80101029 <balloc>
80101204:	89 c3                	mov    %eax,%ebx
80101206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101209:	89 18                	mov    %ebx,(%eax)
      log_write(bp);
8010120b:	83 ec 0c             	sub    $0xc,%esp
8010120e:	57                   	push   %edi
8010120f:	e8 e0 17 00 00       	call   801029f4 <log_write>
80101214:	83 c4 10             	add    $0x10,%esp
80101217:	eb bf                	jmp    801011d8 <bmap+0x57>
  panic("bmap: out of range");
80101219:	83 ec 0c             	sub    $0xc,%esp
8010121c:	68 c9 73 10 80       	push   $0x801073c9
80101221:	e8 1e f1 ff ff       	call   80100344 <panic>

80101226 <iget>:
{
80101226:	55                   	push   %ebp
80101227:	89 e5                	mov    %esp,%ebp
80101229:	57                   	push   %edi
8010122a:	56                   	push   %esi
8010122b:	53                   	push   %ebx
8010122c:	83 ec 28             	sub    $0x28,%esp
8010122f:	89 c7                	mov    %eax,%edi
80101231:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101234:	68 80 2f 11 80       	push   $0x80112f80
80101239:	e8 77 37 00 00       	call   801049b5 <acquire>
8010123e:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101241:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101246:	bb b4 2f 11 80       	mov    $0x80112fb4,%ebx
8010124b:	eb 1c                	jmp    80101269 <iget+0x43>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010124d:	85 c0                	test   %eax,%eax
8010124f:	75 0a                	jne    8010125b <iget+0x35>
80101251:	85 f6                	test   %esi,%esi
80101253:	0f 94 c0             	sete   %al
80101256:	84 c0                	test   %al,%al
80101258:	0f 45 f3             	cmovne %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125b:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101261:	81 fb d4 4b 11 80    	cmp    $0x80114bd4,%ebx
80101267:	73 2d                	jae    80101296 <iget+0x70>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101269:	8b 43 08             	mov    0x8(%ebx),%eax
8010126c:	85 c0                	test   %eax,%eax
8010126e:	7e dd                	jle    8010124d <iget+0x27>
80101270:	39 3b                	cmp    %edi,(%ebx)
80101272:	75 e7                	jne    8010125b <iget+0x35>
80101274:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101277:	39 4b 04             	cmp    %ecx,0x4(%ebx)
8010127a:	75 df                	jne    8010125b <iget+0x35>
      ip->ref++;
8010127c:	83 c0 01             	add    $0x1,%eax
8010127f:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101282:	83 ec 0c             	sub    $0xc,%esp
80101285:	68 80 2f 11 80       	push   $0x80112f80
8010128a:	e8 8d 37 00 00       	call   80104a1c <release>
      return ip;
8010128f:	83 c4 10             	add    $0x10,%esp
80101292:	89 de                	mov    %ebx,%esi
80101294:	eb 2a                	jmp    801012c0 <iget+0x9a>
  if(empty == 0)
80101296:	85 f6                	test   %esi,%esi
80101298:	74 30                	je     801012ca <iget+0xa4>
  ip->dev = dev;
8010129a:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
8010129c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010129f:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
801012a2:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012a9:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012b0:	83 ec 0c             	sub    $0xc,%esp
801012b3:	68 80 2f 11 80       	push   $0x80112f80
801012b8:	e8 5f 37 00 00       	call   80104a1c <release>
  return ip;
801012bd:	83 c4 10             	add    $0x10,%esp
}
801012c0:	89 f0                	mov    %esi,%eax
801012c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c5:	5b                   	pop    %ebx
801012c6:	5e                   	pop    %esi
801012c7:	5f                   	pop    %edi
801012c8:	5d                   	pop    %ebp
801012c9:	c3                   	ret    
    panic("iget: no inodes");
801012ca:	83 ec 0c             	sub    $0xc,%esp
801012cd:	68 dc 73 10 80       	push   $0x801073dc
801012d2:	e8 6d f0 ff ff       	call   80100344 <panic>

801012d7 <readsb>:
{
801012d7:	55                   	push   %ebp
801012d8:	89 e5                	mov    %esp,%ebp
801012da:	53                   	push   %ebx
801012db:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801012de:	6a 01                	push   $0x1
801012e0:	ff 75 08             	pushl  0x8(%ebp)
801012e3:	e8 c2 ed ff ff       	call   801000aa <bread>
801012e8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801012ea:	83 c4 0c             	add    $0xc,%esp
801012ed:	6a 1c                	push   $0x1c
801012ef:	8d 40 5c             	lea    0x5c(%eax),%eax
801012f2:	50                   	push   %eax
801012f3:	ff 75 0c             	pushl  0xc(%ebp)
801012f6:	e8 fd 37 00 00       	call   80104af8 <memmove>
  brelse(bp);
801012fb:	89 1c 24             	mov    %ebx,(%esp)
801012fe:	e8 be ee ff ff       	call   801001c1 <brelse>
}
80101303:	83 c4 10             	add    $0x10,%esp
80101306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101309:	c9                   	leave  
8010130a:	c3                   	ret    

8010130b <bfree>:
{
8010130b:	55                   	push   %ebp
8010130c:	89 e5                	mov    %esp,%ebp
8010130e:	56                   	push   %esi
8010130f:	53                   	push   %ebx
80101310:	89 c6                	mov    %eax,%esi
80101312:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
80101314:	83 ec 08             	sub    $0x8,%esp
80101317:	68 60 2f 11 80       	push   $0x80112f60
8010131c:	50                   	push   %eax
8010131d:	e8 b5 ff ff ff       	call   801012d7 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101322:	83 c4 08             	add    $0x8,%esp
80101325:	89 d8                	mov    %ebx,%eax
80101327:	c1 e8 0c             	shr    $0xc,%eax
8010132a:	03 05 78 2f 11 80    	add    0x80112f78,%eax
80101330:	50                   	push   %eax
80101331:	56                   	push   %esi
80101332:	e8 73 ed ff ff       	call   801000aa <bread>
80101337:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101339:	89 d9                	mov    %ebx,%ecx
8010133b:	83 e1 07             	and    $0x7,%ecx
8010133e:	b8 01 00 00 00       	mov    $0x1,%eax
80101343:	d3 e0                	shl    %cl,%eax
  bi = b % BPB;
80101345:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  if((bp->data[bi/8] & m) == 0)
8010134b:	83 c4 10             	add    $0x10,%esp
8010134e:	c1 fb 03             	sar    $0x3,%ebx
80101351:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
80101356:	0f b6 ca             	movzbl %dl,%ecx
80101359:	85 c1                	test   %eax,%ecx
8010135b:	74 23                	je     80101380 <bfree+0x75>
  bp->data[bi/8] &= ~m;
8010135d:	f7 d0                	not    %eax
8010135f:	21 d0                	and    %edx,%eax
80101361:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101365:	83 ec 0c             	sub    $0xc,%esp
80101368:	56                   	push   %esi
80101369:	e8 86 16 00 00       	call   801029f4 <log_write>
  brelse(bp);
8010136e:	89 34 24             	mov    %esi,(%esp)
80101371:	e8 4b ee ff ff       	call   801001c1 <brelse>
}
80101376:	83 c4 10             	add    $0x10,%esp
80101379:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010137c:	5b                   	pop    %ebx
8010137d:	5e                   	pop    %esi
8010137e:	5d                   	pop    %ebp
8010137f:	c3                   	ret    
    panic("freeing free block");
80101380:	83 ec 0c             	sub    $0xc,%esp
80101383:	68 ec 73 10 80       	push   $0x801073ec
80101388:	e8 b7 ef ff ff       	call   80100344 <panic>

8010138d <iinit>:
{
8010138d:	55                   	push   %ebp
8010138e:	89 e5                	mov    %esp,%ebp
80101390:	56                   	push   %esi
80101391:	53                   	push   %ebx
  initlock(&icache.lock, "icache");
80101392:	83 ec 08             	sub    $0x8,%esp
80101395:	68 ff 73 10 80       	push   $0x801073ff
8010139a:	68 80 2f 11 80       	push   $0x80112f80
8010139f:	e8 c9 34 00 00       	call   8010486d <initlock>
801013a4:	bb c0 2f 11 80       	mov    $0x80112fc0,%ebx
801013a9:	be e0 4b 11 80       	mov    $0x80114be0,%esi
801013ae:	83 c4 10             	add    $0x10,%esp
    initsleeplock(&icache.inode[i].lock, "inode");
801013b1:	83 ec 08             	sub    $0x8,%esp
801013b4:	68 06 74 10 80       	push   $0x80107406
801013b9:	53                   	push   %ebx
801013ba:	e8 c7 33 00 00       	call   80104786 <initsleeplock>
801013bf:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(i = 0; i < NINODE; i++) {
801013c5:	83 c4 10             	add    $0x10,%esp
801013c8:	39 f3                	cmp    %esi,%ebx
801013ca:	75 e5                	jne    801013b1 <iinit+0x24>
  readsb(dev, &sb);
801013cc:	83 ec 08             	sub    $0x8,%esp
801013cf:	68 60 2f 11 80       	push   $0x80112f60
801013d4:	ff 75 08             	pushl  0x8(%ebp)
801013d7:	e8 fb fe ff ff       	call   801012d7 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801013dc:	ff 35 78 2f 11 80    	pushl  0x80112f78
801013e2:	ff 35 74 2f 11 80    	pushl  0x80112f74
801013e8:	ff 35 70 2f 11 80    	pushl  0x80112f70
801013ee:	ff 35 6c 2f 11 80    	pushl  0x80112f6c
801013f4:	ff 35 68 2f 11 80    	pushl  0x80112f68
801013fa:	ff 35 64 2f 11 80    	pushl  0x80112f64
80101400:	ff 35 60 2f 11 80    	pushl  0x80112f60
80101406:	68 6c 74 10 80       	push   $0x8010746c
8010140b:	e8 d1 f1 ff ff       	call   801005e1 <cprintf>
}
80101410:	83 c4 30             	add    $0x30,%esp
80101413:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101416:	5b                   	pop    %ebx
80101417:	5e                   	pop    %esi
80101418:	5d                   	pop    %ebp
80101419:	c3                   	ret    

8010141a <ialloc>:
{
8010141a:	55                   	push   %ebp
8010141b:	89 e5                	mov    %esp,%ebp
8010141d:	57                   	push   %edi
8010141e:	56                   	push   %esi
8010141f:	53                   	push   %ebx
80101420:	83 ec 1c             	sub    $0x1c,%esp
80101423:	8b 45 0c             	mov    0xc(%ebp),%eax
80101426:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101429:	83 3d 68 2f 11 80 01 	cmpl   $0x1,0x80112f68
80101430:	76 4d                	jbe    8010147f <ialloc+0x65>
80101432:	bb 01 00 00 00       	mov    $0x1,%ebx
80101437:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    bp = bread(dev, IBLOCK(inum, sb));
8010143a:	83 ec 08             	sub    $0x8,%esp
8010143d:	89 d8                	mov    %ebx,%eax
8010143f:	c1 e8 03             	shr    $0x3,%eax
80101442:	03 05 74 2f 11 80    	add    0x80112f74,%eax
80101448:	50                   	push   %eax
80101449:	ff 75 08             	pushl  0x8(%ebp)
8010144c:	e8 59 ec ff ff       	call   801000aa <bread>
80101451:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
80101453:	89 d8                	mov    %ebx,%eax
80101455:	83 e0 07             	and    $0x7,%eax
80101458:	c1 e0 06             	shl    $0x6,%eax
8010145b:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
8010145f:	83 c4 10             	add    $0x10,%esp
80101462:	66 83 3f 00          	cmpw   $0x0,(%edi)
80101466:	74 24                	je     8010148c <ialloc+0x72>
    brelse(bp);
80101468:	83 ec 0c             	sub    $0xc,%esp
8010146b:	56                   	push   %esi
8010146c:	e8 50 ed ff ff       	call   801001c1 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101471:	83 c3 01             	add    $0x1,%ebx
80101474:	83 c4 10             	add    $0x10,%esp
80101477:	39 1d 68 2f 11 80    	cmp    %ebx,0x80112f68
8010147d:	77 b8                	ja     80101437 <ialloc+0x1d>
  panic("ialloc: no inodes");
8010147f:	83 ec 0c             	sub    $0xc,%esp
80101482:	68 0c 74 10 80       	push   $0x8010740c
80101487:	e8 b8 ee ff ff       	call   80100344 <panic>
      memset(dip, 0, sizeof(*dip));
8010148c:	83 ec 04             	sub    $0x4,%esp
8010148f:	6a 40                	push   $0x40
80101491:	6a 00                	push   $0x0
80101493:	57                   	push   %edi
80101494:	e8 ca 35 00 00       	call   80104a63 <memset>
      dip->type = type;
80101499:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010149d:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
801014a0:	89 34 24             	mov    %esi,(%esp)
801014a3:	e8 4c 15 00 00       	call   801029f4 <log_write>
      brelse(bp);
801014a8:	89 34 24             	mov    %esi,(%esp)
801014ab:	e8 11 ed ff ff       	call   801001c1 <brelse>
      return iget(dev, inum);
801014b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014b3:	8b 45 08             	mov    0x8(%ebp),%eax
801014b6:	e8 6b fd ff ff       	call   80101226 <iget>
}
801014bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014be:	5b                   	pop    %ebx
801014bf:	5e                   	pop    %esi
801014c0:	5f                   	pop    %edi
801014c1:	5d                   	pop    %ebp
801014c2:	c3                   	ret    

801014c3 <iupdate>:
{
801014c3:	55                   	push   %ebp
801014c4:	89 e5                	mov    %esp,%ebp
801014c6:	56                   	push   %esi
801014c7:	53                   	push   %ebx
801014c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801014cb:	83 ec 08             	sub    $0x8,%esp
801014ce:	8b 43 04             	mov    0x4(%ebx),%eax
801014d1:	c1 e8 03             	shr    $0x3,%eax
801014d4:	03 05 74 2f 11 80    	add    0x80112f74,%eax
801014da:	50                   	push   %eax
801014db:	ff 33                	pushl  (%ebx)
801014dd:	e8 c8 eb ff ff       	call   801000aa <bread>
801014e2:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801014e4:	8b 43 04             	mov    0x4(%ebx),%eax
801014e7:	83 e0 07             	and    $0x7,%eax
801014ea:	c1 e0 06             	shl    $0x6,%eax
801014ed:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801014f1:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
801014f5:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801014f8:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
801014fc:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101500:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
80101504:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101508:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
8010150c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101510:	8b 53 58             	mov    0x58(%ebx),%edx
80101513:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101516:	83 c4 0c             	add    $0xc,%esp
80101519:	6a 34                	push   $0x34
8010151b:	83 c3 5c             	add    $0x5c,%ebx
8010151e:	53                   	push   %ebx
8010151f:	83 c0 0c             	add    $0xc,%eax
80101522:	50                   	push   %eax
80101523:	e8 d0 35 00 00       	call   80104af8 <memmove>
  log_write(bp);
80101528:	89 34 24             	mov    %esi,(%esp)
8010152b:	e8 c4 14 00 00       	call   801029f4 <log_write>
  brelse(bp);
80101530:	89 34 24             	mov    %esi,(%esp)
80101533:	e8 89 ec ff ff       	call   801001c1 <brelse>
}
80101538:	83 c4 10             	add    $0x10,%esp
8010153b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010153e:	5b                   	pop    %ebx
8010153f:	5e                   	pop    %esi
80101540:	5d                   	pop    %ebp
80101541:	c3                   	ret    

80101542 <idup>:
{
80101542:	55                   	push   %ebp
80101543:	89 e5                	mov    %esp,%ebp
80101545:	53                   	push   %ebx
80101546:	83 ec 10             	sub    $0x10,%esp
80101549:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010154c:	68 80 2f 11 80       	push   $0x80112f80
80101551:	e8 5f 34 00 00       	call   801049b5 <acquire>
  ip->ref++;
80101556:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010155a:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
80101561:	e8 b6 34 00 00       	call   80104a1c <release>
}
80101566:	89 d8                	mov    %ebx,%eax
80101568:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010156b:	c9                   	leave  
8010156c:	c3                   	ret    

8010156d <ilock>:
{
8010156d:	55                   	push   %ebp
8010156e:	89 e5                	mov    %esp,%ebp
80101570:	56                   	push   %esi
80101571:	53                   	push   %ebx
80101572:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101575:	85 db                	test   %ebx,%ebx
80101577:	74 22                	je     8010159b <ilock+0x2e>
80101579:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
8010157d:	7e 1c                	jle    8010159b <ilock+0x2e>
  acquiresleep(&ip->lock);
8010157f:	83 ec 0c             	sub    $0xc,%esp
80101582:	8d 43 0c             	lea    0xc(%ebx),%eax
80101585:	50                   	push   %eax
80101586:	e8 2e 32 00 00       	call   801047b9 <acquiresleep>
  if(ip->valid == 0){
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101592:	74 14                	je     801015a8 <ilock+0x3b>
}
80101594:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101597:	5b                   	pop    %ebx
80101598:	5e                   	pop    %esi
80101599:	5d                   	pop    %ebp
8010159a:	c3                   	ret    
    panic("ilock");
8010159b:	83 ec 0c             	sub    $0xc,%esp
8010159e:	68 1e 74 10 80       	push   $0x8010741e
801015a3:	e8 9c ed ff ff       	call   80100344 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015a8:	83 ec 08             	sub    $0x8,%esp
801015ab:	8b 43 04             	mov    0x4(%ebx),%eax
801015ae:	c1 e8 03             	shr    $0x3,%eax
801015b1:	03 05 74 2f 11 80    	add    0x80112f74,%eax
801015b7:	50                   	push   %eax
801015b8:	ff 33                	pushl  (%ebx)
801015ba:	e8 eb ea ff ff       	call   801000aa <bread>
801015bf:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015c1:	8b 43 04             	mov    0x4(%ebx),%eax
801015c4:	83 e0 07             	and    $0x7,%eax
801015c7:	c1 e0 06             	shl    $0x6,%eax
801015ca:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801015ce:	0f b7 10             	movzwl (%eax),%edx
801015d1:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801015d5:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801015d9:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801015dd:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801015e1:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801015e5:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801015e9:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801015ed:	8b 50 08             	mov    0x8(%eax),%edx
801015f0:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015f3:	83 c4 0c             	add    $0xc,%esp
801015f6:	6a 34                	push   $0x34
801015f8:	83 c0 0c             	add    $0xc,%eax
801015fb:	50                   	push   %eax
801015fc:	8d 43 5c             	lea    0x5c(%ebx),%eax
801015ff:	50                   	push   %eax
80101600:	e8 f3 34 00 00       	call   80104af8 <memmove>
    brelse(bp);
80101605:	89 34 24             	mov    %esi,(%esp)
80101608:	e8 b4 eb ff ff       	call   801001c1 <brelse>
    ip->valid = 1;
8010160d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101614:	83 c4 10             	add    $0x10,%esp
80101617:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010161c:	0f 85 72 ff ff ff    	jne    80101594 <ilock+0x27>
      panic("ilock: no type");
80101622:	83 ec 0c             	sub    $0xc,%esp
80101625:	68 24 74 10 80       	push   $0x80107424
8010162a:	e8 15 ed ff ff       	call   80100344 <panic>

8010162f <iunlock>:
{
8010162f:	55                   	push   %ebp
80101630:	89 e5                	mov    %esp,%ebp
80101632:	56                   	push   %esi
80101633:	53                   	push   %ebx
80101634:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101637:	85 db                	test   %ebx,%ebx
80101639:	74 2c                	je     80101667 <iunlock+0x38>
8010163b:	8d 73 0c             	lea    0xc(%ebx),%esi
8010163e:	83 ec 0c             	sub    $0xc,%esp
80101641:	56                   	push   %esi
80101642:	e8 ff 31 00 00       	call   80104846 <holdingsleep>
80101647:	83 c4 10             	add    $0x10,%esp
8010164a:	85 c0                	test   %eax,%eax
8010164c:	74 19                	je     80101667 <iunlock+0x38>
8010164e:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101652:	7e 13                	jle    80101667 <iunlock+0x38>
  releasesleep(&ip->lock);
80101654:	83 ec 0c             	sub    $0xc,%esp
80101657:	56                   	push   %esi
80101658:	e8 ae 31 00 00       	call   8010480b <releasesleep>
}
8010165d:	83 c4 10             	add    $0x10,%esp
80101660:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101663:	5b                   	pop    %ebx
80101664:	5e                   	pop    %esi
80101665:	5d                   	pop    %ebp
80101666:	c3                   	ret    
    panic("iunlock");
80101667:	83 ec 0c             	sub    $0xc,%esp
8010166a:	68 33 74 10 80       	push   $0x80107433
8010166f:	e8 d0 ec ff ff       	call   80100344 <panic>

80101674 <iput>:
{
80101674:	55                   	push   %ebp
80101675:	89 e5                	mov    %esp,%ebp
80101677:	57                   	push   %edi
80101678:	56                   	push   %esi
80101679:	53                   	push   %ebx
8010167a:	83 ec 28             	sub    $0x28,%esp
8010167d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101680:	8d 73 0c             	lea    0xc(%ebx),%esi
80101683:	56                   	push   %esi
80101684:	e8 30 31 00 00       	call   801047b9 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101689:	83 c4 10             	add    $0x10,%esp
8010168c:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101690:	74 07                	je     80101699 <iput+0x25>
80101692:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101697:	74 30                	je     801016c9 <iput+0x55>
  releasesleep(&ip->lock);
80101699:	83 ec 0c             	sub    $0xc,%esp
8010169c:	56                   	push   %esi
8010169d:	e8 69 31 00 00       	call   8010480b <releasesleep>
  acquire(&icache.lock);
801016a2:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
801016a9:	e8 07 33 00 00       	call   801049b5 <acquire>
  ip->ref--;
801016ae:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016b2:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
801016b9:	e8 5e 33 00 00       	call   80104a1c <release>
}
801016be:	83 c4 10             	add    $0x10,%esp
801016c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5f                   	pop    %edi
801016c7:	5d                   	pop    %ebp
801016c8:	c3                   	ret    
    acquire(&icache.lock);
801016c9:	83 ec 0c             	sub    $0xc,%esp
801016cc:	68 80 2f 11 80       	push   $0x80112f80
801016d1:	e8 df 32 00 00       	call   801049b5 <acquire>
    int r = ip->ref;
801016d6:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801016d9:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
801016e0:	e8 37 33 00 00       	call   80104a1c <release>
    if(r == 1){
801016e5:	83 c4 10             	add    $0x10,%esp
801016e8:	83 ff 01             	cmp    $0x1,%edi
801016eb:	75 ac                	jne    80101699 <iput+0x25>
801016ed:	8d 7b 5c             	lea    0x5c(%ebx),%edi
801016f0:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
801016f6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801016f9:	89 c6                	mov    %eax,%esi
801016fb:	eb 07                	jmp    80101704 <iput+0x90>
801016fd:	83 c7 04             	add    $0x4,%edi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101700:	39 f7                	cmp    %esi,%edi
80101702:	74 15                	je     80101719 <iput+0xa5>
    if(ip->addrs[i]){
80101704:	8b 17                	mov    (%edi),%edx
80101706:	85 d2                	test   %edx,%edx
80101708:	74 f3                	je     801016fd <iput+0x89>
      bfree(ip->dev, ip->addrs[i]);
8010170a:	8b 03                	mov    (%ebx),%eax
8010170c:	e8 fa fb ff ff       	call   8010130b <bfree>
      ip->addrs[i] = 0;
80101711:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80101717:	eb e4                	jmp    801016fd <iput+0x89>
80101719:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
8010171c:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101722:	85 c0                	test   %eax,%eax
80101724:	75 2d                	jne    80101753 <iput+0xdf>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101726:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010172d:	83 ec 0c             	sub    $0xc,%esp
80101730:	53                   	push   %ebx
80101731:	e8 8d fd ff ff       	call   801014c3 <iupdate>
      ip->type = 0;
80101736:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
8010173c:	89 1c 24             	mov    %ebx,(%esp)
8010173f:	e8 7f fd ff ff       	call   801014c3 <iupdate>
      ip->valid = 0;
80101744:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010174b:	83 c4 10             	add    $0x10,%esp
8010174e:	e9 46 ff ff ff       	jmp    80101699 <iput+0x25>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101753:	83 ec 08             	sub    $0x8,%esp
80101756:	50                   	push   %eax
80101757:	ff 33                	pushl  (%ebx)
80101759:	e8 4c e9 ff ff       	call   801000aa <bread>
8010175e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101761:	8d 78 5c             	lea    0x5c(%eax),%edi
80101764:	05 5c 02 00 00       	add    $0x25c,%eax
80101769:	83 c4 10             	add    $0x10,%esp
8010176c:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010176f:	89 c6                	mov    %eax,%esi
80101771:	eb 07                	jmp    8010177a <iput+0x106>
80101773:	83 c7 04             	add    $0x4,%edi
    for(j = 0; j < NINDIRECT; j++){
80101776:	39 fe                	cmp    %edi,%esi
80101778:	74 0f                	je     80101789 <iput+0x115>
      if(a[j])
8010177a:	8b 17                	mov    (%edi),%edx
8010177c:	85 d2                	test   %edx,%edx
8010177e:	74 f3                	je     80101773 <iput+0xff>
        bfree(ip->dev, a[j]);
80101780:	8b 03                	mov    (%ebx),%eax
80101782:	e8 84 fb ff ff       	call   8010130b <bfree>
80101787:	eb ea                	jmp    80101773 <iput+0xff>
80101789:	8b 75 e0             	mov    -0x20(%ebp),%esi
    brelse(bp);
8010178c:	83 ec 0c             	sub    $0xc,%esp
8010178f:	ff 75 e4             	pushl  -0x1c(%ebp)
80101792:	e8 2a ea ff ff       	call   801001c1 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101797:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
8010179d:	8b 03                	mov    (%ebx),%eax
8010179f:	e8 67 fb ff ff       	call   8010130b <bfree>
    ip->addrs[NDIRECT] = 0;
801017a4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801017ab:	00 00 00 
801017ae:	83 c4 10             	add    $0x10,%esp
801017b1:	e9 70 ff ff ff       	jmp    80101726 <iput+0xb2>

801017b6 <iunlockput>:
{
801017b6:	55                   	push   %ebp
801017b7:	89 e5                	mov    %esp,%ebp
801017b9:	53                   	push   %ebx
801017ba:	83 ec 10             	sub    $0x10,%esp
801017bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801017c0:	53                   	push   %ebx
801017c1:	e8 69 fe ff ff       	call   8010162f <iunlock>
  iput(ip);
801017c6:	89 1c 24             	mov    %ebx,(%esp)
801017c9:	e8 a6 fe ff ff       	call   80101674 <iput>
}
801017ce:	83 c4 10             	add    $0x10,%esp
801017d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017d4:	c9                   	leave  
801017d5:	c3                   	ret    

801017d6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801017d6:	55                   	push   %ebp
801017d7:	89 e5                	mov    %esp,%ebp
801017d9:	8b 55 08             	mov    0x8(%ebp),%edx
801017dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801017df:	8b 0a                	mov    (%edx),%ecx
801017e1:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801017e4:	8b 4a 04             	mov    0x4(%edx),%ecx
801017e7:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801017ea:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801017ee:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801017f1:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801017f5:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801017f9:	8b 52 58             	mov    0x58(%edx),%edx
801017fc:	89 50 10             	mov    %edx,0x10(%eax)
}
801017ff:	5d                   	pop    %ebp
80101800:	c3                   	ret    

80101801 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101801:	55                   	push   %ebp
80101802:	89 e5                	mov    %esp,%ebp
80101804:	57                   	push   %edi
80101805:	56                   	push   %esi
80101806:	53                   	push   %ebx
80101807:	83 ec 1c             	sub    $0x1c,%esp
8010180a:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010180d:	8b 45 08             	mov    0x8(%ebp),%eax
80101810:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101815:	0f 84 9d 00 00 00    	je     801018b8 <readi+0xb7>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
8010181b:	8b 45 08             	mov    0x8(%ebp),%eax
8010181e:	8b 40 58             	mov    0x58(%eax),%eax
80101821:	39 f8                	cmp    %edi,%eax
80101823:	0f 82 c6 00 00 00    	jb     801018ef <readi+0xee>
80101829:	89 fa                	mov    %edi,%edx
8010182b:	03 55 14             	add    0x14(%ebp),%edx
8010182e:	0f 82 c2 00 00 00    	jb     801018f6 <readi+0xf5>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101834:	89 c1                	mov    %eax,%ecx
80101836:	29 f9                	sub    %edi,%ecx
80101838:	39 d0                	cmp    %edx,%eax
8010183a:	0f 43 4d 14          	cmovae 0x14(%ebp),%ecx
8010183e:	89 4d 14             	mov    %ecx,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101841:	85 c9                	test   %ecx,%ecx
80101843:	74 68                	je     801018ad <readi+0xac>
80101845:	be 00 00 00 00       	mov    $0x0,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010184a:	89 fa                	mov    %edi,%edx
8010184c:	c1 ea 09             	shr    $0x9,%edx
8010184f:	8b 45 08             	mov    0x8(%ebp),%eax
80101852:	e8 2a f9 ff ff       	call   80101181 <bmap>
80101857:	83 ec 08             	sub    $0x8,%esp
8010185a:	50                   	push   %eax
8010185b:	8b 45 08             	mov    0x8(%ebp),%eax
8010185e:	ff 30                	pushl  (%eax)
80101860:	e8 45 e8 ff ff       	call   801000aa <bread>
80101865:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
80101867:	89 f8                	mov    %edi,%eax
80101869:	25 ff 01 00 00       	and    $0x1ff,%eax
8010186e:	bb 00 02 00 00       	mov    $0x200,%ebx
80101873:	29 c3                	sub    %eax,%ebx
80101875:	8b 55 14             	mov    0x14(%ebp),%edx
80101878:	29 f2                	sub    %esi,%edx
8010187a:	83 c4 0c             	add    $0xc,%esp
8010187d:	39 d3                	cmp    %edx,%ebx
8010187f:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101882:	53                   	push   %ebx
80101883:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101886:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
8010188a:	50                   	push   %eax
8010188b:	ff 75 0c             	pushl  0xc(%ebp)
8010188e:	e8 65 32 00 00       	call   80104af8 <memmove>
    brelse(bp);
80101893:	83 c4 04             	add    $0x4,%esp
80101896:	ff 75 e4             	pushl  -0x1c(%ebp)
80101899:	e8 23 e9 ff ff       	call   801001c1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010189e:	01 de                	add    %ebx,%esi
801018a0:	01 df                	add    %ebx,%edi
801018a2:	01 5d 0c             	add    %ebx,0xc(%ebp)
801018a5:	83 c4 10             	add    $0x10,%esp
801018a8:	39 75 14             	cmp    %esi,0x14(%ebp)
801018ab:	77 9d                	ja     8010184a <readi+0x49>
  }
  return n;
801018ad:	8b 45 14             	mov    0x14(%ebp),%eax
}
801018b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018b3:	5b                   	pop    %ebx
801018b4:	5e                   	pop    %esi
801018b5:	5f                   	pop    %edi
801018b6:	5d                   	pop    %ebp
801018b7:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801018b8:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801018bc:	66 83 f8 09          	cmp    $0x9,%ax
801018c0:	77 1f                	ja     801018e1 <readi+0xe0>
801018c2:	98                   	cwtl   
801018c3:	8b 04 c5 00 2f 11 80 	mov    -0x7feed100(,%eax,8),%eax
801018ca:	85 c0                	test   %eax,%eax
801018cc:	74 1a                	je     801018e8 <readi+0xe7>
    return devsw[ip->major].read(ip, dst, n);
801018ce:	83 ec 04             	sub    $0x4,%esp
801018d1:	ff 75 14             	pushl  0x14(%ebp)
801018d4:	ff 75 0c             	pushl  0xc(%ebp)
801018d7:	ff 75 08             	pushl  0x8(%ebp)
801018da:	ff d0                	call   *%eax
801018dc:	83 c4 10             	add    $0x10,%esp
801018df:	eb cf                	jmp    801018b0 <readi+0xaf>
      return -1;
801018e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018e6:	eb c8                	jmp    801018b0 <readi+0xaf>
801018e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018ed:	eb c1                	jmp    801018b0 <readi+0xaf>
    return -1;
801018ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018f4:	eb ba                	jmp    801018b0 <readi+0xaf>
801018f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018fb:	eb b3                	jmp    801018b0 <readi+0xaf>

801018fd <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801018fd:	55                   	push   %ebp
801018fe:	89 e5                	mov    %esp,%ebp
80101900:	57                   	push   %edi
80101901:	56                   	push   %esi
80101902:	53                   	push   %ebx
80101903:	83 ec 1c             	sub    $0x1c,%esp
80101906:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101909:	8b 45 08             	mov    0x8(%ebp),%eax
8010190c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101911:	0f 84 ae 00 00 00    	je     801019c5 <writei+0xc8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101917:	8b 45 08             	mov    0x8(%ebp),%eax
8010191a:	39 70 58             	cmp    %esi,0x58(%eax)
8010191d:	0f 82 ed 00 00 00    	jb     80101a10 <writei+0x113>
80101923:	89 f0                	mov    %esi,%eax
80101925:	03 45 14             	add    0x14(%ebp),%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101928:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010192d:	0f 87 e4 00 00 00    	ja     80101a17 <writei+0x11a>
80101933:	39 f0                	cmp    %esi,%eax
80101935:	0f 82 dc 00 00 00    	jb     80101a17 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010193b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010193f:	74 79                	je     801019ba <writei+0xbd>
80101941:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101948:	89 f2                	mov    %esi,%edx
8010194a:	c1 ea 09             	shr    $0x9,%edx
8010194d:	8b 45 08             	mov    0x8(%ebp),%eax
80101950:	e8 2c f8 ff ff       	call   80101181 <bmap>
80101955:	83 ec 08             	sub    $0x8,%esp
80101958:	50                   	push   %eax
80101959:	8b 45 08             	mov    0x8(%ebp),%eax
8010195c:	ff 30                	pushl  (%eax)
8010195e:	e8 47 e7 ff ff       	call   801000aa <bread>
80101963:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101965:	89 f0                	mov    %esi,%eax
80101967:	25 ff 01 00 00       	and    $0x1ff,%eax
8010196c:	bb 00 02 00 00       	mov    $0x200,%ebx
80101971:	29 c3                	sub    %eax,%ebx
80101973:	8b 55 14             	mov    0x14(%ebp),%edx
80101976:	2b 55 e4             	sub    -0x1c(%ebp),%edx
80101979:	83 c4 0c             	add    $0xc,%esp
8010197c:	39 d3                	cmp    %edx,%ebx
8010197e:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101981:	53                   	push   %ebx
80101982:	ff 75 0c             	pushl  0xc(%ebp)
80101985:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101989:	50                   	push   %eax
8010198a:	e8 69 31 00 00       	call   80104af8 <memmove>
    log_write(bp);
8010198f:	89 3c 24             	mov    %edi,(%esp)
80101992:	e8 5d 10 00 00       	call   801029f4 <log_write>
    brelse(bp);
80101997:	89 3c 24             	mov    %edi,(%esp)
8010199a:	e8 22 e8 ff ff       	call   801001c1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010199f:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801019a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019a5:	01 de                	add    %ebx,%esi
801019a7:	01 5d 0c             	add    %ebx,0xc(%ebp)
801019aa:	83 c4 10             	add    $0x10,%esp
801019ad:	39 4d 14             	cmp    %ecx,0x14(%ebp)
801019b0:	77 96                	ja     80101948 <writei+0x4b>
  }

  if(n > 0 && off > ip->size){
801019b2:	8b 45 08             	mov    0x8(%ebp),%eax
801019b5:	39 70 58             	cmp    %esi,0x58(%eax)
801019b8:	72 34                	jb     801019ee <writei+0xf1>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801019ba:	8b 45 14             	mov    0x14(%ebp),%eax
}
801019bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019c0:	5b                   	pop    %ebx
801019c1:	5e                   	pop    %esi
801019c2:	5f                   	pop    %edi
801019c3:	5d                   	pop    %ebp
801019c4:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801019c5:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801019c9:	66 83 f8 09          	cmp    $0x9,%ax
801019cd:	77 33                	ja     80101a02 <writei+0x105>
801019cf:	98                   	cwtl   
801019d0:	8b 04 c5 04 2f 11 80 	mov    -0x7feed0fc(,%eax,8),%eax
801019d7:	85 c0                	test   %eax,%eax
801019d9:	74 2e                	je     80101a09 <writei+0x10c>
    return devsw[ip->major].write(ip, src, n);
801019db:	83 ec 04             	sub    $0x4,%esp
801019de:	ff 75 14             	pushl  0x14(%ebp)
801019e1:	ff 75 0c             	pushl  0xc(%ebp)
801019e4:	ff 75 08             	pushl  0x8(%ebp)
801019e7:	ff d0                	call   *%eax
801019e9:	83 c4 10             	add    $0x10,%esp
801019ec:	eb cf                	jmp    801019bd <writei+0xc0>
    ip->size = off;
801019ee:	8b 45 08             	mov    0x8(%ebp),%eax
801019f1:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801019f4:	83 ec 0c             	sub    $0xc,%esp
801019f7:	50                   	push   %eax
801019f8:	e8 c6 fa ff ff       	call   801014c3 <iupdate>
801019fd:	83 c4 10             	add    $0x10,%esp
80101a00:	eb b8                	jmp    801019ba <writei+0xbd>
      return -1;
80101a02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a07:	eb b4                	jmp    801019bd <writei+0xc0>
80101a09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a0e:	eb ad                	jmp    801019bd <writei+0xc0>
    return -1;
80101a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a15:	eb a6                	jmp    801019bd <writei+0xc0>
    return -1;
80101a17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a1c:	eb 9f                	jmp    801019bd <writei+0xc0>

80101a1e <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101a1e:	55                   	push   %ebp
80101a1f:	89 e5                	mov    %esp,%ebp
80101a21:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101a24:	6a 0e                	push   $0xe
80101a26:	ff 75 0c             	pushl  0xc(%ebp)
80101a29:	ff 75 08             	pushl  0x8(%ebp)
80101a2c:	e8 26 31 00 00       	call   80104b57 <strncmp>
}
80101a31:	c9                   	leave  
80101a32:	c3                   	ret    

80101a33 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101a33:	55                   	push   %ebp
80101a34:	89 e5                	mov    %esp,%ebp
80101a36:	57                   	push   %edi
80101a37:	56                   	push   %esi
80101a38:	53                   	push   %ebx
80101a39:	83 ec 1c             	sub    $0x1c,%esp
80101a3c:	8b 75 08             	mov    0x8(%ebp),%esi
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101a3f:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101a44:	75 15                	jne    80101a5b <dirlookup+0x28>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101a46:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a4b:	8d 7d d8             	lea    -0x28(%ebp),%edi
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101a4e:	b8 00 00 00 00       	mov    $0x0,%eax
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a53:	83 7e 58 00          	cmpl   $0x0,0x58(%esi)
80101a57:	75 24                	jne    80101a7d <dirlookup+0x4a>
80101a59:	eb 6e                	jmp    80101ac9 <dirlookup+0x96>
    panic("dirlookup not DIR");
80101a5b:	83 ec 0c             	sub    $0xc,%esp
80101a5e:	68 3b 74 10 80       	push   $0x8010743b
80101a63:	e8 dc e8 ff ff       	call   80100344 <panic>
      panic("dirlookup read");
80101a68:	83 ec 0c             	sub    $0xc,%esp
80101a6b:	68 4d 74 10 80       	push   $0x8010744d
80101a70:	e8 cf e8 ff ff       	call   80100344 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a75:	83 c3 10             	add    $0x10,%ebx
80101a78:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a7b:	76 47                	jbe    80101ac4 <dirlookup+0x91>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a7d:	6a 10                	push   $0x10
80101a7f:	53                   	push   %ebx
80101a80:	57                   	push   %edi
80101a81:	56                   	push   %esi
80101a82:	e8 7a fd ff ff       	call   80101801 <readi>
80101a87:	83 c4 10             	add    $0x10,%esp
80101a8a:	83 f8 10             	cmp    $0x10,%eax
80101a8d:	75 d9                	jne    80101a68 <dirlookup+0x35>
    if(de.inum == 0)
80101a8f:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a94:	74 df                	je     80101a75 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
80101a96:	83 ec 08             	sub    $0x8,%esp
80101a99:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a9c:	50                   	push   %eax
80101a9d:	ff 75 0c             	pushl  0xc(%ebp)
80101aa0:	e8 79 ff ff ff       	call   80101a1e <namecmp>
80101aa5:	83 c4 10             	add    $0x10,%esp
80101aa8:	85 c0                	test   %eax,%eax
80101aaa:	75 c9                	jne    80101a75 <dirlookup+0x42>
      if(poff)
80101aac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101ab0:	74 05                	je     80101ab7 <dirlookup+0x84>
        *poff = off;
80101ab2:	8b 45 10             	mov    0x10(%ebp),%eax
80101ab5:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101ab7:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101abb:	8b 06                	mov    (%esi),%eax
80101abd:	e8 64 f7 ff ff       	call   80101226 <iget>
80101ac2:	eb 05                	jmp    80101ac9 <dirlookup+0x96>
  return 0;
80101ac4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101ac9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101acc:	5b                   	pop    %ebx
80101acd:	5e                   	pop    %esi
80101ace:	5f                   	pop    %edi
80101acf:	5d                   	pop    %ebp
80101ad0:	c3                   	ret    

80101ad1 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ad1:	55                   	push   %ebp
80101ad2:	89 e5                	mov    %esp,%ebp
80101ad4:	57                   	push   %edi
80101ad5:	56                   	push   %esi
80101ad6:	53                   	push   %ebx
80101ad7:	83 ec 1c             	sub    $0x1c,%esp
80101ada:	89 c6                	mov    %eax,%esi
80101adc:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101adf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ae2:	80 38 2f             	cmpb   $0x2f,(%eax)
80101ae5:	74 1a                	je     80101b01 <namex+0x30>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ae7:	e8 bd 1a 00 00       	call   801035a9 <myproc>
80101aec:	83 ec 0c             	sub    $0xc,%esp
80101aef:	ff 70 68             	pushl  0x68(%eax)
80101af2:	e8 4b fa ff ff       	call   80101542 <idup>
80101af7:	89 c7                	mov    %eax,%edi
80101af9:	83 c4 10             	add    $0x10,%esp
80101afc:	e9 d4 00 00 00       	jmp    80101bd5 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
80101b01:	ba 01 00 00 00       	mov    $0x1,%edx
80101b06:	b8 01 00 00 00       	mov    $0x1,%eax
80101b0b:	e8 16 f7 ff ff       	call   80101226 <iget>
80101b10:	89 c7                	mov    %eax,%edi
80101b12:	e9 be 00 00 00       	jmp    80101bd5 <namex+0x104>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101b17:	83 ec 0c             	sub    $0xc,%esp
80101b1a:	57                   	push   %edi
80101b1b:	e8 96 fc ff ff       	call   801017b6 <iunlockput>
      return 0;
80101b20:	83 c4 10             	add    $0x10,%esp
80101b23:	bf 00 00 00 00       	mov    $0x0,%edi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101b28:	89 f8                	mov    %edi,%eax
80101b2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b2d:	5b                   	pop    %ebx
80101b2e:	5e                   	pop    %esi
80101b2f:	5f                   	pop    %edi
80101b30:	5d                   	pop    %ebp
80101b31:	c3                   	ret    
      iunlock(ip);
80101b32:	83 ec 0c             	sub    $0xc,%esp
80101b35:	57                   	push   %edi
80101b36:	e8 f4 fa ff ff       	call   8010162f <iunlock>
      return ip;
80101b3b:	83 c4 10             	add    $0x10,%esp
80101b3e:	eb e8                	jmp    80101b28 <namex+0x57>
      iunlockput(ip);
80101b40:	83 ec 0c             	sub    $0xc,%esp
80101b43:	57                   	push   %edi
80101b44:	e8 6d fc ff ff       	call   801017b6 <iunlockput>
      return 0;
80101b49:	83 c4 10             	add    $0x10,%esp
80101b4c:	89 f7                	mov    %esi,%edi
80101b4e:	eb d8                	jmp    80101b28 <namex+0x57>
  while(*path != '/' && *path != 0)
80101b50:	89 f3                	mov    %esi,%ebx
  len = path - s;
80101b52:	89 d8                	mov    %ebx,%eax
80101b54:	29 f0                	sub    %esi,%eax
80101b56:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(len >= DIRSIZ)
80101b59:	83 f8 0d             	cmp    $0xd,%eax
80101b5c:	0f 8e b4 00 00 00    	jle    80101c16 <namex+0x145>
    memmove(name, s, DIRSIZ);
80101b62:	83 ec 04             	sub    $0x4,%esp
80101b65:	6a 0e                	push   $0xe
80101b67:	56                   	push   %esi
80101b68:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b6b:	e8 88 2f 00 00       	call   80104af8 <memmove>
80101b70:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101b73:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101b76:	75 08                	jne    80101b80 <namex+0xaf>
    path++;
80101b78:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101b7b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101b7e:	74 f8                	je     80101b78 <namex+0xa7>
  while((path = skipelem(path, name)) != 0){
80101b80:	85 db                	test   %ebx,%ebx
80101b82:	0f 84 ad 00 00 00    	je     80101c35 <namex+0x164>
    ilock(ip);
80101b88:	83 ec 0c             	sub    $0xc,%esp
80101b8b:	57                   	push   %edi
80101b8c:	e8 dc f9 ff ff       	call   8010156d <ilock>
    if(ip->type != T_DIR){
80101b91:	83 c4 10             	add    $0x10,%esp
80101b94:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80101b99:	0f 85 78 ff ff ff    	jne    80101b17 <namex+0x46>
    if(nameiparent && *path == '\0'){
80101b9f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101ba3:	74 05                	je     80101baa <namex+0xd9>
80101ba5:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ba8:	74 88                	je     80101b32 <namex+0x61>
    if((next = dirlookup(ip, name, 0)) == 0){
80101baa:	83 ec 04             	sub    $0x4,%esp
80101bad:	6a 00                	push   $0x0
80101baf:	ff 75 e4             	pushl  -0x1c(%ebp)
80101bb2:	57                   	push   %edi
80101bb3:	e8 7b fe ff ff       	call   80101a33 <dirlookup>
80101bb8:	89 c6                	mov    %eax,%esi
80101bba:	83 c4 10             	add    $0x10,%esp
80101bbd:	85 c0                	test   %eax,%eax
80101bbf:	0f 84 7b ff ff ff    	je     80101b40 <namex+0x6f>
    iunlockput(ip);
80101bc5:	83 ec 0c             	sub    $0xc,%esp
80101bc8:	57                   	push   %edi
80101bc9:	e8 e8 fb ff ff       	call   801017b6 <iunlockput>
    ip = next;
80101bce:	83 c4 10             	add    $0x10,%esp
80101bd1:	89 f7                	mov    %esi,%edi
80101bd3:	89 de                	mov    %ebx,%esi
  while(*path == '/')
80101bd5:	0f b6 06             	movzbl (%esi),%eax
80101bd8:	3c 2f                	cmp    $0x2f,%al
80101bda:	75 0a                	jne    80101be6 <namex+0x115>
    path++;
80101bdc:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
80101bdf:	0f b6 06             	movzbl (%esi),%eax
80101be2:	3c 2f                	cmp    $0x2f,%al
80101be4:	74 f6                	je     80101bdc <namex+0x10b>
  if(*path == 0)
80101be6:	84 c0                	test   %al,%al
80101be8:	74 4b                	je     80101c35 <namex+0x164>
  while(*path != '/' && *path != 0)
80101bea:	0f b6 06             	movzbl (%esi),%eax
80101bed:	3c 2f                	cmp    $0x2f,%al
80101bef:	0f 84 5b ff ff ff    	je     80101b50 <namex+0x7f>
80101bf5:	84 c0                	test   %al,%al
80101bf7:	0f 84 53 ff ff ff    	je     80101b50 <namex+0x7f>
80101bfd:	89 f3                	mov    %esi,%ebx
    path++;
80101bff:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101c02:	0f b6 03             	movzbl (%ebx),%eax
80101c05:	3c 2f                	cmp    $0x2f,%al
80101c07:	0f 84 45 ff ff ff    	je     80101b52 <namex+0x81>
80101c0d:	84 c0                	test   %al,%al
80101c0f:	75 ee                	jne    80101bff <namex+0x12e>
80101c11:	e9 3c ff ff ff       	jmp    80101b52 <namex+0x81>
    memmove(name, s, len);
80101c16:	83 ec 04             	sub    $0x4,%esp
80101c19:	ff 75 e0             	pushl  -0x20(%ebp)
80101c1c:	56                   	push   %esi
80101c1d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101c20:	56                   	push   %esi
80101c21:	e8 d2 2e 00 00       	call   80104af8 <memmove>
    name[len] = 0;
80101c26:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101c29:	c6 04 0e 00          	movb   $0x0,(%esi,%ecx,1)
80101c2d:	83 c4 10             	add    $0x10,%esp
80101c30:	e9 3e ff ff ff       	jmp    80101b73 <namex+0xa2>
  if(nameiparent){
80101c35:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101c39:	0f 84 e9 fe ff ff    	je     80101b28 <namex+0x57>
    iput(ip);
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	57                   	push   %edi
80101c43:	e8 2c fa ff ff       	call   80101674 <iput>
    return 0;
80101c48:	83 c4 10             	add    $0x10,%esp
80101c4b:	bf 00 00 00 00       	mov    $0x0,%edi
80101c50:	e9 d3 fe ff ff       	jmp    80101b28 <namex+0x57>

80101c55 <dirlink>:
{
80101c55:	55                   	push   %ebp
80101c56:	89 e5                	mov    %esp,%ebp
80101c58:	57                   	push   %edi
80101c59:	56                   	push   %esi
80101c5a:	53                   	push   %ebx
80101c5b:	83 ec 20             	sub    $0x20,%esp
80101c5e:	8b 75 08             	mov    0x8(%ebp),%esi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101c61:	6a 00                	push   $0x0
80101c63:	ff 75 0c             	pushl  0xc(%ebp)
80101c66:	56                   	push   %esi
80101c67:	e8 c7 fd ff ff       	call   80101a33 <dirlookup>
80101c6c:	83 c4 10             	add    $0x10,%esp
80101c6f:	85 c0                	test   %eax,%eax
80101c71:	75 6a                	jne    80101cdd <dirlink+0x88>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c73:	8b 5e 58             	mov    0x58(%esi),%ebx
80101c76:	85 db                	test   %ebx,%ebx
80101c78:	74 29                	je     80101ca3 <dirlink+0x4e>
80101c7a:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c7f:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c82:	6a 10                	push   $0x10
80101c84:	53                   	push   %ebx
80101c85:	57                   	push   %edi
80101c86:	56                   	push   %esi
80101c87:	e8 75 fb ff ff       	call   80101801 <readi>
80101c8c:	83 c4 10             	add    $0x10,%esp
80101c8f:	83 f8 10             	cmp    $0x10,%eax
80101c92:	75 5c                	jne    80101cf0 <dirlink+0x9b>
    if(de.inum == 0)
80101c94:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c99:	74 08                	je     80101ca3 <dirlink+0x4e>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c9b:	83 c3 10             	add    $0x10,%ebx
80101c9e:	3b 5e 58             	cmp    0x58(%esi),%ebx
80101ca1:	72 df                	jb     80101c82 <dirlink+0x2d>
  strncpy(de.name, name, DIRSIZ);
80101ca3:	83 ec 04             	sub    $0x4,%esp
80101ca6:	6a 0e                	push   $0xe
80101ca8:	ff 75 0c             	pushl  0xc(%ebp)
80101cab:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101cae:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cb1:	50                   	push   %eax
80101cb2:	e8 ec 2e 00 00       	call   80104ba3 <strncpy>
  de.inum = inum;
80101cb7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cbe:	6a 10                	push   $0x10
80101cc0:	53                   	push   %ebx
80101cc1:	57                   	push   %edi
80101cc2:	56                   	push   %esi
80101cc3:	e8 35 fc ff ff       	call   801018fd <writei>
80101cc8:	83 c4 20             	add    $0x20,%esp
80101ccb:	83 f8 10             	cmp    $0x10,%eax
80101cce:	75 2d                	jne    80101cfd <dirlink+0xa8>
  return 0;
80101cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101cd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cd8:	5b                   	pop    %ebx
80101cd9:	5e                   	pop    %esi
80101cda:	5f                   	pop    %edi
80101cdb:	5d                   	pop    %ebp
80101cdc:	c3                   	ret    
    iput(ip);
80101cdd:	83 ec 0c             	sub    $0xc,%esp
80101ce0:	50                   	push   %eax
80101ce1:	e8 8e f9 ff ff       	call   80101674 <iput>
    return -1;
80101ce6:	83 c4 10             	add    $0x10,%esp
80101ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cee:	eb e5                	jmp    80101cd5 <dirlink+0x80>
      panic("dirlink read");
80101cf0:	83 ec 0c             	sub    $0xc,%esp
80101cf3:	68 5c 74 10 80       	push   $0x8010745c
80101cf8:	e8 47 e6 ff ff       	call   80100344 <panic>
    panic("dirlink");
80101cfd:	83 ec 0c             	sub    $0xc,%esp
80101d00:	68 fe 7c 10 80       	push   $0x80107cfe
80101d05:	e8 3a e6 ff ff       	call   80100344 <panic>

80101d0a <namei>:

struct inode*
namei(char *path)
{
80101d0a:	55                   	push   %ebp
80101d0b:	89 e5                	mov    %esp,%ebp
80101d0d:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101d10:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101d13:	ba 00 00 00 00       	mov    $0x0,%edx
80101d18:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1b:	e8 b1 fd ff ff       	call   80101ad1 <namex>
}
80101d20:	c9                   	leave  
80101d21:	c3                   	ret    

80101d22 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101d22:	55                   	push   %ebp
80101d23:	89 e5                	mov    %esp,%ebp
80101d25:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101d2b:	ba 01 00 00 00       	mov    $0x1,%edx
80101d30:	8b 45 08             	mov    0x8(%ebp),%eax
80101d33:	e8 99 fd ff ff       	call   80101ad1 <namex>
}
80101d38:	c9                   	leave  
80101d39:	c3                   	ret    

80101d3a <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101d3a:	55                   	push   %ebp
80101d3b:	89 e5                	mov    %esp,%ebp
80101d3d:	56                   	push   %esi
80101d3e:	53                   	push   %ebx
  if(b == 0)
80101d3f:	85 c0                	test   %eax,%eax
80101d41:	0f 84 84 00 00 00    	je     80101dcb <idestart+0x91>
80101d47:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101d49:	8b 58 08             	mov    0x8(%eax),%ebx
80101d4c:	81 fb cf 07 00 00    	cmp    $0x7cf,%ebx
80101d52:	0f 87 80 00 00 00    	ja     80101dd8 <idestart+0x9e>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d58:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d5d:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101d5e:	83 e0 c0             	and    $0xffffffc0,%eax
80101d61:	3c 40                	cmp    $0x40,%al
80101d63:	75 f8                	jne    80101d5d <idestart+0x23>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d65:	b8 00 00 00 00       	mov    $0x0,%eax
80101d6a:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101d6f:	ee                   	out    %al,(%dx)
80101d70:	b8 01 00 00 00       	mov    $0x1,%eax
80101d75:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101d7a:	ee                   	out    %al,(%dx)
80101d7b:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101d80:	89 d8                	mov    %ebx,%eax
80101d82:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101d83:	89 d8                	mov    %ebx,%eax
80101d85:	c1 f8 08             	sar    $0x8,%eax
80101d88:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d8d:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101d8e:	89 d8                	mov    %ebx,%eax
80101d90:	c1 f8 10             	sar    $0x10,%eax
80101d93:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d98:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101d99:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101d9d:	c1 e0 04             	shl    $0x4,%eax
80101da0:	83 e0 10             	and    $0x10,%eax
80101da3:	83 c8 e0             	or     $0xffffffe0,%eax
80101da6:	c1 fb 18             	sar    $0x18,%ebx
80101da9:	83 e3 0f             	and    $0xf,%ebx
80101dac:	09 d8                	or     %ebx,%eax
80101dae:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101db3:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101db4:	f6 06 04             	testb  $0x4,(%esi)
80101db7:	75 2c                	jne    80101de5 <idestart+0xab>
80101db9:	b8 20 00 00 00       	mov    $0x20,%eax
80101dbe:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dc3:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101dc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dc7:	5b                   	pop    %ebx
80101dc8:	5e                   	pop    %esi
80101dc9:	5d                   	pop    %ebp
80101dca:	c3                   	ret    
    panic("idestart");
80101dcb:	83 ec 0c             	sub    $0xc,%esp
80101dce:	68 bf 74 10 80       	push   $0x801074bf
80101dd3:	e8 6c e5 ff ff       	call   80100344 <panic>
    panic("incorrect blockno");
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	68 c8 74 10 80       	push   $0x801074c8
80101de0:	e8 5f e5 ff ff       	call   80100344 <panic>
80101de5:	b8 30 00 00 00       	mov    $0x30,%eax
80101dea:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101def:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101df0:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101df3:	b9 80 00 00 00       	mov    $0x80,%ecx
80101df8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101dfd:	fc                   	cld    
80101dfe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101e00:	eb c2                	jmp    80101dc4 <idestart+0x8a>

80101e02 <ideinit>:
{
80101e02:	55                   	push   %ebp
80101e03:	89 e5                	mov    %esp,%ebp
80101e05:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101e08:	68 da 74 10 80       	push   $0x801074da
80101e0d:	68 80 a5 10 80       	push   $0x8010a580
80101e12:	e8 56 2a 00 00       	call   8010486d <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101e17:	83 c4 08             	add    $0x8,%esp
80101e1a:	a1 a0 52 11 80       	mov    0x801152a0,%eax
80101e1f:	83 e8 01             	sub    $0x1,%eax
80101e22:	50                   	push   %eax
80101e23:	6a 0e                	push   $0xe
80101e25:	e8 63 02 00 00       	call   8010208d <ioapicenable>
80101e2a:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e2d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e32:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e33:	83 e0 c0             	and    $0xffffffc0,%eax
80101e36:	3c 40                	cmp    $0x40,%al
80101e38:	75 f8                	jne    80101e32 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e3a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101e3f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e44:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e45:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e4a:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101e4b:	84 c0                	test   %al,%al
80101e4d:	75 11                	jne    80101e60 <ideinit+0x5e>
80101e4f:	b9 e7 03 00 00       	mov    $0x3e7,%ecx
80101e54:	ec                   	in     (%dx),%al
80101e55:	84 c0                	test   %al,%al
80101e57:	75 07                	jne    80101e60 <ideinit+0x5e>
  for(i=0; i<1000; i++){
80101e59:	83 e9 01             	sub    $0x1,%ecx
80101e5c:	75 f6                	jne    80101e54 <ideinit+0x52>
80101e5e:	eb 0a                	jmp    80101e6a <ideinit+0x68>
      havedisk1 = 1;
80101e60:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101e67:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e6a:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101e6f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e74:	ee                   	out    %al,(%dx)
}
80101e75:	c9                   	leave  
80101e76:	c3                   	ret    

80101e77 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101e77:	55                   	push   %ebp
80101e78:	89 e5                	mov    %esp,%ebp
80101e7a:	57                   	push   %edi
80101e7b:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101e7c:	83 ec 0c             	sub    $0xc,%esp
80101e7f:	68 80 a5 10 80       	push   $0x8010a580
80101e84:	e8 2c 2b 00 00       	call   801049b5 <acquire>

  if((b = idequeue) == 0){
80101e89:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101e8f:	83 c4 10             	add    $0x10,%esp
80101e92:	85 db                	test   %ebx,%ebx
80101e94:	74 48                	je     80101ede <ideintr+0x67>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e96:	8b 43 58             	mov    0x58(%ebx),%eax
80101e99:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e9e:	f6 03 04             	testb  $0x4,(%ebx)
80101ea1:	74 4d                	je     80101ef0 <ideintr+0x79>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80101ea3:	8b 03                	mov    (%ebx),%eax
80101ea5:	83 e0 fb             	and    $0xfffffffb,%eax
80101ea8:	83 c8 02             	or     $0x2,%eax
80101eab:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101ead:	83 ec 0c             	sub    $0xc,%esp
80101eb0:	53                   	push   %ebx
80101eb1:	e8 94 21 00 00       	call   8010404a <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101eb6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101ebb:	83 c4 10             	add    $0x10,%esp
80101ebe:	85 c0                	test   %eax,%eax
80101ec0:	74 05                	je     80101ec7 <ideintr+0x50>
    idestart(idequeue);
80101ec2:	e8 73 fe ff ff       	call   80101d3a <idestart>

  release(&idelock);
80101ec7:	83 ec 0c             	sub    $0xc,%esp
80101eca:	68 80 a5 10 80       	push   $0x8010a580
80101ecf:	e8 48 2b 00 00       	call   80104a1c <release>
80101ed4:	83 c4 10             	add    $0x10,%esp
}
80101ed7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101eda:	5b                   	pop    %ebx
80101edb:	5f                   	pop    %edi
80101edc:	5d                   	pop    %ebp
80101edd:	c3                   	ret    
    release(&idelock);
80101ede:	83 ec 0c             	sub    $0xc,%esp
80101ee1:	68 80 a5 10 80       	push   $0x8010a580
80101ee6:	e8 31 2b 00 00       	call   80104a1c <release>
    return;
80101eeb:	83 c4 10             	add    $0x10,%esp
80101eee:	eb e7                	jmp    80101ed7 <ideintr+0x60>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ef0:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ef5:	ec                   	in     (%dx),%al
80101ef6:	89 c1                	mov    %eax,%ecx
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ef8:	83 e0 c0             	and    $0xffffffc0,%eax
80101efb:	3c 40                	cmp    $0x40,%al
80101efd:	75 f6                	jne    80101ef5 <ideintr+0x7e>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101eff:	f6 c1 21             	test   $0x21,%cl
80101f02:	75 9f                	jne    80101ea3 <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101f04:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101f07:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f0c:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101f11:	fc                   	cld    
80101f12:	f3 6d                	rep insl (%dx),%es:(%edi)
80101f14:	eb 8d                	jmp    80101ea3 <ideintr+0x2c>

80101f16 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101f16:	55                   	push   %ebp
80101f17:	89 e5                	mov    %esp,%ebp
80101f19:	53                   	push   %ebx
80101f1a:	83 ec 10             	sub    $0x10,%esp
80101f1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101f20:	8d 43 0c             	lea    0xc(%ebx),%eax
80101f23:	50                   	push   %eax
80101f24:	e8 1d 29 00 00       	call   80104846 <holdingsleep>
80101f29:	83 c4 10             	add    $0x10,%esp
80101f2c:	85 c0                	test   %eax,%eax
80101f2e:	74 41                	je     80101f71 <iderw+0x5b>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101f30:	8b 03                	mov    (%ebx),%eax
80101f32:	83 e0 06             	and    $0x6,%eax
80101f35:	83 f8 02             	cmp    $0x2,%eax
80101f38:	74 44                	je     80101f7e <iderw+0x68>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101f3a:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101f3e:	74 09                	je     80101f49 <iderw+0x33>
80101f40:	83 3d 60 a5 10 80 00 	cmpl   $0x0,0x8010a560
80101f47:	74 42                	je     80101f8b <iderw+0x75>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101f49:	83 ec 0c             	sub    $0xc,%esp
80101f4c:	68 80 a5 10 80       	push   $0x8010a580
80101f51:	e8 5f 2a 00 00       	call   801049b5 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101f56:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f5d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80101f63:	83 c4 10             	add    $0x10,%esp
80101f66:	85 d2                	test   %edx,%edx
80101f68:	75 30                	jne    80101f9a <iderw+0x84>
80101f6a:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101f6f:	eb 33                	jmp    80101fa4 <iderw+0x8e>
    panic("iderw: buf not locked");
80101f71:	83 ec 0c             	sub    $0xc,%esp
80101f74:	68 de 74 10 80       	push   $0x801074de
80101f79:	e8 c6 e3 ff ff       	call   80100344 <panic>
    panic("iderw: nothing to do");
80101f7e:	83 ec 0c             	sub    $0xc,%esp
80101f81:	68 f4 74 10 80       	push   $0x801074f4
80101f86:	e8 b9 e3 ff ff       	call   80100344 <panic>
    panic("iderw: ide disk 1 not present");
80101f8b:	83 ec 0c             	sub    $0xc,%esp
80101f8e:	68 09 75 10 80       	push   $0x80107509
80101f93:	e8 ac e3 ff ff       	call   80100344 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f98:	89 c2                	mov    %eax,%edx
80101f9a:	8b 42 58             	mov    0x58(%edx),%eax
80101f9d:	85 c0                	test   %eax,%eax
80101f9f:	75 f7                	jne    80101f98 <iderw+0x82>
80101fa1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80101fa4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101fa6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101fac:	74 3a                	je     80101fe8 <iderw+0xd2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101fae:	8b 03                	mov    (%ebx),%eax
80101fb0:	83 e0 06             	and    $0x6,%eax
80101fb3:	83 f8 02             	cmp    $0x2,%eax
80101fb6:	74 1b                	je     80101fd3 <iderw+0xbd>
    sleep(b, &idelock);
80101fb8:	83 ec 08             	sub    $0x8,%esp
80101fbb:	68 80 a5 10 80       	push   $0x8010a580
80101fc0:	53                   	push   %ebx
80101fc1:	e8 91 1d 00 00       	call   80103d57 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101fc6:	8b 03                	mov    (%ebx),%eax
80101fc8:	83 e0 06             	and    $0x6,%eax
80101fcb:	83 c4 10             	add    $0x10,%esp
80101fce:	83 f8 02             	cmp    $0x2,%eax
80101fd1:	75 e5                	jne    80101fb8 <iderw+0xa2>
  }


  release(&idelock);
80101fd3:	83 ec 0c             	sub    $0xc,%esp
80101fd6:	68 80 a5 10 80       	push   $0x8010a580
80101fdb:	e8 3c 2a 00 00       	call   80104a1c <release>
}
80101fe0:	83 c4 10             	add    $0x10,%esp
80101fe3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fe6:	c9                   	leave  
80101fe7:	c3                   	ret    
    idestart(b);
80101fe8:	89 d8                	mov    %ebx,%eax
80101fea:	e8 4b fd ff ff       	call   80101d3a <idestart>
80101fef:	eb bd                	jmp    80101fae <iderw+0x98>

80101ff1 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80101ff1:	55                   	push   %ebp
80101ff2:	89 e5                	mov    %esp,%ebp
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101ff6:	c7 05 d4 4b 11 80 00 	movl   $0xfec00000,0x80114bd4
80101ffd:	00 c0 fe 
  ioapic->reg = reg;
80102000:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102007:	00 00 00 
  return ioapic->data;
8010200a:	a1 d4 4b 11 80       	mov    0x80114bd4,%eax
8010200f:	8b 58 10             	mov    0x10(%eax),%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102012:	c1 eb 10             	shr    $0x10,%ebx
80102015:	0f b6 db             	movzbl %bl,%ebx
  ioapic->reg = reg;
80102018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
8010201e:	a1 d4 4b 11 80       	mov    0x80114bd4,%eax
80102023:	8b 40 10             	mov    0x10(%eax),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102026:	0f b6 15 00 4d 11 80 	movzbl 0x80114d00,%edx
  id = ioapicread(REG_ID) >> 24;
8010202d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102030:	39 c2                	cmp    %eax,%edx
80102032:	75 47                	jne    8010207b <ioapicinit+0x8a>
{
80102034:	ba 10 00 00 00       	mov    $0x10,%edx
80102039:	b8 00 00 00 00       	mov    $0x0,%eax
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010203e:	8d 48 20             	lea    0x20(%eax),%ecx
80102041:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->reg = reg;
80102047:	8b 35 d4 4b 11 80    	mov    0x80114bd4,%esi
8010204d:	89 16                	mov    %edx,(%esi)
  ioapic->data = data;
8010204f:	8b 35 d4 4b 11 80    	mov    0x80114bd4,%esi
80102055:	89 4e 10             	mov    %ecx,0x10(%esi)
80102058:	8d 4a 01             	lea    0x1(%edx),%ecx
  ioapic->reg = reg;
8010205b:	89 0e                	mov    %ecx,(%esi)
  ioapic->data = data;
8010205d:	8b 0d d4 4b 11 80    	mov    0x80114bd4,%ecx
80102063:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010206a:	83 c0 01             	add    $0x1,%eax
8010206d:	83 c2 02             	add    $0x2,%edx
80102070:	39 c3                	cmp    %eax,%ebx
80102072:	7d ca                	jge    8010203e <ioapicinit+0x4d>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102074:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102077:	5b                   	pop    %ebx
80102078:	5e                   	pop    %esi
80102079:	5d                   	pop    %ebp
8010207a:	c3                   	ret    
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010207b:	83 ec 0c             	sub    $0xc,%esp
8010207e:	68 28 75 10 80       	push   $0x80107528
80102083:	e8 59 e5 ff ff       	call   801005e1 <cprintf>
80102088:	83 c4 10             	add    $0x10,%esp
8010208b:	eb a7                	jmp    80102034 <ioapicinit+0x43>

8010208d <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010208d:	55                   	push   %ebp
8010208e:	89 e5                	mov    %esp,%ebp
80102090:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102093:	8d 50 20             	lea    0x20(%eax),%edx
80102096:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
8010209a:	8b 0d d4 4b 11 80    	mov    0x80114bd4,%ecx
801020a0:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801020a2:	8b 0d d4 4b 11 80    	mov    0x80114bd4,%ecx
801020a8:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801020ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801020ae:	c1 e2 18             	shl    $0x18,%edx
801020b1:	83 c0 01             	add    $0x1,%eax
  ioapic->reg = reg;
801020b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801020b6:	a1 d4 4b 11 80       	mov    0x80114bd4,%eax
801020bb:	89 50 10             	mov    %edx,0x10(%eax)
}
801020be:	5d                   	pop    %ebp
801020bf:	c3                   	ret    

801020c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	53                   	push   %ebx
801020c4:	83 ec 04             	sub    $0x4,%esp
801020c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801020ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801020d0:	75 4c                	jne    8010211e <kfree+0x5e>
801020d2:	81 fb c8 5a 11 80    	cmp    $0x80115ac8,%ebx
801020d8:	72 44                	jb     8010211e <kfree+0x5e>
801020da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801020e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801020e5:	77 37                	ja     8010211e <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801020e7:	83 ec 04             	sub    $0x4,%esp
801020ea:	68 00 10 00 00       	push   $0x1000
801020ef:	6a 01                	push   $0x1
801020f1:	53                   	push   %ebx
801020f2:	e8 6c 29 00 00       	call   80104a63 <memset>

  if(kmem.use_lock)
801020f7:	83 c4 10             	add    $0x10,%esp
801020fa:	83 3d 14 4c 11 80 00 	cmpl   $0x0,0x80114c14
80102101:	75 28                	jne    8010212b <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102103:	a1 18 4c 11 80       	mov    0x80114c18,%eax
80102108:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
8010210a:	89 1d 18 4c 11 80    	mov    %ebx,0x80114c18
  if(kmem.use_lock)
80102110:	83 3d 14 4c 11 80 00 	cmpl   $0x0,0x80114c14
80102117:	75 24                	jne    8010213d <kfree+0x7d>
    release(&kmem.lock);
}
80102119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010211c:	c9                   	leave  
8010211d:	c3                   	ret    
    panic("kfree");
8010211e:	83 ec 0c             	sub    $0xc,%esp
80102121:	68 5a 75 10 80       	push   $0x8010755a
80102126:	e8 19 e2 ff ff       	call   80100344 <panic>
    acquire(&kmem.lock);
8010212b:	83 ec 0c             	sub    $0xc,%esp
8010212e:	68 e0 4b 11 80       	push   $0x80114be0
80102133:	e8 7d 28 00 00       	call   801049b5 <acquire>
80102138:	83 c4 10             	add    $0x10,%esp
8010213b:	eb c6                	jmp    80102103 <kfree+0x43>
    release(&kmem.lock);
8010213d:	83 ec 0c             	sub    $0xc,%esp
80102140:	68 e0 4b 11 80       	push   $0x80114be0
80102145:	e8 d2 28 00 00       	call   80104a1c <release>
8010214a:	83 c4 10             	add    $0x10,%esp
}
8010214d:	eb ca                	jmp    80102119 <kfree+0x59>

8010214f <freerange>:
{
8010214f:	55                   	push   %ebp
80102150:	89 e5                	mov    %esp,%ebp
80102152:	56                   	push   %esi
80102153:	53                   	push   %ebx
80102154:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102157:	8b 45 08             	mov    0x8(%ebp),%eax
8010215a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102160:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102166:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010216c:	39 de                	cmp    %ebx,%esi
8010216e:	72 1c                	jb     8010218c <freerange+0x3d>
    kfree(p);
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102179:	50                   	push   %eax
8010217a:	e8 41 ff ff ff       	call   801020c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010217f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102185:	83 c4 10             	add    $0x10,%esp
80102188:	39 f3                	cmp    %esi,%ebx
8010218a:	76 e4                	jbe    80102170 <freerange+0x21>
}
8010218c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010218f:	5b                   	pop    %ebx
80102190:	5e                   	pop    %esi
80102191:	5d                   	pop    %ebp
80102192:	c3                   	ret    

80102193 <kinit1>:
{
80102193:	55                   	push   %ebp
80102194:	89 e5                	mov    %esp,%ebp
80102196:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80102199:	68 60 75 10 80       	push   $0x80107560
8010219e:	68 e0 4b 11 80       	push   $0x80114be0
801021a3:	e8 c5 26 00 00       	call   8010486d <initlock>
  kmem.use_lock = 0;
801021a8:	c7 05 14 4c 11 80 00 	movl   $0x0,0x80114c14
801021af:	00 00 00 
  freerange(vstart, vend);
801021b2:	83 c4 08             	add    $0x8,%esp
801021b5:	ff 75 0c             	pushl  0xc(%ebp)
801021b8:	ff 75 08             	pushl  0x8(%ebp)
801021bb:	e8 8f ff ff ff       	call   8010214f <freerange>
}
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	c9                   	leave  
801021c4:	c3                   	ret    

801021c5 <kinit2>:
{
801021c5:	55                   	push   %ebp
801021c6:	89 e5                	mov    %esp,%ebp
801021c8:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
801021cb:	ff 75 0c             	pushl  0xc(%ebp)
801021ce:	ff 75 08             	pushl  0x8(%ebp)
801021d1:	e8 79 ff ff ff       	call   8010214f <freerange>
  kmem.use_lock = 1;
801021d6:	c7 05 14 4c 11 80 01 	movl   $0x1,0x80114c14
801021dd:	00 00 00 
}
801021e0:	83 c4 10             	add    $0x10,%esp
801021e3:	c9                   	leave  
801021e4:	c3                   	ret    

801021e5 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801021e5:	55                   	push   %ebp
801021e6:	89 e5                	mov    %esp,%ebp
801021e8:	53                   	push   %ebx
801021e9:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801021ec:	83 3d 14 4c 11 80 00 	cmpl   $0x0,0x80114c14
801021f3:	75 21                	jne    80102216 <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
801021f5:	8b 1d 18 4c 11 80    	mov    0x80114c18,%ebx
  if(r)
801021fb:	85 db                	test   %ebx,%ebx
801021fd:	74 10                	je     8010220f <kalloc+0x2a>
    kmem.freelist = r->next;
801021ff:	8b 03                	mov    (%ebx),%eax
80102201:	a3 18 4c 11 80       	mov    %eax,0x80114c18
  if(kmem.use_lock)
80102206:	83 3d 14 4c 11 80 00 	cmpl   $0x0,0x80114c14
8010220d:	75 23                	jne    80102232 <kalloc+0x4d>
    release(&kmem.lock);
  return (char*)r;
}
8010220f:	89 d8                	mov    %ebx,%eax
80102211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102214:	c9                   	leave  
80102215:	c3                   	ret    
    acquire(&kmem.lock);
80102216:	83 ec 0c             	sub    $0xc,%esp
80102219:	68 e0 4b 11 80       	push   $0x80114be0
8010221e:	e8 92 27 00 00       	call   801049b5 <acquire>
  r = kmem.freelist;
80102223:	8b 1d 18 4c 11 80    	mov    0x80114c18,%ebx
  if(r)
80102229:	83 c4 10             	add    $0x10,%esp
8010222c:	85 db                	test   %ebx,%ebx
8010222e:	75 cf                	jne    801021ff <kalloc+0x1a>
80102230:	eb d4                	jmp    80102206 <kalloc+0x21>
    release(&kmem.lock);
80102232:	83 ec 0c             	sub    $0xc,%esp
80102235:	68 e0 4b 11 80       	push   $0x80114be0
8010223a:	e8 dd 27 00 00       	call   80104a1c <release>
8010223f:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102242:	eb cb                	jmp    8010220f <kalloc+0x2a>

80102244 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102244:	ba 64 00 00 00       	mov    $0x64,%edx
80102249:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010224a:	a8 01                	test   $0x1,%al
8010224c:	0f 84 bb 00 00 00    	je     8010230d <kbdgetc+0xc9>
80102252:	ba 60 00 00 00       	mov    $0x60,%edx
80102257:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102258:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010225b:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102261:	74 5b                	je     801022be <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102263:	84 c0                	test   %al,%al
80102265:	78 64                	js     801022cb <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102267:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
8010226d:	f6 c1 40             	test   $0x40,%cl
80102270:	74 0f                	je     80102281 <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102272:	83 c8 80             	or     $0xffffff80,%eax
80102275:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
80102278:	83 e1 bf             	and    $0xffffffbf,%ecx
8010227b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  }

  shift |= shiftcode[data];
80102281:	0f b6 8a a0 76 10 80 	movzbl -0x7fef8960(%edx),%ecx
80102288:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
  shift ^= togglecode[data];
8010228e:	0f b6 82 a0 75 10 80 	movzbl -0x7fef8a60(%edx),%eax
80102295:	31 c1                	xor    %eax,%ecx
80102297:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010229d:	89 c8                	mov    %ecx,%eax
8010229f:	83 e0 03             	and    $0x3,%eax
801022a2:	8b 04 85 80 75 10 80 	mov    -0x7fef8a80(,%eax,4),%eax
801022a9:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801022ad:	f6 c1 08             	test   $0x8,%cl
801022b0:	74 61                	je     80102313 <kbdgetc+0xcf>
    if('a' <= c && c <= 'z')
801022b2:	8d 50 9f             	lea    -0x61(%eax),%edx
801022b5:	83 fa 19             	cmp    $0x19,%edx
801022b8:	77 46                	ja     80102300 <kbdgetc+0xbc>
      c += 'A' - 'a';
801022ba:	83 e8 20             	sub    $0x20,%eax
801022bd:	c3                   	ret    
    shift |= E0ESC;
801022be:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801022c5:	b8 00 00 00 00       	mov    $0x0,%eax
801022ca:	c3                   	ret    
{
801022cb:	55                   	push   %ebp
801022cc:	89 e5                	mov    %esp,%ebp
801022ce:	53                   	push   %ebx
    data = (shift & E0ESC ? data : data & 0x7F);
801022cf:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
801022d5:	89 cb                	mov    %ecx,%ebx
801022d7:	83 e3 40             	and    $0x40,%ebx
801022da:	83 e0 7f             	and    $0x7f,%eax
801022dd:	85 db                	test   %ebx,%ebx
801022df:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801022e2:	0f b6 82 a0 76 10 80 	movzbl -0x7fef8960(%edx),%eax
801022e9:	83 c8 40             	or     $0x40,%eax
801022ec:	0f b6 c0             	movzbl %al,%eax
801022ef:	f7 d0                	not    %eax
801022f1:	21 c8                	and    %ecx,%eax
801022f3:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
801022f8:	b8 00 00 00 00       	mov    $0x0,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801022fd:	5b                   	pop    %ebx
801022fe:	5d                   	pop    %ebp
801022ff:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
80102300:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102303:	8d 50 20             	lea    0x20(%eax),%edx
80102306:	83 f9 1a             	cmp    $0x1a,%ecx
80102309:	0f 42 c2             	cmovb  %edx,%eax
  return c;
8010230c:	c3                   	ret    
    return -1;
8010230d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102312:	c3                   	ret    
}
80102313:	f3 c3                	repz ret 

80102315 <kbdintr>:

void
kbdintr(void)
{
80102315:	55                   	push   %ebp
80102316:	89 e5                	mov    %esp,%ebp
80102318:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010231b:	68 44 22 10 80       	push   $0x80102244
80102320:	e8 16 e4 ff ff       	call   8010073b <consoleintr>
}
80102325:	83 c4 10             	add    $0x10,%esp
80102328:	c9                   	leave  
80102329:	c3                   	ret    

8010232a <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
8010232a:	55                   	push   %ebp
8010232b:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
8010232d:	8b 0d 1c 4c 11 80    	mov    0x80114c1c,%ecx
80102333:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80102336:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102338:	a1 1c 4c 11 80       	mov    0x80114c1c,%eax
8010233d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102340:	5d                   	pop    %ebp
80102341:	c3                   	ret    

80102342 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102342:	55                   	push   %ebp
80102343:	89 e5                	mov    %esp,%ebp
80102345:	56                   	push   %esi
80102346:	53                   	push   %ebx
80102347:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102349:	be 70 00 00 00       	mov    $0x70,%esi
8010234e:	b8 00 00 00 00       	mov    $0x0,%eax
80102353:	89 f2                	mov    %esi,%edx
80102355:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102356:	b9 71 00 00 00       	mov    $0x71,%ecx
8010235b:	89 ca                	mov    %ecx,%edx
8010235d:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
8010235e:	0f b6 c0             	movzbl %al,%eax
80102361:	89 03                	mov    %eax,(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102363:	b8 02 00 00 00       	mov    $0x2,%eax
80102368:	89 f2                	mov    %esi,%edx
8010236a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010236b:	89 ca                	mov    %ecx,%edx
8010236d:	ec                   	in     (%dx),%al
8010236e:	0f b6 c0             	movzbl %al,%eax
80102371:	89 43 04             	mov    %eax,0x4(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102374:	b8 04 00 00 00       	mov    $0x4,%eax
80102379:	89 f2                	mov    %esi,%edx
8010237b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010237c:	89 ca                	mov    %ecx,%edx
8010237e:	ec                   	in     (%dx),%al
8010237f:	0f b6 c0             	movzbl %al,%eax
80102382:	89 43 08             	mov    %eax,0x8(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102385:	b8 07 00 00 00       	mov    $0x7,%eax
8010238a:	89 f2                	mov    %esi,%edx
8010238c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010238d:	89 ca                	mov    %ecx,%edx
8010238f:	ec                   	in     (%dx),%al
80102390:	0f b6 c0             	movzbl %al,%eax
80102393:	89 43 0c             	mov    %eax,0xc(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102396:	b8 08 00 00 00       	mov    $0x8,%eax
8010239b:	89 f2                	mov    %esi,%edx
8010239d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010239e:	89 ca                	mov    %ecx,%edx
801023a0:	ec                   	in     (%dx),%al
801023a1:	0f b6 c0             	movzbl %al,%eax
801023a4:	89 43 10             	mov    %eax,0x10(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023a7:	b8 09 00 00 00       	mov    $0x9,%eax
801023ac:	89 f2                	mov    %esi,%edx
801023ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023af:	89 ca                	mov    %ecx,%edx
801023b1:	ec                   	in     (%dx),%al
801023b2:	0f b6 c0             	movzbl %al,%eax
801023b5:	89 43 14             	mov    %eax,0x14(%ebx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
801023b8:	5b                   	pop    %ebx
801023b9:	5e                   	pop    %esi
801023ba:	5d                   	pop    %ebp
801023bb:	c3                   	ret    

801023bc <lapicinit>:
  if(!lapic)
801023bc:	83 3d 1c 4c 11 80 00 	cmpl   $0x0,0x80114c1c
801023c3:	0f 84 fc 00 00 00    	je     801024c5 <lapicinit+0x109>
{
801023c9:	55                   	push   %ebp
801023ca:	89 e5                	mov    %esp,%ebp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801023cc:	ba 3f 01 00 00       	mov    $0x13f,%edx
801023d1:	b8 3c 00 00 00       	mov    $0x3c,%eax
801023d6:	e8 4f ff ff ff       	call   8010232a <lapicw>
  lapicw(TDCR, X1);
801023db:	ba 0b 00 00 00       	mov    $0xb,%edx
801023e0:	b8 f8 00 00 00       	mov    $0xf8,%eax
801023e5:	e8 40 ff ff ff       	call   8010232a <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801023ea:	ba 20 00 02 00       	mov    $0x20020,%edx
801023ef:	b8 c8 00 00 00       	mov    $0xc8,%eax
801023f4:	e8 31 ff ff ff       	call   8010232a <lapicw>
  lapicw(TICR, 1000000);
801023f9:	ba 40 42 0f 00       	mov    $0xf4240,%edx
801023fe:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102403:	e8 22 ff ff ff       	call   8010232a <lapicw>
  lapicw(LINT0, MASKED);
80102408:	ba 00 00 01 00       	mov    $0x10000,%edx
8010240d:	b8 d4 00 00 00       	mov    $0xd4,%eax
80102412:	e8 13 ff ff ff       	call   8010232a <lapicw>
  lapicw(LINT1, MASKED);
80102417:	ba 00 00 01 00       	mov    $0x10000,%edx
8010241c:	b8 d8 00 00 00       	mov    $0xd8,%eax
80102421:	e8 04 ff ff ff       	call   8010232a <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102426:	a1 1c 4c 11 80       	mov    0x80114c1c,%eax
8010242b:	8b 40 30             	mov    0x30(%eax),%eax
8010242e:	c1 e8 10             	shr    $0x10,%eax
80102431:	3c 03                	cmp    $0x3,%al
80102433:	77 7c                	ja     801024b1 <lapicinit+0xf5>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102435:	ba 33 00 00 00       	mov    $0x33,%edx
8010243a:	b8 dc 00 00 00       	mov    $0xdc,%eax
8010243f:	e8 e6 fe ff ff       	call   8010232a <lapicw>
  lapicw(ESR, 0);
80102444:	ba 00 00 00 00       	mov    $0x0,%edx
80102449:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010244e:	e8 d7 fe ff ff       	call   8010232a <lapicw>
  lapicw(ESR, 0);
80102453:	ba 00 00 00 00       	mov    $0x0,%edx
80102458:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010245d:	e8 c8 fe ff ff       	call   8010232a <lapicw>
  lapicw(EOI, 0);
80102462:	ba 00 00 00 00       	mov    $0x0,%edx
80102467:	b8 2c 00 00 00       	mov    $0x2c,%eax
8010246c:	e8 b9 fe ff ff       	call   8010232a <lapicw>
  lapicw(ICRHI, 0);
80102471:	ba 00 00 00 00       	mov    $0x0,%edx
80102476:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010247b:	e8 aa fe ff ff       	call   8010232a <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102480:	ba 00 85 08 00       	mov    $0x88500,%edx
80102485:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010248a:	e8 9b fe ff ff       	call   8010232a <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010248f:	8b 15 1c 4c 11 80    	mov    0x80114c1c,%edx
80102495:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
8010249b:	f6 c4 10             	test   $0x10,%ah
8010249e:	75 f5                	jne    80102495 <lapicinit+0xd9>
  lapicw(TPR, 0);
801024a0:	ba 00 00 00 00       	mov    $0x0,%edx
801024a5:	b8 20 00 00 00       	mov    $0x20,%eax
801024aa:	e8 7b fe ff ff       	call   8010232a <lapicw>
}
801024af:	5d                   	pop    %ebp
801024b0:	c3                   	ret    
    lapicw(PCINT, MASKED);
801024b1:	ba 00 00 01 00       	mov    $0x10000,%edx
801024b6:	b8 d0 00 00 00       	mov    $0xd0,%eax
801024bb:	e8 6a fe ff ff       	call   8010232a <lapicw>
801024c0:	e9 70 ff ff ff       	jmp    80102435 <lapicinit+0x79>
801024c5:	f3 c3                	repz ret 

801024c7 <lapicid>:
{
801024c7:	55                   	push   %ebp
801024c8:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801024ca:	8b 15 1c 4c 11 80    	mov    0x80114c1c,%edx
    return 0;
801024d0:	b8 00 00 00 00       	mov    $0x0,%eax
  if (!lapic)
801024d5:	85 d2                	test   %edx,%edx
801024d7:	74 06                	je     801024df <lapicid+0x18>
  return lapic[ID] >> 24;
801024d9:	8b 42 20             	mov    0x20(%edx),%eax
801024dc:	c1 e8 18             	shr    $0x18,%eax
}
801024df:	5d                   	pop    %ebp
801024e0:	c3                   	ret    

801024e1 <lapiceoi>:
  if(lapic)
801024e1:	83 3d 1c 4c 11 80 00 	cmpl   $0x0,0x80114c1c
801024e8:	74 14                	je     801024fe <lapiceoi+0x1d>
{
801024ea:	55                   	push   %ebp
801024eb:	89 e5                	mov    %esp,%ebp
    lapicw(EOI, 0);
801024ed:	ba 00 00 00 00       	mov    $0x0,%edx
801024f2:	b8 2c 00 00 00       	mov    $0x2c,%eax
801024f7:	e8 2e fe ff ff       	call   8010232a <lapicw>
}
801024fc:	5d                   	pop    %ebp
801024fd:	c3                   	ret    
801024fe:	f3 c3                	repz ret 

80102500 <microdelay>:
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
}
80102503:	5d                   	pop    %ebp
80102504:	c3                   	ret    

80102505 <lapicstartap>:
{
80102505:	55                   	push   %ebp
80102506:	89 e5                	mov    %esp,%ebp
80102508:	56                   	push   %esi
80102509:	53                   	push   %ebx
8010250a:	8b 75 08             	mov    0x8(%ebp),%esi
8010250d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102510:	b8 0f 00 00 00       	mov    $0xf,%eax
80102515:	ba 70 00 00 00       	mov    $0x70,%edx
8010251a:	ee                   	out    %al,(%dx)
8010251b:	b8 0a 00 00 00       	mov    $0xa,%eax
80102520:	ba 71 00 00 00       	mov    $0x71,%edx
80102525:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102526:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
8010252d:	00 00 
  wrv[1] = addr >> 4;
8010252f:	89 d8                	mov    %ebx,%eax
80102531:	c1 e8 04             	shr    $0x4,%eax
80102534:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
8010253a:	c1 e6 18             	shl    $0x18,%esi
8010253d:	89 f2                	mov    %esi,%edx
8010253f:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102544:	e8 e1 fd ff ff       	call   8010232a <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102549:	ba 00 c5 00 00       	mov    $0xc500,%edx
8010254e:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102553:	e8 d2 fd ff ff       	call   8010232a <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
80102558:	ba 00 85 00 00       	mov    $0x8500,%edx
8010255d:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102562:	e8 c3 fd ff ff       	call   8010232a <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102567:	c1 eb 0c             	shr    $0xc,%ebx
8010256a:	80 cf 06             	or     $0x6,%bh
    lapicw(ICRHI, apicid<<24);
8010256d:	89 f2                	mov    %esi,%edx
8010256f:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102574:	e8 b1 fd ff ff       	call   8010232a <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102579:	89 da                	mov    %ebx,%edx
8010257b:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102580:	e8 a5 fd ff ff       	call   8010232a <lapicw>
    lapicw(ICRHI, apicid<<24);
80102585:	89 f2                	mov    %esi,%edx
80102587:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010258c:	e8 99 fd ff ff       	call   8010232a <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102591:	89 da                	mov    %ebx,%edx
80102593:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102598:	e8 8d fd ff ff       	call   8010232a <lapicw>
}
8010259d:	5b                   	pop    %ebx
8010259e:	5e                   	pop    %esi
8010259f:	5d                   	pop    %ebp
801025a0:	c3                   	ret    

801025a1 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801025a1:	55                   	push   %ebp
801025a2:	89 e5                	mov    %esp,%ebp
801025a4:	57                   	push   %edi
801025a5:	56                   	push   %esi
801025a6:	53                   	push   %ebx
801025a7:	83 ec 4c             	sub    $0x4c,%esp
801025aa:	8b 7d 08             	mov    0x8(%ebp),%edi
801025ad:	b8 0b 00 00 00       	mov    $0xb,%eax
801025b2:	ba 70 00 00 00       	mov    $0x70,%edx
801025b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025b8:	ba 71 00 00 00       	mov    $0x71,%edx
801025bd:	ec                   	in     (%dx),%al
801025be:	83 e0 04             	and    $0x4,%eax
801025c1:	88 45 b7             	mov    %al,-0x49(%ebp)

  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801025c4:	8d 75 d0             	lea    -0x30(%ebp),%esi
801025c7:	89 f0                	mov    %esi,%eax
801025c9:	e8 74 fd ff ff       	call   80102342 <fill_rtcdate>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025ce:	ba 70 00 00 00       	mov    $0x70,%edx
801025d3:	b8 0a 00 00 00       	mov    $0xa,%eax
801025d8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025d9:	ba 71 00 00 00       	mov    $0x71,%edx
801025de:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801025df:	84 c0                	test   %al,%al
801025e1:	78 e4                	js     801025c7 <cmostime+0x26>
        continue;
    fill_rtcdate(&t2);
801025e3:	8d 5d b8             	lea    -0x48(%ebp),%ebx
801025e6:	89 d8                	mov    %ebx,%eax
801025e8:	e8 55 fd ff ff       	call   80102342 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801025ed:	83 ec 04             	sub    $0x4,%esp
801025f0:	6a 18                	push   $0x18
801025f2:	53                   	push   %ebx
801025f3:	56                   	push   %esi
801025f4:	e8 ae 24 00 00       	call   80104aa7 <memcmp>
801025f9:	83 c4 10             	add    $0x10,%esp
801025fc:	85 c0                	test   %eax,%eax
801025fe:	75 c7                	jne    801025c7 <cmostime+0x26>
      break;
  }

  // convert
  if(bcd) {
80102600:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102604:	75 78                	jne    8010267e <cmostime+0xdd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102606:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102609:	89 c2                	mov    %eax,%edx
8010260b:	c1 ea 04             	shr    $0x4,%edx
8010260e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102611:	83 e0 0f             	and    $0xf,%eax
80102614:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102617:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
8010261a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010261d:	89 c2                	mov    %eax,%edx
8010261f:	c1 ea 04             	shr    $0x4,%edx
80102622:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102625:	83 e0 0f             	and    $0xf,%eax
80102628:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010262b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
8010262e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102631:	89 c2                	mov    %eax,%edx
80102633:	c1 ea 04             	shr    $0x4,%edx
80102636:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102639:	83 e0 0f             	and    $0xf,%eax
8010263c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010263f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102642:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102645:	89 c2                	mov    %eax,%edx
80102647:	c1 ea 04             	shr    $0x4,%edx
8010264a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010264d:	83 e0 0f             	and    $0xf,%eax
80102650:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102653:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
80102656:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102659:	89 c2                	mov    %eax,%edx
8010265b:	c1 ea 04             	shr    $0x4,%edx
8010265e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102661:	83 e0 0f             	and    $0xf,%eax
80102664:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102667:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
8010266a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010266d:	89 c2                	mov    %eax,%edx
8010266f:	c1 ea 04             	shr    $0x4,%edx
80102672:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102675:	83 e0 0f             	and    $0xf,%eax
80102678:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010267b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
8010267e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102681:	89 07                	mov    %eax,(%edi)
80102683:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102686:	89 47 04             	mov    %eax,0x4(%edi)
80102689:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010268c:	89 47 08             	mov    %eax,0x8(%edi)
8010268f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102692:	89 47 0c             	mov    %eax,0xc(%edi)
80102695:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102698:	89 47 10             	mov    %eax,0x10(%edi)
8010269b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010269e:	89 47 14             	mov    %eax,0x14(%edi)
  r->year += 2000;
801026a1:	81 47 14 d0 07 00 00 	addl   $0x7d0,0x14(%edi)
}
801026a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026ab:	5b                   	pop    %ebx
801026ac:	5e                   	pop    %esi
801026ad:	5f                   	pop    %edi
801026ae:	5d                   	pop    %ebp
801026af:	c3                   	ret    

801026b0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801026b0:	83 3d 68 4c 11 80 00 	cmpl   $0x0,0x80114c68
801026b7:	0f 8e 84 00 00 00    	jle    80102741 <install_trans+0x91>
{
801026bd:	55                   	push   %ebp
801026be:	89 e5                	mov    %esp,%ebp
801026c0:	57                   	push   %edi
801026c1:	56                   	push   %esi
801026c2:	53                   	push   %ebx
801026c3:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801026c6:	bb 00 00 00 00       	mov    $0x0,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801026cb:	be 20 4c 11 80       	mov    $0x80114c20,%esi
801026d0:	83 ec 08             	sub    $0x8,%esp
801026d3:	89 d8                	mov    %ebx,%eax
801026d5:	03 46 34             	add    0x34(%esi),%eax
801026d8:	83 c0 01             	add    $0x1,%eax
801026db:	50                   	push   %eax
801026dc:	ff 76 44             	pushl  0x44(%esi)
801026df:	e8 c6 d9 ff ff       	call   801000aa <bread>
801026e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801026e7:	83 c4 08             	add    $0x8,%esp
801026ea:	ff 34 9d 6c 4c 11 80 	pushl  -0x7feeb394(,%ebx,4)
801026f1:	ff 76 44             	pushl  0x44(%esi)
801026f4:	e8 b1 d9 ff ff       	call   801000aa <bread>
801026f9:	89 c7                	mov    %eax,%edi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801026fb:	83 c4 0c             	add    $0xc,%esp
801026fe:	68 00 02 00 00       	push   $0x200
80102703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102706:	83 c0 5c             	add    $0x5c,%eax
80102709:	50                   	push   %eax
8010270a:	8d 47 5c             	lea    0x5c(%edi),%eax
8010270d:	50                   	push   %eax
8010270e:	e8 e5 23 00 00       	call   80104af8 <memmove>
    bwrite(dbuf);  // write dst to disk
80102713:	89 3c 24             	mov    %edi,(%esp)
80102716:	e8 6b da ff ff       	call   80100186 <bwrite>
    brelse(lbuf);
8010271b:	83 c4 04             	add    $0x4,%esp
8010271e:	ff 75 e4             	pushl  -0x1c(%ebp)
80102721:	e8 9b da ff ff       	call   801001c1 <brelse>
    brelse(dbuf);
80102726:	89 3c 24             	mov    %edi,(%esp)
80102729:	e8 93 da ff ff       	call   801001c1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010272e:	83 c3 01             	add    $0x1,%ebx
80102731:	83 c4 10             	add    $0x10,%esp
80102734:	39 5e 48             	cmp    %ebx,0x48(%esi)
80102737:	7f 97                	jg     801026d0 <install_trans+0x20>
  }
}
80102739:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010273c:	5b                   	pop    %ebx
8010273d:	5e                   	pop    %esi
8010273e:	5f                   	pop    %edi
8010273f:	5d                   	pop    %ebp
80102740:	c3                   	ret    
80102741:	f3 c3                	repz ret 

80102743 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102743:	55                   	push   %ebp
80102744:	89 e5                	mov    %esp,%ebp
80102746:	53                   	push   %ebx
80102747:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010274a:	ff 35 54 4c 11 80    	pushl  0x80114c54
80102750:	ff 35 64 4c 11 80    	pushl  0x80114c64
80102756:	e8 4f d9 ff ff       	call   801000aa <bread>
8010275b:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
8010275d:	8b 0d 68 4c 11 80    	mov    0x80114c68,%ecx
80102763:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102766:	83 c4 10             	add    $0x10,%esp
80102769:	85 c9                	test   %ecx,%ecx
8010276b:	7e 19                	jle    80102786 <write_head+0x43>
8010276d:	c1 e1 02             	shl    $0x2,%ecx
80102770:	b8 00 00 00 00       	mov    $0x0,%eax
    hb->block[i] = log.lh.block[i];
80102775:	8b 90 6c 4c 11 80    	mov    -0x7feeb394(%eax),%edx
8010277b:	89 54 03 60          	mov    %edx,0x60(%ebx,%eax,1)
8010277f:	83 c0 04             	add    $0x4,%eax
  for (i = 0; i < log.lh.n; i++) {
80102782:	39 c8                	cmp    %ecx,%eax
80102784:	75 ef                	jne    80102775 <write_head+0x32>
  }
  bwrite(buf);
80102786:	83 ec 0c             	sub    $0xc,%esp
80102789:	53                   	push   %ebx
8010278a:	e8 f7 d9 ff ff       	call   80100186 <bwrite>
  brelse(buf);
8010278f:	89 1c 24             	mov    %ebx,(%esp)
80102792:	e8 2a da ff ff       	call   801001c1 <brelse>
}
80102797:	83 c4 10             	add    $0x10,%esp
8010279a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279d:	c9                   	leave  
8010279e:	c3                   	ret    

8010279f <initlog>:
{
8010279f:	55                   	push   %ebp
801027a0:	89 e5                	mov    %esp,%ebp
801027a2:	53                   	push   %ebx
801027a3:	83 ec 2c             	sub    $0x2c,%esp
801027a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801027a9:	68 a0 77 10 80       	push   $0x801077a0
801027ae:	68 20 4c 11 80       	push   $0x80114c20
801027b3:	e8 b5 20 00 00       	call   8010486d <initlock>
  readsb(dev, &sb);
801027b8:	83 c4 08             	add    $0x8,%esp
801027bb:	8d 45 dc             	lea    -0x24(%ebp),%eax
801027be:	50                   	push   %eax
801027bf:	53                   	push   %ebx
801027c0:	e8 12 eb ff ff       	call   801012d7 <readsb>
  log.start = sb.logstart;
801027c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027c8:	a3 54 4c 11 80       	mov    %eax,0x80114c54
  log.size = sb.nlog;
801027cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
801027d0:	89 15 58 4c 11 80    	mov    %edx,0x80114c58
  log.dev = dev;
801027d6:	89 1d 64 4c 11 80    	mov    %ebx,0x80114c64
  struct buf *buf = bread(log.dev, log.start);
801027dc:	83 c4 08             	add    $0x8,%esp
801027df:	50                   	push   %eax
801027e0:	53                   	push   %ebx
801027e1:	e8 c4 d8 ff ff       	call   801000aa <bread>
  log.lh.n = lh->n;
801027e6:	8b 58 5c             	mov    0x5c(%eax),%ebx
801027e9:	89 1d 68 4c 11 80    	mov    %ebx,0x80114c68
  for (i = 0; i < log.lh.n; i++) {
801027ef:	83 c4 10             	add    $0x10,%esp
801027f2:	85 db                	test   %ebx,%ebx
801027f4:	7e 19                	jle    8010280f <initlog+0x70>
801027f6:	c1 e3 02             	shl    $0x2,%ebx
801027f9:	ba 00 00 00 00       	mov    $0x0,%edx
    log.lh.block[i] = lh->block[i];
801027fe:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102802:	89 8a 6c 4c 11 80    	mov    %ecx,-0x7feeb394(%edx)
80102808:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010280b:	39 d3                	cmp    %edx,%ebx
8010280d:	75 ef                	jne    801027fe <initlog+0x5f>
  brelse(buf);
8010280f:	83 ec 0c             	sub    $0xc,%esp
80102812:	50                   	push   %eax
80102813:	e8 a9 d9 ff ff       	call   801001c1 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102818:	e8 93 fe ff ff       	call   801026b0 <install_trans>
  log.lh.n = 0;
8010281d:	c7 05 68 4c 11 80 00 	movl   $0x0,0x80114c68
80102824:	00 00 00 
  write_head(); // clear the log
80102827:	e8 17 ff ff ff       	call   80102743 <write_head>
}
8010282c:	83 c4 10             	add    $0x10,%esp
8010282f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102832:	c9                   	leave  
80102833:	c3                   	ret    

80102834 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102834:	55                   	push   %ebp
80102835:	89 e5                	mov    %esp,%ebp
80102837:	53                   	push   %ebx
80102838:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
8010283b:	68 20 4c 11 80       	push   $0x80114c20
80102840:	e8 70 21 00 00       	call   801049b5 <acquire>
80102845:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80102848:	bb 20 4c 11 80       	mov    $0x80114c20,%ebx
8010284d:	eb 15                	jmp    80102864 <begin_op+0x30>
      sleep(&log, &log.lock);
8010284f:	83 ec 08             	sub    $0x8,%esp
80102852:	68 20 4c 11 80       	push   $0x80114c20
80102857:	68 20 4c 11 80       	push   $0x80114c20
8010285c:	e8 f6 14 00 00       	call   80103d57 <sleep>
80102861:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102864:	83 7b 40 00          	cmpl   $0x0,0x40(%ebx)
80102868:	75 e5                	jne    8010284f <begin_op+0x1b>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010286a:	8b 43 3c             	mov    0x3c(%ebx),%eax
8010286d:	83 c0 01             	add    $0x1,%eax
80102870:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102873:	8b 53 48             	mov    0x48(%ebx),%edx
80102876:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102879:	83 fa 1e             	cmp    $0x1e,%edx
8010287c:	7e 17                	jle    80102895 <begin_op+0x61>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010287e:	83 ec 08             	sub    $0x8,%esp
80102881:	68 20 4c 11 80       	push   $0x80114c20
80102886:	68 20 4c 11 80       	push   $0x80114c20
8010288b:	e8 c7 14 00 00       	call   80103d57 <sleep>
80102890:	83 c4 10             	add    $0x10,%esp
80102893:	eb cf                	jmp    80102864 <begin_op+0x30>
    } else {
      log.outstanding += 1;
80102895:	a3 5c 4c 11 80       	mov    %eax,0x80114c5c
      release(&log.lock);
8010289a:	83 ec 0c             	sub    $0xc,%esp
8010289d:	68 20 4c 11 80       	push   $0x80114c20
801028a2:	e8 75 21 00 00       	call   80104a1c <release>
      break;
    }
  }
}
801028a7:	83 c4 10             	add    $0x10,%esp
801028aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028ad:	c9                   	leave  
801028ae:	c3                   	ret    

801028af <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801028af:	55                   	push   %ebp
801028b0:	89 e5                	mov    %esp,%ebp
801028b2:	57                   	push   %edi
801028b3:	56                   	push   %esi
801028b4:	53                   	push   %ebx
801028b5:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;

  acquire(&log.lock);
801028b8:	68 20 4c 11 80       	push   $0x80114c20
801028bd:	e8 f3 20 00 00       	call   801049b5 <acquire>
  log.outstanding -= 1;
801028c2:	a1 5c 4c 11 80       	mov    0x80114c5c,%eax
801028c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
801028ca:	89 1d 5c 4c 11 80    	mov    %ebx,0x80114c5c
  if(log.committing)
801028d0:	83 c4 10             	add    $0x10,%esp
801028d3:	83 3d 60 4c 11 80 00 	cmpl   $0x0,0x80114c60
801028da:	0f 85 e9 00 00 00    	jne    801029c9 <end_op+0x11a>
    panic("log.committing");
  if(log.outstanding == 0){
801028e0:	85 db                	test   %ebx,%ebx
801028e2:	0f 85 ee 00 00 00    	jne    801029d6 <end_op+0x127>
    do_commit = 1;
    log.committing = 1;
801028e8:	c7 05 60 4c 11 80 01 	movl   $0x1,0x80114c60
801028ef:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801028f2:	83 ec 0c             	sub    $0xc,%esp
801028f5:	68 20 4c 11 80       	push   $0x80114c20
801028fa:	e8 1d 21 00 00       	call   80104a1c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801028ff:	83 c4 10             	add    $0x10,%esp
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102902:	be 20 4c 11 80       	mov    $0x80114c20,%esi
  if (log.lh.n > 0) {
80102907:	83 3d 68 4c 11 80 00 	cmpl   $0x0,0x80114c68
8010290e:	7e 7f                	jle    8010298f <end_op+0xe0>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102910:	83 ec 08             	sub    $0x8,%esp
80102913:	89 d8                	mov    %ebx,%eax
80102915:	03 46 34             	add    0x34(%esi),%eax
80102918:	83 c0 01             	add    $0x1,%eax
8010291b:	50                   	push   %eax
8010291c:	ff 76 44             	pushl  0x44(%esi)
8010291f:	e8 86 d7 ff ff       	call   801000aa <bread>
80102924:	89 c7                	mov    %eax,%edi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102926:	83 c4 08             	add    $0x8,%esp
80102929:	ff 34 9d 6c 4c 11 80 	pushl  -0x7feeb394(,%ebx,4)
80102930:	ff 76 44             	pushl  0x44(%esi)
80102933:	e8 72 d7 ff ff       	call   801000aa <bread>
    memmove(to->data, from->data, BSIZE);
80102938:	83 c4 0c             	add    $0xc,%esp
8010293b:	68 00 02 00 00       	push   $0x200
80102940:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102943:	83 c0 5c             	add    $0x5c,%eax
80102946:	50                   	push   %eax
80102947:	8d 47 5c             	lea    0x5c(%edi),%eax
8010294a:	50                   	push   %eax
8010294b:	e8 a8 21 00 00       	call   80104af8 <memmove>
    bwrite(to);  // write the log
80102950:	89 3c 24             	mov    %edi,(%esp)
80102953:	e8 2e d8 ff ff       	call   80100186 <bwrite>
    brelse(from);
80102958:	83 c4 04             	add    $0x4,%esp
8010295b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010295e:	e8 5e d8 ff ff       	call   801001c1 <brelse>
    brelse(to);
80102963:	89 3c 24             	mov    %edi,(%esp)
80102966:	e8 56 d8 ff ff       	call   801001c1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010296b:	83 c3 01             	add    $0x1,%ebx
8010296e:	83 c4 10             	add    $0x10,%esp
80102971:	3b 5e 48             	cmp    0x48(%esi),%ebx
80102974:	7c 9a                	jl     80102910 <end_op+0x61>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102976:	e8 c8 fd ff ff       	call   80102743 <write_head>
    install_trans(); // Now install writes to home locations
8010297b:	e8 30 fd ff ff       	call   801026b0 <install_trans>
    log.lh.n = 0;
80102980:	c7 05 68 4c 11 80 00 	movl   $0x0,0x80114c68
80102987:	00 00 00 
    write_head();    // Erase the transaction from the log
8010298a:	e8 b4 fd ff ff       	call   80102743 <write_head>
    acquire(&log.lock);
8010298f:	83 ec 0c             	sub    $0xc,%esp
80102992:	68 20 4c 11 80       	push   $0x80114c20
80102997:	e8 19 20 00 00       	call   801049b5 <acquire>
    log.committing = 0;
8010299c:	c7 05 60 4c 11 80 00 	movl   $0x0,0x80114c60
801029a3:	00 00 00 
    wakeup(&log);
801029a6:	c7 04 24 20 4c 11 80 	movl   $0x80114c20,(%esp)
801029ad:	e8 98 16 00 00       	call   8010404a <wakeup>
    release(&log.lock);
801029b2:	c7 04 24 20 4c 11 80 	movl   $0x80114c20,(%esp)
801029b9:	e8 5e 20 00 00       	call   80104a1c <release>
801029be:	83 c4 10             	add    $0x10,%esp
}
801029c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029c4:	5b                   	pop    %ebx
801029c5:	5e                   	pop    %esi
801029c6:	5f                   	pop    %edi
801029c7:	5d                   	pop    %ebp
801029c8:	c3                   	ret    
    panic("log.committing");
801029c9:	83 ec 0c             	sub    $0xc,%esp
801029cc:	68 a4 77 10 80       	push   $0x801077a4
801029d1:	e8 6e d9 ff ff       	call   80100344 <panic>
    wakeup(&log);
801029d6:	83 ec 0c             	sub    $0xc,%esp
801029d9:	68 20 4c 11 80       	push   $0x80114c20
801029de:	e8 67 16 00 00       	call   8010404a <wakeup>
  release(&log.lock);
801029e3:	c7 04 24 20 4c 11 80 	movl   $0x80114c20,(%esp)
801029ea:	e8 2d 20 00 00       	call   80104a1c <release>
801029ef:	83 c4 10             	add    $0x10,%esp
801029f2:	eb cd                	jmp    801029c1 <end_op+0x112>

801029f4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801029f4:	55                   	push   %ebp
801029f5:	89 e5                	mov    %esp,%ebp
801029f7:	53                   	push   %ebx
801029f8:	83 ec 04             	sub    $0x4,%esp
801029fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801029fe:	8b 15 68 4c 11 80    	mov    0x80114c68,%edx
80102a04:	83 fa 1d             	cmp    $0x1d,%edx
80102a07:	7f 6b                	jg     80102a74 <log_write+0x80>
80102a09:	a1 58 4c 11 80       	mov    0x80114c58,%eax
80102a0e:	83 e8 01             	sub    $0x1,%eax
80102a11:	39 c2                	cmp    %eax,%edx
80102a13:	7d 5f                	jge    80102a74 <log_write+0x80>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102a15:	83 3d 5c 4c 11 80 00 	cmpl   $0x0,0x80114c5c
80102a1c:	7e 63                	jle    80102a81 <log_write+0x8d>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102a1e:	83 ec 0c             	sub    $0xc,%esp
80102a21:	68 20 4c 11 80       	push   $0x80114c20
80102a26:	e8 8a 1f 00 00       	call   801049b5 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102a2b:	8b 15 68 4c 11 80    	mov    0x80114c68,%edx
80102a31:	83 c4 10             	add    $0x10,%esp
80102a34:	85 d2                	test   %edx,%edx
80102a36:	7e 56                	jle    80102a8e <log_write+0x9a>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a38:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102a3b:	39 0d 6c 4c 11 80    	cmp    %ecx,0x80114c6c
80102a41:	74 5b                	je     80102a9e <log_write+0xaa>
  for (i = 0; i < log.lh.n; i++) {
80102a43:	b8 00 00 00 00       	mov    $0x0,%eax
80102a48:	83 c0 01             	add    $0x1,%eax
80102a4b:	39 d0                	cmp    %edx,%eax
80102a4d:	74 56                	je     80102aa5 <log_write+0xb1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a4f:	39 0c 85 6c 4c 11 80 	cmp    %ecx,-0x7feeb394(,%eax,4)
80102a56:	75 f0                	jne    80102a48 <log_write+0x54>
      break;
  }
  log.lh.block[i] = b->blockno;
80102a58:	89 0c 85 6c 4c 11 80 	mov    %ecx,-0x7feeb394(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102a5f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102a62:	83 ec 0c             	sub    $0xc,%esp
80102a65:	68 20 4c 11 80       	push   $0x80114c20
80102a6a:	e8 ad 1f 00 00       	call   80104a1c <release>
}
80102a6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a72:	c9                   	leave  
80102a73:	c3                   	ret    
    panic("too big a transaction");
80102a74:	83 ec 0c             	sub    $0xc,%esp
80102a77:	68 b3 77 10 80       	push   $0x801077b3
80102a7c:	e8 c3 d8 ff ff       	call   80100344 <panic>
    panic("log_write outside of trans");
80102a81:	83 ec 0c             	sub    $0xc,%esp
80102a84:	68 c9 77 10 80       	push   $0x801077c9
80102a89:	e8 b6 d8 ff ff       	call   80100344 <panic>
  log.lh.block[i] = b->blockno;
80102a8e:	8b 43 08             	mov    0x8(%ebx),%eax
80102a91:	a3 6c 4c 11 80       	mov    %eax,0x80114c6c
  if (i == log.lh.n)
80102a96:	85 d2                	test   %edx,%edx
80102a98:	75 c5                	jne    80102a5f <log_write+0x6b>
  for (i = 0; i < log.lh.n; i++) {
80102a9a:	89 d0                	mov    %edx,%eax
80102a9c:	eb 11                	jmp    80102aaf <log_write+0xbb>
80102a9e:	b8 00 00 00 00       	mov    $0x0,%eax
80102aa3:	eb b3                	jmp    80102a58 <log_write+0x64>
  log.lh.block[i] = b->blockno;
80102aa5:	8b 53 08             	mov    0x8(%ebx),%edx
80102aa8:	89 14 85 6c 4c 11 80 	mov    %edx,-0x7feeb394(,%eax,4)
    log.lh.n++;
80102aaf:	83 c0 01             	add    $0x1,%eax
80102ab2:	a3 68 4c 11 80       	mov    %eax,0x80114c68
80102ab7:	eb a6                	jmp    80102a5f <log_write+0x6b>

80102ab9 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ab9:	55                   	push   %ebp
80102aba:	89 e5                	mov    %esp,%ebp
80102abc:	53                   	push   %ebx
80102abd:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ac0:	e8 c9 0a 00 00       	call   8010358e <cpuid>
80102ac5:	89 c3                	mov    %eax,%ebx
80102ac7:	e8 c2 0a 00 00       	call   8010358e <cpuid>
80102acc:	83 ec 04             	sub    $0x4,%esp
80102acf:	53                   	push   %ebx
80102ad0:	50                   	push   %eax
80102ad1:	68 e4 77 10 80       	push   $0x801077e4
80102ad6:	e8 06 db ff ff       	call   801005e1 <cprintf>
  idtinit();       // load idt register
80102adb:	e8 f9 31 00 00       	call   80105cd9 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ae0:	e8 32 0a 00 00       	call   80103517 <mycpu>
80102ae5:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ae7:	b8 01 00 00 00       	mov    $0x1,%eax
80102aec:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102af3:	e8 67 0f 00 00       	call   80103a5f <scheduler>

80102af8 <mpenter>:
{
80102af8:	55                   	push   %ebp
80102af9:	89 e5                	mov    %esp,%ebp
80102afb:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102afe:	e8 9d 41 00 00       	call   80106ca0 <switchkvm>
  seginit();
80102b03:	e8 b1 40 00 00       	call   80106bb9 <seginit>
  lapicinit();
80102b08:	e8 af f8 ff ff       	call   801023bc <lapicinit>
  mpmain();
80102b0d:	e8 a7 ff ff ff       	call   80102ab9 <mpmain>

80102b12 <main>:
{
80102b12:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102b16:	83 e4 f0             	and    $0xfffffff0,%esp
80102b19:	ff 71 fc             	pushl  -0x4(%ecx)
80102b1c:	55                   	push   %ebp
80102b1d:	89 e5                	mov    %esp,%ebp
80102b1f:	53                   	push   %ebx
80102b20:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102b21:	83 ec 08             	sub    $0x8,%esp
80102b24:	68 00 00 40 80       	push   $0x80400000
80102b29:	68 c8 5a 11 80       	push   $0x80115ac8
80102b2e:	e8 60 f6 ff ff       	call   80102193 <kinit1>
  kvmalloc();      // kernel page table
80102b33:	e8 ed 45 00 00       	call   80107125 <kvmalloc>
  mpinit();        // detect other processors
80102b38:	e8 50 01 00 00       	call   80102c8d <mpinit>
  lapicinit();     // interrupt controller
80102b3d:	e8 7a f8 ff ff       	call   801023bc <lapicinit>
  seginit();       // segment descriptors
80102b42:	e8 72 40 00 00       	call   80106bb9 <seginit>
  picinit();       // disable pic
80102b47:	e8 01 03 00 00       	call   80102e4d <picinit>
  ioapicinit();    // another interrupt controller
80102b4c:	e8 a0 f4 ff ff       	call   80101ff1 <ioapicinit>
  consoleinit();   // console hardware
80102b51:	e8 fd dd ff ff       	call   80100953 <consoleinit>
  uartinit();      // serial port
80102b56:	e8 45 34 00 00       	call   80105fa0 <uartinit>
  pinit();         // process table
80102b5b:	e8 9d 09 00 00       	call   801034fd <pinit>
  tvinit();        // trap vectors
80102b60:	e8 01 31 00 00       	call   80105c66 <tvinit>
  binit();         // buffer cache
80102b65:	e8 ca d4 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102b6a:	e8 66 e1 ff ff       	call   80100cd5 <fileinit>
  ideinit();       // disk 
80102b6f:	e8 8e f2 ff ff       	call   80101e02 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102b74:	83 c4 0c             	add    $0xc,%esp
80102b77:	68 8a 00 00 00       	push   $0x8a
80102b7c:	68 8c a4 10 80       	push   $0x8010a48c
80102b81:	68 00 70 00 80       	push   $0x80007000
80102b86:	e8 6d 1f 00 00       	call   80104af8 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102b8b:	69 05 a0 52 11 80 b0 	imul   $0xb0,0x801152a0,%eax
80102b92:	00 00 00 
80102b95:	05 20 4d 11 80       	add    $0x80114d20,%eax
80102b9a:	83 c4 10             	add    $0x10,%esp
80102b9d:	3d 20 4d 11 80       	cmp    $0x80114d20,%eax
80102ba2:	76 6c                	jbe    80102c10 <main+0xfe>
80102ba4:	bb 20 4d 11 80       	mov    $0x80114d20,%ebx
80102ba9:	eb 19                	jmp    80102bc4 <main+0xb2>
80102bab:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102bb1:	69 05 a0 52 11 80 b0 	imul   $0xb0,0x801152a0,%eax
80102bb8:	00 00 00 
80102bbb:	05 20 4d 11 80       	add    $0x80114d20,%eax
80102bc0:	39 c3                	cmp    %eax,%ebx
80102bc2:	73 4c                	jae    80102c10 <main+0xfe>
    if(c == mycpu())  // We've started already.
80102bc4:	e8 4e 09 00 00       	call   80103517 <mycpu>
80102bc9:	39 d8                	cmp    %ebx,%eax
80102bcb:	74 de                	je     80102bab <main+0x99>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102bcd:	e8 13 f6 ff ff       	call   801021e5 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102bd2:	05 00 10 00 00       	add    $0x1000,%eax
80102bd7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
80102bdc:	c7 05 f8 6f 00 80 f8 	movl   $0x80102af8,0x80006ff8
80102be3:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102be6:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102bed:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102bf0:	83 ec 08             	sub    $0x8,%esp
80102bf3:	68 00 70 00 00       	push   $0x7000
80102bf8:	0f b6 03             	movzbl (%ebx),%eax
80102bfb:	50                   	push   %eax
80102bfc:	e8 04 f9 ff ff       	call   80102505 <lapicstartap>
80102c01:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102c04:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102c0a:	85 c0                	test   %eax,%eax
80102c0c:	74 f6                	je     80102c04 <main+0xf2>
80102c0e:	eb 9b                	jmp    80102bab <main+0x99>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102c10:	83 ec 08             	sub    $0x8,%esp
80102c13:	68 00 00 00 8e       	push   $0x8e000000
80102c18:	68 00 00 40 80       	push   $0x80400000
80102c1d:	e8 a3 f5 ff ff       	call   801021c5 <kinit2>
  userinit();      // first user process
80102c22:	e8 a6 09 00 00       	call   801035cd <userinit>
  mpmain();        // finish this processor's setup
80102c27:	e8 8d fe ff ff       	call   80102ab9 <mpmain>

80102c2c <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102c2c:	55                   	push   %ebp
80102c2d:	89 e5                	mov    %esp,%ebp
80102c2f:	57                   	push   %edi
80102c30:	56                   	push   %esi
80102c31:	53                   	push   %ebx
80102c32:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102c35:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
  e = addr+len;
80102c3b:	8d 34 13             	lea    (%ebx,%edx,1),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102c3e:	39 f3                	cmp    %esi,%ebx
80102c40:	72 12                	jb     80102c54 <mpsearch1+0x28>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102c42:	bb 00 00 00 00       	mov    $0x0,%ebx
80102c47:	eb 3a                	jmp    80102c83 <mpsearch1+0x57>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c49:	84 c0                	test   %al,%al
80102c4b:	74 36                	je     80102c83 <mpsearch1+0x57>
  for(p = addr; p < e; p += sizeof(struct mp))
80102c4d:	83 c3 10             	add    $0x10,%ebx
80102c50:	39 de                	cmp    %ebx,%esi
80102c52:	76 2a                	jbe    80102c7e <mpsearch1+0x52>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c54:	83 ec 04             	sub    $0x4,%esp
80102c57:	6a 04                	push   $0x4
80102c59:	68 f8 77 10 80       	push   $0x801077f8
80102c5e:	53                   	push   %ebx
80102c5f:	e8 43 1e 00 00       	call   80104aa7 <memcmp>
80102c64:	83 c4 10             	add    $0x10,%esp
80102c67:	85 c0                	test   %eax,%eax
80102c69:	75 e2                	jne    80102c4d <mpsearch1+0x21>
80102c6b:	89 d9                	mov    %ebx,%ecx
80102c6d:	8d 7b 10             	lea    0x10(%ebx),%edi
    sum += addr[i];
80102c70:	0f b6 11             	movzbl (%ecx),%edx
80102c73:	01 d0                	add    %edx,%eax
80102c75:	83 c1 01             	add    $0x1,%ecx
  for(i=0; i<len; i++)
80102c78:	39 f9                	cmp    %edi,%ecx
80102c7a:	75 f4                	jne    80102c70 <mpsearch1+0x44>
80102c7c:	eb cb                	jmp    80102c49 <mpsearch1+0x1d>
  return 0;
80102c7e:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102c83:	89 d8                	mov    %ebx,%eax
80102c85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c88:	5b                   	pop    %ebx
80102c89:	5e                   	pop    %esi
80102c8a:	5f                   	pop    %edi
80102c8b:	5d                   	pop    %ebp
80102c8c:	c3                   	ret    

80102c8d <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102c8d:	55                   	push   %ebp
80102c8e:	89 e5                	mov    %esp,%ebp
80102c90:	57                   	push   %edi
80102c91:	56                   	push   %esi
80102c92:	53                   	push   %ebx
80102c93:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c96:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102c9d:	c1 e0 08             	shl    $0x8,%eax
80102ca0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102ca7:	09 d0                	or     %edx,%eax
80102ca9:	c1 e0 04             	shl    $0x4,%eax
80102cac:	85 c0                	test   %eax,%eax
80102cae:	0f 84 b0 00 00 00    	je     80102d64 <mpinit+0xd7>
    if((mp = mpsearch1(p, 1024)))
80102cb4:	ba 00 04 00 00       	mov    $0x400,%edx
80102cb9:	e8 6e ff ff ff       	call   80102c2c <mpsearch1>
80102cbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cc1:	85 c0                	test   %eax,%eax
80102cc3:	0f 84 cb 00 00 00    	je     80102d94 <mpinit+0x107>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102cc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102ccc:	8b 58 04             	mov    0x4(%eax),%ebx
80102ccf:	85 db                	test   %ebx,%ebx
80102cd1:	0f 84 d7 00 00 00    	je     80102dae <mpinit+0x121>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102cd7:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80102cdd:	83 ec 04             	sub    $0x4,%esp
80102ce0:	6a 04                	push   $0x4
80102ce2:	68 fd 77 10 80       	push   $0x801077fd
80102ce7:	56                   	push   %esi
80102ce8:	e8 ba 1d 00 00       	call   80104aa7 <memcmp>
80102ced:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102cf0:	83 c4 10             	add    $0x10,%esp
80102cf3:	85 c0                	test   %eax,%eax
80102cf5:	0f 85 b3 00 00 00    	jne    80102dae <mpinit+0x121>
  if(conf->version != 1 && conf->version != 4)
80102cfb:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80102d02:	3c 01                	cmp    $0x1,%al
80102d04:	74 08                	je     80102d0e <mpinit+0x81>
80102d06:	3c 04                	cmp    $0x4,%al
80102d08:	0f 85 a0 00 00 00    	jne    80102dae <mpinit+0x121>
  if(sum((uchar*)conf, conf->length) != 0)
80102d0e:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80102d15:	66 85 d2             	test   %dx,%dx
80102d18:	74 1f                	je     80102d39 <mpinit+0xac>
80102d1a:	89 f0                	mov    %esi,%eax
80102d1c:	0f b7 d2             	movzwl %dx,%edx
80102d1f:	8d bc 13 00 00 00 80 	lea    -0x80000000(%ebx,%edx,1),%edi
  sum = 0;
80102d26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    sum += addr[i];
80102d29:	0f b6 08             	movzbl (%eax),%ecx
80102d2c:	01 ca                	add    %ecx,%edx
80102d2e:	83 c0 01             	add    $0x1,%eax
  for(i=0; i<len; i++)
80102d31:	39 c7                	cmp    %eax,%edi
80102d33:	75 f4                	jne    80102d29 <mpinit+0x9c>
  if(sum((uchar*)conf, conf->length) != 0)
80102d35:	84 d2                	test   %dl,%dl
80102d37:	75 75                	jne    80102dae <mpinit+0x121>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102d39:	85 f6                	test   %esi,%esi
80102d3b:	74 71                	je     80102dae <mpinit+0x121>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102d3d:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80102d43:	a3 1c 4c 11 80       	mov    %eax,0x80114c1c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d48:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80102d4e:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80102d55:	01 d6                	add    %edx,%esi
  ismp = 1;
80102d57:	b9 01 00 00 00       	mov    $0x1,%ecx
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80102d5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d5f:	e9 88 00 00 00       	jmp    80102dec <mpinit+0x15f>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102d64:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102d6b:	c1 e0 08             	shl    $0x8,%eax
80102d6e:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102d75:	09 d0                	or     %edx,%eax
80102d77:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102d7a:	2d 00 04 00 00       	sub    $0x400,%eax
80102d7f:	ba 00 04 00 00       	mov    $0x400,%edx
80102d84:	e8 a3 fe ff ff       	call   80102c2c <mpsearch1>
80102d89:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d8c:	85 c0                	test   %eax,%eax
80102d8e:	0f 85 35 ff ff ff    	jne    80102cc9 <mpinit+0x3c>
  return mpsearch1(0xF0000, 0x10000);
80102d94:	ba 00 00 01 00       	mov    $0x10000,%edx
80102d99:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102d9e:	e8 89 fe ff ff       	call   80102c2c <mpsearch1>
80102da3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102da6:	85 c0                	test   %eax,%eax
80102da8:	0f 85 1b ff ff ff    	jne    80102cc9 <mpinit+0x3c>
    panic("Expect to run on an SMP");
80102dae:	83 ec 0c             	sub    $0xc,%esp
80102db1:	68 02 78 10 80       	push   $0x80107802
80102db6:	e8 89 d5 ff ff       	call   80100344 <panic>
      ismp = 0;
80102dbb:	89 f9                	mov    %edi,%ecx
80102dbd:	eb 34                	jmp    80102df3 <mpinit+0x166>
      if(ncpu < NCPU) {
80102dbf:	8b 15 a0 52 11 80    	mov    0x801152a0,%edx
80102dc5:	83 fa 07             	cmp    $0x7,%edx
80102dc8:	7f 1f                	jg     80102de9 <mpinit+0x15c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102dca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102dcd:	69 da b0 00 00 00    	imul   $0xb0,%edx,%ebx
80102dd3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80102dd7:	88 93 20 4d 11 80    	mov    %dl,-0x7feeb2e0(%ebx)
        ncpu++;
80102ddd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102de0:	83 c2 01             	add    $0x1,%edx
80102de3:	89 15 a0 52 11 80    	mov    %edx,0x801152a0
      p += sizeof(struct mpproc);
80102de9:	83 c0 14             	add    $0x14,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102dec:	39 f0                	cmp    %esi,%eax
80102dee:	73 26                	jae    80102e16 <mpinit+0x189>
    switch(*p){
80102df0:	0f b6 10             	movzbl (%eax),%edx
80102df3:	80 fa 04             	cmp    $0x4,%dl
80102df6:	77 c3                	ja     80102dbb <mpinit+0x12e>
80102df8:	0f b6 d2             	movzbl %dl,%edx
80102dfb:	ff 24 95 3c 78 10 80 	jmp    *-0x7fef87c4(,%edx,4)
      ioapicid = ioapic->apicno;
80102e02:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80102e06:	88 15 00 4d 11 80    	mov    %dl,0x80114d00
      p += sizeof(struct mpioapic);
80102e0c:	83 c0 08             	add    $0x8,%eax
      continue;
80102e0f:	eb db                	jmp    80102dec <mpinit+0x15f>
      p += 8;
80102e11:	83 c0 08             	add    $0x8,%eax
      continue;
80102e14:	eb d6                	jmp    80102dec <mpinit+0x15f>
      break;
    }
  }
  if(!ismp)
80102e16:	85 c9                	test   %ecx,%ecx
80102e18:	74 26                	je     80102e40 <mpinit+0x1b3>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102e1d:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102e21:	74 15                	je     80102e38 <mpinit+0x1ab>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e23:	b8 70 00 00 00       	mov    $0x70,%eax
80102e28:	ba 22 00 00 00       	mov    $0x22,%edx
80102e2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e2e:	ba 23 00 00 00       	mov    $0x23,%edx
80102e33:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102e34:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e37:	ee                   	out    %al,(%dx)
  }
}
80102e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e3b:	5b                   	pop    %ebx
80102e3c:	5e                   	pop    %esi
80102e3d:	5f                   	pop    %edi
80102e3e:	5d                   	pop    %ebp
80102e3f:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102e40:	83 ec 0c             	sub    $0xc,%esp
80102e43:	68 1c 78 10 80       	push   $0x8010781c
80102e48:	e8 f7 d4 ff ff       	call   80100344 <panic>

80102e4d <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102e4d:	55                   	push   %ebp
80102e4e:	89 e5                	mov    %esp,%ebp
80102e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e55:	ba 21 00 00 00       	mov    $0x21,%edx
80102e5a:	ee                   	out    %al,(%dx)
80102e5b:	ba a1 00 00 00       	mov    $0xa1,%edx
80102e60:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102e61:	5d                   	pop    %ebp
80102e62:	c3                   	ret    

80102e63 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102e63:	55                   	push   %ebp
80102e64:	89 e5                	mov    %esp,%ebp
80102e66:	57                   	push   %edi
80102e67:	56                   	push   %esi
80102e68:	53                   	push   %ebx
80102e69:	83 ec 0c             	sub    $0xc,%esp
80102e6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102e72:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102e78:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102e7e:	e8 6c de ff ff       	call   80100cef <filealloc>
80102e83:	89 03                	mov    %eax,(%ebx)
80102e85:	85 c0                	test   %eax,%eax
80102e87:	0f 84 a9 00 00 00    	je     80102f36 <pipealloc+0xd3>
80102e8d:	e8 5d de ff ff       	call   80100cef <filealloc>
80102e92:	89 06                	mov    %eax,(%esi)
80102e94:	85 c0                	test   %eax,%eax
80102e96:	0f 84 88 00 00 00    	je     80102f24 <pipealloc+0xc1>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102e9c:	e8 44 f3 ff ff       	call   801021e5 <kalloc>
80102ea1:	89 c7                	mov    %eax,%edi
80102ea3:	85 c0                	test   %eax,%eax
80102ea5:	75 0b                	jne    80102eb2 <pipealloc+0x4f>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102ea7:	8b 03                	mov    (%ebx),%eax
80102ea9:	85 c0                	test   %eax,%eax
80102eab:	75 7d                	jne    80102f2a <pipealloc+0xc7>
80102ead:	e9 84 00 00 00       	jmp    80102f36 <pipealloc+0xd3>
  p->readopen = 1;
80102eb2:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102eb9:	00 00 00 
  p->writeopen = 1;
80102ebc:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102ec3:	00 00 00 
  p->nwrite = 0;
80102ec6:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102ecd:	00 00 00 
  p->nread = 0;
80102ed0:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102ed7:	00 00 00 
  initlock(&p->lock, "pipe");
80102eda:	83 ec 08             	sub    $0x8,%esp
80102edd:	68 50 78 10 80       	push   $0x80107850
80102ee2:	50                   	push   %eax
80102ee3:	e8 85 19 00 00       	call   8010486d <initlock>
  (*f0)->type = FD_PIPE;
80102ee8:	8b 03                	mov    (%ebx),%eax
80102eea:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102ef0:	8b 03                	mov    (%ebx),%eax
80102ef2:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102ef6:	8b 03                	mov    (%ebx),%eax
80102ef8:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102efc:	8b 03                	mov    (%ebx),%eax
80102efe:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102f01:	8b 06                	mov    (%esi),%eax
80102f03:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102f09:	8b 06                	mov    (%esi),%eax
80102f0b:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102f0f:	8b 06                	mov    (%esi),%eax
80102f11:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102f15:	8b 06                	mov    (%esi),%eax
80102f17:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102f1a:	83 c4 10             	add    $0x10,%esp
80102f1d:	b8 00 00 00 00       	mov    $0x0,%eax
80102f22:	eb 2e                	jmp    80102f52 <pipealloc+0xef>
  if(*f0)
80102f24:	8b 03                	mov    (%ebx),%eax
80102f26:	85 c0                	test   %eax,%eax
80102f28:	74 30                	je     80102f5a <pipealloc+0xf7>
    fileclose(*f0);
80102f2a:	83 ec 0c             	sub    $0xc,%esp
80102f2d:	50                   	push   %eax
80102f2e:	e8 6e de ff ff       	call   80100da1 <fileclose>
80102f33:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102f36:	8b 16                	mov    (%esi),%edx
    fileclose(*f1);
  return -1;
80102f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(*f1)
80102f3d:	85 d2                	test   %edx,%edx
80102f3f:	74 11                	je     80102f52 <pipealloc+0xef>
    fileclose(*f1);
80102f41:	83 ec 0c             	sub    $0xc,%esp
80102f44:	52                   	push   %edx
80102f45:	e8 57 de ff ff       	call   80100da1 <fileclose>
80102f4a:	83 c4 10             	add    $0x10,%esp
  return -1;
80102f4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f55:	5b                   	pop    %ebx
80102f56:	5e                   	pop    %esi
80102f57:	5f                   	pop    %edi
80102f58:	5d                   	pop    %ebp
80102f59:	c3                   	ret    
  return -1;
80102f5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f5f:	eb f1                	jmp    80102f52 <pipealloc+0xef>

80102f61 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102f61:	55                   	push   %ebp
80102f62:	89 e5                	mov    %esp,%ebp
80102f64:	53                   	push   %ebx
80102f65:	83 ec 10             	sub    $0x10,%esp
80102f68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102f6b:	53                   	push   %ebx
80102f6c:	e8 44 1a 00 00       	call   801049b5 <acquire>
  if(writable){
80102f71:	83 c4 10             	add    $0x10,%esp
80102f74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102f78:	74 3f                	je     80102fb9 <pipeclose+0x58>
    p->writeopen = 0;
80102f7a:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102f81:	00 00 00 
    wakeup(&p->nread);
80102f84:	83 ec 0c             	sub    $0xc,%esp
80102f87:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f8d:	50                   	push   %eax
80102f8e:	e8 b7 10 00 00       	call   8010404a <wakeup>
80102f93:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f96:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f9d:	75 09                	jne    80102fa8 <pipeclose+0x47>
80102f9f:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102fa6:	74 2f                	je     80102fd7 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102fa8:	83 ec 0c             	sub    $0xc,%esp
80102fab:	53                   	push   %ebx
80102fac:	e8 6b 1a 00 00       	call   80104a1c <release>
80102fb1:	83 c4 10             	add    $0x10,%esp
}
80102fb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fb7:	c9                   	leave  
80102fb8:	c3                   	ret    
    p->readopen = 0;
80102fb9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102fc0:	00 00 00 
    wakeup(&p->nwrite);
80102fc3:	83 ec 0c             	sub    $0xc,%esp
80102fc6:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102fcc:	50                   	push   %eax
80102fcd:	e8 78 10 00 00       	call   8010404a <wakeup>
80102fd2:	83 c4 10             	add    $0x10,%esp
80102fd5:	eb bf                	jmp    80102f96 <pipeclose+0x35>
    release(&p->lock);
80102fd7:	83 ec 0c             	sub    $0xc,%esp
80102fda:	53                   	push   %ebx
80102fdb:	e8 3c 1a 00 00       	call   80104a1c <release>
    kfree((char*)p);
80102fe0:	89 1c 24             	mov    %ebx,(%esp)
80102fe3:	e8 d8 f0 ff ff       	call   801020c0 <kfree>
80102fe8:	83 c4 10             	add    $0x10,%esp
80102feb:	eb c7                	jmp    80102fb4 <pipeclose+0x53>

80102fed <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102fed:	55                   	push   %ebp
80102fee:	89 e5                	mov    %esp,%ebp
80102ff0:	57                   	push   %edi
80102ff1:	56                   	push   %esi
80102ff2:	53                   	push   %ebx
80102ff3:	83 ec 28             	sub    $0x28,%esp
80102ff6:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ff9:	8b 75 0c             	mov    0xc(%ebp),%esi
  int i;

  acquire(&p->lock);
80102ffc:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102fff:	53                   	push   %ebx
80103000:	e8 b0 19 00 00       	call   801049b5 <acquire>
  for(i = 0; i < n; i++){
80103005:	83 c4 10             	add    $0x10,%esp
80103008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010300c:	0f 8e b5 00 00 00    	jle    801030c7 <pipewrite+0xda>
80103012:	89 75 e0             	mov    %esi,-0x20(%ebp)
80103015:	03 75 10             	add    0x10(%ebp),%esi
80103018:	89 75 dc             	mov    %esi,-0x24(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010301b:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103021:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103027:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010302d:	05 00 02 00 00       	add    $0x200,%eax
80103032:	39 c2                	cmp    %eax,%edx
80103034:	75 69                	jne    8010309f <pipewrite+0xb2>
      if(p->readopen == 0 || myproc()->killed){
80103036:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
8010303d:	74 47                	je     80103086 <pipewrite+0x99>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010303f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
      if(p->readopen == 0 || myproc()->killed){
80103045:	e8 5f 05 00 00       	call   801035a9 <myproc>
8010304a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010304e:	75 36                	jne    80103086 <pipewrite+0x99>
      wakeup(&p->nread);
80103050:	83 ec 0c             	sub    $0xc,%esp
80103053:	57                   	push   %edi
80103054:	e8 f1 0f 00 00       	call   8010404a <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103059:	83 c4 08             	add    $0x8,%esp
8010305c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010305f:	56                   	push   %esi
80103060:	e8 f2 0c 00 00       	call   80103d57 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103065:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010306b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103071:	05 00 02 00 00       	add    $0x200,%eax
80103076:	83 c4 10             	add    $0x10,%esp
80103079:	39 c2                	cmp    %eax,%edx
8010307b:	75 22                	jne    8010309f <pipewrite+0xb2>
      if(p->readopen == 0 || myproc()->killed){
8010307d:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80103084:	75 bf                	jne    80103045 <pipewrite+0x58>
        release(&p->lock);
80103086:	83 ec 0c             	sub    $0xc,%esp
80103089:	53                   	push   %ebx
8010308a:	e8 8d 19 00 00       	call   80104a1c <release>
        return -1;
8010308f:	83 c4 10             	add    $0x10,%esp
80103092:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103097:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309a:	5b                   	pop    %ebx
8010309b:	5e                   	pop    %esi
8010309c:	5f                   	pop    %edi
8010309d:	5d                   	pop    %ebp
8010309e:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010309f:	8d 42 01             	lea    0x1(%edx),%eax
801030a2:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801030a8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801030ab:	0f b6 01             	movzbl (%ecx),%eax
801030ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801030b4:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
801030b8:	83 c1 01             	add    $0x1,%ecx
801030bb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(i = 0; i < n; i++){
801030be:	3b 4d dc             	cmp    -0x24(%ebp),%ecx
801030c1:	0f 85 5a ff ff ff    	jne    80103021 <pipewrite+0x34>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801030c7:	83 ec 0c             	sub    $0xc,%esp
801030ca:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801030d0:	50                   	push   %eax
801030d1:	e8 74 0f 00 00       	call   8010404a <wakeup>
  release(&p->lock);
801030d6:	89 1c 24             	mov    %ebx,(%esp)
801030d9:	e8 3e 19 00 00       	call   80104a1c <release>
  return n;
801030de:	83 c4 10             	add    $0x10,%esp
801030e1:	8b 45 10             	mov    0x10(%ebp),%eax
801030e4:	eb b1                	jmp    80103097 <pipewrite+0xaa>

801030e6 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801030e6:	55                   	push   %ebp
801030e7:	89 e5                	mov    %esp,%ebp
801030e9:	57                   	push   %edi
801030ea:	56                   	push   %esi
801030eb:	53                   	push   %ebx
801030ec:	83 ec 18             	sub    $0x18,%esp
801030ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801030f2:	53                   	push   %ebx
801030f3:	e8 bd 18 00 00       	call   801049b5 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030f8:	83 c4 10             	add    $0x10,%esp
801030fb:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103101:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103107:	75 7c                	jne    80103185 <piperead+0x9f>
80103109:	89 de                	mov    %ebx,%esi
8010310b:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80103112:	74 35                	je     80103149 <piperead+0x63>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103114:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    if(myproc()->killed){
8010311a:	e8 8a 04 00 00       	call   801035a9 <myproc>
8010311f:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80103123:	75 4d                	jne    80103172 <piperead+0x8c>
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103125:	83 ec 08             	sub    $0x8,%esp
80103128:	56                   	push   %esi
80103129:	57                   	push   %edi
8010312a:	e8 28 0c 00 00       	call   80103d57 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010312f:	83 c4 10             	add    $0x10,%esp
80103132:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103138:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
8010313e:	75 45                	jne    80103185 <piperead+0x9f>
80103140:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80103147:	75 d1                	jne    8010311a <piperead+0x34>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103149:	be 00 00 00 00       	mov    $0x0,%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010314e:	83 ec 0c             	sub    $0xc,%esp
80103151:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103157:	50                   	push   %eax
80103158:	e8 ed 0e 00 00       	call   8010404a <wakeup>
  release(&p->lock);
8010315d:	89 1c 24             	mov    %ebx,(%esp)
80103160:	e8 b7 18 00 00       	call   80104a1c <release>
  return i;
80103165:	83 c4 10             	add    $0x10,%esp
}
80103168:	89 f0                	mov    %esi,%eax
8010316a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010316d:	5b                   	pop    %ebx
8010316e:	5e                   	pop    %esi
8010316f:	5f                   	pop    %edi
80103170:	5d                   	pop    %ebp
80103171:	c3                   	ret    
      release(&p->lock);
80103172:	83 ec 0c             	sub    $0xc,%esp
80103175:	53                   	push   %ebx
80103176:	e8 a1 18 00 00       	call   80104a1c <release>
      return -1;
8010317b:	83 c4 10             	add    $0x10,%esp
8010317e:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103183:	eb e3                	jmp    80103168 <piperead+0x82>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103185:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80103189:	7e 3c                	jle    801031c7 <piperead+0xe1>
    if(p->nread == p->nwrite)
8010318b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103191:	be 00 00 00 00       	mov    $0x0,%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103196:	8d 50 01             	lea    0x1(%eax),%edx
80103199:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
8010319f:	25 ff 01 00 00       	and    $0x1ff,%eax
801031a4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801031a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801031ac:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801031af:	83 c6 01             	add    $0x1,%esi
801031b2:	39 75 10             	cmp    %esi,0x10(%ebp)
801031b5:	74 97                	je     8010314e <piperead+0x68>
    if(p->nread == p->nwrite)
801031b7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801031bd:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801031c3:	75 d1                	jne    80103196 <piperead+0xb0>
801031c5:	eb 87                	jmp    8010314e <piperead+0x68>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801031c7:	be 00 00 00 00       	mov    $0x0,%esi
801031cc:	eb 80                	jmp    8010314e <piperead+0x68>

801031ce <stateListAdd>:

#ifdef CS333_P3
// Adds processes to the tail of the list
void
stateListAdd(struct ptrs* list, struct proc* p)
{
801031ce:	55                   	push   %ebp
801031cf:	89 e5                	mov    %esp,%ebp
  if((*list).head == NULL){
801031d1:	83 38 00             	cmpl   $0x0,(%eax)
801031d4:	74 21                	je     801031f7 <stateListAdd+0x29>
    (*list).head = p;
    (*list).tail = p;
    p->next = NULL;
  } else{
    ((*list).tail)->next = p;
801031d6:	8b 48 04             	mov    0x4(%eax),%ecx
801031d9:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
    (*list).tail = ((*list).tail)->next;
801031df:	8b 50 04             	mov    0x4(%eax),%edx
801031e2:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
801031e8:	89 50 04             	mov    %edx,0x4(%eax)
    ((*list).tail)->next = NULL;
801031eb:	c7 82 90 00 00 00 00 	movl   $0x0,0x90(%edx)
801031f2:	00 00 00 
  }
}
801031f5:	5d                   	pop    %ebp
801031f6:	c3                   	ret    
    (*list).head = p;
801031f7:	89 10                	mov    %edx,(%eax)
    (*list).tail = p;
801031f9:	89 50 04             	mov    %edx,0x4(%eax)
    p->next = NULL;
801031fc:	c7 82 90 00 00 00 00 	movl   $0x0,0x90(%edx)
80103203:	00 00 00 
80103206:	eb ed                	jmp    801031f5 <stateListAdd+0x27>

80103208 <stateListRemove>:
}

// Removing process p from specific list
int
stateListRemove(struct ptrs* list, struct proc* p)
{
80103208:	55                   	push   %ebp
80103209:	89 e5                	mov    %esp,%ebp
8010320b:	57                   	push   %edi
8010320c:	56                   	push   %esi
8010320d:	53                   	push   %ebx
8010320e:	83 ec 04             	sub    $0x4,%esp
  if((*list).head == NULL || (*list).tail == NULL || p == NULL){
80103211:	8b 18                	mov    (%eax),%ebx
80103213:	85 db                	test   %ebx,%ebx
80103215:	0f 84 82 00 00 00    	je     8010329d <stateListRemove+0x95>
8010321b:	89 c6                	mov    %eax,%esi
8010321d:	89 d7                	mov    %edx,%edi
8010321f:	8b 40 04             	mov    0x4(%eax),%eax
80103222:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103225:	85 d2                	test   %edx,%edx
80103227:	74 7b                	je     801032a4 <stateListRemove+0x9c>
80103229:	85 c0                	test   %eax,%eax
8010322b:	74 77                	je     801032a4 <stateListRemove+0x9c>
  }

  struct proc* current = (*list).head;
  struct proc* previous = 0;

  if(current == p){
8010322d:	39 d3                	cmp    %edx,%ebx
8010322f:	75 1d                	jne    8010324e <stateListRemove+0x46>
    (*list).head = ((*list).head)->next;
80103231:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80103237:	89 06                	mov    %eax,(%esi)
    // prevent tail remaining assigned when we've removed the only item
    // on the list
    if((*list).tail == p){
      (*list).tail = NULL;
    }
    return 0;
80103239:	b8 00 00 00 00       	mov    $0x0,%eax
    if((*list).tail == p){
8010323e:	39 55 f0             	cmp    %edx,-0x10(%ebp)
80103241:	75 43                	jne    80103286 <stateListRemove+0x7e>
      (*list).tail = NULL;
80103243:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
8010324a:	eb 3a                	jmp    80103286 <stateListRemove+0x7e>
    if(current == p){
      break;
    }

    previous = current;
    current = current->next;
8010324c:	89 cb                	mov    %ecx,%ebx
8010324e:	8b 8b 90 00 00 00    	mov    0x90(%ebx),%ecx
    if(current == p){
80103254:	39 cf                	cmp    %ecx,%edi
80103256:	0f 94 c2             	sete   %dl
  while(current){
80103259:	85 c9                	test   %ecx,%ecx
8010325b:	0f 94 c0             	sete   %al
    if(current == p){
8010325e:	08 c2                	or     %al,%dl
80103260:	74 ea                	je     8010324c <stateListRemove+0x44>
  }

  // Process not found. return error
  if(current == NULL){
80103262:	85 c9                	test   %ecx,%ecx
80103264:	74 45                	je     801032ab <stateListRemove+0xa3>
    return -1;
  }

  // Process found.
  if(current == (*list).tail){
80103266:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
80103269:	74 23                	je     8010328e <stateListRemove+0x86>
    (*list).tail = previous;
    ((*list).tail)->next = NULL;
  } else{
    previous->next = current->next;
8010326b:	8b 81 90 00 00 00    	mov    0x90(%ecx),%eax
80103271:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  }

  // Make sure p->next doesn't point into the list.
  p->next = NULL;
80103277:	c7 87 90 00 00 00 00 	movl   $0x0,0x90(%edi)
8010327e:	00 00 00 

  return 0;
80103281:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103286:	83 c4 04             	add    $0x4,%esp
80103289:	5b                   	pop    %ebx
8010328a:	5e                   	pop    %esi
8010328b:	5f                   	pop    %edi
8010328c:	5d                   	pop    %ebp
8010328d:	c3                   	ret    
    (*list).tail = previous;
8010328e:	89 5e 04             	mov    %ebx,0x4(%esi)
    ((*list).tail)->next = NULL;
80103291:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103298:	00 00 00 
8010329b:	eb da                	jmp    80103277 <stateListRemove+0x6f>
    return -1;
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032a2:	eb e2                	jmp    80103286 <stateListRemove+0x7e>
801032a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032a9:	eb db                	jmp    80103286 <stateListRemove+0x7e>
    return -1;
801032ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032b0:	eb d4                	jmp    80103286 <stateListRemove+0x7e>

801032b2 <assertState>:
  if(p -> state != state)
801032b2:	8b 40 0c             	mov    0xc(%eax),%eax
801032b5:	39 d0                	cmp    %edx,%eax
801032b7:	75 02                	jne    801032bb <assertState+0x9>
801032b9:	f3 c3                	repz ret 
{
801032bb:	55                   	push   %ebp
801032bc:	89 e5                	mov    %esp,%ebp
801032be:	83 ec 0c             	sub    $0xc,%esp
    cprintf("We're in %s, we want to be in %s\n", states[p->state], states[state]);
801032c1:	ff 34 95 d4 7b 10 80 	pushl  -0x7fef842c(,%edx,4)
801032c8:	ff 34 85 d4 7b 10 80 	pushl  -0x7fef842c(,%eax,4)
801032cf:	68 58 78 10 80       	push   $0x80107858
801032d4:	e8 08 d3 ff ff       	call   801005e1 <cprintf>
    panic ("No Match");  
801032d9:	c7 04 24 77 79 10 80 	movl   $0x80107977,(%esp)
801032e0:	e8 5f d0 ff ff       	call   80100344 <panic>

801032e5 <wakeup1>:

#ifdef CS333_P3
// New implementation of wakeup1
static void
wakeup1(void *chan)
{
801032e5:	55                   	push   %ebp
801032e6:	89 e5                	mov    %esp,%ebp
801032e8:	57                   	push   %edi
801032e9:	56                   	push   %esi
801032ea:	53                   	push   %ebx
801032eb:	83 ec 0c             	sub    $0xc,%esp
801032ee:	89 c6                	mov    %eax,%esi
  struct proc *p;
  struct proc *current = ptable.list[SLEEPING].head;
801032f0:	8b 1d 24 cb 10 80    	mov    0x8010cb24,%ebx

  while(current)
801032f6:	85 db                	test   %ebx,%ebx
801032f8:	75 1f                	jne    80103319 <wakeup1+0x34>
      current = p;
     }
   else
     current = current -> next;
  }
}
801032fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032fd:	5b                   	pop    %ebx
801032fe:	5e                   	pop    %esi
801032ff:	5f                   	pop    %edi
80103300:	5d                   	pop    %ebp
80103301:	c3                   	ret    
        panic("Wake up 1 error.");
80103302:	83 ec 0c             	sub    $0xc,%esp
80103305:	68 80 79 10 80       	push   $0x80107980
8010330a:	e8 35 d0 ff ff       	call   80100344 <panic>
     current = current -> next;
8010330f:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
  while(current)
80103315:	85 db                	test   %ebx,%ebx
80103317:	74 e1                	je     801032fa <wakeup1+0x15>
    if(current -> chan == chan && current -> state == SLEEPING)
80103319:	39 73 20             	cmp    %esi,0x20(%ebx)
8010331c:	75 f1                	jne    8010330f <wakeup1+0x2a>
8010331e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103322:	75 eb                	jne    8010330f <wakeup1+0x2a>
      p = current -> next;
80103324:	8b bb 90 00 00 00    	mov    0x90(%ebx),%edi
      int rc = stateListRemove(&ptable.list[SLEEPING], current);
8010332a:	89 da                	mov    %ebx,%edx
8010332c:	b8 24 cb 10 80       	mov    $0x8010cb24,%eax
80103331:	e8 d2 fe ff ff       	call   80103208 <stateListRemove>
      if(rc == -1)
80103336:	83 f8 ff             	cmp    $0xffffffff,%eax
80103339:	74 c7                	je     80103302 <wakeup1+0x1d>
      assertState(current, SLEEPING);
8010333b:	ba 02 00 00 00       	mov    $0x2,%edx
80103340:	89 d8                	mov    %ebx,%eax
80103342:	e8 6b ff ff ff       	call   801032b2 <assertState>
      current->state = RUNNABLE;
80103347:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      stateListAdd(&ptable.list[RUNNABLE], current);
8010334e:	89 da                	mov    %ebx,%edx
80103350:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
80103355:	e8 74 fe ff ff       	call   801031ce <stateListAdd>
      current = p;
8010335a:	89 fb                	mov    %edi,%ebx
    {
8010335c:	eb b7                	jmp    80103315 <wakeup1+0x30>

8010335e <allocproc>:
{
8010335e:	55                   	push   %ebp
8010335f:	89 e5                	mov    %esp,%ebp
80103361:	53                   	push   %ebx
80103362:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103365:	68 e0 a5 10 80       	push   $0x8010a5e0
8010336a:	e8 46 16 00 00       	call   801049b5 <acquire>
  p = ptable.list[UNUSED].head;
8010336f:	8b 1d 14 cb 10 80    	mov    0x8010cb14,%ebx
  if(p)
80103375:	83 c4 10             	add    $0x10,%esp
80103378:	85 db                	test   %ebx,%ebx
8010337a:	0f 84 cd 00 00 00    	je     8010344d <allocproc+0xef>
    cprintf("\nunused is not null\n");
80103380:	83 ec 0c             	sub    $0xc,%esp
80103383:	68 91 79 10 80       	push   $0x80107991
80103388:	e8 54 d2 ff ff       	call   801005e1 <cprintf>
  cprintf("\nBefore alloc proc removal\n");
8010338d:	c7 04 24 a6 79 10 80 	movl   $0x801079a6,(%esp)
80103394:	e8 48 d2 ff ff       	call   801005e1 <cprintf>
  int rc = stateListRemove(&ptable.list[UNUSED], p);
80103399:	89 da                	mov    %ebx,%edx
8010339b:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
801033a0:	e8 63 fe ff ff       	call   80103208 <stateListRemove>
  if (rc == -1)
801033a5:	83 c4 10             	add    $0x10,%esp
801033a8:	83 f8 ff             	cmp    $0xffffffff,%eax
801033ab:	0f 84 ae 00 00 00    	je     8010345f <allocproc+0x101>
  assertState(p, UNUSED);
801033b1:	ba 00 00 00 00       	mov    $0x0,%edx
801033b6:	89 d8                	mov    %ebx,%eax
801033b8:	e8 f5 fe ff ff       	call   801032b2 <assertState>
  p->state = EMBRYO;
801033bd:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  stateListAdd(&ptable.list[EMBRYO], p);
801033c4:	89 da                	mov    %ebx,%edx
801033c6:	b8 1c cb 10 80       	mov    $0x8010cb1c,%eax
801033cb:	e8 fe fd ff ff       	call   801031ce <stateListAdd>
  p->pid = nextpid++;
801033d0:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801033d5:	8d 50 01             	lea    0x1(%eax),%edx
801033d8:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801033de:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801033e1:	83 ec 0c             	sub    $0xc,%esp
801033e4:	68 e0 a5 10 80       	push   $0x8010a5e0
801033e9:	e8 2e 16 00 00       	call   80104a1c <release>
  cprintf("\nAfter alloc proc removal\n");
801033ee:	c7 04 24 c2 79 10 80 	movl   $0x801079c2,(%esp)
801033f5:	e8 e7 d1 ff ff       	call   801005e1 <cprintf>
  if((p->kstack = kalloc()) == 0)
801033fa:	e8 e6 ed ff ff       	call   801021e5 <kalloc>
801033ff:	89 43 08             	mov    %eax,0x8(%ebx)
80103402:	83 c4 10             	add    $0x10,%esp
80103405:	85 c0                	test   %eax,%eax
80103407:	74 63                	je     8010346c <allocproc+0x10e>
  sp -= sizeof *p->tf;
80103409:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
8010340f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103412:	c7 80 b0 0f 00 00 5b 	movl   $0x80105c5b,0xfb0(%eax)
80103419:	5c 10 80 
  sp -= sizeof *p->context;
8010341c:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80103421:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103424:	83 ec 04             	sub    $0x4,%esp
80103427:	6a 14                	push   $0x14
80103429:	6a 00                	push   $0x0
8010342b:	50                   	push   %eax
8010342c:	e8 32 16 00 00       	call   80104a63 <memset>
  p->context->eip = (uint)forkret;
80103431:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103434:	c7 40 10 ba 34 10 80 	movl   $0x801034ba,0x10(%eax)
  p -> start_ticks = ticks;
8010343b:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80103440:	89 43 7c             	mov    %eax,0x7c(%ebx)
  return p; 
80103443:	83 c4 10             	add    $0x10,%esp
}
80103446:	89 d8                	mov    %ebx,%eax
80103448:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010344b:	c9                   	leave  
8010344c:	c3                   	ret    
    release(&ptable.lock);
8010344d:	83 ec 0c             	sub    $0xc,%esp
80103450:	68 e0 a5 10 80       	push   $0x8010a5e0
80103455:	e8 c2 15 00 00       	call   80104a1c <release>
    return 0;
8010345a:	83 c4 10             	add    $0x10,%esp
8010345d:	eb e7                	jmp    80103446 <allocproc+0xe8>
    panic("ERROR. Allocproc removal failed\n");
8010345f:	83 ec 0c             	sub    $0xc,%esp
80103462:	68 7c 78 10 80       	push   $0x8010787c
80103467:	e8 d8 ce ff ff       	call   80100344 <panic>
    acquire(&ptable.lock);
8010346c:	83 ec 0c             	sub    $0xc,%esp
8010346f:	68 e0 a5 10 80       	push   $0x8010a5e0
80103474:	e8 3c 15 00 00       	call   801049b5 <acquire>
    stateListRemove(&ptable.list[EMBRYO], p);
80103479:	89 da                	mov    %ebx,%edx
8010347b:	b8 1c cb 10 80       	mov    $0x8010cb1c,%eax
80103480:	e8 83 fd ff ff       	call   80103208 <stateListRemove>
    assertState(p, EMBRYO);
80103485:	ba 01 00 00 00       	mov    $0x1,%edx
8010348a:	89 d8                	mov    %ebx,%eax
8010348c:	e8 21 fe ff ff       	call   801032b2 <assertState>
    p->state = UNUSED;
80103491:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    stateListAdd(&ptable.list[UNUSED], p);
80103498:	89 da                	mov    %ebx,%edx
8010349a:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
8010349f:	e8 2a fd ff ff       	call   801031ce <stateListAdd>
    release(&ptable.lock);
801034a4:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
801034ab:	e8 6c 15 00 00       	call   80104a1c <release>
    return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
801034b3:	bb 00 00 00 00       	mov    $0x0,%ebx
801034b8:	eb 8c                	jmp    80103446 <allocproc+0xe8>

801034ba <forkret>:
{
801034ba:	55                   	push   %ebp
801034bb:	89 e5                	mov    %esp,%ebp
801034bd:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
801034c0:	68 e0 a5 10 80       	push   $0x8010a5e0
801034c5:	e8 52 15 00 00       	call   80104a1c <release>
  if (first) {
801034ca:	83 c4 10             	add    $0x10,%esp
801034cd:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
801034d4:	75 02                	jne    801034d8 <forkret+0x1e>
}
801034d6:	c9                   	leave  
801034d7:	c3                   	ret    
    first = 0;
801034d8:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801034df:	00 00 00 
    iinit(ROOTDEV);
801034e2:	83 ec 0c             	sub    $0xc,%esp
801034e5:	6a 01                	push   $0x1
801034e7:	e8 a1 de ff ff       	call   8010138d <iinit>
    initlog(ROOTDEV);
801034ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801034f3:	e8 a7 f2 ff ff       	call   8010279f <initlog>
801034f8:	83 c4 10             	add    $0x10,%esp
}
801034fb:	eb d9                	jmp    801034d6 <forkret+0x1c>

801034fd <pinit>:
{
801034fd:	55                   	push   %ebp
801034fe:	89 e5                	mov    %esp,%ebp
80103500:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103503:	68 dd 79 10 80       	push   $0x801079dd
80103508:	68 e0 a5 10 80       	push   $0x8010a5e0
8010350d:	e8 5b 13 00 00       	call   8010486d <initlock>
}
80103512:	83 c4 10             	add    $0x10,%esp
80103515:	c9                   	leave  
80103516:	c3                   	ret    

80103517 <mycpu>:
{
80103517:	55                   	push   %ebp
80103518:	89 e5                	mov    %esp,%ebp
8010351a:	56                   	push   %esi
8010351b:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010351c:	9c                   	pushf  
8010351d:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010351e:	f6 c4 02             	test   $0x2,%ah
80103521:	75 4a                	jne    8010356d <mycpu+0x56>
  apicid = lapicid();
80103523:	e8 9f ef ff ff       	call   801024c7 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103528:	8b 35 a0 52 11 80    	mov    0x801152a0,%esi
8010352e:	85 f6                	test   %esi,%esi
80103530:	7e 4f                	jle    80103581 <mycpu+0x6a>
    if (cpus[i].apicid == apicid) {
80103532:	0f b6 15 20 4d 11 80 	movzbl 0x80114d20,%edx
80103539:	39 d0                	cmp    %edx,%eax
8010353b:	74 3d                	je     8010357a <mycpu+0x63>
8010353d:	b9 d0 4d 11 80       	mov    $0x80114dd0,%ecx
  for (i = 0; i < ncpu; ++i) {
80103542:	ba 00 00 00 00       	mov    $0x0,%edx
80103547:	83 c2 01             	add    $0x1,%edx
8010354a:	39 f2                	cmp    %esi,%edx
8010354c:	74 33                	je     80103581 <mycpu+0x6a>
    if (cpus[i].apicid == apicid) {
8010354e:	0f b6 19             	movzbl (%ecx),%ebx
80103551:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103557:	39 c3                	cmp    %eax,%ebx
80103559:	75 ec                	jne    80103547 <mycpu+0x30>
      return &cpus[i];
8010355b:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103561:	05 20 4d 11 80       	add    $0x80114d20,%eax
}
80103566:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103569:	5b                   	pop    %ebx
8010356a:	5e                   	pop    %esi
8010356b:	5d                   	pop    %ebp
8010356c:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
8010356d:	83 ec 0c             	sub    $0xc,%esp
80103570:	68 a0 78 10 80       	push   $0x801078a0
80103575:	e8 ca cd ff ff       	call   80100344 <panic>
  for (i = 0; i < ncpu; ++i) {
8010357a:	ba 00 00 00 00       	mov    $0x0,%edx
8010357f:	eb da                	jmp    8010355b <mycpu+0x44>
  panic("unknown apicid\n");
80103581:	83 ec 0c             	sub    $0xc,%esp
80103584:	68 e4 79 10 80       	push   $0x801079e4
80103589:	e8 b6 cd ff ff       	call   80100344 <panic>

8010358e <cpuid>:
cpuid() {
8010358e:	55                   	push   %ebp
8010358f:	89 e5                	mov    %esp,%ebp
80103591:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103594:	e8 7e ff ff ff       	call   80103517 <mycpu>
80103599:	2d 20 4d 11 80       	sub    $0x80114d20,%eax
8010359e:	c1 f8 04             	sar    $0x4,%eax
801035a1:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801035a7:	c9                   	leave  
801035a8:	c3                   	ret    

801035a9 <myproc>:
myproc(void) {
801035a9:	55                   	push   %ebp
801035aa:	89 e5                	mov    %esp,%ebp
801035ac:	53                   	push   %ebx
801035ad:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801035b0:	e8 2f 13 00 00       	call   801048e4 <pushcli>
  c = mycpu();
801035b5:	e8 5d ff ff ff       	call   80103517 <mycpu>
  p = c->proc;
801035ba:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801035c0:	e8 5c 13 00 00       	call   80104921 <popcli>
}
801035c5:	89 d8                	mov    %ebx,%eax
801035c7:	83 c4 04             	add    $0x4,%esp
801035ca:	5b                   	pop    %ebx
801035cb:	5d                   	pop    %ebp
801035cc:	c3                   	ret    

801035cd <userinit>:
{
801035cd:	55                   	push   %ebp
801035ce:	89 e5                	mov    %esp,%ebp
801035d0:	53                   	push   %ebx
801035d1:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801035d4:	68 e0 a5 10 80       	push   $0x8010a5e0
801035d9:	e8 d7 13 00 00       	call   801049b5 <acquire>
801035de:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
801035e3:	ba 44 cb 10 80       	mov    $0x8010cb44,%edx
801035e8:	83 c4 10             	add    $0x10,%esp
    ptable.list[i].head = NULL;
801035eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    ptable.list[i].tail = NULL;
801035f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
801035f8:	83 c0 08             	add    $0x8,%eax
  for (i = UNUSED; i <= ZOMBIE; i++) {
801035fb:	39 d0                	cmp    %edx,%eax
801035fd:	75 ec                	jne    801035eb <userinit+0x1e>
  for(p = ptable.proc; p < ptable.proc + NPROC; ++p){
801035ff:	bb 14 a6 10 80       	mov    $0x8010a614,%ebx
    p->state = UNUSED;
80103604:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    stateListAdd(&ptable.list[UNUSED], p);
8010360b:	89 da                	mov    %ebx,%edx
8010360d:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
80103612:	e8 b7 fb ff ff       	call   801031ce <stateListAdd>
  for(p = ptable.proc; p < ptable.proc + NPROC; ++p){
80103617:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010361d:	81 fb 14 cb 10 80    	cmp    $0x8010cb14,%ebx
80103623:	72 df                	jb     80103604 <userinit+0x37>
  release(&ptable.lock);
80103625:	83 ec 0c             	sub    $0xc,%esp
80103628:	68 e0 a5 10 80       	push   $0x8010a5e0
8010362d:	e8 ea 13 00 00       	call   80104a1c <release>
  cprintf("\nuserinit called\n");
80103632:	c7 04 24 f4 79 10 80 	movl   $0x801079f4,(%esp)
80103639:	e8 a3 cf ff ff       	call   801005e1 <cprintf>
  p = allocproc();
8010363e:	e8 1b fd ff ff       	call   8010335e <allocproc>
80103643:	89 c3                	mov    %eax,%ebx
  cprintf("\nRight after the allocproc call\n");
80103645:	c7 04 24 c8 78 10 80 	movl   $0x801078c8,(%esp)
8010364c:	e8 90 cf ff ff       	call   801005e1 <cprintf>
  initproc = p;
80103651:	89 1d c0 a5 10 80    	mov    %ebx,0x8010a5c0
  if((p->pgdir = setupkvm()) == 0)
80103657:	e8 5b 3a 00 00       	call   801070b7 <setupkvm>
8010365c:	89 43 04             	mov    %eax,0x4(%ebx)
8010365f:	83 c4 10             	add    $0x10,%esp
80103662:	85 c0                	test   %eax,%eax
80103664:	0f 84 0c 01 00 00    	je     80103776 <userinit+0x1a9>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010366a:	83 ec 04             	sub    $0x4,%esp
8010366d:	68 2c 00 00 00       	push   $0x2c
80103672:	68 60 a4 10 80       	push   $0x8010a460
80103677:	50                   	push   %eax
80103678:	e8 33 37 00 00       	call   80106db0 <inituvm>
  p->sz = PGSIZE;
8010367d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103683:	83 c4 0c             	add    $0xc,%esp
80103686:	6a 4c                	push   $0x4c
80103688:	6a 00                	push   $0x0
8010368a:	ff 73 18             	pushl  0x18(%ebx)
8010368d:	e8 d1 13 00 00       	call   80104a63 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103692:	8b 43 18             	mov    0x18(%ebx),%eax
80103695:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010369b:	8b 43 18             	mov    0x18(%ebx),%eax
8010369e:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801036a4:	8b 43 18             	mov    0x18(%ebx),%eax
801036a7:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801036ab:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801036af:	8b 43 18             	mov    0x18(%ebx),%eax
801036b2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801036b6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801036ba:	8b 43 18             	mov    0x18(%ebx),%eax
801036bd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801036c4:	8b 43 18             	mov    0x18(%ebx),%eax
801036c7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801036ce:	8b 43 18             	mov    0x18(%ebx),%eax
801036d1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801036d8:	83 c4 0c             	add    $0xc,%esp
801036db:	6a 10                	push   $0x10
801036dd:	68 1f 7a 10 80       	push   $0x80107a1f
801036e2:	8d 43 6c             	lea    0x6c(%ebx),%eax
801036e5:	50                   	push   %eax
801036e6:	e8 07 15 00 00       	call   80104bf2 <safestrcpy>
  p->cwd = namei("/");
801036eb:	c7 04 24 28 7a 10 80 	movl   $0x80107a28,(%esp)
801036f2:	e8 13 e6 ff ff       	call   80101d0a <namei>
801036f7:	89 43 68             	mov    %eax,0x68(%ebx)
  cprintf("\nRight before the lock acquistion\n");
801036fa:	c7 04 24 ec 78 10 80 	movl   $0x801078ec,(%esp)
80103701:	e8 db ce ff ff       	call   801005e1 <cprintf>
  acquire(&ptable.lock);
80103706:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
8010370d:	e8 a3 12 00 00       	call   801049b5 <acquire>
  stateListRemove(&ptable.list[p->state], p);
80103712:	8b 43 0c             	mov    0xc(%ebx),%eax
80103715:	8d 04 c5 14 cb 10 80 	lea    -0x7fef34ec(,%eax,8),%eax
8010371c:	89 da                	mov    %ebx,%edx
8010371e:	e8 e5 fa ff ff       	call   80103208 <stateListRemove>
  assertState(p, EMBRYO);
80103723:	ba 01 00 00 00       	mov    $0x1,%edx
80103728:	89 d8                	mov    %ebx,%eax
8010372a:	e8 83 fb ff ff       	call   801032b2 <assertState>
  p->state = RUNNABLE;
8010372f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  stateListAdd(&ptable.list[p->state], p);
80103736:	89 da                	mov    %ebx,%edx
80103738:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
8010373d:	e8 8c fa ff ff       	call   801031ce <stateListAdd>
  release(&ptable.lock);
80103742:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103749:	e8 ce 12 00 00       	call   80104a1c <release>
  cprintf("\nRight after lock releasal\n"); 
8010374e:	c7 04 24 2a 7a 10 80 	movl   $0x80107a2a,(%esp)
80103755:	e8 87 ce ff ff       	call   801005e1 <cprintf>
  p->uid = UID; //setting to default
8010375a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103761:	00 00 00 
  p->gid = GID; //setting to default
80103764:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010376b:	00 00 00 
}
8010376e:	83 c4 10             	add    $0x10,%esp
80103771:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103774:	c9                   	leave  
80103775:	c3                   	ret    
    panic("userinit: out of memory?");
80103776:	83 ec 0c             	sub    $0xc,%esp
80103779:	68 06 7a 10 80       	push   $0x80107a06
8010377e:	e8 c1 cb ff ff       	call   80100344 <panic>

80103783 <traverse>:
{
80103783:	55                   	push   %ebp
80103784:	89 e5                	mov    %esp,%ebp
80103786:	57                   	push   %edi
80103787:	56                   	push   %esi
80103788:	53                   	push   %ebx
80103789:	83 ec 1c             	sub    $0x1c,%esp
8010378c:	8b 75 08             	mov    0x8(%ebp),%esi
  if(state == 3) //runnable processes
8010378f:	83 fe 03             	cmp    $0x3,%esi
80103792:	74 25                	je     801037b9 <traverse+0x36>
  if(state == 2) //sleeping processes
80103794:	83 fe 02             	cmp    $0x2,%esi
80103797:	74 32                	je     801037cb <traverse+0x48>
  if(state == 5) //zombie processes
80103799:	83 fe 05             	cmp    $0x5,%esi
8010379c:	74 3f                	je     801037dd <traverse+0x5a>
  struct proc * current = ptable.list[state].head;
8010379e:	8b 1c f5 14 cb 10 80 	mov    -0x7fef34ec(,%esi,8),%ebx
  while(current)
801037a5:	85 db                	test   %ebx,%ebx
801037a7:	0f 84 a4 00 00 00    	je     80103851 <traverse+0xce>
{
801037ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if(state == 2 || state == 3) //runnable or sleeping
801037b4:	8d 7e fe             	lea    -0x2(%esi),%edi
801037b7:	eb 65                	jmp    8010381e <traverse+0x9b>
    cprintf("\nReady List Processes:\n");
801037b9:	83 ec 0c             	sub    $0xc,%esp
801037bc:	68 46 7a 10 80       	push   $0x80107a46
801037c1:	e8 1b ce ff ff       	call   801005e1 <cprintf>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb d3                	jmp    8010379e <traverse+0x1b>
    cprintf("\nSleep List Processes:\n");
801037cb:	83 ec 0c             	sub    $0xc,%esp
801037ce:	68 5e 7a 10 80       	push   $0x80107a5e
801037d3:	e8 09 ce ff ff       	call   801005e1 <cprintf>
801037d8:	83 c4 10             	add    $0x10,%esp
801037db:	eb c1                	jmp    8010379e <traverse+0x1b>
    cprintf("\nZombie List Processes:\n");
801037dd:	83 ec 0c             	sub    $0xc,%esp
801037e0:	68 76 7a 10 80       	push   $0x80107a76
801037e5:	e8 f7 cd ff ff       	call   801005e1 <cprintf>
  struct proc * current = ptable.list[state].head;
801037ea:	8b 1c f5 14 cb 10 80 	mov    -0x7fef34ec(,%esi,8),%ebx
  while(current)
801037f1:	83 c4 10             	add    $0x10,%esp
801037f4:	85 db                	test   %ebx,%ebx
801037f6:	75 b5                	jne    801037ad <traverse+0x2a>
801037f8:	eb 62                	jmp    8010385c <traverse+0xd9>
      cprintf("%d -> ", current -> pid);  
801037fa:	83 ec 08             	sub    $0x8,%esp
801037fd:	ff 73 10             	pushl  0x10(%ebx)
80103800:	68 8f 7a 10 80       	push   $0x80107a8f
80103805:	e8 d7 cd ff ff       	call   801005e1 <cprintf>
      current = current -> next;
8010380a:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
80103810:	83 c4 10             	add    $0x10,%esp
80103813:	eb 05                	jmp    8010381a <traverse+0x97>
    else if(state == 5) //zombie 
80103815:	83 fe 05             	cmp    $0x5,%esi
80103818:	74 19                	je     80103833 <traverse+0xb0>
  while(current)
8010381a:	85 db                	test   %ebx,%ebx
8010381c:	74 3a                	je     80103858 <traverse+0xd5>
    if(state == 2 || state == 3) //runnable or sleeping
8010381e:	83 ff 01             	cmp    $0x1,%edi
80103821:	76 d7                	jbe    801037fa <traverse+0x77>
    else if(state == 0) //unused 
80103823:	85 f6                	test   %esi,%esi
80103825:	75 ee                	jne    80103815 <traverse+0x92>
      current = current -> next;
80103827:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
      ++ucount; //count number of unused processes
8010382d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103831:	eb e7                	jmp    8010381a <traverse+0x97>
      cprintf("(%d, %d) -> ", current -> pid, current -> parent);
80103833:	83 ec 04             	sub    $0x4,%esp
80103836:	ff 73 14             	pushl  0x14(%ebx)
80103839:	ff 73 10             	pushl  0x10(%ebx)
8010383c:	68 96 7a 10 80       	push   $0x80107a96
80103841:	e8 9b cd ff ff       	call   801005e1 <cprintf>
      current = current -> next;
80103846:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
8010384c:	83 c4 10             	add    $0x10,%esp
8010384f:	eb c9                	jmp    8010381a <traverse+0x97>
  int ucount = 0;
80103851:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  if(state == 0)
80103858:	85 f6                	test   %esi,%esi
8010385a:	74 0d                	je     80103869 <traverse+0xe6>
}
8010385c:	b8 00 00 00 00       	mov    $0x0,%eax
80103861:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103864:	5b                   	pop    %ebx
80103865:	5e                   	pop    %esi
80103866:	5f                   	pop    %edi
80103867:	5d                   	pop    %ebp
80103868:	c3                   	ret    
    cprintf("Free List Size: %d\n", ucount);
80103869:	83 ec 08             	sub    $0x8,%esp
8010386c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010386f:	68 a3 7a 10 80       	push   $0x80107aa3
80103874:	e8 68 cd ff ff       	call   801005e1 <cprintf>
80103879:	83 c4 10             	add    $0x10,%esp
8010387c:	eb de                	jmp    8010385c <traverse+0xd9>

8010387e <growproc>:
{
8010387e:	55                   	push   %ebp
8010387f:	89 e5                	mov    %esp,%ebp
80103881:	56                   	push   %esi
80103882:	53                   	push   %ebx
80103883:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
80103886:	e8 1e fd ff ff       	call   801035a9 <myproc>
8010388b:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
8010388d:	8b 00                	mov    (%eax),%eax
  if(n > 0){
8010388f:	85 f6                	test   %esi,%esi
80103891:	7f 21                	jg     801038b4 <growproc+0x36>
  } else if(n < 0){
80103893:	85 f6                	test   %esi,%esi
80103895:	79 33                	jns    801038ca <growproc+0x4c>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103897:	83 ec 04             	sub    $0x4,%esp
8010389a:	01 c6                	add    %eax,%esi
8010389c:	56                   	push   %esi
8010389d:	50                   	push   %eax
8010389e:	ff 73 04             	pushl  0x4(%ebx)
801038a1:	e8 21 36 00 00       	call   80106ec7 <deallocuvm>
801038a6:	83 c4 10             	add    $0x10,%esp
801038a9:	85 c0                	test   %eax,%eax
801038ab:	75 1d                	jne    801038ca <growproc+0x4c>
      return -1;
801038ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038b2:	eb 29                	jmp    801038dd <growproc+0x5f>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038b4:	83 ec 04             	sub    $0x4,%esp
801038b7:	01 c6                	add    %eax,%esi
801038b9:	56                   	push   %esi
801038ba:	50                   	push   %eax
801038bb:	ff 73 04             	pushl  0x4(%ebx)
801038be:	e8 93 36 00 00       	call   80106f56 <allocuvm>
801038c3:	83 c4 10             	add    $0x10,%esp
801038c6:	85 c0                	test   %eax,%eax
801038c8:	74 1a                	je     801038e4 <growproc+0x66>
  curproc->sz = sz;
801038ca:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801038cc:	83 ec 0c             	sub    $0xc,%esp
801038cf:	53                   	push   %ebx
801038d0:	e8 dd 33 00 00       	call   80106cb2 <switchuvm>
  return 0;
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801038dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038e0:	5b                   	pop    %ebx
801038e1:	5e                   	pop    %esi
801038e2:	5d                   	pop    %ebp
801038e3:	c3                   	ret    
      return -1;
801038e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038e9:	eb f2                	jmp    801038dd <growproc+0x5f>

801038eb <fork>:
{
801038eb:	55                   	push   %ebp
801038ec:	89 e5                	mov    %esp,%ebp
801038ee:	57                   	push   %edi
801038ef:	56                   	push   %esi
801038f0:	53                   	push   %ebx
801038f1:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801038f4:	e8 b0 fc ff ff       	call   801035a9 <myproc>
801038f9:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801038fb:	e8 5e fa ff ff       	call   8010335e <allocproc>
80103900:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103903:	85 c0                	test   %eax,%eax
80103905:	0f 84 4d 01 00 00    	je     80103a58 <fork+0x16d>
8010390b:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010390d:	83 ec 08             	sub    $0x8,%esp
80103910:	ff 33                	pushl  (%ebx)
80103912:	ff 73 04             	pushl  0x4(%ebx)
80103915:	e8 4e 38 00 00       	call   80107168 <copyuvm>
8010391a:	89 47 04             	mov    %eax,0x4(%edi)
8010391d:	83 c4 10             	add    $0x10,%esp
80103920:	85 c0                	test   %eax,%eax
80103922:	74 28                	je     8010394c <fork+0x61>
  np->sz = curproc->sz;
80103924:	8b 03                	mov    (%ebx),%eax
80103926:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103929:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
8010392b:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
8010392e:	8b 73 18             	mov    0x18(%ebx),%esi
80103931:	8b 7a 18             	mov    0x18(%edx),%edi
80103934:	b9 13 00 00 00       	mov    $0x13,%ecx
80103939:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
8010393b:	8b 42 18             	mov    0x18(%edx),%eax
8010393e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103945:	be 00 00 00 00       	mov    $0x0,%esi
8010394a:	eb 6d                	jmp    801039b9 <fork+0xce>
    kfree(np->kstack);
8010394c:	83 ec 0c             	sub    $0xc,%esp
8010394f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103952:	ff 73 08             	pushl  0x8(%ebx)
80103955:	e8 66 e7 ff ff       	call   801020c0 <kfree>
    np->kstack = 0;
8010395a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    acquire(&ptable.lock);
80103961:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103968:	e8 48 10 00 00       	call   801049b5 <acquire>
    stateListRemove(&ptable.list[EMBRYO], np);
8010396d:	89 da                	mov    %ebx,%edx
8010396f:	b8 1c cb 10 80       	mov    $0x8010cb1c,%eax
80103974:	e8 8f f8 ff ff       	call   80103208 <stateListRemove>
    assertState(np, EMBRYO);
80103979:	ba 01 00 00 00       	mov    $0x1,%edx
8010397e:	89 d8                	mov    %ebx,%eax
80103980:	e8 2d f9 ff ff       	call   801032b2 <assertState>
    np->state = UNUSED;
80103985:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    stateListAdd(&ptable.list[UNUSED], np);
8010398c:	89 da                	mov    %ebx,%edx
8010398e:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
80103993:	e8 36 f8 ff ff       	call   801031ce <stateListAdd>
    release(&ptable.lock);
80103998:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
8010399f:	e8 78 10 00 00       	call   80104a1c <release>
    return -1;
801039a4:	83 c4 10             	add    $0x10,%esp
801039a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039ac:	e9 9f 00 00 00       	jmp    80103a50 <fork+0x165>
  for(i = 0; i < NOFILE; i++)
801039b1:	83 c6 01             	add    $0x1,%esi
801039b4:	83 fe 10             	cmp    $0x10,%esi
801039b7:	74 1d                	je     801039d6 <fork+0xeb>
    if(curproc->ofile[i])
801039b9:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801039bd:	85 c0                	test   %eax,%eax
801039bf:	74 f0                	je     801039b1 <fork+0xc6>
      np->ofile[i] = filedup(curproc->ofile[i]);
801039c1:	83 ec 0c             	sub    $0xc,%esp
801039c4:	50                   	push   %eax
801039c5:	e8 92 d3 ff ff       	call   80100d5c <filedup>
801039ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801039cd:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
801039d1:	83 c4 10             	add    $0x10,%esp
801039d4:	eb db                	jmp    801039b1 <fork+0xc6>
  np->cwd = idup(curproc->cwd);
801039d6:	83 ec 0c             	sub    $0xc,%esp
801039d9:	ff 73 68             	pushl  0x68(%ebx)
801039dc:	e8 61 db ff ff       	call   80101542 <idup>
801039e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801039e4:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039e7:	83 c4 0c             	add    $0xc,%esp
801039ea:	6a 10                	push   $0x10
801039ec:	83 c3 6c             	add    $0x6c,%ebx
801039ef:	53                   	push   %ebx
801039f0:	8d 47 6c             	lea    0x6c(%edi),%eax
801039f3:	50                   	push   %eax
801039f4:	e8 f9 11 00 00       	call   80104bf2 <safestrcpy>
  pid = np->pid;
801039f9:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801039fc:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103a03:	e8 ad 0f 00 00       	call   801049b5 <acquire>
  stateListRemove(&ptable.list[EMBRYO], np);
80103a08:	89 fa                	mov    %edi,%edx
80103a0a:	b8 1c cb 10 80       	mov    $0x8010cb1c,%eax
80103a0f:	e8 f4 f7 ff ff       	call   80103208 <stateListRemove>
  assertState(np, EMBRYO);
80103a14:	ba 01 00 00 00       	mov    $0x1,%edx
80103a19:	89 f8                	mov    %edi,%eax
80103a1b:	e8 92 f8 ff ff       	call   801032b2 <assertState>
  np->state = RUNNABLE;
80103a20:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  stateListAdd(&ptable.list[RUNNABLE], np);
80103a27:	89 fa                	mov    %edi,%edx
80103a29:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
80103a2e:	e8 9b f7 ff ff       	call   801031ce <stateListAdd>
  release(&ptable.lock);
80103a33:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103a3a:	e8 dd 0f 00 00       	call   80104a1c <release>
  cprintf("\nOut of fork.\n");
80103a3f:	c7 04 24 b7 7a 10 80 	movl   $0x80107ab7,(%esp)
80103a46:	e8 96 cb ff ff       	call   801005e1 <cprintf>
  return pid;
80103a4b:	89 d8                	mov    %ebx,%eax
80103a4d:	83 c4 10             	add    $0x10,%esp
}
80103a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a53:	5b                   	pop    %ebx
80103a54:	5e                   	pop    %esi
80103a55:	5f                   	pop    %edi
80103a56:	5d                   	pop    %ebp
80103a57:	c3                   	ret    
    return -1;
80103a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a5d:	eb f1                	jmp    80103a50 <fork+0x165>

80103a5f <scheduler>:
{
80103a5f:	55                   	push   %ebp
80103a60:	89 e5                	mov    %esp,%ebp
80103a62:	57                   	push   %edi
80103a63:	56                   	push   %esi
80103a64:	53                   	push   %ebx
80103a65:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103a68:	e8 aa fa ff ff       	call   80103517 <mycpu>
80103a6d:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a6f:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a76:	00 00 00 
      swtch(&(c->scheduler), p->context);
80103a79:	8d 78 04             	lea    0x4(%eax),%edi
  asm volatile("sti");
80103a7c:	fb                   	sti    
    acquire(&ptable.lock);
80103a7d:	83 ec 0c             	sub    $0xc,%esp
80103a80:	68 e0 a5 10 80       	push   $0x8010a5e0
80103a85:	e8 2b 0f 00 00       	call   801049b5 <acquire>
    p = ptable.list[RUNNABLE].head;
80103a8a:	8b 1d 2c cb 10 80    	mov    0x8010cb2c,%ebx
    if(p)
80103a90:	83 c4 10             	add    $0x10,%esp
80103a93:	85 db                	test   %ebx,%ebx
80103a95:	0f 84 89 00 00 00    	je     80103b24 <scheduler+0xc5>
      c->proc = p;
80103a9b:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103aa1:	83 ec 0c             	sub    $0xc,%esp
80103aa4:	53                   	push   %ebx
80103aa5:	e8 08 32 00 00       	call   80106cb2 <switchuvm>
      int rc = stateListRemove(&ptable.list[RUNNABLE], p); //Removing process p from specific list
80103aaa:	89 da                	mov    %ebx,%edx
80103aac:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
80103ab1:	e8 52 f7 ff ff       	call   80103208 <stateListRemove>
      if(rc == -1)
80103ab6:	83 c4 10             	add    $0x10,%esp
80103ab9:	83 f8 ff             	cmp    $0xffffffff,%eax
80103abc:	75 0d                	jne    80103acb <scheduler+0x6c>
        panic("The process wasn't removed from runnable state");  
80103abe:	83 ec 0c             	sub    $0xc,%esp
80103ac1:	68 10 79 10 80       	push   $0x80107910
80103ac6:	e8 79 c8 ff ff       	call   80100344 <panic>
      assertState(p, RUNNABLE); 
80103acb:	ba 03 00 00 00       	mov    $0x3,%edx
80103ad0:	89 d8                	mov    %ebx,%eax
80103ad2:	e8 db f7 ff ff       	call   801032b2 <assertState>
      p->state = RUNNING;
80103ad7:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      stateListAdd(&ptable.list[RUNNING], p);
80103ade:	89 da                	mov    %ebx,%edx
80103ae0:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103ae5:	e8 e4 f6 ff ff       	call   801031ce <stateListAdd>
      p->cpu_ticks_in = ticks;
80103aea:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80103aef:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
      swtch(&(c->scheduler), p->context);
80103af5:	83 ec 08             	sub    $0x8,%esp
80103af8:	ff 73 1c             	pushl  0x1c(%ebx)
80103afb:	57                   	push   %edi
80103afc:	e8 47 11 00 00       	call   80104c48 <swtch>
      switchkvm();
80103b01:	e8 9a 31 00 00       	call   80106ca0 <switchkvm>
      c->proc = 0;
80103b06:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b0d:	00 00 00 
    release(&ptable.lock);
80103b10:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103b17:	e8 00 0f 00 00       	call   80104a1c <release>
80103b1c:	83 c4 10             	add    $0x10,%esp
80103b1f:	e9 58 ff ff ff       	jmp    80103a7c <scheduler+0x1d>
80103b24:	83 ec 0c             	sub    $0xc,%esp
80103b27:	68 e0 a5 10 80       	push   $0x8010a5e0
80103b2c:	e8 eb 0e 00 00       	call   80104a1c <release>
80103b31:	fb                   	sti    

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
  asm volatile("hlt");
80103b32:	f4                   	hlt    
80103b33:	83 c4 10             	add    $0x10,%esp
80103b36:	e9 41 ff ff ff       	jmp    80103a7c <scheduler+0x1d>

80103b3b <sched>:
{
80103b3b:	55                   	push   %ebp
80103b3c:	89 e5                	mov    %esp,%ebp
80103b3e:	56                   	push   %esi
80103b3f:	53                   	push   %ebx
  struct proc *p = myproc();
80103b40:	e8 64 fa ff ff       	call   801035a9 <myproc>
80103b45:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103b47:	83 ec 0c             	sub    $0xc,%esp
80103b4a:	68 e0 a5 10 80       	push   $0x8010a5e0
80103b4f:	e8 2d 0e 00 00       	call   80104981 <holding>
80103b54:	83 c4 10             	add    $0x10,%esp
80103b57:	85 c0                	test   %eax,%eax
80103b59:	74 66                	je     80103bc1 <sched+0x86>
  if(mycpu()->ncli != 1)
80103b5b:	e8 b7 f9 ff ff       	call   80103517 <mycpu>
80103b60:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b67:	75 65                	jne    80103bce <sched+0x93>
  if(p->state == RUNNING)
80103b69:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b6d:	74 6c                	je     80103bdb <sched+0xa0>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b6f:	9c                   	pushf  
80103b70:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b71:	f6 c4 02             	test   $0x2,%ah
80103b74:	75 72                	jne    80103be8 <sched+0xad>
  intena = mycpu()->intena;
80103b76:	e8 9c f9 ff ff       	call   80103517 <mycpu>
80103b7b:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  p->cpu_ticks_total += ticks - p->cpu_ticks_in; //instance of ticks end - tick start
80103b81:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80103b86:	03 83 88 00 00 00    	add    0x88(%ebx),%eax
80103b8c:	2b 83 8c 00 00 00    	sub    0x8c(%ebx),%eax
80103b92:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  swtch(&p->context, mycpu()->scheduler);
80103b98:	e8 7a f9 ff ff       	call   80103517 <mycpu>
80103b9d:	83 ec 08             	sub    $0x8,%esp
80103ba0:	ff 70 04             	pushl  0x4(%eax)
80103ba3:	83 c3 1c             	add    $0x1c,%ebx
80103ba6:	53                   	push   %ebx
80103ba7:	e8 9c 10 00 00       	call   80104c48 <swtch>
  mycpu()->intena = intena;
80103bac:	e8 66 f9 ff ff       	call   80103517 <mycpu>
80103bb1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103bb7:	83 c4 10             	add    $0x10,%esp
80103bba:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bbd:	5b                   	pop    %ebx
80103bbe:	5e                   	pop    %esi
80103bbf:	5d                   	pop    %ebp
80103bc0:	c3                   	ret    
    panic("sched ptable.lock");
80103bc1:	83 ec 0c             	sub    $0xc,%esp
80103bc4:	68 c6 7a 10 80       	push   $0x80107ac6
80103bc9:	e8 76 c7 ff ff       	call   80100344 <panic>
    panic("sched locks");
80103bce:	83 ec 0c             	sub    $0xc,%esp
80103bd1:	68 d8 7a 10 80       	push   $0x80107ad8
80103bd6:	e8 69 c7 ff ff       	call   80100344 <panic>
    panic("sched running");
80103bdb:	83 ec 0c             	sub    $0xc,%esp
80103bde:	68 e4 7a 10 80       	push   $0x80107ae4
80103be3:	e8 5c c7 ff ff       	call   80100344 <panic>
    panic("sched interruptible");
80103be8:	83 ec 0c             	sub    $0xc,%esp
80103beb:	68 f2 7a 10 80       	push   $0x80107af2
80103bf0:	e8 4f c7 ff ff       	call   80100344 <panic>

80103bf5 <exit>:
{
80103bf5:	55                   	push   %ebp
80103bf6:	89 e5                	mov    %esp,%ebp
80103bf8:	57                   	push   %edi
80103bf9:	56                   	push   %esi
80103bfa:	53                   	push   %ebx
80103bfb:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103bfe:	e8 a6 f9 ff ff       	call   801035a9 <myproc>
80103c03:	89 c6                	mov    %eax,%esi
80103c05:	8d 58 28             	lea    0x28(%eax),%ebx
80103c08:	8d 78 68             	lea    0x68(%eax),%edi
  if(curproc == initproc)
80103c0b:	39 05 c0 a5 10 80    	cmp    %eax,0x8010a5c0
80103c11:	75 14                	jne    80103c27 <exit+0x32>
    panic("init exiting");
80103c13:	83 ec 0c             	sub    $0xc,%esp
80103c16:	68 06 7b 10 80       	push   $0x80107b06
80103c1b:	e8 24 c7 ff ff       	call   80100344 <panic>
80103c20:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103c23:	39 fb                	cmp    %edi,%ebx
80103c25:	74 1a                	je     80103c41 <exit+0x4c>
    if(curproc->ofile[fd]){
80103c27:	8b 03                	mov    (%ebx),%eax
80103c29:	85 c0                	test   %eax,%eax
80103c2b:	74 f3                	je     80103c20 <exit+0x2b>
      fileclose(curproc->ofile[fd]);
80103c2d:	83 ec 0c             	sub    $0xc,%esp
80103c30:	50                   	push   %eax
80103c31:	e8 6b d1 ff ff       	call   80100da1 <fileclose>
      curproc->ofile[fd] = 0;
80103c36:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c3c:	83 c4 10             	add    $0x10,%esp
80103c3f:	eb df                	jmp    80103c20 <exit+0x2b>
  begin_op();
80103c41:	e8 ee eb ff ff       	call   80102834 <begin_op>
  iput(curproc->cwd);
80103c46:	83 ec 0c             	sub    $0xc,%esp
80103c49:	ff 76 68             	pushl  0x68(%esi)
80103c4c:	e8 23 da ff ff       	call   80101674 <iput>
  end_op();
80103c51:	e8 59 ec ff ff       	call   801028af <end_op>
  curproc->cwd = 0;
80103c56:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103c5d:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103c64:	e8 4c 0d 00 00       	call   801049b5 <acquire>
  wakeup1(curproc->parent);
80103c69:	8b 46 14             	mov    0x14(%esi),%eax
80103c6c:	e8 74 f6 ff ff       	call   801032e5 <wakeup1>
80103c71:	83 c4 10             	add    $0x10,%esp
  for(int i = EMBRYO; i < statecount; ++i)
80103c74:	bf 01 00 00 00       	mov    $0x1,%edi
80103c79:	eb 70                	jmp    80103ceb <exit+0xf6>
      p = p -> next;
80103c7b:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
    while(p)
80103c81:	85 db                	test   %ebx,%ebx
80103c83:	74 5e                	je     80103ce3 <exit+0xee>
      if (p -> parent == curproc) 
80103c85:	39 73 14             	cmp    %esi,0x14(%ebx)
80103c88:	75 f1                	jne    80103c7b <exit+0x86>
        p -> parent = initproc;
80103c8a:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80103c8f:	89 43 14             	mov    %eax,0x14(%ebx)
        if (i == ZOMBIE)
80103c92:	83 ff 05             	cmp    $0x5,%edi
80103c95:	75 e4                	jne    80103c7b <exit+0x86>
          wakeup1(initproc);
80103c97:	e8 49 f6 ff ff       	call   801032e5 <wakeup1>
      p = p -> next;
80103c9c:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
    while(p)
80103ca2:	85 db                	test   %ebx,%ebx
80103ca4:	75 df                	jne    80103c85 <exit+0x90>
  stateListRemove(&ptable.list[RUNNING], curproc);
80103ca6:	89 f2                	mov    %esi,%edx
80103ca8:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103cad:	e8 56 f5 ff ff       	call   80103208 <stateListRemove>
  assertState(curproc, RUNNING);
80103cb2:	ba 04 00 00 00       	mov    $0x4,%edx
80103cb7:	89 f0                	mov    %esi,%eax
80103cb9:	e8 f4 f5 ff ff       	call   801032b2 <assertState>
  curproc->state = ZOMBIE;
80103cbe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  stateListAdd(&ptable.list[ZOMBIE], curproc);
80103cc5:	89 f2                	mov    %esi,%edx
80103cc7:	b8 3c cb 10 80       	mov    $0x8010cb3c,%eax
80103ccc:	e8 fd f4 ff ff       	call   801031ce <stateListAdd>
  sched();
80103cd1:	e8 65 fe ff ff       	call   80103b3b <sched>
  panic("zombie exit");
80103cd6:	83 ec 0c             	sub    $0xc,%esp
80103cd9:	68 13 7b 10 80       	push   $0x80107b13
80103cde:	e8 61 c6 ff ff       	call   80100344 <panic>
  for(int i = EMBRYO; i < statecount; ++i)
80103ce3:	83 c7 01             	add    $0x1,%edi
80103ce6:	83 ff 06             	cmp    $0x6,%edi
80103ce9:	74 bb                	je     80103ca6 <exit+0xb1>
    p = ptable.list[i].head;
80103ceb:	8b 1c fd 14 cb 10 80 	mov    -0x7fef34ec(,%edi,8),%ebx
    while(p)
80103cf2:	85 db                	test   %ebx,%ebx
80103cf4:	75 8f                	jne    80103c85 <exit+0x90>
80103cf6:	eb eb                	jmp    80103ce3 <exit+0xee>

80103cf8 <yield>:
{
80103cf8:	55                   	push   %ebp
80103cf9:	89 e5                	mov    %esp,%ebp
80103cfb:	53                   	push   %ebx
80103cfc:	83 ec 04             	sub    $0x4,%esp
  struct proc *curproc = myproc();
80103cff:	e8 a5 f8 ff ff       	call   801035a9 <myproc>
80103d04:	89 c3                	mov    %eax,%ebx
  acquire(&ptable.lock);  //DOC: yieldlock
80103d06:	83 ec 0c             	sub    $0xc,%esp
80103d09:	68 e0 a5 10 80       	push   $0x8010a5e0
80103d0e:	e8 a2 0c 00 00       	call   801049b5 <acquire>
  assertState(curproc, RUNNING);
80103d13:	ba 04 00 00 00       	mov    $0x4,%edx
80103d18:	89 d8                	mov    %ebx,%eax
80103d1a:	e8 93 f5 ff ff       	call   801032b2 <assertState>
  stateListRemove(&ptable.list[RUNNING], curproc);
80103d1f:	89 da                	mov    %ebx,%edx
80103d21:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103d26:	e8 dd f4 ff ff       	call   80103208 <stateListRemove>
  curproc->state = RUNNABLE;
80103d2b:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  stateListAdd(&ptable.list[RUNNABLE], curproc);
80103d32:	89 da                	mov    %ebx,%edx
80103d34:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
80103d39:	e8 90 f4 ff ff       	call   801031ce <stateListAdd>
  sched();
80103d3e:	e8 f8 fd ff ff       	call   80103b3b <sched>
  release(&ptable.lock);
80103d43:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103d4a:	e8 cd 0c 00 00       	call   80104a1c <release>
}
80103d4f:	83 c4 10             	add    $0x10,%esp
80103d52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d55:	c9                   	leave  
80103d56:	c3                   	ret    

80103d57 <sleep>:
{
80103d57:	55                   	push   %ebp
80103d58:	89 e5                	mov    %esp,%ebp
80103d5a:	57                   	push   %edi
80103d5b:	56                   	push   %esi
80103d5c:	53                   	push   %ebx
80103d5d:	83 ec 0c             	sub    $0xc,%esp
80103d60:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d63:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103d66:	e8 3e f8 ff ff       	call   801035a9 <myproc>
  if(p == 0)
80103d6b:	85 c0                	test   %eax,%eax
80103d6d:	0f 84 82 00 00 00    	je     80103df5 <sleep+0x9e>
80103d73:	89 c3                	mov    %eax,%ebx
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d75:	81 fe e0 a5 10 80    	cmp    $0x8010a5e0,%esi
80103d7b:	0f 84 81 00 00 00    	je     80103e02 <sleep+0xab>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d81:	83 ec 0c             	sub    $0xc,%esp
80103d84:	68 e0 a5 10 80       	push   $0x8010a5e0
80103d89:	e8 27 0c 00 00       	call   801049b5 <acquire>
    if (lk) release(lk);
80103d8e:	83 c4 10             	add    $0x10,%esp
80103d91:	85 f6                	test   %esi,%esi
80103d93:	0f 84 ab 00 00 00    	je     80103e44 <sleep+0xed>
80103d99:	83 ec 0c             	sub    $0xc,%esp
80103d9c:	56                   	push   %esi
80103d9d:	e8 7a 0c 00 00       	call   80104a1c <release>
  stateListRemove(&ptable.list[RUNNING], p);
80103da2:	89 da                	mov    %ebx,%edx
80103da4:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103da9:	e8 5a f4 ff ff       	call   80103208 <stateListRemove>
  assertState(p, RUNNING);
80103dae:	ba 04 00 00 00       	mov    $0x4,%edx
80103db3:	89 d8                	mov    %ebx,%eax
80103db5:	e8 f8 f4 ff ff       	call   801032b2 <assertState>
  p->chan = chan;
80103dba:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103dbd:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  stateListAdd(&ptable.list[SLEEPING], p);
80103dc4:	89 da                	mov    %ebx,%edx
80103dc6:	b8 24 cb 10 80       	mov    $0x8010cb24,%eax
80103dcb:	e8 fe f3 ff ff       	call   801031ce <stateListAdd>
  sched();
80103dd0:	e8 66 fd ff ff       	call   80103b3b <sched>
  p->chan = 0;
80103dd5:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ddc:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103de3:	e8 34 0c 00 00       	call   80104a1c <release>
    if (lk) acquire(lk);
80103de8:	89 34 24             	mov    %esi,(%esp)
80103deb:	e8 c5 0b 00 00       	call   801049b5 <acquire>
80103df0:	83 c4 10             	add    $0x10,%esp
}
80103df3:	eb 47                	jmp    80103e3c <sleep+0xe5>
    panic("sleep");
80103df5:	83 ec 0c             	sub    $0xc,%esp
80103df8:	68 1f 7b 10 80       	push   $0x80107b1f
80103dfd:	e8 42 c5 ff ff       	call   80100344 <panic>
  stateListRemove(&ptable.list[RUNNING], p);
80103e02:	89 c2                	mov    %eax,%edx
80103e04:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103e09:	e8 fa f3 ff ff       	call   80103208 <stateListRemove>
  assertState(p, RUNNING);
80103e0e:	ba 04 00 00 00       	mov    $0x4,%edx
80103e13:	89 d8                	mov    %ebx,%eax
80103e15:	e8 98 f4 ff ff       	call   801032b2 <assertState>
  p->chan = chan;
80103e1a:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e1d:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  stateListAdd(&ptable.list[SLEEPING], p);
80103e24:	89 da                	mov    %ebx,%edx
80103e26:	b8 24 cb 10 80       	mov    $0x8010cb24,%eax
80103e2b:	e8 9e f3 ff ff       	call   801031ce <stateListAdd>
  sched();
80103e30:	e8 06 fd ff ff       	call   80103b3b <sched>
  p->chan = 0;
80103e35:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e3f:	5b                   	pop    %ebx
80103e40:	5e                   	pop    %esi
80103e41:	5f                   	pop    %edi
80103e42:	5d                   	pop    %ebp
80103e43:	c3                   	ret    
  stateListRemove(&ptable.list[RUNNING], p);
80103e44:	89 da                	mov    %ebx,%edx
80103e46:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103e4b:	e8 b8 f3 ff ff       	call   80103208 <stateListRemove>
  assertState(p, RUNNING);
80103e50:	ba 04 00 00 00       	mov    $0x4,%edx
80103e55:	89 d8                	mov    %ebx,%eax
80103e57:	e8 56 f4 ff ff       	call   801032b2 <assertState>
  p->chan = chan;
80103e5c:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e5f:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  stateListAdd(&ptable.list[SLEEPING], p);
80103e66:	89 da                	mov    %ebx,%edx
80103e68:	b8 24 cb 10 80       	mov    $0x8010cb24,%eax
80103e6d:	e8 5c f3 ff ff       	call   801031ce <stateListAdd>
  sched();
80103e72:	e8 c4 fc ff ff       	call   80103b3b <sched>
  p->chan = 0;
80103e77:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103e7e:	83 ec 0c             	sub    $0xc,%esp
80103e81:	68 e0 a5 10 80       	push   $0x8010a5e0
80103e86:	e8 91 0b 00 00       	call   80104a1c <release>
80103e8b:	83 c4 10             	add    $0x10,%esp
80103e8e:	eb ac                	jmp    80103e3c <sleep+0xe5>

80103e90 <wait>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103e99:	e8 0b f7 ff ff       	call   801035a9 <myproc>
80103e9e:	89 c3                	mov    %eax,%ebx
  acquire(&ptable.lock);
80103ea0:	83 ec 0c             	sub    $0xc,%esp
80103ea3:	68 e0 a5 10 80       	push   $0x8010a5e0
80103ea8:	e8 08 0b 00 00       	call   801049b5 <acquire>
80103ead:	83 c4 10             	add    $0x10,%esp
    struct proc * p1 = ptable.list[EMBRYO].head;
80103eb0:	8b 3d 1c cb 10 80    	mov    0x8010cb1c,%edi
    struct proc * p2 = ptable.list[SLEEPING].head;
80103eb6:	8b 35 24 cb 10 80    	mov    0x8010cb24,%esi
    struct proc * p3 = ptable.list[RUNNABLE].head;
80103ebc:	8b 0d 2c cb 10 80    	mov    0x8010cb2c,%ecx
    struct proc * p4 = ptable.list[RUNNING].head; 
80103ec2:	8b 15 34 cb 10 80    	mov    0x8010cb34,%edx
    struct proc * p = ptable.list[ZOMBIE].head;
80103ec8:	a1 3c cb 10 80       	mov    0x8010cb3c,%eax
80103ecd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    while(p1) // Embryo list
80103ed0:	85 ff                	test   %edi,%edi
80103ed2:	0f 84 1d 01 00 00    	je     80103ff5 <wait+0x165>
    havekids = 0;
80103ed8:	b8 00 00 00 00       	mov    $0x0,%eax
80103edd:	89 55 e0             	mov    %edx,-0x20(%ebp)
      if(p1->parent == curproc)
80103ee0:	39 5f 14             	cmp    %ebx,0x14(%edi)
        havekids = 1;  
80103ee3:	ba 01 00 00 00       	mov    $0x1,%edx
80103ee8:	0f 44 c2             	cmove  %edx,%eax
      p1 = p1 -> next;
80103eeb:	8b bf 90 00 00 00    	mov    0x90(%edi),%edi
    while(p1) // Embryo list
80103ef1:	85 ff                	test   %edi,%edi
80103ef3:	75 eb                	jne    80103ee0 <wait+0x50>
80103ef5:	8b 55 e0             	mov    -0x20(%ebp),%edx
    while(p2) // Sleeping list
80103ef8:	85 f6                	test   %esi,%esi
80103efa:	74 15                	je     80103f11 <wait+0x81>
      if(p2->parent == curproc)
80103efc:	39 5e 14             	cmp    %ebx,0x14(%esi)
        havekids = 1;  
80103eff:	bf 01 00 00 00       	mov    $0x1,%edi
80103f04:	0f 44 c7             	cmove  %edi,%eax
      p2 = p2 -> next;
80103f07:	8b b6 90 00 00 00    	mov    0x90(%esi),%esi
    while(p2) // Sleeping list
80103f0d:	85 f6                	test   %esi,%esi
80103f0f:	75 eb                	jne    80103efc <wait+0x6c>
    while(p3) // Runnable list
80103f11:	85 c9                	test   %ecx,%ecx
80103f13:	74 15                	je     80103f2a <wait+0x9a>
      if(p3->parent == curproc)
80103f15:	39 59 14             	cmp    %ebx,0x14(%ecx)
        havekids = 1;  
80103f18:	be 01 00 00 00       	mov    $0x1,%esi
80103f1d:	0f 44 c6             	cmove  %esi,%eax
      p3 = p3 -> next;
80103f20:	8b 89 90 00 00 00    	mov    0x90(%ecx),%ecx
    while(p3) // Runnable list
80103f26:	85 c9                	test   %ecx,%ecx
80103f28:	75 eb                	jne    80103f15 <wait+0x85>
    while(p4) // Running list
80103f2a:	85 d2                	test   %edx,%edx
80103f2c:	74 15                	je     80103f43 <wait+0xb3>
      if(p4->parent == curproc)
80103f2e:	39 5a 14             	cmp    %ebx,0x14(%edx)
        havekids = 1;  
80103f31:	b9 01 00 00 00       	mov    $0x1,%ecx
80103f36:	0f 44 c1             	cmove  %ecx,%eax
      p4 = p4 -> next;
80103f39:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
    while(p4) // Running list
80103f3f:	85 d2                	test   %edx,%edx
80103f41:	75 eb                	jne    80103f2e <wait+0x9e>
    while(p) // If child is in zombie list, remove it. 
80103f43:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103f46:	85 ff                	test   %edi,%edi
80103f48:	0f 84 c5 00 00 00    	je     80104013 <wait+0x183>
      if(p->parent == curproc) 
80103f4e:	3b 5f 14             	cmp    0x14(%edi),%ebx
80103f51:	0f 84 a8 00 00 00    	je     80103fff <wait+0x16f>
80103f57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      p = p->next;
80103f5a:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
    while(p) // If child is in zombie list, remove it. 
80103f60:	85 d2                	test   %edx,%edx
80103f62:	0f 84 ab 00 00 00    	je     80104013 <wait+0x183>
      if(p->parent == curproc) 
80103f68:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f6b:	75 ed                	jne    80103f5a <wait+0xca>
80103f6d:	89 d6                	mov    %edx,%esi
        int rc = stateListRemove(&ptable.list[ZOMBIE], p);
80103f6f:	89 f2                	mov    %esi,%edx
80103f71:	b8 3c cb 10 80       	mov    $0x8010cb3c,%eax
80103f76:	e8 8d f2 ff ff       	call   80103208 <stateListRemove>
        if(rc == -1)
80103f7b:	83 f8 ff             	cmp    $0xffffffff,%eax
80103f7e:	0f 84 82 00 00 00    	je     80104006 <wait+0x176>
        assertState(p, ZOMBIE); 
80103f84:	ba 05 00 00 00       	mov    $0x5,%edx
80103f89:	89 f0                	mov    %esi,%eax
80103f8b:	e8 22 f3 ff ff       	call   801032b2 <assertState>
        pid = p->pid;
80103f90:	8b 5e 10             	mov    0x10(%esi),%ebx
        kfree(p->kstack);
80103f93:	83 ec 0c             	sub    $0xc,%esp
80103f96:	ff 76 08             	pushl  0x8(%esi)
80103f99:	e8 22 e1 ff ff       	call   801020c0 <kfree>
        p->kstack = 0;
80103f9e:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
        freevm(p->pgdir);
80103fa5:	83 c4 04             	add    $0x4,%esp
80103fa8:	ff 76 04             	pushl  0x4(%esi)
80103fab:	e8 94 30 00 00       	call   80107044 <freevm>
        p->state = UNUSED; 
80103fb0:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
        stateListAdd(&ptable.list[UNUSED], p);
80103fb7:	89 f2                	mov    %esi,%edx
80103fb9:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
80103fbe:	e8 0b f2 ff ff       	call   801031ce <stateListAdd>
        p->pid = 0;
80103fc3:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
        p->parent = 0;
80103fca:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
        p->name[0] = 0;
80103fd1:	c6 46 6c 00          	movb   $0x0,0x6c(%esi)
        p->killed = 0;
80103fd5:	c7 46 24 00 00 00 00 	movl   $0x0,0x24(%esi)
        release(&ptable.lock);
80103fdc:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103fe3:	e8 34 0a 00 00       	call   80104a1c <release>
        return pid;
80103fe8:	89 d8                	mov    %ebx,%eax
80103fea:	83 c4 10             	add    $0x10,%esp
}
80103fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ff0:	5b                   	pop    %ebx
80103ff1:	5e                   	pop    %esi
80103ff2:	5f                   	pop    %edi
80103ff3:	5d                   	pop    %ebp
80103ff4:	c3                   	ret    
    havekids = 0;
80103ff5:	b8 00 00 00 00       	mov    $0x0,%eax
80103ffa:	e9 f9 fe ff ff       	jmp    80103ef8 <wait+0x68>
80103fff:	89 fe                	mov    %edi,%esi
80104001:	e9 69 ff ff ff       	jmp    80103f6f <wait+0xdf>
          panic("ERROR NOT IN ZOMBIE"); 
80104006:	83 ec 0c             	sub    $0xc,%esp
80104009:	68 25 7b 10 80       	push   $0x80107b25
8010400e:	e8 31 c3 ff ff       	call   80100344 <panic>
    if(!havekids || curproc->killed){
80104013:	85 c0                	test   %eax,%eax
80104015:	74 1c                	je     80104033 <wait+0x1a3>
80104017:	83 7b 24 00          	cmpl   $0x0,0x24(%ebx)
8010401b:	75 16                	jne    80104033 <wait+0x1a3>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010401d:	83 ec 08             	sub    $0x8,%esp
80104020:	68 e0 a5 10 80       	push   $0x8010a5e0
80104025:	53                   	push   %ebx
80104026:	e8 2c fd ff ff       	call   80103d57 <sleep>
  for(;;){
8010402b:	83 c4 10             	add    $0x10,%esp
8010402e:	e9 7d fe ff ff       	jmp    80103eb0 <wait+0x20>
      release(&ptable.lock);
80104033:	83 ec 0c             	sub    $0xc,%esp
80104036:	68 e0 a5 10 80       	push   $0x8010a5e0
8010403b:	e8 dc 09 00 00       	call   80104a1c <release>
      return -1;
80104040:	83 c4 10             	add    $0x10,%esp
80104043:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104048:	eb a3                	jmp    80103fed <wait+0x15d>

8010404a <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010404a:	55                   	push   %ebp
8010404b:	89 e5                	mov    %esp,%ebp
8010404d:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80104050:	68 e0 a5 10 80       	push   $0x8010a5e0
80104055:	e8 5b 09 00 00       	call   801049b5 <acquire>
  wakeup1(chan);
8010405a:	8b 45 08             	mov    0x8(%ebp),%eax
8010405d:	e8 83 f2 ff ff       	call   801032e5 <wakeup1>
  release(&ptable.lock);
80104062:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80104069:	e8 ae 09 00 00       	call   80104a1c <release>
}
8010406e:	83 c4 10             	add    $0x10,%esp
80104071:	c9                   	leave  
80104072:	c3                   	ret    

80104073 <kill>:

#ifdef CS333_P3
// New implementation of kill
int
kill(int pid)
{
80104073:	55                   	push   %ebp
80104074:	89 e5                	mov    %esp,%ebp
80104076:	53                   	push   %ebx
80104077:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010407a:	68 e0 a5 10 80       	push   $0x8010a5e0
8010407f:	e8 31 09 00 00       	call   801049b5 <acquire>
80104084:	83 c4 10             	add    $0x10,%esp

  for(int i = EMBRYO; i < statecount; ++i)
80104087:	b8 01 00 00 00       	mov    $0x1,%eax
  {
    p = ptable.list[i].head;
8010408c:	8b 1c c5 14 cb 10 80 	mov    -0x7fef34ec(,%eax,8),%ebx
    while(p)
80104093:	85 db                	test   %ebx,%ebx
80104095:	74 5d                	je     801040f4 <kill+0x81>
    {
      if(p -> pid == pid)
80104097:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010409a:	39 4b 10             	cmp    %ecx,0x10(%ebx)
8010409d:	74 02                	je     801040a1 <kill+0x2e>
8010409f:	eb fe                	jmp    8010409f <kill+0x2c>
      {
        p -> killed = 1;
801040a1:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
        // Wake process from sleep if necessary.
        if(i == SLEEPING)
801040a8:	83 f8 02             	cmp    $0x2,%eax
801040ab:	74 1a                	je     801040c7 <kill+0x54>
          stateListRemove(&ptable.list[SLEEPING], p);
          assertState(p, SLEEPING);
          p->state = RUNNABLE;
          stateListAdd(&ptable.list[RUNNABLE], p);
         }
        release(&ptable.lock);
801040ad:	83 ec 0c             	sub    $0xc,%esp
801040b0:	68 e0 a5 10 80       	push   $0x8010a5e0
801040b5:	e8 62 09 00 00       	call   80104a1c <release>
        return 0;
801040ba:	83 c4 10             	add    $0x10,%esp
801040bd:	b8 00 00 00 00       	mov    $0x0,%eax
       }
     }
  }
  release(&ptable.lock);
  return -1;
}
801040c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040c5:	c9                   	leave  
801040c6:	c3                   	ret    
          stateListRemove(&ptable.list[SLEEPING], p);
801040c7:	89 da                	mov    %ebx,%edx
801040c9:	b8 24 cb 10 80       	mov    $0x8010cb24,%eax
801040ce:	e8 35 f1 ff ff       	call   80103208 <stateListRemove>
          assertState(p, SLEEPING);
801040d3:	ba 02 00 00 00       	mov    $0x2,%edx
801040d8:	89 d8                	mov    %ebx,%eax
801040da:	e8 d3 f1 ff ff       	call   801032b2 <assertState>
          p->state = RUNNABLE;
801040df:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
          stateListAdd(&ptable.list[RUNNABLE], p);
801040e6:	89 da                	mov    %ebx,%edx
801040e8:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
801040ed:	e8 dc f0 ff ff       	call   801031ce <stateListAdd>
801040f2:	eb b9                	jmp    801040ad <kill+0x3a>
  for(int i = EMBRYO; i < statecount; ++i)
801040f4:	83 c0 01             	add    $0x1,%eax
801040f7:	83 f8 06             	cmp    $0x6,%eax
801040fa:	75 90                	jne    8010408c <kill+0x19>
  release(&ptable.lock);
801040fc:	83 ec 0c             	sub    $0xc,%esp
801040ff:	68 e0 a5 10 80       	push   $0x8010a5e0
80104104:	e8 13 09 00 00       	call   80104a1c <release>
  return -1;
80104109:	83 c4 10             	add    $0x10,%esp
8010410c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104111:	eb af                	jmp    801040c2 <kill+0x4f>

80104113 <procdumpP1>:

//Control-P implmeentation for Project 1. Wrapper for procdump.
#ifdef CS333_P1
void
procdumpP1(struct proc *p, char *state)
{
80104113:	55                   	push   %ebp
80104114:	89 e5                	mov    %esp,%ebp
80104116:	57                   	push   %edi
80104117:	56                   	push   %esi
80104118:	53                   	push   %ebx
80104119:	83 ec 0c             	sub    $0xc,%esp
8010411c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int seconds;
  int millisec; 

  // Put equation for ticks here to make it into seconds
  seconds = ticks - p->start_ticks;     // Find the Seconds
8010411f:	8b 0d c0 5a 11 80    	mov    0x80115ac0,%ecx
80104125:	2b 4f 7c             	sub    0x7c(%edi),%ecx
  millisec = seconds%1000;               // Find the millisecond after decimal
80104128:	bb d3 4d 62 10       	mov    $0x10624dd3,%ebx
8010412d:	89 c8                	mov    %ecx,%eax
8010412f:	f7 eb                	imul   %ebx
80104131:	89 d3                	mov    %edx,%ebx
80104133:	c1 fb 06             	sar    $0x6,%ebx
80104136:	89 c8                	mov    %ecx,%eax
80104138:	c1 f8 1f             	sar    $0x1f,%eax
8010413b:	89 de                	mov    %ebx,%esi
8010413d:	29 c6                	sub    %eax,%esi
8010413f:	69 f6 e8 03 00 00    	imul   $0x3e8,%esi,%esi
80104145:	29 f1                	sub    %esi,%ecx
80104147:	89 ce                	mov    %ecx,%esi
  seconds = seconds/1000;               // Convert to actual seconds
80104149:	29 c3                	sub    %eax,%ebx

  if(millisec < 10)
8010414b:	83 f9 09             	cmp    $0x9,%ecx
8010414e:	7e 12                	jle    80104162 <procdumpP1+0x4f>
      cprintf("%d\t%s\t%d.00%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10

  if(millisec < 100)
80104150:	83 fe 63             	cmp    $0x63,%esi
80104153:	7e 2d                	jle    80104182 <procdumpP1+0x6f>
      cprintf("%d\t%s\t%d.0%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10

  if(millisec > 100)
80104155:	83 fe 64             	cmp    $0x64,%esi
80104158:	7f 48                	jg     801041a2 <procdumpP1+0x8f>
      cprintf("%d\t%s\t%d.%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10
}
8010415a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010415d:	5b                   	pop    %ebx
8010415e:	5e                   	pop    %esi
8010415f:	5f                   	pop    %edi
80104160:	5d                   	pop    %ebp
80104161:	c3                   	ret    
      cprintf("%d\t%s\t%d.00%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10
80104162:	83 ec 04             	sub    $0x4,%esp
80104165:	ff 37                	pushl  (%edi)
80104167:	ff 75 0c             	pushl  0xc(%ebp)
8010416a:	51                   	push   %ecx
8010416b:	53                   	push   %ebx
8010416c:	8d 47 6c             	lea    0x6c(%edi),%eax
8010416f:	50                   	push   %eax
80104170:	ff 77 10             	pushl  0x10(%edi)
80104173:	68 39 7b 10 80       	push   $0x80107b39
80104178:	e8 64 c4 ff ff       	call   801005e1 <cprintf>
8010417d:	83 c4 20             	add    $0x20,%esp
80104180:	eb ce                	jmp    80104150 <procdumpP1+0x3d>
      cprintf("%d\t%s\t%d.0%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10
80104182:	83 ec 04             	sub    $0x4,%esp
80104185:	ff 37                	pushl  (%edi)
80104187:	ff 75 0c             	pushl  0xc(%ebp)
8010418a:	56                   	push   %esi
8010418b:	53                   	push   %ebx
8010418c:	8d 47 6c             	lea    0x6c(%edi),%eax
8010418f:	50                   	push   %eax
80104190:	ff 77 10             	pushl  0x10(%edi)
80104193:	68 4e 7b 10 80       	push   $0x80107b4e
80104198:	e8 44 c4 ff ff       	call   801005e1 <cprintf>
8010419d:	83 c4 20             	add    $0x20,%esp
801041a0:	eb b3                	jmp    80104155 <procdumpP1+0x42>
      cprintf("%d\t%s\t%d.%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10
801041a2:	83 ec 04             	sub    $0x4,%esp
801041a5:	ff 37                	pushl  (%edi)
801041a7:	ff 75 0c             	pushl  0xc(%ebp)
801041aa:	56                   	push   %esi
801041ab:	53                   	push   %ebx
801041ac:	8d 47 6c             	lea    0x6c(%edi),%eax
801041af:	50                   	push   %eax
801041b0:	ff 77 10             	pushl  0x10(%edi)
801041b3:	68 62 7b 10 80       	push   $0x80107b62
801041b8:	e8 24 c4 ff ff       	call   801005e1 <cprintf>
801041bd:	83 c4 20             	add    $0x20,%esp
}
801041c0:	eb 98                	jmp    8010415a <procdumpP1+0x47>

801041c2 <procdumpP2>:

#ifdef CS333_P2
//Control-P implementation for Project 2. Wrapper for procdump.
void
procdumpP2(struct proc *p, char *state)
{
801041c2:	55                   	push   %ebp
801041c3:	89 e5                	mov    %esp,%ebp
801041c5:	57                   	push   %edi
801041c6:	56                   	push   %esi
801041c7:	53                   	push   %ebx
801041c8:	83 ec 28             	sub    $0x28,%esp
801041cb:	8b 75 08             	mov    0x8(%ebp),%esi
  // Put equation for ticks here to make it into seconds
  int seconds = ticks - p->start_ticks;     // Find the Seconds
801041ce:	8b 0d c0 5a 11 80    	mov    0x80115ac0,%ecx
801041d4:	2b 4e 7c             	sub    0x7c(%esi),%ecx
  int millisec = seconds%1000;               // Find the millisecond after decimal
801041d7:	89 c8                	mov    %ecx,%eax
801041d9:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
801041de:	f7 ef                	imul   %edi
801041e0:	c1 fa 06             	sar    $0x6,%edx
801041e3:	89 c8                	mov    %ecx,%eax
801041e5:	c1 f8 1f             	sar    $0x1f,%eax
801041e8:	89 d7                	mov    %edx,%edi
801041ea:	29 c7                	sub    %eax,%edi
801041ec:	69 ff e8 03 00 00    	imul   $0x3e8,%edi,%edi
801041f2:	89 cb                	mov    %ecx,%ebx
801041f4:	29 fb                	sub    %edi,%ebx
801041f6:	89 df                	mov    %ebx,%edi
  seconds = seconds/1000;               // Convert to actual seconds
801041f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801041fb:	29 c2                	sub    %eax,%edx
801041fd:	89 55 e0             	mov    %edx,-0x20(%ebp)

  int cpu_seconds = p->cpu_ticks_total/1000;    
  int cpu_millisec = p->cpu_ticks_total%1000;   
80104200:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
80104205:	f7 a6 88 00 00 00    	mull   0x88(%esi)
8010420b:	89 d3                	mov    %edx,%ebx
8010420d:	c1 eb 06             	shr    $0x6,%ebx
80104210:	69 db e8 03 00 00    	imul   $0x3e8,%ebx,%ebx
80104216:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
8010421c:	29 da                	sub    %ebx,%edx
8010421e:	89 d3                	mov    %edx,%ebx
  cpu_seconds = seconds/1000;             
80104220:	ba 83 de 1b 43       	mov    $0x431bde83,%edx
80104225:	89 c8                	mov    %ecx,%eax
80104227:	f7 ea                	imul   %edx
80104229:	c1 fa 12             	sar    $0x12,%edx
8010422c:	2b 55 e4             	sub    -0x1c(%ebp),%edx
8010422f:	89 55 e4             	mov    %edx,-0x1c(%ebp)

  cprintf("%d\t%s\t%d\t%d\t", p->pid, p->name, p->uid, p->gid);
80104232:	ff b6 84 00 00 00    	pushl  0x84(%esi)
80104238:	ff b6 80 00 00 00    	pushl  0x80(%esi)
8010423e:	8d 46 6c             	lea    0x6c(%esi),%eax
80104241:	50                   	push   %eax
80104242:	ff 76 10             	pushl  0x10(%esi)
80104245:	68 75 7b 10 80       	push   $0x80107b75
8010424a:	e8 92 c3 ff ff       	call   801005e1 <cprintf>
  
  //Parent check. Are we in the INIT process?
  if(p->parent == NULL)
8010424f:	8b 46 14             	mov    0x14(%esi),%eax
80104252:	83 c4 20             	add    $0x20,%esp
80104255:	85 c0                	test   %eax,%eax
80104257:	74 41                	je     8010429a <procdumpP2+0xd8>
    cprintf("%d\t", p->pid);
  else
    cprintf("%d\t", p->parent->pid);
80104259:	83 ec 08             	sub    $0x8,%esp
8010425c:	ff 70 10             	pushl  0x10(%eax)
8010425f:	68 7e 7b 10 80       	push   $0x80107b7e
80104264:	e8 78 c3 ff ff       	call   801005e1 <cprintf>
80104269:	83 c4 10             	add    $0x10,%esp

  if(millisec < 10)
8010426c:	83 ff 09             	cmp    $0x9,%edi
8010426f:	7e 3e                	jle    801042af <procdumpP2+0xed>
    cprintf("%d.00%d\t", seconds, millisec);

  if(millisec < 100)
80104271:	83 ff 63             	cmp    $0x63,%edi
80104274:	7e 4f                	jle    801042c5 <procdumpP2+0x103>
    cprintf("%d.0%d\t", seconds, millisec);

  if(millisec > 100)
80104276:	83 ff 64             	cmp    $0x64,%edi
80104279:	7f 60                	jg     801042db <procdumpP2+0x119>
    cprintf("%d.%d\t", seconds, millisec);

  if(cpu_millisec < 10)
8010427b:	83 fb 09             	cmp    $0x9,%ebx
8010427e:	7e 71                	jle    801042f1 <procdumpP2+0x12f>
    cprintf("%d.00%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec < 100)
80104280:	83 fb 63             	cmp    $0x63,%ebx
80104283:	0f 8e 86 00 00 00    	jle    8010430f <procdumpP2+0x14d>
    cprintf("%d.0%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec > 100)
80104289:	83 fb 64             	cmp    $0x64,%ebx
8010428c:	0f 8f 9b 00 00 00    	jg     8010432d <procdumpP2+0x16b>
    cprintf("%d.%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
}
80104292:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104295:	5b                   	pop    %ebx
80104296:	5e                   	pop    %esi
80104297:	5f                   	pop    %edi
80104298:	5d                   	pop    %ebp
80104299:	c3                   	ret    
    cprintf("%d\t", p->pid);
8010429a:	83 ec 08             	sub    $0x8,%esp
8010429d:	ff 76 10             	pushl  0x10(%esi)
801042a0:	68 7e 7b 10 80       	push   $0x80107b7e
801042a5:	e8 37 c3 ff ff       	call   801005e1 <cprintf>
801042aa:	83 c4 10             	add    $0x10,%esp
801042ad:	eb bd                	jmp    8010426c <procdumpP2+0xaa>
    cprintf("%d.00%d\t", seconds, millisec);
801042af:	83 ec 04             	sub    $0x4,%esp
801042b2:	57                   	push   %edi
801042b3:	ff 75 e0             	pushl  -0x20(%ebp)
801042b6:	68 82 7b 10 80       	push   $0x80107b82
801042bb:	e8 21 c3 ff ff       	call   801005e1 <cprintf>
801042c0:	83 c4 10             	add    $0x10,%esp
801042c3:	eb ac                	jmp    80104271 <procdumpP2+0xaf>
    cprintf("%d.0%d\t", seconds, millisec);
801042c5:	83 ec 04             	sub    $0x4,%esp
801042c8:	57                   	push   %edi
801042c9:	ff 75 e0             	pushl  -0x20(%ebp)
801042cc:	68 8b 7b 10 80       	push   $0x80107b8b
801042d1:	e8 0b c3 ff ff       	call   801005e1 <cprintf>
801042d6:	83 c4 10             	add    $0x10,%esp
801042d9:	eb 9b                	jmp    80104276 <procdumpP2+0xb4>
    cprintf("%d.%d\t", seconds, millisec);
801042db:	83 ec 04             	sub    $0x4,%esp
801042de:	57                   	push   %edi
801042df:	ff 75 e0             	pushl  -0x20(%ebp)
801042e2:	68 93 7b 10 80       	push   $0x80107b93
801042e7:	e8 f5 c2 ff ff       	call   801005e1 <cprintf>
801042ec:	83 c4 10             	add    $0x10,%esp
801042ef:	eb 8a                	jmp    8010427b <procdumpP2+0xb9>
    cprintf("%d.00%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
801042f1:	83 ec 0c             	sub    $0xc,%esp
801042f4:	ff 36                	pushl  (%esi)
801042f6:	ff 75 0c             	pushl  0xc(%ebp)
801042f9:	53                   	push   %ebx
801042fa:	ff 75 e4             	pushl  -0x1c(%ebp)
801042fd:	68 3f 7b 10 80       	push   $0x80107b3f
80104302:	e8 da c2 ff ff       	call   801005e1 <cprintf>
80104307:	83 c4 20             	add    $0x20,%esp
8010430a:	e9 71 ff ff ff       	jmp    80104280 <procdumpP2+0xbe>
    cprintf("%d.0%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
8010430f:	83 ec 0c             	sub    $0xc,%esp
80104312:	ff 36                	pushl  (%esi)
80104314:	ff 75 0c             	pushl  0xc(%ebp)
80104317:	53                   	push   %ebx
80104318:	ff 75 e4             	pushl  -0x1c(%ebp)
8010431b:	68 54 7b 10 80       	push   $0x80107b54
80104320:	e8 bc c2 ff ff       	call   801005e1 <cprintf>
80104325:	83 c4 20             	add    $0x20,%esp
80104328:	e9 5c ff ff ff       	jmp    80104289 <procdumpP2+0xc7>
    cprintf("%d.%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
8010432d:	83 ec 0c             	sub    $0xc,%esp
80104330:	ff 36                	pushl  (%esi)
80104332:	ff 75 0c             	pushl  0xc(%ebp)
80104335:	53                   	push   %ebx
80104336:	ff 75 e4             	pushl  -0x1c(%ebp)
80104339:	68 68 7b 10 80       	push   $0x80107b68
8010433e:	e8 9e c2 ff ff       	call   801005e1 <cprintf>
80104343:	83 c4 20             	add    $0x20,%esp
}
80104346:	e9 47 ff ff ff       	jmp    80104292 <procdumpP2+0xd0>

8010434b <procdumpP3>:

//Control-P implementation for Project 3. Wrapper for procdump.
#ifdef CS333_P3
void
procdumpP3(struct proc *p, char *state)
{
8010434b:	55                   	push   %ebp
8010434c:	89 e5                	mov    %esp,%ebp
8010434e:	57                   	push   %edi
8010434f:	56                   	push   %esi
80104350:	53                   	push   %ebx
80104351:	83 ec 28             	sub    $0x28,%esp
80104354:	8b 75 08             	mov    0x8(%ebp),%esi
// Put equation for ticks here to make it into seconds
  int seconds = ticks - p->start_ticks;     // Find the Seconds
80104357:	8b 0d c0 5a 11 80    	mov    0x80115ac0,%ecx
8010435d:	2b 4e 7c             	sub    0x7c(%esi),%ecx
  int millisec = seconds%1000;               // Find the millisecond after decimal
80104360:	89 c8                	mov    %ecx,%eax
80104362:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
80104367:	f7 ef                	imul   %edi
80104369:	c1 fa 06             	sar    $0x6,%edx
8010436c:	89 c8                	mov    %ecx,%eax
8010436e:	c1 f8 1f             	sar    $0x1f,%eax
80104371:	89 d7                	mov    %edx,%edi
80104373:	29 c7                	sub    %eax,%edi
80104375:	69 ff e8 03 00 00    	imul   $0x3e8,%edi,%edi
8010437b:	89 cb                	mov    %ecx,%ebx
8010437d:	29 fb                	sub    %edi,%ebx
8010437f:	89 df                	mov    %ebx,%edi
  seconds = seconds/1000;               // Convert to actual seconds
80104381:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104384:	29 c2                	sub    %eax,%edx
80104386:	89 55 e0             	mov    %edx,-0x20(%ebp)

  int cpu_seconds = p->cpu_ticks_total/1000;    
  int cpu_millisec = p->cpu_ticks_total%1000;   
80104389:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
8010438e:	f7 a6 88 00 00 00    	mull   0x88(%esi)
80104394:	89 d3                	mov    %edx,%ebx
80104396:	c1 eb 06             	shr    $0x6,%ebx
80104399:	69 db e8 03 00 00    	imul   $0x3e8,%ebx,%ebx
8010439f:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
801043a5:	29 da                	sub    %ebx,%edx
801043a7:	89 d3                	mov    %edx,%ebx
  cpu_seconds = seconds/1000;             
801043a9:	ba 83 de 1b 43       	mov    $0x431bde83,%edx
801043ae:	89 c8                	mov    %ecx,%eax
801043b0:	f7 ea                	imul   %edx
801043b2:	c1 fa 12             	sar    $0x12,%edx
801043b5:	2b 55 e4             	sub    -0x1c(%ebp),%edx
801043b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)

  cprintf("%d\t%s\t%d\t%d\t", p->pid, p->name, p->uid, p->gid);
801043bb:	ff b6 84 00 00 00    	pushl  0x84(%esi)
801043c1:	ff b6 80 00 00 00    	pushl  0x80(%esi)
801043c7:	8d 46 6c             	lea    0x6c(%esi),%eax
801043ca:	50                   	push   %eax
801043cb:	ff 76 10             	pushl  0x10(%esi)
801043ce:	68 75 7b 10 80       	push   $0x80107b75
801043d3:	e8 09 c2 ff ff       	call   801005e1 <cprintf>
  
  //Parent check. Are we in the INIT process?
  if(p->parent == NULL)
801043d8:	8b 46 14             	mov    0x14(%esi),%eax
801043db:	83 c4 20             	add    $0x20,%esp
801043de:	85 c0                	test   %eax,%eax
801043e0:	74 41                	je     80104423 <procdumpP3+0xd8>
    cprintf("%d\t", p->pid);
  else
    cprintf("%d\t", p->parent->pid);
801043e2:	83 ec 08             	sub    $0x8,%esp
801043e5:	ff 70 10             	pushl  0x10(%eax)
801043e8:	68 7e 7b 10 80       	push   $0x80107b7e
801043ed:	e8 ef c1 ff ff       	call   801005e1 <cprintf>
801043f2:	83 c4 10             	add    $0x10,%esp

  if(millisec < 10)
801043f5:	83 ff 09             	cmp    $0x9,%edi
801043f8:	7e 3e                	jle    80104438 <procdumpP3+0xed>
    cprintf("%d.00%d\t", seconds, millisec);

  if(millisec < 100)
801043fa:	83 ff 63             	cmp    $0x63,%edi
801043fd:	7e 4f                	jle    8010444e <procdumpP3+0x103>
    cprintf("%d.0%d\t", seconds, millisec);

  if(millisec > 100)
801043ff:	83 ff 64             	cmp    $0x64,%edi
80104402:	7f 60                	jg     80104464 <procdumpP3+0x119>
    cprintf("%d.%d\t", seconds, millisec);

  if(cpu_millisec < 10)
80104404:	83 fb 09             	cmp    $0x9,%ebx
80104407:	7e 71                	jle    8010447a <procdumpP3+0x12f>
    cprintf("%d.00%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec < 100)
80104409:	83 fb 63             	cmp    $0x63,%ebx
8010440c:	0f 8e 86 00 00 00    	jle    80104498 <procdumpP3+0x14d>
    cprintf("%d.0%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec > 100)
80104412:	83 fb 64             	cmp    $0x64,%ebx
80104415:	0f 8f 9b 00 00 00    	jg     801044b6 <procdumpP3+0x16b>
    cprintf("%d.%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
}
8010441b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010441e:	5b                   	pop    %ebx
8010441f:	5e                   	pop    %esi
80104420:	5f                   	pop    %edi
80104421:	5d                   	pop    %ebp
80104422:	c3                   	ret    
    cprintf("%d\t", p->pid);
80104423:	83 ec 08             	sub    $0x8,%esp
80104426:	ff 76 10             	pushl  0x10(%esi)
80104429:	68 7e 7b 10 80       	push   $0x80107b7e
8010442e:	e8 ae c1 ff ff       	call   801005e1 <cprintf>
80104433:	83 c4 10             	add    $0x10,%esp
80104436:	eb bd                	jmp    801043f5 <procdumpP3+0xaa>
    cprintf("%d.00%d\t", seconds, millisec);
80104438:	83 ec 04             	sub    $0x4,%esp
8010443b:	57                   	push   %edi
8010443c:	ff 75 e0             	pushl  -0x20(%ebp)
8010443f:	68 82 7b 10 80       	push   $0x80107b82
80104444:	e8 98 c1 ff ff       	call   801005e1 <cprintf>
80104449:	83 c4 10             	add    $0x10,%esp
8010444c:	eb ac                	jmp    801043fa <procdumpP3+0xaf>
    cprintf("%d.0%d\t", seconds, millisec);
8010444e:	83 ec 04             	sub    $0x4,%esp
80104451:	57                   	push   %edi
80104452:	ff 75 e0             	pushl  -0x20(%ebp)
80104455:	68 8b 7b 10 80       	push   $0x80107b8b
8010445a:	e8 82 c1 ff ff       	call   801005e1 <cprintf>
8010445f:	83 c4 10             	add    $0x10,%esp
80104462:	eb 9b                	jmp    801043ff <procdumpP3+0xb4>
    cprintf("%d.%d\t", seconds, millisec);
80104464:	83 ec 04             	sub    $0x4,%esp
80104467:	57                   	push   %edi
80104468:	ff 75 e0             	pushl  -0x20(%ebp)
8010446b:	68 93 7b 10 80       	push   $0x80107b93
80104470:	e8 6c c1 ff ff       	call   801005e1 <cprintf>
80104475:	83 c4 10             	add    $0x10,%esp
80104478:	eb 8a                	jmp    80104404 <procdumpP3+0xb9>
    cprintf("%d.00%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
8010447a:	83 ec 0c             	sub    $0xc,%esp
8010447d:	ff 36                	pushl  (%esi)
8010447f:	ff 75 0c             	pushl  0xc(%ebp)
80104482:	53                   	push   %ebx
80104483:	ff 75 e4             	pushl  -0x1c(%ebp)
80104486:	68 3f 7b 10 80       	push   $0x80107b3f
8010448b:	e8 51 c1 ff ff       	call   801005e1 <cprintf>
80104490:	83 c4 20             	add    $0x20,%esp
80104493:	e9 71 ff ff ff       	jmp    80104409 <procdumpP3+0xbe>
    cprintf("%d.0%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
80104498:	83 ec 0c             	sub    $0xc,%esp
8010449b:	ff 36                	pushl  (%esi)
8010449d:	ff 75 0c             	pushl  0xc(%ebp)
801044a0:	53                   	push   %ebx
801044a1:	ff 75 e4             	pushl  -0x1c(%ebp)
801044a4:	68 54 7b 10 80       	push   $0x80107b54
801044a9:	e8 33 c1 ff ff       	call   801005e1 <cprintf>
801044ae:	83 c4 20             	add    $0x20,%esp
801044b1:	e9 5c ff ff ff       	jmp    80104412 <procdumpP3+0xc7>
    cprintf("%d.%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
801044b6:	83 ec 0c             	sub    $0xc,%esp
801044b9:	ff 36                	pushl  (%esi)
801044bb:	ff 75 0c             	pushl  0xc(%ebp)
801044be:	53                   	push   %ebx
801044bf:	ff 75 e4             	pushl  -0x1c(%ebp)
801044c2:	68 68 7b 10 80       	push   $0x80107b68
801044c7:	e8 15 c1 ff ff       	call   801005e1 <cprintf>
801044cc:	83 c4 20             	add    $0x20,%esp
}
801044cf:	e9 47 ff ff ff       	jmp    8010441b <procdumpP3+0xd0>

801044d4 <procdump>:
{
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	57                   	push   %edi
801044d8:	56                   	push   %esi
801044d9:	53                   	push   %ebx
801044da:	83 ec 48             	sub    $0x48,%esp
  cprintf(HEADER);
801044dd:	68 40 79 10 80       	push   $0x80107940
801044e2:	e8 fa c0 ff ff       	call   801005e1 <cprintf>
801044e7:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ea:	bb 14 a6 10 80       	mov    $0x8010a614,%ebx
801044ef:	8d 7d e8             	lea    -0x18(%ebp),%edi
801044f2:	eb 31                	jmp    80104525 <procdump+0x51>
    procdumpP3(p, state);
801044f4:	83 ec 08             	sub    $0x8,%esp
801044f7:	50                   	push   %eax
801044f8:	53                   	push   %ebx
801044f9:	e8 4d fe ff ff       	call   8010434b <procdumpP3>
    if(p->state == SLEEPING){
801044fe:	83 c4 10             	add    $0x10,%esp
80104501:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104505:	74 42                	je     80104549 <procdump+0x75>
    cprintf("\n");
80104507:	83 ec 0c             	sub    $0xc,%esp
8010450a:	68 5f 7f 10 80       	push   $0x80107f5f
8010450f:	e8 cd c0 ff ff       	call   801005e1 <cprintf>
80104514:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104517:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010451d:	81 fb 14 cb 10 80    	cmp    $0x8010cb14,%ebx
80104523:	73 7b                	jae    801045a0 <procdump+0xcc>
    if(p->state == UNUSED)
80104525:	8b 53 0c             	mov    0xc(%ebx),%edx
80104528:	85 d2                	test   %edx,%edx
8010452a:	74 eb                	je     80104517 <procdump+0x43>
      state = "???";
8010452c:	b8 9a 7b 10 80       	mov    $0x80107b9a,%eax
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104531:	83 fa 05             	cmp    $0x5,%edx
80104534:	77 be                	ja     801044f4 <procdump+0x20>
80104536:	8b 04 95 d4 7b 10 80 	mov    -0x7fef842c(,%edx,4),%eax
8010453d:	85 c0                	test   %eax,%eax
      state = "???";
8010453f:	ba 9a 7b 10 80       	mov    $0x80107b9a,%edx
80104544:	0f 44 c2             	cmove  %edx,%eax
80104547:	eb ab                	jmp    801044f4 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104549:	83 ec 08             	sub    $0x8,%esp
8010454c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010454f:	50                   	push   %eax
80104550:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104553:	8b 40 0c             	mov    0xc(%eax),%eax
80104556:	83 c0 08             	add    $0x8,%eax
80104559:	50                   	push   %eax
8010455a:	e8 29 03 00 00       	call   80104888 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010455f:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104562:	83 c4 10             	add    $0x10,%esp
80104565:	85 c0                	test   %eax,%eax
80104567:	74 9e                	je     80104507 <procdump+0x33>
        cprintf(" %p", pc[i]);
80104569:	83 ec 08             	sub    $0x8,%esp
8010456c:	50                   	push   %eax
8010456d:	68 41 73 10 80       	push   $0x80107341
80104572:	e8 6a c0 ff ff       	call   801005e1 <cprintf>
80104577:	8d 75 c4             	lea    -0x3c(%ebp),%esi
8010457a:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010457d:	8b 06                	mov    (%esi),%eax
8010457f:	85 c0                	test   %eax,%eax
80104581:	74 84                	je     80104507 <procdump+0x33>
        cprintf(" %p", pc[i]);
80104583:	83 ec 08             	sub    $0x8,%esp
80104586:	50                   	push   %eax
80104587:	68 41 73 10 80       	push   $0x80107341
8010458c:	e8 50 c0 ff ff       	call   801005e1 <cprintf>
80104591:	83 c6 04             	add    $0x4,%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104594:	83 c4 10             	add    $0x10,%esp
80104597:	39 f7                	cmp    %esi,%edi
80104599:	75 e2                	jne    8010457d <procdump+0xa9>
8010459b:	e9 67 ff ff ff       	jmp    80104507 <procdump+0x33>
}
801045a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045a3:	5b                   	pop    %ebx
801045a4:	5e                   	pop    %esi
801045a5:	5f                   	pop    %edi
801045a6:	5d                   	pop    %ebp
801045a7:	c3                   	ret    

801045a8 <setuid>:

#ifdef CS333_P2
// Set the UID of the process
int
setuid(uint uid)
{
801045a8:	55                   	push   %ebp
801045a9:	89 e5                	mov    %esp,%ebp
801045ab:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801045ae:	68 e0 a5 10 80       	push   $0x8010a5e0
801045b3:	e8 fd 03 00 00       	call   801049b5 <acquire>
  myproc()->uid = uid;
801045b8:	e8 ec ef ff ff       	call   801035a9 <myproc>
801045bd:	8b 55 08             	mov    0x8(%ebp),%edx
801045c0:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  release(&ptable.lock);
801045c6:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
801045cd:	e8 4a 04 00 00       	call   80104a1c <release>
  return 1;
}
801045d2:	b8 01 00 00 00       	mov    $0x1,%eax
801045d7:	c9                   	leave  
801045d8:	c3                   	ret    

801045d9 <setgid>:

// Set the GID of the process
int
setgid(uint gid)
{
801045d9:	55                   	push   %ebp
801045da:	89 e5                	mov    %esp,%ebp
801045dc:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801045df:	68 e0 a5 10 80       	push   $0x8010a5e0
801045e4:	e8 cc 03 00 00       	call   801049b5 <acquire>
  myproc()->gid = gid;
801045e9:	e8 bb ef ff ff       	call   801035a9 <myproc>
801045ee:	8b 55 08             	mov    0x8(%ebp),%edx
801045f1:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  release(&ptable.lock);
801045f7:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
801045fe:	e8 19 04 00 00       	call   80104a1c <release>
  return 1;
}
80104603:	b8 01 00 00 00       	mov    $0x1,%eax
80104608:	c9                   	leave  
80104609:	c3                   	ret    

8010460a <getprocs>:

// Displays active processes
int
getprocs(uint max, struct uproc *table)
{
8010460a:	55                   	push   %ebp
8010460b:	89 e5                	mov    %esp,%ebp
8010460d:	57                   	push   %edi
8010460e:	56                   	push   %esi
8010460f:	53                   	push   %ebx
80104610:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
80104613:	68 e0 a5 10 80       	push   $0x8010a5e0
80104618:	e8 98 03 00 00       	call   801049b5 <acquire>

  int count = 0;
  
  for(int i = 0; i < max && i < NPROC; ++i) //Tables may vary in sizes. Prevents going out of bounds.
8010461d:	83 c4 10             	add    $0x10,%esp
80104620:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104624:	0f 84 3d 01 00 00    	je     80104767 <getprocs+0x15d>
8010462a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010462d:	8d 78 40             	lea    0x40(%eax),%edi
80104630:	bb 80 a6 10 80       	mov    $0x8010a680,%ebx
80104635:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int count = 0;
8010463c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80104643:	e9 80 00 00 00       	jmp    801046c8 <getprocs+0xbe>
      table[i].pid = ptable.proc[i].pid;
      table[i].uid = ptable.proc[i].uid; 
      table[i].gid = ptable.proc[i].gid;

      if(ptable.proc[i].parent == 0)
        table[i].ppid = ptable.proc[i].pid;
80104648:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010464b:	89 47 cc             	mov    %eax,-0x34(%edi)
      else
        table[i].ppid = ptable.proc[i].parent->pid;

      table[i].elapsed_ticks = ticks - ptable.proc[i].start_ticks;
8010464e:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80104653:	2b 46 10             	sub    0x10(%esi),%eax
80104656:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104659:	89 42 d4             	mov    %eax,-0x2c(%edx)
      table[i].CPU_total_ticks = ptable.proc[i].cpu_ticks_total;
8010465c:	8b 46 1c             	mov    0x1c(%esi),%eax
8010465f:	89 42 d8             	mov    %eax,-0x28(%edx)

      if(ptable.proc[i].state == SLEEPING)
80104662:	83 7e a0 02          	cmpl   $0x2,-0x60(%esi)
80104666:	0f 84 8f 00 00 00    	je     801046fb <getprocs+0xf1>
        safestrcpy(table[i].state, "sleep", sizeof("sleep"));
      if(ptable.proc[i].state == RUNNABLE)
8010466c:	83 7e a0 03          	cmpl   $0x3,-0x60(%esi)
80104670:	0f 84 a0 00 00 00    	je     80104716 <getprocs+0x10c>
        safestrcpy(table[i].state, "runnable", sizeof("runnable"));
      if(ptable.proc[i].state == RUNNING)
80104676:	83 7e a0 04          	cmpl   $0x4,-0x60(%esi)
8010467a:	0f 84 b1 00 00 00    	je     80104731 <getprocs+0x127>
        safestrcpy(table[i].state, "running", sizeof("running"));
      if(ptable.proc[i].state == ZOMBIE)
80104680:	83 7e a0 05          	cmpl   $0x5,-0x60(%esi)
80104684:	0f 84 c2 00 00 00    	je     8010474c <getprocs+0x142>
        safestrcpy(table[i].state, "zombie", sizeof("zombie"));

      table[i].size = ptable.proc[i].sz; 
8010468a:	8b 46 94             	mov    -0x6c(%esi),%eax
8010468d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80104690:	89 41 fc             	mov    %eax,-0x4(%ecx)
      safestrcpy(table[i].name, ptable.proc[i].name, sizeof(ptable.proc[i].name));
80104693:	83 ec 04             	sub    $0x4,%esp
80104696:	6a 10                	push   $0x10
80104698:	56                   	push   %esi
80104699:	51                   	push   %ecx
8010469a:	e8 53 05 00 00       	call   80104bf2 <safestrcpy>
      ++count;
8010469f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
801046a3:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < max && i < NPROC; ++i) //Tables may vary in sizes. Prevents going out of bounds.
801046a6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801046aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046ad:	83 c7 60             	add    $0x60,%edi
801046b0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801046b6:	39 45 08             	cmp    %eax,0x8(%ebp)
801046b9:	0f 86 af 00 00 00    	jbe    8010476e <getprocs+0x164>
801046bf:	83 f8 3f             	cmp    $0x3f,%eax
801046c2:	0f 8f a6 00 00 00    	jg     8010476e <getprocs+0x164>
801046c8:	89 de                	mov    %ebx,%esi
    if(ptable.proc[i].state != UNUSED && ptable.proc[i].state != EMBRYO) //These states are inactive
801046ca:	83 7b a0 01          	cmpl   $0x1,-0x60(%ebx)
801046ce:	76 d6                	jbe    801046a6 <getprocs+0x9c>
      table[i].pid = ptable.proc[i].pid;
801046d0:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801046d3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801046d6:	89 47 c0             	mov    %eax,-0x40(%edi)
      table[i].uid = ptable.proc[i].uid; 
801046d9:	8b 43 14             	mov    0x14(%ebx),%eax
801046dc:	89 47 c4             	mov    %eax,-0x3c(%edi)
      table[i].gid = ptable.proc[i].gid;
801046df:	8b 43 18             	mov    0x18(%ebx),%eax
801046e2:	89 47 c8             	mov    %eax,-0x38(%edi)
      if(ptable.proc[i].parent == 0)
801046e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
801046e8:	85 c0                	test   %eax,%eax
801046ea:	0f 84 58 ff ff ff    	je     80104648 <getprocs+0x3e>
        table[i].ppid = ptable.proc[i].parent->pid;
801046f0:	8b 40 10             	mov    0x10(%eax),%eax
801046f3:	89 47 cc             	mov    %eax,-0x34(%edi)
801046f6:	e9 53 ff ff ff       	jmp    8010464e <getprocs+0x44>
        safestrcpy(table[i].state, "sleep", sizeof("sleep"));
801046fb:	83 ec 04             	sub    $0x4,%esp
801046fe:	6a 06                	push   $0x6
80104700:	68 1f 7b 10 80       	push   $0x80107b1f
80104705:	8d 47 dc             	lea    -0x24(%edi),%eax
80104708:	50                   	push   %eax
80104709:	e8 e4 04 00 00       	call   80104bf2 <safestrcpy>
8010470e:	83 c4 10             	add    $0x10,%esp
80104711:	e9 56 ff ff ff       	jmp    8010466c <getprocs+0x62>
        safestrcpy(table[i].state, "runnable", sizeof("runnable"));
80104716:	83 ec 04             	sub    $0x4,%esp
80104719:	6a 09                	push   $0x9
8010471b:	68 9e 7b 10 80       	push   $0x80107b9e
80104720:	8d 47 dc             	lea    -0x24(%edi),%eax
80104723:	50                   	push   %eax
80104724:	e8 c9 04 00 00       	call   80104bf2 <safestrcpy>
80104729:	83 c4 10             	add    $0x10,%esp
8010472c:	e9 45 ff ff ff       	jmp    80104676 <getprocs+0x6c>
        safestrcpy(table[i].state, "running", sizeof("running"));
80104731:	83 ec 04             	sub    $0x4,%esp
80104734:	6a 08                	push   $0x8
80104736:	68 ea 7a 10 80       	push   $0x80107aea
8010473b:	8d 47 dc             	lea    -0x24(%edi),%eax
8010473e:	50                   	push   %eax
8010473f:	e8 ae 04 00 00       	call   80104bf2 <safestrcpy>
80104744:	83 c4 10             	add    $0x10,%esp
80104747:	e9 34 ff ff ff       	jmp    80104680 <getprocs+0x76>
        safestrcpy(table[i].state, "zombie", sizeof("zombie"));
8010474c:	83 ec 04             	sub    $0x4,%esp
8010474f:	6a 07                	push   $0x7
80104751:	68 a7 7b 10 80       	push   $0x80107ba7
80104756:	8d 47 dc             	lea    -0x24(%edi),%eax
80104759:	50                   	push   %eax
8010475a:	e8 93 04 00 00       	call   80104bf2 <safestrcpy>
8010475f:	83 c4 10             	add    $0x10,%esp
80104762:	e9 23 ff ff ff       	jmp    8010468a <getprocs+0x80>
  int count = 0;
80104767:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    }
  }
  release(&ptable.lock);
8010476e:	83 ec 0c             	sub    $0xc,%esp
80104771:	68 e0 a5 10 80       	push   $0x8010a5e0
80104776:	e8 a1 02 00 00       	call   80104a1c <release>
  return count; //How large uproc *table is
}
8010477b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010477e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104781:	5b                   	pop    %ebx
80104782:	5e                   	pop    %esi
80104783:	5f                   	pop    %edi
80104784:	5d                   	pop    %ebp
80104785:	c3                   	ret    

80104786 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104786:	55                   	push   %ebp
80104787:	89 e5                	mov    %esp,%ebp
80104789:	53                   	push   %ebx
8010478a:	83 ec 0c             	sub    $0xc,%esp
8010478d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104790:	68 ec 7b 10 80       	push   $0x80107bec
80104795:	8d 43 04             	lea    0x4(%ebx),%eax
80104798:	50                   	push   %eax
80104799:	e8 cf 00 00 00       	call   8010486d <initlock>
  lk->name = name;
8010479e:	8b 45 0c             	mov    0xc(%ebp),%eax
801047a1:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
801047a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
801047b1:	83 c4 10             	add    $0x10,%esp
801047b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047b7:	c9                   	leave  
801047b8:	c3                   	ret    

801047b9 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801047b9:	55                   	push   %ebp
801047ba:	89 e5                	mov    %esp,%ebp
801047bc:	56                   	push   %esi
801047bd:	53                   	push   %ebx
801047be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047c1:	8d 73 04             	lea    0x4(%ebx),%esi
801047c4:	83 ec 0c             	sub    $0xc,%esp
801047c7:	56                   	push   %esi
801047c8:	e8 e8 01 00 00       	call   801049b5 <acquire>
  while (lk->locked) {
801047cd:	83 c4 10             	add    $0x10,%esp
801047d0:	83 3b 00             	cmpl   $0x0,(%ebx)
801047d3:	74 12                	je     801047e7 <acquiresleep+0x2e>
    sleep(lk, &lk->lk);
801047d5:	83 ec 08             	sub    $0x8,%esp
801047d8:	56                   	push   %esi
801047d9:	53                   	push   %ebx
801047da:	e8 78 f5 ff ff       	call   80103d57 <sleep>
  while (lk->locked) {
801047df:	83 c4 10             	add    $0x10,%esp
801047e2:	83 3b 00             	cmpl   $0x0,(%ebx)
801047e5:	75 ee                	jne    801047d5 <acquiresleep+0x1c>
  }
  lk->locked = 1;
801047e7:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801047ed:	e8 b7 ed ff ff       	call   801035a9 <myproc>
801047f2:	8b 40 10             	mov    0x10(%eax),%eax
801047f5:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801047f8:	83 ec 0c             	sub    $0xc,%esp
801047fb:	56                   	push   %esi
801047fc:	e8 1b 02 00 00       	call   80104a1c <release>
}
80104801:	83 c4 10             	add    $0x10,%esp
80104804:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104807:	5b                   	pop    %ebx
80104808:	5e                   	pop    %esi
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    

8010480b <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
8010480b:	55                   	push   %ebp
8010480c:	89 e5                	mov    %esp,%ebp
8010480e:	56                   	push   %esi
8010480f:	53                   	push   %ebx
80104810:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104813:	8d 73 04             	lea    0x4(%ebx),%esi
80104816:	83 ec 0c             	sub    $0xc,%esp
80104819:	56                   	push   %esi
8010481a:	e8 96 01 00 00       	call   801049b5 <acquire>
  lk->locked = 0;
8010481f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104825:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
8010482c:	89 1c 24             	mov    %ebx,(%esp)
8010482f:	e8 16 f8 ff ff       	call   8010404a <wakeup>
  release(&lk->lk);
80104834:	89 34 24             	mov    %esi,(%esp)
80104837:	e8 e0 01 00 00       	call   80104a1c <release>
}
8010483c:	83 c4 10             	add    $0x10,%esp
8010483f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104842:	5b                   	pop    %ebx
80104843:	5e                   	pop    %esi
80104844:	5d                   	pop    %ebp
80104845:	c3                   	ret    

80104846 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104846:	55                   	push   %ebp
80104847:	89 e5                	mov    %esp,%ebp
80104849:	56                   	push   %esi
8010484a:	53                   	push   %ebx
8010484b:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
8010484e:	8d 5e 04             	lea    0x4(%esi),%ebx
80104851:	83 ec 0c             	sub    $0xc,%esp
80104854:	53                   	push   %ebx
80104855:	e8 5b 01 00 00       	call   801049b5 <acquire>
  r = lk->locked;
8010485a:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
8010485c:	89 1c 24             	mov    %ebx,(%esp)
8010485f:	e8 b8 01 00 00       	call   80104a1c <release>
  return r;
}
80104864:	89 f0                	mov    %esi,%eax
80104866:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104869:	5b                   	pop    %ebx
8010486a:	5e                   	pop    %esi
8010486b:	5d                   	pop    %ebp
8010486c:	c3                   	ret    

8010486d <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010486d:	55                   	push   %ebp
8010486e:	89 e5                	mov    %esp,%ebp
80104870:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104873:	8b 55 0c             	mov    0xc(%ebp),%edx
80104876:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104879:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010487f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104886:	5d                   	pop    %ebp
80104887:	c3                   	ret    

80104888 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104888:	55                   	push   %ebp
80104889:	89 e5                	mov    %esp,%ebp
8010488b:	53                   	push   %ebx
8010488c:	8b 45 08             	mov    0x8(%ebp),%eax
8010488f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104892:	8d 90 f8 ff ff 7f    	lea    0x7ffffff8(%eax),%edx
80104898:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010489e:	77 2d                	ja     801048cd <getcallerpcs+0x45>
      break;
    pcs[i] = ebp[1];     // saved %eip
801048a0:	8b 50 fc             	mov    -0x4(%eax),%edx
801048a3:	89 11                	mov    %edx,(%ecx)
    ebp = (uint*)ebp[0]; // saved %ebp
801048a5:	8b 50 f8             	mov    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801048a8:	b8 01 00 00 00       	mov    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048ad:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048b3:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048b9:	77 17                	ja     801048d2 <getcallerpcs+0x4a>
    pcs[i] = ebp[1];     // saved %eip
801048bb:	8b 5a 04             	mov    0x4(%edx),%ebx
801048be:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
801048c1:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048c3:	83 c0 01             	add    $0x1,%eax
801048c6:	83 f8 0a             	cmp    $0xa,%eax
801048c9:	75 e2                	jne    801048ad <getcallerpcs+0x25>
801048cb:	eb 14                	jmp    801048e1 <getcallerpcs+0x59>
801048cd:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801048d2:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801048d9:	83 c0 01             	add    $0x1,%eax
801048dc:	83 f8 09             	cmp    $0x9,%eax
801048df:	7e f1                	jle    801048d2 <getcallerpcs+0x4a>
}
801048e1:	5b                   	pop    %ebx
801048e2:	5d                   	pop    %ebp
801048e3:	c3                   	ret    

801048e4 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801048e4:	55                   	push   %ebp
801048e5:	89 e5                	mov    %esp,%ebp
801048e7:	53                   	push   %ebx
801048e8:	83 ec 04             	sub    $0x4,%esp
801048eb:	9c                   	pushf  
801048ec:	5b                   	pop    %ebx
  asm volatile("cli");
801048ed:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801048ee:	e8 24 ec ff ff       	call   80103517 <mycpu>
801048f3:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
801048fa:	74 12                	je     8010490e <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801048fc:	e8 16 ec ff ff       	call   80103517 <mycpu>
80104901:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104908:	83 c4 04             	add    $0x4,%esp
8010490b:	5b                   	pop    %ebx
8010490c:	5d                   	pop    %ebp
8010490d:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
8010490e:	e8 04 ec ff ff       	call   80103517 <mycpu>
80104913:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104919:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
8010491f:	eb db                	jmp    801048fc <pushcli+0x18>

80104921 <popcli>:

void
popcli(void)
{
80104921:	55                   	push   %ebp
80104922:	89 e5                	mov    %esp,%ebp
80104924:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104927:	9c                   	pushf  
80104928:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104929:	f6 c4 02             	test   $0x2,%ah
8010492c:	75 28                	jne    80104956 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010492e:	e8 e4 eb ff ff       	call   80103517 <mycpu>
80104933:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104939:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010493c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104942:	85 d2                	test   %edx,%edx
80104944:	78 1d                	js     80104963 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104946:	e8 cc eb ff ff       	call   80103517 <mycpu>
8010494b:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80104952:	74 1c                	je     80104970 <popcli+0x4f>
    sti();
}
80104954:	c9                   	leave  
80104955:	c3                   	ret    
    panic("popcli - interruptible");
80104956:	83 ec 0c             	sub    $0xc,%esp
80104959:	68 f7 7b 10 80       	push   $0x80107bf7
8010495e:	e8 e1 b9 ff ff       	call   80100344 <panic>
    panic("popcli");
80104963:	83 ec 0c             	sub    $0xc,%esp
80104966:	68 0e 7c 10 80       	push   $0x80107c0e
8010496b:	e8 d4 b9 ff ff       	call   80100344 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104970:	e8 a2 eb ff ff       	call   80103517 <mycpu>
80104975:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
8010497c:	74 d6                	je     80104954 <popcli+0x33>
  asm volatile("sti");
8010497e:	fb                   	sti    
}
8010497f:	eb d3                	jmp    80104954 <popcli+0x33>

80104981 <holding>:
{
80104981:	55                   	push   %ebp
80104982:	89 e5                	mov    %esp,%ebp
80104984:	56                   	push   %esi
80104985:	53                   	push   %ebx
80104986:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104989:	e8 56 ff ff ff       	call   801048e4 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010498e:	bb 00 00 00 00       	mov    $0x0,%ebx
80104993:	83 3e 00             	cmpl   $0x0,(%esi)
80104996:	75 0b                	jne    801049a3 <holding+0x22>
  popcli();
80104998:	e8 84 ff ff ff       	call   80104921 <popcli>
}
8010499d:	89 d8                	mov    %ebx,%eax
8010499f:	5b                   	pop    %ebx
801049a0:	5e                   	pop    %esi
801049a1:	5d                   	pop    %ebp
801049a2:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801049a3:	8b 5e 08             	mov    0x8(%esi),%ebx
801049a6:	e8 6c eb ff ff       	call   80103517 <mycpu>
801049ab:	39 c3                	cmp    %eax,%ebx
801049ad:	0f 94 c3             	sete   %bl
801049b0:	0f b6 db             	movzbl %bl,%ebx
801049b3:	eb e3                	jmp    80104998 <holding+0x17>

801049b5 <acquire>:
{
801049b5:	55                   	push   %ebp
801049b6:	89 e5                	mov    %esp,%ebp
801049b8:	53                   	push   %ebx
801049b9:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801049bc:	e8 23 ff ff ff       	call   801048e4 <pushcli>
  if(holding(lk))
801049c1:	83 ec 0c             	sub    $0xc,%esp
801049c4:	ff 75 08             	pushl  0x8(%ebp)
801049c7:	e8 b5 ff ff ff       	call   80104981 <holding>
801049cc:	83 c4 10             	add    $0x10,%esp
801049cf:	85 c0                	test   %eax,%eax
801049d1:	75 3c                	jne    80104a0f <acquire+0x5a>
  asm volatile("lock; xchgl %0, %1" :
801049d3:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
801049d8:	8b 55 08             	mov    0x8(%ebp),%edx
801049db:	89 c8                	mov    %ecx,%eax
801049dd:	f0 87 02             	lock xchg %eax,(%edx)
801049e0:	85 c0                	test   %eax,%eax
801049e2:	75 f4                	jne    801049d8 <acquire+0x23>
  __sync_synchronize();
801049e4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801049e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049ec:	e8 26 eb ff ff       	call   80103517 <mycpu>
801049f1:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801049f4:	83 ec 08             	sub    $0x8,%esp
801049f7:	8b 45 08             	mov    0x8(%ebp),%eax
801049fa:	83 c0 0c             	add    $0xc,%eax
801049fd:	50                   	push   %eax
801049fe:	8d 45 08             	lea    0x8(%ebp),%eax
80104a01:	50                   	push   %eax
80104a02:	e8 81 fe ff ff       	call   80104888 <getcallerpcs>
}
80104a07:	83 c4 10             	add    $0x10,%esp
80104a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a0d:	c9                   	leave  
80104a0e:	c3                   	ret    
    panic("acquire");
80104a0f:	83 ec 0c             	sub    $0xc,%esp
80104a12:	68 15 7c 10 80       	push   $0x80107c15
80104a17:	e8 28 b9 ff ff       	call   80100344 <panic>

80104a1c <release>:
{
80104a1c:	55                   	push   %ebp
80104a1d:	89 e5                	mov    %esp,%ebp
80104a1f:	53                   	push   %ebx
80104a20:	83 ec 10             	sub    $0x10,%esp
80104a23:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104a26:	53                   	push   %ebx
80104a27:	e8 55 ff ff ff       	call   80104981 <holding>
80104a2c:	83 c4 10             	add    $0x10,%esp
80104a2f:	85 c0                	test   %eax,%eax
80104a31:	74 23                	je     80104a56 <release+0x3a>
  lk->pcs[0] = 0;
80104a33:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a3a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a41:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a46:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80104a4c:	e8 d0 fe ff ff       	call   80104921 <popcli>
}
80104a51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a54:	c9                   	leave  
80104a55:	c3                   	ret    
    panic("release");
80104a56:	83 ec 0c             	sub    $0xc,%esp
80104a59:	68 1d 7c 10 80       	push   $0x80107c1d
80104a5e:	e8 e1 b8 ff ff       	call   80100344 <panic>

80104a63 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a63:	55                   	push   %ebp
80104a64:	89 e5                	mov    %esp,%ebp
80104a66:	57                   	push   %edi
80104a67:	53                   	push   %ebx
80104a68:	8b 55 08             	mov    0x8(%ebp),%edx
80104a6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a6e:	f6 c2 03             	test   $0x3,%dl
80104a71:	75 05                	jne    80104a78 <memset+0x15>
80104a73:	f6 c1 03             	test   $0x3,%cl
80104a76:	74 0e                	je     80104a86 <memset+0x23>
  asm volatile("cld; rep stosb" :
80104a78:	89 d7                	mov    %edx,%edi
80104a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a7d:	fc                   	cld    
80104a7e:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a80:	89 d0                	mov    %edx,%eax
80104a82:	5b                   	pop    %ebx
80104a83:	5f                   	pop    %edi
80104a84:	5d                   	pop    %ebp
80104a85:	c3                   	ret    
    c &= 0xFF;
80104a86:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a8a:	c1 e9 02             	shr    $0x2,%ecx
80104a8d:	89 f8                	mov    %edi,%eax
80104a8f:	c1 e0 18             	shl    $0x18,%eax
80104a92:	89 fb                	mov    %edi,%ebx
80104a94:	c1 e3 10             	shl    $0x10,%ebx
80104a97:	09 d8                	or     %ebx,%eax
80104a99:	09 f8                	or     %edi,%eax
80104a9b:	c1 e7 08             	shl    $0x8,%edi
80104a9e:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104aa0:	89 d7                	mov    %edx,%edi
80104aa2:	fc                   	cld    
80104aa3:	f3 ab                	rep stos %eax,%es:(%edi)
80104aa5:	eb d9                	jmp    80104a80 <memset+0x1d>

80104aa7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104aa7:	55                   	push   %ebp
80104aa8:	89 e5                	mov    %esp,%ebp
80104aaa:	57                   	push   %edi
80104aab:	56                   	push   %esi
80104aac:	53                   	push   %ebx
80104aad:	8b 75 08             	mov    0x8(%ebp),%esi
80104ab0:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ab3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104ab6:	85 db                	test   %ebx,%ebx
80104ab8:	74 37                	je     80104af1 <memcmp+0x4a>
    if(*s1 != *s2)
80104aba:	0f b6 16             	movzbl (%esi),%edx
80104abd:	0f b6 0f             	movzbl (%edi),%ecx
80104ac0:	38 ca                	cmp    %cl,%dl
80104ac2:	75 19                	jne    80104add <memcmp+0x36>
80104ac4:	b8 01 00 00 00       	mov    $0x1,%eax
  while(n-- > 0){
80104ac9:	39 d8                	cmp    %ebx,%eax
80104acb:	74 1d                	je     80104aea <memcmp+0x43>
    if(*s1 != *s2)
80104acd:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104ad1:	83 c0 01             	add    $0x1,%eax
80104ad4:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104ad9:	38 ca                	cmp    %cl,%dl
80104adb:	74 ec                	je     80104ac9 <memcmp+0x22>
      return *s1 - *s2;
80104add:	0f b6 c2             	movzbl %dl,%eax
80104ae0:	0f b6 c9             	movzbl %cl,%ecx
80104ae3:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104ae5:	5b                   	pop    %ebx
80104ae6:	5e                   	pop    %esi
80104ae7:	5f                   	pop    %edi
80104ae8:	5d                   	pop    %ebp
80104ae9:	c3                   	ret    
  return 0;
80104aea:	b8 00 00 00 00       	mov    $0x0,%eax
80104aef:	eb f4                	jmp    80104ae5 <memcmp+0x3e>
80104af1:	b8 00 00 00 00       	mov    $0x0,%eax
80104af6:	eb ed                	jmp    80104ae5 <memcmp+0x3e>

80104af8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104af8:	55                   	push   %ebp
80104af9:	89 e5                	mov    %esp,%ebp
80104afb:	56                   	push   %esi
80104afc:	53                   	push   %ebx
80104afd:	8b 45 08             	mov    0x8(%ebp),%eax
80104b00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b03:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b06:	39 c3                	cmp    %eax,%ebx
80104b08:	72 1b                	jb     80104b25 <memmove+0x2d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104b0a:	ba 00 00 00 00       	mov    $0x0,%edx
80104b0f:	85 f6                	test   %esi,%esi
80104b11:	74 0e                	je     80104b21 <memmove+0x29>
      *d++ = *s++;
80104b13:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b17:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b1a:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104b1d:	39 d6                	cmp    %edx,%esi
80104b1f:	75 f2                	jne    80104b13 <memmove+0x1b>

  return dst;
}
80104b21:	5b                   	pop    %ebx
80104b22:	5e                   	pop    %esi
80104b23:	5d                   	pop    %ebp
80104b24:	c3                   	ret    
  if(s < d && s + n > d){
80104b25:	8d 14 33             	lea    (%ebx,%esi,1),%edx
80104b28:	39 d0                	cmp    %edx,%eax
80104b2a:	73 de                	jae    80104b0a <memmove+0x12>
    while(n-- > 0)
80104b2c:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b2f:	85 f6                	test   %esi,%esi
80104b31:	74 ee                	je     80104b21 <memmove+0x29>
      *--d = *--s;
80104b33:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b37:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104b3a:	83 ea 01             	sub    $0x1,%edx
80104b3d:	83 fa ff             	cmp    $0xffffffff,%edx
80104b40:	75 f1                	jne    80104b33 <memmove+0x3b>
80104b42:	eb dd                	jmp    80104b21 <memmove+0x29>

80104b44 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b44:	55                   	push   %ebp
80104b45:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104b47:	ff 75 10             	pushl  0x10(%ebp)
80104b4a:	ff 75 0c             	pushl  0xc(%ebp)
80104b4d:	ff 75 08             	pushl  0x8(%ebp)
80104b50:	e8 a3 ff ff ff       	call   80104af8 <memmove>
}
80104b55:	c9                   	leave  
80104b56:	c3                   	ret    

80104b57 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104b57:	55                   	push   %ebp
80104b58:	89 e5                	mov    %esp,%ebp
80104b5a:	53                   	push   %ebx
80104b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80104b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
80104b64:	85 db                	test   %ebx,%ebx
80104b66:	74 2d                	je     80104b95 <strncmp+0x3e>
80104b68:	0f b6 08             	movzbl (%eax),%ecx
80104b6b:	84 c9                	test   %cl,%cl
80104b6d:	74 1b                	je     80104b8a <strncmp+0x33>
80104b6f:	3a 0a                	cmp    (%edx),%cl
80104b71:	75 17                	jne    80104b8a <strncmp+0x33>
80104b73:	01 c3                	add    %eax,%ebx
    n--, p++, q++;
80104b75:	83 c0 01             	add    $0x1,%eax
80104b78:	83 c2 01             	add    $0x1,%edx
  while(n > 0 && *p && *p == *q)
80104b7b:	39 d8                	cmp    %ebx,%eax
80104b7d:	74 1d                	je     80104b9c <strncmp+0x45>
80104b7f:	0f b6 08             	movzbl (%eax),%ecx
80104b82:	84 c9                	test   %cl,%cl
80104b84:	74 04                	je     80104b8a <strncmp+0x33>
80104b86:	3a 0a                	cmp    (%edx),%cl
80104b88:	74 eb                	je     80104b75 <strncmp+0x1e>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b8a:	0f b6 00             	movzbl (%eax),%eax
80104b8d:	0f b6 12             	movzbl (%edx),%edx
80104b90:	29 d0                	sub    %edx,%eax
}
80104b92:	5b                   	pop    %ebx
80104b93:	5d                   	pop    %ebp
80104b94:	c3                   	ret    
    return 0;
80104b95:	b8 00 00 00 00       	mov    $0x0,%eax
80104b9a:	eb f6                	jmp    80104b92 <strncmp+0x3b>
80104b9c:	b8 00 00 00 00       	mov    $0x0,%eax
80104ba1:	eb ef                	jmp    80104b92 <strncmp+0x3b>

80104ba3 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ba3:	55                   	push   %ebp
80104ba4:	89 e5                	mov    %esp,%ebp
80104ba6:	57                   	push   %edi
80104ba7:	56                   	push   %esi
80104ba8:	53                   	push   %ebx
80104ba9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104bac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104baf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104bb2:	89 f9                	mov    %edi,%ecx
80104bb4:	eb 02                	jmp    80104bb8 <strncpy+0x15>
80104bb6:	89 f2                	mov    %esi,%edx
80104bb8:	8d 72 ff             	lea    -0x1(%edx),%esi
80104bbb:	85 d2                	test   %edx,%edx
80104bbd:	7e 11                	jle    80104bd0 <strncpy+0x2d>
80104bbf:	83 c3 01             	add    $0x1,%ebx
80104bc2:	83 c1 01             	add    $0x1,%ecx
80104bc5:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
80104bc9:	88 41 ff             	mov    %al,-0x1(%ecx)
80104bcc:	84 c0                	test   %al,%al
80104bce:	75 e6                	jne    80104bb6 <strncpy+0x13>
    ;
  while(n-- > 0)
80104bd0:	bb 00 00 00 00       	mov    $0x0,%ebx
80104bd5:	83 ea 01             	sub    $0x1,%edx
80104bd8:	85 f6                	test   %esi,%esi
80104bda:	7e 0f                	jle    80104beb <strncpy+0x48>
    *s++ = 0;
80104bdc:	c6 04 19 00          	movb   $0x0,(%ecx,%ebx,1)
80104be0:	83 c3 01             	add    $0x1,%ebx
80104be3:	89 d6                	mov    %edx,%esi
80104be5:	29 de                	sub    %ebx,%esi
  while(n-- > 0)
80104be7:	85 f6                	test   %esi,%esi
80104be9:	7f f1                	jg     80104bdc <strncpy+0x39>
  return os;
}
80104beb:	89 f8                	mov    %edi,%eax
80104bed:	5b                   	pop    %ebx
80104bee:	5e                   	pop    %esi
80104bef:	5f                   	pop    %edi
80104bf0:	5d                   	pop    %ebp
80104bf1:	c3                   	ret    

80104bf2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104bf2:	55                   	push   %ebp
80104bf3:	89 e5                	mov    %esp,%ebp
80104bf5:	56                   	push   %esi
80104bf6:	53                   	push   %ebx
80104bf7:	8b 45 08             	mov    0x8(%ebp),%eax
80104bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bfd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
80104c00:	85 c9                	test   %ecx,%ecx
80104c02:	7e 1e                	jle    80104c22 <safestrcpy+0x30>
80104c04:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c08:	89 c1                	mov    %eax,%ecx
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c0a:	39 f2                	cmp    %esi,%edx
80104c0c:	74 11                	je     80104c1f <safestrcpy+0x2d>
80104c0e:	83 c2 01             	add    $0x1,%edx
80104c11:	83 c1 01             	add    $0x1,%ecx
80104c14:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c18:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c1b:	84 db                	test   %bl,%bl
80104c1d:	75 eb                	jne    80104c0a <safestrcpy+0x18>
    ;
  *s = 0;
80104c1f:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104c22:	5b                   	pop    %ebx
80104c23:	5e                   	pop    %esi
80104c24:	5d                   	pop    %ebp
80104c25:	c3                   	ret    

80104c26 <strlen>:

int
strlen(const char *s)
{
80104c26:	55                   	push   %ebp
80104c27:	89 e5                	mov    %esp,%ebp
80104c29:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104c2c:	80 3a 00             	cmpb   $0x0,(%edx)
80104c2f:	74 10                	je     80104c41 <strlen+0x1b>
80104c31:	b8 00 00 00 00       	mov    $0x0,%eax
80104c36:	83 c0 01             	add    $0x1,%eax
80104c39:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c3d:	75 f7                	jne    80104c36 <strlen+0x10>
    ;
  return n;
}
80104c3f:	5d                   	pop    %ebp
80104c40:	c3                   	ret    
  for(n = 0; s[n]; n++)
80104c41:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
80104c46:	eb f7                	jmp    80104c3f <strlen+0x19>

80104c48 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c48:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c4c:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104c50:	55                   	push   %ebp
  pushl %ebx
80104c51:	53                   	push   %ebx
  pushl %esi
80104c52:	56                   	push   %esi
  pushl %edi
80104c53:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c54:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c56:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104c58:	5f                   	pop    %edi
  popl %esi
80104c59:	5e                   	pop    %esi
  popl %ebx
80104c5a:	5b                   	pop    %ebx
  popl %ebp
80104c5b:	5d                   	pop    %ebp
  ret
80104c5c:	c3                   	ret    

80104c5d <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c5d:	55                   	push   %ebp
80104c5e:	89 e5                	mov    %esp,%ebp
80104c60:	53                   	push   %ebx
80104c61:	83 ec 04             	sub    $0x4,%esp
80104c64:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c67:	e8 3d e9 ff ff       	call   801035a9 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c6c:	8b 00                	mov    (%eax),%eax
80104c6e:	39 d8                	cmp    %ebx,%eax
80104c70:	76 19                	jbe    80104c8b <fetchint+0x2e>
80104c72:	8d 53 04             	lea    0x4(%ebx),%edx
80104c75:	39 d0                	cmp    %edx,%eax
80104c77:	72 19                	jb     80104c92 <fetchint+0x35>
    return -1;
  *ip = *(int*)(addr);
80104c79:	8b 13                	mov    (%ebx),%edx
80104c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c7e:	89 10                	mov    %edx,(%eax)
  return 0;
80104c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c85:	83 c4 04             	add    $0x4,%esp
80104c88:	5b                   	pop    %ebx
80104c89:	5d                   	pop    %ebp
80104c8a:	c3                   	ret    
    return -1;
80104c8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c90:	eb f3                	jmp    80104c85 <fetchint+0x28>
80104c92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c97:	eb ec                	jmp    80104c85 <fetchint+0x28>

80104c99 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c99:	55                   	push   %ebp
80104c9a:	89 e5                	mov    %esp,%ebp
80104c9c:	53                   	push   %ebx
80104c9d:	83 ec 04             	sub    $0x4,%esp
80104ca0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104ca3:	e8 01 e9 ff ff       	call   801035a9 <myproc>

  if(addr >= curproc->sz)
80104ca8:	39 18                	cmp    %ebx,(%eax)
80104caa:	76 2f                	jbe    80104cdb <fetchstr+0x42>
    return -1;
  *pp = (char*)addr;
80104cac:	89 da                	mov    %ebx,%edx
80104cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104cb1:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104cb3:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104cb5:	39 c3                	cmp    %eax,%ebx
80104cb7:	73 29                	jae    80104ce2 <fetchstr+0x49>
    if(*s == 0)
80104cb9:	80 3b 00             	cmpb   $0x0,(%ebx)
80104cbc:	74 0c                	je     80104cca <fetchstr+0x31>
  for(s = *pp; s < ep; s++){
80104cbe:	83 c2 01             	add    $0x1,%edx
80104cc1:	39 d0                	cmp    %edx,%eax
80104cc3:	76 0f                	jbe    80104cd4 <fetchstr+0x3b>
    if(*s == 0)
80104cc5:	80 3a 00             	cmpb   $0x0,(%edx)
80104cc8:	75 f4                	jne    80104cbe <fetchstr+0x25>
      return s - *pp;
80104cca:	89 d0                	mov    %edx,%eax
80104ccc:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104cce:	83 c4 04             	add    $0x4,%esp
80104cd1:	5b                   	pop    %ebx
80104cd2:	5d                   	pop    %ebp
80104cd3:	c3                   	ret    
  return -1;
80104cd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd9:	eb f3                	jmp    80104cce <fetchstr+0x35>
    return -1;
80104cdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ce0:	eb ec                	jmp    80104cce <fetchstr+0x35>
  return -1;
80104ce2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ce7:	eb e5                	jmp    80104cce <fetchstr+0x35>

80104ce9 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ce9:	55                   	push   %ebp
80104cea:	89 e5                	mov    %esp,%ebp
80104cec:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cef:	e8 b5 e8 ff ff       	call   801035a9 <myproc>
80104cf4:	83 ec 08             	sub    $0x8,%esp
80104cf7:	ff 75 0c             	pushl  0xc(%ebp)
80104cfa:	8b 40 18             	mov    0x18(%eax),%eax
80104cfd:	8b 40 44             	mov    0x44(%eax),%eax
80104d00:	8b 55 08             	mov    0x8(%ebp),%edx
80104d03:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
80104d07:	50                   	push   %eax
80104d08:	e8 50 ff ff ff       	call   80104c5d <fetchint>
}
80104d0d:	c9                   	leave  
80104d0e:	c3                   	ret    

80104d0f <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d0f:	55                   	push   %ebp
80104d10:	89 e5                	mov    %esp,%ebp
80104d12:	56                   	push   %esi
80104d13:	53                   	push   %ebx
80104d14:	83 ec 10             	sub    $0x10,%esp
80104d17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104d1a:	e8 8a e8 ff ff       	call   801035a9 <myproc>
80104d1f:	89 c6                	mov    %eax,%esi

  if(argint(n, &i) < 0)
80104d21:	83 ec 08             	sub    $0x8,%esp
80104d24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d27:	50                   	push   %eax
80104d28:	ff 75 08             	pushl  0x8(%ebp)
80104d2b:	e8 b9 ff ff ff       	call   80104ce9 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d30:	83 c4 10             	add    $0x10,%esp
80104d33:	85 db                	test   %ebx,%ebx
80104d35:	78 24                	js     80104d5b <argptr+0x4c>
80104d37:	85 c0                	test   %eax,%eax
80104d39:	78 20                	js     80104d5b <argptr+0x4c>
80104d3b:	8b 16                	mov    (%esi),%edx
80104d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d40:	39 c2                	cmp    %eax,%edx
80104d42:	76 1e                	jbe    80104d62 <argptr+0x53>
80104d44:	01 c3                	add    %eax,%ebx
80104d46:	39 da                	cmp    %ebx,%edx
80104d48:	72 1f                	jb     80104d69 <argptr+0x5a>
    return -1;
  *pp = (char*)i;
80104d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d4d:	89 02                	mov    %eax,(%edx)
  return 0;
80104d4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d57:	5b                   	pop    %ebx
80104d58:	5e                   	pop    %esi
80104d59:	5d                   	pop    %ebp
80104d5a:	c3                   	ret    
    return -1;
80104d5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d60:	eb f2                	jmp    80104d54 <argptr+0x45>
80104d62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d67:	eb eb                	jmp    80104d54 <argptr+0x45>
80104d69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d6e:	eb e4                	jmp    80104d54 <argptr+0x45>

80104d70 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d79:	50                   	push   %eax
80104d7a:	ff 75 08             	pushl  0x8(%ebp)
80104d7d:	e8 67 ff ff ff       	call   80104ce9 <argint>
80104d82:	83 c4 10             	add    $0x10,%esp
80104d85:	85 c0                	test   %eax,%eax
80104d87:	78 13                	js     80104d9c <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80104d89:	83 ec 08             	sub    $0x8,%esp
80104d8c:	ff 75 0c             	pushl  0xc(%ebp)
80104d8f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d92:	e8 02 ff ff ff       	call   80104c99 <fetchstr>
80104d97:	83 c4 10             	add    $0x10,%esp
}
80104d9a:	c9                   	leave  
80104d9b:	c3                   	ret    
    return -1;
80104d9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104da1:	eb f7                	jmp    80104d9a <argstr+0x2a>

80104da3 <syscall>:
};
#endif // PRINT_SYSCALLS

void
syscall(void)
{
80104da3:	55                   	push   %ebp
80104da4:	89 e5                	mov    %esp,%ebp
80104da6:	53                   	push   %ebx
80104da7:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104daa:	e8 fa e7 ff ff       	call   801035a9 <myproc>
80104daf:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104db1:	8b 40 18             	mov    0x18(%eax),%eax
80104db4:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104db7:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dba:	83 fa 1c             	cmp    $0x1c,%edx
80104dbd:	77 18                	ja     80104dd7 <syscall+0x34>
80104dbf:	8b 14 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%edx
80104dc6:	85 d2                	test   %edx,%edx
80104dc8:	74 0d                	je     80104dd7 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
80104dca:	ff d2                	call   *%edx
80104dcc:	8b 53 18             	mov    0x18(%ebx),%edx
80104dcf:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dd5:	c9                   	leave  
80104dd6:	c3                   	ret    
    cprintf("%d %s: unknown sys call %d\n",
80104dd7:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104dd8:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ddb:	50                   	push   %eax
80104ddc:	ff 73 10             	pushl  0x10(%ebx)
80104ddf:	68 25 7c 10 80       	push   $0x80107c25
80104de4:	e8 f8 b7 ff ff       	call   801005e1 <cprintf>
    curproc->tf->eax = -1;
80104de9:	8b 43 18             	mov    0x18(%ebx),%eax
80104dec:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104df3:	83 c4 10             	add    $0x10,%esp
}
80104df6:	eb da                	jmp    80104dd2 <syscall+0x2f>

80104df8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104df8:	55                   	push   %ebp
80104df9:	89 e5                	mov    %esp,%ebp
80104dfb:	56                   	push   %esi
80104dfc:	53                   	push   %ebx
80104dfd:	83 ec 18             	sub    $0x18,%esp
80104e00:	89 d6                	mov    %edx,%esi
80104e02:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104e04:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e07:	52                   	push   %edx
80104e08:	50                   	push   %eax
80104e09:	e8 db fe ff ff       	call   80104ce9 <argint>
80104e0e:	83 c4 10             	add    $0x10,%esp
80104e11:	85 c0                	test   %eax,%eax
80104e13:	78 2e                	js     80104e43 <argfd+0x4b>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e15:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e19:	77 2f                	ja     80104e4a <argfd+0x52>
80104e1b:	e8 89 e7 ff ff       	call   801035a9 <myproc>
80104e20:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104e23:	8b 54 88 28          	mov    0x28(%eax,%ecx,4),%edx
80104e27:	85 d2                	test   %edx,%edx
80104e29:	74 26                	je     80104e51 <argfd+0x59>
    return -1;
  if(pfd)
80104e2b:	85 f6                	test   %esi,%esi
80104e2d:	74 02                	je     80104e31 <argfd+0x39>
    *pfd = fd;
80104e2f:	89 0e                	mov    %ecx,(%esi)
  if(pf)
    *pf = f;
  return 0;
80104e31:	b8 00 00 00 00       	mov    $0x0,%eax
  if(pf)
80104e36:	85 db                	test   %ebx,%ebx
80104e38:	74 02                	je     80104e3c <argfd+0x44>
    *pf = f;
80104e3a:	89 13                	mov    %edx,(%ebx)
}
80104e3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e3f:	5b                   	pop    %ebx
80104e40:	5e                   	pop    %esi
80104e41:	5d                   	pop    %ebp
80104e42:	c3                   	ret    
    return -1;
80104e43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e48:	eb f2                	jmp    80104e3c <argfd+0x44>
    return -1;
80104e4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e4f:	eb eb                	jmp    80104e3c <argfd+0x44>
80104e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e56:	eb e4                	jmp    80104e3c <argfd+0x44>

80104e58 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104e58:	55                   	push   %ebp
80104e59:	89 e5                	mov    %esp,%ebp
80104e5b:	53                   	push   %ebx
80104e5c:	83 ec 04             	sub    $0x4,%esp
80104e5f:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104e61:	e8 43 e7 ff ff       	call   801035a9 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104e66:	83 78 28 00          	cmpl   $0x0,0x28(%eax)
80104e6a:	74 1b                	je     80104e87 <fdalloc+0x2f>
  for(fd = 0; fd < NOFILE; fd++){
80104e6c:	ba 01 00 00 00       	mov    $0x1,%edx
    if(curproc->ofile[fd] == 0){
80104e71:	83 7c 90 28 00       	cmpl   $0x0,0x28(%eax,%edx,4)
80104e76:	74 14                	je     80104e8c <fdalloc+0x34>
  for(fd = 0; fd < NOFILE; fd++){
80104e78:	83 c2 01             	add    $0x1,%edx
80104e7b:	83 fa 10             	cmp    $0x10,%edx
80104e7e:	75 f1                	jne    80104e71 <fdalloc+0x19>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80104e80:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80104e85:	eb 09                	jmp    80104e90 <fdalloc+0x38>
  for(fd = 0; fd < NOFILE; fd++){
80104e87:	ba 00 00 00 00       	mov    $0x0,%edx
      curproc->ofile[fd] = f;
80104e8c:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
80104e90:	89 d0                	mov    %edx,%eax
80104e92:	83 c4 04             	add    $0x4,%esp
80104e95:	5b                   	pop    %ebx
80104e96:	5d                   	pop    %ebp
80104e97:	c3                   	ret    

80104e98 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e98:	55                   	push   %ebp
80104e99:	89 e5                	mov    %esp,%ebp
80104e9b:	57                   	push   %edi
80104e9c:	56                   	push   %esi
80104e9d:	53                   	push   %ebx
80104e9e:	83 ec 44             	sub    $0x44,%esp
80104ea1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104ea4:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104ea7:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104eaa:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80104ead:	52                   	push   %edx
80104eae:	50                   	push   %eax
80104eaf:	e8 6e ce ff ff       	call   80101d22 <nameiparent>
80104eb4:	89 c6                	mov    %eax,%esi
80104eb6:	83 c4 10             	add    $0x10,%esp
80104eb9:	85 c0                	test   %eax,%eax
80104ebb:	0f 84 34 01 00 00    	je     80104ff5 <create+0x15d>
    return 0;
  ilock(dp);
80104ec1:	83 ec 0c             	sub    $0xc,%esp
80104ec4:	50                   	push   %eax
80104ec5:	e8 a3 c6 ff ff       	call   8010156d <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104eca:	83 c4 0c             	add    $0xc,%esp
80104ecd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104ed0:	50                   	push   %eax
80104ed1:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104ed4:	50                   	push   %eax
80104ed5:	56                   	push   %esi
80104ed6:	e8 58 cb ff ff       	call   80101a33 <dirlookup>
80104edb:	89 c3                	mov    %eax,%ebx
80104edd:	83 c4 10             	add    $0x10,%esp
80104ee0:	85 c0                	test   %eax,%eax
80104ee2:	74 3f                	je     80104f23 <create+0x8b>
    iunlockput(dp);
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	56                   	push   %esi
80104ee8:	e8 c9 c8 ff ff       	call   801017b6 <iunlockput>
    ilock(ip);
80104eed:	89 1c 24             	mov    %ebx,(%esp)
80104ef0:	e8 78 c6 ff ff       	call   8010156d <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ef5:	83 c4 10             	add    $0x10,%esp
80104ef8:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104efd:	75 11                	jne    80104f10 <create+0x78>
80104eff:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104f04:	75 0a                	jne    80104f10 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f06:	89 d8                	mov    %ebx,%eax
80104f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f0b:	5b                   	pop    %ebx
80104f0c:	5e                   	pop    %esi
80104f0d:	5f                   	pop    %edi
80104f0e:	5d                   	pop    %ebp
80104f0f:	c3                   	ret    
    iunlockput(ip);
80104f10:	83 ec 0c             	sub    $0xc,%esp
80104f13:	53                   	push   %ebx
80104f14:	e8 9d c8 ff ff       	call   801017b6 <iunlockput>
    return 0;
80104f19:	83 c4 10             	add    $0x10,%esp
80104f1c:	bb 00 00 00 00       	mov    $0x0,%ebx
80104f21:	eb e3                	jmp    80104f06 <create+0x6e>
  if((ip = ialloc(dp->dev, type)) == 0)
80104f23:	83 ec 08             	sub    $0x8,%esp
80104f26:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104f2a:	50                   	push   %eax
80104f2b:	ff 36                	pushl  (%esi)
80104f2d:	e8 e8 c4 ff ff       	call   8010141a <ialloc>
80104f32:	89 c3                	mov    %eax,%ebx
80104f34:	83 c4 10             	add    $0x10,%esp
80104f37:	85 c0                	test   %eax,%eax
80104f39:	74 55                	je     80104f90 <create+0xf8>
  ilock(ip);
80104f3b:	83 ec 0c             	sub    $0xc,%esp
80104f3e:	50                   	push   %eax
80104f3f:	e8 29 c6 ff ff       	call   8010156d <ilock>
  ip->major = major;
80104f44:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104f48:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104f4c:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
80104f50:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f56:	89 1c 24             	mov    %ebx,(%esp)
80104f59:	e8 65 c5 ff ff       	call   801014c3 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f5e:	83 c4 10             	add    $0x10,%esp
80104f61:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104f66:	74 35                	je     80104f9d <create+0x105>
  if(dirlink(dp, name, ip->inum) < 0)
80104f68:	83 ec 04             	sub    $0x4,%esp
80104f6b:	ff 73 04             	pushl  0x4(%ebx)
80104f6e:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104f71:	50                   	push   %eax
80104f72:	56                   	push   %esi
80104f73:	e8 dd cc ff ff       	call   80101c55 <dirlink>
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	85 c0                	test   %eax,%eax
80104f7d:	78 69                	js     80104fe8 <create+0x150>
  iunlockput(dp);
80104f7f:	83 ec 0c             	sub    $0xc,%esp
80104f82:	56                   	push   %esi
80104f83:	e8 2e c8 ff ff       	call   801017b6 <iunlockput>
  return ip;
80104f88:	83 c4 10             	add    $0x10,%esp
80104f8b:	e9 76 ff ff ff       	jmp    80104f06 <create+0x6e>
    panic("create: ialloc");
80104f90:	83 ec 0c             	sub    $0xc,%esp
80104f93:	68 d8 7c 10 80       	push   $0x80107cd8
80104f98:	e8 a7 b3 ff ff       	call   80100344 <panic>
    dp->nlink++;  // for ".."
80104f9d:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104fa2:	83 ec 0c             	sub    $0xc,%esp
80104fa5:	56                   	push   %esi
80104fa6:	e8 18 c5 ff ff       	call   801014c3 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104fab:	83 c4 0c             	add    $0xc,%esp
80104fae:	ff 73 04             	pushl  0x4(%ebx)
80104fb1:	68 e8 7c 10 80       	push   $0x80107ce8
80104fb6:	53                   	push   %ebx
80104fb7:	e8 99 cc ff ff       	call   80101c55 <dirlink>
80104fbc:	83 c4 10             	add    $0x10,%esp
80104fbf:	85 c0                	test   %eax,%eax
80104fc1:	78 18                	js     80104fdb <create+0x143>
80104fc3:	83 ec 04             	sub    $0x4,%esp
80104fc6:	ff 76 04             	pushl  0x4(%esi)
80104fc9:	68 e7 7c 10 80       	push   $0x80107ce7
80104fce:	53                   	push   %ebx
80104fcf:	e8 81 cc ff ff       	call   80101c55 <dirlink>
80104fd4:	83 c4 10             	add    $0x10,%esp
80104fd7:	85 c0                	test   %eax,%eax
80104fd9:	79 8d                	jns    80104f68 <create+0xd0>
      panic("create dots");
80104fdb:	83 ec 0c             	sub    $0xc,%esp
80104fde:	68 ea 7c 10 80       	push   $0x80107cea
80104fe3:	e8 5c b3 ff ff       	call   80100344 <panic>
    panic("create: dirlink");
80104fe8:	83 ec 0c             	sub    $0xc,%esp
80104feb:	68 f6 7c 10 80       	push   $0x80107cf6
80104ff0:	e8 4f b3 ff ff       	call   80100344 <panic>
    return 0;
80104ff5:	89 c3                	mov    %eax,%ebx
80104ff7:	e9 0a ff ff ff       	jmp    80104f06 <create+0x6e>

80104ffc <sys_dup>:
{
80104ffc:	55                   	push   %ebp
80104ffd:	89 e5                	mov    %esp,%ebp
80104fff:	53                   	push   %ebx
80105000:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
80105003:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80105006:	ba 00 00 00 00       	mov    $0x0,%edx
8010500b:	b8 00 00 00 00       	mov    $0x0,%eax
80105010:	e8 e3 fd ff ff       	call   80104df8 <argfd>
80105015:	85 c0                	test   %eax,%eax
80105017:	78 23                	js     8010503c <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
80105019:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010501c:	e8 37 fe ff ff       	call   80104e58 <fdalloc>
80105021:	89 c3                	mov    %eax,%ebx
80105023:	85 c0                	test   %eax,%eax
80105025:	78 1c                	js     80105043 <sys_dup+0x47>
  filedup(f);
80105027:	83 ec 0c             	sub    $0xc,%esp
8010502a:	ff 75 f4             	pushl  -0xc(%ebp)
8010502d:	e8 2a bd ff ff       	call   80100d5c <filedup>
  return fd;
80105032:	83 c4 10             	add    $0x10,%esp
}
80105035:	89 d8                	mov    %ebx,%eax
80105037:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010503a:	c9                   	leave  
8010503b:	c3                   	ret    
    return -1;
8010503c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105041:	eb f2                	jmp    80105035 <sys_dup+0x39>
    return -1;
80105043:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105048:	eb eb                	jmp    80105035 <sys_dup+0x39>

8010504a <sys_read>:
{
8010504a:	55                   	push   %ebp
8010504b:	89 e5                	mov    %esp,%ebp
8010504d:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105050:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80105053:	ba 00 00 00 00       	mov    $0x0,%edx
80105058:	b8 00 00 00 00       	mov    $0x0,%eax
8010505d:	e8 96 fd ff ff       	call   80104df8 <argfd>
80105062:	85 c0                	test   %eax,%eax
80105064:	78 43                	js     801050a9 <sys_read+0x5f>
80105066:	83 ec 08             	sub    $0x8,%esp
80105069:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010506c:	50                   	push   %eax
8010506d:	6a 02                	push   $0x2
8010506f:	e8 75 fc ff ff       	call   80104ce9 <argint>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	78 35                	js     801050b0 <sys_read+0x66>
8010507b:	83 ec 04             	sub    $0x4,%esp
8010507e:	ff 75 f0             	pushl  -0x10(%ebp)
80105081:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105084:	50                   	push   %eax
80105085:	6a 01                	push   $0x1
80105087:	e8 83 fc ff ff       	call   80104d0f <argptr>
8010508c:	83 c4 10             	add    $0x10,%esp
8010508f:	85 c0                	test   %eax,%eax
80105091:	78 24                	js     801050b7 <sys_read+0x6d>
  return fileread(f, p, n);
80105093:	83 ec 04             	sub    $0x4,%esp
80105096:	ff 75 f0             	pushl  -0x10(%ebp)
80105099:	ff 75 ec             	pushl  -0x14(%ebp)
8010509c:	ff 75 f4             	pushl  -0xc(%ebp)
8010509f:	e8 f9 bd ff ff       	call   80100e9d <fileread>
801050a4:	83 c4 10             	add    $0x10,%esp
}
801050a7:	c9                   	leave  
801050a8:	c3                   	ret    
    return -1;
801050a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ae:	eb f7                	jmp    801050a7 <sys_read+0x5d>
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b5:	eb f0                	jmp    801050a7 <sys_read+0x5d>
801050b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050bc:	eb e9                	jmp    801050a7 <sys_read+0x5d>

801050be <sys_write>:
{
801050be:	55                   	push   %ebp
801050bf:	89 e5                	mov    %esp,%ebp
801050c1:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050c4:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801050c7:	ba 00 00 00 00       	mov    $0x0,%edx
801050cc:	b8 00 00 00 00       	mov    $0x0,%eax
801050d1:	e8 22 fd ff ff       	call   80104df8 <argfd>
801050d6:	85 c0                	test   %eax,%eax
801050d8:	78 43                	js     8010511d <sys_write+0x5f>
801050da:	83 ec 08             	sub    $0x8,%esp
801050dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050e0:	50                   	push   %eax
801050e1:	6a 02                	push   $0x2
801050e3:	e8 01 fc ff ff       	call   80104ce9 <argint>
801050e8:	83 c4 10             	add    $0x10,%esp
801050eb:	85 c0                	test   %eax,%eax
801050ed:	78 35                	js     80105124 <sys_write+0x66>
801050ef:	83 ec 04             	sub    $0x4,%esp
801050f2:	ff 75 f0             	pushl  -0x10(%ebp)
801050f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801050f8:	50                   	push   %eax
801050f9:	6a 01                	push   $0x1
801050fb:	e8 0f fc ff ff       	call   80104d0f <argptr>
80105100:	83 c4 10             	add    $0x10,%esp
80105103:	85 c0                	test   %eax,%eax
80105105:	78 24                	js     8010512b <sys_write+0x6d>
  return filewrite(f, p, n);
80105107:	83 ec 04             	sub    $0x4,%esp
8010510a:	ff 75 f0             	pushl  -0x10(%ebp)
8010510d:	ff 75 ec             	pushl  -0x14(%ebp)
80105110:	ff 75 f4             	pushl  -0xc(%ebp)
80105113:	e8 0a be ff ff       	call   80100f22 <filewrite>
80105118:	83 c4 10             	add    $0x10,%esp
}
8010511b:	c9                   	leave  
8010511c:	c3                   	ret    
    return -1;
8010511d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105122:	eb f7                	jmp    8010511b <sys_write+0x5d>
80105124:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105129:	eb f0                	jmp    8010511b <sys_write+0x5d>
8010512b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105130:	eb e9                	jmp    8010511b <sys_write+0x5d>

80105132 <sys_close>:
{
80105132:	55                   	push   %ebp
80105133:	89 e5                	mov    %esp,%ebp
80105135:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105138:	8d 4d f0             	lea    -0x10(%ebp),%ecx
8010513b:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010513e:	b8 00 00 00 00       	mov    $0x0,%eax
80105143:	e8 b0 fc ff ff       	call   80104df8 <argfd>
80105148:	85 c0                	test   %eax,%eax
8010514a:	78 25                	js     80105171 <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
8010514c:	e8 58 e4 ff ff       	call   801035a9 <myproc>
80105151:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105154:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010515b:	00 
  fileclose(f);
8010515c:	83 ec 0c             	sub    $0xc,%esp
8010515f:	ff 75 f0             	pushl  -0x10(%ebp)
80105162:	e8 3a bc ff ff       	call   80100da1 <fileclose>
  return 0;
80105167:	83 c4 10             	add    $0x10,%esp
8010516a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010516f:	c9                   	leave  
80105170:	c3                   	ret    
    return -1;
80105171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105176:	eb f7                	jmp    8010516f <sys_close+0x3d>

80105178 <sys_fstat>:
{
80105178:	55                   	push   %ebp
80105179:	89 e5                	mov    %esp,%ebp
8010517b:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010517e:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80105181:	ba 00 00 00 00       	mov    $0x0,%edx
80105186:	b8 00 00 00 00       	mov    $0x0,%eax
8010518b:	e8 68 fc ff ff       	call   80104df8 <argfd>
80105190:	85 c0                	test   %eax,%eax
80105192:	78 2a                	js     801051be <sys_fstat+0x46>
80105194:	83 ec 04             	sub    $0x4,%esp
80105197:	6a 14                	push   $0x14
80105199:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010519c:	50                   	push   %eax
8010519d:	6a 01                	push   $0x1
8010519f:	e8 6b fb ff ff       	call   80104d0f <argptr>
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	85 c0                	test   %eax,%eax
801051a9:	78 1a                	js     801051c5 <sys_fstat+0x4d>
  return filestat(f, st);
801051ab:	83 ec 08             	sub    $0x8,%esp
801051ae:	ff 75 f0             	pushl  -0x10(%ebp)
801051b1:	ff 75 f4             	pushl  -0xc(%ebp)
801051b4:	e8 9d bc ff ff       	call   80100e56 <filestat>
801051b9:	83 c4 10             	add    $0x10,%esp
}
801051bc:	c9                   	leave  
801051bd:	c3                   	ret    
    return -1;
801051be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c3:	eb f7                	jmp    801051bc <sys_fstat+0x44>
801051c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ca:	eb f0                	jmp    801051bc <sys_fstat+0x44>

801051cc <sys_link>:
{
801051cc:	55                   	push   %ebp
801051cd:	89 e5                	mov    %esp,%ebp
801051cf:	56                   	push   %esi
801051d0:	53                   	push   %ebx
801051d1:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801051d7:	50                   	push   %eax
801051d8:	6a 00                	push   $0x0
801051da:	e8 91 fb ff ff       	call   80104d70 <argstr>
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	85 c0                	test   %eax,%eax
801051e4:	0f 88 26 01 00 00    	js     80105310 <sys_link+0x144>
801051ea:	83 ec 08             	sub    $0x8,%esp
801051ed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801051f0:	50                   	push   %eax
801051f1:	6a 01                	push   $0x1
801051f3:	e8 78 fb ff ff       	call   80104d70 <argstr>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	0f 88 14 01 00 00    	js     80105317 <sys_link+0x14b>
  begin_op();
80105203:	e8 2c d6 ff ff       	call   80102834 <begin_op>
  if((ip = namei(old)) == 0){
80105208:	83 ec 0c             	sub    $0xc,%esp
8010520b:	ff 75 e0             	pushl  -0x20(%ebp)
8010520e:	e8 f7 ca ff ff       	call   80101d0a <namei>
80105213:	89 c3                	mov    %eax,%ebx
80105215:	83 c4 10             	add    $0x10,%esp
80105218:	85 c0                	test   %eax,%eax
8010521a:	0f 84 93 00 00 00    	je     801052b3 <sys_link+0xe7>
  ilock(ip);
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	50                   	push   %eax
80105224:	e8 44 c3 ff ff       	call   8010156d <ilock>
  if(ip->type == T_DIR){
80105229:	83 c4 10             	add    $0x10,%esp
8010522c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105231:	0f 84 88 00 00 00    	je     801052bf <sys_link+0xf3>
  ip->nlink++;
80105237:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
8010523c:	83 ec 0c             	sub    $0xc,%esp
8010523f:	53                   	push   %ebx
80105240:	e8 7e c2 ff ff       	call   801014c3 <iupdate>
  iunlock(ip);
80105245:	89 1c 24             	mov    %ebx,(%esp)
80105248:	e8 e2 c3 ff ff       	call   8010162f <iunlock>
  if((dp = nameiparent(new, name)) == 0)
8010524d:	83 c4 08             	add    $0x8,%esp
80105250:	8d 45 ea             	lea    -0x16(%ebp),%eax
80105253:	50                   	push   %eax
80105254:	ff 75 e4             	pushl  -0x1c(%ebp)
80105257:	e8 c6 ca ff ff       	call   80101d22 <nameiparent>
8010525c:	89 c6                	mov    %eax,%esi
8010525e:	83 c4 10             	add    $0x10,%esp
80105261:	85 c0                	test   %eax,%eax
80105263:	74 7e                	je     801052e3 <sys_link+0x117>
  ilock(dp);
80105265:	83 ec 0c             	sub    $0xc,%esp
80105268:	50                   	push   %eax
80105269:	e8 ff c2 ff ff       	call   8010156d <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	8b 03                	mov    (%ebx),%eax
80105273:	39 06                	cmp    %eax,(%esi)
80105275:	75 60                	jne    801052d7 <sys_link+0x10b>
80105277:	83 ec 04             	sub    $0x4,%esp
8010527a:	ff 73 04             	pushl  0x4(%ebx)
8010527d:	8d 45 ea             	lea    -0x16(%ebp),%eax
80105280:	50                   	push   %eax
80105281:	56                   	push   %esi
80105282:	e8 ce c9 ff ff       	call   80101c55 <dirlink>
80105287:	83 c4 10             	add    $0x10,%esp
8010528a:	85 c0                	test   %eax,%eax
8010528c:	78 49                	js     801052d7 <sys_link+0x10b>
  iunlockput(dp);
8010528e:	83 ec 0c             	sub    $0xc,%esp
80105291:	56                   	push   %esi
80105292:	e8 1f c5 ff ff       	call   801017b6 <iunlockput>
  iput(ip);
80105297:	89 1c 24             	mov    %ebx,(%esp)
8010529a:	e8 d5 c3 ff ff       	call   80101674 <iput>
  end_op();
8010529f:	e8 0b d6 ff ff       	call   801028af <end_op>
  return 0;
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052af:	5b                   	pop    %ebx
801052b0:	5e                   	pop    %esi
801052b1:	5d                   	pop    %ebp
801052b2:	c3                   	ret    
    end_op();
801052b3:	e8 f7 d5 ff ff       	call   801028af <end_op>
    return -1;
801052b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052bd:	eb ed                	jmp    801052ac <sys_link+0xe0>
    iunlockput(ip);
801052bf:	83 ec 0c             	sub    $0xc,%esp
801052c2:	53                   	push   %ebx
801052c3:	e8 ee c4 ff ff       	call   801017b6 <iunlockput>
    end_op();
801052c8:	e8 e2 d5 ff ff       	call   801028af <end_op>
    return -1;
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d5:	eb d5                	jmp    801052ac <sys_link+0xe0>
    iunlockput(dp);
801052d7:	83 ec 0c             	sub    $0xc,%esp
801052da:	56                   	push   %esi
801052db:	e8 d6 c4 ff ff       	call   801017b6 <iunlockput>
    goto bad;
801052e0:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052e3:	83 ec 0c             	sub    $0xc,%esp
801052e6:	53                   	push   %ebx
801052e7:	e8 81 c2 ff ff       	call   8010156d <ilock>
  ip->nlink--;
801052ec:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052f1:	89 1c 24             	mov    %ebx,(%esp)
801052f4:	e8 ca c1 ff ff       	call   801014c3 <iupdate>
  iunlockput(ip);
801052f9:	89 1c 24             	mov    %ebx,(%esp)
801052fc:	e8 b5 c4 ff ff       	call   801017b6 <iunlockput>
  end_op();
80105301:	e8 a9 d5 ff ff       	call   801028af <end_op>
  return -1;
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530e:	eb 9c                	jmp    801052ac <sys_link+0xe0>
    return -1;
80105310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105315:	eb 95                	jmp    801052ac <sys_link+0xe0>
80105317:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531c:	eb 8e                	jmp    801052ac <sys_link+0xe0>

8010531e <sys_unlink>:
{
8010531e:	55                   	push   %ebp
8010531f:	89 e5                	mov    %esp,%ebp
80105321:	57                   	push   %edi
80105322:	56                   	push   %esi
80105323:	53                   	push   %ebx
80105324:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105327:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010532a:	50                   	push   %eax
8010532b:	6a 00                	push   $0x0
8010532d:	e8 3e fa ff ff       	call   80104d70 <argstr>
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	85 c0                	test   %eax,%eax
80105337:	0f 88 81 01 00 00    	js     801054be <sys_unlink+0x1a0>
  begin_op();
8010533d:	e8 f2 d4 ff ff       	call   80102834 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105342:	83 ec 08             	sub    $0x8,%esp
80105345:	8d 45 ca             	lea    -0x36(%ebp),%eax
80105348:	50                   	push   %eax
80105349:	ff 75 c4             	pushl  -0x3c(%ebp)
8010534c:	e8 d1 c9 ff ff       	call   80101d22 <nameiparent>
80105351:	89 c7                	mov    %eax,%edi
80105353:	83 c4 10             	add    $0x10,%esp
80105356:	85 c0                	test   %eax,%eax
80105358:	0f 84 df 00 00 00    	je     8010543d <sys_unlink+0x11f>
  ilock(dp);
8010535e:	83 ec 0c             	sub    $0xc,%esp
80105361:	50                   	push   %eax
80105362:	e8 06 c2 ff ff       	call   8010156d <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105367:	83 c4 08             	add    $0x8,%esp
8010536a:	68 e8 7c 10 80       	push   $0x80107ce8
8010536f:	8d 45 ca             	lea    -0x36(%ebp),%eax
80105372:	50                   	push   %eax
80105373:	e8 a6 c6 ff ff       	call   80101a1e <namecmp>
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	85 c0                	test   %eax,%eax
8010537d:	0f 84 51 01 00 00    	je     801054d4 <sys_unlink+0x1b6>
80105383:	83 ec 08             	sub    $0x8,%esp
80105386:	68 e7 7c 10 80       	push   $0x80107ce7
8010538b:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010538e:	50                   	push   %eax
8010538f:	e8 8a c6 ff ff       	call   80101a1e <namecmp>
80105394:	83 c4 10             	add    $0x10,%esp
80105397:	85 c0                	test   %eax,%eax
80105399:	0f 84 35 01 00 00    	je     801054d4 <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010539f:	83 ec 04             	sub    $0x4,%esp
801053a2:	8d 45 c0             	lea    -0x40(%ebp),%eax
801053a5:	50                   	push   %eax
801053a6:	8d 45 ca             	lea    -0x36(%ebp),%eax
801053a9:	50                   	push   %eax
801053aa:	57                   	push   %edi
801053ab:	e8 83 c6 ff ff       	call   80101a33 <dirlookup>
801053b0:	89 c3                	mov    %eax,%ebx
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	85 c0                	test   %eax,%eax
801053b7:	0f 84 17 01 00 00    	je     801054d4 <sys_unlink+0x1b6>
  ilock(ip);
801053bd:	83 ec 0c             	sub    $0xc,%esp
801053c0:	50                   	push   %eax
801053c1:	e8 a7 c1 ff ff       	call   8010156d <ilock>
  if(ip->nlink < 1)
801053c6:	83 c4 10             	add    $0x10,%esp
801053c9:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053ce:	7e 79                	jle    80105449 <sys_unlink+0x12b>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053d5:	74 7f                	je     80105456 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
801053d7:	83 ec 04             	sub    $0x4,%esp
801053da:	6a 10                	push   $0x10
801053dc:	6a 00                	push   $0x0
801053de:	8d 75 d8             	lea    -0x28(%ebp),%esi
801053e1:	56                   	push   %esi
801053e2:	e8 7c f6 ff ff       	call   80104a63 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053e7:	6a 10                	push   $0x10
801053e9:	ff 75 c0             	pushl  -0x40(%ebp)
801053ec:	56                   	push   %esi
801053ed:	57                   	push   %edi
801053ee:	e8 0a c5 ff ff       	call   801018fd <writei>
801053f3:	83 c4 20             	add    $0x20,%esp
801053f6:	83 f8 10             	cmp    $0x10,%eax
801053f9:	0f 85 9c 00 00 00    	jne    8010549b <sys_unlink+0x17d>
  if(ip->type == T_DIR){
801053ff:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105404:	0f 84 9e 00 00 00    	je     801054a8 <sys_unlink+0x18a>
  iunlockput(dp);
8010540a:	83 ec 0c             	sub    $0xc,%esp
8010540d:	57                   	push   %edi
8010540e:	e8 a3 c3 ff ff       	call   801017b6 <iunlockput>
  ip->nlink--;
80105413:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105418:	89 1c 24             	mov    %ebx,(%esp)
8010541b:	e8 a3 c0 ff ff       	call   801014c3 <iupdate>
  iunlockput(ip);
80105420:	89 1c 24             	mov    %ebx,(%esp)
80105423:	e8 8e c3 ff ff       	call   801017b6 <iunlockput>
  end_op();
80105428:	e8 82 d4 ff ff       	call   801028af <end_op>
  return 0;
8010542d:	83 c4 10             	add    $0x10,%esp
80105430:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105435:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105438:	5b                   	pop    %ebx
80105439:	5e                   	pop    %esi
8010543a:	5f                   	pop    %edi
8010543b:	5d                   	pop    %ebp
8010543c:	c3                   	ret    
    end_op();
8010543d:	e8 6d d4 ff ff       	call   801028af <end_op>
    return -1;
80105442:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105447:	eb ec                	jmp    80105435 <sys_unlink+0x117>
    panic("unlink: nlink < 1");
80105449:	83 ec 0c             	sub    $0xc,%esp
8010544c:	68 06 7d 10 80       	push   $0x80107d06
80105451:	e8 ee ae ff ff       	call   80100344 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105456:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
8010545a:	0f 86 77 ff ff ff    	jbe    801053d7 <sys_unlink+0xb9>
80105460:	be 20 00 00 00       	mov    $0x20,%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105465:	6a 10                	push   $0x10
80105467:	56                   	push   %esi
80105468:	8d 45 b0             	lea    -0x50(%ebp),%eax
8010546b:	50                   	push   %eax
8010546c:	53                   	push   %ebx
8010546d:	e8 8f c3 ff ff       	call   80101801 <readi>
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	83 f8 10             	cmp    $0x10,%eax
80105478:	75 14                	jne    8010548e <sys_unlink+0x170>
    if(de.inum != 0)
8010547a:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
8010547f:	75 47                	jne    801054c8 <sys_unlink+0x1aa>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105481:	83 c6 10             	add    $0x10,%esi
80105484:	3b 73 58             	cmp    0x58(%ebx),%esi
80105487:	72 dc                	jb     80105465 <sys_unlink+0x147>
80105489:	e9 49 ff ff ff       	jmp    801053d7 <sys_unlink+0xb9>
      panic("isdirempty: readi");
8010548e:	83 ec 0c             	sub    $0xc,%esp
80105491:	68 18 7d 10 80       	push   $0x80107d18
80105496:	e8 a9 ae ff ff       	call   80100344 <panic>
    panic("unlink: writei");
8010549b:	83 ec 0c             	sub    $0xc,%esp
8010549e:	68 2a 7d 10 80       	push   $0x80107d2a
801054a3:	e8 9c ae ff ff       	call   80100344 <panic>
    dp->nlink--;
801054a8:	66 83 6f 56 01       	subw   $0x1,0x56(%edi)
    iupdate(dp);
801054ad:	83 ec 0c             	sub    $0xc,%esp
801054b0:	57                   	push   %edi
801054b1:	e8 0d c0 ff ff       	call   801014c3 <iupdate>
801054b6:	83 c4 10             	add    $0x10,%esp
801054b9:	e9 4c ff ff ff       	jmp    8010540a <sys_unlink+0xec>
    return -1;
801054be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c3:	e9 6d ff ff ff       	jmp    80105435 <sys_unlink+0x117>
    iunlockput(ip);
801054c8:	83 ec 0c             	sub    $0xc,%esp
801054cb:	53                   	push   %ebx
801054cc:	e8 e5 c2 ff ff       	call   801017b6 <iunlockput>
    goto bad;
801054d1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801054d4:	83 ec 0c             	sub    $0xc,%esp
801054d7:	57                   	push   %edi
801054d8:	e8 d9 c2 ff ff       	call   801017b6 <iunlockput>
  end_op();
801054dd:	e8 cd d3 ff ff       	call   801028af <end_op>
  return -1;
801054e2:	83 c4 10             	add    $0x10,%esp
801054e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ea:	e9 46 ff ff ff       	jmp    80105435 <sys_unlink+0x117>

801054ef <sys_open>:

int
sys_open(void)
{
801054ef:	55                   	push   %ebp
801054f0:	89 e5                	mov    %esp,%ebp
801054f2:	57                   	push   %edi
801054f3:	56                   	push   %esi
801054f4:	53                   	push   %ebx
801054f5:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054fb:	50                   	push   %eax
801054fc:	6a 00                	push   $0x0
801054fe:	e8 6d f8 ff ff       	call   80104d70 <argstr>
80105503:	83 c4 10             	add    $0x10,%esp
80105506:	85 c0                	test   %eax,%eax
80105508:	0f 88 0b 01 00 00    	js     80105619 <sys_open+0x12a>
8010550e:	83 ec 08             	sub    $0x8,%esp
80105511:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105514:	50                   	push   %eax
80105515:	6a 01                	push   $0x1
80105517:	e8 cd f7 ff ff       	call   80104ce9 <argint>
8010551c:	83 c4 10             	add    $0x10,%esp
8010551f:	85 c0                	test   %eax,%eax
80105521:	0f 88 f9 00 00 00    	js     80105620 <sys_open+0x131>
    return -1;

  begin_op();
80105527:	e8 08 d3 ff ff       	call   80102834 <begin_op>

  if(omode & O_CREATE){
8010552c:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80105530:	0f 84 8a 00 00 00    	je     801055c0 <sys_open+0xd1>
    ip = create(path, T_FILE, 0, 0);
80105536:	83 ec 0c             	sub    $0xc,%esp
80105539:	6a 00                	push   $0x0
8010553b:	b9 00 00 00 00       	mov    $0x0,%ecx
80105540:	ba 02 00 00 00       	mov    $0x2,%edx
80105545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105548:	e8 4b f9 ff ff       	call   80104e98 <create>
8010554d:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010554f:	83 c4 10             	add    $0x10,%esp
80105552:	85 c0                	test   %eax,%eax
80105554:	74 5e                	je     801055b4 <sys_open+0xc5>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105556:	e8 94 b7 ff ff       	call   80100cef <filealloc>
8010555b:	89 c3                	mov    %eax,%ebx
8010555d:	85 c0                	test   %eax,%eax
8010555f:	0f 84 ce 00 00 00    	je     80105633 <sys_open+0x144>
80105565:	e8 ee f8 ff ff       	call   80104e58 <fdalloc>
8010556a:	89 c7                	mov    %eax,%edi
8010556c:	85 c0                	test   %eax,%eax
8010556e:	0f 88 b3 00 00 00    	js     80105627 <sys_open+0x138>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105574:	83 ec 0c             	sub    $0xc,%esp
80105577:	56                   	push   %esi
80105578:	e8 b2 c0 ff ff       	call   8010162f <iunlock>
  end_op();
8010557d:	e8 2d d3 ff ff       	call   801028af <end_op>

  f->type = FD_INODE;
80105582:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80105588:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010558b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80105592:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105595:	89 d0                	mov    %edx,%eax
80105597:	83 f0 01             	xor    $0x1,%eax
8010559a:	83 e0 01             	and    $0x1,%eax
8010559d:	88 43 08             	mov    %al,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055a0:	83 c4 10             	add    $0x10,%esp
801055a3:	f6 c2 03             	test   $0x3,%dl
801055a6:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
801055aa:	89 f8                	mov    %edi,%eax
801055ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055af:	5b                   	pop    %ebx
801055b0:	5e                   	pop    %esi
801055b1:	5f                   	pop    %edi
801055b2:	5d                   	pop    %ebp
801055b3:	c3                   	ret    
      end_op();
801055b4:	e8 f6 d2 ff ff       	call   801028af <end_op>
      return -1;
801055b9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801055be:	eb ea                	jmp    801055aa <sys_open+0xbb>
    if((ip = namei(path)) == 0){
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	ff 75 e4             	pushl  -0x1c(%ebp)
801055c6:	e8 3f c7 ff ff       	call   80101d0a <namei>
801055cb:	89 c6                	mov    %eax,%esi
801055cd:	83 c4 10             	add    $0x10,%esp
801055d0:	85 c0                	test   %eax,%eax
801055d2:	74 39                	je     8010560d <sys_open+0x11e>
    ilock(ip);
801055d4:	83 ec 0c             	sub    $0xc,%esp
801055d7:	50                   	push   %eax
801055d8:	e8 90 bf ff ff       	call   8010156d <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055dd:	83 c4 10             	add    $0x10,%esp
801055e0:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055e5:	0f 85 6b ff ff ff    	jne    80105556 <sys_open+0x67>
801055eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801055ef:	0f 84 61 ff ff ff    	je     80105556 <sys_open+0x67>
      iunlockput(ip);
801055f5:	83 ec 0c             	sub    $0xc,%esp
801055f8:	56                   	push   %esi
801055f9:	e8 b8 c1 ff ff       	call   801017b6 <iunlockput>
      end_op();
801055fe:	e8 ac d2 ff ff       	call   801028af <end_op>
      return -1;
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010560b:	eb 9d                	jmp    801055aa <sys_open+0xbb>
      end_op();
8010560d:	e8 9d d2 ff ff       	call   801028af <end_op>
      return -1;
80105612:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80105617:	eb 91                	jmp    801055aa <sys_open+0xbb>
    return -1;
80105619:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010561e:	eb 8a                	jmp    801055aa <sys_open+0xbb>
80105620:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80105625:	eb 83                	jmp    801055aa <sys_open+0xbb>
      fileclose(f);
80105627:	83 ec 0c             	sub    $0xc,%esp
8010562a:	53                   	push   %ebx
8010562b:	e8 71 b7 ff ff       	call   80100da1 <fileclose>
80105630:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105633:	83 ec 0c             	sub    $0xc,%esp
80105636:	56                   	push   %esi
80105637:	e8 7a c1 ff ff       	call   801017b6 <iunlockput>
    end_op();
8010563c:	e8 6e d2 ff ff       	call   801028af <end_op>
    return -1;
80105641:	83 c4 10             	add    $0x10,%esp
80105644:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80105649:	e9 5c ff ff ff       	jmp    801055aa <sys_open+0xbb>

8010564e <sys_mkdir>:

int
sys_mkdir(void)
{
8010564e:	55                   	push   %ebp
8010564f:	89 e5                	mov    %esp,%ebp
80105651:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105654:	e8 db d1 ff ff       	call   80102834 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105659:	83 ec 08             	sub    $0x8,%esp
8010565c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010565f:	50                   	push   %eax
80105660:	6a 00                	push   $0x0
80105662:	e8 09 f7 ff ff       	call   80104d70 <argstr>
80105667:	83 c4 10             	add    $0x10,%esp
8010566a:	85 c0                	test   %eax,%eax
8010566c:	78 36                	js     801056a4 <sys_mkdir+0x56>
8010566e:	83 ec 0c             	sub    $0xc,%esp
80105671:	6a 00                	push   $0x0
80105673:	b9 00 00 00 00       	mov    $0x0,%ecx
80105678:	ba 01 00 00 00       	mov    $0x1,%edx
8010567d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105680:	e8 13 f8 ff ff       	call   80104e98 <create>
80105685:	83 c4 10             	add    $0x10,%esp
80105688:	85 c0                	test   %eax,%eax
8010568a:	74 18                	je     801056a4 <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010568c:	83 ec 0c             	sub    $0xc,%esp
8010568f:	50                   	push   %eax
80105690:	e8 21 c1 ff ff       	call   801017b6 <iunlockput>
  end_op();
80105695:	e8 15 d2 ff ff       	call   801028af <end_op>
  return 0;
8010569a:	83 c4 10             	add    $0x10,%esp
8010569d:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056a2:	c9                   	leave  
801056a3:	c3                   	ret    
    end_op();
801056a4:	e8 06 d2 ff ff       	call   801028af <end_op>
    return -1;
801056a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ae:	eb f2                	jmp    801056a2 <sys_mkdir+0x54>

801056b0 <sys_mknod>:

int
sys_mknod(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056b6:	e8 79 d1 ff ff       	call   80102834 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056bb:	83 ec 08             	sub    $0x8,%esp
801056be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c1:	50                   	push   %eax
801056c2:	6a 00                	push   $0x0
801056c4:	e8 a7 f6 ff ff       	call   80104d70 <argstr>
801056c9:	83 c4 10             	add    $0x10,%esp
801056cc:	85 c0                	test   %eax,%eax
801056ce:	78 62                	js     80105732 <sys_mknod+0x82>
     argint(1, &major) < 0 ||
801056d0:	83 ec 08             	sub    $0x8,%esp
801056d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056d6:	50                   	push   %eax
801056d7:	6a 01                	push   $0x1
801056d9:	e8 0b f6 ff ff       	call   80104ce9 <argint>
  if((argstr(0, &path)) < 0 ||
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	85 c0                	test   %eax,%eax
801056e3:	78 4d                	js     80105732 <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
801056e5:	83 ec 08             	sub    $0x8,%esp
801056e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056eb:	50                   	push   %eax
801056ec:	6a 02                	push   $0x2
801056ee:	e8 f6 f5 ff ff       	call   80104ce9 <argint>
     argint(1, &major) < 0 ||
801056f3:	83 c4 10             	add    $0x10,%esp
801056f6:	85 c0                	test   %eax,%eax
801056f8:	78 38                	js     80105732 <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056fa:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801056fe:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105701:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
80105705:	50                   	push   %eax
80105706:	ba 03 00 00 00       	mov    $0x3,%edx
8010570b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010570e:	e8 85 f7 ff ff       	call   80104e98 <create>
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	85 c0                	test   %eax,%eax
80105718:	74 18                	je     80105732 <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010571a:	83 ec 0c             	sub    $0xc,%esp
8010571d:	50                   	push   %eax
8010571e:	e8 93 c0 ff ff       	call   801017b6 <iunlockput>
  end_op();
80105723:	e8 87 d1 ff ff       	call   801028af <end_op>
  return 0;
80105728:	83 c4 10             	add    $0x10,%esp
8010572b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105730:	c9                   	leave  
80105731:	c3                   	ret    
    end_op();
80105732:	e8 78 d1 ff ff       	call   801028af <end_op>
    return -1;
80105737:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573c:	eb f2                	jmp    80105730 <sys_mknod+0x80>

8010573e <sys_chdir>:

int
sys_chdir(void)
{
8010573e:	55                   	push   %ebp
8010573f:	89 e5                	mov    %esp,%ebp
80105741:	56                   	push   %esi
80105742:	53                   	push   %ebx
80105743:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105746:	e8 5e de ff ff       	call   801035a9 <myproc>
8010574b:	89 c6                	mov    %eax,%esi

  begin_op();
8010574d:	e8 e2 d0 ff ff       	call   80102834 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105752:	83 ec 08             	sub    $0x8,%esp
80105755:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105758:	50                   	push   %eax
80105759:	6a 00                	push   $0x0
8010575b:	e8 10 f6 ff ff       	call   80104d70 <argstr>
80105760:	83 c4 10             	add    $0x10,%esp
80105763:	85 c0                	test   %eax,%eax
80105765:	78 52                	js     801057b9 <sys_chdir+0x7b>
80105767:	83 ec 0c             	sub    $0xc,%esp
8010576a:	ff 75 f4             	pushl  -0xc(%ebp)
8010576d:	e8 98 c5 ff ff       	call   80101d0a <namei>
80105772:	89 c3                	mov    %eax,%ebx
80105774:	83 c4 10             	add    $0x10,%esp
80105777:	85 c0                	test   %eax,%eax
80105779:	74 3e                	je     801057b9 <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
8010577b:	83 ec 0c             	sub    $0xc,%esp
8010577e:	50                   	push   %eax
8010577f:	e8 e9 bd ff ff       	call   8010156d <ilock>
  if(ip->type != T_DIR){
80105784:	83 c4 10             	add    $0x10,%esp
80105787:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010578c:	75 37                	jne    801057c5 <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010578e:	83 ec 0c             	sub    $0xc,%esp
80105791:	53                   	push   %ebx
80105792:	e8 98 be ff ff       	call   8010162f <iunlock>
  iput(curproc->cwd);
80105797:	83 c4 04             	add    $0x4,%esp
8010579a:	ff 76 68             	pushl  0x68(%esi)
8010579d:	e8 d2 be ff ff       	call   80101674 <iput>
  end_op();
801057a2:	e8 08 d1 ff ff       	call   801028af <end_op>
  curproc->cwd = ip;
801057a7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057aa:	83 c4 10             	add    $0x10,%esp
801057ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057b5:	5b                   	pop    %ebx
801057b6:	5e                   	pop    %esi
801057b7:	5d                   	pop    %ebp
801057b8:	c3                   	ret    
    end_op();
801057b9:	e8 f1 d0 ff ff       	call   801028af <end_op>
    return -1;
801057be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c3:	eb ed                	jmp    801057b2 <sys_chdir+0x74>
    iunlockput(ip);
801057c5:	83 ec 0c             	sub    $0xc,%esp
801057c8:	53                   	push   %ebx
801057c9:	e8 e8 bf ff ff       	call   801017b6 <iunlockput>
    end_op();
801057ce:	e8 dc d0 ff ff       	call   801028af <end_op>
    return -1;
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057db:	eb d5                	jmp    801057b2 <sys_chdir+0x74>

801057dd <sys_exec>:

int
sys_exec(void)
{
801057dd:	55                   	push   %ebp
801057de:	89 e5                	mov    %esp,%ebp
801057e0:	57                   	push   %edi
801057e1:	56                   	push   %esi
801057e2:	53                   	push   %ebx
801057e3:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057ec:	50                   	push   %eax
801057ed:	6a 00                	push   $0x0
801057ef:	e8 7c f5 ff ff       	call   80104d70 <argstr>
801057f4:	83 c4 10             	add    $0x10,%esp
801057f7:	85 c0                	test   %eax,%eax
801057f9:	0f 88 b4 00 00 00    	js     801058b3 <sys_exec+0xd6>
801057ff:	83 ec 08             	sub    $0x8,%esp
80105802:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105808:	50                   	push   %eax
80105809:	6a 01                	push   $0x1
8010580b:	e8 d9 f4 ff ff       	call   80104ce9 <argint>
80105810:	83 c4 10             	add    $0x10,%esp
80105813:	85 c0                	test   %eax,%eax
80105815:	0f 88 9f 00 00 00    	js     801058ba <sys_exec+0xdd>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010581b:	83 ec 04             	sub    $0x4,%esp
8010581e:	68 80 00 00 00       	push   $0x80
80105823:	6a 00                	push   $0x0
80105825:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
8010582b:	50                   	push   %eax
8010582c:	e8 32 f2 ff ff       	call   80104a63 <memset>
80105831:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105834:	be 00 00 00 00       	mov    $0x0,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105839:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
8010583f:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
80105846:	83 ec 08             	sub    $0x8,%esp
80105849:	57                   	push   %edi
8010584a:	89 d8                	mov    %ebx,%eax
8010584c:	03 85 60 ff ff ff    	add    -0xa0(%ebp),%eax
80105852:	50                   	push   %eax
80105853:	e8 05 f4 ff ff       	call   80104c5d <fetchint>
80105858:	83 c4 10             	add    $0x10,%esp
8010585b:	85 c0                	test   %eax,%eax
8010585d:	78 62                	js     801058c1 <sys_exec+0xe4>
      return -1;
    if(uarg == 0){
8010585f:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105865:	85 c0                	test   %eax,%eax
80105867:	74 28                	je     80105891 <sys_exec+0xb4>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105869:	83 ec 08             	sub    $0x8,%esp
8010586c:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
80105872:	01 d3                	add    %edx,%ebx
80105874:	53                   	push   %ebx
80105875:	50                   	push   %eax
80105876:	e8 1e f4 ff ff       	call   80104c99 <fetchstr>
8010587b:	83 c4 10             	add    $0x10,%esp
8010587e:	85 c0                	test   %eax,%eax
80105880:	78 4c                	js     801058ce <sys_exec+0xf1>
  for(i=0;; i++){
80105882:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
80105885:	83 fe 20             	cmp    $0x20,%esi
80105888:	75 b5                	jne    8010583f <sys_exec+0x62>
      return -1;
8010588a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588f:	eb 35                	jmp    801058c6 <sys_exec+0xe9>
      argv[i] = 0;
80105891:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80105898:	00 00 00 00 
      return -1;
  }
  return exec(path, argv);
8010589c:	83 ec 08             	sub    $0x8,%esp
8010589f:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801058a5:	50                   	push   %eax
801058a6:	ff 75 e4             	pushl  -0x1c(%ebp)
801058a9:	e8 e9 b0 ff ff       	call   80100997 <exec>
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	eb 13                	jmp    801058c6 <sys_exec+0xe9>
    return -1;
801058b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b8:	eb 0c                	jmp    801058c6 <sys_exec+0xe9>
801058ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058bf:	eb 05                	jmp    801058c6 <sys_exec+0xe9>
      return -1;
801058c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058c9:	5b                   	pop    %ebx
801058ca:	5e                   	pop    %esi
801058cb:	5f                   	pop    %edi
801058cc:	5d                   	pop    %ebp
801058cd:	c3                   	ret    
      return -1;
801058ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d3:	eb f1                	jmp    801058c6 <sys_exec+0xe9>

801058d5 <sys_pipe>:

int
sys_pipe(void)
{
801058d5:	55                   	push   %ebp
801058d6:	89 e5                	mov    %esp,%ebp
801058d8:	53                   	push   %ebx
801058d9:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058dc:	6a 08                	push   $0x8
801058de:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058e1:	50                   	push   %eax
801058e2:	6a 00                	push   $0x0
801058e4:	e8 26 f4 ff ff       	call   80104d0f <argptr>
801058e9:	83 c4 10             	add    $0x10,%esp
801058ec:	85 c0                	test   %eax,%eax
801058ee:	78 46                	js     80105936 <sys_pipe+0x61>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058f0:	83 ec 08             	sub    $0x8,%esp
801058f3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058f6:	50                   	push   %eax
801058f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058fa:	50                   	push   %eax
801058fb:	e8 63 d5 ff ff       	call   80102e63 <pipealloc>
80105900:	83 c4 10             	add    $0x10,%esp
80105903:	85 c0                	test   %eax,%eax
80105905:	78 36                	js     8010593d <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105907:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010590a:	e8 49 f5 ff ff       	call   80104e58 <fdalloc>
8010590f:	89 c3                	mov    %eax,%ebx
80105911:	85 c0                	test   %eax,%eax
80105913:	78 3c                	js     80105951 <sys_pipe+0x7c>
80105915:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105918:	e8 3b f5 ff ff       	call   80104e58 <fdalloc>
8010591d:	85 c0                	test   %eax,%eax
8010591f:	78 23                	js     80105944 <sys_pipe+0x6f>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105921:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105924:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80105926:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105929:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
8010592c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105931:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105934:	c9                   	leave  
80105935:	c3                   	ret    
    return -1;
80105936:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593b:	eb f4                	jmp    80105931 <sys_pipe+0x5c>
    return -1;
8010593d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105942:	eb ed                	jmp    80105931 <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80105944:	e8 60 dc ff ff       	call   801035a9 <myproc>
80105949:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80105950:	00 
    fileclose(rf);
80105951:	83 ec 0c             	sub    $0xc,%esp
80105954:	ff 75 f0             	pushl  -0x10(%ebp)
80105957:	e8 45 b4 ff ff       	call   80100da1 <fileclose>
    fileclose(wf);
8010595c:	83 c4 04             	add    $0x4,%esp
8010595f:	ff 75 ec             	pushl  -0x14(%ebp)
80105962:	e8 3a b4 ff ff       	call   80100da1 <fileclose>
    return -1;
80105967:	83 c4 10             	add    $0x10,%esp
8010596a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596f:	eb c0                	jmp    80105931 <sys_pipe+0x5c>

80105971 <sys_fork>:
#include "pdx-kernel.h"
#endif // PDX_XV6

int
sys_fork(void)
{
80105971:	55                   	push   %ebp
80105972:	89 e5                	mov    %esp,%ebp
80105974:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105977:	e8 6f df ff ff       	call   801038eb <fork>
}
8010597c:	c9                   	leave  
8010597d:	c3                   	ret    

8010597e <sys_exit>:

int
sys_exit(void)
{
8010597e:	55                   	push   %ebp
8010597f:	89 e5                	mov    %esp,%ebp
80105981:	83 ec 08             	sub    $0x8,%esp
  exit();
80105984:	e8 6c e2 ff ff       	call   80103bf5 <exit>
  return 0;  // not reached
}
80105989:	b8 00 00 00 00       	mov    $0x0,%eax
8010598e:	c9                   	leave  
8010598f:	c3                   	ret    

80105990 <sys_wait>:

int
sys_wait(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105996:	e8 f5 e4 ff ff       	call   80103e90 <wait>
}
8010599b:	c9                   	leave  
8010599c:	c3                   	ret    

8010599d <sys_kill>:

int
sys_kill(void)
{
8010599d:	55                   	push   %ebp
8010599e:	89 e5                	mov    %esp,%ebp
801059a0:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059a6:	50                   	push   %eax
801059a7:	6a 00                	push   $0x0
801059a9:	e8 3b f3 ff ff       	call   80104ce9 <argint>
801059ae:	83 c4 10             	add    $0x10,%esp
801059b1:	85 c0                	test   %eax,%eax
801059b3:	78 10                	js     801059c5 <sys_kill+0x28>
    return -1;
  return kill(pid);
801059b5:	83 ec 0c             	sub    $0xc,%esp
801059b8:	ff 75 f4             	pushl  -0xc(%ebp)
801059bb:	e8 b3 e6 ff ff       	call   80104073 <kill>
801059c0:	83 c4 10             	add    $0x10,%esp
}
801059c3:	c9                   	leave  
801059c4:	c3                   	ret    
    return -1;
801059c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ca:	eb f7                	jmp    801059c3 <sys_kill+0x26>

801059cc <sys_getpid>:

int
sys_getpid(void)
{
801059cc:	55                   	push   %ebp
801059cd:	89 e5                	mov    %esp,%ebp
801059cf:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059d2:	e8 d2 db ff ff       	call   801035a9 <myproc>
801059d7:	8b 40 10             	mov    0x10(%eax),%eax
}
801059da:	c9                   	leave  
801059db:	c3                   	ret    

801059dc <sys_sbrk>:

int
sys_sbrk(void)
{
801059dc:	55                   	push   %ebp
801059dd:	89 e5                	mov    %esp,%ebp
801059df:	53                   	push   %ebx
801059e0:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059e6:	50                   	push   %eax
801059e7:	6a 00                	push   $0x0
801059e9:	e8 fb f2 ff ff       	call   80104ce9 <argint>
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	85 c0                	test   %eax,%eax
801059f3:	78 26                	js     80105a1b <sys_sbrk+0x3f>
    return -1;
  addr = myproc()->sz;
801059f5:	e8 af db ff ff       	call   801035a9 <myproc>
801059fa:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059fc:	83 ec 0c             	sub    $0xc,%esp
801059ff:	ff 75 f4             	pushl  -0xc(%ebp)
80105a02:	e8 77 de ff ff       	call   8010387e <growproc>
80105a07:	83 c4 10             	add    $0x10,%esp
80105a0a:	85 c0                	test   %eax,%eax
    return -1;
80105a0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a11:	0f 48 d8             	cmovs  %eax,%ebx
  return addr;
}
80105a14:	89 d8                	mov    %ebx,%eax
80105a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a19:	c9                   	leave  
80105a1a:	c3                   	ret    
    return -1;
80105a1b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a20:	eb f2                	jmp    80105a14 <sys_sbrk+0x38>

80105a22 <sys_sleep>:

int
sys_sleep(void)
{
80105a22:	55                   	push   %ebp
80105a23:	89 e5                	mov    %esp,%ebp
80105a25:	56                   	push   %esi
80105a26:	53                   	push   %ebx
80105a27:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a2d:	50                   	push   %eax
80105a2e:	6a 00                	push   $0x0
80105a30:	e8 b4 f2 ff ff       	call   80104ce9 <argint>
80105a35:	83 c4 10             	add    $0x10,%esp
80105a38:	85 c0                	test   %eax,%eax
80105a3a:	78 39                	js     80105a75 <sys_sleep+0x53>
    return -1;
  ticks0 = ticks;
80105a3c:	8b 35 c0 5a 11 80    	mov    0x80115ac0,%esi
  while(ticks - ticks0 < n){
80105a42:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105a45:	85 db                	test   %ebx,%ebx
80105a47:	74 38                	je     80105a81 <sys_sleep+0x5f>
    if(myproc()->killed){
80105a49:	e8 5b db ff ff       	call   801035a9 <myproc>
80105a4e:	8b 58 24             	mov    0x24(%eax),%ebx
80105a51:	85 db                	test   %ebx,%ebx
80105a53:	75 27                	jne    80105a7c <sys_sleep+0x5a>
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
80105a55:	83 ec 08             	sub    $0x8,%esp
80105a58:	6a 00                	push   $0x0
80105a5a:	68 c0 5a 11 80       	push   $0x80115ac0
80105a5f:	e8 f3 e2 ff ff       	call   80103d57 <sleep>
  while(ticks - ticks0 < n){
80105a64:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80105a69:	29 f0                	sub    %esi,%eax
80105a6b:	83 c4 10             	add    $0x10,%esp
80105a6e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a71:	72 d6                	jb     80105a49 <sys_sleep+0x27>
80105a73:	eb 0c                	jmp    80105a81 <sys_sleep+0x5f>
    return -1;
80105a75:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a7a:	eb 05                	jmp    80105a81 <sys_sleep+0x5f>
      return -1;
80105a7c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  }
  return 0;
}
80105a81:	89 d8                	mov    %ebx,%eax
80105a83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a86:	5b                   	pop    %ebx
80105a87:	5e                   	pop    %esi
80105a88:	5d                   	pop    %ebp
80105a89:	c3                   	ret    

80105a8a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a8a:	55                   	push   %ebp
80105a8b:	89 e5                	mov    %esp,%ebp
  uint xticks;

  xticks = ticks;
  return xticks;
}
80105a8d:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80105a92:	5d                   	pop    %ebp
80105a93:	c3                   	ret    

80105a94 <sys_halt>:

#ifdef PDX_XV6
// Turn off the computer
int
sys_halt(void)
{
80105a94:	55                   	push   %ebp
80105a95:	89 e5                	mov    %esp,%ebp
80105a97:	83 ec 14             	sub    $0x14,%esp
  cprintf("Shutting down ...\n");
80105a9a:	68 39 7d 10 80       	push   $0x80107d39
80105a9f:	e8 3d ab ff ff       	call   801005e1 <cprintf>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105aa4:	b8 00 20 00 00       	mov    $0x2000,%eax
80105aa9:	ba 04 06 00 00       	mov    $0x604,%edx
80105aae:	66 ef                	out    %ax,(%dx)
  outw( 0x604, 0x0 | 0x2000);
  return 0;
}
80105ab0:	b8 00 00 00 00       	mov    $0x0,%eax
80105ab5:	c9                   	leave  
80105ab6:	c3                   	ret    

80105ab7 <sys_date>:

#ifdef CS333_P1
//Checks if argument successfully was read. Get the time.
int
sys_date(void)
{
80105ab7:	55                   	push   %ebp
80105ab8:	89 e5                	mov    %esp,%ebp
80105aba:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *d;
  
  if(argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0)
80105abd:	6a 18                	push   $0x18
80105abf:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac2:	50                   	push   %eax
80105ac3:	6a 00                	push   $0x0
80105ac5:	e8 45 f2 ff ff       	call   80104d0f <argptr>
80105aca:	83 c4 10             	add    $0x10,%esp
80105acd:	85 c0                	test   %eax,%eax
80105acf:	78 15                	js     80105ae6 <sys_date+0x2f>
    return -1;

  cmostime(d);
80105ad1:	83 ec 0c             	sub    $0xc,%esp
80105ad4:	ff 75 f4             	pushl  -0xc(%ebp)
80105ad7:	e8 c5 ca ff ff       	call   801025a1 <cmostime>
  return 0;
80105adc:	83 c4 10             	add    $0x10,%esp
80105adf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ae4:	c9                   	leave  
80105ae5:	c3                   	ret    
    return -1;
80105ae6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aeb:	eb f7                	jmp    80105ae4 <sys_date+0x2d>

80105aed <sys_getuid>:

#ifdef CS333_P2
//Returns the uid
uint
sys_getuid(void)
{
80105aed:	55                   	push   %ebp
80105aee:	89 e5                	mov    %esp,%ebp
80105af0:	83 ec 08             	sub    $0x8,%esp
  return myproc() -> uid;
80105af3:	e8 b1 da ff ff       	call   801035a9 <myproc>
80105af8:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80105afe:	c9                   	leave  
80105aff:	c3                   	ret    

80105b00 <sys_getgid>:


//Returns the gid
uint
sys_getgid(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 08             	sub    $0x8,%esp
  return myproc() -> gid;
80105b06:	e8 9e da ff ff       	call   801035a9 <myproc>
80105b0b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80105b11:	c9                   	leave  
80105b12:	c3                   	ret    

80105b13 <sys_getppid>:


//Returns the ppid
uint
sys_getppid(void)
{
80105b13:	55                   	push   %ebp
80105b14:	89 e5                	mov    %esp,%ebp
80105b16:	83 ec 08             	sub    $0x8,%esp
  if(myproc() -> parent == NULL)
80105b19:	e8 8b da ff ff       	call   801035a9 <myproc>
80105b1e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
80105b22:	74 0d                	je     80105b31 <sys_getppid+0x1e>
     return myproc() -> pid;
 
  return myproc() -> parent -> pid;
80105b24:	e8 80 da ff ff       	call   801035a9 <myproc>
80105b29:	8b 40 14             	mov    0x14(%eax),%eax
80105b2c:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b2f:	c9                   	leave  
80105b30:	c3                   	ret    
     return myproc() -> pid;
80105b31:	e8 73 da ff ff       	call   801035a9 <myproc>
80105b36:	8b 40 10             	mov    0x10(%eax),%eax
80105b39:	eb f4                	jmp    80105b2f <sys_getppid+0x1c>

80105b3b <sys_setuid>:


//Called by test1P2. Makes sure uid is set in the correct range.
int
sys_setuid(void)
{
80105b3b:	55                   	push   %ebp
80105b3c:	89 e5                	mov    %esp,%ebp
80105b3e:	83 ec 20             	sub    $0x20,%esp
  int uid;
   
  if(argint(0, &uid) < 0)
80105b41:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b44:	50                   	push   %eax
80105b45:	6a 00                	push   $0x0
80105b47:	e8 9d f1 ff ff       	call   80104ce9 <argint>
80105b4c:	83 c4 10             	add    $0x10,%esp
80105b4f:	85 c0                	test   %eax,%eax
80105b51:	78 30                	js     80105b83 <sys_setuid+0x48>
    return -1;
  cprintf("UID TEST: my variable is %d\n", uid);
80105b53:	83 ec 08             	sub    $0x8,%esp
80105b56:	ff 75 f4             	pushl  -0xc(%ebp)
80105b59:	68 4c 7d 10 80       	push   $0x80107d4c
80105b5e:	e8 7e aa ff ff       	call   801005e1 <cprintf>
  if(uid < 0 || uid > 32767)
80105b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b66:	83 c4 10             	add    $0x10,%esp
80105b69:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80105b6e:	77 1a                	ja     80105b8a <sys_setuid+0x4f>
    return -1;

  setuid(uid);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	50                   	push   %eax
80105b74:	e8 2f ea ff ff       	call   801045a8 <setuid>
  return 1;
80105b79:	83 c4 10             	add    $0x10,%esp
80105b7c:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b81:	c9                   	leave  
80105b82:	c3                   	ret    
    return -1;
80105b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b88:	eb f7                	jmp    80105b81 <sys_setuid+0x46>
    return -1;
80105b8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b8f:	eb f0                	jmp    80105b81 <sys_setuid+0x46>

80105b91 <sys_setgid>:


//Called by test1P2. Makes sure gid is set in the correct range.
int
sys_setgid(void)
{
80105b91:	55                   	push   %ebp
80105b92:	89 e5                	mov    %esp,%ebp
80105b94:	83 ec 20             	sub    $0x20,%esp
  int gid;
   
  if(argint(0, &gid) < 0)
80105b97:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b9a:	50                   	push   %eax
80105b9b:	6a 00                	push   $0x0
80105b9d:	e8 47 f1 ff ff       	call   80104ce9 <argint>
80105ba2:	83 c4 10             	add    $0x10,%esp
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	78 30                	js     80105bd9 <sys_setgid+0x48>
    return -1;
  cprintf("GID TEST: my variable is %d\n", gid);
80105ba9:	83 ec 08             	sub    $0x8,%esp
80105bac:	ff 75 f4             	pushl  -0xc(%ebp)
80105baf:	68 69 7d 10 80       	push   $0x80107d69
80105bb4:	e8 28 aa ff ff       	call   801005e1 <cprintf>
  if(gid < 0 || gid > 32767)
80105bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bbc:	83 c4 10             	add    $0x10,%esp
80105bbf:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80105bc4:	77 1a                	ja     80105be0 <sys_setgid+0x4f>
    return -1;

  setgid(gid);
80105bc6:	83 ec 0c             	sub    $0xc,%esp
80105bc9:	50                   	push   %eax
80105bca:	e8 0a ea ff ff       	call   801045d9 <setgid>
  return 1;
80105bcf:	83 c4 10             	add    $0x10,%esp
80105bd2:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105bd7:	c9                   	leave  
80105bd8:	c3                   	ret    
    return -1;
80105bd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bde:	eb f7                	jmp    80105bd7 <sys_setgid+0x46>
    return -1;
80105be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be5:	eb f0                	jmp    80105bd7 <sys_setgid+0x46>

80105be7 <sys_getprocs>:


//Wrapper for getting the current processes. 
int
sys_getprocs(void)
{
80105be7:	55                   	push   %ebp
80105be8:	89 e5                	mov    %esp,%ebp
80105bea:	83 ec 20             	sub    $0x20,%esp
  int max;
  struct uproc * table;
  if (argint(0, &max) < 0 || argptr(1, (void*)&table, sizeof(struct uproc)) < 0)
80105bed:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bf0:	50                   	push   %eax
80105bf1:	6a 00                	push   $0x0
80105bf3:	e8 f1 f0 ff ff       	call   80104ce9 <argint>
80105bf8:	83 c4 10             	add    $0x10,%esp
80105bfb:	85 c0                	test   %eax,%eax
80105bfd:	78 2f                	js     80105c2e <sys_getprocs+0x47>
80105bff:	83 ec 04             	sub    $0x4,%esp
80105c02:	6a 60                	push   $0x60
80105c04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c07:	50                   	push   %eax
80105c08:	6a 01                	push   $0x1
80105c0a:	e8 00 f1 ff ff       	call   80104d0f <argptr>
80105c0f:	83 c4 10             	add    $0x10,%esp
80105c12:	85 c0                	test   %eax,%eax
80105c14:	78 1f                	js     80105c35 <sys_getprocs+0x4e>
    return -1;

  else
  {
    if(max > 0)
80105c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c19:	85 c0                	test   %eax,%eax
80105c1b:	7e 1f                	jle    80105c3c <sys_getprocs+0x55>
      return getprocs(max, table); //implemented in proc.c
80105c1d:	83 ec 08             	sub    $0x8,%esp
80105c20:	ff 75 f0             	pushl  -0x10(%ebp)
80105c23:	50                   	push   %eax
80105c24:	e8 e1 e9 ff ff       	call   8010460a <getprocs>
80105c29:	83 c4 10             	add    $0x10,%esp
    else
      return -1;
  }
}
80105c2c:	c9                   	leave  
80105c2d:	c3                   	ret    
    return -1;
80105c2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c33:	eb f7                	jmp    80105c2c <sys_getprocs+0x45>
80105c35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c3a:	eb f0                	jmp    80105c2c <sys_getprocs+0x45>
      return -1;
80105c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c41:	eb e9                	jmp    80105c2c <sys_getprocs+0x45>

80105c43 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c43:	1e                   	push   %ds
  pushl %es
80105c44:	06                   	push   %es
  pushl %fs
80105c45:	0f a0                	push   %fs
  pushl %gs
80105c47:	0f a8                	push   %gs
  pushal
80105c49:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c4a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c4e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c50:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c52:	54                   	push   %esp
  call trap
80105c53:	e8 a5 00 00 00       	call   80105cfd <trap>
  addl $4, %esp
80105c58:	83 c4 04             	add    $0x4,%esp

80105c5b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c5b:	61                   	popa   
  popl %gs
80105c5c:	0f a9                	pop    %gs
  popl %fs
80105c5e:	0f a1                	pop    %fs
  popl %es
80105c60:	07                   	pop    %es
  popl %ds
80105c61:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c62:	83 c4 08             	add    $0x8,%esp
  iret
80105c65:	cf                   	iret   

80105c66 <tvinit>:
uint ticks;
#endif // PDX_XV6

void
tvinit(void)
{
80105c66:	55                   	push   %ebp
80105c67:	89 e5                	mov    %esp,%ebp
  int i;

  for(i = 0; i < 256; i++)
80105c69:	b8 00 00 00 00       	mov    $0x0,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c6e:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105c75:	66 89 14 c5 c0 52 11 	mov    %dx,-0x7feead40(,%eax,8)
80105c7c:	80 
80105c7d:	66 c7 04 c5 c2 52 11 	movw   $0x8,-0x7feead3e(,%eax,8)
80105c84:	80 08 00 
80105c87:	c6 04 c5 c4 52 11 80 	movb   $0x0,-0x7feead3c(,%eax,8)
80105c8e:	00 
80105c8f:	c6 04 c5 c5 52 11 80 	movb   $0x8e,-0x7feead3b(,%eax,8)
80105c96:	8e 
80105c97:	c1 ea 10             	shr    $0x10,%edx
80105c9a:	66 89 14 c5 c6 52 11 	mov    %dx,-0x7feead3a(,%eax,8)
80105ca1:	80 
  for(i = 0; i < 256; i++)
80105ca2:	83 c0 01             	add    $0x1,%eax
80105ca5:	3d 00 01 00 00       	cmp    $0x100,%eax
80105caa:	75 c2                	jne    80105c6e <tvinit+0x8>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cac:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105cb1:	66 a3 c0 54 11 80    	mov    %ax,0x801154c0
80105cb7:	66 c7 05 c2 54 11 80 	movw   $0x8,0x801154c2
80105cbe:	08 00 
80105cc0:	c6 05 c4 54 11 80 00 	movb   $0x0,0x801154c4
80105cc7:	c6 05 c5 54 11 80 ef 	movb   $0xef,0x801154c5
80105cce:	c1 e8 10             	shr    $0x10,%eax
80105cd1:	66 a3 c6 54 11 80    	mov    %ax,0x801154c6

#ifndef PDX_XV6
  initlock(&tickslock, "time");
#endif // PDX_XV6
}
80105cd7:	5d                   	pop    %ebp
80105cd8:	c3                   	ret    

80105cd9 <idtinit>:

void
idtinit(void)
{
80105cd9:	55                   	push   %ebp
80105cda:	89 e5                	mov    %esp,%ebp
80105cdc:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105cdf:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105ce5:	b8 c0 52 11 80       	mov    $0x801152c0,%eax
80105cea:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105cee:	c1 e8 10             	shr    $0x10,%eax
80105cf1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105cf5:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105cf8:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105cfb:	c9                   	leave  
80105cfc:	c3                   	ret    

80105cfd <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105cfd:	55                   	push   %ebp
80105cfe:	89 e5                	mov    %esp,%ebp
80105d00:	57                   	push   %edi
80105d01:	56                   	push   %esi
80105d02:	53                   	push   %ebx
80105d03:	83 ec 1c             	sub    $0x1c,%esp
80105d06:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105d09:	8b 47 30             	mov    0x30(%edi),%eax
80105d0c:	83 f8 40             	cmp    $0x40,%eax
80105d0f:	74 13                	je     80105d24 <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d11:	83 e8 20             	sub    $0x20,%eax
80105d14:	83 f8 1f             	cmp    $0x1f,%eax
80105d17:	0f 87 1f 01 00 00    	ja     80105e3c <trap+0x13f>
80105d1d:	ff 24 85 28 7e 10 80 	jmp    *-0x7fef81d8(,%eax,4)
    if(myproc()->killed)
80105d24:	e8 80 d8 ff ff       	call   801035a9 <myproc>
80105d29:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105d2d:	75 1f                	jne    80105d4e <trap+0x51>
    myproc()->tf = tf;
80105d2f:	e8 75 d8 ff ff       	call   801035a9 <myproc>
80105d34:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105d37:	e8 67 f0 ff ff       	call   80104da3 <syscall>
    if(myproc()->killed)
80105d3c:	e8 68 d8 ff ff       	call   801035a9 <myproc>
80105d41:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105d45:	74 7e                	je     80105dc5 <trap+0xc8>
      exit();
80105d47:	e8 a9 de ff ff       	call   80103bf5 <exit>
80105d4c:	eb 77                	jmp    80105dc5 <trap+0xc8>
      exit();
80105d4e:	e8 a2 de ff ff       	call   80103bf5 <exit>
80105d53:	eb da                	jmp    80105d2f <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105d55:	e8 34 d8 ff ff       	call   8010358e <cpuid>
80105d5a:	85 c0                	test   %eax,%eax
80105d5c:	74 6f                	je     80105dcd <trap+0xd0>
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
#endif // PDX_XV6
    }
    lapiceoi();
80105d5e:	e8 7e c7 ff ff       	call   801024e1 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d63:	e8 41 d8 ff ff       	call   801035a9 <myproc>
80105d68:	85 c0                	test   %eax,%eax
80105d6a:	74 1c                	je     80105d88 <trap+0x8b>
80105d6c:	e8 38 d8 ff ff       	call   801035a9 <myproc>
80105d71:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105d75:	74 11                	je     80105d88 <trap+0x8b>
80105d77:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d7b:	83 e0 03             	and    $0x3,%eax
80105d7e:	66 83 f8 03          	cmp    $0x3,%ax
80105d82:	0f 84 48 01 00 00    	je     80105ed0 <trap+0x1d3>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d88:	e8 1c d8 ff ff       	call   801035a9 <myproc>
80105d8d:	85 c0                	test   %eax,%eax
80105d8f:	74 0f                	je     80105da0 <trap+0xa3>
80105d91:	e8 13 d8 ff ff       	call   801035a9 <myproc>
80105d96:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d9a:	0f 84 3a 01 00 00    	je     80105eda <trap+0x1dd>
    tf->trapno == T_IRQ0+IRQ_TIMER)
#endif // PDX_XV6
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105da0:	e8 04 d8 ff ff       	call   801035a9 <myproc>
80105da5:	85 c0                	test   %eax,%eax
80105da7:	74 1c                	je     80105dc5 <trap+0xc8>
80105da9:	e8 fb d7 ff ff       	call   801035a9 <myproc>
80105dae:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105db2:	74 11                	je     80105dc5 <trap+0xc8>
80105db4:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105db8:	83 e0 03             	and    $0x3,%eax
80105dbb:	66 83 f8 03          	cmp    $0x3,%ax
80105dbf:	0f 84 48 01 00 00    	je     80105f0d <trap+0x210>
    exit();
}
80105dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dc8:	5b                   	pop    %ebx
80105dc9:	5e                   	pop    %esi
80105dca:	5f                   	pop    %edi
80105dcb:	5d                   	pop    %ebp
80105dcc:	c3                   	ret    
// atom_inc() necessary for removal of tickslock
// other atomic ops added for completeness
static inline void
atom_inc(volatile int *num)
{
  asm volatile ( "lock incl %0" : "=m" (*num));
80105dcd:	f0 ff 05 c0 5a 11 80 	lock incl 0x80115ac0
      wakeup(&ticks);
80105dd4:	83 ec 0c             	sub    $0xc,%esp
80105dd7:	68 c0 5a 11 80       	push   $0x80115ac0
80105ddc:	e8 69 e2 ff ff       	call   8010404a <wakeup>
80105de1:	83 c4 10             	add    $0x10,%esp
80105de4:	e9 75 ff ff ff       	jmp    80105d5e <trap+0x61>
    ideintr();
80105de9:	e8 89 c0 ff ff       	call   80101e77 <ideintr>
    lapiceoi();
80105dee:	e8 ee c6 ff ff       	call   801024e1 <lapiceoi>
    break;
80105df3:	e9 6b ff ff ff       	jmp    80105d63 <trap+0x66>
    kbdintr();
80105df8:	e8 18 c5 ff ff       	call   80102315 <kbdintr>
    lapiceoi();
80105dfd:	e8 df c6 ff ff       	call   801024e1 <lapiceoi>
    break;
80105e02:	e9 5c ff ff ff       	jmp    80105d63 <trap+0x66>
    uartintr();
80105e07:	e8 39 02 00 00       	call   80106045 <uartintr>
    lapiceoi();
80105e0c:	e8 d0 c6 ff ff       	call   801024e1 <lapiceoi>
    break;
80105e11:	e9 4d ff ff ff       	jmp    80105d63 <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e16:	8b 77 38             	mov    0x38(%edi),%esi
80105e19:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105e1d:	e8 6c d7 ff ff       	call   8010358e <cpuid>
80105e22:	56                   	push   %esi
80105e23:	53                   	push   %ebx
80105e24:	50                   	push   %eax
80105e25:	68 88 7d 10 80       	push   $0x80107d88
80105e2a:	e8 b2 a7 ff ff       	call   801005e1 <cprintf>
    lapiceoi();
80105e2f:	e8 ad c6 ff ff       	call   801024e1 <lapiceoi>
    break;
80105e34:	83 c4 10             	add    $0x10,%esp
80105e37:	e9 27 ff ff ff       	jmp    80105d63 <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e3c:	e8 68 d7 ff ff       	call   801035a9 <myproc>
80105e41:	85 c0                	test   %eax,%eax
80105e43:	74 60                	je     80105ea5 <trap+0x1a8>
80105e45:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105e49:	74 5a                	je     80105ea5 <trap+0x1a8>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e4b:	0f 20 d0             	mov    %cr2,%eax
80105e4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e51:	8b 77 38             	mov    0x38(%edi),%esi
80105e54:	e8 35 d7 ff ff       	call   8010358e <cpuid>
80105e59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105e5c:	8b 5f 34             	mov    0x34(%edi),%ebx
80105e5f:	8b 4f 30             	mov    0x30(%edi),%ecx
80105e62:	89 4d e0             	mov    %ecx,-0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e65:	e8 3f d7 ff ff       	call   801035a9 <myproc>
80105e6a:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e6d:	e8 37 d7 ff ff       	call   801035a9 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e72:	ff 75 d8             	pushl  -0x28(%ebp)
80105e75:	56                   	push   %esi
80105e76:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e79:	53                   	push   %ebx
80105e7a:	ff 75 e0             	pushl  -0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e7d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e80:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e83:	52                   	push   %edx
80105e84:	ff 70 10             	pushl  0x10(%eax)
80105e87:	68 e0 7d 10 80       	push   $0x80107de0
80105e8c:	e8 50 a7 ff ff       	call   801005e1 <cprintf>
    myproc()->killed = 1;
80105e91:	83 c4 20             	add    $0x20,%esp
80105e94:	e8 10 d7 ff ff       	call   801035a9 <myproc>
80105e99:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105ea0:	e9 be fe ff ff       	jmp    80105d63 <trap+0x66>
80105ea5:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ea8:	8b 5f 38             	mov    0x38(%edi),%ebx
80105eab:	e8 de d6 ff ff       	call   8010358e <cpuid>
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	56                   	push   %esi
80105eb4:	53                   	push   %ebx
80105eb5:	50                   	push   %eax
80105eb6:	ff 77 30             	pushl  0x30(%edi)
80105eb9:	68 ac 7d 10 80       	push   $0x80107dac
80105ebe:	e8 1e a7 ff ff       	call   801005e1 <cprintf>
      panic("trap");
80105ec3:	83 c4 14             	add    $0x14,%esp
80105ec6:	68 23 7e 10 80       	push   $0x80107e23
80105ecb:	e8 74 a4 ff ff       	call   80100344 <panic>
    exit();
80105ed0:	e8 20 dd ff ff       	call   80103bf5 <exit>
80105ed5:	e9 ae fe ff ff       	jmp    80105d88 <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
80105eda:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105ede:	0f 85 bc fe ff ff    	jne    80105da0 <trap+0xa3>
    tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80105ee4:	8b 0d c0 5a 11 80    	mov    0x80115ac0,%ecx
80105eea:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105eef:	89 c8                	mov    %ecx,%eax
80105ef1:	f7 e2                	mul    %edx
80105ef3:	c1 ea 03             	shr    $0x3,%edx
80105ef6:	8d 04 92             	lea    (%edx,%edx,4),%eax
80105ef9:	01 c0                	add    %eax,%eax
80105efb:	39 c1                	cmp    %eax,%ecx
80105efd:	0f 85 9d fe ff ff    	jne    80105da0 <trap+0xa3>
    yield();
80105f03:	e8 f0 dd ff ff       	call   80103cf8 <yield>
80105f08:	e9 93 fe ff ff       	jmp    80105da0 <trap+0xa3>
    exit();
80105f0d:	e8 e3 dc ff ff       	call   80103bf5 <exit>
80105f12:	e9 ae fe ff ff       	jmp    80105dc5 <trap+0xc8>

80105f17 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105f17:	55                   	push   %ebp
80105f18:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f1a:	83 3d 44 cb 10 80 00 	cmpl   $0x0,0x8010cb44
80105f21:	74 15                	je     80105f38 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f23:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f28:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f29:	a8 01                	test   $0x1,%al
80105f2b:	74 12                	je     80105f3f <uartgetc+0x28>
80105f2d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f32:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f33:	0f b6 c0             	movzbl %al,%eax
}
80105f36:	5d                   	pop    %ebp
80105f37:	c3                   	ret    
    return -1;
80105f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3d:	eb f7                	jmp    80105f36 <uartgetc+0x1f>
    return -1;
80105f3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f44:	eb f0                	jmp    80105f36 <uartgetc+0x1f>

80105f46 <uartputc>:
  if(!uart)
80105f46:	83 3d 44 cb 10 80 00 	cmpl   $0x0,0x8010cb44
80105f4d:	74 4f                	je     80105f9e <uartputc+0x58>
{
80105f4f:	55                   	push   %ebp
80105f50:	89 e5                	mov    %esp,%ebp
80105f52:	56                   	push   %esi
80105f53:	53                   	push   %ebx
80105f54:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f59:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f5a:	a8 20                	test   $0x20,%al
80105f5c:	75 30                	jne    80105f8e <uartputc+0x48>
    microdelay(10);
80105f5e:	83 ec 0c             	sub    $0xc,%esp
80105f61:	6a 0a                	push   $0xa
80105f63:	e8 98 c5 ff ff       	call   80102500 <microdelay>
80105f68:	83 c4 10             	add    $0x10,%esp
80105f6b:	bb 7f 00 00 00       	mov    $0x7f,%ebx
80105f70:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f75:	89 f2                	mov    %esi,%edx
80105f77:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f78:	a8 20                	test   $0x20,%al
80105f7a:	75 12                	jne    80105f8e <uartputc+0x48>
    microdelay(10);
80105f7c:	83 ec 0c             	sub    $0xc,%esp
80105f7f:	6a 0a                	push   $0xa
80105f81:	e8 7a c5 ff ff       	call   80102500 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f86:	83 c4 10             	add    $0x10,%esp
80105f89:	83 eb 01             	sub    $0x1,%ebx
80105f8c:	75 e7                	jne    80105f75 <uartputc+0x2f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80105f91:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f96:	ee                   	out    %al,(%dx)
}
80105f97:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f9a:	5b                   	pop    %ebx
80105f9b:	5e                   	pop    %esi
80105f9c:	5d                   	pop    %ebp
80105f9d:	c3                   	ret    
80105f9e:	f3 c3                	repz ret 

80105fa0 <uartinit>:
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	56                   	push   %esi
80105fa4:	53                   	push   %ebx
80105fa5:	b9 00 00 00 00       	mov    $0x0,%ecx
80105faa:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105faf:	89 c8                	mov    %ecx,%eax
80105fb1:	ee                   	out    %al,(%dx)
80105fb2:	be fb 03 00 00       	mov    $0x3fb,%esi
80105fb7:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105fbc:	89 f2                	mov    %esi,%edx
80105fbe:	ee                   	out    %al,(%dx)
80105fbf:	b8 0c 00 00 00       	mov    $0xc,%eax
80105fc4:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fc9:	ee                   	out    %al,(%dx)
80105fca:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105fcf:	89 c8                	mov    %ecx,%eax
80105fd1:	89 da                	mov    %ebx,%edx
80105fd3:	ee                   	out    %al,(%dx)
80105fd4:	b8 03 00 00 00       	mov    $0x3,%eax
80105fd9:	89 f2                	mov    %esi,%edx
80105fdb:	ee                   	out    %al,(%dx)
80105fdc:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fe1:	89 c8                	mov    %ecx,%eax
80105fe3:	ee                   	out    %al,(%dx)
80105fe4:	b8 01 00 00 00       	mov    $0x1,%eax
80105fe9:	89 da                	mov    %ebx,%edx
80105feb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fec:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ff1:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ff2:	3c ff                	cmp    $0xff,%al
80105ff4:	74 48                	je     8010603e <uartinit+0x9e>
  uart = 1;
80105ff6:	c7 05 44 cb 10 80 01 	movl   $0x1,0x8010cb44
80105ffd:	00 00 00 
80106000:	ba fa 03 00 00       	mov    $0x3fa,%edx
80106005:	ec                   	in     (%dx),%al
80106006:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010600b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010600c:	83 ec 08             	sub    $0x8,%esp
8010600f:	6a 00                	push   $0x0
80106011:	6a 04                	push   $0x4
80106013:	e8 75 c0 ff ff       	call   8010208d <ioapicenable>
80106018:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
8010601b:	bb a8 7e 10 80       	mov    $0x80107ea8,%ebx
80106020:	b8 78 00 00 00       	mov    $0x78,%eax
    uartputc(*p);
80106025:	83 ec 0c             	sub    $0xc,%esp
80106028:	0f be c0             	movsbl %al,%eax
8010602b:	50                   	push   %eax
8010602c:	e8 15 ff ff ff       	call   80105f46 <uartputc>
  for(p="xv6...\n"; *p; p++)
80106031:	83 c3 01             	add    $0x1,%ebx
80106034:	0f b6 03             	movzbl (%ebx),%eax
80106037:	83 c4 10             	add    $0x10,%esp
8010603a:	84 c0                	test   %al,%al
8010603c:	75 e7                	jne    80106025 <uartinit+0x85>
}
8010603e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106041:	5b                   	pop    %ebx
80106042:	5e                   	pop    %esi
80106043:	5d                   	pop    %ebp
80106044:	c3                   	ret    

80106045 <uartintr>:

void
uartintr(void)
{
80106045:	55                   	push   %ebp
80106046:	89 e5                	mov    %esp,%ebp
80106048:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010604b:	68 17 5f 10 80       	push   $0x80105f17
80106050:	e8 e6 a6 ff ff       	call   8010073b <consoleintr>
}
80106055:	83 c4 10             	add    $0x10,%esp
80106058:	c9                   	leave  
80106059:	c3                   	ret    

8010605a <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $0
8010605c:	6a 00                	push   $0x0
  jmp alltraps
8010605e:	e9 e0 fb ff ff       	jmp    80105c43 <alltraps>

80106063 <vector1>:
.globl vector1
vector1:
  pushl $0
80106063:	6a 00                	push   $0x0
  pushl $1
80106065:	6a 01                	push   $0x1
  jmp alltraps
80106067:	e9 d7 fb ff ff       	jmp    80105c43 <alltraps>

8010606c <vector2>:
.globl vector2
vector2:
  pushl $0
8010606c:	6a 00                	push   $0x0
  pushl $2
8010606e:	6a 02                	push   $0x2
  jmp alltraps
80106070:	e9 ce fb ff ff       	jmp    80105c43 <alltraps>

80106075 <vector3>:
.globl vector3
vector3:
  pushl $0
80106075:	6a 00                	push   $0x0
  pushl $3
80106077:	6a 03                	push   $0x3
  jmp alltraps
80106079:	e9 c5 fb ff ff       	jmp    80105c43 <alltraps>

8010607e <vector4>:
.globl vector4
vector4:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $4
80106080:	6a 04                	push   $0x4
  jmp alltraps
80106082:	e9 bc fb ff ff       	jmp    80105c43 <alltraps>

80106087 <vector5>:
.globl vector5
vector5:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $5
80106089:	6a 05                	push   $0x5
  jmp alltraps
8010608b:	e9 b3 fb ff ff       	jmp    80105c43 <alltraps>

80106090 <vector6>:
.globl vector6
vector6:
  pushl $0
80106090:	6a 00                	push   $0x0
  pushl $6
80106092:	6a 06                	push   $0x6
  jmp alltraps
80106094:	e9 aa fb ff ff       	jmp    80105c43 <alltraps>

80106099 <vector7>:
.globl vector7
vector7:
  pushl $0
80106099:	6a 00                	push   $0x0
  pushl $7
8010609b:	6a 07                	push   $0x7
  jmp alltraps
8010609d:	e9 a1 fb ff ff       	jmp    80105c43 <alltraps>

801060a2 <vector8>:
.globl vector8
vector8:
  pushl $8
801060a2:	6a 08                	push   $0x8
  jmp alltraps
801060a4:	e9 9a fb ff ff       	jmp    80105c43 <alltraps>

801060a9 <vector9>:
.globl vector9
vector9:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $9
801060ab:	6a 09                	push   $0x9
  jmp alltraps
801060ad:	e9 91 fb ff ff       	jmp    80105c43 <alltraps>

801060b2 <vector10>:
.globl vector10
vector10:
  pushl $10
801060b2:	6a 0a                	push   $0xa
  jmp alltraps
801060b4:	e9 8a fb ff ff       	jmp    80105c43 <alltraps>

801060b9 <vector11>:
.globl vector11
vector11:
  pushl $11
801060b9:	6a 0b                	push   $0xb
  jmp alltraps
801060bb:	e9 83 fb ff ff       	jmp    80105c43 <alltraps>

801060c0 <vector12>:
.globl vector12
vector12:
  pushl $12
801060c0:	6a 0c                	push   $0xc
  jmp alltraps
801060c2:	e9 7c fb ff ff       	jmp    80105c43 <alltraps>

801060c7 <vector13>:
.globl vector13
vector13:
  pushl $13
801060c7:	6a 0d                	push   $0xd
  jmp alltraps
801060c9:	e9 75 fb ff ff       	jmp    80105c43 <alltraps>

801060ce <vector14>:
.globl vector14
vector14:
  pushl $14
801060ce:	6a 0e                	push   $0xe
  jmp alltraps
801060d0:	e9 6e fb ff ff       	jmp    80105c43 <alltraps>

801060d5 <vector15>:
.globl vector15
vector15:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $15
801060d7:	6a 0f                	push   $0xf
  jmp alltraps
801060d9:	e9 65 fb ff ff       	jmp    80105c43 <alltraps>

801060de <vector16>:
.globl vector16
vector16:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $16
801060e0:	6a 10                	push   $0x10
  jmp alltraps
801060e2:	e9 5c fb ff ff       	jmp    80105c43 <alltraps>

801060e7 <vector17>:
.globl vector17
vector17:
  pushl $17
801060e7:	6a 11                	push   $0x11
  jmp alltraps
801060e9:	e9 55 fb ff ff       	jmp    80105c43 <alltraps>

801060ee <vector18>:
.globl vector18
vector18:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $18
801060f0:	6a 12                	push   $0x12
  jmp alltraps
801060f2:	e9 4c fb ff ff       	jmp    80105c43 <alltraps>

801060f7 <vector19>:
.globl vector19
vector19:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $19
801060f9:	6a 13                	push   $0x13
  jmp alltraps
801060fb:	e9 43 fb ff ff       	jmp    80105c43 <alltraps>

80106100 <vector20>:
.globl vector20
vector20:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $20
80106102:	6a 14                	push   $0x14
  jmp alltraps
80106104:	e9 3a fb ff ff       	jmp    80105c43 <alltraps>

80106109 <vector21>:
.globl vector21
vector21:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $21
8010610b:	6a 15                	push   $0x15
  jmp alltraps
8010610d:	e9 31 fb ff ff       	jmp    80105c43 <alltraps>

80106112 <vector22>:
.globl vector22
vector22:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $22
80106114:	6a 16                	push   $0x16
  jmp alltraps
80106116:	e9 28 fb ff ff       	jmp    80105c43 <alltraps>

8010611b <vector23>:
.globl vector23
vector23:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $23
8010611d:	6a 17                	push   $0x17
  jmp alltraps
8010611f:	e9 1f fb ff ff       	jmp    80105c43 <alltraps>

80106124 <vector24>:
.globl vector24
vector24:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $24
80106126:	6a 18                	push   $0x18
  jmp alltraps
80106128:	e9 16 fb ff ff       	jmp    80105c43 <alltraps>

8010612d <vector25>:
.globl vector25
vector25:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $25
8010612f:	6a 19                	push   $0x19
  jmp alltraps
80106131:	e9 0d fb ff ff       	jmp    80105c43 <alltraps>

80106136 <vector26>:
.globl vector26
vector26:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $26
80106138:	6a 1a                	push   $0x1a
  jmp alltraps
8010613a:	e9 04 fb ff ff       	jmp    80105c43 <alltraps>

8010613f <vector27>:
.globl vector27
vector27:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $27
80106141:	6a 1b                	push   $0x1b
  jmp alltraps
80106143:	e9 fb fa ff ff       	jmp    80105c43 <alltraps>

80106148 <vector28>:
.globl vector28
vector28:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $28
8010614a:	6a 1c                	push   $0x1c
  jmp alltraps
8010614c:	e9 f2 fa ff ff       	jmp    80105c43 <alltraps>

80106151 <vector29>:
.globl vector29
vector29:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $29
80106153:	6a 1d                	push   $0x1d
  jmp alltraps
80106155:	e9 e9 fa ff ff       	jmp    80105c43 <alltraps>

8010615a <vector30>:
.globl vector30
vector30:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $30
8010615c:	6a 1e                	push   $0x1e
  jmp alltraps
8010615e:	e9 e0 fa ff ff       	jmp    80105c43 <alltraps>

80106163 <vector31>:
.globl vector31
vector31:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $31
80106165:	6a 1f                	push   $0x1f
  jmp alltraps
80106167:	e9 d7 fa ff ff       	jmp    80105c43 <alltraps>

8010616c <vector32>:
.globl vector32
vector32:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $32
8010616e:	6a 20                	push   $0x20
  jmp alltraps
80106170:	e9 ce fa ff ff       	jmp    80105c43 <alltraps>

80106175 <vector33>:
.globl vector33
vector33:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $33
80106177:	6a 21                	push   $0x21
  jmp alltraps
80106179:	e9 c5 fa ff ff       	jmp    80105c43 <alltraps>

8010617e <vector34>:
.globl vector34
vector34:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $34
80106180:	6a 22                	push   $0x22
  jmp alltraps
80106182:	e9 bc fa ff ff       	jmp    80105c43 <alltraps>

80106187 <vector35>:
.globl vector35
vector35:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $35
80106189:	6a 23                	push   $0x23
  jmp alltraps
8010618b:	e9 b3 fa ff ff       	jmp    80105c43 <alltraps>

80106190 <vector36>:
.globl vector36
vector36:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $36
80106192:	6a 24                	push   $0x24
  jmp alltraps
80106194:	e9 aa fa ff ff       	jmp    80105c43 <alltraps>

80106199 <vector37>:
.globl vector37
vector37:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $37
8010619b:	6a 25                	push   $0x25
  jmp alltraps
8010619d:	e9 a1 fa ff ff       	jmp    80105c43 <alltraps>

801061a2 <vector38>:
.globl vector38
vector38:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $38
801061a4:	6a 26                	push   $0x26
  jmp alltraps
801061a6:	e9 98 fa ff ff       	jmp    80105c43 <alltraps>

801061ab <vector39>:
.globl vector39
vector39:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $39
801061ad:	6a 27                	push   $0x27
  jmp alltraps
801061af:	e9 8f fa ff ff       	jmp    80105c43 <alltraps>

801061b4 <vector40>:
.globl vector40
vector40:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $40
801061b6:	6a 28                	push   $0x28
  jmp alltraps
801061b8:	e9 86 fa ff ff       	jmp    80105c43 <alltraps>

801061bd <vector41>:
.globl vector41
vector41:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $41
801061bf:	6a 29                	push   $0x29
  jmp alltraps
801061c1:	e9 7d fa ff ff       	jmp    80105c43 <alltraps>

801061c6 <vector42>:
.globl vector42
vector42:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $42
801061c8:	6a 2a                	push   $0x2a
  jmp alltraps
801061ca:	e9 74 fa ff ff       	jmp    80105c43 <alltraps>

801061cf <vector43>:
.globl vector43
vector43:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $43
801061d1:	6a 2b                	push   $0x2b
  jmp alltraps
801061d3:	e9 6b fa ff ff       	jmp    80105c43 <alltraps>

801061d8 <vector44>:
.globl vector44
vector44:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $44
801061da:	6a 2c                	push   $0x2c
  jmp alltraps
801061dc:	e9 62 fa ff ff       	jmp    80105c43 <alltraps>

801061e1 <vector45>:
.globl vector45
vector45:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $45
801061e3:	6a 2d                	push   $0x2d
  jmp alltraps
801061e5:	e9 59 fa ff ff       	jmp    80105c43 <alltraps>

801061ea <vector46>:
.globl vector46
vector46:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $46
801061ec:	6a 2e                	push   $0x2e
  jmp alltraps
801061ee:	e9 50 fa ff ff       	jmp    80105c43 <alltraps>

801061f3 <vector47>:
.globl vector47
vector47:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $47
801061f5:	6a 2f                	push   $0x2f
  jmp alltraps
801061f7:	e9 47 fa ff ff       	jmp    80105c43 <alltraps>

801061fc <vector48>:
.globl vector48
vector48:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $48
801061fe:	6a 30                	push   $0x30
  jmp alltraps
80106200:	e9 3e fa ff ff       	jmp    80105c43 <alltraps>

80106205 <vector49>:
.globl vector49
vector49:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $49
80106207:	6a 31                	push   $0x31
  jmp alltraps
80106209:	e9 35 fa ff ff       	jmp    80105c43 <alltraps>

8010620e <vector50>:
.globl vector50
vector50:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $50
80106210:	6a 32                	push   $0x32
  jmp alltraps
80106212:	e9 2c fa ff ff       	jmp    80105c43 <alltraps>

80106217 <vector51>:
.globl vector51
vector51:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $51
80106219:	6a 33                	push   $0x33
  jmp alltraps
8010621b:	e9 23 fa ff ff       	jmp    80105c43 <alltraps>

80106220 <vector52>:
.globl vector52
vector52:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $52
80106222:	6a 34                	push   $0x34
  jmp alltraps
80106224:	e9 1a fa ff ff       	jmp    80105c43 <alltraps>

80106229 <vector53>:
.globl vector53
vector53:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $53
8010622b:	6a 35                	push   $0x35
  jmp alltraps
8010622d:	e9 11 fa ff ff       	jmp    80105c43 <alltraps>

80106232 <vector54>:
.globl vector54
vector54:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $54
80106234:	6a 36                	push   $0x36
  jmp alltraps
80106236:	e9 08 fa ff ff       	jmp    80105c43 <alltraps>

8010623b <vector55>:
.globl vector55
vector55:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $55
8010623d:	6a 37                	push   $0x37
  jmp alltraps
8010623f:	e9 ff f9 ff ff       	jmp    80105c43 <alltraps>

80106244 <vector56>:
.globl vector56
vector56:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $56
80106246:	6a 38                	push   $0x38
  jmp alltraps
80106248:	e9 f6 f9 ff ff       	jmp    80105c43 <alltraps>

8010624d <vector57>:
.globl vector57
vector57:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $57
8010624f:	6a 39                	push   $0x39
  jmp alltraps
80106251:	e9 ed f9 ff ff       	jmp    80105c43 <alltraps>

80106256 <vector58>:
.globl vector58
vector58:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $58
80106258:	6a 3a                	push   $0x3a
  jmp alltraps
8010625a:	e9 e4 f9 ff ff       	jmp    80105c43 <alltraps>

8010625f <vector59>:
.globl vector59
vector59:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $59
80106261:	6a 3b                	push   $0x3b
  jmp alltraps
80106263:	e9 db f9 ff ff       	jmp    80105c43 <alltraps>

80106268 <vector60>:
.globl vector60
vector60:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $60
8010626a:	6a 3c                	push   $0x3c
  jmp alltraps
8010626c:	e9 d2 f9 ff ff       	jmp    80105c43 <alltraps>

80106271 <vector61>:
.globl vector61
vector61:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $61
80106273:	6a 3d                	push   $0x3d
  jmp alltraps
80106275:	e9 c9 f9 ff ff       	jmp    80105c43 <alltraps>

8010627a <vector62>:
.globl vector62
vector62:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $62
8010627c:	6a 3e                	push   $0x3e
  jmp alltraps
8010627e:	e9 c0 f9 ff ff       	jmp    80105c43 <alltraps>

80106283 <vector63>:
.globl vector63
vector63:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $63
80106285:	6a 3f                	push   $0x3f
  jmp alltraps
80106287:	e9 b7 f9 ff ff       	jmp    80105c43 <alltraps>

8010628c <vector64>:
.globl vector64
vector64:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $64
8010628e:	6a 40                	push   $0x40
  jmp alltraps
80106290:	e9 ae f9 ff ff       	jmp    80105c43 <alltraps>

80106295 <vector65>:
.globl vector65
vector65:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $65
80106297:	6a 41                	push   $0x41
  jmp alltraps
80106299:	e9 a5 f9 ff ff       	jmp    80105c43 <alltraps>

8010629e <vector66>:
.globl vector66
vector66:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $66
801062a0:	6a 42                	push   $0x42
  jmp alltraps
801062a2:	e9 9c f9 ff ff       	jmp    80105c43 <alltraps>

801062a7 <vector67>:
.globl vector67
vector67:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $67
801062a9:	6a 43                	push   $0x43
  jmp alltraps
801062ab:	e9 93 f9 ff ff       	jmp    80105c43 <alltraps>

801062b0 <vector68>:
.globl vector68
vector68:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $68
801062b2:	6a 44                	push   $0x44
  jmp alltraps
801062b4:	e9 8a f9 ff ff       	jmp    80105c43 <alltraps>

801062b9 <vector69>:
.globl vector69
vector69:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $69
801062bb:	6a 45                	push   $0x45
  jmp alltraps
801062bd:	e9 81 f9 ff ff       	jmp    80105c43 <alltraps>

801062c2 <vector70>:
.globl vector70
vector70:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $70
801062c4:	6a 46                	push   $0x46
  jmp alltraps
801062c6:	e9 78 f9 ff ff       	jmp    80105c43 <alltraps>

801062cb <vector71>:
.globl vector71
vector71:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $71
801062cd:	6a 47                	push   $0x47
  jmp alltraps
801062cf:	e9 6f f9 ff ff       	jmp    80105c43 <alltraps>

801062d4 <vector72>:
.globl vector72
vector72:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $72
801062d6:	6a 48                	push   $0x48
  jmp alltraps
801062d8:	e9 66 f9 ff ff       	jmp    80105c43 <alltraps>

801062dd <vector73>:
.globl vector73
vector73:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $73
801062df:	6a 49                	push   $0x49
  jmp alltraps
801062e1:	e9 5d f9 ff ff       	jmp    80105c43 <alltraps>

801062e6 <vector74>:
.globl vector74
vector74:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $74
801062e8:	6a 4a                	push   $0x4a
  jmp alltraps
801062ea:	e9 54 f9 ff ff       	jmp    80105c43 <alltraps>

801062ef <vector75>:
.globl vector75
vector75:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $75
801062f1:	6a 4b                	push   $0x4b
  jmp alltraps
801062f3:	e9 4b f9 ff ff       	jmp    80105c43 <alltraps>

801062f8 <vector76>:
.globl vector76
vector76:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $76
801062fa:	6a 4c                	push   $0x4c
  jmp alltraps
801062fc:	e9 42 f9 ff ff       	jmp    80105c43 <alltraps>

80106301 <vector77>:
.globl vector77
vector77:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $77
80106303:	6a 4d                	push   $0x4d
  jmp alltraps
80106305:	e9 39 f9 ff ff       	jmp    80105c43 <alltraps>

8010630a <vector78>:
.globl vector78
vector78:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $78
8010630c:	6a 4e                	push   $0x4e
  jmp alltraps
8010630e:	e9 30 f9 ff ff       	jmp    80105c43 <alltraps>

80106313 <vector79>:
.globl vector79
vector79:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $79
80106315:	6a 4f                	push   $0x4f
  jmp alltraps
80106317:	e9 27 f9 ff ff       	jmp    80105c43 <alltraps>

8010631c <vector80>:
.globl vector80
vector80:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $80
8010631e:	6a 50                	push   $0x50
  jmp alltraps
80106320:	e9 1e f9 ff ff       	jmp    80105c43 <alltraps>

80106325 <vector81>:
.globl vector81
vector81:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $81
80106327:	6a 51                	push   $0x51
  jmp alltraps
80106329:	e9 15 f9 ff ff       	jmp    80105c43 <alltraps>

8010632e <vector82>:
.globl vector82
vector82:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $82
80106330:	6a 52                	push   $0x52
  jmp alltraps
80106332:	e9 0c f9 ff ff       	jmp    80105c43 <alltraps>

80106337 <vector83>:
.globl vector83
vector83:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $83
80106339:	6a 53                	push   $0x53
  jmp alltraps
8010633b:	e9 03 f9 ff ff       	jmp    80105c43 <alltraps>

80106340 <vector84>:
.globl vector84
vector84:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $84
80106342:	6a 54                	push   $0x54
  jmp alltraps
80106344:	e9 fa f8 ff ff       	jmp    80105c43 <alltraps>

80106349 <vector85>:
.globl vector85
vector85:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $85
8010634b:	6a 55                	push   $0x55
  jmp alltraps
8010634d:	e9 f1 f8 ff ff       	jmp    80105c43 <alltraps>

80106352 <vector86>:
.globl vector86
vector86:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $86
80106354:	6a 56                	push   $0x56
  jmp alltraps
80106356:	e9 e8 f8 ff ff       	jmp    80105c43 <alltraps>

8010635b <vector87>:
.globl vector87
vector87:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $87
8010635d:	6a 57                	push   $0x57
  jmp alltraps
8010635f:	e9 df f8 ff ff       	jmp    80105c43 <alltraps>

80106364 <vector88>:
.globl vector88
vector88:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $88
80106366:	6a 58                	push   $0x58
  jmp alltraps
80106368:	e9 d6 f8 ff ff       	jmp    80105c43 <alltraps>

8010636d <vector89>:
.globl vector89
vector89:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $89
8010636f:	6a 59                	push   $0x59
  jmp alltraps
80106371:	e9 cd f8 ff ff       	jmp    80105c43 <alltraps>

80106376 <vector90>:
.globl vector90
vector90:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $90
80106378:	6a 5a                	push   $0x5a
  jmp alltraps
8010637a:	e9 c4 f8 ff ff       	jmp    80105c43 <alltraps>

8010637f <vector91>:
.globl vector91
vector91:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $91
80106381:	6a 5b                	push   $0x5b
  jmp alltraps
80106383:	e9 bb f8 ff ff       	jmp    80105c43 <alltraps>

80106388 <vector92>:
.globl vector92
vector92:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $92
8010638a:	6a 5c                	push   $0x5c
  jmp alltraps
8010638c:	e9 b2 f8 ff ff       	jmp    80105c43 <alltraps>

80106391 <vector93>:
.globl vector93
vector93:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $93
80106393:	6a 5d                	push   $0x5d
  jmp alltraps
80106395:	e9 a9 f8 ff ff       	jmp    80105c43 <alltraps>

8010639a <vector94>:
.globl vector94
vector94:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $94
8010639c:	6a 5e                	push   $0x5e
  jmp alltraps
8010639e:	e9 a0 f8 ff ff       	jmp    80105c43 <alltraps>

801063a3 <vector95>:
.globl vector95
vector95:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $95
801063a5:	6a 5f                	push   $0x5f
  jmp alltraps
801063a7:	e9 97 f8 ff ff       	jmp    80105c43 <alltraps>

801063ac <vector96>:
.globl vector96
vector96:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $96
801063ae:	6a 60                	push   $0x60
  jmp alltraps
801063b0:	e9 8e f8 ff ff       	jmp    80105c43 <alltraps>

801063b5 <vector97>:
.globl vector97
vector97:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $97
801063b7:	6a 61                	push   $0x61
  jmp alltraps
801063b9:	e9 85 f8 ff ff       	jmp    80105c43 <alltraps>

801063be <vector98>:
.globl vector98
vector98:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $98
801063c0:	6a 62                	push   $0x62
  jmp alltraps
801063c2:	e9 7c f8 ff ff       	jmp    80105c43 <alltraps>

801063c7 <vector99>:
.globl vector99
vector99:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $99
801063c9:	6a 63                	push   $0x63
  jmp alltraps
801063cb:	e9 73 f8 ff ff       	jmp    80105c43 <alltraps>

801063d0 <vector100>:
.globl vector100
vector100:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $100
801063d2:	6a 64                	push   $0x64
  jmp alltraps
801063d4:	e9 6a f8 ff ff       	jmp    80105c43 <alltraps>

801063d9 <vector101>:
.globl vector101
vector101:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $101
801063db:	6a 65                	push   $0x65
  jmp alltraps
801063dd:	e9 61 f8 ff ff       	jmp    80105c43 <alltraps>

801063e2 <vector102>:
.globl vector102
vector102:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $102
801063e4:	6a 66                	push   $0x66
  jmp alltraps
801063e6:	e9 58 f8 ff ff       	jmp    80105c43 <alltraps>

801063eb <vector103>:
.globl vector103
vector103:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $103
801063ed:	6a 67                	push   $0x67
  jmp alltraps
801063ef:	e9 4f f8 ff ff       	jmp    80105c43 <alltraps>

801063f4 <vector104>:
.globl vector104
vector104:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $104
801063f6:	6a 68                	push   $0x68
  jmp alltraps
801063f8:	e9 46 f8 ff ff       	jmp    80105c43 <alltraps>

801063fd <vector105>:
.globl vector105
vector105:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $105
801063ff:	6a 69                	push   $0x69
  jmp alltraps
80106401:	e9 3d f8 ff ff       	jmp    80105c43 <alltraps>

80106406 <vector106>:
.globl vector106
vector106:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $106
80106408:	6a 6a                	push   $0x6a
  jmp alltraps
8010640a:	e9 34 f8 ff ff       	jmp    80105c43 <alltraps>

8010640f <vector107>:
.globl vector107
vector107:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $107
80106411:	6a 6b                	push   $0x6b
  jmp alltraps
80106413:	e9 2b f8 ff ff       	jmp    80105c43 <alltraps>

80106418 <vector108>:
.globl vector108
vector108:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $108
8010641a:	6a 6c                	push   $0x6c
  jmp alltraps
8010641c:	e9 22 f8 ff ff       	jmp    80105c43 <alltraps>

80106421 <vector109>:
.globl vector109
vector109:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $109
80106423:	6a 6d                	push   $0x6d
  jmp alltraps
80106425:	e9 19 f8 ff ff       	jmp    80105c43 <alltraps>

8010642a <vector110>:
.globl vector110
vector110:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $110
8010642c:	6a 6e                	push   $0x6e
  jmp alltraps
8010642e:	e9 10 f8 ff ff       	jmp    80105c43 <alltraps>

80106433 <vector111>:
.globl vector111
vector111:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $111
80106435:	6a 6f                	push   $0x6f
  jmp alltraps
80106437:	e9 07 f8 ff ff       	jmp    80105c43 <alltraps>

8010643c <vector112>:
.globl vector112
vector112:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $112
8010643e:	6a 70                	push   $0x70
  jmp alltraps
80106440:	e9 fe f7 ff ff       	jmp    80105c43 <alltraps>

80106445 <vector113>:
.globl vector113
vector113:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $113
80106447:	6a 71                	push   $0x71
  jmp alltraps
80106449:	e9 f5 f7 ff ff       	jmp    80105c43 <alltraps>

8010644e <vector114>:
.globl vector114
vector114:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $114
80106450:	6a 72                	push   $0x72
  jmp alltraps
80106452:	e9 ec f7 ff ff       	jmp    80105c43 <alltraps>

80106457 <vector115>:
.globl vector115
vector115:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $115
80106459:	6a 73                	push   $0x73
  jmp alltraps
8010645b:	e9 e3 f7 ff ff       	jmp    80105c43 <alltraps>

80106460 <vector116>:
.globl vector116
vector116:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $116
80106462:	6a 74                	push   $0x74
  jmp alltraps
80106464:	e9 da f7 ff ff       	jmp    80105c43 <alltraps>

80106469 <vector117>:
.globl vector117
vector117:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $117
8010646b:	6a 75                	push   $0x75
  jmp alltraps
8010646d:	e9 d1 f7 ff ff       	jmp    80105c43 <alltraps>

80106472 <vector118>:
.globl vector118
vector118:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $118
80106474:	6a 76                	push   $0x76
  jmp alltraps
80106476:	e9 c8 f7 ff ff       	jmp    80105c43 <alltraps>

8010647b <vector119>:
.globl vector119
vector119:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $119
8010647d:	6a 77                	push   $0x77
  jmp alltraps
8010647f:	e9 bf f7 ff ff       	jmp    80105c43 <alltraps>

80106484 <vector120>:
.globl vector120
vector120:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $120
80106486:	6a 78                	push   $0x78
  jmp alltraps
80106488:	e9 b6 f7 ff ff       	jmp    80105c43 <alltraps>

8010648d <vector121>:
.globl vector121
vector121:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $121
8010648f:	6a 79                	push   $0x79
  jmp alltraps
80106491:	e9 ad f7 ff ff       	jmp    80105c43 <alltraps>

80106496 <vector122>:
.globl vector122
vector122:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $122
80106498:	6a 7a                	push   $0x7a
  jmp alltraps
8010649a:	e9 a4 f7 ff ff       	jmp    80105c43 <alltraps>

8010649f <vector123>:
.globl vector123
vector123:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $123
801064a1:	6a 7b                	push   $0x7b
  jmp alltraps
801064a3:	e9 9b f7 ff ff       	jmp    80105c43 <alltraps>

801064a8 <vector124>:
.globl vector124
vector124:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $124
801064aa:	6a 7c                	push   $0x7c
  jmp alltraps
801064ac:	e9 92 f7 ff ff       	jmp    80105c43 <alltraps>

801064b1 <vector125>:
.globl vector125
vector125:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $125
801064b3:	6a 7d                	push   $0x7d
  jmp alltraps
801064b5:	e9 89 f7 ff ff       	jmp    80105c43 <alltraps>

801064ba <vector126>:
.globl vector126
vector126:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $126
801064bc:	6a 7e                	push   $0x7e
  jmp alltraps
801064be:	e9 80 f7 ff ff       	jmp    80105c43 <alltraps>

801064c3 <vector127>:
.globl vector127
vector127:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $127
801064c5:	6a 7f                	push   $0x7f
  jmp alltraps
801064c7:	e9 77 f7 ff ff       	jmp    80105c43 <alltraps>

801064cc <vector128>:
.globl vector128
vector128:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $128
801064ce:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064d3:	e9 6b f7 ff ff       	jmp    80105c43 <alltraps>

801064d8 <vector129>:
.globl vector129
vector129:
  pushl $0
801064d8:	6a 00                	push   $0x0
  pushl $129
801064da:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064df:	e9 5f f7 ff ff       	jmp    80105c43 <alltraps>

801064e4 <vector130>:
.globl vector130
vector130:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $130
801064e6:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064eb:	e9 53 f7 ff ff       	jmp    80105c43 <alltraps>

801064f0 <vector131>:
.globl vector131
vector131:
  pushl $0
801064f0:	6a 00                	push   $0x0
  pushl $131
801064f2:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064f7:	e9 47 f7 ff ff       	jmp    80105c43 <alltraps>

801064fc <vector132>:
.globl vector132
vector132:
  pushl $0
801064fc:	6a 00                	push   $0x0
  pushl $132
801064fe:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106503:	e9 3b f7 ff ff       	jmp    80105c43 <alltraps>

80106508 <vector133>:
.globl vector133
vector133:
  pushl $0
80106508:	6a 00                	push   $0x0
  pushl $133
8010650a:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010650f:	e9 2f f7 ff ff       	jmp    80105c43 <alltraps>

80106514 <vector134>:
.globl vector134
vector134:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $134
80106516:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010651b:	e9 23 f7 ff ff       	jmp    80105c43 <alltraps>

80106520 <vector135>:
.globl vector135
vector135:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $135
80106522:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106527:	e9 17 f7 ff ff       	jmp    80105c43 <alltraps>

8010652c <vector136>:
.globl vector136
vector136:
  pushl $0
8010652c:	6a 00                	push   $0x0
  pushl $136
8010652e:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106533:	e9 0b f7 ff ff       	jmp    80105c43 <alltraps>

80106538 <vector137>:
.globl vector137
vector137:
  pushl $0
80106538:	6a 00                	push   $0x0
  pushl $137
8010653a:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010653f:	e9 ff f6 ff ff       	jmp    80105c43 <alltraps>

80106544 <vector138>:
.globl vector138
vector138:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $138
80106546:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010654b:	e9 f3 f6 ff ff       	jmp    80105c43 <alltraps>

80106550 <vector139>:
.globl vector139
vector139:
  pushl $0
80106550:	6a 00                	push   $0x0
  pushl $139
80106552:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106557:	e9 e7 f6 ff ff       	jmp    80105c43 <alltraps>

8010655c <vector140>:
.globl vector140
vector140:
  pushl $0
8010655c:	6a 00                	push   $0x0
  pushl $140
8010655e:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106563:	e9 db f6 ff ff       	jmp    80105c43 <alltraps>

80106568 <vector141>:
.globl vector141
vector141:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $141
8010656a:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010656f:	e9 cf f6 ff ff       	jmp    80105c43 <alltraps>

80106574 <vector142>:
.globl vector142
vector142:
  pushl $0
80106574:	6a 00                	push   $0x0
  pushl $142
80106576:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010657b:	e9 c3 f6 ff ff       	jmp    80105c43 <alltraps>

80106580 <vector143>:
.globl vector143
vector143:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $143
80106582:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106587:	e9 b7 f6 ff ff       	jmp    80105c43 <alltraps>

8010658c <vector144>:
.globl vector144
vector144:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $144
8010658e:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106593:	e9 ab f6 ff ff       	jmp    80105c43 <alltraps>

80106598 <vector145>:
.globl vector145
vector145:
  pushl $0
80106598:	6a 00                	push   $0x0
  pushl $145
8010659a:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010659f:	e9 9f f6 ff ff       	jmp    80105c43 <alltraps>

801065a4 <vector146>:
.globl vector146
vector146:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $146
801065a6:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065ab:	e9 93 f6 ff ff       	jmp    80105c43 <alltraps>

801065b0 <vector147>:
.globl vector147
vector147:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $147
801065b2:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065b7:	e9 87 f6 ff ff       	jmp    80105c43 <alltraps>

801065bc <vector148>:
.globl vector148
vector148:
  pushl $0
801065bc:	6a 00                	push   $0x0
  pushl $148
801065be:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065c3:	e9 7b f6 ff ff       	jmp    80105c43 <alltraps>

801065c8 <vector149>:
.globl vector149
vector149:
  pushl $0
801065c8:	6a 00                	push   $0x0
  pushl $149
801065ca:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065cf:	e9 6f f6 ff ff       	jmp    80105c43 <alltraps>

801065d4 <vector150>:
.globl vector150
vector150:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $150
801065d6:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065db:	e9 63 f6 ff ff       	jmp    80105c43 <alltraps>

801065e0 <vector151>:
.globl vector151
vector151:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $151
801065e2:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065e7:	e9 57 f6 ff ff       	jmp    80105c43 <alltraps>

801065ec <vector152>:
.globl vector152
vector152:
  pushl $0
801065ec:	6a 00                	push   $0x0
  pushl $152
801065ee:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065f3:	e9 4b f6 ff ff       	jmp    80105c43 <alltraps>

801065f8 <vector153>:
.globl vector153
vector153:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $153
801065fa:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065ff:	e9 3f f6 ff ff       	jmp    80105c43 <alltraps>

80106604 <vector154>:
.globl vector154
vector154:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $154
80106606:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010660b:	e9 33 f6 ff ff       	jmp    80105c43 <alltraps>

80106610 <vector155>:
.globl vector155
vector155:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $155
80106612:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106617:	e9 27 f6 ff ff       	jmp    80105c43 <alltraps>

8010661c <vector156>:
.globl vector156
vector156:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $156
8010661e:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106623:	e9 1b f6 ff ff       	jmp    80105c43 <alltraps>

80106628 <vector157>:
.globl vector157
vector157:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $157
8010662a:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010662f:	e9 0f f6 ff ff       	jmp    80105c43 <alltraps>

80106634 <vector158>:
.globl vector158
vector158:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $158
80106636:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010663b:	e9 03 f6 ff ff       	jmp    80105c43 <alltraps>

80106640 <vector159>:
.globl vector159
vector159:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $159
80106642:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106647:	e9 f7 f5 ff ff       	jmp    80105c43 <alltraps>

8010664c <vector160>:
.globl vector160
vector160:
  pushl $0
8010664c:	6a 00                	push   $0x0
  pushl $160
8010664e:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106653:	e9 eb f5 ff ff       	jmp    80105c43 <alltraps>

80106658 <vector161>:
.globl vector161
vector161:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $161
8010665a:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010665f:	e9 df f5 ff ff       	jmp    80105c43 <alltraps>

80106664 <vector162>:
.globl vector162
vector162:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $162
80106666:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010666b:	e9 d3 f5 ff ff       	jmp    80105c43 <alltraps>

80106670 <vector163>:
.globl vector163
vector163:
  pushl $0
80106670:	6a 00                	push   $0x0
  pushl $163
80106672:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106677:	e9 c7 f5 ff ff       	jmp    80105c43 <alltraps>

8010667c <vector164>:
.globl vector164
vector164:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $164
8010667e:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106683:	e9 bb f5 ff ff       	jmp    80105c43 <alltraps>

80106688 <vector165>:
.globl vector165
vector165:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $165
8010668a:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010668f:	e9 af f5 ff ff       	jmp    80105c43 <alltraps>

80106694 <vector166>:
.globl vector166
vector166:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $166
80106696:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010669b:	e9 a3 f5 ff ff       	jmp    80105c43 <alltraps>

801066a0 <vector167>:
.globl vector167
vector167:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $167
801066a2:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066a7:	e9 97 f5 ff ff       	jmp    80105c43 <alltraps>

801066ac <vector168>:
.globl vector168
vector168:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $168
801066ae:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066b3:	e9 8b f5 ff ff       	jmp    80105c43 <alltraps>

801066b8 <vector169>:
.globl vector169
vector169:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $169
801066ba:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066bf:	e9 7f f5 ff ff       	jmp    80105c43 <alltraps>

801066c4 <vector170>:
.globl vector170
vector170:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $170
801066c6:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066cb:	e9 73 f5 ff ff       	jmp    80105c43 <alltraps>

801066d0 <vector171>:
.globl vector171
vector171:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $171
801066d2:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066d7:	e9 67 f5 ff ff       	jmp    80105c43 <alltraps>

801066dc <vector172>:
.globl vector172
vector172:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $172
801066de:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066e3:	e9 5b f5 ff ff       	jmp    80105c43 <alltraps>

801066e8 <vector173>:
.globl vector173
vector173:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $173
801066ea:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066ef:	e9 4f f5 ff ff       	jmp    80105c43 <alltraps>

801066f4 <vector174>:
.globl vector174
vector174:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $174
801066f6:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066fb:	e9 43 f5 ff ff       	jmp    80105c43 <alltraps>

80106700 <vector175>:
.globl vector175
vector175:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $175
80106702:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106707:	e9 37 f5 ff ff       	jmp    80105c43 <alltraps>

8010670c <vector176>:
.globl vector176
vector176:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $176
8010670e:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106713:	e9 2b f5 ff ff       	jmp    80105c43 <alltraps>

80106718 <vector177>:
.globl vector177
vector177:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $177
8010671a:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010671f:	e9 1f f5 ff ff       	jmp    80105c43 <alltraps>

80106724 <vector178>:
.globl vector178
vector178:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $178
80106726:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010672b:	e9 13 f5 ff ff       	jmp    80105c43 <alltraps>

80106730 <vector179>:
.globl vector179
vector179:
  pushl $0
80106730:	6a 00                	push   $0x0
  pushl $179
80106732:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106737:	e9 07 f5 ff ff       	jmp    80105c43 <alltraps>

8010673c <vector180>:
.globl vector180
vector180:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $180
8010673e:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106743:	e9 fb f4 ff ff       	jmp    80105c43 <alltraps>

80106748 <vector181>:
.globl vector181
vector181:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $181
8010674a:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010674f:	e9 ef f4 ff ff       	jmp    80105c43 <alltraps>

80106754 <vector182>:
.globl vector182
vector182:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $182
80106756:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010675b:	e9 e3 f4 ff ff       	jmp    80105c43 <alltraps>

80106760 <vector183>:
.globl vector183
vector183:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $183
80106762:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106767:	e9 d7 f4 ff ff       	jmp    80105c43 <alltraps>

8010676c <vector184>:
.globl vector184
vector184:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $184
8010676e:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106773:	e9 cb f4 ff ff       	jmp    80105c43 <alltraps>

80106778 <vector185>:
.globl vector185
vector185:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $185
8010677a:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010677f:	e9 bf f4 ff ff       	jmp    80105c43 <alltraps>

80106784 <vector186>:
.globl vector186
vector186:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $186
80106786:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010678b:	e9 b3 f4 ff ff       	jmp    80105c43 <alltraps>

80106790 <vector187>:
.globl vector187
vector187:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $187
80106792:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106797:	e9 a7 f4 ff ff       	jmp    80105c43 <alltraps>

8010679c <vector188>:
.globl vector188
vector188:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $188
8010679e:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067a3:	e9 9b f4 ff ff       	jmp    80105c43 <alltraps>

801067a8 <vector189>:
.globl vector189
vector189:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $189
801067aa:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067af:	e9 8f f4 ff ff       	jmp    80105c43 <alltraps>

801067b4 <vector190>:
.globl vector190
vector190:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $190
801067b6:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067bb:	e9 83 f4 ff ff       	jmp    80105c43 <alltraps>

801067c0 <vector191>:
.globl vector191
vector191:
  pushl $0
801067c0:	6a 00                	push   $0x0
  pushl $191
801067c2:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067c7:	e9 77 f4 ff ff       	jmp    80105c43 <alltraps>

801067cc <vector192>:
.globl vector192
vector192:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $192
801067ce:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067d3:	e9 6b f4 ff ff       	jmp    80105c43 <alltraps>

801067d8 <vector193>:
.globl vector193
vector193:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $193
801067da:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067df:	e9 5f f4 ff ff       	jmp    80105c43 <alltraps>

801067e4 <vector194>:
.globl vector194
vector194:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $194
801067e6:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067eb:	e9 53 f4 ff ff       	jmp    80105c43 <alltraps>

801067f0 <vector195>:
.globl vector195
vector195:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $195
801067f2:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067f7:	e9 47 f4 ff ff       	jmp    80105c43 <alltraps>

801067fc <vector196>:
.globl vector196
vector196:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $196
801067fe:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106803:	e9 3b f4 ff ff       	jmp    80105c43 <alltraps>

80106808 <vector197>:
.globl vector197
vector197:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $197
8010680a:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010680f:	e9 2f f4 ff ff       	jmp    80105c43 <alltraps>

80106814 <vector198>:
.globl vector198
vector198:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $198
80106816:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010681b:	e9 23 f4 ff ff       	jmp    80105c43 <alltraps>

80106820 <vector199>:
.globl vector199
vector199:
  pushl $0
80106820:	6a 00                	push   $0x0
  pushl $199
80106822:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106827:	e9 17 f4 ff ff       	jmp    80105c43 <alltraps>

8010682c <vector200>:
.globl vector200
vector200:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $200
8010682e:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106833:	e9 0b f4 ff ff       	jmp    80105c43 <alltraps>

80106838 <vector201>:
.globl vector201
vector201:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $201
8010683a:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010683f:	e9 ff f3 ff ff       	jmp    80105c43 <alltraps>

80106844 <vector202>:
.globl vector202
vector202:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $202
80106846:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010684b:	e9 f3 f3 ff ff       	jmp    80105c43 <alltraps>

80106850 <vector203>:
.globl vector203
vector203:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $203
80106852:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106857:	e9 e7 f3 ff ff       	jmp    80105c43 <alltraps>

8010685c <vector204>:
.globl vector204
vector204:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $204
8010685e:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106863:	e9 db f3 ff ff       	jmp    80105c43 <alltraps>

80106868 <vector205>:
.globl vector205
vector205:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $205
8010686a:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010686f:	e9 cf f3 ff ff       	jmp    80105c43 <alltraps>

80106874 <vector206>:
.globl vector206
vector206:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $206
80106876:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010687b:	e9 c3 f3 ff ff       	jmp    80105c43 <alltraps>

80106880 <vector207>:
.globl vector207
vector207:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $207
80106882:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106887:	e9 b7 f3 ff ff       	jmp    80105c43 <alltraps>

8010688c <vector208>:
.globl vector208
vector208:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $208
8010688e:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106893:	e9 ab f3 ff ff       	jmp    80105c43 <alltraps>

80106898 <vector209>:
.globl vector209
vector209:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $209
8010689a:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010689f:	e9 9f f3 ff ff       	jmp    80105c43 <alltraps>

801068a4 <vector210>:
.globl vector210
vector210:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $210
801068a6:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068ab:	e9 93 f3 ff ff       	jmp    80105c43 <alltraps>

801068b0 <vector211>:
.globl vector211
vector211:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $211
801068b2:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068b7:	e9 87 f3 ff ff       	jmp    80105c43 <alltraps>

801068bc <vector212>:
.globl vector212
vector212:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $212
801068be:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068c3:	e9 7b f3 ff ff       	jmp    80105c43 <alltraps>

801068c8 <vector213>:
.globl vector213
vector213:
  pushl $0
801068c8:	6a 00                	push   $0x0
  pushl $213
801068ca:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068cf:	e9 6f f3 ff ff       	jmp    80105c43 <alltraps>

801068d4 <vector214>:
.globl vector214
vector214:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $214
801068d6:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068db:	e9 63 f3 ff ff       	jmp    80105c43 <alltraps>

801068e0 <vector215>:
.globl vector215
vector215:
  pushl $0
801068e0:	6a 00                	push   $0x0
  pushl $215
801068e2:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068e7:	e9 57 f3 ff ff       	jmp    80105c43 <alltraps>

801068ec <vector216>:
.globl vector216
vector216:
  pushl $0
801068ec:	6a 00                	push   $0x0
  pushl $216
801068ee:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068f3:	e9 4b f3 ff ff       	jmp    80105c43 <alltraps>

801068f8 <vector217>:
.globl vector217
vector217:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $217
801068fa:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068ff:	e9 3f f3 ff ff       	jmp    80105c43 <alltraps>

80106904 <vector218>:
.globl vector218
vector218:
  pushl $0
80106904:	6a 00                	push   $0x0
  pushl $218
80106906:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010690b:	e9 33 f3 ff ff       	jmp    80105c43 <alltraps>

80106910 <vector219>:
.globl vector219
vector219:
  pushl $0
80106910:	6a 00                	push   $0x0
  pushl $219
80106912:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106917:	e9 27 f3 ff ff       	jmp    80105c43 <alltraps>

8010691c <vector220>:
.globl vector220
vector220:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $220
8010691e:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106923:	e9 1b f3 ff ff       	jmp    80105c43 <alltraps>

80106928 <vector221>:
.globl vector221
vector221:
  pushl $0
80106928:	6a 00                	push   $0x0
  pushl $221
8010692a:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010692f:	e9 0f f3 ff ff       	jmp    80105c43 <alltraps>

80106934 <vector222>:
.globl vector222
vector222:
  pushl $0
80106934:	6a 00                	push   $0x0
  pushl $222
80106936:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010693b:	e9 03 f3 ff ff       	jmp    80105c43 <alltraps>

80106940 <vector223>:
.globl vector223
vector223:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $223
80106942:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106947:	e9 f7 f2 ff ff       	jmp    80105c43 <alltraps>

8010694c <vector224>:
.globl vector224
vector224:
  pushl $0
8010694c:	6a 00                	push   $0x0
  pushl $224
8010694e:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106953:	e9 eb f2 ff ff       	jmp    80105c43 <alltraps>

80106958 <vector225>:
.globl vector225
vector225:
  pushl $0
80106958:	6a 00                	push   $0x0
  pushl $225
8010695a:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010695f:	e9 df f2 ff ff       	jmp    80105c43 <alltraps>

80106964 <vector226>:
.globl vector226
vector226:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $226
80106966:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010696b:	e9 d3 f2 ff ff       	jmp    80105c43 <alltraps>

80106970 <vector227>:
.globl vector227
vector227:
  pushl $0
80106970:	6a 00                	push   $0x0
  pushl $227
80106972:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106977:	e9 c7 f2 ff ff       	jmp    80105c43 <alltraps>

8010697c <vector228>:
.globl vector228
vector228:
  pushl $0
8010697c:	6a 00                	push   $0x0
  pushl $228
8010697e:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106983:	e9 bb f2 ff ff       	jmp    80105c43 <alltraps>

80106988 <vector229>:
.globl vector229
vector229:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $229
8010698a:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010698f:	e9 af f2 ff ff       	jmp    80105c43 <alltraps>

80106994 <vector230>:
.globl vector230
vector230:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $230
80106996:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010699b:	e9 a3 f2 ff ff       	jmp    80105c43 <alltraps>

801069a0 <vector231>:
.globl vector231
vector231:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $231
801069a2:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069a7:	e9 97 f2 ff ff       	jmp    80105c43 <alltraps>

801069ac <vector232>:
.globl vector232
vector232:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $232
801069ae:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069b3:	e9 8b f2 ff ff       	jmp    80105c43 <alltraps>

801069b8 <vector233>:
.globl vector233
vector233:
  pushl $0
801069b8:	6a 00                	push   $0x0
  pushl $233
801069ba:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069bf:	e9 7f f2 ff ff       	jmp    80105c43 <alltraps>

801069c4 <vector234>:
.globl vector234
vector234:
  pushl $0
801069c4:	6a 00                	push   $0x0
  pushl $234
801069c6:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069cb:	e9 73 f2 ff ff       	jmp    80105c43 <alltraps>

801069d0 <vector235>:
.globl vector235
vector235:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $235
801069d2:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069d7:	e9 67 f2 ff ff       	jmp    80105c43 <alltraps>

801069dc <vector236>:
.globl vector236
vector236:
  pushl $0
801069dc:	6a 00                	push   $0x0
  pushl $236
801069de:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069e3:	e9 5b f2 ff ff       	jmp    80105c43 <alltraps>

801069e8 <vector237>:
.globl vector237
vector237:
  pushl $0
801069e8:	6a 00                	push   $0x0
  pushl $237
801069ea:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069ef:	e9 4f f2 ff ff       	jmp    80105c43 <alltraps>

801069f4 <vector238>:
.globl vector238
vector238:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $238
801069f6:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069fb:	e9 43 f2 ff ff       	jmp    80105c43 <alltraps>

80106a00 <vector239>:
.globl vector239
vector239:
  pushl $0
80106a00:	6a 00                	push   $0x0
  pushl $239
80106a02:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a07:	e9 37 f2 ff ff       	jmp    80105c43 <alltraps>

80106a0c <vector240>:
.globl vector240
vector240:
  pushl $0
80106a0c:	6a 00                	push   $0x0
  pushl $240
80106a0e:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a13:	e9 2b f2 ff ff       	jmp    80105c43 <alltraps>

80106a18 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $241
80106a1a:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a1f:	e9 1f f2 ff ff       	jmp    80105c43 <alltraps>

80106a24 <vector242>:
.globl vector242
vector242:
  pushl $0
80106a24:	6a 00                	push   $0x0
  pushl $242
80106a26:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a2b:	e9 13 f2 ff ff       	jmp    80105c43 <alltraps>

80106a30 <vector243>:
.globl vector243
vector243:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $243
80106a32:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a37:	e9 07 f2 ff ff       	jmp    80105c43 <alltraps>

80106a3c <vector244>:
.globl vector244
vector244:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $244
80106a3e:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a43:	e9 fb f1 ff ff       	jmp    80105c43 <alltraps>

80106a48 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a48:	6a 00                	push   $0x0
  pushl $245
80106a4a:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a4f:	e9 ef f1 ff ff       	jmp    80105c43 <alltraps>

80106a54 <vector246>:
.globl vector246
vector246:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $246
80106a56:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a5b:	e9 e3 f1 ff ff       	jmp    80105c43 <alltraps>

80106a60 <vector247>:
.globl vector247
vector247:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $247
80106a62:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a67:	e9 d7 f1 ff ff       	jmp    80105c43 <alltraps>

80106a6c <vector248>:
.globl vector248
vector248:
  pushl $0
80106a6c:	6a 00                	push   $0x0
  pushl $248
80106a6e:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a73:	e9 cb f1 ff ff       	jmp    80105c43 <alltraps>

80106a78 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $249
80106a7a:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a7f:	e9 bf f1 ff ff       	jmp    80105c43 <alltraps>

80106a84 <vector250>:
.globl vector250
vector250:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $250
80106a86:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a8b:	e9 b3 f1 ff ff       	jmp    80105c43 <alltraps>

80106a90 <vector251>:
.globl vector251
vector251:
  pushl $0
80106a90:	6a 00                	push   $0x0
  pushl $251
80106a92:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a97:	e9 a7 f1 ff ff       	jmp    80105c43 <alltraps>

80106a9c <vector252>:
.globl vector252
vector252:
  pushl $0
80106a9c:	6a 00                	push   $0x0
  pushl $252
80106a9e:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106aa3:	e9 9b f1 ff ff       	jmp    80105c43 <alltraps>

80106aa8 <vector253>:
.globl vector253
vector253:
  pushl $0
80106aa8:	6a 00                	push   $0x0
  pushl $253
80106aaa:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106aaf:	e9 8f f1 ff ff       	jmp    80105c43 <alltraps>

80106ab4 <vector254>:
.globl vector254
vector254:
  pushl $0
80106ab4:	6a 00                	push   $0x0
  pushl $254
80106ab6:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106abb:	e9 83 f1 ff ff       	jmp    80105c43 <alltraps>

80106ac0 <vector255>:
.globl vector255
vector255:
  pushl $0
80106ac0:	6a 00                	push   $0x0
  pushl $255
80106ac2:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ac7:	e9 77 f1 ff ff       	jmp    80105c43 <alltraps>

80106acc <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106acc:	55                   	push   %ebp
80106acd:	89 e5                	mov    %esp,%ebp
80106acf:	57                   	push   %edi
80106ad0:	56                   	push   %esi
80106ad1:	53                   	push   %ebx
80106ad2:	83 ec 0c             	sub    $0xc,%esp
80106ad5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ad7:	c1 ea 16             	shr    $0x16,%edx
80106ada:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80106add:	8b 1f                	mov    (%edi),%ebx
80106adf:	f6 c3 01             	test   $0x1,%bl
80106ae2:	74 21                	je     80106b05 <walkpgdir+0x39>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ae4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106aea:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106af0:	c1 ee 0a             	shr    $0xa,%esi
80106af3:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106af9:	01 f3                	add    %esi,%ebx
}
80106afb:	89 d8                	mov    %ebx,%eax
80106afd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b00:	5b                   	pop    %ebx
80106b01:	5e                   	pop    %esi
80106b02:	5f                   	pop    %edi
80106b03:	5d                   	pop    %ebp
80106b04:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b05:	85 c9                	test   %ecx,%ecx
80106b07:	74 2b                	je     80106b34 <walkpgdir+0x68>
80106b09:	e8 d7 b6 ff ff       	call   801021e5 <kalloc>
80106b0e:	89 c3                	mov    %eax,%ebx
80106b10:	85 c0                	test   %eax,%eax
80106b12:	74 e7                	je     80106afb <walkpgdir+0x2f>
    memset(pgtab, 0, PGSIZE);
80106b14:	83 ec 04             	sub    $0x4,%esp
80106b17:	68 00 10 00 00       	push   $0x1000
80106b1c:	6a 00                	push   $0x0
80106b1e:	50                   	push   %eax
80106b1f:	e8 3f df ff ff       	call   80104a63 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b24:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b2a:	83 c8 07             	or     $0x7,%eax
80106b2d:	89 07                	mov    %eax,(%edi)
80106b2f:	83 c4 10             	add    $0x10,%esp
80106b32:	eb bc                	jmp    80106af0 <walkpgdir+0x24>
      return 0;
80106b34:	bb 00 00 00 00       	mov    $0x0,%ebx
80106b39:	eb c0                	jmp    80106afb <walkpgdir+0x2f>

80106b3b <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b3b:	55                   	push   %ebp
80106b3c:	89 e5                	mov    %esp,%ebp
80106b3e:	57                   	push   %edi
80106b3f:	56                   	push   %esi
80106b40:	53                   	push   %ebx
80106b41:	83 ec 1c             	sub    $0x1c,%esp
80106b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b47:	89 d0                	mov    %edx,%eax
80106b49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b4e:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b50:	8d 54 0a ff          	lea    -0x1(%edx,%ecx,1),%edx
80106b54:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106b5a:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106b5d:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b60:	29 c7                	sub    %eax,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b62:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b65:	83 c8 01             	or     $0x1,%eax
80106b68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b6b:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b6e:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b73:	89 da                	mov    %ebx,%edx
80106b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b78:	e8 4f ff ff ff       	call   80106acc <walkpgdir>
80106b7d:	85 c0                	test   %eax,%eax
80106b7f:	74 24                	je     80106ba5 <mappages+0x6a>
    if(*pte & PTE_P)
80106b81:	f6 00 01             	testb  $0x1,(%eax)
80106b84:	75 12                	jne    80106b98 <mappages+0x5d>
    *pte = pa | perm | PTE_P;
80106b86:	0b 75 dc             	or     -0x24(%ebp),%esi
80106b89:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b8b:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80106b8e:	74 22                	je     80106bb2 <mappages+0x77>
      break;
    a += PGSIZE;
80106b90:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b96:	eb d3                	jmp    80106b6b <mappages+0x30>
      panic("remap");
80106b98:	83 ec 0c             	sub    $0xc,%esp
80106b9b:	68 b0 7e 10 80       	push   $0x80107eb0
80106ba0:	e8 9f 97 ff ff       	call   80100344 <panic>
      return -1;
80106ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    pa += PGSIZE;
  }
  return 0;
}
80106baa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bad:	5b                   	pop    %ebx
80106bae:	5e                   	pop    %esi
80106baf:	5f                   	pop    %edi
80106bb0:	5d                   	pop    %ebp
80106bb1:	c3                   	ret    
  return 0;
80106bb2:	b8 00 00 00 00       	mov    $0x0,%eax
80106bb7:	eb f1                	jmp    80106baa <mappages+0x6f>

80106bb9 <seginit>:
{
80106bb9:	55                   	push   %ebp
80106bba:	89 e5                	mov    %esp,%ebp
80106bbc:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106bbf:	e8 ca c9 ff ff       	call   8010358e <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106bc4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106bca:	66 c7 80 98 4d 11 80 	movw   $0xffff,-0x7feeb268(%eax)
80106bd1:	ff ff 
80106bd3:	66 c7 80 9a 4d 11 80 	movw   $0x0,-0x7feeb266(%eax)
80106bda:	00 00 
80106bdc:	c6 80 9c 4d 11 80 00 	movb   $0x0,-0x7feeb264(%eax)
80106be3:	c6 80 9d 4d 11 80 9a 	movb   $0x9a,-0x7feeb263(%eax)
80106bea:	c6 80 9e 4d 11 80 cf 	movb   $0xcf,-0x7feeb262(%eax)
80106bf1:	c6 80 9f 4d 11 80 00 	movb   $0x0,-0x7feeb261(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106bf8:	66 c7 80 a0 4d 11 80 	movw   $0xffff,-0x7feeb260(%eax)
80106bff:	ff ff 
80106c01:	66 c7 80 a2 4d 11 80 	movw   $0x0,-0x7feeb25e(%eax)
80106c08:	00 00 
80106c0a:	c6 80 a4 4d 11 80 00 	movb   $0x0,-0x7feeb25c(%eax)
80106c11:	c6 80 a5 4d 11 80 92 	movb   $0x92,-0x7feeb25b(%eax)
80106c18:	c6 80 a6 4d 11 80 cf 	movb   $0xcf,-0x7feeb25a(%eax)
80106c1f:	c6 80 a7 4d 11 80 00 	movb   $0x0,-0x7feeb259(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c26:	66 c7 80 a8 4d 11 80 	movw   $0xffff,-0x7feeb258(%eax)
80106c2d:	ff ff 
80106c2f:	66 c7 80 aa 4d 11 80 	movw   $0x0,-0x7feeb256(%eax)
80106c36:	00 00 
80106c38:	c6 80 ac 4d 11 80 00 	movb   $0x0,-0x7feeb254(%eax)
80106c3f:	c6 80 ad 4d 11 80 fa 	movb   $0xfa,-0x7feeb253(%eax)
80106c46:	c6 80 ae 4d 11 80 cf 	movb   $0xcf,-0x7feeb252(%eax)
80106c4d:	c6 80 af 4d 11 80 00 	movb   $0x0,-0x7feeb251(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c54:	66 c7 80 b0 4d 11 80 	movw   $0xffff,-0x7feeb250(%eax)
80106c5b:	ff ff 
80106c5d:	66 c7 80 b2 4d 11 80 	movw   $0x0,-0x7feeb24e(%eax)
80106c64:	00 00 
80106c66:	c6 80 b4 4d 11 80 00 	movb   $0x0,-0x7feeb24c(%eax)
80106c6d:	c6 80 b5 4d 11 80 f2 	movb   $0xf2,-0x7feeb24b(%eax)
80106c74:	c6 80 b6 4d 11 80 cf 	movb   $0xcf,-0x7feeb24a(%eax)
80106c7b:	c6 80 b7 4d 11 80 00 	movb   $0x0,-0x7feeb249(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106c82:	05 90 4d 11 80       	add    $0x80114d90,%eax
  pd[0] = size-1;
80106c87:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80106c8d:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c91:	c1 e8 10             	shr    $0x10,%eax
80106c94:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c98:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c9b:	0f 01 10             	lgdtl  (%eax)
}
80106c9e:	c9                   	leave  
80106c9f:	c3                   	ret    

80106ca0 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ca3:	a1 c4 5a 11 80       	mov    0x80115ac4,%eax
80106ca8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cad:	0f 22 d8             	mov    %eax,%cr3
}
80106cb0:	5d                   	pop    %ebp
80106cb1:	c3                   	ret    

80106cb2 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106cb2:	55                   	push   %ebp
80106cb3:	89 e5                	mov    %esp,%ebp
80106cb5:	57                   	push   %edi
80106cb6:	56                   	push   %esi
80106cb7:	53                   	push   %ebx
80106cb8:	83 ec 1c             	sub    $0x1c,%esp
80106cbb:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106cbe:	85 f6                	test   %esi,%esi
80106cc0:	0f 84 c3 00 00 00    	je     80106d89 <switchuvm+0xd7>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106cc6:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80106cca:	0f 84 c6 00 00 00    	je     80106d96 <switchuvm+0xe4>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106cd0:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80106cd4:	0f 84 c9 00 00 00    	je     80106da3 <switchuvm+0xf1>
    panic("switchuvm: no pgdir");

  pushcli();
80106cda:	e8 05 dc ff ff       	call   801048e4 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cdf:	e8 33 c8 ff ff       	call   80103517 <mycpu>
80106ce4:	89 c3                	mov    %eax,%ebx
80106ce6:	e8 2c c8 ff ff       	call   80103517 <mycpu>
80106ceb:	89 c7                	mov    %eax,%edi
80106ced:	e8 25 c8 ff ff       	call   80103517 <mycpu>
80106cf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106cf5:	e8 1d c8 ff ff       	call   80103517 <mycpu>
80106cfa:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106d01:	67 00 
80106d03:	83 c7 08             	add    $0x8,%edi
80106d06:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d10:	83 c2 08             	add    $0x8,%edx
80106d13:	c1 ea 10             	shr    $0x10,%edx
80106d16:	88 93 9c 00 00 00    	mov    %dl,0x9c(%ebx)
80106d1c:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106d23:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106d2a:	83 c0 08             	add    $0x8,%eax
80106d2d:	c1 e8 18             	shr    $0x18,%eax
80106d30:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106d36:	e8 dc c7 ff ff       	call   80103517 <mycpu>
80106d3b:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d42:	e8 d0 c7 ff ff       	call   80103517 <mycpu>
80106d47:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d4d:	8b 5e 08             	mov    0x8(%esi),%ebx
80106d50:	e8 c2 c7 ff ff       	call   80103517 <mycpu>
80106d55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d5b:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d5e:	e8 b4 c7 ff ff       	call   80103517 <mycpu>
80106d63:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d69:	b8 28 00 00 00       	mov    $0x28,%eax
80106d6e:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d71:	8b 46 04             	mov    0x4(%esi),%eax
80106d74:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d79:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106d7c:	e8 a0 db ff ff       	call   80104921 <popcli>
}
80106d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d84:	5b                   	pop    %ebx
80106d85:	5e                   	pop    %esi
80106d86:	5f                   	pop    %edi
80106d87:	5d                   	pop    %ebp
80106d88:	c3                   	ret    
    panic("switchuvm: no process");
80106d89:	83 ec 0c             	sub    $0xc,%esp
80106d8c:	68 b6 7e 10 80       	push   $0x80107eb6
80106d91:	e8 ae 95 ff ff       	call   80100344 <panic>
    panic("switchuvm: no kstack");
80106d96:	83 ec 0c             	sub    $0xc,%esp
80106d99:	68 cc 7e 10 80       	push   $0x80107ecc
80106d9e:	e8 a1 95 ff ff       	call   80100344 <panic>
    panic("switchuvm: no pgdir");
80106da3:	83 ec 0c             	sub    $0xc,%esp
80106da6:	68 e1 7e 10 80       	push   $0x80107ee1
80106dab:	e8 94 95 ff ff       	call   80100344 <panic>

80106db0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	56                   	push   %esi
80106db4:	53                   	push   %ebx
80106db5:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106db8:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106dbe:	77 4c                	ja     80106e0c <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
80106dc0:	e8 20 b4 ff ff       	call   801021e5 <kalloc>
80106dc5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106dc7:	83 ec 04             	sub    $0x4,%esp
80106dca:	68 00 10 00 00       	push   $0x1000
80106dcf:	6a 00                	push   $0x0
80106dd1:	50                   	push   %eax
80106dd2:	e8 8c dc ff ff       	call   80104a63 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106dd7:	83 c4 08             	add    $0x8,%esp
80106dda:	6a 06                	push   $0x6
80106ddc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106de2:	50                   	push   %eax
80106de3:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106de8:	ba 00 00 00 00       	mov    $0x0,%edx
80106ded:	8b 45 08             	mov    0x8(%ebp),%eax
80106df0:	e8 46 fd ff ff       	call   80106b3b <mappages>
  memmove(mem, init, sz);
80106df5:	83 c4 0c             	add    $0xc,%esp
80106df8:	56                   	push   %esi
80106df9:	ff 75 0c             	pushl  0xc(%ebp)
80106dfc:	53                   	push   %ebx
80106dfd:	e8 f6 dc ff ff       	call   80104af8 <memmove>
}
80106e02:	83 c4 10             	add    $0x10,%esp
80106e05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e08:	5b                   	pop    %ebx
80106e09:	5e                   	pop    %esi
80106e0a:	5d                   	pop    %ebp
80106e0b:	c3                   	ret    
    panic("inituvm: more than a page");
80106e0c:	83 ec 0c             	sub    $0xc,%esp
80106e0f:	68 f5 7e 10 80       	push   $0x80107ef5
80106e14:	e8 2b 95 ff ff       	call   80100344 <panic>

80106e19 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106e19:	55                   	push   %ebp
80106e1a:	89 e5                	mov    %esp,%ebp
80106e1c:	57                   	push   %edi
80106e1d:	56                   	push   %esi
80106e1e:	53                   	push   %ebx
80106e1f:	83 ec 1c             	sub    $0x1c,%esp
80106e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106e25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e28:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106e2d:	75 71                	jne    80106ea0 <loaduvm+0x87>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106e2f:	8b 75 18             	mov    0x18(%ebp),%esi
80106e32:	bb 00 00 00 00       	mov    $0x0,%ebx
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106e37:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106e3c:	85 f6                	test   %esi,%esi
80106e3e:	74 7f                	je     80106ebf <loaduvm+0xa6>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e43:	8d 14 18             	lea    (%eax,%ebx,1),%edx
80106e46:	b9 00 00 00 00       	mov    $0x0,%ecx
80106e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e4e:	e8 79 fc ff ff       	call   80106acc <walkpgdir>
80106e53:	85 c0                	test   %eax,%eax
80106e55:	74 56                	je     80106ead <loaduvm+0x94>
    pa = PTE_ADDR(*pte);
80106e57:	8b 00                	mov    (%eax),%eax
80106e59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = sz - i;
80106e5e:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e64:	bf 00 10 00 00       	mov    $0x1000,%edi
80106e69:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e6c:	57                   	push   %edi
80106e6d:	89 da                	mov    %ebx,%edx
80106e6f:	03 55 14             	add    0x14(%ebp),%edx
80106e72:	52                   	push   %edx
80106e73:	05 00 00 00 80       	add    $0x80000000,%eax
80106e78:	50                   	push   %eax
80106e79:	ff 75 10             	pushl  0x10(%ebp)
80106e7c:	e8 80 a9 ff ff       	call   80101801 <readi>
80106e81:	83 c4 10             	add    $0x10,%esp
80106e84:	39 f8                	cmp    %edi,%eax
80106e86:	75 32                	jne    80106eba <loaduvm+0xa1>
  for(i = 0; i < sz; i += PGSIZE){
80106e88:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e8e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106e94:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106e97:	77 a7                	ja     80106e40 <loaduvm+0x27>
  return 0;
80106e99:	b8 00 00 00 00       	mov    $0x0,%eax
80106e9e:	eb 1f                	jmp    80106ebf <loaduvm+0xa6>
    panic("loaduvm: addr must be page aligned");
80106ea0:	83 ec 0c             	sub    $0xc,%esp
80106ea3:	68 b0 7f 10 80       	push   $0x80107fb0
80106ea8:	e8 97 94 ff ff       	call   80100344 <panic>
      panic("loaduvm: address should exist");
80106ead:	83 ec 0c             	sub    $0xc,%esp
80106eb0:	68 0f 7f 10 80       	push   $0x80107f0f
80106eb5:	e8 8a 94 ff ff       	call   80100344 <panic>
      return -1;
80106eba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ec2:	5b                   	pop    %ebx
80106ec3:	5e                   	pop    %esi
80106ec4:	5f                   	pop    %edi
80106ec5:	5d                   	pop    %ebp
80106ec6:	c3                   	ret    

80106ec7 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106ec7:	55                   	push   %ebp
80106ec8:	89 e5                	mov    %esp,%ebp
80106eca:	57                   	push   %edi
80106ecb:	56                   	push   %esi
80106ecc:	53                   	push   %ebx
80106ecd:	83 ec 0c             	sub    $0xc,%esp
80106ed0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
80106ed3:	89 f8                	mov    %edi,%eax
  if(newsz >= oldsz)
80106ed5:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106ed8:	73 16                	jae    80106ef0 <deallocuvm+0x29>

  a = PGROUNDUP(newsz);
80106eda:	8b 45 10             	mov    0x10(%ebp),%eax
80106edd:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106ee3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106ee9:	39 df                	cmp    %ebx,%edi
80106eeb:	77 21                	ja     80106f0e <deallocuvm+0x47>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80106eed:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ef3:	5b                   	pop    %ebx
80106ef4:	5e                   	pop    %esi
80106ef5:	5f                   	pop    %edi
80106ef6:	5d                   	pop    %ebp
80106ef7:	c3                   	ret    
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ef8:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106efe:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106f04:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f0a:	39 df                	cmp    %ebx,%edi
80106f0c:	76 df                	jbe    80106eed <deallocuvm+0x26>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106f0e:	b9 00 00 00 00       	mov    $0x0,%ecx
80106f13:	89 da                	mov    %ebx,%edx
80106f15:	8b 45 08             	mov    0x8(%ebp),%eax
80106f18:	e8 af fb ff ff       	call   80106acc <walkpgdir>
80106f1d:	89 c6                	mov    %eax,%esi
    if(!pte)
80106f1f:	85 c0                	test   %eax,%eax
80106f21:	74 d5                	je     80106ef8 <deallocuvm+0x31>
    else if((*pte & PTE_P) != 0){
80106f23:	8b 00                	mov    (%eax),%eax
80106f25:	a8 01                	test   $0x1,%al
80106f27:	74 db                	je     80106f04 <deallocuvm+0x3d>
      if(pa == 0)
80106f29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f2e:	74 19                	je     80106f49 <deallocuvm+0x82>
      kfree(v);
80106f30:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106f33:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f38:	50                   	push   %eax
80106f39:	e8 82 b1 ff ff       	call   801020c0 <kfree>
      *pte = 0;
80106f3e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106f44:	83 c4 10             	add    $0x10,%esp
80106f47:	eb bb                	jmp    80106f04 <deallocuvm+0x3d>
        panic("kfree");
80106f49:	83 ec 0c             	sub    $0xc,%esp
80106f4c:	68 5a 75 10 80       	push   $0x8010755a
80106f51:	e8 ee 93 ff ff       	call   80100344 <panic>

80106f56 <allocuvm>:
{
80106f56:	55                   	push   %ebp
80106f57:	89 e5                	mov    %esp,%ebp
80106f59:	57                   	push   %edi
80106f5a:	56                   	push   %esi
80106f5b:	53                   	push   %ebx
80106f5c:	83 ec 1c             	sub    $0x1c,%esp
80106f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106f62:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106f65:	85 ff                	test   %edi,%edi
80106f67:	0f 88 c5 00 00 00    	js     80107032 <allocuvm+0xdc>
  if(newsz < oldsz)
80106f6d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f70:	72 60                	jb     80106fd2 <allocuvm+0x7c>
  a = PGROUNDUP(oldsz);
80106f72:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f75:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106f7b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106f81:	39 df                	cmp    %ebx,%edi
80106f83:	0f 86 b0 00 00 00    	jbe    80107039 <allocuvm+0xe3>
    mem = kalloc();
80106f89:	e8 57 b2 ff ff       	call   801021e5 <kalloc>
80106f8e:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106f90:	85 c0                	test   %eax,%eax
80106f92:	74 46                	je     80106fda <allocuvm+0x84>
    memset(mem, 0, PGSIZE);
80106f94:	83 ec 04             	sub    $0x4,%esp
80106f97:	68 00 10 00 00       	push   $0x1000
80106f9c:	6a 00                	push   $0x0
80106f9e:	50                   	push   %eax
80106f9f:	e8 bf da ff ff       	call   80104a63 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fa4:	83 c4 08             	add    $0x8,%esp
80106fa7:	6a 06                	push   $0x6
80106fa9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106faf:	50                   	push   %eax
80106fb0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fb5:	89 da                	mov    %ebx,%edx
80106fb7:	8b 45 08             	mov    0x8(%ebp),%eax
80106fba:	e8 7c fb ff ff       	call   80106b3b <mappages>
80106fbf:	83 c4 10             	add    $0x10,%esp
80106fc2:	85 c0                	test   %eax,%eax
80106fc4:	78 3c                	js     80107002 <allocuvm+0xac>
  for(; a < newsz; a += PGSIZE){
80106fc6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fcc:	39 df                	cmp    %ebx,%edi
80106fce:	77 b9                	ja     80106f89 <allocuvm+0x33>
80106fd0:	eb 67                	jmp    80107039 <allocuvm+0xe3>
    return oldsz;
80106fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fd8:	eb 5f                	jmp    80107039 <allocuvm+0xe3>
      cprintf("allocuvm out of memory\n");
80106fda:	83 ec 0c             	sub    $0xc,%esp
80106fdd:	68 2d 7f 10 80       	push   $0x80107f2d
80106fe2:	e8 fa 95 ff ff       	call   801005e1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106fe7:	83 c4 0c             	add    $0xc,%esp
80106fea:	ff 75 0c             	pushl  0xc(%ebp)
80106fed:	57                   	push   %edi
80106fee:	ff 75 08             	pushl  0x8(%ebp)
80106ff1:	e8 d1 fe ff ff       	call   80106ec7 <deallocuvm>
      return 0;
80106ff6:	83 c4 10             	add    $0x10,%esp
80106ff9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107000:	eb 37                	jmp    80107039 <allocuvm+0xe3>
      cprintf("allocuvm out of memory (2)\n");
80107002:	83 ec 0c             	sub    $0xc,%esp
80107005:	68 45 7f 10 80       	push   $0x80107f45
8010700a:	e8 d2 95 ff ff       	call   801005e1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010700f:	83 c4 0c             	add    $0xc,%esp
80107012:	ff 75 0c             	pushl  0xc(%ebp)
80107015:	57                   	push   %edi
80107016:	ff 75 08             	pushl  0x8(%ebp)
80107019:	e8 a9 fe ff ff       	call   80106ec7 <deallocuvm>
      kfree(mem);
8010701e:	89 34 24             	mov    %esi,(%esp)
80107021:	e8 9a b0 ff ff       	call   801020c0 <kfree>
      return 0;
80107026:	83 c4 10             	add    $0x10,%esp
80107029:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107030:	eb 07                	jmp    80107039 <allocuvm+0xe3>
    return 0;
80107032:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010703c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010703f:	5b                   	pop    %ebx
80107040:	5e                   	pop    %esi
80107041:	5f                   	pop    %edi
80107042:	5d                   	pop    %ebp
80107043:	c3                   	ret    

80107044 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107044:	55                   	push   %ebp
80107045:	89 e5                	mov    %esp,%ebp
80107047:	57                   	push   %edi
80107048:	56                   	push   %esi
80107049:	53                   	push   %ebx
8010704a:	83 ec 0c             	sub    $0xc,%esp
8010704d:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;

  if(pgdir == 0)
80107050:	85 ff                	test   %edi,%edi
80107052:	74 1d                	je     80107071 <freevm+0x2d>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107054:	83 ec 04             	sub    $0x4,%esp
80107057:	6a 00                	push   $0x0
80107059:	68 00 00 00 80       	push   $0x80000000
8010705e:	57                   	push   %edi
8010705f:	e8 63 fe ff ff       	call   80106ec7 <deallocuvm>
80107064:	89 fb                	mov    %edi,%ebx
80107066:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
8010706c:	83 c4 10             	add    $0x10,%esp
8010706f:	eb 14                	jmp    80107085 <freevm+0x41>
    panic("freevm: no pgdir");
80107071:	83 ec 0c             	sub    $0xc,%esp
80107074:	68 61 7f 10 80       	push   $0x80107f61
80107079:	e8 c6 92 ff ff       	call   80100344 <panic>
8010707e:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107081:	39 f3                	cmp    %esi,%ebx
80107083:	74 1e                	je     801070a3 <freevm+0x5f>
    if(pgdir[i] & PTE_P){
80107085:	8b 03                	mov    (%ebx),%eax
80107087:	a8 01                	test   $0x1,%al
80107089:	74 f3                	je     8010707e <freevm+0x3a>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010708b:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010708e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107093:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107098:	50                   	push   %eax
80107099:	e8 22 b0 ff ff       	call   801020c0 <kfree>
8010709e:	83 c4 10             	add    $0x10,%esp
801070a1:	eb db                	jmp    8010707e <freevm+0x3a>
    }
  }
  kfree((char*)pgdir);
801070a3:	83 ec 0c             	sub    $0xc,%esp
801070a6:	57                   	push   %edi
801070a7:	e8 14 b0 ff ff       	call   801020c0 <kfree>
}
801070ac:	83 c4 10             	add    $0x10,%esp
801070af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b2:	5b                   	pop    %ebx
801070b3:	5e                   	pop    %esi
801070b4:	5f                   	pop    %edi
801070b5:	5d                   	pop    %ebp
801070b6:	c3                   	ret    

801070b7 <setupkvm>:
{
801070b7:	55                   	push   %ebp
801070b8:	89 e5                	mov    %esp,%ebp
801070ba:	56                   	push   %esi
801070bb:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801070bc:	e8 24 b1 ff ff       	call   801021e5 <kalloc>
801070c1:	89 c6                	mov    %eax,%esi
801070c3:	85 c0                	test   %eax,%eax
801070c5:	74 42                	je     80107109 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801070c7:	83 ec 04             	sub    $0x4,%esp
801070ca:	68 00 10 00 00       	push   $0x1000
801070cf:	6a 00                	push   $0x0
801070d1:	50                   	push   %eax
801070d2:	e8 8c d9 ff ff       	call   80104a63 <memset>
801070d7:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070da:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
801070df:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801070e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070e5:	29 c1                	sub    %eax,%ecx
801070e7:	83 ec 08             	sub    $0x8,%esp
801070ea:	ff 73 0c             	pushl  0xc(%ebx)
801070ed:	50                   	push   %eax
801070ee:	8b 13                	mov    (%ebx),%edx
801070f0:	89 f0                	mov    %esi,%eax
801070f2:	e8 44 fa ff ff       	call   80106b3b <mappages>
801070f7:	83 c4 10             	add    $0x10,%esp
801070fa:	85 c0                	test   %eax,%eax
801070fc:	78 14                	js     80107112 <setupkvm+0x5b>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070fe:	83 c3 10             	add    $0x10,%ebx
80107101:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107107:	75 d6                	jne    801070df <setupkvm+0x28>
}
80107109:	89 f0                	mov    %esi,%eax
8010710b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010710e:	5b                   	pop    %ebx
8010710f:	5e                   	pop    %esi
80107110:	5d                   	pop    %ebp
80107111:	c3                   	ret    
      freevm(pgdir);
80107112:	83 ec 0c             	sub    $0xc,%esp
80107115:	56                   	push   %esi
80107116:	e8 29 ff ff ff       	call   80107044 <freevm>
      return 0;
8010711b:	83 c4 10             	add    $0x10,%esp
8010711e:	be 00 00 00 00       	mov    $0x0,%esi
80107123:	eb e4                	jmp    80107109 <setupkvm+0x52>

80107125 <kvmalloc>:
{
80107125:	55                   	push   %ebp
80107126:	89 e5                	mov    %esp,%ebp
80107128:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010712b:	e8 87 ff ff ff       	call   801070b7 <setupkvm>
80107130:	a3 c4 5a 11 80       	mov    %eax,0x80115ac4
  switchkvm();
80107135:	e8 66 fb ff ff       	call   80106ca0 <switchkvm>
}
8010713a:	c9                   	leave  
8010713b:	c3                   	ret    

8010713c <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010713c:	55                   	push   %ebp
8010713d:	89 e5                	mov    %esp,%ebp
8010713f:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107142:	b9 00 00 00 00       	mov    $0x0,%ecx
80107147:	8b 55 0c             	mov    0xc(%ebp),%edx
8010714a:	8b 45 08             	mov    0x8(%ebp),%eax
8010714d:	e8 7a f9 ff ff       	call   80106acc <walkpgdir>
  if(pte == 0)
80107152:	85 c0                	test   %eax,%eax
80107154:	74 05                	je     8010715b <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107156:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107159:	c9                   	leave  
8010715a:	c3                   	ret    
    panic("clearpteu");
8010715b:	83 ec 0c             	sub    $0xc,%esp
8010715e:	68 72 7f 10 80       	push   $0x80107f72
80107163:	e8 dc 91 ff ff       	call   80100344 <panic>

80107168 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107168:	55                   	push   %ebp
80107169:	89 e5                	mov    %esp,%ebp
8010716b:	57                   	push   %edi
8010716c:	56                   	push   %esi
8010716d:	53                   	push   %ebx
8010716e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107171:	e8 41 ff ff ff       	call   801070b7 <setupkvm>
80107176:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107179:	85 c0                	test   %eax,%eax
8010717b:	0f 84 bb 00 00 00    	je     8010723c <copyuvm+0xd4>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107181:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80107185:	0f 84 b1 00 00 00    	je     8010723c <copyuvm+0xd4>
8010718b:	bf 00 00 00 00       	mov    $0x0,%edi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107190:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107193:	b9 00 00 00 00       	mov    $0x0,%ecx
80107198:	89 fa                	mov    %edi,%edx
8010719a:	8b 45 08             	mov    0x8(%ebp),%eax
8010719d:	e8 2a f9 ff ff       	call   80106acc <walkpgdir>
801071a2:	85 c0                	test   %eax,%eax
801071a4:	74 67                	je     8010720d <copyuvm+0xa5>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801071a6:	8b 00                	mov    (%eax),%eax
801071a8:	a8 01                	test   $0x1,%al
801071aa:	74 6e                	je     8010721a <copyuvm+0xb2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801071ac:	89 c6                	mov    %eax,%esi
801071ae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
801071b4:	25 ff 0f 00 00       	and    $0xfff,%eax
801071b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
801071bc:	e8 24 b0 ff ff       	call   801021e5 <kalloc>
801071c1:	89 c3                	mov    %eax,%ebx
801071c3:	85 c0                	test   %eax,%eax
801071c5:	74 60                	je     80107227 <copyuvm+0xbf>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801071c7:	83 ec 04             	sub    $0x4,%esp
801071ca:	68 00 10 00 00       	push   $0x1000
801071cf:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801071d5:	56                   	push   %esi
801071d6:	50                   	push   %eax
801071d7:	e8 1c d9 ff ff       	call   80104af8 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801071dc:	83 c4 08             	add    $0x8,%esp
801071df:	ff 75 e0             	pushl  -0x20(%ebp)
801071e2:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801071e8:	53                   	push   %ebx
801071e9:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801071f4:	e8 42 f9 ff ff       	call   80106b3b <mappages>
801071f9:	83 c4 10             	add    $0x10,%esp
801071fc:	85 c0                	test   %eax,%eax
801071fe:	78 27                	js     80107227 <copyuvm+0xbf>
  for(i = 0; i < sz; i += PGSIZE){
80107200:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107206:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107209:	77 85                	ja     80107190 <copyuvm+0x28>
8010720b:	eb 2f                	jmp    8010723c <copyuvm+0xd4>
      panic("copyuvm: pte should exist");
8010720d:	83 ec 0c             	sub    $0xc,%esp
80107210:	68 7c 7f 10 80       	push   $0x80107f7c
80107215:	e8 2a 91 ff ff       	call   80100344 <panic>
      panic("copyuvm: page not present");
8010721a:	83 ec 0c             	sub    $0xc,%esp
8010721d:	68 96 7f 10 80       	push   $0x80107f96
80107222:	e8 1d 91 ff ff       	call   80100344 <panic>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107227:	83 ec 0c             	sub    $0xc,%esp
8010722a:	ff 75 dc             	pushl  -0x24(%ebp)
8010722d:	e8 12 fe ff ff       	call   80107044 <freevm>
  return 0;
80107232:	83 c4 10             	add    $0x10,%esp
80107235:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
8010723c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010723f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107242:	5b                   	pop    %ebx
80107243:	5e                   	pop    %esi
80107244:	5f                   	pop    %edi
80107245:	5d                   	pop    %ebp
80107246:	c3                   	ret    

80107247 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107247:	55                   	push   %ebp
80107248:	89 e5                	mov    %esp,%ebp
8010724a:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010724d:	b9 00 00 00 00       	mov    $0x0,%ecx
80107252:	8b 55 0c             	mov    0xc(%ebp),%edx
80107255:	8b 45 08             	mov    0x8(%ebp),%eax
80107258:	e8 6f f8 ff ff       	call   80106acc <walkpgdir>
  if((*pte & PTE_P) == 0)
8010725d:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
8010725f:	89 c2                	mov    %eax,%edx
80107261:	83 e2 05             	and    $0x5,%edx
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107264:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107269:	05 00 00 00 80       	add    $0x80000000,%eax
8010726e:	83 fa 05             	cmp    $0x5,%edx
80107271:	ba 00 00 00 00       	mov    $0x0,%edx
80107276:	0f 45 c2             	cmovne %edx,%eax
}
80107279:	c9                   	leave  
8010727a:	c3                   	ret    

8010727b <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010727b:	55                   	push   %ebp
8010727c:	89 e5                	mov    %esp,%ebp
8010727e:	57                   	push   %edi
8010727f:	56                   	push   %esi
80107280:	53                   	push   %ebx
80107281:	83 ec 0c             	sub    $0xc,%esp
80107284:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107287:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010728b:	74 55                	je     801072e2 <copyout+0x67>
    va0 = (uint)PGROUNDDOWN(va);
8010728d:	89 df                	mov    %ebx,%edi
8010728f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107295:	83 ec 08             	sub    $0x8,%esp
80107298:	57                   	push   %edi
80107299:	ff 75 08             	pushl  0x8(%ebp)
8010729c:	e8 a6 ff ff ff       	call   80107247 <uva2ka>
    if(pa0 == 0)
801072a1:	83 c4 10             	add    $0x10,%esp
801072a4:	85 c0                	test   %eax,%eax
801072a6:	74 41                	je     801072e9 <copyout+0x6e>
      return -1;
    n = PGSIZE - (va - va0);
801072a8:	89 fe                	mov    %edi,%esi
801072aa:	29 de                	sub    %ebx,%esi
801072ac:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072b2:	3b 75 14             	cmp    0x14(%ebp),%esi
801072b5:	0f 47 75 14          	cmova  0x14(%ebp),%esi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801072b9:	83 ec 04             	sub    $0x4,%esp
801072bc:	56                   	push   %esi
801072bd:	ff 75 10             	pushl  0x10(%ebp)
801072c0:	29 fb                	sub    %edi,%ebx
801072c2:	01 d8                	add    %ebx,%eax
801072c4:	50                   	push   %eax
801072c5:	e8 2e d8 ff ff       	call   80104af8 <memmove>
    len -= n;
    buf += n;
801072ca:	01 75 10             	add    %esi,0x10(%ebp)
    va = va0 + PGSIZE;
801072cd:	8d 9f 00 10 00 00    	lea    0x1000(%edi),%ebx
  while(len > 0){
801072d3:	83 c4 10             	add    $0x10,%esp
801072d6:	29 75 14             	sub    %esi,0x14(%ebp)
801072d9:	75 b2                	jne    8010728d <copyout+0x12>
  }
  return 0;
801072db:	b8 00 00 00 00       	mov    $0x0,%eax
801072e0:	eb 0c                	jmp    801072ee <copyout+0x73>
801072e2:	b8 00 00 00 00       	mov    $0x0,%eax
801072e7:	eb 05                	jmp    801072ee <copyout+0x73>
      return -1;
801072e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f1:	5b                   	pop    %ebx
801072f2:	5e                   	pop    %esi
801072f3:	5f                   	pop    %edi
801072f4:	5d                   	pop    %ebp
801072f5:	c3                   	ret    
