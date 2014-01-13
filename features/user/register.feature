Feature: register
    In order to save my records
    As a user
    I want to register

    Scenario: Register with Email
        Given no account exist for my email
        When I register an account with my email
        Then I should be signed in as a new user identified by my email

    Scenario: Register with Sina Oauth
        Given no account exist for my sina account
        When I authenticate with my sina account
        Then I should be signed in as a new user identified by my sina account

    Scenario: Register as existing Sina user
        Given an account exists for my sina account
        When I authenticate with my sina account
        Then I should be signed in as an existing user identified by my sina account

    # Scenario: Warn user about existing email
    #     Given an account exists for my email
    #     When I register an account with my email
    #     Then I should see a warning regarding email duplication

    # Scenario: Warn user about existing email through AJAX
    #     Given an account exists for my email
    #     And I am on the registration page
    #     When I fill in the email field with my email
    #     Then I should see a warning regarding email duplication
