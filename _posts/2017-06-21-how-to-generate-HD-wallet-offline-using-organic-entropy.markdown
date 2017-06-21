---
layout: post
title:  "how to generate HD wallet offline using organic entropy"
date:   2017-06-21
categories: bitcoin
---

step 1. obtain secure offline environment

Inspired by the glacier protocol \[1\], I followed the Setup Protocol in that [document][glacier] to obtain a computer without any way to access the internet. They recommend using two sets of hardware for maximum security, but I believe only one is fine since we're not using any computer generated entropy and the machine will always stay offline. I recommend the following:

netbook - [2016 Dell Inspiron 11.6"][dell]
usb drives - [3x SanDisk Cruzer 8GB][usb]
dice - [red dice][dice] (note that blue or green dice will NOT work)
small screwdriver - [like this one][screwdriver]






This just means buying a 2netbook with at least 2 usb ports and then physically removing the wireless/bluetooth chip.


step 2. flip that coin, roll some dice


step 3. think of a password and generate your wallet


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

Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

\[1\] [https://glacierprotocol.org][https://glacierprotocol.org]

[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
[glacier]: https://github.com/apples0/blog/raw/master/Glacier.pdf
[dell]: https://www.amazon.com/Dell-Inspiron-Celeron-Processor-Windows/dp/B01H7Q4LG8/ref=sr_1_14?s=pc&ie=UTF8&qid=1471767727&sr=1-14&keywords=inspiron&refinements=p_85%3A2470955011
[usb]: https://www.amazon.com/SanDisk-Cruzer-Frustration-Free-Packaging-SDCZ36-008G-AFFP2/dp/B00E9W1UKY/ref=sr_1_7?ie=UTF8&qid=1485220606&sr=8-7&keywords=2GB+USB+drive
[dice]: https://www.amazon.com/Trademark-Poker-Grade-Serialized-Casino/dp/B00157YFJE/ref=sr_1_1?ie=UTF8&qid=1473894884&sr=8-1&keywords=casino+dice
[screwdriver]: https://www.amazon.com/TEKTON-2977-Phillips-Precision-Screwdriver/dp/B008TM1910/ref=sr_1_2?s=hi&ie=UTF8&qid=1476232469&sr=1-2&keywords=%2300+screwdriver
