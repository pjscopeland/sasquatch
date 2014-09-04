module ColoursHelper
  def colour_style(options)
    case options
    when Colour
      tmp = options
    when Hash
      tmp = Colour.new(options)
    end
    "background: #{tmp.hex}; color: #{tmp.luma > 0.5 ? 'black' : 'white'};"
  end
end
