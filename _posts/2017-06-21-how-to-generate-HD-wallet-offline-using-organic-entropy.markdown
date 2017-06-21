---
layout: post
title:  "how to generate HD wallet offline using organic entropy"
date:   2017-06-21
categories: bitcoin
---

:man-digging: UNDER CONSTRUCTION :man-digging:

## 1. obtain secure offline environment

In order to accomplish this, I followed the Setup section of the [glacier protocol][glacier] \[1\]. They recommend using two latops in the protocol for maximum security, but I believe only one is fine since we're not using any computer generated entropy and the machine will always stay offline.

# a. get the required equipment

- netbook with at least 2 usb ports, no ethernet ([I recommend this one][dell])
- 3 usb drives, at least 2GB ([I used these][usb])
- dice (4 dies) ([like these][dice])
- coin
- small screwdriver [like this one][screwdriver]
- electrical tape
- masking tape
- marker

# b. label your drives

- using the masking tape and marker, label the usb drives as "setup", "boot" and "apps"

# c. remove the netbook's wireless card

For this step you will need to take your small screwdriver and open up the netbook, if you're using the recommended dell netbook ([2016 Dell Inspiron 11.6"][dell]) then you can check out the following resources on how to do this:

- [video][video] (if link is down then check [here][video2])
- [manual][manual] look at the "Removing the wireless card" section

After removing the card, use the electrical tape to wrap up the exposed terminal leads. You'll notice they make you remove the battery before removing the card, I think this is to prevent damage to the circuitry when pulling the card out.

# d. create the "setup" drive

This step assumes that you're using a macbook, if that's not the case then take a look at the Setup section of the [glacier protocol][glacier].

- download ubuntu [http://releases.ubuntu.com/xenial/ubuntu-16.04.2-desktop-amd64.iso][ubuntu] (*)
- verify its integrity

{% highlight bash %}
$ shasum -a 256 ubuntu-16.04.2-desktop-amd64.iso
0f3086aa44edd38531898b32ee3318540af9c643c27346340deb2f9bc1c3de7e  ubuntu-16.04.2-desktop-amd64.iso
{% endhighlight %}

The output should match what's listed in [http://releases.ubuntu.com/xenial/SHA256SUMS][SHA256SUMS]

- convert the iso to dmg format

{% highlight bash %}
$ hdiutil convert ubuntu-16.04.2-desktop-amd64.iso -format UDRW -o ubuntu-16.04.2-desktop-amd64.img
{% endhighlight %}

- determine the macOS device identifier for the boot USB

`$ diskutil list`

- plug the "setup" usb drive into your regular computer

`$ diskutil list `

You should now see your usb listed as an additional drive that wasn't there before. The device identifier ​is the part that comes before `(external, physical)` ​(for example `/dev/disk2`) ​

- unmount the usb

`$ diskutil unmountDisk ​USB-device-identifier-here`



- copy dmg to usb drive (make sure to use the correct device identifier!! Using the wrong one could overwrite your hard drive)

`$ sudo dd if=ubuntu-16.04.2-desktop-amd64.img.dmg of=​USB-device-identifier-here ​ bs=1m`

if = input file
of = output file
bs = block size


(*) note the the glacier document shows this as 16.04.1, when I did it this version was not available



## 2. flip that coin, roll some dice


## 3. find the 24th word

In order to satisfy the BIP39 checksum, we must choose a suitable last word. We have a simple [script][script] to accomplish this, thanks to Morveus in [this reddit thread][reddit].

## 4. think of a password and generate your wallet


Notes:


plausible deniability

You’ll find this post in your `_posts` directory. Go ahead and edit it and re-build the site to see your changes. You can rebuild the site in many different ways, but the most common way is to run `jekyll serve`, which launches a web server and auto-regenerates your site when a file is updated.

To add new posts, simply add a file in the `_posts` directory that follows the convention `YYYY-MM-DD-name-of-post.ext` and includes the necessary front matter. Take a look at the source for this post to get an idea about how it works.

Jekyll also offers powerful support for code snippets:

{% highlight ruby %}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

\[1\] [https://glacierprotocol.org][https://glacierprotocol.org]

[glacier]: https://github.com/apples0/blog/blob/master/Glacier.pdf
[dell]: https://www.amazon.com/Dell-Inspiron-Celeron-Processor-Windows/dp/B01H7Q4LG8/ref=sr_1_14?s=pc&ie=UTF8&qid=1471767727&sr=1-14&keywords=inspiron&refinements=p_85%3A2470955011
[usb]: https://www.amazon.com/SanDisk-Cruzer-Frustration-Free-Packaging-SDCZ36-008G-AFFP2/dp/B00E9W1UKY/ref=sr_1_7?ie=UTF8&qid=1485220606&sr=8-7&keywords=2GB+USB+drive
[dice]: https://www.amazon.com/Trademark-Poker-Grade-Serialized-Casino/dp/B00157YFJE/ref=sr_1_1?ie=UTF8&qid=1473894884&sr=8-1&keywords=casino+dice
[screwdriver]: https://www.amazon.com/TEKTON-2977-Phillips-Precision-Screwdriver/dp/B008TM1910/ref=sr_1_2?s=hi&ie=UTF8&qid=1476232469&sr=1-2&keywords=%2300+screwdriver
[video]: https://www.youtube.com/watch?v=nFYXQQPoh90
[video2]: https://www.youtube.com/watch?v=nFYXQQPoh90
[manual]: https://github.com/apples0/blog/blob/master/dell_manual.pdf
[ubuntu]: http://releases.ubuntu.com/xenial/ubuntu-16.04.2-desktop-amd64.iso
[reddit]: https://www.reddit.com/r/crypto/comments/684zvj/need_help_generating_lastword_checksum_for_bip39/dgvq3ca/
[script]: https://github.com/apples0/blog/blob/master/findlastword.py
[SHA256SUMS]: http://releases.ubuntu.com/xenial/SHA256SUMS