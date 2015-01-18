class Communit2.Views.Users extends Backbone.View
  template: JST['users/index']

  render: ->
    @$el.html @template(@model.toJSON())
    @