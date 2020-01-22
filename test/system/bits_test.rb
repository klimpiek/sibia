require "application_system_test_case"

class BitsTest < ApplicationSystemTestCase
  setup do
    @bit = bits(:one)
  end

  test "visiting the index" do
    visit bits_url
    assert_selector "h1", text: "Bits"
  end

  test "creating a Bit" do
    visit bits_url
    click_on "New Bit"

    click_on "Create Bit"

    assert_text "Bit was successfully created"
    click_on "Back"
  end

  test "updating a Bit" do
    visit bits_url
    click_on "Edit", match: :first

    click_on "Update Bit"

    assert_text "Bit was successfully updated"
    click_on "Back"
  end

  test "destroying a Bit" do
    visit bits_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Bit was successfully destroyed"
  end
end
