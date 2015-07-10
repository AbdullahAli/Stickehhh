# Sticky9 Ruby programming test

How to run:

    irb
    load "./readable.rb"
    t = Time.now; Readable.new.match; Time.now - t

    load "./faster.rb"
    t = Time.now; Faster.new.match; Time.now - t


## Readable
The readable(!) code makes use of:

####initializer:
  to set up the class (although this is hard coded for the sake of simplicity)

####private methods:
  ensuring no one uses the class in an unexpected way/ I didn't want the public API of the class to include the 'internals' of the class

####the `match` method:
  this method does all the work of matching words. In essence, it tries to fragment the words into little sections, for example:

    `winton` will be split into:
      `w` and `inton`
      `wi` and `nton`
      `win` and `ton`
      `wint` and `on`
      `winto` and `n`

  using these fragments, the method would make a query against our dictionary (which has been cleaned up to remove trailing lines and only words which have a max length of 6 characters)

  That's all for this class.  Although this class is somewhat readable, it is pretty slow.  On my machine, it look an abysmal 23 seconds to find the matching words.  Not very good :shit:.

## Faster (more fun! :bowtie:)
  The faster code works with very different criteria.  It tries to execute the code as quickly as possible, shaving milliseconds where possible. The main differences are:

  1) The files is read differently, rather than iterating over each line, I send a `.read` to the file, and split on the trailing lines

  2) Uses a hash to look up the words.  Hash is much faster than an array at doing the search. `Searching through the array will take O(n) time`!

  I managed to save around 10 seconds by looks through a hash, which looks like this:

    hash[1] => [...all 1 letter words go here...]
    hash[2] => [...all 2 letter words go here...]
    hash[3] => [...all 3 letter words go here...]
    hash[4] => [...all 5 letter words go here...]
    hash[5] => [...all 6 letter words go here...]
    hash[6] => [...all 6 letter words go here...]

  This hash has the word's length as it's key, so when we check a word, we only need to do a constant time search.  As you can see, by replacing the array's `include`, which looks though this hash, we have converted the O(n) problem into a O(1) problem.  Winning!

  Additionally, upon initialization of the dictionary, I also store the related valid words together in another hash.  For example:

    hash["winton"] => [["win", "ton"], ["wint", "on"]]

  Again, rather than checking against all the words in the dictionary, I now only need to check against 2 words in this case (another O(n) problem solved)

##Finally
  I finally got a little stuck with shaving time :neckbeard:.  I managed to get it down to 12.3 seconds.  But I was not happy with this.  That’s a long time!

  So, I brought out the big guns! Ruby-Prof (haven’t used it before if I am honest, but I read a lot about how Aaron Patterson uses it for his Rails core work).

  Using this profiler, I spotted that 93% of the program's life was being spent on `<<` method inside `cleaned_up_dictionary_words`.

  After doing some research, I managed to look at the documentation, which stated that the implementation of `Set` is much faster (C lib).  And since we are never going to have (or want) two words, which are the same, I opted to use set.  The time dropped to **`0.141` seconds on initialization and only `0.07` seconds** after subsequent usage of the initialized dictionary! Yessir! :heart_eyes:

  I can't see how I can improve on the speed, since I have been trying to shave seconds here and there for the last couple of hours.  Might revisit this another time.

## Tests
  I should have test, but I genuinely did not have time to do them since I was a little busy between work and other interviews.  More than happy to discuss how to test this or even bring my laptop to test this in the interview if you want. 
