This is a mirror of AVISubDetector source code that is no longer available on the internet.

***

AVISubDetector Version 0.4.9.3 beta


This program (AVISubDetector) is created to simplify process
of timing subtitles hard-burned into source AVI.

It is mostly aimed at anime content.

Author can be contacted at bat@etel.ru

Simplified guide:
If too many non-subtitle frames are detected as subtitles,
you should increase Block Value, Drop Values and decrease
slider to leftmost position if it's not already there.

You can also increase Block Count and Line Count a bit (by 1-5),
but that is not recommended - default values for them should
be fine in most cases, and where they aren't, changing them
to the point where they'll not detect subtitle where there is none
but it is detected with default setting will most likely cause them
to skip places with subtitles too.

If frames containing subtitles are not detected as such, you
should decrease "Drop Values", Block Value and move slider
to one of the positions to the right.

If subtitle change is detected wrongly, you should check values
for MED, LBC and DLC in square brackets, note those above
value set at "Tracking Changes", and change values accordingly.

If subtitle change is not detected, you can try decreasing
MED and LBC... or maybe just live with that and fix that
manually later.

It is generally recommended to skip opening sequences
when processing anime - as credits there are often
detected all too well...

In window appearing after checking "Show AVI" you can
see which parts of picture are considered to contain subtitle,
and also load picture from BMP to tune detection.
"Check BV", depeding on button "L", shows either "sharp"
blocks in the picture or "sharp" lines in inverted colors.
"Influence" shows pixels not zeroed by "Drop Values".

Black vertical line on the graphic to the right corresponds to Block Count limit.
If DLC shown after "Check BV" is above Line Count, then program will
decide that this frame contains subtitle.

"Substraction", "[DOM]" and "<DOM>" will currently only
work during avi playback. 

"=DOM" sets current "dominating color"
to the pixel on which you previouly clicked, and "+DOM" adds that
pixel color as additional "dominating color".

Complete Theory of Operation:

Each line the in picture is separated to 16-pixel blocks (with rightmost block ignored for simplicity).
For each block progam calculates sum of absolute differences between pixels for each color component,
and if that sum exceeds set threshold (Block Value), that block is considered to be "sharp" and possibly
containing subtitle.

If absolute difference in color component for a given pixel is below
one set at "Drop Values", that difference is considered to be zero
and is ignored in Pixel Sum. If sum of all differences for a given pixel
is below one set at "Drop Values" for sum (and Sum checkbox is set)
that pixel difference is considered to be zero.

Slider above "Drop Values" sets distance between pixels checked
for absolute difference. Default is 1 (check pixels next to each over).
You can set it to 2 or 3 if there is really strong blurring or antialiasing
which inhibits subtitle detection, but you'll most likely also have
to increase Block Value too to prevent noise aplification.
Default Block Value of 200 is fairly optimistic and relies mostly
on supression of medium color changes by "Drop Values".

RedDiff   = Abs(   Red[X, Y] -   Red[X+Offset, Y] );
GreenDiff = Abs( Green[X, Y] - Green[X+Offset, Y] );
BlueDiff  = Abs(  Blue[X, Y] -  Blue[X+Offset, Y] );
PixelValue = RedDiff + GreenDiff + BlueDiff;
BlockValue = Sum (PixelValues);

Once Block Value exceeds the threshold, that Block is considered to be "sharp".
Once we got all Block Values for a line, they are counted in rather simple manner:
0111110 => BlockCount=4 (1 - sharp block, 0 - non-sharp block)
0110110 => BlockCount=2
0101010 => BlockCount=0
Hope you get an idea. Only consecutive blocks add to BlockCount.
Once line exceeds set BlockCount, it is considered to be "sharp" too.
Then we check lines in the same manner as blocks in previous example
to obtain LineCount, and once that exceeds set value, we consider that
frame as containing subtitle.

As you see, everything is really simple... I implemented this after about
six hours of programming and was truly amazed how good results were
compared to what i expected...

Program detected appearing subtitles really well; but once
there was no delay between subtitle change, that was insufficient.

So i added "Tracking Changes".
"MED" tracks difference between average number of blocks divided
by number of lines (multiplied by 10 for precision), therefore
reacting to change in subtitle horizontal length.

"DLC" track difference between count of detected lines,
therefore reacting to transitions between one- and two-lined subtitles.

"LBC" track difference in number of lines with same block count,
which should react to both width and height changes...
but it's not really useful, and you might want to turn it off
if there is too many false change detections.
I should probably add another threshold there which
will "join" lines with block count difference below set value.

"MBC" checks maximum number of blocks in detected lines,
and in general produces too much noise at low settings
and adds quite little at high settings.

For each of these values the number in square brackets
shows value which caused program to detect change.
If that change was wrong (and not once), you should set
corresponding tracking value above wrong one.

