Feature: Caching HTTP with Hypercacher
  Background:
    Given I have configured Hypercacher to use the heap store
    And there is an app:
      """
      get "/simple" do
        cache_control :public, :max_age => 60
        "Hello, World!"
      end
      """

  Scenario: Making another request within `max-age`
    When I make a request to "/simple"
    And  I make another request to "/simple" within 60 seconds

    Then there should only have been 1 request made to "/simple"

  Scenario: Making another request after `max-age` has elapsed
    When I make a request to "/simple"
    And  I make another request to "/simple" after 90 seconds

    Then there should have been 2 requests made to "/simple"





