class Colour < ActiveRecord::Base
  include Math

  # The colour in HTML format
  def hex
    '#' + parts.map { |c| c.to_s(16).rjust(2, '0') }.join.upcase
  end

  def hex=(hex)
    raise 'Invalid hex colour' unless hex =~ /^#[\dA-F]{6}$/i
    self.red, self.green, self.blue = hex.scan(/[\dA-F]{2}/i).map { |c| c.to_i(16) }
  end

  def hue
    (atan2(sqrt(3) * (green - blue), 2 * red - green - blue) * 180 / PI).round % 360
  end

  def saturation
    return 0.0 if value == 0
    (1 - normalize(parts.min) / value).round(2)
  end

  def value
    normalize(parts.max).round(2)
  end

  def lightness
    (normalize(parts.max + parts.min) / 2).round(2)
  end

  def intensity
    (normalize(parts.sum) / 3).round(2)
  end

  LUMA_WEIGHTS = [0.3, 0.59, 0.11]
  def luma
    normalize(parts.zip(LUMA_WEIGHTS).map { |a| a.inject(:*) }.sum).round(2)
  end

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
