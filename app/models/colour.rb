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

  def hsv=(hsv)
    raise ArgumentError, 'hsv array must have three elements' if hsv.count != 3
    h, s, v = hsv
    raise ArgumentError, 'hue must be in 0...360' unless (0...360) === h
    raise ArgumentError, 'saturation must be in 0.0..1.0' unless (0.0..1.0) === s
    raise ArgumentError, 'value must be in 0.0..1.0' unless (0.0..1.0) === v
    c = s * v

    self.red = (255 * (case h
      when   0... 60, 300...360 then c
      when  60...120 then c * (2 - h / 60.0)
      when 120...240 then 0
      when 240...300 then c * (h / 60.0 - 4)
    end + v - c)).ceil

    self.green = (255 * (case h
      when   0... 60 then c * (h / 60.0)
      when  60...180 then c
      when 180...240 then c * (4 - h / 60.0)
      when 240...360 then 0
    end + v - c)).ceil

    self.blue = (255 * (case h
      when   0...120 then 0
      when 120...180 then c * (h / 60.0 - 2)
      when 180...300 then c
      when 300...360 then c * (6 - h / 60.0)
    end + v - c)).ceil
  end

  def hsl=(hsl)
    raise ArgumentError, 'hsl array must have three elements' if hsl.count != 3
    h, s, l = hsl
    raise ArgumentError, 'hue must be in 0...360' unless (0...360) === h
    raise ArgumentError, 'saturation must be in 0.0..1.0' unless (0.0..1.0) === s
    raise ArgumentError, 'lightness must be in 0.0..1.0' unless (0.0..1.0) === l
    c = s * (1 - (2.0 * l - 1).abs)

    self.red = (255 * (case h
      when   0... 60, 300...360 then c
      when  60...120 then c * (2 - h / 60.0)
      when 120...240 then 0
      when 240...300 then c * (h / 60.0 - 4)
    end + l - c / 2)).ceil

    self.green = (255 * (case h
      when   0... 60 then c * (h / 60.0)
      when  60...180 then c
      when 180...240 then c * (4 - h / 60.0)
      when 240...360 then 0
    end + l - c / 2)).ceil

    self.blue = (255 * (case h
      when   0...120 then 0
      when 120...180 then c * (h / 60.0 - 2)
      when 180...300 then c
      when 300...360 then c * (6 - h / 60.0)
    end + l - c / 2)).ceil
  end

  # The hue of the colour (0-359).
  def hue
    (atan2(sqrt(3) * (green - blue), 2 * red - green - blue) * 180 / PI).round % 360
  end

  # The rest of these methods describe how bright the colour is in various ways. For reference, I'm not using CSS colour
  # names here; green' is #00FF00, 'cyan' is #00FFFF, and 'aqua' is #008080.

  # How grey the colour isn't. (Any shade of grey is 0; green, aqua and cyan are all 1.)
  def saturation
    return 0.0 if value == 0
    (1 - normalize(parts.min) / value).round(2)
  end

  # How far any single component is from black. (Black is 0; green, cyan and white are all 1; aqua is 0.5.)
  def value
    normalize(parts.max).round(2)
  end

  # The average of the highest and the lowest component. In this case, only white is 1. Green and cyan are 0.5, and aqua
  # is 0.25.
  def lightness
    (normalize(parts.max + parts.min) / 2).round(2)
  end

  # The average of all three components. Again, only black is 0, and only white is 1; but this time, green and aqua are
  # 0.33, and cyan is 0.67.
  def intensity
    (normalize(parts.sum) / 3).round(2)
  end

  # The average of all three components, weighted by how bright each component appears to the human eye at full
  # intensity. Only black is 0, only white is 1, but green is 0.59, cyan is 0.7, and aqua is 0.35.
  LUMA_WEIGHTS = [0.3, 0.59, 0.11]
  def luma
    normalize(parts.zip(LUMA_WEIGHTS).map { |a| a.inject(:*) }.sum).round(2)
  end

  # A combination of saturation and value. Greyscales are all 0, but as saturated colours get darker, the chroma also
  # gets lower. Green and cyan are both 1; aqua is 0.5. Another way to express chroma is saturation * value, but since
  # we are rounding those values, small inaccuracies may creep in from calculating it that way.
  def chroma
    normalize(parts.max - parts.min).round(2)
  end

  private

  def parts
    [red, green, blue]
  end

  def normalize(number)
    number / 255.0
  end
end
