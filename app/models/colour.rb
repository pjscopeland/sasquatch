class Colour < ActiveRecord::Base
  include Math

  # The colour in HTML format
  def hex
    '#' + parts.map { |c| c.to_s(16).rjust(2, '0') }.join.upcase
  end

  def hex=(hex)
    raise ArgumentError, 'invalid hex colour' unless hex =~ /^#[\dA-F]{6}$/i
    self.red, self.green, self.blue = hex.scan(/[\dA-F]{2}/i).map { |c| c.to_i(16) }
  end

  def red1
    red / 255.0
  end

  def green1
    green / 255.0
  end

  def blue1
    blue / 255.0
  end

  def red1=(value)
    self.red = (value * 255).ceil
  end

  def green1=(value)
    self.green = (value * 255).ceil
  end

  def blue1=(value)
    self.blue = (value * 255).ceil
  end

  def hsv=(hsv)
    raise ArgumentError, 'hsv array must have three elements' if hsv.count != 3
    h, s, v = hsv
    raise ArgumentError, 'hue must be in 0...360' unless (0...360) === h
    raise ArgumentError, 'saturation must be in 0.0..1.0' unless (0.0..1.0) === s
    raise ArgumentError, 'value must be in 0.0..1.0' unless (0.0..1.0) === v
    c = s * v

    self.red1 = (case h
      when   0... 60, 300...360 then c
      when  60...120 then c * (2 - h / 60.0)
      when 120...240 then 0
      when 240...300 then c * (h / 60.0 - 4)
    end + v - c)

    self.green1 = (case h
      when   0... 60 then c * (h / 60.0)
      when  60...180 then c
      when 180...240 then c * (4 - h / 60.0)
      when 240...360 then 0
    end + v - c)

    self.blue1 = (case h
      when   0...120 then 0
      when 120...180 then c * (h / 60.0 - 2)
      when 180...300 then c
      when 300...360 then c * (6 - h / 60.0)
    end + v - c)
  end

  def hsl=(hsl)
    raise ArgumentError, 'hsl array must have three elements' if hsl.count != 3
    h, s, l = hsl
    raise ArgumentError, 'hue must be in 0...360' unless (0...360) === h
    raise ArgumentError, 'saturation must be in 0.0..1.0' unless (0.0..1.0) === s
    raise ArgumentError, 'lightness must be in 0.0..1.0' unless (0.0..1.0) === l
    c = s * (1 - (2.0 * l - 1).abs)

    self.red1 = (case h
      when   0... 60, 300...360 then c
      when  60...120 then c * (2 - h / 60.0)
      when 120...240 then 0
      when 240...300 then c * (h / 60.0 - 4)
    end + l - c / 2)

    self.green1 = (case h
      when   0... 60 then c * (h / 60.0)
      when  60...180 then c
      when 180...240 then c * (4 - h / 60.0)
      when 240...360 then 0
    end + l - c / 2)

    self.blue1 = (case h
      when   0...120 then 0
      when 120...180 then c * (h / 60.0 - 2)
      when 180...300 then c
      when 300...360 then c * (6 - h / 60.0)
    end + l - c / 2)
  end

  # The hue of the colour (0-359).
  def hue
    (atan2(sqrt(3) * (green - blue), 2 * red - green - blue) * 180 / PI).round % 360
  end

  # The rest of these methods describe how bright the colour is in various ways. For reference, I'm not using CSS colour
  # names here; 'green' (as a primary colour) is #00FF00, 'cyan' (as a secondary colour) is #00FFFF, and 'aqua' (as a
  # shade of a secondary colour) is #008080.

  # How grey the colour isn't. Any shade of grey is 0; green, aqua and cyan are all 1.
  def saturation
    return 0.0 if max1 == 0.0
    1 - min1 / max1
  end

  # How far any single component is from black. Only black is 0; green, cyan and white are all 1; aqua is 0.5.
  def value
    max1
  end

  # The average of the highest and the lowest component. In this case, only white is 1. Green and cyan are 0.5, and aqua
  # is 0.25.
  def lightness
    (max1 + min1) / 2
  end

  # The average of all three components. Again, only black is 0, and only white is 1; but this time, green and aqua are
  # 0.33, and cyan is 0.67.
  def intensity
    parts1.sum / 3
  end

  # The average of all three components, weighted by how bright each component appears to the human eye at full
  # intensity. Only black is 0, only white is 1, but green is 0.59, cyan is 0.7, and aqua is 0.35.
  LUMA_WEIGHTS = [
    LUMA_RED   = 0.3,
    LUMA_GREEN = 0.59,
    LUMA_BLUE  = 0.11]
  def luma
    parts1.zip(LUMA_WEIGHTS).map { |a| a.inject(:*) }.sum
  end

  # A combination of saturation and value. Greyscales are all 0, but as saturated colours get darker, the chroma also
  # gets lower. Green and cyan are both 1; aqua is 0.5. Another way to express chroma is saturation * value, but that
  # involves more actual calculation.
  def chroma
    max1 - min1
  end

  private

  def parts
    [red, green, blue]
  end

  def parts1
    [red1, green1, blue1]
  end

  delegate :min, :max, to: :parts

  def min1
    parts1.min
  end

  def max1
    parts1.max
  end
end
