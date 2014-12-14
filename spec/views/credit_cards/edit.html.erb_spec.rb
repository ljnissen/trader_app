require 'spec_helper'

describe "credit_cards/edit" do
  before(:each) do
    @credit_card = assign(:credit_card, stub_model(CreditCard))
  end

  it "renders the edit credit_card form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", credit_card_path(@credit_card), "post" do
    end
  end
end
