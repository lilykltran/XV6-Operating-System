
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
8010003b:	68 a0 72 10 80       	push   $0x801072a0
80100040:	68 60 db 10 80       	push   $0x8010db60
80100045:	e8 be 47 00 00       	call   80104808 <initlock>

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
80100078:	68 a7 72 10 80       	push   $0x801072a7
8010007d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100080:	50                   	push   %eax
80100081:	e8 9b 46 00 00       	call   80104721 <initsleeplock>
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
801000be:	e8 8d 48 00 00       	call   80104950 <acquire>
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
801000e5:	68 ae 72 10 80       	push   $0x801072ae
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
80100110:	e8 a2 48 00 00       	call   801049b7 <release>
      acquiresleep(&b->lock);
80100115:	8d 43 0c             	lea    0xc(%ebx),%eax
80100118:	89 04 24             	mov    %eax,(%esp)
8010011b:	e8 34 46 00 00       	call   80104754 <acquiresleep>
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
80100156:	e8 5c 48 00 00       	call   801049b7 <release>
      acquiresleep(&b->lock);
8010015b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010015e:	89 04 24             	mov    %eax,(%esp)
80100161:	e8 ee 45 00 00       	call   80104754 <acquiresleep>
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
80100194:	e8 48 46 00 00       	call   801047e1 <holdingsleep>
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
801001b7:	68 bf 72 10 80       	push   $0x801072bf
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
801001d0:	e8 0c 46 00 00       	call   801047e1 <holdingsleep>
801001d5:	83 c4 10             	add    $0x10,%esp
801001d8:	85 c0                	test   %eax,%eax
801001da:	74 6b                	je     80100247 <brelse+0x86>
    panic("brelse");

  releasesleep(&b->lock);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	56                   	push   %esi
801001e0:	e8 c1 45 00 00       	call   801047a6 <releasesleep>

  acquire(&bcache.lock);
801001e5:	c7 04 24 60 db 10 80 	movl   $0x8010db60,(%esp)
801001ec:	e8 5f 47 00 00       	call   80104950 <acquire>
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
80100238:	e8 7a 47 00 00       	call   801049b7 <release>
}
8010023d:	83 c4 10             	add    $0x10,%esp
80100240:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100243:	5b                   	pop    %ebx
80100244:	5e                   	pop    %esi
80100245:	5d                   	pop    %ebp
80100246:	c3                   	ret    
    panic("brelse");
80100247:	83 ec 0c             	sub    $0xc,%esp
8010024a:	68 c6 72 10 80       	push   $0x801072c6
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
80100275:	e8 d6 46 00 00       	call   80104950 <acquire>
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
80100294:	e8 e8 32 00 00       	call   80103581 <myproc>
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
801002ac:	e8 41 3a 00 00       	call   80103cf2 <sleep>
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
801002f6:	e8 bc 46 00 00       	call   801049b7 <release>
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
80100318:	e8 9a 46 00 00       	call   801049b7 <release>
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
80100360:	68 cd 72 10 80       	push   $0x801072cd
80100365:	e8 77 02 00 00       	call   801005e1 <cprintf>
  cprintf(s);
8010036a:	83 c4 04             	add    $0x4,%esp
8010036d:	ff 75 08             	pushl  0x8(%ebp)
80100370:	e8 6c 02 00 00       	call   801005e1 <cprintf>
  cprintf("\n");
80100375:	c7 04 24 1f 7e 10 80 	movl   $0x80107e1f,(%esp)
8010037c:	e8 60 02 00 00       	call   801005e1 <cprintf>
  getcallerpcs(&s, pcs);
80100381:	83 c4 08             	add    $0x8,%esp
80100384:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100387:	53                   	push   %ebx
80100388:	8d 45 08             	lea    0x8(%ebp),%eax
8010038b:	50                   	push   %eax
8010038c:	e8 92 44 00 00       	call   80104823 <getcallerpcs>
80100391:	8d 75 f8             	lea    -0x8(%ebp),%esi
80100394:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100397:	83 ec 08             	sub    $0x8,%esp
8010039a:	ff 33                	pushl  (%ebx)
8010039c:	68 e1 72 10 80       	push   $0x801072e1
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
801003de:	e8 fe 5a 00 00       	call   80105ee1 <uartputc>
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
8010043e:	e8 9e 5a 00 00       	call   80105ee1 <uartputc>
80100443:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010044a:	e8 92 5a 00 00       	call   80105ee1 <uartputc>
8010044f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100456:	e8 86 5a 00 00       	call   80105ee1 <uartputc>
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
801004c3:	68 e5 72 10 80       	push   $0x801072e5
801004c8:	e8 77 fe ff ff       	call   80100344 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004cd:	83 ec 04             	sub    $0x4,%esp
801004d0:	68 60 0e 00 00       	push   $0xe60
801004d5:	68 a0 80 0b 80       	push   $0x800b80a0
801004da:	68 00 80 0b 80       	push   $0x800b8000
801004df:	e8 af 45 00 00       	call   80104a93 <memmove>
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
801004ff:	e8 fa 44 00 00       	call   801049fe <memset>
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
80100546:	0f b6 92 10 73 10 80 	movzbl -0x7fef8cf0(%edx),%edx
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
801005a0:	e8 ab 43 00 00       	call   80104950 <acquire>
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
801005c7:	e8 eb 43 00 00       	call   801049b7 <release>
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
80100629:	e8 22 43 00 00       	call   80104950 <acquire>
8010062e:	83 c4 10             	add    $0x10,%esp
80100631:	eb c3                	jmp    801005f6 <cprintf+0x15>
    panic("null fmt");
80100633:	83 ec 0c             	sub    $0xc,%esp
80100636:	68 ff 72 10 80       	push   $0x801072ff
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
801006f0:	be f8 72 10 80       	mov    $0x801072f8,%esi
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
8010072e:	e8 84 42 00 00       	call   801049b7 <release>
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
8010074c:	e8 ff 41 00 00       	call   80104950 <acquire>
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
801008e7:	e8 cb 40 00 00       	call   801049b7 <release>
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
80100901:	e8 24 2e 00 00       	call   8010372a <traverse>
80100906:	83 c4 10             	add    $0x10,%esp
}
80100909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010090c:	5b                   	pop    %ebx
8010090d:	5e                   	pop    %esi
8010090e:	5f                   	pop    %edi
8010090f:	5d                   	pop    %ebp
80100910:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
80100911:	e8 59 3b 00 00       	call   8010446f <procdump>
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
80100946:	e8 9a 36 00 00       	call   80103fe5 <wakeup>
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
80100959:	68 08 73 10 80       	push   $0x80107308
8010095e:	68 20 a5 10 80       	push   $0x8010a520
80100963:	e8 a0 3e 00 00       	call   80104808 <initlock>

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
801009a3:	e8 d9 2b 00 00       	call   80103581 <myproc>
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
80100a1f:	e8 2e 66 00 00       	call   80107052 <setupkvm>
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
80100ac0:	e8 2c 64 00 00       	call   80106ef1 <allocuvm>
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
80100af1:	e8 be 62 00 00       	call   80106db4 <loaduvm>
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
80100b39:	e8 b3 63 00 00       	call   80106ef1 <allocuvm>
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
80100b54:	e8 86 64 00 00       	call   80106fdf <freevm>
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
80100b7b:	e8 57 65 00 00       	call   801070d7 <clearpteu>
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
80100b95:	e8 27 40 00 00       	call   80104bc1 <strlen>
80100b9a:	f7 d0                	not    %eax
80100b9c:	01 d8                	add    %ebx,%eax
80100b9e:	83 e0 fc             	and    $0xfffffffc,%eax
80100ba1:	89 c3                	mov    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ba3:	83 c4 04             	add    $0x4,%esp
80100ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ba9:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bac:	e8 10 40 00 00       	call   80104bc1 <strlen>
80100bb1:	83 c0 01             	add    $0x1,%eax
80100bb4:	50                   	push   %eax
80100bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb8:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bbb:	53                   	push   %ebx
80100bbc:	57                   	push   %edi
80100bbd:	e8 54 66 00 00       	call   80107216 <copyout>
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
80100c33:	e8 de 65 00 00       	call   80107216 <copyout>
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
80100c7b:	e8 0d 3f 00 00       	call   80104b8d <safestrcpy>
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
80100ca7:	e8 a1 5f 00 00       	call   80106c4d <switchuvm>
  freevm(oldpgdir);
80100cac:	89 1c 24             	mov    %ebx,(%esp)
80100caf:	e8 2b 63 00 00       	call   80106fdf <freevm>
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
80100cdb:	68 21 73 10 80       	push   $0x80107321
80100ce0:	68 60 25 11 80       	push   $0x80112560
80100ce5:	e8 1e 3b 00 00       	call   80104808 <initlock>
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
80100cfb:	e8 50 3c 00 00       	call   80104950 <acquire>
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
80100d2a:	e8 88 3c 00 00       	call   801049b7 <release>
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
80100d4d:	e8 65 3c 00 00       	call   801049b7 <release>
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
80100d6b:	e8 e0 3b 00 00       	call   80104950 <acquire>
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
80100d88:	e8 2a 3c 00 00       	call   801049b7 <release>
  return f;
}
80100d8d:	89 d8                	mov    %ebx,%eax
80100d8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d92:	c9                   	leave  
80100d93:	c3                   	ret    
    panic("filedup");
80100d94:	83 ec 0c             	sub    $0xc,%esp
80100d97:	68 28 73 10 80       	push   $0x80107328
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
80100db2:	e8 99 3b 00 00       	call   80104950 <acquire>
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
80100dd3:	e8 df 3b 00 00       	call   801049b7 <release>
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
80100de6:	68 30 73 10 80       	push   $0x80107330
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
80100e17:	e8 9b 3b 00 00       	call   801049b7 <release>
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
80100f11:	68 3a 73 10 80       	push   $0x8010733a
80100f16:	e8 29 f4 ff ff       	call   80100344 <panic>
    return -1;
80100f1b:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100f20:	eb cb                	jmp    80100eed <fileread+0x50>

80100f22 <filewrite>:

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
80100fe2:	68 43 73 10 80       	push   $0x80107343
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
80101016:	68 49 73 10 80       	push   $0x80107349
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
80101088:	e8 71 39 00 00       	call   801049fe <memset>
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
80101177:	68 53 73 10 80       	push   $0x80107353
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
8010121c:	68 69 73 10 80       	push   $0x80107369
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
80101239:	e8 12 37 00 00       	call   80104950 <acquire>
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
8010128a:	e8 28 37 00 00       	call   801049b7 <release>
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
801012b8:	e8 fa 36 00 00       	call   801049b7 <release>
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
801012cd:	68 7c 73 10 80       	push   $0x8010737c
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
801012f6:	e8 98 37 00 00       	call   80104a93 <memmove>
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
80101383:	68 8c 73 10 80       	push   $0x8010738c
80101388:	e8 b7 ef ff ff       	call   80100344 <panic>

8010138d <iinit>:
{
8010138d:	55                   	push   %ebp
8010138e:	89 e5                	mov    %esp,%ebp
80101390:	56                   	push   %esi
80101391:	53                   	push   %ebx
  initlock(&icache.lock, "icache");
80101392:	83 ec 08             	sub    $0x8,%esp
80101395:	68 9f 73 10 80       	push   $0x8010739f
8010139a:	68 80 2f 11 80       	push   $0x80112f80
8010139f:	e8 64 34 00 00       	call   80104808 <initlock>
801013a4:	bb c0 2f 11 80       	mov    $0x80112fc0,%ebx
801013a9:	be e0 4b 11 80       	mov    $0x80114be0,%esi
801013ae:	83 c4 10             	add    $0x10,%esp
    initsleeplock(&icache.inode[i].lock, "inode");
801013b1:	83 ec 08             	sub    $0x8,%esp
801013b4:	68 a6 73 10 80       	push   $0x801073a6
801013b9:	53                   	push   %ebx
801013ba:	e8 62 33 00 00       	call   80104721 <initsleeplock>
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
80101406:	68 0c 74 10 80       	push   $0x8010740c
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
80101482:	68 ac 73 10 80       	push   $0x801073ac
80101487:	e8 b8 ee ff ff       	call   80100344 <panic>
      memset(dip, 0, sizeof(*dip));
8010148c:	83 ec 04             	sub    $0x4,%esp
8010148f:	6a 40                	push   $0x40
80101491:	6a 00                	push   $0x0
80101493:	57                   	push   %edi
80101494:	e8 65 35 00 00       	call   801049fe <memset>
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
80101523:	e8 6b 35 00 00       	call   80104a93 <memmove>
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
80101551:	e8 fa 33 00 00       	call   80104950 <acquire>
  ip->ref++;
80101556:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010155a:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
80101561:	e8 51 34 00 00       	call   801049b7 <release>
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
80101586:	e8 c9 31 00 00       	call   80104754 <acquiresleep>
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
8010159e:	68 be 73 10 80       	push   $0x801073be
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
80101600:	e8 8e 34 00 00       	call   80104a93 <memmove>
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
80101625:	68 c4 73 10 80       	push   $0x801073c4
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
80101642:	e8 9a 31 00 00       	call   801047e1 <holdingsleep>
80101647:	83 c4 10             	add    $0x10,%esp
8010164a:	85 c0                	test   %eax,%eax
8010164c:	74 19                	je     80101667 <iunlock+0x38>
8010164e:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101652:	7e 13                	jle    80101667 <iunlock+0x38>
  releasesleep(&ip->lock);
80101654:	83 ec 0c             	sub    $0xc,%esp
80101657:	56                   	push   %esi
80101658:	e8 49 31 00 00       	call   801047a6 <releasesleep>
}
8010165d:	83 c4 10             	add    $0x10,%esp
80101660:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101663:	5b                   	pop    %ebx
80101664:	5e                   	pop    %esi
80101665:	5d                   	pop    %ebp
80101666:	c3                   	ret    
    panic("iunlock");
80101667:	83 ec 0c             	sub    $0xc,%esp
8010166a:	68 d3 73 10 80       	push   $0x801073d3
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
80101684:	e8 cb 30 00 00       	call   80104754 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101689:	83 c4 10             	add    $0x10,%esp
8010168c:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101690:	74 07                	je     80101699 <iput+0x25>
80101692:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101697:	74 30                	je     801016c9 <iput+0x55>
  releasesleep(&ip->lock);
80101699:	83 ec 0c             	sub    $0xc,%esp
8010169c:	56                   	push   %esi
8010169d:	e8 04 31 00 00       	call   801047a6 <releasesleep>
  acquire(&icache.lock);
801016a2:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
801016a9:	e8 a2 32 00 00       	call   80104950 <acquire>
  ip->ref--;
801016ae:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016b2:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
801016b9:	e8 f9 32 00 00       	call   801049b7 <release>
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
801016d1:	e8 7a 32 00 00       	call   80104950 <acquire>
    int r = ip->ref;
801016d6:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801016d9:	c7 04 24 80 2f 11 80 	movl   $0x80112f80,(%esp)
801016e0:	e8 d2 32 00 00       	call   801049b7 <release>
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
8010188e:	e8 00 32 00 00       	call   80104a93 <memmove>
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
8010198a:	e8 04 31 00 00       	call   80104a93 <memmove>
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
80101a2c:	e8 c1 30 00 00       	call   80104af2 <strncmp>
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
80101a5e:	68 db 73 10 80       	push   $0x801073db
80101a63:	e8 dc e8 ff ff       	call   80100344 <panic>
      panic("dirlookup read");
80101a68:	83 ec 0c             	sub    $0xc,%esp
80101a6b:	68 ed 73 10 80       	push   $0x801073ed
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
80101ae7:	e8 95 1a 00 00       	call   80103581 <myproc>
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
80101b6b:	e8 23 2f 00 00       	call   80104a93 <memmove>
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
80101c21:	e8 6d 2e 00 00       	call   80104a93 <memmove>
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
80101cb2:	e8 87 2e 00 00       	call   80104b3e <strncpy>
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
80101cf3:	68 fc 73 10 80       	push   $0x801073fc
80101cf8:	e8 47 e6 ff ff       	call   80100344 <panic>
    panic("dirlink");
80101cfd:	83 ec 0c             	sub    $0xc,%esp
80101d00:	68 be 7b 10 80       	push   $0x80107bbe
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
80101dce:	68 5f 74 10 80       	push   $0x8010745f
80101dd3:	e8 6c e5 ff ff       	call   80100344 <panic>
    panic("incorrect blockno");
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	68 68 74 10 80       	push   $0x80107468
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
80101e08:	68 7a 74 10 80       	push   $0x8010747a
80101e0d:	68 80 a5 10 80       	push   $0x8010a580
80101e12:	e8 f1 29 00 00       	call   80104808 <initlock>
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
80101e84:	e8 c7 2a 00 00       	call   80104950 <acquire>

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
80101eb1:	e8 2f 21 00 00       	call   80103fe5 <wakeup>

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
80101ecf:	e8 e3 2a 00 00       	call   801049b7 <release>
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
80101ee6:	e8 cc 2a 00 00       	call   801049b7 <release>
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
80101f24:	e8 b8 28 00 00       	call   801047e1 <holdingsleep>
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
80101f51:	e8 fa 29 00 00       	call   80104950 <acquire>

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
80101f74:	68 7e 74 10 80       	push   $0x8010747e
80101f79:	e8 c6 e3 ff ff       	call   80100344 <panic>
    panic("iderw: nothing to do");
80101f7e:	83 ec 0c             	sub    $0xc,%esp
80101f81:	68 94 74 10 80       	push   $0x80107494
80101f86:	e8 b9 e3 ff ff       	call   80100344 <panic>
    panic("iderw: ide disk 1 not present");
80101f8b:	83 ec 0c             	sub    $0xc,%esp
80101f8e:	68 a9 74 10 80       	push   $0x801074a9
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
80101fc1:	e8 2c 1d 00 00       	call   80103cf2 <sleep>
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
80101fdb:	e8 d7 29 00 00       	call   801049b7 <release>
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
8010207e:	68 c8 74 10 80       	push   $0x801074c8
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
801020f2:	e8 07 29 00 00       	call   801049fe <memset>

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
80102121:	68 fa 74 10 80       	push   $0x801074fa
80102126:	e8 19 e2 ff ff       	call   80100344 <panic>
    acquire(&kmem.lock);
8010212b:	83 ec 0c             	sub    $0xc,%esp
8010212e:	68 e0 4b 11 80       	push   $0x80114be0
80102133:	e8 18 28 00 00       	call   80104950 <acquire>
80102138:	83 c4 10             	add    $0x10,%esp
8010213b:	eb c6                	jmp    80102103 <kfree+0x43>
    release(&kmem.lock);
8010213d:	83 ec 0c             	sub    $0xc,%esp
80102140:	68 e0 4b 11 80       	push   $0x80114be0
80102145:	e8 6d 28 00 00       	call   801049b7 <release>
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
80102199:	68 00 75 10 80       	push   $0x80107500
8010219e:	68 e0 4b 11 80       	push   $0x80114be0
801021a3:	e8 60 26 00 00       	call   80104808 <initlock>
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
8010221e:	e8 2d 27 00 00       	call   80104950 <acquire>
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
8010223a:	e8 78 27 00 00       	call   801049b7 <release>
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
80102281:	0f b6 8a 40 76 10 80 	movzbl -0x7fef89c0(%edx),%ecx
80102288:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
  shift ^= togglecode[data];
8010228e:	0f b6 82 40 75 10 80 	movzbl -0x7fef8ac0(%edx),%eax
80102295:	31 c1                	xor    %eax,%ecx
80102297:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010229d:	89 c8                	mov    %ecx,%eax
8010229f:	83 e0 03             	and    $0x3,%eax
801022a2:	8b 04 85 20 75 10 80 	mov    -0x7fef8ae0(,%eax,4),%eax
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
801022e2:	0f b6 82 40 76 10 80 	movzbl -0x7fef89c0(%edx),%eax
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
801025f4:	e8 49 24 00 00       	call   80104a42 <memcmp>
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
8010270e:	e8 80 23 00 00       	call   80104a93 <memmove>
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
801027a9:	68 40 77 10 80       	push   $0x80107740
801027ae:	68 20 4c 11 80       	push   $0x80114c20
801027b3:	e8 50 20 00 00       	call   80104808 <initlock>
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
80102840:	e8 0b 21 00 00       	call   80104950 <acquire>
80102845:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80102848:	bb 20 4c 11 80       	mov    $0x80114c20,%ebx
8010284d:	eb 15                	jmp    80102864 <begin_op+0x30>
      sleep(&log, &log.lock);
8010284f:	83 ec 08             	sub    $0x8,%esp
80102852:	68 20 4c 11 80       	push   $0x80114c20
80102857:	68 20 4c 11 80       	push   $0x80114c20
8010285c:	e8 91 14 00 00       	call   80103cf2 <sleep>
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
8010288b:	e8 62 14 00 00       	call   80103cf2 <sleep>
80102890:	83 c4 10             	add    $0x10,%esp
80102893:	eb cf                	jmp    80102864 <begin_op+0x30>
    } else {
      log.outstanding += 1;
80102895:	a3 5c 4c 11 80       	mov    %eax,0x80114c5c
      release(&log.lock);
8010289a:	83 ec 0c             	sub    $0xc,%esp
8010289d:	68 20 4c 11 80       	push   $0x80114c20
801028a2:	e8 10 21 00 00       	call   801049b7 <release>
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
801028bd:	e8 8e 20 00 00       	call   80104950 <acquire>
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
801028fa:	e8 b8 20 00 00       	call   801049b7 <release>
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
8010294b:	e8 43 21 00 00       	call   80104a93 <memmove>
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
80102997:	e8 b4 1f 00 00       	call   80104950 <acquire>
    log.committing = 0;
8010299c:	c7 05 60 4c 11 80 00 	movl   $0x0,0x80114c60
801029a3:	00 00 00 
    wakeup(&log);
801029a6:	c7 04 24 20 4c 11 80 	movl   $0x80114c20,(%esp)
801029ad:	e8 33 16 00 00       	call   80103fe5 <wakeup>
    release(&log.lock);
801029b2:	c7 04 24 20 4c 11 80 	movl   $0x80114c20,(%esp)
801029b9:	e8 f9 1f 00 00       	call   801049b7 <release>
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
801029cc:	68 44 77 10 80       	push   $0x80107744
801029d1:	e8 6e d9 ff ff       	call   80100344 <panic>
    wakeup(&log);
801029d6:	83 ec 0c             	sub    $0xc,%esp
801029d9:	68 20 4c 11 80       	push   $0x80114c20
801029de:	e8 02 16 00 00       	call   80103fe5 <wakeup>
  release(&log.lock);
801029e3:	c7 04 24 20 4c 11 80 	movl   $0x80114c20,(%esp)
801029ea:	e8 c8 1f 00 00       	call   801049b7 <release>
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
80102a26:	e8 25 1f 00 00       	call   80104950 <acquire>
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
80102a6a:	e8 48 1f 00 00       	call   801049b7 <release>
}
80102a6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a72:	c9                   	leave  
80102a73:	c3                   	ret    
    panic("too big a transaction");
80102a74:	83 ec 0c             	sub    $0xc,%esp
80102a77:	68 53 77 10 80       	push   $0x80107753
80102a7c:	e8 c3 d8 ff ff       	call   80100344 <panic>
    panic("log_write outside of trans");
80102a81:	83 ec 0c             	sub    $0xc,%esp
80102a84:	68 69 77 10 80       	push   $0x80107769
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
80102ac0:	e8 a1 0a 00 00       	call   80103566 <cpuid>
80102ac5:	89 c3                	mov    %eax,%ebx
80102ac7:	e8 9a 0a 00 00       	call   80103566 <cpuid>
80102acc:	83 ec 04             	sub    $0x4,%esp
80102acf:	53                   	push   %ebx
80102ad0:	50                   	push   %eax
80102ad1:	68 84 77 10 80       	push   $0x80107784
80102ad6:	e8 06 db ff ff       	call   801005e1 <cprintf>
  idtinit();       // load idt register
80102adb:	e8 94 31 00 00       	call   80105c74 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ae0:	e8 0a 0a 00 00       	call   801034ef <mycpu>
80102ae5:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ae7:	b8 01 00 00 00       	mov    $0x1,%eax
80102aec:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102af3:	e8 02 0f 00 00       	call   801039fa <scheduler>

80102af8 <mpenter>:
{
80102af8:	55                   	push   %ebp
80102af9:	89 e5                	mov    %esp,%ebp
80102afb:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102afe:	e8 38 41 00 00       	call   80106c3b <switchkvm>
  seginit();
80102b03:	e8 4c 40 00 00       	call   80106b54 <seginit>
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
80102b33:	e8 88 45 00 00       	call   801070c0 <kvmalloc>
  mpinit();        // detect other processors
80102b38:	e8 50 01 00 00       	call   80102c8d <mpinit>
  lapicinit();     // interrupt controller
80102b3d:	e8 7a f8 ff ff       	call   801023bc <lapicinit>
  seginit();       // segment descriptors
80102b42:	e8 0d 40 00 00       	call   80106b54 <seginit>
  picinit();       // disable pic
80102b47:	e8 01 03 00 00       	call   80102e4d <picinit>
  ioapicinit();    // another interrupt controller
80102b4c:	e8 a0 f4 ff ff       	call   80101ff1 <ioapicinit>
  consoleinit();   // console hardware
80102b51:	e8 fd dd ff ff       	call   80100953 <consoleinit>
  uartinit();      // serial port
80102b56:	e8 e0 33 00 00       	call   80105f3b <uartinit>
  pinit();         // process table
80102b5b:	e8 75 09 00 00       	call   801034d5 <pinit>
  tvinit();        // trap vectors
80102b60:	e8 9c 30 00 00       	call   80105c01 <tvinit>
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
80102b86:	e8 08 1f 00 00       	call   80104a93 <memmove>

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
80102bc4:	e8 26 09 00 00       	call   801034ef <mycpu>
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
80102c22:	e8 7e 09 00 00       	call   801035a5 <userinit>
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
80102c59:	68 98 77 10 80       	push   $0x80107798
80102c5e:	53                   	push   %ebx
80102c5f:	e8 de 1d 00 00       	call   80104a42 <memcmp>
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
80102ce2:	68 9d 77 10 80       	push   $0x8010779d
80102ce7:	56                   	push   %esi
80102ce8:	e8 55 1d 00 00       	call   80104a42 <memcmp>
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
80102db1:	68 a2 77 10 80       	push   $0x801077a2
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
80102dfb:	ff 24 95 dc 77 10 80 	jmp    *-0x7fef8824(,%edx,4)
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
80102e43:	68 bc 77 10 80       	push   $0x801077bc
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
  return 0;

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
80102edd:	68 f0 77 10 80       	push   $0x801077f0
80102ee2:	50                   	push   %eax
80102ee3:	e8 20 19 00 00       	call   80104808 <initlock>
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
80102f6c:	e8 df 19 00 00       	call   80104950 <acquire>
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
80102f8e:	e8 52 10 00 00       	call   80103fe5 <wakeup>
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
80102fac:	e8 06 1a 00 00       	call   801049b7 <release>
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
80102fcd:	e8 13 10 00 00       	call   80103fe5 <wakeup>
80102fd2:	83 c4 10             	add    $0x10,%esp
80102fd5:	eb bf                	jmp    80102f96 <pipeclose+0x35>
    release(&p->lock);
80102fd7:	83 ec 0c             	sub    $0xc,%esp
80102fda:	53                   	push   %ebx
80102fdb:	e8 d7 19 00 00       	call   801049b7 <release>
    kfree((char*)p);
80102fe0:	89 1c 24             	mov    %ebx,(%esp)
80102fe3:	e8 d8 f0 ff ff       	call   801020c0 <kfree>
80102fe8:	83 c4 10             	add    $0x10,%esp
80102feb:	eb c7                	jmp    80102fb4 <pipeclose+0x53>

80102fed <pipewrite>:

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
80103000:	e8 4b 19 00 00       	call   80104950 <acquire>
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
80103045:	e8 37 05 00 00       	call   80103581 <myproc>
8010304a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010304e:	75 36                	jne    80103086 <pipewrite+0x99>
      wakeup(&p->nread);
80103050:	83 ec 0c             	sub    $0xc,%esp
80103053:	57                   	push   %edi
80103054:	e8 8c 0f 00 00       	call   80103fe5 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103059:	83 c4 08             	add    $0x8,%esp
8010305c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010305f:	56                   	push   %esi
80103060:	e8 8d 0c 00 00       	call   80103cf2 <sleep>
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
8010308a:	e8 28 19 00 00       	call   801049b7 <release>
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
801030d1:	e8 0f 0f 00 00       	call   80103fe5 <wakeup>
  release(&p->lock);
801030d6:	89 1c 24             	mov    %ebx,(%esp)
801030d9:	e8 d9 18 00 00       	call   801049b7 <release>
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
801030f3:	e8 58 18 00 00       	call   80104950 <acquire>
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
8010311a:	e8 62 04 00 00       	call   80103581 <myproc>
8010311f:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80103123:	75 4d                	jne    80103172 <piperead+0x8c>
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103125:	83 ec 08             	sub    $0x8,%esp
80103128:	56                   	push   %esi
80103129:	57                   	push   %edi
8010312a:	e8 c3 0b 00 00       	call   80103cf2 <sleep>
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
80103158:	e8 88 0e 00 00       	call   80103fe5 <wakeup>
  release(&p->lock);
8010315d:	89 1c 24             	mov    %ebx,(%esp)
80103160:	e8 52 18 00 00       	call   801049b7 <release>
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
80103176:	e8 3c 18 00 00       	call   801049b7 <release>
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
801032c1:	ff 34 95 a0 7a 10 80 	pushl  -0x7fef8560(,%edx,4)
801032c8:	ff 34 85 a0 7a 10 80 	pushl  -0x7fef8560(,%eax,4)
801032cf:	68 f8 77 10 80       	push   $0x801077f8
801032d4:	e8 08 d3 ff ff       	call   801005e1 <cprintf>
    panic ("No Match");  
801032d9:	c7 04 24 cf 78 10 80 	movl   $0x801078cf,(%esp)
801032e0:	e8 5f d0 ff ff       	call   80100344 <panic>

801032e5 <allocproc>:

// New implementation of allocproc to work with the new list
#ifdef CS333_P3
static struct proc*
allocproc(void)
{
801032e5:	55                   	push   %ebp
801032e6:	89 e5                	mov    %esp,%ebp
801032e8:	53                   	push   %ebx
801032e9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801032ec:	68 e0 a5 10 80       	push   $0x8010a5e0
801032f1:	e8 5a 16 00 00       	call   80104950 <acquire>
  int found = 0;
  
  p = ptable.list[UNUSED].head;
801032f6:	8b 1d 14 cb 10 80    	mov    0x8010cb14,%ebx

  if(p)
801032fc:	83 c4 10             	add    $0x10,%esp
801032ff:	85 db                	test   %ebx,%ebx
80103301:	0f 84 a5 00 00 00    	je     801033ac <allocproc+0xc7>
  if (!found) {
    release(&ptable.lock);
    return 0;
  }

  int rc = stateListRemove(&ptable.list[UNUSED], p);
80103307:	89 da                	mov    %ebx,%edx
80103309:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
8010330e:	e8 f5 fe ff ff       	call   80103208 <stateListRemove>
  if (rc == -1)
80103313:	83 f8 ff             	cmp    $0xffffffff,%eax
80103316:	0f 84 a2 00 00 00    	je     801033be <allocproc+0xd9>
    panic("ERROR. Allocproc removal failed\n");
  assertState(p, UNUSED);
8010331c:	ba 00 00 00 00       	mov    $0x0,%edx
80103321:	89 d8                	mov    %ebx,%eax
80103323:	e8 8a ff ff ff       	call   801032b2 <assertState>
  p->state = EMBRYO;
80103328:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  stateListAdd(&ptable.list[EMBRYO], p);
8010332f:	89 da                	mov    %ebx,%edx
80103331:	b8 1c cb 10 80       	mov    $0x8010cb1c,%eax
80103336:	e8 93 fe ff ff       	call   801031ce <stateListAdd>
  p->pid = nextpid++;
8010333b:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103340:	8d 50 01             	lea    0x1(%eax),%edx
80103343:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80103349:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010334c:	83 ec 0c             	sub    $0xc,%esp
8010334f:	68 e0 a5 10 80       	push   $0x8010a5e0
80103354:	e8 5e 16 00 00       	call   801049b7 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0)
80103359:	e8 87 ee ff ff       	call   801021e5 <kalloc>
8010335e:	89 43 08             	mov    %eax,0x8(%ebx)
80103361:	83 c4 10             	add    $0x10,%esp
80103364:	85 c0                	test   %eax,%eax
80103366:	74 63                	je     801033cb <allocproc+0xe6>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103368:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
8010336e:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103371:	c7 80 b0 0f 00 00 f6 	movl   $0x80105bf6,0xfb0(%eax)
80103378:	5b 10 80 

  sp -= sizeof *p->context;
8010337b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80103380:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103383:	83 ec 04             	sub    $0x4,%esp
80103386:	6a 14                	push   $0x14
80103388:	6a 00                	push   $0x0
8010338a:	50                   	push   %eax
8010338b:	e8 6e 16 00 00       	call   801049fe <memset>
  p->context->eip = (uint)forkret;
80103390:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103393:	c7 40 10 92 34 10 80 	movl   $0x80103492,0x10(%eax)

  #ifdef CS333_P1
  p -> start_ticks = ticks;
8010339a:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
8010339f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  #ifdef CS333_p2
  p -> cpu_ticks_in = 0;
  p -> cpu_ticks_total = 0;
  #endif

  return p; 
801033a2:	83 c4 10             	add    $0x10,%esp
}
801033a5:	89 d8                	mov    %ebx,%eax
801033a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033aa:	c9                   	leave  
801033ab:	c3                   	ret    
    release(&ptable.lock);
801033ac:	83 ec 0c             	sub    $0xc,%esp
801033af:	68 e0 a5 10 80       	push   $0x8010a5e0
801033b4:	e8 fe 15 00 00       	call   801049b7 <release>
    return 0;
801033b9:	83 c4 10             	add    $0x10,%esp
801033bc:	eb e7                	jmp    801033a5 <allocproc+0xc0>
    panic("ERROR. Allocproc removal failed\n");
801033be:	83 ec 0c             	sub    $0xc,%esp
801033c1:	68 1c 78 10 80       	push   $0x8010781c
801033c6:	e8 79 cf ff ff       	call   80100344 <panic>
    acquire(&ptable.lock);
801033cb:	83 ec 0c             	sub    $0xc,%esp
801033ce:	68 e0 a5 10 80       	push   $0x8010a5e0
801033d3:	e8 78 15 00 00       	call   80104950 <acquire>
    stateListRemove(&ptable.list[EMBRYO], p);
801033d8:	89 da                	mov    %ebx,%edx
801033da:	b8 1c cb 10 80       	mov    $0x8010cb1c,%eax
801033df:	e8 24 fe ff ff       	call   80103208 <stateListRemove>
    assertState(p, EMBRYO);
801033e4:	ba 01 00 00 00       	mov    $0x1,%edx
801033e9:	89 d8                	mov    %ebx,%eax
801033eb:	e8 c2 fe ff ff       	call   801032b2 <assertState>
    p->state = UNUSED;
801033f0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    stateListAdd(&ptable.list[UNUSED], p);
801033f7:	89 da                	mov    %ebx,%edx
801033f9:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
801033fe:	e8 cb fd ff ff       	call   801031ce <stateListAdd>
    release(&ptable.lock);
80103403:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
8010340a:	e8 a8 15 00 00       	call   801049b7 <release>
    return 0;
8010340f:	83 c4 10             	add    $0x10,%esp
80103412:	bb 00 00 00 00       	mov    $0x0,%ebx
80103417:	eb 8c                	jmp    801033a5 <allocproc+0xc0>

80103419 <wakeup1>:

#ifdef CS333_P3
// New implementation of wakeup1
static void
wakeup1(void *chan)
{
80103419:	55                   	push   %ebp
8010341a:	89 e5                	mov    %esp,%ebp
8010341c:	57                   	push   %edi
8010341d:	56                   	push   %esi
8010341e:	53                   	push   %ebx
8010341f:	83 ec 0c             	sub    $0xc,%esp
80103422:	89 c6                	mov    %eax,%esi
  struct proc *p;
  struct proc *current = ptable.list[SLEEPING].head;
80103424:	8b 1d 24 cb 10 80    	mov    0x8010cb24,%ebx

  while(current)
8010342a:	85 db                	test   %ebx,%ebx
8010342c:	75 1f                	jne    8010344d <wakeup1+0x34>
      current = p;
     }
   else
     current = current -> next;
  }
}
8010342e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103431:	5b                   	pop    %ebx
80103432:	5e                   	pop    %esi
80103433:	5f                   	pop    %edi
80103434:	5d                   	pop    %ebp
80103435:	c3                   	ret    
        panic("Wake up 1 error.");
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	68 d8 78 10 80       	push   $0x801078d8
8010343e:	e8 01 cf ff ff       	call   80100344 <panic>
     current = current -> next;
80103443:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
  while(current)
80103449:	85 db                	test   %ebx,%ebx
8010344b:	74 e1                	je     8010342e <wakeup1+0x15>
    if(current -> chan == chan && current -> state == SLEEPING)
8010344d:	39 73 20             	cmp    %esi,0x20(%ebx)
80103450:	75 f1                	jne    80103443 <wakeup1+0x2a>
80103452:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103456:	75 eb                	jne    80103443 <wakeup1+0x2a>
      p = current -> next;
80103458:	8b bb 90 00 00 00    	mov    0x90(%ebx),%edi
      int rc = stateListRemove(&ptable.list[SLEEPING], current);
8010345e:	89 da                	mov    %ebx,%edx
80103460:	b8 24 cb 10 80       	mov    $0x8010cb24,%eax
80103465:	e8 9e fd ff ff       	call   80103208 <stateListRemove>
      if(rc == -1)
8010346a:	83 f8 ff             	cmp    $0xffffffff,%eax
8010346d:	74 c7                	je     80103436 <wakeup1+0x1d>
      assertState(current, SLEEPING);
8010346f:	ba 02 00 00 00       	mov    $0x2,%edx
80103474:	89 d8                	mov    %ebx,%eax
80103476:	e8 37 fe ff ff       	call   801032b2 <assertState>
      current->state = RUNNABLE;
8010347b:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      stateListAdd(&ptable.list[RUNNABLE], current);
80103482:	89 da                	mov    %ebx,%edx
80103484:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
80103489:	e8 40 fd ff ff       	call   801031ce <stateListAdd>
      current = p;
8010348e:	89 fb                	mov    %edi,%ebx
    {
80103490:	eb b7                	jmp    80103449 <wakeup1+0x30>

80103492 <forkret>:
{
80103492:	55                   	push   %ebp
80103493:	89 e5                	mov    %esp,%ebp
80103495:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103498:	68 e0 a5 10 80       	push   $0x8010a5e0
8010349d:	e8 15 15 00 00       	call   801049b7 <release>
  if (first) {
801034a2:	83 c4 10             	add    $0x10,%esp
801034a5:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
801034ac:	75 02                	jne    801034b0 <forkret+0x1e>
}
801034ae:	c9                   	leave  
801034af:	c3                   	ret    
    first = 0;
801034b0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801034b7:	00 00 00 
    iinit(ROOTDEV);
801034ba:	83 ec 0c             	sub    $0xc,%esp
801034bd:	6a 01                	push   $0x1
801034bf:	e8 c9 de ff ff       	call   8010138d <iinit>
    initlog(ROOTDEV);
801034c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801034cb:	e8 cf f2 ff ff       	call   8010279f <initlog>
801034d0:	83 c4 10             	add    $0x10,%esp
}
801034d3:	eb d9                	jmp    801034ae <forkret+0x1c>

801034d5 <pinit>:
{
801034d5:	55                   	push   %ebp
801034d6:	89 e5                	mov    %esp,%ebp
801034d8:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801034db:	68 e9 78 10 80       	push   $0x801078e9
801034e0:	68 e0 a5 10 80       	push   $0x8010a5e0
801034e5:	e8 1e 13 00 00       	call   80104808 <initlock>
}
801034ea:	83 c4 10             	add    $0x10,%esp
801034ed:	c9                   	leave  
801034ee:	c3                   	ret    

801034ef <mycpu>:
{
801034ef:	55                   	push   %ebp
801034f0:	89 e5                	mov    %esp,%ebp
801034f2:	56                   	push   %esi
801034f3:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801034f4:	9c                   	pushf  
801034f5:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801034f6:	f6 c4 02             	test   $0x2,%ah
801034f9:	75 4a                	jne    80103545 <mycpu+0x56>
  apicid = lapicid();
801034fb:	e8 c7 ef ff ff       	call   801024c7 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103500:	8b 35 a0 52 11 80    	mov    0x801152a0,%esi
80103506:	85 f6                	test   %esi,%esi
80103508:	7e 4f                	jle    80103559 <mycpu+0x6a>
    if (cpus[i].apicid == apicid) {
8010350a:	0f b6 15 20 4d 11 80 	movzbl 0x80114d20,%edx
80103511:	39 d0                	cmp    %edx,%eax
80103513:	74 3d                	je     80103552 <mycpu+0x63>
80103515:	b9 d0 4d 11 80       	mov    $0x80114dd0,%ecx
  for (i = 0; i < ncpu; ++i) {
8010351a:	ba 00 00 00 00       	mov    $0x0,%edx
8010351f:	83 c2 01             	add    $0x1,%edx
80103522:	39 f2                	cmp    %esi,%edx
80103524:	74 33                	je     80103559 <mycpu+0x6a>
    if (cpus[i].apicid == apicid) {
80103526:	0f b6 19             	movzbl (%ecx),%ebx
80103529:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
8010352f:	39 c3                	cmp    %eax,%ebx
80103531:	75 ec                	jne    8010351f <mycpu+0x30>
      return &cpus[i];
80103533:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103539:	05 20 4d 11 80       	add    $0x80114d20,%eax
}
8010353e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103541:	5b                   	pop    %ebx
80103542:	5e                   	pop    %esi
80103543:	5d                   	pop    %ebp
80103544:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
80103545:	83 ec 0c             	sub    $0xc,%esp
80103548:	68 40 78 10 80       	push   $0x80107840
8010354d:	e8 f2 cd ff ff       	call   80100344 <panic>
  for (i = 0; i < ncpu; ++i) {
80103552:	ba 00 00 00 00       	mov    $0x0,%edx
80103557:	eb da                	jmp    80103533 <mycpu+0x44>
  panic("unknown apicid\n");
80103559:	83 ec 0c             	sub    $0xc,%esp
8010355c:	68 f0 78 10 80       	push   $0x801078f0
80103561:	e8 de cd ff ff       	call   80100344 <panic>

80103566 <cpuid>:
cpuid() {
80103566:	55                   	push   %ebp
80103567:	89 e5                	mov    %esp,%ebp
80103569:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010356c:	e8 7e ff ff ff       	call   801034ef <mycpu>
80103571:	2d 20 4d 11 80       	sub    $0x80114d20,%eax
80103576:	c1 f8 04             	sar    $0x4,%eax
80103579:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010357f:	c9                   	leave  
80103580:	c3                   	ret    

80103581 <myproc>:
myproc(void) {
80103581:	55                   	push   %ebp
80103582:	89 e5                	mov    %esp,%ebp
80103584:	53                   	push   %ebx
80103585:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103588:	e8 f2 12 00 00       	call   8010487f <pushcli>
  c = mycpu();
8010358d:	e8 5d ff ff ff       	call   801034ef <mycpu>
  p = c->proc;
80103592:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103598:	e8 1f 13 00 00       	call   801048bc <popcli>
}
8010359d:	89 d8                	mov    %ebx,%eax
8010359f:	83 c4 04             	add    $0x4,%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5d                   	pop    %ebp
801035a4:	c3                   	ret    

801035a5 <userinit>:
{
801035a5:	55                   	push   %ebp
801035a6:	89 e5                	mov    %esp,%ebp
801035a8:	53                   	push   %ebx
801035a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801035ac:	68 e0 a5 10 80       	push   $0x8010a5e0
801035b1:	e8 9a 13 00 00       	call   80104950 <acquire>
801035b6:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
801035bb:	ba 44 cb 10 80       	mov    $0x8010cb44,%edx
801035c0:	83 c4 10             	add    $0x10,%esp
    ptable.list[i].head = NULL;
801035c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    ptable.list[i].tail = NULL;
801035c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
801035d0:	83 c0 08             	add    $0x8,%eax
  for (i = UNUSED; i <= ZOMBIE; i++) {
801035d3:	39 d0                	cmp    %edx,%eax
801035d5:	75 ec                	jne    801035c3 <userinit+0x1e>
  for(p = ptable.proc; p < ptable.proc + NPROC; ++p){
801035d7:	bb 14 a6 10 80       	mov    $0x8010a614,%ebx
    p->state = UNUSED;
801035dc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    stateListAdd(&ptable.list[UNUSED], p);
801035e3:	89 da                	mov    %ebx,%edx
801035e5:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
801035ea:	e8 df fb ff ff       	call   801031ce <stateListAdd>
  for(p = ptable.proc; p < ptable.proc + NPROC; ++p){
801035ef:	81 c3 94 00 00 00    	add    $0x94,%ebx
801035f5:	81 fb 14 cb 10 80    	cmp    $0x8010cb14,%ebx
801035fb:	72 df                	jb     801035dc <userinit+0x37>
  release(&ptable.lock);
801035fd:	83 ec 0c             	sub    $0xc,%esp
80103600:	68 e0 a5 10 80       	push   $0x8010a5e0
80103605:	e8 ad 13 00 00       	call   801049b7 <release>
  p = allocproc();
8010360a:	e8 d6 fc ff ff       	call   801032e5 <allocproc>
8010360f:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103611:	a3 c0 a5 10 80       	mov    %eax,0x8010a5c0
  if((p->pgdir = setupkvm()) == 0)
80103616:	e8 37 3a 00 00       	call   80107052 <setupkvm>
8010361b:	89 43 04             	mov    %eax,0x4(%ebx)
8010361e:	83 c4 10             	add    $0x10,%esp
80103621:	85 c0                	test   %eax,%eax
80103623:	0f 84 f4 00 00 00    	je     8010371d <userinit+0x178>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103629:	83 ec 04             	sub    $0x4,%esp
8010362c:	68 2c 00 00 00       	push   $0x2c
80103631:	68 60 a4 10 80       	push   $0x8010a460
80103636:	50                   	push   %eax
80103637:	e8 0f 37 00 00       	call   80106d4b <inituvm>
  p->sz = PGSIZE;
8010363c:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103642:	83 c4 0c             	add    $0xc,%esp
80103645:	6a 4c                	push   $0x4c
80103647:	6a 00                	push   $0x0
80103649:	ff 73 18             	pushl  0x18(%ebx)
8010364c:	e8 ad 13 00 00       	call   801049fe <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103651:	8b 43 18             	mov    0x18(%ebx),%eax
80103654:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010365a:	8b 43 18             	mov    0x18(%ebx),%eax
8010365d:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103663:	8b 43 18             	mov    0x18(%ebx),%eax
80103666:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010366a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010366e:	8b 43 18             	mov    0x18(%ebx),%eax
80103671:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103675:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103679:	8b 43 18             	mov    0x18(%ebx),%eax
8010367c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103683:	8b 43 18             	mov    0x18(%ebx),%eax
80103686:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010368d:	8b 43 18             	mov    0x18(%ebx),%eax
80103690:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103697:	83 c4 0c             	add    $0xc,%esp
8010369a:	6a 10                	push   $0x10
8010369c:	68 19 79 10 80       	push   $0x80107919
801036a1:	8d 43 6c             	lea    0x6c(%ebx),%eax
801036a4:	50                   	push   %eax
801036a5:	e8 e3 14 00 00       	call   80104b8d <safestrcpy>
  p->cwd = namei("/");
801036aa:	c7 04 24 22 79 10 80 	movl   $0x80107922,(%esp)
801036b1:	e8 54 e6 ff ff       	call   80101d0a <namei>
801036b6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801036b9:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
801036c0:	e8 8b 12 00 00       	call   80104950 <acquire>
  stateListRemove(&ptable.list[p->state], p);
801036c5:	8b 43 0c             	mov    0xc(%ebx),%eax
801036c8:	8d 04 c5 14 cb 10 80 	lea    -0x7fef34ec(,%eax,8),%eax
801036cf:	89 da                	mov    %ebx,%edx
801036d1:	e8 32 fb ff ff       	call   80103208 <stateListRemove>
  assertState(p, EMBRYO);
801036d6:	ba 01 00 00 00       	mov    $0x1,%edx
801036db:	89 d8                	mov    %ebx,%eax
801036dd:	e8 d0 fb ff ff       	call   801032b2 <assertState>
  p->state = RUNNABLE;
801036e2:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  stateListAdd(&ptable.list[p->state], p);
801036e9:	89 da                	mov    %ebx,%edx
801036eb:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
801036f0:	e8 d9 fa ff ff       	call   801031ce <stateListAdd>
  release(&ptable.lock);
801036f5:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
801036fc:	e8 b6 12 00 00       	call   801049b7 <release>
  p->uid = UID; //setting to default
80103701:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103708:	00 00 00 
  p->gid = GID; //setting to default
8010370b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103712:	00 00 00 
}
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010371b:	c9                   	leave  
8010371c:	c3                   	ret    
    panic("userinit: out of memory?");
8010371d:	83 ec 0c             	sub    $0xc,%esp
80103720:	68 00 79 10 80       	push   $0x80107900
80103725:	e8 1a cc ff ff       	call   80100344 <panic>

8010372a <traverse>:
{
8010372a:	55                   	push   %ebp
8010372b:	89 e5                	mov    %esp,%ebp
8010372d:	57                   	push   %edi
8010372e:	56                   	push   %esi
8010372f:	53                   	push   %ebx
80103730:	83 ec 1c             	sub    $0x1c,%esp
80103733:	8b 75 08             	mov    0x8(%ebp),%esi
  if(state == 3) //runnable processes
80103736:	83 fe 03             	cmp    $0x3,%esi
80103739:	74 25                	je     80103760 <traverse+0x36>
  if(state == 2) //sleeping processes
8010373b:	83 fe 02             	cmp    $0x2,%esi
8010373e:	74 32                	je     80103772 <traverse+0x48>
  if(state == 5) //zombie processes
80103740:	83 fe 05             	cmp    $0x5,%esi
80103743:	74 3f                	je     80103784 <traverse+0x5a>
  struct proc * current = ptable.list[state].head;
80103745:	8b 1c f5 14 cb 10 80 	mov    -0x7fef34ec(,%esi,8),%ebx
  while(current)
8010374c:	85 db                	test   %ebx,%ebx
8010374e:	0f 84 a4 00 00 00    	je     801037f8 <traverse+0xce>
{
80103754:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if(state == 2 || state == 3) //runnable or sleeping
8010375b:	8d 7e fe             	lea    -0x2(%esi),%edi
8010375e:	eb 65                	jmp    801037c5 <traverse+0x9b>
    cprintf("\nReady List Processes:\n");
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	68 24 79 10 80       	push   $0x80107924
80103768:	e8 74 ce ff ff       	call   801005e1 <cprintf>
8010376d:	83 c4 10             	add    $0x10,%esp
80103770:	eb d3                	jmp    80103745 <traverse+0x1b>
    cprintf("\nSleep List Processes:\n");
80103772:	83 ec 0c             	sub    $0xc,%esp
80103775:	68 3c 79 10 80       	push   $0x8010793c
8010377a:	e8 62 ce ff ff       	call   801005e1 <cprintf>
8010377f:	83 c4 10             	add    $0x10,%esp
80103782:	eb c1                	jmp    80103745 <traverse+0x1b>
    cprintf("\nZombie List Processes:\n");
80103784:	83 ec 0c             	sub    $0xc,%esp
80103787:	68 54 79 10 80       	push   $0x80107954
8010378c:	e8 50 ce ff ff       	call   801005e1 <cprintf>
  struct proc * current = ptable.list[state].head;
80103791:	8b 1c f5 14 cb 10 80 	mov    -0x7fef34ec(,%esi,8),%ebx
  while(current)
80103798:	83 c4 10             	add    $0x10,%esp
8010379b:	85 db                	test   %ebx,%ebx
8010379d:	75 b5                	jne    80103754 <traverse+0x2a>
8010379f:	eb 62                	jmp    80103803 <traverse+0xd9>
      cprintf("%d -> ", current -> pid);  
801037a1:	83 ec 08             	sub    $0x8,%esp
801037a4:	ff 73 10             	pushl  0x10(%ebx)
801037a7:	68 6d 79 10 80       	push   $0x8010796d
801037ac:	e8 30 ce ff ff       	call   801005e1 <cprintf>
      current = current -> next;
801037b1:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
801037b7:	83 c4 10             	add    $0x10,%esp
801037ba:	eb 05                	jmp    801037c1 <traverse+0x97>
    else if(state == 5) //zombie 
801037bc:	83 fe 05             	cmp    $0x5,%esi
801037bf:	74 19                	je     801037da <traverse+0xb0>
  while(current)
801037c1:	85 db                	test   %ebx,%ebx
801037c3:	74 3a                	je     801037ff <traverse+0xd5>
    if(state == 2 || state == 3) //runnable or sleeping
801037c5:	83 ff 01             	cmp    $0x1,%edi
801037c8:	76 d7                	jbe    801037a1 <traverse+0x77>
    else if(state == 0) //unused 
801037ca:	85 f6                	test   %esi,%esi
801037cc:	75 ee                	jne    801037bc <traverse+0x92>
      current = current -> next;
801037ce:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
      ++ucount; //count number of unused processes
801037d4:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801037d8:	eb e7                	jmp    801037c1 <traverse+0x97>
      cprintf("(%d, %d) -> ", current -> pid, current -> parent);
801037da:	83 ec 04             	sub    $0x4,%esp
801037dd:	ff 73 14             	pushl  0x14(%ebx)
801037e0:	ff 73 10             	pushl  0x10(%ebx)
801037e3:	68 74 79 10 80       	push   $0x80107974
801037e8:	e8 f4 cd ff ff       	call   801005e1 <cprintf>
      current = current -> next;
801037ed:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
801037f3:	83 c4 10             	add    $0x10,%esp
801037f6:	eb c9                	jmp    801037c1 <traverse+0x97>
  int ucount = 0;
801037f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  if(state == 0)
801037ff:	85 f6                	test   %esi,%esi
80103801:	74 0d                	je     80103810 <traverse+0xe6>
}
80103803:	b8 00 00 00 00       	mov    $0x0,%eax
80103808:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010380b:	5b                   	pop    %ebx
8010380c:	5e                   	pop    %esi
8010380d:	5f                   	pop    %edi
8010380e:	5d                   	pop    %ebp
8010380f:	c3                   	ret    
    cprintf("Free List Size: %d\n", ucount);
80103810:	83 ec 08             	sub    $0x8,%esp
80103813:	ff 75 e4             	pushl  -0x1c(%ebp)
80103816:	68 81 79 10 80       	push   $0x80107981
8010381b:	e8 c1 cd ff ff       	call   801005e1 <cprintf>
80103820:	83 c4 10             	add    $0x10,%esp
80103823:	eb de                	jmp    80103803 <traverse+0xd9>

80103825 <growproc>:
{
80103825:	55                   	push   %ebp
80103826:	89 e5                	mov    %esp,%ebp
80103828:	56                   	push   %esi
80103829:	53                   	push   %ebx
8010382a:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010382d:	e8 4f fd ff ff       	call   80103581 <myproc>
80103832:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103834:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103836:	85 f6                	test   %esi,%esi
80103838:	7f 21                	jg     8010385b <growproc+0x36>
  } else if(n < 0){
8010383a:	85 f6                	test   %esi,%esi
8010383c:	79 33                	jns    80103871 <growproc+0x4c>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010383e:	83 ec 04             	sub    $0x4,%esp
80103841:	01 c6                	add    %eax,%esi
80103843:	56                   	push   %esi
80103844:	50                   	push   %eax
80103845:	ff 73 04             	pushl  0x4(%ebx)
80103848:	e8 15 36 00 00       	call   80106e62 <deallocuvm>
8010384d:	83 c4 10             	add    $0x10,%esp
80103850:	85 c0                	test   %eax,%eax
80103852:	75 1d                	jne    80103871 <growproc+0x4c>
      return -1;
80103854:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103859:	eb 29                	jmp    80103884 <growproc+0x5f>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010385b:	83 ec 04             	sub    $0x4,%esp
8010385e:	01 c6                	add    %eax,%esi
80103860:	56                   	push   %esi
80103861:	50                   	push   %eax
80103862:	ff 73 04             	pushl  0x4(%ebx)
80103865:	e8 87 36 00 00       	call   80106ef1 <allocuvm>
8010386a:	83 c4 10             	add    $0x10,%esp
8010386d:	85 c0                	test   %eax,%eax
8010386f:	74 1a                	je     8010388b <growproc+0x66>
  curproc->sz = sz;
80103871:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103873:	83 ec 0c             	sub    $0xc,%esp
80103876:	53                   	push   %ebx
80103877:	e8 d1 33 00 00       	call   80106c4d <switchuvm>
  return 0;
8010387c:	83 c4 10             	add    $0x10,%esp
8010387f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103884:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103887:	5b                   	pop    %ebx
80103888:	5e                   	pop    %esi
80103889:	5d                   	pop    %ebp
8010388a:	c3                   	ret    
      return -1;
8010388b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103890:	eb f2                	jmp    80103884 <growproc+0x5f>

80103892 <fork>:
{
80103892:	55                   	push   %ebp
80103893:	89 e5                	mov    %esp,%ebp
80103895:	57                   	push   %edi
80103896:	56                   	push   %esi
80103897:	53                   	push   %ebx
80103898:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
8010389b:	e8 e1 fc ff ff       	call   80103581 <myproc>
801038a0:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801038a2:	e8 3e fa ff ff       	call   801032e5 <allocproc>
801038a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038aa:	85 c0                	test   %eax,%eax
801038ac:	0f 84 41 01 00 00    	je     801039f3 <fork+0x161>
801038b2:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038b4:	83 ec 08             	sub    $0x8,%esp
801038b7:	ff 33                	pushl  (%ebx)
801038b9:	ff 73 04             	pushl  0x4(%ebx)
801038bc:	e8 42 38 00 00       	call   80107103 <copyuvm>
801038c1:	89 47 04             	mov    %eax,0x4(%edi)
801038c4:	83 c4 10             	add    $0x10,%esp
801038c7:	85 c0                	test   %eax,%eax
801038c9:	74 28                	je     801038f3 <fork+0x61>
  np->sz = curproc->sz;
801038cb:	8b 03                	mov    (%ebx),%eax
801038cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038d0:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
801038d2:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801038d5:	8b 73 18             	mov    0x18(%ebx),%esi
801038d8:	8b 7a 18             	mov    0x18(%edx),%edi
801038db:	b9 13 00 00 00       	mov    $0x13,%ecx
801038e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
801038e2:	8b 42 18             	mov    0x18(%edx),%eax
801038e5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801038ec:	be 00 00 00 00       	mov    $0x0,%esi
801038f1:	eb 6d                	jmp    80103960 <fork+0xce>
    kfree(np->kstack);
801038f3:	83 ec 0c             	sub    $0xc,%esp
801038f6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801038f9:	ff 73 08             	pushl  0x8(%ebx)
801038fc:	e8 bf e7 ff ff       	call   801020c0 <kfree>
    np->kstack = 0;
80103901:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    acquire(&ptable.lock);
80103908:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
8010390f:	e8 3c 10 00 00       	call   80104950 <acquire>
    stateListRemove(&ptable.list[EMBRYO], np);
80103914:	89 da                	mov    %ebx,%edx
80103916:	b8 1c cb 10 80       	mov    $0x8010cb1c,%eax
8010391b:	e8 e8 f8 ff ff       	call   80103208 <stateListRemove>
    assertState(np, EMBRYO);
80103920:	ba 01 00 00 00       	mov    $0x1,%edx
80103925:	89 d8                	mov    %ebx,%eax
80103927:	e8 86 f9 ff ff       	call   801032b2 <assertState>
    np->state = UNUSED;
8010392c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    stateListAdd(&ptable.list[UNUSED], np);
80103933:	89 da                	mov    %ebx,%edx
80103935:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
8010393a:	e8 8f f8 ff ff       	call   801031ce <stateListAdd>
    release(&ptable.lock);
8010393f:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103946:	e8 6c 10 00 00       	call   801049b7 <release>
    return -1;
8010394b:	83 c4 10             	add    $0x10,%esp
8010394e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103953:	e9 93 00 00 00       	jmp    801039eb <fork+0x159>
  for(i = 0; i < NOFILE; i++)
80103958:	83 c6 01             	add    $0x1,%esi
8010395b:	83 fe 10             	cmp    $0x10,%esi
8010395e:	74 1d                	je     8010397d <fork+0xeb>
    if(curproc->ofile[i])
80103960:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103964:	85 c0                	test   %eax,%eax
80103966:	74 f0                	je     80103958 <fork+0xc6>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103968:	83 ec 0c             	sub    $0xc,%esp
8010396b:	50                   	push   %eax
8010396c:	e8 eb d3 ff ff       	call   80100d5c <filedup>
80103971:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103974:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
80103978:	83 c4 10             	add    $0x10,%esp
8010397b:	eb db                	jmp    80103958 <fork+0xc6>
  np->cwd = idup(curproc->cwd);
8010397d:	83 ec 0c             	sub    $0xc,%esp
80103980:	ff 73 68             	pushl  0x68(%ebx)
80103983:	e8 ba db ff ff       	call   80101542 <idup>
80103988:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010398b:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010398e:	83 c4 0c             	add    $0xc,%esp
80103991:	6a 10                	push   $0x10
80103993:	83 c3 6c             	add    $0x6c,%ebx
80103996:	53                   	push   %ebx
80103997:	8d 47 6c             	lea    0x6c(%edi),%eax
8010399a:	50                   	push   %eax
8010399b:	e8 ed 11 00 00       	call   80104b8d <safestrcpy>
  pid = np->pid;
801039a0:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801039a3:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
801039aa:	e8 a1 0f 00 00       	call   80104950 <acquire>
  stateListRemove(&ptable.list[EMBRYO], np);
801039af:	89 fa                	mov    %edi,%edx
801039b1:	b8 1c cb 10 80       	mov    $0x8010cb1c,%eax
801039b6:	e8 4d f8 ff ff       	call   80103208 <stateListRemove>
  assertState(np, EMBRYO);
801039bb:	ba 01 00 00 00       	mov    $0x1,%edx
801039c0:	89 f8                	mov    %edi,%eax
801039c2:	e8 eb f8 ff ff       	call   801032b2 <assertState>
  np->state = RUNNABLE;
801039c7:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  stateListAdd(&ptable.list[RUNNABLE], np);
801039ce:	89 fa                	mov    %edi,%edx
801039d0:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
801039d5:	e8 f4 f7 ff ff       	call   801031ce <stateListAdd>
  release(&ptable.lock);
801039da:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
801039e1:	e8 d1 0f 00 00       	call   801049b7 <release>
  return pid;
801039e6:	89 d8                	mov    %ebx,%eax
801039e8:	83 c4 10             	add    $0x10,%esp
}
801039eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039ee:	5b                   	pop    %ebx
801039ef:	5e                   	pop    %esi
801039f0:	5f                   	pop    %edi
801039f1:	5d                   	pop    %ebp
801039f2:	c3                   	ret    
    return -1;
801039f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039f8:	eb f1                	jmp    801039eb <fork+0x159>

801039fa <scheduler>:
{
801039fa:	55                   	push   %ebp
801039fb:	89 e5                	mov    %esp,%ebp
801039fd:	57                   	push   %edi
801039fe:	56                   	push   %esi
801039ff:	53                   	push   %ebx
80103a00:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103a03:	e8 e7 fa ff ff       	call   801034ef <mycpu>
80103a08:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a0a:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a11:	00 00 00 
      swtch(&(c->scheduler), p->context);
80103a14:	8d 78 04             	lea    0x4(%eax),%edi
  asm volatile("sti");
80103a17:	fb                   	sti    
    acquire(&ptable.lock);
80103a18:	83 ec 0c             	sub    $0xc,%esp
80103a1b:	68 e0 a5 10 80       	push   $0x8010a5e0
80103a20:	e8 2b 0f 00 00       	call   80104950 <acquire>
    p = ptable.list[RUNNABLE].head;
80103a25:	8b 1d 2c cb 10 80    	mov    0x8010cb2c,%ebx
    if(p)
80103a2b:	83 c4 10             	add    $0x10,%esp
80103a2e:	85 db                	test   %ebx,%ebx
80103a30:	0f 84 89 00 00 00    	je     80103abf <scheduler+0xc5>
      c->proc = p;
80103a36:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a3c:	83 ec 0c             	sub    $0xc,%esp
80103a3f:	53                   	push   %ebx
80103a40:	e8 08 32 00 00       	call   80106c4d <switchuvm>
      int rc = stateListRemove(&ptable.list[RUNNABLE], p); //Removing process p from specific list
80103a45:	89 da                	mov    %ebx,%edx
80103a47:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
80103a4c:	e8 b7 f7 ff ff       	call   80103208 <stateListRemove>
      if(rc == -1)
80103a51:	83 c4 10             	add    $0x10,%esp
80103a54:	83 f8 ff             	cmp    $0xffffffff,%eax
80103a57:	75 0d                	jne    80103a66 <scheduler+0x6c>
        panic("The process wasn't removed from runnable state");  
80103a59:	83 ec 0c             	sub    $0xc,%esp
80103a5c:	68 68 78 10 80       	push   $0x80107868
80103a61:	e8 de c8 ff ff       	call   80100344 <panic>
      assertState(p, RUNNABLE); 
80103a66:	ba 03 00 00 00       	mov    $0x3,%edx
80103a6b:	89 d8                	mov    %ebx,%eax
80103a6d:	e8 40 f8 ff ff       	call   801032b2 <assertState>
      p->state = RUNNING;
80103a72:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      stateListAdd(&ptable.list[RUNNING], p);
80103a79:	89 da                	mov    %ebx,%edx
80103a7b:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103a80:	e8 49 f7 ff ff       	call   801031ce <stateListAdd>
      p->cpu_ticks_in = ticks;
80103a85:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80103a8a:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
      swtch(&(c->scheduler), p->context);
80103a90:	83 ec 08             	sub    $0x8,%esp
80103a93:	ff 73 1c             	pushl  0x1c(%ebx)
80103a96:	57                   	push   %edi
80103a97:	e8 47 11 00 00       	call   80104be3 <swtch>
      switchkvm();
80103a9c:	e8 9a 31 00 00       	call   80106c3b <switchkvm>
      c->proc = 0;
80103aa1:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103aa8:	00 00 00 
    release(&ptable.lock);
80103aab:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103ab2:	e8 00 0f 00 00       	call   801049b7 <release>
80103ab7:	83 c4 10             	add    $0x10,%esp
80103aba:	e9 58 ff ff ff       	jmp    80103a17 <scheduler+0x1d>
80103abf:	83 ec 0c             	sub    $0xc,%esp
80103ac2:	68 e0 a5 10 80       	push   $0x8010a5e0
80103ac7:	e8 eb 0e 00 00       	call   801049b7 <release>
80103acc:	fb                   	sti    

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
  asm volatile("hlt");
80103acd:	f4                   	hlt    
80103ace:	83 c4 10             	add    $0x10,%esp
80103ad1:	e9 41 ff ff ff       	jmp    80103a17 <scheduler+0x1d>

80103ad6 <sched>:
{
80103ad6:	55                   	push   %ebp
80103ad7:	89 e5                	mov    %esp,%ebp
80103ad9:	56                   	push   %esi
80103ada:	53                   	push   %ebx
  struct proc *p = myproc();
80103adb:	e8 a1 fa ff ff       	call   80103581 <myproc>
80103ae0:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103ae2:	83 ec 0c             	sub    $0xc,%esp
80103ae5:	68 e0 a5 10 80       	push   $0x8010a5e0
80103aea:	e8 2d 0e 00 00       	call   8010491c <holding>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	74 66                	je     80103b5c <sched+0x86>
  if(mycpu()->ncli != 1)
80103af6:	e8 f4 f9 ff ff       	call   801034ef <mycpu>
80103afb:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b02:	75 65                	jne    80103b69 <sched+0x93>
  if(p->state == RUNNING)
80103b04:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b08:	74 6c                	je     80103b76 <sched+0xa0>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b0a:	9c                   	pushf  
80103b0b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b0c:	f6 c4 02             	test   $0x2,%ah
80103b0f:	75 72                	jne    80103b83 <sched+0xad>
  intena = mycpu()->intena;
80103b11:	e8 d9 f9 ff ff       	call   801034ef <mycpu>
80103b16:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  p->cpu_ticks_total += ticks - p->cpu_ticks_in; //instance of ticks end - tick start
80103b1c:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80103b21:	03 83 88 00 00 00    	add    0x88(%ebx),%eax
80103b27:	2b 83 8c 00 00 00    	sub    0x8c(%ebx),%eax
80103b2d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  swtch(&p->context, mycpu()->scheduler);
80103b33:	e8 b7 f9 ff ff       	call   801034ef <mycpu>
80103b38:	83 ec 08             	sub    $0x8,%esp
80103b3b:	ff 70 04             	pushl  0x4(%eax)
80103b3e:	83 c3 1c             	add    $0x1c,%ebx
80103b41:	53                   	push   %ebx
80103b42:	e8 9c 10 00 00       	call   80104be3 <swtch>
  mycpu()->intena = intena;
80103b47:	e8 a3 f9 ff ff       	call   801034ef <mycpu>
80103b4c:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b52:	83 c4 10             	add    $0x10,%esp
80103b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b58:	5b                   	pop    %ebx
80103b59:	5e                   	pop    %esi
80103b5a:	5d                   	pop    %ebp
80103b5b:	c3                   	ret    
    panic("sched ptable.lock");
80103b5c:	83 ec 0c             	sub    $0xc,%esp
80103b5f:	68 95 79 10 80       	push   $0x80107995
80103b64:	e8 db c7 ff ff       	call   80100344 <panic>
    panic("sched locks");
80103b69:	83 ec 0c             	sub    $0xc,%esp
80103b6c:	68 a7 79 10 80       	push   $0x801079a7
80103b71:	e8 ce c7 ff ff       	call   80100344 <panic>
    panic("sched running");
80103b76:	83 ec 0c             	sub    $0xc,%esp
80103b79:	68 b3 79 10 80       	push   $0x801079b3
80103b7e:	e8 c1 c7 ff ff       	call   80100344 <panic>
    panic("sched interruptible");
80103b83:	83 ec 0c             	sub    $0xc,%esp
80103b86:	68 c1 79 10 80       	push   $0x801079c1
80103b8b:	e8 b4 c7 ff ff       	call   80100344 <panic>

80103b90 <exit>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	57                   	push   %edi
80103b94:	56                   	push   %esi
80103b95:	53                   	push   %ebx
80103b96:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103b99:	e8 e3 f9 ff ff       	call   80103581 <myproc>
80103b9e:	89 c6                	mov    %eax,%esi
80103ba0:	8d 58 28             	lea    0x28(%eax),%ebx
80103ba3:	8d 78 68             	lea    0x68(%eax),%edi
  if(curproc == initproc)
80103ba6:	39 05 c0 a5 10 80    	cmp    %eax,0x8010a5c0
80103bac:	75 14                	jne    80103bc2 <exit+0x32>
    panic("init exiting");
80103bae:	83 ec 0c             	sub    $0xc,%esp
80103bb1:	68 d5 79 10 80       	push   $0x801079d5
80103bb6:	e8 89 c7 ff ff       	call   80100344 <panic>
80103bbb:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103bbe:	39 fb                	cmp    %edi,%ebx
80103bc0:	74 1a                	je     80103bdc <exit+0x4c>
    if(curproc->ofile[fd]){
80103bc2:	8b 03                	mov    (%ebx),%eax
80103bc4:	85 c0                	test   %eax,%eax
80103bc6:	74 f3                	je     80103bbb <exit+0x2b>
      fileclose(curproc->ofile[fd]);
80103bc8:	83 ec 0c             	sub    $0xc,%esp
80103bcb:	50                   	push   %eax
80103bcc:	e8 d0 d1 ff ff       	call   80100da1 <fileclose>
      curproc->ofile[fd] = 0;
80103bd1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103bd7:	83 c4 10             	add    $0x10,%esp
80103bda:	eb df                	jmp    80103bbb <exit+0x2b>
  begin_op();
80103bdc:	e8 53 ec ff ff       	call   80102834 <begin_op>
  iput(curproc->cwd);
80103be1:	83 ec 0c             	sub    $0xc,%esp
80103be4:	ff 76 68             	pushl  0x68(%esi)
80103be7:	e8 88 da ff ff       	call   80101674 <iput>
  end_op();
80103bec:	e8 be ec ff ff       	call   801028af <end_op>
  curproc->cwd = 0;
80103bf1:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103bf8:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103bff:	e8 4c 0d 00 00       	call   80104950 <acquire>
  wakeup1(curproc->parent);
80103c04:	8b 46 14             	mov    0x14(%esi),%eax
80103c07:	e8 0d f8 ff ff       	call   80103419 <wakeup1>
80103c0c:	83 c4 10             	add    $0x10,%esp
  for(int i = EMBRYO; i < statecount; ++i)
80103c0f:	bf 01 00 00 00       	mov    $0x1,%edi
80103c14:	eb 70                	jmp    80103c86 <exit+0xf6>
      p = p -> next;
80103c16:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
    while(p)
80103c1c:	85 db                	test   %ebx,%ebx
80103c1e:	74 5e                	je     80103c7e <exit+0xee>
      if (p -> parent == curproc) 
80103c20:	39 73 14             	cmp    %esi,0x14(%ebx)
80103c23:	75 f1                	jne    80103c16 <exit+0x86>
        p -> parent = initproc;
80103c25:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80103c2a:	89 43 14             	mov    %eax,0x14(%ebx)
        if (i == ZOMBIE)
80103c2d:	83 ff 05             	cmp    $0x5,%edi
80103c30:	75 e4                	jne    80103c16 <exit+0x86>
          wakeup1(initproc);
80103c32:	e8 e2 f7 ff ff       	call   80103419 <wakeup1>
      p = p -> next;
80103c37:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
    while(p)
80103c3d:	85 db                	test   %ebx,%ebx
80103c3f:	75 df                	jne    80103c20 <exit+0x90>
  stateListRemove(&ptable.list[RUNNING], curproc);
80103c41:	89 f2                	mov    %esi,%edx
80103c43:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103c48:	e8 bb f5 ff ff       	call   80103208 <stateListRemove>
  assertState(curproc, RUNNING);
80103c4d:	ba 04 00 00 00       	mov    $0x4,%edx
80103c52:	89 f0                	mov    %esi,%eax
80103c54:	e8 59 f6 ff ff       	call   801032b2 <assertState>
  curproc->state = ZOMBIE;
80103c59:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  stateListAdd(&ptable.list[ZOMBIE], curproc);
80103c60:	89 f2                	mov    %esi,%edx
80103c62:	b8 3c cb 10 80       	mov    $0x8010cb3c,%eax
80103c67:	e8 62 f5 ff ff       	call   801031ce <stateListAdd>
  sched();
80103c6c:	e8 65 fe ff ff       	call   80103ad6 <sched>
  panic("zombie exit");
80103c71:	83 ec 0c             	sub    $0xc,%esp
80103c74:	68 e2 79 10 80       	push   $0x801079e2
80103c79:	e8 c6 c6 ff ff       	call   80100344 <panic>
  for(int i = EMBRYO; i < statecount; ++i)
80103c7e:	83 c7 01             	add    $0x1,%edi
80103c81:	83 ff 06             	cmp    $0x6,%edi
80103c84:	74 bb                	je     80103c41 <exit+0xb1>
    p = ptable.list[i].head;
80103c86:	8b 1c fd 14 cb 10 80 	mov    -0x7fef34ec(,%edi,8),%ebx
    while(p)
80103c8d:	85 db                	test   %ebx,%ebx
80103c8f:	75 8f                	jne    80103c20 <exit+0x90>
80103c91:	eb eb                	jmp    80103c7e <exit+0xee>

80103c93 <yield>:
{
80103c93:	55                   	push   %ebp
80103c94:	89 e5                	mov    %esp,%ebp
80103c96:	53                   	push   %ebx
80103c97:	83 ec 04             	sub    $0x4,%esp
  struct proc *curproc = myproc();
80103c9a:	e8 e2 f8 ff ff       	call   80103581 <myproc>
80103c9f:	89 c3                	mov    %eax,%ebx
  acquire(&ptable.lock);  //DOC: yieldlock
80103ca1:	83 ec 0c             	sub    $0xc,%esp
80103ca4:	68 e0 a5 10 80       	push   $0x8010a5e0
80103ca9:	e8 a2 0c 00 00       	call   80104950 <acquire>
  assertState(curproc, RUNNING);
80103cae:	ba 04 00 00 00       	mov    $0x4,%edx
80103cb3:	89 d8                	mov    %ebx,%eax
80103cb5:	e8 f8 f5 ff ff       	call   801032b2 <assertState>
  stateListRemove(&ptable.list[RUNNING], curproc);
80103cba:	89 da                	mov    %ebx,%edx
80103cbc:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103cc1:	e8 42 f5 ff ff       	call   80103208 <stateListRemove>
  curproc->state = RUNNABLE;
80103cc6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  stateListAdd(&ptable.list[RUNNABLE], curproc);
80103ccd:	89 da                	mov    %ebx,%edx
80103ccf:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
80103cd4:	e8 f5 f4 ff ff       	call   801031ce <stateListAdd>
  sched();
80103cd9:	e8 f8 fd ff ff       	call   80103ad6 <sched>
  release(&ptable.lock);
80103cde:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103ce5:	e8 cd 0c 00 00       	call   801049b7 <release>
}
80103cea:	83 c4 10             	add    $0x10,%esp
80103ced:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cf0:	c9                   	leave  
80103cf1:	c3                   	ret    

80103cf2 <sleep>:
{
80103cf2:	55                   	push   %ebp
80103cf3:	89 e5                	mov    %esp,%ebp
80103cf5:	57                   	push   %edi
80103cf6:	56                   	push   %esi
80103cf7:	53                   	push   %ebx
80103cf8:	83 ec 0c             	sub    $0xc,%esp
80103cfb:	8b 7d 08             	mov    0x8(%ebp),%edi
80103cfe:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103d01:	e8 7b f8 ff ff       	call   80103581 <myproc>
  if(p == 0)
80103d06:	85 c0                	test   %eax,%eax
80103d08:	0f 84 82 00 00 00    	je     80103d90 <sleep+0x9e>
80103d0e:	89 c3                	mov    %eax,%ebx
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d10:	81 fe e0 a5 10 80    	cmp    $0x8010a5e0,%esi
80103d16:	0f 84 81 00 00 00    	je     80103d9d <sleep+0xab>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d1c:	83 ec 0c             	sub    $0xc,%esp
80103d1f:	68 e0 a5 10 80       	push   $0x8010a5e0
80103d24:	e8 27 0c 00 00       	call   80104950 <acquire>
    if (lk) release(lk);
80103d29:	83 c4 10             	add    $0x10,%esp
80103d2c:	85 f6                	test   %esi,%esi
80103d2e:	0f 84 ab 00 00 00    	je     80103ddf <sleep+0xed>
80103d34:	83 ec 0c             	sub    $0xc,%esp
80103d37:	56                   	push   %esi
80103d38:	e8 7a 0c 00 00       	call   801049b7 <release>
  stateListRemove(&ptable.list[RUNNING], p);
80103d3d:	89 da                	mov    %ebx,%edx
80103d3f:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103d44:	e8 bf f4 ff ff       	call   80103208 <stateListRemove>
  assertState(p, RUNNING);
80103d49:	ba 04 00 00 00       	mov    $0x4,%edx
80103d4e:	89 d8                	mov    %ebx,%eax
80103d50:	e8 5d f5 ff ff       	call   801032b2 <assertState>
  p->chan = chan;
80103d55:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d58:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  stateListAdd(&ptable.list[SLEEPING], p);
80103d5f:	89 da                	mov    %ebx,%edx
80103d61:	b8 24 cb 10 80       	mov    $0x8010cb24,%eax
80103d66:	e8 63 f4 ff ff       	call   801031ce <stateListAdd>
  sched();
80103d6b:	e8 66 fd ff ff       	call   80103ad6 <sched>
  p->chan = 0;
80103d70:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103d77:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103d7e:	e8 34 0c 00 00       	call   801049b7 <release>
    if (lk) acquire(lk);
80103d83:	89 34 24             	mov    %esi,(%esp)
80103d86:	e8 c5 0b 00 00       	call   80104950 <acquire>
80103d8b:	83 c4 10             	add    $0x10,%esp
}
80103d8e:	eb 47                	jmp    80103dd7 <sleep+0xe5>
    panic("sleep");
80103d90:	83 ec 0c             	sub    $0xc,%esp
80103d93:	68 ee 79 10 80       	push   $0x801079ee
80103d98:	e8 a7 c5 ff ff       	call   80100344 <panic>
  stateListRemove(&ptable.list[RUNNING], p);
80103d9d:	89 c2                	mov    %eax,%edx
80103d9f:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103da4:	e8 5f f4 ff ff       	call   80103208 <stateListRemove>
  assertState(p, RUNNING);
80103da9:	ba 04 00 00 00       	mov    $0x4,%edx
80103dae:	89 d8                	mov    %ebx,%eax
80103db0:	e8 fd f4 ff ff       	call   801032b2 <assertState>
  p->chan = chan;
80103db5:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103db8:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  stateListAdd(&ptable.list[SLEEPING], p);
80103dbf:	89 da                	mov    %ebx,%edx
80103dc1:	b8 24 cb 10 80       	mov    $0x8010cb24,%eax
80103dc6:	e8 03 f4 ff ff       	call   801031ce <stateListAdd>
  sched();
80103dcb:	e8 06 fd ff ff       	call   80103ad6 <sched>
  p->chan = 0;
80103dd0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dda:	5b                   	pop    %ebx
80103ddb:	5e                   	pop    %esi
80103ddc:	5f                   	pop    %edi
80103ddd:	5d                   	pop    %ebp
80103dde:	c3                   	ret    
  stateListRemove(&ptable.list[RUNNING], p);
80103ddf:	89 da                	mov    %ebx,%edx
80103de1:	b8 34 cb 10 80       	mov    $0x8010cb34,%eax
80103de6:	e8 1d f4 ff ff       	call   80103208 <stateListRemove>
  assertState(p, RUNNING);
80103deb:	ba 04 00 00 00       	mov    $0x4,%edx
80103df0:	89 d8                	mov    %ebx,%eax
80103df2:	e8 bb f4 ff ff       	call   801032b2 <assertState>
  p->chan = chan;
80103df7:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103dfa:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  stateListAdd(&ptable.list[SLEEPING], p);
80103e01:	89 da                	mov    %ebx,%edx
80103e03:	b8 24 cb 10 80       	mov    $0x8010cb24,%eax
80103e08:	e8 c1 f3 ff ff       	call   801031ce <stateListAdd>
  sched();
80103e0d:	e8 c4 fc ff ff       	call   80103ad6 <sched>
  p->chan = 0;
80103e12:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103e19:	83 ec 0c             	sub    $0xc,%esp
80103e1c:	68 e0 a5 10 80       	push   $0x8010a5e0
80103e21:	e8 91 0b 00 00       	call   801049b7 <release>
80103e26:	83 c4 10             	add    $0x10,%esp
80103e29:	eb ac                	jmp    80103dd7 <sleep+0xe5>

80103e2b <wait>:
{
80103e2b:	55                   	push   %ebp
80103e2c:	89 e5                	mov    %esp,%ebp
80103e2e:	57                   	push   %edi
80103e2f:	56                   	push   %esi
80103e30:	53                   	push   %ebx
80103e31:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103e34:	e8 48 f7 ff ff       	call   80103581 <myproc>
80103e39:	89 c3                	mov    %eax,%ebx
  acquire(&ptable.lock);
80103e3b:	83 ec 0c             	sub    $0xc,%esp
80103e3e:	68 e0 a5 10 80       	push   $0x8010a5e0
80103e43:	e8 08 0b 00 00       	call   80104950 <acquire>
80103e48:	83 c4 10             	add    $0x10,%esp
    struct proc * p1 = ptable.list[EMBRYO].head;
80103e4b:	8b 3d 1c cb 10 80    	mov    0x8010cb1c,%edi
    struct proc * p2 = ptable.list[SLEEPING].head;
80103e51:	8b 35 24 cb 10 80    	mov    0x8010cb24,%esi
    struct proc * p3 = ptable.list[RUNNABLE].head;
80103e57:	8b 0d 2c cb 10 80    	mov    0x8010cb2c,%ecx
    struct proc * p4 = ptable.list[RUNNING].head; 
80103e5d:	8b 15 34 cb 10 80    	mov    0x8010cb34,%edx
    struct proc * p = ptable.list[ZOMBIE].head;
80103e63:	a1 3c cb 10 80       	mov    0x8010cb3c,%eax
80103e68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    while(p1) // Embryo list
80103e6b:	85 ff                	test   %edi,%edi
80103e6d:	0f 84 1d 01 00 00    	je     80103f90 <wait+0x165>
    havekids = 0;
80103e73:	b8 00 00 00 00       	mov    $0x0,%eax
80103e78:	89 55 e0             	mov    %edx,-0x20(%ebp)
      if(p1->parent == curproc)
80103e7b:	39 5f 14             	cmp    %ebx,0x14(%edi)
        havekids = 1;  
80103e7e:	ba 01 00 00 00       	mov    $0x1,%edx
80103e83:	0f 44 c2             	cmove  %edx,%eax
      p1 = p1 -> next;
80103e86:	8b bf 90 00 00 00    	mov    0x90(%edi),%edi
    while(p1) // Embryo list
80103e8c:	85 ff                	test   %edi,%edi
80103e8e:	75 eb                	jne    80103e7b <wait+0x50>
80103e90:	8b 55 e0             	mov    -0x20(%ebp),%edx
    while(p2) // Sleeping list
80103e93:	85 f6                	test   %esi,%esi
80103e95:	74 15                	je     80103eac <wait+0x81>
      if(p2->parent == curproc)
80103e97:	39 5e 14             	cmp    %ebx,0x14(%esi)
        havekids = 1;  
80103e9a:	bf 01 00 00 00       	mov    $0x1,%edi
80103e9f:	0f 44 c7             	cmove  %edi,%eax
      p2 = p2 -> next;
80103ea2:	8b b6 90 00 00 00    	mov    0x90(%esi),%esi
    while(p2) // Sleeping list
80103ea8:	85 f6                	test   %esi,%esi
80103eaa:	75 eb                	jne    80103e97 <wait+0x6c>
    while(p3) // Runnable list
80103eac:	85 c9                	test   %ecx,%ecx
80103eae:	74 15                	je     80103ec5 <wait+0x9a>
      if(p3->parent == curproc)
80103eb0:	39 59 14             	cmp    %ebx,0x14(%ecx)
        havekids = 1;  
80103eb3:	be 01 00 00 00       	mov    $0x1,%esi
80103eb8:	0f 44 c6             	cmove  %esi,%eax
      p3 = p3 -> next;
80103ebb:	8b 89 90 00 00 00    	mov    0x90(%ecx),%ecx
    while(p3) // Runnable list
80103ec1:	85 c9                	test   %ecx,%ecx
80103ec3:	75 eb                	jne    80103eb0 <wait+0x85>
    while(p4) // Running list
80103ec5:	85 d2                	test   %edx,%edx
80103ec7:	74 15                	je     80103ede <wait+0xb3>
      if(p4->parent == curproc)
80103ec9:	39 5a 14             	cmp    %ebx,0x14(%edx)
        havekids = 1;  
80103ecc:	b9 01 00 00 00       	mov    $0x1,%ecx
80103ed1:	0f 44 c1             	cmove  %ecx,%eax
      p4 = p4 -> next;
80103ed4:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
    while(p4) // Running list
80103eda:	85 d2                	test   %edx,%edx
80103edc:	75 eb                	jne    80103ec9 <wait+0x9e>
    while(p) // If child is in zombie list, remove it. 
80103ede:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103ee1:	85 ff                	test   %edi,%edi
80103ee3:	0f 84 c5 00 00 00    	je     80103fae <wait+0x183>
      if(p->parent == curproc) 
80103ee9:	3b 5f 14             	cmp    0x14(%edi),%ebx
80103eec:	0f 84 a8 00 00 00    	je     80103f9a <wait+0x16f>
80103ef2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      p = p->next;
80103ef5:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
    while(p) // If child is in zombie list, remove it. 
80103efb:	85 d2                	test   %edx,%edx
80103efd:	0f 84 ab 00 00 00    	je     80103fae <wait+0x183>
      if(p->parent == curproc) 
80103f03:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f06:	75 ed                	jne    80103ef5 <wait+0xca>
80103f08:	89 d6                	mov    %edx,%esi
        int rc = stateListRemove(&ptable.list[ZOMBIE], p);
80103f0a:	89 f2                	mov    %esi,%edx
80103f0c:	b8 3c cb 10 80       	mov    $0x8010cb3c,%eax
80103f11:	e8 f2 f2 ff ff       	call   80103208 <stateListRemove>
        if(rc == -1)
80103f16:	83 f8 ff             	cmp    $0xffffffff,%eax
80103f19:	0f 84 82 00 00 00    	je     80103fa1 <wait+0x176>
        assertState(p, ZOMBIE); 
80103f1f:	ba 05 00 00 00       	mov    $0x5,%edx
80103f24:	89 f0                	mov    %esi,%eax
80103f26:	e8 87 f3 ff ff       	call   801032b2 <assertState>
        pid = p->pid;
80103f2b:	8b 5e 10             	mov    0x10(%esi),%ebx
        kfree(p->kstack);
80103f2e:	83 ec 0c             	sub    $0xc,%esp
80103f31:	ff 76 08             	pushl  0x8(%esi)
80103f34:	e8 87 e1 ff ff       	call   801020c0 <kfree>
        p->kstack = 0;
80103f39:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
        freevm(p->pgdir);
80103f40:	83 c4 04             	add    $0x4,%esp
80103f43:	ff 76 04             	pushl  0x4(%esi)
80103f46:	e8 94 30 00 00       	call   80106fdf <freevm>
        p->state = UNUSED; 
80103f4b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
        stateListAdd(&ptable.list[UNUSED], p);
80103f52:	89 f2                	mov    %esi,%edx
80103f54:	b8 14 cb 10 80       	mov    $0x8010cb14,%eax
80103f59:	e8 70 f2 ff ff       	call   801031ce <stateListAdd>
        p->pid = 0;
80103f5e:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
        p->parent = 0;
80103f65:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
        p->name[0] = 0;
80103f6c:	c6 46 6c 00          	movb   $0x0,0x6c(%esi)
        p->killed = 0;
80103f70:	c7 46 24 00 00 00 00 	movl   $0x0,0x24(%esi)
        release(&ptable.lock);
80103f77:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103f7e:	e8 34 0a 00 00       	call   801049b7 <release>
        return pid;
80103f83:	89 d8                	mov    %ebx,%eax
80103f85:	83 c4 10             	add    $0x10,%esp
}
80103f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f8b:	5b                   	pop    %ebx
80103f8c:	5e                   	pop    %esi
80103f8d:	5f                   	pop    %edi
80103f8e:	5d                   	pop    %ebp
80103f8f:	c3                   	ret    
    havekids = 0;
80103f90:	b8 00 00 00 00       	mov    $0x0,%eax
80103f95:	e9 f9 fe ff ff       	jmp    80103e93 <wait+0x68>
80103f9a:	89 fe                	mov    %edi,%esi
80103f9c:	e9 69 ff ff ff       	jmp    80103f0a <wait+0xdf>
          panic("ERROR NOT IN ZOMBIE"); 
80103fa1:	83 ec 0c             	sub    $0xc,%esp
80103fa4:	68 f4 79 10 80       	push   $0x801079f4
80103fa9:	e8 96 c3 ff ff       	call   80100344 <panic>
    if(!havekids || curproc->killed){
80103fae:	85 c0                	test   %eax,%eax
80103fb0:	74 1c                	je     80103fce <wait+0x1a3>
80103fb2:	83 7b 24 00          	cmpl   $0x0,0x24(%ebx)
80103fb6:	75 16                	jne    80103fce <wait+0x1a3>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103fb8:	83 ec 08             	sub    $0x8,%esp
80103fbb:	68 e0 a5 10 80       	push   $0x8010a5e0
80103fc0:	53                   	push   %ebx
80103fc1:	e8 2c fd ff ff       	call   80103cf2 <sleep>
  for(;;){
80103fc6:	83 c4 10             	add    $0x10,%esp
80103fc9:	e9 7d fe ff ff       	jmp    80103e4b <wait+0x20>
      release(&ptable.lock);
80103fce:	83 ec 0c             	sub    $0xc,%esp
80103fd1:	68 e0 a5 10 80       	push   $0x8010a5e0
80103fd6:	e8 dc 09 00 00       	call   801049b7 <release>
      return -1;
80103fdb:	83 c4 10             	add    $0x10,%esp
80103fde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fe3:	eb a3                	jmp    80103f88 <wait+0x15d>

80103fe5 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fe5:	55                   	push   %ebp
80103fe6:	89 e5                	mov    %esp,%ebp
80103fe8:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103feb:	68 e0 a5 10 80       	push   $0x8010a5e0
80103ff0:	e8 5b 09 00 00       	call   80104950 <acquire>
  wakeup1(chan);
80103ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff8:	e8 1c f4 ff ff       	call   80103419 <wakeup1>
  release(&ptable.lock);
80103ffd:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80104004:	e8 ae 09 00 00       	call   801049b7 <release>
}
80104009:	83 c4 10             	add    $0x10,%esp
8010400c:	c9                   	leave  
8010400d:	c3                   	ret    

8010400e <kill>:

#ifdef CS333_P3
// New implementation of kill
int
kill(int pid)
{
8010400e:	55                   	push   %ebp
8010400f:	89 e5                	mov    %esp,%ebp
80104011:	53                   	push   %ebx
80104012:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104015:	68 e0 a5 10 80       	push   $0x8010a5e0
8010401a:	e8 31 09 00 00       	call   80104950 <acquire>
8010401f:	83 c4 10             	add    $0x10,%esp

  for(int i = EMBRYO; i < statecount; ++i)
80104022:	b8 01 00 00 00       	mov    $0x1,%eax
  {
    p = ptable.list[i].head;
80104027:	8b 1c c5 14 cb 10 80 	mov    -0x7fef34ec(,%eax,8),%ebx
    while(p)
8010402e:	85 db                	test   %ebx,%ebx
80104030:	74 5d                	je     8010408f <kill+0x81>
    {
      if(p -> pid == pid)
80104032:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104035:	39 4b 10             	cmp    %ecx,0x10(%ebx)
80104038:	74 02                	je     8010403c <kill+0x2e>
8010403a:	eb fe                	jmp    8010403a <kill+0x2c>
      {
        p -> killed = 1;
8010403c:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
        // Wake process from sleep if necessary.
        if(i == SLEEPING)
80104043:	83 f8 02             	cmp    $0x2,%eax
80104046:	74 1a                	je     80104062 <kill+0x54>
          stateListRemove(&ptable.list[SLEEPING], p);
          assertState(p, SLEEPING);
          p->state = RUNNABLE;
          stateListAdd(&ptable.list[RUNNABLE], p);
         }
        release(&ptable.lock);
80104048:	83 ec 0c             	sub    $0xc,%esp
8010404b:	68 e0 a5 10 80       	push   $0x8010a5e0
80104050:	e8 62 09 00 00       	call   801049b7 <release>
        return 0;
80104055:	83 c4 10             	add    $0x10,%esp
80104058:	b8 00 00 00 00       	mov    $0x0,%eax
       }
     }
  }
  release(&ptable.lock);
  return -1;
}
8010405d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104060:	c9                   	leave  
80104061:	c3                   	ret    
          stateListRemove(&ptable.list[SLEEPING], p);
80104062:	89 da                	mov    %ebx,%edx
80104064:	b8 24 cb 10 80       	mov    $0x8010cb24,%eax
80104069:	e8 9a f1 ff ff       	call   80103208 <stateListRemove>
          assertState(p, SLEEPING);
8010406e:	ba 02 00 00 00       	mov    $0x2,%edx
80104073:	89 d8                	mov    %ebx,%eax
80104075:	e8 38 f2 ff ff       	call   801032b2 <assertState>
          p->state = RUNNABLE;
8010407a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
          stateListAdd(&ptable.list[RUNNABLE], p);
80104081:	89 da                	mov    %ebx,%edx
80104083:	b8 2c cb 10 80       	mov    $0x8010cb2c,%eax
80104088:	e8 41 f1 ff ff       	call   801031ce <stateListAdd>
8010408d:	eb b9                	jmp    80104048 <kill+0x3a>
  for(int i = EMBRYO; i < statecount; ++i)
8010408f:	83 c0 01             	add    $0x1,%eax
80104092:	83 f8 06             	cmp    $0x6,%eax
80104095:	75 90                	jne    80104027 <kill+0x19>
  release(&ptable.lock);
80104097:	83 ec 0c             	sub    $0xc,%esp
8010409a:	68 e0 a5 10 80       	push   $0x8010a5e0
8010409f:	e8 13 09 00 00       	call   801049b7 <release>
  return -1;
801040a4:	83 c4 10             	add    $0x10,%esp
801040a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040ac:	eb af                	jmp    8010405d <kill+0x4f>

801040ae <procdumpP1>:

//Control-P implmeentation for Project 1. Wrapper for procdump.
#ifdef CS333_P1
void
procdumpP1(struct proc *p, char *state)
{
801040ae:	55                   	push   %ebp
801040af:	89 e5                	mov    %esp,%ebp
801040b1:	57                   	push   %edi
801040b2:	56                   	push   %esi
801040b3:	53                   	push   %ebx
801040b4:	83 ec 0c             	sub    $0xc,%esp
801040b7:	8b 7d 08             	mov    0x8(%ebp),%edi
  int seconds;
  int millisec; 

  // Put equation for ticks here to make it into seconds
  seconds = ticks - p->start_ticks;     // Find the Seconds
801040ba:	8b 0d c0 5a 11 80    	mov    0x80115ac0,%ecx
801040c0:	2b 4f 7c             	sub    0x7c(%edi),%ecx
  millisec = seconds%1000;               // Find the millisecond after decimal
801040c3:	bb d3 4d 62 10       	mov    $0x10624dd3,%ebx
801040c8:	89 c8                	mov    %ecx,%eax
801040ca:	f7 eb                	imul   %ebx
801040cc:	89 d3                	mov    %edx,%ebx
801040ce:	c1 fb 06             	sar    $0x6,%ebx
801040d1:	89 c8                	mov    %ecx,%eax
801040d3:	c1 f8 1f             	sar    $0x1f,%eax
801040d6:	89 de                	mov    %ebx,%esi
801040d8:	29 c6                	sub    %eax,%esi
801040da:	69 f6 e8 03 00 00    	imul   $0x3e8,%esi,%esi
801040e0:	29 f1                	sub    %esi,%ecx
801040e2:	89 ce                	mov    %ecx,%esi
  seconds = seconds/1000;               // Convert to actual seconds
801040e4:	29 c3                	sub    %eax,%ebx

  if(millisec < 10)
801040e6:	83 f9 09             	cmp    $0x9,%ecx
801040e9:	7e 12                	jle    801040fd <procdumpP1+0x4f>
      cprintf("%d\t%s\t%d.00%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10

  if(millisec < 100)
801040eb:	83 fe 63             	cmp    $0x63,%esi
801040ee:	7e 2d                	jle    8010411d <procdumpP1+0x6f>
      cprintf("%d\t%s\t%d.0%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10

  if(millisec > 100)
801040f0:	83 fe 64             	cmp    $0x64,%esi
801040f3:	7f 48                	jg     8010413d <procdumpP1+0x8f>
      cprintf("%d\t%s\t%d.%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10
}
801040f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040f8:	5b                   	pop    %ebx
801040f9:	5e                   	pop    %esi
801040fa:	5f                   	pop    %edi
801040fb:	5d                   	pop    %ebp
801040fc:	c3                   	ret    
      cprintf("%d\t%s\t%d.00%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10
801040fd:	83 ec 04             	sub    $0x4,%esp
80104100:	ff 37                	pushl  (%edi)
80104102:	ff 75 0c             	pushl  0xc(%ebp)
80104105:	51                   	push   %ecx
80104106:	53                   	push   %ebx
80104107:	8d 47 6c             	lea    0x6c(%edi),%eax
8010410a:	50                   	push   %eax
8010410b:	ff 77 10             	pushl  0x10(%edi)
8010410e:	68 08 7a 10 80       	push   $0x80107a08
80104113:	e8 c9 c4 ff ff       	call   801005e1 <cprintf>
80104118:	83 c4 20             	add    $0x20,%esp
8010411b:	eb ce                	jmp    801040eb <procdumpP1+0x3d>
      cprintf("%d\t%s\t%d.0%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10
8010411d:	83 ec 04             	sub    $0x4,%esp
80104120:	ff 37                	pushl  (%edi)
80104122:	ff 75 0c             	pushl  0xc(%ebp)
80104125:	56                   	push   %esi
80104126:	53                   	push   %ebx
80104127:	8d 47 6c             	lea    0x6c(%edi),%eax
8010412a:	50                   	push   %eax
8010412b:	ff 77 10             	pushl  0x10(%edi)
8010412e:	68 1d 7a 10 80       	push   $0x80107a1d
80104133:	e8 a9 c4 ff ff       	call   801005e1 <cprintf>
80104138:	83 c4 20             	add    $0x20,%esp
8010413b:	eb b3                	jmp    801040f0 <procdumpP1+0x42>
      cprintf("%d\t%s\t%d.%d\t%s\t%d\t", p->pid, p->name, seconds, millisec, state, p->sz); // Add 2 more zeros for less than 10
8010413d:	83 ec 04             	sub    $0x4,%esp
80104140:	ff 37                	pushl  (%edi)
80104142:	ff 75 0c             	pushl  0xc(%ebp)
80104145:	56                   	push   %esi
80104146:	53                   	push   %ebx
80104147:	8d 47 6c             	lea    0x6c(%edi),%eax
8010414a:	50                   	push   %eax
8010414b:	ff 77 10             	pushl  0x10(%edi)
8010414e:	68 31 7a 10 80       	push   $0x80107a31
80104153:	e8 89 c4 ff ff       	call   801005e1 <cprintf>
80104158:	83 c4 20             	add    $0x20,%esp
}
8010415b:	eb 98                	jmp    801040f5 <procdumpP1+0x47>

8010415d <procdumpP2>:

#ifdef CS333_P2
//Control-P implementation for Project 2. Wrapper for procdump.
void
procdumpP2(struct proc *p, char *state)
{
8010415d:	55                   	push   %ebp
8010415e:	89 e5                	mov    %esp,%ebp
80104160:	57                   	push   %edi
80104161:	56                   	push   %esi
80104162:	53                   	push   %ebx
80104163:	83 ec 28             	sub    $0x28,%esp
80104166:	8b 75 08             	mov    0x8(%ebp),%esi
  // Put equation for ticks here to make it into seconds
  int seconds = ticks - p->start_ticks;     // Find the Seconds
80104169:	8b 0d c0 5a 11 80    	mov    0x80115ac0,%ecx
8010416f:	2b 4e 7c             	sub    0x7c(%esi),%ecx
  int millisec = seconds%1000;               // Find the millisecond after decimal
80104172:	89 c8                	mov    %ecx,%eax
80104174:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
80104179:	f7 ef                	imul   %edi
8010417b:	c1 fa 06             	sar    $0x6,%edx
8010417e:	89 c8                	mov    %ecx,%eax
80104180:	c1 f8 1f             	sar    $0x1f,%eax
80104183:	89 d7                	mov    %edx,%edi
80104185:	29 c7                	sub    %eax,%edi
80104187:	69 ff e8 03 00 00    	imul   $0x3e8,%edi,%edi
8010418d:	89 cb                	mov    %ecx,%ebx
8010418f:	29 fb                	sub    %edi,%ebx
80104191:	89 df                	mov    %ebx,%edi
  seconds = seconds/1000;               // Convert to actual seconds
80104193:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104196:	29 c2                	sub    %eax,%edx
80104198:	89 55 e0             	mov    %edx,-0x20(%ebp)

  int cpu_seconds = p->cpu_ticks_total/1000;    
  int cpu_millisec = p->cpu_ticks_total%1000;   
8010419b:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
801041a0:	f7 a6 88 00 00 00    	mull   0x88(%esi)
801041a6:	89 d3                	mov    %edx,%ebx
801041a8:	c1 eb 06             	shr    $0x6,%ebx
801041ab:	69 db e8 03 00 00    	imul   $0x3e8,%ebx,%ebx
801041b1:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
801041b7:	29 da                	sub    %ebx,%edx
801041b9:	89 d3                	mov    %edx,%ebx
  cpu_seconds = seconds/1000;             
801041bb:	ba 83 de 1b 43       	mov    $0x431bde83,%edx
801041c0:	89 c8                	mov    %ecx,%eax
801041c2:	f7 ea                	imul   %edx
801041c4:	c1 fa 12             	sar    $0x12,%edx
801041c7:	2b 55 e4             	sub    -0x1c(%ebp),%edx
801041ca:	89 55 e4             	mov    %edx,-0x1c(%ebp)

  cprintf("%d\t%s\t%d\t%d\t", p->pid, p->name, p->uid, p->gid);
801041cd:	ff b6 84 00 00 00    	pushl  0x84(%esi)
801041d3:	ff b6 80 00 00 00    	pushl  0x80(%esi)
801041d9:	8d 46 6c             	lea    0x6c(%esi),%eax
801041dc:	50                   	push   %eax
801041dd:	ff 76 10             	pushl  0x10(%esi)
801041e0:	68 44 7a 10 80       	push   $0x80107a44
801041e5:	e8 f7 c3 ff ff       	call   801005e1 <cprintf>
  
  //Parent check. Are we in the INIT process?
  if(p->parent == NULL)
801041ea:	8b 46 14             	mov    0x14(%esi),%eax
801041ed:	83 c4 20             	add    $0x20,%esp
801041f0:	85 c0                	test   %eax,%eax
801041f2:	74 41                	je     80104235 <procdumpP2+0xd8>
    cprintf("%d\t", p->pid);
  else
    cprintf("%d\t", p->parent->pid);
801041f4:	83 ec 08             	sub    $0x8,%esp
801041f7:	ff 70 10             	pushl  0x10(%eax)
801041fa:	68 4d 7a 10 80       	push   $0x80107a4d
801041ff:	e8 dd c3 ff ff       	call   801005e1 <cprintf>
80104204:	83 c4 10             	add    $0x10,%esp

  if(millisec < 10)
80104207:	83 ff 09             	cmp    $0x9,%edi
8010420a:	7e 3e                	jle    8010424a <procdumpP2+0xed>
    cprintf("%d.00%d\t", seconds, millisec);

  if(millisec < 100)
8010420c:	83 ff 63             	cmp    $0x63,%edi
8010420f:	7e 4f                	jle    80104260 <procdumpP2+0x103>
    cprintf("%d.0%d\t", seconds, millisec);

  if(millisec > 100)
80104211:	83 ff 64             	cmp    $0x64,%edi
80104214:	7f 60                	jg     80104276 <procdumpP2+0x119>
    cprintf("%d.%d\t", seconds, millisec);

  if(cpu_millisec < 10)
80104216:	83 fb 09             	cmp    $0x9,%ebx
80104219:	7e 71                	jle    8010428c <procdumpP2+0x12f>
    cprintf("%d.00%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec < 100)
8010421b:	83 fb 63             	cmp    $0x63,%ebx
8010421e:	0f 8e 86 00 00 00    	jle    801042aa <procdumpP2+0x14d>
    cprintf("%d.0%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec > 100)
80104224:	83 fb 64             	cmp    $0x64,%ebx
80104227:	0f 8f 9b 00 00 00    	jg     801042c8 <procdumpP2+0x16b>
    cprintf("%d.%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
}
8010422d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104230:	5b                   	pop    %ebx
80104231:	5e                   	pop    %esi
80104232:	5f                   	pop    %edi
80104233:	5d                   	pop    %ebp
80104234:	c3                   	ret    
    cprintf("%d\t", p->pid);
80104235:	83 ec 08             	sub    $0x8,%esp
80104238:	ff 76 10             	pushl  0x10(%esi)
8010423b:	68 4d 7a 10 80       	push   $0x80107a4d
80104240:	e8 9c c3 ff ff       	call   801005e1 <cprintf>
80104245:	83 c4 10             	add    $0x10,%esp
80104248:	eb bd                	jmp    80104207 <procdumpP2+0xaa>
    cprintf("%d.00%d\t", seconds, millisec);
8010424a:	83 ec 04             	sub    $0x4,%esp
8010424d:	57                   	push   %edi
8010424e:	ff 75 e0             	pushl  -0x20(%ebp)
80104251:	68 51 7a 10 80       	push   $0x80107a51
80104256:	e8 86 c3 ff ff       	call   801005e1 <cprintf>
8010425b:	83 c4 10             	add    $0x10,%esp
8010425e:	eb ac                	jmp    8010420c <procdumpP2+0xaf>
    cprintf("%d.0%d\t", seconds, millisec);
80104260:	83 ec 04             	sub    $0x4,%esp
80104263:	57                   	push   %edi
80104264:	ff 75 e0             	pushl  -0x20(%ebp)
80104267:	68 5a 7a 10 80       	push   $0x80107a5a
8010426c:	e8 70 c3 ff ff       	call   801005e1 <cprintf>
80104271:	83 c4 10             	add    $0x10,%esp
80104274:	eb 9b                	jmp    80104211 <procdumpP2+0xb4>
    cprintf("%d.%d\t", seconds, millisec);
80104276:	83 ec 04             	sub    $0x4,%esp
80104279:	57                   	push   %edi
8010427a:	ff 75 e0             	pushl  -0x20(%ebp)
8010427d:	68 62 7a 10 80       	push   $0x80107a62
80104282:	e8 5a c3 ff ff       	call   801005e1 <cprintf>
80104287:	83 c4 10             	add    $0x10,%esp
8010428a:	eb 8a                	jmp    80104216 <procdumpP2+0xb9>
    cprintf("%d.00%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
8010428c:	83 ec 0c             	sub    $0xc,%esp
8010428f:	ff 36                	pushl  (%esi)
80104291:	ff 75 0c             	pushl  0xc(%ebp)
80104294:	53                   	push   %ebx
80104295:	ff 75 e4             	pushl  -0x1c(%ebp)
80104298:	68 0e 7a 10 80       	push   $0x80107a0e
8010429d:	e8 3f c3 ff ff       	call   801005e1 <cprintf>
801042a2:	83 c4 20             	add    $0x20,%esp
801042a5:	e9 71 ff ff ff       	jmp    8010421b <procdumpP2+0xbe>
    cprintf("%d.0%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
801042aa:	83 ec 0c             	sub    $0xc,%esp
801042ad:	ff 36                	pushl  (%esi)
801042af:	ff 75 0c             	pushl  0xc(%ebp)
801042b2:	53                   	push   %ebx
801042b3:	ff 75 e4             	pushl  -0x1c(%ebp)
801042b6:	68 23 7a 10 80       	push   $0x80107a23
801042bb:	e8 21 c3 ff ff       	call   801005e1 <cprintf>
801042c0:	83 c4 20             	add    $0x20,%esp
801042c3:	e9 5c ff ff ff       	jmp    80104224 <procdumpP2+0xc7>
    cprintf("%d.%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	ff 36                	pushl  (%esi)
801042cd:	ff 75 0c             	pushl  0xc(%ebp)
801042d0:	53                   	push   %ebx
801042d1:	ff 75 e4             	pushl  -0x1c(%ebp)
801042d4:	68 37 7a 10 80       	push   $0x80107a37
801042d9:	e8 03 c3 ff ff       	call   801005e1 <cprintf>
801042de:	83 c4 20             	add    $0x20,%esp
}
801042e1:	e9 47 ff ff ff       	jmp    8010422d <procdumpP2+0xd0>

801042e6 <procdumpP3>:

//Control-P implementation for Project 3. Wrapper for procdump.
#ifdef CS333_P3
void
procdumpP3(struct proc *p, char *state)
{
801042e6:	55                   	push   %ebp
801042e7:	89 e5                	mov    %esp,%ebp
801042e9:	57                   	push   %edi
801042ea:	56                   	push   %esi
801042eb:	53                   	push   %ebx
801042ec:	83 ec 28             	sub    $0x28,%esp
801042ef:	8b 75 08             	mov    0x8(%ebp),%esi
// Put equation for ticks here to make it into seconds
  int seconds = ticks - p->start_ticks;     // Find the Seconds
801042f2:	8b 0d c0 5a 11 80    	mov    0x80115ac0,%ecx
801042f8:	2b 4e 7c             	sub    0x7c(%esi),%ecx
  int millisec = seconds%1000;               // Find the millisecond after decimal
801042fb:	89 c8                	mov    %ecx,%eax
801042fd:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
80104302:	f7 ef                	imul   %edi
80104304:	c1 fa 06             	sar    $0x6,%edx
80104307:	89 c8                	mov    %ecx,%eax
80104309:	c1 f8 1f             	sar    $0x1f,%eax
8010430c:	89 d7                	mov    %edx,%edi
8010430e:	29 c7                	sub    %eax,%edi
80104310:	69 ff e8 03 00 00    	imul   $0x3e8,%edi,%edi
80104316:	89 cb                	mov    %ecx,%ebx
80104318:	29 fb                	sub    %edi,%ebx
8010431a:	89 df                	mov    %ebx,%edi
  seconds = seconds/1000;               // Convert to actual seconds
8010431c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010431f:	29 c2                	sub    %eax,%edx
80104321:	89 55 e0             	mov    %edx,-0x20(%ebp)

  int cpu_seconds = p->cpu_ticks_total/1000;    
  int cpu_millisec = p->cpu_ticks_total%1000;   
80104324:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
80104329:	f7 a6 88 00 00 00    	mull   0x88(%esi)
8010432f:	89 d3                	mov    %edx,%ebx
80104331:	c1 eb 06             	shr    $0x6,%ebx
80104334:	69 db e8 03 00 00    	imul   $0x3e8,%ebx,%ebx
8010433a:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
80104340:	29 da                	sub    %ebx,%edx
80104342:	89 d3                	mov    %edx,%ebx
  cpu_seconds = seconds/1000;             
80104344:	ba 83 de 1b 43       	mov    $0x431bde83,%edx
80104349:	89 c8                	mov    %ecx,%eax
8010434b:	f7 ea                	imul   %edx
8010434d:	c1 fa 12             	sar    $0x12,%edx
80104350:	2b 55 e4             	sub    -0x1c(%ebp),%edx
80104353:	89 55 e4             	mov    %edx,-0x1c(%ebp)

  cprintf("%d\t%s\t%d\t%d\t", p->pid, p->name, p->uid, p->gid);
80104356:	ff b6 84 00 00 00    	pushl  0x84(%esi)
8010435c:	ff b6 80 00 00 00    	pushl  0x80(%esi)
80104362:	8d 46 6c             	lea    0x6c(%esi),%eax
80104365:	50                   	push   %eax
80104366:	ff 76 10             	pushl  0x10(%esi)
80104369:	68 44 7a 10 80       	push   $0x80107a44
8010436e:	e8 6e c2 ff ff       	call   801005e1 <cprintf>
  
  //Parent check. Are we in the INIT process?
  if(p->parent == NULL)
80104373:	8b 46 14             	mov    0x14(%esi),%eax
80104376:	83 c4 20             	add    $0x20,%esp
80104379:	85 c0                	test   %eax,%eax
8010437b:	74 41                	je     801043be <procdumpP3+0xd8>
    cprintf("%d\t", p->pid);
  else
    cprintf("%d\t", p->parent->pid);
8010437d:	83 ec 08             	sub    $0x8,%esp
80104380:	ff 70 10             	pushl  0x10(%eax)
80104383:	68 4d 7a 10 80       	push   $0x80107a4d
80104388:	e8 54 c2 ff ff       	call   801005e1 <cprintf>
8010438d:	83 c4 10             	add    $0x10,%esp

  if(millisec < 10)
80104390:	83 ff 09             	cmp    $0x9,%edi
80104393:	7e 3e                	jle    801043d3 <procdumpP3+0xed>
    cprintf("%d.00%d\t", seconds, millisec);

  if(millisec < 100)
80104395:	83 ff 63             	cmp    $0x63,%edi
80104398:	7e 4f                	jle    801043e9 <procdumpP3+0x103>
    cprintf("%d.0%d\t", seconds, millisec);

  if(millisec > 100)
8010439a:	83 ff 64             	cmp    $0x64,%edi
8010439d:	7f 60                	jg     801043ff <procdumpP3+0x119>
    cprintf("%d.%d\t", seconds, millisec);

  if(cpu_millisec < 10)
8010439f:	83 fb 09             	cmp    $0x9,%ebx
801043a2:	7e 71                	jle    80104415 <procdumpP3+0x12f>
    cprintf("%d.00%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec < 100)
801043a4:	83 fb 63             	cmp    $0x63,%ebx
801043a7:	0f 8e 86 00 00 00    	jle    80104433 <procdumpP3+0x14d>
    cprintf("%d.0%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 

  if(cpu_millisec > 100)
801043ad:	83 fb 64             	cmp    $0x64,%ebx
801043b0:	0f 8f 9b 00 00 00    	jg     80104451 <procdumpP3+0x16b>
    cprintf("%d.%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
}
801043b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043b9:	5b                   	pop    %ebx
801043ba:	5e                   	pop    %esi
801043bb:	5f                   	pop    %edi
801043bc:	5d                   	pop    %ebp
801043bd:	c3                   	ret    
    cprintf("%d\t", p->pid);
801043be:	83 ec 08             	sub    $0x8,%esp
801043c1:	ff 76 10             	pushl  0x10(%esi)
801043c4:	68 4d 7a 10 80       	push   $0x80107a4d
801043c9:	e8 13 c2 ff ff       	call   801005e1 <cprintf>
801043ce:	83 c4 10             	add    $0x10,%esp
801043d1:	eb bd                	jmp    80104390 <procdumpP3+0xaa>
    cprintf("%d.00%d\t", seconds, millisec);
801043d3:	83 ec 04             	sub    $0x4,%esp
801043d6:	57                   	push   %edi
801043d7:	ff 75 e0             	pushl  -0x20(%ebp)
801043da:	68 51 7a 10 80       	push   $0x80107a51
801043df:	e8 fd c1 ff ff       	call   801005e1 <cprintf>
801043e4:	83 c4 10             	add    $0x10,%esp
801043e7:	eb ac                	jmp    80104395 <procdumpP3+0xaf>
    cprintf("%d.0%d\t", seconds, millisec);
801043e9:	83 ec 04             	sub    $0x4,%esp
801043ec:	57                   	push   %edi
801043ed:	ff 75 e0             	pushl  -0x20(%ebp)
801043f0:	68 5a 7a 10 80       	push   $0x80107a5a
801043f5:	e8 e7 c1 ff ff       	call   801005e1 <cprintf>
801043fa:	83 c4 10             	add    $0x10,%esp
801043fd:	eb 9b                	jmp    8010439a <procdumpP3+0xb4>
    cprintf("%d.%d\t", seconds, millisec);
801043ff:	83 ec 04             	sub    $0x4,%esp
80104402:	57                   	push   %edi
80104403:	ff 75 e0             	pushl  -0x20(%ebp)
80104406:	68 62 7a 10 80       	push   $0x80107a62
8010440b:	e8 d1 c1 ff ff       	call   801005e1 <cprintf>
80104410:	83 c4 10             	add    $0x10,%esp
80104413:	eb 8a                	jmp    8010439f <procdumpP3+0xb9>
    cprintf("%d.00%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
80104415:	83 ec 0c             	sub    $0xc,%esp
80104418:	ff 36                	pushl  (%esi)
8010441a:	ff 75 0c             	pushl  0xc(%ebp)
8010441d:	53                   	push   %ebx
8010441e:	ff 75 e4             	pushl  -0x1c(%ebp)
80104421:	68 0e 7a 10 80       	push   $0x80107a0e
80104426:	e8 b6 c1 ff ff       	call   801005e1 <cprintf>
8010442b:	83 c4 20             	add    $0x20,%esp
8010442e:	e9 71 ff ff ff       	jmp    801043a4 <procdumpP3+0xbe>
    cprintf("%d.0%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
80104433:	83 ec 0c             	sub    $0xc,%esp
80104436:	ff 36                	pushl  (%esi)
80104438:	ff 75 0c             	pushl  0xc(%ebp)
8010443b:	53                   	push   %ebx
8010443c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010443f:	68 23 7a 10 80       	push   $0x80107a23
80104444:	e8 98 c1 ff ff       	call   801005e1 <cprintf>
80104449:	83 c4 20             	add    $0x20,%esp
8010444c:	e9 5c ff ff ff       	jmp    801043ad <procdumpP3+0xc7>
    cprintf("%d.%d\t%s\t%d\t", cpu_seconds, cpu_millisec, state, p->sz); 
80104451:	83 ec 0c             	sub    $0xc,%esp
80104454:	ff 36                	pushl  (%esi)
80104456:	ff 75 0c             	pushl  0xc(%ebp)
80104459:	53                   	push   %ebx
8010445a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010445d:	68 37 7a 10 80       	push   $0x80107a37
80104462:	e8 7a c1 ff ff       	call   801005e1 <cprintf>
80104467:	83 c4 20             	add    $0x20,%esp
}
8010446a:	e9 47 ff ff ff       	jmp    801043b6 <procdumpP3+0xd0>

8010446f <procdump>:
{
8010446f:	55                   	push   %ebp
80104470:	89 e5                	mov    %esp,%ebp
80104472:	57                   	push   %edi
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
80104475:	83 ec 48             	sub    $0x48,%esp
  cprintf(HEADER);
80104478:	68 98 78 10 80       	push   $0x80107898
8010447d:	e8 5f c1 ff ff       	call   801005e1 <cprintf>
80104482:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104485:	bb 14 a6 10 80       	mov    $0x8010a614,%ebx
8010448a:	8d 7d e8             	lea    -0x18(%ebp),%edi
8010448d:	eb 31                	jmp    801044c0 <procdump+0x51>
    procdumpP3(p, state);
8010448f:	83 ec 08             	sub    $0x8,%esp
80104492:	50                   	push   %eax
80104493:	53                   	push   %ebx
80104494:	e8 4d fe ff ff       	call   801042e6 <procdumpP3>
    if(p->state == SLEEPING){
80104499:	83 c4 10             	add    $0x10,%esp
8010449c:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801044a0:	74 42                	je     801044e4 <procdump+0x75>
    cprintf("\n");
801044a2:	83 ec 0c             	sub    $0xc,%esp
801044a5:	68 1f 7e 10 80       	push   $0x80107e1f
801044aa:	e8 32 c1 ff ff       	call   801005e1 <cprintf>
801044af:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b2:	81 c3 94 00 00 00    	add    $0x94,%ebx
801044b8:	81 fb 14 cb 10 80    	cmp    $0x8010cb14,%ebx
801044be:	73 7b                	jae    8010453b <procdump+0xcc>
    if(p->state == UNUSED)
801044c0:	8b 53 0c             	mov    0xc(%ebx),%edx
801044c3:	85 d2                	test   %edx,%edx
801044c5:	74 eb                	je     801044b2 <procdump+0x43>
      state = "???";
801044c7:	b8 69 7a 10 80       	mov    $0x80107a69,%eax
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044cc:	83 fa 05             	cmp    $0x5,%edx
801044cf:	77 be                	ja     8010448f <procdump+0x20>
801044d1:	8b 04 95 a0 7a 10 80 	mov    -0x7fef8560(,%edx,4),%eax
801044d8:	85 c0                	test   %eax,%eax
      state = "???";
801044da:	ba 69 7a 10 80       	mov    $0x80107a69,%edx
801044df:	0f 44 c2             	cmove  %edx,%eax
801044e2:	eb ab                	jmp    8010448f <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044e4:	83 ec 08             	sub    $0x8,%esp
801044e7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044ea:	50                   	push   %eax
801044eb:	8b 43 1c             	mov    0x1c(%ebx),%eax
801044ee:	8b 40 0c             	mov    0xc(%eax),%eax
801044f1:	83 c0 08             	add    $0x8,%eax
801044f4:	50                   	push   %eax
801044f5:	e8 29 03 00 00       	call   80104823 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044fa:	8b 45 c0             	mov    -0x40(%ebp),%eax
801044fd:	83 c4 10             	add    $0x10,%esp
80104500:	85 c0                	test   %eax,%eax
80104502:	74 9e                	je     801044a2 <procdump+0x33>
        cprintf(" %p", pc[i]);
80104504:	83 ec 08             	sub    $0x8,%esp
80104507:	50                   	push   %eax
80104508:	68 e1 72 10 80       	push   $0x801072e1
8010450d:	e8 cf c0 ff ff       	call   801005e1 <cprintf>
80104512:	8d 75 c4             	lea    -0x3c(%ebp),%esi
80104515:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104518:	8b 06                	mov    (%esi),%eax
8010451a:	85 c0                	test   %eax,%eax
8010451c:	74 84                	je     801044a2 <procdump+0x33>
        cprintf(" %p", pc[i]);
8010451e:	83 ec 08             	sub    $0x8,%esp
80104521:	50                   	push   %eax
80104522:	68 e1 72 10 80       	push   $0x801072e1
80104527:	e8 b5 c0 ff ff       	call   801005e1 <cprintf>
8010452c:	83 c6 04             	add    $0x4,%esi
      for(i=0; i<10 && pc[i] != 0; i++)
8010452f:	83 c4 10             	add    $0x10,%esp
80104532:	39 f7                	cmp    %esi,%edi
80104534:	75 e2                	jne    80104518 <procdump+0xa9>
80104536:	e9 67 ff ff ff       	jmp    801044a2 <procdump+0x33>
}
8010453b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010453e:	5b                   	pop    %ebx
8010453f:	5e                   	pop    %esi
80104540:	5f                   	pop    %edi
80104541:	5d                   	pop    %ebp
80104542:	c3                   	ret    

80104543 <setuid>:

#ifdef CS333_P2
// Set the UID of the process
int
setuid(uint uid)
{
80104543:	55                   	push   %ebp
80104544:	89 e5                	mov    %esp,%ebp
80104546:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80104549:	68 e0 a5 10 80       	push   $0x8010a5e0
8010454e:	e8 fd 03 00 00       	call   80104950 <acquire>
  myproc()->uid = uid;
80104553:	e8 29 f0 ff ff       	call   80103581 <myproc>
80104558:	8b 55 08             	mov    0x8(%ebp),%edx
8010455b:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  release(&ptable.lock);
80104561:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80104568:	e8 4a 04 00 00       	call   801049b7 <release>
  return 1;
}
8010456d:	b8 01 00 00 00       	mov    $0x1,%eax
80104572:	c9                   	leave  
80104573:	c3                   	ret    

80104574 <setgid>:

// Set the GID of the process
int
setgid(uint gid)
{
80104574:	55                   	push   %ebp
80104575:	89 e5                	mov    %esp,%ebp
80104577:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010457a:	68 e0 a5 10 80       	push   $0x8010a5e0
8010457f:	e8 cc 03 00 00       	call   80104950 <acquire>
  myproc()->gid = gid;
80104584:	e8 f8 ef ff ff       	call   80103581 <myproc>
80104589:	8b 55 08             	mov    0x8(%ebp),%edx
8010458c:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  release(&ptable.lock);
80104592:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80104599:	e8 19 04 00 00       	call   801049b7 <release>
  return 1;
}
8010459e:	b8 01 00 00 00       	mov    $0x1,%eax
801045a3:	c9                   	leave  
801045a4:	c3                   	ret    

801045a5 <getprocs>:

// Displays active processes
int
getprocs(uint max, struct uproc *table)
{
801045a5:	55                   	push   %ebp
801045a6:	89 e5                	mov    %esp,%ebp
801045a8:	57                   	push   %edi
801045a9:	56                   	push   %esi
801045aa:	53                   	push   %ebx
801045ab:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
801045ae:	68 e0 a5 10 80       	push   $0x8010a5e0
801045b3:	e8 98 03 00 00       	call   80104950 <acquire>

  int count = 0;
  
  for(int i = 0; i < max && i < NPROC; ++i) //Tables may vary in sizes. Prevents going out of bounds.
801045b8:	83 c4 10             	add    $0x10,%esp
801045bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045bf:	0f 84 3d 01 00 00    	je     80104702 <getprocs+0x15d>
801045c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801045c8:	8d 78 40             	lea    0x40(%eax),%edi
801045cb:	bb 80 a6 10 80       	mov    $0x8010a680,%ebx
801045d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int count = 0;
801045d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801045de:	e9 80 00 00 00       	jmp    80104663 <getprocs+0xbe>
      table[i].pid = ptable.proc[i].pid;
      table[i].uid = ptable.proc[i].uid; 
      table[i].gid = ptable.proc[i].gid;

      if(ptable.proc[i].parent == 0)
        table[i].ppid = ptable.proc[i].pid;
801045e3:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801045e6:	89 47 cc             	mov    %eax,-0x34(%edi)
      else
        table[i].ppid = ptable.proc[i].parent->pid;

      table[i].elapsed_ticks = ticks - ptable.proc[i].start_ticks;
801045e9:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
801045ee:	2b 46 10             	sub    0x10(%esi),%eax
801045f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801045f4:	89 42 d4             	mov    %eax,-0x2c(%edx)
      table[i].CPU_total_ticks = ptable.proc[i].cpu_ticks_total;
801045f7:	8b 46 1c             	mov    0x1c(%esi),%eax
801045fa:	89 42 d8             	mov    %eax,-0x28(%edx)

      if(ptable.proc[i].state == SLEEPING)
801045fd:	83 7e a0 02          	cmpl   $0x2,-0x60(%esi)
80104601:	0f 84 8f 00 00 00    	je     80104696 <getprocs+0xf1>
        safestrcpy(table[i].state, "sleep", sizeof("sleep"));
      if(ptable.proc[i].state == RUNNABLE)
80104607:	83 7e a0 03          	cmpl   $0x3,-0x60(%esi)
8010460b:	0f 84 a0 00 00 00    	je     801046b1 <getprocs+0x10c>
        safestrcpy(table[i].state, "runnable", sizeof("runnable"));
      if(ptable.proc[i].state == RUNNING)
80104611:	83 7e a0 04          	cmpl   $0x4,-0x60(%esi)
80104615:	0f 84 b1 00 00 00    	je     801046cc <getprocs+0x127>
        safestrcpy(table[i].state, "running", sizeof("running"));
      if(ptable.proc[i].state == ZOMBIE)
8010461b:	83 7e a0 05          	cmpl   $0x5,-0x60(%esi)
8010461f:	0f 84 c2 00 00 00    	je     801046e7 <getprocs+0x142>
        safestrcpy(table[i].state, "zombie", sizeof("zombie"));

      table[i].size = ptable.proc[i].sz; 
80104625:	8b 46 94             	mov    -0x6c(%esi),%eax
80104628:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010462b:	89 41 fc             	mov    %eax,-0x4(%ecx)
      safestrcpy(table[i].name, ptable.proc[i].name, sizeof(ptable.proc[i].name));
8010462e:	83 ec 04             	sub    $0x4,%esp
80104631:	6a 10                	push   $0x10
80104633:	56                   	push   %esi
80104634:	51                   	push   %ecx
80104635:	e8 53 05 00 00       	call   80104b8d <safestrcpy>
      ++count;
8010463a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
8010463e:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < max && i < NPROC; ++i) //Tables may vary in sizes. Prevents going out of bounds.
80104641:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104648:	83 c7 60             	add    $0x60,%edi
8010464b:	81 c3 94 00 00 00    	add    $0x94,%ebx
80104651:	39 45 08             	cmp    %eax,0x8(%ebp)
80104654:	0f 86 af 00 00 00    	jbe    80104709 <getprocs+0x164>
8010465a:	83 f8 3f             	cmp    $0x3f,%eax
8010465d:	0f 8f a6 00 00 00    	jg     80104709 <getprocs+0x164>
80104663:	89 de                	mov    %ebx,%esi
    if(ptable.proc[i].state != UNUSED && ptable.proc[i].state != EMBRYO) //These states are inactive
80104665:	83 7b a0 01          	cmpl   $0x1,-0x60(%ebx)
80104669:	76 d6                	jbe    80104641 <getprocs+0x9c>
      table[i].pid = ptable.proc[i].pid;
8010466b:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010466e:	89 7d e0             	mov    %edi,-0x20(%ebp)
80104671:	89 47 c0             	mov    %eax,-0x40(%edi)
      table[i].uid = ptable.proc[i].uid; 
80104674:	8b 43 14             	mov    0x14(%ebx),%eax
80104677:	89 47 c4             	mov    %eax,-0x3c(%edi)
      table[i].gid = ptable.proc[i].gid;
8010467a:	8b 43 18             	mov    0x18(%ebx),%eax
8010467d:	89 47 c8             	mov    %eax,-0x38(%edi)
      if(ptable.proc[i].parent == 0)
80104680:	8b 43 a8             	mov    -0x58(%ebx),%eax
80104683:	85 c0                	test   %eax,%eax
80104685:	0f 84 58 ff ff ff    	je     801045e3 <getprocs+0x3e>
        table[i].ppid = ptable.proc[i].parent->pid;
8010468b:	8b 40 10             	mov    0x10(%eax),%eax
8010468e:	89 47 cc             	mov    %eax,-0x34(%edi)
80104691:	e9 53 ff ff ff       	jmp    801045e9 <getprocs+0x44>
        safestrcpy(table[i].state, "sleep", sizeof("sleep"));
80104696:	83 ec 04             	sub    $0x4,%esp
80104699:	6a 06                	push   $0x6
8010469b:	68 ee 79 10 80       	push   $0x801079ee
801046a0:	8d 47 dc             	lea    -0x24(%edi),%eax
801046a3:	50                   	push   %eax
801046a4:	e8 e4 04 00 00       	call   80104b8d <safestrcpy>
801046a9:	83 c4 10             	add    $0x10,%esp
801046ac:	e9 56 ff ff ff       	jmp    80104607 <getprocs+0x62>
        safestrcpy(table[i].state, "runnable", sizeof("runnable"));
801046b1:	83 ec 04             	sub    $0x4,%esp
801046b4:	6a 09                	push   $0x9
801046b6:	68 6d 7a 10 80       	push   $0x80107a6d
801046bb:	8d 47 dc             	lea    -0x24(%edi),%eax
801046be:	50                   	push   %eax
801046bf:	e8 c9 04 00 00       	call   80104b8d <safestrcpy>
801046c4:	83 c4 10             	add    $0x10,%esp
801046c7:	e9 45 ff ff ff       	jmp    80104611 <getprocs+0x6c>
        safestrcpy(table[i].state, "running", sizeof("running"));
801046cc:	83 ec 04             	sub    $0x4,%esp
801046cf:	6a 08                	push   $0x8
801046d1:	68 b9 79 10 80       	push   $0x801079b9
801046d6:	8d 47 dc             	lea    -0x24(%edi),%eax
801046d9:	50                   	push   %eax
801046da:	e8 ae 04 00 00       	call   80104b8d <safestrcpy>
801046df:	83 c4 10             	add    $0x10,%esp
801046e2:	e9 34 ff ff ff       	jmp    8010461b <getprocs+0x76>
        safestrcpy(table[i].state, "zombie", sizeof("zombie"));
801046e7:	83 ec 04             	sub    $0x4,%esp
801046ea:	6a 07                	push   $0x7
801046ec:	68 76 7a 10 80       	push   $0x80107a76
801046f1:	8d 47 dc             	lea    -0x24(%edi),%eax
801046f4:	50                   	push   %eax
801046f5:	e8 93 04 00 00       	call   80104b8d <safestrcpy>
801046fa:	83 c4 10             	add    $0x10,%esp
801046fd:	e9 23 ff ff ff       	jmp    80104625 <getprocs+0x80>
  int count = 0;
80104702:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    }
  }
  release(&ptable.lock);
80104709:	83 ec 0c             	sub    $0xc,%esp
8010470c:	68 e0 a5 10 80       	push   $0x8010a5e0
80104711:	e8 a1 02 00 00       	call   801049b7 <release>
  return count; //How large uproc *table is
}
80104716:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104719:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010471c:	5b                   	pop    %ebx
8010471d:	5e                   	pop    %esi
8010471e:	5f                   	pop    %edi
8010471f:	5d                   	pop    %ebp
80104720:	c3                   	ret    

80104721 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104721:	55                   	push   %ebp
80104722:	89 e5                	mov    %esp,%ebp
80104724:	53                   	push   %ebx
80104725:	83 ec 0c             	sub    $0xc,%esp
80104728:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010472b:	68 b8 7a 10 80       	push   $0x80107ab8
80104730:	8d 43 04             	lea    0x4(%ebx),%eax
80104733:	50                   	push   %eax
80104734:	e8 cf 00 00 00       	call   80104808 <initlock>
  lk->name = name;
80104739:	8b 45 0c             	mov    0xc(%ebp),%eax
8010473c:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
8010473f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104745:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
8010474c:	83 c4 10             	add    $0x10,%esp
8010474f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104752:	c9                   	leave  
80104753:	c3                   	ret    

80104754 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104754:	55                   	push   %ebp
80104755:	89 e5                	mov    %esp,%ebp
80104757:	56                   	push   %esi
80104758:	53                   	push   %ebx
80104759:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010475c:	8d 73 04             	lea    0x4(%ebx),%esi
8010475f:	83 ec 0c             	sub    $0xc,%esp
80104762:	56                   	push   %esi
80104763:	e8 e8 01 00 00       	call   80104950 <acquire>
  while (lk->locked) {
80104768:	83 c4 10             	add    $0x10,%esp
8010476b:	83 3b 00             	cmpl   $0x0,(%ebx)
8010476e:	74 12                	je     80104782 <acquiresleep+0x2e>
    sleep(lk, &lk->lk);
80104770:	83 ec 08             	sub    $0x8,%esp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	e8 78 f5 ff ff       	call   80103cf2 <sleep>
  while (lk->locked) {
8010477a:	83 c4 10             	add    $0x10,%esp
8010477d:	83 3b 00             	cmpl   $0x0,(%ebx)
80104780:	75 ee                	jne    80104770 <acquiresleep+0x1c>
  }
  lk->locked = 1;
80104782:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104788:	e8 f4 ed ff ff       	call   80103581 <myproc>
8010478d:	8b 40 10             	mov    0x10(%eax),%eax
80104790:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104793:	83 ec 0c             	sub    $0xc,%esp
80104796:	56                   	push   %esi
80104797:	e8 1b 02 00 00       	call   801049b7 <release>
}
8010479c:	83 c4 10             	add    $0x10,%esp
8010479f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047a2:	5b                   	pop    %ebx
801047a3:	5e                   	pop    %esi
801047a4:	5d                   	pop    %ebp
801047a5:	c3                   	ret    

801047a6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047a6:	55                   	push   %ebp
801047a7:	89 e5                	mov    %esp,%ebp
801047a9:	56                   	push   %esi
801047aa:	53                   	push   %ebx
801047ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047ae:	8d 73 04             	lea    0x4(%ebx),%esi
801047b1:	83 ec 0c             	sub    $0xc,%esp
801047b4:	56                   	push   %esi
801047b5:	e8 96 01 00 00       	call   80104950 <acquire>
  lk->locked = 0;
801047ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047c0:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047c7:	89 1c 24             	mov    %ebx,(%esp)
801047ca:	e8 16 f8 ff ff       	call   80103fe5 <wakeup>
  release(&lk->lk);
801047cf:	89 34 24             	mov    %esi,(%esp)
801047d2:	e8 e0 01 00 00       	call   801049b7 <release>
}
801047d7:	83 c4 10             	add    $0x10,%esp
801047da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047dd:	5b                   	pop    %ebx
801047de:	5e                   	pop    %esi
801047df:	5d                   	pop    %ebp
801047e0:	c3                   	ret    

801047e1 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801047e1:	55                   	push   %ebp
801047e2:	89 e5                	mov    %esp,%ebp
801047e4:	56                   	push   %esi
801047e5:	53                   	push   %ebx
801047e6:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801047e9:	8d 5e 04             	lea    0x4(%esi),%ebx
801047ec:	83 ec 0c             	sub    $0xc,%esp
801047ef:	53                   	push   %ebx
801047f0:	e8 5b 01 00 00       	call   80104950 <acquire>
  r = lk->locked;
801047f5:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801047f7:	89 1c 24             	mov    %ebx,(%esp)
801047fa:	e8 b8 01 00 00       	call   801049b7 <release>
  return r;
}
801047ff:	89 f0                	mov    %esi,%eax
80104801:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104804:	5b                   	pop    %ebx
80104805:	5e                   	pop    %esi
80104806:	5d                   	pop    %ebp
80104807:	c3                   	ret    

80104808 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104808:	55                   	push   %ebp
80104809:	89 e5                	mov    %esp,%ebp
8010480b:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010480e:	8b 55 0c             	mov    0xc(%ebp),%edx
80104811:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104814:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010481a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104821:	5d                   	pop    %ebp
80104822:	c3                   	ret    

80104823 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104823:	55                   	push   %ebp
80104824:	89 e5                	mov    %esp,%ebp
80104826:	53                   	push   %ebx
80104827:	8b 45 08             	mov    0x8(%ebp),%eax
8010482a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010482d:	8d 90 f8 ff ff 7f    	lea    0x7ffffff8(%eax),%edx
80104833:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104839:	77 2d                	ja     80104868 <getcallerpcs+0x45>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010483b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010483e:	89 11                	mov    %edx,(%ecx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104840:	8b 50 f8             	mov    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104843:	b8 01 00 00 00       	mov    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104848:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010484e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104854:	77 17                	ja     8010486d <getcallerpcs+0x4a>
    pcs[i] = ebp[1];     // saved %eip
80104856:	8b 5a 04             	mov    0x4(%edx),%ebx
80104859:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
8010485c:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010485e:	83 c0 01             	add    $0x1,%eax
80104861:	83 f8 0a             	cmp    $0xa,%eax
80104864:	75 e2                	jne    80104848 <getcallerpcs+0x25>
80104866:	eb 14                	jmp    8010487c <getcallerpcs+0x59>
80104868:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  for(; i < 10; i++)
    pcs[i] = 0;
8010486d:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80104874:	83 c0 01             	add    $0x1,%eax
80104877:	83 f8 09             	cmp    $0x9,%eax
8010487a:	7e f1                	jle    8010486d <getcallerpcs+0x4a>
}
8010487c:	5b                   	pop    %ebx
8010487d:	5d                   	pop    %ebp
8010487e:	c3                   	ret    

8010487f <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010487f:	55                   	push   %ebp
80104880:	89 e5                	mov    %esp,%ebp
80104882:	53                   	push   %ebx
80104883:	83 ec 04             	sub    $0x4,%esp
80104886:	9c                   	pushf  
80104887:	5b                   	pop    %ebx
  asm volatile("cli");
80104888:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104889:	e8 61 ec ff ff       	call   801034ef <mycpu>
8010488e:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80104895:	74 12                	je     801048a9 <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104897:	e8 53 ec ff ff       	call   801034ef <mycpu>
8010489c:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801048a3:	83 c4 04             	add    $0x4,%esp
801048a6:	5b                   	pop    %ebx
801048a7:	5d                   	pop    %ebp
801048a8:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
801048a9:	e8 41 ec ff ff       	call   801034ef <mycpu>
801048ae:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801048ba:	eb db                	jmp    80104897 <pushcli+0x18>

801048bc <popcli>:

void
popcli(void)
{
801048bc:	55                   	push   %ebp
801048bd:	89 e5                	mov    %esp,%ebp
801048bf:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048c2:	9c                   	pushf  
801048c3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048c4:	f6 c4 02             	test   $0x2,%ah
801048c7:	75 28                	jne    801048f1 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048c9:	e8 21 ec ff ff       	call   801034ef <mycpu>
801048ce:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801048d4:	8d 51 ff             	lea    -0x1(%ecx),%edx
801048d7:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801048dd:	85 d2                	test   %edx,%edx
801048df:	78 1d                	js     801048fe <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048e1:	e8 09 ec ff ff       	call   801034ef <mycpu>
801048e6:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
801048ed:	74 1c                	je     8010490b <popcli+0x4f>
    sti();
}
801048ef:	c9                   	leave  
801048f0:	c3                   	ret    
    panic("popcli - interruptible");
801048f1:	83 ec 0c             	sub    $0xc,%esp
801048f4:	68 c3 7a 10 80       	push   $0x80107ac3
801048f9:	e8 46 ba ff ff       	call   80100344 <panic>
    panic("popcli");
801048fe:	83 ec 0c             	sub    $0xc,%esp
80104901:	68 da 7a 10 80       	push   $0x80107ada
80104906:	e8 39 ba ff ff       	call   80100344 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010490b:	e8 df eb ff ff       	call   801034ef <mycpu>
80104910:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80104917:	74 d6                	je     801048ef <popcli+0x33>
  asm volatile("sti");
80104919:	fb                   	sti    
}
8010491a:	eb d3                	jmp    801048ef <popcli+0x33>

8010491c <holding>:
{
8010491c:	55                   	push   %ebp
8010491d:	89 e5                	mov    %esp,%ebp
8010491f:	56                   	push   %esi
80104920:	53                   	push   %ebx
80104921:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104924:	e8 56 ff ff ff       	call   8010487f <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104929:	bb 00 00 00 00       	mov    $0x0,%ebx
8010492e:	83 3e 00             	cmpl   $0x0,(%esi)
80104931:	75 0b                	jne    8010493e <holding+0x22>
  popcli();
80104933:	e8 84 ff ff ff       	call   801048bc <popcli>
}
80104938:	89 d8                	mov    %ebx,%eax
8010493a:	5b                   	pop    %ebx
8010493b:	5e                   	pop    %esi
8010493c:	5d                   	pop    %ebp
8010493d:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
8010493e:	8b 5e 08             	mov    0x8(%esi),%ebx
80104941:	e8 a9 eb ff ff       	call   801034ef <mycpu>
80104946:	39 c3                	cmp    %eax,%ebx
80104948:	0f 94 c3             	sete   %bl
8010494b:	0f b6 db             	movzbl %bl,%ebx
8010494e:	eb e3                	jmp    80104933 <holding+0x17>

80104950 <acquire>:
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104957:	e8 23 ff ff ff       	call   8010487f <pushcli>
  if(holding(lk))
8010495c:	83 ec 0c             	sub    $0xc,%esp
8010495f:	ff 75 08             	pushl  0x8(%ebp)
80104962:	e8 b5 ff ff ff       	call   8010491c <holding>
80104967:	83 c4 10             	add    $0x10,%esp
8010496a:	85 c0                	test   %eax,%eax
8010496c:	75 3c                	jne    801049aa <acquire+0x5a>
  asm volatile("lock; xchgl %0, %1" :
8010496e:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80104973:	8b 55 08             	mov    0x8(%ebp),%edx
80104976:	89 c8                	mov    %ecx,%eax
80104978:	f0 87 02             	lock xchg %eax,(%edx)
8010497b:	85 c0                	test   %eax,%eax
8010497d:	75 f4                	jne    80104973 <acquire+0x23>
  __sync_synchronize();
8010497f:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104984:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104987:	e8 63 eb ff ff       	call   801034ef <mycpu>
8010498c:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010498f:	83 ec 08             	sub    $0x8,%esp
80104992:	8b 45 08             	mov    0x8(%ebp),%eax
80104995:	83 c0 0c             	add    $0xc,%eax
80104998:	50                   	push   %eax
80104999:	8d 45 08             	lea    0x8(%ebp),%eax
8010499c:	50                   	push   %eax
8010499d:	e8 81 fe ff ff       	call   80104823 <getcallerpcs>
}
801049a2:	83 c4 10             	add    $0x10,%esp
801049a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a8:	c9                   	leave  
801049a9:	c3                   	ret    
    panic("acquire");
801049aa:	83 ec 0c             	sub    $0xc,%esp
801049ad:	68 e1 7a 10 80       	push   $0x80107ae1
801049b2:	e8 8d b9 ff ff       	call   80100344 <panic>

801049b7 <release>:
{
801049b7:	55                   	push   %ebp
801049b8:	89 e5                	mov    %esp,%ebp
801049ba:	53                   	push   %ebx
801049bb:	83 ec 10             	sub    $0x10,%esp
801049be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801049c1:	53                   	push   %ebx
801049c2:	e8 55 ff ff ff       	call   8010491c <holding>
801049c7:	83 c4 10             	add    $0x10,%esp
801049ca:	85 c0                	test   %eax,%eax
801049cc:	74 23                	je     801049f1 <release+0x3a>
  lk->pcs[0] = 0;
801049ce:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801049d5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801049dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801049e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
801049e7:	e8 d0 fe ff ff       	call   801048bc <popcli>
}
801049ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049ef:	c9                   	leave  
801049f0:	c3                   	ret    
    panic("release");
801049f1:	83 ec 0c             	sub    $0xc,%esp
801049f4:	68 e9 7a 10 80       	push   $0x80107ae9
801049f9:	e8 46 b9 ff ff       	call   80100344 <panic>

801049fe <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049fe:	55                   	push   %ebp
801049ff:	89 e5                	mov    %esp,%ebp
80104a01:	57                   	push   %edi
80104a02:	53                   	push   %ebx
80104a03:	8b 55 08             	mov    0x8(%ebp),%edx
80104a06:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a09:	f6 c2 03             	test   $0x3,%dl
80104a0c:	75 05                	jne    80104a13 <memset+0x15>
80104a0e:	f6 c1 03             	test   $0x3,%cl
80104a11:	74 0e                	je     80104a21 <memset+0x23>
  asm volatile("cld; rep stosb" :
80104a13:	89 d7                	mov    %edx,%edi
80104a15:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a18:	fc                   	cld    
80104a19:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a1b:	89 d0                	mov    %edx,%eax
80104a1d:	5b                   	pop    %ebx
80104a1e:	5f                   	pop    %edi
80104a1f:	5d                   	pop    %ebp
80104a20:	c3                   	ret    
    c &= 0xFF;
80104a21:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a25:	c1 e9 02             	shr    $0x2,%ecx
80104a28:	89 f8                	mov    %edi,%eax
80104a2a:	c1 e0 18             	shl    $0x18,%eax
80104a2d:	89 fb                	mov    %edi,%ebx
80104a2f:	c1 e3 10             	shl    $0x10,%ebx
80104a32:	09 d8                	or     %ebx,%eax
80104a34:	09 f8                	or     %edi,%eax
80104a36:	c1 e7 08             	shl    $0x8,%edi
80104a39:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104a3b:	89 d7                	mov    %edx,%edi
80104a3d:	fc                   	cld    
80104a3e:	f3 ab                	rep stos %eax,%es:(%edi)
80104a40:	eb d9                	jmp    80104a1b <memset+0x1d>

80104a42 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a42:	55                   	push   %ebp
80104a43:	89 e5                	mov    %esp,%ebp
80104a45:	57                   	push   %edi
80104a46:	56                   	push   %esi
80104a47:	53                   	push   %ebx
80104a48:	8b 75 08             	mov    0x8(%ebp),%esi
80104a4b:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a51:	85 db                	test   %ebx,%ebx
80104a53:	74 37                	je     80104a8c <memcmp+0x4a>
    if(*s1 != *s2)
80104a55:	0f b6 16             	movzbl (%esi),%edx
80104a58:	0f b6 0f             	movzbl (%edi),%ecx
80104a5b:	38 ca                	cmp    %cl,%dl
80104a5d:	75 19                	jne    80104a78 <memcmp+0x36>
80104a5f:	b8 01 00 00 00       	mov    $0x1,%eax
  while(n-- > 0){
80104a64:	39 d8                	cmp    %ebx,%eax
80104a66:	74 1d                	je     80104a85 <memcmp+0x43>
    if(*s1 != *s2)
80104a68:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104a6c:	83 c0 01             	add    $0x1,%eax
80104a6f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104a74:	38 ca                	cmp    %cl,%dl
80104a76:	74 ec                	je     80104a64 <memcmp+0x22>
      return *s1 - *s2;
80104a78:	0f b6 c2             	movzbl %dl,%eax
80104a7b:	0f b6 c9             	movzbl %cl,%ecx
80104a7e:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104a80:	5b                   	pop    %ebx
80104a81:	5e                   	pop    %esi
80104a82:	5f                   	pop    %edi
80104a83:	5d                   	pop    %ebp
80104a84:	c3                   	ret    
  return 0;
80104a85:	b8 00 00 00 00       	mov    $0x0,%eax
80104a8a:	eb f4                	jmp    80104a80 <memcmp+0x3e>
80104a8c:	b8 00 00 00 00       	mov    $0x0,%eax
80104a91:	eb ed                	jmp    80104a80 <memcmp+0x3e>

80104a93 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a93:	55                   	push   %ebp
80104a94:	89 e5                	mov    %esp,%ebp
80104a96:	56                   	push   %esi
80104a97:	53                   	push   %ebx
80104a98:	8b 45 08             	mov    0x8(%ebp),%eax
80104a9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a9e:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104aa1:	39 c3                	cmp    %eax,%ebx
80104aa3:	72 1b                	jb     80104ac0 <memmove+0x2d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104aa5:	ba 00 00 00 00       	mov    $0x0,%edx
80104aaa:	85 f6                	test   %esi,%esi
80104aac:	74 0e                	je     80104abc <memmove+0x29>
      *d++ = *s++;
80104aae:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ab2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ab5:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104ab8:	39 d6                	cmp    %edx,%esi
80104aba:	75 f2                	jne    80104aae <memmove+0x1b>

  return dst;
}
80104abc:	5b                   	pop    %ebx
80104abd:	5e                   	pop    %esi
80104abe:	5d                   	pop    %ebp
80104abf:	c3                   	ret    
  if(s < d && s + n > d){
80104ac0:	8d 14 33             	lea    (%ebx,%esi,1),%edx
80104ac3:	39 d0                	cmp    %edx,%eax
80104ac5:	73 de                	jae    80104aa5 <memmove+0x12>
    while(n-- > 0)
80104ac7:	8d 56 ff             	lea    -0x1(%esi),%edx
80104aca:	85 f6                	test   %esi,%esi
80104acc:	74 ee                	je     80104abc <memmove+0x29>
      *--d = *--s;
80104ace:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ad2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104ad5:	83 ea 01             	sub    $0x1,%edx
80104ad8:	83 fa ff             	cmp    $0xffffffff,%edx
80104adb:	75 f1                	jne    80104ace <memmove+0x3b>
80104add:	eb dd                	jmp    80104abc <memmove+0x29>

80104adf <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104adf:	55                   	push   %ebp
80104ae0:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104ae2:	ff 75 10             	pushl  0x10(%ebp)
80104ae5:	ff 75 0c             	pushl  0xc(%ebp)
80104ae8:	ff 75 08             	pushl  0x8(%ebp)
80104aeb:	e8 a3 ff ff ff       	call   80104a93 <memmove>
}
80104af0:	c9                   	leave  
80104af1:	c3                   	ret    

80104af2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104af2:	55                   	push   %ebp
80104af3:	89 e5                	mov    %esp,%ebp
80104af5:	53                   	push   %ebx
80104af6:	8b 45 08             	mov    0x8(%ebp),%eax
80104af9:	8b 55 0c             	mov    0xc(%ebp),%edx
80104afc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
80104aff:	85 db                	test   %ebx,%ebx
80104b01:	74 2d                	je     80104b30 <strncmp+0x3e>
80104b03:	0f b6 08             	movzbl (%eax),%ecx
80104b06:	84 c9                	test   %cl,%cl
80104b08:	74 1b                	je     80104b25 <strncmp+0x33>
80104b0a:	3a 0a                	cmp    (%edx),%cl
80104b0c:	75 17                	jne    80104b25 <strncmp+0x33>
80104b0e:	01 c3                	add    %eax,%ebx
    n--, p++, q++;
80104b10:	83 c0 01             	add    $0x1,%eax
80104b13:	83 c2 01             	add    $0x1,%edx
  while(n > 0 && *p && *p == *q)
80104b16:	39 d8                	cmp    %ebx,%eax
80104b18:	74 1d                	je     80104b37 <strncmp+0x45>
80104b1a:	0f b6 08             	movzbl (%eax),%ecx
80104b1d:	84 c9                	test   %cl,%cl
80104b1f:	74 04                	je     80104b25 <strncmp+0x33>
80104b21:	3a 0a                	cmp    (%edx),%cl
80104b23:	74 eb                	je     80104b10 <strncmp+0x1e>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b25:	0f b6 00             	movzbl (%eax),%eax
80104b28:	0f b6 12             	movzbl (%edx),%edx
80104b2b:	29 d0                	sub    %edx,%eax
}
80104b2d:	5b                   	pop    %ebx
80104b2e:	5d                   	pop    %ebp
80104b2f:	c3                   	ret    
    return 0;
80104b30:	b8 00 00 00 00       	mov    $0x0,%eax
80104b35:	eb f6                	jmp    80104b2d <strncmp+0x3b>
80104b37:	b8 00 00 00 00       	mov    $0x0,%eax
80104b3c:	eb ef                	jmp    80104b2d <strncmp+0x3b>

80104b3e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b3e:	55                   	push   %ebp
80104b3f:	89 e5                	mov    %esp,%ebp
80104b41:	57                   	push   %edi
80104b42:	56                   	push   %esi
80104b43:	53                   	push   %ebx
80104b44:	8b 7d 08             	mov    0x8(%ebp),%edi
80104b47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b4a:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b4d:	89 f9                	mov    %edi,%ecx
80104b4f:	eb 02                	jmp    80104b53 <strncpy+0x15>
80104b51:	89 f2                	mov    %esi,%edx
80104b53:	8d 72 ff             	lea    -0x1(%edx),%esi
80104b56:	85 d2                	test   %edx,%edx
80104b58:	7e 11                	jle    80104b6b <strncpy+0x2d>
80104b5a:	83 c3 01             	add    $0x1,%ebx
80104b5d:	83 c1 01             	add    $0x1,%ecx
80104b60:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
80104b64:	88 41 ff             	mov    %al,-0x1(%ecx)
80104b67:	84 c0                	test   %al,%al
80104b69:	75 e6                	jne    80104b51 <strncpy+0x13>
    ;
  while(n-- > 0)
80104b6b:	bb 00 00 00 00       	mov    $0x0,%ebx
80104b70:	83 ea 01             	sub    $0x1,%edx
80104b73:	85 f6                	test   %esi,%esi
80104b75:	7e 0f                	jle    80104b86 <strncpy+0x48>
    *s++ = 0;
80104b77:	c6 04 19 00          	movb   $0x0,(%ecx,%ebx,1)
80104b7b:	83 c3 01             	add    $0x1,%ebx
80104b7e:	89 d6                	mov    %edx,%esi
80104b80:	29 de                	sub    %ebx,%esi
  while(n-- > 0)
80104b82:	85 f6                	test   %esi,%esi
80104b84:	7f f1                	jg     80104b77 <strncpy+0x39>
  return os;
}
80104b86:	89 f8                	mov    %edi,%eax
80104b88:	5b                   	pop    %ebx
80104b89:	5e                   	pop    %esi
80104b8a:	5f                   	pop    %edi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    

80104b8d <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b8d:	55                   	push   %ebp
80104b8e:	89 e5                	mov    %esp,%ebp
80104b90:	56                   	push   %esi
80104b91:	53                   	push   %ebx
80104b92:	8b 45 08             	mov    0x8(%ebp),%eax
80104b95:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
80104b9b:	85 c9                	test   %ecx,%ecx
80104b9d:	7e 1e                	jle    80104bbd <safestrcpy+0x30>
80104b9f:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ba3:	89 c1                	mov    %eax,%ecx
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ba5:	39 f2                	cmp    %esi,%edx
80104ba7:	74 11                	je     80104bba <safestrcpy+0x2d>
80104ba9:	83 c2 01             	add    $0x1,%edx
80104bac:	83 c1 01             	add    $0x1,%ecx
80104baf:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104bb3:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104bb6:	84 db                	test   %bl,%bl
80104bb8:	75 eb                	jne    80104ba5 <safestrcpy+0x18>
    ;
  *s = 0;
80104bba:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104bbd:	5b                   	pop    %ebx
80104bbe:	5e                   	pop    %esi
80104bbf:	5d                   	pop    %ebp
80104bc0:	c3                   	ret    

80104bc1 <strlen>:

int
strlen(const char *s)
{
80104bc1:	55                   	push   %ebp
80104bc2:	89 e5                	mov    %esp,%ebp
80104bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104bc7:	80 3a 00             	cmpb   $0x0,(%edx)
80104bca:	74 10                	je     80104bdc <strlen+0x1b>
80104bcc:	b8 00 00 00 00       	mov    $0x0,%eax
80104bd1:	83 c0 01             	add    $0x1,%eax
80104bd4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104bd8:	75 f7                	jne    80104bd1 <strlen+0x10>
    ;
  return n;
}
80104bda:	5d                   	pop    %ebp
80104bdb:	c3                   	ret    
  for(n = 0; s[n]; n++)
80104bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
80104be1:	eb f7                	jmp    80104bda <strlen+0x19>

80104be3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104be3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104be7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104beb:	55                   	push   %ebp
  pushl %ebx
80104bec:	53                   	push   %ebx
  pushl %esi
80104bed:	56                   	push   %esi
  pushl %edi
80104bee:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104bef:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104bf1:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104bf3:	5f                   	pop    %edi
  popl %esi
80104bf4:	5e                   	pop    %esi
  popl %ebx
80104bf5:	5b                   	pop    %ebx
  popl %ebp
80104bf6:	5d                   	pop    %ebp
  ret
80104bf7:	c3                   	ret    

80104bf8 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104bf8:	55                   	push   %ebp
80104bf9:	89 e5                	mov    %esp,%ebp
80104bfb:	53                   	push   %ebx
80104bfc:	83 ec 04             	sub    $0x4,%esp
80104bff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c02:	e8 7a e9 ff ff       	call   80103581 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c07:	8b 00                	mov    (%eax),%eax
80104c09:	39 d8                	cmp    %ebx,%eax
80104c0b:	76 19                	jbe    80104c26 <fetchint+0x2e>
80104c0d:	8d 53 04             	lea    0x4(%ebx),%edx
80104c10:	39 d0                	cmp    %edx,%eax
80104c12:	72 19                	jb     80104c2d <fetchint+0x35>
    return -1;
  *ip = *(int*)(addr);
80104c14:	8b 13                	mov    (%ebx),%edx
80104c16:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c19:	89 10                	mov    %edx,(%eax)
  return 0;
80104c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c20:	83 c4 04             	add    $0x4,%esp
80104c23:	5b                   	pop    %ebx
80104c24:	5d                   	pop    %ebp
80104c25:	c3                   	ret    
    return -1;
80104c26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c2b:	eb f3                	jmp    80104c20 <fetchint+0x28>
80104c2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c32:	eb ec                	jmp    80104c20 <fetchint+0x28>

80104c34 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	53                   	push   %ebx
80104c38:	83 ec 04             	sub    $0x4,%esp
80104c3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c3e:	e8 3e e9 ff ff       	call   80103581 <myproc>

  if(addr >= curproc->sz)
80104c43:	39 18                	cmp    %ebx,(%eax)
80104c45:	76 2f                	jbe    80104c76 <fetchstr+0x42>
    return -1;
  *pp = (char*)addr;
80104c47:	89 da                	mov    %ebx,%edx
80104c49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104c4c:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104c4e:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104c50:	39 c3                	cmp    %eax,%ebx
80104c52:	73 29                	jae    80104c7d <fetchstr+0x49>
    if(*s == 0)
80104c54:	80 3b 00             	cmpb   $0x0,(%ebx)
80104c57:	74 0c                	je     80104c65 <fetchstr+0x31>
  for(s = *pp; s < ep; s++){
80104c59:	83 c2 01             	add    $0x1,%edx
80104c5c:	39 d0                	cmp    %edx,%eax
80104c5e:	76 0f                	jbe    80104c6f <fetchstr+0x3b>
    if(*s == 0)
80104c60:	80 3a 00             	cmpb   $0x0,(%edx)
80104c63:	75 f4                	jne    80104c59 <fetchstr+0x25>
      return s - *pp;
80104c65:	89 d0                	mov    %edx,%eax
80104c67:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c69:	83 c4 04             	add    $0x4,%esp
80104c6c:	5b                   	pop    %ebx
80104c6d:	5d                   	pop    %ebp
80104c6e:	c3                   	ret    
  return -1;
80104c6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c74:	eb f3                	jmp    80104c69 <fetchstr+0x35>
    return -1;
80104c76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c7b:	eb ec                	jmp    80104c69 <fetchstr+0x35>
  return -1;
80104c7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c82:	eb e5                	jmp    80104c69 <fetchstr+0x35>

80104c84 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c84:	55                   	push   %ebp
80104c85:	89 e5                	mov    %esp,%ebp
80104c87:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c8a:	e8 f2 e8 ff ff       	call   80103581 <myproc>
80104c8f:	83 ec 08             	sub    $0x8,%esp
80104c92:	ff 75 0c             	pushl  0xc(%ebp)
80104c95:	8b 40 18             	mov    0x18(%eax),%eax
80104c98:	8b 40 44             	mov    0x44(%eax),%eax
80104c9b:	8b 55 08             	mov    0x8(%ebp),%edx
80104c9e:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
80104ca2:	50                   	push   %eax
80104ca3:	e8 50 ff ff ff       	call   80104bf8 <fetchint>
}
80104ca8:	c9                   	leave  
80104ca9:	c3                   	ret    

80104caa <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104caa:	55                   	push   %ebp
80104cab:	89 e5                	mov    %esp,%ebp
80104cad:	56                   	push   %esi
80104cae:	53                   	push   %ebx
80104caf:	83 ec 10             	sub    $0x10,%esp
80104cb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104cb5:	e8 c7 e8 ff ff       	call   80103581 <myproc>
80104cba:	89 c6                	mov    %eax,%esi

  if(argint(n, &i) < 0)
80104cbc:	83 ec 08             	sub    $0x8,%esp
80104cbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cc2:	50                   	push   %eax
80104cc3:	ff 75 08             	pushl  0x8(%ebp)
80104cc6:	e8 b9 ff ff ff       	call   80104c84 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ccb:	83 c4 10             	add    $0x10,%esp
80104cce:	85 db                	test   %ebx,%ebx
80104cd0:	78 24                	js     80104cf6 <argptr+0x4c>
80104cd2:	85 c0                	test   %eax,%eax
80104cd4:	78 20                	js     80104cf6 <argptr+0x4c>
80104cd6:	8b 16                	mov    (%esi),%edx
80104cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cdb:	39 c2                	cmp    %eax,%edx
80104cdd:	76 1e                	jbe    80104cfd <argptr+0x53>
80104cdf:	01 c3                	add    %eax,%ebx
80104ce1:	39 da                	cmp    %ebx,%edx
80104ce3:	72 1f                	jb     80104d04 <argptr+0x5a>
    return -1;
  *pp = (char*)i;
80104ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ce8:	89 02                	mov    %eax,(%edx)
  return 0;
80104cea:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cf2:	5b                   	pop    %ebx
80104cf3:	5e                   	pop    %esi
80104cf4:	5d                   	pop    %ebp
80104cf5:	c3                   	ret    
    return -1;
80104cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cfb:	eb f2                	jmp    80104cef <argptr+0x45>
80104cfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d02:	eb eb                	jmp    80104cef <argptr+0x45>
80104d04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d09:	eb e4                	jmp    80104cef <argptr+0x45>

80104d0b <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d0b:	55                   	push   %ebp
80104d0c:	89 e5                	mov    %esp,%ebp
80104d0e:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d11:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d14:	50                   	push   %eax
80104d15:	ff 75 08             	pushl  0x8(%ebp)
80104d18:	e8 67 ff ff ff       	call   80104c84 <argint>
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	85 c0                	test   %eax,%eax
80104d22:	78 13                	js     80104d37 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80104d24:	83 ec 08             	sub    $0x8,%esp
80104d27:	ff 75 0c             	pushl  0xc(%ebp)
80104d2a:	ff 75 f4             	pushl  -0xc(%ebp)
80104d2d:	e8 02 ff ff ff       	call   80104c34 <fetchstr>
80104d32:	83 c4 10             	add    $0x10,%esp
}
80104d35:	c9                   	leave  
80104d36:	c3                   	ret    
    return -1;
80104d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d3c:	eb f7                	jmp    80104d35 <argstr+0x2a>

80104d3e <syscall>:
};
#endif // PRINT_SYSCALLS

void
syscall(void)
{
80104d3e:	55                   	push   %ebp
80104d3f:	89 e5                	mov    %esp,%ebp
80104d41:	53                   	push   %ebx
80104d42:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d45:	e8 37 e8 ff ff       	call   80103581 <myproc>
80104d4a:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d4c:	8b 40 18             	mov    0x18(%eax),%eax
80104d4f:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d52:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d55:	83 fa 1c             	cmp    $0x1c,%edx
80104d58:	77 18                	ja     80104d72 <syscall+0x34>
80104d5a:	8b 14 85 20 7b 10 80 	mov    -0x7fef84e0(,%eax,4),%edx
80104d61:	85 d2                	test   %edx,%edx
80104d63:	74 0d                	je     80104d72 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
80104d65:	ff d2                	call   *%edx
80104d67:	8b 53 18             	mov    0x18(%ebx),%edx
80104d6a:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d70:	c9                   	leave  
80104d71:	c3                   	ret    
    cprintf("%d %s: unknown sys call %d\n",
80104d72:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d73:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d76:	50                   	push   %eax
80104d77:	ff 73 10             	pushl  0x10(%ebx)
80104d7a:	68 f1 7a 10 80       	push   $0x80107af1
80104d7f:	e8 5d b8 ff ff       	call   801005e1 <cprintf>
    curproc->tf->eax = -1;
80104d84:	8b 43 18             	mov    0x18(%ebx),%eax
80104d87:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104d8e:	83 c4 10             	add    $0x10,%esp
}
80104d91:	eb da                	jmp    80104d6d <syscall+0x2f>

80104d93 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104d93:	55                   	push   %ebp
80104d94:	89 e5                	mov    %esp,%ebp
80104d96:	56                   	push   %esi
80104d97:	53                   	push   %ebx
80104d98:	83 ec 18             	sub    $0x18,%esp
80104d9b:	89 d6                	mov    %edx,%esi
80104d9d:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104d9f:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104da2:	52                   	push   %edx
80104da3:	50                   	push   %eax
80104da4:	e8 db fe ff ff       	call   80104c84 <argint>
80104da9:	83 c4 10             	add    $0x10,%esp
80104dac:	85 c0                	test   %eax,%eax
80104dae:	78 2e                	js     80104dde <argfd+0x4b>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104db0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104db4:	77 2f                	ja     80104de5 <argfd+0x52>
80104db6:	e8 c6 e7 ff ff       	call   80103581 <myproc>
80104dbb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104dbe:	8b 54 88 28          	mov    0x28(%eax,%ecx,4),%edx
80104dc2:	85 d2                	test   %edx,%edx
80104dc4:	74 26                	je     80104dec <argfd+0x59>
    return -1;
  if(pfd)
80104dc6:	85 f6                	test   %esi,%esi
80104dc8:	74 02                	je     80104dcc <argfd+0x39>
    *pfd = fd;
80104dca:	89 0e                	mov    %ecx,(%esi)
  if(pf)
    *pf = f;
  return 0;
80104dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  if(pf)
80104dd1:	85 db                	test   %ebx,%ebx
80104dd3:	74 02                	je     80104dd7 <argfd+0x44>
    *pf = f;
80104dd5:	89 13                	mov    %edx,(%ebx)
}
80104dd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dda:	5b                   	pop    %ebx
80104ddb:	5e                   	pop    %esi
80104ddc:	5d                   	pop    %ebp
80104ddd:	c3                   	ret    
    return -1;
80104dde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de3:	eb f2                	jmp    80104dd7 <argfd+0x44>
    return -1;
80104de5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dea:	eb eb                	jmp    80104dd7 <argfd+0x44>
80104dec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104df1:	eb e4                	jmp    80104dd7 <argfd+0x44>

80104df3 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104df3:	55                   	push   %ebp
80104df4:	89 e5                	mov    %esp,%ebp
80104df6:	53                   	push   %ebx
80104df7:	83 ec 04             	sub    $0x4,%esp
80104dfa:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104dfc:	e8 80 e7 ff ff       	call   80103581 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104e01:	83 78 28 00          	cmpl   $0x0,0x28(%eax)
80104e05:	74 1b                	je     80104e22 <fdalloc+0x2f>
  for(fd = 0; fd < NOFILE; fd++){
80104e07:	ba 01 00 00 00       	mov    $0x1,%edx
    if(curproc->ofile[fd] == 0){
80104e0c:	83 7c 90 28 00       	cmpl   $0x0,0x28(%eax,%edx,4)
80104e11:	74 14                	je     80104e27 <fdalloc+0x34>
  for(fd = 0; fd < NOFILE; fd++){
80104e13:	83 c2 01             	add    $0x1,%edx
80104e16:	83 fa 10             	cmp    $0x10,%edx
80104e19:	75 f1                	jne    80104e0c <fdalloc+0x19>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80104e1b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80104e20:	eb 09                	jmp    80104e2b <fdalloc+0x38>
  for(fd = 0; fd < NOFILE; fd++){
80104e22:	ba 00 00 00 00       	mov    $0x0,%edx
      curproc->ofile[fd] = f;
80104e27:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
80104e2b:	89 d0                	mov    %edx,%eax
80104e2d:	83 c4 04             	add    $0x4,%esp
80104e30:	5b                   	pop    %ebx
80104e31:	5d                   	pop    %ebp
80104e32:	c3                   	ret    

80104e33 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e33:	55                   	push   %ebp
80104e34:	89 e5                	mov    %esp,%ebp
80104e36:	57                   	push   %edi
80104e37:	56                   	push   %esi
80104e38:	53                   	push   %ebx
80104e39:	83 ec 44             	sub    $0x44,%esp
80104e3c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104e3f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104e42:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e45:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80104e48:	52                   	push   %edx
80104e49:	50                   	push   %eax
80104e4a:	e8 d3 ce ff ff       	call   80101d22 <nameiparent>
80104e4f:	89 c6                	mov    %eax,%esi
80104e51:	83 c4 10             	add    $0x10,%esp
80104e54:	85 c0                	test   %eax,%eax
80104e56:	0f 84 34 01 00 00    	je     80104f90 <create+0x15d>
    return 0;
  ilock(dp);
80104e5c:	83 ec 0c             	sub    $0xc,%esp
80104e5f:	50                   	push   %eax
80104e60:	e8 08 c7 ff ff       	call   8010156d <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104e65:	83 c4 0c             	add    $0xc,%esp
80104e68:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e6b:	50                   	push   %eax
80104e6c:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104e6f:	50                   	push   %eax
80104e70:	56                   	push   %esi
80104e71:	e8 bd cb ff ff       	call   80101a33 <dirlookup>
80104e76:	89 c3                	mov    %eax,%ebx
80104e78:	83 c4 10             	add    $0x10,%esp
80104e7b:	85 c0                	test   %eax,%eax
80104e7d:	74 3f                	je     80104ebe <create+0x8b>
    iunlockput(dp);
80104e7f:	83 ec 0c             	sub    $0xc,%esp
80104e82:	56                   	push   %esi
80104e83:	e8 2e c9 ff ff       	call   801017b6 <iunlockput>
    ilock(ip);
80104e88:	89 1c 24             	mov    %ebx,(%esp)
80104e8b:	e8 dd c6 ff ff       	call   8010156d <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e90:	83 c4 10             	add    $0x10,%esp
80104e93:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104e98:	75 11                	jne    80104eab <create+0x78>
80104e9a:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104e9f:	75 0a                	jne    80104eab <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ea1:	89 d8                	mov    %ebx,%eax
80104ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ea6:	5b                   	pop    %ebx
80104ea7:	5e                   	pop    %esi
80104ea8:	5f                   	pop    %edi
80104ea9:	5d                   	pop    %ebp
80104eaa:	c3                   	ret    
    iunlockput(ip);
80104eab:	83 ec 0c             	sub    $0xc,%esp
80104eae:	53                   	push   %ebx
80104eaf:	e8 02 c9 ff ff       	call   801017b6 <iunlockput>
    return 0;
80104eb4:	83 c4 10             	add    $0x10,%esp
80104eb7:	bb 00 00 00 00       	mov    $0x0,%ebx
80104ebc:	eb e3                	jmp    80104ea1 <create+0x6e>
  if((ip = ialloc(dp->dev, type)) == 0)
80104ebe:	83 ec 08             	sub    $0x8,%esp
80104ec1:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ec5:	50                   	push   %eax
80104ec6:	ff 36                	pushl  (%esi)
80104ec8:	e8 4d c5 ff ff       	call   8010141a <ialloc>
80104ecd:	89 c3                	mov    %eax,%ebx
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	74 55                	je     80104f2b <create+0xf8>
  ilock(ip);
80104ed6:	83 ec 0c             	sub    $0xc,%esp
80104ed9:	50                   	push   %eax
80104eda:	e8 8e c6 ff ff       	call   8010156d <ilock>
  ip->major = major;
80104edf:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104ee3:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104ee7:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
80104eeb:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ef1:	89 1c 24             	mov    %ebx,(%esp)
80104ef4:	e8 ca c5 ff ff       	call   801014c3 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ef9:	83 c4 10             	add    $0x10,%esp
80104efc:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104f01:	74 35                	je     80104f38 <create+0x105>
  if(dirlink(dp, name, ip->inum) < 0)
80104f03:	83 ec 04             	sub    $0x4,%esp
80104f06:	ff 73 04             	pushl  0x4(%ebx)
80104f09:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104f0c:	50                   	push   %eax
80104f0d:	56                   	push   %esi
80104f0e:	e8 42 cd ff ff       	call   80101c55 <dirlink>
80104f13:	83 c4 10             	add    $0x10,%esp
80104f16:	85 c0                	test   %eax,%eax
80104f18:	78 69                	js     80104f83 <create+0x150>
  iunlockput(dp);
80104f1a:	83 ec 0c             	sub    $0xc,%esp
80104f1d:	56                   	push   %esi
80104f1e:	e8 93 c8 ff ff       	call   801017b6 <iunlockput>
  return ip;
80104f23:	83 c4 10             	add    $0x10,%esp
80104f26:	e9 76 ff ff ff       	jmp    80104ea1 <create+0x6e>
    panic("create: ialloc");
80104f2b:	83 ec 0c             	sub    $0xc,%esp
80104f2e:	68 98 7b 10 80       	push   $0x80107b98
80104f33:	e8 0c b4 ff ff       	call   80100344 <panic>
    dp->nlink++;  // for ".."
80104f38:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104f3d:	83 ec 0c             	sub    $0xc,%esp
80104f40:	56                   	push   %esi
80104f41:	e8 7d c5 ff ff       	call   801014c3 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f46:	83 c4 0c             	add    $0xc,%esp
80104f49:	ff 73 04             	pushl  0x4(%ebx)
80104f4c:	68 a8 7b 10 80       	push   $0x80107ba8
80104f51:	53                   	push   %ebx
80104f52:	e8 fe cc ff ff       	call   80101c55 <dirlink>
80104f57:	83 c4 10             	add    $0x10,%esp
80104f5a:	85 c0                	test   %eax,%eax
80104f5c:	78 18                	js     80104f76 <create+0x143>
80104f5e:	83 ec 04             	sub    $0x4,%esp
80104f61:	ff 76 04             	pushl  0x4(%esi)
80104f64:	68 a7 7b 10 80       	push   $0x80107ba7
80104f69:	53                   	push   %ebx
80104f6a:	e8 e6 cc ff ff       	call   80101c55 <dirlink>
80104f6f:	83 c4 10             	add    $0x10,%esp
80104f72:	85 c0                	test   %eax,%eax
80104f74:	79 8d                	jns    80104f03 <create+0xd0>
      panic("create dots");
80104f76:	83 ec 0c             	sub    $0xc,%esp
80104f79:	68 aa 7b 10 80       	push   $0x80107baa
80104f7e:	e8 c1 b3 ff ff       	call   80100344 <panic>
    panic("create: dirlink");
80104f83:	83 ec 0c             	sub    $0xc,%esp
80104f86:	68 b6 7b 10 80       	push   $0x80107bb6
80104f8b:	e8 b4 b3 ff ff       	call   80100344 <panic>
    return 0;
80104f90:	89 c3                	mov    %eax,%ebx
80104f92:	e9 0a ff ff ff       	jmp    80104ea1 <create+0x6e>

80104f97 <sys_dup>:
{
80104f97:	55                   	push   %ebp
80104f98:	89 e5                	mov    %esp,%ebp
80104f9a:	53                   	push   %ebx
80104f9b:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
80104f9e:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104fa1:	ba 00 00 00 00       	mov    $0x0,%edx
80104fa6:	b8 00 00 00 00       	mov    $0x0,%eax
80104fab:	e8 e3 fd ff ff       	call   80104d93 <argfd>
80104fb0:	85 c0                	test   %eax,%eax
80104fb2:	78 23                	js     80104fd7 <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
80104fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fb7:	e8 37 fe ff ff       	call   80104df3 <fdalloc>
80104fbc:	89 c3                	mov    %eax,%ebx
80104fbe:	85 c0                	test   %eax,%eax
80104fc0:	78 1c                	js     80104fde <sys_dup+0x47>
  filedup(f);
80104fc2:	83 ec 0c             	sub    $0xc,%esp
80104fc5:	ff 75 f4             	pushl  -0xc(%ebp)
80104fc8:	e8 8f bd ff ff       	call   80100d5c <filedup>
  return fd;
80104fcd:	83 c4 10             	add    $0x10,%esp
}
80104fd0:	89 d8                	mov    %ebx,%eax
80104fd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fd5:	c9                   	leave  
80104fd6:	c3                   	ret    
    return -1;
80104fd7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104fdc:	eb f2                	jmp    80104fd0 <sys_dup+0x39>
    return -1;
80104fde:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104fe3:	eb eb                	jmp    80104fd0 <sys_dup+0x39>

80104fe5 <sys_read>:
{
80104fe5:	55                   	push   %ebp
80104fe6:	89 e5                	mov    %esp,%ebp
80104fe8:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104feb:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104fee:	ba 00 00 00 00       	mov    $0x0,%edx
80104ff3:	b8 00 00 00 00       	mov    $0x0,%eax
80104ff8:	e8 96 fd ff ff       	call   80104d93 <argfd>
80104ffd:	85 c0                	test   %eax,%eax
80104fff:	78 43                	js     80105044 <sys_read+0x5f>
80105001:	83 ec 08             	sub    $0x8,%esp
80105004:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105007:	50                   	push   %eax
80105008:	6a 02                	push   $0x2
8010500a:	e8 75 fc ff ff       	call   80104c84 <argint>
8010500f:	83 c4 10             	add    $0x10,%esp
80105012:	85 c0                	test   %eax,%eax
80105014:	78 35                	js     8010504b <sys_read+0x66>
80105016:	83 ec 04             	sub    $0x4,%esp
80105019:	ff 75 f0             	pushl  -0x10(%ebp)
8010501c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010501f:	50                   	push   %eax
80105020:	6a 01                	push   $0x1
80105022:	e8 83 fc ff ff       	call   80104caa <argptr>
80105027:	83 c4 10             	add    $0x10,%esp
8010502a:	85 c0                	test   %eax,%eax
8010502c:	78 24                	js     80105052 <sys_read+0x6d>
  return fileread(f, p, n);
8010502e:	83 ec 04             	sub    $0x4,%esp
80105031:	ff 75 f0             	pushl  -0x10(%ebp)
80105034:	ff 75 ec             	pushl  -0x14(%ebp)
80105037:	ff 75 f4             	pushl  -0xc(%ebp)
8010503a:	e8 5e be ff ff       	call   80100e9d <fileread>
8010503f:	83 c4 10             	add    $0x10,%esp
}
80105042:	c9                   	leave  
80105043:	c3                   	ret    
    return -1;
80105044:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105049:	eb f7                	jmp    80105042 <sys_read+0x5d>
8010504b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105050:	eb f0                	jmp    80105042 <sys_read+0x5d>
80105052:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105057:	eb e9                	jmp    80105042 <sys_read+0x5d>

80105059 <sys_write>:
{
80105059:	55                   	push   %ebp
8010505a:	89 e5                	mov    %esp,%ebp
8010505c:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010505f:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80105062:	ba 00 00 00 00       	mov    $0x0,%edx
80105067:	b8 00 00 00 00       	mov    $0x0,%eax
8010506c:	e8 22 fd ff ff       	call   80104d93 <argfd>
80105071:	85 c0                	test   %eax,%eax
80105073:	78 43                	js     801050b8 <sys_write+0x5f>
80105075:	83 ec 08             	sub    $0x8,%esp
80105078:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010507b:	50                   	push   %eax
8010507c:	6a 02                	push   $0x2
8010507e:	e8 01 fc ff ff       	call   80104c84 <argint>
80105083:	83 c4 10             	add    $0x10,%esp
80105086:	85 c0                	test   %eax,%eax
80105088:	78 35                	js     801050bf <sys_write+0x66>
8010508a:	83 ec 04             	sub    $0x4,%esp
8010508d:	ff 75 f0             	pushl  -0x10(%ebp)
80105090:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105093:	50                   	push   %eax
80105094:	6a 01                	push   $0x1
80105096:	e8 0f fc ff ff       	call   80104caa <argptr>
8010509b:	83 c4 10             	add    $0x10,%esp
8010509e:	85 c0                	test   %eax,%eax
801050a0:	78 24                	js     801050c6 <sys_write+0x6d>
  return filewrite(f, p, n);
801050a2:	83 ec 04             	sub    $0x4,%esp
801050a5:	ff 75 f0             	pushl  -0x10(%ebp)
801050a8:	ff 75 ec             	pushl  -0x14(%ebp)
801050ab:	ff 75 f4             	pushl  -0xc(%ebp)
801050ae:	e8 6f be ff ff       	call   80100f22 <filewrite>
801050b3:	83 c4 10             	add    $0x10,%esp
}
801050b6:	c9                   	leave  
801050b7:	c3                   	ret    
    return -1;
801050b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050bd:	eb f7                	jmp    801050b6 <sys_write+0x5d>
801050bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c4:	eb f0                	jmp    801050b6 <sys_write+0x5d>
801050c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050cb:	eb e9                	jmp    801050b6 <sys_write+0x5d>

801050cd <sys_close>:
{
801050cd:	55                   	push   %ebp
801050ce:	89 e5                	mov    %esp,%ebp
801050d0:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801050d3:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801050d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801050d9:	b8 00 00 00 00       	mov    $0x0,%eax
801050de:	e8 b0 fc ff ff       	call   80104d93 <argfd>
801050e3:	85 c0                	test   %eax,%eax
801050e5:	78 25                	js     8010510c <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
801050e7:	e8 95 e4 ff ff       	call   80103581 <myproc>
801050ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050ef:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801050f6:	00 
  fileclose(f);
801050f7:	83 ec 0c             	sub    $0xc,%esp
801050fa:	ff 75 f0             	pushl  -0x10(%ebp)
801050fd:	e8 9f bc ff ff       	call   80100da1 <fileclose>
  return 0;
80105102:	83 c4 10             	add    $0x10,%esp
80105105:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010510a:	c9                   	leave  
8010510b:	c3                   	ret    
    return -1;
8010510c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105111:	eb f7                	jmp    8010510a <sys_close+0x3d>

80105113 <sys_fstat>:
{
80105113:	55                   	push   %ebp
80105114:	89 e5                	mov    %esp,%ebp
80105116:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105119:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010511c:	ba 00 00 00 00       	mov    $0x0,%edx
80105121:	b8 00 00 00 00       	mov    $0x0,%eax
80105126:	e8 68 fc ff ff       	call   80104d93 <argfd>
8010512b:	85 c0                	test   %eax,%eax
8010512d:	78 2a                	js     80105159 <sys_fstat+0x46>
8010512f:	83 ec 04             	sub    $0x4,%esp
80105132:	6a 14                	push   $0x14
80105134:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105137:	50                   	push   %eax
80105138:	6a 01                	push   $0x1
8010513a:	e8 6b fb ff ff       	call   80104caa <argptr>
8010513f:	83 c4 10             	add    $0x10,%esp
80105142:	85 c0                	test   %eax,%eax
80105144:	78 1a                	js     80105160 <sys_fstat+0x4d>
  return filestat(f, st);
80105146:	83 ec 08             	sub    $0x8,%esp
80105149:	ff 75 f0             	pushl  -0x10(%ebp)
8010514c:	ff 75 f4             	pushl  -0xc(%ebp)
8010514f:	e8 02 bd ff ff       	call   80100e56 <filestat>
80105154:	83 c4 10             	add    $0x10,%esp
}
80105157:	c9                   	leave  
80105158:	c3                   	ret    
    return -1;
80105159:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010515e:	eb f7                	jmp    80105157 <sys_fstat+0x44>
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105165:	eb f0                	jmp    80105157 <sys_fstat+0x44>

80105167 <sys_link>:
{
80105167:	55                   	push   %ebp
80105168:	89 e5                	mov    %esp,%ebp
8010516a:	56                   	push   %esi
8010516b:	53                   	push   %ebx
8010516c:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010516f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105172:	50                   	push   %eax
80105173:	6a 00                	push   $0x0
80105175:	e8 91 fb ff ff       	call   80104d0b <argstr>
8010517a:	83 c4 10             	add    $0x10,%esp
8010517d:	85 c0                	test   %eax,%eax
8010517f:	0f 88 26 01 00 00    	js     801052ab <sys_link+0x144>
80105185:	83 ec 08             	sub    $0x8,%esp
80105188:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010518b:	50                   	push   %eax
8010518c:	6a 01                	push   $0x1
8010518e:	e8 78 fb ff ff       	call   80104d0b <argstr>
80105193:	83 c4 10             	add    $0x10,%esp
80105196:	85 c0                	test   %eax,%eax
80105198:	0f 88 14 01 00 00    	js     801052b2 <sys_link+0x14b>
  begin_op();
8010519e:	e8 91 d6 ff ff       	call   80102834 <begin_op>
  if((ip = namei(old)) == 0){
801051a3:	83 ec 0c             	sub    $0xc,%esp
801051a6:	ff 75 e0             	pushl  -0x20(%ebp)
801051a9:	e8 5c cb ff ff       	call   80101d0a <namei>
801051ae:	89 c3                	mov    %eax,%ebx
801051b0:	83 c4 10             	add    $0x10,%esp
801051b3:	85 c0                	test   %eax,%eax
801051b5:	0f 84 93 00 00 00    	je     8010524e <sys_link+0xe7>
  ilock(ip);
801051bb:	83 ec 0c             	sub    $0xc,%esp
801051be:	50                   	push   %eax
801051bf:	e8 a9 c3 ff ff       	call   8010156d <ilock>
  if(ip->type == T_DIR){
801051c4:	83 c4 10             	add    $0x10,%esp
801051c7:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051cc:	0f 84 88 00 00 00    	je     8010525a <sys_link+0xf3>
  ip->nlink++;
801051d2:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801051d7:	83 ec 0c             	sub    $0xc,%esp
801051da:	53                   	push   %ebx
801051db:	e8 e3 c2 ff ff       	call   801014c3 <iupdate>
  iunlock(ip);
801051e0:	89 1c 24             	mov    %ebx,(%esp)
801051e3:	e8 47 c4 ff ff       	call   8010162f <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051e8:	83 c4 08             	add    $0x8,%esp
801051eb:	8d 45 ea             	lea    -0x16(%ebp),%eax
801051ee:	50                   	push   %eax
801051ef:	ff 75 e4             	pushl  -0x1c(%ebp)
801051f2:	e8 2b cb ff ff       	call   80101d22 <nameiparent>
801051f7:	89 c6                	mov    %eax,%esi
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	85 c0                	test   %eax,%eax
801051fe:	74 7e                	je     8010527e <sys_link+0x117>
  ilock(dp);
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	50                   	push   %eax
80105204:	e8 64 c3 ff ff       	call   8010156d <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105209:	83 c4 10             	add    $0x10,%esp
8010520c:	8b 03                	mov    (%ebx),%eax
8010520e:	39 06                	cmp    %eax,(%esi)
80105210:	75 60                	jne    80105272 <sys_link+0x10b>
80105212:	83 ec 04             	sub    $0x4,%esp
80105215:	ff 73 04             	pushl  0x4(%ebx)
80105218:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010521b:	50                   	push   %eax
8010521c:	56                   	push   %esi
8010521d:	e8 33 ca ff ff       	call   80101c55 <dirlink>
80105222:	83 c4 10             	add    $0x10,%esp
80105225:	85 c0                	test   %eax,%eax
80105227:	78 49                	js     80105272 <sys_link+0x10b>
  iunlockput(dp);
80105229:	83 ec 0c             	sub    $0xc,%esp
8010522c:	56                   	push   %esi
8010522d:	e8 84 c5 ff ff       	call   801017b6 <iunlockput>
  iput(ip);
80105232:	89 1c 24             	mov    %ebx,(%esp)
80105235:	e8 3a c4 ff ff       	call   80101674 <iput>
  end_op();
8010523a:	e8 70 d6 ff ff       	call   801028af <end_op>
  return 0;
8010523f:	83 c4 10             	add    $0x10,%esp
80105242:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105247:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010524a:	5b                   	pop    %ebx
8010524b:	5e                   	pop    %esi
8010524c:	5d                   	pop    %ebp
8010524d:	c3                   	ret    
    end_op();
8010524e:	e8 5c d6 ff ff       	call   801028af <end_op>
    return -1;
80105253:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105258:	eb ed                	jmp    80105247 <sys_link+0xe0>
    iunlockput(ip);
8010525a:	83 ec 0c             	sub    $0xc,%esp
8010525d:	53                   	push   %ebx
8010525e:	e8 53 c5 ff ff       	call   801017b6 <iunlockput>
    end_op();
80105263:	e8 47 d6 ff ff       	call   801028af <end_op>
    return -1;
80105268:	83 c4 10             	add    $0x10,%esp
8010526b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105270:	eb d5                	jmp    80105247 <sys_link+0xe0>
    iunlockput(dp);
80105272:	83 ec 0c             	sub    $0xc,%esp
80105275:	56                   	push   %esi
80105276:	e8 3b c5 ff ff       	call   801017b6 <iunlockput>
    goto bad;
8010527b:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010527e:	83 ec 0c             	sub    $0xc,%esp
80105281:	53                   	push   %ebx
80105282:	e8 e6 c2 ff ff       	call   8010156d <ilock>
  ip->nlink--;
80105287:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010528c:	89 1c 24             	mov    %ebx,(%esp)
8010528f:	e8 2f c2 ff ff       	call   801014c3 <iupdate>
  iunlockput(ip);
80105294:	89 1c 24             	mov    %ebx,(%esp)
80105297:	e8 1a c5 ff ff       	call   801017b6 <iunlockput>
  end_op();
8010529c:	e8 0e d6 ff ff       	call   801028af <end_op>
  return -1;
801052a1:	83 c4 10             	add    $0x10,%esp
801052a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a9:	eb 9c                	jmp    80105247 <sys_link+0xe0>
    return -1;
801052ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b0:	eb 95                	jmp    80105247 <sys_link+0xe0>
801052b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b7:	eb 8e                	jmp    80105247 <sys_link+0xe0>

801052b9 <sys_unlink>:
{
801052b9:	55                   	push   %ebp
801052ba:	89 e5                	mov    %esp,%ebp
801052bc:	57                   	push   %edi
801052bd:	56                   	push   %esi
801052be:	53                   	push   %ebx
801052bf:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801052c2:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052c5:	50                   	push   %eax
801052c6:	6a 00                	push   $0x0
801052c8:	e8 3e fa ff ff       	call   80104d0b <argstr>
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	85 c0                	test   %eax,%eax
801052d2:	0f 88 81 01 00 00    	js     80105459 <sys_unlink+0x1a0>
  begin_op();
801052d8:	e8 57 d5 ff ff       	call   80102834 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052dd:	83 ec 08             	sub    $0x8,%esp
801052e0:	8d 45 ca             	lea    -0x36(%ebp),%eax
801052e3:	50                   	push   %eax
801052e4:	ff 75 c4             	pushl  -0x3c(%ebp)
801052e7:	e8 36 ca ff ff       	call   80101d22 <nameiparent>
801052ec:	89 c7                	mov    %eax,%edi
801052ee:	83 c4 10             	add    $0x10,%esp
801052f1:	85 c0                	test   %eax,%eax
801052f3:	0f 84 df 00 00 00    	je     801053d8 <sys_unlink+0x11f>
  ilock(dp);
801052f9:	83 ec 0c             	sub    $0xc,%esp
801052fc:	50                   	push   %eax
801052fd:	e8 6b c2 ff ff       	call   8010156d <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105302:	83 c4 08             	add    $0x8,%esp
80105305:	68 a8 7b 10 80       	push   $0x80107ba8
8010530a:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010530d:	50                   	push   %eax
8010530e:	e8 0b c7 ff ff       	call   80101a1e <namecmp>
80105313:	83 c4 10             	add    $0x10,%esp
80105316:	85 c0                	test   %eax,%eax
80105318:	0f 84 51 01 00 00    	je     8010546f <sys_unlink+0x1b6>
8010531e:	83 ec 08             	sub    $0x8,%esp
80105321:	68 a7 7b 10 80       	push   $0x80107ba7
80105326:	8d 45 ca             	lea    -0x36(%ebp),%eax
80105329:	50                   	push   %eax
8010532a:	e8 ef c6 ff ff       	call   80101a1e <namecmp>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	85 c0                	test   %eax,%eax
80105334:	0f 84 35 01 00 00    	je     8010546f <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010533a:	83 ec 04             	sub    $0x4,%esp
8010533d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105340:	50                   	push   %eax
80105341:	8d 45 ca             	lea    -0x36(%ebp),%eax
80105344:	50                   	push   %eax
80105345:	57                   	push   %edi
80105346:	e8 e8 c6 ff ff       	call   80101a33 <dirlookup>
8010534b:	89 c3                	mov    %eax,%ebx
8010534d:	83 c4 10             	add    $0x10,%esp
80105350:	85 c0                	test   %eax,%eax
80105352:	0f 84 17 01 00 00    	je     8010546f <sys_unlink+0x1b6>
  ilock(ip);
80105358:	83 ec 0c             	sub    $0xc,%esp
8010535b:	50                   	push   %eax
8010535c:	e8 0c c2 ff ff       	call   8010156d <ilock>
  if(ip->nlink < 1)
80105361:	83 c4 10             	add    $0x10,%esp
80105364:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105369:	7e 79                	jle    801053e4 <sys_unlink+0x12b>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010536b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105370:	74 7f                	je     801053f1 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80105372:	83 ec 04             	sub    $0x4,%esp
80105375:	6a 10                	push   $0x10
80105377:	6a 00                	push   $0x0
80105379:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010537c:	56                   	push   %esi
8010537d:	e8 7c f6 ff ff       	call   801049fe <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105382:	6a 10                	push   $0x10
80105384:	ff 75 c0             	pushl  -0x40(%ebp)
80105387:	56                   	push   %esi
80105388:	57                   	push   %edi
80105389:	e8 6f c5 ff ff       	call   801018fd <writei>
8010538e:	83 c4 20             	add    $0x20,%esp
80105391:	83 f8 10             	cmp    $0x10,%eax
80105394:	0f 85 9c 00 00 00    	jne    80105436 <sys_unlink+0x17d>
  if(ip->type == T_DIR){
8010539a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010539f:	0f 84 9e 00 00 00    	je     80105443 <sys_unlink+0x18a>
  iunlockput(dp);
801053a5:	83 ec 0c             	sub    $0xc,%esp
801053a8:	57                   	push   %edi
801053a9:	e8 08 c4 ff ff       	call   801017b6 <iunlockput>
  ip->nlink--;
801053ae:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053b3:	89 1c 24             	mov    %ebx,(%esp)
801053b6:	e8 08 c1 ff ff       	call   801014c3 <iupdate>
  iunlockput(ip);
801053bb:	89 1c 24             	mov    %ebx,(%esp)
801053be:	e8 f3 c3 ff ff       	call   801017b6 <iunlockput>
  end_op();
801053c3:	e8 e7 d4 ff ff       	call   801028af <end_op>
  return 0;
801053c8:	83 c4 10             	add    $0x10,%esp
801053cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d3:	5b                   	pop    %ebx
801053d4:	5e                   	pop    %esi
801053d5:	5f                   	pop    %edi
801053d6:	5d                   	pop    %ebp
801053d7:	c3                   	ret    
    end_op();
801053d8:	e8 d2 d4 ff ff       	call   801028af <end_op>
    return -1;
801053dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e2:	eb ec                	jmp    801053d0 <sys_unlink+0x117>
    panic("unlink: nlink < 1");
801053e4:	83 ec 0c             	sub    $0xc,%esp
801053e7:	68 c6 7b 10 80       	push   $0x80107bc6
801053ec:	e8 53 af ff ff       	call   80100344 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053f1:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053f5:	0f 86 77 ff ff ff    	jbe    80105372 <sys_unlink+0xb9>
801053fb:	be 20 00 00 00       	mov    $0x20,%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105400:	6a 10                	push   $0x10
80105402:	56                   	push   %esi
80105403:	8d 45 b0             	lea    -0x50(%ebp),%eax
80105406:	50                   	push   %eax
80105407:	53                   	push   %ebx
80105408:	e8 f4 c3 ff ff       	call   80101801 <readi>
8010540d:	83 c4 10             	add    $0x10,%esp
80105410:	83 f8 10             	cmp    $0x10,%eax
80105413:	75 14                	jne    80105429 <sys_unlink+0x170>
    if(de.inum != 0)
80105415:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
8010541a:	75 47                	jne    80105463 <sys_unlink+0x1aa>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010541c:	83 c6 10             	add    $0x10,%esi
8010541f:	3b 73 58             	cmp    0x58(%ebx),%esi
80105422:	72 dc                	jb     80105400 <sys_unlink+0x147>
80105424:	e9 49 ff ff ff       	jmp    80105372 <sys_unlink+0xb9>
      panic("isdirempty: readi");
80105429:	83 ec 0c             	sub    $0xc,%esp
8010542c:	68 d8 7b 10 80       	push   $0x80107bd8
80105431:	e8 0e af ff ff       	call   80100344 <panic>
    panic("unlink: writei");
80105436:	83 ec 0c             	sub    $0xc,%esp
80105439:	68 ea 7b 10 80       	push   $0x80107bea
8010543e:	e8 01 af ff ff       	call   80100344 <panic>
    dp->nlink--;
80105443:	66 83 6f 56 01       	subw   $0x1,0x56(%edi)
    iupdate(dp);
80105448:	83 ec 0c             	sub    $0xc,%esp
8010544b:	57                   	push   %edi
8010544c:	e8 72 c0 ff ff       	call   801014c3 <iupdate>
80105451:	83 c4 10             	add    $0x10,%esp
80105454:	e9 4c ff ff ff       	jmp    801053a5 <sys_unlink+0xec>
    return -1;
80105459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545e:	e9 6d ff ff ff       	jmp    801053d0 <sys_unlink+0x117>
    iunlockput(ip);
80105463:	83 ec 0c             	sub    $0xc,%esp
80105466:	53                   	push   %ebx
80105467:	e8 4a c3 ff ff       	call   801017b6 <iunlockput>
    goto bad;
8010546c:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
8010546f:	83 ec 0c             	sub    $0xc,%esp
80105472:	57                   	push   %edi
80105473:	e8 3e c3 ff ff       	call   801017b6 <iunlockput>
  end_op();
80105478:	e8 32 d4 ff ff       	call   801028af <end_op>
  return -1;
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105485:	e9 46 ff ff ff       	jmp    801053d0 <sys_unlink+0x117>

8010548a <sys_open>:

int
sys_open(void)
{
8010548a:	55                   	push   %ebp
8010548b:	89 e5                	mov    %esp,%ebp
8010548d:	57                   	push   %edi
8010548e:	56                   	push   %esi
8010548f:	53                   	push   %ebx
80105490:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105493:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105496:	50                   	push   %eax
80105497:	6a 00                	push   $0x0
80105499:	e8 6d f8 ff ff       	call   80104d0b <argstr>
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	85 c0                	test   %eax,%eax
801054a3:	0f 88 0b 01 00 00    	js     801055b4 <sys_open+0x12a>
801054a9:	83 ec 08             	sub    $0x8,%esp
801054ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
801054af:	50                   	push   %eax
801054b0:	6a 01                	push   $0x1
801054b2:	e8 cd f7 ff ff       	call   80104c84 <argint>
801054b7:	83 c4 10             	add    $0x10,%esp
801054ba:	85 c0                	test   %eax,%eax
801054bc:	0f 88 f9 00 00 00    	js     801055bb <sys_open+0x131>
    return -1;

  begin_op();
801054c2:	e8 6d d3 ff ff       	call   80102834 <begin_op>

  if(omode & O_CREATE){
801054c7:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
801054cb:	0f 84 8a 00 00 00    	je     8010555b <sys_open+0xd1>
    ip = create(path, T_FILE, 0, 0);
801054d1:	83 ec 0c             	sub    $0xc,%esp
801054d4:	6a 00                	push   $0x0
801054d6:	b9 00 00 00 00       	mov    $0x0,%ecx
801054db:	ba 02 00 00 00       	mov    $0x2,%edx
801054e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801054e3:	e8 4b f9 ff ff       	call   80104e33 <create>
801054e8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	85 c0                	test   %eax,%eax
801054ef:	74 5e                	je     8010554f <sys_open+0xc5>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054f1:	e8 f9 b7 ff ff       	call   80100cef <filealloc>
801054f6:	89 c3                	mov    %eax,%ebx
801054f8:	85 c0                	test   %eax,%eax
801054fa:	0f 84 ce 00 00 00    	je     801055ce <sys_open+0x144>
80105500:	e8 ee f8 ff ff       	call   80104df3 <fdalloc>
80105505:	89 c7                	mov    %eax,%edi
80105507:	85 c0                	test   %eax,%eax
80105509:	0f 88 b3 00 00 00    	js     801055c2 <sys_open+0x138>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010550f:	83 ec 0c             	sub    $0xc,%esp
80105512:	56                   	push   %esi
80105513:	e8 17 c1 ff ff       	call   8010162f <iunlock>
  end_op();
80105518:	e8 92 d3 ff ff       	call   801028af <end_op>

  f->type = FD_INODE;
8010551d:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80105523:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80105526:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
8010552d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105530:	89 d0                	mov    %edx,%eax
80105532:	83 f0 01             	xor    $0x1,%eax
80105535:	83 e0 01             	and    $0x1,%eax
80105538:	88 43 08             	mov    %al,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010553b:	83 c4 10             	add    $0x10,%esp
8010553e:	f6 c2 03             	test   $0x3,%dl
80105541:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80105545:	89 f8                	mov    %edi,%eax
80105547:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010554a:	5b                   	pop    %ebx
8010554b:	5e                   	pop    %esi
8010554c:	5f                   	pop    %edi
8010554d:	5d                   	pop    %ebp
8010554e:	c3                   	ret    
      end_op();
8010554f:	e8 5b d3 ff ff       	call   801028af <end_op>
      return -1;
80105554:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80105559:	eb ea                	jmp    80105545 <sys_open+0xbb>
    if((ip = namei(path)) == 0){
8010555b:	83 ec 0c             	sub    $0xc,%esp
8010555e:	ff 75 e4             	pushl  -0x1c(%ebp)
80105561:	e8 a4 c7 ff ff       	call   80101d0a <namei>
80105566:	89 c6                	mov    %eax,%esi
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	85 c0                	test   %eax,%eax
8010556d:	74 39                	je     801055a8 <sys_open+0x11e>
    ilock(ip);
8010556f:	83 ec 0c             	sub    $0xc,%esp
80105572:	50                   	push   %eax
80105573:	e8 f5 bf ff ff       	call   8010156d <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105580:	0f 85 6b ff ff ff    	jne    801054f1 <sys_open+0x67>
80105586:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010558a:	0f 84 61 ff ff ff    	je     801054f1 <sys_open+0x67>
      iunlockput(ip);
80105590:	83 ec 0c             	sub    $0xc,%esp
80105593:	56                   	push   %esi
80105594:	e8 1d c2 ff ff       	call   801017b6 <iunlockput>
      end_op();
80105599:	e8 11 d3 ff ff       	call   801028af <end_op>
      return -1;
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801055a6:	eb 9d                	jmp    80105545 <sys_open+0xbb>
      end_op();
801055a8:	e8 02 d3 ff ff       	call   801028af <end_op>
      return -1;
801055ad:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801055b2:	eb 91                	jmp    80105545 <sys_open+0xbb>
    return -1;
801055b4:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801055b9:	eb 8a                	jmp    80105545 <sys_open+0xbb>
801055bb:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801055c0:	eb 83                	jmp    80105545 <sys_open+0xbb>
      fileclose(f);
801055c2:	83 ec 0c             	sub    $0xc,%esp
801055c5:	53                   	push   %ebx
801055c6:	e8 d6 b7 ff ff       	call   80100da1 <fileclose>
801055cb:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801055ce:	83 ec 0c             	sub    $0xc,%esp
801055d1:	56                   	push   %esi
801055d2:	e8 df c1 ff ff       	call   801017b6 <iunlockput>
    end_op();
801055d7:	e8 d3 d2 ff ff       	call   801028af <end_op>
    return -1;
801055dc:	83 c4 10             	add    $0x10,%esp
801055df:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801055e4:	e9 5c ff ff ff       	jmp    80105545 <sys_open+0xbb>

801055e9 <sys_mkdir>:

int
sys_mkdir(void)
{
801055e9:	55                   	push   %ebp
801055ea:	89 e5                	mov    %esp,%ebp
801055ec:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055ef:	e8 40 d2 ff ff       	call   80102834 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055f4:	83 ec 08             	sub    $0x8,%esp
801055f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055fa:	50                   	push   %eax
801055fb:	6a 00                	push   $0x0
801055fd:	e8 09 f7 ff ff       	call   80104d0b <argstr>
80105602:	83 c4 10             	add    $0x10,%esp
80105605:	85 c0                	test   %eax,%eax
80105607:	78 36                	js     8010563f <sys_mkdir+0x56>
80105609:	83 ec 0c             	sub    $0xc,%esp
8010560c:	6a 00                	push   $0x0
8010560e:	b9 00 00 00 00       	mov    $0x0,%ecx
80105613:	ba 01 00 00 00       	mov    $0x1,%edx
80105618:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010561b:	e8 13 f8 ff ff       	call   80104e33 <create>
80105620:	83 c4 10             	add    $0x10,%esp
80105623:	85 c0                	test   %eax,%eax
80105625:	74 18                	je     8010563f <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105627:	83 ec 0c             	sub    $0xc,%esp
8010562a:	50                   	push   %eax
8010562b:	e8 86 c1 ff ff       	call   801017b6 <iunlockput>
  end_op();
80105630:	e8 7a d2 ff ff       	call   801028af <end_op>
  return 0;
80105635:	83 c4 10             	add    $0x10,%esp
80105638:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010563d:	c9                   	leave  
8010563e:	c3                   	ret    
    end_op();
8010563f:	e8 6b d2 ff ff       	call   801028af <end_op>
    return -1;
80105644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105649:	eb f2                	jmp    8010563d <sys_mkdir+0x54>

8010564b <sys_mknod>:

int
sys_mknod(void)
{
8010564b:	55                   	push   %ebp
8010564c:	89 e5                	mov    %esp,%ebp
8010564e:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105651:	e8 de d1 ff ff       	call   80102834 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105656:	83 ec 08             	sub    $0x8,%esp
80105659:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010565c:	50                   	push   %eax
8010565d:	6a 00                	push   $0x0
8010565f:	e8 a7 f6 ff ff       	call   80104d0b <argstr>
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	85 c0                	test   %eax,%eax
80105669:	78 62                	js     801056cd <sys_mknod+0x82>
     argint(1, &major) < 0 ||
8010566b:	83 ec 08             	sub    $0x8,%esp
8010566e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105671:	50                   	push   %eax
80105672:	6a 01                	push   $0x1
80105674:	e8 0b f6 ff ff       	call   80104c84 <argint>
  if((argstr(0, &path)) < 0 ||
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	85 c0                	test   %eax,%eax
8010567e:	78 4d                	js     801056cd <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
80105680:	83 ec 08             	sub    $0x8,%esp
80105683:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105686:	50                   	push   %eax
80105687:	6a 02                	push   $0x2
80105689:	e8 f6 f5 ff ff       	call   80104c84 <argint>
     argint(1, &major) < 0 ||
8010568e:	83 c4 10             	add    $0x10,%esp
80105691:	85 c0                	test   %eax,%eax
80105693:	78 38                	js     801056cd <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105695:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105699:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
8010569c:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
801056a0:	50                   	push   %eax
801056a1:	ba 03 00 00 00       	mov    $0x3,%edx
801056a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a9:	e8 85 f7 ff ff       	call   80104e33 <create>
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	85 c0                	test   %eax,%eax
801056b3:	74 18                	je     801056cd <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056b5:	83 ec 0c             	sub    $0xc,%esp
801056b8:	50                   	push   %eax
801056b9:	e8 f8 c0 ff ff       	call   801017b6 <iunlockput>
  end_op();
801056be:	e8 ec d1 ff ff       	call   801028af <end_op>
  return 0;
801056c3:	83 c4 10             	add    $0x10,%esp
801056c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056cb:	c9                   	leave  
801056cc:	c3                   	ret    
    end_op();
801056cd:	e8 dd d1 ff ff       	call   801028af <end_op>
    return -1;
801056d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d7:	eb f2                	jmp    801056cb <sys_mknod+0x80>

801056d9 <sys_chdir>:

int
sys_chdir(void)
{
801056d9:	55                   	push   %ebp
801056da:	89 e5                	mov    %esp,%ebp
801056dc:	56                   	push   %esi
801056dd:	53                   	push   %ebx
801056de:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056e1:	e8 9b de ff ff       	call   80103581 <myproc>
801056e6:	89 c6                	mov    %eax,%esi

  begin_op();
801056e8:	e8 47 d1 ff ff       	call   80102834 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056ed:	83 ec 08             	sub    $0x8,%esp
801056f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056f3:	50                   	push   %eax
801056f4:	6a 00                	push   $0x0
801056f6:	e8 10 f6 ff ff       	call   80104d0b <argstr>
801056fb:	83 c4 10             	add    $0x10,%esp
801056fe:	85 c0                	test   %eax,%eax
80105700:	78 52                	js     80105754 <sys_chdir+0x7b>
80105702:	83 ec 0c             	sub    $0xc,%esp
80105705:	ff 75 f4             	pushl  -0xc(%ebp)
80105708:	e8 fd c5 ff ff       	call   80101d0a <namei>
8010570d:	89 c3                	mov    %eax,%ebx
8010570f:	83 c4 10             	add    $0x10,%esp
80105712:	85 c0                	test   %eax,%eax
80105714:	74 3e                	je     80105754 <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
80105716:	83 ec 0c             	sub    $0xc,%esp
80105719:	50                   	push   %eax
8010571a:	e8 4e be ff ff       	call   8010156d <ilock>
  if(ip->type != T_DIR){
8010571f:	83 c4 10             	add    $0x10,%esp
80105722:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105727:	75 37                	jne    80105760 <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105729:	83 ec 0c             	sub    $0xc,%esp
8010572c:	53                   	push   %ebx
8010572d:	e8 fd be ff ff       	call   8010162f <iunlock>
  iput(curproc->cwd);
80105732:	83 c4 04             	add    $0x4,%esp
80105735:	ff 76 68             	pushl  0x68(%esi)
80105738:	e8 37 bf ff ff       	call   80101674 <iput>
  end_op();
8010573d:	e8 6d d1 ff ff       	call   801028af <end_op>
  curproc->cwd = ip;
80105742:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105745:	83 c4 10             	add    $0x10,%esp
80105748:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010574d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105750:	5b                   	pop    %ebx
80105751:	5e                   	pop    %esi
80105752:	5d                   	pop    %ebp
80105753:	c3                   	ret    
    end_op();
80105754:	e8 56 d1 ff ff       	call   801028af <end_op>
    return -1;
80105759:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575e:	eb ed                	jmp    8010574d <sys_chdir+0x74>
    iunlockput(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	53                   	push   %ebx
80105764:	e8 4d c0 ff ff       	call   801017b6 <iunlockput>
    end_op();
80105769:	e8 41 d1 ff ff       	call   801028af <end_op>
    return -1;
8010576e:	83 c4 10             	add    $0x10,%esp
80105771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105776:	eb d5                	jmp    8010574d <sys_chdir+0x74>

80105778 <sys_exec>:

int
sys_exec(void)
{
80105778:	55                   	push   %ebp
80105779:	89 e5                	mov    %esp,%ebp
8010577b:	57                   	push   %edi
8010577c:	56                   	push   %esi
8010577d:	53                   	push   %ebx
8010577e:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105784:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105787:	50                   	push   %eax
80105788:	6a 00                	push   $0x0
8010578a:	e8 7c f5 ff ff       	call   80104d0b <argstr>
8010578f:	83 c4 10             	add    $0x10,%esp
80105792:	85 c0                	test   %eax,%eax
80105794:	0f 88 b4 00 00 00    	js     8010584e <sys_exec+0xd6>
8010579a:	83 ec 08             	sub    $0x8,%esp
8010579d:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057a3:	50                   	push   %eax
801057a4:	6a 01                	push   $0x1
801057a6:	e8 d9 f4 ff ff       	call   80104c84 <argint>
801057ab:	83 c4 10             	add    $0x10,%esp
801057ae:	85 c0                	test   %eax,%eax
801057b0:	0f 88 9f 00 00 00    	js     80105855 <sys_exec+0xdd>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057b6:	83 ec 04             	sub    $0x4,%esp
801057b9:	68 80 00 00 00       	push   $0x80
801057be:	6a 00                	push   $0x0
801057c0:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057c6:	50                   	push   %eax
801057c7:	e8 32 f2 ff ff       	call   801049fe <memset>
801057cc:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801057cf:	be 00 00 00 00       	mov    $0x0,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057d4:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
801057da:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
801057e1:	83 ec 08             	sub    $0x8,%esp
801057e4:	57                   	push   %edi
801057e5:	89 d8                	mov    %ebx,%eax
801057e7:	03 85 60 ff ff ff    	add    -0xa0(%ebp),%eax
801057ed:	50                   	push   %eax
801057ee:	e8 05 f4 ff ff       	call   80104bf8 <fetchint>
801057f3:	83 c4 10             	add    $0x10,%esp
801057f6:	85 c0                	test   %eax,%eax
801057f8:	78 62                	js     8010585c <sys_exec+0xe4>
      return -1;
    if(uarg == 0){
801057fa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105800:	85 c0                	test   %eax,%eax
80105802:	74 28                	je     8010582c <sys_exec+0xb4>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105804:	83 ec 08             	sub    $0x8,%esp
80105807:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
8010580d:	01 d3                	add    %edx,%ebx
8010580f:	53                   	push   %ebx
80105810:	50                   	push   %eax
80105811:	e8 1e f4 ff ff       	call   80104c34 <fetchstr>
80105816:	83 c4 10             	add    $0x10,%esp
80105819:	85 c0                	test   %eax,%eax
8010581b:	78 4c                	js     80105869 <sys_exec+0xf1>
  for(i=0;; i++){
8010581d:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
80105820:	83 fe 20             	cmp    $0x20,%esi
80105823:	75 b5                	jne    801057da <sys_exec+0x62>
      return -1;
80105825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582a:	eb 35                	jmp    80105861 <sys_exec+0xe9>
      argv[i] = 0;
8010582c:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80105833:	00 00 00 00 
      return -1;
  }
  return exec(path, argv);
80105837:	83 ec 08             	sub    $0x8,%esp
8010583a:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105840:	50                   	push   %eax
80105841:	ff 75 e4             	pushl  -0x1c(%ebp)
80105844:	e8 4e b1 ff ff       	call   80100997 <exec>
80105849:	83 c4 10             	add    $0x10,%esp
8010584c:	eb 13                	jmp    80105861 <sys_exec+0xe9>
    return -1;
8010584e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105853:	eb 0c                	jmp    80105861 <sys_exec+0xe9>
80105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585a:	eb 05                	jmp    80105861 <sys_exec+0xe9>
      return -1;
8010585c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105861:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105864:	5b                   	pop    %ebx
80105865:	5e                   	pop    %esi
80105866:	5f                   	pop    %edi
80105867:	5d                   	pop    %ebp
80105868:	c3                   	ret    
      return -1;
80105869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586e:	eb f1                	jmp    80105861 <sys_exec+0xe9>

80105870 <sys_pipe>:

int
sys_pipe(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	53                   	push   %ebx
80105874:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105877:	6a 08                	push   $0x8
80105879:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010587c:	50                   	push   %eax
8010587d:	6a 00                	push   $0x0
8010587f:	e8 26 f4 ff ff       	call   80104caa <argptr>
80105884:	83 c4 10             	add    $0x10,%esp
80105887:	85 c0                	test   %eax,%eax
80105889:	78 46                	js     801058d1 <sys_pipe+0x61>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010588b:	83 ec 08             	sub    $0x8,%esp
8010588e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105891:	50                   	push   %eax
80105892:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105895:	50                   	push   %eax
80105896:	e8 c8 d5 ff ff       	call   80102e63 <pipealloc>
8010589b:	83 c4 10             	add    $0x10,%esp
8010589e:	85 c0                	test   %eax,%eax
801058a0:	78 36                	js     801058d8 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a5:	e8 49 f5 ff ff       	call   80104df3 <fdalloc>
801058aa:	89 c3                	mov    %eax,%ebx
801058ac:	85 c0                	test   %eax,%eax
801058ae:	78 3c                	js     801058ec <sys_pipe+0x7c>
801058b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058b3:	e8 3b f5 ff ff       	call   80104df3 <fdalloc>
801058b8:	85 c0                	test   %eax,%eax
801058ba:	78 23                	js     801058df <sys_pipe+0x6f>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801058bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058bf:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801058c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058c4:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
801058c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058cf:	c9                   	leave  
801058d0:	c3                   	ret    
    return -1;
801058d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d6:	eb f4                	jmp    801058cc <sys_pipe+0x5c>
    return -1;
801058d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058dd:	eb ed                	jmp    801058cc <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
801058df:	e8 9d dc ff ff       	call   80103581 <myproc>
801058e4:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801058eb:	00 
    fileclose(rf);
801058ec:	83 ec 0c             	sub    $0xc,%esp
801058ef:	ff 75 f0             	pushl  -0x10(%ebp)
801058f2:	e8 aa b4 ff ff       	call   80100da1 <fileclose>
    fileclose(wf);
801058f7:	83 c4 04             	add    $0x4,%esp
801058fa:	ff 75 ec             	pushl  -0x14(%ebp)
801058fd:	e8 9f b4 ff ff       	call   80100da1 <fileclose>
    return -1;
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590a:	eb c0                	jmp    801058cc <sys_pipe+0x5c>

8010590c <sys_fork>:
#include "pdx-kernel.h"
#endif // PDX_XV6

int
sys_fork(void)
{
8010590c:	55                   	push   %ebp
8010590d:	89 e5                	mov    %esp,%ebp
8010590f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105912:	e8 7b df ff ff       	call   80103892 <fork>
}
80105917:	c9                   	leave  
80105918:	c3                   	ret    

80105919 <sys_exit>:

int
sys_exit(void)
{
80105919:	55                   	push   %ebp
8010591a:	89 e5                	mov    %esp,%ebp
8010591c:	83 ec 08             	sub    $0x8,%esp
  exit();
8010591f:	e8 6c e2 ff ff       	call   80103b90 <exit>
  return 0;  // not reached
}
80105924:	b8 00 00 00 00       	mov    $0x0,%eax
80105929:	c9                   	leave  
8010592a:	c3                   	ret    

8010592b <sys_wait>:

int
sys_wait(void)
{
8010592b:	55                   	push   %ebp
8010592c:	89 e5                	mov    %esp,%ebp
8010592e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105931:	e8 f5 e4 ff ff       	call   80103e2b <wait>
}
80105936:	c9                   	leave  
80105937:	c3                   	ret    

80105938 <sys_kill>:

int
sys_kill(void)
{
80105938:	55                   	push   %ebp
80105939:	89 e5                	mov    %esp,%ebp
8010593b:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010593e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105941:	50                   	push   %eax
80105942:	6a 00                	push   $0x0
80105944:	e8 3b f3 ff ff       	call   80104c84 <argint>
80105949:	83 c4 10             	add    $0x10,%esp
8010594c:	85 c0                	test   %eax,%eax
8010594e:	78 10                	js     80105960 <sys_kill+0x28>
    return -1;
  return kill(pid);
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	ff 75 f4             	pushl  -0xc(%ebp)
80105956:	e8 b3 e6 ff ff       	call   8010400e <kill>
8010595b:	83 c4 10             	add    $0x10,%esp
}
8010595e:	c9                   	leave  
8010595f:	c3                   	ret    
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105965:	eb f7                	jmp    8010595e <sys_kill+0x26>

80105967 <sys_getpid>:

int
sys_getpid(void)
{
80105967:	55                   	push   %ebp
80105968:	89 e5                	mov    %esp,%ebp
8010596a:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010596d:	e8 0f dc ff ff       	call   80103581 <myproc>
80105972:	8b 40 10             	mov    0x10(%eax),%eax
}
80105975:	c9                   	leave  
80105976:	c3                   	ret    

80105977 <sys_sbrk>:

int
sys_sbrk(void)
{
80105977:	55                   	push   %ebp
80105978:	89 e5                	mov    %esp,%ebp
8010597a:	53                   	push   %ebx
8010597b:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010597e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105981:	50                   	push   %eax
80105982:	6a 00                	push   $0x0
80105984:	e8 fb f2 ff ff       	call   80104c84 <argint>
80105989:	83 c4 10             	add    $0x10,%esp
8010598c:	85 c0                	test   %eax,%eax
8010598e:	78 26                	js     801059b6 <sys_sbrk+0x3f>
    return -1;
  addr = myproc()->sz;
80105990:	e8 ec db ff ff       	call   80103581 <myproc>
80105995:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105997:	83 ec 0c             	sub    $0xc,%esp
8010599a:	ff 75 f4             	pushl  -0xc(%ebp)
8010599d:	e8 83 de ff ff       	call   80103825 <growproc>
801059a2:	83 c4 10             	add    $0x10,%esp
801059a5:	85 c0                	test   %eax,%eax
    return -1;
801059a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ac:	0f 48 d8             	cmovs  %eax,%ebx
  return addr;
}
801059af:	89 d8                	mov    %ebx,%eax
801059b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059b4:	c9                   	leave  
801059b5:	c3                   	ret    
    return -1;
801059b6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059bb:	eb f2                	jmp    801059af <sys_sbrk+0x38>

801059bd <sys_sleep>:

int
sys_sleep(void)
{
801059bd:	55                   	push   %ebp
801059be:	89 e5                	mov    %esp,%ebp
801059c0:	56                   	push   %esi
801059c1:	53                   	push   %ebx
801059c2:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801059c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059c8:	50                   	push   %eax
801059c9:	6a 00                	push   $0x0
801059cb:	e8 b4 f2 ff ff       	call   80104c84 <argint>
801059d0:	83 c4 10             	add    $0x10,%esp
801059d3:	85 c0                	test   %eax,%eax
801059d5:	78 39                	js     80105a10 <sys_sleep+0x53>
    return -1;
  ticks0 = ticks;
801059d7:	8b 35 c0 5a 11 80    	mov    0x80115ac0,%esi
  while(ticks - ticks0 < n){
801059dd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801059e0:	85 db                	test   %ebx,%ebx
801059e2:	74 38                	je     80105a1c <sys_sleep+0x5f>
    if(myproc()->killed){
801059e4:	e8 98 db ff ff       	call   80103581 <myproc>
801059e9:	8b 58 24             	mov    0x24(%eax),%ebx
801059ec:	85 db                	test   %ebx,%ebx
801059ee:	75 27                	jne    80105a17 <sys_sleep+0x5a>
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
801059f0:	83 ec 08             	sub    $0x8,%esp
801059f3:	6a 00                	push   $0x0
801059f5:	68 c0 5a 11 80       	push   $0x80115ac0
801059fa:	e8 f3 e2 ff ff       	call   80103cf2 <sleep>
  while(ticks - ticks0 < n){
801059ff:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80105a04:	29 f0                	sub    %esi,%eax
80105a06:	83 c4 10             	add    $0x10,%esp
80105a09:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a0c:	72 d6                	jb     801059e4 <sys_sleep+0x27>
80105a0e:	eb 0c                	jmp    80105a1c <sys_sleep+0x5f>
    return -1;
80105a10:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a15:	eb 05                	jmp    80105a1c <sys_sleep+0x5f>
      return -1;
80105a17:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  }
  return 0;
}
80105a1c:	89 d8                	mov    %ebx,%eax
80105a1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a21:	5b                   	pop    %ebx
80105a22:	5e                   	pop    %esi
80105a23:	5d                   	pop    %ebp
80105a24:	c3                   	ret    

80105a25 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a25:	55                   	push   %ebp
80105a26:	89 e5                	mov    %esp,%ebp
  uint xticks;

  xticks = ticks;
  return xticks;
}
80105a28:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80105a2d:	5d                   	pop    %ebp
80105a2e:	c3                   	ret    

80105a2f <sys_halt>:

#ifdef PDX_XV6
// Turn off the computer
int
sys_halt(void)
{
80105a2f:	55                   	push   %ebp
80105a30:	89 e5                	mov    %esp,%ebp
80105a32:	83 ec 14             	sub    $0x14,%esp
  cprintf("Shutting down ...\n");
80105a35:	68 f9 7b 10 80       	push   $0x80107bf9
80105a3a:	e8 a2 ab ff ff       	call   801005e1 <cprintf>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a3f:	b8 00 20 00 00       	mov    $0x2000,%eax
80105a44:	ba 04 06 00 00       	mov    $0x604,%edx
80105a49:	66 ef                	out    %ax,(%dx)
  outw( 0x604, 0x0 | 0x2000);
  return 0;
}
80105a4b:	b8 00 00 00 00       	mov    $0x0,%eax
80105a50:	c9                   	leave  
80105a51:	c3                   	ret    

80105a52 <sys_date>:

#ifdef CS333_P1
//Checks if argument successfully was read. Get the time.
int
sys_date(void)
{
80105a52:	55                   	push   %ebp
80105a53:	89 e5                	mov    %esp,%ebp
80105a55:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *d;
  
  if(argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0)
80105a58:	6a 18                	push   $0x18
80105a5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a5d:	50                   	push   %eax
80105a5e:	6a 00                	push   $0x0
80105a60:	e8 45 f2 ff ff       	call   80104caa <argptr>
80105a65:	83 c4 10             	add    $0x10,%esp
80105a68:	85 c0                	test   %eax,%eax
80105a6a:	78 15                	js     80105a81 <sys_date+0x2f>
    return -1;

  cmostime(d);
80105a6c:	83 ec 0c             	sub    $0xc,%esp
80105a6f:	ff 75 f4             	pushl  -0xc(%ebp)
80105a72:	e8 2a cb ff ff       	call   801025a1 <cmostime>
  return 0;
80105a77:	83 c4 10             	add    $0x10,%esp
80105a7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a7f:	c9                   	leave  
80105a80:	c3                   	ret    
    return -1;
80105a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a86:	eb f7                	jmp    80105a7f <sys_date+0x2d>

80105a88 <sys_getuid>:

#ifdef CS333_P2
//Returns the uid
uint
sys_getuid(void)
{
80105a88:	55                   	push   %ebp
80105a89:	89 e5                	mov    %esp,%ebp
80105a8b:	83 ec 08             	sub    $0x8,%esp
  return myproc() -> uid;
80105a8e:	e8 ee da ff ff       	call   80103581 <myproc>
80105a93:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80105a99:	c9                   	leave  
80105a9a:	c3                   	ret    

80105a9b <sys_getgid>:


//Returns the gid
uint
sys_getgid(void)
{
80105a9b:	55                   	push   %ebp
80105a9c:	89 e5                	mov    %esp,%ebp
80105a9e:	83 ec 08             	sub    $0x8,%esp
  return myproc() -> gid;
80105aa1:	e8 db da ff ff       	call   80103581 <myproc>
80105aa6:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80105aac:	c9                   	leave  
80105aad:	c3                   	ret    

80105aae <sys_getppid>:


//Returns the ppid
uint
sys_getppid(void)
{
80105aae:	55                   	push   %ebp
80105aaf:	89 e5                	mov    %esp,%ebp
80105ab1:	83 ec 08             	sub    $0x8,%esp
  if(myproc() -> parent == NULL)
80105ab4:	e8 c8 da ff ff       	call   80103581 <myproc>
80105ab9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
80105abd:	74 0d                	je     80105acc <sys_getppid+0x1e>
     return myproc() -> pid;
 
  return myproc() -> parent -> pid;
80105abf:	e8 bd da ff ff       	call   80103581 <myproc>
80105ac4:	8b 40 14             	mov    0x14(%eax),%eax
80105ac7:	8b 40 10             	mov    0x10(%eax),%eax
}
80105aca:	c9                   	leave  
80105acb:	c3                   	ret    
     return myproc() -> pid;
80105acc:	e8 b0 da ff ff       	call   80103581 <myproc>
80105ad1:	8b 40 10             	mov    0x10(%eax),%eax
80105ad4:	eb f4                	jmp    80105aca <sys_getppid+0x1c>

80105ad6 <sys_setuid>:


//Called by test1P2. Makes sure uid is set in the correct range.
int
sys_setuid(void)
{
80105ad6:	55                   	push   %ebp
80105ad7:	89 e5                	mov    %esp,%ebp
80105ad9:	83 ec 20             	sub    $0x20,%esp
  int uid;
   
  if(argint(0, &uid) < 0)
80105adc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105adf:	50                   	push   %eax
80105ae0:	6a 00                	push   $0x0
80105ae2:	e8 9d f1 ff ff       	call   80104c84 <argint>
80105ae7:	83 c4 10             	add    $0x10,%esp
80105aea:	85 c0                	test   %eax,%eax
80105aec:	78 30                	js     80105b1e <sys_setuid+0x48>
    return -1;
  cprintf("UID TEST: my variable is %d\n", uid);
80105aee:	83 ec 08             	sub    $0x8,%esp
80105af1:	ff 75 f4             	pushl  -0xc(%ebp)
80105af4:	68 0c 7c 10 80       	push   $0x80107c0c
80105af9:	e8 e3 aa ff ff       	call   801005e1 <cprintf>
  if(uid < 0 || uid > 32767)
80105afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b01:	83 c4 10             	add    $0x10,%esp
80105b04:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80105b09:	77 1a                	ja     80105b25 <sys_setuid+0x4f>
    return -1;

  setuid(uid);
80105b0b:	83 ec 0c             	sub    $0xc,%esp
80105b0e:	50                   	push   %eax
80105b0f:	e8 2f ea ff ff       	call   80104543 <setuid>
  return 1;
80105b14:	83 c4 10             	add    $0x10,%esp
80105b17:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b1c:	c9                   	leave  
80105b1d:	c3                   	ret    
    return -1;
80105b1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b23:	eb f7                	jmp    80105b1c <sys_setuid+0x46>
    return -1;
80105b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2a:	eb f0                	jmp    80105b1c <sys_setuid+0x46>

80105b2c <sys_setgid>:


//Called by test1P2. Makes sure gid is set in the correct range.
int
sys_setgid(void)
{
80105b2c:	55                   	push   %ebp
80105b2d:	89 e5                	mov    %esp,%ebp
80105b2f:	83 ec 20             	sub    $0x20,%esp
  int gid;
   
  if(argint(0, &gid) < 0)
80105b32:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b35:	50                   	push   %eax
80105b36:	6a 00                	push   $0x0
80105b38:	e8 47 f1 ff ff       	call   80104c84 <argint>
80105b3d:	83 c4 10             	add    $0x10,%esp
80105b40:	85 c0                	test   %eax,%eax
80105b42:	78 30                	js     80105b74 <sys_setgid+0x48>
    return -1;
  cprintf("GID TEST: my variable is %d\n", gid);
80105b44:	83 ec 08             	sub    $0x8,%esp
80105b47:	ff 75 f4             	pushl  -0xc(%ebp)
80105b4a:	68 29 7c 10 80       	push   $0x80107c29
80105b4f:	e8 8d aa ff ff       	call   801005e1 <cprintf>
  if(gid < 0 || gid > 32767)
80105b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b57:	83 c4 10             	add    $0x10,%esp
80105b5a:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80105b5f:	77 1a                	ja     80105b7b <sys_setgid+0x4f>
    return -1;

  setgid(gid);
80105b61:	83 ec 0c             	sub    $0xc,%esp
80105b64:	50                   	push   %eax
80105b65:	e8 0a ea ff ff       	call   80104574 <setgid>
  return 1;
80105b6a:	83 c4 10             	add    $0x10,%esp
80105b6d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b72:	c9                   	leave  
80105b73:	c3                   	ret    
    return -1;
80105b74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b79:	eb f7                	jmp    80105b72 <sys_setgid+0x46>
    return -1;
80105b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b80:	eb f0                	jmp    80105b72 <sys_setgid+0x46>

80105b82 <sys_getprocs>:


//Wrapper for getting the current processes. 
int
sys_getprocs(void)
{
80105b82:	55                   	push   %ebp
80105b83:	89 e5                	mov    %esp,%ebp
80105b85:	83 ec 20             	sub    $0x20,%esp
  int max;
  struct uproc * table;
  if (argint(0, &max) < 0 || argptr(1, (void*)&table, sizeof(struct uproc)) < 0)
80105b88:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b8b:	50                   	push   %eax
80105b8c:	6a 00                	push   $0x0
80105b8e:	e8 f1 f0 ff ff       	call   80104c84 <argint>
80105b93:	83 c4 10             	add    $0x10,%esp
80105b96:	85 c0                	test   %eax,%eax
80105b98:	78 2f                	js     80105bc9 <sys_getprocs+0x47>
80105b9a:	83 ec 04             	sub    $0x4,%esp
80105b9d:	6a 60                	push   $0x60
80105b9f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ba2:	50                   	push   %eax
80105ba3:	6a 01                	push   $0x1
80105ba5:	e8 00 f1 ff ff       	call   80104caa <argptr>
80105baa:	83 c4 10             	add    $0x10,%esp
80105bad:	85 c0                	test   %eax,%eax
80105baf:	78 1f                	js     80105bd0 <sys_getprocs+0x4e>
    return -1;

  else
  {
    if(max > 0)
80105bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb4:	85 c0                	test   %eax,%eax
80105bb6:	7e 1f                	jle    80105bd7 <sys_getprocs+0x55>
      return getprocs(max, table); //implemented in proc.c
80105bb8:	83 ec 08             	sub    $0x8,%esp
80105bbb:	ff 75 f0             	pushl  -0x10(%ebp)
80105bbe:	50                   	push   %eax
80105bbf:	e8 e1 e9 ff ff       	call   801045a5 <getprocs>
80105bc4:	83 c4 10             	add    $0x10,%esp
    else
      return -1;
  }
}
80105bc7:	c9                   	leave  
80105bc8:	c3                   	ret    
    return -1;
80105bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bce:	eb f7                	jmp    80105bc7 <sys_getprocs+0x45>
80105bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd5:	eb f0                	jmp    80105bc7 <sys_getprocs+0x45>
      return -1;
80105bd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bdc:	eb e9                	jmp    80105bc7 <sys_getprocs+0x45>

80105bde <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105bde:	1e                   	push   %ds
  pushl %es
80105bdf:	06                   	push   %es
  pushl %fs
80105be0:	0f a0                	push   %fs
  pushl %gs
80105be2:	0f a8                	push   %gs
  pushal
80105be4:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105be5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105be9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105beb:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105bed:	54                   	push   %esp
  call trap
80105bee:	e8 a5 00 00 00       	call   80105c98 <trap>
  addl $4, %esp
80105bf3:	83 c4 04             	add    $0x4,%esp

80105bf6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105bf6:	61                   	popa   
  popl %gs
80105bf7:	0f a9                	pop    %gs
  popl %fs
80105bf9:	0f a1                	pop    %fs
  popl %es
80105bfb:	07                   	pop    %es
  popl %ds
80105bfc:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bfd:	83 c4 08             	add    $0x8,%esp
  iret
80105c00:	cf                   	iret   

80105c01 <tvinit>:
uint ticks;
#endif // PDX_XV6

void
tvinit(void)
{
80105c01:	55                   	push   %ebp
80105c02:	89 e5                	mov    %esp,%ebp
  int i;

  for(i = 0; i < 256; i++)
80105c04:	b8 00 00 00 00       	mov    $0x0,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c09:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105c10:	66 89 14 c5 c0 52 11 	mov    %dx,-0x7feead40(,%eax,8)
80105c17:	80 
80105c18:	66 c7 04 c5 c2 52 11 	movw   $0x8,-0x7feead3e(,%eax,8)
80105c1f:	80 08 00 
80105c22:	c6 04 c5 c4 52 11 80 	movb   $0x0,-0x7feead3c(,%eax,8)
80105c29:	00 
80105c2a:	c6 04 c5 c5 52 11 80 	movb   $0x8e,-0x7feead3b(,%eax,8)
80105c31:	8e 
80105c32:	c1 ea 10             	shr    $0x10,%edx
80105c35:	66 89 14 c5 c6 52 11 	mov    %dx,-0x7feead3a(,%eax,8)
80105c3c:	80 
  for(i = 0; i < 256; i++)
80105c3d:	83 c0 01             	add    $0x1,%eax
80105c40:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c45:	75 c2                	jne    80105c09 <tvinit+0x8>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c47:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105c4c:	66 a3 c0 54 11 80    	mov    %ax,0x801154c0
80105c52:	66 c7 05 c2 54 11 80 	movw   $0x8,0x801154c2
80105c59:	08 00 
80105c5b:	c6 05 c4 54 11 80 00 	movb   $0x0,0x801154c4
80105c62:	c6 05 c5 54 11 80 ef 	movb   $0xef,0x801154c5
80105c69:	c1 e8 10             	shr    $0x10,%eax
80105c6c:	66 a3 c6 54 11 80    	mov    %ax,0x801154c6

#ifndef PDX_XV6
  initlock(&tickslock, "time");
#endif // PDX_XV6
}
80105c72:	5d                   	pop    %ebp
80105c73:	c3                   	ret    

80105c74 <idtinit>:

void
idtinit(void)
{
80105c74:	55                   	push   %ebp
80105c75:	89 e5                	mov    %esp,%ebp
80105c77:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105c7a:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105c80:	b8 c0 52 11 80       	mov    $0x801152c0,%eax
80105c85:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c89:	c1 e8 10             	shr    $0x10,%eax
80105c8c:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c90:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c93:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c96:	c9                   	leave  
80105c97:	c3                   	ret    

80105c98 <trap>:

void
trap(struct trapframe *tf)
{
80105c98:	55                   	push   %ebp
80105c99:	89 e5                	mov    %esp,%ebp
80105c9b:	57                   	push   %edi
80105c9c:	56                   	push   %esi
80105c9d:	53                   	push   %ebx
80105c9e:	83 ec 1c             	sub    $0x1c,%esp
80105ca1:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105ca4:	8b 47 30             	mov    0x30(%edi),%eax
80105ca7:	83 f8 40             	cmp    $0x40,%eax
80105caa:	74 13                	je     80105cbf <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105cac:	83 e8 20             	sub    $0x20,%eax
80105caf:	83 f8 1f             	cmp    $0x1f,%eax
80105cb2:	0f 87 1f 01 00 00    	ja     80105dd7 <trap+0x13f>
80105cb8:	ff 24 85 e8 7c 10 80 	jmp    *-0x7fef8318(,%eax,4)
    if(myproc()->killed)
80105cbf:	e8 bd d8 ff ff       	call   80103581 <myproc>
80105cc4:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105cc8:	75 1f                	jne    80105ce9 <trap+0x51>
    myproc()->tf = tf;
80105cca:	e8 b2 d8 ff ff       	call   80103581 <myproc>
80105ccf:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105cd2:	e8 67 f0 ff ff       	call   80104d3e <syscall>
    if(myproc()->killed)
80105cd7:	e8 a5 d8 ff ff       	call   80103581 <myproc>
80105cdc:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105ce0:	74 7e                	je     80105d60 <trap+0xc8>
      exit();
80105ce2:	e8 a9 de ff ff       	call   80103b90 <exit>
80105ce7:	eb 77                	jmp    80105d60 <trap+0xc8>
      exit();
80105ce9:	e8 a2 de ff ff       	call   80103b90 <exit>
80105cee:	eb da                	jmp    80105cca <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105cf0:	e8 71 d8 ff ff       	call   80103566 <cpuid>
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	74 6f                	je     80105d68 <trap+0xd0>
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
#endif // PDX_XV6
    }
    lapiceoi();
80105cf9:	e8 e3 c7 ff ff       	call   801024e1 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cfe:	e8 7e d8 ff ff       	call   80103581 <myproc>
80105d03:	85 c0                	test   %eax,%eax
80105d05:	74 1c                	je     80105d23 <trap+0x8b>
80105d07:	e8 75 d8 ff ff       	call   80103581 <myproc>
80105d0c:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105d10:	74 11                	je     80105d23 <trap+0x8b>
80105d12:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d16:	83 e0 03             	and    $0x3,%eax
80105d19:	66 83 f8 03          	cmp    $0x3,%ax
80105d1d:	0f 84 48 01 00 00    	je     80105e6b <trap+0x1d3>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d23:	e8 59 d8 ff ff       	call   80103581 <myproc>
80105d28:	85 c0                	test   %eax,%eax
80105d2a:	74 0f                	je     80105d3b <trap+0xa3>
80105d2c:	e8 50 d8 ff ff       	call   80103581 <myproc>
80105d31:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d35:	0f 84 3a 01 00 00    	je     80105e75 <trap+0x1dd>
    tf->trapno == T_IRQ0+IRQ_TIMER)
#endif // PDX_XV6
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d3b:	e8 41 d8 ff ff       	call   80103581 <myproc>
80105d40:	85 c0                	test   %eax,%eax
80105d42:	74 1c                	je     80105d60 <trap+0xc8>
80105d44:	e8 38 d8 ff ff       	call   80103581 <myproc>
80105d49:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105d4d:	74 11                	je     80105d60 <trap+0xc8>
80105d4f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d53:	83 e0 03             	and    $0x3,%eax
80105d56:	66 83 f8 03          	cmp    $0x3,%ax
80105d5a:	0f 84 48 01 00 00    	je     80105ea8 <trap+0x210>
    exit();
}
80105d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d63:	5b                   	pop    %ebx
80105d64:	5e                   	pop    %esi
80105d65:	5f                   	pop    %edi
80105d66:	5d                   	pop    %ebp
80105d67:	c3                   	ret    
// atom_inc() necessary for removal of tickslock
// other atomic ops added for completeness
static inline void
atom_inc(volatile int *num)
{
  asm volatile ( "lock incl %0" : "=m" (*num));
80105d68:	f0 ff 05 c0 5a 11 80 	lock incl 0x80115ac0
      wakeup(&ticks);
80105d6f:	83 ec 0c             	sub    $0xc,%esp
80105d72:	68 c0 5a 11 80       	push   $0x80115ac0
80105d77:	e8 69 e2 ff ff       	call   80103fe5 <wakeup>
80105d7c:	83 c4 10             	add    $0x10,%esp
80105d7f:	e9 75 ff ff ff       	jmp    80105cf9 <trap+0x61>
    ideintr();
80105d84:	e8 ee c0 ff ff       	call   80101e77 <ideintr>
    lapiceoi();
80105d89:	e8 53 c7 ff ff       	call   801024e1 <lapiceoi>
    break;
80105d8e:	e9 6b ff ff ff       	jmp    80105cfe <trap+0x66>
    kbdintr();
80105d93:	e8 7d c5 ff ff       	call   80102315 <kbdintr>
    lapiceoi();
80105d98:	e8 44 c7 ff ff       	call   801024e1 <lapiceoi>
    break;
80105d9d:	e9 5c ff ff ff       	jmp    80105cfe <trap+0x66>
    uartintr();
80105da2:	e8 39 02 00 00       	call   80105fe0 <uartintr>
    lapiceoi();
80105da7:	e8 35 c7 ff ff       	call   801024e1 <lapiceoi>
    break;
80105dac:	e9 4d ff ff ff       	jmp    80105cfe <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105db1:	8b 77 38             	mov    0x38(%edi),%esi
80105db4:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105db8:	e8 a9 d7 ff ff       	call   80103566 <cpuid>
80105dbd:	56                   	push   %esi
80105dbe:	53                   	push   %ebx
80105dbf:	50                   	push   %eax
80105dc0:	68 48 7c 10 80       	push   $0x80107c48
80105dc5:	e8 17 a8 ff ff       	call   801005e1 <cprintf>
    lapiceoi();
80105dca:	e8 12 c7 ff ff       	call   801024e1 <lapiceoi>
    break;
80105dcf:	83 c4 10             	add    $0x10,%esp
80105dd2:	e9 27 ff ff ff       	jmp    80105cfe <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105dd7:	e8 a5 d7 ff ff       	call   80103581 <myproc>
80105ddc:	85 c0                	test   %eax,%eax
80105dde:	74 60                	je     80105e40 <trap+0x1a8>
80105de0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105de4:	74 5a                	je     80105e40 <trap+0x1a8>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105de6:	0f 20 d0             	mov    %cr2,%eax
80105de9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dec:	8b 77 38             	mov    0x38(%edi),%esi
80105def:	e8 72 d7 ff ff       	call   80103566 <cpuid>
80105df4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105df7:	8b 5f 34             	mov    0x34(%edi),%ebx
80105dfa:	8b 4f 30             	mov    0x30(%edi),%ecx
80105dfd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e00:	e8 7c d7 ff ff       	call   80103581 <myproc>
80105e05:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e08:	e8 74 d7 ff ff       	call   80103581 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e0d:	ff 75 d8             	pushl  -0x28(%ebp)
80105e10:	56                   	push   %esi
80105e11:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e14:	53                   	push   %ebx
80105e15:	ff 75 e0             	pushl  -0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e18:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e1b:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e1e:	52                   	push   %edx
80105e1f:	ff 70 10             	pushl  0x10(%eax)
80105e22:	68 a0 7c 10 80       	push   $0x80107ca0
80105e27:	e8 b5 a7 ff ff       	call   801005e1 <cprintf>
    myproc()->killed = 1;
80105e2c:	83 c4 20             	add    $0x20,%esp
80105e2f:	e8 4d d7 ff ff       	call   80103581 <myproc>
80105e34:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105e3b:	e9 be fe ff ff       	jmp    80105cfe <trap+0x66>
80105e40:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e43:	8b 5f 38             	mov    0x38(%edi),%ebx
80105e46:	e8 1b d7 ff ff       	call   80103566 <cpuid>
80105e4b:	83 ec 0c             	sub    $0xc,%esp
80105e4e:	56                   	push   %esi
80105e4f:	53                   	push   %ebx
80105e50:	50                   	push   %eax
80105e51:	ff 77 30             	pushl  0x30(%edi)
80105e54:	68 6c 7c 10 80       	push   $0x80107c6c
80105e59:	e8 83 a7 ff ff       	call   801005e1 <cprintf>
      panic("trap");
80105e5e:	83 c4 14             	add    $0x14,%esp
80105e61:	68 e3 7c 10 80       	push   $0x80107ce3
80105e66:	e8 d9 a4 ff ff       	call   80100344 <panic>
    exit();
80105e6b:	e8 20 dd ff ff       	call   80103b90 <exit>
80105e70:	e9 ae fe ff ff       	jmp    80105d23 <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
80105e75:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105e79:	0f 85 bc fe ff ff    	jne    80105d3b <trap+0xa3>
    tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80105e7f:	8b 0d c0 5a 11 80    	mov    0x80115ac0,%ecx
80105e85:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105e8a:	89 c8                	mov    %ecx,%eax
80105e8c:	f7 e2                	mul    %edx
80105e8e:	c1 ea 03             	shr    $0x3,%edx
80105e91:	8d 04 92             	lea    (%edx,%edx,4),%eax
80105e94:	01 c0                	add    %eax,%eax
80105e96:	39 c1                	cmp    %eax,%ecx
80105e98:	0f 85 9d fe ff ff    	jne    80105d3b <trap+0xa3>
    yield();
80105e9e:	e8 f0 dd ff ff       	call   80103c93 <yield>
80105ea3:	e9 93 fe ff ff       	jmp    80105d3b <trap+0xa3>
    exit();
80105ea8:	e8 e3 dc ff ff       	call   80103b90 <exit>
80105ead:	e9 ae fe ff ff       	jmp    80105d60 <trap+0xc8>

80105eb2 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105eb2:	55                   	push   %ebp
80105eb3:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105eb5:	83 3d 44 cb 10 80 00 	cmpl   $0x0,0x8010cb44
80105ebc:	74 15                	je     80105ed3 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ebe:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ec3:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ec4:	a8 01                	test   $0x1,%al
80105ec6:	74 12                	je     80105eda <uartgetc+0x28>
80105ec8:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ecd:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ece:	0f b6 c0             	movzbl %al,%eax
}
80105ed1:	5d                   	pop    %ebp
80105ed2:	c3                   	ret    
    return -1;
80105ed3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ed8:	eb f7                	jmp    80105ed1 <uartgetc+0x1f>
    return -1;
80105eda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105edf:	eb f0                	jmp    80105ed1 <uartgetc+0x1f>

80105ee1 <uartputc>:
  if(!uart)
80105ee1:	83 3d 44 cb 10 80 00 	cmpl   $0x0,0x8010cb44
80105ee8:	74 4f                	je     80105f39 <uartputc+0x58>
{
80105eea:	55                   	push   %ebp
80105eeb:	89 e5                	mov    %esp,%ebp
80105eed:	56                   	push   %esi
80105eee:	53                   	push   %ebx
80105eef:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ef4:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ef5:	a8 20                	test   $0x20,%al
80105ef7:	75 30                	jne    80105f29 <uartputc+0x48>
    microdelay(10);
80105ef9:	83 ec 0c             	sub    $0xc,%esp
80105efc:	6a 0a                	push   $0xa
80105efe:	e8 fd c5 ff ff       	call   80102500 <microdelay>
80105f03:	83 c4 10             	add    $0x10,%esp
80105f06:	bb 7f 00 00 00       	mov    $0x7f,%ebx
80105f0b:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f10:	89 f2                	mov    %esi,%edx
80105f12:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f13:	a8 20                	test   $0x20,%al
80105f15:	75 12                	jne    80105f29 <uartputc+0x48>
    microdelay(10);
80105f17:	83 ec 0c             	sub    $0xc,%esp
80105f1a:	6a 0a                	push   $0xa
80105f1c:	e8 df c5 ff ff       	call   80102500 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f21:	83 c4 10             	add    $0x10,%esp
80105f24:	83 eb 01             	sub    $0x1,%ebx
80105f27:	75 e7                	jne    80105f10 <uartputc+0x2f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f29:	8b 45 08             	mov    0x8(%ebp),%eax
80105f2c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f31:	ee                   	out    %al,(%dx)
}
80105f32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f35:	5b                   	pop    %ebx
80105f36:	5e                   	pop    %esi
80105f37:	5d                   	pop    %ebp
80105f38:	c3                   	ret    
80105f39:	f3 c3                	repz ret 

80105f3b <uartinit>:
{
80105f3b:	55                   	push   %ebp
80105f3c:	89 e5                	mov    %esp,%ebp
80105f3e:	56                   	push   %esi
80105f3f:	53                   	push   %ebx
80105f40:	b9 00 00 00 00       	mov    $0x0,%ecx
80105f45:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105f4a:	89 c8                	mov    %ecx,%eax
80105f4c:	ee                   	out    %al,(%dx)
80105f4d:	be fb 03 00 00       	mov    $0x3fb,%esi
80105f52:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f57:	89 f2                	mov    %esi,%edx
80105f59:	ee                   	out    %al,(%dx)
80105f5a:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f5f:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f64:	ee                   	out    %al,(%dx)
80105f65:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105f6a:	89 c8                	mov    %ecx,%eax
80105f6c:	89 da                	mov    %ebx,%edx
80105f6e:	ee                   	out    %al,(%dx)
80105f6f:	b8 03 00 00 00       	mov    $0x3,%eax
80105f74:	89 f2                	mov    %esi,%edx
80105f76:	ee                   	out    %al,(%dx)
80105f77:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f7c:	89 c8                	mov    %ecx,%eax
80105f7e:	ee                   	out    %al,(%dx)
80105f7f:	b8 01 00 00 00       	mov    $0x1,%eax
80105f84:	89 da                	mov    %ebx,%edx
80105f86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f87:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f8c:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f8d:	3c ff                	cmp    $0xff,%al
80105f8f:	74 48                	je     80105fd9 <uartinit+0x9e>
  uart = 1;
80105f91:	c7 05 44 cb 10 80 01 	movl   $0x1,0x8010cb44
80105f98:	00 00 00 
80105f9b:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105fa0:	ec                   	in     (%dx),%al
80105fa1:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fa6:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fa7:	83 ec 08             	sub    $0x8,%esp
80105faa:	6a 00                	push   $0x0
80105fac:	6a 04                	push   $0x4
80105fae:	e8 da c0 ff ff       	call   8010208d <ioapicenable>
80105fb3:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105fb6:	bb 68 7d 10 80       	mov    $0x80107d68,%ebx
80105fbb:	b8 78 00 00 00       	mov    $0x78,%eax
    uartputc(*p);
80105fc0:	83 ec 0c             	sub    $0xc,%esp
80105fc3:	0f be c0             	movsbl %al,%eax
80105fc6:	50                   	push   %eax
80105fc7:	e8 15 ff ff ff       	call   80105ee1 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105fcc:	83 c3 01             	add    $0x1,%ebx
80105fcf:	0f b6 03             	movzbl (%ebx),%eax
80105fd2:	83 c4 10             	add    $0x10,%esp
80105fd5:	84 c0                	test   %al,%al
80105fd7:	75 e7                	jne    80105fc0 <uartinit+0x85>
}
80105fd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fdc:	5b                   	pop    %ebx
80105fdd:	5e                   	pop    %esi
80105fde:	5d                   	pop    %ebp
80105fdf:	c3                   	ret    

80105fe0 <uartintr>:

void
uartintr(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fe6:	68 b2 5e 10 80       	push   $0x80105eb2
80105feb:	e8 4b a7 ff ff       	call   8010073b <consoleintr>
}
80105ff0:	83 c4 10             	add    $0x10,%esp
80105ff3:	c9                   	leave  
80105ff4:	c3                   	ret    

80105ff5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $0
80105ff7:	6a 00                	push   $0x0
  jmp alltraps
80105ff9:	e9 e0 fb ff ff       	jmp    80105bde <alltraps>

80105ffe <vector1>:
.globl vector1
vector1:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $1
80106000:	6a 01                	push   $0x1
  jmp alltraps
80106002:	e9 d7 fb ff ff       	jmp    80105bde <alltraps>

80106007 <vector2>:
.globl vector2
vector2:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $2
80106009:	6a 02                	push   $0x2
  jmp alltraps
8010600b:	e9 ce fb ff ff       	jmp    80105bde <alltraps>

80106010 <vector3>:
.globl vector3
vector3:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $3
80106012:	6a 03                	push   $0x3
  jmp alltraps
80106014:	e9 c5 fb ff ff       	jmp    80105bde <alltraps>

80106019 <vector4>:
.globl vector4
vector4:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $4
8010601b:	6a 04                	push   $0x4
  jmp alltraps
8010601d:	e9 bc fb ff ff       	jmp    80105bde <alltraps>

80106022 <vector5>:
.globl vector5
vector5:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $5
80106024:	6a 05                	push   $0x5
  jmp alltraps
80106026:	e9 b3 fb ff ff       	jmp    80105bde <alltraps>

8010602b <vector6>:
.globl vector6
vector6:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $6
8010602d:	6a 06                	push   $0x6
  jmp alltraps
8010602f:	e9 aa fb ff ff       	jmp    80105bde <alltraps>

80106034 <vector7>:
.globl vector7
vector7:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $7
80106036:	6a 07                	push   $0x7
  jmp alltraps
80106038:	e9 a1 fb ff ff       	jmp    80105bde <alltraps>

8010603d <vector8>:
.globl vector8
vector8:
  pushl $8
8010603d:	6a 08                	push   $0x8
  jmp alltraps
8010603f:	e9 9a fb ff ff       	jmp    80105bde <alltraps>

80106044 <vector9>:
.globl vector9
vector9:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $9
80106046:	6a 09                	push   $0x9
  jmp alltraps
80106048:	e9 91 fb ff ff       	jmp    80105bde <alltraps>

8010604d <vector10>:
.globl vector10
vector10:
  pushl $10
8010604d:	6a 0a                	push   $0xa
  jmp alltraps
8010604f:	e9 8a fb ff ff       	jmp    80105bde <alltraps>

80106054 <vector11>:
.globl vector11
vector11:
  pushl $11
80106054:	6a 0b                	push   $0xb
  jmp alltraps
80106056:	e9 83 fb ff ff       	jmp    80105bde <alltraps>

8010605b <vector12>:
.globl vector12
vector12:
  pushl $12
8010605b:	6a 0c                	push   $0xc
  jmp alltraps
8010605d:	e9 7c fb ff ff       	jmp    80105bde <alltraps>

80106062 <vector13>:
.globl vector13
vector13:
  pushl $13
80106062:	6a 0d                	push   $0xd
  jmp alltraps
80106064:	e9 75 fb ff ff       	jmp    80105bde <alltraps>

80106069 <vector14>:
.globl vector14
vector14:
  pushl $14
80106069:	6a 0e                	push   $0xe
  jmp alltraps
8010606b:	e9 6e fb ff ff       	jmp    80105bde <alltraps>

80106070 <vector15>:
.globl vector15
vector15:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $15
80106072:	6a 0f                	push   $0xf
  jmp alltraps
80106074:	e9 65 fb ff ff       	jmp    80105bde <alltraps>

80106079 <vector16>:
.globl vector16
vector16:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $16
8010607b:	6a 10                	push   $0x10
  jmp alltraps
8010607d:	e9 5c fb ff ff       	jmp    80105bde <alltraps>

80106082 <vector17>:
.globl vector17
vector17:
  pushl $17
80106082:	6a 11                	push   $0x11
  jmp alltraps
80106084:	e9 55 fb ff ff       	jmp    80105bde <alltraps>

80106089 <vector18>:
.globl vector18
vector18:
  pushl $0
80106089:	6a 00                	push   $0x0
  pushl $18
8010608b:	6a 12                	push   $0x12
  jmp alltraps
8010608d:	e9 4c fb ff ff       	jmp    80105bde <alltraps>

80106092 <vector19>:
.globl vector19
vector19:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $19
80106094:	6a 13                	push   $0x13
  jmp alltraps
80106096:	e9 43 fb ff ff       	jmp    80105bde <alltraps>

8010609b <vector20>:
.globl vector20
vector20:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $20
8010609d:	6a 14                	push   $0x14
  jmp alltraps
8010609f:	e9 3a fb ff ff       	jmp    80105bde <alltraps>

801060a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $21
801060a6:	6a 15                	push   $0x15
  jmp alltraps
801060a8:	e9 31 fb ff ff       	jmp    80105bde <alltraps>

801060ad <vector22>:
.globl vector22
vector22:
  pushl $0
801060ad:	6a 00                	push   $0x0
  pushl $22
801060af:	6a 16                	push   $0x16
  jmp alltraps
801060b1:	e9 28 fb ff ff       	jmp    80105bde <alltraps>

801060b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $23
801060b8:	6a 17                	push   $0x17
  jmp alltraps
801060ba:	e9 1f fb ff ff       	jmp    80105bde <alltraps>

801060bf <vector24>:
.globl vector24
vector24:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $24
801060c1:	6a 18                	push   $0x18
  jmp alltraps
801060c3:	e9 16 fb ff ff       	jmp    80105bde <alltraps>

801060c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801060c8:	6a 00                	push   $0x0
  pushl $25
801060ca:	6a 19                	push   $0x19
  jmp alltraps
801060cc:	e9 0d fb ff ff       	jmp    80105bde <alltraps>

801060d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801060d1:	6a 00                	push   $0x0
  pushl $26
801060d3:	6a 1a                	push   $0x1a
  jmp alltraps
801060d5:	e9 04 fb ff ff       	jmp    80105bde <alltraps>

801060da <vector27>:
.globl vector27
vector27:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $27
801060dc:	6a 1b                	push   $0x1b
  jmp alltraps
801060de:	e9 fb fa ff ff       	jmp    80105bde <alltraps>

801060e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $28
801060e5:	6a 1c                	push   $0x1c
  jmp alltraps
801060e7:	e9 f2 fa ff ff       	jmp    80105bde <alltraps>

801060ec <vector29>:
.globl vector29
vector29:
  pushl $0
801060ec:	6a 00                	push   $0x0
  pushl $29
801060ee:	6a 1d                	push   $0x1d
  jmp alltraps
801060f0:	e9 e9 fa ff ff       	jmp    80105bde <alltraps>

801060f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $30
801060f7:	6a 1e                	push   $0x1e
  jmp alltraps
801060f9:	e9 e0 fa ff ff       	jmp    80105bde <alltraps>

801060fe <vector31>:
.globl vector31
vector31:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $31
80106100:	6a 1f                	push   $0x1f
  jmp alltraps
80106102:	e9 d7 fa ff ff       	jmp    80105bde <alltraps>

80106107 <vector32>:
.globl vector32
vector32:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $32
80106109:	6a 20                	push   $0x20
  jmp alltraps
8010610b:	e9 ce fa ff ff       	jmp    80105bde <alltraps>

80106110 <vector33>:
.globl vector33
vector33:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $33
80106112:	6a 21                	push   $0x21
  jmp alltraps
80106114:	e9 c5 fa ff ff       	jmp    80105bde <alltraps>

80106119 <vector34>:
.globl vector34
vector34:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $34
8010611b:	6a 22                	push   $0x22
  jmp alltraps
8010611d:	e9 bc fa ff ff       	jmp    80105bde <alltraps>

80106122 <vector35>:
.globl vector35
vector35:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $35
80106124:	6a 23                	push   $0x23
  jmp alltraps
80106126:	e9 b3 fa ff ff       	jmp    80105bde <alltraps>

8010612b <vector36>:
.globl vector36
vector36:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $36
8010612d:	6a 24                	push   $0x24
  jmp alltraps
8010612f:	e9 aa fa ff ff       	jmp    80105bde <alltraps>

80106134 <vector37>:
.globl vector37
vector37:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $37
80106136:	6a 25                	push   $0x25
  jmp alltraps
80106138:	e9 a1 fa ff ff       	jmp    80105bde <alltraps>

8010613d <vector38>:
.globl vector38
vector38:
  pushl $0
8010613d:	6a 00                	push   $0x0
  pushl $38
8010613f:	6a 26                	push   $0x26
  jmp alltraps
80106141:	e9 98 fa ff ff       	jmp    80105bde <alltraps>

80106146 <vector39>:
.globl vector39
vector39:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $39
80106148:	6a 27                	push   $0x27
  jmp alltraps
8010614a:	e9 8f fa ff ff       	jmp    80105bde <alltraps>

8010614f <vector40>:
.globl vector40
vector40:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $40
80106151:	6a 28                	push   $0x28
  jmp alltraps
80106153:	e9 86 fa ff ff       	jmp    80105bde <alltraps>

80106158 <vector41>:
.globl vector41
vector41:
  pushl $0
80106158:	6a 00                	push   $0x0
  pushl $41
8010615a:	6a 29                	push   $0x29
  jmp alltraps
8010615c:	e9 7d fa ff ff       	jmp    80105bde <alltraps>

80106161 <vector42>:
.globl vector42
vector42:
  pushl $0
80106161:	6a 00                	push   $0x0
  pushl $42
80106163:	6a 2a                	push   $0x2a
  jmp alltraps
80106165:	e9 74 fa ff ff       	jmp    80105bde <alltraps>

8010616a <vector43>:
.globl vector43
vector43:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $43
8010616c:	6a 2b                	push   $0x2b
  jmp alltraps
8010616e:	e9 6b fa ff ff       	jmp    80105bde <alltraps>

80106173 <vector44>:
.globl vector44
vector44:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $44
80106175:	6a 2c                	push   $0x2c
  jmp alltraps
80106177:	e9 62 fa ff ff       	jmp    80105bde <alltraps>

8010617c <vector45>:
.globl vector45
vector45:
  pushl $0
8010617c:	6a 00                	push   $0x0
  pushl $45
8010617e:	6a 2d                	push   $0x2d
  jmp alltraps
80106180:	e9 59 fa ff ff       	jmp    80105bde <alltraps>

80106185 <vector46>:
.globl vector46
vector46:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $46
80106187:	6a 2e                	push   $0x2e
  jmp alltraps
80106189:	e9 50 fa ff ff       	jmp    80105bde <alltraps>

8010618e <vector47>:
.globl vector47
vector47:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $47
80106190:	6a 2f                	push   $0x2f
  jmp alltraps
80106192:	e9 47 fa ff ff       	jmp    80105bde <alltraps>

80106197 <vector48>:
.globl vector48
vector48:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $48
80106199:	6a 30                	push   $0x30
  jmp alltraps
8010619b:	e9 3e fa ff ff       	jmp    80105bde <alltraps>

801061a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $49
801061a2:	6a 31                	push   $0x31
  jmp alltraps
801061a4:	e9 35 fa ff ff       	jmp    80105bde <alltraps>

801061a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $50
801061ab:	6a 32                	push   $0x32
  jmp alltraps
801061ad:	e9 2c fa ff ff       	jmp    80105bde <alltraps>

801061b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $51
801061b4:	6a 33                	push   $0x33
  jmp alltraps
801061b6:	e9 23 fa ff ff       	jmp    80105bde <alltraps>

801061bb <vector52>:
.globl vector52
vector52:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $52
801061bd:	6a 34                	push   $0x34
  jmp alltraps
801061bf:	e9 1a fa ff ff       	jmp    80105bde <alltraps>

801061c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $53
801061c6:	6a 35                	push   $0x35
  jmp alltraps
801061c8:	e9 11 fa ff ff       	jmp    80105bde <alltraps>

801061cd <vector54>:
.globl vector54
vector54:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $54
801061cf:	6a 36                	push   $0x36
  jmp alltraps
801061d1:	e9 08 fa ff ff       	jmp    80105bde <alltraps>

801061d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $55
801061d8:	6a 37                	push   $0x37
  jmp alltraps
801061da:	e9 ff f9 ff ff       	jmp    80105bde <alltraps>

801061df <vector56>:
.globl vector56
vector56:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $56
801061e1:	6a 38                	push   $0x38
  jmp alltraps
801061e3:	e9 f6 f9 ff ff       	jmp    80105bde <alltraps>

801061e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $57
801061ea:	6a 39                	push   $0x39
  jmp alltraps
801061ec:	e9 ed f9 ff ff       	jmp    80105bde <alltraps>

801061f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $58
801061f3:	6a 3a                	push   $0x3a
  jmp alltraps
801061f5:	e9 e4 f9 ff ff       	jmp    80105bde <alltraps>

801061fa <vector59>:
.globl vector59
vector59:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $59
801061fc:	6a 3b                	push   $0x3b
  jmp alltraps
801061fe:	e9 db f9 ff ff       	jmp    80105bde <alltraps>

80106203 <vector60>:
.globl vector60
vector60:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $60
80106205:	6a 3c                	push   $0x3c
  jmp alltraps
80106207:	e9 d2 f9 ff ff       	jmp    80105bde <alltraps>

8010620c <vector61>:
.globl vector61
vector61:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $61
8010620e:	6a 3d                	push   $0x3d
  jmp alltraps
80106210:	e9 c9 f9 ff ff       	jmp    80105bde <alltraps>

80106215 <vector62>:
.globl vector62
vector62:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $62
80106217:	6a 3e                	push   $0x3e
  jmp alltraps
80106219:	e9 c0 f9 ff ff       	jmp    80105bde <alltraps>

8010621e <vector63>:
.globl vector63
vector63:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $63
80106220:	6a 3f                	push   $0x3f
  jmp alltraps
80106222:	e9 b7 f9 ff ff       	jmp    80105bde <alltraps>

80106227 <vector64>:
.globl vector64
vector64:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $64
80106229:	6a 40                	push   $0x40
  jmp alltraps
8010622b:	e9 ae f9 ff ff       	jmp    80105bde <alltraps>

80106230 <vector65>:
.globl vector65
vector65:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $65
80106232:	6a 41                	push   $0x41
  jmp alltraps
80106234:	e9 a5 f9 ff ff       	jmp    80105bde <alltraps>

80106239 <vector66>:
.globl vector66
vector66:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $66
8010623b:	6a 42                	push   $0x42
  jmp alltraps
8010623d:	e9 9c f9 ff ff       	jmp    80105bde <alltraps>

80106242 <vector67>:
.globl vector67
vector67:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $67
80106244:	6a 43                	push   $0x43
  jmp alltraps
80106246:	e9 93 f9 ff ff       	jmp    80105bde <alltraps>

8010624b <vector68>:
.globl vector68
vector68:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $68
8010624d:	6a 44                	push   $0x44
  jmp alltraps
8010624f:	e9 8a f9 ff ff       	jmp    80105bde <alltraps>

80106254 <vector69>:
.globl vector69
vector69:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $69
80106256:	6a 45                	push   $0x45
  jmp alltraps
80106258:	e9 81 f9 ff ff       	jmp    80105bde <alltraps>

8010625d <vector70>:
.globl vector70
vector70:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $70
8010625f:	6a 46                	push   $0x46
  jmp alltraps
80106261:	e9 78 f9 ff ff       	jmp    80105bde <alltraps>

80106266 <vector71>:
.globl vector71
vector71:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $71
80106268:	6a 47                	push   $0x47
  jmp alltraps
8010626a:	e9 6f f9 ff ff       	jmp    80105bde <alltraps>

8010626f <vector72>:
.globl vector72
vector72:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $72
80106271:	6a 48                	push   $0x48
  jmp alltraps
80106273:	e9 66 f9 ff ff       	jmp    80105bde <alltraps>

80106278 <vector73>:
.globl vector73
vector73:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $73
8010627a:	6a 49                	push   $0x49
  jmp alltraps
8010627c:	e9 5d f9 ff ff       	jmp    80105bde <alltraps>

80106281 <vector74>:
.globl vector74
vector74:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $74
80106283:	6a 4a                	push   $0x4a
  jmp alltraps
80106285:	e9 54 f9 ff ff       	jmp    80105bde <alltraps>

8010628a <vector75>:
.globl vector75
vector75:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $75
8010628c:	6a 4b                	push   $0x4b
  jmp alltraps
8010628e:	e9 4b f9 ff ff       	jmp    80105bde <alltraps>

80106293 <vector76>:
.globl vector76
vector76:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $76
80106295:	6a 4c                	push   $0x4c
  jmp alltraps
80106297:	e9 42 f9 ff ff       	jmp    80105bde <alltraps>

8010629c <vector77>:
.globl vector77
vector77:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $77
8010629e:	6a 4d                	push   $0x4d
  jmp alltraps
801062a0:	e9 39 f9 ff ff       	jmp    80105bde <alltraps>

801062a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $78
801062a7:	6a 4e                	push   $0x4e
  jmp alltraps
801062a9:	e9 30 f9 ff ff       	jmp    80105bde <alltraps>

801062ae <vector79>:
.globl vector79
vector79:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $79
801062b0:	6a 4f                	push   $0x4f
  jmp alltraps
801062b2:	e9 27 f9 ff ff       	jmp    80105bde <alltraps>

801062b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $80
801062b9:	6a 50                	push   $0x50
  jmp alltraps
801062bb:	e9 1e f9 ff ff       	jmp    80105bde <alltraps>

801062c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $81
801062c2:	6a 51                	push   $0x51
  jmp alltraps
801062c4:	e9 15 f9 ff ff       	jmp    80105bde <alltraps>

801062c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $82
801062cb:	6a 52                	push   $0x52
  jmp alltraps
801062cd:	e9 0c f9 ff ff       	jmp    80105bde <alltraps>

801062d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $83
801062d4:	6a 53                	push   $0x53
  jmp alltraps
801062d6:	e9 03 f9 ff ff       	jmp    80105bde <alltraps>

801062db <vector84>:
.globl vector84
vector84:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $84
801062dd:	6a 54                	push   $0x54
  jmp alltraps
801062df:	e9 fa f8 ff ff       	jmp    80105bde <alltraps>

801062e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $85
801062e6:	6a 55                	push   $0x55
  jmp alltraps
801062e8:	e9 f1 f8 ff ff       	jmp    80105bde <alltraps>

801062ed <vector86>:
.globl vector86
vector86:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $86
801062ef:	6a 56                	push   $0x56
  jmp alltraps
801062f1:	e9 e8 f8 ff ff       	jmp    80105bde <alltraps>

801062f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $87
801062f8:	6a 57                	push   $0x57
  jmp alltraps
801062fa:	e9 df f8 ff ff       	jmp    80105bde <alltraps>

801062ff <vector88>:
.globl vector88
vector88:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $88
80106301:	6a 58                	push   $0x58
  jmp alltraps
80106303:	e9 d6 f8 ff ff       	jmp    80105bde <alltraps>

80106308 <vector89>:
.globl vector89
vector89:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $89
8010630a:	6a 59                	push   $0x59
  jmp alltraps
8010630c:	e9 cd f8 ff ff       	jmp    80105bde <alltraps>

80106311 <vector90>:
.globl vector90
vector90:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $90
80106313:	6a 5a                	push   $0x5a
  jmp alltraps
80106315:	e9 c4 f8 ff ff       	jmp    80105bde <alltraps>

8010631a <vector91>:
.globl vector91
vector91:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $91
8010631c:	6a 5b                	push   $0x5b
  jmp alltraps
8010631e:	e9 bb f8 ff ff       	jmp    80105bde <alltraps>

80106323 <vector92>:
.globl vector92
vector92:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $92
80106325:	6a 5c                	push   $0x5c
  jmp alltraps
80106327:	e9 b2 f8 ff ff       	jmp    80105bde <alltraps>

8010632c <vector93>:
.globl vector93
vector93:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $93
8010632e:	6a 5d                	push   $0x5d
  jmp alltraps
80106330:	e9 a9 f8 ff ff       	jmp    80105bde <alltraps>

80106335 <vector94>:
.globl vector94
vector94:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $94
80106337:	6a 5e                	push   $0x5e
  jmp alltraps
80106339:	e9 a0 f8 ff ff       	jmp    80105bde <alltraps>

8010633e <vector95>:
.globl vector95
vector95:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $95
80106340:	6a 5f                	push   $0x5f
  jmp alltraps
80106342:	e9 97 f8 ff ff       	jmp    80105bde <alltraps>

80106347 <vector96>:
.globl vector96
vector96:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $96
80106349:	6a 60                	push   $0x60
  jmp alltraps
8010634b:	e9 8e f8 ff ff       	jmp    80105bde <alltraps>

80106350 <vector97>:
.globl vector97
vector97:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $97
80106352:	6a 61                	push   $0x61
  jmp alltraps
80106354:	e9 85 f8 ff ff       	jmp    80105bde <alltraps>

80106359 <vector98>:
.globl vector98
vector98:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $98
8010635b:	6a 62                	push   $0x62
  jmp alltraps
8010635d:	e9 7c f8 ff ff       	jmp    80105bde <alltraps>

80106362 <vector99>:
.globl vector99
vector99:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $99
80106364:	6a 63                	push   $0x63
  jmp alltraps
80106366:	e9 73 f8 ff ff       	jmp    80105bde <alltraps>

8010636b <vector100>:
.globl vector100
vector100:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $100
8010636d:	6a 64                	push   $0x64
  jmp alltraps
8010636f:	e9 6a f8 ff ff       	jmp    80105bde <alltraps>

80106374 <vector101>:
.globl vector101
vector101:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $101
80106376:	6a 65                	push   $0x65
  jmp alltraps
80106378:	e9 61 f8 ff ff       	jmp    80105bde <alltraps>

8010637d <vector102>:
.globl vector102
vector102:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $102
8010637f:	6a 66                	push   $0x66
  jmp alltraps
80106381:	e9 58 f8 ff ff       	jmp    80105bde <alltraps>

80106386 <vector103>:
.globl vector103
vector103:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $103
80106388:	6a 67                	push   $0x67
  jmp alltraps
8010638a:	e9 4f f8 ff ff       	jmp    80105bde <alltraps>

8010638f <vector104>:
.globl vector104
vector104:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $104
80106391:	6a 68                	push   $0x68
  jmp alltraps
80106393:	e9 46 f8 ff ff       	jmp    80105bde <alltraps>

80106398 <vector105>:
.globl vector105
vector105:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $105
8010639a:	6a 69                	push   $0x69
  jmp alltraps
8010639c:	e9 3d f8 ff ff       	jmp    80105bde <alltraps>

801063a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $106
801063a3:	6a 6a                	push   $0x6a
  jmp alltraps
801063a5:	e9 34 f8 ff ff       	jmp    80105bde <alltraps>

801063aa <vector107>:
.globl vector107
vector107:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $107
801063ac:	6a 6b                	push   $0x6b
  jmp alltraps
801063ae:	e9 2b f8 ff ff       	jmp    80105bde <alltraps>

801063b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $108
801063b5:	6a 6c                	push   $0x6c
  jmp alltraps
801063b7:	e9 22 f8 ff ff       	jmp    80105bde <alltraps>

801063bc <vector109>:
.globl vector109
vector109:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $109
801063be:	6a 6d                	push   $0x6d
  jmp alltraps
801063c0:	e9 19 f8 ff ff       	jmp    80105bde <alltraps>

801063c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $110
801063c7:	6a 6e                	push   $0x6e
  jmp alltraps
801063c9:	e9 10 f8 ff ff       	jmp    80105bde <alltraps>

801063ce <vector111>:
.globl vector111
vector111:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $111
801063d0:	6a 6f                	push   $0x6f
  jmp alltraps
801063d2:	e9 07 f8 ff ff       	jmp    80105bde <alltraps>

801063d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $112
801063d9:	6a 70                	push   $0x70
  jmp alltraps
801063db:	e9 fe f7 ff ff       	jmp    80105bde <alltraps>

801063e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $113
801063e2:	6a 71                	push   $0x71
  jmp alltraps
801063e4:	e9 f5 f7 ff ff       	jmp    80105bde <alltraps>

801063e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $114
801063eb:	6a 72                	push   $0x72
  jmp alltraps
801063ed:	e9 ec f7 ff ff       	jmp    80105bde <alltraps>

801063f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $115
801063f4:	6a 73                	push   $0x73
  jmp alltraps
801063f6:	e9 e3 f7 ff ff       	jmp    80105bde <alltraps>

801063fb <vector116>:
.globl vector116
vector116:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $116
801063fd:	6a 74                	push   $0x74
  jmp alltraps
801063ff:	e9 da f7 ff ff       	jmp    80105bde <alltraps>

80106404 <vector117>:
.globl vector117
vector117:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $117
80106406:	6a 75                	push   $0x75
  jmp alltraps
80106408:	e9 d1 f7 ff ff       	jmp    80105bde <alltraps>

8010640d <vector118>:
.globl vector118
vector118:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $118
8010640f:	6a 76                	push   $0x76
  jmp alltraps
80106411:	e9 c8 f7 ff ff       	jmp    80105bde <alltraps>

80106416 <vector119>:
.globl vector119
vector119:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $119
80106418:	6a 77                	push   $0x77
  jmp alltraps
8010641a:	e9 bf f7 ff ff       	jmp    80105bde <alltraps>

8010641f <vector120>:
.globl vector120
vector120:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $120
80106421:	6a 78                	push   $0x78
  jmp alltraps
80106423:	e9 b6 f7 ff ff       	jmp    80105bde <alltraps>

80106428 <vector121>:
.globl vector121
vector121:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $121
8010642a:	6a 79                	push   $0x79
  jmp alltraps
8010642c:	e9 ad f7 ff ff       	jmp    80105bde <alltraps>

80106431 <vector122>:
.globl vector122
vector122:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $122
80106433:	6a 7a                	push   $0x7a
  jmp alltraps
80106435:	e9 a4 f7 ff ff       	jmp    80105bde <alltraps>

8010643a <vector123>:
.globl vector123
vector123:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $123
8010643c:	6a 7b                	push   $0x7b
  jmp alltraps
8010643e:	e9 9b f7 ff ff       	jmp    80105bde <alltraps>

80106443 <vector124>:
.globl vector124
vector124:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $124
80106445:	6a 7c                	push   $0x7c
  jmp alltraps
80106447:	e9 92 f7 ff ff       	jmp    80105bde <alltraps>

8010644c <vector125>:
.globl vector125
vector125:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $125
8010644e:	6a 7d                	push   $0x7d
  jmp alltraps
80106450:	e9 89 f7 ff ff       	jmp    80105bde <alltraps>

80106455 <vector126>:
.globl vector126
vector126:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $126
80106457:	6a 7e                	push   $0x7e
  jmp alltraps
80106459:	e9 80 f7 ff ff       	jmp    80105bde <alltraps>

8010645e <vector127>:
.globl vector127
vector127:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $127
80106460:	6a 7f                	push   $0x7f
  jmp alltraps
80106462:	e9 77 f7 ff ff       	jmp    80105bde <alltraps>

80106467 <vector128>:
.globl vector128
vector128:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $128
80106469:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010646e:	e9 6b f7 ff ff       	jmp    80105bde <alltraps>

80106473 <vector129>:
.globl vector129
vector129:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $129
80106475:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010647a:	e9 5f f7 ff ff       	jmp    80105bde <alltraps>

8010647f <vector130>:
.globl vector130
vector130:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $130
80106481:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106486:	e9 53 f7 ff ff       	jmp    80105bde <alltraps>

8010648b <vector131>:
.globl vector131
vector131:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $131
8010648d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106492:	e9 47 f7 ff ff       	jmp    80105bde <alltraps>

80106497 <vector132>:
.globl vector132
vector132:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $132
80106499:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010649e:	e9 3b f7 ff ff       	jmp    80105bde <alltraps>

801064a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $133
801064a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064aa:	e9 2f f7 ff ff       	jmp    80105bde <alltraps>

801064af <vector134>:
.globl vector134
vector134:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $134
801064b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064b6:	e9 23 f7 ff ff       	jmp    80105bde <alltraps>

801064bb <vector135>:
.globl vector135
vector135:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $135
801064bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064c2:	e9 17 f7 ff ff       	jmp    80105bde <alltraps>

801064c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $136
801064c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801064ce:	e9 0b f7 ff ff       	jmp    80105bde <alltraps>

801064d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $137
801064d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801064da:	e9 ff f6 ff ff       	jmp    80105bde <alltraps>

801064df <vector138>:
.globl vector138
vector138:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $138
801064e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064e6:	e9 f3 f6 ff ff       	jmp    80105bde <alltraps>

801064eb <vector139>:
.globl vector139
vector139:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $139
801064ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064f2:	e9 e7 f6 ff ff       	jmp    80105bde <alltraps>

801064f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $140
801064f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064fe:	e9 db f6 ff ff       	jmp    80105bde <alltraps>

80106503 <vector141>:
.globl vector141
vector141:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $141
80106505:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010650a:	e9 cf f6 ff ff       	jmp    80105bde <alltraps>

8010650f <vector142>:
.globl vector142
vector142:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $142
80106511:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106516:	e9 c3 f6 ff ff       	jmp    80105bde <alltraps>

8010651b <vector143>:
.globl vector143
vector143:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $143
8010651d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106522:	e9 b7 f6 ff ff       	jmp    80105bde <alltraps>

80106527 <vector144>:
.globl vector144
vector144:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $144
80106529:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010652e:	e9 ab f6 ff ff       	jmp    80105bde <alltraps>

80106533 <vector145>:
.globl vector145
vector145:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $145
80106535:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010653a:	e9 9f f6 ff ff       	jmp    80105bde <alltraps>

8010653f <vector146>:
.globl vector146
vector146:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $146
80106541:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106546:	e9 93 f6 ff ff       	jmp    80105bde <alltraps>

8010654b <vector147>:
.globl vector147
vector147:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $147
8010654d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106552:	e9 87 f6 ff ff       	jmp    80105bde <alltraps>

80106557 <vector148>:
.globl vector148
vector148:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $148
80106559:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010655e:	e9 7b f6 ff ff       	jmp    80105bde <alltraps>

80106563 <vector149>:
.globl vector149
vector149:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $149
80106565:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010656a:	e9 6f f6 ff ff       	jmp    80105bde <alltraps>

8010656f <vector150>:
.globl vector150
vector150:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $150
80106571:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106576:	e9 63 f6 ff ff       	jmp    80105bde <alltraps>

8010657b <vector151>:
.globl vector151
vector151:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $151
8010657d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106582:	e9 57 f6 ff ff       	jmp    80105bde <alltraps>

80106587 <vector152>:
.globl vector152
vector152:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $152
80106589:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010658e:	e9 4b f6 ff ff       	jmp    80105bde <alltraps>

80106593 <vector153>:
.globl vector153
vector153:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $153
80106595:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010659a:	e9 3f f6 ff ff       	jmp    80105bde <alltraps>

8010659f <vector154>:
.globl vector154
vector154:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $154
801065a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065a6:	e9 33 f6 ff ff       	jmp    80105bde <alltraps>

801065ab <vector155>:
.globl vector155
vector155:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $155
801065ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065b2:	e9 27 f6 ff ff       	jmp    80105bde <alltraps>

801065b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $156
801065b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065be:	e9 1b f6 ff ff       	jmp    80105bde <alltraps>

801065c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $157
801065c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065ca:	e9 0f f6 ff ff       	jmp    80105bde <alltraps>

801065cf <vector158>:
.globl vector158
vector158:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $158
801065d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801065d6:	e9 03 f6 ff ff       	jmp    80105bde <alltraps>

801065db <vector159>:
.globl vector159
vector159:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $159
801065dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065e2:	e9 f7 f5 ff ff       	jmp    80105bde <alltraps>

801065e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $160
801065e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065ee:	e9 eb f5 ff ff       	jmp    80105bde <alltraps>

801065f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $161
801065f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065fa:	e9 df f5 ff ff       	jmp    80105bde <alltraps>

801065ff <vector162>:
.globl vector162
vector162:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $162
80106601:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106606:	e9 d3 f5 ff ff       	jmp    80105bde <alltraps>

8010660b <vector163>:
.globl vector163
vector163:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $163
8010660d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106612:	e9 c7 f5 ff ff       	jmp    80105bde <alltraps>

80106617 <vector164>:
.globl vector164
vector164:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $164
80106619:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010661e:	e9 bb f5 ff ff       	jmp    80105bde <alltraps>

80106623 <vector165>:
.globl vector165
vector165:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $165
80106625:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010662a:	e9 af f5 ff ff       	jmp    80105bde <alltraps>

8010662f <vector166>:
.globl vector166
vector166:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $166
80106631:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106636:	e9 a3 f5 ff ff       	jmp    80105bde <alltraps>

8010663b <vector167>:
.globl vector167
vector167:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $167
8010663d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106642:	e9 97 f5 ff ff       	jmp    80105bde <alltraps>

80106647 <vector168>:
.globl vector168
vector168:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $168
80106649:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010664e:	e9 8b f5 ff ff       	jmp    80105bde <alltraps>

80106653 <vector169>:
.globl vector169
vector169:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $169
80106655:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010665a:	e9 7f f5 ff ff       	jmp    80105bde <alltraps>

8010665f <vector170>:
.globl vector170
vector170:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $170
80106661:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106666:	e9 73 f5 ff ff       	jmp    80105bde <alltraps>

8010666b <vector171>:
.globl vector171
vector171:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $171
8010666d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106672:	e9 67 f5 ff ff       	jmp    80105bde <alltraps>

80106677 <vector172>:
.globl vector172
vector172:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $172
80106679:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010667e:	e9 5b f5 ff ff       	jmp    80105bde <alltraps>

80106683 <vector173>:
.globl vector173
vector173:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $173
80106685:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010668a:	e9 4f f5 ff ff       	jmp    80105bde <alltraps>

8010668f <vector174>:
.globl vector174
vector174:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $174
80106691:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106696:	e9 43 f5 ff ff       	jmp    80105bde <alltraps>

8010669b <vector175>:
.globl vector175
vector175:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $175
8010669d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066a2:	e9 37 f5 ff ff       	jmp    80105bde <alltraps>

801066a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $176
801066a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066ae:	e9 2b f5 ff ff       	jmp    80105bde <alltraps>

801066b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $177
801066b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066ba:	e9 1f f5 ff ff       	jmp    80105bde <alltraps>

801066bf <vector178>:
.globl vector178
vector178:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $178
801066c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066c6:	e9 13 f5 ff ff       	jmp    80105bde <alltraps>

801066cb <vector179>:
.globl vector179
vector179:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $179
801066cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801066d2:	e9 07 f5 ff ff       	jmp    80105bde <alltraps>

801066d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $180
801066d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801066de:	e9 fb f4 ff ff       	jmp    80105bde <alltraps>

801066e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $181
801066e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066ea:	e9 ef f4 ff ff       	jmp    80105bde <alltraps>

801066ef <vector182>:
.globl vector182
vector182:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $182
801066f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066f6:	e9 e3 f4 ff ff       	jmp    80105bde <alltraps>

801066fb <vector183>:
.globl vector183
vector183:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $183
801066fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106702:	e9 d7 f4 ff ff       	jmp    80105bde <alltraps>

80106707 <vector184>:
.globl vector184
vector184:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $184
80106709:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010670e:	e9 cb f4 ff ff       	jmp    80105bde <alltraps>

80106713 <vector185>:
.globl vector185
vector185:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $185
80106715:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010671a:	e9 bf f4 ff ff       	jmp    80105bde <alltraps>

8010671f <vector186>:
.globl vector186
vector186:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $186
80106721:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106726:	e9 b3 f4 ff ff       	jmp    80105bde <alltraps>

8010672b <vector187>:
.globl vector187
vector187:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $187
8010672d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106732:	e9 a7 f4 ff ff       	jmp    80105bde <alltraps>

80106737 <vector188>:
.globl vector188
vector188:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $188
80106739:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010673e:	e9 9b f4 ff ff       	jmp    80105bde <alltraps>

80106743 <vector189>:
.globl vector189
vector189:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $189
80106745:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010674a:	e9 8f f4 ff ff       	jmp    80105bde <alltraps>

8010674f <vector190>:
.globl vector190
vector190:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $190
80106751:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106756:	e9 83 f4 ff ff       	jmp    80105bde <alltraps>

8010675b <vector191>:
.globl vector191
vector191:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $191
8010675d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106762:	e9 77 f4 ff ff       	jmp    80105bde <alltraps>

80106767 <vector192>:
.globl vector192
vector192:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $192
80106769:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010676e:	e9 6b f4 ff ff       	jmp    80105bde <alltraps>

80106773 <vector193>:
.globl vector193
vector193:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $193
80106775:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010677a:	e9 5f f4 ff ff       	jmp    80105bde <alltraps>

8010677f <vector194>:
.globl vector194
vector194:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $194
80106781:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106786:	e9 53 f4 ff ff       	jmp    80105bde <alltraps>

8010678b <vector195>:
.globl vector195
vector195:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $195
8010678d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106792:	e9 47 f4 ff ff       	jmp    80105bde <alltraps>

80106797 <vector196>:
.globl vector196
vector196:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $196
80106799:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010679e:	e9 3b f4 ff ff       	jmp    80105bde <alltraps>

801067a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $197
801067a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067aa:	e9 2f f4 ff ff       	jmp    80105bde <alltraps>

801067af <vector198>:
.globl vector198
vector198:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $198
801067b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067b6:	e9 23 f4 ff ff       	jmp    80105bde <alltraps>

801067bb <vector199>:
.globl vector199
vector199:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $199
801067bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067c2:	e9 17 f4 ff ff       	jmp    80105bde <alltraps>

801067c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $200
801067c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801067ce:	e9 0b f4 ff ff       	jmp    80105bde <alltraps>

801067d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $201
801067d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801067da:	e9 ff f3 ff ff       	jmp    80105bde <alltraps>

801067df <vector202>:
.globl vector202
vector202:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $202
801067e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067e6:	e9 f3 f3 ff ff       	jmp    80105bde <alltraps>

801067eb <vector203>:
.globl vector203
vector203:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $203
801067ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067f2:	e9 e7 f3 ff ff       	jmp    80105bde <alltraps>

801067f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $204
801067f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067fe:	e9 db f3 ff ff       	jmp    80105bde <alltraps>

80106803 <vector205>:
.globl vector205
vector205:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $205
80106805:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010680a:	e9 cf f3 ff ff       	jmp    80105bde <alltraps>

8010680f <vector206>:
.globl vector206
vector206:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $206
80106811:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106816:	e9 c3 f3 ff ff       	jmp    80105bde <alltraps>

8010681b <vector207>:
.globl vector207
vector207:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $207
8010681d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106822:	e9 b7 f3 ff ff       	jmp    80105bde <alltraps>

80106827 <vector208>:
.globl vector208
vector208:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $208
80106829:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010682e:	e9 ab f3 ff ff       	jmp    80105bde <alltraps>

80106833 <vector209>:
.globl vector209
vector209:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $209
80106835:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010683a:	e9 9f f3 ff ff       	jmp    80105bde <alltraps>

8010683f <vector210>:
.globl vector210
vector210:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $210
80106841:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106846:	e9 93 f3 ff ff       	jmp    80105bde <alltraps>

8010684b <vector211>:
.globl vector211
vector211:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $211
8010684d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106852:	e9 87 f3 ff ff       	jmp    80105bde <alltraps>

80106857 <vector212>:
.globl vector212
vector212:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $212
80106859:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010685e:	e9 7b f3 ff ff       	jmp    80105bde <alltraps>

80106863 <vector213>:
.globl vector213
vector213:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $213
80106865:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010686a:	e9 6f f3 ff ff       	jmp    80105bde <alltraps>

8010686f <vector214>:
.globl vector214
vector214:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $214
80106871:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106876:	e9 63 f3 ff ff       	jmp    80105bde <alltraps>

8010687b <vector215>:
.globl vector215
vector215:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $215
8010687d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106882:	e9 57 f3 ff ff       	jmp    80105bde <alltraps>

80106887 <vector216>:
.globl vector216
vector216:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $216
80106889:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010688e:	e9 4b f3 ff ff       	jmp    80105bde <alltraps>

80106893 <vector217>:
.globl vector217
vector217:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $217
80106895:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010689a:	e9 3f f3 ff ff       	jmp    80105bde <alltraps>

8010689f <vector218>:
.globl vector218
vector218:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $218
801068a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068a6:	e9 33 f3 ff ff       	jmp    80105bde <alltraps>

801068ab <vector219>:
.globl vector219
vector219:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $219
801068ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068b2:	e9 27 f3 ff ff       	jmp    80105bde <alltraps>

801068b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $220
801068b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068be:	e9 1b f3 ff ff       	jmp    80105bde <alltraps>

801068c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $221
801068c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068ca:	e9 0f f3 ff ff       	jmp    80105bde <alltraps>

801068cf <vector222>:
.globl vector222
vector222:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $222
801068d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801068d6:	e9 03 f3 ff ff       	jmp    80105bde <alltraps>

801068db <vector223>:
.globl vector223
vector223:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $223
801068dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068e2:	e9 f7 f2 ff ff       	jmp    80105bde <alltraps>

801068e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $224
801068e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068ee:	e9 eb f2 ff ff       	jmp    80105bde <alltraps>

801068f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $225
801068f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068fa:	e9 df f2 ff ff       	jmp    80105bde <alltraps>

801068ff <vector226>:
.globl vector226
vector226:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $226
80106901:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106906:	e9 d3 f2 ff ff       	jmp    80105bde <alltraps>

8010690b <vector227>:
.globl vector227
vector227:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $227
8010690d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106912:	e9 c7 f2 ff ff       	jmp    80105bde <alltraps>

80106917 <vector228>:
.globl vector228
vector228:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $228
80106919:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010691e:	e9 bb f2 ff ff       	jmp    80105bde <alltraps>

80106923 <vector229>:
.globl vector229
vector229:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $229
80106925:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010692a:	e9 af f2 ff ff       	jmp    80105bde <alltraps>

8010692f <vector230>:
.globl vector230
vector230:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $230
80106931:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106936:	e9 a3 f2 ff ff       	jmp    80105bde <alltraps>

8010693b <vector231>:
.globl vector231
vector231:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $231
8010693d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106942:	e9 97 f2 ff ff       	jmp    80105bde <alltraps>

80106947 <vector232>:
.globl vector232
vector232:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $232
80106949:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010694e:	e9 8b f2 ff ff       	jmp    80105bde <alltraps>

80106953 <vector233>:
.globl vector233
vector233:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $233
80106955:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010695a:	e9 7f f2 ff ff       	jmp    80105bde <alltraps>

8010695f <vector234>:
.globl vector234
vector234:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $234
80106961:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106966:	e9 73 f2 ff ff       	jmp    80105bde <alltraps>

8010696b <vector235>:
.globl vector235
vector235:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $235
8010696d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106972:	e9 67 f2 ff ff       	jmp    80105bde <alltraps>

80106977 <vector236>:
.globl vector236
vector236:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $236
80106979:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010697e:	e9 5b f2 ff ff       	jmp    80105bde <alltraps>

80106983 <vector237>:
.globl vector237
vector237:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $237
80106985:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010698a:	e9 4f f2 ff ff       	jmp    80105bde <alltraps>

8010698f <vector238>:
.globl vector238
vector238:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $238
80106991:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106996:	e9 43 f2 ff ff       	jmp    80105bde <alltraps>

8010699b <vector239>:
.globl vector239
vector239:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $239
8010699d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069a2:	e9 37 f2 ff ff       	jmp    80105bde <alltraps>

801069a7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $240
801069a9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069ae:	e9 2b f2 ff ff       	jmp    80105bde <alltraps>

801069b3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $241
801069b5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069ba:	e9 1f f2 ff ff       	jmp    80105bde <alltraps>

801069bf <vector242>:
.globl vector242
vector242:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $242
801069c1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069c6:	e9 13 f2 ff ff       	jmp    80105bde <alltraps>

801069cb <vector243>:
.globl vector243
vector243:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $243
801069cd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801069d2:	e9 07 f2 ff ff       	jmp    80105bde <alltraps>

801069d7 <vector244>:
.globl vector244
vector244:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $244
801069d9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801069de:	e9 fb f1 ff ff       	jmp    80105bde <alltraps>

801069e3 <vector245>:
.globl vector245
vector245:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $245
801069e5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069ea:	e9 ef f1 ff ff       	jmp    80105bde <alltraps>

801069ef <vector246>:
.globl vector246
vector246:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $246
801069f1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069f6:	e9 e3 f1 ff ff       	jmp    80105bde <alltraps>

801069fb <vector247>:
.globl vector247
vector247:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $247
801069fd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a02:	e9 d7 f1 ff ff       	jmp    80105bde <alltraps>

80106a07 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $248
80106a09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a0e:	e9 cb f1 ff ff       	jmp    80105bde <alltraps>

80106a13 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $249
80106a15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a1a:	e9 bf f1 ff ff       	jmp    80105bde <alltraps>

80106a1f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $250
80106a21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a26:	e9 b3 f1 ff ff       	jmp    80105bde <alltraps>

80106a2b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $251
80106a2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a32:	e9 a7 f1 ff ff       	jmp    80105bde <alltraps>

80106a37 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $252
80106a39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a3e:	e9 9b f1 ff ff       	jmp    80105bde <alltraps>

80106a43 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $253
80106a45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a4a:	e9 8f f1 ff ff       	jmp    80105bde <alltraps>

80106a4f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $254
80106a51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a56:	e9 83 f1 ff ff       	jmp    80105bde <alltraps>

80106a5b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $255
80106a5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a62:	e9 77 f1 ff ff       	jmp    80105bde <alltraps>

80106a67 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a67:	55                   	push   %ebp
80106a68:	89 e5                	mov    %esp,%ebp
80106a6a:	57                   	push   %edi
80106a6b:	56                   	push   %esi
80106a6c:	53                   	push   %ebx
80106a6d:	83 ec 0c             	sub    $0xc,%esp
80106a70:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106a72:	c1 ea 16             	shr    $0x16,%edx
80106a75:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80106a78:	8b 1f                	mov    (%edi),%ebx
80106a7a:	f6 c3 01             	test   $0x1,%bl
80106a7d:	74 21                	je     80106aa0 <walkpgdir+0x39>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a7f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106a85:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a8b:	c1 ee 0a             	shr    $0xa,%esi
80106a8e:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106a94:	01 f3                	add    %esi,%ebx
}
80106a96:	89 d8                	mov    %ebx,%eax
80106a98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a9b:	5b                   	pop    %ebx
80106a9c:	5e                   	pop    %esi
80106a9d:	5f                   	pop    %edi
80106a9e:	5d                   	pop    %ebp
80106a9f:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106aa0:	85 c9                	test   %ecx,%ecx
80106aa2:	74 2b                	je     80106acf <walkpgdir+0x68>
80106aa4:	e8 3c b7 ff ff       	call   801021e5 <kalloc>
80106aa9:	89 c3                	mov    %eax,%ebx
80106aab:	85 c0                	test   %eax,%eax
80106aad:	74 e7                	je     80106a96 <walkpgdir+0x2f>
    memset(pgtab, 0, PGSIZE);
80106aaf:	83 ec 04             	sub    $0x4,%esp
80106ab2:	68 00 10 00 00       	push   $0x1000
80106ab7:	6a 00                	push   $0x0
80106ab9:	50                   	push   %eax
80106aba:	e8 3f df ff ff       	call   801049fe <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106abf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ac5:	83 c8 07             	or     $0x7,%eax
80106ac8:	89 07                	mov    %eax,(%edi)
80106aca:	83 c4 10             	add    $0x10,%esp
80106acd:	eb bc                	jmp    80106a8b <walkpgdir+0x24>
      return 0;
80106acf:	bb 00 00 00 00       	mov    $0x0,%ebx
80106ad4:	eb c0                	jmp    80106a96 <walkpgdir+0x2f>

80106ad6 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ad6:	55                   	push   %ebp
80106ad7:	89 e5                	mov    %esp,%ebp
80106ad9:	57                   	push   %edi
80106ada:	56                   	push   %esi
80106adb:	53                   	push   %ebx
80106adc:	83 ec 1c             	sub    $0x1c,%esp
80106adf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106ae2:	89 d0                	mov    %edx,%eax
80106ae4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ae9:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106aeb:	8d 54 0a ff          	lea    -0x1(%edx,%ecx,1),%edx
80106aef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106af5:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106af8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106afb:	29 c7                	sub    %eax,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106afd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b00:	83 c8 01             	or     $0x1,%eax
80106b03:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b06:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b09:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b0e:	89 da                	mov    %ebx,%edx
80106b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b13:	e8 4f ff ff ff       	call   80106a67 <walkpgdir>
80106b18:	85 c0                	test   %eax,%eax
80106b1a:	74 24                	je     80106b40 <mappages+0x6a>
    if(*pte & PTE_P)
80106b1c:	f6 00 01             	testb  $0x1,(%eax)
80106b1f:	75 12                	jne    80106b33 <mappages+0x5d>
    *pte = pa | perm | PTE_P;
80106b21:	0b 75 dc             	or     -0x24(%ebp),%esi
80106b24:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b26:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80106b29:	74 22                	je     80106b4d <mappages+0x77>
      break;
    a += PGSIZE;
80106b2b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b31:	eb d3                	jmp    80106b06 <mappages+0x30>
      panic("remap");
80106b33:	83 ec 0c             	sub    $0xc,%esp
80106b36:	68 70 7d 10 80       	push   $0x80107d70
80106b3b:	e8 04 98 ff ff       	call   80100344 <panic>
      return -1;
80106b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    pa += PGSIZE;
  }
  return 0;
}
80106b45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b48:	5b                   	pop    %ebx
80106b49:	5e                   	pop    %esi
80106b4a:	5f                   	pop    %edi
80106b4b:	5d                   	pop    %ebp
80106b4c:	c3                   	ret    
  return 0;
80106b4d:	b8 00 00 00 00       	mov    $0x0,%eax
80106b52:	eb f1                	jmp    80106b45 <mappages+0x6f>

80106b54 <seginit>:
{
80106b54:	55                   	push   %ebp
80106b55:	89 e5                	mov    %esp,%ebp
80106b57:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b5a:	e8 07 ca ff ff       	call   80103566 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b5f:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b65:	66 c7 80 98 4d 11 80 	movw   $0xffff,-0x7feeb268(%eax)
80106b6c:	ff ff 
80106b6e:	66 c7 80 9a 4d 11 80 	movw   $0x0,-0x7feeb266(%eax)
80106b75:	00 00 
80106b77:	c6 80 9c 4d 11 80 00 	movb   $0x0,-0x7feeb264(%eax)
80106b7e:	c6 80 9d 4d 11 80 9a 	movb   $0x9a,-0x7feeb263(%eax)
80106b85:	c6 80 9e 4d 11 80 cf 	movb   $0xcf,-0x7feeb262(%eax)
80106b8c:	c6 80 9f 4d 11 80 00 	movb   $0x0,-0x7feeb261(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b93:	66 c7 80 a0 4d 11 80 	movw   $0xffff,-0x7feeb260(%eax)
80106b9a:	ff ff 
80106b9c:	66 c7 80 a2 4d 11 80 	movw   $0x0,-0x7feeb25e(%eax)
80106ba3:	00 00 
80106ba5:	c6 80 a4 4d 11 80 00 	movb   $0x0,-0x7feeb25c(%eax)
80106bac:	c6 80 a5 4d 11 80 92 	movb   $0x92,-0x7feeb25b(%eax)
80106bb3:	c6 80 a6 4d 11 80 cf 	movb   $0xcf,-0x7feeb25a(%eax)
80106bba:	c6 80 a7 4d 11 80 00 	movb   $0x0,-0x7feeb259(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106bc1:	66 c7 80 a8 4d 11 80 	movw   $0xffff,-0x7feeb258(%eax)
80106bc8:	ff ff 
80106bca:	66 c7 80 aa 4d 11 80 	movw   $0x0,-0x7feeb256(%eax)
80106bd1:	00 00 
80106bd3:	c6 80 ac 4d 11 80 00 	movb   $0x0,-0x7feeb254(%eax)
80106bda:	c6 80 ad 4d 11 80 fa 	movb   $0xfa,-0x7feeb253(%eax)
80106be1:	c6 80 ae 4d 11 80 cf 	movb   $0xcf,-0x7feeb252(%eax)
80106be8:	c6 80 af 4d 11 80 00 	movb   $0x0,-0x7feeb251(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106bef:	66 c7 80 b0 4d 11 80 	movw   $0xffff,-0x7feeb250(%eax)
80106bf6:	ff ff 
80106bf8:	66 c7 80 b2 4d 11 80 	movw   $0x0,-0x7feeb24e(%eax)
80106bff:	00 00 
80106c01:	c6 80 b4 4d 11 80 00 	movb   $0x0,-0x7feeb24c(%eax)
80106c08:	c6 80 b5 4d 11 80 f2 	movb   $0xf2,-0x7feeb24b(%eax)
80106c0f:	c6 80 b6 4d 11 80 cf 	movb   $0xcf,-0x7feeb24a(%eax)
80106c16:	c6 80 b7 4d 11 80 00 	movb   $0x0,-0x7feeb249(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106c1d:	05 90 4d 11 80       	add    $0x80114d90,%eax
  pd[0] = size-1;
80106c22:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80106c28:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c2c:	c1 e8 10             	shr    $0x10,%eax
80106c2f:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c33:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c36:	0f 01 10             	lgdtl  (%eax)
}
80106c39:	c9                   	leave  
80106c3a:	c3                   	ret    

80106c3b <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106c3b:	55                   	push   %ebp
80106c3c:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c3e:	a1 c4 5a 11 80       	mov    0x80115ac4,%eax
80106c43:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c48:	0f 22 d8             	mov    %eax,%cr3
}
80106c4b:	5d                   	pop    %ebp
80106c4c:	c3                   	ret    

80106c4d <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106c4d:	55                   	push   %ebp
80106c4e:	89 e5                	mov    %esp,%ebp
80106c50:	57                   	push   %edi
80106c51:	56                   	push   %esi
80106c52:	53                   	push   %ebx
80106c53:	83 ec 1c             	sub    $0x1c,%esp
80106c56:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c59:	85 f6                	test   %esi,%esi
80106c5b:	0f 84 c3 00 00 00    	je     80106d24 <switchuvm+0xd7>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106c61:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80106c65:	0f 84 c6 00 00 00    	je     80106d31 <switchuvm+0xe4>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106c6b:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80106c6f:	0f 84 c9 00 00 00    	je     80106d3e <switchuvm+0xf1>
    panic("switchuvm: no pgdir");

  pushcli();
80106c75:	e8 05 dc ff ff       	call   8010487f <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c7a:	e8 70 c8 ff ff       	call   801034ef <mycpu>
80106c7f:	89 c3                	mov    %eax,%ebx
80106c81:	e8 69 c8 ff ff       	call   801034ef <mycpu>
80106c86:	89 c7                	mov    %eax,%edi
80106c88:	e8 62 c8 ff ff       	call   801034ef <mycpu>
80106c8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c90:	e8 5a c8 ff ff       	call   801034ef <mycpu>
80106c95:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106c9c:	67 00 
80106c9e:	83 c7 08             	add    $0x8,%edi
80106ca1:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106ca8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106cab:	83 c2 08             	add    $0x8,%edx
80106cae:	c1 ea 10             	shr    $0x10,%edx
80106cb1:	88 93 9c 00 00 00    	mov    %dl,0x9c(%ebx)
80106cb7:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106cbe:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106cc5:	83 c0 08             	add    $0x8,%eax
80106cc8:	c1 e8 18             	shr    $0x18,%eax
80106ccb:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106cd1:	e8 19 c8 ff ff       	call   801034ef <mycpu>
80106cd6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cdd:	e8 0d c8 ff ff       	call   801034ef <mycpu>
80106ce2:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ce8:	8b 5e 08             	mov    0x8(%esi),%ebx
80106ceb:	e8 ff c7 ff ff       	call   801034ef <mycpu>
80106cf0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cf6:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cf9:	e8 f1 c7 ff ff       	call   801034ef <mycpu>
80106cfe:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d04:	b8 28 00 00 00       	mov    $0x28,%eax
80106d09:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d0c:	8b 46 04             	mov    0x4(%esi),%eax
80106d0f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d14:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106d17:	e8 a0 db ff ff       	call   801048bc <popcli>
}
80106d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d1f:	5b                   	pop    %ebx
80106d20:	5e                   	pop    %esi
80106d21:	5f                   	pop    %edi
80106d22:	5d                   	pop    %ebp
80106d23:	c3                   	ret    
    panic("switchuvm: no process");
80106d24:	83 ec 0c             	sub    $0xc,%esp
80106d27:	68 76 7d 10 80       	push   $0x80107d76
80106d2c:	e8 13 96 ff ff       	call   80100344 <panic>
    panic("switchuvm: no kstack");
80106d31:	83 ec 0c             	sub    $0xc,%esp
80106d34:	68 8c 7d 10 80       	push   $0x80107d8c
80106d39:	e8 06 96 ff ff       	call   80100344 <panic>
    panic("switchuvm: no pgdir");
80106d3e:	83 ec 0c             	sub    $0xc,%esp
80106d41:	68 a1 7d 10 80       	push   $0x80107da1
80106d46:	e8 f9 95 ff ff       	call   80100344 <panic>

80106d4b <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106d4b:	55                   	push   %ebp
80106d4c:	89 e5                	mov    %esp,%ebp
80106d4e:	56                   	push   %esi
80106d4f:	53                   	push   %ebx
80106d50:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106d53:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d59:	77 4c                	ja     80106da7 <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
80106d5b:	e8 85 b4 ff ff       	call   801021e5 <kalloc>
80106d60:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d62:	83 ec 04             	sub    $0x4,%esp
80106d65:	68 00 10 00 00       	push   $0x1000
80106d6a:	6a 00                	push   $0x0
80106d6c:	50                   	push   %eax
80106d6d:	e8 8c dc ff ff       	call   801049fe <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d72:	83 c4 08             	add    $0x8,%esp
80106d75:	6a 06                	push   $0x6
80106d77:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d7d:	50                   	push   %eax
80106d7e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d83:	ba 00 00 00 00       	mov    $0x0,%edx
80106d88:	8b 45 08             	mov    0x8(%ebp),%eax
80106d8b:	e8 46 fd ff ff       	call   80106ad6 <mappages>
  memmove(mem, init, sz);
80106d90:	83 c4 0c             	add    $0xc,%esp
80106d93:	56                   	push   %esi
80106d94:	ff 75 0c             	pushl  0xc(%ebp)
80106d97:	53                   	push   %ebx
80106d98:	e8 f6 dc ff ff       	call   80104a93 <memmove>
}
80106d9d:	83 c4 10             	add    $0x10,%esp
80106da0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106da3:	5b                   	pop    %ebx
80106da4:	5e                   	pop    %esi
80106da5:	5d                   	pop    %ebp
80106da6:	c3                   	ret    
    panic("inituvm: more than a page");
80106da7:	83 ec 0c             	sub    $0xc,%esp
80106daa:	68 b5 7d 10 80       	push   $0x80107db5
80106daf:	e8 90 95 ff ff       	call   80100344 <panic>

80106db4 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106db4:	55                   	push   %ebp
80106db5:	89 e5                	mov    %esp,%ebp
80106db7:	57                   	push   %edi
80106db8:	56                   	push   %esi
80106db9:	53                   	push   %ebx
80106dba:	83 ec 1c             	sub    $0x1c,%esp
80106dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106dc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106dc3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106dc8:	75 71                	jne    80106e3b <loaduvm+0x87>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106dca:	8b 75 18             	mov    0x18(%ebp),%esi
80106dcd:	bb 00 00 00 00       	mov    $0x0,%ebx
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106dd2:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106dd7:	85 f6                	test   %esi,%esi
80106dd9:	74 7f                	je     80106e5a <loaduvm+0xa6>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dde:	8d 14 18             	lea    (%eax,%ebx,1),%edx
80106de1:	b9 00 00 00 00       	mov    $0x0,%ecx
80106de6:	8b 45 08             	mov    0x8(%ebp),%eax
80106de9:	e8 79 fc ff ff       	call   80106a67 <walkpgdir>
80106dee:	85 c0                	test   %eax,%eax
80106df0:	74 56                	je     80106e48 <loaduvm+0x94>
    pa = PTE_ADDR(*pte);
80106df2:	8b 00                	mov    (%eax),%eax
80106df4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = sz - i;
80106df9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106dff:	bf 00 10 00 00       	mov    $0x1000,%edi
80106e04:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e07:	57                   	push   %edi
80106e08:	89 da                	mov    %ebx,%edx
80106e0a:	03 55 14             	add    0x14(%ebp),%edx
80106e0d:	52                   	push   %edx
80106e0e:	05 00 00 00 80       	add    $0x80000000,%eax
80106e13:	50                   	push   %eax
80106e14:	ff 75 10             	pushl  0x10(%ebp)
80106e17:	e8 e5 a9 ff ff       	call   80101801 <readi>
80106e1c:	83 c4 10             	add    $0x10,%esp
80106e1f:	39 f8                	cmp    %edi,%eax
80106e21:	75 32                	jne    80106e55 <loaduvm+0xa1>
  for(i = 0; i < sz; i += PGSIZE){
80106e23:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e29:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106e2f:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106e32:	77 a7                	ja     80106ddb <loaduvm+0x27>
  return 0;
80106e34:	b8 00 00 00 00       	mov    $0x0,%eax
80106e39:	eb 1f                	jmp    80106e5a <loaduvm+0xa6>
    panic("loaduvm: addr must be page aligned");
80106e3b:	83 ec 0c             	sub    $0xc,%esp
80106e3e:	68 70 7e 10 80       	push   $0x80107e70
80106e43:	e8 fc 94 ff ff       	call   80100344 <panic>
      panic("loaduvm: address should exist");
80106e48:	83 ec 0c             	sub    $0xc,%esp
80106e4b:	68 cf 7d 10 80       	push   $0x80107dcf
80106e50:	e8 ef 94 ff ff       	call   80100344 <panic>
      return -1;
80106e55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e5d:	5b                   	pop    %ebx
80106e5e:	5e                   	pop    %esi
80106e5f:	5f                   	pop    %edi
80106e60:	5d                   	pop    %ebp
80106e61:	c3                   	ret    

80106e62 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106e62:	55                   	push   %ebp
80106e63:	89 e5                	mov    %esp,%ebp
80106e65:	57                   	push   %edi
80106e66:	56                   	push   %esi
80106e67:	53                   	push   %ebx
80106e68:	83 ec 0c             	sub    $0xc,%esp
80106e6b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
80106e6e:	89 f8                	mov    %edi,%eax
  if(newsz >= oldsz)
80106e70:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106e73:	73 16                	jae    80106e8b <deallocuvm+0x29>

  a = PGROUNDUP(newsz);
80106e75:	8b 45 10             	mov    0x10(%ebp),%eax
80106e78:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106e7e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106e84:	39 df                	cmp    %ebx,%edi
80106e86:	77 21                	ja     80106ea9 <deallocuvm+0x47>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80106e88:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e8e:	5b                   	pop    %ebx
80106e8f:	5e                   	pop    %esi
80106e90:	5f                   	pop    %edi
80106e91:	5d                   	pop    %ebp
80106e92:	c3                   	ret    
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e93:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106e99:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106e9f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ea5:	39 df                	cmp    %ebx,%edi
80106ea7:	76 df                	jbe    80106e88 <deallocuvm+0x26>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106ea9:	b9 00 00 00 00       	mov    $0x0,%ecx
80106eae:	89 da                	mov    %ebx,%edx
80106eb0:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb3:	e8 af fb ff ff       	call   80106a67 <walkpgdir>
80106eb8:	89 c6                	mov    %eax,%esi
    if(!pte)
80106eba:	85 c0                	test   %eax,%eax
80106ebc:	74 d5                	je     80106e93 <deallocuvm+0x31>
    else if((*pte & PTE_P) != 0){
80106ebe:	8b 00                	mov    (%eax),%eax
80106ec0:	a8 01                	test   $0x1,%al
80106ec2:	74 db                	je     80106e9f <deallocuvm+0x3d>
      if(pa == 0)
80106ec4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ec9:	74 19                	je     80106ee4 <deallocuvm+0x82>
      kfree(v);
80106ecb:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106ece:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106ed3:	50                   	push   %eax
80106ed4:	e8 e7 b1 ff ff       	call   801020c0 <kfree>
      *pte = 0;
80106ed9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106edf:	83 c4 10             	add    $0x10,%esp
80106ee2:	eb bb                	jmp    80106e9f <deallocuvm+0x3d>
        panic("kfree");
80106ee4:	83 ec 0c             	sub    $0xc,%esp
80106ee7:	68 fa 74 10 80       	push   $0x801074fa
80106eec:	e8 53 94 ff ff       	call   80100344 <panic>

80106ef1 <allocuvm>:
{
80106ef1:	55                   	push   %ebp
80106ef2:	89 e5                	mov    %esp,%ebp
80106ef4:	57                   	push   %edi
80106ef5:	56                   	push   %esi
80106ef6:	53                   	push   %ebx
80106ef7:	83 ec 1c             	sub    $0x1c,%esp
80106efa:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106efd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106f00:	85 ff                	test   %edi,%edi
80106f02:	0f 88 c5 00 00 00    	js     80106fcd <allocuvm+0xdc>
  if(newsz < oldsz)
80106f08:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f0b:	72 60                	jb     80106f6d <allocuvm+0x7c>
  a = PGROUNDUP(oldsz);
80106f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f10:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106f16:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106f1c:	39 df                	cmp    %ebx,%edi
80106f1e:	0f 86 b0 00 00 00    	jbe    80106fd4 <allocuvm+0xe3>
    mem = kalloc();
80106f24:	e8 bc b2 ff ff       	call   801021e5 <kalloc>
80106f29:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106f2b:	85 c0                	test   %eax,%eax
80106f2d:	74 46                	je     80106f75 <allocuvm+0x84>
    memset(mem, 0, PGSIZE);
80106f2f:	83 ec 04             	sub    $0x4,%esp
80106f32:	68 00 10 00 00       	push   $0x1000
80106f37:	6a 00                	push   $0x0
80106f39:	50                   	push   %eax
80106f3a:	e8 bf da ff ff       	call   801049fe <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f3f:	83 c4 08             	add    $0x8,%esp
80106f42:	6a 06                	push   $0x6
80106f44:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f4a:	50                   	push   %eax
80106f4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f50:	89 da                	mov    %ebx,%edx
80106f52:	8b 45 08             	mov    0x8(%ebp),%eax
80106f55:	e8 7c fb ff ff       	call   80106ad6 <mappages>
80106f5a:	83 c4 10             	add    $0x10,%esp
80106f5d:	85 c0                	test   %eax,%eax
80106f5f:	78 3c                	js     80106f9d <allocuvm+0xac>
  for(; a < newsz; a += PGSIZE){
80106f61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f67:	39 df                	cmp    %ebx,%edi
80106f69:	77 b9                	ja     80106f24 <allocuvm+0x33>
80106f6b:	eb 67                	jmp    80106fd4 <allocuvm+0xe3>
    return oldsz;
80106f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f73:	eb 5f                	jmp    80106fd4 <allocuvm+0xe3>
      cprintf("allocuvm out of memory\n");
80106f75:	83 ec 0c             	sub    $0xc,%esp
80106f78:	68 ed 7d 10 80       	push   $0x80107ded
80106f7d:	e8 5f 96 ff ff       	call   801005e1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106f82:	83 c4 0c             	add    $0xc,%esp
80106f85:	ff 75 0c             	pushl  0xc(%ebp)
80106f88:	57                   	push   %edi
80106f89:	ff 75 08             	pushl  0x8(%ebp)
80106f8c:	e8 d1 fe ff ff       	call   80106e62 <deallocuvm>
      return 0;
80106f91:	83 c4 10             	add    $0x10,%esp
80106f94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106f9b:	eb 37                	jmp    80106fd4 <allocuvm+0xe3>
      cprintf("allocuvm out of memory (2)\n");
80106f9d:	83 ec 0c             	sub    $0xc,%esp
80106fa0:	68 05 7e 10 80       	push   $0x80107e05
80106fa5:	e8 37 96 ff ff       	call   801005e1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106faa:	83 c4 0c             	add    $0xc,%esp
80106fad:	ff 75 0c             	pushl  0xc(%ebp)
80106fb0:	57                   	push   %edi
80106fb1:	ff 75 08             	pushl  0x8(%ebp)
80106fb4:	e8 a9 fe ff ff       	call   80106e62 <deallocuvm>
      kfree(mem);
80106fb9:	89 34 24             	mov    %esi,(%esp)
80106fbc:	e8 ff b0 ff ff       	call   801020c0 <kfree>
      return 0;
80106fc1:	83 c4 10             	add    $0x10,%esp
80106fc4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106fcb:	eb 07                	jmp    80106fd4 <allocuvm+0xe3>
    return 0;
80106fcd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fda:	5b                   	pop    %ebx
80106fdb:	5e                   	pop    %esi
80106fdc:	5f                   	pop    %edi
80106fdd:	5d                   	pop    %ebp
80106fde:	c3                   	ret    

80106fdf <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106fdf:	55                   	push   %ebp
80106fe0:	89 e5                	mov    %esp,%ebp
80106fe2:	57                   	push   %edi
80106fe3:	56                   	push   %esi
80106fe4:	53                   	push   %ebx
80106fe5:	83 ec 0c             	sub    $0xc,%esp
80106fe8:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;

  if(pgdir == 0)
80106feb:	85 ff                	test   %edi,%edi
80106fed:	74 1d                	je     8010700c <freevm+0x2d>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80106fef:	83 ec 04             	sub    $0x4,%esp
80106ff2:	6a 00                	push   $0x0
80106ff4:	68 00 00 00 80       	push   $0x80000000
80106ff9:	57                   	push   %edi
80106ffa:	e8 63 fe ff ff       	call   80106e62 <deallocuvm>
80106fff:	89 fb                	mov    %edi,%ebx
80107001:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
80107007:	83 c4 10             	add    $0x10,%esp
8010700a:	eb 14                	jmp    80107020 <freevm+0x41>
    panic("freevm: no pgdir");
8010700c:	83 ec 0c             	sub    $0xc,%esp
8010700f:	68 21 7e 10 80       	push   $0x80107e21
80107014:	e8 2b 93 ff ff       	call   80100344 <panic>
80107019:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
8010701c:	39 f3                	cmp    %esi,%ebx
8010701e:	74 1e                	je     8010703e <freevm+0x5f>
    if(pgdir[i] & PTE_P){
80107020:	8b 03                	mov    (%ebx),%eax
80107022:	a8 01                	test   $0x1,%al
80107024:	74 f3                	je     80107019 <freevm+0x3a>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80107026:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107029:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010702e:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107033:	50                   	push   %eax
80107034:	e8 87 b0 ff ff       	call   801020c0 <kfree>
80107039:	83 c4 10             	add    $0x10,%esp
8010703c:	eb db                	jmp    80107019 <freevm+0x3a>
    }
  }
  kfree((char*)pgdir);
8010703e:	83 ec 0c             	sub    $0xc,%esp
80107041:	57                   	push   %edi
80107042:	e8 79 b0 ff ff       	call   801020c0 <kfree>
}
80107047:	83 c4 10             	add    $0x10,%esp
8010704a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010704d:	5b                   	pop    %ebx
8010704e:	5e                   	pop    %esi
8010704f:	5f                   	pop    %edi
80107050:	5d                   	pop    %ebp
80107051:	c3                   	ret    

80107052 <setupkvm>:
{
80107052:	55                   	push   %ebp
80107053:	89 e5                	mov    %esp,%ebp
80107055:	56                   	push   %esi
80107056:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107057:	e8 89 b1 ff ff       	call   801021e5 <kalloc>
8010705c:	89 c6                	mov    %eax,%esi
8010705e:	85 c0                	test   %eax,%eax
80107060:	74 42                	je     801070a4 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107062:	83 ec 04             	sub    $0x4,%esp
80107065:	68 00 10 00 00       	push   $0x1000
8010706a:	6a 00                	push   $0x0
8010706c:	50                   	push   %eax
8010706d:	e8 8c d9 ff ff       	call   801049fe <memset>
80107072:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107075:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
8010707a:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010707d:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107080:	29 c1                	sub    %eax,%ecx
80107082:	83 ec 08             	sub    $0x8,%esp
80107085:	ff 73 0c             	pushl  0xc(%ebx)
80107088:	50                   	push   %eax
80107089:	8b 13                	mov    (%ebx),%edx
8010708b:	89 f0                	mov    %esi,%eax
8010708d:	e8 44 fa ff ff       	call   80106ad6 <mappages>
80107092:	83 c4 10             	add    $0x10,%esp
80107095:	85 c0                	test   %eax,%eax
80107097:	78 14                	js     801070ad <setupkvm+0x5b>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107099:	83 c3 10             	add    $0x10,%ebx
8010709c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801070a2:	75 d6                	jne    8010707a <setupkvm+0x28>
}
801070a4:	89 f0                	mov    %esi,%eax
801070a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070a9:	5b                   	pop    %ebx
801070aa:	5e                   	pop    %esi
801070ab:	5d                   	pop    %ebp
801070ac:	c3                   	ret    
      freevm(pgdir);
801070ad:	83 ec 0c             	sub    $0xc,%esp
801070b0:	56                   	push   %esi
801070b1:	e8 29 ff ff ff       	call   80106fdf <freevm>
      return 0;
801070b6:	83 c4 10             	add    $0x10,%esp
801070b9:	be 00 00 00 00       	mov    $0x0,%esi
801070be:	eb e4                	jmp    801070a4 <setupkvm+0x52>

801070c0 <kvmalloc>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801070c6:	e8 87 ff ff ff       	call   80107052 <setupkvm>
801070cb:	a3 c4 5a 11 80       	mov    %eax,0x80115ac4
  switchkvm();
801070d0:	e8 66 fb ff ff       	call   80106c3b <switchkvm>
}
801070d5:	c9                   	leave  
801070d6:	c3                   	ret    

801070d7 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801070d7:	55                   	push   %ebp
801070d8:	89 e5                	mov    %esp,%ebp
801070da:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070dd:	b9 00 00 00 00       	mov    $0x0,%ecx
801070e2:	8b 55 0c             	mov    0xc(%ebp),%edx
801070e5:	8b 45 08             	mov    0x8(%ebp),%eax
801070e8:	e8 7a f9 ff ff       	call   80106a67 <walkpgdir>
  if(pte == 0)
801070ed:	85 c0                	test   %eax,%eax
801070ef:	74 05                	je     801070f6 <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
801070f1:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801070f4:	c9                   	leave  
801070f5:	c3                   	ret    
    panic("clearpteu");
801070f6:	83 ec 0c             	sub    $0xc,%esp
801070f9:	68 32 7e 10 80       	push   $0x80107e32
801070fe:	e8 41 92 ff ff       	call   80100344 <panic>

80107103 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107103:	55                   	push   %ebp
80107104:	89 e5                	mov    %esp,%ebp
80107106:	57                   	push   %edi
80107107:	56                   	push   %esi
80107108:	53                   	push   %ebx
80107109:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010710c:	e8 41 ff ff ff       	call   80107052 <setupkvm>
80107111:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107114:	85 c0                	test   %eax,%eax
80107116:	0f 84 bb 00 00 00    	je     801071d7 <copyuvm+0xd4>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010711c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80107120:	0f 84 b1 00 00 00    	je     801071d7 <copyuvm+0xd4>
80107126:	bf 00 00 00 00       	mov    $0x0,%edi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010712b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010712e:	b9 00 00 00 00       	mov    $0x0,%ecx
80107133:	89 fa                	mov    %edi,%edx
80107135:	8b 45 08             	mov    0x8(%ebp),%eax
80107138:	e8 2a f9 ff ff       	call   80106a67 <walkpgdir>
8010713d:	85 c0                	test   %eax,%eax
8010713f:	74 67                	je     801071a8 <copyuvm+0xa5>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107141:	8b 00                	mov    (%eax),%eax
80107143:	a8 01                	test   $0x1,%al
80107145:	74 6e                	je     801071b5 <copyuvm+0xb2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107147:	89 c6                	mov    %eax,%esi
80107149:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
8010714f:	25 ff 0f 00 00       	and    $0xfff,%eax
80107154:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80107157:	e8 89 b0 ff ff       	call   801021e5 <kalloc>
8010715c:	89 c3                	mov    %eax,%ebx
8010715e:	85 c0                	test   %eax,%eax
80107160:	74 60                	je     801071c2 <copyuvm+0xbf>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107162:	83 ec 04             	sub    $0x4,%esp
80107165:	68 00 10 00 00       	push   $0x1000
8010716a:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80107170:	56                   	push   %esi
80107171:	50                   	push   %eax
80107172:	e8 1c d9 ff ff       	call   80104a93 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107177:	83 c4 08             	add    $0x8,%esp
8010717a:	ff 75 e0             	pushl  -0x20(%ebp)
8010717d:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107183:	53                   	push   %ebx
80107184:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107189:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010718c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010718f:	e8 42 f9 ff ff       	call   80106ad6 <mappages>
80107194:	83 c4 10             	add    $0x10,%esp
80107197:	85 c0                	test   %eax,%eax
80107199:	78 27                	js     801071c2 <copyuvm+0xbf>
  for(i = 0; i < sz; i += PGSIZE){
8010719b:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071a1:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801071a4:	77 85                	ja     8010712b <copyuvm+0x28>
801071a6:	eb 2f                	jmp    801071d7 <copyuvm+0xd4>
      panic("copyuvm: pte should exist");
801071a8:	83 ec 0c             	sub    $0xc,%esp
801071ab:	68 3c 7e 10 80       	push   $0x80107e3c
801071b0:	e8 8f 91 ff ff       	call   80100344 <panic>
      panic("copyuvm: page not present");
801071b5:	83 ec 0c             	sub    $0xc,%esp
801071b8:	68 56 7e 10 80       	push   $0x80107e56
801071bd:	e8 82 91 ff ff       	call   80100344 <panic>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801071c2:	83 ec 0c             	sub    $0xc,%esp
801071c5:	ff 75 dc             	pushl  -0x24(%ebp)
801071c8:	e8 12 fe ff ff       	call   80106fdf <freevm>
  return 0;
801071cd:	83 c4 10             	add    $0x10,%esp
801071d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
801071d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801071da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071dd:	5b                   	pop    %ebx
801071de:	5e                   	pop    %esi
801071df:	5f                   	pop    %edi
801071e0:	5d                   	pop    %ebp
801071e1:	c3                   	ret    

801071e2 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071e2:	55                   	push   %ebp
801071e3:	89 e5                	mov    %esp,%ebp
801071e5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071e8:	b9 00 00 00 00       	mov    $0x0,%ecx
801071ed:	8b 55 0c             	mov    0xc(%ebp),%edx
801071f0:	8b 45 08             	mov    0x8(%ebp),%eax
801071f3:	e8 6f f8 ff ff       	call   80106a67 <walkpgdir>
  if((*pte & PTE_P) == 0)
801071f8:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801071fa:	89 c2                	mov    %eax,%edx
801071fc:	83 e2 05             	and    $0x5,%edx
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801071ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107204:	05 00 00 00 80       	add    $0x80000000,%eax
80107209:	83 fa 05             	cmp    $0x5,%edx
8010720c:	ba 00 00 00 00       	mov    $0x0,%edx
80107211:	0f 45 c2             	cmovne %edx,%eax
}
80107214:	c9                   	leave  
80107215:	c3                   	ret    

80107216 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107216:	55                   	push   %ebp
80107217:	89 e5                	mov    %esp,%ebp
80107219:	57                   	push   %edi
8010721a:	56                   	push   %esi
8010721b:	53                   	push   %ebx
8010721c:	83 ec 0c             	sub    $0xc,%esp
8010721f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107222:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107226:	74 55                	je     8010727d <copyout+0x67>
    va0 = (uint)PGROUNDDOWN(va);
80107228:	89 df                	mov    %ebx,%edi
8010722a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107230:	83 ec 08             	sub    $0x8,%esp
80107233:	57                   	push   %edi
80107234:	ff 75 08             	pushl  0x8(%ebp)
80107237:	e8 a6 ff ff ff       	call   801071e2 <uva2ka>
    if(pa0 == 0)
8010723c:	83 c4 10             	add    $0x10,%esp
8010723f:	85 c0                	test   %eax,%eax
80107241:	74 41                	je     80107284 <copyout+0x6e>
      return -1;
    n = PGSIZE - (va - va0);
80107243:	89 fe                	mov    %edi,%esi
80107245:	29 de                	sub    %ebx,%esi
80107247:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010724d:	3b 75 14             	cmp    0x14(%ebp),%esi
80107250:	0f 47 75 14          	cmova  0x14(%ebp),%esi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107254:	83 ec 04             	sub    $0x4,%esp
80107257:	56                   	push   %esi
80107258:	ff 75 10             	pushl  0x10(%ebp)
8010725b:	29 fb                	sub    %edi,%ebx
8010725d:	01 d8                	add    %ebx,%eax
8010725f:	50                   	push   %eax
80107260:	e8 2e d8 ff ff       	call   80104a93 <memmove>
    len -= n;
    buf += n;
80107265:	01 75 10             	add    %esi,0x10(%ebp)
    va = va0 + PGSIZE;
80107268:	8d 9f 00 10 00 00    	lea    0x1000(%edi),%ebx
  while(len > 0){
8010726e:	83 c4 10             	add    $0x10,%esp
80107271:	29 75 14             	sub    %esi,0x14(%ebp)
80107274:	75 b2                	jne    80107228 <copyout+0x12>
  }
  return 0;
80107276:	b8 00 00 00 00       	mov    $0x0,%eax
8010727b:	eb 0c                	jmp    80107289 <copyout+0x73>
8010727d:	b8 00 00 00 00       	mov    $0x0,%eax
80107282:	eb 05                	jmp    80107289 <copyout+0x73>
      return -1;
80107284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107289:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010728c:	5b                   	pop    %ebx
8010728d:	5e                   	pop    %esi
8010728e:	5f                   	pop    %edi
8010728f:	5d                   	pop    %ebp
80107290:	c3                   	ret    
