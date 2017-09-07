require 'test_helper'

class OffersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @offer = offers(:one)
  end

  test "should get index" do
    get offers_url
    assert_response :success
  end

  test "should get new" do
    get new_offer_url
    assert_response :success
  end

  test "should create offer" do
    assert_difference('Offer.count') do
      post offers_url, params: { offer: { category_id: @offer.category_id, date_ad_posted: @offer.date_ad_posted, keywords: @offer.keywords, link: @offer.link, platform: @offer.platform, price: @offer.price, product_details: @offer.product_details, product_name: @offer.product_name, video_link: @offer.video_link, virability: @offer.virability } }
    end

    assert_redirected_to offer_url(Offer.last)
  end

  test "should show offer" do
    get offer_url(@offer)
    assert_response :success
  end

  test "should get edit" do
    get edit_offer_url(@offer)
    assert_response :success
  end

  test "should update offer" do
    patch offer_url(@offer), params: { offer: { category_id: @offer.category_id, date_ad_posted: @offer.date_ad_posted, keywords: @offer.keywords, link: @offer.link, platform: @offer.platform, price: @offer.price, product_details: @offer.product_details, product_name: @offer.product_name, video_link: @offer.video_link, virability: @offer.virability } }
    assert_redirected_to offer_url(@offer)
  end

  test "should destroy offer" do
    assert_difference('Offer.count', -1) do
      delete offer_url(@offer)
    end

    assert_redirected_to offers_url
  end
end
