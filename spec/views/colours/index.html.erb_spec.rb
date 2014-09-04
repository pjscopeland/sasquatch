require 'rails_helper'

RSpec.describe "colours/index", :type => :view do
  before(:each) do
    assign(:colours, [
      Colour.create!(),
      Colour.create!()
    ])
  end

  it "renders a list of colours" do
    render
  end
end
