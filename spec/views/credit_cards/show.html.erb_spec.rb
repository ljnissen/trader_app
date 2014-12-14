require 'spec_helper'

describe "credit_cards/show" do
  before(:each) do
    @credit_card = assign(:credit_card, stub_model(CreditCard))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
