module Ranking
  extend self

  def hot_value score, time
    time ||= Time.now
    time_seed = Time.new(2013,4,1,23,00,00)
    order = Math.log10([score, 1].max)
    seconds = (time.to_i - time_seed.to_i)
    order + seconds * 1.0 / 45000
  end
end
