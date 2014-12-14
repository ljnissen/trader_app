require 'spec_helper'

describe "credit_cards/index" do
  before(:each) do
    assign(:credit_cards, [
      stub_model(CreditCard),
      stub_model(CreditCard)
    ])
  end

  it "renders a list of credit_cards" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
