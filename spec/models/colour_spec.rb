require 'rails_helper'

RSpec.describe Colour, type: :model do
  let(   :red) { Colour.find_by_name(   'Red') }
  let(  :blue) { Colour.find_by_name(  'Blue') }
  let(  :grey) { Colour.find_by_name(  'Grey') }
  let(  :pink) { Colour.find_by_name(  'Pink') }
  let( :black) { Colour.find_by_name( 'Black') }
  let( :brown) { Colour.find_by_name( 'Brown') }
  let( :green) { Colour.find_by_name( 'Green') }
  let( :white) { Colour.find_by_name( 'White') }
  let(:orange) { Colour.find_by_name('Orange') }
  let(:purple) { Colour.find_by_name('Purple') }
  let(:yellow) { Colour.find_by_name('Yellow') }

  it '#hex' do
    expect(   red.hex).to eq('#FF0000')
    expect(  blue.hex).to eq('#0000FF')
    expect(  grey.hex).to eq('#808080')
    expect(  pink.hex).to eq('#FFC0CB')
    expect( black.hex).to eq('#000000')
    expect( brown.hex).to eq('#A52A2A')
    expect( green.hex).to eq('#008000')
    expect( white.hex).to eq('#FFFFFF')
    expect(orange.hex).to eq('#FFA500')
    expect(purple.hex).to eq('#800080')
    expect(yellow.hex).to eq('#FFFF00')
  end

  it '#hex=(invalid)' do
    expect { red.hex = '' }.to raise_error('Invalid hex colour')
    expect { red.hex = '#AAA' }.to raise_error('Invalid hex colour')
    expect { red.hex = '#GGGGGG' }.to raise_error('Invalid hex colour')
    expect { red.hex = '#AAAAAAA' }.to raise_error('Invalid hex colour')
    expect { red.hex = 'AAAAAA' }.to raise_error('Invalid hex colour')
    expect(red.hex).to eq('#FF0000')
  end

  it '#hex=' do
    red.hex = '#123456'
    expect([red.red, red.green, red.blue]).to eq([18, 52, 86])
    red.hex = '#AbCdEf'
    expect([red.red, red.green, red.blue]).to eq([171, 205, 239])
  end

  it '#hsv=' do
    red.hsv = [  0, 1.0, 1.0]
    expect(red.hex).to eq('#FF0000')
    red.hsv = [ 60, 1.0, 0.5]
    expect(red.hex).to eq('#7F7F00')
    red.hsv = [120, 1.0, 0.0]
    expect(red.hex).to eq('#000000')
    red.hsv = [180, 0.0, 1.0]
    expect(red.hex).to eq('#FFFFFF')
    red.hsv = [240, 0.5, 1.0]
    expect(red.hex).to eq('#7F7FFF')
    red.hsv = [300, 0.5, 0.5]
    expect(red.hex).to eq('#7F3F7F')
  end

  it '#hue' do
    expect(   red.hue).to eq(  0)
    expect(  blue.hue).to eq(240)
    expect(  grey.hue).to eq(  0)
    expect(  pink.hue).to eq(351)
    expect( black.hue).to eq(  0)
    expect( brown.hue).to eq(  0)
    expect( green.hue).to eq(120)
    expect( white.hue).to eq(  0)
    expect(orange.hue).to eq( 40)
    expect(purple.hue).to eq(300)
    expect(yellow.hue).to eq( 60)
  end

  it '#saturation' do
    expect(   red.saturation).to eq(1.00)
    expect(  blue.saturation).to eq(1.00)
    expect(  grey.saturation).to eq(0.00)
    expect(  pink.saturation).to eq(0.25)
    expect( black.saturation).to eq(0.00)
    expect( brown.saturation).to eq(0.75)
    expect( green.saturation).to eq(1.00)
    expect( white.saturation).to eq(0.00)
    expect(orange.saturation).to eq(1.00)
    expect(purple.saturation).to eq(1.00)
    expect(yellow.saturation).to eq(1.00)
  end

  it '#value' do
    expect(   red.value).to eq(1.00)
    expect(  blue.value).to eq(1.00)
    expect(  grey.value).to eq(0.50)
    expect(  pink.value).to eq(1.00)
    expect( black.value).to eq(0.00)
    expect( brown.value).to eq(0.65)
    expect( green.value).to eq(0.50)
    expect( white.value).to eq(1.00)
    expect(orange.value).to eq(1.00)
    expect(purple.value).to eq(0.50)
    expect(yellow.value).to eq(1.00)
  end

  it '#lightness' do
    expect(   red.lightness).to eq(0.50)
    expect(  blue.lightness).to eq(0.50)
    expect(  grey.lightness).to eq(0.50)
    expect(  pink.lightness).to eq(0.88)
    expect( black.lightness).to eq(0.00)
    expect( brown.lightness).to eq(0.41)
    expect( green.lightness).to eq(0.25)
    expect( white.lightness).to eq(1.00)
    expect(orange.lightness).to eq(0.50)
    expect(purple.lightness).to eq(0.25)
    expect(yellow.lightness).to eq(0.50)
  end

  it '#intensity' do
    expect(   red.intensity).to eq(0.33)
    expect(  blue.intensity).to eq(0.33)
    expect(  grey.intensity).to eq(0.50)
    expect(  pink.intensity).to eq(0.85)
    expect( black.intensity).to eq(0.00)
    expect( brown.intensity).to eq(0.33)
    expect( green.intensity).to eq(0.17)
    expect( white.intensity).to eq(1.00)
    expect(orange.intensity).to eq(0.55)
    expect(purple.intensity).to eq(0.33)
    expect(yellow.intensity).to eq(0.67)
  end

  it '#luma' do
    expect(   red.luma).to eq(0.30)
    expect(  blue.luma).to eq(0.11)
    expect(  grey.luma).to eq(0.50)
    expect(  pink.luma).to eq(0.83)
    expect( black.luma).to eq(0.00)
    expect( brown.luma).to eq(0.31)
    expect( green.luma).to eq(0.30)
    expect( white.luma).to eq(1.00)
    expect(orange.luma).to eq(0.68)
    expect(purple.luma).to eq(0.21)
    expect(yellow.luma).to eq(0.89)
  end

  it '#chroma' do
    expect(   red.chroma).to eq(1.00)
    expect(  blue.chroma).to eq(1.00)
    expect(  grey.chroma).to eq(0.00)
    expect(  pink.chroma).to eq(0.25)
    expect( black.chroma).to eq(0.00)
    expect( brown.chroma).to eq(0.48)
    expect( green.chroma).to eq(0.50)
    expect( white.chroma).to eq(0.00)
    expect(orange.chroma).to eq(1.00)
    expect(purple.chroma).to eq(0.50)
    expect(yellow.chroma).to eq(1.00)
  end
end
