---
layout: post
title:  "how to generate HD wallet offline using organic entropy"
date:   2017-06-21
categories: bitcoin
comments: false
---

## 1. obtain secure offline environment

In order to accomplish this, I followed the Setup section of the [glacier protocol][glacierprotocol]. The glacier protocol recommends using two laptops in the protocol for maximum security, but I believe only one is fine since we're not using any computer generated entropy and the generated keys will be confirmed with two independent open source software packages. Any manufacturer-placed malware to display false keys would have to be extremely sophisticated, but if you require further peace of mind then you can always duplicate these steps on another system.

### a. get the required equipment

- netbook with at least 2 usb ports, no ethernet ([I recommend this one][dell])
- 3 usb drives, at least 2GB ([I used these ones (8GB)][usb])
- coin
- dice (4 dies), (buy the [red ones][dice], note that the purple ones will NOT work)
- small screwdriver [(one of these should work)][screwdriver]
- electrical tape
- masking tape
- marker

### b. label your drives

Using the masking tape and marker, label the usb drives as "online", "offline boot" and "offline apps". In the glacier protocol the "online" drive is named SETUP because that's all they ever use it for but we're going to be using this drive again and again, in order to communicate with our offline machine (via QR codes) and broadcast transactions to the network.

### c. remove the netbook's wireless card

For this step you will need to take your small screwdriver and open up the netbook. If you're using the recommended dell netbook ([2016 Dell Inspiron 11.6"][dell]) then you can check out the following resources on how to do this:

\- [video][video] (if link is down then check [here][video2])  
\- [manual][manual] (look at the "Removing the wireless card" section)

After removing the card, use the electrical tape to wrap up the exposed terminal leads. You'll notice they make you remove the battery before removing the card, I think this is to prevent damage to the circuitry when pulling the card out.

### d. create the "online" drive

This step assumes that you're using a macbook for your regular computer, if that's not the case then take a look at the Setup section of the [glacier protocol][glacier] to learn how to do this.

