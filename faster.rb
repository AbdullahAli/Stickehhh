require "set"

class Faster

  WORD_FILE_LOCATION = "WordList.txt"

  attr_accessor :allowed_word_length, :cleaned_up_words, :six_letter_words

  def initialize
    @allowed_word_length = 6
    @cleaned_up_words = cleaned_up_dictionary_words
  end

  def match
    matched_words = Set.new([])

    @cleaned_up_words.each do |word, _|
      (0..@allowed_word_length).each do |current_letter_index|
        first_part_of_the_word = word[0..current_letter_index]
        last_part_of_the_word = word[current_letter_index + 1..@allowed_word_length]

        if makes_up_a_valid_word?(word, first_part_of_the_word, last_part_of_the_word)
          matched_words << "#{first_part_of_the_word} + #{last_part_of_the_word} => #{word}"
        end
      end
    end

    matched_words
  end

  private

  def makes_up_a_valid_word?(current_word, first_part_of_the_word, last_part_of_the_word)
    is_valid_word = false
    @cleaned_up_words[current_word].each do |letter_combinations|
      if([first_part_of_the_word, last_part_of_the_word] - letter_combinations).empty?
        is_valid_word = true
      end
    end
    is_valid_word
  end

  def word?(words_with_max_6_letters, possible_word)
    words_with_max_6_letters[possible_word.length].include?(possible_word)
  end

  def all_dictionary_words
    words = File.open(WORD_FILE_LOCATION).read.split("\r\n")
  end

  def words_within_length_limit
    all_dictionary_words.select{|word| !word.empty? && word.length <= @allowed_word_length }
  end

  def cleaned_up_dictionary_words
    words_within_limit = words_within_length_limit
    @six_letter_words = words_within_limit.select{|word| word.length == @allowed_word_length }

    cleaned_words = {}
    word_length_hash = construct_word_length_hash(words_within_limit)

    @six_letter_words.each do |six_letter_word|
      mattching = Set.new []
      (0..@allowed_word_length).each do |current_letter_index|

        last_part_of_the_word = six_letter_word[current_letter_index + 1..@allowed_word_length]

        if !last_part_of_the_word.nil? && !last_part_of_the_word.empty?
          first_part_of_the_word = six_letter_word[0..current_letter_index]

          if word?(word_length_hash, first_part_of_the_word) && word?(word_length_hash, last_part_of_the_word)
            mattching << [first_part_of_the_word, last_part_of_the_word]
          end
        end
      end
      cleaned_words[six_letter_word] = mattching
    end
    cleaned_words
  end

  def construct_word_length_hash(words_within_limit)
    word_length_hash = {}
    (1..6).each { |i| word_length_hash[i] = Set.new([]) }
    words_within_limit.each do |six_letter_word|
      word_length_hash[six_letter_word.length] << six_letter_word
    end
    word_length_hash
  end
end
