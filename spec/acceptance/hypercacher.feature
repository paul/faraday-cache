Feature: Caching HTTP with Hypercacher
  Background:
    Given I have configured Hypercacher to use the heap store

    And there is an action:
      """
      get "/simple" do
        "Hello, World!"
      end
      """

  Scenario: Making another request within `max-age`
    When I make a request to "/simple"
    And  I make another request to "/simple" within 60 seconds

    Then there should only have been 1 request made to "/simple"





