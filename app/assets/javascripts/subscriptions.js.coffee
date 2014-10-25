# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

  $('#card_number').payment('formatCardNumber')
  $('#card_exp').payment('formatCardExpiry')
  $('#card_code').payment('formatCardCVC')

subscription =
  setupForm: ->
    $('#new_subscription').submit ->
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
      alert(response.id)
      $('#new_subscription')[0].submit()
    else
      alert(response.error.message)
      $('input[type=submit]').attr('disabled', false)

