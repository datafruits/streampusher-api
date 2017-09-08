# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('[data-controller=subscriptions]').ready ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

  $('#card_number').payment('formatCardNumber')
  $('#card_exp').payment('formatCardExpiry')
  $('#card_code').payment('formatCardCVC')

  $("#subscription_plan_id").change ->
    name = $("#subscription_plan_id option:selected").data('name')
    price = $("#subscription_plan_id option:selected").data('price')
    $("input.subscribe-button").val("Subscribe to #{name} plan for #{price} per month")

subscription =
  setupForm: ->
    $('.edit_subscription').submit ->
      $('input[type=submit]').attr('disabled', true)
      if $('#card_number').length
        subscription.processCard()
        false
      else
        true

  processCard: ->
    exp_text = $('#card_exp').val()
    exp_month = $.payment.cardExpiryVal(exp_text).month
    exp_year = $.payment.cardExpiryVal(exp_text).year
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: exp_month
      expYear: exp_year
    Stripe.createToken(card, subscription.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      console.log(response.id)
      $('#subscription_stripe_card_token').val(response.id)
      $('.edit_subscription')[0].submit()
    else
      console.log(response.error.message)
      $('input[type=submit]').attr('disabled', false)

