require 'csv'

class TextProgressBar
  attr_accessor :progress, :capacity, :started

  def reset(options = {})
    @progress = options[:progress] || 0
    @capacity = options[:capacity] || @capacity || 1
    @started  = (s = options[:started]) && s.to_time || Time.now
    @updated  = Time.now
    self
  end

  # @param [Hash] options accepts:
  #   :complete (sets the progress to the capacity if truish),
  #   :to (sets the progress to the specified number), or
  #   :by (increments the progress by the specified number - 1 by default).
  def update(options = {})
    if options[:complete]
      @progress = @capacity
    elsif options[:to]
      @progress = options[:to]
    else
      steps     = options[:by] || 1
      @progress += steps
    end
    @updated = Time.now
    @success = options[:success]
    self
  end

  # @param [Hash] options accepts:
  #   :progress (the number of steps completed - 0 by default),
  #   :capacity (the number of steps in total - 1 by default), and
  #   :started (the time the process started - Time.now by default).
  def initialize(options = {})
    reset(options)
  end

  def to_s
    output = ''
    return output if @capacity == 0
    
    output << case @success
      when nil   then "\e[00m"   # black
      when true  then "\e[0;32m" # green
      when false then "\e[0;31m" # red
    end

    bar_width     = 20
    cycling_chars = ["", "\u258F", "\u258E", "\u258D", "\u258C", "\u258B", "\u258A", "\u2589"]
    cycling_char  = if @progress > @capacity
      '?'
    else
      cycling_chars[(@capacity == 0 ? 0 : bar_width) * cycling_chars.count * @progress / @capacity % cycling_chars.count]
    end
    output << "[#{("\u2588" * [@capacity == 0 ? 0 : bar_width * @progress / @capacity, bar_width].min + cycling_char).ljust(bar_width)}] "

    output << "#{@progress.to_s.rjust(Math.log(@capacity + 1, 10).ceil)} / #@capacity " <<
      "(#{(@capacity == 0 ? 0 : 100 * @progress / @capacity).to_s.rjust(3)}%) "

    output << "#{(Time.new(0) + elapsed).strftime('%H:%M:%S')} elapsed - " <<
      "#{(Time.new(0) + estimated).strftime('%H:%M:%S')} estimated - " <<
      "#{(Time.new(0) + remaining).strftime('%H:%M:%S')} remaining "

    if rate >= 1
      number = rate
      unit   = 'Hz'
    else
      number = rate == 0 ? 0 : 1 / rate
      unit   = 's'
    end
    rate_str = (number == 0) ? '0Hz' : "#{number.round(2 - Math.log10(number).floor)}#{unit}" # round to 3 s.f.
    output << "(#{rate_str})\e[K\e[00m\r"
  end

  def remaining
    estimated - elapsed
  end

  def estimated
    rate == 0 ? 0 : @capacity / rate
  end

  def rate
    elapsed == 0 ? 0 : @progress / elapsed
  end

  def elapsed
    @updated - @started
  end
end

[Array, Enumerator, Range, CSV::Table].each do |klass|
  eval <<-RUBY
    class #{klass}
      def track(method = :each)
        tpb = TextProgressBar.new(:capacity => self.count)
        print tpb
        self.send(method) do |element|
          (yield element if block_given?).tap do
            print tpb.update
          end
        end.tap { puts }
      end
    end
  RUBY
end