\- download ubuntu [http://releases.ubuntu.com/xenial/ubuntu-16.04.2-desktop-amd64.iso][ubuntu]  

(Note that the glacier document shows this as 16.04.1, when I did it this version was not available. Use the latest!)

\- verify its integrity

{% highlight bash %}
$ shasum -a 256 ubuntu-16.04.2-desktop-amd64.iso
0f3086aa44edd38531898b32ee3318540af9c643c27346340deb2f9bc1c3de7e  ubuntu-16.04.2-desktop-amd64.iso
{% endhighlight %}

(The output should match what's listed in [http://releases.ubuntu.com/xenial/SHA256SUMS][SHA256SUMS])

\- convert the iso to dmg format

{% highlight bash %}
$ hdiutil convert ubuntu-16.04.2-desktop-amd64.iso -format UDRW -o ubuntu-16.04.2-desktop-amd64.img
{% endhighlight %}

\- determine the macOS device identifier for the boot USB

`$ diskutil list`

\- plug the "online" usb drive into your regular computer

`$ diskutil list `

You should now see your usb listed as an additional drive that wasn't there before. The device identifier ​is the part that comes before `(external, physical)` ​(for example `/dev/disk2`) ​

\- unmount the usb

`$ diskutil unmountDisk ​USB-device-identifier-here`

"​USB-device-identifier-here" will be something like `/dev/disk2`, it should be the last one but make sure to check

\- copy dmg to usb drive (**make sure to use the correct device identifier!!** *Using the wrong identifier could overwrite your hard drive*)


{% highlight bash %}
$ sudo dd if=ubuntu-16.04.2-desktop-amd64.img.dmg of=​USB-device-identifier-here ​bs=1m
{% endhighlight %}

if = input file  
of = output file  
bs = block size  

\- click Ignore button 
  
After the process has completed you'll get an error saying the disk is not recognized, just click the Ignore button (you just made a drive with a Linux filesystem so it makes sense that your mac doesn't recognize it)
  

### e. boot into the "online" Ubuntu system

\- shut down your regular computer
\- plug the "online" usb drive into your regular computer  
\- turn on your regular computer  
\- hold down the option key  
\- select the "online" drive, it will probably say "UEFI". If there are two then it's probably the last one, if you pick the wrong one don't cry over your keyboard just try again.  

Note that your screen might flicker and jitter around a bit when you're in the ubuntu system on a macbook, this happens to me but it's not big deal.

### f. create the "offline boot" drive

\- enable networking by clicking on the WIFI cone on the top right and connect to your router/hotspot  
\- download ubuntu [http://releases.ubuntu.com/xenial/ubuntu-16.04.2-desktop-amd64.iso][ubuntu]  
\- verify its integrity  

{% highlight bash %}
$ sha256sum ubuntu-16.04.2-desktop-amd64.iso
0f3086aa44edd38531898b32ee3318540af9c643c27346340deb2f9bc1c3de7e  ubuntu-16.04.2-desktop-amd64.iso
{% endhighlight %}

Again, the output should match what's listed in [http://releases.ubuntu.com/xenial/SHA256SUMS][SHA256SUMS]

\- open the Ubuntu search console by clicking the purple circle/swirl icon in the upper-left corner of the screen  
\- type "startup disk"  
\- click on Startup Disk Creator icon  
\- The “Source disc image” panel should show the .iso file you downloaded. If it doesn't then click the “Other” button and find it in the folder you downloaded it to.  
\- identify the “Disk to use” field, you're going to see your usb drive show up in there  
\- plug in the "offline boot" usb drive  
\- select the "offline boot" drive in the "Disk to use" field  
\- click "Make Startup Disk"  

### h. create the "offline apps" drive

You should still be in the "online" Ubuntu system, but if you're not then complete [section e](#e-boot-into-the-online-system) again.

# download apt-get dependencies

\- add repositories

For some reason the usb booted Ubuntu system doesn't have the normal apt-get repositories added by default, so we need to add them:

{% highlight bash %}
$ sudo apt-add-repository universe
$ sudo apt-get update
{% endhighlight %}


\- download the apps for the offline machine

{% highlight bash %}
$ sudo apt-get install qrencode zbar-tools python-mnemonic python-qt4 python-pip
{% endhighlight %}

`qrencode` - used to encode QR codes into text  
`zbar-tools` - this library contains the zbarcam command, used to decode QR codes from text  
`python-mnemonic` - used to find the 24th word to satisfy the BIP39 checksum, in the findlastword.py script  
`python-qt4`, `python-pip` - electrum dependencies  


\- copy apps to folder

{% highlight bash %}
$ mkdir ~/apps
$ cp /var/cache/apt/archives/*.deb ~/apps
{% endhighlight %}

# download electrum

\- download electrum and its signature
 
{% highlight bash %}
$ mkdir ~/electrum
$ cd ~/electrum
$ wget https://download.electrum.org/2.8.3/Electrum-2.8.3.tar.gz
$ wget https://download.electrum.org/2.8.3/Electrum-2.8.3.tar.gz.asc
{% endhighlight %}

**verify electrum**

The source tarball should be signed by Thomas Voegtlin of the electrum project, his pgp key is available through [this][electrumpgp] link on the electrum website. You see this up at the top:

pub  4096R/[7F9470E6][pgpfingerprint] 2011-06-15

Click on the 7F9470E6 fingerprint and that will take you to a static page with the pgp public key block, copy everthing from `-----BEGIN PGP PUBLIC KEY BLOCK-----` to `-----END PGP PUBLIC KEY BLOCK-----` and save it as a file. You can name it `electrumpubkey.asc` or `numberonestunna.makethemsayuggghhh` it doesn't really matter.

\- import gpg public key into your keyring

`$ gpg --import electrumpubkey.asc`

\- verify the downloaded source was actually signed by Thomas and not some hacker.

{% highlight bash %}
$ gpg --verify Electrum-2.8.3.tar.gz.asc Electrum-2.8.3.tar.gz

gpg: Signature made Mon 29 May 2017 07:33:24 AM UTC using RSA key ID 7F9470E6
gpg: Good signature from "Thomas Voegtlin (https://electrum.org) <thomasv@electrum.org>"
gpg:                 aka "ThomasV <thomasv1@gmx.de>"
gpg:                 aka "Thomas Voegtlin <thomasv1@gmx.de>"
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 6694 D8DE 7BE8 EE56 31BE  D950 2BD5 824B 7F94 70E6
{% endhighlight %}

The important thing here is that you see the text "Good signature from "Thomas Voegtlin (https://electrum.org) \<thomasv@electrum.org\>", unless you're a security nerd you won't have a web of trust so disregard the scary warning message that appears afterwards.

\- download electrum dependencies using pip installer in download mode

`$ sudo pip2 install --download ~/electrum ~/electrum/Electrum-2.8.3.tar.gz`

# download BIP39 mnemonic generator

{% highlight bash %}
$ sudo apt-get install git
$ git clone https://github.com/iancoleman/bip39.git
{% endhighlight %}

# download findlastword.py script

In order to satisfy the BIP39 checksum, we must choose a suitable last word. We have a simple [script][script] to accomplish this, thanks to reddit user Morveus in [this thread][reddit].

`$ wget https://raw.githubusercontent.com/apples0/blog/master/findlastword.py`

# copy all of this junk to the offline apps usb

you should now have the folders `apps`, `electrum`, `bip39` and the file `findlastword.py` in the offline apps drive

## i. boot offline computer

\- plug in the "offline boot" usb drive into your offline computer  
\- power it on and repeatedly press F2 until you enter BIOS setup  
\- in the BIOS, disable "Fast Boot" and "Secure Boot"  
\- click "File Browser Add Boot Option"  
\- click on the USB drive and keep drilling down until you see "grubx64.efi" and the click on it  
\- now disable the "Windows Boot Manager" option  
\- click F10 to save and exit  

You should now boot into the grub menu, in order for the dell to boot you have to adjust the boot commands.

\- press "e" to edit the boot commands  
\- delete "quiet splash"  
\- in its place, add "nomodeset=0"  
\- click F10 to save and boot  

You should now successfully boot into the Ubuntu system. If the above steps don't work for you then just use google and play around with the BIOS settings until it works.

## j. install apps

\- plug in "offline apps" drive  
\- copy everything on the drive to your home folder  

**install the apt-get packages**

`$ sudo dpkg -i ~/apps/*.deb`

**install electrum**

{% highlight bash %}
$ sudo pip2 install --no-index --find-links ~/electrum/ ~/electrum/Electrum-2.8.3.tar.gz
{% endhighlight %}

Congratulations, now you have a secure offline environment where you can generate your master public key and sign transactions.  

<br/>
<br/>
   
## 2. generating mnemonic words using organic entropy

If you have already been using a 12 word seed, use these words as your first 12 words (see [Plausible Deniability](#plausible-deniability) section).

### a. flip that coin, roll some dice

In this section we will be using a coin and dice to generate the seed words. We will be using this awesome [pdf][dicewarepdf] from [https://github.com/taelfrinn/Bip39-diceware][diceware] thanks to github user taelfrinn. We're rolling 4 dies because it can produce 1296 different permutations (6^4=1296), and this is a little more than half of 2048. To cover the remaining words we flip a coin and have dice rolls with heads represent the first 1296 words and dice rolls with tails cover the remaining. Because there are more combinations than we need (2*1296>2048), we simply ignore dice rolls with tails that are above 4362. Although to be honest, when I rolled over that number I would just reverse the way I read off the numbers so T4672 would turn into T2764. Besides this case, it's important to always read the numbers in a consistent way.

- flip a coin  
- roll the dice  
- record the word  

- repeat the above steps until you have recorded 23 words  

### b. find the 24th word

In order for our words to be fully BIP39 compatible, the checksum must be satisfied. We can use the [findlastword.py][script] script to do this. Input your 23 words and then run the following command:

`$ python findlastword.py`

There are a handful of words that will satisfy the checksum, the way I picked the word was to flip a coin and roll a die. Heads would mean I would start from the top and tails would mean I would start from bottom, I would then select the word corresponding to what I rolled. So if I flipped a tails and rolled a two then the second to last word would be selected. Or you can just pick one.

### c. think of a password

Think of an easy to remember password that isn't written down anywhere or associated with you online.

Now you should have 24 words and a password.

<br/>
<br/>

## 3. storing your mnemonic words and password

<p align="center">
  <img src="https://github.com/apples0/blog/raw/master/figure.png" alt="figure"/>
</p>

### a. offline storage

*Store the first 12 words offline, in multiple locations.*

It's important to write the words down on paper instead of using something like a thumb drive or a QR code, the idea is to make it as difficult and annoying as possible to convert this into a digital form that could then be transmitted on the internet. I've just been writing them down on paper and putting them in different places (my house, my car, my friend's house, my desk at work, my dad's house) for a good amount of redundancy, but if you have a creative idea please let me know in the comments! I'm not using any of these right now but here are a few ideas I came up with:
 
- writing the words on the inside of a book  
- circling and indexing words in a dictionary  
- laminating 3 pieces of paper together with the words written on the middle sheet, maybe the outside sheets would be a painting or a picture  
- writing the words in UV light on the inside of a closet or some other weird location  

### b. online storage

*Store the second 12 words online, in multiple locations.*

These words can be emailed to yourself, put on cloud storage, stored in a private repo, ftp, whatever. An important additional step which I like to do, is to hide these words in an image using the program steghide.

#### embedding words in image

{% highlight bash %}
$ echo "rival garden idea assault alter expire protect guess goddess thought chase illegal" >> file.txt
$ steghide embed -cf cat.jpg -ef file.txt
{% endhighlight %}

`cf` = cover file  
`ef` = embedded file

The program also allows you to protect your data with a password if you choose, but this is optional.

#### extracting words from image

{% highlight bash %}
$ steghide extract -sf cat.jpg
{% endhighlight %}

`sf` = steganographic file (cover file + embedded file)

Here is a [great tutorial][steghidetutorial] if you need more detail, if the link is down then click [here][steghidetutorial2].

### c. mindgrapes storage

*Store the password in your head*

Remember your password as if your entire bank account depended on it.

<br/>
<br/>

## 4. generating HD wallet

In your offline computer, open the bip39-standalone.html file and input your 24 words into the "BIP39 Mnemonic" field and your password into the "BIP39 Passphrase" field. Now scroll down and you'll see two sets of extended keys, the BIP32 Extended Keys are the ones representing the very root so they are the master ones. However in practice you won't actually use these, you'll use the Account Extended Keys to dynamically generate public addresses without requiring the private key and these are derived from the BIP32 Extended Keys. Now that you see the extended keys and the generated addresses down at the bottom you can input your words into Electrum and compare the values.

Open Electrum and do "Standard Wallet -> I already have a seed" and then click the Options button and make sure that the checkboxes "Extend this seed with custom words" and "BIP39 seed" are both checked. If Electrum crashes at any point just open it up again, this happens every now and again and it's no big deal. Now that your wallet is created you can check to see if your keys match. Open up a terminal (Ctrl-Alt-T in Ubuntu) and type the following command:

`$ cat ~/.electrum/wallets/default_wallet`  

You should see your xprv and xpub keys in plaintext down at the bottom. Make sure these keys match what you get from the bip39-standalone.html file! If they don't match then you're either mistakenly reading from the BIP39 Extended Keys instead of the Account Extended Keys or something is horribly, horribly wrong.

<br/>
<br/>

## 5. receiving btc

In Electrum in your offline computer, go to "Wallet -> Master Public Keys" and now you can use this xpub extended key to generate receiving addresses. You can even click on the little QR code icon on the bottom right of the dialog to reveal a QR code. You can then maximize this window and read the code off with your phone's camera. I know that the MyCelium and Electrum android apps allow you to import this address, and then you can receive BTC and monitor your account without needing to put any of the private keys on the hot device. However keep in mind that the Master Public Key is still considered a sensitive piece of information that you shouldn't go sharing around everywhere, because it allows anyone to see how much unspent BTC you control and which receiving addresses and transactions are linked to you.

<br/>
<br/>

## 6. sending btc

Sending BTC is a more involved process. We will be using our regular computer booted off the "online" usb to create a transaction, then we will read this transaction onto our offline computer through a QR code, sign the transaction, and then transfer the signed transaction back to our online computer using another QR code. A high-level summary of the steps are shown below:

a. prepare online computer  
b. prepare offline computer  
c. transfer master public key to online computer  
d. create unsigned transaction on the online computer  
e. transfer unsigned transaction to offline computer  
f. sign transaction  
g. transfer signed transaction to the online computer  
h. broadcast transaction  

Here we go!

### a. prepare online computer

\- boot online computer off of "online" usb drive  

{% highlight bash %}
$ sudo apt-add-repository universe
$ sudo apt-get update
$ sudo apt-get install qrencode zbar-tools steghide python-pip python-qt4
{% endhighlight %}

\- follow [download electrum](#download-electrum) step to download, verify and install electrum

Unfortunately the macbook camera (called facetimehd) does not work in Linux, however thankfully github user patjak came up with a solution outlined [here][bcwc_pcie]. Using these instructions I created this [script][facetimehdscript].

{% highlight bash %}
$ sudo apt-add-repository universe
$ sudo apt-get update
$ wget https://github.com/apples0/blog/raw/master/enable_facetimehd_camera.sh
$ sudo bash enable_facetimehd_camera.sh
{% endhighlight %}

To test that the above works, type the command `$ zbarcam`, if everything worked out then you should see a dialog pop up showing the camera output.

### b. prepare offline computer

\- boot offline computer off of "offline boot" usb drive  
\- copy apps and electrum folders to home directory  
\- install apps and electrum as in the [install apps](#j-install-apps) section  

### c. transfer master public key to online computer

*on the online computer:*

\- open Electrum  
\- Standard Wallet -> Use public or private keys  
\- click on QR code icon  
    
The camera should appear, now you're ready to receive the master public key as a QR code.
 
*on the offline computer:*

\- open Electrum  
\- Standard Wallet -> I already have a seed  
\- collect and input your words, using the online computer with steghide as needed    
\- Wallet -> Master Public Keys (Electrum sometimes crashes here, just start it up again and try again)  
\- Click the QR code icon  

Now maximize the dialog to make the QR code take up the whole screen and then hold your offline computer screen to your online computer camera to scan the code. Now you should have a "watching wallet" on your online computer.

### d. create unsigned transaction on the online computer

*on the online computer:*

\- go to the Send tab and enter the receiving address in the Pay to field and the Amount in mBTC.  
\- click the Preview button  
\- on the dialog that pops up, click the QR code button and maximize the resulting dialog so it's easier to scan  

### e. transfer unsigned transaction to offline computer

*on the offline computer:*

\- Tools -> Load Transaction -> From QR code  
    
Now hold your offline computer camera to the online computer screen and read the QR code

### f. sign transaction

*on the offline computer:*

\- make sure everything looks good  
\- click the Sign button  

### g. transfer signed transaction to the online computer

*on the offline computer:*

\- after hitting the Sign button, click the QR code icon and maximize it  

*on the online computer:*

\- Tools -> Load Transaction -> From QR code

Now hold your offline computer screen up to your online computer camera

### h. broadcast to the network

*on the online computer:*

click the Broadcast button, it should say something like "Payment sent" and show the Transaction ID


<br/>
<br/>

## additional notes

### plausible deniability

If you have already been using a 12 word seed, then you can use those 12 words as the words you store in multiple locations offline. By transferring its funds to your new wallet you will have real plausible deniability because there will be significant transaction history with those words. The offline words are also the most likely to be found by someone who would want to hit you with a wrench.

You might also want to transfer your existing bitcoin to your new wallet incrementally over time to make the history seem more realistic, like you were selling them off to people on localbitcoins.com or something. One large transaction will probably appear more like you just transferred it to a new wallet.

{% if page.comments %}
{% include disqus.html %}                     
{% endif %}

[glacierprotocol]: https://glacierprotocol.org
[glacier]: https://github.com/apples0/blog/blob/master/Glacier.pdf
[dell]: https://www.amazon.com/Dell-Inspiron-Celeron-Processor-Windows/dp/B01H7Q4LG8/ref=sr_1_14?s=pc&ie=UTF8&qid=1471767727&sr=1-14&keywords=inspiron&refinements=p_85%3A2470955011
[usb]: https://www.amazon.com/SanDisk-Cruzer-Frustration-Free-Packaging-SDCZ36-008G-AFFP2/dp/B00E9W1UKY/ref=sr_1_7?ie=UTF8&qid=1485220606&sr=8-7&keywords=2GB+USB+drive
[dice]: https://www.amazon.com/Trademark-Poker-Grade-Serialized-Casino/dp/B00157YFJE/ref=sr_1_1?ie=UTF8&qid=1473894884&sr=8-1&keywords=casino+dice
[screwdriver]: https://www.amazon.com/TEKTON-2977-Phillips-Precision-Screwdriver/dp/B008TM1910/ref=sr_1_2?s=hi&ie=UTF8&qid=1476232469&sr=1-2&keywords=%2300+screwdriver
[video]: https://www.youtube.com/watch?v=nFYXQQPoh90
[video2]: https://github.com/apples0/blog/raw/master/removing_wireless_card_nFYXQQPoh90.mp4
[manual]: https://github.com/apples0/blog/blob/master/dell_manual.pdf
[ubuntu]: http://releases.ubuntu.com/xenial/ubuntu-16.04.2-desktop-amd64.iso
[reddit]: https://www.reddit.com/r/crypto/comments/684zvj/need_help_generating_lastword_checksum_for_bip39/dgvq3ca/
[script]: https://github.com/apples0/blog/blob/master/findlastword.py
[SHA256SUMS]: http://releases.ubuntu.com/xenial/SHA256SUMS
[electrumpgp]: https://pgp.mit.edu/pks/lookup?op=vindex&search=0x2BD5824B7F9470E6
[pgpfingerprint]: https://pgp.mit.edu/pks/lookup?op=get&search=0x2BD5824B7F9470E6
[dicewarepdf]: https://github.com/apples0/blog/blob/master/bip39-diceware.pdf
[diceware]: https://github.com/taelfrinn/Bip39-diceware
[figure]: https://github.com/apples0/blog/raw/master/figure.png
[steghidetutorial]: https://www.youtube.com/watch?v=pW4BQK0LvJo
[steghidetutorial2]: https://github.com/apples0/blog/raw/master/steghide.mp4
[bcwc_pcie]: https://github.com/patjak/bcwc_pcie/wiki/Get-Started
[facetimehdscript]: https://github.com/apples0/blog/blob/master/enable_facetimehd_camera.sh