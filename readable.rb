class Readable

  WORD_FILE_LOCATION = "WordList.txt"

  attr_accessor :allowed_word_length, :cleaned_up_words, :six_letter_words

  def initialize
    @allowed_word_length = 6
    @cleaned_up_words = cleaned_up_dictionary_words
    @six_letter_words = six_character_words
  end

  def match
    matched_words = []

    @six_letter_words.each do |word|
      (0..@allowed_word_length).each do |current_letter_index|
          first_part_of_the_word = word[0..current_letter_index]
          last_part_of_the_word = word[current_letter_index + 1..@allowed_word_length]

          if word?(first_part_of_the_word) && word?(last_part_of_the_word)
            matched_words << "#{first_part_of_the_word} + #{last_part_of_the_word} => #{word}"
          end
        end
    end

    matched_words
  end

  private

  def word?(possible_word)
    @cleaned_up_words.include?(possible_word)
  end

  def all_dictionary_words
    words = []

    File.open(WORD_FILE_LOCATION, "r").each_line do |word|
      words << word
    end

    words
  end

  def six_character_words
    @cleaned_up_words.select{|word| word.length == 6 }
  end

  def cleaned_up_dictionary_words
    stripped_words = all_dictionary_words.collect(&:strip)
    stripped_words.select{|word| !word.empty? && word.length <= 6 }
  end
end