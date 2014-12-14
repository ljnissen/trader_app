require 'spec_helper'

describe "credit_cards/new" do
  before(:each) do
    assign(:credit_card, stub_model(CreditCard).as_new_record)
  end

  it "renders new credit_card form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", credit_cards_path, "post" do
    end
  end
end
