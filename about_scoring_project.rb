require File.expand_path(File.dirname(__FILE__) + '/neo')

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used to calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

def score(dice)
  # You need to write this method
  final_score = 0
  if dice.length > 0
    dice_count = build_dice_hash(dice)
    final_score = check_for_three_or_more_of_same_number(final_score, dice_count)
    final_score = score_ones_and_fives_when_there_are_less_than_3(final_score, dice_count)
  else
    final_score = 0
  end
  final_score
end

def check_for_three_or_more_of_same_number (final_score, dice_hash)
  triplicates = dice_hash.select { |number, count| count >= 3 }

  final_score += 1000 + (dice_hash[:one] - 3) * 100 if triplicates.key?(:one)
  final_score += 200 if triplicates.key?(:two)
  final_score += 300 if triplicates.key?(:three)
  final_score += 400 if triplicates.key?(:four)
  final_score += 500 + (dice_hash[:five] - 3) * 50 if triplicates.key?(:five)
  final_score += 600 if triplicates.key?(:six)

  return final_score
end

def score_ones_and_fives_when_there_are_less_than_3 (final_score, dice_hash)
  ones_and_fives = dice_hash.select { |number, count| (number == :one || number == :five) && (count < 3) }
  final_score += ones_and_fives[:one] * 100 if ones_and_fives.key?(:one)
  final_score += ones_and_fives[:five] * 50 if ones_and_fives.key?(:five)

  return final_score
end

def build_dice_hash(dice)
  dice_count = Hash.new(0)
  dice.each do |die|
    if die == 1
      dice_count[:one] += 1
    elsif die == 2
      dice_count[:two] += 1
    elsif die == 3
      dice_count[:three] += 1
    elsif die == 4
      dice_count[:four] += 1
    elsif die == 5
      dice_count[:five] += 1
    elsif die == 6
      dice_count[:six] += 1
    else
      dice_count[:other] += 1
    end
  end
  dice_count
end

class AboutScoringProject < Neo::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, score([1])
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, score([1,5,5,1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, score([2,3,4,6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, score([1,1,1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, score([2,2,2])
    assert_equal 300, score([3,3,3])
    assert_equal 400, score([4,4,4])
    assert_equal 500, score([5,5,5])
    assert_equal 600, score([6,6,6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, score([2,5,2,2,3])
    assert_equal 550, score([5,5,5,5])
    assert_equal 1100, score([1,1,1,1])
    assert_equal 1200, score([1,1,1,1,1])
    assert_equal 1150, score([1,1,1,5,1])
  end

end
