srttimer
========

Small script to adjust time of subtitles in SRT file when the subtitle is not timing for the video (video is from different source for example).

Usage:

    ruby srttimer [path to srt file] [seconds]

The `seconds` parameter can be negative.

Example: We have the SRT file `example.srt`:

    00:00:10,000 --> 00:00:15,000
    First subtitle...
    ...

The first subtitle in the video begins actually at 00:00:05,000 (5 seconds before).

Run `ruby srttimer example.srt -5` will return in a new file `example_new.srt` which has the right timing for the subtitles.
